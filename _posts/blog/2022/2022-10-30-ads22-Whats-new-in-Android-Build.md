---
layout: post
title: "[요약] What's new in Android Build (Android Dev Summit '22)"
date: 2022-10-30 22:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/WZ1A7aoEHSw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/001.png" }}" />

- Android Gradle Plugin 8.0의 새로운 기능을 소개
- 동작 변경 사항
- Build Analyzer 소개
- Transform 제거

## New Features

### DSL/Variant API

Variant API는 Stable한 상태이다. 사용하는 것이 안전하며 이전 API와 비교하여 사용성 면에서 개선되었다.

> https://developer.android.com/reference/tools/gradle-api/7.4/com/android/build/api/variant/Variant

### Test Fixtures 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/002.png" }}" />

- 라이브러리를 사용하는 사용자가 더 쉽게 테스트할 수 있도록 하는 기능이며 Gradle에서 개발되었다.
- 라이브러리에 테스트 기능을 정의하고, 테스트 프로젝트에서 사용할 수 있다.
- Java에 대한 지원을 추가했다.
- Kotlin은 아직 미지원

### 증분 Kotlin 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/003.png" }}" />

- 이전에는 Kotlin 컴파일이 실패시 처음부터 다시 빌드되었다.
- 증분 컴파일을 위한 지원이 추가되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/004.png" }}" />

- Kotlin을 사용하는 경우, 이전에 비하여 빌드 속도가 변경되었다.
- Kotlin 컴파일러는 Java 컴파일러만큼 빠르지 않다

### Configuration Cache

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/005.png" }}" />

- Gradle에서 개발한 기능이다.
- Configuration 단계는 Task 트리를 구성하는 단계이며 매번 실행해야 한다.
  - 상대적으로 느리며, 프로젝트 크기에 따라서 실제로 느려질 수 있다. (몇 초, 10~20초 등)
  - 빌드할 때마다 소요되는 비용이다.
- Configuration Cache로 Task 트리를 캐시할 수 있게 되었다.
- 일반적으로 로컬 캐시이므로 빠르게 진행된다.
- 아직 완전히 안정적이지 않으며, 플래그로 On/Off를 할 수 있다.

> Use configuration caching : https://developer.android.com/studio/build/optimize-your-build#use-configuration-caching-experimental

## 동작 변경 사항

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/006.png" }}" />

`Upgrade Assistant`가 대부분의 과정을 알려준다.

### build.gradle에서 Namespace 속성이 필수

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/007.png" }}" />

- `Namespace`는 Build Configs에서 생성되는 R 클래스에 대한 Java/Kotlin 패키지 이름이다. 
- 기존 Android Manifest에 작성한 패키지 속성을 대체한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/008.png" }}" />

- 이전에는 패키지 속성이 Application ID와 R 클래스 생성에 사용되었다.
- build.gradle에서 Application ID를 설정할 수도 있다
- gradle 파일에서 해당 정보의 출처에 대한 혼란을 가져다준다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/009.png" }}" />

- Manifest에서 패키지 설정을 제거하고 Namespace 속성을 도입함으로 Application ID와 R 클래스 네임스페이스를 깔끔하게 분리할 수 있게 된다.
- 정보의 혼돈이 없고, Application ID에 영향을 주지 않고 코드/리소스를 자유롭게 리팩터링 할 수 있다
- AGP 7.3부터 사용할 수 있으며, AGP 8 Alpha03부터 필수로 적용된다
- Update Assistant로 Android Manifest의 패키지 속성을 build.gradle의 namespace 속성으로 마이그레이션 할 수 있다.

### BuildConfig 생성은 기본적으로 비활성화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/010.png" }}" />

- BuildConfig는 패키지 이름, Flavor 이름, Debug 플래그 등 현재 빌드에 대한 정적 정보를 포함하는 Java 파일이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/011.png" }}" />

- 이전에는 BuildConfig가 항상 생성되었다.
- 멀티 모듈 앱을 개발하는 경우, AGP의 빌드 속도에 영향을 주는 BuildConfig 파일이 생길 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/012.png" }}" />

