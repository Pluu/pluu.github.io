---
layout: post
title: "[요약] What's New in Android Studio (Android Dev Summit '19)"
date: 2019-11-07 23:59:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/XPMrnR1_Biw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<!--more-->

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/001.png" }}" /> 

Google I/O에서 Android Studio 3.5 베타를 출시했으며, 9월부터는 3.6 베타 프로그램이 시작했다. 

3.6의 기능은 아래와 같다.

- ViewBinding
- Google 지도가 포함된 에뮬레이터
- 디자인 툴 개선
- Kotlin & JNI 지원

## Android Studio 3.5

Android Studio 3.5에서는 Project Marble이 큰 중심이다. Project Marble의 상세한 기능으로는 아래와 같다.

### Typing Latency 개선

| Android Studio 3.4                                           | Android Studio 3.5                                           |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![https://developer.android.com/studio/images/releases/xml-editing-latency-3.4.gif](https://developer.android.com/studio/images/releases/xml-editing-latency-3.4.gif) | ![https://developer.android.com/studio/images/releases/xml-editing-latency-3.5.gif](https://developer.android.com/studio/images/releases/xml-editing-latency-3.5.gif) |

XML에서 데이터 바인딩 코드 작성 시 입력이 지연되는 문제를 수정했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/002.png" }}" /> 

Android Studio에서 일어나는 메모리 문제를 수집하고 사용자에게 IDE에 할당 가능한 힙 사이즈 크기를 조절할 수 있게 했다. 그리고, 최신 버전의 Gradle Plugin을 사용하는 방법을 추천하다.

### 빌드 & 배포 시간

Project Marble 이전 빌드 속도는 평균 12.5초였지만, 적용 후 9.3초까지 개선했다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/003.png" }}" /> 

기존 3.0에서 3.3까지는 빌드 속도가 증가했다. 3.5에서는 Android Studio Gradle Plugin을 통해서 빌드 시간을 줄이도록 개선했다. 

그리고, `Apply Changes`를 통해서 디바이스 혹은 에뮬레이터로 배포하는 시간을 7.9초에서 3.6초로 단축했다. Apply Changes는 Instant Run의 대체재이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/004.png" }}" /> 

## Android Studio 4.0

### Build Speed Profiler (Canary 1 미포함)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/005.png" }}" /> 

빌드시에 일어나는 작업의 시간을 그래프 형태로 명시적으로 제공한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/006.png" }}" /> 

각 플러그인의 빌드 시간에 대한 분석도 제공한다. 위 그림에서는 `com.google.android.gms.oss-licenses-plugin` 이 빌드의 40%를 차지하는 것을 알 수 있다. 이 작업이 디버그 빌드에 불필요하면 별도 작업을 해야 한다는 것을 알 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/007.png" }}" /> 

항상 실행되는 `Task`에 대해서도 체크해야 한다. `Task` 변경에 대한 항목이 실행되어야 하지만, 매번 실행되는  `Task` 를 확인할 수 있어 수정이 필요하다는 것을 알 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/008.png" }}" /> 

증분 빌드를 방해하는 충돌하는 Task를 알 수 있으며

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/009.png" }}" /> 

캐시가 불가능한 Task를 알려준다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/010.png" }}" /> 

Incremental Annotation Buil가 되지 않는 Task도 알 수 있으므로, Incremental Build가 불가능해서 발생하는 빌드 속도 문제 원인을 알 수 있다. 케이스에 따라서는 버전 업데이트만으로 해당 문제가 해결된다는 안내도 함께 메시지로 노출한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/011.png" }}" /> 

Configuration 작업은 무엇보다도 빠르게 작동해야 하지만, 일부 플러그인에서 많은 계산은 하고 있다. 위 예제에서는 특정 Configuration 작업에 2초가 발생한다는 것을 알 수 있다.

> 첫 번째 빌드와 증분 빌드를 분리하여 확인하면 CI에서의 빌드 최적화 여부를 찾을 수 있다.

### Kotlin DSL script 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/012.png" }}" /> 

드디어 Android Studio에서 Kotlin DSL Build Script(*.kts)를 지원한다. 코드 자동완성과 Document 지원으로 더 빠르게 개발할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/013.png" }}" /> 

`Project Structure dialog`도 지원하며, 라이브러리의 최신 버전이 있으면, `Project Structure dialog`에서 갱신할 수 있도록 알려준다.

### Java 8 library desugaring

```kotlin
android {
  compileOptions {
    // Flag to enable support for the new language APIs
    coreLibraryDesugaringEnabled true
    // Sets Java compatibility to Java 8
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
}
```

Android Studio 4.0에서는 `desugaring`을 통해 minSdkVersion로 인해 사용할 수 없었던 API 기능을 사용할 수 있다. D8을 통해 API의 구현을 포함하는 별도의 라이브러리 DEX 파일로 컴파일한다. 즉,  `Desugaring` 프로세스는 런타임에 해당 라이브러리를 대신 사용하도록 앱의 코드를 다시 작성한다.

지원하는 API는 아래와 같다.

- `java.util.stream`
- `java.time`
- `java.util.function`
- `java.util.{Map,Collection,Comparator}`
- `java.util.Optional, java.util.OptionalInt`, `java.util.OptionalDouble`) 
-  `java.util.concurrent.atomic` , `AtomicInteger`, `AtomicLong` , `AtomicReference`
- 버그가 수정된 `ConcurrentHashMap` 

