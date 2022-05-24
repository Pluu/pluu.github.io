---
layout: post
title: "[요약] Fragments: The good (non-deprecated) parts"
date: 2022-05-24 23:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io22
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/OE-tDh3d1F4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

## Unbundled Library

Fragment는 기기에 관계없이 일관된 개발자 경험을 제공하는 것을 목표하는 라이브러리이다. Android 프레임워크에서 번들로 분리된 Android 팀에서 제공한 최초의 라이브러리 중 하나이다.

초기 릴리스 이후 Fragment의 역할이 크게 변경되었다.

### Mini Activities

Fragment는 본질적으로 작은 Activity로 시작했고, Activity에 있던 다양한 기능도 지원했다.

> view, lifecycle, SavedInstanceState, callbacks, onConfigurationChanged, onActivityResult 

이 기능들은 메소드 오버라이딩하는 것만이 유일한 방법이었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/001.png" }}" /> 

오늘날의 Fragment는 View는 여전히 소유하고 있어서 Android View/Jetpack Compose로 구현할 수 있다

다른 책임은 필요할 때만 사용하도록 별도의 구성 요소에서 처리한다.

### AndroidX Lifecycle

Fragment가 접근할 수 있는 가장 중요한 구성 요소 중 하나는 수명 주기이다.

AndroidX Lifecycle는 생성, 시작, 재개된 상태의 집합으로 작업의 일관되고 중첩된 재진입 시 안전한 방법을 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/002.png" }}" />

Fragment의 한 가지 목표는 Lifecycle 방법처럼 보이지만, 실제로 Lifecycle 이벤트과 관련된 것들이나 동작이 없는 API를 폐기하는 것이다. 대신 관찰할 수 있는 AndroidX Lifecycle을 권장한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/003.png" }}" />

ViewPager 내부로 Map Fragment에서 사용자의 위치 수신과 같이 비용이 비싼 작업은 사용자가 실제로 해당 화면을 보고 있는 경우에만 필요하다.

ViewPager에서는 현재 Fragment만 resumed이 되며, 다른 Fragment는 started로 제한된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/004.png" }}" />

즉, Fragment가 ViewPager의 현재 Fragment일 때만 Kotlin Coroutine flow를 수집하는 것은 `resumed` 상태에서 `repeatOnLifecycle`을 호출하여 수행할 수 있음을 의미한다. 사용자가 스와이프하면 Fragment는 paused 되고 repeatOnLifecycle 블록이 자동으로 취소된다. 

그러나, 이 Lifecycle은 Fragment와 Fragment View의 존재와 관련 있다. Configuration 변경과 같이 더 오랫동안 지속되는 것을 원하는 경우에는 Fragment로는 해결이 안 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/005.png" }}" />

이것이 앱 아키텍처 가이드에서 UI 레이어를 두 개의 레이어로 분할하는 이유이다.

UI 요소는 Fragment 자체와 앱의 다른 계층과 통신하는 별도의 이해 관계자 계층이 소유하는 것이다.

State Holder 레이어는 Fragment에 UI 상태를 제공하고 UI 상태를 업데이트하는 Fragment의 이벤트를 처리한다.

이러한 분리가 바로 Fragment가 다른 아키텍처 구성 요소인 ViewModel과 통합되는 이유이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/006.png" }}" />

단일 Fragment와 연결된 ViewModel의 경우, 이는 Fragment의 UI와 도메인 또는 데이터 계층 간의 연결점이다.

View에 적용할 Fragment에 Kotlin Flow 또는 기타 관찰 가능한 데이터 소스를 제공하고 이를 조정하는 것은 ViewModel 레이어이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/007.png" }}" />

ViewModel은 다른 ViewModel Store Owner를 사용하는 것만으로도 공유 리소스가 될 수도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/008.png" }}" />

Fragment Result API은 Lifecycle을 사용해 Fragment에서 다른 Fragment로 정보 전달하는 문제를 해결한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/009.png" }}" />

Fragment Result API는 다른 Fragment에 대한 참조를 유지하는 데 의존하지 않고, 대신 Fragment Manager에 의존하여 한 Fragment의 결과 처리하고 수신 Fragment가 시작될 때만 다른 Fragent에서 이를 수신한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/011.png" }}" />

실제 API는 리스너가 준비될 때까지 이러한 결과를 저장하는 책임이 있는 Fragment Manager에 있다.

자식 Fragment와 부모 Fragment 간에 결과를 전달할 수 있을 뿐만 아니라 FragmentScenario를 사용하여 해당 API를 더 쉽게 테스트할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/012.png" }}" />

