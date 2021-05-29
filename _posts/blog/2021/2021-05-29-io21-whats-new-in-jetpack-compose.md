---
layout: post
title: "[요약] What's new in Jetpack Compose (Google I/O '21)"
date: 2021-05-29 11:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/7Mf2175h3RQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

Compose는 Android의 최신 네이티브 UI 도구 키트이다

- 현재 베타버전이며 곧 1.0이 출시된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/001.png" }}" />

- 처음부터 개발을 빠르게 하도록 설계되었다
- 훨씬 적은 코드로 UI를 구현할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/002.png" }}" />

- View 기반의 기존 Toolkit은 10년 넘게 사용했다
- 기기 성능도 향상되었고 앱에 대한 기대감도 커졌다
- UI는 훨씬 동적이고 다양하게 표현한다
- 기존 Views로도 개발할 수 있지만, 최신 아키텍처를 기반으로 하며 Kotlin을 활용하는 최신 도구 키트 요청이 많았다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/003.png" }}" />

- 구글 또한 기능 및 개선 사항을 빠르게 적용하길 원한다
- 선언적 독립형 도쿠 키트인 Jetpack Compose를 3년 전부터 개발하기 시작했다

### `Declarative` UI Toolkit

Compose의 2가지 개념

### Declarative

- 요즘 앱은 데이터가 동적이며 실시간으로 업데이트된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/004.png" }}" />

- 기존 Android Views를 사용하면 XML에 UI를 선언해야 한다
- 데이터 변경 시 UI도 업데이트를 위해 속성을 설정해야 한다
  - 앱의 상태(DB, 네트워크 호출이 로드)가 바뀔 때마다 새로운 정보로 UI를 업데이트해서 데이터를 동기화해야 한다
  - View마다 상태가 다르며 각각 업데이트해야 하므로 과정이 복잡해진다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/005.png" }}" />

- Compose와 같은 선언적 UI는 상태를 UI로 변환하는 방식이다
- UI는 변경 불가능하며 한번 생성하면 업데이트가 불가능하다. 앱 상태가 바뀌면 새로운 상태를 새로운 표현으로 변환한다.
- 새로운 표현 적용 시 UI 전체를 다시 생성하지만, Compose는 변경되지 않은 요소에 대한 작업은 건너뛴다
  - 개념적으로 특정 상태에 맞춰 UI를 다시 생성하는 것과 같다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/006.png" }}" />

- Compose에서 UI 구성요소는 `Composable` 주석이 달린 함수일 뿐이다
- UI 구성요소를 빠르고 쉽게 만들 수 있다
- 재사용 가능한 요소로 구성된 라이브러리로 UI를 나누는 것이 좋다
- `Composable` 함수는 값 반환 대신 UI를 전달한다
- 예제는 텍스트를 수직으로 배열하고 텍스트 레이블을 표시하며, 메시지가 없는 경우에 "No message" 레이블을 표시할 수도 있다
- Composable은 데이터를 매개변수로 받아서 UI를 전달하는 방식이다.
- 상태가 바뀌거나 메시지 목록이 바뀌었을 때 이 함수를 실행하면 새 UI가 생성된다. 이를 `Recomposing`이라고 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/007.png" }}" />

- 메시지 목록은 ViewModel이 message의 LiveData를 노출한다
- 관찰한 messages 필드를 읽는 Composable은 새 데이터가 입력될 때마다 recomposable 된다
- Compose Compiler가 어느 Composable이 상태를 읽는지 추적하고 상태 변경 시 자동으로 재실행한다
  - 상태가 변경된 Composable만 다시 실행하고 나머지는 건너뛴다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/008.png" }}" />

- 각 Composable은 Immutable 하므로 Composable을 참조하거나 나중에 쿼리 혹은 내용을 업데이트할 수 없다
- 정보를 입력할 때는 모두 매개변수로 Composable에 전달해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/009.png" }}" />

> 모든 메시지를 선택하는 CheckBox를 추가한 예제

- CheckBox는 미선택된 상태가 기본이다
- 기존 View와는 달리 CheckBox를 클릭하더라도 시각적인 변화는 없다. 그 이유는 상태를 상수(false)로 전달했기 때문이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/010.png" }}" />

- CheckBox 선택 여부를 결정하는 로컬 변수를 추가했다
- CheckBox 클릭 시 onCheckChange의 콜백에서 로컬 상태를 업데이트할 수 있다
- 코드 작성을 해야만 CheckBox 클릭 시 선택된다는 것이 직관적이지 못하다고 생각할 수 있지만, 그것이 선언적 UI의 핵심 개념이다
- 요소는 전달되는 매개변수가 완전히 통제한다. 이렇게 `단일 진실 공급원(Single source of truth)` 을 생성한다 → 동기화해야 할 상태를 없앤다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/011.png" }}" />

- 재실행하거나 Recomposition을 호출하더라도 유지하고 싶은 변수가 있을 경우 `remember` 함수를 사용하면 이전 실행에서 얻은 값을 기억할 수 있다
- 값을 재사용함으로써 재할당을 방지하거나 상태를 고정할 수 있다
- 위 예제는 이벤트 핸들링을 인라인으로 구현

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/012.png" }}" />

- state와 업데이트 람다를 Composable의 매개변수로 전달하고 `단일 진실 공급원`으로 로직을 올릴 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/013.png" }}" />

선언적 UI의 핵심은

