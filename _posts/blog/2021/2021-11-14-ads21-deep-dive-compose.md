---
layout: post
title: "[요약] Deep dive into Jetpack Compose layouts (Android Dev Summit '21)"
date: 2021-11-14 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/zMKMwh9gZuI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

> Composable 및 Modifier를 지원하는 구성된 레이아웃 모델을 설명하고, 내부에서 작동하는 방식과 기능에 대한 내용이다.

Compose 레이아웃 시스템의 목표는

- 커스텀 레이아웃을 만들기 `쉽고`
- 레이아웃 시스템이 `강력`하여 앱에 필요한 것을 만들 수 있으며
- `고성능`

### Layout Model

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/001.png" }}" />

- Jetpack Compose는 상태를 UI로 변환한다
- 변환은 Composition, Layout, Drawing 3단계의 프로세스를 거친다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/002.png" }}" />

Composition은 UI를 방출(emit)하여 UI 트리를 만들 수 있는 Composable 함수를 실행한다

- SearchResult Composable을 실행하면 그림과 같은 트리가 생성된다
- 상태에 따라서 다른 트리를 생성할 수 있다

Layout 단계서는 각 트리를 다니며 UI 항목을 측정하여 배치를 담당한다

- 각 노드의 Width, Height, x, y 좌표를 결정한다

Drawing 단계에서는 UI 트리를 다니면서 모든 요소를 렌더링 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/003.png" }}" />

- Layout 단계에는 측정(Measure)와 배치(Place) 단계가 있다
- 측정 결과는 기존 View 레이아웃 시스템의 measure 값과 거의 동일하다. 그러나 Compose에서는 이러한 단계가 서로 얽혀 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/004.png" }}" />

UI 트리에 각 노드 레이아웃은 3단계 프로세스를 진행한다

1. 각 노드는 하위 노드를 측정
2. 자체 크기 결정
3. 하위 노드를 배치

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/005.png" }}" />

1. 루트 레이아웃에 측정(measure)을 요청한다
2. 첫 번째 자식인 이미지에 측정을 요청한다
3. 이미지는 자식이 없는 Leaf 노드라서, 자체적으로 측정하고 크기를 알려준다
   1. 자식 노드를 배치 방법에 대한 정보도 반환한다. 이 경우는 비어있다.
   2. 모든 레이아웃은 크기를 설정함과 동시에 배치 지침을 알려준다
4. Column의 노드를 측정한다.
5. 첫 번째 Text의 크기와 배치 지침을 측정하고 알려준다
6. 두 번째 Text도 마찬가지이다.
7. Column의 자식들이 측정되었으므로 자체 크기와 배치를 결정한다
8. 루트 Row의 자식 노드들의 크기가 측정되었으므로 자신의 크기와 배치를 결정한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/006.png" }}" />

모든 노드의 크기가 측정되면 트리가 다시 탐색되고 모든 배치(place) 지침이 배치 단계에서 실행된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/007.png" }}" />

기존 UI 트리에서 각 Composable은 자체적으로 하위 수준 Composable에서 구성된다.

- Text는 여러 하위 수준의 블록으로 구성된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/008.png" }}" />

- 화면에 요소를 배치하는 모든 Composable에 하나 이상의 Layout Composable이 존재한다.
- Layout Composable의 기능은 Compose UI의 기본 구성 블록이다. 레이아웃 노드를 방출(emit) 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/009.png" }}" />

Compose에서 UI 트리 및 구성은 Layout Node의 트리이다

### Layout composable

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/010.png" }}" />

- content : 모든 하위 Composable에 대한 슬롯이며 레이아웃을 위해 cotnent에는 자식 Layout이 포함된다
- Modifier : 레이아웃에 Modifier를 적용하기 위한 파라미터를 받는다
- measurePolicy : 레이아웃이 Node를 측정하고 배치하는 방법인 측정 정책이다

```kotlin
@Composable
fun MyCustomLayout(
  modifier: Modifier = Modifier,
  content: @Composable () -> Unit
) {
  Layout(
    modifier = modifier,
    content = content // 전달된 자식 노드
  ) { measurables: List<Measurable>, // 측정 가능한 목록
      constraints: Constraints ->
     // TODO measure and place imtes
  }
}
```

