---
layout: post
title: "[요약] What's new in Android testing tools (Google I/O '21)"
date: 2021-05-20 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/juEkViDyzF8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/001.png" }}" /> 

- 간혹 로컬 Android Studio와 CI 서버의 테스트 결과가 다른 경우가 발생한다
- 원인은 Android Studio와 Android Gradle Plugin에서 Android Instrument Test Runner 버전이 다르기 때문이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/002.png" }}" /> 

- 해결 방법으로는 Android Studio 상의 모든 테스트를 Android Gradle Plugin에서 실행하도록 위임하는 것이다.
- Android Studio Arctic Fox에서는 이미 Unit Test를 Gradle을 통해 실행하도록 이전하고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/003.png" }}" /> 

- Gutter Action으로 Unit Test를 실행하면 Android Studio에서 자동으로 Gradle Configuration을 생성하고 Gradle을 통해 Unit Test를 실행한다
- 최신 Android Studio Canary 버전에서는 Android Gradle Test Runner를 통해서 모든 Instrument Test를 실행한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/018.png" }}" /> 

- Android Studio의 설정에서 Gradle Test Runner 사용 옵션을 활성화
  - Preferences \| Build, Execution, Deployment \| Testing

### Unified Test Platform

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/004.png" }}" /> 

- Android Studio와 Android Gradle Plugin에서 Android Test를 실행하는 Test Runner

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/005.png" }}" /> 

- 모듈 방식으로 Android Test를 개선 및 기능을 추가 가능
- 사용 중인 Build Tool Chain 및 OS와는 독립적

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/006.png" }}" /> 

- UTP의 활용 사례로 `Gradle Managed Devices`로 Gradle DSL을 사용해서 Device를 정의 가능
- 시스템 이미지 다운로드, 기기 생성, 테스트 시작부터 종료까지의 모든 과정이 포함
- 가상 기기의 상태 저장으로 테스트 결과를 캐싱 및 Emulator 스냅샷을 활용해 테스트를 실행마다 빠르게 복원할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/007.png" }}" /> 

- app 모듈에 있는 build.gradle 내에서 Device 정보를 정의할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/008.png" }}" /> 

```bash
$ gradlew
-Pandroid.experimental.androidTest.useUnifiedTestPlatform=true
pixel12api29DebugAndroidTest
```

- Gradle Manage Virtual Device로 테스트를 실행하려면 `기기 이름`과 `빌드 종류`를 붙여서 Android Test Task를 실행하면 된다
- UTP 기능이 필요하므로 속성을 전달해서 활성화한다
- Android Gradle Plugin은 다음 처리를 진행
  - 필요한 시스템 이미지를 다운로드
  - 기기에서 테스트를 실행한 다음 결과를 반환

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/009.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/010.png" }}" /> 

- 기기 그룹에서 테스트를 지정하고 동시에 실행할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/011.png" }}" /> 

- Android Studio 내에서도 병렬로 Device 테스트를 사용할 수 있다
- 메뉴의 Select Multiple Devices을 선택한 후 테스트할 디바이스를 선택하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/012.png" }}" /> 

- 새롭게 디자인한 테스트 결과 보고서는 병렬로 기기 테스트를 목적으로 설계되었다
- API 버전 및 특정 기기로 필터도 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/013.png" }}" /> 

- 특정 기기의 테스트 결과를 선택함으로 우측 정보 패널을 통해서 확인할 수 있다

### Emulator Snapshots

- 특정 시점의 가상 기기의 상태를 캡처하므로 이후에 그 상태로 빠르게 복원할 수 있다
- Android Emulator에서 테스트를 실행할 때 테스트 실패 시 자동으로 스냅샷을 캡처하고 테스트 결과에 포함하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/014.png" }}" /> 

- 실패한 스냅샷 정보 및 테스트 기기에서 상태를 복원할 수 있다. 그 후 디버거를 사용해서 실패를 분석할 수 있다
- Emulator Snapshots은 확실하지 않거나 재현이 어렵거나 실행에 오랜 시간이 걸리는 테스트 실패를 디버깅하는데 유용하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/015.png" }}" /> 

- 테스트 실패에 Emulator Snapshots을 사용하려면 app 모듈을 build.gradle에 속성을 추가함으로 활성화된다
- Android Studio는 기본적으로 테스트 실행 1회에 기기당 2개의 Snapshots만 생성한다. 최대 Snapshot 갯수를 변경도 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/016.png" }}" /> 

- Command를 통해서도 기능을 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-testing-tools/017.png" }}" /> 

- Android Studio 외부에서 테스트를 실행할 때는 Run - Import Tests from File을 통해서 결과를 가져온 후 앱의 build/output 폴더에서 test-results.pb 파일을 가져오면 된다.