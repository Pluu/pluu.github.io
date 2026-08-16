---
layout: post
title: "Jetpack Compose에서 PinnableContainer로 아이템 유지하기"
date: 2026-08-16 18:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

LazyColumn에서 UI 상태를 변경(예 : 아이템을 펼치거나 포커스)한 후 스크롤하면, 화면 밖으로 이동한 아이템의 composition이 제거될 수 있습니다. 추가 처리가 없다면 다시 아이템이 노출되었을 때 UI가 초기화되는 문제가 발생합니다.

재생 중인 미디어·포커스를 가진 입력창·펼쳐진 상세 영역처럼 화면 밖으로 이동해도 composition을 유지해야 하는 아이템인 경우 더욱 처리가 필요합니다.

이 글에서는 이런 상황을 `PinnableContainer`로 처리하는 방법을 소개합니다.

<!--more-->

------

{% include img_assets.html id="/blog/2026/0816/pinnable-container-overview.svg" %}

## 1. PinnableContainer란?

Lazy 아이템의 UI를 유지해야 하는 상황이 생기면 보통 다음 방법부터 생각합니다.

- 입력값이나 펼침 상태를 rememberSaveable 또는 ViewModel로 올립니다.
- 아이템을 LazyList 밖으로 옮기거나 별도 overlay로 구성합니다.
- key를 지정해 데이터가 바뀌어도 같은 아이템의 상태를 유지합니다.

각 방법은 목적이 다릅니다. rememberSaveable과 ViewModel은 `상태를 보존`하는 방법이고, LazyList 밖으로 UI를 옮기는 방식은 `화면에 계속 노출`하는 방법입니다. key는 `아이템 identity를 유지`하지만 화면 밖으로 이동한 아이템의 composition dispose를 막지는 않습니다.

하지만 현재 포커스, 실행 중인 effect, 재생 중인 미디어처럼 **UI의 composition 자체를 유지해야 하는 경우**에는 위 방법만으로 해결되지 않을 수 있습니다. 이때 Lazy layout에 해당 아이템을 당분간 유지해야 한다고 알려주는 방법이 `PinnableContainer`입니다. `PinnableContainer`는 콘텐츠를 유지해야 하는 동안 컨테이너를 pin할 수 있도록 정의한 API입니다. LazyList에서 **PinnableContainer를 사용하면 아이템이 viewport 밖으로 이동해도 dispose되지 않습니다.**

예를 들어 다음과 같은 아이템에 사용할 수 있습니다.

- 재생 중인 오디오나 비디오를 가지는 Row
- 키보드 포커스를 가진 TextField
- 펼쳐진 상세 패널이나 메뉴
- 드래그 중인 Row
- 접근성 포커스 또는 화면 밖에서도 유지해야 하는 일시적 UI를 처리하는 Row

PinnableContainer는 아이템을 화면에 계속 표시하거나 목록 위치를 고정하는 API가 아닙니다. 현재 composition을 유지해야 한다는 사실을 전달하는 역할을 합니다.

### LazyList에서만 사용할 수 있는가?

API 이름에는 Container가 들어가지만, 일반적인 Column이나 Row를 위한 API는 아닙니다. AndroidX API 문서에서는 LazyList의 각 아이템을 하나의 `PinnableContainer`로 설명합니다.

> For example, each item of lazy list represents one PinnableContainer, and if this container is pinned, this item will not be disposed when scrolled out of the viewport.

따라서 LazyColumn이나 LazyRow처럼 `LocalPinnableContainer`를 제공하는 LazyLayout의 아이템 안에서 사용하는 것이 간단한 사례입니다. 일반적인 **Column** 바깥에서는 같은 컨테이너가 제공되지 않으므로 직접 `PinnableContainer`를 만들어 CompositionLocal에 주입하는 방식도 가능해 보입니다.

## 2. `PinnableContainer`의 기본 사용 방법

