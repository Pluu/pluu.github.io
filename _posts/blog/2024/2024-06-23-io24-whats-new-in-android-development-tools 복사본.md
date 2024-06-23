---
layout: post
title: "[요약] Designing scalable Compose APIs (Google I/O '24)"
date: 2024-06-23 15:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io24
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/JvbyGcqdWBA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

# Introduction

Composable 함수 작성시에 중요한 사항

- 뛰어난 확장성
- 보다 직관적
- 더 나은 방향으로 안내

관용적인 Compose API 개발

- Component에 대해 생각하고 계획하는 방법
- Kotlin 및 명명 규칙을 활용하고 API의 견고한 구조를 정의하는 방법
- API를 검증하고 유지 관리하는 방법

> 세션에서 다루는 가이드라인은 
>
> - 프레임워크 : 엄격한 규칙
> - 라이브러리 : 가능한 가이드라인을 따르는 것을 권장
> - 앱 개발 : 가이드라인을 권장 고려

# Creating a new API

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/01.png" %}

새 API를 만드는 방법

1. 이 API가 하나의 문제를 해결하기 위한 것인지부터 고려
2. 제한된 선택지로 사용자에게 간단한 옵션을 제공하는 컴포넌트 생성 (FilterChip)

> 하나의 컴포넌트, 하나의 문제를 한 곳에서 해결

suggestions/quick actions과 같은 기능이 추가로 필요한 경우, 다른 목적을 가진 FilterChip 변형 버전이 필요해진다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/02.png" %}

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/03.png" %}

|              FilterChip에 더 많은 옵션을 넣기?               |                완전 별개의 컴포넌트로 만들기?                |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/04.png" %} | {% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/05.png" %} |

앱 디자인에 일관된 요구 사항이 있지만, 다소 유사한 컴포넌트의 변형에 대한 요구 사항이 있다면 새로운 컴포넌트를 레이어 위에 구축하는 것이 좋다.

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/06.png" %}

계층화된 상위 수준의 API는 더 많은 제약이 따르며 특정 동작과 기본값을 제공하고 커스텀 옵션이 더 적다. 레이어는 일반 Chip과 같이 하위 수준의 컴포넌트 위에 만들어져야 한다. 

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/07.png" %}

단순하고 하위 수준의 컴포넌트는 커스텀 정의에 더 개방적이어야 한다. 즉, 하위 수준에서 상위 수준 API로 이동할 때 동작이 증가/커스텀 옵션이 줄어든다.

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/08.png" %}

이 전략에 의거해 Compose는 suggestion/assist/input chips의 새로운 레이어를 선택했다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/09.png" %}

- ChipGroup은 Chip을 세로/가로로 배열하는 가능하며, 기존의 Column/Row Composable로 할 수 있다.
- Style은 적용된 Modifier/Behavior로 처리 가능
- 즉, ChipGroup API에 필요한 새로운 커스텀 동작은 없다. 기존 블록을 사용하여 구현 가능

새로운 API는 필요성을 정당화해야함. 새 컴포넌트를 만들거나 기존 컴포넌트에 위임하는 방법 중 하나를 선택하면 됨

# Naming

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/10.png" %}

- Unit을 리턴하는 Composable 함수: 파스칼 케이스와 명사를 사용하여 이름을 지정
  - FilterChip에 대문자 F가 붙은 이유 : Composition에 추가할 수 있는 UI를 생략하고 기본적으로 Unit을 리턴
  - `클래스 네이밍 규칙`을 사용
- 값을 반환하는 Composable 함수 : 소문자로 시작하는 `함수 네이밍 규칙`을 사용
  - Compposition으로 내보내거나 값 반환 둘 중 하나만 해야 한다
- remember를 사용하고 변경 가능한 객체를 반환하는 Composable 함수는 그 성격과 Recomposition을 통해 지속될 가능성을 명확하게 알리기 위해 `remember라는 접두사`를 붙여야 한다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/11.png" %}

