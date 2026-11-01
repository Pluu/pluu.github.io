---
layout: post
title: "[요약] The latest in Android dev tools (Android Dev Summit '26)"
date: 2026-10-31 21:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

{% include youtube.html id="w-auFZP5gJo" %}

<!--more-->

기존 안드로이드 CLI 도구는 사용자 대화형 입력(Interactive Prompt)을 요구해 AI 에이전트가 자동으로 처리하기 어려웠습니다.

Android Dev Summit 2026의 "The latest in Android dev tools" 세션에서는 터미널, 데스크톱 에이전트 앱, Android Studio에서 AI 에이전트가 직접 제어할 수 있는 새로운 안드로이드 도구 체인을 발표했습니다.

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - -

# 개요: AI 코딩 에이전트 시대의 안드로이드 개발 도구

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/01.png" %}

### 핵심 구성 요소
- Android CLI: 터미널 스크립트, CI, 에이전트 앱, Android Studio 전체를 관통하는 단일 엔트리 포인트 도구
- Agent Applications: Google Antigravity, Claude Code, OpenAI Codex 등과의 딥 인테그레이션(공식 플러그인 & Sidecar)
- Android Studio Rabbit 2/3: ACP(Agent Client Protocol) 기반 BYOA(Bring Your Own Agent) 및 AI Change Review

> 데모 전반에는 40개 모듈로 구성된 대규모 오픈소스 오디오/비디오 팟캐스트 앱인 Pocket Casts가 사용되었습니다.

- - -

# 1. Android CLI

Android CLI는 AI 에이전트가 안드로이드 도구를 실행할 때 생기는 파싱 오류와 불필요한 대기를 없애도록 만들었습니다.
- 예측 가능한 명령어 체계 (Predictable commands)
- JSON 등 기계가 읽기 쉬운 구조화된 출력 (Structured outputs)
- 추가 입력 프롬프트 없이 즉시 끝나는 비대화형 실행 (Zero interactive prompts)

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/02.png" %}

### 주요 신규 명령어 (`android --ads`)

| 명령어 | 주요 기능 및 특징 |
|---|---|
| signals | Crashlytics의 크래시 목록 및 현장 텔레메트리 데이터를 조회 |
| device | 연결된 기기/에뮬레이터 미러링(device hub) 및 원격 물리 기기 대여(Reservation) 관리 |
| profiler | 앱, 게임, 디바이스의 시스템 트레이스(Perfetto) 및 힙 덤프 수집 |
| build | Gradle 등의 빌드 아티팩트를 CLI에서 직접 빌드 |
| preview | Android Studio나 실제 기기 없이 터미널에서 Jetpack Compose @Preview를 PNG 및 JSON 컴포넌트 트리로 렌더링 |
| install | 변경된 바이트만 전송하는 델타 푸시(Delta push) 배포 (기존 ADB 대비 대폭 시간 절약) |
| input | 복잡한 좌표 계산 대신 시맨틱 UI 요소를 대상으로 제스처 및 키 이벤트 전송 |
| analyze | AAB/APK의 R8 설정, 난독화 비율, DEX 크기 및 리소스 분석 |
| docs | 공식 안드로이드 지식 베이스(KB)에서 최신 가이드 문서를 온디맨드로 로컬 검색 및 fetch |
| auth | 안드로이드 CLI 도구용 Google 서비스 인증 로그인/로그아웃 |

- - -

# 2. 터미널 환경의 에이전트 자동화 데모 (Claude Code)

## (1) 프로덕션 크래시 재현 및 핫픽스

Firebase Crashlytics에 보고된 실제 크래시를 에이전트가 탐색, 재현, 코드 수정, 배포 및 검증까지 단 1분 42초 만에 수정했습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/03.png" %}

#### 데모

1. 크래시 탐색: `android signals` 명령어로 지난 30일간 사용자 발생 수가 가장 높은 크래시를 조회
   - 원인: 비밀번호 재설정("I forgot my password") 버튼을 연속 두 번 탭하면 네비게이션이 중복 실행되어 **IllegalArgumentException**이 발생
     > IllegalArgumentException: Navigation action ... cannot be found from the current destination
