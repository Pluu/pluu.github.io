---
layout: post
title: "[요약] Demystifying Android Accessibility Development (Google I/O '19)"
date: 2019-09-24 01:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/bTodlNvQGfY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
<!--more-->

Android Accessibility 개발은 매우 복잡하다. Accessibility조차 Android의 일부이다.

→ 구글 팀이 할 일은 복잡성을 다루지 않도록 하는 것

세션의 목표

- 아이디어
- Accessibility에 대한 전반적인 아이디어
- 경험을 단순화하기 위한 새로운 API
- Test를 위한 일부 Tools

## 일상적인 작업에 적용할 수 있는 세 가지

### 1. 정보를 공개

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/001.png" }}" /> 

대부분이 시각 장애인을 위한 Accessibility에 대해서 먼저 시작한다.

#### 크기

- 시력이 약하다
- 나이가 들어서 작은 글씨를 읽기 어려운 것

추가 도구 및 손쉬운 사용 없이 정보를 잘 보이게 하는 것은 어렵다.

#### 색상

색맹인 사람들에게는 전달하려는 정보가 누락

### 2. 간단하고 큰 컨트롤 선호

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/002.png" }}" /> 

UI를 보고 내용을 이해할 수 있을 때 UI를 사용할 수 있을까? 

이때 컨트롤의 변화로 큰 차이를 만들 수 있다.

작은 공간에 많은 기능을 추가하면 누군가는 어려움을 겪게 된다. (ex, 손가락이 커서 UX 경험이 나쁜 경우)

→ 중요한 정보는 크고 이해하기 쉽게 컨트롤할 수 있도록 해야 한다.

### 3. 이미지를 정확하고 간결하게 라벨링

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/003.png" }}" /> 

화면을 볼 수 없는 사용자를 돕기 위해서는 많이 생각해야 한다. 이미지 사용 시, 전혀 볼 수 없는 사람에게도 효과가 있는지 체크해야 한다.

- 간단한 해결 : 이미지에 레이블 지정
- 이유 : 텍스트로 정보가 전달되는지 확인이 필요하다. Screen Reader 사용자 경험에서는 Graphic이 얼마나 좋은지에 대해서는 관심 밖이다. 
- 가능한 한 정확하게, 방법을 설명하려면 동사인 단어만 사용


<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/004.png" }}" /> 


사용자가 앱과 상호 작용하는 방식에서 본질적으로 두 가지가 있다

- 사용자에게 정보 제공
- UI에서 어떤 행동을 함

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/005.png" }}" /> 

앱 개발 단계 (선결제를 위한 사람들을 타겟팅)

- 일반적인 사람
- 시각 장애 : 서로 다른 수준의 장애가 있으며, 특정 유형의 물건을 볼 수 없기도 하다
- 운동 장애 : 다양한 종류가 존재
- 청각 장애

이런 장애가 조합적인 사람들도 있다.

전 세계에는 10억 명의 장애를 가진 사람이 있지만, 10억 개의 사례를 기준으로 하지 않아도 된다. 이런 생태계에서 `Accessibility Service` 를 통해 많은 사례에 맞게 확장할 수 있도록 지원한다. Accessibility Service는 Android Platform에 대한 플러그인이며, 사용자 대신 UI에 대한 정보를 얻거나 액션을 취할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/006.png" }}" /> 

특정 사용자에게 맞게 정보를 제공하는 방법을 제시한다.

- 오디오
- 점자
- 스위치

동작 방식은 Android Framework를 통해서 처리한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/007.png" }}" /> 

API를 사용하여 정보를 제시하고 사용자가 Action을 하도록 하는 것이다. 그런 다음 테스트 도구를 사용하여 실제로 동작하는지 확인한다.

------

## Accessibility API

### 1. ContentDescription

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/008.png" }}" /> 

Accessibility Service와 통신하는 방법은 `Accessibility API`를 사용하는 것이다. 대부분은 뷰 계층을 통해서 유추할 수 있다. 그러나, 위와 같은 옵션 버튼은 Android Framework는 화면의 위치 및 클릭 가능한 정보 등을 `View.java` 를 통해 유추할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/009.png" }}" /> 

화면을 볼 수 없는 `TalkBack` 사용자는 이 항목에 손가락을 대면 아무것도 얻지 못한다. TalkBack이 해당 상황에서 무엇을 말해야 하는지 모르기 때문이다. 그것은 Description Text가 없기 때문이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/010.png" }}" /> 

