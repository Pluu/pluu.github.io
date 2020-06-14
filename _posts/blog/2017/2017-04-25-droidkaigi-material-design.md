---
layout: post
title: "[번역] DroidKaigi 2017 ~ 역순 머티리얼 디자인"
date: 2017-04-25 00:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 逆引きマテリアルデザイン](http://yaraki.github.io/slides/droidkaigi2017/#1) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

역순 머티리얼 디자인

```
DroidKaigi 2017
2017/03/09
Araki Yuichi
```

## 2p 자기소개

Araki Yuichi

[@yuichi_araki](https://twitter.com/yuichi_araki)

Developer Programs Engineer @Google

- Support Library (주로 design 과 transition)
- [d.android.com/samples](http://d.android.com/samples) 샘플 여러 가지
- Android Studio 템플릿 일부
- [CameraView](https://github.com/google/cameraview)

## 3p

머티리얼 디자인

## 4p 머티리얼 디자인

[https://material.io](https://material.io/)

"디지털 경험을 만들기 위한 이론과 리소스와 도구를 맞춘 통합 시스템"

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/Q8TXgCzxEnw" frameborder="0" allowfullscreen></iframe>
</div>

## 5p 머티리얼 디자인 가이드라인

[https://material.io/guidelines/](https://material.io/guidelines/)

- 개요
- Motion
- Style
- Layout
- Components
- Patterns
- …

## 6p [What's new](https://material.io/guidelines/material-design/whats-new.html)

[https://material.io/guidelines/material-design/whats-new.html](https://material.io/guidelines/material-design/whats-new.html)

수시로 업데이트되고 있다

최근 업데이트

- Platforms : 플랫폼별로 변형
- Accessibility : 읽기에 관해 설명 추가

## 7p 일본어판

머티리얼 디자인 가이드라인 일본어판

[https://material.io/jp/guidelines/](https://material.io/jp/guidelines/)

PDF

## 8p 오늘 주제

머티리얼 디자인을 형태로 한다

- 있는 것을 활용
- 사용자 정의
- 움직인다
  - 공동 작업
  - 상태 변화

## 9p

있는 것을 활용한다

## 10p [Components - Buttons: Floating Action Button](https://material.io/guidelines/components/buttons-floating-action-button.html)

- 크기는 40 또는 56dp
- 그림자
- 표시·비표시 전환은 스케일 애니메이션

→ 머티리얼 디자인 서포트 라이브러리

## 11p FloatingActionButton

머티리얼 디자인 서포트 라이브러리

```
<android.support.design.widget.FloatingActionButton
    android:layout_height="wrap_content"
    android:layout_width="wrap_content"
    app:fabSize="normal"
    app:srcCompat="@drawable/ic_action" />
```
```
FloatingActionButton fab = ...;
fab.show();
...
fab.hide();
```

## 12p 주의점

라이브러리를 사용에 있어서 유의점

- 그 화면에서의 주요 작업
  - 내비게이션에 사용하지 않는다
  - 특히 중요하지 않은 작업에 사용하지 않는다
- 오른쪽 아래가 아니어도 좋다
- 아래의 요소를 막아 버리지 않도록 주의

## 13p Components - ...

- Bottom navigation (BottomNavigationView)
- Bottom sheets (BottomSheetBehavior)
- Buttons / FAB (AppCompatButton / FAB)
- Cards (CardView)
- Snackbars & toasts (Snackbar)
- Tabs (TabLayout)
- Text fields (TextInputLayout)
- Toolbar (Toolbar)

## 14p [Components - Grid lists](https://material.io/guidelines/components/grid-lists.html)

이미지와 문자를 포함한 항목 위에 터치 피드백

```
<FrameLayout
    android:id="@+id/item"
    android:layout_width="256dp"
    android:layout_height="256dp"
    android:foreground=
      "?attr/selectableItemBackground">
    <!-- ImageView など -->
</FrameLayout>
```

ForegroundLinearLayout으로 검색

## 15p [Patterns - Launch screens](https://material.io/guidelines/patterns/launch-screens.html)

0.1초라도 빠르게 사용자가 관심 있는 콘텐츠를 보여주는 것이 대원칙

다만 시간이 걸리는 경우 브랜드 이미지를 표시

## 16p [Patterns - Launch screens](https://material.io/guidelines/patterns/launch-screens.html)

[https://plus.google.com/+AndroidDevelopers/posts/Z1Wwainpjhd](https://plus.google.com/+AndroidDevelopers/posts/Z1Wwainpjhd)

```
<style name="Theme.MyApp.Launcher">
  <item name="android:windowBackground">
    @drawable/launch_screen</item>
</style>
```
```
 @Override
  protected void onCreate(Bundle savedInstanceState) {
    setTheme(R.style.Theme_MyApp); // 보통 배경으로 되돌린다
    super.onCreate(savedInstanceState);
    ...
```

## 17p

사용자 정의

## 18p 스타일과 테마를 이해한다

XML에서 @style/foobar 과 ?attr/foobar는 각각 무슨 뜻?

스타일과 테마는 어떻게 다른가?

FAB의 색상은 어디서 오는가?

## 19p 속성

스타일이나 테마 지정에 이용하는 키

res/values/attrs.xml

```
<declare-styleable name="FloatingActionButton">
  <attr name="backgroundTint"/>
  <attr name="fabSize">
    <enum name="auto" value="-1"/>
    <enum name="normal" value="0"/>
    <enum name="mini" value="1"/>
  </attr>
  ...
</declare-styleable>
```

타입은 integer, float, string, boolean, enum, flag, dimension, color, reference, fraction

## 20p 스타일

속성과 그 값의 매핑

res/values/styles.xml

```
<style name="Widget.MyApp.FloatingActionButton"
       parent="Widget.Design.FloatingActionButton">
  <item name="backgroundTint">@color/add</item>
  <item name="fabSize">normal</item>
</style>
```

명시적인 상속 · 암시적인 상속

## 21p 스타일 사용

레이아웃 XML

```
<android.support.design.widget.FloatingActionButton
  android:id="@+id/fab"
  style="@style/Widget.MyApp.FloatingActionButton"
  android:layout_width="wrap_content"
  android:layout_height="wrap_content"
  app:srcCompat="@drawable/ic_android"/>
```

## 22p 테마

속성과 그 값의 매핑 (= 스타일과 동일)

res/values/themes.xml (styles.xml)

```
<style name="Theme.MyApp"
       parent="Theme.AppCompat.Light.DarkActionBar">
  <item name="colorPrimary">@color/colorPrimary</item>
  <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
  <item name="colorAccent">@color/colorAccent</item>
</style>
```

## 23p 테마 사용

AndroidManifest.xml

```
<activity
    android:name=".MainActivity"
    android:theme="@style/Theme.MyApp">
    ...
```

## 24p 테마내의 속성값 사용

레이아웃 XML

```
<android.support.v7.widget.Toolbar
  android:id="@+id/toolbar"
  android:layout_width="match_parent"
  android:layout_height="?attr/actionBarSize"
  android:background="?attr/colorAccent"/>
```

## 25p [Components - Text fields](https://material.io/guidelines/components/text-fields.html)

android.support.design.widget.TextInputLayout

에러 텍스트 색상을 사용자 정의 한다

## 26p 예: 문서에서 (1/2)

[TextInputLayout 레퍼런스](http://d.android.com/reference/android/support/design/widget/TextInputLayout.html)에서 errorTextAppearance 를 찾는다

레이아웃 XML

```
<android.support.design.widget.TextInputLayout
  android:id="@+id/input"
  android:layout_width="match_parent"
  android:layout_height="wrap_content"
  app:errorTextAppearance="@style/TextAppearance.MyApp.Error">
  ...
```

## 27p 예: 문서에서 (2/2)

TextAppearance 을 스타일로 작성

res/values/styles.mxl

```
<style name="TextAppearance.MyApp.Error"
       parent="TextAppearance.Design.Error">
  <item name="android:textColor">@color/my_error</item>
</style>
```

## 28p 예: 소스 코드에서 (1/4)

frameworks/support/design/res/values/styles.xml

```
<style name="Widget.Design.TextInputLayout" parent="android:Widget">
  <item name="hintTextAppearance">@style/TextAppearance.Design.Hint</item>
  <item name="errorTextAppearance">@style/TextAppearance.Design.Error</item>
  <item name="counterTextAppearance">@style/TextAppearance.Design.Counter</item>
  <item name="counterOverflowTextAppearance">@style/TextAppearance.Design.Counter.Overflow</item>
  <item name="passwordToggleDrawable">@drawable/design_password_eye</item>
  <item name="passwordToggleTint">@color/design_tint_password_toggle</item>
  <item name="passwordToggleContentDescription">@string/password_toggle_content_description</item>
</style>
```

## 29p 예: 소스 코드에서 (2/4)

frameworks/support/design/res/values/styles.xml

```
<style name="TextAppearance.Design.Error"
       parent="TextAppearance.AppCompat.Caption">
  <item name="android:textColor">@color/design_error</item>
</style>
```

## 30p 예: 소스 코드에서 (3/4)

frameworks/support/design/res/color/design_error.xml

```
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_enabled="false"
          android:color="?android:attr/textColorTertiary"/>
    <item android:color="?attr/textColorError"/>
</selector>
```

## 31p 예: 소스 코드에서 (4/4)

자신의 앱 테마로 textColorError 를 지정하면 된다

```
<style name="Theme.MyApp"
       parent="Theme.AppCompat.Light.DarkActionBar">
  ...
   <item name="textColorError">#090</item>
</style>
```

## 32p

View 들을 강조시켜 이동시킨다

## 33p Material design - Material properties

여러 요소가 같은 공간 (elevation) 에 존재하면 안 된다

## 34p [Material design - Elevation & shadows](https://material.io/guidelines/material-design/elevation-shadows.html)

| Elevation (dp) | Component |
| :-- | :-- |
| 24 | Dialog / Picker |
| 16 | Nav drawer / Modal bottom sheet |
| ... | ... |
| 8 | FAB / Snackbar |
| ... | ... |

## 35p [Components - Snackbars & toasts](https://material.io/guidelines/components/snackbars-toasts.html#snackbars-toasts-usage)

Snackbar가 나올 때 FAB 가 비킨다

FAB 을 CoordinatorLayout 에 넣으면 자동으로 된다  

```
Snackbar
  .make(view, "Hello!",
        Snackbar.LENGTH_SHORT)
  .show();
```

<video controls="" loop="" preload="metadata" width="50%" height="auto">
  <source src="https://storage.googleapis.com/material-design/publish/material_v_10/assets/0B6Okdz75tqQsZV9TS3lTVHFzRUE/components_snackbar_usage_fabdo_005.webm" type="video/webm">
</video>

## 36p FAB처럼 비키고 싶다

FAB 처럼 아래에서 나오는 Snackbar를 비키고 싶다

CoordinatorLayout 바로 아래에

```
<com.example.yourapp.CustomView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="bottom"
    app:layout_dodgeInsetEdges="bottom"/>
```

## 37p Snackbar처럼 비키도록 하고 싶다

Snackbar처럼 FAB 등을 비키도록 하고 싶다

CoordinatorLayout 바로 아래에

```
<com.example.yourapp.CustomView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="bottom|start"
    app:layout_insetEdge="bottom"/>
```

## 38p [Components - Bottom sheets](https://material.io/guidelines/components/bottom-sheets.html#bottom-sheets-persistent-bottom-sheets)

```
<a.s.d.w.FloatingActionButton
  android:id="@+id/pause"
  android:layout_width="wrap_content"
  android:layout_height="wrap_content"
  app:layout_anchor="@id/bottom_sheet"
  app:srcCompat="@drawable/ic_pause"/>
```

@id/bottom_sheet가 움직임에 따라 뒤따른다

## 39p

상태 변화를 움직인다

## 40p [Motion - Transforming material](https://material.io/guidelines/motion/transforming-material.html#transforming-material-rectangular-transformation)

이미지 확대 축소 애니메이션

어떻게 구현하는가?

- ViewPropertyAnimator?
  - view.animate()...
- Animator?
  - ObjectAnimator / ValueAnimator

유저가 애니메이션 중에 전환을 반복하는 경우에 어떻게 대응하는가?

## 41p [Transition API](https://developer.android.com/training/transitions/overview.html)

API 레벨 19 KitKat에서 도입

Animator에 따른 고수준 애니메이션 API

※ Activity 간의 Transition만이 Transition은 아니다

## 42p Transition API 사용법

```
ChangeBounds changeBounds = new ChangeBounds();
...
TransitionManager.beginDelayedTransition(root, changeBounds);
FrameLayout.LayoutParams lp =
    (FrameLayout.LayoutParams) v.getLayoutParams();
lp.width = lp.height = FrameLayout.LayoutParams.WRAP_CONTENT;
v.setLayoutParams(lp);
```

## 43p 다양한 Transition

| Transition | 애니메이션 대상 |
| :--- | :--- |
| ChangeBounds | 크기와 위치 |
| ChangeTransform | scale, rotation 등 |
| ChangeScroll | 스크롤 위치 |
| ChangeImageTransform | ImageView의 scaleType |
| Fade | visibiliy |
| Slide	| visibiliy |
| Explode	| visibiliy |
| TransitionSet	| 조합 |

## 44p [Motion– Choreography](https://material.io/guidelines/motion/choreography.html)

<video controls="" loop="" aria-describedby="continuity-figure-caption-2" loop="" preload="metadata" tabindex="0"  width="100%" height="auto">
<source src="https://storage.googleapis.com/material-design/publish/material_v_11/assets/0B14F_FSUCc01MDBDd3JsRV9kZWM/Continuity_02_SingleShared_v6-remapped.webm" type="video/webm">
<source src="https://storage.googleapis.com/material-design/publish/material_v_11/assets/0B14F_FSUCc01VUdTaW40WXFvdGM/Continuity_02_SingleShared_v6-remapped.mp4" type="video/mp4">
</video>

## 45p Transition API 기능

PathMotion

호에 따라 움직인다

TransitionPropagation

복수 애니메이션의 startDelay를 별도로 조정한다

## 46p 정리

- 머티리얼 디자인 가이드라인을 읽으세요
- 있는 것을 활용하자
  - 라이브러리, 플랫폼의 기능
- 사용자 정의
  - 스타일과 테마의 기본을 알면 원하는 대로 사용자 정의할 수 있다
- 컴포넌트 간의 공동 작업
  - CoordinatorLayout을 사용할 수 있다
- 상태 변화를 애니메이션
  - Transition API를 사용할 수 있다

## 47p

Android 플랫폼

지원 라이브러리

b.android.com

버그 리포트, 기능 요청은 이쪽에서

※ 스크린 샷 (동영상) 중요