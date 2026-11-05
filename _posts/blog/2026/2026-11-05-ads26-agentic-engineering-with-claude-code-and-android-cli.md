---
layout: post
title: "[요약] Agentic engineering with Claude Code and Android CLI (Android Dev Summit '26)"
date: 2026-11-05 23:00:00 +09:00
tag: [Android, AI, Agent, AndroidCLI]
categories:
- blog
- Android
- AndroidDevSummit
---

{% include youtube.html id="Mb9H43ia0kE" %}

<!--more-->

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - -

# 1. 에이전틱 엔지니어링 패러다임과 개발자의 새로운 역할

안드로이드 개발자 관계팀(DevRel)의 Ben Trengrove와 안드로이드 스튜디오 제품 매니저(PM) Stephen Jenkins는 Claude Code와 Android CLI를 활용하여 자율 에이전트 기반으로 앱을 개발하는 방법과 엔지니어링 접근법을 공유했습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/01.png" %}

발표자들은 AI 생태계의 변화 속도가 너무 빨라 발표 내용 중 일부는 시청 시점에 이미 구식이 되었을 수도 있다고 솔직히 언급했습니다. 따라서 발표 내용은 미래를 내다보는 전향적인 관점을 담되, 세션에서 선보이는 데모들은 현재 시점에서도 안정적으로 재현되도록 현실적인 기반 위에서 구성했습니다. 또한 Claude Code를 대표적인 예시로 사용하지만, 제시하는 원칙들은 특정 도구에 얽매이지 않고 모든 에이전트 하네스에 공통으로 적용되는 개발자의 사고방식(Mindset)입니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/02.png" %}

개발자의 역할은 자율 에이전트(Autonomous Agents) 팀을 지휘하고 이들이 성공할 수 있는 환경을 조성하는 방향으로 전환되고 있습니다. 에이전트가 특정 기능 구현에 실패했을 때 "AI는 아직 이것을 못한다"라며 작업을 포기하는 대신, 일반 소프트웨어 버그를 다루듯 "에이전트에게 어떤 정보가 누락되었는가?"를 되돌아보고 원인을 분석해야 합니다. 실제로 Claude Code, Codex, Antigravity 등을 만드는 엔지니어링 팀들도 자체 도구를 바로 이러한 방식으로 개발하고 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/03.png" %}

안드로이드 빌더로서 지금보다 흥미진진한 시기는 없지만, 한편으로는 어디에 집중해야 할지 갈피를 잡기 어려울 수 있습니다. 핵심은 새로운 프론티어 모델이 출시될 때마다 지금까지 들인 노력이 헛수고(Redundant)가 되지 않도록 방지하는 데 있습니다. 모델의 발전과 함께 지능적으로 확장되는(Scale with intelligence) 도구와 워크플로우를 갖추어야 모델의 개선이 에이전트 워크플로우의 고도화로 이어지고, 궁극적으로 최종 사용자에게 더 나은 결과(Better outcomes)를 제공하는 미래 대비(Future-proof) 체계가 완성됩니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/04.png" %}

본 세션에서 다루는 네 가지 핵심 아젠다
- 01 환경(Environment) : 에이전트가 스스로 성공할 수 있도록 지원하는 작업 환경 조성의 중요성 설명
- 02 컨텍스트(Context) : 모델의 추론 능력을 극대화하기 위한 컨텍스트 개요 및 최적의 관리 방법 제시
- 03 도구(Tools) : 에이전트 내부에서 안드로이드 개발자가 활용할 수 있는 최상의 도구 체계 소개
- 04 루프(Loops) : 에이전틱 워크플로우에 자체 검증 루프를 추가해야 하는 당위성과 실증 근거 제시

- - -

# 2. 에이전트 성공을 위한 환경(Environment) 구축

환경 구축이란 개발자가 화면 앞에 계속 앉아 프롬프트를 다시 입력하고 궤도를 수정해 줄 필요 없이, 에이전트가 자율적으로 작업을 완수할 수 있는 공간을 만드는 것을 의미합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/05.png" %}

개발자의 상시 개입이 필요 없는 환경이 갖추어질 때 비로소 병렬 에이전트(Parallel agents) 운용이 가능해집니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/06.png" %}

여러 에이전트 팀이 개발자를 대신해 동시에 작업을 처리할 수 있을 때 비로소 진정한 생산성 혁신이 일어납니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/07.png" %}

