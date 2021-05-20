---
layout: post
title: "[요약] What's new in Android (Google I/O '21)"
date: 2021-05-19 21:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/D2cU_itNDAI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

### `@Deprecated` Annotation

- Android 12 Preview 1에서 @Deprecated Annotation이 Deprecated된 이슈는 문서 생성 스크립트 버그로 발생한 해프닝이었다

### Android 12 ~ color and motion

- Color Palette 확대
- Pixel 기기에서는 선택된 배경화면에 따라서 Color Palette가 자동으로 선택되어 시스템 UI 전반에 사용된다 (잠금 화면, 홈 화면, 알림, 설정 등)
  - Color Palette는 중성색 (Neutral) 2개와 강조색 (Accent) 3개로 구성
  - API를 통해서 기기 전체에서 사용하는 Color Palettte를 앱에서는 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/001.png" }}" /> 

> 이미지 출처 : https://www.youtube.com/watch?v=D2cU_itNDAI

> 참고 자료 : Unveiling Material You https://material.io/blog/announcing-material-you

<iframe width="560" height="315" src="https://www.youtube.com/embed/UHQPdP8qgrk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 참고 자료 : Android 12 Beta: Designed for you https://blog.google/products/android/android-12-beta/

Color Pallet이 앱에 반영되는 예시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/002.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/003.png" }}" /> 

> 이미지 출처 : https://twitter.com/materialdesign/status/1394718566457364481?s=20

### Android 12 ~ Widgets

- 84%의 사용자는 1개 이상의 위젯을 사용하며 사용자의 2/3는 2개 이상의 위젯을 사용
- 위젯 설치 시 과정을 간소화 처리
- 시스템 Color Palette를 위젯에서도 사용 가능함
- 위젯에 관련된 API들이 업데이트 예정
  - Cupcake와도 호환되는 RemoteViews 위젯을 생성하는 API 출시 

<img src="https://1.bp.blogspot.com/-nMtiWDRBRB8/YKMMpO0Vz2I/AAAAAAAAQh8/ZbNKF2l9_TUCLgfnyBxF-3yEzwKOJmlYwCLcBGAsYHQ/s0/blue%2Bwidgets.png" width="400" />

> 이미지 출처 : What’s new in Android 12 Beta https://android-developers.googleblog.com/2021/05/whats-new-in-android-12-beta.html

> 참고 자료 : Android 12 widgets improvements https://developer.android.com/about/versions/12/features/widgets

### Android 12 ~ Launch animations