- MyCustomLayout에서 Layout 함수를 호출하고 측정 기능 구현을 후행 람다로 제공하는 모습이다.
- **Constraints** 객체를 수신하여 레이아웃의 크기를 결정한다
- measurable은 항목을 측정하기 위한 기능을 노출한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/011.png" }}" />

- Constraints는 레이아웃될 수 있는 최소 및 최대 너비와 높이를 모델링하는 간단한 클래스이다

```kotlin
// 레이아웃이 제한이 없으며 원하는 만큼 커질 수 있음을 표현
val bigAsYouLike = Constraints(
  minWidth = 0,
  maxWidth = Constraints.Infinity,
  minHeight = 0,
  maxHeight = Constraints.Infinity
)

// 정확한 크기르 표현
val exact = Constraints(
  minWidth = 50,
  maxWidth = 50,
  minHeight = 50,
  maxHeight = 50
)
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/012.png" }}" />

- 먼저 모든 자식들을 측정(measure)한다. measurable은 크기 제약을 허용하는 측정 방법을 노출한다.
- 커스텀 측정 로직을 적용하지 않는 간단한 경우에는 목록을 매핑하여 각각을 측정할 수 있다
- 최종적으로 placeables 목록이 생성된다. 여기에는 측정된 자식과 크기 정보가 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/013.png" }}" />

- placeables 목록을 사용하여 레이아웃의 크기를 계산할 수 있다.
- `layout` 메서드를 호출하여 레이아웃이 원하는 크기를 전달할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/014.png" }}" />

- 후행 람다로 구현된 배치 블록이 사용되며, 각 항목을 원하는 위치에 배치할 수 있다
- RTL을 처리를 위한 `placeRelative` 메서드도 존재한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/015.png" }}" />

- API 디자인적으로 측정되지 않은 요소를 배치하려는 시도를 방지한다.
- `place` 메서드는 측정(measure) 메서드에서 반환된 placeable 항목만 사용할 수 있다

### Layout Examples

#### Column

항목들을 세로로 배치하기 위한 **Column** 컴포넌트의 방식을 이해하기 위해 먼저 자체 Column을 구현해 본다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/016.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/017.png" }}" />

- MyColumn의 높이는 모든 항목의 측정된 높이의 합이 된다. 너비는 가장 넓은 항목이 너비가 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/018.png" }}" />

- 크기를 보고한 다음, y 위치를 추적(tracking)하고 배치된 각 항목의 높이만큼 증가시켜 각 항목을 배치한다.
- 실제 Column은 가중치, 정렬 등의 기능을 추가로 지원한다

#### VerticalGrid

> 2개의 Column을 가지는 VerticalGrid Composable 함수 예시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/019.png" }}" />

- 각 열의 너비는 레이아웃의 최대 너비를 사용하여 계산한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/020.png" }}" />

- 계산된 약 Column의 너비 값을 사용하여 항목에 대한 새 Constraints 객체를 구성한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/021.png" }}" />

- 앞서 작성한 제약 조건으로 각 항목을 측정(measure)한 다음 Grid에 배치한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/022.png" }}" />

- 자식 노드를 측정하기 위해 다양한 제약 조건을 생성하는 기능이 이 모델의 핵심이다
- 부모와 자식 사이에는 협상이 없으며, 부모는 제약 조건으로 표현되는 허용 가능한 크기 범위를 전달한다
- 자식 노드가 전달된 범위 내에서 크기를 선택하면, 부모는 그것을 받아들이고 처리해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/023.png" }}" />

- 단일 패스로 전체 UI 트리를 측정할 수 있고, 여러 번 측정을 금지할 수 있다
- 실제로 항목을 2번 측정하면 Compose에서 예외가 발생한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/024.png" }}" />

- 앱 디자인에서 요구하는 특정 레이아웃을 만들 때 Layout Composable이 유용하다
- Jetsnack 샘플의 Bottom Navigation Design이 그 사례이다.
  - 선택된 항목만 레이블이 표시. 그 외에는 아이콘만 표시
  - 항목 선택 시 애니메이션을 적용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/025.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/026.png" }}" />

- 요구 사항에 맞추기 위해서 아이콘과 텍스트에 대한 두개의 슬롯을 노출한다
- 호출자가 제공해야 하는 애니메이션 진행률 값이 있다
  - 0 : 선택 해제
  - 1 : 항목 선택

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/027.png" }}" />

- 커스텀 레이아웃에서 Box에 아이콘과 텍스트를 래핑한다. Layer ID Modifier를 각가 적용하기 위한 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/028.png" }}" />

- Measure 블록에서 measurables에서 필요한 배치 항목을 검색하여 가져온다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/029.png" }}" />

- 애니메이션 진행률에 따라 텍스트와 아이콘을 배치하는 계산을 한다
- Compose의 Layout 성능이 매우 좋아서 측정 또는 배치를 애니메이션으로 만들거나 제스처로 구동할 수 있기 때문에 가능하다. 
- 기존 View 시스템에서는 레이아웃 애니메이션이 성능상의 문제로 권장되지 않았다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/030.png" }}" />

커스텀 Compose가 유용한 경우는?

- 표준 레이아웃으로는 어려운 디자인을 만들어야 하는 경우. 대부분 Row/Columns으로 가능하다
- 측정 또는 배치 로직을 정밀하게 제어해야 하는 경우
- 레이아웃을 애니메이션 시키거나 동작시키고 싶은 경우
  - 배치(Place) 애니메이션 API는 현재 개발 중
- 성능을 제어할 경우

### Modifier

Modifier는 레이아웃, 크기, 위치 구성에 중요한 역할을 한다. 자신이 적용되는 요소를 장식하고, 레이아웃 자체의 측정 및 배치 전에 측정 및 배치에 참여한다

Drawing, 포인터 입력 Modifier, 포커스 등 다양한 동작에 영향을 주는 Modifier가 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/031.png" }}" />

- **MeasureScope.measure**는 측정 가능한 단일 항목에만 작동한다는 점을 제외하고 Layout Composable과 동일한 측정 방법을 제공한다.
- 제약 조건을 변경하거나 커스텀한 배치 로직을 구현할 수 있다.
- `단일 항목`에 대해서만 작업을 수행하려는 경우에만 Modifier를 대신 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/032.png" }}" />

- Modifier.`padding`은 Modifier 체인을 기반으로 만들어지며, 원하는 패딩 값을 캡처하는 PaddingModifier 객체를 만든다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/033.png" }}" />

- PaddingModifier는 LayoutModifier의 한 종류이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/034.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/035.png" }}" />

- 패딩 크기만큼 외부 제약 조건을 축소하여 측정을 변경한 다음 내용을 측정한다. 그다음 원하는 패딩만큼 오프셋 된 콘텐츠를 배치한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/036.png" }}" />

- PaddingModifier처럼 커스텀 Layout Modifie를 작성하는 것 이외에 **Modifier.layout**을 사용도 가능하다
- Modifier 체인에서 직접 Composable 구성 요소에 커스텀 측정 또는 배치 로직을 추가할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/037.png" }}" />

Box가 최대 200x300 픽셀의 컨테이너 안에 배치되는 경우

- 체인의 첫 번째 Modifier에 크기의 제약 조건이 전달된다
  - fillMaxSize : 새로운 제약 조건을 생성 후, 최소/최대 너비와 높이를 최대 너비와 높이와 동일하게 설정하여 최대로 채운다
  - ```kotlin
    val childConstraints = Constraints(
      minWidth = outerConstraints.maxWidth,
      maxWidth = outerConstraints.maxWidth,
      minHeight = outerConstraints.maxHeight,
      maxHeight = outerConstraints.maxHeight,
    )
    ```
  - 결과는 w : 200, h : 300
- 위 제약 조건은 다음 wrapContentSize Modifier가 받는다.
  - wrapContentSize : 콘텐츠가 원하는 크기로 측정되도록 처리
  - ```kotlin
    val childConstraints = Constraints(
      minWidth = 0,
      maxWidth = outerConstraints.maxWidth,
      minHeight = 0,
      maxHeight = outerConstraints.maxHeight,
    )
    ```
  - 결과는 w : 0~200, h : 0~300
- size Modifier로 전달된다
  - size : 크기 제약 조건을 생성
  - ```kotlin
    val childConstraints = Constraints(
      minWidth = 50,
      maxWidth = 50,
      minHeight = 50,
      maxHeight = 50,
    )
    ```
  - 결과는 w : 50, h : 50
- 마지막으로 상위 Box의 Layout으로 전달된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/038.png" }}" />

- Modifier 체인을 백업하여 확인된 50x50 크기를 측정하고 반환한다
- Size Modifier는 50x50을 확인하고 배치 지침을 만든다
- wrapContentSize 은 크기를 확인할 컨텐트 중앙에 배치 지침을 만든다
  - 크기가 200x300이고 다음 요소가 50x50이라는 것을 알고 있기 때문에 중앙에 배치한다.
- fillMaxSize는 크기와 배치를 확인한다

### Advanced features

#### 내장 기능 측정 (Intrinsic Measurement)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/039.png" }}" />

- Compose에서 항상 한 번에 레이아웃을 수행할 수는 없다.
- 제약 조건을 완성하기 전에 자식 크기를 알아야 하는 경우가 있다 (예 : 메뉴 팝업)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/040.png" }}" />

- 팝업에서는 **최대 고유 너비(IntrinsicSize.Max)**를 사용하여 크기를 결정해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/041.png" }}" />

- Max 대신 Min을 사용할 경우, Column이 원하는 최소 크기를 찾습니다.
- 텍스트의 최소 고유 너비는 각 줄에 한 단어가 있는 너비이다.

#### ParentData

경우에 따라 레이아웃에서 자식의 정보가 필요한 일부 동작을 제공할 수 있다. 이 경우에 **ParentData Modifier**가 유용하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/042.png" }}" />

> Box 안에 Box가 있는 예제이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/043.png" }}" />

- Box 내부의 콘텐츠는 BoxScope 범위에서 실행된다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/044.png" }}" />

- BoxScope는 Box에서만 사용할 수 있는 Modifier를 말한다
- BoxScope이 제공하는 기능 중 하나로 Align이 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/045.png" }}" />

- Align Modifier를 사용해서 위치를 지정할 수 있다.
  - Align은 단순히 부모에게 일부 정보를 전달하는 상위 데이터 Modifier이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/046.png" }}" />

- 커스텀 레이아웃에 대한 부모 데이터 Modifier를 작성하여 자녀가 Layout에서 사용해야 하는 일부 정보를 부모에게 전달할 수 있다.

#### Alignment Lines

Alignment Lines을 사용하면 레이아웃의 상단/하단/중앙이 아닌 다르게 정렬할 수 있습니다. 흔하게 사용되는 Alignment Lines은 textBaseline이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/047.png" }}" />

- 텍스트와 아이콘 모두 중앙 배치를 위해서 **Alignment.CenterVertically**을 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/048.png" }}" />

- Alignment.CenterVertically 사용할 경우, 텍스트의 baseline과 아이콘의 위치가 일치하지 않는다.
- 이 문제의 해결로는
  - Row에 텍스트를 baseline에 맞추도록 지정할 수 있다
  - 아이콘은 기준선이 존재하지 않기 때문에 **alignBy** Modifier를 사용하여 아이콘을 원하는 위치에 정렬하도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/049.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/050.png" }}" />

- Nested Child에서도 문제가 발생할 수 있다. baseline alignment을 갖도록 수정하는 것은 문제가 된다.
- 다행히도 align은 부모를 통과하여 적용된다.
- 버튼의 기준선에 맞춰 정렬하도록 한다. 대신, 버튼은 자식으로부터 값을 가져온다.
- 추가로 커스텀 레이아웃에서 커스텀 정렬을 만들 수도 있다.

#### BoxWithConstraints

Composition에서 로직과 제어 흐름으로 표시할 항목을 선택적으로 할 수 있다. 그러나 사용 가능한 공간에 따라 다르게 결정하고 싶을 수 있다.

기존 Compose의 3단계에서 Layout 단계까지는 크기 조정 정보를 사용할 수 없다. Composition 시 표시할 항목을 결정하는 데 사용할 수 없다.

→ BoxWithConstraints가 필요한 시점

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/051.png" }}" />

- Box와 유사하게 구성 가능하지만, 레이아웃 정보가 Layout 단계까지 Content 구성을 연기한다
- BoxWithConstraints의 content는 Layout 단계에서 결정된 제약 조건을 px/dpi 값으로 노출하는 수신기 범위에서 실행된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/052.png" }}" />

- 결정된 제약조건을 사용하여 content 구성을 선택할 수 있다

### Performance

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/053.png" }}" />

- Single-pass Layout 모델이 측정/배치에 과도한 시간 소비를 방지하는 방법을 이미 다루었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/054.png" }}" />

- 측정과 배치가 Layout 단계의 별개의 하위 단계라는 것도 알았다
- 측정이 아닌 `항목 배치`에만 영향을 미치는 변경 사항을 별도로 실행할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/055.png" }}" />

- Jetsnack에는 페이지 스크롤에 따라서 여러 항목이 이동, 크기 조정되는 스크롤 효과가 있다
- 스크롤 시 화면 상단에 고정된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/056.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/057.png" }}" />

- Box에 쌓인 별도 Composable로 구현되어 있다
- 스크롤 상태를 Body의 Composable로 전달하는 것으로 세로 스크롤 시에 맞춰 콘텐츠가 이동한다
- Title도 스크롤의 위치를 관할할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/058.png" }}" />

- Title에 넘겨진 스크롤 정보를 **Modifier.offset**에 이용할 경우 문제가 발생한다..
  - scroll 수치가 관찰 가능한 상태이고 읽는 범위가 상태 변경 시 다시 실행해야 하는 항목을 가리키고 있다. Composition에서 scroll 값을 읽은 다음 offset Modifier를 만드는데 사용하게 된다. 
  - scroll 값이 변경될 때마다 title의 Composable을 재구성해야 하고 새로운 offset Modifier를 생성하고 실행한다
  - 스크롤 상태가 Composition에서 읽히므로 모든 변경으로 인해 Recomposition이 발생한다.
  - Recomposition 시에 Layout, Drawing 단계도 실행해야 한다.
- 실제로 필요한 것은 보여주고 있는 것을 바꾸는 것이 아니라, `어디에 있는지를` 바꾸려고 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/059.png" }}" />

- scroll 위치를 얻는 대신, 위치를 제공할 수 있는 기능을 전달하도록 구현을 수정한다.
- Modifier.offset 람다를 호출하고 다른 시간에 스크롤 상태를 읽을 수 있다 -> scroll 변경될 때마다 Modifier를 다시 만들 필요가 없다
- scroll 상태 값은 배치 단계에서만 읽도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/060.png" }}" />

- 최종적으로 scroll 상태 변경 시 배치와 Drawing만 실행하면 된다.
- Recomposition 및 측정이 없으므로 성능이 향상된다.
- 표시할 위치나 방법이 아니라 `표시 내용을 변경할 때만 재구성하면 된다`.

#### BoxWithConstraints

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/061.png" }}" />

- Layout에 의존하는 Composition을 허용한다
- Layout 중에 Sub-Composition을 시작한다. 성능상의 이유로 Layout 중에 Composition을 최대한 피하기 위해서이다.
- BoxWithConstraints를 사용하는 것보다 크기에 따라 변경되는 레이아웃을 사용하는 것을 권장한다.
- 정보의 유형이 `크기에 따라 변경될 때 BoxWithConstraints를 사용`해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/062.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/063.png" }}" />

- 카드 안에 icon/title/body가 있을 경우, 카드의 크기를 계산할 때 body만 계산하면 된다.
- 시스템은 body만 측정한 것으로 인식하여 Layout의 크기 결정하는데 중요한 자식이 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/064.png" }}" />

- 아이콘과 텍스트는 계속 측정되어야 한다.
- 최종적으로 title이 변경되더라도 시스템에서 Layout 측정을 다시 실행할 필요가 없게 된다.

### Resources

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Deep-dive-into-Jetpack-Compose-layouts/065.png" }}" />
