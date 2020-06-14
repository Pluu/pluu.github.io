---
layout: post
title: "[요약] What's new in Android development tools (Google I/O '18)"
date: 2018-05-13 01:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- IO18
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/WxAZk7A7OkM" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</div>

<!--more-->

## Roadmap

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/01.png" }}" /> 

### v3.0

작년 출시한 Android 3.0에는 Performance Profiler, Kotlin 언어 지원, Adaptive Icon, PlayStore가 포함된 에뮬레이터 및 20개의 새로운 기능이 포함되었습니다

### v3.1

Android Studio 3.1은 성능과 품질에 초첨을 맞추었고. 800개이상의 버그와 안정성 문제를 해결했습니다.

### Build Speed

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/02.png" }}" />

Sugar가 포함된 D8을 사용할때 캐싱없이 Full Build에서 빌드 속도가 60%이상 향상되었습니다.

### SQL Code Editing

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/03.png" }}" /> 

SQL 코드 편집 지원을 포함하여 코드 완성과 프로젝트 탐색이 가능합니다.

### Kotlin Lint Checks

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/04.png" }}" /> 

코틀린을 Android Studio 내부 플랫폼에서 first class 언어로 발표했습니다. Android Studio 3.1에서 Kotlin 검사를 IDE뿐만아니라 Command line을 통해서도 할 수 있습니다.

### C++ Profiler

C++ CPU Profiler가 추가되었습니다. C++ 코드가 성능에 미치는 영향을 파악할 수 있습니다.

### Network Profiler

애플리케이션에 멀티 스레드인 네트워크 스레드를 가지고 있음을 알고 있습니다. 각 스레드를 보고 성능을 확인할 수 있습니다.

### IntelliJ Platform Update

각 버전의 Android Studio에는 최신 버전의 IntelliJ가 포함되어있습니다. 

### Emulator Quick Boot

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/05.png" }}" /> 

Emulator를 빠른 부팅을 가능하게 했습니다. 그로인해 에뮬레이터를 3초이내로 시작할 수 있습니다.

## Android Studio 3.2

Android Studio 3.2를 사용하면 Android P 개발자 Preview의 모든 최신 Android API를 테스트하고 검증할 수 있습니다.

#### Android App Bundle

Android App Bundle이라는 새로운 포맷을 구축할 수 있으며, Google Play를 통하여 사용자에게 맞춤 설정된 APK를 배포할 수 있습니다.

#### Android Jetpack

`Android Jetpack` 은 Android 앱을 빠르고 쉽게 확장할 수 있도록 도와주는 라이브러리, 개발자 도구 및 가이드라인 모음입니다.

---

### Android App Bundle

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/06.png" }}" /> 

오른쪽에 새로운 window 에서는 새로운 기능 및 변경사항을 강조합니다.

App Bundle의 핵심은 PlayStore에서 칩 아키텍쳐, 화면 크기, Locale의 조합에 대해 다양한 버전의 앱을 만들 수 있도록 앱을 패키지징하고 업로드할 수 있다는 것입니다. 다운로드 사이즈도 더 작아집니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/07.png" }}" /> 

Build → `Generate Signed Bundle / APK` 메뉴를 통해 사용이 가능합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/08.png" }}" /> 

앱 번들을 생성하는 새로운 옵션이 있습니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/09.png" }}" /> 

Google Play 에서 App Bundle을 사용하려면 암호화 키를 줘야합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/10.png" }}" /> 

번들로 내보내지 않았으며, 저장된 키의 위치를 확인하여 업로드할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/11.png" }}" /> 

APK Analyzer 를 통해 Bundle 파일을 확인할 수 있습니다. 샘플의 **Article Composer** 라는 부분은 `Dynamic Feature` 모듈의 정보입니다.

New → New Module → `Dynamic Feature Module` 을 통해 생성할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/12.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/13.png" }}" /> 

```groovy
apply plugin: 'com.android.dynamic-feature'
```

gradle 파일을 확인하면 Dynamic Features 를 위해 새로운 Gradle 플러그인이 적용되어 있습니다.

```xml
	<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:dist="http://schemas.android.com/apk/distribution"
    package="com.example.article_composer">

    <dist:module
        dist:onDemand="true"
        dist:title="@string/title_article_composer">
        <dist:fusing include="true" />
    </dist:module>
</manifest>
```

onDemand로 상태로 표시할 수 있으며, PlayStore에서 이 기능을 지원하지 않는 구형 단말의 APK에 이 모듈을 포함시킬지 결정할 수 있습니다. 메인 앱 모듈에는 이러한 Dynamic Features 에 연결됩니다.

