---
layout: post
title: "[요약] Kotlin Flows in practice (Android Dev Summit '21)"
date: 2021-11-07 16:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/fSB6_KE95bU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/001.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/002.png" }}" />

데이터를 Flow에 로드, 변환하고 표시되도록 View에 노출하는 방법을 살펴본다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/003.png" }}" />

- View 시작이 ViewModel에 데이터를 요청 후 ViewModel이 Data Layer에 데이터를 요청한다. 응답 시에는 반대로 동작한다.
- suspend를 사용하면 쉽게 수행할 수 있다.
- 그러나, 몇몇 인프라에 투자하면 효과를 더 얻을 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/004.png" }}" />

- 데이터를 요청하는 대신 관찰하는 것이다.
- 관찰자는 관찰 대상의 변화에 자동으로 반응하기 때문에 이러한 패턴을 사용하는 시스템을 반응형(Reactive)이라고 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/005.png" }}" />

- 중요한 설계 중 하나는 데이터 흐름을 한 방향으로만 유지하는 것이다. 오류가 발생하기 어렵고, 관리하기 쉽기 때문이다
- 다양한 작업이 View를 통해서 이루어지는 것은 가능하지만 버그가 발생하기 쉽다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/006.png" }}" />

- 더 좋은 방법은 데이터가 한 방향으로만 흐르도록 하여 데이터 스트림을 결합하고 변환하기 위한 형태로 만드는 것이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/007.png" }}" />

- Flow는 사용자 데이터 또는 UI 상태와 같은 모든 타입을 사용할 수 있다.
- Producer : 소비자가 Flow에서 수집할 데이터를 내보낸다 (emit)
- Data Source 혹은 Repository가 화면에 데이터를 표시하기 위해 데이터를 만드는 생산자이다.

### Creating Flows

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/008.png" }}" />

- 대부분 Flow를 직접 만들 필요는 없다
- DataSource, Refotift, Room, WorkManager 라이브러리는 이미 Coroutine 및 Flow를 지원한다
- 데이터가 어떻게 생성되는지 모른 채 연결하기만 하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/009.png" }}" />

- Room을 예로 들면, Flow를 외부로 노출하여 데이터 베이스의 변경사항에 대한 알림을 받을 수 있다.
- Room 라이브러리가 생성자 역할을 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/010.png" }}" />

- Flow를 직접 만들어야 할 경우의 대안 중 하나는 `Flow builder`이다.
- Flow builder는 `flow` 블록을 시작으로 일시 중단하도록 안내한다. Flow는 Coroutine Context에서 실행되기 때문에 suspend 함수 호출도 가능하다
- `emit` suspend 기능을 사용하여 결과를 Flow에 추가할 수 있다
- 데이터 수집기가 항목을 받을 때까지 coroutine이 일시 중단하며, 마지막으로 coroutine을 잠시 중단한다.
- Flow에서의 작업은 동일한 Coroutine에서 순차적으로 실행한다
- while true 루프로 인해 이 Flowsms 관찰자가 사라지고, 수집을 중지할 때까지 최신 메시지를 계속 가져온다
- Flow builder로 전달되는 suspend 블록을 **Producer block**이라 한다

### Collecting Flows

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/011.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/012.png" }}" />

- 스트림의 시작점을 Flow으로 간주하면 `map` 연산자를 사용하여 다른 타입으로 변환할 수 있다
- 각 연산자는 기능에 따라서 데이터를 내보내는 새 `Flow`를 만든다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/013.png" }}" />

- Stream을 필터링도 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/014.png" }}" />

- Flow에서 오류는 `catch` 연산자를 사용하여 Upstream Flow에서의 예외를 catch 할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/015.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/016.png" }}" />

- Upstream Flow는 생산자 블록과 현재 블록보다 먼저 호출된 연산자에 의해 생성된 flow를 말한다
- 현재 연산자 이후에 발생하는 것을 Downstream Flow라고 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/017.png" }}" />

- catch 한 예외를 다시 throw 하거나 새로운 값을 내보낼 수 있다

### Observing Flows

흐름 수집은 일반적으로 UI 레이어에서 일어난다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/018.png" }}" />

> 다음 샘플은 최신 메시지를 목록에 표시하여 진행 상황을 파악하려는 예이다.

