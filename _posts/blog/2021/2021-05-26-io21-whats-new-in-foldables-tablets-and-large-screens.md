---
layout: post
title: "[요약] What’s new in foldables, tablets, and large screens (Google I/O '21)"
date: 2021-05-26 22:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/Qkiz3QIPJzk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

### Why Large Screens

<img src="https://1.bp.blogspot.com/-EljZ5-h_wV4/YKLyZOhq4vI/AAAAAAAAAHk/AK8Rj3zjIbUA_ESW8cgF8hEXE1fKZ6YowCLcBGAsYHQ/s0/image10.gif" />

> 이미지 출처 : https://android-developers.googleblog.com/2021/05/whats-new-in-foldables-tablets-and.html

- 화면 크기가 커지면서 모바일이 빠르게 성장한 시기가 3번 있었다
- 사용자는 큰 화면을 선호하고 하나의 기능으로 많은 일을 처리하고 싶어 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/002.png" }}" /> 

- 지난 1년간 폴더블과 태블릿 기기들이 많이 출시되었다
- 사용자가 집에 머무는 시간이 늘면서 수요도 늘어서 2020년 태블릿 매출은 16% 증가, 2022년에는 Android 태블릿이 4천만 대 이상 증가할 것으로 예상, 폴더블은 2년 내로 3천만대로 예상
- Android 앱은 Chrome OS에서 실행할 수 있다
- Android 대형 화면 기기용으로 만들어진 앱은 폴더블, 태블릿, Chromebook 합쳐서 2억 5천만 대에서 사용 중이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/003.png" }}" /> 

- 화면이 클수록 기기를 사용하는 시간이 증가하며 더욱 깊이 몰입한다
- 삼성 Galaxy Z Fold2 사용자의 40% 이상이 태블릿 형태로 변경한다. 콘텐츠를 볼 공간을 확보한다는 의미이다
- 한 화면에서 더 많은 일을 할 수 있다는 이유로 사용자는 대형 기기를 선호한다
- 폴더블을 사용할 때 분할 화면이나 다중 창 모드를 켜는 사용자가 10배 증가했다
- 폴더블 기기는 탁자 모드 화면을 제공함으로 영상을 보거나 통화를 하는 핸즈프리 활동에 유용하다

<img src="https://developer.android.com/images/guide/topics/ui/foldables/posture_laptop.png" />

> Half-opened (Laptop/Tabletop)
>
> 이미지 출처 : Building apps for foldables > Postures https://developer.android.com/guide/topics/ui/foldables#postures

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/004.png" }}" /> 

- 다양한 사례를 통해 앱에서 어떻게 대형 폼팩터를 도입했는지 확인할 수 있다

> Responsive layouts for tablets, large screens, and foldables > Case studies : [goo.gle/large-screens-case-studies](goo.gle/large-screens-case-studies)

### Large Screen Read

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/005.png" }}" /> 

앱에서 대형 화면 지원시 준비해야 하는 기능

- 앱을 대형 화면에 맞게 디자인해야 한다
  - 600dpi 이상 해상도에는 태블릿 레이아웃을 추가하고, 앱이 제대로 노출되는지 확인해야 한다
  - 세로 모드와 가로 모드에서 모두 사용될 것에 대비해야 한다
- 멀티태스킹 환경을 앱에서 처리할 계획을 세워야 한다
  - 앱의 크기를 조정 / 접고 펼치기 / 다중 창 모드
  - 생산성 앱은 다중 인스턴스와 다중 재시작을 지원
- 태블릿용 기본 키보드와 마우스 스타일러스 지원이 필요하다

### Component Updates

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/006.png" }}" /> 

- SlidingPaneLayout은 두 창의 너비를 사용하여 창을 나란히 놓을 수 있는지 확인한다
- Folds와 Hinges 등 Display Feature를 인식하는 기능을 추가했다. 이를 통해 콘텐츠 자동 배치의 가능 여부가 적용된다.
- 잠금 모드 도입 : 각 화면의 스와이프 제스처를 더 세밀하게 제어할 수 있다
- SlidingPaneLayout 1.2.0은 현재 베타 버전이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/007.png" }}" /> 

- Navigation Rail은 새로운 Material Component로 UI가 확장 시 편하게 탐색할 수 있도록 도와준다
- Navigation Rail 사용 시 사용자가 쉽게 접근할 수 있는 곳으로 Navigation을 옮길 수 있다
- Bottom Navigation과 Navigation Rail은 동일한 API 세트를 지원하므로 큰 영향은 없을 것이다

<img src="https://lh3.googleusercontent.com/XRlp9aecePbg-KZVKBw5Aoz7HMdaiEfLUIsDI1WNHXLXWQ6qKlJYK8q4Mupe-Hv-wKL97zTEKpAHmIjDER8a2TXtn_1AG9GBUwXKwA=w1064-v0" />

> Left: Owl uses bottom navigation on smaller devices. Right: On larger displays the bottom navigation becomes a rail.
>
> 참고 이미지 : https://material.io/components/navigation-rail#behavior
>
> 참고 자료 : Material Design Navigation rail https://material.io/components/navigation-rail

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/009.png" }}" /> 

- 여러 Material Component에 max width 속성을 추가했다
- 대형 화면에서 앱을 열었을 때 자주 발생하는 문제는 UI 요소가 화면 전체로 늘어나는 현상이다
- max width 속성은 늘어나는 현상이 가장 많이 발생하는 요소에 추가했다
  - Button, TextFields, Sheets

### WindowManager Jetpack

- WindowManager는 새로운 폼팩터 기기를 지원하고 폴더블/태블릿 등의 다양한 기기를 지원하기 위한 공통 API를 제공하는 라이브러리이다.
- 현재는 알파 단계이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/010.png" }}" /> 

- WindowManager Jetpack에서는 `Display Feature`라는 개념을 사용해서 앱이 Display Feature에 영향을 받으면 콜백으로 알려준다
  - Folds, Hinges가 해당된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/011.png" }}" /> 

- ConstraintLayout 2.1에서 SharedValue와 ReactiveGuide라는 개념을 도입했다
  - 런타임에 fold의 위치를 입력할 수 있다
- MotionLayout에서는 fold 위치로 자동으로 애니메이션이 적용된며 기기 상태를 쉽게 모델링 할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/012.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/013.png" }}" /> 

- Display Feature와 속성을 이용해서 ReactiveGuideline을 조정한 후 레이아웃 애니메이션을 시작하는 샘플이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/014.png" }}" /> 

폴더블 기기에 맞게 개발하는 방법

- WindowManager Jetpack API를 새롭게 구축해서 테스트 환경을 개선했다
- WindowManager 을 위한 테스트 모듈을 개발해서 자동 테스트 코딩을 지원할 계획이다
  - Test Rule 도입과 기기 상태 변화를 모델링하는 기능을 적용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-foldables-tablets-and-large-screens/015.png" }}" /> 

- 큰 화면에서 다중 창이 점점 더 많이 사용되고 있다
- Android 11에서는 WindowMetrics API를 도입해 디스플레이 정보보다 Window에 필요한 정보를 제공하고자 했다
- Android 12의 Display에서 getRealSize() / getRealMetrics API가 Deprecated 되었다
  - WindowManager Jetpack에 Window Metrics API를 도입해 동일한 API로 구 버전을 지원하고 있다
- Current WindowMetrics : 현재 Window의 Bounds를 제공
- Maximum WindowMetrics : 현재 시스템 구성에서 사용 가능한 최대 Bounds를 제공
  - Multiple Display의 경우 앱이 실행되는 디스플레이에 따라 변경된다
