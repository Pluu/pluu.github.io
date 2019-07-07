---
layout: post
title: "[요약] Android Studio/ Tips and Tricks ~ Part1 (Google I/O '19)"
date: 2019-07-06 16:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

Android Studio/ Tips and Tricks 세션의 내용이 많아서 3개의 파트로 나누어서 공개합니다.

본 글에서는 Android Studio의 Profiler와 기본 IDE의 내용을 소개합니다.

<!--more-->

- - - 

<iframe width="560" height="315" src="https://www.youtube.com/embed/ihF-PwDfRZ4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Android Studio/ Tips and Tricks

- [Part 1]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)

- - -

> 단축키 그림
>
> - Shift : ⇧
> - ESC : ⎋
> - Control : ⌃
> - Option : ⌥
> - Command : ⌘
> - Tab : ⇥
> - Backspace : ⌫

---

## Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/001.png" }}" /> 

위 버튼을 선택하면 앱이 시작되고 프로파일링 세션이 시작된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/002.png" }}" /> 

- 단축키 : `⇧⌘↑` , `⇧⌘↓` : 특정 창의 크기 조절

> Main menu | Window | Active Tool Window | Resize | Stretch to Top
> Main menu | Window | Active Tool Window | Resize | Stretch to Bottom 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/003.png" }}" /> 

CPU, 메모리, 네트워크, 에너지 프로파일러를 확인할 수 있다.

### Memory Profiler

Memory Leak을 검출하는 좋은 도구이다.

