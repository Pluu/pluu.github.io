---
layout: post
title: "[요약] What's new in Android (Google I/O '26)"
date: 2026-06-08 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io26
---

{% include youtube.html id="8PxuWdjESfg" %}

<!--more-->

- - -

# Compose First

<img src="https://developer.android.com/static/develop/ui/compose/images/compose-first.png" />

- Compose는 Android UI 개발의 표준으로 성숙
- 모든 안드로이드 UI를 `Jetpack Compose`로 구축하는 `Compose First` 원칙을 발표

> goo.gle/compose-first

- 이후 모든 API, 라이브러리, Tool, 가이드는 Compose로 제공된다. 기존 `View 컴포넌트(Fragment, RecyclerView, Material View 컴포넌트 등)는 유지 보수 모드로 전환`되며, 앞으로 새로운 기능 추가 없이 버그 수정만 제공된다고 한다.
  - 당장 View 컴포넌트를 지원 중단(Deprecated)하거나 제거할 계획은 없음

## Compose로 마이그레이션

XML을 Compose로 변환을 돕는 Skill외에도 Android Studio에 기능을 준비 중이다.

- 프로젝트 정보를 기반으로 AI 에이전트로 UI 변화가 이루어짐
- 레이아웃이 참조하는 스타일, 리소스를 확인한 후 마이그레이션 전후를 비교할 수 있는 스크린샷 데스트를 생성해 줌

## Compose 1.11

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/01.png" %}

Compose 1.10 및 1.11에서 Retain, 테스트 API, SharedTransitionLayout, 새로운 TextField 기능이 추가되었다.

## New Styles API

컴포넌트의 스타일 특성을 표준화된 세트로 정의해 컴포넌트의 동작과 외관을 분리되었다. 컴포넌트 스타일을 쉽게 커스텀 할 수 있을 것이다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/02.png" %}

- 상태 지원
- 상태 변경 애니메이션
- 성능 최적화가 적용되어 Recomposition을 최소화

향후 Material 컴포넌트에도 Style 지원 계획이다.

> Styles in Compose : https://developer.android.com/develop/ui/compose/styles

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/03.png" %}

### Hero benchmarks

최신 Compose 1.11에서는 스크롤 버벅임(Jank), Startup, View와 Compose가 공존하는 하이브리드 UI 성능이 향상되었다.

실제 앱 성능을 비교하는 새로운 벤치마크 제품을 오픈소스로 출시

> Hero benchmarks: http://goo.gle/hero-benchmark

# 성능 최적화 및 디버깅 도구

## R8 configuration analyzer

- 새로운 R8 인사이트 도구를 Play console에 순차적으로 출시 예정
- Android Studio에서도 확인할 수 있는 R8 configuration analyzer를 출시함. 최적화, 난독화, 리소스 축소의 효율성을 점수로 노출
- AI Agent가 R8과 연동할 수 있는 새로운 Skill도 출시할 계획

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/04.png" %}

> Use R8 Configuration Analyzer : http://goo.gle/r8-analyzer

# 안드로이드 17의 메모리 관리 강화

## 메모리 제한(Memory limits)

안드로이드 17은 메모리 누수 등으로 리소스를 과도하게 사용하는 앱에 영향을 주는 메모리 제한(Memory limits)을 도입합니다. 

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/05.png" %}

실제로 앱이 메모리 제한에 영향을 받은 경우, 애플리케이션 종료 정보(exitinfo)에 메모리 제한에 대한 문자열이 포함된다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/06.png" %}

