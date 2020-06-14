---
layout: post
title: "[요약] What's New in Android Development Tools (Google I/O '19)"
date: 2019-05-25 22:10:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/8rfvfojtRss" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/001.png" }}" /> 

## Roadmap

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/002.png" }}" /> 

### Android Studio 3.2

작년 Android Stuido 3.2를 출시했으며, App Bundle, Navigation Editor, Emulator Snapshots, Energy Profiler를 추가했다.

### Android Studio 3.3

올해 초 3.3을 출시했다. 제품 피드백과 IDE의 동기화 속도 향상이 포함되어 있다

### Android Studio 3.4

Android Studio 3.4에서는 새로운 Resource Manager, Project Struct Dialog, R8 이 도입되었다.

# Android Studio 3.5

## Project Marble

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/004.png" }}" /> 

올해는 새로운 기능 대신, 다른 것을 소개한다. 작년 11월에 `Project Marble` 을 발표했고, 주요 문제를 해결하는데 주력했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/005.png" }}" /> 

크게 3가지로 `System Health`, `Feature Polish` 및 `Bug Backlog` 해결이다.

## System Health

그래서 시스템 건강부터 시작합시다.

이것은 UI가 얼마나 반응이 좋고 메모리 누수가 있는지를 의미한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/006.png" }}" /> 

Android Studio를 처음 실행하면 통계를 Google에 보내려고 하는지 묻는다. 이것을 통해 시스템 상태를 측정할 수 있다.

### Exceptions Dashboard

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/007.png" }}" /> 

예를 들어 Andra studio가 예외가 발생 시 Analytics를 선택했으면 해당 정보를 Google 서버로 전송한다.

그런 다음 Exceptions 대시 보드를 통해 모든 예외를 볼 수 있다. 가장 중요한 문제는 해결될 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/008.png" }}" /> 

Android Studio 사용 중 오른쪽 하단과 같이 빨간색 느낌표와 만날 수 있다. 이 아이콘은 Android Studio에서 충돌이 일어난 경우에 대한 표시이다. 어떤 에러인지와 피드백을 Android Studio 팀으로 버그를 전달하는 빠른 방법이다.

단, Foreground 액션에 대해서는 알림 표시를 하지 않는다. 예외보다는 지금 진행 중인 동작에 더 초점을 주기 위해서이다.

### UI Freezed Dashboard

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/009.png" }}" /> 

UI 스레드가 작업으로 몇 초 동안 응답하지 않은 경우에 UI가 멈추는 것을 경험할 수 있다. 

이 경우 전체 스레드 덤프를 가져와서 서버에 업로드하여 UI Freezed 대시보드에 표시할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/010.png" }}" /> 

예제로 가장 크게 UI가 멈춘 것이 평균 14초이고 50,000 건이 넘는 리포트를 보고되었다는 것을 알 수 있다. 이것으로 오류의 우선순위를 지정할 수 있다.

| Android Studio 3.4 | Android Studio 3.5 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://1.bp.blogspot.com/-qvkT4GJRj5U/XNL9RfPyvkI/AAAAAAAAI40/N3qdVfZyWI8UDTq1mQ8IucBMP-cwHAjowCLcBGAs/s1600/image16.gif" /> | <img src="https://1.bp.blogspot.com/-zp7L4e1kjsQ/XNL9mo4jnBI/AAAAAAAAI48/JL8n3cThgQ0dmfQLgULb4hitkHg1A7p0ACLcBGAs/s1600/image5.gif" /> |

또 다른 예로, 데이터 바인딩 사용 시 XML 편집 작업을 한다. 기존 버전에서는 작업 시 매우 느리고 UI가 정지하는 현상이 겪는다.

### Regression Infrastructure

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/011.png" }}" /> 

UI가 멈추는 원인을 분석할 수 있도록 Android Lint를 수정했다. UI 스레드가 네트워크 호출에 접근할 때마다 UI가 멈추는 것을 얻을 수 있다. 이것은 Android의 StrictMode와 비슷하다.

### OutOfMemoryException Dashboard

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/012.png" }}" /> 

Android Studio에서 메모리가 부족할 때 통계를 수집해 서버로 수집해 관련 오류를 추적한다.

근본적으로 Android Studio가 메모리가 부족한 이유는 두 가지이다. 

첫 번째는, 대규모 프로젝트가 있으면 리소스/코드를 모델링에 많은 자원이 필요하므로 적합하지 않을 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/013.png" }}" /> 

