---
layout: post
title: "[메모] Compose LazyVerticalGrid 렌더링 프로파일 체크"
date: 2024-04-21 13:30:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

<!--more-->

------

사이드 프로젝트에 적용한 Compose가 아쉬울 수준의 성능이 자꾸 나와서 성능 비교한 모습이다.

{% include youtube.html id="GgV7uBThp3U" %}

- Compose LazyVerticalGrid Debug
- Compose LazyVerticalGrid Release
- RecyclerView Grid Debug

대략 개발자 모드에 있는 렌더링 프로파일로 비교한 모습입니다.

## Compose Test Code

```kotlin
@Composable
fun Greeting(name: List<GridSample>, modifier: Modifier = Modifier) {
   LazyVerticalGrid(
      columns = GridCells.Fixed(3),
      modifier = modifier.fillMaxSize(),
      verticalArrangement = Arrangement.spacedBy(4.dp),
      horizontalArrangement = Arrangement.spacedBy(4.dp),
      contentPadding = PaddingValues(4.dp)
   ) {
      itemsIndexed(
         items = name,
         key = { _, item -> item.name },
      ) { _, item ->
         Card(
            modifier = Modifier.aspectRatio(1f),
            colors = CardDefaults.cardColors().copy(
               containerColor = item.color
            )
         ) {
            Text(text = item.name)
         }
      }
   }
}

data class GridSample(
    val name: String,
    val color: Color
)
```

## 흠...

Compose 스펙상 `Unbundled`이라서, Release/R8/Profiles이 같이 적용된 상태로 실행시킨 경우 최적이라고 Medium에서 설명하고 있다.

> [Why should you always test Compose performance in release?](https://medium.com/androiddevelopers/why-should-you-always-test-compose-performance-in-release-4168dd0f2c71)

많은 Compose 사용자가 같은 환경은 아니겠지만,

- 릴리즈 적용 여부에 따라서 성능 갭 차이가 큰 케이스라는 것을 어떻게 알 수 있을까?
- 일부 앱은 덩치가 큰데, 릴리즈 모드를 자주 할 수 있을까?

개인적으로는 버벅이니깐 릴리즈로 해보자라고 하는게 좋은 방식일까?? 생각이 든다.

## 흠...2

Compose 사용으로 좀 더(?) 심플하게 UI 개발이 가능해졌다. 한동안 조용했던 Android 개발에 새로운 내용이다.

개바자들에게 배포하고 필요한 것을 수집하는 페이즈1 단계가 지금까지였다면, 다음은 라이브러리 지원 + 성능을 끌어올려야 할 페이즈2가 와야 한다.

하루빨리 Compsoe의 Debug에서 성능을 빨리 올리는 방식이 도입되었으면 한다.
