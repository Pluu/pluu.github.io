---
layout: post
title: "[요약] Android Studio: Debugging Tips n' Tricks (Android Dev Summit '19)"
date: 2019-11-14 23:25:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/rjlhSDhFwzM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

## Android Logcat

### Log Configuration

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/001.png" }}" /> 

Logcat의 설정을 통해서 화면에 표시할 로그를 수정할 수 있다. 노출 변경 가능한 것은 아래와 같다.

- Date & Time
- Process & Thread ID
- Package name
- Tag

### Log Filter

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/002.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/003.png" }}" /> 

필터 하는 방법은 Logcat 상단의 Filter를 이용하는 방법과 새로운 Logcat Filter를 만들어서 사용하는 방법이 있다.

### Log Folding

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/004.png" }}" /> 

반복되는 로그가 이어질 상황에 해당 로그를 접은 형태로 사용이 가능하다. 접고 싶은 영역을 선택한 후 우측 메뉴의 `Fold Lines Like This` 를 선택한다. 그 뒤 위 측 영역에 원하는 형태로 추가하면 이후부터는 접은 상태로 노출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/005.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/006.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/007.png" }}" /> 

Fold 되어있는 부분을 선택지 숨어있는 로그가 노출된다.

## Apply Debug Mode

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/008.png" }}" /> 

이미 실행 중인 앱에 디버거 연결 또한 가능하다. 상단 메뉴에서 `Attach debugger to process` 을 클릭한 후 디버거와 연결할 프로세스를 선택하면 된다.

## Dependent breakpoints

