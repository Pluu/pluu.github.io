---
layout: post
title: "[요약] What's new in Android (Google I/O '25)"
date: 2025-06-03 09:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io25
---

{% include youtube.html id="IaNpcrCSDiI" %}

<!--more-->

- - -

# Jetpack Compose

## Autofill

Compose에서 Autofill API를 사용하는 방법을 소개합니다.

`BOM 2025.05.01`

```kotlin
TextField(
  state = rememberTextFieldState(),
  ...,
  modifier = Modifier.contentType(Username)
)

TextField(
  state = rememberTextFieldState(),
  ...,
  modifier = Modifier.contentType(Password)
)
```

`alpha BOM 2025.05.01`

- ContentType을 코드 한 줄로 설정 가능해짐
- [Modifier#contentType API](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).contentType(androidx.compose.ui.autofill.ContentType))

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/01.png" %}

## Autosize text

- 텍스트의 크기를 자동으로 조절. Container 크기에 자동으로 맞춰지는 기능
- [TextAutoSize API](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize)

`BOM 2025.05.01`

```kotlin
Box {
  Text(
    text = myText,
    maxLines = 1,
    autoSize = TextAutoSize.StepBased()
  )
}

// 최소, 최대, 단계 설정
Box {
  Text(
    text = myText,
    maxLines = 1,
    autoSize = TextAutoSize.StepBased(
      minFontSize = 20.sp,
      maxFontSize = 32.sp,
      stepSize = 1.sp
    )
  )
}
```

## Animate bounds

Container 내에서 Composable의 위치와 크기를 자동으로 애니메이션화 가능

- animateContentSize와 유사하지만, LookaheadScope에 있을 때 처리됨
- [Modifier#animateBounds API](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).animateBounds(androidx.compose.ui.layout.LookaheadScope,androidx.compose.ui.Modifier,androidx.compose.animation.BoundsTransform,kotlin.Boolean))

`BOM 2025.05.01`

```kotlin
LookaheadScope {
  Box(
    Modifier
      .animateBounds(this@LookaheadScope)
      .width(if(inRow) 100.dp else 150.dp)
      .background(...)
      .border(...)
  )
}
```

## Visibility tracking

### onLayoutRectChanged

화면 내에서 Composable의 위치를 추적하는데 사용할 수 있는 저수준 API

- Visibility 추적 혹은 위치 추적에 사용될 수 있음
- onGloballyPositioned와 비슷하지만, 성능이 향상된 버전
- [Modifier#onLayoutRectChanged API](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).onLayoutRectChanged(kotlin.Long,kotlin.Long,kotlin.Function1))

`BOM 2025.05.01`

```kotlin
Box(
  Modifier
    .size(...)
    .offset(...)
    .border(...)
    .background(...)
    .onLayoutRectChanged {
      l = it.boundsInRoot.left.toString()
      t = it.boundsInRoot.top.toString()
      r = it.boundsInRoot.right.toString()
      b = it.boundsInRoot.bottom.toString()
    }
) {
  ...
}

// throttle, debounce 사용 사례
Box(
  Modifier
    .size(...)
    .offset(...)
    .border(...)
    .background(...)
    .onLayoutRectChanged(
      throttleMillis = 200,
      debounceMillis = 1000
    ) {
      ...
    }
) {
  ...
}
```

### onVisibilityChanged

Composable의 가시성(Visibility)이 변경될 때마다 콜백을 제공하여 ViewPort에 들어오거나 나갈 때 호출됩니다.

- Video가 화면에 나타나서 자동으로 재생하거나 일시 정지하는데 유용
- [Modifier#onVisibilityChanged API](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).onVisibilityChanged(kotlin.Long,kotlin.Float,androidx.compose.ui.layout.LayoutBoundsHolder,kotlin.Function1))

`alpha BOM 2025.05.01`

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/02.png" %}

### onFirstVisible

- Composable이 일정 시간 동안 화면에 표시될 때마다 콜백을 제공
- [Modifier#onFirstVisible API](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).onFirstVisible(kotlin.Long,kotlin.Float,androidx.compose.ui.layout.LayoutBoundsHolder,kotlin.Function0))

## Performance - Jank rate

Composable 버전에 따른 벤치마크 결과

- Pixel 3a 기준, 최신 버전에서는 0.1%의 비율로 버벅임이 발생

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/03.png" %}

다른 최적화 방안

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/04.png" %}

- Pausable composition : 여러 프레임에 걸쳐 Composition을 분할
- Background text measurement : 메인 스레드의 무거운 작업 중 일부를 다른 작업으로 넘김
- Prefetch customization : LazyList에서 item을 미리 가져오는 기능을 사용자 정의

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/05.png" %}

- Google에서 사용되는 Compose의 경우 단일 버전이 사용됨
- 업데이트 주기 변경 : 한 달에 한 번씩 -> 하루에 한 번씩

experimental API 조사

- 다수의 API를 안정화하도록 처리
- 1년 만에 experimental API를 32% 줄이는데 성공

# Navigation 3

Compose에서 기존 Navigation으로는 Backstack 및 상태 호이스팅을 다루는 경우 사용하기 불편했습니다.

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/06.png" %}

- 애니메이션을 사용하여 서로 다른 목적지간의 전환을 쉽게 수행
- predictive back 및 shared element transition 구현 가능
- 다양한 폼 팩터에서 작동
- Material Design이 통합
- 사용자 정의가 가능
- 현재는 알파 버전 단계

### Camera / Media3에서 Compose 지원

기존 PreviewView / PlayerView를 감싸는 형태가 아니라 기초부터 재작성 중입니다.

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/07.png" %}

Androidify 샘플에서 비디오 관련 샘플을 다룹니다.

> https://github.com/android/androidify

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/08.png" %}

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/09.png" %}

- Media3의 Player 인스턴스를 PlayerSurface로 인스턴스를 전달하면됩니다.
- [rememberPlayPauseButtonState](https://developer.android.com/reference/kotlin/androidx/media3/ui/compose/state/package-summary#rememberPlayPauseButtonState(androidx.media3.common.Player)) 를 사용하여 Player와 상호작용을 함

# Kotlin Multiplatform

Google에서도 KMP를 지원하고 있으며 Jetpack libraries들 중 일부에서도 지원하고 있습니다.

Stable 목록

- Room
- DataStore
- Collections
- Saved State
- View Model
- Lifecycle 
- paging*

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/10.png" %}

Jetpack 라이브러리들에서 3가지 트랙을 나눴으며, 각 계층은 각각 다른 의미를 가집니다.

- 티어 1 : Android, iOS, Kotlin 백엔드에서 비즈니스 로직을 공유하는 모바일 앱을 빌드 가능
- 티어 2/3은 티어1보다 지원 수준이 낮음

KMP 관련 추가 자료

- [Google I/O 세션 ~ Demystify KMP builds and structure](https://youtu.be/gP5Y-ct6QXI?si=ZR9dyuPRMtLb6ClP)
- 코드랩
  - [Get Started With Kotlin Multiplatform](http://goo.gle/kmp-get-started-codelab)
  - [Migrate existing apps to Room KMP](https://developer.android.com/codelabs/kmp-migrate-room)
- Android Studio templates

# Android 16

Android의 출시 주기 변경

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/11.png" %}

## Safe

### Credential Manager

- 통합된 API
- 간단하고 안전한 솔루션
- 전세계 상호 운용이 가능
- 모든 폼팩터에서 Google로 로그인/패스워드 가능
- 휴대폰, 태블릿, 웨어러블, XR에서 패스키 지원

**디지털 자격 증명 검증 API**

- 연령, 학위 확인 등 모든 종류의 신분 확인을 위해 신분증 검증 가능
- https://developer.android.com/identity/digital-credentials

**자격 증명 복원 API**

- 사용자가 새 기기를 설정할 때 앱 계정을 복원 가능
- https://developer.android.com/identity/sign-in/restore-credentials

### 3P Code

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/12.png" %}

Privacy Sandbox를 사용하면 3P 코드를 격리된 런타임 환경에서 대응 가능

- http://privacysandbox.google.com/learn

**Android 고급 보호 모드**

- 사용자가 기기에서 On/Off 가능한 보안 기능 모음
- https://developer.android.com/privacy-and-security/advanced-protection-mode

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/13.png" %}

**Identity Check를 통한 도난 방지**

- 민감한 사용자 작업이 있는 앱에 적용
- BiometricManager를 통해 신원 확인이 활성화되어 있는지 확인 가능

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/14.png" %}

### Health Connect

**Medical records API**

- 건강 데이터를 통합 가능
- 건강 데이터와 같은 정보를 읽고 쓰기 가능

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/15.png" %}

**새로운 데이터 유형 추가**

- Background Reads

- History Reads : 시간 경과에 따른 추세 파악에 도움
- https://developer.android.com/health-and-fitness/guides/health-connect/develop/read-data
- https://developer.android.com/health-and-fitness/guides/medical-records

### Battery

새로운 Android Vital metric : Excessive Wake Locks

- 배터리 소모를 측정하는 지표
- https://developer.android.com/topic/performance/vitals

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/16.png" %}

- Expedited로 작업을 설정

## Across devices

### Adaptive Apps with Android 16

Large Screen에 포커스

600dp 이상인 대형 화면 단말에서 Target SDK 36를 사용하는 경우 일부 manifest 정의가 무시됩니다.

- Screen Orientation
- Resizeable Activities
- Aspect Ratios

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/17.png" %}

### Wear OS

Watch Face Push

- 개발자가 시계 화면을 직접 추가, 업데이트 또는 삭제할 수 있습니다.
- 각 Watch Face를 Play에 업로드하는 대신 Cloud Storage를 사용할 수도 있습니다.
- https://developer.android.com/training/wearables/watch-face-push

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/18.png" %}

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/19.png" %}

### Health 권한 강화

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/20.png" %}

- 기존 2가지의 권한을 새로운 권한으로 대체

### Wear OS 6 개발자 프리뷰

- https://android-developers.googleblog.com/2025/05/whats-new-in-wear-os-6.html

## Delightful

### Material3 Expressive

Material3의 확장팩이며 기존 M3 기능과 호환됩니다.

```groovy
// Compose
implementation("androidx.compose.material3:material3:1.4.0-alpha15")

// Views
implementation("com.google.android.material:material:1.14.0-alpha01")
```

{% include youtube.html id="6IsFP3gD28E" %}

### Live Updates

사용자가 중요하고 시간에 민감한 진행 중인 작업을 돕는 새로운 알림 정의.

- 기존 Foreground Service로 알림을 사용한 경우의 도움
- 실시간 업데이트가 포함되는 경우에 유용
- https://developer.android.com/about/versions/16/features/progress-centric-notifications

Notification에 ProgressStyle 템플릿을 추가

- 작업의 단계를 시각화하여 보여줄 수 있음

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/21.png" %}

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/22.png" %}

{% include youtube.html id="ihR8hL_Hmec" %}

### Widget

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/23.png" %}

- 잠금 화면에서 위젯 기능을 다시 사용 가능해짐

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/24.png" %}

- 훌륭한 Widgets 제공을 위해서 Google Play에 새로운 필터를 추가

### Jetpack Glance

- Jetpack Glance 1.2 알파 출시
- https://android-developers.googleblog.com/2025/03/design-with-widget-canonical-layouts.html

### Widgets Metrics API

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/25.png" %}

### Edge to edge

Android 16부터는 opt out옵션이 더 이상 제공되지 않음

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/26.png" %}

Predictive Back(뒤로 탐색 예측)

- https://developer.android.com/guide/navigation/custom-back/predictive-back-gesture
- 홈으로 돌아가기, 앱 이동, Activity간 이동에 대해 기본적으로 활성화 됨

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/27.png" %}

- 뒤로 가기 이벤트를 가로채고 있다면, BackHandler API로 마이그레이션할 필요가 있음
- 임시 opt-out 플래그(**enableOnBackInvokedCallback**)가 제공됨

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/28.png" %}

- Android 15 : 카메라 센서와 ISP를 사용해 자동 노출 모드를 도입
- Google Low Light Boost : 자동 노출 모드를 사용할 수 없는 단말에서는 머신 러닝을 사용해 카메라 화면 밝기를 실시간으로 조절
  - https://developer.android.com/media/camera/lowlight/low-light-boost-ae

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/29.png" %}

Jetpack Media3에서 Preload Manager API 출시

- 여러 미디어 소스를 미리 로드 가능
- 짧은 형식의 비디오 재생에 최적화됨

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/30.png" %}

배터리 절약을 위한 더 나은 성능을 제공하는 경우에 사용

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/31.png" %}

- 전문 크리에이터를 위한 기능을 추가할 예정

## Intelligent

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/32.png" %}

- Android는 기기 내 Gemini Nano 모델을 통해 AI 사용이 가능
- 클라우드에서 더 큰 모델에 접근할 수 있는 API 제공

GenAI

{% include youtube.html id="mP9QESmEDls" %}

- https://github.com/android/ai-samples/tree/main/ai-catalog

Gemini Live APIs

- Gemini의 Multi-modal을 사용하여
- startAudioConversation 함수를 호출하여 Gemini와 연결 시작

{% include img_assets.html id="/blog/io/io25/whats-new-in-android/33.png" %}
