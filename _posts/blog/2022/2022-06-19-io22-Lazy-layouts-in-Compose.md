---
layout: post
title: "[요약] Lazy layouts in Compose"
date: 2022-06-19 10:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io22
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/1ANt65eoNhQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

## Lazy layouts in Compsoe

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/001.png" }}" /> 

Lazy Layout은 기존 View 시스템에서의 RecyclerView와 유사하다. 

- 한 번에 모두가 아니라 화면에 표시될 때 스크롤 가능한 아이템 목록을 렌더링하는 것이다.
- 로드할 아이템이나 대용량 데이터 세트가 많은 경우 지연 레이아웃을 사용으로 앱의 성능과 응답성을 높일 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/002.png" }}" /> 

Compose 1.2에서 여러 개의 Lazy Layout을 사용할 수 있다

- LazyColumn
- LazyRow
- LazyGrid (가로/세로 모두 지원)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/003.png" }}" /> 

기존 View 시스템의 RecyclerView 사용 시에는 Adapter/ViewHolder/RecyclerView 레이아웃/Item의 레이아웃/RecyclerView에 Adapter를 바인딩하는 코드가 필요했다

Compose의 Lazy Layout은 더 적은 코드로 동일한 결과를 얻을 수 있으므로, 읽고 쓰기 쉽고 간편하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/004.png" }}" /> 

아이템을 추가하려면 LazyList Scope DSL 블록을 사용하여 원하는 아이템을 추가할 수 있다.

아이템을 추가하는 API로 두 가지 방법을 제공한다

- item 블록을 사용하여 하나를 추가
- items 블록을 사용하여 여러 개를 추가

item의 인덱스를 알아야 할 경우에는 `itemsIndexed` API를 사용하면 된다

```kotlin
LazyColumn {
  itemsIndexed(data) { index, item ->
    Item(item, index)
  }
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/005.png" }}" /> 

Content 주위에 Padding을 추가할 경우에 전체 List에 주고 싶다면 `Padding Modifier`로 적용할 수 있다.

이 경우, 첫 아이템과 마지막 아이템이 스크롤 할 때 Padding Modifier에 의해서 컨텐츠가 잘리는 현상이 발생한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/006.png" }}" /> 

List에 동일한 Padding을 유지하면서 Content가 잘리지 않게 하는 해결법으로는 List의 `ContentPadding`에 필요한 값을 전달하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/007.png" }}" /> 

또한 아이템 간의 간격을 추가하려면 Layout Layout의 arrangement를 전달하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/008.png" }}" /> 

스크롤에 따른 동작을 하기 위해서는 스크롤 상태를 관찰해야 한다. 이때의 핵심이 스크롤 위치를 저장하고 List의 정보를 포함하는 객체인 `LazyListState`이다. 상태를 기억하도록 하려면 `rememberLazyListState`를 사용하여 상태를 호이스트하고 List에 전달하면 된다.

```kotlin
val state = rememberLazyListState()

// 첫 번째 아이템의 인덱스
state.firstVisibleItemIndex
// 첫 번째 아이템의 오프셋
state.firstVisibleItemScrolOffset
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/009.png" }}" /> 

LazyListState를 사용하여 첫 번째 아이템이 표시에 따라서 최상단으로 스크롤하는 버튼을 표시할지 여부로 사용할 수 있다.

LazyListState는 매우 자주 변경되므로 해당 속성을 읽는 것만으로도 불필요한 Recomposition이 트리거된다.

이를 방지하려면 `remember`와 `derivedStateOf`를 사용하여 상태를 래핑해야한다. 이렇게 하면 계산에 사용된 상태 속성이 변경될 때만 Recomposition이 발생한다.

> Performance best practices for Jetpack Compose : https://www.youtube.com/watch?v=EOQB8PTLkpY

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/010.png" }}" /> 

LazyListState에는 현재 보이는 항목 및 총 항목 수와 같은 정보도 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/011.png" }}" /> 