- 값 수신을 시작하려면 terminal 연산자를 사용해야 한다
- 스트림의 값을 얻으려면 `collect` 연산자를 사용하며, suspend 함수의 결과이므로 Coroutine 내에서 실행되어야 한다.
- Flow에 terminal 연산자를 적용하면, Flow가 값을 내보내기 시작한다
- intermediate 연산자의 경우, 값이 Flow로 방출될 때 느리게 실행되는 작업 체인을 설정한다
- Flow에 대해서 collect가 호출될 때마다 새로운 Flow가 생성된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/019.png" }}" />

- 생산자 블록은 자체 간격으로 API의 결과로 submitList를 호출한다
- Coroutine에서는 이러한 타입의 Flow를 요청 시 생성되고 관찰될 때만 데이터를 방출하기 때문에 Flow라고 한다

### Flows in Android UI

Android UI에 Flow를 최적으로 수집 시에 주요 사항이 있다

1. 앱이 백그라운드에 있을 때 리소스를 낭비하지 않는 것
2. Configuration 변경

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/020.png" }}" />

위와 같은 코드가 있다고 가정하며 이야기를 진행한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/021.png" }}" />

- UI는 화면에 표시되지 않을 때에는 Flow에서 수집을 중지해야 한다.
- UI 생명주기를 알고 있는 기능이 제공되고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/022.png" }}" />

- asLiveData Flow 연산자 : UI가 화면에 표시되는 동안에만 값을 관찰하는 LiveData와 Flow를 비교한다. 
- ViewModel에서 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/023.png" }}" />

- UI에서는 기존처럼 LiveData를 사용하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/024.png" }}" />

- `RepeatOnLifecycle`은 UI 계층에서 Flow를 수집하는 데 권장하는 방법이다.
- 생명 주기 단계를 매개변수로 받는 suspend 함수이다.
- 생명 주기를 인식해 해당 단계에 도달하면 블록과 함께 새 Coroutine을 자동으로 시작한다. 해당 상태의 아래로 떨어지면 진행 중인 Coroutine이 취소된다
- repeatOnLifecycle은 suspend 함수이므로 Coroutine에서 호출해야 한다
- Activity에서는 lifecycleScope를 사용하면 된다.
- 생명 주기가 초기화되는 onCreate에서 호출하는 것이 좋은 방법이다
- 생명 주기가 DESTROYED 될 때까지 실행을 재개하지 않는다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/025.png" }}" />

- 여러 Flow에서 수집해야 하는 경우 repeatOnLifecycle 블록 내에서 사용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/026.png" }}" />

- Flow가 하나만 있는 경우 `flowWithLifecycle` 연산자를 사용할 수도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/027.png" }}" />

> 액티비티가 처음 생성하고서 사용자가 홈 버튼을 눌러 백그라운드로 이동한 후 다시 앱을 열었을 때의 모습이다

1. STARTED 상태로 repeatOnLifecycle을 호출하면 UI가 화면에 노출되는 동안 Flow 방출을 처리
2. 앱이 백그라운드로 이동하면 collect가 취소

repeatOnLifecycle 및 flowWithLifecycle은 `lifecycle-runtime-ktx:2.4.0`에 추가된 API이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/028.png" }}" />

- lifecycleScope에서 시작한 Coroutine에서 직접 수집할 수 있다. 이러한 방식으로 Flow를 수집하는 것이 항상 안전한 것은 아니다.
- 앱이 백그라운드에 있더라도 Flow에서 수집하고 UI 요소를 업데이트한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/029.png" }}" />

- lifecycleScope.launch 및 lifecycleCoroutineScope.launchWhenX API에서도 발생할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/030.png" }}" />

- lifecycleScope.launch에서 수집하는 경우 Activity가 백그라운드에 이동하더라도 Flow의 업데이트를 계속 수신한다
  - 이 문제의 해결법은 수동으로 onStart에서 수집하고 onStop에서 중지하는 것이다
  - repeatOnLifecycle를 사용하면 이런 코드를 제거할 수 있다.
- 대안으로 launchWhenStarted를 보면 앱이 백그라운드에 있는 동안 Flow 수집을 일시 중단하기 때문에 lifecycleScope.launch보다 낫다.
  - 이 방법도 Flow 생산자를 활성 상태로 유지하므로, 화면에 표시하지 않는 항목으로 메모리를 많이 소비할 가능성이 있는 항목을 백그라운드에서 방출할 가능성이 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/031.png" }}" />

- UI는 Flow 생성자가 어떻게 구현되는지 실제로 알지 못하기 때문에 항상 안전하게 실행해야 한다.
- UI가 백그라운드에 있을 때 항목을 수집하고 Flow 생산자를 활성 상태로 유지하지 않으려면, repeatOnLifecycle 또는 flowWithLifecycle을 사용하는 것이 좋다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/032.png" }}" />

