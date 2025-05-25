---
layout: post
title: "[요약] What's new in Android development tools (Google I/O '25)"
date: 2025-05-25 14:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io25
---

{% include youtube.html id="KXKP2tDPW4Y" %}

<!--more-->

- - -

# Roadmap

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/01.png" %}

Android Studio의 릴리즈는 기존 대비 2배로 증가했습니다.

- 최초 업데이트 : Platform Update, 버그 수정 등
- Feature Drop : 안드로이드 전용 기능 포함

작년 IO 이후, Ladybug/Meerkat의 전체 릴리즈가 되었습니다

## 주요 업데이트

### Android Studio Ladybug Feature Drop

- Wear OS Preview/Health Services
- App Link Assistant : App Link 테스트가 더 용이
- Google Play SDK Insights Integration : IDE와 통합으로 직접 문제를 확인 가능
- 700개 이상의 버그 수정

### Android Studio Meerkat Feature Drop

- Compose Preview 향상
- Kotlin Multiplatform Shared Module : Kotlin Multiplatform 추가를 위한 새로운 템플릿 등 지원
- Update Build Menu & Actions : 빌드 메뉴를 효율적으로 간소화하게 업데이트
- Themed Icon Preview

## Gemini in Android Studio

Gemini와 Android Studio를 핵심 개발자 작업에 적용했습니다.

- 코드 제안, 문서 생성, 충돌 해결 등
- Gemini 모델은 약 2주마다 새로운 개선이 이루어지고 있음

### AI에 대한 철학

0 to 1

- 프로토타입, 새로운 아이디어 등에서 출발할 경우
- 빠르고 새로운 아이디어가 필요

1 to Production

- 기존 코드 베이스가 존재하는 경우

# Demo

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/02.png" %}

하단의 Gemini suggestions에서 질의에 암묵적으로 사용되는 파일을 보여줍니다. 또한, 이미지를 코드로 변환하고 싶은 경우를 위한 이미지 첨부도 가능합니다.

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/03.png" %}

질의 입력 창 우측 아래에 사용 중인 모델이 표시됩니다.

> Android Studio Narwal Feature Drop 2에서는 미표시 중입니다.

### Gemini를 통한 라이브러리 업데이트

시연 영상 : https://youtu.be/KXKP2tDPW4Y?si=eGlFA8wRVPSYQbMb&t=358

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/04.png" %}

- Gemini는 빌드 파일을 분석하여 라이브러리를 업데이트하도록 제안
- 업데이트될 라이브러리들의 하이퍼링크도 제공
- 제안받은 내용을 반영 가능
- 반영 후, 빌드를 통해 발견된 오류를 추론하여 수정 사항을 검토받을 수 있다.

### Backup and Sync

로컬 컴퓨터와 다양한 원격 컴퓨터의 설정이 Google 혹은 Jetbrain 계정을 사용하여 Android Studio 설정을 클라우드 저장소에 백업할 수 있습니다.

- Keymaps, Code settings, System settings 등의 설정을 동기화 가능

> Backup and Sync : https://developer.android.com/studio/preview/features?utm_source=android-studio#backup-and-sync

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/05.png" %}

### Journeys

https://developer.android.com/static/studio/preview/gemini/images/journey-animation.mp4

<video width=100% preload="auto" muted loop>
  <source src="https://developer.android.com/static/studio/preview/gemini/images/journey-animation.mp4" type="video/mp4">
</video>

자연어를 사용하여 각 테스트의 단계와 어설션을 설명할 수 있으므로 엔드 투 엔드 테스트를 쉽게 작성하고 유지할 수 있습니다.

- 실제 코드는 XML로 작성됨
- 그래픽 에디터도 제공
- 드래그 앤 드롭으로 순서를 변경/새 항목 추가/삭제도 가능
- 레코드를 사용하여 기존 Journey 또는 빈 Journey에 추가 가능
  - https://youtu.be/KXKP2tDPW4Y?si=FelEQO9IjWpbUX-r&t=751
  - 하단 업데이트 바에서 입력을 처리 중임을 노출
  - 각 제스처는 Gemini에 많은 프레임을 업로드하고 일부 처리를 수행하기 때문에 시간이 소요됨

