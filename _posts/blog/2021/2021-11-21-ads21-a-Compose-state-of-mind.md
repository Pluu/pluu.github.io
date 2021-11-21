---
layout: post
title: "[요약] A Compose state of mind: Using Jetpack Compose's automatic state observation (Android Dev Summit '21)"
date: 2021-11-21 21:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/rmv2ug-wW4U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- 상태는 시간이 지남에 따라 변경될 수 있는 앱의 모든 값이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/001.png" }}" />

> 검색 화면에서 Composition을 시각적으로 표현

- Composition은 앱의 현재 상태를 설명하는 Compose에서 만드는 UI에 대한 설명이다
- 선언형 프레임워크에서는 앱의 현재 상태를 설명하고 프레임워크는 상태가 변경될 때마다 UI 업데이트를 처리한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/002.png" }}" />

- 장바구니 화면으로 이동할 때, 검색 대신 지금 상태 변경의 영향을 받는 UI 부분을 실행한다
- 검색 대신 Navigation host가 업데이트되어 장바구니 화면이 표시된다
- UI의 모든 부분은 Composable 함수이므로 상태가 변경되면 화면에 새 데이터를 표시하기 위해 재구성이 발생한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/003.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/004.png" }}" />

- 두 개의 Button, 하나의 Text가 있는 Row를 사용하여 UI를 만들 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/005.png" }}" />

- Composable 함수에 변수를 추가한 후 항목(quantity)의 변경을 하더라도 아무런 동작을 하지 않는다
- 함수는 상태 변경으로 재구성이 되지 않으며, 변수를 Compose에서 값을 추적하지 않기 때문이다

State changes need to be `tracked` by Compose

- Compose에는 상태를 읽는 Composable에 대한 재구성을 예약하는 상태 추적 시스템이 존재한다. 이를 통해 변경해야 하는 Composable 함수만 재구성할 수 있다.
- 상태에 대한 쓰기/읽기도 추적하여 재구성하도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/006.png" }}" />

- Compose의 State 및 MutableState 타입을 사용하여 상태를 관찰 가능하게 만든다
- 값 속성을 재지정하고 값이 변경될 때 재구성을 트리거하는 Composable을 추적한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/007.png" }}" />

- mutableStateOf() 함수를 사용하여 MutableState를 만들 수 있다
- quantity의 value 속성을 사용하여 읽고 쓸 수 있다
- 위처럼 재구성되더라도 UI에 변경된 상태는 반영되지 않는다. 이유는 함수를 재구성하더라도 quantity은 `항상 1로 초기화`되기 때문이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/008.png" }}" />

- 실제로 이 코드는 컴파일 오류가 발생한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/009.png" }}" />

- 재구성에서 quantity를 재사용하려면 Composition의 일부로 만들어야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/010.png" }}" />

- `remember` composable 함수를 사용하여 Composition에서 사용할 수 있다
- 가변/불변 객체 모두 사용 가능하다

State created in composables needs to be `remembered`

- 상태를 기억하는 것은 Composable 함수 내부에서 생성된 상태에 대해서 해야 하는 작업이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/011.png" }}" />

- 상태는 Composition의 일부가 되고 함수가 재구성될 때 재사용된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/012.png" }}" />

- `rememberSavable`는 Activity/프로세스 재생성, Configuration 변경 시에 상태를 유지하는 방법이다
- UI 상태에 적합하지만, 일시적인 애니메이션 상태 같은 항목에는 적합하지 않다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/013.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/014.png" }}" />

- `by` 키워드로 Property 대리자(delegate)를 사용할 수 있다. 항상 value 속성에 접근하지 않아도 된다
- Composable은 자주 실행되고 어떤 순서로든 실행할 수 있으므로 Composable 함수 범위 밖에서만 상태를 변경해야 한다
- 사용자 입력 및 Side-effects를 사용하여 상태 변경을 트리거 할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/015.png" }}" />

- quantity는 항상 1로 초기화하므로 재사용 및 원하는 초기값 대응을 위해서 의존성 주입과 유사하게 함수의 파라미터로 전달받아야 한다
- 전달된 quantity는 `단일 정보 소스 원칙`을 위해 변경되지 않아야 한다. 데이터는 한 곳에서만 수정되도록 코를 구조하도록 권장한다
- CartItem이 상태를 갖지 않으면 업데이트하지 않아야 한다
- 그로 인해 버튼과 같은 상호 작용에 의한 상태 업데이트를 트리거하도록 호출한 곳에 알릴 필요가 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/016.png" }}" />

