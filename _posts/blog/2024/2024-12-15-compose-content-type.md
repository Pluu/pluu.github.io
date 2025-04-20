---
layout: post
title: "Compose Lazy에서 Content type 지원 살펴보기"
date: 2024-12-15 17:00:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

AndroidX Compose foundation 1.2.0-alpha03부터 Lazy List/Grid에서 key 대신 Content type이 추가되었습니다. 

<!--more-->

구글 리뷰 시스템을 통해서 찾아볼 수 있는 content type 지원 작업은 아래와 같습니다.

- [1789196: Support content types in Lazy lists](https://android-review.googlesource.com/c/platform/frameworks/support/+/1789196)
- [1960712: Support content types in Lazy grids](https://android-review.googlesource.com/c/platform/frameworks/support/+/1960712)



본 글에서는 [1789196: Support content types in Lazy lists](https://android-review.googlesource.com/c/platform/frameworks/support/+/1789196) 에서 변경된 주요 파일 및 관련 정의를 살펴보겠습니다.

------

본 글에서 사용된 코드는 아래 버전 기준입니다

- AndroidX compose foundation 1.8.0 alpha07
- AndroidX 최신 버전

------

# LazyDsl API

가장 눈에 띄는 변경 사항은 LazyDsl의 API 변동입니다.

기존 LazyListScope 및 확장 함수로 제공하던 API에 contentType를 제공하는 형태로 변경되었습니다. contentType의 기본값은 key와 동일하게 `null`로 제공합니다.

> 실제로 Key를 전달하지 않으면 index 기반으로 키를 정의합니다
>
> - [getDefaultLazyLayoutKey](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/androidMain/kotlin/androidx/compose/foundation/lazy/layout/Lazy.android.kt)

```kotlin
@LazyScopeMarker
@JvmDefaultWithCompatibility
interface LazyListScope {
   fun item(
      key: Any? = null,
      contentType: Any? = null, // ← contentType 추가
      content: @Composable LazyItemScope.() -> Unit
   ) {
      error("The method is not implemented")
   }
  
   ...
}

inline fun <T> LazyListScope.items(
   items: List<T>,
   noinline key: ((item: T) -> Any)? = null,
   noinline contentType: (item: T) -> Any? = { null }, // ← contentType 추가
   crossinline itemContent: @Composable LazyItemScope.(item: T) -> Unit
) =
   items(
      count = items.size,
      key = if (key != null) { index: Int -> key(items[index]) } else null,
      contentType = { index: Int -> contentType(items[index]) }
   ) {
      itemContent(items[it])
   }
...
```

> 소스 출처 : [링크](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/LazyDsl.kt)

# internal/private LazyList

## LazyListIntervalContent

앞서 소개한 LazyListScope는 인터페이스입니다. 해당 인터페이스를 구현한 [LazyListIntervalContent](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/LazyListIntervalContent.kt)도 동일하게 변경합니다. 그리고, `LazyDsl API`의 item/items API 사용 시 내부적으로 **LazyListInterval** 클래스로 인스턴스화한 후 intervals 프로퍼티에 추가합니다. item/items API 함수에서 람다 타입의 `itemContent` 파라미터가 실제 그려야 할 Composable을 가리킵니다. 

최종적으로 **LazyListInterval**을 이용하여 레이아웃 표시에 필요한 key/contentType/content Composable을 얻을 수 있습니다. 

```kotlin
internal class LazyListIntervalContent(
   content: LazyListScope.() -> Unit,
) : LazyLayoutIntervalContent<LazyListInterval>(), LazyListScope {
   override val intervals: MutableIntervalList<LazyListInterval> = MutableIntervalList()
   ...

   init {
      apply(content)
   }

   override fun items(
      count: Int,
      key: ((index: Int) -> Any)?,
      contentType: (index: Int) -> Any?, // ← contentType 추가
      itemContent: @Composable LazyItemScope.(index: Int) -> Unit
   ) {
      intervals.addInterval(
         count,
         LazyListInterval(key = key, type = contentType, item = itemContent)
      )
   }

   override fun item(
      key: Any?, 
      contentType: Any?, // ← contentType 추가
      content: @Composable LazyItemScope.() -> Unit
   ) {
      intervals.addInterval(
         1,
         LazyListInterval(
            key = if (key != null) { _: Int -> key } else null,
            type = { contentType },
            item = { content() }
         )
      )
   }

   override fun stickyHeader(
      key: Any?,
      contentType: Any?, // ← contentType 추가
      content: @Composable LazyItemScope.(Int) -> Unit
   ) {
      ...
   }
}

internal class LazyListInterval(
    override val key: ((index: Int) -> Any)?,
    override val type: ((index: Int) -> Any?), // ← contentType을 가져올 수 있는 Lambda 추가
    val item: @Composable LazyItemScope.(index: Int) -> Unit
) : LazyLayoutIntervalContent.Interval
```

> 소스 출처 : [링크](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/LazyListIntervalContent.kt)

## LazyLayoutItemProvider

앞서 설명한 LazyListIntervalContent가 사용되는 곳을 살펴볼 차례입니다.

[LazyLayoutItemProvider](https://developer.android.com/reference/kotlin/androidx/compose/foundation/lazy/layout/LazyLayoutItemProvider)는 하위 및 LazyLayout으로 표시할 항목에 대한 정보를 제공하는 인터페이스입니다. 이 인터페이스는 레이아웃 형태와 무관하게 동작에 대한 인터페이스를 정의하고 있습니다. 상세 레이아웃에 필요한 Provider는 별도로 확장하여 사용됩니다.

- [LazyListItemProvider](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/LazyListItemProvider.kt) : LazyRow, LazyColumn
- [LazyGridItemProvider](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/grid/LazyGridItemProvider.kt) : LazyVerticalGrid, LazyHorizontalGrid
- [LazyStaggeredGridItemProvider](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemProvider.kt) : LazyVerticalStaggeredGrid, LazyHorizontalStaggeredGrid

LazyRow, LazyColumn에서는 LazyListItemProvider 인터페이스를 구현한 [LazyListItemProviderImpl]((https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/LazyListItemProvider.kt))이 사용됩니다.

```kotlin
private class LazyListItemProviderImpl
constructor(
   ...
   private val intervalContent: LazyListIntervalContent,
   override val keyIndexMap: LazyLayoutKeyIndexMap,
) : LazyListItemProvider {
   ...
   @Composable
   override fun Item(index: Int, key: Any) {
      LazyLayoutPinnableItem(key, index, state.pinnedItems) {
         intervalContent.withInterval(index) { localIndex, content ->
            content.item(itemScope, localIndex)
         }
      }
   }
   ...  
   override fun getKey(index: Int): Any =
      keyIndexMap.getKey(index) ?: intervalContent.getKey(index)
  
   // ↓ contentType을 가져올 수 있는 기능 추가
   override fun getContentType(index: Int): Any? = intervalContent.getContentType(index) 
   ...
}
```

LazyListItemProvider에서 필요한 Key/ContentType은 생성자로 받은 intervalContent를 통해서 제공됩니다.

# internal/private LazyLayout

## LazyLayoutItemContentFactory

{% include img_assets.html id="/blog/2024/1215-compose-content-type/LazyLayoutItemContentFactory.png" %}

[LazyLayoutItemContentFactory](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/layout/LazyLayoutItemContentFactory.kt)는 람다 캐시 및 제공하는 역할 담당하는 Factory 클래스입니다.

LazyLayoutItemContentFactory 클래스의 주석에는 다음과 같이 작성되어 있습니다.

1. itemProvider가 생성하는 람다를 캐시 합니다. 이를 통해 Content lambda 객체로 subcompose하는 경우 compose runtime이 전체 compose를 건너뛸 수 있으므로 recomposition을 덜 수행할 수 있습니다.
2. 새로운 factory가 있을 때 key와 index 간의 매핑을 업데이트합니다.
3. itemProvider가 반환한 composable 위에 [saveableStateHolder](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/runtime/runtime-saveable/src/commonMain/kotlin/androidx/compose/runtime/saveable/SaveableStateHolder.kt)의 도움으로 상태 복원을 추가합니다.

```kotlin
internal class LazyLayoutItemContentFactory(
   ...,
   val itemProvider: () -> LazyLayoutItemProvider,
) {
   /** itemProvider에서 생성된 캐시된 람다를 포함 */
   private val lambdasCache = mutableScatterMapOf<Any, CachedItemContent>()

   /** 
    * 지정된 키가 있는 아이템의 contentType을 반환합니다. 아이템의 composition 재사용 효율을 개선하는 데 사용됩니다
    */
   fun getContentType(key: Any?): Any? { // ← contentType을 가져올 수 있는 기능 추가
      if (key == null) return null

      val cachedContent = lambdasCache[key]
      return if (cachedContent != null) {
         cachedContent.contentType
      } else {
         val itemProvider = itemProvider()
         val index = itemProvider.getIndex(key)
         if (index != -1) {
            itemProvider.getContentType(index)
         } else {
            null
         }
      }
   }

   /** 캐시된 item content 람다를 반환하거나 새 람다를 생성하여 캐시에 넣습니다. */
   fun getContent(index: Int, key: Any, contentType: Any?): @Composable () -> Unit {
      val cached = lambdasCache[key]
      return if (cached != null && cached.index == index && cached.contentType == contentType) {
         cached.content
      } else {
         val newContent = CachedItemContent(index, key, contentType)
         lambdasCache[key] = newContent
         newContent.content
      }
   }

   ...
}
...
```

> 소스 출처 : [링크](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/layout/LazyLayoutItemContentFactory.kt)

LazyLayoutItemContentFactory에서 기존과 달라진 점은 getContentType 함수 추가와 getContent 조건으로 `contentType`가 추가된 점입니다.

## LazyLayoutItemReusePolicy

LazyLayoutItemReusePolicy은 [SubcomposeSlotReusePolicy](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy) 인터페이스를 구현하고 있으며 Compose에서 재사용에 관련된 정책을 담당합니다.

- LazyLayout에서 SubcomposeLayout 호출시 [SubcomposeLayoutState](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeLayoutState?hl=en)의 생성자로 전달되어 사용됩니다.



[SubcomposeSlotReusePolicy](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy)은 SubcomposeLayout에서 더 이상 사용하지 않는 Slot을 없애는 대신, Slot을 유지하고 재사용하도록 합니다. LazyLayout을 사용하고 있는 모든 Composable에서 **LazyLayoutItemReusePolicy**이 사용됩니다. LazyLayout을 사용하는 곳은 LazyRow, LazyColumn, LazyVerticalGrid, LazyHorizontalGrid 등이 있습니다.

- [getSlotsToRetain](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy#getSlotsToRetain(androidx.compose.ui.layout.SubcomposeSlotReusePolicy.SlotIdsSet)) : 재사용 가능한 slot Id로 채워진 slotIds 세트로 호출
- [areCompatible](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy#areCompatible(kotlin.Any,kotlin.Any)) : slotId와 reusableSlotId가 가리키는 Content가 호환되는지 판단

```kotlin
private class LazyLayoutItemReusePolicy(private val factory: LazyLayoutItemContentFactory) :
   SubcomposeSlotReusePolicy {
   private val countPerType = mutableObjectIntMapOf<Any?>()

   override fun getSlotsToRetain(slotIds: SubcomposeSlotReusePolicy.SlotIdsSet) {
      countPerType.clear()
      slotIds.forEach { slotId ->
         val type = factory.getContentType(slotId)
         val currentCount = countPerType.getOrDefault(type, 0)
                       
         // MaxItemsToRetainForReuse은 현재 7로 정의   
         // RecyclerView와 동일한 최대 수치 지정              
         // (RecycledViewPool.DEFAULT_MAX_SCRAP) + 2 (Recycler.DEFAULT_CACHE_SIZE)
         if (currentCount == MaxItemsToRetainForReuse) {
            slotIds.remove(slotId)
         } else {
            countPerType[type] = currentCount + 1
         }
      }
   }

   override fun areCompatible(slotId: Any?, reusableSlotId: Any?): Boolean =
      factory.getContentType(slotId) == factory.getContentType(reusableSlotId)
} 
```

> 소스 출처 : [링크](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/layout/LazyLayout.kt;l=86-105)

> MaxItemsToRetainForReuse의 정의 : [링크](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/foundation/foundation/src/commonMain/kotlin/androidx/compose/foundation/lazy/layout/LazyLayout.kt;l=107-111)

### SlotIdsSet

slotIds의 타입인 SlotIdsSet 클래스 [SubcomposeSlotReusePolicy.SlotIdsSet](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy.SlotIdsSet?hl=en)은 Collection 인터페이스를 구현한 클래스입니다. 해당 클래스는 SubcomposeSlotReusePolicy 내부에 정의되어 있으며, `androidx.compose.ui.layout` 패키지에 위치하여 Compose slot id를 위한 전용 클래스라는 것을 알 수 있습니다.

해당 클래스 주석에는 다음과 같이 설명하고 있습니다.

- 현재 재사용할 수 있는 slot ID를 포함하는 Set입니다. [getSlotsToRetain](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/SubcomposeSlotReusePolicy#getSlotsToRetain(androidx.compose.ui.layout.SubcomposeSlotReusePolicy.SlotIdsSet))에서 사용됩니다. 이 Set은 요소의 삽입 순서를 유지하여 안정적인 반복 순서를 보장합니다.
- 이 클래스는 MutableSet과 똑같이 작동하지만 새 항목을 추가할 수 없습니다.

또한 SlotIdsSet의 생성자로 [MutableOrderedScatterSet](https://developer.android.com/reference/androidx/collection/MutableOrderedScatterSet)를 가집니다. 이 클래스도 구글이 만든 [OrderedScatterSet](https://developer.android.com/reference/androidx/collection/OrderedScatterSet) 계열 중 하나입니다.

## 정리

본 글에서는 [1789196: Support content types in Lazy lists](https://android-review.googlesource.com/c/platform/frameworks/support/+/1789196)에 관련된 변경점과 관련 클래스를 일부를 살펴봤습니다. 변경이 발생한 부분을 보고 개인적으로 정리와 이해를 위해서 작성해 봤습니다.

다음 글에서는 전반적인 흐름을 다룰 예정입니다.