ContentDescription API를 통해서 설명을 추가할 수 있다. Localized 된 문자열을 전달하면 된다. 누군가는 문자열을 들어야 하므로 현지화와 간결한 설명이 필요하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/011.png" }}" /> 

추가 옵션 버튼이라는 것을 알게 되었으며, 원하던 상호작용을 이어나갈 수 있다.

### 2. AccessibilityAction

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/012.png" }}" /> 

다른 예로는, 이메일 UI에서 스와이프로 이메일을 삭제/읽음을 표시할 수 있다. 스와이프하면 해당 이메일은 삭제된다. 그러나 모든 사용자가 탭/스와이프를 할 수 있는 것은 아니다.

- TalkBack 사용자는 다른 제스처를 통해 UI 동작
- 스위치 사용자는 단일 스위치를 통해 UI 동작

`Accessibility Service`를 통해서 각 케이스에서 할 수 있는 작업을 알 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/013.png" }}" /> 

ContentDescription과 유사하게 `Accessibility API`를 사용하면 된다.

> [ViewCompat#addAccessibilityAction](https://developer.android.com/reference/androidx/core/view/ViewCompat#addAccessibilityAction(android.view.View,%20java.lang.CharSequence,%20androidx.core.view.accessibility.AccessibilityViewCommand))

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/014.png" }}" /> 

View, 지역화된 문자열, 사용자 요청 시 수행할 Lambda를 전달하여 정의한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/015.png" }}" /> 

`ViewCompat#addAccessibilityAction` API를 사용함으로 스위치 사용자가 Select/Remove 작업을 모두 수행할 수 있다.

> AndroidX API이므로 `API 21 이상`에서 동작한다.

### 3. EnableAccessibleClickableSpanSupport

Android O 이전에는 Accessibility Frameworks가 텍스트 링크 혹은 ClickableSpans 사용 시 URL이 아닌 범위에 대해 처리를 할 수 없었다. TalkBack 사용자는 화면에 링크가 있다는 메시지가 표시되지 않는 문제가 발생했다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/016.png" }}" /> 

해당 문제를 해결하기 위해 AndroidX에 API가 추가되었다.

> [ViewCompat#enableAccessibleClickableSpanSupport](https://developer.android.com/reference/androidx/core/view/ViewCompat#enableAccessibleClickableSpanSupport(android.view.View))
>
> `API 19 이상`에서 동작한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/017.png" }}" /> 

> 정상적으로 적용된 경우의 화면

### 4. AccessibilityPaneTitle

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/018.png" }}" /> 

Dialog가 아니라 ViewGroup 과 텍스트와 버튼의 조합으로 구현하는 경우, 상황에 따라 시각적으로 표현하는 정보가 결정되므로 TalkBack과 같은 Accessibility Service에 문제가 발생한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/019.png" }}" /> 

이 경우, 해결방법은 ViewGroup에 Accessibility을 제공하는 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/020.png" }}" /> 

> [ViewCompat#setAccessibilityPaneTitle]([https://developer.android.com/reference/androidx/core/view/ViewCompat#setAccessibilityPaneTitle(android.view.View,%20java.lang.CharSequence)](https://developer.android.com/reference/androidx/core/view/ViewCompat#setAccessibilityPaneTitle(android.view.View, java.lang.CharSequence))
>
> `API 19 이상`에서 동작한다.


<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/021.png" }}" /> 

이제 TalkBack을 통해서 올바르게 음성으로 알려준다.

### 5. Timeout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/022.png" }}" /> 

비디오 플레이어에서 재생 버튼 등이 일정 시간이 지나면 사라지는 컨트롤이 있는 것은 일반적이다. 대부분 콘텐츠를 원하기 때문에 유용한 기능이다.

그러나, 컨트롤과 상호작용하는데 시간이 걸리는 Accessibility 사용자를 위해서 재생 버튼을 화면에 다시 표시하는 방법을 찾아야 한다. Timeout으로 사라지기 전에 상호 작용하는 방법을 찾아야 한다. 

필요한 것은 상황에 따라 이상적으로 필요한 Timeout 시간을 조정하는 방법이다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/023.png" }}" /> 

사용자가 반응할 시간을 줄 수 있도록 최소한이 시간 동안 컨트롤을 화면에 유지해야 합니다. 

1. AccessibilityManager에 대한 참조를 취득한다
2. getRecommendedTimeoutMillis API를 호출한다. 사용자에게 필요한 UI 변경에 대한 Timeout 시간이 반환된다. 

> 적용된 사례 : [SnackBar#Duration](https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/snackbar/Snackbar.java#L307)

- FLAG_CONTENT_CONTROLS
- FLAG_CONTENT_ICONS
- FLAG_CONTENT_TEXT

------

## Anti-patterns

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/024.png" }}" /> 

화면에서 볼 수 없는 음성 안내 지원 사용자를 위해 특별히 제작한다는 가정을 해보겠습니다. 새 이메일이 나타날 때 어떤 경험이 될지 정하려고 합니다. 가장 좋은 방법은 알리는 것이다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/025.png" }}" /> 

새 이메일이 나타날 때마다 알리는 것은 좋은 방법이 아니다. UI 변경사항은 Accessibility Service 및 사용자 설정에 따라 다르게 표현된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/026.png" }}" /> 

Service는 Application의 Accessibility UI를 조정할 필요가 없다. 

> 이해하기 쉬운 사용자를 위해 스스로 조작할 수 있는 일반적인 UI 표현이 필요하다.

이때 우리는 아무것도 하지 않는다. 

AndroidX 및 Material 등의 Framework에서 제공하는 위젯을 사용하여 이를 처리할 수 있다. 해당 위젯에 기본적으로 Accessibility 관련 기능이 내장되어 있다. 그러나, 커스텀 위젯을 만드는 경우 `Accessibility 이벤트` 를 사용해 UI 변경 사항의 정확한 의미를 전달해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/006.png" }}" /> 

이 상황에서 기억해야 할 것은 사용자와 직접 주고받지 않는다. `Accessibility Service` 와 작업을 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/027.png" }}" /> 

그리고, Accessibility focus를 관리하는 것을 선호하기도 한다. 이것 또한 나쁜 선택이다. `Accessibility focus` 는 Accessibility Service에 의해 결정되어야 한다. 알림과 마찬가지로 경험에 일관성이 없다. 실제로 Accessibility 사용자가 직면하는 가장 큰 문제 중 하나이다. 앱은 시간이 지남에 따라 일관성이 없어진다.

앱 개발에서 Accessibility Service를 이용하지 않는 경우, Accessibility 사용자는 매 앱을 열 때마다 Accessibility에 대한 기대를 버린다. 그리고, 새로운 UI를 근본적인 수준에서부터 다시 배워야 한다. Accessibility 사용자를 위해 할 수 있는 최선의 방법은 시간이 지남에 따라 시스템과 일관성을 유지하는 것이다.

# Test

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/028.png" }}" /> 

Accessibility 적용할 것이 올바른지 어떻게 알 수 있을까? 대부분의 사용자가 사용할 수 있는 환경을 만들 방법은 아래와 같다.

1. 자동화된 테스트
   1. 약간의 코드 변경이 필요하며, Accessibility 문제를 감지하는데 매우 좋다. UI 단위 및 통합 테스트를 통해서 실행할 수 있다.
2. Accessibility 테스트 도구
   1. 기술 지식이 필요하지 않으며 QA 팀 혹은 릴리즈 관리자가 앱을 공개하기 전 상태 확인을 위해 실행할 수 있다
3. 수동 테스트
   1. 실제 Accessibility 사용자에게 End-To-End 경험을 제공할 방법이다.

## Accessibility Test Code

대부분의 Android Accessibility 테스트 도구는 Android Accessibility Service Test Framework에서 지원한다. Java 라이브러리이며, 런타임시 Accessibility 문제에 대해 Android UI 항목을 평가하기 위해 Rule 기반으로 작성된다. 오픈 소스라는 장점이 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/029.png" }}" /> 

Test Framework는 아래와 같은 것을 테스트한다.

- Label이 누락되었거나 잘못되었는지 찾는다
- 작은 터치 항목을 찾는다
- 명암비가 낮은 텍스트/이미지를 찾는다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/030.png" }}" /> 

Accessibility Test Framework를 Espresso/Robolectric을 통해서 사용할 수 있다. 테스트에서 뷰와 상호 작용 시 Accessibility 검사는 실행 전에 자동으로 확인한다. 버튼과 상호작용 시 버튼 및 주위의 UI를 통해 Accessibility 문제를 찾는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/031.png" }}" /> 

Espresso에서는 `AccessibilityChecks.enable()` 으로 테스트를 활성화할 수 있다.

- setRunChecksfroomRootView : RootView에서 실행해 테스트 범위를 늘릴 수 있다.
- setSupressingResultMatcher : 알려진 Accessibility 문제를 화이트 리스트에 추가하여 테스트 시 성공처리가 되도록 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/032.png" }}" /> 

뷰와 직접 상호 작용하는 경우 Accessibility 검사를 무시한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/033.png" }}" /> 

Robolectric의 경우 AddAccessibilityChecks 주석을 사용하여 테스트를 활성화된다. ShadowView를 호출하면 View에서 테스트가 호출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/034.png" }}" /> 

Espresso와 마찬가지로 Robolectric의 Accessibility 도구를 사용하여 테스트를 재정의할 수 있다.

## Accessibility Test Tool

초기 단계는 자동화된 테스트, 코드 변경, Accessibility 문제 파악 등이 전부였다. 자동화 도구이며 기술 지식이 필요하지 않다. 

### Google Play 사전 출시 보고서

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/035.png" }}" /> 

이 도구는 여러 물리적 장치에서 앱을 제어하고 Accessibility 문제를 찾아서 앱 출시 전에 해결할 수 있는 자동화 도구이다. Crash, Performance, Accessibility 문제를 찾는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/036.png" }}" /> 

이 검사는 모든 Play Store에 출시된 모든 APK에서 실행된다. `사전 출시 보고서`는 Google Play 콘솔에 있다. 사전 출시 보고서에서 문제를 파악할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/037.png" }}" /> 

사전 출시 보고서에서 생성된 보고서의 상세화면이다. 대비가 잘못된 텍스트가 강조 표시되어 개선을 위한 제안이 제공된다.

### Accessibility Scanner

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/038.png" }}" /> 

`Accessibility Scanner` 는 UI를 스캔하여 Label 누락, 작은 터치 등과 같은 잠재적 Accessibility 문제를 찾는 또 다른 앱이다. Accessibility Scanner를 사용하기 위해서 코드를 변경할 필요는 없다. Play Store에서 앱을 다운로드하거나 `g.co/accessibilityscanner` 에 방문하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/039.png" }}" /> 

Accessibility Scanner를 실행하면 파란색 Floating 버튼이 나타난다. 앱을 스캔하려면 UI가 Foreground에 있는 동안 파란색 버튼을 누르기만 하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/040.png" }}" /> 

Accessibility Scanner에서 작성된 보고서의 모습이다. 예로는 잘못된 비율로 강조 표시된 텍스트를 볼 수 있다. 그리고 개선을 위한 제안도 제공한다. 이메일과 Google Drive로 보고서를 공유할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/041.png" }}" /> 

`자세히 알아보기` 를 선택하면 관련된 상세 문서로 이동한다.

### 수동 테스트

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/042.png" }}" /> 

자동화 테스트는 유용하지만 특정 제한 사항이 있다.

1. 자동화 테스트는 테스트 코드에 의존한다. 즉, 테스트 코드가 제공하는 범위에 따라서 결과가 좌우된다. 테스트되지 않은 코드 부분에서는 Accessibility 문제가 있을 수 있다.
2. 잘못된 탐지 가능성이 있다.
3. 인간의 판단과 개입이 필요한 특정 문제가 있다. 예를 들어, Label 누락은 알 수 있지만, Label이 사용자에게 이해가 되는지 여부는 사람만 결정할 수 있다.

보조 기술을 사용해 앱과 상호 작용하는 방법을 이해하는 것이다. 이를 달성하는 방법은 여러 가지가 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/043.png" }}" /> 

1. Accessibility 사용자와 직접 작업하고 피드백을 요청하는 것
2. Android 자체 Accessibility Service를 사용하는 것 (TalkBack, Switch Access)

# Summary

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/044.png" }}" /> 

앱에서 작업할 때 실제로 요청하는 것은 다른 사람이 앱을 사용하도록 도와주고 다른 Accessibility Service 개발자가 다른 사람이 앱을 사용하도록 도와주는 것이다.

- UI를 사용하여 가능한 많은 사람과 UI를 공유하기
- Accessibility를 테스트

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/045.png" }}" /> 

3가지로 정리할 수 있다.

1. 정보를 표시
2. 단순하고 큰 컨트롤을 선호
3. 이미지에 정확하고 간결하게 레이블을 지정

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/demystifying-android-accessibility-development/046.png" }}" /> 

## Reference

Accessibility 테스트에 도움이 되는 자료
- [I/O 19 ~ Basic Android Accessibility Codelab](https://codelabs.developers.google.com/codelabs/basic-android-accessibility/index.html)
- [Android Accessibility Suite](https://play.google.com/store/apps/details?id=com.google.android.marvin.talkback)