2. 기기에서 재현: `android layout`으로 버튼 좌표를 확인한 뒤 `android input tap`으로 버튼을 두 번 탭해 실제 기기에서 크래시 발생
3. 코드 수정: 중복 화면 이동을 막도록 SignInFragment.kt와 PromoCodeFragment.kt의 네비게이션 로직에 `currentDestination` 확인 가드를 추가
4. 고속 재배포: `android build`로 빌드한 뒤 `android install`을 실행해 전체 84MB APK 대신 **3.84MB 델타 패치**만 기기로 전송
5. 검증: 기기에서 다시 더블 탭을 실행해 크래시 로그가 남지 않고(0 lines) 화면이 정상 유지됨을 확인

#### 사용된 Android CLI commands
- `android signals crashes list --firebase-app ... --sort-by=users --timeframe=30d`
  - 최근 30일간 사용자 수 기준 상위 크래시 이슈 랭킹 조회
- `android signals crashes describe <issue> --timeframe=30d`
  - 해당 크래시의 상세 스택 트레이스 및 디바이스/안드로이드 OS 버전별 분포 확인
- `android layout --device=... --flat`
  - 수정 전/후 비밀번호 재설정 버튼의 좌표를 파악하기 위한 UI 레이아웃 트리 조회
- `android input tap --device=... "id:btnSignIn"`
  - 구버전 로그인 화면으로 진입하기 위한 시맨틱 탭 전송 (2회 실행)
- `android build "gradle://?:app:assembleDebugProd"`
  - 수정된 코드의 빌드 산출물 생성
- `android install --device=...`
  - 초기 수정 전 빌드 설치, 핫픽스 빌드 델타 패치 주입 (84MB 중 3.84MB만 전송)  
  *(참고: CLI가 지원하지 않는 화면 회전 고정, 딥링크 호출, 백키 입력, 더블탭 등 일부 작업에는 `adb`를 보조로 사용)*

## (2) APK 최적화: R8 Configuration Analyzer

`Release Bundle이 너무 크다`는 요청에 대해 에이전트가 ProGuard/R8 룰을 분석하고 불필요한 keep 룰을 제거했습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/04.png" %}

#### 데모

- 원인 파악: Protocol Buffers keep 룰이 지나치게 포괄적이어서 불필요한 클래스까지 난독화 대상에서 제외되고 있었습니다.

  > - 수정 전 : -keep class * extends com.google.protobuf.GeneratedMessageLite { *; }
  > - 수정 후 : -keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite { <fields>; }

- 클래스 전체를 유지하지 않고, 실제 사용하는 필드 멤버와 Retrofit 반환 타입으로 호출되는 API 메시지만 유지(keep)하도록 수정

개선 결과:

- 비압축 DEX 크기: 19,485,804 B → 18,957,388 B (-528 KB, -2.7%)
- APK 압축 크기: 42,311,672 B → 42,147,832 B (-164 KB)
- Keep된 메서드 수: 17,940개 → 11,757개 (-6,183개 제거, -34%)
- Keep된 필드 수: 7,944개 → 7,209개 (-735개 감소)
- Keep된 클래스 수: 2,342개 → 2,268개 (-74개 감소)
- DEX 난독화 비율: 92.72% → 93.06% (+0.34%p)

#### 사용된 Android CLI commands

- `android analyze ./before/app-release.apk`
  - 수정 전 베이스라인 APK의 DEX 크기, R8 설정 및 난독화 비율(Obfuscation ratio) 측정
- `android analyze ./after/app-release.apk`
  - 룰 수정 후 생성된 APK의 수치를 동일하게 추출하여 개선 지표 비교  
    *(참고: CLI에 Configuration Analyzer 출력 파싱 명령어가 없어 상위 룰 랭킹에는 보조 스크립트 활용)*

## (3) 앱 시작 시간(Startup Time) 최적화: Baseline Profile & Profiler

앱 시작 성능 개선 요청 시 에이전트가 공식 문서를 읽고 프로파일러를 통한 측정을 수행했습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/05.png" %}

#### 데모