에이전트 환경에 필수적으로 개방해야 하는 정보 자산
- 코드 및 프로젝트 명세 : 프로젝트 아키텍처 규칙과 작업 명세서 제공 (가장 기본적인 요구사항)
- 팀 협업 맥락(Team Context) : 메신저 대화방 연동을 통한 의사결정 배경 전달, 과거 의사결정 이력(ADR) 및 PR 리뷰 코멘트 열람 지원
- 실행 및 디버깅 도구 : 실기기 및 에뮬레이터 접근 권한 (기기 없이 안드로이드 개발을 할 수 없듯 에이전트에게도 필수), 성능 프로파일러, 앱이 사용하는 백엔드 서비스 연동 통로

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/08.png" %}

### Android CLI의 역할
- 안드로이드의 다양한 SDK 도구를 터미널에서 제어하기 위한 새로운 명령줄 인터페이스(CLI)
- AI 제품 자체가 아닌 범용 CLI로 동작하여 SDK 매니저 제어, 에뮬레이터 구동, Crashlytics 백엔드 연결 지원
- 로컬 셸 환경에 상주하므로 개발자가 사용하는 모든 에이전트 하네스에서 호출 가능

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/09.png" %}

공식 링크(`goo.gle/android-cli`)를 통해 설치할 수 있으며, 터미널에서 `android init`을 실행하여 즉시 활성화할 수 있습니다.

- - -

# 3. 실전 사례 1 : Android CLI를 통한 크래시 및 ANR 해결

환경 구축의 중요성을 증명하기 위해 자체 제작한 상용 프로덕션 앱 'Sideline'을 실증 예시로 소개했습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/10.png" %}

Android CLI를 활용하여 실제 프로덕션 환경의 크래시를 해결하는 과정을 시연했습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/11.png" %}

Sideline은 테니스 선수를 위한 안드로이드 앱으로, 공과 선수의 위치를 실시간 분석하고 비디오 리플레이 기반 오프라인 코칭 피드백과 타구 속도, 이동 거리, 랠리 횟수 등의 운동 데이터를 제공합니다. 모든 분석은 기기 내에서 직접 실행되는 커스텀 TFLite 모델을 통해 온디바이스로 구동됩니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/12.png" %}

### Crashlytics 연동과 ANR 발견
발표팀은 "존재하는지조차 모르는 문제는 해결할 수 없다"고 강조했습니다. Android CLI를 통해 개발 환경에 Firebase Crashlytics를 연동하자, 로컬 에뮬레이터에서는 전혀 재현되지 않던 Pixel 11 Pro Fold 단말 전용의 ANR(Application Not Responding) 결함이 발견되었습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/13.png" %}

결함 해결 및 검증 프로세스
- Android Device Streaming 연동 : 개발자가 해당 폴더블 기기를 보유하지 않은 상태에서, 에이전트가 클라우드의 원격 Pixel 11 Pro Fold 기기에 연결하여 49초 시점에 발생하는 ANR 재현
- 원인 분석 : Android 17 환경에서 CPU 친화도(Affinity) 호출 거부가 원인임을 확인
- 2줄 코드 수정 : OpenMP 및 스레드 친화도 환경 변수를 안전하게 재설정하여 해결
- 원격 검증 : 동일한 원격 단말에서 270초 무중단 실행 확인 후 PR 생성, 병합, Play Console 배포까지 자동 완결

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/14.png" %}

배포된 1.0 빌드에서 Crashlytics 콘솔을 통해 해당 결함이 완전히 해결되었음을 확인했습니다. 개발 환경에 적절한 도구와 권한을 주지 않았다면 문제 발견과 검증 자체가 불가능했을 것이라고 설명했습니다.

- - -

# 4. 컨텍스트(Context) 관리와 150k 토큰의 법칙

약 1년 반에서 2년 전 AI 업계에서는 더 큰 컨텍스트 윈도우를 확보하기 위한 경쟁이 치열했습니다. 당시에는 모델에 최대한 많은 정보를 넣으면 더 좋은 결과가 나올 것이라는 기대로 공식 개발자 문서(developer.android.com) 전체를 프롬프트에 넣는 시도까지 있었으나 효과가 없었습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/15.png" %}

컨텍스트 윈도우 크기는 대략 100만(1M) 토큰 선에서 정체(Plateau)되었지만, 모델의 코딩 추론 능력은 계속해서 가파르게 상승하고 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/16.png" %}

