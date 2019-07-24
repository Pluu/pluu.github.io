---
layout: post
title: "Android Studio Tips #1"
date: 2019-07-13 23:00:00 +09:00
tag: [Android Studio]
categories:
- blog
- Android Studio
---

Android Studio 에 숨어있는 꿀팁 등 다양한 기능을 공유하는 포스팅입니다.

<!--more-->

- - -

연재 글

- [Android Studio Tips #2]({{ site.baseurl }}/blog/android studio/2019/07/24/android-studio-tip2/)

- - -

### Quick List

Android Studio 사용 시 `Surround With` / `Refactor This` 와 같은 기능은 코드 개선과 코드 블럭을 이용하여 추가 작업을 위해 많이 사용되는 도구 중 하나이다. 이 Menu는 Android Studio 내부에서 기본적으로 제공되는 기능이다.

| Surround With                                                | Refactor This                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/01.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/02.png" }}" />  |

이처럼 Android Studio 사용 시 자주 사용하는 기능의 목록을 별도 팝업으로 만들 수 있다. 바로 이 기능이 `Quick Lists` 이다. 

> Preferences \| Appearance & Behavior \| Quick Lists 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/03.png" }}" /> 

메뉴의 왼쪽 아래의 `+` 버튼 Click 통해서 새로운 `Quick Lists` 를 추가할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/04.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/05.png" }}" /> 

원하는 Action 들을 선택한 후 OK 버튼을 원하는 기능을 모은 나만의 팝업 메뉴를 사용할 수 있게 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/06.png" }}" /> 

위와 같이 Action과 Separator를 이용할 수 있다. 이후, Find Action 혹은 Search Everywhere 기능을 통해서 Quick List 입력 시 등록한 `Display Name`으로 만들어둔 Quick List에 접근할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/07.png" }}" /> 

> Find Action에서 입력시 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/10.png" }}" /> 

> 커스텀 Quick List 선택 화면

그리고, Quick List에 단축키를 부여하는 것이 가능하므로 더 쉽게 Quick List를 실행할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/08.png" }}" /> 

> Path : Preferences \| Keymap

### Notification

Notification은 특정 이벤트의 결과를 알려주는 것을 가리킨다. 주로 경험하는 것은 풍선 알림 형태로 나오는 Kotlin Plugin Update 혹은 Git Fetch시에 노출되는 팝업이다. 모든 이벤트의 결과가 아래와 같은 형태로 노출되는 것이 아니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/11.png" }}" /> 

> Path : Preferences \| Appearance & Behavior \| Notifications

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/12.png" }}" /> 

`Popup` 컬럼에 해당하는 항목을 수정해서 Notification의 노출 여부 및 풍선 알림을 원하는 형태로 변경할 수 있다.

#### Read Notification

Notification은 좀 더 재미난 기능으로 Notification 메뉴의 가장 오른쪽 컬럼이 기본적으로 모두 해제되어있다. 이 기능을 선택함으로써 해당 Notification에서 전달하는 이벤트의 메시지를 Sound 형태로 읽어준다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/13.png" }}" /> 

### File Colors

Android Studio의 Project View에서 `.gradle` 폴더와 `androidTest`, `test`의 폴더에 별도의 오렌지와 녹색으로 지정되어 있는 것을 볼 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/14.png" }}" /> 

해당 정보는 별도 메뉴를 통해서 확인할 수 있다

> Path : Preferences \| Appearance & Behavior \| File Colors

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/15.png" }}" /> 

`+` 버튼을 통해서 Scope에 해당하는 색상을 등록할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/16.png" }}" /> 

|                Production Scope가 적용된 모습                |                선택한 Flavor에만 색상이 적용                 |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/17.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/18.png" }}" />  |

File Colors에 등록된 Scope에 해당하는 Colors 정보들은 File Trees 뿐만 아니라, 실제 편집 시의 상단 탭에도 색상이 반영되어있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/19.png" }}" /> 

### Reformat

개발 작업 시 코드 스타일대로 반영으로 `Reformat Code` 혹은 `Lint`로 스타일을 반영하기도 한다. 

그리고, Commit Changes의 `Reformat code`, `Rearrange code`, `Optimize imports` 으로 Commit시에 적용할 수 있다. 이 기능은 코드 스타일과, Property, Function, Import 기능 최적화와 순서를 정리하므로 어떤 결과가 되는지 모른 채로 Commit된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/20.png" }}" /> 

```kotlin
fun format(value:Int) {
    if(value!=5){
    println(value)
    }
}
```

위 코드처럼 스타일이 맞지 않더라도, Android Studio에서 스타일 수정이 필요하다고 안내해주지 않는다. 좀 더 확연하게 안내해주는 방법이 있다.

#### Inspection

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/21.png" }}" /> 

> Path : Preferences \| Editor \| Inspections
>
> Kotlin > Style issues > File is not formatted according to project settings 체크

Kotlin에서 포맷에 대한 Inspection 기능이 기본 체크 해제되어있다. 해당 부분을 체크한 후 `Severity`를 알맞게 변경함으로 바로 안내해준다. 실제로 적용한 것은 아래 화면에서 볼 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/22.png" }}" /> 

#### Formatter Markers

간혹 프로퍼티 정의 등을 위해서 `=` 을 이쁘게?! 맞추기 위해서 작업을 하는 경우도 많다. 하지만 Reformat Code 적용 시 다시 정렬해야 하는 작업을 해야 한다. 특정 영역의 Code Style 처리를 무효화시키는 것이 가능하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/23.png" }}" /> 

> Path : Preferences \| Editor \| Code Style

Formatter Control 탭의 `Enable formatter markers in comments` 체크

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/24.png" }}" /> 

상단과 하단의 메소드의 코드는 동일하다. 그렇지만 위의 코드는 `Error` 형태로 노출되지만, 하단의 코드는 문제없이 노출된다. 핵심은 Preference에 정의된 Annotation으로 Formatter Off/On으로 정의하는 것이다.

### Break Point

Break Point는 특정 지점에서 프로그램을 일시 중단해서 해당 지점에서 디버깅을 할 수 있는 기능을 지원한다.  Break Point는 단순한 형태도 가능하며, 특정 조건일 때 멈추도록 하는 `Condition` 기능도 제공하고 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/25.png" }}" /> 

`Condition` 이 적용된 경우 `?` 키원드가 노출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/26.png" }}" /> 

Condition은 위와 같이 입력하는 것이 가능하다.

기본적으로 Break Point는 쉽게 해제가 가능하여, Condition이 적용된 케이스에도 동일하다. Condition이 적용된 Break Point의 경우에 한번 더 확인하게 하여 삭제 시에 좀 더 신중하게 행동할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/27.png" }}" /> 

> Path : Preferences \| Build, Execution, Deployment \| Debugger
>
> Confirm removal of conditional or logging breakpoints 체크

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/28.png" }}" /> 

Condition이 적용된 Break Point를 해제 시에 노출되는 팝업 화면이다.

### Language Format

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/30.png" }}" /> 

Android Studio 내부에서 JSON으로 String을 인식시키는 방법이 존재한다. `⌥⏎` 키 입력한 후  `Inject language or reference`으로 해당 String을 어떤 형태로 인식시킬지 정의할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/31.png" }}" /> 

JSON 이외에 다양한 타입으로 선택할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/32.png" }}" /> 

추가적으로 Annotation을 더하여 추후에 Android Studio가 인식 가능하도록 `⌥⏎` 키를 선택한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/33.png" }}" /> 

선택 시 `@Language("JSON")`이 입력되어, 이후에도 해당 String은 JSON으로 처리된다.  

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/34.png" }}" /> 

JSON으로 인식된 경우 `⌥⏎` 키 입력 시 Android Studio 내에서 JSON을 편집할 수 있는 `JSON Fragment` 편집기를 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/35.png" }}" /> 

JSON Fragment 에디터를 통해서 `\n` 입력과 관계없이 쉽게 JSON 편집이 가능하다. 

다만 Annotation을 입력할지를 알리는 팝업은 방향키 혹은 마우스 이동 등의 아주 쉽게 팝업 해제가 된다. 대신, Inject language or reference 선택으로 노출된 Injection 할 언어 선택 시 자동으로 Annotation을 주입하도록 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/36.png" }}" /> 

> Path : Preferences \| Editor \| Language Injections \| Advanced
>
> Add @Language annotation or comment if needed 체크

### Layout Editor (xml)

기본적으로 Layout XML 파일을 열 경우 Design View가 먼저 노출된다. `Layout Editor`의 옵션을 수정해서 Design View 대신 Text View가 먼저 노출되도록 변경할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/38.png" }}" /> 

> Path : Preferences \| Editor \| Layout Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/39.png" }}" /> 

이것으로 Layout 파일은 Text View가 가장 앞으로 이동되어 쉽게 Text View 형태에서 작업을 시작할 수 있다.

### Preference Path Copy

Android Studio의 Preference가 있는 위치를 다양한 곳에 작성해야 할 경우가 있다. 특히나 이름이 아주 긴 경우에 더욱 Path 작성이 어렵다. 이럴 때는 Android Studio의 Preference가 위치한 Preference의 오른쪽 마우스를 누르면 `Copy Preferences Path` 메뉴가 노출되며 해당 Preferences의 Path를 복사할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0713-android-studio-tips/40.png" }}" /> 

결과는 다음과 같다.

Preferences \| Build, Execution, Deployment \| Debugger \| Data Views \| Kotlin

- - -

연재 글

- [Android Studio Tips #2]({{ site.baseurl }}/blog/android studio/2019/07/24/android-studio-tip2/)