- 모듈에서 BuildConfig 클래스 정보가 불필요할 수 있다.
- BuildConfig에 의존해야 하는 경우, 위 스니펫을 모듈의 build.gradle 파일에 추가하여 해당 속성을 활성화할 수 있다.
- 전체 프로젝트에 이전과 같은 동작을 원하면 gradle.properties 파일에 설정할 수 있다.

> BuildFeatures#buildconfig : https://developer.android.com/reference/tools/gradle-api/4.1/com/android/build/api/dsl/BuildFeatures#buildconfig

> android.defaults.buildfeatures.buildconfig=true

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/013.png" }}" />

- 불필요한 파일을 생성하지 않는 것이 중요하다
- BuildConfig가 Java 파일이므로 Kotlin을 사용하는 경우 빌드 성능에 추가적인 영향을 미친다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/014.png" }}" />

- AIDL과 Renderscript도 필요한 모듈/전체 프로젝트에 활성화할 수 있다.
- Renderscript는 Android 12부터 더 이상 사용되지 않는다.

### 비전이적 R classes가 기본적으로 활성화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/015.png" }}" />

R 클래스는 리소스 이름을 Application 코드의 ID에 매핑하는 생성된 클래스이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/016.png" }}" />

- AGP 7.1 및 Android Studio Bumblebee이전까지의 AGP는 라이브러리 R 클래스뿐만 아니라 모든 종속성에 대한 키를 생성했다.
- 그로 인해 더 큰 실행 파일 크기와 더 긴 빌드 시간을 초래했다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/017.png" }}" />

- 비전이적 R 클래스는 해당 모듈에 선언된 리소스만 포함하므로 R 클래스의 크기가 줄어든다
- 비전이적 R 클래스는 gradle.properties에 설정한 `nonTransitiveRClass` 플래그에 의해 제어된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/018.png" }}" />

- `nonTransitiveRClass`는 AGP 7.1이 설치된 Android Studio Bumblebee에 도입되었다.
- 기본적으로 신규 프로젝트에는 true이다.
- AGP 8부터는 미지정할 경우 true로 설정된다.

### R8의 Full mode가 기본적으로 적용

- R8은 이제 기본적으로 Full-mode이므로 더 많은 최적화가 가능하다.
- 새로운 최적화가 활성화된 상태에서 프로젝트가 올바르게 빌드되는지 다시 확인해야 할 수도 있다.

## Build Analyzer

### Download

다운로드는 빌드 성능에서 무시되는 영역 중 하나이다.

Build Analyzer에서 다운로드 정보를 시각화하는 도구를 추가했다.

Gradle은 선언된 순서대로 Plugin/Dependency Repository를 검색한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/019.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/020.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/021.png" }}" />

**androidx.compose.ui** 라이브러리의 경우,

1. maven repo : Not found
2. mavenCentral : Not found
3. google : `Found`

빌드는 Repository 블록에 나열된 Repository를 수정함으로써 네트워크 호출에 시간을 절약할 수 있다. 해결법으로 가장 먼저 정의한 Repository는 대부분의 종속성과 플러그인이 포함되어야 한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/022.png" }}" />

- 실패한 네트워크 시도 숫자를 확인하고 Repository 순서를 실험해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/023.png" }}" />

- 동적 버전은 종속성 선언에 + 혹은 * 를 사용하는 종속성 버전이다.
- 이 경우 Gradle이 네트워크를 호출하여 빌드 간에 최신 종속성 버전을 가져온다.
- 동적 버전을 사용하는 경우 증분 빌드가 실행한 직후에 다운로드가 표시된다.

## Transform removal

Transform API를 제거했으며, 약간의 영향을 미칠 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/024.png" }}" />

- Transform API는 오랫동안 사용되지 않았으며, AGP 8.0에서 제거했다.
- 제거된 이유
  - 사용하기 쉬운 API가 아니다
  - 병목 현상을 일으키는 경향이 있다
