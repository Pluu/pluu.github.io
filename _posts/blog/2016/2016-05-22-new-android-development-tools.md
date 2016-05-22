---
layout: post
title: "Android Studio 2.2 Preview 1"
date: 2016-05-22 16:30:00 +09:00
tag: [Android, Android-Studio]
categories:
- blog
- Android
---

Android Studio 2.2 Preview 1이 Google I/O 2016에서 발표했습니다.

Android Studio 2.1의 첫 Preview가 2016년 3월 10일에 발표되었고, 정식 버전은 4월 27일에 발표했습니다.

2.0부터는 새로운 버전 출시 주기가 상당히 빨라진 것으로 보입니다.

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-01.png" }}" />

## Coponent Installer

Background 실행 기능 추가

## Analyze APK

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-02.png" }}" />

APK 내에서 사용되고 있는 `리소스, 클래스` 등의 내용의 `Raw File Size, Download Size, 전체 비율` 등을 보여줘, 65K 문제나 APK 사이즈 줄이는 작업에도 도움이 될 것 같습니다.

APK를 리팩키징을 하여 보여줘, 라이브러리/클래스/이미지 하나하나 단위로 나타내므로, 현재 APK의 분석 및 APK 디컴파일용으로도 유용해 보입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-03.png" }}" />

> 샘플 이미지는 WebToon APK로 큰 기능은 없기에 리소스는 적게 차지하고, Realm 라이브러리, Class 순으로 비중을 차지하고 있었습니다.

## Merged Manifest Viewer

애플리케이션을 만들면서 여러 조합으로 애플리케이션은 만들어집니다. 이때 Manifest의 전체 결과는 자동으로 정리되었지만, Permission, Activity 등의 Manifest 정보가 결과적으로 어떻게 만들어지며, 해당 내용의 사용 출처를 알려줍니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-04.png" }}" />

> 샘플 이미지는 WebToon 소스의 Manifest로 LeakCanary 관련 service를 선택한 상태 표시입니다.

## Project Structure Dialogue (출시예정)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-05.png" }}" />

기존 Android Studio의 Project Structure와 사뭇 비슷해 보이지만, 오히려 IntelliJ의 구성에 더 가까워진 느낌이었습니다.

기존 Depedency 표시는 라이브러리 최신 버전 검색, 해당 라이브러리 및 버전 명시, Build Type, Scope의 자유도가 있었지만, 새로운 Project Structure에서는 기존 Dependency 선택 시의 불편함이 해소될 것으로 보입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-06.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-07.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-08.png" }}" />

#### Step1

`Group ID / Artifact Naem / Repository / Versions` 선택 가능

#### Step2

Dependency의 `Scopes / Build Types / Product Flavor` 선택 가능

## Cnhanced C++ (CMake and NDK-Build, 출시예정)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-09.png" }}" />

Android Studio 2.2 Preview 1에는 `IntelliJ & CLion 2016.1`이 포함되어 더 나은 C++ Project 작업이 가능하게 되었습니다.

그리고, 자연스럽게 C++의 디버깅도 가능합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-10.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-11.png" }}" />

## Layout Editor

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-12.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-13.png" }}" />

- Menu / Preference에 대해서 Drag & Drop으로 메뉴 추가 가능
- ScrollVeiw 사용 시 Layout Editor 스크롤이 가능
- 속성 탭 UI 개선

## Constraint Layout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-14.png" }}" />

기존 RelativeLelayout / LinearLayout 등으로 복잡한 레이아웃을 구성했지만, 새롭게 등장한 `ConstraintLayout`으로 깊은 UI Depth의 상태가 되지 않으면서 레이아웃 구성이 가능하게 되었습니다.

- Fast UI Development
- Responsive UI
- Performant UI
- Gingerbread Compatible

하지만, 간편하게 LayoutEditor로 UI를 작성할 수 있지만, 실제 작성되는 코드의 Namespace / Attribute의 결과는 복잡한 상황입니다. 여기에 대한 대응은 여러분의 몫입니다.