32GB RAM을 가지는 머신에서는 JVM에서 실행 시의 힙 크기는 1.2GB로 제한되어있다. 괜찮은 팁으로는 힙 크기를 늘려 더 많은 메모리를 스튜디오에게 제공하는 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/014.png" }}" /> 

Android Studio 3.5에서는 가용 램 및 프로젝트의 규모를 확인하여 권장 사양을 제시한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/015.png" }}" /> 

혹은 Preferences > Appearance & Behavior > System Settings > Memory Settings 에서 원하는 IDE 힙 사이즈, Gradle 데몬 힙 사이즈 설정을 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/016.png" }}" /> 

통계에서 얻은 데이터를 통해 힙 사이즈, 파일 수, 모듈 수 등을 이용해 적절한 설정인지 등을 확인한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/017.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/018.png" }}" /> 

힙 사이즈를 수정하더라도 메모리 누수에 의한 메모리 부족은 발생할 수 있다. 그 경우, 전체 힙을 서버로 보내지 않고, 힙 덤프를 클라이언트 측에서 해당 파일에 대한 분석을 실행한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/019.png" }}" /> 

분석 결과에는 메모리 누수에 대한 정보가 단순히 텍스트로만 존재하며, Google 서버로 업드로해서 피드백의 해결을 돕는다. Android Studio 3.5에서 이 기능은 매우 유용했으며, 첫 번째로 타사 플러그인에서 많은 메모리 누수가 있는 것을 확인했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/021.png" }}" /> 

특정 테스트를 반복적으로 실행할 수 있는 새로운 테스트 러너를 구현했다. 각 실행 사이에 힙 스냅 샷을 얻은 다음 몇 가지 비교를 수행하고 자동으로 누수를 찾을 수 있다.

### Speed

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/022.png" }}" /> 

잘 알려진 방법의 하나는 사용하지 않는 플러그인을 비활성화한다.

### Build Speed

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/023.png" }}" /> 

Android Studio에서 가장 큰 속도 불만은 빌드 시스템이다. 과거 이클립스 시대부터 지금까지 최우선 과제이다. Kotlin Incremental Annotation Processing 을 도입했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/024.png" }}" /> 

