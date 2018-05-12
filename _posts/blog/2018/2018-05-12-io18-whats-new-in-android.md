---
layout: post
title: "[요약] What's new in Android (Google I/O '18)"
date: 2018-05-12 02:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- IO18
---

<!--more-->

- - -

# [요약] What's new in Android (Google I/O '18)

## Android App Bundles

Application을 빌드할 때 다른 메뉴를 클릭하는 것만으로 가능합니다.

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [The future of apps on Android and Google Play: modular, instant, and dynamic](https://www.youtube.com/watch?v=0raqVydJmNE)
>
> [Build the new, modular Android App Bundle](https://www.youtube.com/watch?v=bViNOUeFuiQ)

## Jetpack

더 나은 안드로이드 애플리케이션을 구축하는 방법에 대한 지침입니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/01.png" }}" /> 

Support Library에 좋은 점은 패키지 이름에 출시 번호가 명시되는 부분이지만, 그러나 지금은 더 이상 지원하지 않습니다. 최소버전이 14이다. 하지만, 이런 버전은 이제는 패키지 이름에 지나지 않습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/02.png" }}" /> 

그래서, AndroidX라는 더 적절한 이름으로 바뀌고 있습니다.

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Android Jetpack: what’s new in Android Support Library](https://www.youtube.com/watch?v=jdKUm8tGogw)
>
> [Android Developers Blog ~ Hello World, AndroidX](https://android-developers.googleblog.com/2018/05/hello-world-androidx.html)

### Android Test

- First class Kotlin 지원
- boilerplate 코드를 줄이고 가독성을 높이기위한 API 제공합니다

```java
// Before
assertEquals(view.getVisiblity(), view.VISIBLE);
// "Failed Expected 0 but was 16"
```

위와 같은 코드는 매개변수의 순서가 알기 어려우며, 그로인한 오류 메시지도 그다지 도움되지 않습니다.

아래와 같은 코드가 더욱 더 실제 속성에 대해서 작업된다고 보입니다. 오류 메시지도 더 잘 제공합니다

```java
// Now
assertThat(view).isVisible();
// "Failed, view was not visible"
```

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Frictionless Android testing: write once, run everywhere](https://www.youtube.com/watch?v=wYMIadv9iF8)

### Jetpack Architecture

Jetpack에는 아래와 같은 것이 포함되어 있습니다

- Lifecycle
- ViewModel
- Room
- LiveData
- Paging (1.0)
- WorkManager (Preview)
  - 작업 스케줄링에 관한 것이지만 특정 버전을 사용하지 않고 이전 버전에서 모든 사례를 처리하는 방식으로 수행됩니다
- Navigation

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Android Jetpack: what's new in Architecture Components](https://www.youtube.com/watch?v=pErTyQpA390)
>
> [Android Jetpack: easy background processing with WorkManager](https://www.youtube.com/watch?v=IrKoBFLwTN0)
>
> [Android Jetpack: manage UI navigation with Navigation Controller](https://www.youtube.com/watch?v=8GCXtCjtg40) 
>
> [Android Jetpack: manage infinite lists with RecyclerView and Paging](https://www.youtube.com/watch?v=BE5bsyGGLf4)

## Battery

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/03.png" }}" /> 

App standby buckets

- 애플리케이션 사용을 모니터링하여 사용자가 얼마나 적극적으로 사용하는지 확인 후 배터리를 더 많이 요구에 응합니다

Background 제한

- 애플리케이션이 잘못 작동하는 경우, 오랫동안 잠자기 모드를 유지하거나 충전중이지 않는 상태의 경우 설정에 주의하라고 노출합니다

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Don't let your app drain your users' battery](https://www.youtube.com/watch?v=kGWT99eMgyM) 

## Background Input & Privacy

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/04.png" }}" /> 

앱이 백그라운드에 있을 경우 `마이크`, `카메라`에 더이상 접근할 수 없습니다. `센서`에 접근이 불가능합니다. 그러므로 자동으로 데이터 수신을 받을 수 없습니다.  수동으로 업데이트는 가능하지만, `Foreground Service` 사용을 권장합니다.

## Kotlin

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/05.png" }}" /> 

성능 향상

- ART, D8 & R8
  - Kotlin 컴파일러에 의해 생성된 바이트 코드를 분석해 최적화 작업을 했습니다.

Suppory Library and libcore

- 더 많은 Nullable 주석을 추가

Android KTX

- 기존 플랫폼 API를 위한 Kotlin Extension 모음입니다
- 이미 Kotlin을 사용하는 것만으로 사용하기 쉽지만 Extension 을 사용하면 훨씬 좋아집니다



Android KTX를 사용한 예제 코드입니다.

```kotlin
val bitmap = createBitmap(1280, 720).applyCanvas {
    withScale(2.0f, 2.0f) {
        paint.xfermode = PorterDuff.Mode.DST_IN.toXfermode()
        drawPath(pathB - pathA, paint)
    }
}
val (_, r, g, b) = bitmap[16, 16]
```

`applyCanvas` 를 사용하면 캔버스를 자동으로 만들 수 있습니다. int를 byte로 변환하거나 마스킹할 필요가 없습니다.

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Android Jetpack: sweetening Kotlin development with Android KTX](https://www.youtube.com/watch?v=st1XVfkDWqk)

## Mockable Framework ~ mockito

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/23.png" }}" /> 

Android Framework를 쉽게 mock 가능해집니다.

- Final method
- Static method (곧 가능)
- System-created objects (Activity ...)

## Background Text Measurement

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/06.png" }}" /> 

텍스트 표시하는데 필요한 작업의 80%~90% 가 텍스트 draw/measure/layout 구간에서 발생한다. 이런 계산을 Background 스레드로 이동시켜 화면에 노출시 표시만을 위한 것을 제공합니다

```kotlin
PrecomputedText.create(...)
```

## Magnifier (돋보기)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/07.png" }}" /> 

텍스트를 선택하여 미리보기를 할 수 있습니다. 팝업으로 노출할 수 있게해주는 API를 제공합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/08.png" }}" /> 

## Baseline Distance

텍스트의 수직 배열 정렬을 위한 API를 제공합니다

```kotlin
val tv: TextView
// Distance from top to first baseline
tv.firstBaselineToTopHeight = distancePx
// Distance from bottom to last baseline
tv.lastBaselineToBottomHeight = distancePx
```

## Smart Linkify

더 똑똑한 Linkify이며 머신러닝을 통해 사용자가 스마트 텍스트 선택을 통해 다른 개체를 발견할 수 있습니다.

```java
Spannable text = ...
TextLinks.Request request = new TextLinks.Request.Builder(text);

// On background thread
executor.execute {
    TextClassifier.generateLinks(request).apply(text);
    textview.post { textview.text = text }
}
```

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Best practices for text on Android](https://www.youtube.com/watch?v=x-FcOX6ErdI)

## Location

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/09.png" }}" /> 

새로운 패키지인 `android.net.wifi.rtt.*` 를 활용할 수 있습니다.

WiFi round trip time API 를 이용해서 실내에서 정확한 위치를 찾을 수 있습니다.

호환되는 하드웨어와 AP가 필요하며 위치 찾기 권한이 필요하며, 실제로 AP에 연결할 필요는 없습니다.

## Accessibility

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/10.png" }}" /> 

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [What’s new in Android accessibility](https://www.youtube.com/watch?v=Lcoc4aCLfqI)

## Security

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/11.png" }}" /> 

Unified BiometricDialog (통합 지문 인증 대화상자) 를 제공합니다. FingerprintManager는 @deprecated 되었습니다. 지문보다 신체를 인증하는 방법이 더 많기 때문입니다. 모든 장치와 인증 수단에 대해 단일 UI를 제공합니다.

 `Build.SERIAL` 는 더 이상 동작하지 않습니다. API로서 존재하지만 가짜 데이터를 반환합니다.

## Enterprise

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/12.png" }}" /> 

업무와 개인 프로필을 사용으로 각가의 섹션을 만들 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/13.png" }}" /> 

그리고, 패키지를 특정 작업에 고정시킬 수 있다. 최소 그룹 및 단일 애플리케이션의 집합을 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/14.png" }}" /> 

키오스크 모드를 제공하여 임시 사용자를 보유가능한 기능을 작동할 수 있다.

## DIsplay Cutout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/15.png" }}" /> 

- `WindowInset#getDisplayCutout()` : DisplayCutout 클래스를 이용하여 비표시해야하는 영역의 위치와 모양을 얻을 수 있습니다. 
- windowLayoutInDisplayCutoutMode
  - mode="never" : 컷아웃으로 인한 겹치는것을 원하지 않을 때
  - mode="default" : 컷아웃부분 이외에 정상적으로 표시 
  - mode="shortEdges" + DisplayCutout#getSafeInsets() 
  - mode="shortEdges" + DisplayCutout#getBounds()

## Slices

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/16.png" }}" /> 

컨텐츠를 앱에서 다른곳으로 가져오는 문제를 해소하기 위해, 사용자의 앱 또는 이를 지원하는 다른 앱에 UI를 그릴 수 있습니다. 캔버스나 absolute layout 이 아니다.

채우기 위한 구조와 매우 유연한 템플릿 모음을 제공합니다. 그로인해 Slices 를 사용처에 해당 데이터를 표시할 수 있습니다. 상호작용이 가능하며 업데이트할 수 있습니다.

Slices는 content URI 로 주소 지정할 수 있습니다. 

Slices는 Support Library에 있습니다. Jetpack에 있으며 하위버전과 호완되며 API 19까지 사용할 수 있습니다.

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Android Slices: build interactive results for Google Search](https://www.youtube.com/watch?v=a7IVH5aNwwc)

## Actions

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/17.png" }}" /> 

매개변수가 있는 바로가기로 기본적으로 추가 페이로드를 사용하여 앱에 연결되는 deeplink입니다.

APK 및 APK 번들에 포함되는 actions.xml 파일에 정의된 작업이 표시됩니다.

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Integrating your Android apps with the Google Assistant](https://www.youtube.com/watch?v=v0uYZ4rTOrk)

## Notifications

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/18.png" }}" /> 

사용자는 메세지를 좋아한다는 설문 결과로 메시징 스타일 API를 향상시키는데 힘을 쏟았습니다. 인라인 이미지, 참가자 이미지를 작성하고 참가자에 대한 메타 데이터를 첨부할 수 있습니다. SmartReply 를 할 수 있습니다. RemoteInput.setChoices() 를  사용하여 즉시 응답할 수 있습니다.

## Deprecation Policy

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/19.png" }}" /> 

모든 애플리케이션이 Target API를 최신으로 할 필요가 있습니다. 그로인해 보안 수준을 높게 유지하며 성능 등이 향상됩니다.

- 2018년 8월 → 새로운 애플리케이션은 Target 26이 필요
- 2018년 11월 → 현재 Play Store에 게시된 애플리케이션을 업데이트하려면 Target 26이 필요

Native Code

- 2019년 8월 → 64비트 API를 만들 예정

> 더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Migrate your existing app to target Android Oreo and above](https://www.youtube.com/watch?v=YyDnYaFtRS0)

## App compatibility

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/20.png" }}" /> 

Android API의 비공개 API와 @hide 가 잇습니다. 이것은 API는 경고를 유발합니다. 경고는 Toast나 로그일 수도 있습니다. 공개가 필요한 API가 있다면 `g.co/dev/appcompat` 으로 알려주세요.

API가 블랙리스트에 포함되면 사용자는 이를 절대로 호출할 수 없습니다.

## NDK

r17에는 Neural networks API 추가, JNI Shared Memory API 추가, Rootless ASAN, UBSAN 지원됩니다. simpleperf CPU profiler 지원 추가되었습니다.

ARMv5 or MIPS, MIPS 32-bit or 64-bit 지원은 중단됩니다.

r18에서는 GCC를 제거할 것입니다.

## Graphics & Media

### Camera

- OIS 타임스탬프 및 디스플래이 기반 플래시 지원
- USB 카메라 지원
- 복수 카메라 지원

### ImageDecoder

BitmapFactory을 대신한 새로운 API로 Android P의 일부입니다. 이미지 혹은 애니메이션 이미지를 더 쉽게 해독할 수 있습니다. Bitmap 디코딩뿐만 아니라 AnimatedImageDrawable 을 포함한 Drawable도 사용할 수 있습니다.

Source, Post-processor, Header listener 요소가 추가되었고, 아래 코드로 Bitmap 변환이 가능해지고 Bitmap 사이즈 변경도 편리해졌습니다.

```kotlin
val src = ImageDecorder.createSource(/* ... */)
val b = ImageDecorder.decodeBitmap(src){ decorder, info, s ->
  decoder.setTargetSize(width, height)
  decoder.setTargetColorSpace(ColorSpace.get(ColorSpace.Named.SRGM))
  decoder.setPostProcessor {
    canvas.drawText(/* .. */)
    PixelFormat.UNKNOWN
  }
}
```

### Media

- HDR VP9 동영상 지원
- HEIF 이미지 압축 지원
- 미디어 API

이것은 Support Library의 일부이거나 지금은 Jetpack의 일부입니다.

## Vulkan

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/21.png" }}" /> 

## Neural networks APIs

[화면 캡쳐 : 9:43]

Android Framework를 쉽게 mock 가능해집니다.

- Final method

- Static method (곧 가능)
- System-created objects (Activity ...)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android/22.png" }}" /> 

기계 학습을 위해 설계된 C API이며 낮은 수준의 API이기도 합니다.

## ARCore

ARCore 1.2가 발표되었고, 에뮬레이터 지원을 도입하고 있습니다.

>  더 자세한 내용은 아래의 세션에서 소개되고 있습니다
>
> [Building AR apps with the Sceneform SDK](https://www.youtube.com/watch?v=jzaMMV6w_OE)

## ChromeOS

Chromebook에서 Linux 프로그램을 실행할 수 있습니다. 특히 Android Studio를 실행할 수 있습니다. Chrome OS에서 Android 앱을 앱으로 실행하는 것입니다.

