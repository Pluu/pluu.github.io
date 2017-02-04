---
layout: post
title: "[번역] AlertDialog 스타일을 커스터마이즈"
date: 2017-02-04 22:30:00 +09:00
tag: [Java, RxJava]
categories:
- blog
- RxJava
---

본 포스팅은 [AlertDialogのスタイルをカスタマイズ](http://qiita.com/granoeste/items/bc30c25caefe5ceb102b) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

이 기사는 [Android 3 Advent Calendar 2016 - Qiita](http://qiita.com/advent-calendar/2016/android_third)의 12번째 기사입니다.

- - -

**주의!!**

이 문서는 appcompat-v7 버전 25.0.1에서 테스트한 내용입니다. 최신 버전 25.1.0에서는 android.support.v7.app.AlertController의 구현이 변경되어 사용할 수 없는 부분이 있습니다.

- - -

## AlertDialog 스타일을 커스터마이즈

[Support Library v7 appcompat 라이브러리](https://developer.android.com/topic/libraries/support-library/features.html?hl=ja#v7)를 사용하면 Android 2.3(API 레벨 9) 이상의 디바이스에서 앱에서 머티리얼 디자인을 사용할 수 있으며, 다이얼로그도 머티리얼 디자인입니다.

```
import android.support.v7.app.AlertDialog;

// 생략

    AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
    builder.setTitle("확인");
    builder.setMessage("XXX해도 괜찮습니까?");
    builder.setPositiveButton("예", null);
    builder.setNegativeButton("아니오", null);
    builder.setNeutralButton("취소", null);
    builder.create().show();
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/953ce775-018d-1595-7b43-99f7101be405.png"/>

NeutralButton이 왼쪽에 있고, PositiveButton과 NegativeButton이 오른쪽에 있는 디자인이네요.

일반 사용자가 사용하는 어플이라면 이 디자인으로 괜찮을 거라고 생각합니다만, 유아/고령자용 어플을 생각했을 때 더 큰 글자로 누르기 쉬운 버튼 디자인으로 하고 싶었기 때문에 다이얼로그를 커스터마이즈 해보겠습니다.

### styles.xml

먼저 스타일을 정의합니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">

</style>
```

AlertDialog.Builder의 두 번째 인수 int themeResId에 테마를 지정하여 커스터마이즈 스타일을 적용할 수 있습니다. [AlertDialog.Builder ┃ Android Developers](https://developer.android.com/reference/android/support/v7/app/AlertDialog.Builder.html#AlertDialog.Builder(android.content.Context,%20int))


```
AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.MyAlertDialogStyle);
```

어플의 모든 다이얼로그에 스타일을 적용하려면 AppTheme의 android:alertDialogTheme에 지정합니다.

```
// themes.xml
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
    <item name="colorPrimary">@color/primary</item>
    <item name="colorPrimaryDark">@color/primary_dark</item>
    <item name="colorAccent">@color/accent</item>
    <item name="android:alertDialogTheme">@style/MyAlertDialogStyle</item>
</style>
```

### 버튼의 텍스트 색상

colorAccent를 지정합니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
</style>
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/37d69bb5-3335-7361-48d0-48edf6e3024a.png"/>

### 타이틀과 버튼의 텍스트 크기

android:textSize를 지정합니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
    <item name="android:textSize">@dimen/dialog_text_size</item>
</style>
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/dac18f97-4e0a-d911-70cb-1ef253178509.png"/>

버튼이 세로로 되어버렸습니다...

메시지의 크기는 변경되지 않네요...

### 다이얼로그의 크기를 변경

android:windowMinWidthMajor, android:windowMinWidthMinor를 지정합니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
    <item name="android:textSize">@dimen/dialog_text_size</item>
    <item name="android:windowMinWidthMajor">@dimen/dialog_min_width_major</item>
    <item name="android:windowMinWidthMinor">@dimen/dialog_min_width_minor</item>
</style>
```

- android:windowMinWidthMajor... 최대 크기
- android:windowMinWidthMinor... 최소 크기

#### dimen은 화면 전체의 비율(%)로 지정할 수 있습니다.

```
// dimens.xml
<resources>
    <item type="dimen" name="dialog_min_width_major">95%</item>
    <item type="dimen" name="dialog_min_width_minor">95%</item>
</resources>
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/727f9db7-e7bb-96c0-c5e9-0af69d43168e.png"/>

## 텍스트 스타일

android:textColorPrimary를 지정하면 텍스트 색상을 변경할 수 있습니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
    <item name="android:textColorPrimary">@color/colorPrimary</item>
</style>
```

android:windowTitleStyle을 정의하면 타이틀 스타일을 변경할 수 있습니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
    <item name="android:windowTitleStyle">@style/windowTitleStyle</item>
</style>

<style name="windowTitleStyle" parent="TextAppearance.AppCompat.Large">
    <item name="android:textSize">@dimen/dialog_text_size</item>
</style>
```

## 메시지의 텍스트 크기

메시지의 텍스트 크기를 지정할 수 있는 속성이 존재하지 않았기 때문에 코드로 해킹합니다.

```
AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.MyAlertDialogStyle);
builder.setTitle("확인");
builder.setMessage("XXX해도 괜찮습니까?");
builder.setPositiveButton("예", null);
builder.setNegativeButton("아니오", null);
builder.setNeutralButton("취소", null);

AlertDialog dialog = builder.show();

// 메시지 텍스트를 변경한다.
TextView textView = (TextView) dialog.findViewById(android.R.id.message);
textView.setTextSize(48.0f);
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/8a177b77-98a5-47a0-a7a9-4be52e1225e1.png"/>

## 버튼 스타일

buttonBarNeutralButtonStyle, buttonBarNegativeButtonStyle, buttonBarPositiveButtonStyle에서 지정할 수 있습니다.

```
// styles.xml
<style name="MyAlertDialogStyle" parent="Theme.AppCompat.Light.Dialog">
    <item name="colorAccent">@color/primary</item>
    <item name="android:textSize">@dimen/dialog_text_size</item>
    <item name="android:windowMinWidthMajor">@dimen/dialog_min_width_major</item>
    <item name="android:windowMinWidthMinor">@dimen/dialog_min_width_minor</item>

    <item name="buttonBarNeutralButtonStyle">@style/buttonBarButtonStyle.Neutral</item>
    <item name="buttonBarNegativeButtonStyle">@style/buttonBarButtonStyle.Negative</item>
    <item name="buttonBarPositiveButtonStyle">@style/buttonBarButtonStyle.Positive</item>

</style>
```

### 텍스트 색상

```
// styles.xml
<style name="buttonBarButtonStyle" parent="Widget.AppCompat.Button.Borderless.Colored">
</style>

<style name="buttonBarButtonStyle.Neutral">
</style>

<style name="buttonBarButtonStyle.Negative">
    <item name="android:textColor">@color/red</item>
</style>

<style name="buttonBarButtonStyle.Positive">
    <item name="android:textColor">@color/blue</item>
</style>
```

부모(parent)에 Widget.AppCompat.Button.Borderless.Colored를 지정하면 텍스트 컬러의 기본이 colorAccent로 됩니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/1a957701-a0a1-d759-581f-d544c018ace2.png"/>

#### 컬러 버튼

부모(parent)에 Widget.AppCompat.Button.Colored을 지정하면 colorAccent를 배경으로 한 버튼이 배치됩니다.

```
// styles.xml
<style name="buttonBarButtonStyle" parent="Widget.AppCompat.Button.Colored">
</style>

<style name="buttonBarButtonStyle.Neutral">
</style>

<style name="buttonBarButtonStyle.Negative">
    <item name="android:textColor">@color/red</item>
</style>

<style name="buttonBarButtonStyle.Positive">
    <item name="android:textColor">@color/blue</item>
</style>
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/f34ceb01-4c5e-46a7-808c-ee0c81b0fd49.png"/>

##### 배경

~~배경의 크기를 크게하거나 색상을 변경할 경우에는 android:background를 변경합니다.~~

~~Ripple 효과가 있는 배경으로 하고싶은 경우는 appcompat 소스를 참고하면 좋을 것입니다.~~

배경 색상을 변경할 경우에는 app:backgroundTint를 지정합니다.

```
<style name="buttonBarButtonStyle.Positive">
    <item name="backgroundTint">@color/colorAccent</item>
</style>
```

## 버튼의 배치

머티리얼 디자인 이전의 다이얼로그처럼 버튼이 중앙에 3개의 있는 스타일을 원한다면, 코드로 해킹합니다.

```
AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.MyAlertDialogStyle);
builder.setTitle("확인");
builder.setMessage("XXX해도 괜찮습니까?");
builder.setPositiveButton("예", null);
// builder.setNegativeButton("아니오", null);
builder.setNeutralButton("취소", null);

AlertDialog dialog = builder.show();

// 메시지 텍스트를 변경한다.
TextView textView = (TextView) dialog.findViewById(android.R.id.message);
textView.setTextSize(48.0f);

// 버튼 패널의 컨테이너를 가져온다.
LinearLayout containerButtons = (LinearLayout) dialog.findViewById(R.id.buttonPanel);

// Space View를 삭제한다
containerButtons.removeView(containerButtons.getChildAt(1));

// 버튼 패널의 자식 View의 버튼의 Gravity을 CENTER로 설정
containerButtons.setGravity(Gravity.CENTER);

// LinearLayout의 비율의 합계를 3으로 설정한다.
containerButtons.setWeightSum(3.0f);

// 각 버튼을 얻는다.
Button button3 = (Button) containerButtons.findViewById(android.R.id.button3);
Button button2 = (Button) containerButtons.findViewById(android.R.id.button2);
Button button1 = (Button) containerButtons.findViewById(android.R.id.button1);

// 각 버튼의 비율을 지정한다
((LinearLayout.LayoutParams)button3.getLayoutParams()).weight = 1.0f;
((LinearLayout.LayoutParams)button2.getLayoutParams()).weight = 1.0f;
((LinearLayout.LayoutParams)button1.getLayoutParams()).weight = 1.0f;

// 각 버튼의 폭을 0으로 한다
((LinearLayout.LayoutParams)button3.getLayoutParams()).width = 0;
((LinearLayout.LayoutParams)button2.getLayoutParams()).width = 0;
((LinearLayout.LayoutParams)button1.getLayoutParams()).width = 0;
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/12177/c9cd3a93-dad8-c15e-1c0c-cf3c0376f2fb.png"/>

## Layout으로 해킹

appcompat 라이브러리에서 사용되는 리소스를 덮어쓰는 것으로 다이얼로그의 디자인을 변경할 수 있습니다.

[sdk/extras/android/support/v7/appcompat/res/layout/abc_alert_dialog_material.xml - android_tools - Git at Google](https://chromium.googlesource.com/android_tools/+/HEAD/sdk/extras/android/support/v7/appcompat/res/layout/abc_alert_dialog_material.xml)

```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:id="@+id/parentPanel"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical">
    <LinearLayout
            android:id="@+id/topPanel"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical">
        <LinearLayout
                android:id="@+id/title_template"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="horizontal"
                android:gravity="center_vertical"
                android:paddingLeft="?attr/dialogPreferredPadding"
                android:paddingRight="?attr/dialogPreferredPadding"
                android:paddingTop="@dimen/abc_dialog_padding_top_material">
            <ImageView
                    android:id="@android:id/icon"
                    android:layout_width="32dip"
                    android:layout_height="32dip"
                    android:scaleType="fitCenter"
                    android:src="@null"
                    style="@style/RtlOverlay.Widget.AppCompat.DialogTitle.Icon"/>
            <android.support.v7.widget.DialogTitle
                    android:id="@+id/alertTitle"
                    style="?attr/android:windowTitleStyle"
                    android:singleLine="true"
                    android:ellipsize="end"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:textAlignment="viewStart" />
        </LinearLayout>
        <!-- If the client uses a customTitle, it will be added here. -->
    </LinearLayout>
    <FrameLayout
            android:id="@+id/contentPanel"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:minHeight="48dp">
        <View android:id="@+id/scrollIndicatorUp"
              android:visibility="gone"
              android:layout_width="match_parent"
              android:layout_height="1dp"
              android:layout_gravity="top"
              android:background="?attr/colorControlHighlight"/>
        <android.support.v4.widget.NestedScrollView
                android:id="@+id/scrollView"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:clipToPadding="false">
            <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="vertical">
                <TextView
                        android:id="@android:id/message"
                        style="@style/TextAppearance.AppCompat.Subhead"
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:paddingLeft="?attr/dialogPreferredPadding"
                        android:paddingTop="@dimen/abc_dialog_padding_top_material"
                        android:paddingRight="?attr/dialogPreferredPadding"/>
                <View
                        android:id="@+id/textSpacerNoButtons"
                        android:visibility="gone"
                        android:layout_width="0dp"
                        android:layout_height="@dimen/abc_dialog_padding_top_material"/>
            </LinearLayout>
        </android.support.v4.widget.NestedScrollView>
        <View android:id="@+id/scrollIndicatorDown"
              android:visibility="gone"
              android:layout_width="match_parent"
              android:layout_height="1dp"
              android:layout_gravity="bottom"
              android:background="?attr/colorControlHighlight"/>
    </FrameLayout>
    <FrameLayout
            android:id="@+id/customPanel"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:minHeight="48dp">
        <FrameLayout
                android:id="@+id/custom"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"/>
    </FrameLayout>
    <include layout="@layout/abc_alert_dialog_button_bar_material" />
</LinearLayout>
```

[sdk/extras/android/support/v7/appcompat/res/layout/abc_alert_dialog_button_bar_material.xml - android_tools - Git at Google](https://chromium.googlesource.com/android_tools/+/HEAD/sdk/extras/android/support/v7/appcompat/res/layout/abc_alert_dialog_button_bar_material.xml)

```
// layout/abc_alert_dialog_button_bar_material.xml
<?xml version="1.0" encoding="utf-8"?>
<android.support.v7.widget.ButtonBarLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/buttonPanel"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layoutDirection="locale"
    android:orientation="horizontal"
    android:paddingLeft="12dp"
    android:paddingRight="12dp"
    android:paddingTop="4dp"
    android:paddingBottom="4dp"
    android:gravity="bottom"
    app:allowStacking="@bool/abc_allow_stacked_button_bar"
    style="?attr/buttonBarStyle">
    <Button
        android:id="@android:id/button3"
        style="?attr/buttonBarNeutralButtonStyle"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />
    <android.support.v4.widget.Space
        android:id="@+id/spacer"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:visibility="invisible" />
    <Button
        android:id="@android:id/button2"
        style="?attr/buttonBarNegativeButtonStyle"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />
    <Button
        android:id="@android:id/button1"
        style="?attr/buttonBarPositiveButtonStyle"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />
</android.support.v7.widget.ButtonBarLayout>
```

**※ `<android.support.v4.widget.Space android:id="@+id/spacer"/>` 는 필수입니다. 삭제하면 오류가 발생합니다.**

appcompat 라이브러리에서 사용되는 자원을 쫓는 것으로, 어디에서 어떻게 style이나 속성이 사용되고 있는지 확인할 수 있기 때문에, 대상 사용자에 따라 사용하기 쉬운 디자인으로 해킹해보고 싶다고 생각합니다.

## 참고

- [Tips and Tricks for Android Material Support Library 2: Electric Boogaloo – Code @ Hootsuite](http://code.hootsuite.com/tips-and-tricks-for-android-material-support-library-2-electric-boogaloo/)
- [Y.A.M의 낙서장: AppCompat에서 색상 Raised Button을 설정하는 올바른 방법](http://y-anz-m.blogspot.jp/2015/09/appcompat-raised-button.html)
- [AppCompatButton의 스타일을 Material로 하기 - Qiita](http://qiita.com/MeilCli/items/614a1afba9105a791f5c)