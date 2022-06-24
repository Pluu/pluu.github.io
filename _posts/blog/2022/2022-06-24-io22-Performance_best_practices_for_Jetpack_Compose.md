---
layout: post
title: "[요약] Performance best practices for Jetpack Compose (Google I/O '22)"
date: 2022-06-24 10:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io22
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/EOQB8PTLkpY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

Compose의 목표

- 즉시 사용할 수 있는 UI 시스템을 제공
- 자연스럽게 코드를 작성

## Configuration

> 성능과 관련하여 앱을 올바르게 구성하는 방법

### 성능 테스트 및 평가를 위해 앱을 구성하는 방법

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/001.png" }}" /> 

Compose 앱의 성능을 평가할 때 `R8 최적화가 활성화된 릴리스 모드`에서 실행 중인지 확인하는 것이 중요하다.

Android Runtime이 디버깅을 위해 최적화를 해제하기 때문에 디버그로 배포될 때 속도가 느리다. 디버그에서 실행할 때 비활성화되는 많은 최적화는 버벅거림이 없는 애플리케이션에 중요하다.

`앱에서 성능 문제가 발견되면 먼저 릴리스 모드에 문제가 있는지 확인해야 한다.`

## Gotchas

> 일반적인 문제를 살펴보고 이를 방지하기 위한 모범 사례를 설명

### 1. something to remember

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/002.png" }}" /> 

목록이 재구성될 때마다 재정렬되지만, Composable은 자주 실행될 수 있으므로 이에 염두에 두어 작성해야 한다.

실제로 이 예제는 화면에 새 Row가 나타날 때마다 연락처 목록을 재정렬한다. 새 Row가 나타나면 `LazyList composition scope`가 무효화되기 때문이다. 그 후 Compose가 재구성을 한다.

즉, 모든 코드가 다시 실행된다는 것을 의미한다.

정렬은 이 범위 안에 있기 때문에, 정렬은 모든 recomposition에서 호출된다.

#### 1) remember {}

`remember 함수`를 사용하여 값비싼 작업이나 할당을 필요할 때만 실행되도록 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/003.png" }}" /> 

정렬을 remember 함수로 이동할 수 있다. 

연락처 목록과 sortComparator를 사용하여 remember 함수의 키를 지정한다. 키 중 하나가 변경될 때마다 목록이 재정렬되지만 모든 recomposition에 재정렬되지는 않는다.

더 최적의 개선 사항은 이 정렬을 **ViewModel 또는 Data Source로 이동**하는 것이다. 필요할 때만 Compose 상태를 변경함으로써 가능한 가장 낮은 오버헤드를 갖게 된다.

#### 2) LazyList Key

LazyList에서 항목에 대한 키를 정의할 수 있다. 키를 제공하지 않으면 해당 Item의 위치를 키로 사용한다. 

Item이 List에서 이동할 때 그 뒤의 모든 Item도 재구성되므로 성능이 나빠질 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/004.png" }}" /> 

items 함수에 키 람다를 추가하면 키를 제공할 수 있다. 이 떄 중요한 것은 `각 키가 고유해야 한다`는 것이다.

이제 Item이 List에서 이동할 때 Compose는 이동된 Item을 알고 해당 Item만 재구성하면 된다.

또한 키는 최적화 외의 다양한 용도로 사양된다.

#### 3) Deriving change / derivedStateOf {}

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/005.png" }}" /> 

위로 스크롤하는 버튼을 추가해야 할 때에는 목록이 아래로 스크롤 된 후에만 표시해야 한다.

첫 번째 보이는 **아이템 인덱스가 0보다 클 때** true가 되는 showButton이라는 Boolean 변수로 대응할 수 있다.

다만, 위 구현은 문제가 있다.

LazyList는 모든 스크롤의 모든 프레임에서 listState 변수를 업데이트하고 읽으므로 필요 이상의 recomposition이 일어난다.

첫 번째 표시되는 인덱스가 0에서 또는 0으로 변경에만 관심이 있다.

Compose에서는 이것을 위해서 `derivedStateOf` 함수를 제공한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/006.png" }}" /> 

`derivedStateOf`는 자주 변경되는 상태를 가져와 필요한 변경 사항만 버퍼링한다.

> 이미지의 예에서는 firstVisibleItemIndex가 0보다 큰 경우이다.

derivedStateOf를 기억하는 함수로 래핑한다. 이것으로 이 조건이 실제로 변경될 때만 재구성된다.

List를 아래로 스크롤 할 때 한 번, 위로 스크롤 할 때 다시 한번 일어난다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/007.png" }}" /> 

derivedStateOf가 좋지 않은 케이스로는 어떤 상태에서 변수를 생성할 때마다 사용할 필요는 없다.

실제로 변경 사항을 버퍼링하지 않기 때문에, derivedStateOf는 실제로 약간의 오버헤드를 가져오고 중복된다.

#### 4) 지연 처리 / Reading state

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/008.png" }}" /> 

