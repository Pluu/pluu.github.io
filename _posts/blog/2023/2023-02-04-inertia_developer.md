---
layout: post
title: "[잡담] 관성 개발 ~ 기존에 하던 관성으로 했습니다?!"
date: 2023-02-04 23:10:00 +09:00
tag: [주인장 이야기]
categories:
- blog
- owner
---

<img src="https://images.unsplash.com/photo-1485982353291-4f167f9dee32?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1920&q=80" />

> 이미지 출처 : https://unsplash.com/ko/%EC%82%AC%EC%A7%84/eKfEO0qM1aU

<!--more-->

## 서론

혹시 여러분은 누구에게 코드 설명하는 시간에 `왜 이렇게 작성하셨어요?`라는 질문에 "기존에 하던 대로 했어요" 혹은 "관성대로 했어요"라고 대답한 적 있으신가요?

개발자뿐만 아니라 직업을 가지는 동안에는 질의응답에 의한 커뮤니케이션은 너무나도 흔한 모습입니다. 개발자들은 주로 다음과 같은 곳에서 이야기를 나눕니다.

- Stack Overflow에서 질문과 답변
- GitHub/Gitlab과 같은 곳의 코드 리뷰
- 기타 대화를 나누는 공간

이런 곳은 주로 질문과 대답이 주로 이루어지지만 먼저 언급했던 `관성대로`라는 표현은 사용하지 않습니다. 

그러면 과연 어디에서 들리는 표현일까요? 저도 자주 듣는 표현은 아니지만, 대부분 코드를 누군가에게 소개/설명하는 자리인 것 같습니다. 좀 더 상세한 사례로는 **코딩 과제 면접**이나 **회사 밖 프로젝트**에서 코드를 설명하는 경우일 것입니다. 



이후부터는 관성대로 개발한다는 것을 `관성 개발`로 지칭해서 설명할 예정입니다.

------

본 내용은 특정 회사와 단체의 의견이 아니며, 주관적인 의견임을 언급합니다.

------

## 관성 개발의 단점

관성 개발을 하는 이유는 각자가 처한 상황과 환경 등 `축적된 경험`에 의해서 정해지는 경우가 많습니다. 그 경험에 의해서 어떤 코드를 작성하는지는 다양하지만, 모두가 옳고 이롭다고만 보기는 어려울 것입니다. 

경험에 의한 선택이 어떤 의미를 가지는지 몇 가지의 사례와 함께 다뤄보겠습니다.

### 1. 익숙함/편리함 때문에 놓치는 지식

먼저 아래 질문에 대해서 대답을 한번 생각해 보세요.

- `by viewModels()`로 ViewModel을 생성할 수 있는데, KTX 없이 생성하는 방법을 설명해 보세요.
- `클린 아키텍처`를 설명해 보세요. 코드에서 클린 아키텍처를 위해서 사용되는 디자인 패턴의 필요성을 설명해 보세요.

#### 1-1 KTX의 편리함

<img src="https://developer.android.com/static/images/cluster-illustrations/kotlin-hero.svg" width="25%" />

> 이미지 출처 : https://developer.android.com/kotlin

