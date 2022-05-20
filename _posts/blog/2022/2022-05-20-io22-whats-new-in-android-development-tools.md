---
layout: post
title: "[요약] What's new in Android development tools (Google I/O '22)"
date: 2022-05-20 21:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io22
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/RFv8GkLd5OY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

# Roadmap

작년 I/O '21 이후, 제보/관찰 중인 버그가 1600개 이상, UI 중단 문제가 20개, 메모리 누수 12개를 수정되었다.

## Android Studio Bumblebee

**Deivice Manager**

물리적 및 가상 ID에 연결된 모든 디바이스를 볼 수 있는 새로운 `Deivice Manager`를 출시했다

**Animated Vector Drawable Preview**

애니메이션 Vector Drawable의 Preview 지원을 추가했다.

**ADB over Wi-Fi**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/001.png" }}" /> 

Wi-Fi를 통해 디바이스를 ADB와 페어링 하도록 추가했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/002.png" }}" /> 

Bumblebee에 추가된 주요 변경사항이다.

## Android Studio Chipmunk

**Compose Animation Preview**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/003.png" }}" /> 

Compose 애니메이션을 미리 볼 수 있는 Preview를 추가했다.

**Jank Detection**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/004.png" }}" /> 

Android Studio Profiler에서 앱의 버벅거림 감지 기능을 추가했다. 

> Support for profiling your app : https://developer.android.com/studio/releases#support-for-profiling-app

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/005.png" }}" /> 

Chipmunk는 IDE의 품질에 시간을 할애하여 안정성을 집중한 소규모 릴리즈이다.

# Demo

## Android Studio Dolphin & Electric Eel

### **Build Analyzer**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/006.png" }}" /> 

Configuration cache를 켜야 한다고 알려주며, 이를 위해서 Android Gradle plugin을 업그레이드해야 한다.

빌드 속도를 향상시키기 위해 할 수 있는 가장 쉬운 일은 AGP/Kotlin 컴파일러/다른 플러그인을 최신 버전으로 유지하는 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/007.png" }}" /> 

마이그레이션할 버전을 선택하고 `Run selected steps` 버튼으로 원하는 작업을 실행하면 변경된 사항을 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/008.png" }}" /> 

build analyzer를 통해서 새로운 제안 사항이 있다는 것을 감지하였을 때 알려주는 기능이 추가되었다. 

Android Studio 팀에서 Jetifier를 제거하려고 한다는 것을 암시적으로 알려준다. 이 기능은 전이적 의존성(transitive dependencies)을 통하여 deprecated된 패키지를 필요로 하는 라이브러리에 의존한다는 것을 알려준다.

**Google Play SDK Index Lint**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/009.png" }}" /> 

사용 중인 라이브러리 버전에 안전한지를 지정할 수 있도록 SDK 게시자와 협력하고 있다.

Studio integration을 사용하면 APK 릴리즈뿐만 아니라 가능한 한 빨리 문제를 알 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/010.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/011.png" }}" /> 

필요한 대응 후 검사 결과 Jetifier를 비활성화 가능하므로 변경한다.

Jetifier 플래그를 빼면 `증분 빌드 속도가 5~8% 증가`할 수 있다.

**configuration cache**

configuration cache는 기본적으로 활성화되길 바라며 변경을 제안한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/012.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/013.png" }}" /> 

**Files download**

빌드 중에 네트워크 트래픽을 감지하면 이를 표시한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/014.png" }}" /> 

잘못 구성된 Repository, 불필요한 리다이렉션, 과도한 재시도 등으로 인해 빌드 속도가 느려지는 경우에 유용하다. 

**비전이적 R 클래스**

소규모 프로젝트에서는 유용하지 않다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/015.png" }}" /> 

이것은 각 모듈의 R 클래스에 대한 네임스페이스를 사용하도록 코드를 업데이트하는 것이다. 즉, AGP는 빌드 시 리소스를 앱 R 클래스에 복제할 필요가 없다.

```properties
# gradle.properties

android.nonTransitiveRClass=true
```

```kotlin
// before
val actionText = getString(R.string.settings)

// after
val actionText = getString(com.android.tools.core.R.string.settings)
```

R 클래스에 정규화된 이름을 사용하기 때문에 다른 모듈에서 리소스에 액세스하는 것이 길어지지만, Kotlin의 import aliases를 사용하여 정리할 수 있다.

```kotlin
import com.android.tools.core.R as Core_R

val actionText = getString(Core_R.string.settings)
```

모든 케이스를 위한 것은 아니지만, 쉽게 시도하여 프로젝트의 빌드 속도에 의미 있는 차이를 만든다.

**Lint를 AGP에서 캐시 및 증분**

```bash
./gradlew lint
```

