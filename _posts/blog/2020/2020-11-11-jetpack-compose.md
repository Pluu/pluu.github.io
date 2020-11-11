---
layout: post
title: "Jetpack Compose 공부 ~ 3주차"
date: 2020-11-11 22:30:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog
- Android
---

본 글은 개인적으로 Jetpack AndroidX Compose의 스터디한 내용을 정리하는 아카이브용입니다.

<!--more-->

`지극히 개인적인` 의견입니다.

- - -

테스트 전제 조건

- Android Studio 4.2 Canary 15
- Jetpack Compose 1.0.0-alpha06


실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. Jetpack Compose for Desktop: Milestone 1 Released 

- Blog : https://blog.jetbrains.com/cross-post/jetpack-compose-for-desktop-milestone-1-released/
- Sample : https://github.com/JetBrains/compose-jb

### 2. Compose로 DemoApp 기반 샘플 코드

- androidx/compose : https://github.com/androidx/androidx/tree/androidx-master-dev/compose/integration-tests/demos

### 3. (궁금) Compose에서 Overdraw는 발생하는 것인가??

하나의 Canvas에 Compsoe를 렌더링하지만, 레이아웃 구조에서는 Stack이나 Overdraw 형태로 정의될 수 있기 때문에 드는 생각

> 안드로이드 GPU 오버드로 디버그에서는 발생하는 것처럼 보이는데... 맞을까...

### 4. ambientOf, staticAmbientOf

- 타 플랫폼에서 비슷한 개념
  - React : Context
  - Flutter : Provider
  - SwiftUI : EnvironmentObject

- 참고글 : https://lcdsmao.medium.com/jetpack-compose-what-is-the-difference-between-ambientof-and-staticambientof-383eef30b02e

### 5. Paging이나 Load More로 무한 피드 처리

기존 코드 패턴에서 Adapter에 맵핑되는 것은 `LazyItemScope` 에 해당된다.

```kotlin
@Composable
fun <T> LazyColumnFor(
    items: List<T>,
    modifier: Modifier = Modifier,
    state: LazyListState = rememberLazyListState(),
    contentPadding: PaddingValues = PaddingValues(0.dp),
    horizontalAlignment: Alignment.Horizontal = Alignment.Start,
    itemContent: @Composable LazyItemScope.(T) -> Unit
) {
```

아이템 사이즈와  `threshold`  를 계산해서 Paging이나 Load More 시작 여부를 호출한다면 대안은 Index를 지원하는 LazyColumnFor, LazyRowFor Compose를 사용

```kotlin
LazyColumnForIndexed(items = ...) { index, item ->
   // if (index + threshold == lastIndex ) ...
}

LazyRowForIndexed(items = ...) { index, item ->
   // if (index + threshold == lastIndex ) ...
}
```

### 6. RecyclerView#Adapter의 ViewType 마다 처리하는 고민

1) LazyColumnFor에 전달하는 List<T>의 T의 데이터를 사용해서 분기처리

- Sealed Classes
- Item 자체에서 ViewType 정의

2) 고정적인 데이터 기준으로 Lazy 처리

```kotlin
import androidx.compose.foundation.Text
import androidx.compose.foundation.lazy.LazyColumn

val itemsList = (0..5).toList()
val itemsIndexedList = listOf("A", "B", "C")

LazyColumn {
    items(itemsList) {
        Text("Item is $it")
    }

    item {
        Text("Single item")
    }

    itemsIndexed(itemsIndexedList) { index, item ->
        Text("Item at index $index is $item")
    }
}
```

> https://developer.android.com/reference/kotlin/androidx/compose/foundation/lazy/package-summary#lazycolumn

3) 내부 비교

LazyColumn와 LazyColumnFor 둘 다 LazyFor Compose를 사용

> LazyFor는 internal inline

LazyColumn

```kotlin
@Composable
@ExperimentalLazyDsl
fun LazyColumn(
    modifier: Modifier = Modifier,
    state: LazyListState = rememberLazyListState(),
    contentPadding: PaddingValues = PaddingValues(0.dp),
    horizontalAlignment: Alignment.Horizontal = Alignment.Start,
    content: LazyListScope.() -> Unit
) {
    val scope = LazyListScopeImpl()
    scope.apply(content)

    LazyFor(
        itemsCount = scope.totalSize,
        modifier = modifier,
        state = state,
        contentPadding = contentPadding,
        horizontalAlignment = horizontalAlignment,
        isVertical = true
    ) { index ->
        scope.contentFor(index, this)
    }
}
```

LazyColumnFor

```kotlin
@Composable
fun <T> LazyColumnFor(
    items: List<T>,
    modifier: Modifier = Modifier,
    state: LazyListState = rememberLazyListState(),
    contentPadding: PaddingValues = PaddingValues(0.dp),
    horizontalAlignment: Alignment.Horizontal = Alignment.Start,
    itemContent: @Composable LazyItemScope.(T) -> Unit
) {
    LazyFor(
        itemsCount = items.size,
        modifier = modifier,
        state = state,
        contentPadding = contentPadding,
        horizontalAlignment = horizontalAlignment,
        isVertical = true
    ) { index ->
        val item = items[index]
        {
            key(index) {
                itemContent(item)
            }
        }
    }
}
```

### 샘플 소스

- compose-dotsandlines  : https://github.com/halilozercan/compose-dotsandlines
- DeskNotes : https://github.com/ychescale9/desk-notes