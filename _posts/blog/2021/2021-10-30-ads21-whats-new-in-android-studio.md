---
layout: post
title: "[요약] What’s new in Android Studio (Android Dev Summit '21)"
date: 2021-10-30 17:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/PwE5NqeeFk0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

### Android Studio Arctic Fox

- Android Studio Arctic Fox는 현재 Stable 릴리스 채널에 있다
- Design
  - Jetpack Compose에 대한 도구 지원 (Layout Inspector)
- Device
  - WearOS의 심박수 센서 및 Google TV를 지원하는 Android TV 에뮬레이터 등 다양한 기능이 포함되어 있다
- Dev Productivity
  - WorkManager 도구를 통해 개발자 생산성을 개선하기 위한 작업이 들어있다.

### Android Studio Bumblebee

- Beta 릴리스 채널에서 다운로드할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/001.png" }}" />

- Material You에 대한 초기 지원 및 Jetpack Compose 도구의 개선이 포함되어 있다
- Android 12L을 사용하여 큰 화면에 맞게 앱을 만들 수 있다.

### Android Studio Chipmunk

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/002.jpeg" }}" />

- Android Studio 다음 릴리스의 코드명은 `Chipmunk` 이다.

#### Upgrade Assistant

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/003.png" }}" />

- AGP 업그레이드 도우미를 통해서 프로젝트 업그레이드를 사용할 수 있다.

#### Build Analyzer

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/004.png" }}" />

- 프로젝트 빌드 후 Build Analyzer에서 Build Configuration 시간을 최적화할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/005.png" }}" />

- Configuration Cache가 설정된 상태로 빌드를 실행할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/006.png" }}" />

- 빌드가 Configuration Cache와 호환되는지 확인이 필요하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/007.png" }}" />

**gradle.properties**에 환경 변수를 설정하면 된다.

```properties
org.gradle.unsafe.configuration-cache=true
```

#### Non-Transitive R Classes

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/008.png" }}" />

non-transitive R classes 지원

- Menu -Refactor - **Migrate to Non-Transitive R Classes**를 통해서 실행 가능
- 리소스를 참조하는 소스 파일을 찾은 다음 프로젝트 로컬로 수정한다.
- 최종적으로 Resource merging을 건너뛰게 함으로 성능에 도움이 된다
- 특히, 많은 모듈과 리소스가 포함된 프로젝트에 유용하다

#### Lint

- Bumblebee Canary 13 이상에서는 증분 Lint 작업, 캐싱, Remote 캐싱을 지원한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/009.png" }}" />

#### Profilers

- 원활하게 프레임 출력을 하지 못하는 버벅거리는 현상을 추적하는데 유용하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/010.png" }}" />

- Android 11 및 12에서 프레임의 수명 주기를 캡처할 수 있다
- **Frames view**에서 Frame이 신청서에 소요된 시간을 볼 수 있다
- 샘플에서는 이전 프레임이 오랫동안 디스플레이에 표시된 것이 버벅거리는 이유이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/011.png" }}" />

- RenderThread 및 애플리케이션에서 어떤 작업을 수행하는지 확인할 수 있다
  - 샘플에서는 동시에 많은 Texture를 로드하려고 한 것이 버벅임의 원인이다

#### Graphical editors

- 이제 Android Studio에서 임베디드 된 상태로 Emulator를 실행할 수 있다
- Bumblebee에서 Emulator의 Snapshot 사용은 기본값이다
- 새로운 Device Manager는 기존 팝업으로 노출하던 AVD Manager 대신합니다.
  - 에뮬레이터와 Wi-Fi 페어링으로 연결된 물리적 장치 화면을 볼 수 있다

|                           Emulator                           |                          실제 단말                           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/013.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/014.png" }}" /> |

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/012.gif" }}" />

- 디바이스를 회전할 때 자연스럽게 UI를 노출하는 방법으로 MotionLayout을 선택할 수 있다
  - 디자인 화면에서도 쉽게 테스트할 수 있다

#### Visual Linting

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/015.png" }}" />

- Phone/Forldable/Tablet 등, 일부 모드에서 애니메이션이 깨져있는 경우 미리 개발자에게 알려준다

|                            샘플1                             |                            샘플2                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/016.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/017.png" }}" /> |

- Layout Validation에서도 레이아웃 간의 불일치를 표시해 준다. 
- 이런 체크들은 백그라운드에서 체크하며 점점 확장할 계획이다

#### Compose

- Arctic Fox부터 Compose에 대해서 완전히 지원한다
- Bumblebee에 몇 가지 기능이 추가되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/018.png" }}" />

- Interactive Preview
  - Preview에서 **Start Interactive Mode** 클릭으로 실행할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/019.gif" }}" />

- 중요한 것은 `터치 입력으로 움직임 테스트`를 할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/020.gif" }}" />

- Animation Inspection
  - 원하는 경우 애니메이션의 위치를 선택하거나 루프로 재생할 수 있다
  - 애니메이션의 조합을 살펴보는데 유용하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/021.png" }}" />

`@Preview` Annotation 옆에 있는 아이콘으로 Preview의 구성을 쉽게 변경할 수 있다

Compose 개발 시 빌드 속도가 큰 걸림돌이므로 이를 돕는 기능을 소개한다

- Live Edit of literals
  - **숫자, 문자열, Color, Dp, Boolean** 타입의 값에 대한 실시간 편집을 지원한다
  - 에뮬레이터뿐만 아니라 실제 단말에서도 동작한다

<img src="https://developer.android.com/images/jetpack/compose/tooling-live-literals-demo.gif" />

> 출처 : https://developer.android.com/jetpack/compose/tooling#live-edit-literals

#### Live Editing (개발 중)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/022.gif" }}" />

- Live Edit of literals보다 더 일반적인 시나리오를 편집하는데 유용하다
- 이 기능은 Preview뿐만 아니라 실제 디바이스로 개발 시에도 사용됩니다.

#### Light Mode (개발 중)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/023.png" }}" />

- 실시간 편집과는 정반대의 기능이다
- 실시간 편집 및 Visual Linting은 많은 계산을 통해서 일어나는 동작이다.
- Light Mode를 사용하면 IDE를 사용하는 동안 리소스를 더 적게 사용할 수 있다.
  - 유효성 검사를 수행하지 않는다
  - Go to 선언과 같은 기본 편집 기능은 사용 가능
- File - **Light Mode**를 통해서 활성화할 수 있다.
- 단순 입력 시에는 유효성 검사를 하지 않으므로, 입력 중에 잘못 작성된 코드는 검사하지 않는다. 파일 저장 시 기본 유효성 검사를 수행한다.

#### Etc

- IntelliJ 2021.2의 일부 새로운 기능
- Android 12L 등을 위한 크기 조정 가능한 에뮬레이터

## Recap

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Whats-new-in-Android-Studio/024.png" }}" />
