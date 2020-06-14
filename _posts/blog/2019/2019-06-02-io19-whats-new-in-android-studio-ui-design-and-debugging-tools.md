---
layout: post
title: "[요약] What's New in Android Studio UI Design and Debugging Tools (Google I/O '19)"
date: 2019-06-02 22:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/oWTG5g5rT4s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/001.png" }}" /> 

새로운 Android Studio의 개선은 수정뿐만 아니라, 사용성 개선도 함께한다. Google Trips 앱을 이용한 예시를 보겠다.

## Layout Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/002.png" }}" /> 

| :--: | :--: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/003.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/004.png" }}" /> |

ConstraintLayout 을 사용하면 Blueprint 뷰를 더 빠르게 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/005.png" }}" /> 

Context Menu를 사용하면 한 번에 여러 가지 제약 조건을 설정할 수 있다. Context Menu는 마우스 오른쪽 버튼을 클릭해서 사용할 수 있다.

> 예제) RecyclerView를 레이아웃의 중심에 배치

### Preview

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/006.png" }}" /> 

Design뷰에서는 Blueprint 뷰에서는 나타나지 않는 것을 볼 수 있다. RecyclerView에서 실제 데이터가 표시를 위해서 design attribute 속성을 사용할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/007.png" }}" /> 

`Set Sample Data` > `Design-time View Attributes` 를 사용해 샘플 데이터를 선택할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/008.png" }}" /> 

Sample Data를 선택하면 `tools:listitem` 속성에 정의된 레이아웃에 선택한 레이아웃으로 갱신되고, RecyclerView에 정의된 템플릿이 노출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/009.png" }}" /> 

Resource Manager의 레이아웃에서 해당 파일의 이름을 변경할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/010.png" }}" /> 

그리고, Resource Manager에서 레이아웃을 더블 클릭하면 레이아웃 편집기에서 해당 레이아웃이 열린다.

### Constraint

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/011.png" }}" /> 

Design 뷰에서 ConstraintLayout 사용시 복수 View가 겹쳐진 상황에서 원하는 마우스 드래그를 이용해서 제약 조건을 처리하는 것은 어려웠다.

이제는 제약 조건은 적용하려고 컴포넌트의 어떤 위치로 드래그하면 팝업이 열리고, 설정하려는 제약 조건 형태를 선택할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/012.png" }}" /> 

제약 조건을 적용하는 마지막 방법은 Constrain Menu를 사용하는 것이다. 먼저 `Component Tree`에서 제약 조건을 설정하려는 두 개의 뷰를 선택하고, 오른쪽 마우스를 클릭하여 `Constrain` 메뉴를 통해서 원하는 제약 조건 하나를 적용할 수 있다.

### Attributes Panel

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/013.png" }}" /> 

Attributes Panel을 새롭게 디자인해서 속성의 추가/제거를 더 쉽게 했다.

- Declared Attributes : 설정된 속성 수정

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/014.png" }}" /> 

- Layout : 임의의 마진 값(Dimension)을 설정할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/015.png" }}" /> 

`@ …` 를 통해서 `Pick a Dimension` 다이얼로그를 통해서 새로운 Dimension 값을 설정할 수 있다.

### Sample Data

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/016.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/017.png" }}" /> 

Android Studio에서 제공하는 기본 Sample Data를 이용할 수 있지만, `sample` 폴더에 필요한 형태의 `Sample Data`를 추가해서 사용할 수 있다. 이전 레이아웃에 돌아가면 실제 디자인과 비슷해진다.

## Navigation Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/018.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/019.png" }}" /> 

> Navigation Editor를 사용하면 앱의 전체 레이아웃을 시각화하고 Navigation Architecture Component를 사용해 화면 간의 예측 가능한 흐름을 쉽게 만들 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/020.png" }}" /> 

Navigation Architecture Component의 동작 방식은 `NavHostFragment` 를 앱의 기본 레이아웃으로 사용하는 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/021.png" }}" /> 

> Navigation Graph는 대상 및 작업과 관련된 정보가 들어있는 리소스 파일이다.

기본적으로 NavHostGraph는 비어있고, 다른 Fragment로 채우는 형태이다. 더블 클릭하는 것으로, `Navigation Editor`를 확인할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/022.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/023.png" }}" /> 

`New Destination` 을 통해서 이미 작성된 Fragment를 선택할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/024.png" }}" /> 