이전에 Lint를 실행한 후 Lint를 실행하면 완전히 캐시 가능하다는 것을 알 수 있다. 코드를 변경하더라도 영향을 받는 새로운 모듈만 다시 계산한다.

CI 서버에서 Lint를 점진적으로 실행하면 훨씬 더 빠르게 실행된다.

### Instrumentation Tests

에뮬레이터를 사용하여 Instrumentation test를 하더라도 매우 느리고 구성하기 까다롭다. 또한 부팅하고 실행하는데 시간이 오래 걸린다.

새로운 Gradle managed devices를 통하여 이 문제를 해결할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/016.png" }}" /> 

build.gradle 파일에 테스트를 실행할 장치 구성을 지정할 수 있다. 기기 유형, API level, 이미지 종류(AOSP, Google 서비스 포함 여부)를 선택할 수 있다.

새로운 유형의 시스템 이미지와 자동화된 테스트 장치(줄여서 ATD)를 만들었다. 테스트를 실행하도록 특별히 최적화되어있다. 설정 앱, Gmail, Google 지도 등과 같이 테스트에 필요하지 않은 항목은 포함되어 있지 않다.

특정 system image를 별도로 다운로드하지 않아도 테스트가 실행 중인 컴퓨터를 기반으로 자동으로 선택한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/017.png" }}" /> 

테스트를 다시 실행하면 몇 초 안에 장치에서 테스트가 실행되며, 계측 테스트임에도 불구하고 빨리 시작되어 실행된다. 재사용하고 있던 스냅샷에서 에뮬레이터를 부팅하므로 이런 효과를 얻을 수 있다.

## Jetpack Compose

Jetpack Compose는 새로운 UI toolkit이며, 시스템 이미지와 함께 번들로 제공되는 이전 View 시스템과 달리 전체 toolkit이 앱과 함께 번들로 제공된다.

### baseline profile

APK 내부의 `asserts/dexopt/baseline.prof`이 생겨난다. 이것은 APK Analyzer에 의해 분리된 바이너리 파일로 Play Store에서 앱을 설치 시 미리 컴파일해야 하는 메서드가 나열되어 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/018.png" }}" /> 

이 처리는 release variants를 빌드 할 때 자동으로 일어난다. 라이브러리 측에서도 제공한 baseline profile과 Gradle Plugin이 이를 앱에 합친다(=Merged).

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/019.png" }}" /> 

baseline profile은 특정 경로에 맞게 커스텀도 가능하다. 특정 시나리오를 작성한 후 디바이스에서 가져올 baseline profile이 생성된다.

- 소스 트리에서 체크인한 후 나머지는 Gradle plugin이 처리한다

### profiler debuggable builds

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/020.png" }}" /> 

디버깅 정보 없이 프로파일링을 시작할 수 있다. 프로파일링만을 위한 테스트가 가능해졌다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/021.png" }}" /> 

네트워크 검사기와 같이 모든 원격 측정을 사용할 수 없다는 메시지가 표시된다. 더 적은 정보 수집으로 일부 정보를 놓치고 있지만, 실제 단말로 측정하기 때문에 CPU 프로필이 더 정확하다는 것을 의미한다.

### jank profiling

Jank Profiling 또는 일부 프레임이 지연되는 UI를 찾는 프로파일링이다. Systrace에 새로운 `Janky frames` 섹션이 추가되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/022.png" }}" /> 

> 예시의 프레임은 20ms 초의 예상 시간이었지만, 실제로는 30.6ms 초가 걸렸다

Jank Profiling을 사용하려면 Android 12에서 이와 같은 프레임 수명 주기를 캡처하는 데 필요한 모든 정확한 데이터를 가져와야 한다.

### Logcat

Logcat이 새롭게 단장했으며 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/023.png" }}" /> 

> New Logcat : https://developer.android.com/studio/preview/features/#logcat

### Device Management

**Embedded Emulator**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/024.png" }}" /> 

이제 에뮬레이터뿐만 아니라, 실제 디바이스도 Android Studio 내에서 제어할 수 있다. 

**ADB wireless**

ADB 무선을 사용하여 Android Studio와 페어링 할 수 있다. API 레벨 26 이상인 장치에서 동작한다. Embedded Emulator와 마찬가지로 간편하게 실제 디바이스에서 앱을 테스트할 수 있다.

Wear 페어링도 개선했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/025.png" }}" /> 

Wear에서 타일/시계 모드를 쉽게 실행할 수 있으며, Wear 전용 메뉴도 생긴다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/026.png" }}" /> 

버튼을 클릭하거나 시계를 기울이기, 시계 위에 손바닥을 올려놓는 시뮬레이션을 쉽게 할 수 있다.

**Bluetooth 지원**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/027.png" }}" /> 

이제 터미널에서 가상 심박수 모니터를 만들 수 있다. 이 기능을 만든 의도는 Bluetooth 장치가 실제로 계측 테스트에서 동작하길 위함이다.

