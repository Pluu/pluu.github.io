---
layout: post
title: "[요약] What's new in Android development tools (Google I/O '24)"
date: 2024-05-26 22:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io23
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/2wOfYgIMf-A" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

# Roadmap

Android Studio Hedgehog

- 앱 품질 통계 (Android Vitals, Power Profiler)
- SDK upgrade assistant
- New UI

Android Studio Iguana

- App Quality Insights 내의 [Version Control](https://developer.android.com/studio/debug/app-quality-insights)  
- Jetpack Compsoe용 UI Check
- Baseline Profile
- Gradle Version Catalog 지원

Android Studio의 Studio Bot을 Gemini로 전환

- Gemini 1.0 Pro를 사용
- 200개 이상의 국가에서 사용 가능
- 개인정보 보호 제어 기능을 사용하여 공유 여부와 항목을 제어 가능

최근 Stable 릴리즈에 900개 이상의 버그와 이슈 해결

메모리와 성능이 33% 가까이 향상

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/01.png" %}

최신 Android Studio 출시

- Stable : Android Studio Jellyfish
- Preview : Android Studio Koala Feature Drop

# Android Studio Koala

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/02.png" %}

Intellij 2024.1 기반

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/03.png" %}

### Sticky lines

> Sticky lines : https://www.jetbrains.com/help/idea/sticky-lines.html 

- 스크롤하더라도 관련 Context가 상단에 표시
- Code, XML에서도 동작

### Inline breakpoints

> line breakpoints : https://www.jetbrains.com/help/idea/using-breakpoints.html#set-breakpoints

- 라인 및 개별 지점에 breakpoint 지정 가능

# Android Studio Koala Feature Drop

### USB 케이블 속도 감지

> usb-check : https://developer.android.com/studio/preview/features#usb-check

<img src="https://developer.android.com/static/studio/images/usb-check.png" />

- 대기 시간이 짧은 디버깅을 위한 가장 빠른 배포 연결은 물리적 케이블을 사용하는 것
- USB-2와 USB-3의 경우 10배 이상 차이가 난다

### 기기 UI 설정 바로 가기

> Device UI setting shortcuts : https://developer.android.com/studio/preview/features#device-ui-setting-shortcuts

디바이스 설정을 더 빠르게 변경 가능

- Dark 테마 여부
- 앱 언어
- TalkBack
- 폰트 사이즈
- 스크린 사이즈

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/04.png" %}

### Resizable Emulator

<img src="https://developer.android.com/static/studio/images/resizable-emulator.png" />

디스플레이 모드에서 폼팩터를 변경 가능 (폰, 폴더블, 태블릿)

### Layout Inspector

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/05.png" %}

- 안정적으로 Layout Inspector를 작동
- 앱과 상호 작용 가능하며, 경계 직사각형도 표시
- Compose recomposition을 highlight 컬러로 강조

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/06.png" %}

- Recomposition 횟수
- 속성 및 클릭 Handler로 이동 가능
- 현재 UI 상태를 Snaptshot으로 export/import 가능
  - 앱의 정적 스냅샷이지만 모든 레이어와 텍스처가 포함되어 있다.

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/07.png" %}

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/08.png" %}

### UI Check

- [Compose Glance Preview 지원](https://developer.android.com/studio/preview/features#tile-preview-panel)

Compose Preview는 성능/메모리를 고려해 게으르게 렌더링함

- 스크롤 시 Preview가 흐려지게 렌더링
- UI Check : Layout Lint 역할
  - 다양한 상태(다양한 화면 크기, 어두운 모드, 밝은 모드 등)에 걸쳐 렌더링한 다음 문제를 찾는다

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/09.png" %}

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/10.png" %}

> 터치 크기가 너무 작다는 경고가 노출

### Baseline Profile

[Baseline Profile Generator](https://developer.android.com/topic/performance/baselineprofiles/create-baselineprofile)를 통해서 쉽게 생성 가능

<img src="https://developer.android.com/static/topic/performance/images/studio/baseline-profile-generator-module-template.png" />

<img src="https://developer.android.com/static/topic/performance/images/studio/generate-baseline-profile.png" />

시작 경로를 캡쳐하고 Studio로 가져온 결과를 앱과 함께 패키징하고 배포하면, 앱이 더 빠르게 시작된다.

### 새로운 Profiler

> Faster and improved Profiler with a task-centric approach : https://developer.android.com/studio/preview/features#task-based-profiler

필요한 작업 중심으로 개선

<img src="https://developer.android.com/static/studio/images/task-based-profiler.png" />

<iframe width="560" height="315" src="https://www.youtube.com/embed/2wOfYgIMf-A?si=JNo0t6WRwqMMkZcV&amp;start=848" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### Gemini

Studio Bot대신 Gemini로 변경

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/11.png" %}

Gemini가 볼 수 있는지 코드의 범위를 선택할 수 있다

- Do not use context from any project : 프롬프트로 입력한 내용만 전송

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/12.png" %}

- 프로젝트에 대한 액세스 권한을 부여하면, 하단에 AI 기반 코드 완성이 활성화된 것을 볼 수 있다

Context 공유

> Configure context sharing with .aiexclude files : https://developer.android.com/studio/preview/gemini/aiexclude

- `.aiexclude` 파일을 생성한 후 정의하면 된다
- .gitignore 파일의 구문/문법과 동일
- `*`만 넣는다면 내 프로젝트의 모든 항목을 제외한다는 의미
  - 코드 및 Context menu 내의 Gemini 옵션도 비활성화됨

#### Custom Transformations

> Code suggestions with Gemini in Android Studio : https://developer.android.com/studio/preview/features#gemini-code-suggestions

Gemini에게 새 코드를 추가하거나 선택한 코드를 변환하는 코드 제안을 생성하도록 요청 가능

> 동작 영상 : https://developer.android.com/static/studio/videos/gemini-code-suggestions.mp4

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/13.png" %}

- 제안된 코드에서 추가 쿼리를 요청 가능

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/14.png" %}

- 변환된 항목들 중 특정 기록 시점으로 되돌아갈 수 있다

기타 예제

- [재귀를 반복문으로 변경](https://youtu.be/2wOfYgIMf-A?si=QyNomPqg_5x1pOmv&t=1340)
- [string 리소스 파일의 일부 문자열의 번역 처리](https://youtu.be/2wOfYgIMf-A?si=CpgjY0ha_g-lbSa3&t=1383)
- [코드 리팩터링](https://youtu.be/2wOfYgIMf-A?si=L8pRgUj8kxdE9Q9z&t=1465)
- [테스트 시나리오](https://youtu.be/2wOfYgIMf-A?si=TxjNeiq1XB_V4Vll&t=1549)
- [커밋 메세지 추천](https://youtu.be/2wOfYgIMf-A?si=Mj6B-7ufdomlamaQ&t=1594)

#### Gemini의 multi-modal

> 동작 영상 : https://youtu.be/2wOfYgIMf-A?si=ThAyKyUQ7D6ITvlg&t=1624

1.5 모델로 전환 시 가능한 기능

- UI 이미지와 프롬프트 명령어로 UI 코드 생성해 줌

# Firebase

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/15.png" %}

릴리즈 모니터링

- 새로운 대시보드. 30초마다 갱신

Crashlytics에서 Gemini를 통해서 체크 가능

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/16.png" %}

Android Studio내 App Quality Insights를 통해서 Crash를 확인 가능

- `Show insights`를 통해 Gemini 사용

> Analyze crash reports with Gemini in Android Studio : https://developer.android.com/studio/preview/features#gemini-aqi

<img src="https://developer.android.com/static/studio/images/gemini-aqi.png" />

#### Version control system integration

Crashlytics Stack trace에서 크래시가 발생한 시점의 관련 코드로 이동할 수 있다. 현재 git 체크아웃의 코드 줄로 이동하거나 현재 체크아웃과 크래시를 생성한 버전 간의 차이점을 볼 수 있다.

> Version control system integration in App Quality Insights : https://developer.android.com/studio/releases/past-releases/as-iguana-release-notes#aqi-vcs

<img src="https://developer.android.com/static/studio/images/aqi-vcs-integration.png" />

## Stable Release Process

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/17.png" %}

Android Studio를 다운로드하면 두 가지 구성 요소를 다운로드하게 된다.

- Android 개발과 관련된 Android 앱 개발 구성요소 번들
- IntelliJ 플랫폼의 최신 버전

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/18.png" %}

2단계에 걸쳐 Android Studio를 출시할 예정

- 첫 단계 : IntelliJ 플랫폼에 몇 가지 버그 수정 및 품질 수정이 추가된 플랫폼 릴리스
- Feature 단계: 해당 Android Studio 버전의 Android 관련 기능

결과적으로

- 매년 2배의 업데이트와 Stable 버전 만들어짐
- 안정성과 품질 향상
- Android 기능의 출시 주기가 예측 가능하고 뚜렷해짐

{% include img_assets.html id="/blog/io/io24/Whats_new_in_Android_development_tools/19.png" %}