Fragment를 테스트하기 위해 FragmentScenario로 시작하고 상위 Fragment Manager에 대한 참조를 얻는다. 테스트 결과가 Fragment Manager에 저장된다.

### Testing Fragments

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/013.png" }}" />

Activity Result API에는 아래와 같이 영역이 정의된다.

1. 결과에 대한 리스너가 필요하다 --> registerForActivityResult
2. GetContent으로 계약 유형을 선택한다. Type-safe 입력을 기반으로 사용자를 대신하여 반환을 Type-safe 출력으로 구문 분석하여 수신기에 전달하는 계약이다.
3. 해당 registerForActivity 콜백은 ActivityResultLauncher를 제공한다. 그 후 필요한 곳에서 launch로 호출하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/014.png" }}" />

테스트 시에는 외부 의존성을 명시적으로 하여 진행할 수 있다. 

Fragment Factory를 사용하여 직접 Fragment 생성자에 주입할 수 있고, 기본 ActivityResultRegistry에 의존하는 대신 자체적으로 전달한다. Hilt를 사용하는 경우 OnCreate에서 ActivityResultRegistry를 호출하는 것으로 동일한 접근 방식이 적용된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/015.png" }}" />

Fragment로 전달할 Fake URI인 결과를 생성한 후, 예상 결과를 즉시 반환하는 Fake ActivityResultRegistry를 만든다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/016.png" }}" />

add_attachment_button을 누른 다음 결과가 예상한 결과임을 확인하는 테스트이다. 자신의 ActivityResultRegistry를 삽입하는 기능을 사용하면 적용된 외부 종속성에서 명시적 종속성으로 이동할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/017.png" }}" />

명시적 외부 종속성과 테스트가 크게 겹치는 또 다른 영역은 Fragment가 메뉴 및 AppBar와 상호 작용하는 방식이다.

Fragment는 자체 도구 모음을 소유하고 도구 모음 API를 사용하거나 Fragment가 작업 표시줄에서 제공하는 전역 메뉴에 메뉴 항목을 추가한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/018.png" }}" />

MenuHost를 추가하여 메뉴의 출처를 추상화하고, 추상 인터페이스를 Fragment에 주입할 수 있도록 하는 인터페이스이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/019.png" }}" />

Hilt를 사용하는 실제 종속성 주입 설정이 Activity에서 MenuHost를 가져올 수 있는 반면, 테스트에서는 테스트를 위해 이 인터페이스의 모의 또는 Fake 구현을 제공할 수 있음을 의미한다.

Fragment는 더 이상 Menu API를 직접 호출할 필요가 없으며, Menu Provider를 추가할 수 있도록 MenuHost 인터페이스만 사용하여 메뉴와 상호 작용할 수 있다.

추가로 이 Menu Provider는 lifecycle를 인식한다.

- lifecycle이 파괴되거나 사용자가 제공한 수명 주기 상태 아래로 떨어지면 자동으로 정리된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/020.png" }}" />

위 예제는 ViewPager에서 RESUMED 상태 일 때만 유효한 케이스이며, ViewPager에서 스와프하는 즉시 MenuHost에서 자동으로 제거된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/021.png" }}" />

이전 Menu API와 유사하게 MenuProvider 인터페이스를 구현하여 메뉴를 생성/선택에 대한 처리를 할 수 있다.

이 메뉴 코드는 더 이상 Fragment 자체에 있을 필요가 없으며 Fragment API에 전혀 의존하지도 않는다.

### Testable Components

별도의 테스트 가능한 구성 요소는 Fragment 자체에 대한 종속성이 적고 여러 책임을 하나의 클래스로 결합하는 것을 방지하여 행복한 길로 유지함을 의미한다.

### And the old ways?

Deprecated 된 것이 있더라도 바이너리 및 동작 호환성은 유지한다.

### Migration

Lint로 코드에 대한 컴파일 시간 정보를 제공하며, 엄격 모드 API인 FragmentStrictMode도 제공한다.

코드 및 사용하는 모든 라이브러리의 코드가 이러한 모범 사례를 따르고 더 이상 사용되지 않는 API 사용을 방지하는지 런타임 확인을 제공할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/fragments_the_good_non-deprecated_parts/022.png" }}" />

일반적인 사용법은 기본 정책을 설정하여 애플리케이션 수준에서 사용하는 것이다. detect~~~ API를 사용하여 특정 위반을 감지할 수 있다. 

런타임에 발생할 경우 `penaltyLog`가 가장 조용한 반면, `penaltyDeath`는 문제가 있음을 즉시 알려준다. 별도 로깅을 사용할 경우에는 `penaltyListener`를 사용할 수 있다.
