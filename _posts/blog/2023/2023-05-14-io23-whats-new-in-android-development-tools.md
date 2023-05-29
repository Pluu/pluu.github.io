---
layout: post
title: "[요약] What's new in Android development tools (Google I/O '23)"
date: 2023-05-14 15:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io23
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/7lubRrkxagk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

## Roadmap

### Android Studio Flamingo

#### Network Inspector Traffic Interception

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/001.png" }}" />

> https://developer.android.com/studio/releases#network-inspector

- Network Inspector에 트래픽 인터셉트 기능이 추가되었습니다.
- 네트워크 타임라인에서 시간 범위를 선택하고 규칙을 생성하여 네트워크 헤더, 상태 코드 등을 추가할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/002.png" }}" />

- 디자인 도구에 앱 아이콘에 테마를 변경할 수 있는 미리 보기를 추가입니다.
- Dynamic backgrounds, Android 13 이상에서의 테마가 적용된 앱 아이콘 변경을 할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/003.png" }}" />

> https://developer.android.com/studio/releases#lint-sdk-extensions

- SDK Extensions을 사용하여 공개 SDK에 API를 추가할 수 있습니다.
- Privacy Sandbox 및 Photo Picker와 같이 원래 SDK에서 미지원된 기능을 제공할 수 있습니다.
- SDK Extensions Lint도 추가되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/004.png" }}" />

## Demo

### SDK 마이그레이션 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/005.png" }}" />

> https://developer.android.com/studio/preview/features#android-sdk-upgrade-assistant

최신 SDK를 targetSdkVersion으로 지정하지 않은 경우, 대응해야 할 과정을 만드는 Quick fix가 있습니다. 앱 업데이트하는 방법에 대한 지침을 확인할 수 있습니다. Web에 각 단계의 내용이 문서화되어 있지만, IDE에 통합되어 있습니다.

### Compose

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/006.png" }}" />

- Android Studio에서 New Project시 기본값으로 설정됩니다.
- 기본 Build Script 언어를 Groovy 대신 Kotlin DSL을 선택할 수 있습니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/007.png" }}" />

- Preview를 통해서 폴더블 및 태블릿과 같은 디바이스에서 어떻게 노출되는지 확인할 수 있습니다.

### Embedded Layout Inspector

> https://developer.android.com/studio/preview/features#embedded-layout-inspector

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/008.png" }}" />

- 스마트폰을 컴퓨터와 연결하면 Android Studio에서 새로운 디바이스 스트리밍 창을 통해서 IDE에서 바로 상호작용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/009.png" }}" />

- Toolbar에서 Layout Inspector를 선택해서 현재 화면의 뷰 계층 구조를 확인할 수 있습니다.
- Alt 키를 누러 View를 선택하면 해당 소스로 이동할 수 있습니다.
- 일부는 코드 편집 후 저장 시 실시간으로 업데이트됩니다.

### Studio Bot

> https://developer.android.com/studio/preview/studio-bot

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/010.png" }}" />

- Logcat에서 크래시가 난 부분에서 마우스 우 클릭 시 Studio에 오류의 내용을 설명해 달라고 요청할 수 있는 기능이 추가되었습니다.

> 새로운 IntelliJ UI를 위해서는 설정에서 기능을 활성화하면 됩니다.
>
> https://developer.android.com/studio/preview/features#new-ui-preview

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/011.png" }}" />

- IDE에 AI 기반 채팅 봇인 Studio Bot이 나타납니다.
  - 크래시가 무엇인지에 대한 설명과 해결 방법에 대한 설명을 얻을 수 있습니다.
  - 예제로 `Merge into manifest` 버튼을 클릭하면 기본 Manifest를 찾아 올바른 위치에 XML 코드를 추가합니다.
- Studio Bot에 코드 생성도 요청할 수 있습니다.
  - 클래스 작성 및 몇 가지 사용 정보도 제공해 줍니다.
  - `Explore in playground` 버튼을 통해서 Playground에서 예제를 사용해 볼 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/012.png" }}" />

- Playground를 통해서 예제가 올바르게 작동하고 있음을 알 수 있습니다.
- Studio Bot이 테스트를 작성하도록 요청하면 관련 테스트 코드를 작성해 줍니다.
  - Insert into to new Kotlin file : 해당 파일을 추가. Studio가 테스트 파일이라는 것을 알아차리고 테스트 sourceSet에 추가
- 우측 패널에는 import가 없지만, Studio가 import 코드를 추가합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/013.png" }}" />

- /stop at 6 : 6라인에 breakpoint를 설정
- /debug test : 디버그 실행
- /renames Coordinate to PointTest
  - 이름 짓기를 Studio Bot을 통해서 얻을 수 있습니다.

## Update

### App Quality Insights + Android Vitals

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/014.png" }}" />

- App Quality Insights에 이전에 추가된 Firebase Crashytics와 더불어 `Android Vitals`이 추가되었습니다.
- Google Play Store에 앱을 출시하고 Android Studio에 로그인한 후 App Quality Insights에서 디바이스의 Crash 데이터에 접근할 수 있으므로 IDE에서 직접 앱의 기술적 품질을 개선할 수 있습니다.

### Google Assistant Plugin

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/015.png" }}" />

- Play Store에 제출하지 않고 Google Assistant용 App Action 미리 보기를 생성하고 테스트할 수 있습니다.

### Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/016.png" }}" />

앱이 Foreground/Background에서 실행 중일 때 디바이스의 전력 소비를 하드웨어 레벨까지 시각화할 수 있도록 Power Profiler를 업데이트했습니다.

### Device Explorer

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/017.png" }}" />

- 기존 Device File Explorer 대신 `Device Explorer`로 이름을 변경했습니다.
- `Processes` 탭에서 실행 중인 모든 프로세스를 확인하고 디버거 연결/프로세스 강제 종료를 할 수 있습니다.

### Watch Face Format

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/018.png" }}" />

- 블루투스를 지원하는 Emulator용 Wear OS 출시
- 커스텀으로 만든 시계 모드를 실행할 수 있습니다.
  - XML 포맷을 사용하여 모양/리소스를 정의하면 Wear OS가 렌더링을 처리합니다.

> Watch Face Studio
>
> https://developer.samsung.com/watch-face-studio/overview.html

### Gradle Managed Devices on Firebase

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/019.png" }}" />

> Use Firebase Test Lab devices with Gradle Managed Devices
>
> https://developer.android.com/studio/preview/features/#ftl-gmd

- Gradle Managed Device 지원을 Firebase와 통합하고 있습니다.
- 로컬 디바이스에만 의존하는 대신 Fireabse Tesetlab에 자동화된 테스트를 디바이스 셋트와 함께 배포할 수 있습니다.

### Gradle Configuration Caching

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/020.png" }}" />

- Gradle 빌드 시스템이 프로젝트의 Build Task Graph 대한 정보를 기록한 다음 빌드에서 재사용할 수 있습니다.
- Build Analyzer에서 해당 기능을 켜야 합니다.
- Build Analyzer는 각 빌드 변경사항을 통해 절약할 수 있는 빌드 시간도 추정해 줍니다.

### Baseline Profile

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/021.png" }}" />

- 최신 Android Gradle Plugin과 Android Studio에서 Baseline Profile을 사용하면 앱 시작 시간이 60% 이상 개선될 수 있습니다.
- Android Studio에 Baseline Module Template와 Configuration이 추가되었습니다. Gradle에서 복수의 Baseline Profile을 생성할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io23/whats_new_in_android_development_tools/022.png" }}" />