실제 개발 현장의 안드로이드 구현 과제를 평가하는 Android Bench 1.0 벤치마크 결과, 100만 토큰 환경에서 모델의 코드 작성 성공률은 지속적으로 향상되었습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/17.png" %}

### 컨텍스트 부패(Context Rot)와 15만 토큰 한계선
컨텍스트는 여전히 엄격한 고정 예산(Fixed budget)입니다. 당면한 문제와 직접 관련이 없는 정보를 넣으면 모델의 주의 집중력이 흐려집니다. 많은 에이전트 하네스들이 100만 토큰 전체를 사용자에게 노출하지 않는 이유도 무작정 토큰을 늘리면 결과가 나빠지기 때문입니다. 

모델에 따라 다르지만, 단일 대화 세션을 약 15만 토큰(150k) 이내로 유지할 때 컨텍스트 손실 없이 모델의 최고 성능을 온전히 활용할 수 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/18.png" %}

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/19.png" %}

컨텍스트의 내부 구성 요소

- 시스템 지침(System Instruction) : 에이전트의 동작 방식 및 기본 행동 수칙 규정
- 작업 공간 및 메타데이터 : 현재 작업 디렉토리, 설치된 SDK 정보
- 설치된 스킬 및 MCP 도구 스키마 : 모델이 호출 가능한 도구 목록 (상시 컨텍스트 소모)
- 전체 대화 및 도구 호출 이력 : 프롬프트 전송 시마다 누적되는 메시지 기록 (가장 큰 비중 차지)

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/20.png" %}

### 장황한 Gradle 로그의 위험성

Gradle 빌드 로그는 매우 길고 상세하지만 대부분은 문제 해결에 불필요한 노이즈입니다. 따라서 Gradle 실행 시 quiet 모드(`./gradlew assembleDebug --quiet`)를 활용하는 것을 추천한다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/21.png" %}

### 150k 세션 워크플로우

15만 토큰이라는 마법의 창을 넘기지 않기 위해 Matt Pocock이 고안한 워크플로우 Skill을 소개했습니다:

1. 역질문 정렬(`/grill-me`) : 프로젝트나 기능을 시작할 때 실행. 에이전트가 개발자에게 세부 구현 방식과 위치 등을 역으로 질문하여 머릿속의 모호성을 제거하고 이슈로 구체화
2. 명세서 작성(`/write-a-prd`) : 대형 스펙 문서를 작성하여 요구사항 영속화
3. 이슈 슬라이싱 : 각 이슈가 약 15만 토큰 내에서 완료될 수 있는 크기로 이슈 분할 및 등록
4. 이슈당 1세션 실행 후 초기화 : 터미널이나 IDE에서 1개 이슈 처리 → 빌드 및 검증 통과 → 세션 종료 및 컨텍스트 초기화(`/clear`) 반복

- - -

# 5. AGENTS.md 운영 규칙과 실제 저장소 구조

`AGENTS.md`는 프로젝트나 작업 공간 전체에서 에이전트가 수행하는 모든 프롬프트에 상시 포함되는 설정 파일입니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/22.png" %}

### AGENTS.md 운영 가이드라인
- 상시 적용되는 규칙만 수록 : 아키텍처 및 모듈 규칙(특히 비공개 소스 프로젝트의 경우 모델이 사전 학습할 수 없으므로 기능의 소속 위치를 지정하여 추론 비용 절감)
- 빈번한 코드 리뷰 실수 방지 : 팀에서 반복 지적되는 규칙 명시 (예: `kotlinx.datetime` 선호)
- 모델 세대별 프롬프트 대응 : Opus 4.6 시절에는 대문자로 "NEVER DO THIS"를 썼으나, Opus 5에서는 소문자 평문이 더 효과적이라는 Anthropic의 발표처럼 모델 특성에 맞춰 지속 관리 필요
- 문서 길이 250줄 이내 제한 : 과도한 사전 주입으로 인한 토큰 낭비 방지
- 에이전트의 파일 자동 수정 금지(arxiv:2602.11988) : 에이전트에게 `AGENTS.md`를 스스로 수정하게 하면 작업 성능이 2~3% 하락하고 비용이 20% 증가한다는 2026년 2월 연구 결과 제시. 대신 PR 완료 후 회고(Retrospective) 문서만 작성하게 하고 팀이 검토 후 수동 반영 권장

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/23.png" %}