- CardItem을 재사용할 수 있으므로 각 quantity와 상태 업데이트 로직은 Cart Composable이 해당 로직을 가지고 있어야 한다고 생각할 수 있다
- CartItem을 재사용 가능하게 만드는 과정을 `상태 호이스팅(state hoisting)`이라고 한다
  - Composable을 Stateless로 만들기 위해 상태를 Composable의 호출자로 옮겨 재사용할 수 있도록 하는 패턴이다

> State hoisting : https://developer.android.com/jetpack/compose/state#state-hoisting

- Stateless Composable은 상태를 일체 가지지 않는 Composable이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/017.png" }}" />

- Composable은 상태를 파라미터로 수신, 람다로 이벤트를 전달한다
- 더 재사용 가능해지고 테스트할 수 있다
- 호이스팅된 상태는 필요에 따라 공유/가로챌 수 있다
- 단일 정보 소스 원칙을 준수해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/018.png" }}" />

> Stateless한 Composable CartItem

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/019.png" }}" />

- Cart는 LazyColumn을 사용해 장바구니 항목을 표시하는 CartItem을 호출하는 역할을 한다
- 실제 데이터는 CartViewModel을 통해서 전달된 데이터이다.
- 특정 quantity를 전달하며, 항목의 증가/감소는 데이터 소유자인 viewModel에 위임한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/020.png" }}" />

- 상태 호이스팅은 Compose에서 널리 사용되는 패턴이다
- 많은 Compose API에서 UI 요소에서 내부적으로 사용되는 상태를 가로채고 제어한다
- 가로채는 상태는 선택 사항이므로 기본 파라미터로도 존재한다.

Hoist state to at least the `lowest common ancestor` of its consumers

- 실제 상태를 관리하는 것은 데이터 소유권의 문제이다. 불확실한 경우 해당 상태를 액세스하는 Composable의 가장 낮은 공통 위치로 상태를 호이스트한다
  - CartItems의 가장 낮은 공통 조상은 Cart이다.

Composable parameters: pass only what they need

> Composable은 필요한 파라미터만 취해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/021.png" }}" />

> 비즈니스 로직과 상태를 처리하는 ViewModel을 사용하면 stateless한 Card Composable이 가능해진다

- 테스트하기 쉬워지며
- 단일 정보 소스 원칙을 준수하며
- 재사용 가능성이 높아진다
- 상태 저장 재정의도 가능해진다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/022.png" }}" />

- Stateful 혹은 Stateless 패턴은 필요한 경우 재사용할 수 있는 Composable로 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/023.png" }}" />

- 다양한 상태를 관리 및 정의하는 방법은 다양하다
- Composables : 간단한 UI 요소를 관리
- State holder : 복잡한 UI 요소를 관리
- Architecture Components ViewModel : 비즈니스 로직에 대한 액세스를 제공, 화면을 위해 앱 데이터를 준비하는 타입의 상태 관리자

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/024.png" }}" />

- UI 요소 상태 : UI 요소의 호이스트 상태 (ex: ScaffoldState)
- 화면 혹은 UI 상태 : 화면에 표시되는 것 (ex: CartUiState)
  - 앱 데이터를 포함하므로 다른 계층과 연결된다
- UI 동작 논리 : 화면에 상태 변경을 표시하는 방법과 관련됨 (ex: Navigation 로직, SnackBar 표시)
  - `항상 Composition에 있어야 한다`
- 비즈니스 로직 : 무엇으로 상태 변경을 처리할 것인가 (ex: 돈을 지불하거나 기본 설정을 저장하는 것 등)
  - 비즈니스 혹은 데이터 계층에 배치

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/025.png" }}" />

- 처리할 UI 요소 상태가 단순하면 Composable 자체에 둘 수 있다
  - JetsnackApp은 scaffoldState를 가지고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/026.png" }}" />

- scaffoldState은 변경 가능한 속성이 포함되므로 상호 작용은 같은 Composable 함수에서 발생해야 한다
- 다른 곳에 상태 변경을 전달하면 **단일 정보 소스 원칙에 위배된다**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/027.png" }}" />

- 복잡한 UI 노출 및 화면 이동 등 모든 것이 Composable에 있으면 읽고 이해하기 어렵다
- 관심사 분리 원칙에 따라 UI 로직과 UI 요소 상태를 `State holder`라는 별도의 클래스에 위임하고 Composable 함수는 UI만 내보내도록 정리할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/028.png" }}" />

- JetsnackAppState는 JetsnackApp의 UI 요소 상태에 대한 정보 소스이므로 모든 상태 쓰기는 해당 클래스 내에서 일어나야 한다
- 해당 State holder는 Composition에서 생성 및 remember되는 일반 클래스이다
- 이를 생성하는 Composable에 범위가 지정된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/029.png" }}" />

