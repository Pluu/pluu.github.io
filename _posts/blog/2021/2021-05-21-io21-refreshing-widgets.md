---
layout: post
title: "[요약] Refreshing widgets (Google I/O '21)"
date: 2021-05-21 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/cHv84zXZf6E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

Android Cupcake에서 처음 등장한 위젯은 등장 이래로 사용자가 홈 화면에서 정보를 빠르게 모니터링하거나 작업을 완료하거나 좋은 영감을 얻기 위한 좋은 수단으로 사용된다 

위젯이 승승장구한 이유는 다음과 같다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/001.png" }}" /> 

Useful

- 앱을 시작하지 않아도 유용한 정보를 볼 수 있다
- 84%의 사용자가 1개 이상의 위젯을 사용하며, 63%가 여러 개를 사용한다는 설문 결과가 있었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/002.png" }}" /> 

Personal

- 위젯은 사용자가 개성을 표현할 수 있는 수단이고, 사용자는 여기에서 기쁨을 느낀다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/003.png" }}" /> 

Engaging

- 열정적인 사용자들은 위젯을 통해 앱과 상호 작용하며 앱에 다시 참여한다
- 사례로 Google Keep의 Android 위젯은 2018년보다 참여율이 3.5배 증가했다
- Google Keep뿐만 아니라 Google의 다른 앱에서도 위젯을 설치한 사용자가 앱에 더 많이 참여한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/004.png" }}" /> 

- 이번 Android 12에서는 출시 이래로 가장 큰 시스템 UI 업데이트를 진행한다
- 그리고 위젯은 `앱 참여율을 높이는 방향`으로 진행하기로 결정했다
- 위젯을 더욱 쉽게 만들고 관리하기 위한 도구와 리소스도 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/005.png" }}" /> 

세 가지 핵심 요소를 통해 위젯 도입과 앱 참여율을 높이고자 한다

- 쉽게 검색되고
- 더욱 유용하고
- 아름다운

### Useful

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/006.png" }}" /> 

인터랙티브 요소의 추가 지원된다

- CheckBox
- Switch
- Radio Button
- Vectial Scroll
- Multiple tap target
- 기타

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/007.png" }}" /> 

- 위젯에 체크 박스를 추가하고, 체크 상태 변경을 수신하는 예제 코드

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/008.png" }}" /> 

- 사용자는 자신과 관련이 깊은 위젯을 좋아하므로 위젯을 더 쉽게 개인화할 수 있도록 변경되었다
- 위젯 구성 변경 및 위젯 검색을 쉽게 할 수 있는 진입점을 추가했다
- 앱에서 최초 구성 Activity을 건너뛸 수도 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/009.png" }}" /> 

- 위젯 재구성을 허용하려면 먼저 "reconfigurable" 플래그를 추가해야 한다
- configuration_optional로 최초 구성 Activity를 건너뛸 수 있다

### Discoverable

사용자가 더 쉽게 찾고 추가할 수 있게 하기 위해서 위젯이 검색 가능해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/010.png" }}" /> 

- Android 12에서는 실제와 같은 Preview Layout과 위젯 설명을 표시함으로 사용자가 그 위젯이 자신에게 적합한 이유를 알 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/011.png" }}" /> 

- 기존 Widget Picker는 Drawable Resource를 표시하므로 위젯의 외형을 정확히 반영하지 못했다
- 대신 `android:previewLayout` 속성으로 xml 레이아웃을 제공할 수 있다
- `android:description` 속성으로 Preview에서 표시할 설명을 작성할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/012.png" }}" /> 

위젯의 위치도 증가

- Android의 OnDevice 검색
- Mobile 및 Auto의 어시스턴트

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/013.png" }}" /> 

- 휴대 전화가 잠겨있거나 차 안에 있을 때 핸즈프리 업데이트가 필요한 경우에 유용하다. 이때 Android Auto의 어시스턴트를 이용하면 된다
- Strava 앱은 음성으로 상태를 간단하게 체크하고 어시스턴트 패널에서 홈 화면으로 위젯을 추가할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/014.png" }}" /> 