특정 아이템으로 이동할 때 scrollToItem을 사용할 수 있으며, 부드러운 애니메이션으로 전환할 경우 animateScrollToItem을 사용할 수 있다.

둘 다 suspend 함수이므로 `rememberCoroutineScope`에서 제공하는 coroutineScope내에서 실행하면 된다.

## Lazy grids

Compose 1.2에서 Lazy Grids는 Stable로 전환되었다.

Lazy Grid는 수직으로 스크롤하는 `LazyVerticalGrid`와 수평으로 스크롤하는 `LazyHorizontalGrid`을 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/012.png" }}" /> 

기존 LazyList와 유사한 사용법이다. 아이템을 작성하는 API도 유사하다.

Gird는 아이템 간의 간격을 위해서 Vertical/Horizontal Arrangement을 매개변수로 전달할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/013.png" }}" /> 

Lazy grid도 ContentPadding과 LazyGridState를 가질 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/014.png" }}" /> 

LazyGridState 또한 firstVisibleItemIndex 및 layoutInfo와 같은 정보를 접근할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/015.png" }}" /> 

`GridCells.Fixed` API를 사용해 고정된 수의 Column을 구현할 수 있다. **Arrangements.spacedBy**로 항목 간의 간격도 추가할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/016.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/017.png" }}" /> 

고정된 크기는 테스트하는 단말에 따라서 유효하지 않을 수 있다. 태블릿에서는 이를 해결하기 위해 `GridCells.Adaptive` API를 사용해 적용형 크기 조정을 사용했다.

아이템의 너비를 지정할 수 있으며, 가능한 한 많은 Column을 노출하도록 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/018.png" }}" /> 

더 복잡한 크기의 요구사항이 있더라도 GridCells의 적응형을 직접 구현할 수 있다. 

- availableSize : 사용 가능한 사이즈
- spacing : 아이템 간의 간격

반환값으로 계산된 아이템의 크기가 포함된 목록이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/019.png" }}" /> 

특정 아이템만 크기가 다른 경우에도, Grid Scope DSL 및 item 메소드의 파라미터를 통해서 지정할 수 있다.

아이템이 현재 줄에서 차지할 수 있는 범위를 나타내는 maxCurrentLineSpan 값이 하나 더 있으며 아이템이 줄의 시작 부분에 없을 때 maxLineSpan과 다르다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/020.png" }}" /> 

아이템은 기본 Span Size가 1이기 때문에 별도 Span을 명시적으로 지정하지 않아도 된다. 일부 항목을 조정하고 싶을 때 `GridItemSpan`을 사용하면 된다.

## LazyLayout

Compose 1.2에서 자신만의 레이아웃 관리자를 구현하기 위해 `LazyLayout`이라는 새로운 실험 API를 추가했다. LazyList와 LazyGrid도 LazyLayout API로 만들어졌다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/021.png" }}" /> 

Compose for Wear OS에서 보이는 것처럼 Component 중심까지의 거리에 따라서 아이템의 크기를 조정하는 Wear 관련 Lazy List가 그 사례이다.

Staggered Grids도 추후 공개 예정이다.

## Item animations

Compose 1.1에서 Lazy List에 대한 실험으로 아이템 재정렬 애니메이션을 도입했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/022.png" }}" /> 

Compose 1.2에서는 이 기능은 Lazy Gird에도 적용했다. 각 셀에 개별적으로 애니메이션을 적용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/023.png" }}" /> 

`Modifier.animateItemPlacement()` API를 아이템 콘텐츠로 설정하기만 하면 된다. 필요에 따라서 animationSpec을 조정할 수 있다.

이동할 요소의 새 위치를 찾을 수 있도록 아이템에 대한 키를 제공해야 한다. 그러나, Activity가 생성될 때 상태를 유지하기 위한 Android 메커니즘인 Bundle에서 지원되는 타입만 키로 사용할 수 있다.

재정렬 외에도 추가/제거를 위한 아이템 애니메이션도 작업 중이다.

## LazyLayout Tips

### Tips #1 0픽셀 크기의 아이템을 사용하지 마세요.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/024.png" }}" /> 