UI의 배경에 애니메이션 효과를 준다고 가정하겠다. Cyan과 Magenta로 반복적으로 애니메이션을 해야 한다.

잘 동작하는 것 같지만, 잠재적인 최적화 이슈가 있다. 실제로 Compose에 필요 이상으로 많은 작업을 요청한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/009.png" }}" /> 

애니메이션에서는 이 코드를 모든 프레임에서 재구성된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/010.png" }}" /> 

Compose는 Composition, Layout, Draw 세 가지 단계가 있다.

첫 번째 단계 **Composition**은 composable 함수를 실행한다.

- 애플리케이션의 콘텐츠를 생성/업데이트하고 다음 두 단계에서 수행할 작업을 정의한다.

두 번째 단계인 Layout에서는 Composition에 의해 정의된 콘텐츠가 측정되어 화면에 나타날 위치에 배치된다.

- 텍스트, Row, Column과 같은 다른 Composable 함수에 대한 Modifier와 호출을 고려하고 단일 패스에서 모든 콘텐츠를 측정하고 배치한다.

마지막 단계인 **Draw**에서는 애플리케이션의 캔버스에 내용을 그린다.

- 해당하는 케이스는 선, 호, 직사각형, 이미지 및 텍스트 그리기와 같은 기본 요소이다.
- 이전 단계인 레이아웃에 의해 결정된 위치에 그려진다.

이 세 단계는 읽은 데이터가 변경되는 모든 프레임에서 반복된다. 그러나 **데이터가 변경되지 않으면 하나 이상의 단계를 건너뛸 수 있다**.

```kotlin
val color by animateColorBetween(Color.Cyan, Color.Magenta)
Box(Modifier.fillMaxSize().background(color))
```

이 코드는 애니메이션이 적용되기 때문에 모든 프레임에서 색상이 변경되므로 모든 프레임에 대해 `Composition도 발생`합니다.

다른 색상만 그리기 때문에 Composition, Layout 단계를 건너뛰고, Box를 새로운 색상으로 다시 그릴 수 있다면 좋다.

필요할 때까지 상태 읽기를 연기하는 것은 Compose의 중요한 개념이다.

읽기를 연기하면 다시 실행해야 하는 함수의 수를 줄일 수 있으며 Composition, Layout을 완전히 건너뛸 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/011.png" }}" /> 

여기에서는 background 대신 `drawBehind`를 사용한다.

drawBehind는 Compose의 Draw 단계에서 호출되는 함수 인스턴스를 사용한다. 색상 값을 읽는 유일한 시점이므로 색상이 변경되면 Draw 단계의 결과만 변경하면 된다. Draw를 다시 실행해야 하는 유일한 단계가 되어 Compose에서 Composition, Layout을 모두 건너뛸 수 있다.

여기서 중요한 것은 합성 함수가 아니라 함수 인스턴스의 색상 상태를 읽는 것이다. 함수 인스턴스는 변경되지 않으므로 읽는 변수는 동일하다. Composition 관점에서 변경된 사항은 없으므로 이 기능을 다시 실행할 필요가 없다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/012.png" }}" /> 

함수 인스턴스의 상태를 읽고 매개변수로 전달하는 것은 단계를 건너뛸 수 있을 뿐만 아니라 필요한 코드의 양을 줄이는 데에도 사용할 수 있는 방법이다.

연락처의 이름이 변경되면 Text에 대한 호출만 다시 실행된다. ContactCard 및 MyCard에 대한 호출은 연락처 이름을 읽지 않으므로 건너뛴다.

Text에 대한 호출만 수행되며, 이는 함수 인스턴스에서 캡처된다.

#### 5) Running backwards / Backwards write

이번 장에서 소개하는 문제는 항상 피해야 하는 코드이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/013.png" }}" /> 

잔액의 합계를 계산하기 위해서, 위와 같이 계산한 다음 트랜잭션과 새 잔액을 표시할 수도 있다.

실제 위 코드는 문제가 있으며, System trace를 했을 때 문제가 있음을 깨닫는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/014.png" }}" /> 

메인 스레드가 예상보다 훨씬 더 바쁘다는 것을 알게 된다. 화면이 바뀌지 않기 때문에 Idle 상태가 될 것으로 예상할 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/015.png" }}" /> 

System trace 결과 재구성 Marker가 모든 프레임에 있음을 알 수 있다.

Composition은 항상 일어나며 무한으로 동작하고 있다.

문제는 잔액을 업데이트하는 라인이며, 이 코드는 Compose의 핵심 가정을 위반하고 있다.

Compose는 값을 읽은 후에는 Composition이 완료될 때까지 변경되지 않는다고 가정한다. Composition에서 이미 읽은 값을 절대로 수정하면 안 된다.

> 이미 읽은 데이터를 새롭게 업데이트하는 것을 "Backwards write"라고 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/016.png" }}" /> 

for-loop를 풀어쓰면 **Backwards write**가 분명해진다. balance를 읽기 전에 쓰기 처리를 하는 것이 좋다.