- 접두사가 없는 컴포넌트는 바로 사용 가능하며, 어느 정도 스타일처리 된 기본 컴포넌트
- 기본 뼈대인 API에는 기본 접두사를 사용하는 것이 좋다
- 구성 요소의 사용 사례나 목적에 따라 주로 파생된 접두사와 이름을 선호
- Composition locals : 컴포넌트의 특정 하위 트리로 Scope가 제한된 Global value를 제공
  - 서술적인 이름을 지정. 접두사로 local을 사용

# Parameters

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/12.png" %}

파라미터 : API의 목적과 요구 사항을 정의하는 데 매우 중요

- (Composition locals 및 유사한 메커니즘) 암시적으로 모호한 입력 사용은 출처를 추적하기 어려우므로 가급적 지양해야 한다
- API Open 및 명시적 파라미터 사용 -> 사용자가 더 많은 커스텀 계층을 추가 가능

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/13.png" %}

컴포넌트는 자체 내부 동작과 외관을 담당하고, Modifier는 외부 컴포넌트를 잘 수정하는 역할을 담당

컴포넌트 사용자는 이미 Modifier를 어디에 어떻게 사용할지에 대한 기대치가 있다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/14.png" %}

- UI를 출력하는 모든 컴포넌트에는 Modifier 타입의 Modifier 파라미터가 있어야 한다
- 첫 번째 Optional 파라미터
- 기본값이 없음으로 사용자가 기존 체인에 추가한 자체 Modifier를 사용해도 기능이 손실되지 않음
- 단일 컴포넌트에 유일한 Modifier 파라미터
- Modifier는 컴포넌트의 가장 바깥쪽 루트 레이아웃에 한 번만 적용해야 함

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/15.png" %}

Modifier가 Composable 동작과 Shape을 설명하는 경우 명시적인 파라미터가 왜 필요한가?

- API의 주요 목적을 나타내는 명시적 파라미터이여야 한다
- 파라미터는 Modifier를 통해 추가할 수 없는 동작이나 장식도 추가할 수 있어야 한다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/16.png" %}

- 핵심 Modifier가 지원되지 않는 커스텀한 경우에는 Modifier를 사용 가능

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/17.png" %}

파라미터의 순서 정의

1. 필수 파라미터
2. Modifier
3. 옵셔널 파라미터
4. 후행 composable 람다 : Slot 컨텐츠가 필요한 경우

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/18.png" %}

- Nullable 파라미터 : API 기능을 사용 가능하지만, 필수가 아님을 암시
  - Empty와는 동일하지 않음
- Empty : 필수. Empty를 사용하거나 커스텀 정의 가능
- Default : null이 아니여야 하며, 의미 있는 명확한 값

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/19.png" %}

스타일/옵션과 같은 세부 집합의 경우, 기본값을 제공하며 API가 독립적으로 사용 가능하도록 하는 것이 좋다

기본 스타일링 값이 짧고 예측 가능한 경우 간단한 inline 상수로 가능

기본값이 많이 필요한 경우, 컴포넌트 기본값을 사용하여 한 곳에 맵핑 가능 (예: ChipDefaults)

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/20.png" %}

상태에 따른 조건 처리도 기본 API에 위임 가능하다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/21.png" %}

Slot 파라미터/컨텐츠 : 부모 컴포넌트 내부의 빈 공간을 자식 컴포넌트로 채우도록 지정하는 Composable 람다 파라미터

- 필요한 정보이외 나머지는 모두 slot에 위임함으로써 메인 API 간소화 가능

Chip의 경우

- 단일 slot : Composable의 마지막 콘텐츠 파라미터로 배치. Composable 일관성을 보장. 후행 람다로 사용 가능
- 복수 slot : 파라미터를 여러 개 제공

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/22.png" %}

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/23.png" %}

컴포넌트 내부/외부에서 일어나는 변경 사항을 관리할 메커니즘에 State가 필요함

Chip Composable은 활성화/비활성화 상태에 따른 UI에 영향을 주는 프로퍼티가 필요함

상태 처리 방법

1. statefull : Composable이 자체 상태를 소유 (remember/mutableStateOf 사용)
2. stateless : 입력으로 Recomposition이 되어 다른 상태로 렌더링

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/24.png" %}

가능하면 stateless 방식을 추천

- 사용하는 곳이 변경사항을 컨트롤
- 컴포넌트는 API대로 동작하면 되므로 API의 reusable/testable이 높아짐

