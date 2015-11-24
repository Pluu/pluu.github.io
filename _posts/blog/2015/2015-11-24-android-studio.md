---
layout: post
title: "Android Studio 2.0 Preview 반나절 사용 후기"
date: 2015-11-24 20:45:00
tag: [Android, Android-Studio]
categories:
- blog
- Android
---

<!--more-->

Android Studio 2.0 Preview 가 2015년 11월 24일 새벽에 발표했습니다.

# Android Studio 2.0 의 특징
- `Instant Run`
- `Accelerated build and deployment sppeds`
- `Next-generation Emulator`
- New GPU profiler
- IntelliJ 15
- Enhanced testing support
- Support for Google Search deep linking

실제 관련된 자세한 영상은 다음 포스팅들을 체크해주세요

- [Android Studio 2.0 Preview](http://android-developers.blogspot.kr/2015/11/android-studio-20-preview.html?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed:+blogspot/hsDu+(Android+Developers+Blog))
- [Keynote with Dave Burke and Stephanie Cuthbertson (Android Dev Summit 2015)](https://www.youtube.com/watch?v=oBV2U4w89_A)

# 이 포스팅에서 이야기할 부분

주로 새로운 기능을 써보면서 나왔던 현상들을 공유할 목적으로 작성합니다

실제로 여러가지 추가된 기능도 있지만, 바로 볼 수 있는 항목 위주로 적어봤습니다.

# Instant Run

코드 및 레이아웃, values 관련 수정시 Application 처음부터 재시작 되지않고 해당 Activity 부터 재시작되어 적용되는 Run 기능입니다.

해당 Activity 만 재 실행되므로 빌드 속도가 빨라지고 좀 더 빠르게 테스트 테스트가 가능해진듯 합니다.

## Setting

`Instant Run` 을 동작 시키기 위해서는 프로젝트 설정이 다음과 같이 지원해야 합니다

- Build Tools Version 23.0.2
- Gradle Wrapper Version 2.8
- Gradle Build Plugin 2.0.0 Alpha
- Android OS Version ICS (14) 이상

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-01.PNG" }}" />

현재 프로젝트가 미지원인 경우 수동으로 작업하셔도 되고

Settings - Build, Execution, Deplyment - Instant Run 항목 진입시 `Update Project` 로 선택이 가능합니다.

## Run

Android Studio 2.0 에서는 기존 Run 과 달리 기본적으로 `Instant Run` 이 실행되며 IDE 도구 표시가 아래와 같이 바뀝니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-02.PNG" }}" />

변경점

- Instant Run 표시 추가 (아마도 번개 마크)

## Layout Edit

변경 점 : `텍스트 색상`

수정 전
{% highlight xml %}
<TextView
  android:id="@android:id/text1"
  android:layout_width="match_parent"
  android:layout_toLeftOf="@+id/status"
  android:layout_height="wrap_content"
  android:textAppearance="?android:attr/textAppearanceListItem"
  android:background="@drawable/border_gray"
  android:textColor="@android:color/white"
  android:singleLine="true"
  android:textStyle="bold"
  tools:text="Title"/>
{% endhighlight %}

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-03-Sample1.png" }}" />

수정 후
{% highlight xml %}
<TextView
  android:id="@android:id/text1"
  android:layout_width="match_parent"
  android:layout_toLeftOf="@+id/status"
  android:layout_height="wrap_content"
  android:textAppearance="?android:attr/textAppearanceListItem"
  android:background="@drawable/border_gray"
  android:textColor="#FF0"
  android:singleLine="true"
  android:textStyle="bold"
  tools:text="Title"/>
{% endhighlight %}

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-03-Sample2.png" }}" />

수정 후 캡쳐 화면을 보면 하단에 `Applied changes, restarted activity` 라고 표시되는데, 아마도 `Instant Run` 관련으로 Android 내부적으로 표시하도록 작업되어 있는것 같습니다.

## Code Edit

코드 수정은 아직 프리뷰 단계라서 이런 현상이 발생하는지는 모르겠지만, 코드 수정후 `Instant Run` 을 기대하고 실행하면 별 문제 없이 실행되기도 하지만 주로 다음과 같은 현상이 주로 발생했습니다.

### Restart Activity

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-04.PNG" }}" />

이 현상은 단순하게 알림이지만

```
Instant Run applied code changes.
You can restart the current activity by clicking here or pressing Ctrl+Shift+R anytime.
You can also configure restarts to happen automatically. (Dismiss, Dismiss All)
```

코드 수정시에는 `Ctrl+Shift+R` 을 이용해서 Activity 를 재실행하도록 알려주고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-05.PNG" }}" />

실제로 Run 관련 메뉴에 `Restart Activity` 라는 항목이 추가 되어있습니다.

### Build Fail

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-06.PNG" }}" />

아직 Android Studio 2.0인 관계상 나타나는 오류 일수도 있지만, 코드 수정시 빈번히 나오는 오류였습니다.

해당 에러가 나오는 경우에는 별 수 없이 올바르게 빌드 후 Application 자체를 재시작해야만 합니다.

# 추가적인 변경 사항

## Resource XML Depth 표시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-24-AS-07.PNG" }}" />

정확한 문구 설명은 어렵습니다만, XML 리소스에서 현재 포커스된 위치의 Depth 표시를 간단하게 하고 있었습니다.

# 간단 사용 후기

- `Instant Run`으로 코드 및 레이아웃 수정에 대한 체크 속도가 확실히 빠릅니다.
- Android Studio 1.5 정식판 발표한지 얼마되지않아 2.0 프리뷰 발표라는 당혹감
- X.0.0 및 Alpha1 이라는 불안한 버전
- 발표는 했지만, 아직 포함되지않은 Emulator 2.0
- Code 수정시 Build Fail 과 `Restart Activity` 실행시 `Applied changes, restarted activity` 가 표시되었지만, 수정되지 않은 경우도 발생
- Android Application + Library Module (AAR) 구조에서 Library Module 수정시에도 `Instant Run`이 정상 동작!!

반나절정도 간단하게 사용했지만, 기존 1.x에 비해서 실행에 대한 퍼포먼스는 확실히 상승한 듯 보였습니다.

체감상 빌드 로직 및 시간이 개선된것 같은(?) 느낌도 듭니다.

에뮬레이터를 좀 테스트해보고 싶었지만, 어떻게 실행해야하는지 찾을 수가 없어서 ... 추후에 업데이트 하겠습니다.