> 자세한 것은 다음 세션에서 확인 : [What's New in the Android Studio Build System](https://www.youtube.com/watch?v=LFRCzsD7UhY)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/025.png" }}" /> 

Android Studio의 대부분의 사용자는 Windows 유저입니다. 

대부분의 사용자는 실제로 Windows에 있습니다. 최근 긴 경로 문제를 수정했지만, 지금까지 가장 큰 영향은 바이러스 검사 프로그램이다. 바이러스 검사 프로그램으로 폴더를 검사할 때 여러 배 느려진다. 내부 테스트 결과 Android Studio 및 SDK 폴더와 프로젝트 폴더를 제외하면 약 4배 정도 빨라진다. 기본적으로 Linux 성능과 비슷하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/026.png" }}" /> 

바이러스 검사 프로그램을 사용 중이라면 성능과 보안 사이의 균형을 결정해야 한다. 검사 폴더를 제외하려면 별도의 예방 조치가 필요하며 관련 내용은 안내가 된다.

### Emulator CPU Usage

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/027.png" }}" /> 

기존 에뮬레이터는 Idle 상태일 때도 CPU 를 소비하고 있어 큰 불만이었다.

첫 번째, Google Play Service가 시작되면 업데이트 및 최적화하는데 CPU를 소모했다. Google Play Service는 기본적으로 배터리 방전이 아닌 충전 중으로 설정되어있어 많은 CPU를 사용하게 되었다. 기본값을 배터리 방전으로 바꿔 백그라운드 CPU 사용을 3배 이상 감소시켰다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/028.png" }}" /> 

두 번째, Google Assistant는 실제로 말을 들으려고 한다. 에뮬레이터에서는 하드웨어 지원이 없는데 CPU는 이 작업을 위해 작업을 수행했다. 그래서 기본적으로 마이크는 꺼져있는 형태로 수정했다.

## Feature Polish

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/029.png" }}" /> 

두 번째 영역은 잘 작동하지 않는 기능을 수정하는 것이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/030.png" }}" /> 

먼저 새로운 Instant Run이며 `Apply Changes`라고 부른다. 기존 Instant Run과 비슷해 보인다. 

Complete Rewrite

- 빠른 Incremental Run과 리소스 hot-swap해서 실행할 수 있다.
- Instant Run에서 50,000줄을 삭제하며 완전 재작성 되었다.

Platform APIs

- Android Oreo이상에서 작동하도록 제한했다. dalvik 및 이전 버전에서 Instant Run 을 위한 기능을 제거하고, 플랫폼 API만을 사용하여 빠르게 앱을 실행한다.
- Instant Run은 hot-swap을 위해서 바이트 코드에 추가 작업이 진행되어 더 느리게 만들어지고, 64K 의 메소드 이상을 가지는 경우 Instant Run을 활성화하면 빌드할 수 없다
- Apply Changes는 APK 수정 없이 플랫폼 API로 hot-swap을 사용한다 

### Gradle Sync

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/031.png" }}" /> 

`Single Variant Sync` 라고 불리는 것을 통해 더 빠르게 만들었다.

그 중, `Gradle` 을 사용하면 모든 `jar 파일` 을 캐시하는데 점점 이 크기는 늘어간다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/032.png" }}" /> 

작년, Gradle은 7~30일간 미사용 시 캐시를 정리하는 기능을 발표했다. 그리고. Android Studio 성능상의 이유로 IDE가 재시작할 때 실제 Gradle 빌드를 수행하지 않는다. 이전에 캐시 된 동기화 스테이지를 로드하며 Gradle 폴더에 있는 라이브러리를 가리키는 캐시 된 상태를 불러온다.

### Offline

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/033.png" }}" /> 

네트워크 연결이 안되거나 프록시 등 디펜던시를 가져오기 어려운 환경에서 프로젝트 빌드가 가능하도록 했다. 3.5 베타에서의 모든 종속성을 가진 Android Gradle Plugin과 Google Maven dependencies을 다운로드할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/034.png" }}" /> 

`Android Home` 폴더에 압축을 풀고, `.gradle/init.d` 아래에 `offline.gradle` 에 해당 스크립트를 넣은 후 실행하면 된다.

> 위 이미지의 스크립트를 참고하지 말고, 공식 사이트의 스크립트를 참고하세요

이것은 빌드 서버가 인터넷을 통해 종속성 관련 정보를 다운로드 하고 싶지 않은 경우에 유용하다

### Project Upgrades

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/035.png" }}" /> 

Android Studio 3.3에서 의존성 관련 경고를 확인할 수 있다. 의존성 문제를 고친다면 이 메시지는 사라진다.

### Data Binding

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/036.png" }}" /> 

데이터 바인딩은 따옴표를 사용해서 작성한다. 이미 성능 문제에 대한 애니메이션을 봤을 것이다. 그 버그는 해결했고, 새로운 Lint 검사와 코드 폴딩을 3.5에 추가해서 작업하기 쉽게 했다 

## Bug Backlog

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/037.png" }}" /> 

몇 주전 통계로 Android Studio에 400개가 넘는 버그를 고쳤다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/038.png" }}" /> 

오류 분석과 UI 작업 시 빌드가 왜 실패했는지 정확히 알려준다. 

Android Studio 3.5는 3.4보다 300MB 작다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/039.png" }}" /> 

버그 수정을 위해 여러 가지 인프라를 구축했고, Android Studio의 상태를 모니터링할 수있는 대시 보드를 만들었다. 습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/040.png" }}" /> 

최근 업그레이드 프로세스에 대한 설문조사에 의하면 많은 사람이 Android Studio와 Gradle을 동시에 업데이트한다는 것을 알았다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/041.png" }}" /> 

몇 년 전에 Instant Run과 같은 기능은 동시에 업그레이드해야 했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/042.png" }}" /> 

이제는 Android Studio와 Gradle Plugin은 별도로 업그레이드할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/043.png" }}" /> 

하지만, Gradle은 업그레이드하는데 시간이 걸리므로 최신 IDE를 사용하길 권장한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/044.png" }}" /> 

동일한 Gradle을 사용하지만, Stable, Beta, Canary 버전의 Android Studio를 사용할 수 있다.

# Demo

### Foldable Support

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/045.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/046.png" }}" /> 

수많은 자바, 코틀린, 리소스 파일로는 실제로 어떻게 동작하는지 이해가 어렵다. 검증 방법의 하나는 앱을 실행하는 것이다. `Fold 아이콘`을 사용해서 새로운 Context로 전환할 수 있다. 

### Dark Theme

| :-- | :-- |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/047.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/048.png" }}" /> |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/049.png" }}" /> |  |

Android Q는 Dark Theme를 OS 차원에서 지원한다. 그리고, 앱에서도 제어할 수 있다. 

> 예제로 Google I/O에서는 Dark Theme의 붉은색 Accent Color를 변경하는 예제를 확인할 수 있다.

### New Layout Inspector

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/050.png" }}" /> 

Layout Inspector는 앱의 계증 구조를 볼 수 있는 방법이다. 그리고, Elevation 문제가 있을 때 다양하게 계층 구조를 체크해 볼 수 있다.

> 실제 영상은 아래를 참고해주세요
>
> <iframe width="560" height="315" src="https://www.youtube.com/embed/8rfvfojtRss?start=1651" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/051.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/052.png" }}" /> 

Layout Inspector의 우측 `Properties` 창에서 `Command + B` 를 입력하면 해당 속성을 정의한 소스 코드로 이동한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/053.png" }}" /> 

2가지 이상의 스타일 처리가 되어있다면, 위와 같이 스타일을 선택할 수 있는 팝업을 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/054.png" }}" /> 

Layout Inspector의 유효성 검사를 위해 레이아웃을 검사를 새로 고치는 방법이다.

### Resource

기존 리소스가 어떤 것인지 확인하는 방법은 모두 두 번 클릭하는 것이다. Android Studio 3.4에서 추가된 `New Resource Manager` 를 사용할 수 있다.

| :-- | :-- |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/055.png" }}" /> |  |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/056.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/057.png" }}" /> |

모듈에 따라 List와 Grid 형태로 리소스를 시각화하여 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/058.png" }}" /> 

그리고 dpi에 따른 이미지도 볼 수 있다 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/059.png" }}" /> 

디자인 팀이 리소스를 업데이트할 때 대량의 SVG 파일을 업데이트할 수 있다. 기존에는 개별적으로 SVG를 VectorDrawable로 변환해야했지만, `Import Drawable` 을 통해 폴더에 있는 전체 SVG를 가져올 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/060.png" }}" /> 

그리고, Resource의 구문을 검사 가능하다. `Do not import`, `대문자 체크` 를 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/061.png" }}" /> 

Resource Manager로부터 XML로 Drag&Drop 할 경우 ImageView 가 추가되며, XML View에서도 수정하려는 속성으로 Drag&Drop할 경우 해당 Property가 업데이트된다.

> 자세한 것은 [Manage your app's UI resources with Resource Manager](https://developer.android.com/studio/write/resource-manager) 에서 확인 할 수 있다.

### Project Structure Dialog 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/062.png" }}" /> 

`Dependencies` 패널을 통해서 모든 의존성과 모듈의 목록을 볼 수 있다. 그리고, 충돌 여부도 확인할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/063.png" }}" /> 

`Suggestions` 패널을 통해 `Update Variable` 을 이용해 Gradle 파일 업데이트를 할 수 있다.

### MotionLayout

MotionLayout은 Beta가 되었다. MotionLayout은 ConstraintLayout 기반으로 만들어졌다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/065.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/064.png" }}" /> 

- MotionLayout : 레이아웃에 모든 컴포넌트가 어떻게 배치되어 있는지 정의
- MotionScene : 각 컴포넌트가 어떻게 움직일지 정의

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/066.png" }}" /> 

새로운 타임라인 View를 통해서 시작과 종료 상태 사이를 시간 경과에 따라 어떻게 작동하는지 확인할 수 있다. 

### Jetpack Compose

Kotlin을 이용해 Reactive Programming을 결합한 것이다. 별도 XML과 Kotlin파일 대신 하나의 파일에 담았다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/067.png" }}" /> 

에뮬레이터로 실행이 가능하며, 별도로 제공되는 Android Studio를 이용해서 확인할 수 있다.

### Chrome OS

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/068.png" }}" /> 

Chrome OS Version 75에서 Android Studio 3.5를 지원한다.

### Android Automotive

| :-- | :-- |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/069.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/070.png" }}" /> |

임베디드 Android Automotive를 지원하는 새로운 에뮬레이터이다.

> 자세한 것은 다음 세션에서 확인 : [Best Practices in Using the Android Emulator](https://www.youtube.com/watch?v=Up3hyBSDAMA)

## Summary

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats_new_in_android_development_tools/071.png" }}" /> 

Android Studio 3.5는 Project Marble의 모든 작업이 들어갔습니다. 