아이템을 처음 측정할 때 LazyColumn은 처음에 무제한 높이 제약 조건으로 항목을 측정한다. 

-> 계산을 위해 측정된 높이를 사용하여 사용 가능한 뷰포트를 채울 때까지 계속 구성하기 위해 아이템에 다른 제약을 가하지 않는다. 그 후 List는 아이템을 위한 처리를 중단한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/025.png" }}" /> 

리스트 아이템이 처음에 0픽셀 높이를 차지하는 경우, 첫 번째 측정에서 Lazy Column 높이가 0픽셀이므로 모든 아이템이 구성된다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/026.png" }}" /> 

몇 미리 초 후에 이미지가 로드되면, 아이템이 Recomposition되고 이미지가 표시된다.

Lazy List는 실제 뷰포트에 들어갈 수 있는 아이템이 일부라는 것을 알고, 불필요하게 Composition된 다른 아이템을 모두 버린다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/027.png" }}" /> 

이를 방지하려면 Lazy Layout이 실제 뷰포트에 맞는 항목 수를 올바르게 계산할 수 있도록 아이템에 기본 크기를 설정해야 한다.

데이터를 비동기식으로 로드한 후, 아이템의 크기를 지정하는 경우에는 데이터 로드 전후의 아이템 크기가 동일하게 유지되도록 하는 것이 좋다.

### Tips #2 같은 방향으로 스크롤 가능한 중첩 구성 요소를 피하세요.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/028.png" }}" /> 

방향 스크롤이 가능한 다른 부모 안에 미리 정의된 크기가 없는 스크롤 가능한 자식을 중첩하는 경우를 피하라는 말이다.

이 경우, 그렇게 하려고 해도 Compose가 그 행위를 막을 것이다.

기존 View 시스템에서 ScrolView 내부에 RecyclerView를 둘 수 있었기 때문에 혼란스러웠다. 이렇게 정의하면 모든 아이템이 즉시 생성되므로 재활용이 무효화되는 성능에 심각한 영향을 미친다.

그 이유는 이전 0픽셀 크기 아이템에서 언급한 것과 유사하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/029.png" }}" /> 

Compose에서는 하나의 부모 Lazy Column 안에 모든 Composable을 래핑하면 다양한 타입의 컨텐츠를 표시할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/030.png" }}" /> 

스크롤 가능한 상위 Row와 LazyColumn과 같이 다른 방향의 레이아웃을 중첩하는 경우뿐만 아니라

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/031.png" }}" /> 

동일한 방향을 사용하지만, 고정된 크기의 하위 레이아웃 설정은 허용한다.

### Tips #3 한 아이템에 여러 요소를 넣지 않아야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/032.png" }}" /> 

둘 이상의 요소를 하나의 item composable에 넣으면, Compose는 다른 아이템인 것처럼 요소를 차례대로 배치한다.

여러 요소가 한 아이템의 일부로 처리되면, 하나의 개체로 처리되므로 더 이상 개별적으로 구성할 수 없다. 하나의 요소가 화면에 보이면 해당 아이템에 해당하는 모든 요소를 Composition하여 측정한다. 그로 인해 성능 저하가 발생할 수 있다. 이런 극단적인 사례는 Lazy Layout을 사용하는 의미가 없다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/033.png" }}" /> 

그 외에도 scrollToItem/animateScrollToItem을 방해할 수도 있다. 이러한 메서드의 인덱스 매개변수가 실제 요소 수가 아니라 DSL 사용에서 파생된 아이템 수를 기준으로 해석되기 때문이다.

예로서 scrollToItem(2)를 호출하면 실제로 항목 3이 맨 위에 표시된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/034.png" }}" /> 

그렇지만, item DSL에 아이템과는 별도로 다른 요소를 넣는 것은 유효한 사용 사례이다.

Divier는 독립된 요소로 처리하면 안되며, Divier가 작기 때문에 성능에 영향을 미치지 않으므로 Divier가 표시되기 전에 아이템이 표시될 때 표시될 가능성이 높다.