API 기준으로 `PinnableContainer`는 다음과 같습니다.

- PinnableContainer: 콘텐츠를 유지해야 하는 동안 pin할 수 있는 컨테이너입니다.
- pin(): 컨테이너를 pin하고 `PinnedHandle`을 반환
- PinnedHandle: pin을 해제할 때 사용하는 핸들
- release(): pin을 해제한 이후 LazyLayout은 화면 밖으로 벗어난 아이템을 dispose할 수 있습니다.

대표적인 사용 사례는 현재 포커스를 가진 LazyList 아이템을 pin하는 것입니다. 아이템이 화면 밖으로 이동해도 포커스를 잃지 않도록 composition 수명을 유지할 수 있습니다. 포커스가 해제되거나 콘텐츠를 더 이상 유지할 필요가 없어지면 `PinnedHandle.release()`를 호출해야 합니다.

{% include img_assets.html id="/blog/2026/0816/pin-lifecycle.svg" %}

### 기본 코드

```kotlin
@Composable
private fun PinWhileNeeded(shouldKeep: Boolean) {
   val container = LocalPinnableContainer.current

   DisposableEffect(container, shouldKeep) {
      val handle = if (shouldKeep) container?.pin() else null

      onDispose {
         handle?.release()
      }
   }
}
```

Composable에서 pin과 release를 나누어 작성하면 해제 시점을 놓치기 쉽습니다. `pin()`이 반환하는 핸들의 수명을 `DisposableEffect`에 맞춰 관리하는 방식이 적합합니다.

## 3. `LocalPinnableContainer` 상세 설명

### 1) Local은 전역 싱글톤이 아닙니다

`LocalPinnableContainer`의 타입은 다음과 같은 `CompositionLocal`입니다.

```kotlin
val LocalPinnableContainer:
   ProvidableCompositionLocal<PinnableContainer?>
```

앱 전체에 하나만 존재하는 전역 컨테이너를 가져오는 API가 아닙니다. 현재 Composable이 속한 Composition 트리에서 가장 가까운 provider가 제공하는 값을 읽습니다. 

```kotlin
@Composable
private fun SimplePinnableItem(...) {
   val container = LocalPinnableContainer.current
}
```

### 2) LazyLayout과 같이 아이템 재활용에 적합

LazyList의 각 item이 하나의 `PinnableContainer`에 해당합니다. 따라서 다음 코드처럼 `items { ... }` 내부에서 SimplePinnableItem을 호출하면 SimplePinnableItem 하위 트리의 `LocalPinnableContainer.current`가 해당 item 컨테이너를 가리킵니다. 이 컨테이너를 pin하면 item이 viewport 밖으로 나가도 dispose되지 않습니다.

```kotlin
LazyColumn {
   items(
      items = demoItems,
      key = { it.id },
      contentType = { "simple" },
   ) { item ->
      // item slot 하위에서 호출
      SimplePinnableItem(
         item = item,
         isExpanded = expandedId == item.id,
         onToggleExpanded = { /* ... */ },
      )
   }
}
```

LazyColumn 바깥의 화면 공통 헤더에서 `LocalPinnableContainer.current`를 읽으면 컨테이너가 제공되지 않습니다. 특정 Lazy item의 하위 Composition이 아니기 때문입니다. 판단 기준은 함수 이름이 아니라 Composition 트리의 위치입니다.

### 3) `current`와 `pin()`의 차이

두 API를 분리해서 이해하면 수명 관리 흐름을 쉽게 파악할 수 있습니다.

```kotlin
// 현재 하위 트리의 컨테이너를 조회
val container = LocalPinnableContainer.current

// 해당 컨테이너를 유지 필요 상태로 표시하고 PinnedHandle 반환
val handle = container?.pin()

// 상태 종료를 알림
handle?.release()
```

