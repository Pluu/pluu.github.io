---
layout: post
title: "[번역] Material Design 느낌이 높아지는 Ripple Effect 대응"
date: 2016-01-03 13:00:00 +09:00
tag: [Android, Material Design]
categories:
- blog
- Android
---

본 포스팅은 [Material Design度が高まるRipple Effect対応](http://qiita.com/nissiy/items/bf2742ffb990e3c8f875) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 개요

Material Design 대응을 하는 앱이 많아진 느끼는 요즘입니다만, 여러분 Ripple Effect 대응은 하고 있습니까?

Ripple Effect는 Material Design 중에서도 열쇠가 되는 표현 효과이지만, API 레벨 21 (Lollipop) 이상의 OS가 아니면 표준 구조로는 다루지 못하기 때문에 뒷전으로 하는 앱도 많은 것이 아닐까라고 생각합니다.

이번에는 제가 개발에 참여하고 있는 여성용 애플리케이션 [iQON](https://play.google.com/store/apps/details?id=jp.vasily.iqon&hl=ja)에서 Ripple Effect 대응을 할 때의 이야기를 쓰고 싶습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/40539/5d3901e4-5cb9-c835-a228-b3052e7a26bc.gif" />

## 대응 방침

Ripple Effect 대응을 하기 있어서 먼저 아래와 같이 대응 방침을 정했습니다.

### 1. 표준 구조를 사용해서 대응

Ripple Effect는 Backporting 된 서드파티 Library가 일부 존재하지만, 이번에는 그런 Library를 사용하지말고, OS가 표준으로 제공하고 있는 구조를 써서 대응하기로 했습니다.

따라서, 실제로 Ripple Effect가 나타나는 것은 API 레벨 21 이상의 OS만 됩니다. 그러나 API 레벨 21 미만의 경우에도 Pressed일 때의 터치 피드백을 Ripple Effect와 같은 영역에 표시하도록 합니다.

서드파티 Library를 사용하지 않는 이유로는 Ripple Effect 부분을 서드파티 Library에 의존하면 대부분 화면이 의존해버리므로 어떤 일이 있을 때의 수리가 어려울 가능성이 있다고 생각하기 때문입니다.

### 2. 가능한 drawable-v21이하에 파일을 만들지 않는다

장기적으로 작업을 계속하는 앱인 경우, 버전별로 같은 이름의 파일을 너무 만들면 수리에 어려운 구조가 될 가능성이 있으므로, 가능한 drawable-v21 이하에 파일을 만들지 않도록 합니다.

그러나, UI의 표현상 ripple 태그를 사용할 필요가 있는 경우나 '?android:attr/selectableItemBackgroundBorderless' 를 사용할 필요가 있는 경우는 어쩔 수 없다고 판단됩니다.

### 3. ImageView 등의 View를 가지는 ViewGroup을 탭 영역으로 할 경우는 View를 Ripple Effect로 Overlay

앱에 따라서 사용하는 View를 Overlay하는 앱, 하지 않는 앱이 있지만 이번에는 View를 사용하는 경우에는 Overlay 하도록 통일하기로 했습니다. 이유는 Overlay하는 편이 Ripple Effect의 효과가 좋기 때문입니다.

Overlay 하지 않는 경우

<img src="https://qiita-image-store.s3.amazonaws.com/0/40539/46bfcfe1-b5b8-5d4a-3858-f241d6b7cab9.gif" />

Overlay 하는 경우

<img src="https://qiita-image-store.s3.amazonaws.com/0/40539/94e5c294-d1a7-d361-47c7-425b96fbd67c.gif" />

### 4. Ripple Effect 색은 지정한 색으로 한다

이 항목에 대해서는 앱 특유의 문제가 되지만, 앱 내의 디자인 통일을 위해서 Ripple Effect 색은 기본 회색 이외인 지정한 색이 되도록 했습니다.

API 레벨 21 미만의 Pressed일 때의 터치 피드백도 같은 색이 되도록 합니다.

## 구현

위의 대응 방침을 바탕으로 실제로 한 것을 소개하겠습니다.

### OnClickListener를 구현하는 View의 background/foreground에는 selectableItemBackground를 설정

예외도 있지만, OnClickListener을 구현하는 대부분의 View의 background/foreground에는 '?android:attr/selectableItemBackground'를 설정했습니다.

'?android:attr/selectableItemBackground'를 설정해서, 그 View에는 Pressed일때에 터치 피드백이 나타날 수 있습니다.

물론 API 레벨 21 이상에서는 Ripple Effect가 나타날 수 있습니다.

다른 Drawable를 설정하는 경우에는, Drawable안에 '?android:attr/selectableItemBackground'를 설정하면 대응 가능합니다.

### View를 Overlay 시키는 경우에는 foreground에 selectableItemBackground를 설정

ImageView 등의 View를 Overlay 시키고 싶은 경우에는, OnClickListener를 구현하는 ViewGroup의 foreground에 '?android:attr/selectableItemBackground'를 설정합니다. 그러나, foreground의 attribute를 가지는 ViewGroup은 'FrameLayout'이나 FrameLayout를 상속한' CardView' 등으로 제한되므로 주의가 필요합니다.

경우에 따라서는 View의 계층이 깊게 될 경우도 있다고 생각합니다만, 아무래도 신경이 쓰이는 경우에는 Google I/O 앱의 코드인 [ForegroundLinearLayout.java](https://github.com/google/iosched/blob/master/android/src/main/java/com/google/samples/apps/iosched/ui/widget/ForegroundLinearLayout.java) 등을 참고해서 CustomView를 만들면 피할 수 있다고 생각합니다.

### Ripple Effect의 색을 바꾸기 위해 colorControlHighlight에 색을 설정

'?android:attr/selectableItemBackground'를 설정 시 Ripple Effect (API 레벨 21 이상)의 색과 'colorControlHighlight'의 색은 연동하고 있으므로, 기본으로 사용하고 있는 style에 'colorControlHighlight' item을 추가합니다.

styles.xml

```xml
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    <item name="colorControlHighlight">@color/color_control_highlight</item>
</style>
```

### API 레벨 21 미만의 Pressed시를 위해 styles.xml를 버전별로 나누기

API 레벨 21 미만의 Press의 Touch Feedback을 Ripple Effect과 같은 색으로 하기 위해서 style에 'android:selectableItemBackground' item을 추가합니다.

그러나, 이걸로는 API 레벨 21 이상도 영향을 받으므로 Ripple Effect가 표시되지 않으므로, 'android:selectableItemBackground' item을 추가하지 않은 'v21/styles.xml'을 작성해서 넣을 필요가 있습니다 (더 나은 방법이 없는가).

styles.xml

```xml
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    <item name="colorPrimary">@color/color_primary</item>
    <item name="colorPrimaryDark">@color/color_primary_dark</item>
    <item name="colorAccent">@color/color_accent</item>
    <item name="colorControlHighlight">@color/color_control_highlight</item>
    <item name="android:selectableItemBackground">@drawable/pre_lollipop_selectable_item</item>
</style>
```

pre_lollipop_selectable_item.xml

```xml
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/color_control_highlight" android:state_pressed="true" />
    <item android:drawable="@android:color/transparent" />
</selector>
```

v21/styles.xml

```xml
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    <item name="colorPrimary">@color/color_primary</item>
    <item name="colorPrimaryDark">@color/color_primary_dark</item>
    <item name="colorAccent">@color/color_accent</item>
    <item name="colorControlHighlight">@color/color_control_highlight</item>
</style>
```

## 샘플 코드

이번 내용의 샘플코드는 여기에 있습니다

[https://github.com/nissiy/RippleSample](https://github.com/nissiy/RippleSample)

흥미가 있는 분은 API 레벨 21 이상과 API 레벨 21 미만의 단말에 빌드해서 비교해보세요.

## 정리

API 레벨 21 이상에서만 유효하지 않지만 '?android:attr/selectableItemBackground'의 사용에 맞추면 비교적 편리하게 Ripple Effect 대응이 가능합니다.

이번에 소개한 방법을 이용하면 API 레벨 21 미만의 Pressed시의 터치 피드백도 함께 최적화 가능하므로 추천합니다.

한번에 Material Design 느낌이 높아지므로 Ripple Effect 대응을 하지 않은 앱은 대응을 검토해보는 것은 어떤가요?