- 성능이 좋지 않고 사용하기 어려웠다
- Upgrade Assistant로 Transform API를 제거하는 데 도움은 안된다
- Transform API를 **Instrumentation/Artifacts API**로 교체했다.

### Instrumentation API

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/025.png" }}" />

- Instrumentation은 클래스 파일과 같은 바이트 코드 향상이 필요한 경우이다.
- 클래스 파일이 컴파일된 후, Dexing 되기 전에 바이트 코드를 살펴보고 일부 내용을 추가하고 싶을 수 있다.
  - 이전 Transform API의 일반적인 사용 패턴이다.
- Artifacts API를 사용하여 이 작업을 수행할 수도 있다.
  - 클래스 파일을 로드하고, 바이트 코드 계측을 수행, 클래스 파일을 작성하는 단계를 거쳐야 한다.
  - Transformer들 중 몇 개가 연결되어 있다면, 비효율적이다. 각각 로드, 변환, 쓰기를 수행한다.
- 해결법으로는 로딩과 쓰기를 처리하는 API이고, 등록된 모든 항목과 함께 다른 방문자와 함께 변경할 수 있는 ASM 방문자를 재작성한다. 즉, 한 번만 로드된다. 바이트 코드를 변환할 방문자 체인이 있고 결국 한 번 작성된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/026.png" }}" />

- ASM은 기본적으로 메서드/필드/외부 클래스를 방문하고, 부모 인터페이스와 모든 것을 방문할 수 있는 작은 방문자 스타일 인터페이스이다.
- 바이트 코드 조작이고, 소스 파일만큼 편리하지 않다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/027.png" }}" />

- ASM Factory 메소드를 사용하고 Variant API를 사용할 수 있다
- 사용 방법이 다양하며 이전에 이야기한 다른 API인 Artifacts API를 사용할 수도 있다
  - 언어 이외에 다른 것을 입력으로 사용하는 클래스가 있고 최종 결과물/APK에 추가해야 하는 클래스를 생성하는 경우에 유용하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/028.png" }}" />

- Artifacts API로 비교적 쉽게 사용할 수 있다
- 기본적으로 새로운 것을 생성하거나, 특별한 경우에 기존 것을 수정하는 작업을 작성하는 것이다.
  - 추가/제거 필요한 모든 작업을 할 수 있다.
- 이 작업을 실행하면 빌드 시스템의 파이프라인 전체에서 새 클래스 집합을 사용할 수 있고 Dexing 부분에 사용된다.
  - Compiler와 Dexing 사이에 끼어들고 싶다면 이것을 사용하면 된다.
- 입력으로 디렉터리/Jar 파일이 있으며, Jar 파일이 될 단일 출력 파일을 생성하는 것이 위 코드에서 할 일이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/029.png" }}" />

- 여기에서 Artifacts API를 사용할 수 있다. `artifacts`는 Artifacts API에 액세스하는 방법이다.
- 프로젝트 범위의 모든 클래스에 접근하고, 해당 클래스들을 변경하는데 Task를 사용할 수 있다.
  - 입력 필드 : 모든 Jar 파일, 모든 디렉터리
  - 출력 : 새롭게 생성될 위치
- 컴파일러가 완료될 때마다 이 Task가 호출된다.

> https://goo.gle/gradle-recipes

- gradle-recipes GitHub 프로젝트에서 많은 예제가 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Whats-new-in-Android-Build/030.png" }}" />

- 만약 Transform API를 사용한다면 변경해야 한다. AGP 8.0에서 Transform API 지원을 완전히 제거할 것이다.
- 대부분의 앱 개발자는 해당 API를 직접 사용하는 경우는 없다. 대신 해당 API를 사용하는 플러그인을 사용할 수도 있다.
  - 2년 전에 Hilt Gradle 플러그인은 Transform API를 사용하고 있었다.

### Learn more

- [goo.gle/gradle-recipes](goo.gle/gradle-recipes)
- [goo.gle/agp8-transform-removal](goo.gle/agp8-transform-removal)
- [goo.gle/agp-release-notes](goo.gle/agp-release-notes)
