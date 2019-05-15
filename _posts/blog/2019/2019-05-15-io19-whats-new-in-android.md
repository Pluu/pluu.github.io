---
layout: post
title: "[요약] What's new in Android (Google I/O '19)"
date: 2019-05-15 01:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/td3Kd7fOROw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<!--more-->

- - -

## Bubbles

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/002.png" }}" /> 

API 29 Preview에 추가된 기능인 Bubbles는 모든 앱에서 구현이 가능하며, 떠다니는 채팅 버블을 이야기한다. 앱을 연결하는 데 사용할 수 있다.

- 알림 게시
- 아이콘 추가, Activity 연결 포함
- Intent로 Bubbles 안의 창에 연결

> Q 개발자 설정에서 이 기능을 사용할 수 있다.

- SAW (System Alert Window)는 완전히 deprecated 될 것이며, 관련 패러다임을 사용하는 앱은 Bubbles API로 넘어가게 될 것이다.

> 자세한 것은 다음 세션에서 확인 : [What's New in the Android OS User Interface (Google I/O'19)](https://www.youtube.com/watch?v=nWbW58RMteI)

## Dark Theme

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/004.png" }}" /> 

- 시간과 관련된 MODE AUTO_TIME가 deprecated 됨
- Dark Theme를 끄고 켜는 방식을 취함

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/005.png" }}" /> 

Dark Theme의 작동 방식입니다

- Option A, Android Dark Theme 사용
  - Theme.AppCompat.DayNight : 이미 사용 가능
  - Theme.DeviceDefault.DayNight : Device 스타일에 맞춤
  - ThemeOverlay.DeviceDefault.Accent.DayNight
- Option B, DarkTheme를 강제 On/Off 사용
- Option C, 화면 구성에 따른 직접 커스터마이징
- Option D, DarkTheme 무시

## Sharing

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/007.png" }}" /> 

ShareSheet는 Q에서 조금 더 신경 쓸 필요가 있다

- 앱에서 제공되는 맞춤형 공유
- Content 미리 보기
- 클립보드

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/008.png" }}" /> 

- 클립 데이터에 무엇을 넣느냐에 따라 이미지/텍스트를 나타내는 콘텐츠를 미리 보기가 가능
- 새로운 Share Shortcut API를 지원
- 클립보드에 복사 버튼을 추가
- 매우 빠름

> 자세한 것은 다음 세션에서 확인 : [What's New in the Android OS User Interface (Google I/O'19)](https://www.youtube.com/watch?v=nWbW58RMteI)

## Interruptions

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/011.png" }}" /> 

Notification의 중요도에 따라 섹션을 구분한다

- priority : 사용자의 관심을 끌기 위해서 알림 영역 (상단)
- gentle : 사용자의 관심도가 낮은 알림 영역 (하단)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/012.png" }}" /> 

1. App - high/max priority : 팝업 노출
2. OS 레벨의 경험적 방법
   1. 필수 장치 기능
   2. 사람들에게서의 커뮤니케이션
   3. 이벤트/알람 
3. 사용자에 의해 priority에서 gentle로 변경

## Notification actions

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/013.png" }}" /> 

OS가 모든 메시징 스타일 알림에 제공

> 자세한 것은 다음 세션에서 확인 : [What's New in the Android OS User Interface (Google I/O'19)](https://www.youtube.com/watch?v=nWbW58RMteI)

## Gesture navigation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/015.png" }}" /> 

- 기본적인 아이디어는 시스템 UI를 줄이는 것
- 몰입형 전체 화면에서는 gesture로 다른 동작을 사용
- OEM과 협력하여 단순한 표준을 만듦

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/079.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/017.png" }}" /> 

StatusBar와 Naivigation Bar 아래에 더 컨텐츠를 그릴 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/018.png" }}" /> 

제스처 영역이 어디에 있는지 파악해야 한다.

- 운영체제별로 화면 가장자리에서 스와이프 처리가 일어난다
- 이제 화면 좌우에서 제스처가 일어난다. (터치, 탭 하려는 객체를 넣으면 안 된다)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/020.png" }}" /> 

사이드에서 드래그할 수 있어야 하는 상황, exclusion rects를 이용해 시스템 제스처 영역 중 하나만 빼앗도록 한다

> 자세한 것은 다음 세션에서 확인 : [Dark Theme & Gesture Navigation](https://www.youtube.com/watch?v=OCHEjeLC_UY)

## WebView

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/022.png" }}" /> 

- WebView는 Chrome에서 WebView를 분리하는 Trichrome을 도입
- 렌더링이 멈추면 감지

## Accesibility (접근성)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/023.png" }}" /> 

- 더 쉬운 접근성 설정
- 화면에 머물러야 하는 시간 설정

## Text

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/024.png" }}" /> 

- Hyphenation을 API 23에 도입, 그러나 Android Q에서는 off상태

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/025.png" }}" /> 

기존은 XML 파일을 구문 분석해서 폰트 취득. 시스템 글꼴을 검색으로 개선

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/026.png" }}" /> 

네이티브 애플리케이션을 위한 API를 가지고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/027.png" }}" /> 

- LineBackgroundSpan, LineHeightSpan 지원
- TextAppearanceSpan은 TextAppearance에서 사용 가능한 모든 특성을 읽지 않는 데 사용
- LineBreaker 및 MeasuredText를 제공
- Zawgyi 지원 (글꼴 및 인코딩)이 있으며 미얀마 사용자에게 유용

> 자세한 것은 다음 세션에서 확인 : [Best practices for text on Android](https://www.youtube.com/watch?v=x-FcOX6ErdI)

## Magnifier

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/028.png" }}" /> 

- Android P에서 추가된 돋보기 API의 기능 추가
  - CornerRadius
  - Elevation
  - Initial Zoom
  - Size

## Private APIs

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/029.png" }}" /> 

Private API를 호출할 이유가 없다는 것을 언급

- Public 메소드가 이미 있거나
- 별도 새로운 Public 메소드를 도입 예정
- Private API를 grey list에 올리는 것으로 제한할 예정
- 향후 릴리즈에서 기능이 더 이상 작동하지 않을 수 있다

> 자세한 정보는 [developer.android.com/preview/non-sdk-q](https://developer.android.com/preview/non-sdk-q) 참고

## ART

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/031.png" }}" /> 

- Cloud 에서 App Profile 가능

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/032.png" }}" /> 

- 새로운 동시성 Collector 추가
- GC, Generational Collector 추가

> 자세한 것은 다음 세션에서 확인 : [Understanding Android Runtime (ART) for Faster Apps](https://www.youtube.com/watch?v=1uLzSXWWfDg)

## Kotlin

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/033.png" }}" /> 

- Android Q에 새롭게 추가된 API에는 nullable annotation이 함께 제공
- Q를 타겟으로 할 때 null 허용을 오류로 강제화한다
- Kotlin 1.3.30에서 kapt의 Incremental annotation processing 반영

> 자세한 것은 다음 세션에서 확인 : What's New in Kotlin on Android, 2 Year In

## Security

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/034.png" }}" /> 

- TLS 1.3이 기본 활성화 (약 40% 개선)
- Biometric dialog 개선
- Jetpack 보안 라이브러리

> 자세한 것은 다음 세션에서 확인 : [Security on Android: What's Next](https://www.youtube.com/watch?v=0uG_RKiDmQY)

## PowerManager

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/035.png" }}" /> 

- Throttling 상태 수신 가능

## Neural Network API

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/036.png" }}" /> 

60회의 새로운 작업을 수행하여 대기 시간을 대폭 줄였습니다.

> 자세한 것은 다음 세션에서 확인 : [What’s New in Android Machine Learning](https://www.youtube.com/watch?v=wpKJpeOy-68)

## Preferences

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/040.png" }}" /> 

- android.preference는 deprecated
- android jatpack의 androids.preference 사용을 권장

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/038.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/039.png" }}" /> 

> 자세한 것은 다음 세션에서 확인 : [Youtube (ADS '18): Preferential Practices for Preferences](https://www.youtube.com/watch?v=PS9jhuHECEQ)

## Architecture Components

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/041.png" }}" /> 

- WorkManager : 1.0.1 및 2.0.1 Stable 

> 자세한 것은 다음 세션에서 확인 : [Youtube (ADS '18) : Easier Background Processing with WorkManager](https://www.youtube.com/watch?v=83a4rYXsDs0)

- Navigation : 1.0 & 2.0

> 자세한 것은 다음 세션에서 확인 : [Jetpack Navigation](https://www.youtube.com/watch?v=JFGq0asqSuA)

- ViewModel의 SavedState가 알파로 변경. 프로세스 재사용을 보다 쉽게 처리
- 벤치마킹 : 코드에서 성능 테스트를 처리하는 새로운 Jetpack API

> 자세한 것은 다음 세션에서 확인 : [Improving App Performance with Benchmarking](https://www.youtube.com/watch?v=ZffMCJdA5Qc)

- Lifecycles, Livedata 및 Room : 향후 Architecture Component 이용 시 Coroutine 과 함께 사용

> 자세한 것은 다음 세션에서 확인 : [[What's New in Architecture Components](https://www.youtube.com/watch?v=Qxj2eBmXLHg)

## CameraX

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/043.png" }}" /> 

- 일부 플랫폼 API의 장치별 구현을 가지고 있는 문제 해결
- Android Lollipop의 모든 버전과 호환
- 간결한 API
- HDR과 같은 기기별 기능에 대한 제공을 위해 제조업체와 협력

> 자세한 것은 다음 세션에서 확인가능 : [Android Jetpack: Understand the CameraX Camera-Support Library](https://www.youtube.com/watch?v=kuv8uK-5CLY)

## Jetpack Compose

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/044.png" }}" /> 

- Keynote에서 언급한 것처럼 Jetpack Compose라는 새로운 UI Toolkit을 개발 중
- Unbundled : 애플리케이션 내부에 위치하여, 언제든지 업데이트를 제공
- 반응형
- Kotlin으로 작성

AOSP에 모든 것이 이루어진다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/045.png" }}" /> 

Jetpack Compose를 사용하면 구성 요소가 단일 기능에 불과합니다.

- Annotation Processor를 사용하지 않고, Kotlin Compiler Plugin을 사용
- 함수의 모든 매개 변수는 구성 요소의 매개 변수 또는 속성
- XML을 작성하지 않아도 된다. XML 레이아웃이 없음
- 데이터 바인딩이 없음
- 리스너가 없음

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/046.png" }}" /> 

더 많은 것을 알고 싶다면 [d.android.com/jetpackcompose](d.android.com/jetpackcompose) 를 방문해주세요

> 자세한 것은 다음 세션에서 확인가능 : [Declarative UI Patterns](https://www.youtube.com/watch?v=VsStyq4Lzxo)

## ViewPager2

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/047.png" }}" /> 

ViewPager 와 비슷하지만 더 유연한

- 쉽게 ViewPager에서 마이그레이션
- RecyclerView 기능
- RTL 지원
- 수직 ViewPaging 지원
- DataSet 변경에 대한 알림을 효과적으로 지원

## ViewBindings

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/048.png" }}" /> 

더 이상 findViewById를 사용하지 않아도 된다

- Annotation Processor를 사용하지 않아도 된다
- XML 레이아웃에 직접 바인딩 코드를 생성
- Null에 대해서 안전하며 type-safe하다

> 자세한 것은 다음 세션에서 확인가능 : [What's New in Architecture Components](https://www.youtube.com/watch?v=Qxj2eBmXLHg)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/049.png" }}" /> 

- 컴파일시에 DataBinding를 사용하는 것과 유사한 기술을 사용해 SearchItemBindings 클래스를 생성
- 뷰에 직접 접근하는 데 사용할 수 있는 여러 필드 또는 속성이 존재

## Blend Modes

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/050.png" }}" /> 

- Android Q에서 PorterDuff.Mode 대신 BlendMode를 도입
- HARD_LIGHT 및 SOFT_LIGHT 등 추가

## RenderNode

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/051.png" }}" /> 

- RenderNode는 UI Toolkit에서 하드웨어 가속 및 내부적으로 뷰에서 사용 됨
- 효율적인 렌더링을 위해 렌더링 노트 트리를 작성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/052.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/053.png" }}" /> 

- 캔버스가 하드웨어 가속이 가능한지 확인 필요
- drawRenderNode를 호출하여 RenderNode 를 사용하여 렌더링 가능

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/054.png" }}" /> 

- 별도 View를 생성하지 않고, 외곽선/그림자를 렌더링 가능

## HardwareRedner

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/055.png" }}" /> 

- UI toolkit 내부적으로 사용
- 모든 RenderNodes를 Suface로 렌더링
- Material Design에서 사용하는 광원을 제어할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/056.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/057.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/058.png" }}" /> 

## Hardware Bitmpas

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/059.png" }}" /> 

- 하드웨어 비트 맵은 HardwareBuffer를 래핑 가능
- OpenGL, 카메라 또는 다양한 다른 하드웨어 모듈에 의해 생성됨
- Texture Upload 비용을 들이지 않고 사용 가능
- 기본적으로 Suface를 래핑하는데 사용할 수 있음

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/060.png" }}" /> 

> 예제 : 하드웨어 렌더링을 사용하는 Lottie 애니메이션

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/061.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/062.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/063.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/064.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/065.png" }}" /> 

> 자세한 것은 다음 Office Hours에서 확인가능 : Android Graphics Office Hours

## Vulkan

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/066.png" }}" /> 

새로운 64 비트 장치는 Vulkan 1.1과 함께 제공된다

> 자세한 것은 다음 Office Hours에서 확인가능 : Android Graphics Office Hours

## ANGLE

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/067.png" }}" /> 

- 실험적 기능이며
- Vulkan 위에서 OpenGL ES 실행
- OpenGL ES 드라이버에 대한 업데이트를 단순한 APK로 전달 가능

> 자세한 것은 다음 Office Hours에서 확인가능 : Android Graphics Office Hours

## Wide Color Gamut

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/068.png" }}" /> 

- Android O에서 Wide Color 렌더링을 도입, 16비트를 사용
  - 많은 배터리를 사용 → 8비트 색상 심도를 사용하여 문제 해결
- @ColorLong 새로운 API도 추가

## Audio Playback Capture

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/069.png" }}" /> 

- 별도 장치에서 오디오를 캡처할 수 있다
- Android Q를 타겟팅한 경우에만 기본적으로 ON으로 선택

## External Storage

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/071.png" }}" /> 

- 기본적으로 다른 앱에서 만든 파일에 접근할 수 없도록 하는 것
- targetSdk Q의 경우 기본적으로 샌드박스로 설정
  - 해당 앱에서만 파일에 접근 가능
- 미디어 파일 : MediaStore API와 Storage Permission을 사용해 접근 가능
- 사진 메타정보 : Storage Permission과 MediaLocation Permission이 필요
- 모든 파일 : File Browser 같은 앱이라면 Manifiest에 설정 필요

> 자세한 것은 다음 세션에서 확인 : [What’s New in Shared Storage](https://www.youtube.com/watch?v=3EtBw5s9iRY)

## Location

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/072.png" }}" /> 

- 백그라운드에서 실행되어야 할 경우 등 사용자 위치에 대한 새로운 권한이 필요
- 다음 3가지로 권한을 부여한다
  - 항상 사용 / 사용 중일 때만 사용 / 거부

> 자세한 것은 다음 세션에서 확인 : [Updating Your Apps for Location Permission Changes in Android Q](https://www.youtube.com/watch?v=L7zwfTwrDEs)

## Background Activity Start

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/073.png" }}" /> 

- Background에서 시작될 때 실행을 제한
- 필요하다면
  - Foreground 앱
  - System, Broadcast에서 PendingIntent를 사용
  - Foreground Notification 사용

> 자세한 것은 다음 세션에서 확인 : [Overview of Privacy Changes in Android Q](https://www.youtube.com/watch?v=bFp2n5OxYEE)

## Camera

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/074.png" }}" /> 

- 카메라의 특성의 데이터에 대한 접근을 제한
- 정보 취득을 위해서 카메라 권한이 필요

> 자세한 것은 다음 세션에서 확인 : [Overview of Privacy Changes in Android Q](https://www.youtube.com/watch?v=bFp2n5OxYEE)

## Connectivity

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/075.png" }}" /> 

- 앱에서 와이파이를 즉시 사용/미사용으로 변경할 수 없다
- 대신 별도 Settings Panel을 사용하도록 권장

## Settings Panel

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-android/076.png" }}" /> 

- Internet, NFC, 볼륨, Wifi를 앱 내에서 설정 가능