> Link : https://developer.android.com/studio/preview/features#j8-desugar

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/014.png" }}" /> 

Stream의 경우 minSdkVersion이 24 이상인 경우에만 플랫폼에 포함되어 사용할 수 있다. 그리고 위와 같이 메시지를 확인할 수 있다. 이때 coreLibraryDesugaringEnabled를 추가하여 백포트를 지원함으로서 낮은 API에서도 원하는 기능을 할 수 있다.

```kotlin
android {
  compileOptions {
    coreLibraryDesugaringEnabled true
  }
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/015.png" }}" /> 

이로써 이전과 같은 메시지를 노출하지 않는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/016.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/017.png" }}" /> 

기존 java/util/stream이 j$/util/stream으로 대체되어있으며 `desugaring`을 통한 백포트가 일어난 것을 볼 수 있다.

### ProGuard

ProGuard에 명시되어있는 클래스를 리팩토링할 시에 ProGuard 파일에도 적용된다.

### View Binding

```kotlin
android {
	viewBinding {
		isEnabled = true
	}
}
```

ViewBinding 은 DataBinding과 비슷하며, DataBinding을 사용하는 방법과 같다. 위 기능을 활성화시 Compile시에 Binding 클래스가 생성된다.

```kotlin
private lateinit var binding: ActivityMainBinding