**Resizable**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/028.png" }}" /> 

대형 화면 장치에서의 앱 개선을 위한 일환으로 `크기 조정 가능한 Emulator`를 추가했다. 	

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/029.png" }}" /> 

일반 에뮬레이터처럼 보이지만, 화면 크기를 전환하는 메뉴를 볼 수 있다. 화면 크기 변경 시 레이아웃을 새로운 크기로 강제하는 것이 아니라 Android OS 수준에서 수행된다.

**Visual Lint**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/030.png" }}" /> 

레이아웃에 대한 일부 분석을 실행하여 일반적인 문제를 찾기 때문에 Visual Lint라는 이름이 붙었다. 레이아웃 노출 및 텍스트와 배경 색상간의 대비를 체크해 준다. 현재 View 시스템에만 적용되어 있지만, 추후 Compose에도 적용 계획이다.

## Compose

### Live Edit

문자열과 숫자를 즉시 업데이트할 수 있는 기능은 미리 보기뿐만 아니라 디바이스/에뮬레이터에서 앱을 실행하는 데에도 동작한다. 

<iframe width="560" height="315" src="https://www.youtube.com/embed/RFv8GkLd5OY?start=1288" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 예시에서는 텍스트/Padding/텍스트 크기/텍스트 컬러 변경을 보여준다

> Live Edit : https://developer.android.com/studio/run#live-edit

<iframe width="560" height="315" src="https://www.youtube.com/embed/RFv8GkLd5OY?start=1401" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

- LazyGrid로 고정 개수 및 너비에 따른 노출 처리도 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/031.png" }}" /> 

`-1`과 같이 사용 불가능 한 값을 사용하여 앱 충돌을 일으키는 버그가 있는 코드를 작성할 수 있다.

### Compose Preview

Compose Preview 사용으로 Light/Dark Theme, 디바이스 방향, 화면 크기 등 다양한 조건에서 Composable을 미리 확인할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/032.png" }}" /> 

단일 기능에 대한 여러 개의 Preview를 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/033.png" }}" /> 

Compsoe 1.2에서는 Preview Annotation을 복수 Preview Annotation으로 선언할 수 있다. 이로써 Configuration을 계속해서 반복 정의할 필요가 없다.

Preview에서도 Live Edit 기능을 지원한다. 매번 레이아웃 환경을 다시 만듦으로 1~2초의 약간의 트레이드오프가 있다. `Interactive Preview`도 제공한다.

### Animation Preview

Interactive preview 옆에 Animation Preview도 존재한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/034.png" }}" /> 

> Animations : https://developer.android.com/jetpack/compose/tooling#animations

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/035.png" }}" /> 

Compose 1.2에서는 특정 케이스를 고정할 수 있다. 고정한 항목은 애니메이션이 동작하지 않도록 하여 다른 애니메이션이 상대적으로 어떻게 움직이는지 확인할 수 있다.

### Layout Inspector

재구성 수에 대한 지원이 추가되었다. 영향을 받지 않은 이 다른 텍스트는 건너뛰기 횟수가 증가한 것을 볼 수 있다.

<img src="https://developer.android.com/images/jetpack/compose/tooling-layout-inspector-recomposition-counts.png" />

> recomposition counts : https://developer.android.com/jetpack/compose/tooling#editor-actions

## App Insights

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/036.png" }}" /> 

Android Studio 내부에서 Google 계정에 로그인하면 Firebase Crashlytics로 탐지된 에러를 확인할 수 있다. 

> 예시로는 해당 라인에 에러가 있다는 것을 알려주고 있으며, 이것이 거의 6,000개의 장치에 영향을 미치고 알려주고 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/037.png" }}" /> 

Firebase Crashlytics를 통해서 수집된 오류는 `App Insights`에서 확인할 수 있다. 이벤트 및 Device 개수로 정렬된 앱의 모든 Crash를 볼 수 있다.

- Crash가 발생한 Devices
- Android Versions
- App version, 수집 시간

Stack Traces를 클릭하여 소스로 이동할 수 있다.

# Updates

### Disable Jetifier

업데이트된 build analyzer를 사용할 때 gradle.properties 파일에서 Jettifier 플래그를 사용 중인지 감지하고 이를 false로 변경하도록 알려준다.

프로젝트의 80%가 이 플래그를 사용 중이지만, 제거하면 증분 빌드 속도가 10% 이상 향상된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/038.png" }}" /> 

### Baseline Profile

지난해 가을에 출시 간 Baseline Profile은 6,000명 이상의 개발자가 사용 중이며, 프로젝트 설정에 따라서 앱 시작 시간이 40% 이상 향상되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/039.png" }}" /> 

### 전체 요약

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/whats_new_in_android_development_tools/040.png" }}" /> 