최근에는 안드로이드 개발 시 Kotlin을 사용하지 않는 사람이 없을 정도로 Kotlin의 인기는 당연하게 여기고 있을 겁니다. 그 결과로 Kotlin 전용인 [Android KTX](https://developer.android.com/kotlin/ktx)가 배포되고 있습니다. 그만큼 Kotlin 친화적인 라이브러리 사용으로 효과를 얻지만, 반대로 놓치는 부분이 없는지 체크해 볼 필요가 있습니다.

간단한 예로 [viewModels](https://developer.android.com/reference/kotlin/androidx/fragment/app/package-summary#(androidx.fragment.app.Fragment).viewModels(kotlin.Function0,kotlin.Function0,kotlin.Function0))/[activityViewModels](https://developer.android.com/reference/kotlin/androidx/fragment/app/package-summary#(androidx.fragment.app.Fragment).activityViewModels(kotlin.Function0,kotlin.Function0))를 통하여 ViewModel을 쉽게 가져올 수 있는 KTX가 있습니다. KTX가 API를 쉽게 사용하는 것에 포커스를 맞춘 것이므로 숨어있는 개념을 파악하는 것은 개발자 자신의 몫입니다. 동작 방식이라도 가볍게 알아둬야지 추후 또 다른 응용이나 이슈 해결에도 한결 쉬워집니다.

#### 1-2 마법의 단어 사용

여러분은 프로젝트 구성에 대한 설명할 때 구현 형태에 대해서 어떻게 설명할지 생각해 보세요. 아마도 많은 분이 `클린 아키텍처`라는 단어를 사용해서 설명할 겁니다. 그런데 클린 아키텍처를 말하면 좋은 평가/인식을 받을 거로 생각하지 않나요? 

그렇다면 `클린 아키텍처`라는 것은 무엇일까요? 이론? 구현? 등 다양한 정의가 떠오르실 것입니다. 정확한 설명이나 내용도 중요하지만, 더 필요한 것은 여러분 스스로 이것을 어떻게 정의하고 있다고 생각합니다. 그리고 개념+구현을 위해서 어떤 기술들이 필요한지도 생각해 보세요. 모든 아키텍처가 제각각이 추구하는 방향이 있으며, 어떤 이유로 생겨났으며, 장단점이 존재합니다. 

<iframe class="speakerdeck-iframe" frameborder="0" src="https://speakerdeck.com/player/bcdae3422a18474ebbde25d1596d048f?slide=11" title="코드 품질 1% 올리기" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true" style="border: 0px; background: padding-box padding-box rgba(0, 0, 0, 0.1); margin: 0px; padding: 0px; border-radius: 6px; box-shadow: rgba(0, 0, 0, 0.2) 0px 5px 40px; width: 100%; height: auto; aspect-ratio: 560 / 314;" data-ratio="1.78343949044586"></iframe>

여러 아키텍처 중에서 여러분은 결국 어떤 하나를 선택했을 겁니다. 단순하게 정할 수도 있지만, 회사라면 당연히 동료/팀의 현재 기술/상황을 고려해서 정하는 게 일반적입니다. 다만 그 과정 속에서 정해진 결정이 최고의 선택은 아닐지라도, 팀에서는 최선의 선택일 테니 실망하거나 부끄러워하지 않아도 됩니다. 그것이 현재 최선일 테니깐요. 

아키텍처란 사용하는 사람과 환경에 맞춰서 적용되고 변화한다는 사실을 잊지 말기를 바랍니다.

### 2. 잘못된 습관

모든 개발자는 여러 경험을 통해서 익혀진 자신만의 습관/관습 등 일정한 패턴이 있습니다. 그 패턴이 높은 퍼포먼스나 안정적인 개발을 할 수 있는 힘이 될 수도 있습니다.

#### 2-1. 편리함이 원칙을 깨트림

> 극단적으로 간단한 사례로 설명할 예정입니다.

프로그래밍하다 보면 가시성/읽기+쓰기 여부 등 견고함을 추구하는 방법은 다양합니다. 원칙을 지키기는 어렵지만, 편하게 하자는 생각으로 개발하게 되면 무너진 원칙이 굳어지기 쉽습니다. 

먼저 Int타입의 List를 String 타입으로 변환하는 함수를 만든다고 가정을 해봅니다. 

```kotlin
fun map(list: MutableList<Int>): MutableList<String> {
  val transformList = mutableListOf<String>()
  // skip code
  ...
  return transformList
}
```

위 코드와 같이 작성하더라도 List<Int>를 List<String>으로 바꾸는 의도대로 결과물을 나옵니다. 그러나 여러 가지의 문제가 있는 코드인데 여러분은 어떤 부분이 문제인지 파악하셨습니까?

- 파라미터가 Mutable하므로 map 함수 내부에서 수정할 수 있습니다.
- 함수의 리턴이 Mutable하므로 함수를 호출한 곳에서 수정할 수 있습니다. 

또 다른 사례로는 mutable을 외부로 그대로 노출하는 경우입니다. class의 프로퍼티를 그대로 반환하는 경우라면 외부 조작으로 class에 영향을 줄 수 있습니다.

```kotlin
class Test {
  val list = mutableListOf<Int>()
}
```

의도된 정의가 아니라면 외부 조작에 의한 변경 가능성은 최소화해야 합니다.

#### 2-2. 비효율적인 선택

회사에서 개발할 때 중요한 것 중 하나로 `시간에 맞게 개발`을 하는 것입니다. 당연히 OOP/함수형 프로그래밍 및 팀의 가치관에 맞춰서 개발한다는 전제 사항입니다.

그러더라도 특정 기능에 너무 많은 시간을 쏟고 있으며, 해결 못 하는 순간까지 도달하는 경험을 할 때도 있습니다. 남은 할 일도 있으니 언제까지 그 문제에 시간을 쓸 수만을 없을 것입니다. 혼자만 끙끙 앓고 있는 그런 순간은 언젠가 경험할 시간일 것입니다. 그럴 때 여러분은 어떤 결정을 하셔야 합니다.

- 정석적인 방법이 아닌 쉽게 해결. 코드가 맘에 들지 않더라도.
- 혼자서 해결이 안 된다면 주변에 도움을 요청
- 기획과 협의해서 스펙 조정

프로그래밍하면서 뭐든지 맘에 들도록 작업한다는 것은 많은 시간과 생각/고민/협의를 통해서 도출되는 결과물일 것입니다. 이것이 여유롭지 않다면 어떻게든 선택과 집중을 할 수밖에 없습니다. 그 선택이 후회될 수 있지만, 전체적+거시적 관점에서는 성공적인 선택일 수도 있습니다.

#### 2-3. 변화에 대응하지 않는 자세

IT 업계는 매년 새로운 기술이 쏟아져 나오고 있으며, 안드로이드 또한 초반 개발에 비해서 크고 작은 변화들이 있었습니다.

- MVVM 패턴
- AndroidX
- Kotlin 지원
- ViewBinding/DataBinding/Compose
- 멀티 모듈
- 기타

이 글을 쓰는 현시점에서는 위의 항목들이지만, 몇 년 후에는 또 다른 새로운 것들이 나올 수도 있습니다.

이런 변화 속에 여러분은 새로운 변화에 준비하고 있으신가요? 새로운 것을 배움에 쏟는 시간은 모든 개발자에게 분명 부담입니다. 느리더라도 결국 움직여야 한다는 것을 알고 있지만 개인마다 다양한 이유로 실천이 어렵습니다. 

그러더라도 확정된 변화에 준비/대응하는 것만이 본인의 가치를 올릴 수 있는 방법 중 하나라는 사실은 변함없다는 것을 기억해야 합니다. 더 좋은 것이 있다면 받아들이거나 배워서 내 것으로 만들 수 있는 자세가 중요하다고 생각합니다.

## 관성 개발의 이점

### 1. 안정적인 개발

관성 개발의 이점 중 가장 큰 것은 안정적으로 개발할 수 있다고 생각합니다. 그 외에도 여러 가지 있겠지만, 안정적인 상황을 기반으로 생겨난 효과라고 생각합니다.

- 자료가 많다
- 물어볼 사람이 많다
- 안정감
- 빠르게 개발할 수 있다

기존대로 개발할 수 있다는 것은 일정 산정이나 문제가 되는 부분을 사전에 체크하기 쉽습니다. 만약 어려운 문제를 부딪치더라도 도움을 얻을 곳이 많으며 어떻게 질문할지 맥락을 파악하기도 쉽습니다. 즉, 작업에 대해서 어떤 행동들을 할지 `예상이 가능하다`는 것이 포인트입니다. 

### 2. 이해관계 속 정해진 결과

이 항목 또한 관성 개발 이점의 1번째 항목의 연장선입니다. 

모든 개발이 그렇지만 프레임워크/SDK/라이브러리/개발 지식들이 누구 한 사람으로 인해 생겨난 것들이 아니란 것을 아실 겁니다. 1인 개발자도 여러 가지 경험을 통해서 자기만의 패턴을 확립했으며, 회사는 더 많은 인원의 이해관계와 논의를 통해서 정해집니다. 이렇게 정해진 패턴은 모두가 만족할 수는 없지만, 다수의 합의로 결정된 사항이므로 뒤엎는 것도 어려운 사항입니다. 결국, 관성으로 개발하는 것이 몸도 마음도 편해지는 것이겠죠.

이렇게 정해진 것도 아무것도 정해진 것이 없는 것보다 나은 상황이라는 것입니다. 최소한 다음을 이야기할 수 있는 기준점과 비교 대상이 있으니 건설적인 이야기를 할 수 있습니다.

## 정리

관성 개발은 각자의 사정과 철학이 다른 만큼 명확한 정답이 있는 부분도 있고, 아닌 것도 있을 것입니다. 다만, 개발자로서 꾸준히 발전, 퍼포먼스 발휘, 안정적인 개발을 위해서 어떤 노력과 선택을 해야만 한다는 것입니다.