- JetsnackAppState는 일반 클래스 및 Composable 수명주기를 따르므로 메모리 누수에 대한 걱정 없이 Composable 종속성을 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/030.png" }}" />

- State holder는 재구성을 발생시키는 Composable 프로퍼티도 가질 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/031.png" }}" />

- Navigation 로직과 같은 UI 관련 로직도 포함한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/032.png" }}" />

- 재구성에서 재사용하기 위해 remember를 사용한다
- 종속성이 있는 경우 State holder를 remember하는 방법을 제공하는 것도 좋다
  - 종속성이 변경되는 경우, 새로운 인스턴스를 가져오기 위해 기억할 종속성을 전달한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/033.png" }}" />

- 호이스트된 상태를 Composable에 전달한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/034.png" }}" />

- UI 요소를 표시해야 하는 시기를 확인한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/035.png" }}" />

- UI 관련 작업을 트리거하는 함수를 호출하는데 사용하는 appState 인스턴스를 얻는다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/036.png" }}" />

State holder란

- UI 요소 상태를 끌어올리고 UI 관련 로직을 포함하는 일반 클래스
- Composable의 복잡성을 줄이고 테스트 가능성을 높여 관심사를 분리하는데 유리
- 호이스트할 상태가 하나만 있기 때문에 상태 호이스팅이 더 쉽다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/037.png" }}" />

State holder는 간단하고 집중할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/038.png" }}" />

State holder 이외에도 ViewModel을 사용해 비즈니스 로직에 의해 결정되는 상태에 대한 State holder로 사용할 수 있다

ViewModel의 책임

1. Repository와 같이 다른 계층에 배치되는 앱의 비즈니스 로직에 대한 액세스를 제공한다
2. 특정 화면에 표시할 앱 데이터를 준비한다

Compose에서는 Compose의 상태 유형을 사용할 수 있다. 하이브리드 앱에서는 StateFlow를 사용한 observable 형태로 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/039.png" }}" />

- ViewModel은 Configuration 변경 후에도 유지되므로 Composition보다 수명이 길다. 
- Composition 범위로 상태를 얻을 수 없다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/040.png" }}" />

- 상태 변경 시 UI를 재구성하려면 Compose State API를 사용해야 한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/041.png" }}" />

- Composition 외부에 유지되므로 remember를 사용할 필요는 없다.
- 단순히 소비하면 되고, 변경될 때마다 다시 실행될 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/042.png" }}" />

- 데이터 스트림을 사용하여 변경 사항을 전파할 경우 `Flow`를 사용하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/043.png" }}" />

- 데이터 스트림을 Compose에서 관찰 가능한 상태 API로 변환하는 함수가 있으므로 Compose와도 완벽하게 작동한다
- `collectAsState()` API는 Flow에서 값을 수집하고 상태를 나타내므로 새 값이 Flow으로 방출될 때마다 재구성이 발생한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/044.png" }}" />

ViewModel은

- Composition에서 상태를 끌어올리고 수명이 더 길다
- 화면의 비즈니스 로직과 표시할 데이터를 결정한다
- 다른 계층에서 데이터를 수집하고 표시하기 위해 준비한다
- 화면 레벨에 맞는 Composable에 사용을 권장한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/045.png" }}" />

ViewModel이 일반 State holder보다 나은 이점은 아래와 같다

- ViewModel에 의해 트리거된 작업은 Configuration 변경 후에도 유지된다
- Hilt 및 Navigation과 같은 Jetpack 라이브러리와 잘 통합된다
- Navigation 사용 시 BackStack에 있는 동안 ViewModel을 캐시한다.
  - BackStack에서 제거되면 ViewModel이 지워지므로 상태가 자동으로 정리된다

위 사항을 Composable 화면의 수명 주기를 따르는 State holder로 대응하기가 더 어렵다.

화면 수준 Composable에 State holder와 ViewModel이 있을 수도 있고, ViewModel의 수명이 더 길기 때문에 State holder는 ViewModel을 종속성으로 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/046.png" }}" />

- 실제로 적용하면 Cart Composition 요소에 있는 CartViewModel 외에도 UI 요소 상태 및 UI 로직을 포함하는 추가 CartState를 가질 수 있다. 
- ViewModel과 State holder 둘 다 Cart에 위치하며 다른 목적으로 함께 일한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/047.png" }}" />

- CartState는 Cart 구성 요소의 수명주기를 따른다.
- CartViewModel의 범위는 Navigation 목적지, Graph, Fragment, Activity에 따른 다른 수명 주기로 지정된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/048.png" }}" />

- 각 개체의 역할이 명확하게 정의되어 있다.
- 역할이 있는 다양한 엔티티와 이들 간의 잠재적 종속 관계를 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/A-Compose-state-of-mind/049.png" }}" />
