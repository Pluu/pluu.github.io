---
layout: post
title: "Jetpack Compose 공부 ~ 4주차"
date: 2020-11-18 20:20:00 +09:00
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

- Android Studio 4.2 Canary 16
- Jetpack Compose 1.0.0-alpha07

실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. Release

Jetpack Compose

- 1.0.0-alpha07 : https://developer.android.com/jetpack/androidx/versions/all-channel#november_11_2020

- Deprecated
  - foundation.Text → material.Text
  - AmbientTextStyle, ProvideTextStyle, AmbientContentColor : compose.animation에서 compose.material로 이동
  - BaseTextField → BasicTextField
  - LazyColumnItems/LazyRowItems → LazyColumnFor/LazyRowFor
  - relativePaddingFrom → paddingFrom
  - DpConstraints
  - ProvideEmphasis → AmbientContentAlpha
    - ```kotlin
      color.copy(alpha = AmbientContentAlpha.current)
      ```
  - LaunchedTask → LaunchedEffect  
- SNAPSHOT
  - ContextAmbient → AmbientContext (xxxAmbient → Ambientxxxx)

material-components-android-compose-theme-adapter

- v1.0.0-alpha07 : https://github.com/material-components/material-components-android-compose-theme-adapter/releases/tag/v1.0.0-alpha07

accompanist

- v0.3.3.1 : https://github.com/chrisbanes/accompanist/releases/tag/v0.3.3

Lottie

- https://gpeal.medium.com/lottie-for-jetpack-compose-29865520e9bb

```kotlin
@Composable
fun Loader() {
    val animationSpec = remember { LottieAnimationSpec.RawRes(R.raw.loader) }
    LottieAnimation(
        animationSpec,
        modifier = Modifier.preferredSize(100.dp)
    )
}
```

```groovy
dependencies {
  implementation 'com.airbnb.android:lottie-compose:1.0.0-alpha02'
}
```

### 2. Pull to Refresh

SwipeToRefresh

> https://github.com/android/compose-samples/blob/main/JetNews/app/src/main/java/com/example/jetnews/ui/SwipeToRefresh.kt

사용 방법

```kotlin
SwipeToRefreshLayout(
    refreshingState = loading,
    onRefresh = onRefresh,
    refreshIndicator = { ... },
    content = content, 
)
```

- https://github.com/android/compose-samples/blob/main/JetNews/app/src/main/java/com/example/jetnews/ui/home/HomeScreen.kt#L216

### 3. FragmentContainerViews의 대체는 어떻게?

> [Jetchat, Jetsurvey] Replace <fragment> Tags with FragmentContainerViews #161
>
> https://github.com/android/compose-samples/issues/161

Advocate의 답변 : Since these are not AAC samples and the navigation solution for Compose is starting to take shape, I think we shouldn't complicate the boilerplate any more and wait until we have an official integration.

> 공식 지원이 되기까지 기다려달라.

### 4. 기존 View#Invisible은 어떻게 할 것 인가?

개인적인 형태는 `alpha를 0`으로 적용

### 5. Back 키 처리

BackPressedDispatcherAmbient

> https://github.com/android/compose-samples/blob/main/Jetchat/app/src/main/java/com/example/compose/jetchat/conversation/BackHandler.kt

### Etc. 서버 기반 렌더링 (샘플은 컬러만 처리)

```kotlin
@Composable
fun ProvideDesignSystemColors(
    colors: DesignSystemColors,
    content: @Composable () -> Unit
) {
    val colorPalette = remember { colors }
    colorPalette.update(colors)
    Providers(AmbientDesignSystemColors provides colorPalette, children = content)
}
```

> https://adambennett.dev/2020/11/server-driven-theming-in-jetpack-compose/

### Etc. accompanist ~ Twitter

```
Had a bit of a Friday afternoon hack today: adding animated keyboard (IME) support to Accompanist Insets for #JetpackCompose

This adds support for reacting to Android 10's `WindowInsetsAnimation`
```

> https://twitter.com/chrisbanes/status/1327319154412707847