### Tips #4 Custom arrangements 사용을 고려하세요

일반적으로 Lazy List에는 많은 아이템이 있으며 스크롤 컨테이너의 크기보다 더 많이 차지할 수 있다. 그러나 List에 몇 개의 아이템으로 채워지면 좀 더 구체적인 배치하는 경우도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/035.png" }}" /> 

예를 들어, 사용 가능한 높이를 채울 만큼 아이템이 충분하지 않은 경우 Footer를 하단에 표시해야 할 수 있다. 이를 위해서 Custom Vertical Arrangement를 사용하여 Lazy Column에 전달할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/036.png" }}" /> 

TopWithFooter 객체는 각 아이템의 높이를 지정할 수 있다. 뷰포트 높이가 될 총 크기와 항목의 높이가 될 크기를 제공합니다. 최종 결과를 outPositions에 담아야 한다.

각 항목을 계산한 후, 총 길이보다 낮으면 Footer를 아래쪽에 배치하면 된다.

## Performance

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/037.png" }}" /> 

Lazy Layout의 성능을 안정적으로 측정하려면 최적화가 활성화된 릴리즈 모드에서만 가능하다. 디버그 빌드에서 Lazy Layout 스크롤이 느리게 나타난다.

또한 baseline profile로 해결할 수도 있다.

> Performance best practices for Jetpack Compose : https://www.youtube.com/watch?v=EOQB8PTLkpY

List Scroll을 보다 효율적으로 만들기 위해 내부에서 수행하는 몇 가지 최적화 방법을 시도해 볼 수 있다.

### Optimization #1, Composition Reusing

RecyclerView가 하는 일과 다소 비슷하다.

스크롤 후 이전에 보이던 아이템이 더 이상 필요하지 않게 되더라도 바로 폐기하지 않는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/038.png" }}" /> 

새 아이템을 작성할 때 재사용할 수 있도록 아이템 중 몇 개를 보관한다.

1. 완전히 새로운 Composition을 처리하고 시작하는 데 필요한 시간을 절약할 수 있다.
2. Layout Node를 재사용한다. Layout Node는 UI 트리의 모든 레이아웃을 내부적으로 표현한 것이다.

재사용된 Composition에서 새 아이템을 작성할 때, 유사한 UI 구조를 가진 아이템에 대해 내부 Layout Node 개체를 자동으로 재사용한다. 생략된 Layout Node가 완전히 동일하여 크기 및 기타 모든 동적 속성에 대해 동일한 값을 갖는 경우 전체 재측정을 건너뛸 수도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/039.png" }}" /> 

Compose 1.2에서 List의 각 아이템에 대한 Content Type을 지정할 수 있는 새 API가 추가되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/040.png" }}" /> 

다른 타입의 아이템으로 구성된 List의 경우, Content Type을 제공하면 동일한 Type의 아이템 간에서만 Composition을 재사용한다.

### Optimization #2, Prefetching

이것 또한 RecyclerView에서 수행되는 작업과 매우 유사하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/041.png" }}" /> 

UI 스레드에서 새로운 위치를 적용한 다음 새로운 **Draw**를 하기 전에 새 **Layout**을 수행한다. 그 후 Draw 정보가 Render 스레드로 전달되어 GPU로 전달한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/042.png" }}" /> 

새 아이템이 화면에 나타나면 먼저 새 아이템 내용을 구성한 다음 측정해야 하므로 더 많은 작업이 필요하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/043.png" }}" /> 

이러한 추가 단계는 모든 단계에 필요한 시간이 프레임 경계를 초과할 때 정크를 유발할 수 있다.

이전 프레임에서의 UI 스레드는 작업을 마친 후 아무 작업도 수행하지 않았다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io22/Lazy_layouts_in_Compose/044.png" }}" /> 

추가 단계를 거기로 이동시켰으며, 이것을 `prefetching`이다. 화면에 표시될 항목을 미리 구성함으로써 바로 작업을 수행하는 대신 작업을 더 일찍 완료할 수 있다.