Composition에서 오래된 것으로 판단되면 다음 프레임에 대해 새 Composition을 예약한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/017.png" }}" /> 

이 코드가 더 나은 버전이며 또한 상태를 완전히 작성하는 것을 피한다. 그리고 Composable 함수는 처음 표시될 때 한 번만 실행한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/018.png" }}" /> 

코드를 변경한 후 System trace를 재수행하면 기대했던 결과를 볼 수 있다. Main 스레드는 처음에 사용하고 Idle 상태가 된다. 

Transaction List가 표시될 때 Composition이 한 번 실행되고 다시 실행되도록 예약되지 않음을 알 수 있다.

> "Backwards write"를 방지하려면 이미 읽은 상태에 쓰면 안 된다.

#### 6) Baseline Profiles

Android Studio에서 앱을 실행할 때 처음 몇 초 동안 버벅거림이 있고 난 후에는 매끄럽게 나타난다.

이것은 Just-In-Time 컴파일의 효과이다. Android Studio에서 실행할 때 코드가 해석될 때, 시작 시에 성능이 떨어지는 경우가 많다.

그렇지만 사용자는 Baseline Profiles 덕분에 사용자는 이런 것을 볼 수 없을 것이다.

앱에 Baseline Profiles을 추가하면 시작 속도를 높이고 버벅거림을 줄이고 성능을 개선하는 데 도움이 될 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/019.png" }}" /> 

Compose는 번들로 제공되지 않는 라이브러리이기 때문에 이전 Android 버전 및 기기를 지원할 수 있다. 그리고, 새로운 기능 및 버그 수정으로 Compose를 쉽게 업데이트할 수 있다.

Android 업그레이드를 기다릴 필요가 없다.

그러나 일부 단점도 존재한다.

Android는 앱 간에 Toolkit 클래스 및 Drawable 등 시스템 리소스를 공유한다. 이렇게 하면 시작 시간이 빨라지고 메모리 사용량이 줄어들게 된다.

그러나, 번들화되지 않은 라이브러리인 Compose는 이 공유에 참여하지 않으며 앱의 또 다른 부분으로 취급된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/020.png" }}" /> 

사용자가 Play 스토어에서 앱을 설치하면 기기에 다운로드된 APK에는 모든 코드와 앱과 함께 번들로 제공되는 모든 라이브러리가 포함되어 있다.

시작 시 이 코드는 Android 런타임에 의해 해석되고 기계어 코드로 컴파일되어야 한다. 이 프로세스는 시간이 걸리므로 성능이 저하될 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/021.png" }}" /> 

Play Store에는 개선을 위해 Cloud Profile이 있다. 이후 Play Store는 앱 시작 시 사용된 클래스 및 메서드 등 시작하는 동안 앱에서 사용하는 코드 목록을 집계한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/022.png" }}" /> 

Play Store에서 이 프로필을 앱 다운로드와 함께 전달된다. 앱 설치 시 Android 런타임은 이 데이터를 사용하여 나열된 클래스 및 메서드를 미리 컴파일한다. 그러면 앱 시작할 때 해석할 것이 더 적어진다.

그러나 앱을 자주 업데이트하는 경우에는 실제로 적용되는 효과를 못 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/023.png" }}" /> 

Baseline Profiles은 이 목록을 Play Store에서 직접 제공하는 방법입니다. 사용자가 앱을 다운로드하면 설치 시 항상 프로필 데이터를 사용할 수 있도록 Play Store에 Baseline Profiles이 포함된다. 따라서 런타임은 미리 컴파일할 항목을 알고 있다.

그리고, Cloud Profile 데이터를 지속적으로 집계하여 더욱 개선될 것이다.

Compose는 기본적으로 APK에 포함되는 자체 Baseline Profile과 함께 제공된다. Baseline Profiles의 이점을 보기 위해 추가 작업을 수행하지 않아도 된다.

Android Studio에서 실행할 때는 Baseline Profile은 포함되지 않는다. 따라서 로컬 테스트에서는 이러한 이점을 얻을 수 없다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/024.png" }}" /> 

테스트 라이브러리인 Macrobenchmark를 사용하여 Baseline Profile로 시작하도록 앱을 구성할 수 있다. 이 기능은 Play Store에서 설치할 때 사용자가 처음 실행하는 환경을 테스트하는 데 유용하다.

다만, Compose 라이브러리에 최적화된 프로필이 이미 포함되어 있기 때문에 프로필을 조정하고 최적화해야 하므로 별도의 Baseline Profile을 추가해도 성능 향상이 보장되지 않는다.

Baseline Profile을 추가하는 경우 실제로 메트릭이 개선되는지 테스트해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Performance_best_practices_for_Jetpack_Compose/025.png" }}" /> 

Baseline Profile을 추가함으로써

- Composite 샘플 중 하나인 Jetsnack은 시작 성능이 22% 향상
- Google 지도는 평균 시작 시간을 30% 개선
- Play Store는 검색 페이지의 초기 렌더링 시간을 40%까지 개선