![https://developer.android.com/images/tools/as-breakpointline.png](https://developer.android.com/images/tools/as-breakpointline.png)

디버깅하고 싶은 부분에 Break Point를 추가한 후 현재의 상태로 다른 라인에 Break Point로 변경하고 싶은 경우에는 Break Point를 Drag&Drop 하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/009.png" }}" /> 

특정 경우에만 Break Point에서 멈추고 싶을때는 Break Point의 `Condition` 정보를 추가하여, 해당식에 맞을 경우에만 멈출 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/010.png" }}" /> 

복수의 Break Point 설정 시 하나의 Break Point가 활성화되는 기준을 다른 Break Point가 멈출 경우에만 활성화할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/009.png" }}" /> 

Break Point를 정의하는 곳 좌측 하단의 More를 선택한 후, `Disable until breakpoint is hit` 항목의 Dropdown List에서 종속성을 연결하고 싶은 Break Point를 선택하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/011.png" }}" /> 

> 39번 라인의 Break Point는 36번 라인의 Break Point가 멈출 경우에만 활성화된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/012.png" }}" /> 

기본적인 Break Point는 특정 라인의 Thread가 Background인 경우에도 전체 스레드가 lock이 걸리는 형태이다. 이 경우 UI 스레드는 멈추지 않고 진행하는 방법으로는 Suspend 옵션에서 Thread 항목을 선택해주면 된다.

> IntelliJ에서는 이 방식을 livelock이라고 한다.
>
> https://www.jetbrains.com/help/idea/tutorial-java-debugging-deep-dive.html#845884da

![https://developer.android.com/images/tools/as-breakpointline.png](https://developer.android.com/images/tools/as-breakpointline.png)

Break Point는 Mac의 경우 Alt + 클릭을 통해서 Break Point의 활성화 여부를 변경할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/013.png" }}" /> 

특정 로그를 원할 때 코드에 로그 코드를 추가하는 방법을 많이 사용한다. 그렇지만 결국 코드를 변경하는 작업이 일어나므로 빌드와 새롭게 앱을 실행하는 등 원하는 조건을 맞추기 어렵다. 

보다 쉽게 원하는 로그를 출력하는 방법으로 Breakpoint 기능 중 `Evaluate and log` 을 사용하는 것이다. 흔히 사용하는 Logcat과는 다르게 Debug 탭의 Console에 원하는 로그가 출력된다. Breakpoint를 멈추고 싶지 않은 경우에 Suspend 옵션을 해제해두는 것이다.

해당 Break Point에 걸린 경우에 메시지를 노출하고 싶을 경우에는 "Break point hit" 옵션을 체크하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/014.png" }}" /> 

> Evaluate and log : ON

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/015.png" }}" /> 

> Break point hit : Enable , Evaluate and log : ON

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/016.png" }}" /> 

매번 위와 같은 Suspend가 비활성화된 Break point 생성은 번거로우므로 `Shift + Click`으로 쉽게 생성할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/017.png" }}" /> 

우리는 Break point를 추가할 때 다양하게 추가하므로 특정 Break point를 그룹화하고 싶을 때가 있다. 그럴 때는 해당 Break point를 선택한 후 오른쪽 마우스를 통해서 선택된 Break point를 그룹화하는 것이 가능하다. 그룹화된 Break point 들을 쉽게 활성화/비활성화 전환을 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/018.png" }}" /> 

> 그룹 처리된 Break point

### Breakpoint Control

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/019.png" }}" /> 

간혹 디버깅 시 조작 실수로 원하던 Break point를 지나치는 경우가 많다. 다시 처음부터 Break point까지 도착해야 하는 번거러운 작업을 한다. 그러나 Android 10 이상의 기기를 사용하는 경우에 이 작업을 되돌릴 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/020.png" }}" /> 

디버그 메뉴에서 `Drop Frame` 을 선택하면 된다. 선택 시 해당 Break point가 호출되기 직전의 시점으로 돌아간다. 그 후 다시 한번 동일하게 Break point까지 이전 상태로 접근할 수 있다.

### Watcher

기본적으로 Debug 모드의 Variables은 현재 Scope에 해당하는 변수만 접근/노출할 수 있다. `Mark Object` 기능을 사용하면 Scope 밖에서도 해당하는 변수를 참조할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/021.png" }}" /> 

MainViewModel Scope에서 private 변수로 정의된 MutableLiveData의 `_list` 변수에 Mark Object를 이용해 `mylist` 라는 이름으로 지정했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/022.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/023.png" }}" /> 

그리고, SessionComponent라는 곳에서 `New Watch` 를 이용해  MainViewModel Scope에서 지정한 `mylist_DebugLabel` 에 접근할 수 있다. 실제 list에 반영된 값 또한 확인이 가능하다. 이로써 Scope에 제한적으로 변수를 추적했던 과거와는 다르게 다양한 위치에서 해당 변수의 값을 확인할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/024.png" }}" /> 

Watcher뿐만 아니라 다양한 곳에서 `mylist` 로 지정한 변수를 사용할 수 있다.

### Evaluate

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/025.png" }}" /> 

Evaluate는 더 다양한 내용으로 값을 체크할 수 있다. 변수 생성 및 별도 메소드를 호출한 결과 또한 확인이 가능하다.

### Apply Code Changes

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/026.png" }}" /> 

디버깅 중 누락된 작업을 추가하고 싶을 때 기존이라면 디버그 모드를 종료한 후 코드를 작성하고서 다시 디버깅 모드로 진입하여 추가한 코드를 확인한다. 

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/YIYaC9eHUJs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Break Point를 설정한 곳에서 멈춘 곳 이후의 부분에 코드를 추가로 작성하고서 `Apply Code Changes`를 실행한다. 그 뒤 Frame Drop을 통해 다시 Break Point가 멈춘 후 이어서 실행을 시켜보면 예제와 같이 새롭게 추가한 로그가 출력되는 것을 볼 수 있다.

## Bug Report

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads19/android-studio-debugging/027.png" }}" /> 

에러가 발생한 후 얻을 수 있는 버그 리포트를 통해서 위와 같은 call stack 로그를 얻을 수 있다. 

![https://developer.android.com/studio/images/debug/analyze-stacktrace_2-2_2x.png](https://developer.android.com/studio/images/debug/analyze-stacktrace_2-2_2x.png)

Android Studio > Analyze > `Analyze Stack Trace`를 선택한 후 열리는 창에 로그를 붙여넣고 OK를 누른다

![https://developer.android.com/studio/images/debug/stacktrace-window_2x.png](https://developer.android.com/studio/images/debug/stacktrace-window_2x.png)

Console 화면에 가져온 Stack 정보를 얻을 수 있으며, 현재 소유하고 있는 코드의 경우 코드 이동도 빠르게 가능하다.