### 실제 Sideline 저장소의 AGENTS.md 구조
앱에 실제 적용된 `AGENTS.md`를 화면에 공유하며 두 가지 핵심을 강조했습니다
- 명확한 아키텍처 정의 : 모듈 구조와 의존성 흐름을 명문화하면 에이전트가 코드베이스 전체를 불필요하게 뒤지는 동작을 방지하여 토큰과 컨텍스트 절약
- 비공개 소스(Closed-source) 앱 관리 : 외부 모델이 해당 코드를 학습한 적이 없으므로, `AGENTS.md`를 지속적으로 정제하고 개선하는 작업이 장기적인 생산성 향상의 핵심

- - -

# 6. 도구 및 Skill(Tools & Levers) 생태계

`AGENTS.md`에 모든 지침을 넣을 수 없다면, 훅(Hooks)과 Skill을 통해 에이전트의 행동을 제어해야 합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/25.png" %}

### 훅(Hooks)
`AGENTS.md`에 "코드를 작성한 후 항상 Lint를 돌려라"라고 적는 대신, 세션 종료(`Stop`) 훅에 셸 스크립트를 등록하면 AI의 확률적 무작위성을 제어하고 결정론적 검증을 강제할 수 있습니다.

에이전트가 지원하는 주요 라이프사이클 이벤트

- 세션 시작(Start) 및 세션 종료(Stop) 이벤트
- 파일 읽기(Read) 및 파일 쓰기(Write) 차단 : 비밀키 파일이 서버로 전송되는 것을 원천 차단하거나 `AGENTS.md`의 무단 수정을 방지하는 용도로 활용

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/26.png" %}

### Skills
`AGENTS.md`가 모든 요청에 상시 적용된다면, Skill은 특정 상황에서만 필요한 대용량 문서나 도구를 제공합니다. 

Skills의 3요소

- Name  Skill 식별자
- Description : 최대 1,024자 제한. 스킬이 필요한 시점을 모델이 판단할 수 있도록 컨텍스트에 상시 로드
- Body : 대용량 문서, API 레퍼런스, 실행 스크립트 포함. 스킬이 실제로 호출될 때만 임시 로드

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/27.png" %}

Android CLI 스킬의 설명문(Description)에서는 해당 도구가 언제 필요한지 간결하게 기술되어 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/28.png" %}

Skills의 본문(Body)은 화면을 가득 채울 정도로 방대합니다. 이처럼 거대한 본문을 평소에는 제외하고, 필요한 순간에만 선택적으로 로드할 수 있게 해줍니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/29.png" %}

### 무차별적인 스킬 설치의 위험성
인터넷에서 공유되는 100여 개의 에이전틱 스킬 모음집을 무분별하게 설치하면 안 됩니다
- 보안 위험 : 스킬 내부에 악의적인 명령어가 숨겨져 있을 위험 (구글 공식 안드로이드 스킬은 검증을 거침)
- 컨텍스트 잠식 : 스킬 100개의 설명문(100 × 1,000자)만으로 작업을 시작하기도 전에 10만 자의 컨텍스트를 소모
- 권장 방식 : 기본 `android-cli` 스킬만 설치하고 필요 시 탐색하여 추가하거나, Compose나 edge-to-edge처럼 보편적인 스킬만 선별 설치
- 스킬 감사 : Claude Code의 `skill-doctor` 또는 하네스의 통계 화면을 활용하여 한 번도 활성화되지 않은 잉여 스킬 제거

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/30.png" %}

- `android skills list` : 사용 가능한 스킬 목록을 확인
- `android skills add navigation-3` : 필요한 스킬만 명시적으로 추가

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/31.png" %}

### Android CLI를 CLI 형태로 구현한 이유
CLI는 속도가 빠르고 결합성(Composable)이 뛰어나며 로컬 셸에서 실행되어 비용이 들지 않습니다. 또한 최신 LLM 제조사들이 소프트웨어 엔지니어링 벤치마크 중 가장 중요한 Terminal Bench 점수를 올리기 위해 집중적으로 학습시켰기 때문에, 최신 모델들은 셸 명령어 호출에 대단히 능숙합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/32.png" %}