- 특정 상태에서 UI의 형태를 완전히 `설명`한다
- 상태가 바뀌면 프레임워크에서 UI `업데이트`를 처리한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/014.png" }}" />

- Compose는 단방향 데이터 흐름을 따르는 아키텍처와 잘 맞는다
- ViewModel이 화면 상태의 단일 스트림을 노출하면 Compose UI에서 관찰하고 각 구성요소의 매개변수로 전달한다
- 각 구성요소는 필요한 상태만 수신하므로 데이터를 바꿀 때만 업데이트하면 된다
- 상태 변경을 ViewModel 한곳에서 처리하는 데 도움이 된다

### Declarative `UI Toolkit`

Jetpack Compose는 Material Design Component와 Theme 시스템을 구현한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/015.png" }}" />

- 앱을 만드는데 필요한 컴포넌트도 제공한다
- 모든 컴포넌트는 기본적으로 Material Styling을 따른다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/016.png" }}" />

- Material Theme를 구현하므로 모든 컴포넌트를 커스텀 설정할 수 있다 (Color, Typography, Shapes)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/017.png" }}" />

- 새로운 레이아웃을 제공한다 (가로/세로 LinearLayout과 유사)
- Views와는 달리 Compose Layout 모델은 여러 개의 measure를 전달할 수 없어서 중첩된 레이아웃에 적합하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/018.png" }}" />

- Compose DSL을 적용한 ConstraintLayout을 사용하면 복잡한 레이아웃을 표현 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/019.png" }}" />

- 또한 커스텀 레이아웃도 훨씬 간단하게 구현된다
- measure / layout을 직접 설정하고 싶으면 함수를 구현하기만 하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/020.png" }}" />

- 새로운 애니메이션 시스템은 기존보다 효과적이고 간단하게 UI에 모션을 적용할 수 있다
- Compose에 MotionLayout을 가져오는 작업도 진행하고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/021.png" }}" />

- Compose에서는 테스트와 접근성이 1급 객체이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/022.png" }}" />

- 테스트 기능을 극대화하는 전용 Test Artifact를 제공하며 Composable을 테스트하는 간단한 API를 제공한다
- Test Rule에서 clock이 노출된 후, UI가 업데이트되고 이를 제어하기 위한 API가 제공된다
- 애니메이션 코드를 테스트할 때도 테스트를 완전히 통제할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/023.png" }}" />

- Compose는 Kotlin으로만 개발되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/024.png" }}" />

- Coroutine을 사용하면 간단하게 비동기 API를 작성할 수 있다
- 예를 들어 제스처를 애니메이션으로 핸드오프 하는 것처럼 비동기식 이벤트를 결합한 코드를 간단하게 작성할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/025.png" }}" />

우측 이미지와 같이 Composable을 구현하는 방법

1. topic Model 객체로 매개변수를 받는 Composable 함수 생성
2. 이미지와 텍스트가 있는 행으로 구성된 구성 요소를 생성
3. 배경에 Card Composable로 행을 감싼다
4. 텍스트 주변 간격을 위해서 padding moodifier 매개변수로 Composable을 정의한다
5. 이미지 위에 체크 아이콘을 노출하기 위해 Boolean 매개변수를 추가한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/026.png" }}" />

- 이미지를 Box로 감싼 후 선택한 매개변수에 따라서 아이콘을 추가할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/027.png" }}" />

- 선택한 항목의 모서리 또한 선택한 매개변수에 따라서 모서리 Radius를 설정한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/028.png" }}" />

- 애니메이션으로 바꾸려면 `animateAsState` 함수로 조건을 사용합니다. 모서리 Radius가 자동으로 애니메이션으로 변환된다

#### Layout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/029.png" }}" />

- Compose LazyColumn Composable을 제공한다. RecyclerView처럼 뷰포트를 채우는 형태와 비슷하다
- 객체 목록을 items block으로 전달하고 각 항목을 렌더링에 전달할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/030.png" }}" />

- Compose에서 Custom Layout을 사용하면 Topic을 수평으로 한 순차 노출도 가능하다

#### Theme

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/031.png" }}" />

- 우측 이미지 예제 Owl은 Theme에서 배경색을 가져온다
- 앱이 다크 모드를 지원하도록 쉽게 테마를 설정할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/032.png" }}" />

- 시스템이 다크 모드인지 판단한 후 Coloe Scheme를 전달한다
- Compsoe에서 모든 테마는 런타임에서 실행되므로 기본 테마 외의 동적 테마도 쉽게 지원한다

> Compose Sample Repository : [goo.gle/compose-sample](goo.gle/compose-sample)

### Built for interop

Jetpack Compose는 기본 View 시스템과 호환된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/033.png" }}" />

- Compose를 필요에 따라 점진적으로 도입할 수 있다
- 필요한 단계별로 진행할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/034.png" }}" />

- 또한 Compose에 기존 Views를 호스팅 할 수 있다
- MapView의 광고처럼 아직 Compose로 대응하지 않은 콘텐츠를 표시할 때 유용하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/035.png" }}" />

- 다른 주요 라이브러리와의 통합을 제공한다
- Compose는 기존 애플리케이션 아키텍처와도 호환된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/036.png" }}" />

- Component와 함께 Preview를 정의할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-jetpack-compose/037.png" }}" />

- 다양한 폼팩터를 지원한다

### Compose 학습 자료

- goo.gle/compose-pathway
- goo.gle/compose-samples
- goo.gle/compose-docs
- goo.gle/compose-slack
- goo.gle/compose-feedback