실제 작성되는 XML 코드량이 너무 방대하여 링크로 대체합니다.

> [activity_main_done.xml](https://github.com/googlecodelabs/constraint-layout/blob/master/constraint-layout-start/app/src/main/res/layout/activity_main_done.xml)

다행히 `Converter` 기능이 지원되므로 기존방법처럼 작성 후 Convert하는 방법도 괜찮을듯합니다.

## Firebase

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-15.png" }}" />

이번 Google I/O 2016에서 핫한 Firebase 기능이 Android Studio에도 포함되었습니다.

접근방법은 `Tools > Firebase`입니다.

자세한 내용은 다음 링크를 참고하세요

[Firebase](https://firebase.google.com/?utm_source=studio)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-16.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-17.png" }}" />

위 그림은 `Firebase > Cloud Messaging`을 선택했을 때 설정 화면입니다.

## Find Sample Code (Code Sample Browser)

Android Flatform 사용 시 해당 함수의 사용기능이 궁금했다면, 기존 샘플 코드의 작성 방법을 알려줍니다.

해당 Class, Method에서 `Right Click - Find Sample Code`를 선택하면 됩니다.

## Permissions Dialog (출시예정)

RuntimePermission은 마시멜로부터 중요한 체크 사항이지만, 작업해야 할 코드가 의외로 많다는 사실은 알고 있습니다. 이런 고충을 Android Studio에서 해결 가능하게 되었습니다.

`Refactor > Convert to Android System Permissions`

## Record Espresso Test (출시예정)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-18.png" }}" />

에뮬레이터의 동작을 통해서 자동으로 Espresso Test Code를 자동으로 작성해주는 기능이 추가되었습니다. 실제 비교할 Asseretion 값도 Edit 가능하므로, 한결 쉬운 Test Code 작성이 가능하게 되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-19.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-20.png" }}" />

Test Target으로 `Cloud Testing`도 보이네요.

## Another

- 현재 코드가 Leak 발생 여부를 알려줍니다.
- 일정이상 버전에서만 지원 가능한 함수의 실행은 `if (VERSION.SDK_INT > = VERSION_CODES.LOLLIPOP)` 으로 했다면, 메서드단에 지정 가능한 `@RequiresApi`가 생겼습니다. 이전 코드를 `@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)`으로 변경 가능합니다.
- @Dimension, @Px 등의 Annotation 추가
- ProGuard에서 Keep 되기 위한 `@Keep` Annotation 추가
- `Analyze > Infer Annotation` 추가

## Instant Run

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-21.png" }}" />

메소드 내의 수정은 바로 실행, 메소드 추가에 따른 변화는 Application 처음부터 실행

- Hot Swap
  - This is the fastest type of swap and makes changes visible almost instantly. Your application keeps running and a stub method with the new implementation is used the next time the method is called.
- Warm Swap
  - This swap is still very fast, but requires an automatic activity restart when Instant Run pushes the changed resources to the target device. Your app keeps running, but a small flicker may appear on the screen as the activity restarts—this is normal.
- Cold Swap
  - API level 21 or higher) Instant Run pushes the structural code changes to the target device and restarts the whole app.
  - For target devices running API level 20 or lower, Android Studio deploys a full build of the APK.

## 자세한 영상

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-05-22-new-android-development-tools-22.png" }}" />

<iframe width="560" height="315" src="https://www.youtube.com/embed/csaXml4xtN8" frameborder="0" allowfullscreen></iframe>

## 읽어볼 만한 페이지

- [Android Studio 2.2 Preview - New UI Designer & Constraint Layout](http://android-developers.blogspot.kr/2016/05/android-studio-22-preview-new-ui.html)
- [New Layout Editor with Constraint Layout](http://tools.android.com/tech-docs/layout-editor)
- [Firebase Plugin for Android Studio](http://tools.android.com/tech-docs/firebase-plugin)
- [Instant Run](http://tools.android.com/tech-docs/instant-run)