```groovy
// app.gradle
android {
    dynamicFeatures = [":article_composer"]
}
```

다운로드 및 설치에는 Play core 라이브러리를 사용해야합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/14.png" }}" /> 

 Run/Config Dialog에 추가된 기능으로 로컬에서 테스트할 때 포함할 Features를 선택할 수 있습니다.

### Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/15.png" }}" /> 

여러 프로파일링 세션을 기록하고 나서 결과를 비교할 수 있습니다. 

#### CPU Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/16.png" }}" /> 

System Trace로 나타난`systrace` 는 강력한 프로파일러입니다. 커널에서 데이터를 확인하기 때문에 다른 CPU에서 일어나는일을 알 수 있습니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/17.png" }}" /> 

지금까지 `Record a method trace` 를 클릭하고 하고 확인하려고 했지만, 코드에서 트리거를 할 수 있습니다. 3.2에서는 디버그 Method를 호출할 수 있습니다. 표준 SDK Method인 `android.os.Debug` 입니다.

```java
// 디버그 시작
Debug.startMethodTracing("dmtrace.trace");
// 디버그 종료
Debug.stopMethodTracing();
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/18.png" }}" /> 

이를 통해 무엇이 잘못되었는지 알 수 있습니다.

#### Network Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/19.png" }}" /> 

- 어떤 스레드가 무엇을 하는지 볼 수 있는 Thread View가 있습니다
- 네트워크에 대한 Request/Response도 표시합니다

#### Memory Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/20.png" }}" /> 

새로운 큰 특징은 JNI 레퍼런스를 보유줄 수 있게 되었고, JNI 레퍼런스 allocation trace 추적이다

#### Energy Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/21.png" }}" /> 

Energy Profiler 는 배터리 수명이 어떻게 되는지 알 수 있습니다. 실제 CPU 사용량, 네트워크, 위치요청, Wake Locks 등을 사용하는지 알려줍니다. 바닥에 빨간색 막대는 Wake Lock 잠금 장치가 작동한다는 것을 보여주고 있습니다.

### Emulator

#### Snapshots

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/22.png" }}" /> 

에뮬레이터가 동작하는 동안 스냅샷 생성을 할 수 있으며, 생성된 스냅샷을 통해 바로 그 상태가 될 수 있습니다. 재생버튼을 누르면 스냅샷을 기록하는데 15초가 소요됩니다.

#### Screen record

오디오와 함께 비디오 녹화를 할 수 있습니다. 카메라도 향상했습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/23.png" }}" /> 

카메라 선택시 3D Scene에서 움직여서 확인 가능합니다. AR 앱을 만들때 중요합니다. IDE에서 AR에 대한 지원이 제공합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/24.png" }}" /> 

GLSK 파일과 Google Sceneform Tools 플러그인을 통해 3D 모델을 미리 볼 수 있습니다. Sceneform Asset을 불러올 수 있습니다. 실제로 이 모델이 무엇을 하는지 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/25.png" }}" /> 

### Jetpack

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/26.png" }}" /> 

android.support 의 v4, v7이 잘못된 버전 번호입니다. legacy 정리를 위해 `AndroidX`로 다시 패키징하고 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/27.png" }}" /> 

기존 namespace 를 새로운 namespace에 있는 라이브러리를 자동으로 리팩토링해주는 도구를 제공합니다. 이는 XML, Gradle 파일에도 적용됩니다. group ID와 artifact ID를 리패키징화합니다.

Refactor → `Refactor to AndroidX` 를 통해 리팩토링 가능합니다.

```groovy
// 기존
com.android.support:appcompat-v7:27.1.1
com.android.support:design:27.1.1
com.android.support:constraint:constraint-layout:1.1.0
com.androud.support.test:runner:1.0.2
com.androud.support.test.espresso:espresso-core:3.0.2
```

```groovy
// Refactoring
androidx.appcompat:appcompat:1.0.0-alpha1
com.google.android.material:material:1.0.0-alpha1
androidx.constraintlayout:constraintlayout:1.1.0
androidx.test:runner:1.1.0-alpha1
androidx.test.espresso:espresso-core:3.1.0-alpha1
```

현재 Canary 14 / Canary 15에는 몇몇 버그가 있습니다.

#### Navigation Library

<img src="https://4.bp.blogspot.com/-GDbN2ZoC_Xg/WvD9jHurQPI/AAAAAAAAFTA/4Y_QOG_fVrwzI1gUnff8BDDSJ9_cGOS2QCLcBGAs/s1600/navigation_editor.png" />

Navigation Library 에서는 처음부터 Navigation Library용 앱을 설계해야합니다. 

화면을 구성하는 레이아웃을 나열하고, 각 화면을 이동할 곳을 화살표로 연결하는 것으로, Navigator 상으로 이동되는 것이 결정됩니다. 

그리고, 각 XML의 레이아웃에서 NavHostFragment 넣으면, 런타임에 Dispatching 을 수행합니다. 그런 다음 navigation resource file에 저장합니다. 

```xml
<fragment
    android:name="androidx.navigation.fragment.NavHostFragment"
    app:navGraph="@navigation/nav_graph"
    app:defaultNavHost="true" />
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/28.png" }}" /> 