### 로컬 CLI vs MCP(Model Context Protocol) 역할 분담
- MCP : GitHub, Figma, Slack 등 이미 원격에 배포된 외부 호스팅 서비스와의 연결에 최적 (별도 설치 없이 추가 컨텍스트 확보)
- CLI + Skills : Android CLI, Perfetto, Gradle 등 개발 머신의 모든 리소스에 접근해야 하는 작업은 로컬 셸에서 실행하는 것이 가장 효율적

- - -

# 7. 실전 사례 2 : Perfetto 트레이스와 Performance Hint API를 통한 성능 튜닝

과거에는 성능 분석 도구인 Perfetto의 학습 곡선이 너무 가팔라 활용이 쉽지 않았으나, AI를 결합하면 이 과정을 대폭 단순화할 수 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/34.png" %}

Sideline 앱이 정상 동작하려면 실시간 30 FPS를 유지해야 하지만, Pixel 10 Pro Fold 기기에서 카메라 라이브 프리뷰 구동 시 20~22 FPS로 떨어지며 프레임 드롭이 발생했습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/35.png" %}

Claude Code에 30 FPS 요구사항을 부여했을 때 나타난 두 가지 핵심 동작
1. `android profiler`를 통한 트레이스 수집 : 연결된 Pixel 10 Pro Fold에서 시스템 트레이스를 기록하고, AI 비전 스레드가 단말의 가장 느린 저전력 코어(Slowest cores)에서 실행 중임을 발견
2. 공식 문서 자율 검색 및 해결 : 명시적으로 지시하지 않았음에도 에이전트가 안드로이드 공식 문서를 검색하여 **Performance Hint API** 가이드라인을 참조하고 시스템 스케줄러 우선순위를 조정하는 코드 작성

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/36.png" %}

수정 후 동일 기기에서 라이브 카메라 프리뷰가 안정적인 30 FPS를 달성함을 검증했습니다. 개발자가 도구의 사용법을 완벽히 숙지하지 못했더라도 Android CLI를 통해 적절한 도구를 찾아 문제를 해결할 수 있음을 증명했습니다.

- - -

# 8. 검증 루프(Loops)와 완료(Done)의 기준 정의

에이전트에게 큰 작업을 요청했을 때 **완료했다**는 보고만 믿고, 개발자가 직접 폰을 조작하며 버그를 찾아 타이핑하는 행위는 **개발자를 단순 QA 테스터로 전락시키는 일**이며 반드시 멈추어야 합니다.

작업을 시작하기 전 무엇이 `완료(Done)`인지 사전에 명확히 정의해야 합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/38.png" %}

수동 QA를 대신하는 악순환을 끊고 사전 완료 기준을 제시해야 합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/39.png" %}

예를 들어 프로젝트 전체를 최신 `androidx.navigation3`로 마이그레이션하라는 작업을 부여할 수 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/40.png" %}

### 수동 검증의 함정과 검증 루프의 필요성
에이전트는 자신만만하게 "마이그레이션이 완료되었습니다"라고 보고하지만, 스마트폰을 회전하면 앱이 비정상 종료되고 화면 전환 애니메이션이 누락되며 기존 Gradle 의존성도 정리되지 않은 상태였습니다. 사전에 완료 기준을 제시하고 그 기준을 통과할 때까지 에이전트가 자체적으로 반복 실행하도록 만드는 체계가 바로 **검증 루프(Verification loop)**입니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/41.png" %}

### Android Bench 2.0 공식 데이터
새롭게 공개된 Android Bench 2.0의 현재 평균 통과율은 약 40% 수준이며, Navigation 2에서 3으로의 마이그레이션과 같은 실제적인 고난도 과제들이 포함되어 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/42.png" %}

Claude Fable 5.1 모델을 대상으로 동일한 Navigation 마이그레이션 과제를 수행한 결과
- 자연어 프롬프트만 제공 : 성공률 22%
- 사전에 실패하는 테스트 스위트(Failing Test Suite)만 제공 : 성공률 **90%**

최신 모델들은 대부분의 안드로이드 구현 능력을 갖추고 있으나 "무엇이 완료인지"를 모를 뿐입니다. 실패하는 테스트 스위트를 제공하면 통과할 때까지 코드를 수정하며 성공률을 극대화합니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/43.png" %}

