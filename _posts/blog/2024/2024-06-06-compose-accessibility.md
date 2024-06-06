---
layout: post
title: "[정리] Compose 가이드 문서 ~ 접근성"
date: 2024-06-06 18:00:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog
- Android
---

<!--more-->

------

https://developer.android.com/develop/ui/compose/accessibility

------

# 주요 단계

## 터치 영역 최소 크기 고려

[Material Design 접근성 가이드라인](https://m3.material.io/foundations/accessible-design/overview) 기준, 최소 크기는 48dp

> Material Component는 Surface가 최소 크기를 내부적으로 설정하지만 Component가 사용자 작업을 수신할 수 있는 경우에만 설정

```kotlin
@Composable
private fun CheckableCheckbox() {
   Checkbox(checked = true, onCheckedChange = {})
}

// 상호작용할 수 없는 경우 패딩이 포함되지 않는다
@Composable
private fun NonClickableCheckbox() {
   Checkbox(checked = true, onCheckedChange = null)
}
```

클릭 가능한 Composable의 크기가 터치 영역 최소 크기보다 작은 경우 Compose는 터치 영역 크기를 늘린다. Composable의 경계 밖으로 터치 영역 크기를 확장하여 작업을 수행

터치 영역 영역은 Box 경계를 넘어 자동으로 확장되므로 Box 옆을 탭하면 여전히 클릭 이벤트가 트리거 된다

```kotlin
@Composable
private fun SmallBox() {
   var clicked by remember { mutableStateOf(false) }
   Box(
      Modifier
         .size(100.dp)
         .background(if (clicked) Color.DarkGray else Color.LightGray)
   ) {
      Box(
         Modifier
            .align(Alignment.Center)
            .clickable { clicked = !clicked }
            .background(Color.Black)
            .size(1.dp)
      )
   }
}
```

<img src="https://developer.android.com/static/develop/ui/compose/images/a11y-expanded-target.gif" />

서로 다른 Composable의 터치 영역이 겹치지 않도록 항상 Composable에 최소 크기를 설정하기 위해 `sizeIn` Modifier를 설정해야 한다.

## 클릭 라벨 추가

클릭 라벨을 사용하여 Composable의 클릭 동작에 시맨틱 의미를 설정 가능

```kotlin
@Composable
private fun ArticleListItem(openArticle: () -> Unit) {
   Row(
      Modifier.clickable(
         // R.string.action_read_article = "read article"
         onClickLabel = stringResource(R.string.action_read_article),
         onClick = openArticle
      )
   ) {
      // ..
   }
}
```

또는 clickable Modifier를 사용할 수 없는 경우 [semantics](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).semantics(kotlin.Boolean,kotlin.Function1)) Modifier에서 클릭 라벨을 설정

```kotlin
@Composable
private fun LowLevelClickLabel(openArticle: () -> Boolean) {
   // R.string.action_read_article = "read article"
   val readArticleLabel = stringResource(R.string.action_read_article)
   Canvas(
      Modifier.semantics {
         onClick(label = readArticleLabel, action = openArticle)
      }
   ) {
      // ..
   }
}
```

## 시각적 요소 설명

contentDescription 파라미터는 시각적 요소를 설명을 정의

- null로도 전달 가능

```kotlin
@Composable
private fun ShareButton(onClick: () -> Unit) {
   IconButton(onClick = onClick) {
      Icon(
         imageVector = Icons.Filled.Share,
         contentDescription = stringResource(R.string.label_share)
      )
   }
}
```

## elements 병합

