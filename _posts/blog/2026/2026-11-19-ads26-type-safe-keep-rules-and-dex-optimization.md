---
layout: post
title: "[요약] Type safe keep rules and DEX optimization (Android Dev Summit '26)"
date: 2026-11-19 22:00:00 +09:00
tag: [Android, Performance]
categories:
- blog
- Android
- AndroidDevSummit
---

{% include youtube.html id="bwlRxGJMzWs" %}

<!--more-->

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - -

Android Dev Summit '26의 `Type safe keep rules and DEX optimization` 세션에서는 DEX 최적화의 필요성과 최신 도구들을 소개합니다.

# 1. DEX 최적화의 중요성과 Google Play 정책

오랫동안 DEX 최적화는 시간이 날 때 한 번 설정해 두고 잊어버리는 부가 작업으로 취급되곤 했습니다. 하지만 모바일 하드웨어 공급망 제약으로 기기의 메모리 가용성이 달라지면서, 잘 최적화된 DEX는 앱의 필수 요건이 되었습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/01.png" %}

최적화된 DEX는 앱이 메모리를 적게 사용하도록 하며, 다음과 같은 성능 이점을 제공합니다.

- 더 빠른 앱 시작 속도
- 더 가벼운 APK 크기
- ANR 감소 및 전반적인 런타임/렌더링 성능 향상

### Google Play 앱 품질 요구사항 (2월 시행)

Google Play는 건강한 Android 생태계를 유지하기 위해 2월부터 성능 임계치가 포함된 새로운 앱 품질 요구사항을 적용합니다.