- 원인 분석: 출시 버전 프로토타입 APK의 **baseline.prof**가 약 8KB에 불과하며, 포함된 6,690개 룰 중 Pocket Casts 자체 코드 룰이 0개(전체 프로필 로드 룰 중에서도 단 66개)여서 시작 코드가 JIT/인터프리터로 구동되고 있음을 확인
- 최적화 수행: 공식 문서를 읽어 무루팅 환경(Android 14+)에서 베이스라인 프로필을 수집 및 생성하는 절차를 확인하고, 콜드 스타트 프로필 룰(Pocket Casts 룰 2,621개 포함)을 갱신

#### 사용된 Android CLI commands
- `android profiler systemtrace start --launch --duration=8`
  - 앱 콜드 런치(Cold start) 시점의 시스템 트레이스를 Perfetto 형식(`*.pftrace`)으로 수집 (수집된 트레이스는 `ui.perfetto.dev`에서 분석)
- `android docs fetch kb://android/topic/performance/baselineprofiles/manually-create-measure`
  - Android 14+ 기기에서 루팅 없이 Baseline Profile을 수동 생성하고 측정하는 최신 공식 기술 가이드라인 로컬 fetch 및 학습

개선 수치 (Pixel 6 Pro 기준):

- Main-thread CPU 시간: 297.7ms → 244.7ms (-17.8%)
- Total app CPU 시간: 809.3ms → 600.4ms (-25.8%)
- JIT thread CPU 시간: 56.3ms → 15.6ms (-72.2%)
- Time to initial display (TTID): 463.2ms → 383.4ms (-17.2% 단축)

- - -

# 3. Linux 데스크탑에서 Android 앱 네이티브 실행 (실험적 프로토타입)

별도의 무거운 에뮬레이터나 중첩 가상화(Nested Virtualization) 없이, **Linux 데스크톱 상에서 Android x86 APK를 단일 네이티브 프로세스로 직접 실행**하는 새로운 기술이 공개되었습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/06.png" %}

- 초경량 구조: 단일 프로세스로 실행되며 stdout/stdin으로 로그가 직접 출력됨
- 클라우드 에이전트 환경 최적화: 중첩 가상화를 지원하지 않는 클라우드 VM이나 CI 컨테이너에서도 에이전트가 앱을 직접 실행하고 테스트 가능
- 높은 완성도:
  - 순수 Compose 앱 실행
  - 네트워크 통신이 포함된 Google 레퍼런스 앱 실행
  - 네이티브 .so 라이브러리 변환 계층을 통해 C++ 라이브러리와 오디오 출력이 포함된 실제 Pocket Casts 앱 구동
  - 데스크톱 변환 계층을 통한 OpenGL ES 1 네이티브 게임 앱 렌더링

- - -

# 4. AI 에이전트를 위한 공식 Android 플러그인

Google Antigravity, Claude Code, OpenAI Codex를 위한 공식 Android 플러그인이 배포되었습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/07.png" %}

플러그인을 활성화하면 Android CLI 뿐만 아니라, 공식 최신 지식/가이드가 포함된 `Android Skills`가 주입되어 모델의 오래된 학습 데이터 대신 항상 최신 아키텍처 표준을 따릅니다.

### Google Antigravity

#### (1) Android Compose Preview
AI 에이전트에게 기존 View 코드를 Compose로 변환하고 대화면(폴더블·태블릿)에 맞게 최적화하도록 요청하면, 에이전트가 `@Preview` 어노테이션을 작성하고 Sidecar 패널에 프리뷰 화면을 즉시 렌더링합니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/08.png" %}

- 전체 앱 컴파일 및 기기 배포를 반복하지 않고, Sidecar 창에서 프리뷰 렌더링을 즉시 갱신
- 대화면에서 1열 스크롤 대신 헤더와 에피소드 목록을 좌우로 나누는 듀얼 창(Dual-pane) 레이아웃을 제안

#### (2) Android Device Hub
Antigravity 내에서 가상 기기(AVD) 및 물리 기기를 통합 관리하고 화면을 직접 미러링할 수 있습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/09.png" %}

- Pixel 10 Pro Fold 등 실제 연결된 기기 목록과 가상 기기(AI Glasses, Medium Phone, Small Phone 등)를 Sidecar 패널에서 통합 관리
- 미러링된 기기 화면을 보며 실시간 터치와 제스처로 상호작용 가능

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/09_split_screen.png" %}