Composable에 [`clickable`](https://developer.android.com/reference/kotlin/androidx/compose/foundation/package-summary#clickable(androidx.compose.ui.Modifier,kotlin.Boolean,kotlin.String,androidx.compose.ui.semantics.Role,kotlin.Function0)) Modifier를 적용하면 Composable에 포함된 모든 elements를 자동으로 병합한다

semantics Modifier의 mergeDescendants 파라미터를 사용하여 element 병합 여부를 설정 가능

```kotlin
@Composable
private fun PostMetadata(metadata: Metadata) {
   // 접근성을 위해 아래 elements를 병합
   Row(modifier = Modifier.semantics(mergeDescendants = true) {}) {
      Image(
         imageVector = Icons.Filled.AccountCircle,
         contentDescription = null // decorative
      )
      Column {
         Text(metadata.author.name)
         Text("${metadata.date} • ${metadata.readTimeMinutes} min read")
      }
   }
}
```

<img src="https://developer.android.com/static/develop/ui/compose/images/a11y-userinfo-all-selected.png" />

<img src="https://developer.android.com/static/develop/ui/compose/images/a11y-list-item-all-selected.png" />

[`clearAndSetSemantics`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#clearAndSetSemantics(androidx.compose.ui.Modifier,kotlin.Function1)s) Modifier : 모든 하위 노드의 시맨틱을 지우고 새로운 시맨틱을 설정

```kotlin
@Composable
private fun PostCardSimple(
   /* ... */
   isFavorite: Boolean,
   onToggleFavorite: () -> Boolean
) {
   val actionLabel = stringResource(
      if (isFavorite) R.string.unfavorite else R.string.favorite
   )
   Row(
      modifier = Modifier
         .clickable(onClick = { /* ... */ })
         .semantics {
            // Set any explicit semantic properties
            customActions = listOf(
               CustomAccessibilityAction(actionLabel, onToggleFavorite)
            )
         }
   ) {
      /* ... */
      BookmarkButton(
         isBookmarked = isFavorite,
         onClick = onToggleFavorite,
         // Clear any semantics properties set on this node
         modifier = Modifier.clearAndSetSemantics { }
      )
   }
}
```

## element 상태 설명

Composable의 상태를 읽는 데 사용하는 semantics의 stateDescription를 정의

- toggle 가능한 Composable은 '선택됨' 또는 '선택 해제됨' 상태로 정의

```kotlin
@Composable
private fun TopicItem(itemTitle: String, selected: Boolean, onToggle: () -> Unit) {
   val stateSubscribed = stringResource(R.string.subscribed)
   val stateNotSubscribed = stringResource(R.string.not_subscribed)
   Row(
      modifier = Modifier
         .semantics {
            // 명시적 의미 속성 설정
            stateDescription = if (selected) stateSubscribed else stateNotSubscribed
         }
         .toggleable(
            value = selected,
            onValueChange = { onToggle() }
         )
   ) {
      /* ... */
   }
}
```

# 시맨틱

Composition은 앱의 UI를 설명하며 composable을 실행하여 생성하며, Composition은 UI를 설명하는 composable로 구성된 트리 구조.

Composition 옆에는 시맨틱 트리라는 병렬 트리가 있으며, 이 트리는 접근성 서비스와 테스트 프레임워크에서 이해할 수 있는 대체 방식으로 UI를 설명.

## 시맨틱 속성

시맨틱 트리를 시각화하려면 Layout Inspector 도구를 사용하거나 테스트 내에서 printToLog() 메서드를 사용. Logcat 내 현재 시맨틱 트리가 출력됨

```kotlin
class MyComposeTest {
   @get:Rule
   val composeTestRule = createComposeRule()

   @Test
   fun MyTest() {
      // Start the app
      composeTestRule.setContent {
         MyTheme {
            Text("Hello world!")
         }
      }
      // Log the full semantics tree
      composeTestRule.onRoot().printToLog("MY TAG")
   }
}
```

아래와 같이 출력

```
    Printing with useUnmergedTree = 'false'
    Node #1 at (l=0.0, t=63.0, r=221.0, b=120.0)px
     |-Node #2 at (l=0.0, t=63.0, r=221.0, b=120.0)px
       Text = '[Hello world!]'
       Actions = [GetTextLayoutResult]
```

- 시맨틱 속성의 전체 목록 : [`SemanticsProperties`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/SemanticsProperties) 
- 접근성 작업의 전체 목록 : [`SemanticsActions`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/SemanticsActions)

clickable과 toggleable 수정자는 자동으로 하위 element를 병합

### 트리 검사

접근성 서비스는 병합되지 않은 트리를 사용하고 mergeDescendants 속성을 고려하여 자체 병합 알고리즘을 적용

테스트 프레임워크는 기본적으로 병합된 트리를 사용

|      merged/unmerged 시맨틱 트리를 표시할 수 있는 옵션       |                   병합된 시맨틱 속성 모습                    |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://developer.android.com/static/develop/ui/compose/images/semantics-layout-inspector-menu.png"  /> | <img src="https://developer.android.com/static/develop/ui/compose/images/semantics-merged-and-set.png" /> |

### 병합 동작

자체적으로 mergeDescendants = true를 설정한 하위 element는 병합에 포함되지 않는다

<img src="https://developer.android.com/static/develop/ui/compose/images/semantics-dagger.png" style="zoom:50%;" />

<img src="https://developer.android.com/static/develop/ui/compose/images/semantics-merged-vs-unmerged.png" style="zoom:50%;" />

> 병합된 트리에는 행 노드 내부 목록에 여러 텍스트가 포함
>
> 병합되지 않은 트리에는 각 Text 컴포저블에 대한 별도의 노드가 포함

# 순회 순서 제어

기본적으로 Compose 앱의 접근성 스크린 리더 동작은 예상되는 읽기 순서로 구현

- 일반적으로 왼쪽에서 오른쪽, 그런 다음 위에서 아래로 진행
- 읽기 순서를 결정할 수 있는 처리
  - 뷰 기반 : `traversalBefore` 및 `traversalAfter` 속성
  - Compose : [`isTraversalGroup`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#(androidx.compose.ui.semantics.SemanticsPropertyReceiver).isTraversalGroup()) 및 [`traversalIndex`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#(androidx.compose.ui.semantics.SemanticsPropertyReceiver).traversalIndex()) 
    - isTraversalGroup : 의미상 중요한 그룹을 식별용
    - traversalIndex : 그룹 내에서 개별 element의 순서 설정

## isTraversalGroup를 사용하여 element 그룹화

시맨틱 노드가 순회 그룹인지 여부를 정의

isTraversalGroup = true를 설정하면 다른 element로 이동하기 전에 해당 노드의 모든 하위 element를 방문

```kotlin
@Composable
fun TraversalGroupDemo2() {
   val topSampleText1 = "This sentence is in "
   val bottomSampleText1 = "the left column."
   val topSampleText2 = "This sentence is"
   val bottomSampleText2 = "on the right."
   Row {
      CardBox(
//       1,
         topSampleText1,
         bottomSampleText1,
         Modifier.semantics { isTraversalGroup = true }
      )
      CardBox(
//       2,
         topSampleText2,
         bottomSampleText2,
         Modifier.semantics { isTraversalGroup = true }
      )
   }
}
```

## 순회 순서 추가 커스텀

[`traversalIndex`](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#(androidx.compose.ui.semantics.SemanticsPropertyReceiver).traversalIndex())은 TalkBack 순회 순서를 설정할 수 있는 속성

- `traversalIndex` 값이 낮은 요소에 우선순위가 높다
- 양수 또는 음수일 수 있다
- 기본값은 `0f`
- 텍스트나 버튼과 같은 화면상의 element와 같이 스크린 리더에 포커스를 둘 수 있는 노드에만 영향 줌

# 접근성 테스트

 ```kotlin
 @Test
 fun test() {
    composeTestRule
       .onNode(nodeMatcher)
       .assert(
          SemanticsMatcher("onClickLabel is set correctly") {
             it.config.getOrNull(SemanticsActions.OnClick)?.label == "My Click Label"
          }
       )
 }
 ```