- 앱이 백그라운드에서 로드될 때 Launch animation이 노출됨
- 기본적으로 앱 아이콘을 확대하는 애니메이션이 적용됨
- 커스터마이징 처리도 가능
  - [Activity.getSplashScreen](https://developer.android.com/reference/android/app/Activity#getSplashScreen()) API

> 참고 자료 : Splash screens https://developer.android.com/about/versions/12/features/splash-screen

### Android 12 ~ Notifications

Notification

- Android 12에서 모든 템플릿을 새롭게 디자인됨
- Color Palette, Theme, Typograph, Corner Round도 대응
- 기본 템플릿을 사용 중이라면 추가 작업을 하지 않아도 됨
- Custom RemoteViews로 수정한 경우에는 Android 12에 맞춰서 많은 수정이 필요함

|                       수정가능한 영역                        |                       수정가능한 영역                        |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://developer.android.com/images/about/versions/12/custom-collapsed-view.png" /> | <img src="https://developer.android.com/images/about/versions/12/custom-expanded-view.png" /> |

> 이미지 출처 및 참고 자료 : Custom notifications https://developer.android.com/about/versions/12/behavior-changes-12#custom-notifications

Trampoline

- 이전 버전에는 Notification의 선택으로 앱을 실행하는 경우, 알림이 닫히고 몇 초간 아무런 반응이 없는 상황이 발생한다. 그 이유는 Notification에서 직접 앱을 실행하지 않고 Service / Braodcast Receiver를 통해서 앱을 시작했기 때문이다. 이것을 `trampoline` 라고 한다.
- Android 12를 Target API로 하는 앱은 Notification trampoline을 사용하는 Service / Braodcast Receiver를 통해서 Activity를 실행할 수 없음
  - Notification trampoline 역할을 하는 경우에는 Activity를 시작하려고 하면 시스템이 Activity를 시작되지 않도록 함

> 참고 자료 : Notification trampoline restrictions https://developer.android.com/about/versions/12/behavior-changes-12#notification-trampolines

Toast

- 이전 버전에서는 어떤 앱이 Toast를 노출했는지 확인할 수 없었음 -> Toast를 사용하는 앱의 아이콘이 표시하는 것으로 개선
- Toast에 노출 가능한 문자 길이를 줄였으며 1~2줄 사용을 권장함
- 복수개의 Toast를 호출한 경우, Toast 노출시간이 끝나야 다음 Toast를 볼 수 있는 문제를 개선하기 위해서 특성 시간동안 앱에서 쌓이게 할 수 있는 Toast 수를 매우 적게 줄였음

### Android 12 ~ Picture in Picture

- 앱에서 PiP 모드로 전환 예정이라고 안내하는 등의 API가 추가
- SeamlessResizeEnabled Flag를 추가하여 PiP 창에서 비디오가 아닌 콘텐츠의 크기를 조정할 때 부드러운 cross-fading 애니메이션을 제공 

> 참고 자료 : Picture in Picture (PiP) improvements https://developer.android.com/about/versions/12/features/pip-improvements

### Android 12 ~ Blur

- [View.setRenderEffect(RenderEffect)](https://developer.android.com/reference/android/view/View#setRenderEffect(android.graphics.RenderEffect)) API를 사용해서 View에 Blur 처리를 가능하게 됨
- View뿐만 아니라 Window에도 적용할 경우 Theme에 windowBackgroundBlurRadius, windowBlurBehindEnabled, windowBlurBehindRadius 속성을 추가하여 Blur 처리할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/004.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/005.png" }}" /> 

> 이미지 출처 : https://www.youtube.com/watch?v=D2cU_itNDAI

- 성능 면에서 해당 기능이 시스템에 부하가 심했지만, CPU 및 GPU 성능이 향상되어 Android 12 버전에 API로 도입

> 참고 자료 : Easier blurs, color filters, and other effects https://developer.android.com/about/versions/12/features#rendereffect

### Android 12 ~ Ripple

- Android 12의 시각적 표현 중 하나로 Ripple 효과에 sparkle effect를 새롭게 추가

### Android 12 ~ Edge

- 스크롤 컨테이너 끝에 닿을 때마다 컨테이너의 위/아래에 노출되는 Edge 효과는 진저 브레드에서 추가된 이후로 변화가 없었다
- Android 12에서는 기본적으로 유효하게 설정됨
- 몇 개월 이내로 자세할 발표가 있을 예정

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://developer.android.com/about/versions/12/images/pull-stretch-overscroll.gif" width="75%" /> | <img src="https://developer.android.com/about/versions/12/images/fling-stretch-overscroll.gif" width="75%" /> |

> 이미지 출처 : https://developer.android.com/about/versions/12/overscroll

> 참고 자료 : https://developer.android.com/about/versions/12/overscroll

### Android 12 ~ Graphics

이미지

- AVIF 이미지 포맷 지원
- JPEG와 같은 용량 대비 높은 화질 이미지
- 무손실 압축이 가능하며 알파 채널이 존재함
- HDR, 10bit/12bit 색심도 지원

동영상

- H.265, HDR10, HDR+ 지원이 추가됨
- 추가한 포맷이 앱에서 지원하지 않을 경우 동영상을 자동 변환하는 기능이 추가됨

> 참고 자료 : https://developer.android.com/about/versions/12/features/compatible-media-transcoding

오디오

- 오디오 트랙을 기반으로 HapticGenerator에 전달하면 진동 패턴이나 햅틱 패턴이 생성되어 사용자의 몰입도를 높일 수 있다

```kotlin
if (HapticGenerator.isAvailable()) {
  val audioSession = audioTrack.audioSessionId
  generator = HapticGenerator.create(audioSession)
}
```

> 참고 자료 : https://developer.android.com/reference/android/media/audiofx/HapticGenerator

### Android 12 ~ Privacy

Location

- 이전 버전에는 블루투스를 스캔하려면 위치 권한이 필요했지만, 사용자는 위치 권한의 필요성을 알지 못했다. 
- Android 12에서 블루투스 권한을 새로 정의하여, 위치 권한이 없어도 블루투스 기기를 스캔하고 연결할 수 있다

> 참고 자료 : https://developer.android.com/about/versions/12/features/bluetooth-permissions

- 사용자가 위치 정보는 제공하되 자세한 정보는 제외한다는 옵션을 선택할 수 있다.

<img src="https://1.bp.blogspot.com/-98jX3g1mzEo/YKMUgriePUI/AAAAAAAAQjE/mzlpynZb4V8LMPqywuph3rbjyvfVxQTvQCLcBGAsYHQ/s0/Untitled%2B%25282%2529.gif"/>

> 이미지 출처 : https://android-developers.googleblog.com/2021/05/android-security-and-privacy-recap.html

Clipbord access

- Foreground 상태의 앱이 클립보드에 데이터를 요청할 경우에 시스템은 사용자에게 클립보드에 접근한다고 알려준다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/006.png" }}" /> 

> 이미지 출처 : https://www.youtube.com/watch?v=D2cU_itNDAI

Foreground restrictions

- Background에서 Foreground Service가 시작하는 것을 제한
  - WorkManager에 추가된 [setExpedited()](https://developer.android.com/reference/androidx/work/WorkRequest.Builder)를 사용해서 이전 버전과의 호환성을 제공한다. Android 12에서는 즉시 처리해야 하는 긴급 작업에 사용하는 API

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/007.png" }}" /> 

> 이미지 출처 : https://www.youtube.com/watch?v=D2cU_itNDAI

> 참고 자료 : https://developer.android.com/about/versions/12/foreground-services

### Android 12 ~ Drag&Draop, Copy&Paste, Keyboard Stickers

- 다른 앱에 있는 데이터를 자신의 앱으로 가져올 경우에 사용되는 경로가 이전 버전에서는 3가지였지만 Android 12에서는 하나의 경로로 통합됨
- 하위 플랫폼과의 호환성은 AndroidX API가 제공될 예정

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/008.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android/009.png" }}" /> 

> 이미지 출처 : https://www.youtube.com/watch?v=D2cU_itNDAI

> 참고 자료 : https://developer.android.com/about/versions/12/features/unified-content-api