`current`를 읽는 것만으로 item이 유지되는 것은 아닙니다. 반드시 `pin()`을 호출해 handle을 만들고, 이후 `release()`해야 합니다. AndroidX API 문서도 `pin()`이 `PinnedHandle`을 반환하며, 유지할 필요가 없어지면 `release()`를 호출해야 한다고 명시되어 있습니다.

## 4. 단순 예제: 펼쳐진 Lazy 아이템 유지하기

단순 예제에서는 한 번에 하나의 아이템만 펼치는 목록을 사용합니다.

```kotlin
@Composable
private fun SimplePinDemo() {
   var expandedId by rememberSaveable { mutableStateOf<Int?>(null) }

   LazyColumn {
      items(
         items = demoItems,
         key = { it.id },
         contentType = { "simple" },
      ) { item ->
         val isExpanded = expandedId == item.id
         SimplePinnableItem(
            item = item,
            isExpanded = isExpanded,
            onToggleExpanded = {
               expandedId = if (isExpanded) null else item.id
            },
         )
      }
   }
}
```

아이템 UI와 pin 수명은 별도 Composable로 분리합니다. Lambda는 상태 연결만 담당합니다.

```kotlin
@Composable
private fun SimplePinnableItem(
   item: DemoItem,
   isExpanded: Boolean,
   onToggleExpanded: () -> Unit,
) {
   PinWhileNeeded(
      itemId = item.id,
      shouldKeep = isExpanded,
   )

   Card(Modifier.animateContentSize()) {
      Column(Modifier.padding(16.dp)) {
         Text(item.title)
         if (isExpanded) Text("상세 내용")
         TextButton(onClick = onToggleExpanded) {
            Text(if (isExpanded) "접기" else "펼치기")
         }
      }
   }
}
```

pin 수명을 관리하는 Helper 함수는 다음과 같습니다.

```kotlin
@Composable
private fun PinWhileNeeded(
   itemId: Int,
   shouldKeep: Boolean,
) {
   val container = LocalPinnableContainer.current

   DisposableEffect(container, itemId, shouldKeep) {
      val handle = if (shouldKeep) {
         container?.pin()?.also {
            Log.d("PinnableDemo", "PIN key=$itemId")
         }
      } else {
         null
      }

      onDispose {
         handle?.release()
         if (handle != null) {
            Log.d("PinnableDemo", "RELEASE key=$itemId")
         }
      }
   }
}
```

`shouldKeep`이 false → true가 되면 **PIN** 로그와 함께 handle을 만들고, true → false가 되면 기존 effect가 dispose되면서 **RELEASE** 로그를 출력합니다. 아이템 자체가 dispose되는 경우에도 onDispose가 실행되므로 해제 경로가 한 곳에 모입니다.

### 왜 `DisposableEffect`인가?

`pin()`을 호출하면 아이템을 유지하는 동안 사용할 `PinnedHandle`이 반환됩니다. 이 핸들을 보관하고 있다가 더 이상 아이템을 유지할 필요가 없어지는 시점에 `release()`를 호출하면 pin이 해제됩니다.

```text
유지 필요  →  handle 생성  →  아이템 수명 연장
유지 불필요/Composition 종료  →  handle.release()
```

아이템을 더 이상 유지할 필요가 없어져 effect가 다시 실행될 때도, 아이템이 composition에서 사라질 때도 onDispose에서 `release()`가 호출됩니다.

## 5. 동작 확인

앱을 실행한 뒤 다음 순서로 확인합니다.

1. 목록에서 아이템 하나를 펼칩니다.
2. 아이템이 viewport 밖으로 나가도록 빠르게 스크롤합니다.
3. 다시 돌아와 상세 영역이 유지되는지 확인합니다.
4. Android Studio Logcat에서 PinnableDemo 태그를 필터링합니다.
5. 다시 빠르게 스크롤해 PIN/RELEASE와 ENTER/DISPOSE 로그를 비교합니다.
6. 펼친 아이템을 화면 밖으로 보낸 뒤 DISPOSE가 지연되는지 확인합니다.

