---
layout: post
title: "[번역] VectorDrawable 대응 정리"
date: 2016-04-11 16:30:00 +09:00
tag: [Android, MVC, MVP]
categories:
- blog
- Android
---

본 포스팅은 [VectorDrawable対応まとめ](http://qiita.com/konifar/items/bf581b8f23dea7b30f85) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

DroidKaigi 공식 어플 아이콘을 VectorDrawable로 하여 각 해상도의 png 파일을 대부분 제거 가능했으므로, 대응한 내용을 정리해보려고 합니다

[Suppoort vector drawable #345](https://github.com/konifar/droidkaigi2016/pull/345)

## 사전 준비

### Gradle 설정

gradle의 build tool 버전을 v2.0으로 올립니다.

build.gradle

```
buildscript {
    ...
    dependencies {
        ...
        classpath 'com.android.tools.build:gradle:2.0.0-beta6'
        ...
    }
}
```

build.gradle의 defaultConfig에 아래를 추가합니다.

build.gradle

```
android {
  ...
  defaultConfig {
    ...
    vectorDrawables.useSupportLibrary = true
    ...
  }
}
```

혹시 build tool v1.5.0 하위 버전을 사용해야 하는 경우는 아래와 같이 기술합니다.

```
android {
  defaultConfig {
    // Stops the Gradle plugin’s automatic rasterization of vectors
    generatedDensities = []
  }
  // Flag to tell aapt to keep the attribute ids around
  aaptOptions {
    additionalParameters "--no-version-vectors"
  }
}
```

### 2. Support Library 업데이트

appCompat 버전을 23.2.0으로 올립니다.

`support-vector-drawable`는 명식적으로 추가하지 않아도 괜찮습니다.

build.gradle

```
dependencies {
    ...
    compile "com.android.support:appcompat-v7:23.2.0"
    compile "com.android.support:support-vector-drawable:23.2.0"
    compile "com.android.support:animated-vector-drawable:23.2.0"
    ...
}
```

자세한 것은 아래 기사가 자세하므로 참고해주세요.

[AppCompat v23.2 — Age of the vectors](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88)

## VectorDrawable 작성

[Vector Asset Studio](http://developer.android.com/intl/ja/tools/help/vector-asset-studio.html) 등을 사용해서 기존 아이콘과 같은 VectorDrawable를 만듭니다. 자세한 것은 아래를 참고해주세요.

[기존 아이콘으로 VectorDrawable를 만들기](http://qiita.com/konifar/items/a82fb45746ca6380299c)

## 대응 항목

ImageView의 `anodroid:src`이나 TextView의 `anodroid:drawableLeft`, Notification의 icon 등, 각각 어떻게 대응했는지 정리합니다.

### 1. ImageView의 android:src

xml 안의 `android:src`를 `app:srcCompat`으로 변경할 뿐입니다.

```
<ImageView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    app:srcCompat="@drawable/ic_search"/>
```

코드에서 지정하는 경우는, `setImageResource`를 사용하면 OK 입니다

```
imageView.setImageResource(R.drawable.ic_search);
```

### 2. TextView의 android:drawableLeft

TextView의 경우는, 직접 VectorDrawable를 지정하면 죽습니다.

그래서, StateListDrawable를 작성해서 그 내부에 VectorDrawable를 지정할 필요가 있습니다.

```
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/ic_access_time_grey_500_12dp_vector" />
</selector>
```
```
<TextView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:drawableLeft="@drawable/ic_access_time_grey_500_12dp_vector_state"
    android:drawablePadding="@dimen/icon_spacing_small"
    android:drawableStart="@drawable/ic_access_time_grey_500_12dp_vector_state"
```

### 3. ContextCompat.getDrawable()

아무것도 하지 않아도 OK입니다. AppCompat 23.2.0부터는 내부의 아이콘도 VectorDrawable을 사용하고 있고, 기본적으로 ~Compat Class를 사용하면 별도의 대응은 필요 없을 것입니다.

### 4. android.support.design.widget.NavigationView

menu 안의 `android:icon`에 VectorDrawable를 지정하면 그대로 움직입니다.

drawer_menu.xml

```
<menu xmlns:android="http://schemas.android.com/apk/res/android">

    <group android:checkableBehavior="single">
        <item
            android:id="@+id/nav_all_sessions"
            android:icon="@drawable/ic_event_note_grey_600_24dp_vector"
            android:title="@string/all_sessions" />
        ...
    </group>

</menu>
```

### 5. Toolbar 메뉴 아이콘

AppCompatActivity를 사용하면, VectorDrawable을 지정하는 것만으로 OK입니다.

menu_sessions.xml

```
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">

    <item
        android:id="@+id/item_search"
        android:icon="@drawable/ic_search_white_24dp_vector"
        android:orderInCategory="100"
        android:title="@string/search"
        app:showAsAction="always" />

</menu>
```

### 6. Notification 아이콘

**Lollipop 미만은 아직 미대응입니다**

Lollipop 이상은 drawable-v21 폴더에 넣은 VectorDrawable를 지정하는 것만으로 OK입니다.

```
Notification notification = new NotificationCompat.Builder(context)
    .setContentIntent(pendingIntent)
    .setSmallIcon(R.drawable.ic_stat_notification_vector)
    ...
```

### 7. GoogleMap Maker

`BitmapDescriptorFactory.fromResource()`를 사용하면 죽습니다.

한번 Bitmap으로 변환해서, `fromBitmap()`을 사용해 대응했습니다.

[VectorDrawable을 Bitmap으로 변환하기](http://qiita.com/konifar/items/aaff934edbf44e39b04a)

### 8. Drawable를 지정하는 UI 라이브러리

내부에서 BitmapDrawable로 변환하면 죽습니다.

혹시 대응하지 않는 경우는, 라이브러리에 PullRequest를 보내서 대응합시다.

DroidKaigi 어플의 경우, LikeButton이 대응되어있지 않기 때문에 PullRequest를 보냈습니다.

[https://github.com/jd-alexander/LikeButton/pull/17](https://github.com/jd-alexander/LikeButton/pull/17)

## VectorDrawable 속성 설명

주요 속성을 정리해둡니다. 자세한것은 [공식 VectorDrawable 레퍼런스](http://developer.android.com/intl/ja/reference/android/graphics/drawable/VectorDrawable.html)를 봐주세요.

| Tag | 속성 | 설명 |
| - | - | - |
| vector | android:width | 표시하는 넓이. dp로 지정합니다. |
| vector | android:height | 표시하는 높이. dp로 지정합니다. |
| vector | android:viewportWidth | 작성한 Vector의 넓이 px. dp로 지정합니다. |
| vector | android:viewportHeight | 작성한 Vector의 높이 px. dp로 지정합니다. |
| vector | android:autoMirrored | RTL로 반전시키는 아이콘의 경우, true를 지정합니다. |
| path | android:fillColor | path 색. 투명을 지정해도 무시됩니다. |
| path | android:fillAlpha | path 투명도. 0.0 (투명) ~ 1.0을 지정합니다 |
| path | android:pathData	 | 이미지 Path |

## 대응 시에 신경 쓰이는 부분

아래 대응 시의 복잡한 마음입니다.

### 어느 정도 apk 사이즈가 줄어드는가?

DroidKaigi 어플의 경우, 29개 아이콘을 VectorDrawable로 변경한 것으로 200KB 정도 줄었습니다.

[Suppoort vector drawable #345](https://github.com/konifar/droidkaigi2016/pull/345)

[AppCompat v23.2 — Age of the vectors](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.fzcft7z1w)에 의하면, AppCompat 자체도 70KB 줄였다고 합니다

> Allows AppCompat to use vector drawables itself. This itself has shaved off around 70KB from AppCompat’s AAR (~9%).

대응은 귀찮은 부분도 있습니다만, 아이콘 개수만 효과 있는 느낌입니다.

### 어떤 구조인가?

실제로 VectorDrawable을 어떻게 해석하는지는 모르겠습니다만, VectorDrawableCompat이 적용될 때까지의 흐름은 아래에 자세하게 정리되어 있습니다.

[Support Library의 VectorDrawableCompat이 적응될 때까지의 구조](http://qiita.com/takahirom/items/c6f5a3204210d1e95c70)

### 이제부터는 VectorDrawable를 대응해야 하는가?

Vector로 해야 하지 않을까요.

최근 Google의 OSS [plaid](https://github.com/nickbutcher/plaid)도 전부 VectorDrawable로 만들고 있네요.

색의 변경도 편하고, 채용하지 않는 이유는 특별히 없어 보입니다. AndroidStudio의 Preview가 아직 제대로 표시되지 않는 부분이 있습니다만, 가까운 시일 내에 대응해줄 것입니다.

### 명명이나 파일 위치는 어떻게 해야 하는가?

[plaid](https://github.com/nickbutcher/plaid)를 흉내내서, drawable 내부에 두도록 했습니다.

파일명은 아이콘의 경우는 `ic_xxxx_vector.xml`과 같이 접미사로 `_vector`를 붙이도록 했습니다. vector이외의 아이콘도 혼재하고 있으므로, 언뜻 봐서 VectorDrawable인지 알도록 하고 싶었기 때문입니다.

TextView의 drawableLeft 등으로 사용하는데 StateListDrawable를 만들 필요가 있는 경우는, `ic_xxxx_vector_state.xml` 같이 했습니다. 여기는 어떻게 해야 할지 아직 정하지 않았습니다.

### 실행 시의 오버헤드는?

내부를 안 봐서 체감이지만, 특별히 느끼지 못했습니다.

### 빌드시간에 영향은 없는가?

내부를 안 봐서 체감이지만, 특별히 느끼지 못했습니다.

## 참고자료

### [1. AppCompat v23.2 — Age of the vectors](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88)

기본적인 VectorDrawable 도입방법이 정리되어 있습니다.

### [2. Support Library의 VectorDrawableCompat이 적응될 때까지의 구조](http://qiita.com/takahirom/items/c6f5a3204210d1e95c70)

내부에서 어떻게 VectorDrawableCompat이 적용되는지 자세하게 설명되어 있습니다.

### [3. VectorDrawable 레퍼런스](https://developer.android.com/intl/ja/reference/android/graphics/drawable/VectorDrawable.html)

VectorDrawable의 속성이나 메소드가 전체 정리되어 있습니다.

### [4. Vector Asset Studio](http://developer.android.com/intl/ja/tools/help/vector-asset-studio.html)

svg 파일로부터 VectorDrawable를 작성하는 AndroidStudio 도구의 설명입니다.

### [5. plaid](https://github.com/nickbutcher/plaid)

Google의 내부의 사람이 만들고 있는 OSS입니다. 아이콘은 전부 VectorDrawable로 만들어져 있습니다.