- 음성으로 위젯을 호출하는 작업은 App Actions BII에서 딥 링크를 타고 앱으로 이동하는 것과 비슷하다
- capability 아래에 app-widget 태그를 추가하면 이를 위젯 실행으로 나타낼 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/015.png" }}" /> 

어시스턴트와의 통합으로 원샷 답변 같은 간단한 업데이트 외에도 여러 단계의 상호 작용도 가능하다. 사용자는 동일한 위젯으로 어시스턴트와 대화를 나누고 여러 단계에 걸친 단계를 완료할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/016.png" }}" /> 

위젯에 텍스트 음성 변환을 추가하는 작업은 Widget Provider 도구에서 Widget Helper SDK로 처리된다. 위젯의 네트워크 요청을 하거나 다른 작업을 처리한 후 어시스턴트에서 말할 텍스트를 전송할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/017.png" }}" /> 

> 사례 : 던킨 도너츠

사용자가 이동 중이거나 지원되는 차량 내에서 주문하면 Android Auto가 자연스럽게 목적지까지 길 안내를 한다.

### Beautiful

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/018.png" }}" /> 

- Android 12에서 위젯 스타일을 다른 위젯 및 앱 아이콘과 어울리도록 한다
- 시스템 레벨의 리소스를 도입할 예정
- 런처에서 Padding과 Corner Radius를 조절할 수 있게 된다
- 시스템 레벨의 리소스를 적용하지 않으면 Launcher가 위젯에 자동으로 Mask를 적용하여 Corner Radius가 최소한의 일관성을 유지하도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/019.png" }}" /> 

- Corner Radius에 `@android:dimen/system_app_widget_background_radius`로 시스템 레벨 리소스를 추가할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/020.png" }}" /> 

반응형 레이아웃을 사용하면 디스플레이 크기에 최적인 레이아웃을 제공할 수 있다. 그로 인해 다양한 기기에서 항상 최적의 상태를 유지할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/021.png" }}" /> 

위젯 크기 조정 옵션을 구성하는 방법을 볼 수 있다. 위젯 크기를 조절할 수 있으면 조절 가능한 최대 width/hegith로 크기를 제한할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/022.png" }}" /> 

각 디스플레이 크기에 맞게 조정되도록 위젯을 구성하고 폴더블, 태블릿 등의 대형 폼팩터로 위젯을 확장할 수 있다. 디스플레이 크기에 맞게 외형을 조정하거나 각 크기에 사용할 여러 레이아웃을 제공할 수 잇다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/023.png" }}" /> 

위젯에 Color 테마도 도입된다. `Dynamic Color API`로 위젯에서 시스템 컬러를 사용하거나 배경화면에서 추출한 색상을 사용할 수 있다. 그로 인해 홈 화면에 균일한 스타일을 적용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/024.png" }}" /> 

위젯에 시스템 테마를 추가하고 시스템에 정의된 컬러 속성을 사용하면 Dynamic Color를 쉽게 추가할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/025.png" }}" /> 

ID를 추가하면 위젯과 앱의 전환도 더 자연스럽게 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/026.png" }}" /> 

해당 ID로 Background에 주석을 달아서 개선된 전환을 활성화할 수 있다. 그 후 런처가 나머지 처리를 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/027.png" }}" /> 

 머티리얼을 준수하는 컴포넌트 추가 및 새로운 가이드라인으로 새로운 위젯을 만들 수 있도록 지원한다.

### Jetpack Compose

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/028.png" }}" /> 

- 아직은 라이브러리 설계 단계이다
- Compose로 작성한 위젯의 모습을 살펴볼 수 있다

### Summary

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/refreshing-widgets/029.png" }}" /> 

2008년 위젯 출시 이후에 최대 규모의 업데이트이다. 이런 변화를 도입한 이유는 위젯 도입과 앱 참여율을 높이도록 좋은 위젯을 개발하는 시간을 줄이기 위해서이다.