### 유지 필요 상태

key=0을 펼치면 `shouldKeep`이 true가 되면서 먼저 PIN 로그가 출력됩니다. 이후 화면 밖으로 스크롤해도 key=0의 DISPOSE 로그가 바로 출력되지 않습니다. 화면에 보이지 않는 다른 아이템은 먼저 dispose될 수 있습니다.

```text
PinnableDemo: ENTER key=0
PinnableDemo: PIN key=0
PinnableDemo: ENTER key=1
PinnableDemo: DISPOSE key=1
```

다시 아이템으로 돌아와 펼침을 해제하면 RELEASE 로그가 출력됩니다. 아이템이 화면 밖에 남아 있다면 이후 DISPOSE가 출력될 수 있습니다.

```text
PinnableDemo: RELEASE key=0
PinnableDemo: DISPOSE key=0
```

### 유지 불필요 상태

아이템을 펼치지 않은 상태에서는 `shouldKeep`이 false이므로 PIN 로그가 출력되지 않습니다. 이 아이템을 화면 밖으로 스크롤하면 다음처럼 DISPOSE가 출력될 수 있습니다.

```text
PinnableDemo: ENTER key=2
PinnableDemo: DISPOSE key=2
```

실제 출력 순서와 key 값은 스크롤 속도와 viewport에 따라 달라질 수 있습니다.

{% include img_assets.html id="/blog/2026/0816/pin-log-comparison.svg" %}

개발 중에는 **PIN**과 **RELEASE** 로그를 함께 확인합니다. 기대하는 결과는 “유지 필요 상태로 전환될 때마다 **PIN** 하나, 유지할 필요가 없어질 때마다 **RELEASE** 하나”입니다. **PIN**만 계속 증가하고 **RELEASE**가 따라오지 않는다면 handle 수명이 잘못 관리되고 있을 가능성이 있습니다.

## 6. 재활용되는지 확인하는 방법

Compose의 LazyList에는 RecyclerView의 `onViewRecycled()`와 같은 콜백이 없습니다. Compose에서 확인해야 하는 대상은 View의 재활용이 아니라 다음 세 가지입니다.

1. `key`: 같은 논리 아이템인지 식별
2. `contentType`: 같은 구조의 아이템끼리 composition을 재사용 가능
3. `DisposableEffect`: 아이템 composition이 생성되고 dispose되는 시점을 관찰

따라서 ENTER가 출력됐다고 바로 재활용이 발생했다고 판단하면 안 됩니다. 이전 composition이 dispose된 뒤 같은 `key`의 아이템이 다시 ENTER되는지, 또는 기존 composition이 유지되는지를 함께 봐야 합니다.

모든 item의 구조가 같으므로 stable `key`와 `contentType`을 함께 지정합니다.

```kotlin
items(
   items = demoItems,
   key = { it.id },
   contentType = { "simple" },
) { item ->
   SimplePinnableItem(
      item = item,
      isExpanded = expandedId == item.id,
      onToggleExpanded = { /* ... */ },
   )
}
```

SimplePinnableItem에는 composition 수명을 확인하는 로그를 넣었습니다. PinWhileNeeded에는 pin 상태를 확인하는 로그를 추가했습니다.

```kotlin
DisposableEffect(item.id) {
   Log.d("PinnableDemo", "ENTER key=${item.id}")
   onDispose {
      Log.d("PinnableDemo", "DISPOSE key=${item.id}")
   }
}
```

```text
PIN key=0
RELEASE key=0
```

Android Studio의 Logcat에서 PinnableDemo 태그를 필터링한 다음 목록을 빠르게 스크롤합니다.

- ENTER key=...: 해당 item composition이 생성된 시점
- PIN key=...: `pin()`이 호출된 시점
- RELEASE key=...: `PinnedHandle.release()`가 호출된 시점
- DISPOSE key=...: 해당 item composition이 종료된 시점