firebase app distribution의 테스트 에이전트와 Journeys을 통합하고 있으며, app distribution에서도 볼 수 있습니다. 실행한 결과를 확인할 수 있습니다.

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/06.png" %}

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/07.png" %}

### Gemini agent

https://youtu.be/KXKP2tDPW4Y?si=bSRIZF3KTQ5qiX3y&t=902

Gemini에 Agent 탭이 새롭게 제공됩니다.

- 특정 동작의 버그를 질의하여 문제의 코드를 발견하고, 수정 방법을 제안
- 테스트 코드 생성을 질의하여 Gemini로부터 코드 제안 및 실제 반영할 수 있음
- Lint 경고를 질의하여 

Android Studio내의 Firebase Crashlytics 탭에서의 신기능

- Crash에 대해서 실제 코드를 살펴보고 수정 방법을 제안
- https://developer.android.com/studio/preview/features#suggested-fixes

Gemini를 사용한 Compose 미리보기 생성

- 동작 영상 : https://developer.android.com/static/studio/preview/gemini/images/journey-animation.mp4

## Firebase Device Streaming

Firebase Device Streaming은 Google의 Device Lab의 원격 장치에 연결할 수 있게 해주는 기능입니다. OEM/Device Lab을 통해서 다양한 제조사의 단말을 선택할 수 있습니다. Google의 Device Lab이 아니라 해당 기기의 Lab에 연결하는 기능입니다.

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/08.png" %}

> Connect to Partner Device Labs : https://developer.android.com/studio/run/android-device-streaming#2P

## Wifi 페어링

- 같은 와이파이를 사용하는 경우, 기기 목록에 빠르게 노출됨

## Compose Preview

- 한 번에 하나의 Preview에 집중하고 싶은 경우 Focus 모드를 사용하면 됩니다
- Focus 모드
  - 우측 아래의 크기 조절을 통해서 다양한 Composable 크기를 테스트 가능

## Backup and restore

App 데이터 백업을 생성하고 다른 기기에 복원할 수 있는 기능을 제공합니다.

- Backup App Data : 애뮬레이터의 스냅샷을 만드는 것과 유사
- Restore App Data

> https://developer.android.com/studio/preview/features#test-backup-restore

## XR 지원

{% include youtube.html id="8jNWfbkWAs4" %}

- Layout Inspector
- Screen resize 지원

# Updates

Gemini in Android Studio for business

- 기업 대상 Android Studio for business를 출시
- 코드 보안 기능을 제공
- https://developer.android.com/gemini-for-businesses

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/09.png" %}

Android Studio Cloud

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/10.png" %}

- Android 앱 개발을 위해 특별히 설계된 원격 프로비저닝된 Linux 가상 머신을 사용
- Firebase Studio를 통해서도 접근가능
- 인터넷 연결만으로 프로젝트를 열 수 있는 편리한 방법을 제공
- 컴퓨터에 소스 코드를 보관할 수 없는 개발자나 성능이 낮은 머신을 사용하는 개발자에게 유용

Backup & Sync Settings

- Android Studio의 로컬/원격 버전간의 설정 동기화에 유용
- Google 혹은 Jetbrain 계정으로 로그인하여 설정을 동기화 가능

Optimize apps with R8

- AGP 9부터는 점진적인 R8를 도입

Phased Sync

- 동기화 프로세스를 여러 개의 작은 단계(phase)로 분할하여 IDE가 기능적인 프로젝트를 훨씬 더 빠르게 로드할 수 있게 해줌.

Gradle Daemon Toolchain

- Gradle daemon을 실행할 정확한 JDK 버전을 지정 가능

16KB Page Size Validation

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/11.png" %}

- Android 플랫폼과 Google Play Store 정책에 따라 앱의 Pase Size를 4KB에서 16KB를 지원해야 함
- 16KB Page 지원 없이 빌드할 경우, 경고를 표시
- APK Analyzer를 통해 문제의 SO 파일을 알려줌
- https://developer.android.com/guide/practices/page-sizes

{% include img_assets.html id="/blog/io/io25/What's_new_in_Android_development_tools/12.png" %}