### 실무 적용 방안과 verify 스킬
사전에 전체 테스트 스위트를 작성하지 않더라도 검증 루프를 간단히 구축할 수 있습니다
- UI 작업 : Compose 프리뷰를 렌더링하여 Figma 스펙과 일치하는지 시각적 결과를 직접 제시하도록 요구 ("완료했습니다"라는 텍스트 응답 대신 실제 결과물을 증명하게 하는 방식이 훨씬 효과적)
- 비즈니스 로직 : 단위 테스트 실행 및 통과 요구
- 크래시 결함 : 원격 테스트 랩을 통해 실제 단말에서 결함 해결 검증
- Claude Code 내장 `verify` 스킬을 활용하여 이러한 검증 루프를 즉시 구성 가능

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/44.png" %}

### Android Studio MCP 검증 도구
Android Studio는 에이전트가 검증 루프를 구축할 수 있도록 다양한 도구가 있습니다
- Lint : 모든 린트 오류가 0개가 될 때까지 세션을 멈추지 않도록 강제
- Journeys : 프롬프트 형태로 작성된 기능 시나리오가 모두 통과할 때까지 완료 선언 방지

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/45.png" %}

### 다층 검증 루프(Tiered Verification) 전략
Journeys나 원격 테스트는 실행에 시간이 걸리므로 검증 단계를 계층화해야 합니다

- 1단계 : 단위 테스트 및 Compose 프리뷰 렌더링 (초 단위 빠른 피드백)
- 2단계 : 에뮬레이터 연결 테스트 및 Android Journeys 검증
- 3단계 : 수 시간이 소요되는 원격 디바이스 테스트 랩 전체 스위트 실행

모델은 지나치게 낙관적이어서 한 번에 모든 테스트를 통과할 것이라 착각하므로, 빠른 1단계를 통과한 후에만 다음 단계로 넘어가도록 루프를 계층화해야 합니다.

- - -

# 9. 실전 사례 3 : XR 안경 확장 및 자가 치유(Self-healing) 루프

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/47.png" %}

실제 Sideline 앱을 XR Glasses 폼팩터로 확장하는 작업에 다층 검증 루프를 적용했습니다.

실제 하드웨어가 없으므로 XR 에뮬레이터를 사용하고, 에이전트에게 3단계 루프를 강제했습니다.
- 1단계 JVM 단위 테스트 : 초 단위로 반복 실행하여 6개 Compose 프리뷰 상태 정의
- 2단계 Compose 프리뷰 : UI 오버플로 문제를 에뮬레이터를 띄우기도 전에 조기 발견 및 수정
- 3단계 XR 에뮬레이터 : 단위 테스트와 프리뷰에서 잡지 못한 XR 디스플레이 전용 렌더링 버그 4건을 최종 발견 및 해결

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/48.png" %}

그 결과 선수가 경기 중 공에서 시선을 떼지 않고도 스윙 종류와 타구 속도를 실시간 피드백 받을 수 있는 "SERVE 73 MPH" 형태의 헤드업 디스플레이를 구현했습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/49.png" %}

### 스케줄러 기반 자가 치유(Self-healing) 파이프라인
Claude Code의 `/schedule` 명령어를 활용하여 주기적인 자가 치유 파이프라인을 구축할 수 있습니다
- Firebase Crashlytics에서 신규 결함 자동 수집
- 원격 실기기에서 버그 재현 및 수정 코드 작성
- 테스트 스위트 검증 완료 후 엔지니어가 검토 및 병합할 수 있는 Pull Request 자동 등록

- - -

# 10. 결론 및 권고사항

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/50.png" %}

에이전틱 엔지니어링의 핵심은 에이전트가 성공할 수 있는 환경을 만들고, 일반 소프트웨어 개발 및 버그를 다루듯 체계적으로 접근하여 병렬 에이전트를 운용하는 데 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/51.png" %}

온라인에는 상충되는 수많은 조언들이 넘쳐납니다. 이를 극복하는 최선의 방법은 **프로젝트 자체의 평가 벤치마크(Evals)**를 직접 작성하는 것입니다. 새로운 조언이나 새 모델이 나왔을 때 실제 생산성에 도움이 되는지 자체 벤치마크로 측정해야 하며, Claude Code의 `/claude-api build-eval` 스킬을 활용할 수 있습니다.

{% include img_assets.html id="/blog/ads26/agentic-engineering-with-claude-code-and-android-cli/52.png" %}

Android Dev Summit의 관련 세션으로 구글의 공식 벤치마크 구축 경험을 다룬 **Android Bench 세션**과, 실무 현장의 안드로이드 개발자들이 참여하는 **미국 및 런던 패널 토론 세션** 시청을 추천합니다.