- View에 Flow를 노출하려면 생명 주기가 다른 두 요소 간에 데이터를 전달하려고 한다는 점을 고려해야 한다.
- 디바이스가 회전되거나 구성 변경 사항이 수신되면 모든 작업이 다시 시작될 수 있지만 ViewModel은 그대로 유지된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/033.png" }}" />

- 이와 같은 call flow는 처음 수집될 때마다 발생하므로 Repository는 회전 후에 다시 호출한다
- 데이터를 보유하고 몇 번 재생성 하더라도 여러 수집기 간에 공유할 수 있는 버퍼가 필요할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/034.png" }}" />

- `StateFlow`가 바로 그런 용도로 만들어졌다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/035.png" }}" />

- StateFlow는 수집하는 대상이 없어도 데이터를 보유한다.
- 여러 번 수집할 수 있으므로 Activity/Fragment와 함께 사용하는 것도 안전하다
- MutableStateFlow를 사용해서 원할 때마다 값을 업데이트할 수 있다
- 위와 같은 형태는 `reactive`하지 않은 표현이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/036.png" }}" />

- 모든 Flow는 StateFlow로 변환할 수 있다
- StateFlow는 업스트림 Flow에서 업데이트를 수신하고 최신 값을 저장한다
- 다양한 Flow가 존재하지만 StateFlow는 정확하게 최적화할 수 있으므로 권장한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/037.png" }}" />

- Flow를 StateFlow로 변환하기 위해 `stateIn` 연산자를 사용할 수 있다
- initialValue : 항상 값이 존재해야 하므로 초기값으로 지정
- scope : Coroutine이 시작되는 Scope

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/038.png" }}" />

WhileSubscribed(5000)이 유의미한 몇 가지의 시나리오가 있다.

1. Flow의 수집기인 Activity가 순식간에 destory되었다가 recreate 되는 케이스
2. 앱이 백그라운드에 있는 홈으로 이동하는 케이스

2번째 시나리오에서는 배터리 및 기타 리소스를 절약하기 위해 모든 Flow를 중지한다. 이러한 케이스들은 `Timeout`으로 이루어진다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/039.png" }}" />

StateFlow가 수집을 중지하면 모든 업스트림 Flow를 즉시 중지하지 않는다. 대신에, 예를 들어 5초 동안 기다린다. Timeout 전에 Flow가 다시 수집되면 업스트림 Flow는 취소되지 않는다. 이것이 **WhileSubscribed(5000)**가 하는 일이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/040.png" }}" />

> 앱이 백그라운드로 일어날 때 발생하는 다이어그램

1. 홈 버튼을 누르기 전에 View는 업데이트를 수신하고 StateFlow는 정상적으로 생성되는 업스트림 Flow를 가진다.
2. View가 중지되면 수집이 즉시 종료됩니다.
3. StateFlow는 구성 방식 때문에 업스트림 Flow를 중지하는 데 5초가 걸린다. 
4. Timeout 되면 업스트림 Flow가 취소된다
5. 사용자가 앱을 다시 열면 업스트림 Flow가 자동으로 다시 시작된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/041.png" }}" />

> 디바이스를 회전할 때 발생하는 다이어그램

View는 5초 미만의 매우 짧은 시간 동안만 중지된다. StateFlow는 복원되지 않고 모든 업스트림 Flow를 활성 상태로 유지한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/042.png" }}" />

StateFlow를 사용하여 ViewModel에서 Flow를 노출하거나 정확히 동일한 작업을 수행할 시에 사용하는 것이 좋다.

### Testing Flows

#### 첫 번째 테스트, UnitTest에서 Flow를 수신

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/043.png" }}" />

테스트하는 쉬운 방법은 종속성을 FakeFlow 생산자로 바꾸는 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/044.png" }}" />

이 예에서는 간단한 호출 Flow와 같이 다양한 테스트 사례에 필요한 모든 것을 내보내도록 Fake Repository를 만들 수 있다.

#### 두 번째 테스트, 테스트 대상이 Flow를 노출하고 있고 해당 값 또는 값의 Flow을 확인하려는 경우

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/045.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/046.png" }}" />

- Flow에서 첫 번째 메소드를 호출하면 첫 번째 항목을 수신할 때까지 수집하고, 그 이후는 수집을 중지할 수 있다
- take(5)와 같은 연산자를 사용하여, 정확히 5개의 메시지를 수집할 수 있다

### Resources

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Kotlin-Flows-in-practice/047.png" }}" />