private fun onCreateViewBinding(...) {
  binding = ActivityMainBinding.inflate(layoutInflater)
  // ...
	binding.textView.text = ...
  binding.button?.text = ...
}
```

ViewBinding을 사용함으로 해당 레이아웃에 어떤 뷰가 정확히 있는지 알 수 있다. 

### Jetpack Compose

기존까지 Bundle 형태로 제공하지 않아서 실제로 Compose 기능이 있는 Android Studio를 빌드해서 사용해야 했지만, Android Studio 4.0 Canary1부터는 Jetpack Compose를 지원한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/018.png" }}" /> 

IDE 상에서 `@Preview` Annotation이 정의된 부분의 작업은 화면 오른쪽에 Preview를 바로 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/019.png" }}" /> 

Light/Dark와 체크 상태 여부를 Preview를 통해서 바로 확인할 수 있음으로 매우 편리하다. 테마 및 글꼴, Scale 처리 등을 할 수 있다.

### Embed Emulator on Android Studio (Canary 1 미포함)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/020.png" }}" /> 

Android Studio 상에서 바로 Emulator에 접근할 수 있다. 

### Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/021.png" }}" /> 

기존 버전에서는 좌측하단에 Design/Text 탭이 존재했지만, 우측상단으로 이동했다. 각 버튼은 Editor Only/Editor and Preview/Preview Only 이렇게 3가지의 형태이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/022.png" }}" /> 

CustomView에서는 Preview로 어떤 형태로 노출되는지 확인할 수 있다.

### Layout Inspector (Canary 1 미포함)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/023.png" }}" /> 

새로운 Layout Inspector은 View의 리소스 정보를 알아보기 쉽게 노출한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/024.png" }}" /> 

버튼의 텍스트 색상은 녹색이지만, 이 색상이 어떻게 적용되었는지도 확인 가능하다. Material의 회색 컬러는 반영되지 않고, 실제로는 다른 Style에 있는 녹색이 반영되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/025.png" }}" /> 

현재 Layout Inspector를 한 디바이스의 화면이 변경되었을 경우, 즉시 반영된다. 그리고, 3D 형태로 전체 뷰의 스택을 확인할 수 있다. 실제로 화면을 구성하는 뷰 및 보이지 않는 뷰를 쉽게 추적할 수 있다.

### Motion Editor

![https://developer.android.com/studio/preview/features/images/motion-editor-convert.png](https://developer.android.com/studio/preview/features/images/motion-editor-convert.png)

ContraintLayout에서 쉽게 MotionLayout으로 변경할 수 있다. Layout Editor에서 오른쪽 메뉴를 통해서 변경되며 아래와 같은 화면으로 마이그레이션 된다.

![https://developer.android.com/studio/preview/features/images/start_end_constraint_set.png](https://developer.android.com/studio/preview/features/images/start_end_constraint_set.png)

![https://developer.android.com/studio/preview/features/images/motion_select_components.gif](https://developer.android.com/studio/preview/features/images/motion_select_components.gif)

Start 상태 / End 상태 / Transition / MotionLayout을 직접 선택할 수 있다.

![https://developer.android.com/studio/preview/features/images/motion_edit_constraints.gif](https://developer.android.com/studio/preview/features/images/motion_edit_constraints.gif)

변경하고자 하는 뷰를 선택한 후 원하는 변경을 지정하면 된다. 

![https://developer.android.com/studio/preview/features/images/motion-editor-keyposition.png](https://developer.android.com/studio/preview/features/images/motion-editor-keyposition.png)

Frame 이동 도중 다른 상태를 반영하기 위해서는 `KeyPosition`을 이용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/026.png" }}" /> 

복수 Transition이 정의된 경우 화면에 복수의 선이 노출된다.

![https://developer.android.com/studio/preview/features/images/motion_animation_preview.gif](https://developer.android.com/studio/preview/features/images/motion_animation_preview.gif)

### Resource Manager

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/027.png" }}" /> 

Vector Asset에서 새로운 Icon 생성 시의 다이얼로그를 개선했다. Material Design Site에 있는 아이콘을 추가했으며 Filled/Outlined/Round/Sharp/Two Tone 형태로 전환할 수 있다.

### Kotlin Live Template

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/028.png" }}" /> 

Class에 TAG를 지정하려면 `logt` 입력 후 Tab을 선택하면 된다. TAG에 지정되는 정보는 현재 파일 이름 기준이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/029.png" }}" /> 

`logm`을 사용할 경우, 현재 메소드의 이름과 모든 파라매터를 함께 로그로 표현한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/030.png" }}" /> 

`sbc` 사용하면 블록 형태의 주석을 얻을 수 있다.

> 실제로 이외에도 Kotlin 요으로 여러 가지 추가되었다.

## Emulator

### Displays

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/031.png" }}" /> 

복수의 디스플레이가 있는 테스트를 위해서 Emulator도 개선되었다. 원하는 디스플레이를 추가한 후 APPLY CHANGES를 누르면 실제 에뮬레이터에 반영된 것을 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/032.png" }}" /> 

### Location

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/033.png" }}" /> 

Emulator에 Google Map이 추가되었고, 실제로 경로를 재생할 수 있다. 그로 인해 위치가 필요한 앱에 직접적으로 위치를 경로를 전달할 수 있다.

## Additional

### Dynamic Features

![https://developer.android.com/studio/preview/features/images/feature-on-feature.png](https://developer.android.com/studio/preview/features/images/feature-on-feature.png)

기존에는 Dynamic Feature Module은 기본 모듈에만 의존할 수 있다. Android Gradle Plugin 4.0을 사용할 경우, 다른 Dynamic Feature Module에 의존하는 기능을 포함할 수 있다.

`:video` 모듈의 기능은 `:camera` 모듈에 따라서 달라질 수 있다.

### Layout Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/034.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/035.png" }}" /> 

### New Fragment wizard & fragment templates

![https://developer.android.com/studio/preview/features/images/fragment-gallery.png](https://developer.android.com/studio/preview/features/images/fragment-gallery.png)

Fragment를 생성하는 Wizard가 갱신되었다.

### ARM & x86 ABI 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/036.png" }}" /> 

기존 Emulator에서는 ARM 계열의 C++ 코드로 x86 Emulator를 사용할 수 없었다. ARM API와 x86 모두를 지원하는 Emulator가 공개되었다. 하나의 Emulator에서 두 가지 모두 사용할 수 있다.

### Chome OS

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/037.png" }}" /> 

Chrome OS에서 Android 앱 개발을 위해서 외부 Android 기기가 필요하거나 OS를 개발자 모드로 부팅해야하는 불편함이 있었다. 이제 더 이상 필요 없게 되었다. Chrome OS M80 업데이트부터 개발, 디버깅, 앱 배포를 모두 할 수 있다.

## Summary

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads/ads19/whats-new-in-android-studio/038.png" }}" /> 