> [Elevating app quality: Reducing memory usage and improving device migration](https://android-developers.googleblog.com/2026/08/app-quality-memory-optimization-secure-onboarding.html)

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/02.png" %}

앱은 DEX 코드 최적화에서 아래 세 가지 기준을 모두 넘겨야 합니다.

- Shrinking(코드 축소) : 25% 초과
- Optimization(최적화) : 25% 초과
- Obfuscation(난독화) : 25% 초과

최적화되지 않은 DEX 코드는 사용자 경험을 해칠 뿐만 아니라 Play Store에서의 앱 노출도와 배포 가능 여부에도 영향을 미칠 수 있습니다.

### R8 앱 옵티마이저의 효과

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/03.png" %}

`R8` : Google Play 요구사항을 충족하는 가장 권장 도구

다른 옵티마이저로 임계치를 넘길 수도 있지만, R8을 사용하면 Android 빌드 파이프라인 안에서 더 빠른 시작, 더 가벼운 APK, 향상된 런타임 성능을 얻을 수 있습니다.

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| {% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/04.png" %} | {% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/05.png" %} |

Grab은 R8 Full 모드를 도입하고 Keep 룰을 정밀하게 다듬어 높은 최적화 수치를 달성

- Grab R8 지표 : Optimization 78%, Shrinking 79%, Obfuscation 82%
- 실제 성능 개선 : 베이스라인 프로파일과 결합해 ANR 32% 감소, 앱 시작 속도 35% 단축

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/06.png" %}

상위 앱들이 R8을 처음 도입했을 때 평균적으로 나타나는 효과도 분명합니다.

- DEX 크기 평균 38% 감소
- 사용자 체감 ANR 평균 16% 감소

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/07.png" %}

이미 R8을 사용 중인 앱이라도 최적화, 축소, 난독화 수준을 50% 이상으로 끌어올리면 추가적인 성능 향상을 얻습니다.

- DEX 크기 평균 25% 추가 감소
- 앱 시작 시간 평균 4% 단축
- 사용자 체감 ANR 평균 17% 추가 감소 (기존 16% 감소에 더해진 수치)

### R8 구성의 어려움과 현황

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/08.png" %}

R8은 높은 수준의 최적화를 제공하지만, 리플렉션 호출처럼 입력을 예측하기 어려운 코드가 런타임 크래시로 이어질 수 있어 세심한 설정이 필요합니다. 이 때문에 과거 많은 앱 팀과 라이브러리 팀이 안전을 이유로 지나치게 넓은 와일드카드 Keep 룰을 추가해 왔습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/09.png" %}

현재 상위 앱의 41%는 Google Play 기준인 25% 미만에 머물러 있습니다. 반면 상위 앱의 13%는 다양한 산업군과 사용자 여정 속에서도 이미 기준치의 3배인 75% 이상의 최적화율을 달성하고 있습니다. 

앱 자체의 Keep 룰과 라이브러리에서 상속된 Keep 룰을 파악할 수 있는 도구만 있다면 높은 최적화 점수를 달성할 수 있습니다.

### 지난 1년간의 R8 주요 개선 사항

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/10.png" %}

R8 최적화를 더 쉽게 적용할 수 있도록 여러 기반 기능을 개선했습니다.

- 신규 앱 템플릿 `packageScope` 기본 포함 : 프로젝트 시작 시점부터 최소한의 최적화 수준 보장
- R8 Configuration Analyzer 확장 지원 : 구버전 AGP 지원 및 Bazel 비공식 지원 추가
- AGP 9.2 코루틴 프리미티브 2배 가속 : R8 내부 개선으로 코루틴 프리미티브 실행 속도 향상

> Tinder는 AGP 9.0.1에서 9.2로 업그레이드한 것만으로 R8 개선 효과를 얻어 ANR이 13% 감소

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/11.png" %}

AGP 9.3에서는 R8 설정 API도 새롭게 설계되었습니다. 

- isMinifyEnabled나 proguardFiles 대신 `optimization { enabled = true }` 형태로 직관적인 이름을 제공
- 기본 규칙과 리소스 축소를 별도로 지정하지 않아도 더 나은 기본값이 적용
- `src/main/keepRules/` 디렉토리에 둔 Keep 룰 파일을 자동으로 인식

- - -

# 2. R8 Configuration Analyzer와 최적화 병목 진단

DEX 최적화 조사를 시작할 때 가장 먼저 사용할 도구는 **R8 Configuration Analyzer**입니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/12.png" %}

R8 Configuration Analyzer는 앱의 R8 설정 정보를 시각화해 주는 HTML 리포트입니다. 

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/13.png" %}

리포트 상단에서는 다음 세 가지 지표를 측정합니다.

- Shrinking : 첫 번째 축소 패스 이후 Keep 룰에 의해 유지되지 않고 제거 가능한 클래스, 메서드, 필드 비율
- Optimization : 메서드 인라이닝과 클래스 병합 같은 전체 프로그램 최적화에 열려 있는 코드 비율
- Obfuscation : 더 짧은 식별자로 이름을 바꿀 수 있는 멤버 비율

R8 Configuration Analyzer는 최종 최적화와 DEX 컴파일 이전에 점수를 계산하므로 Play Console의 최종 DEX 측정치와 정확히 일치하지는 않습니다. 이는 개발 중 빠른 로컬 피드백 루프를 제공하기 위한 설계이며, Play Store 업로드 전 최적화 잠재력을 검증하는 데 충분합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/14.png" %}

메인 뷰의 Keep rule analysis 테이블에서는 각 Keep 룰을 클릭해 해당 룰이 유지하는 클래스, 메서드, 필드의 정확한 개수를 확인할 수 있습니다.

- 더 넓은 룰과 겹치는 하위 룰을 강조 표시하여 불필요한 넓은 룰 제거 유도
- 앱 안정성 위험 없이 즉시 삭제 가능한 미사용 룰 표시

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/15.png" %}

R8 Configuration Analyzer는 기존 R8 운영에서 겪던 세 가지 문제를 해결합니다.

- 레거시 룰 누적 해소 : 룰별 가시성이 없어 오래된 룰을 지우지 못하거나 더 넓은 와일드카드를 덧대던 관행 개선
- 라이브러리 룰 사각지대 발견 : SDK 추가 시 번들된 Keep 룰이 과도하게 넓은지, 시간이 자난 뒤에도 여전히 필요한지 판별
- 최적화 영향도 평가 : 특정 Keep 룰이 어느 정도의 클래스를 유지하는지 정량적으로 파악

### R8 도달성 분석과 와일드카드 Keep 룰의 영향

R8이 앱 모듈과 3개의 라이브러리(그중 라이브러리 3이 패키지 전체 Keep 룰을 가진 `analytics` 라이브러리)를 어떻게 처리하는지 단계별로 살펴봅니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/16.png" %}

1단계 초기 상태에서는 도달성 분석을 수행하기 전에 앱과 라이브러리의 모든 클래스(총 72개)를 불러옵니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/17.png" %}

2단계에서는 병합된 모든 Keep 룰과 AndroidManifest의 진입점으로부터 루트(노란색)를 식별합니다. 정상적이라면 매니페스트에 선언된 주요 진입점만 루트가 되어야 하지만, `analytics` 라이브러리의 와일드카드 Keep 룰 때문에 라이브러리 내 모든 클래스가 진입점으로 취급됩니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/18.png" %}

3단계에서는 식별된 루트로부터 호출 그래프와 멤버 참조를 따라가며 도달 가능성을 추적합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/19.png" %}

4단계에서는 루트에서 도달 가능한 클래스를 유지 대상(초록색)으로 분류합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/20.png" %}

5단계에서는 어디에서도 참조되지 않는 나머지 클래스를 데드 코드(빨간색)로 표시합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/21.png" %}

6단계에서는 트리 쉐이킹을 수행해 참조되지 않은 데드 코드를 제거합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/22.png" %}

7단계 첫 번째 축소 패스 이후 남은 결과에서 이 앱의 Shrinking 점수는 42.5%입니다. Google Play의 25% 기준은 넘겼지만, `analytics` 라이브러리의 패키지 단위 Keep 룰 때문에 남은 40개 클래스 중 23개가 유지되고 17개만 추가로 축소될 수 있습니다. 단 하나의 잘못된 Keep 룰이 앱 전체의 최적화 잠재력을 크게 떨어뜨립니다.

### 라이브러리 Keep 룰 문제와 실행 방법

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/23.png" %}

많은 라이브러리가 안정성을 이유로 과도하게 넓은 Keep 룰을 포함해 배포하거나, 앱 개발자가 직접 넓은 Keep 룰을 추가하도록 문서에 안내합니다. 하지만 넓은 Keep 룰은 안정성에 필요하지 않으며, 그 성능 비용은 온전히 앱 개발자가 부담하게 됩니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/24.png" %}

`-keep class com.example.analytics.bloat.** { *; }` 같은 패키지 전체 Keep 룰 하나가 라이브러리 전체를 유지시키면서 앱 최적화 점수를 크게 떨어뜨립니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/25.png" %}

Google 내부 SDK 역시 예외는 아니어서, 지난 1년간 12개 이상의 Google 라이브러리에서 과도하게 넓은 Keep 룰을 수정했습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/26.png" %}

R8 Configuration Analyzer는 AGP 9.3에 기본 통합되어 있으며, R8 버전을 올리면 구버전 AGP에서도 사용할 수 있습니다.

- 독립 실행 태스크 : `./gradlew :app:analyzeReleaseR8Configuration` 실행 (전체 릴리스 빌드보다 빠르게 HTML 리포트 생성)
- 전체 릴리스 빌드 시 자동 생성 경로 : `build/outputs/mapping/release/configanalyzer.html`

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/27.png" %}

WHOOP 팀은 R8 Configuration Analyzer를 실행한 뒤 Shrinking 74%, Obfuscation 74%에 비해 Optimization 점수가 0%로 나오는 것을 발견했습니다. 리포트를 통해 빌드가 최적화를 비활성화하는 레거시 ProGuard 파일을 사용하고 있음을 확인했고, 이를 최신 설정으로 전환해 Optimization 점수를 55%까지 끌어올렸습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/28.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/29.png" %}

WHOOP은 이 최적화와 커스텀 베이스라인 프로파일을 결합해 다음과 같은 성과를 거두었습니다.

- APK 크기 4% 감소
- 콜드 스타트 시간 38% 단축
- 과도한 프리징 프레임(Frozen frames) 28% 감소

### R8 Analyzer 스킬로 리포트 분석 자동화

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/30.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/31.png" %}

앱의 R8 설정 상태에 따라 HTML 리포트를 수동으로 일일이 검토하는 데 시간이 많이 들 수 있습니다. 이를 빠르게 처리할 수 있도록 Android CLI를 통해 **R8 Analyzer 스킬**을 제공합니다.

```bash
$ android skills list
$ android skills add r8-analyzer
```

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/32.png" %}

에이전트에게 R8 설정 분석을 요청하면 리포트를 생성하고 가장 영향력이 큰 Keep 룰을 짚어줍니다. 예시 출력에서는 Optimization 점수가 42.39%로 57.61%의 코드베이스가 최적화되지 못하고 있음을 요약하고, `-keep class com.example.analytics.bloat.** { *; }` 룰이 91,430개 항목(코드베이스의 22.29%)을 유지하고 있으므로 정밀한 룰로 개선하라고 권고합니다.

- - -

# 3. Jetpack Keep : 타입 안전한 자동 Keep 룰 생성

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/33.png" %}

과도하게 넓은 Keep 룰을 찾았더라도, 런타임 크래시를 유발하지 않으면서 안전하게 교체하는 일은 쉽지 않습니다. 근본 원인은 `리플렉션`에 있습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/34.png" %}

리플렉션을 사용하면 정적 호출이 런타임까지 지연됩니다. `Class.forName(className)`처럼 문자열로 전달된 클래스 이름은 빌드 시점에 R8이 추적할 수 없으므로 기본적으로 DEX 최적화가 깨집니다. 물론 직렬화나 의존성 주입처럼 코드젠 도구로 리플렉션을 완전히 없앨 수 있는 영역에서는 피하는 것이 최선이지만, 리플렉션이 여전히 필요한 경우도 존재합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/35.png" %}

`analytics-bloat` 라이브러리에 넓은 Keep 룰이 생긴 전형적인 리플렉션 사례는 세 가지입니다.

- 선택적 의존성(Optional dependency) : 라이브러리 클래스패스에 없는 타입을 문자열로 조회하여 리플렉션으로 생성하는 경우
- 서브클래스 동적 인스턴스화 : 매니페스트나 서버 응답 등에서 전달된 클래스 이름으로 서브클래스를 지연 생성하는 경우
- 리플렉션 기반 직렬화 : 객체의 모든 선언된 필드를 순회하며 JSON으로 직렬화하는 경우

이런 리플렉션 호출이 쌓이면 개발자 편의를 위해 패키지 전체를 유지하는 넓은 Keep 룰을 넣는 유혹에 빠지기 쉽습니다.

### 이상적인 수동 Keep 룰 작성의 한계

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/36.png" %}

`createEventFilter(className: String): EventFilter` 함수 하나를 위해 이상적인 Keep 룰을 직접 작성하려면 매우 복잡한 단계를 거쳐야 합니다.

1. Kotlin 파일이므로 문자열 기반의 EventFilterKt 클래스 이름을 정확히 기입
2. 반환 타입 자체가 아니라 서브클래스를 생성하므로 extends com.example.analytics.bloat.EventFilterKt 지정
3. 효율성을 위해 -keepclasseswithmembers와 사용 중인 기본 생성자 void <init>(); 명시
4. 추가 최적화를 막지 않도록 allowaccessmodification 옵션 추가
5. 라이브러리 소비자가 해당 함수를 호출할 때만 룰이 작동하도록 -if 조건부 룰 작성

이처럼 수동으로 좁은 Keep 룰을 작성하는 것은 읽고 쓰기 어렵고, 문자열 기반이라 하위 코드가 변경되면 쉽게 깨집니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/37.png" %}

대안으로 사용해 온 AndroidX의 `@Keep` 어노테이션 역시 한계가 있습니다. 

- 유지보수는 조금 쉬울지 몰라도 유연성이 떨어지며, 호출 지점 분석이나 `allowaccessmodification` 같은 최적화를 지원하지 못함
- 서브클래스를 대상으로 삼지못하므로 모든 서브클래스에 일일이 `@Keep`을 붙여야 함

두 방식 모두 누락하기 쉽고, 문제를 뒤늦게 발견하며, 호출자 조건부로 동작하지 않고, 실제 리플렉션 코드와 떨어진 곳에 위치한다는 단점이 있습니다.

### Jetpack Keep 소개 및 동작 방식

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/38.png" %}

이 문제를 해결하기 위해 AndroidX에서 `Jetpack Keep(Alpha)` 라이브러리와 Gradle 플러그인을 새로 선보였습니다. Jetpack Keep의 목표는 두 가지입니다.

- 어노테이션으로부터 정밀한 Keep 룰 자동 생성
- 코드베이스 내 리플렉션 코드를 분석해 어노테이션 자체를 자동 생성

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/39.png" %}

설정은 앱이나 라이브러리 모듈의 `build.gradle.kts`에 플러그인과 의존성을 추가하면 됩니다.

```kotlin
plugins {
    id("com.android.library")
    id("androidx.annotation.keep")
}

dependencies {
    implementation("androidx.annotation.keep:keep")
}
```

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/40.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/41.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/42.png" %}

서브클래스를 동적으로 생성하는 createEventFilter 함수에 대해 `./gradlew :analyticsbloat:lintFix`를 실행하면, Lint가 메서드 내부의 리플렉션을 분석해 `@UsesReflectionToConstruct` 어노테이션을 자동으로 추가합니다.

```kotlin
@UsesReflectionToConstruct(
    classConstant = EventFilter::class,
    parameterTypes = []
)
fun createEventFilter(className: String): EventFilter { ... }
```

어노테이션이 문자열이 아닌 `EventFilter::class` 클래스 상수와 생성자 파라미터 타입을 직접 참조하므로 타입 안전성이 보장됩니다. 빌드 시점에는 이 어노테이션을 바탕으로 `-if` 조건문과 `allowaccessmodification`까지 포함된 이상적인 Keep 룰이 자동 생성됩니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/43.png" %}

클래스패스에 없는 선택적 의존성 사례에서도 `className`만 문자열로 지정하고 `parameterTypes = [Context::class]`처럼 파라미터 타입은 클래스 참조로 유지해 동일한 수준의 조건부 Keep 룰을 생성합니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/44.png" %}

필드 전체를 순회하는 직렬화 코드에서는 `@UsesReflectionToAccessField` 어노테이션과 `fieldName = "*"` 와일드카드를 생성하여 해당 모델 클래스의 필드만 정확히 유지하는 Keep 룰을 만들어 줍니다.

### Jetpack Keep의 장점과 지원 범위

Jetpack Keep을 도입하면 Keep 룰을 직접 관리할 부담을 대폭 줄일 수 있으며, Lint의 결정론적 검사를 통해 마이그레이션 이후에도 코드 변경 시 새로운 리플렉션을 즉시 잡아냅니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/45.png" %}

- 요구사항 : 플러그인과 Lint는 AGP 8.7 이상 필요
- 적용 대상 : 앱, Android 라이브러리(AAR), KMP 라이브러리, JAR 빌드(수동 연결 필요) 지원
- 하위 호환성 : 라이브러리 개발자가 사용하더라도 표준 컨슈머 규칙(`consumerProguardFiles`) 형태로 내보내므로 구버전 R8이나 서드파티 도구를 쓰는 소비자 앱에서도 안전하게 동작

- - -

# 4. Android CLI `analyze`: 최종 배포 전 로컬 검증

마지막 단계로 릴리스 직전 빌드 산출물의 최적화 상태를 점검할 수 있는 **Android CLI**의 `analyze` 명령이 새롭게 추가되었습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/46.png" %}

기존에는 Play Console에 앱 번들을 업로드해야만 최종 DEX 크기와 최적화 비율을 확인할 수 있었지만, 이제는 Play Store와 동일한 분석 로직을 로컬 CLI에서 바로 실행할 수 있습니다.

```bash
$ android analyze <mybundle.aab>
$ android analyze <mybundle.apk>
```

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/47.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/48.png" %}

`android analyze`를 앱 번들(AAB)이나 APK에 실행하면 Play Store가 실제로 적용하는 기준에 따라 비압축 DEX 크기(15.45 MB), R8 메타데이터, `shrinking=23.06%`, `optimization=23.51%`, `obfuscation=23.22%` 같은 수치를 출력하고, 25% 미만일 경우 경고를 표시합니다. JSON 출력 형식도 지원하므로 CI 스크립트에 통합해 최적화 지표가 급격히 떨어지는 회귀를 자동으로 차단할 수 있습니다.

### 라이브러리(AAR, JAR) 품질 분석

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/49.png" %}

`android analyze`는 앱뿐만 아니라 라이브러리(AAR, JAR)도 단독으로 분석할 수 있습니다.

```bash
$ android analyze <library.aar>
$ android analyze <library.jar>
```

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/50.png" %}

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/51.png" %}

이론적으로 외부 참조가 없는 라이브러리를 단독으로 R8 최적화하면 유지되는 코드가 없어 0바이트에 가까워야 합니다. 예시 라이브러리 분석 결과에서는 D8 기준 DEX 크기 `4.31 MB` 대비 R8 최적화 후에도 `3.12 MB`가 남아 `Keep Ratio: 72.22%`를 기록했으며, 패키지 전체 Keep 룰과 라이브러리 외부(다른 라이브러리)까지 영향을 주는 위험한 Keep 룰을 경고로 짚어냅니다. 라이브러리 분석 역시 JSON 출력을 지원하므로 라이브러리 배포 전 품질 게이트나 앱의 라이브러리 업데이트 검증 스크립트에 활용할 수 있습니다.

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/52.png" %}

만약 사용 중인 서드파티 라이브러리에서 Keep 룰 문제를 발견했다면 다음 순서로 대응하는 것이 좋습니다.

1. 라이브러리 최신 버전으로 업데이트 확인 (이미 수정된 릴리스가 있을 수 있음)
2. 기존 이슈가 등록되어 있는지 검색
3. `android analyze` 리포트를 첨부해 라이브러리 개발자에게 Keep 룰 개선 요청

- - -

# 5. 요약 및 참고 자료

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/53.png" %}

이번 세션에서 다룬 DEX 최적화 핵심 도구 세 가지는 다음과 같습니다.

- R8 Configuration Analyzer : R8 빌드에서 최적화 가능 영역과 병목 Keep 룰 분석
- Jetpack Keep : 리플렉션 코드 기반 어노테이션 자동 추가 및 조건부 Keep 룰 자동 생성
- Android CLI (`analyze`) : 최종 AAB, APK, AAR, JAR의 최적화 지표 로컬 검증 및 CI 회귀 방지

{% include img_assets.html id="/blog/ads26/type-safe-keep-rules-and-dex-optimization/54.png" %}

- R8 공식 문서 : [goo.gle/android-r8](https://goo.gle/android-r8)
- R8 Configuration Analyzer 가이드 : [goo.gle/r8-analyzer](https://goo.gle/r8-analyzer)
- Jetpack Keep 문서 : [goo.gle/jetpack-keep](https://goo.gle/jetpack-keep)
- Android CLI 문서 : [goo.gle/android-cli](https://goo.gle/android-cli)