추가적인 화면을 만들고 싶을 때는 `Create new destination` 을 통해 새로운 Fragment을 생성할 수 있고, 이를 통해 Navigation의 새로운 화면을 만들었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/025.png" }}" /> 

Navigation Editor에 두 화면은 `Action` 으로 연결한다. Drag&Drop을 통해서 연결할 수 있으며, 속성 패널을 통해서 애니메이션을 설정할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/026.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/027.png" }}" /> 

Action 호출 시 데이터를 안전하게 전달하는 것을 정의할 수 있다. 사전에 정의된 데이터 유형으로 전달할 수 있다.

> 관련 내용은 다음 링크를 확인해보세요 [Pass data between destinations](https://developer.android.com/guide/navigation/navigation-pass-data)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/028.png" }}" /> 

Navigation Editor의 Action으로 부족한 경우에는 위와 같은 코드로도 가능하다. 

Navigation Editor에서 정의한 파라매터를 이용해 액션을 만든다. 그리고, Navigation의 navigate 함수를 호출하여 화면 전환을 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/029.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/030.png" }}" /> 

상세한 화면 정의를 하지 않고, 빠르게 화면 흐름에 대해 정의를 할 경우에 `placeholder` 기능이 유용하다. 실제 작업이 완료되면 placeholder 대신 대체하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/031.png" }}" /> 

## Resource Manager

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/032.png" }}" /> 

Android Studio에서 Resouce 디렉토리 구조는 프레임워크와 비슷한 구조로 되어있고, 전체 리소스를 한눈에 미리 볼 수 없는 문제가 있었다. 문제 해결을 위해 Android Studio 3.4에서 `Resource Manager`를 도입했다. 더 눈에 보이는 형태로 리소스를 관리하는 도구이다. Android Studio의 좌측에 Resource Manager를 통해서 사용 가능하다.

### Bach Import

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/033.png" }}" /> 

디자이너로부터 이미지 결과물을 Android Studio로 가져올 때 다음과 같은 문제가 있을 수 있다

1. `drawable` 폴더 이름이 생략
2. 파일 이름에 `@2x` 가 있어서 제거해야 함
3. 수동으로 `특정한 폴더`에 넣어야 하는 케이스

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/034.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/035.png" }}" /> 

원하는 Drawable을 Drag&Drop으로 가져오면, 자동 Import되며 이름별로 그룹화된다.

> 실제 Google I/O 공식 영상을 통해 실제 움직임을 확인할 수 있다
>
> <iframe width="560" height="315" src="https://www.youtube.com/embed/oWTG5g5rT4s?start=1039" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/036.png" }}" /> 

파일 경로를 통해서 한정자를 식별하고 Android 폴더를 만들어 파일 이름에 있는 접미어를 제거하고 파일을 복사한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/037.png" }}" /> 

한정자를 추가하려는 경우에도 간단하게 추가할 수 있다.

### Grouped Resources

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/038.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/039.png" }}" /> 

동일한 이름으로 Import된 리소스는 Resource Manager에 의해 그룹화되어 표시된다. 원하는 리소스를 더블 클릭하여 다른 버전도 체크할 수 있다.

### Import SVGs

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/040.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/041.png" }}" /> 

SVG파일들도 Drag&Drop으로 한 번에 VectorDrawable로 변환할 수 있다.

### Preview Layout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/042.png" }}" /> 

Resource Manager의 Layout 탭을 선택함으로 모든 레이아웃을 미리 볼 수 있어, 원하는 레이아웃을 쉽게 찾을 수 있다

### Integration

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/043.png" }}" /> 

Resource Manager의 Layout을 선택 후 실제 XML로 Drag&Drop하면 `<include>` tag를 사용한 View로 추가된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/044.png" }}" /> 

Drawable을 Drag&Drop하면 ImageView가 추가된다.

### Color Picker

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/045.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/046.png" }}" /> 

Resource Manager의 Color 탭의 컬러를 더블 클릭하면 실제 정의된 Resource 파일이 열린다. XML의 좌측에 컬러를 선택하면 `Color Picker` 를 사용할 수 있다. RGB, HSB 모드를 지원한다. 

## Layout Inspector

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/047.png" }}" /> 

런타임에 레이아웃이 어떻게 구성하는지 확인하고 싶은 경우에는 Android Studio에 Layout Inspector를 사용하면 된다. 화면의 전체 View의 구조의 스냅샷과 뷰에 설정된 정보를 보여준다. Android Framework가 Android Studio에게 전달하는 데이터가 일부였기에 부분적인 정보만 노출되었다. Android Q부터 더 많은 뷰와 레이아웃 디버깅에 관한 정보를 제공하도록 API가 추가되었다.

### New Layout Inspector

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/048.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/049.png" }}" /> 

새로운 Layout Inspector는 아래와 같이 변경되었다.

1. 텍스트를 선택한 후 오른쪽 Attributes Panel을 보면 현재와 다르게 실제 속성 및 스타일에서 정의한 내용으로 매핑되어서 노출하고 있다.

2. ID, enum 값, Color 값 등을 좀 더 알기 쉽게 했다

3. 속성값이 설정된 위치에 대한 정보를 노출한다

   1. 속성값이 정의된 곳을 선택하면 그 값이 설정된 xml로 이동할 수 있다

4. 실제 디바이스에서 일어나는 것을 미러링하여 노출한다

   > 디바이스를 스크롤 시 Layout Inspector도 스크롤 되는 시연을 함

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/050.png" }}" /> 

화면에 보이는 배경색이 어디에서 적용된 값인지 알고 싶을 때, 3D View로 레이아웃을 보여줌으로 실제로 설정된 곳을 쉽게 찾을 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/051.png" }}" /> 

좀 더 다른 방식으로도 시각화할 수 있다. 위 이미지와 같이 하나의 뷰와 그 자식에만 집중할 수 있게 해준다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/052.png" }}" /> 

또는, 레이아웃 파일을 기반으로 그룹화도 가능하다.

## Android Framework

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/053.png" }}" /> 

Android Q에서는 Inspection 기능을 위해 새로운 API가 추가되었다.

### Skia Picture

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/054.png" }}" /> 

Skia는 UI Toolkit의 기초가 되는 2D Graphic Library이다. 위 예제는 간단하게 되었지만, 해당 화면을 만드는데 사용되는 Draw 명령들이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/055.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/056.png" }}" /> 

하단 영역은 단순히 그리기에 집중하고 있다. 그리고, ReaderNode API를 확인할 수 있다. 각각 Node에 부여된 ID를 통해서 Draw 명령을 그룹화하고 있다. 이를 통해 Android Studio에서 뷰의 시작과 종료된 위치를 얻을 수 있다.

### Fast Property Reading

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/057.png" }}" /> 

기존에는 View의 속성에 대한 정보를 Reflection을 통해서 얻었다. 휴대 기기에서 Reflection의 속도 저하를 고려해서 모든 것을 직렬화하는 방법으로 개선했다. 그러나, 새 속성을 추가 시 대응을 위해서 Annotation Processor를 사용해 유연성을 유지하도록 했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/058.png" }}" /> 

새로운 속성을 추가 시에는 위와 같이 getter 에 `InspectableProperty` Annotation 주석을 추가하면 된다.

`color` 라는 속성은 @Colora Annotation과 정수형이라는 것을 알 수 있다. Annotation의 속성을 사용하여 속성을 추론하는데 사용한다. 코드 생성 시 `companion` 객체를 만든다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/059.png" }}" /> 

`InspectionCompanion`으로 Android Q를 위한 새로운 API이다. 두 가지의 목적을 가지고 있다.

첫 번째, 클래스의 목록을 정의

> color를 정의했기에 Propertymapper에 color로 정의한다.
> generate된 colorId는 Android Studio에서 사용된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/060.png" }}" /> 

두 번째, 뷰의 인스턴스가 있을 때 속성을 읽기

> view.getColor()를 통해 뷰의 속성을 얻는다.
>
> 이를 통해 Android Studio에서 View 계층의 실시간 업데이트를 가능하게 한다. 이전에 있던 Reflection관련 오버헤드는 없다

### Style Stack

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/061.png" }}" /> 

실제 사용되는 컬러가 어떻게 정의되었는지 결정한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/whats-new-in-androidstudio-ui-design-and-debugging-tools/062.png" }}" /> 

Resource의 정보들은 일시적인 것이다. View가 커지면 Reousrce의 관계도 잃어버리기 쉽다. 

그래서, View의 속성 ID 맵과 그 위치 및 View의 테마의 Style Stack을 모두 저장할 수 있는 개발자 옵션이 추가되었다. Android Studio에서 해당 속성값의 출처와 스타일에 관해서 확인할 수 있다.