펼친 item을 화면 밖으로 스크롤했는데 **DISPOSE**가 나오지 않으면 pin이 살아 있는 동안 composition이 유지된 것입니다.

펼침을 해제한 뒤 **RELEASE**가 출력되고, 아이템이 화면 밖에 있다면 이후 **DISPOSE**가 출력될 수 있습니다.

이 로그는 `재구성(recomposition)`과 `composition 종료(dispose)`를 구분하는 데 사용합니다. 단순히 화면이 다시 그려졌다고 item이 재활용되거나 dispose되는 것은 아닙니다. 또한 **key**는 데이터 상태가 다른 item으로 잘못 이동하지 않게 하는 기준이고, **contentType**은 동일한 구조의 item끼리 composition 재사용을 최적화하는 힌트입니다. 

**LazyList**는 화면에 다시 들어올 가능성이 있는 아이템을 잠시 유지할 수 있으므로, **RELEASE** 직후 **DISPOSE**가 항상 즉시 출력되는 것은 아닙니다. 이 로그는 재활용 횟수를 세는 지표가 아니라, 특정 `key`의 composition과 pin 핸들 수명을 확인하는 용도로 사용하는 것이 정확합니다.

재활용 여부는 하나의 카운터보다 **key**, **contentType**, **PIN/RELEASE**, **ENTER/DISPOSE** 로그를 함께 확인하는 편이 정확합니다. 

## 7. pin의 경계선

### `pin`이 보장하는 것

`PinnableContainer`가 연결된 lazy 아이템이라면 pin이 살아 있는 동안 viewport 밖으로 나간 아이템을 즉시 dispose하지 않도록 lazy layout에 신호를 보냅니다. 따라서 재생 중인 row의 composition이나 포커스가 남아 있어야 하는 입력 row처럼 현재 UI 작업이 끝나지 않은 내용을 보호할 수 있습니다.

### `pin`이 보장하지 않는 것

- 화면에 아이템을 계속 표시하지 않습니다.
- 목록 위치를 저장하지 않습니다.
- `remember` 상태를 프로세스 종료 후 복원하지 않습니다.
- 네트워크 캐시나 데이터베이스를 대체하지 않습니다.
- 무제한으로 많은 아이템을 유지해도 안전하다는 뜻이 아닙니다.

프로세스 복원이나 화면 회전 후에도 값을 보존해야 한다면 `rememberSaveable`, ViewModel, 저장소 등을 별도로 사용해야 합니다. `PinnableContainer`는 현재 composition 수명에 관한 힌트입니다.

## 8. PinnableContainer와 retain의 차이

`retain`은 Composable이 Composition에서 잠시 제거됐다가 다시 추가될 때, 특정 객체나 값을 다시 사용할 수 있도록 보관하는 API입니다. 화면에 아이템을 계속 남겨 두거나 아이템의 composition 자체를 유지하는 기능은 아닙니다.

`PinnableContainer`와 `retain`은 둘 다 Composable의 수명과 관련된 기능처럼 보이지만, 유지하는 대상과 목적이 다릅니다.

| 구분 | PinnableContainer | retain |
|---|---|---|
| 목적 | Lazy 아이템의 composition 유지 | composition에서 잠시 제거된 값 유지 |
| 대상 | Lazy layout의 아이템 | 객체, 상태, 리소스 |
| 사용 위치 | LocalPinnableContainer.current | retain { ... } |
| 동작 | viewport 밖으로 나가도 아이템을 dispose하지 않음 | Composable이 제거됐다가 다시 생성될 때 기존 값을 재사용 |
| 수명 종료 | PinnedHandle.release() | RetainedValuesStore가 값을 retire할 때 |
| 대표 사례 | 포커스, 펼침, 드래그, 재생 중인 아이템 | Navigation back stack, configuration change, 일시적으로 제거되는 UI |

### 사용 방법 비교