- 화면 분할(Split Screen) 전환 시 앱이 싱글 페인(Single-pane)과 듀얼 페인(Dual-pane) 사이를 적응형(Adaptive)으로 올바르게 전환하는지 실시간 검증

### Android CLI 연동에 따른 에이전트 효율성 벤치마크

Claude Opus를 대상으로 6개 사용자 Journeys 및 6개 디바이스에서 메모리 누수를 찾고 수정하는 과제를 Android CLI 사용 여부에 따라 A/B 테스트한 결과입니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/10.png" %}

- 작업 완료 속도: 1.9배 향상 (88분 → 46분, 42분 단축)
- 토큰 사용량: 1.3배 절감 (4.6M 토큰 → 3.5M 토큰)
- Compose Preview: 전통적인 컴파일/실행 반복 대비 반복 시간 77% 단축
- Analyze 명령어: 다중 왕복 검사를 단일 구조화 명령어로 대체하여 출력 토큰 5.5배 절감
- Semantic Input: 화면 좌표 추정 환각(Hallucination)을 없애 작업 실행 속도 25% 향상

- - -

# 5. Android Studio와 AI 에이전트의 진화

## (1) Bring Your Own Agent (BYOA) via Agent Client Protocol (ACP)

Android Studio는 내장 Gemini 외에도, 개발자와 팀이 이미 사용 및 구독 중인 외부 에이전트를 IDE로 가져올 수 있는 BYOA 기능을 도입했습니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/11.png" %}

- 경로: `Settings > Tools > AI > Agents`
- Agent Client Protocol (ACP) 기반으로 다양한 에이전트 연결 지원:
  - Built-in Agent v2.0
  - Google Antigravity
  - Claude Agent (Claude Code / Anthropic API 연동)
  - OpenAI Codex
  - JetBrains Junie
  - ACP Agent Marketplace
- 기존 개인 구독이나 기업용 계정을 그대로 활용 가능

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/12.png" %}

연결된 에이전트(예: Claude Opus 5.5)는 Android Studio의 모든 도구 체인(파일 수정, 정적 분석, 빌드, Gradle 싱크, Compose 프리뷰 렌더링, 기기 배포, 공식 문서 조회)에 직접 접근할 수 있습니다.

## (2) AI Change Review

대량의 코드를 검토할 때 버그를 사전에 잡을 수 있도록 지원하는 코드 리뷰 기능입니다. 로컬 변경점뿐만 아니라 PR도 분석합니다.

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/13.png" %}

- 15개 파일, 800줄의 PR 변경점을 분석해 잠재적 버그를 사전에 감지
- 데모에서 발견된 실제 이슈:
  - 북마크 스와이프 행 컴포저블(SwipeRow.kt)에서 LaunchedEffect 키가 람다 객체로 설정되어 있어, 행이 Recomposition될 때마다 풀 스와이프 동작이 중복 실행되는 버그
  - 삭제 다이얼로그가 뜬 상태에서 북마크 삭제 확인 다이얼로그가 계속 중복 노출되는 문제
- 해결책 제시 및 일괄 반영: 원인을 설명하고 rememberUpdatedState를 적용한 코드 diff를 제공합니다. 체크박스로 선택한 이슈를 버튼 한 번으로 일괄 수정(Fix all selected issues) 가능
- 주제별 워크스루(`Walkthrough`): PR 내 변경 사항을 기능 단위로 묶어 코드 변경 내역을 확인하고 승인 가능

## (3) Android Studio Rabbit 릴리스 현황

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/14.png" %}

{% include img_assets.html id="/blog/ads26/whats-new-in-android-dev-tools/15.png" %}

# 관련 링크
- Watch Tools & Performance sessions: [goo.gle/ADS26-Tools-and-Perf](https://goo.gle/ADS26-Tools-and-Perf)
- Watch all sessions from Android Dev Summit 2026: [goo.gle/ADS26-All-Sessions](https://goo.gle/ADS26-All-Sessions)
- Android CLI 피드백: [d.android.com/cli](https://d.android.com/cli)