ProfilingManager API에 [TRIGGER_TYPE_ANOMALY](https://developer.android.com/reference/kotlin/android/os/ProfilingTrigger#trigger_type_anomaly)또는 [TRIGGER_TYPE_OOM](https://developer.android.com/reference/kotlin/android/os/ProfilingTrigger#trigger_type_oom) 타입의 프로파일링 트리거가 있다. Heapdump를 얻어 메모리 문제를 진단하고 해결할 수 있다.

> Trigger-based profiling : https://developer.android.com/topic/performance/tracing/profiling-manager/trigger-based-capture

## Android Studio

안드로이드 스튜디오의 프로파일러에 LeakCanary가 통합되어 Gemini AI를 통해 메모리 누수 원인과 수정 제안을 받을 수 있습니다.

<img src="https://developer.android.com/static/studio/preview/features/images/leakcanary-task.png" />

> 이미지 출처 : https://developer.android.com/studio/preview/features#leakcanary

## Android 17

- CustomView가 포함된 알림의 이미지 크기를 제한하여, 특정 크기를 초과하면 이미지를 제거한다.
- ART에서 Young Generation GC를 더 자주 도입한다

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/07.png" %}

- Target Android 17로 지정 시 Reflection을 이용한 Static final field 수정은 불가능해진다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/08.png" %}

고성능과 전력 효율을 위해 Vulkan이 자체 GPU API로 지원하고 있으며, 기존 OpenGL/WebGPU API는 Vulkan 위에 계층적으로 추가된다. 앱/게임에서 OpenGL을 사용 중이라면 ANGLE이 Vulkan으로 변환해준다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/09.png" %}

- 앱이 GPU 성능을 활용할 수 있도록 
- Jetpack WebGPU 종속성을 추가하면 된다

> AndroidX webgpu : https://developer.android.com/jetpack/androidx/releases/webgpu

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/10.png" %}

새로운 Performance Analyzer는 하나의 툴체인으로 통합하여 디버깅을 획기적으로 간소화한다. 트레이스를 로드 및 렌더링하는 속도가 기존 대비 최대 26배 빨라졌다. 독립적인 실행하거나 Studio Profiler 내에서 실행될 수 있다.

# Intelligence

Gemini와 같은 Agnet는 여러 앱에 걸쳐 오케스트레이터(Orchestrator) 역할을 할 수 있다.

- Gemini는 앱 화면을 분석/탐색

### AppFunctions

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/11.png" %}

AppFunctions은 Android MCP 통합 구축을 간소화하는 Jetpack 라이브러리의 Android 플랫폼 API이다. 이를 통해 앱은 기기 내 MCP 서버처럼 작동할 수 있으며, Gemini와 같은 Client Agent 및 어시스턴트가 사용할 수 있는 도구 역할을 하는 기능을 제공한다.

- Gemini를 통해서 AppFunctions 구현을 쉽게 할 수 있다.

```kotlin
@AppFunction(isDescribedByKDoc = true)
suspend fun searchEmails(
   context: AppFunctionContext,
   query: String
): List<EmailSummary>
```

> 코드 출처 : https://developer.android.com/ai/appfunctions

### On device

Gemini Nano와 같은 On Device 모델을 사용하면, 사용자 데이터를 로컬에 보관하고 인터넷 연결 없이 작동하면 거래당 비용도 발생하지 않는다.

올해 말 Gemma 4를 탐재한 Gemini Nano 4를 사용할 수 있다.

> ML Kit GenAI Prompt API : https://developers.google.com/ml-kit/genai/prompt/android

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/12.png" %}

Gemini Cloud 모델은 고급 기능을 갖추고 있으며, [Firebase AI Logic](https://firebase.google.com/docs/ai-logic)을 통해 Android 앱에서 사용할 수 있다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/13.png" %}

Cloud 기반 에이전트를 구축하려는 경우, A2UI 프로토콜을 사용하면 클라이언트에 UI를 표시할 수 있다.

안드로이드용 A2UI를 표시하는 Jetpack Compose Renderer가 곧 출시 예정

# Accessibility

- Compose에서 제스처를 사용해 앱 콘텐츠 크기를 조절하는 가이드가 새로 배포 (Pinch to zoom)
- 사용자가 생성한 콘텐츠 등에서 설명이 누락된 경우, AI를 활용해 이미지 설명을 자동으로 생성
- 새로운 Accessibility Scanner는 명암비가 낮거나 터치 타겟이 너무 작은 일반적인 문제들을 더욱 잘 잡아낸다

# 개인정보 보호 및 보안

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/14.png" %}

- 앱에서 네이티브 라이브러리를 동적으로 로드할 때 읽기 전용으로 처리
- OTP가 포함된 메시지에 접근하는 것을 방지하기 위해 3시간 동안 읽기 접근을 지연

### Credential Manager

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/15.png" %}

- 이메일과 전화번호 인증을 제공하며, 기존 비밀번호 사용자를 위해 패스키(Passkeys)를 자동으로 생성해 주어 보안성을 높인다.

### ACCESS_LOCAL_NETWORK

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/16.png" %}

Android 17을 Target으로하는 앱은 스마트 홈 장치 등 로컬 네트워크 장치를 찾으려면 `ACCESS_LOCAL_NETWORK` 권한이 runtime으로 요구됩니다.

### Privacy Preserving Pickers

앱이 광범위한 전체 권한을 요청하지 않아도 되도록 Picker를 제공합니다.

- Output Switcher : 특정 장치에 연결
- EyeDropper API : 화면의 특정 색상을 선택
- Contacts Picker : 연락처 내 특정 필드와 특정 연락처에 접근
- Photo Picker : 그리드 뷰를 지원

# OS Experiences

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/17.png" %}

Live Update Notification

- 건강 및 피트니스, 앱, 타이머, 여행 앱에서 사용할 수 있는 미터법 스타일 템플릿을 추가
- Sementic color API를 사용하여 실시간으로 상태를 전달할 수 있다

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/18.png" %}

올해 말 다양한 이모티콘을 업데이트할 예정이다.

# Camera & Media

### On device 이미지/비디오 강화

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/19.png" %}

기기 내부에서 실행되는 AI를 사용해 오프라인 상태에서도 서버 비용 없이 사진의 화질 개선, 초점 보정(Deblur), 노이즈 제거(Denoise), 업스케일링 등을 처리할 수 있는 라이브러리가 제공됩니다.

### 백그라운드 오디오 제한

사용자가 의도하지 않은 배경 음악이나 소음이 갑자기 재생되는 것을 막기 위해 Android 17은 백그라운드 앱의 오디오 API 사용을 엄격히 제한합니다. (정확한 알람 제외)

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/20.png" %}

새로운 이미지 포맷 지원

- RAW14
- H.266 VVC

스트리밍 개선

- HE-AAC

카메라 강화

- 제조사별 확장 기능 등

차세대 Eclipsa 비디오 포맷이 공식 출시

- 고품질 HDR 재생을 지원
- ExoPlayer는 추가 설정 없이 바로 사용 가능

# Adaptive

### Ignored API

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/21.png" %}

안드로이드 17부터는 기기의 전체 화면 비율이나 가로/세로 방향을 앱이 임의로 제한(opt-out)할 수 없습니다.

무시되는 옵션

- screenOrientation
- ﻿﻿resizableActivity
- ﻿﻿minAspectRatio
- ﻿﻿maxAspectRatio
- ﻿﻿setRequestedOrientation
- ﻿﻿getRequestedOrientation

### MediaQuery, FlexBox, Grid

Compose 1.11에서는 기기 상태를 쿼리하는 MediaQuery와 유연한 요소 배치를 위한 FlexBox, Grid 레이아웃 API가 실험적으로 제공

> MediaQuery : https://developer.android.com/develop/adaptive-apps/guides/mediaquery

> FlexBox : https://developer.android.com/develop/ui/compose/layouts/adaptive/flexbox

> Grid : https://developer.android.com/develop/ui/compose/layouts/adaptive/grid

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/22.png" %}

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/23.png" %}

### Continue On

한 기기에서 시작한 작업을 다른 기기로 전환하여 작업을 계속할 수 있다.

> Continue On : goo.gle/continue-on

### Bubbles

모든 앱에서 화면을 띄울 수 있는 Bubbles 기능이 확대되었으며, 대화면 전용 Bubble bar가 도입되었습니다. 

> Bubbles : https://developer.android.com/develop/ui/compose/layouts/adaptive/support-bubbles

### Widget

Jetpack Glance를 활용해 위젯을 여러 생태계로 손쉽게 확장할 수 있습니다. 특히 올해는 자동차에 위젯을 제공할 준비를 하고 있습니다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/24.png" %}

Snap scroll API를 사용하여 위젯 애니메이션을 구현할 수 있다.

> SnapScrollMatchHeight : https://developer.android.com/reference/kotlin/androidx/glance/appwidget/lazy/VerticalScrollMode.SnapScrollMatchHeight

# Wear OS 7

시스템 플랫폼 개선으로 배터리 수명이 최대 10% 길어집니다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/25.png" %}

사용자가 스마트폰에서 미디어를 재생하면 워치에 자동으로 제어 컨트롤이 나타나며, 휴대폰의 실시간 알림이 시계로 브리지 연동됩니다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/26.png" %}

스마트 워치는 연결된 스마트폰의 미디어 출력을 제어하여 스피커에서 헤드폰으로 전환 등을 할 수 있습니다.

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/27.png" %}

시계 제조 업체는 스마트폰에서 시계로 실시간 업데이트 알림을 전송하는 기능을 제공할 수 있습니다.

### Wear OS AppFunctions

> Wear OS 6.1 이상

제미나이(Gemini)와 같은 AI 에이전트와 연동되는 AppFunctions를 생성할 수 있습니다. 이를 활용하면 에이전트가 사용자를 대신하여 앱 내의 특정 작업 흐름(in-app flows)을 직접 호출하고 실행할 수 있습니다.

### 추가 업데이트

- 올해 말 Wear Workout Tracker 앱을 출시 예정
- Wear OS 1.6용 Compose는 Navigation 3를 지원하며, LocalAmbientModeManager를 통해 기기가 절전모드일 때 컨텐츠를 관리할 수 있다
- Wear OS 7 Canary Emulator가 Android Studio에서 제공

# Andorid XR

몰입형 가상현실과 증강현실(AR) 안경을 지원하는 Android XR SDK Developer Preview 4가 출시됩니다. 

> Updates to the Android XR SDK: Introducing Developer Preview 4 : https://developer.android.com/blog/posts/updates-to-the-android-xr-sdk-introducing-developer-preview-4

Jetpack XR SDK 라이브러리가 베타 버전으로 출시될 예정

{% include img_assets.html id="/blog/io/io26/whats-new-in-android/28.png" %}

개선 사항

- 대용량 3D 모델을 앱에 포함하는 대신 실시간으로 지오메트리를 생성해 앱 크기를 줄임
- XR Glasses에 Geospatial API를 도입해 공간 길 찾기를 돕는다
- GODOT 및 언리얼 엔진에 대한 지원을 확장
- 시각적 및 상호 작용 제약 조건에 맞춰 디자인하는데 사용할 수 있는 컴포넌트 Jetpack Compose Glimmer 개선
  - Jetpack Compose Glimmer는 디스플레이 글라스에 최적화된 증강 Android XR 환경을 빌드하기 위한 Compose UI 툴킷
  - Glimmer를 쉽게 추가할 수 있는 Skill도 제공

> Build UI for display glasses with Jetpack Compose Glimmer : https://developer.android.com/develop/xr/jetpack-xr-sdk/jetpack-compose-glimmer

# Cars

Android Auto와 구글이 내장된 차량용 앱간의 호환성을 높여 차량용 앱 개발을 간소화했다. 

단일 코드로 양쪽 플랫폼에 Media Apps Templates를 모두 사용할 수 있으며, 두 플랫폼 모두에서 콘텐츠가 포함된 지도 템플릿과 함께 Google Maps SDK를 사용할 수 있다.

Car App Library 1.9에서는 두 플랫폼에서 사용할 수 있는 새로운 컴포넌트와 레이아웃을 추가한다.