-> 상태 컨트롤을 추출하는 것을 `상태 호이스팅`이라고 함

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/25.png" %}

API 컨트롤은 외부에 있지만, 클릭과 같이 호출자에게 신호를 보낼 방법이 필요

- onClick과 같은 이벤트는 람다 파라미터로 전달되어야 한다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/26.png" %}

MutableState/Immutable 상태 API를 직접 파라미터로 전달은 하지 말아야 한다

- 호출자와 Composable 모두가 상태를 소유하게 되므로 복잡해짐

-> 명시적인 입력이어야 한다

# Semantics

### 견고하고 안정적인 API

접근성/테스트/문서화/이전 버전과의 호환성 등 중요한 요구사항을 충족하는지 확인 필요

-> 장기적으로 견고하고 신뢰할 수 있는 API가 되길 희망

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/27.png" %}

접근성

- 다양한 사용자를 지원하려면 API가 화면에 표시되는 내용을 보다 적합한 형식으로 안정적/논리적으로 변환 필요
- semantic 프로퍼티를 사용하여 접근성 서비스에 전달
- Low level API : 사전 정의된 방식 존재. 기본값 제공 혹은 명시적으로 요청하고 있음
- Higher level API : 사용자에게 UI를 설명하는 방법을 이해하기 위해 정보를 요청해야 함

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/28.png" %}

API에 명시적인 semantic 세트가 필요한 경우 non-optional 접근성 파라미터를 요청

> 예 : image composable의 contentDescription 프로퍼티

Chip composable

- contentDescription 파라피터 사용
- [semantics](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#(androidx.compose.ui.Modifier).semantics(kotlin.Boolean,kotlin.Function1)) Modifier를 사용

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/29.png" %}

파라미터 대신 Slop 컨텐츠 방식으로도 사용 가능

- Slot이 있는 API는 접근성 서비스가 읽을 수 있는 텍스트를 반드시 설정할 필요는 없다
- 상위 semantic에서 합치고 싶은 경우 [mergeDescendants = true](https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary#(androidx.compose.ui.Modifier).semantics(kotlin.Boolean,kotlin.Function1))로 설정하면 된다
  - 자식 컴포넌트의 데이터를 수집하여 단일 엔티티로 처리

### Testing

격리된 상태에서 얼마나 testable한지 확인하는 것은 잘 만들어진 API의 좋은 지표이며, 더 큰 복합 컴포넌트의 일부로서도 테스트가 더 쉬워진다.

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/30.png" %}

특정 Activity/Context가 필요한 경우, test/preview에서 리소스에 접근할 수 없기 때문에 testable이 제한된다

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/31.png" %}

더 나은 대안 : Click 이벤트로 activity 시작에 context가 필요하면 Click 람다 파라미터로 제공하여 호출자에게 책임을 위임하는 것

- Context/Composition Local과 같은 암시적 리소스는 testable에 영향을 준다
- 항상 명시적 파라미터를 통해 대안을 사용해야 함
- 스타일 지정 목적으로 Composition Local이 필요한 경우 기본값을 설정으로 해결

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/32.png" %}

API를 테스트할 때는 가능한 모든 상태를 쉽게 확인할 수 있어야 한다

- 명시적 상태 파라미터로 노출하면 테스트에서 원하는 대로 변경/검증 가능

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/33.png" %}

좀 더 상태를 쉽게 테스트하기 위해서 [interactionSource](https://developer.android.com/reference/kotlin/androidx/compose/foundation/interaction/InteractionSource)를 사용할 수 있다

- [PressInteraction](https://developer.android.com/reference/kotlin/androidx/compose/foundation/interaction/PressInteraction) 이벤트를 발생하여 확인 가능

특정 컴포넌트를 테스트에서 식별하는데 [testTag](https://developer.android.com/reference/kotlin/androidx/compose/ui/Modifier#(androidx.compose.ui.Modifier).testTag(kotlin.String))를 지정 가능 

{% include img_assets.html id="/blog/io/io24/Designing_scalable_Compose_APIs/34.png" %}

API의 장기적인 안정성과 유지보수를 위해 적절한 문서 작성도 필요

- 이전 버전과의 호환성 지원 확인