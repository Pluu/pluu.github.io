---
layout: post
title: "[요약] Android Studio/ Tips and Tricks Part 2 ~ Navigation Editor, Resource Manager (Google I/O '19)"
date: 2019-07-06 16:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

Android Studio/ Tips and Tricks 세션의 내용이 많아서 3개의 파트로 나누어서 공개합니다.

본 글에서는 Navigation Editor, Resource Manager를 소개합니다.

<!--more-->

- - - 

<iframe width="560" height="315" src="https://www.youtube.com/embed/ihF-PwDfRZ4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Android Studio/ Tips and Tricks

- [Part 1 ~ Profiler, 기본 IDE]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2 ~ Navigation Editor, Resource Manager]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)
- [Part 3 ~ Build&Deploy]({{ site.baseurl }}/blog/android/io19/2019/07/08/io19-android_studio_tips_and_tricks_part3/)

- - -

## Design Tools

### Navigation Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/027.png" }}" /> 

좌측 Navigation Graph가 정의된 패널에서 항목 선택 시 자동으로 해당 화면으로 이동한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/028.png" }}" /> 

Navigation Editor의 `Auto Arrange` 기능으로 복잡하게 연결된 Graph가 더 나은 형태로 노출된다.

| 변경 전                                                      | 변경 후                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/029.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/030.png" }}" /> |

`Nested Graph`는 Navigation Graph로 구성하며 캡슐화하며 일부를 재사용시에 유용하다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/031.png" }}" /> 

Nested Graph로 그룹화하고 싶은 destinations을 선택한 후 `Move to Nested Graph > New Graph` 메뉴를 통해서 만들 수 있다.

![img](https://developer.android.com/images/topic/libraries/architecture/navigation-nestedgraph_2x.png)

(출처 : [Nested navigation graphs](https://developer.android.com/guide/navigation/navigation-nested-graphs))

Nested Graph를 더블 클릭하면 내부를 더 자세히 볼 수 있다.

### Resource Editor

Graph를 정의하는 곳이 RecyclerView를 사용한다면 `Sample Data ` 를 사용하면 다양한 데이터가 Design View에서 노출한다.

| Sample Data                                                  | 적용된 화면                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/032.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/033.png" }}" /> |

#### Constraint Layout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/034.png" }}" /> 

Android Studio 3.5에서는 Design View에서 Constraint Layout를 다루기 위해서 개선되었다. 먼저 기존에 적용된 제약조건을 쉽게 제거할 수 있다. 제약조건에서 `⌘`키를 누르면 제거할 수 있는 형태로 변경된다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/035.png" }}" /> 

혹은 제약 조건을 선택한 후 제거하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/036.png" }}" /> 

기본적으로 Android에서 View가 렌더링 시에 사용되는 순서는 XML에서 정의한 순서이다. 만약, 해당 View 하단에 다른 View 있다고 가정할 경우, 그 View를 변경하고 싶을 때 불편했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/037.png" }}" /> 

Design View에서 `Component Tree`에서 쉽게 XML의 정의 순서를 변경할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/038.png" }}" /> 

`Included` View의 경우 더블 클릭으로 해당 레이아웃으로 이동할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/039.png" }}" /> 

Resource에 정의된 내용을 사용하고 싶을 경우에 Attribute Pannel의 ![img](https://developer.android.com/studio/images/buttons/layout-editor-indicator-solid.png) 혹은 ![img](https://developer.android.com/studio/images/buttons/layout-editor-indicator-empty.png) Indicator를 클릭하면 된다.  리소스 선택 버튼을 클릭하면 리소스 선택 다이얼로그가 노출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/040.png" }}" /> 

그리고, Text Color의 경우 추가로 변경하고 싶은 경우에는 Attribute Pannel에서 Color 가 노출되는 부분을 더블 클릭하면 Color Picker를 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/041.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/042.png" }}" /> 

### Resource Manager

![img](https://developer.android.com/images/studio/write/resource-manager-2x.png)

(출처 : [Manage your app's UI resources with Resource Manager](https://developer.android.com/studio/write/resource-manager))

Resource Manager는 기본적으로 프로젝트에 있는 모든 리소스를 확인할 수 있다. 

- ④ 번 : Drawable, Color, Layout 등 지원
- ⑤ 번 : 외부 라이브러리의 리소스를 표시 가능
- ⑦ 번 : List/Grid 형태로 모드 전환 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/043.png" }}" /> 

Resource Manager의 Drawable은 Layout에 Drag&Drop하는 것으로 ImageView 형태로 추가할 수 있다. 뿐만 아니라 Layout도 가능하다. 이 경우는 `include` 형태로 추가된다.

해당 기능은 Design View 뿐만 아니라 Text View 에서도 가능하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/044.png" }}" /> 

기존 ImageView에 Drag&Drop을 하면 새로운 이미지로 바꾼다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/045.png" }}" /> 

기본 Design View에서 `O` 버튼을 통해서 Preview의 landscape/landscape로 변경할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/046.png" }}" /> 

이미지의 Scale 대신 ConstraintLayout의 aspect ratio이용하는 방법도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/047.png" }}" /> 

Preview의 우측하단에 있는 View를 Drag하는 것으로 다양한 디바이스&해상도에서 어떻게 노출되는지 확인할 수 있다.

- - - 

Android Studio/ Tips and Tricks

- [Part 1 ~ Profiler, 기본 IDE]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2 ~ Navigation Editor, Resource Manager]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)
- [Part 3 ~ Build&Deploy]({{ site.baseurl }}/blog/android/io19/2019/07/08/io19-android_studio_tips_and_tricks_part3/)