```kotlin
// Lazy 아이템 자체를 화면 밖에서도 유지
val handle = LocalPinnableContainer.current?.pin()

// 유지할 필요가 없어지면 해제
handle?.release()
```

```kotlin
// Composable이 일시적으로 제거됐다가 다시 생성될 때 값 재사용
val player = retain {
   MediaPlayer(mediaUri)
}
```

### 어떤 API를 선택할까?

- 화면 밖으로 이동해도 아이템의 UI와 composition이 살아 있어야 한다면 => `PinnableContainer`
- Composable은 제거될 수 있지만, 다시 생성될 때 특정 객체나 값을 재사용해야 한다면 => `retain`
- 프로세스 종료 후에도 상태를 복원해야 한다면 => `rememberSaveable` 또는 ViewModel

`retain`은 UI를 화면에 계속 표시하지 않으며, `PinnableContainer`처럼 Lazy 아이템의 dispose를 막는 API도 아닙니다. 반대로 `PinnableContainer`는 값을 configuration change나 Composition 재생성 이후까지 보존하는 API가 아닙니다.

또한 `retain`으로 보관한 값은 Composable보다 오래 유지될 수 있습니다. Context, View, 또는 이를 간접적으로 참조하는 객체를 `retain`하면 메모리 누수가 발생할 수 있으므로 보관 대상에 주의해야 합니다.

## 9. 주의할 점

### 1) `release()`를 빼먹는 경우

```kotlin
// 좋지 않은 예: pin은 만들지만 해제하지 않음
val handle = LocalPinnableContainer.current?.pin()
```

이 코드는 아이템을 계속 유지해야 한다고 잘못 알려 줄 수 있습니다. `DisposableEffect`의 `onDispose` 또는 명확한 lifecycle callback에서 반드시 `release()`해야 합니다.

### 2) 모든 아이템을 pin하는 경우

pin은 유지해야 할 이유가 있을 때만 사용해야 합니다. 모든 행을 pin하면 lazy layout의 메모리 절약 효과를 스스로 없애게 됩니다. 특히 이미지, 플레이어, 애니메이션, 큰 입력 UI가 들어간 행은 비용이 빠르게 커질 수 있습니다.

### 3) “보이고 싶다”와 “살아 있어야 한다”를 혼동하는 경우

사용자가 스크롤해도 아이템이 화면에 남아 있어야 한다면 sticky header, 별도 overlay, `LazyListState` 기반의 UI 이동 등 다른 방법을 사용해야 합니다. `PinnableContainer`는 보이지 않는 순간에도 composition을 유지할 필요가 있는 경우에 적합합니다.

### 4) composition 유지와 데이터 상태를 같은 것으로 생각하는 경우

pin은 composition dispose를 늦춥니다. 앱의 핵심 상태를 item composition 안의 일반 `remember`에만 맡기지 말고, 오래 보존해야 하는 상태는 ViewModel이나 적절한 state holder로 끌어올려야 합니다.

## 10. 결론

`PinnableContainer`는 작은 수명 관리 도구입니다. 판단 기준은 하나입니다.

> “이 lazy 아이템이 지금 화면 밖으로 나가도 composition을 잃으면 안 되는가?”

그렇다면 `LocalPinnableContainer.current?.pin()`으로 유지 필요 상태를 표시하고, 더 이상 유지할 필요가 없어지는 순간 `release()`해야 합니다. key, contentType, DisposableEffect 로그를 함께 사용하면 LazyList의 item identity와 composition 수명을 직접 확인할 수 있습니다.

## 참고 자료

- [PinnableContainer API reference](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/PinnableContainer)
- [PinnableContainer.PinnedHandle API reference](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/PinnableContainer.PinnedHandle)
- [retain API reference](https://developer.android.com/reference/kotlin/androidx/compose/runtime/retain/retain.composable)
- [Compose UI layout API — LocalPinnableContainer](https://developer.android.com/reference/kotlin/androidx/compose/ui/layout/package-summary)