추가적으로 Navigation Editor를 통해서 애니메이션 처리도 가능합니다.

**Deep Link**

|                      Navigation Editor                       |                     Add Deep Link Dialog                     |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/29.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/30.png" }}" />  |

Deep Link 추가시 manifest에 추가되는것을 확인할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/31.png" }}" /> 

그리고, Merged Manifest에 실제로 Deep Link로 추가한 필터 정보가 생성됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/32.png" }}" /> 

### LayoutEditor ~ Sample Data

샘플 데이터에 대한 작업을 했었지만, 이번 릴리즈에서 사용하기 훨씬 쉬워졌습니다. Layout 의 Design Time Property 에 접근할 수 있습니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/33.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/34.png" }}" /> 

현재 접근 가능한 모든 샘플 데이터를 탐색할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/35.png" }}" /> 

그리고, 뷰 선택시 네개의 버튼이 있습니다. 네번째 아이콘은 `wrench` 입니다. 디자인 타임 속성을 의미합니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/36.png" }}" /> 

해당 기능은 RecyclerView 에도 적용이 가능합니다.

### LayoutEditor ~ Material Theming

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/37.png" }}" /> 

새롭게 추가된 chip widget, 둥근 곡선으로 볼수 있는 BottomAppBar입니다.

### LayoutEditor ~ MotionLayout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/38.png" }}" /> 

ConstraintLayout 의 하위 뷰에 애니메이션을 적용할 수 있으며, 실제로 동작 경로도 확인 가능합니다. 추가적으로 키 프레임을 추가할 수 있습니다. 

## Build

### Android App Bundle

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/39.png" }}" /> 

App Bundle을 좀 더 제어하고 싶은 경우, build.gradle 파일에 플래그를 추가할 수 있습니다. (ex, 화면 밀도, ABI, 언어)

### AndroidX Refactoring

build 시스템 관점에서 grade 속성 파일에 몇가지 사항을 추가해야합니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/40.png" }}" /> 

### D8 & R8

- D8 : Default Dexer
- R8 : New Optimizer

D8은 현재 디폴트이고 Dex를  대체합니다. 

R8은 빌드 툴 체인의 optimizer와 shrinker를 담당하며 Proguard를 R8로 대체하는것이 장기적 전략입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/41.png" }}" /> 

 grade.properties에 속성을 활성화하기만 하면됩니다. 하지만 아직 실험단계이므로 PlayStore까지 내보내는것은 추천하지 않습니다.

더 자세한 세션을 원하면 아래의 세션을 참고해주세요

> [What's new with the Android build system (Google I/O '18)](https://www.youtube.com/watch?v=N5xONyp69eU)
>
> [Best practices using compilers in Android Studio (Google I/O '18)](https://www.youtube.com/watch?v=gGOOkk2y_Ss&t=1149s)
>
> [Improve app performance with Android Studio Profilers (Google I/O '18)](https://www.youtube.com/watch?v=O5V9ZSL0BsM&t=156s)
>
> [What's new with ConstraintLayout and Android Studio design tools (Google I/O '18)](https://www.youtube.com/watch?v=ytZteMo4ETk)

## Feedback

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/42.png" }}" /> 

Android Studio 는 Canary, Beta, Stable 채널로 출시합니다. Canary는 최신 기술이 포함된 채널이고 약간의 테스트를 거치고 출시합니다. Stable은 가장 안정적인 피드백을 받고 테스트가 끝나면 출시합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/43.png" }}" /> 

Canary 채널에 대한 피드백을 일찍 받을수록 우리가 그것을 고칠 가능성이 더 높다는 것입니다. 문제는 일단 Android Studio가 Stable로 도달하면 문제를 해결하기엔 너무 늦습니다. Canary 채널에서 Android Studio를 다운로드하고 피드백을 보내주시기 바랍니다.

## Recap

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-development-tools/44.png" }}" />