![img](https://developer.android.com/studio/images/profile/memory-profiler-callouts_2x.png)

> 출처 : [View the Java heap and memory allocations with Memory Profiler](https://developer.android.com/studio/profile/memory-profiler)

- ① 버튼 : `Force garbage collection`, 가비지 수집 이벤트를 강제로 실행 
  - 단축키 : `⌘G`
- ② 버튼 : Heap Dump를 얻어 GC 체크
- 프로파일링 뷰의 화면을 확대/축소할 수 있다
  - ④ 번 버튼의 항목 선택
  - 단축키 : `⌘+` , `⌘-` 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/004.png" }}" /> 

- Activity 전환 시 Activity의 활성 상태를 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/006.png" }}" /> 

- 특정 구간의 메모리 상태를 설정할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/007.png" }}" /> 

- 필터 선택으로 특정 Activity로 필터링할 수 있다
- 메모리의 할당과 해제도 볼 수 있다

### Energy Profiler

![img](https://developer.android.com/studio/images/profile/energy-profiler-L1_2x.png)  

> 출처 : [Inspect energy use with Energy Profiler](https://developer.android.com/studio/profile/energy-profiler)

Energy Profiler를 통해서 CPU, 네트워크, GPS 센서에서 사용되는 Energy를 시각화하여 표시한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/008.png" }}" /> 

Energy 타임 라인에서 원하는 시간을 선택하면, 그 시간에 실행한 System Event를 볼 수 있다.  

## Core IDE Tips

### General Environment Tips

#### Open/Close Tool Windos

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/009.png" }}" /> 

Android Studio 내에서 일부 탭에 밑줄이 그어져 있는 번호를 통해서 빠르게 편집 화면 전환이 가능하다. 동일한 단축키 입력 시 해당 편집 화면을 닫을 수 있다.

- 단축키 : `⌘ + Tab에 작성된 번호`

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/010.png" }}" /> 

가장 최근에 사용한 Window는  `Switcher` 화면을 통해서 이동할 수 있다.

- 단축기 : `⌃⇥`

> Other | Switcher 

Gradle Window의 경우 단축키가 없음므로, Switcher 화면에서 Control 키를 누르채로  `G` 키 입력으로 Gradle 창을 열 수 있다.

현재 활성화된 Window는 `⇧⎋` 를 사용해서 닫을 수 있다. 

> Main menu | Window | Active Tool Window | Hide Active Tool Window

`F12` 키를 이용해 마지막으로 활성화된 Tool Window로 쉽게 이동할 수 있다.

> Main menu | Window | Active Tool Window | Jump to Last Tool Window

`⇧⌘F12` 를 이용해 Editor를 제외한 다른 Tool Window를 모두 숨길 수 있다.  다시 한번 커맨드 입력 시 이전 상태로 복원할 수 있다.

> Main menu | Window | Active Tool Window | Hide All Tool Windows

#### Moving around Editor Tabs

| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/011.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/012.png" }}" /> |

탐색 트리와 검색 결과에서 원하는 파일 검색 시에는 해당 이름을 입력하는 것으로 빠르게 필터링 된 결과를 이동할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/013.png" }}" /> 

Editor 화면에서 `⇧⌘[` 혹은 `⇧⌘]` 명령어를 통해서 Editor 간의 좌/우로 이동을 할 수 있다.

> Main menu | Window | Editor Tabs | Select Previous Tab 
> Main menu | Window | Editor Tabs | Select Next Tab 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/014.png" }}" /> 

Android Studio의 Layout 파일에서 Design/Text View의 전환이 필요할 때는 `⇧⌃→ ` 혹은 `⇧⌃←` 를 사용할 수 있다. 이 기능은 `Version Control` Window에서도 사용할 수 있다.

> Other | Tabs | Select Previous Tab in multi-editor file
> Other | Tabs | Select Next Tab in multi-editor file

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/015.png" }}" /> 

넓은 화면에서 더 많은 코드를 보기 위해서 Move Right를 통해서 복수의 탭으로 코드를 분리할 수 있다. Drag&Drop으로 분리된 탭에 Editor를 분리할 수 있다.

> Main menu | Window | Editor Tabs | Move Right

분할된 화면을 되돌리기 위해서 `Unsplit` Action을 실행할 수 있다.

> Main menu | Window | Editor Tabs | Unsplit

#### Find Anything

Double Shift 기능을 이용해서 클래스, Symbol, Action를 찾을 수 있다

- 단축키 : `⇧⇧`

> Other | Search Everywhere

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/016.png" }}" /> 

원하는 경우 Class/File/Symbol 등 빠르게 찾는 단축키를 이용하는 것도 좋은 방법이다.

### Moving Around Code

#### CamelHump text navigation

기본적으로 `⌥` 키를 사용하여 좌우로 단어를 건너뛸 수 있고, `⇧` 키를 사용하여 텍스트 선택을 한다

> Editor Actions | Move Caret to Previous Word
> Editor Actions | Move Caret to Next Word
> Editor Actions | Left with Selection
> Editor Actions | Right with Selection

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/017.png" }}" /> 

대문자 단위(Camel Hump)로 텍스트를 이동/선택할 경우 사용하면 편하다

> Preferences | Editor | General | Smart Keys … Use "CamelHumps" words

#### Go to Method Above/Below

`⌃↑` 혹은 `⌃↓` 을 이용해 빠르게 위아래에 있는 메소드로 빠르게 이동할 수 있다

> Main menu | Navigate | Previous Method
> Main menu | Navigate | Next Method
>
> ※ MAC에서는 System 키와 중첩되어 동작하지 않습니다.

#### Go to Last Edit Location

마지막으로 코드를 편집했던 곳으로 가고 싶을 때 사용할 수 있다

- 단축키 : `⇧⌘⌫`

> Main menu | Navigate | Last Edit Location

### Coding  Intelligence

#### Method Info / Parameter Info

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/018.png" }}" /> 

Quick Documentation 를 이용하면 JavaDoc을 빠르게 확인할 수 있다

-  단축키 : `F1`

> Main menu | View | Quick Documentation

메소드의 Parameter 정보를 확인하기 위해 `Parameter Info` 기능 사용할 수 있다. 그리고 `⇥`과 `⇧⇥` 으로 Parameter 를 이동할 수 있다.

- 단축키 : `⌘P`

> Main menu | View | Parameter Info

#### Code Completion basics

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/019.png" }}" /> 

Parameter의 정보와 내부에서 접근 가능한 변수명을 체크해서 일부 일치하는 이름을 목록의 맨 위로 놓습니다. 변경 가능한 목록에서  `⇥` 을 선택 시 기존 Parameter를 대체할 수 있다.

- 단축키 : `⌃Space`

> Main menu | Code | Completion | Basic

#### Smart Code Completion

복수의 Parameter를 변경해야 할 경우 `SmartType Completion` 기능을 사용하면 더 쉽게 Parameter를 반영할 수 있다. 그리고, 목록에서 `⇥` 키를 선택하면 Parameter를 반영한 후 다음 필드로 자동으로 이동한다.

- 단축키 : `⇧⌃Space`

> Main menu | Code | Completion | SmartType

### Editing Tricks

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/020.png" }}" /> 

또한 Find Action에서는 System에 바로 적용 가능한 기능도 제공한다.

- 단축키 : `⇧⌃A`

#### Editing commands

현재 포커스가 있는 줄과 다음 줄 혹은 선택된 여러 줄을 하나의 줄로 합칠 수 있다.

- 단축키 : `⇧⌃J`

> Main menu | Edit | Join Lines

`⌥↑`키를 통해서 선택 영역을 확장 가능하며, `⌥↓` 키로 선택 영역을 축소할 수 있다. 

> Main menu | Edit | Extend Selection
> Main menu | Edit | Shrink Selection

`⌘D` 키를 통해 선택 영역을 복제할 수 있다.

> Main menu | Edit | Duplicate Line or Selection

그리고, `⌘/` 키로 현재 포커스가 있는 줄 혹은 선택한 영역을 주석으로 처리할 수 있다.

> Main menu | Code | Comment with Line Comment

`⇧⌘↑` 키와 `⇧⌘↓` 키를 통해서 필요한 줄을 이동할 수 있다. 자동으로 블럭의 들여쓰기 등도 반영된다. 이 기능은 해당 라인이 유효한 범위내에서 이동된다.

> Main menu | Code | Move Statement Down
> Main menu | Code | Move Statement Up

위의 기능과 상관없이 라인 이동을 원할 경우 `⌥⇧↑`키와 `⌥⇧↓`키를 사용하면 된다.

> Main menu | Code | Move Line Down
> Main menu | Code | Move Line Up

`⌘⌫` 키를 통해서 삭제를 할 수 있다.

> Editor Actions | Delete Line

특정 키워드를 가지는 단어를 멀티 선택 시에 `⌃G` 키로 선택할 수 있다. `⇧⌃G` 로 선택 해제할 수 있다.

> Main menu | Edit | Find | Add Selection for Next Occurrence
> Main menu | Edit | Find | Unselect Occurrence

이전에 여러 가지 복사를 했다면 `⇧⌘V` 키를 통해서 지금까지 복사한 것들을 선택할 수 있다.

> Main menu | Edit | Paste from History...

#### Refactoring tools

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/021.png" }}" /> 

`⌃T` 키를 통해서 코드 리팩토링 메뉴를 제공한다. Extract 기능을 통해서 Variable, Property, Parameter 등을 제공한다.

> Main menu | Refactor | Refactor This...
> Main menu | Refactor | Extract | Variable...
> Main menu | Refactor | Extract | Method...

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/022.png" }}" /> 

`⌥⌘T` 를 이용하면 많이 사용되는 Control 기능을 선택할 수 있다.

>  Main menu | Code | Surround With...

| ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/023.png" }}" />  |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/024.png" }}" />  |

특정 영역의 내용을 메소드의 Parameter로 주입받고 싶을 경우에는 `⌥⌘P` 키를 사용해서 Parameter로 추출할 수 있다.

> Main menu | Refactor | Extract | Parameter...

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/025.png" }}" /> 

`⌘B` 키를 이용해 현재 메소드가 사용되는 곳을 쉽게 찾을 수 있다. 

> Main menu | Navigate | Declaration

#### Postfix Completion

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/026.png" }}" /> 

buildPath 함수의 반환형이 Boolean 형일 경우 기존 `Surround With` 에서 if를 이용할 수도 있지만, `Postfix Completion`을 이용하면 더 쉽다.

위 예제는 buildPath 함수를 사용한 곳 뒤에서  `.` 입력시 Trigger로 `if`에 해당하는 Postfix Completion를 보여주고 있다. List Type의 경우에는 `forEach` 가 자주 사용되므로 추천하고 싶다.

> Preferences | Editor | General | Postfix Completion

#### Coding with Intensions

Androi Studio의 Intensions 기능은 코드를 분석하고 검색한 후 최적화하는 방법과 잠재 문제를 해결하는 방안을 제안한다. IDE가 더 나은 방법을 찾았다면, 코드의 줄 옆에 노란색 전구 아이콘을 표시한다. 이 아이콘을 클릭하면 관련된 Intension 작업할 수 있다.

> Preferences | Editor | Intentions

- - - 

Android Studio/ Tips and Tricks

- [Part 1]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)