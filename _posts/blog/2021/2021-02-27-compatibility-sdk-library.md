---
layout: post
title: "Android 호환성 유지에 대한 고찰 ~ SDK/라이브러리"
date: 2021-02-27 12:00:00 +09:00
tag: [Android, Java, Kotlin]
categories:
- blog
- Android
---

우리들은 Android Platform SDK와 AndroidX 라이브러리를 사용하여 앱을 만듭니다. 그러나 구글에서 제공하는 것만으로 작성하기엔 우리의 시간은 짧습니다. 그래서 특정 라이브러리를 사용해서 혜택을 얻습니다. 대표적인 사례로는 네트워크 통신 라이브러리(OkHttp/Retrofit)를 사용함으로써 개발 속도를 올린다거나 스스로 구현했으면 놓칠 수 있는 부분까지의 안정성을 보장받습니다.

<!--more-->

- 이전글 : [Android 호환성 유지에 대한 고찰 ~ 언어편](http://pluu.github.io/blog/android/2021/01/27/compatibility-language/)

------

본 글에서는 SDK와 라이브러리 측면에서 어떻게 호환성 유지를 고려하는지 살펴보겠습니다.

## 기본 지식

먼저 기본적으로 체크해야 할 호환성으로는 소프트웨어와 하드웨어 이렇게 2가지로 나뉩니다.

### 소프트웨어

소프트웨어에서의 중요한 포인트는 `현재 실행 중인 OS 버전`에 따른 동작 차이를 구분하는 것입니다. 여기서 현재 실행 중인 OS 버전을 가져오는 API가 `Build.VERSION.SDK_INT`입니다. 

> https://developer.android.com/reference/android/os/Build.VERSION#SDK_INT

```kotlin
fun something() {
  if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.M) {
    // do action
  }
}
```

처음 안드로이드 개발을 접한 사람에게는 왜 위와 같은 버전 분기 처리가 필요한지 의문을 가질 수 있습니다. 대표적인 이유는 아래와 같습니다.

- 신규 API 추가 및 기존 API Deperecated (ex : getColor, getDrawable)
- OS 동작의 변경 대응 (ex : runtime-permissions)
- 특정 버전 버그 대응

이처럼 버전 분기 처리는 안드로이드 버전마다 다양한 개선점으로도 사용되지만, 보안/개인 정보 보호 등의 이슈로 불가피하게 사용하게 됩니다. 개발자가 작성한 코드는 다양한 안드로이드 버전에 설치된다는 것을 잊어서는 안됩니다. 즉, 설치 가능한 버전에 대한 호환성 대응 역시 우리가 해야 할 일입니다. 

구체적으로 프로젝트에서 사용한 minSdkVersion, targetSdkVersion 속성은 해당하는 최소 지원 버전과 원활한 동작을 지원 버전에 대한 동작 대응을 요구한다는 의미를 가집니다. min 21과 target 29을 지정하면, Android 5.0 (API 21)부터 Android 10 (API 30)까지 OS 본연의 100% 동작을 지원한다는 의미입니다.

| 플랫폼 버전       | API 레벨 | 설치 가능 | 호환성 동작 |
| ----------------- | -------- | --------- | ----------- |
| Android 11        | 30       | O         | ▵           |
| Android 10        | 29       | O         | O           |
| Pie (9.0)         | 28       | O         | O           |
| Oreo (8.x)        | 26, 27   | O         | O           |
| Nougat (7.x)      | 24, 25   | O         | O           |
| Marshmallow (6.0) | 23       | O         | O           |
| Lollipop (5.x)    | 21, 22   | O         | O           |
| Kitkat (4.4.x)    | 19       | X         | X           |

### 하드웨어

하드웨어 호환성은 필수 장치의 경우, Android Manifest에 `uses-feature`를 사용해 설치 가능한 디바이스에서만 설치되도록 하는 방법이 있습니다.

> \<uses-feature\> : https://developer.android.com/guide/topics/manifest/uses-feature-element
>
> 카메라 앱에서는 \<uses-feature android:name="android.hardware.camera" /> 를 선언하여 필수 요구 사항 대응 처리를 합니다.

다만, 일부 센서들의 경우 있으면 사용자에게 더 편리한 기능을 제공할 수 있지만, 그렇다고 없다고 앱 사용에 문제 되지 않는 경우도 많습니다. 그 예로 자이로스코프와 근접 센서가 있습니다. 구글 지도의 경우 자이로스코프가 없는 경우, 나침반 기능을 사용할 수 없습니다. 그리고 나침반 아이콘도 미노출됩니다. 그러나 이 센서가 없더라도 앱 사용에는 문제가 없습니다.

```kotlin
val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)?.let {
  // Sensor found
} ?: {
  // Sensor not found
}
```

> 센서 : https://developer.android.com/guide/topics/sensors

각 센서의 존재를 체크하고 대응하는 것은 편리성을 제공하는 긍정적인 효과도 있습니다. 간헐적으로 물리적으로 없지만 소프트웨어적으로 존재하는 것으로 인식해서 설치되는 경우에 대한 대처 방법으로도 사용될 수 있습니다.

## SDK/라이브러리

### 최소한의 호환성 선정이 첫걸음

앱 개발 시에 최소 버전의 이슈가 있는 것처럼 SDK/라이브러리도 최소 버전이 존재합니다. 앱과의 차이점은 영향을 받는 대상자입니다.

- 앱 : 일반 사용자
- SDK/라이브러리 : 개발자, 기타 사용자

앱/SDK/라이브러리 모두 호환성이 넓을수록 좋지만, 그만큼 챙겨야 할 이슈가 다양해지므로 대응에 어렵습니다. 그만큼 `버전`은 선택과 집중이 필요한 사항입니다. 최근 Http 통신 라이브러리로 유명한 OkHttp와 Rertrofit에서도 최소 요구 사항을 Java 8과 안드로이드 5.0 이상으로 변경한 적이 있습니다. 

이어서 안드로이드 SDK/라이브러리 내부에서 어떻게 호환성 대응을 하는지 살펴보겠습니다.

### Compat에서의 호환성 패턴

#### 사례 (1) ContextCompat

Context를 사용하는 경우의 호환성을 도와주는 클래스가 바로 ContextCompat입니다. 이외에도 `~~~Compat`의 코드를 살펴보면 다양하게 형태를 볼 수 있습니다

Context를 사용하는 케이스 중 하나는 색상을 가져오는 API가 있습니다. Color Resource ID를 사용해서 색상을 가져오는 API는 API Level 23 (Marshmallow)부터 변경되었습니다. `ContextCompat#getColor`에서는 앞서 소개한 Build.VERSION.SDK_INT를 사용해서 API 호출마다 체크하는 형태로 구현되어 있습니다.

- Context#getColor(int) : Added in API level 23
  - https://developer.android.com/reference/android/content/Context.html?hl=en#getColor(int)
- Resources#getColor(int) : Added in API level 1 / Deprecated in API level 23
  - https://developer.android.com/reference/android/content/res/Resources#getColor(int)

```java
public class ContextCompat {
  @SuppressWarnings("deprecation")
  @ColorInt
  public static int getColor(@NonNull Context context, @ColorRes int id) {
    if (Build.VERSION.SDK_INT >= 23) {
      return context.getColor(id);
    } else {
      return context.getResources().getColor(id);
    }
  }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:core/core/src/main/java/androidx/core/content/ContextCompat.java;l=515?q=ContextCompat

#### 사례 (2) WindowInsetsCompat

WindowInsets은 API level 30 (Android 11)부터 추가된 기능입니다. 요구되는 API Level이 높기 때문에 실제 사용 시에는 버전에 따른 분기가 필요합니다. 이때 내부적으로 호환성을 대신해주는 클래스가 바로 WindowInsetsCompat입니다. 그리고 내부에는 2가지의 패턴으로 호환성을 유지하고 있습니다. 

1. WindowInsetsCompat class가 JVM에 로드되는 시점에 버전마다 다른 CONSUMED 객체 설정
2. WindowInsetsCompat 생성자에서 실제 구현체를 실행하는 버전마다 다른 클래스를 인스턴스화

```java
public class WindowInsetsCompat {
  @NonNull
  public static final WindowInsetsCompat CONSUMED;

  static {
    if (SDK_INT >= 30) {
      CONSUMED = Impl30.CONSUMED;
    } else {
      CONSUMED = Impl.CONSUMED;
    }
  }

  private final Impl mImpl;

  public WindowInsetsCompat(@Nullable final WindowInsetsCompat src) {
    if (src != null) {
      // We'll copy over from the 'src' instance's impl
      final Impl srcImpl = src.mImpl;
      if (SDK_INT >= 30 && srcImpl instanceof Impl30) {
        mImpl = new Impl30(this, (Impl30) srcImpl);
      } else if (SDK_INT >= 29 && srcImpl instanceof Impl29) {
        mImpl = new Impl29(this, (Impl29) srcImpl);
      } else if (SDK_INT >= 28 && srcImpl instanceof Impl28) {
        mImpl = new Impl28(this, (Impl28) srcImpl);
      } else if (SDK_INT >= 21 && srcImpl instanceof Impl21) {
        mImpl = new Impl21(this, (Impl21) srcImpl);
      } else if (SDK_INT >= 20 && srcImpl instanceof Impl20) {
        mImpl = new Impl20(this, (Impl20) srcImpl);
      } else {
        mImpl = new Impl(this);
      }
      srcImpl.copyWindowDataInto(this);
    } else {
      // Ideally src would be @NonNull, oh well.
      mImpl = new Impl(this);
    }
  }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:core/core/src/main/java/androidx/core/view/WindowInsetsCompat.java

### Theme에서의 호환성 패턴 ~ AppCompat / Material Design Component

안드로이드 개발에서 스타일 적용하는 방법 중 하나로 `Theme`가 있습니다. 이 방법은 해당 컴포넌트 및 하위 컴포넌트 전체에 일관된 스타일 적용하고 싶을 때 사용합니다.

> Style과 Theme 적용에 대해서 다음 글을 살펴보셔도 좋습니다
>
> Android Global View Style에 대한 정리 https://pluu.github.io/blog/android/2020/08/02/global-style/

#### 사례 (1) MDC Theme

많은 안드로이드 개발자가 사용하는 Theme로는 `AppCompat`과 `Material Design Component`(이하 MDC)가 있습니다. 그리고 MDC는 AppComapt을 상속해서 재정의하는 형태로 구현되어 있습니다. 약간의 작업은 필요하지만, AppCompat에서 MDC Theme로 전환도 가능합니다.

아래 표는 각 Theme에서 대응이 필요한 Color 속성 중 일부입니다.

| AppCompat                                                 | Material Design Component                                    |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| - colorPrimary<br />- colorPrimaryDark<br />- colorAccent | - colorPrimaryVariant<br />- colorSecondary<br />- colorSecondaryVariant<br />- colorSurface<br />- colorPrimarySurface<br />- colorOnPrimary<br />- colorOnSecondary<br />- colorOnBackground<br />- colorOnError<br />- colorOnSurface<br />- colorOnPrimarySurface |

MDC를 사용하고 싶지만 대응에 시간이 부족한 경우에 MDC에서는 호환성을 보장하는 `MDC Bridge` Theme를 사용하는 것도 방법입니다. Theme.MaterialComponents.*.Bridge 내부적으로 추가 구현해야 하는 부분을 대신해줍니다.

- Theme.MaterialComponents.Bridge
- Theme.MaterialComponents.Light.Bridge
- Theme.MaterialComponents.Light.DarkActionBar.Bridge
- etc

```xml
<resources>  
  <style name="Platform.MaterialComponents" parent="Theme.AppCompat"/>
  
  <style name="Base.V14.Theme.MaterialComponents.Bridge" parent="Platform.MaterialComponents">
    <item name="colorPrimaryVariant">@color/design_dark_default_color_primary_variant</item>
    <item name="colorSecondary">@color/design_dark_default_color_secondary</item>
    <item name="colorSecondaryVariant">@color/design_dark_default_color_secondary_variant</item>
    <item name="colorSurface">@color/design_dark_default_color_surface</item>
    <item name="colorPrimarySurface">?attr/colorSurface</item>
    <item name="colorOnPrimary">@color/design_dark_default_color_on_primary</item>
    <item name="colorOnSecondary">@color/design_dark_default_color_on_secondary</item>
    <item name="colorOnBackground">@color/design_dark_default_color_on_background</item>
    <item name="colorOnError">@color/design_dark_default_color_on_error</item>
    <item name="colorOnSurface">@color/design_dark_default_color_on_surface</item>
    <item name="colorOnPrimarySurface">?attr/colorOnSurface</item>
    ...
  </style>
  
  <style name="Base.Theme.MaterialComponents.Bridge" parent="Base.V14.Theme.MaterialComponents.Bridge"/>
  
  <style name="Theme.MaterialComponents.Bridge" parent="Base.Theme.MaterialComponents.Bridge"/>
</resources>
```

> 출처 : https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/theme/res/values/themes_base_bridge.xml

그러니 MDC를 쓰고 싶은데 AppCompat에서 선뜻 넘어가기가 두려운 분은 `Bridge` 적용으로 해결 가능합니다.

#### 사례 (2) ViewInflater

개발 시 작성하는 View는 Theme에 따라서 실제 구현체가 달라진다는 것을 알고 있나요? 아래의 표는 Platform/AppCompat/MDC Theme 사용시 실제 구현되는 View입니다.

|       Platform       |           AppCompat           |  Material Design Component   |
| :------------------: | :---------------------------: | :--------------------------: |
|       TextView       |       AppCompatTextView       |       MaterialTextView       |
|        Button        |        AppCompatButton        |        MaterialButton        |
|       CheckBox       |       AppCompatCheckBox       |       MaterialCheckBox       |
|     RadioButton      |     AppCompatRadioButton      |     MaterialRadioButton      |
| AutoCompleteTextView | AppCompatAutoCompleteTextView | MaterialAutoCompleteTextView |

XML에서 첫 번째 열의 View를 사용하더라도 Theme마다 다르게 적용됩니다. 그래서 Platform의 View에는 존재하지 않는 속성을 사용하더라도 오류가 발생하지 않습니다. 이 처리는 Android Studio의 Design Preview와 실제 단말에서도 동일하게 적용됩니다.

이어서 해당 처리가 어떻게 이루어지는지 살펴보겠습니다.

**AppCompatViewInflater**

AppCompatViewInflater는 이름대로 AppCompat에서 레이아웃 파일에 정의된 주요 View를 AppCompat View로 대체하는 작업을 담당합니다. 그리고 내부에는 View 생성을 위한 create 함수들이 정의되어 있습니다.

> https://developer.android.com/reference/androidx/appcompat/app/AppCompatViewInflater

```java
public class AppCompatViewInflater {
  @NonNull
  protected AppCompatTextView createTextView(Context context, AttributeSet attrs) {
    return new AppCompatTextView(context, attrs);
  }
  ...
  @NonNull
  protected AppCompatButton createButton(Context context, AttributeSet attrs) {
    return new AppCompatButton(context, attrs);
  }
  ...
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/app/AppCompatViewInflater.java

**MaterialComponentsViewInflater**

MDC Theme에서는 MDC 스타일 View를 만들기 위한 `MaterialComponentsViewInflater` 클래스를 제공합니다. 그리고 AppCompatViewInflater를 상속해서 재정의하고 있습니다.

```java
public class MaterialComponentsViewInflater extends AppCompatViewInflater {
  @NonNull
  @Override
  protected AppCompatButton createButton(@NonNull Context context, @NonNull AttributeSet attrs) {
    return new MaterialButton(context, attrs);
  }
  ...
  @NonNull
  @Override
  protected AppCompatTextView createTextView(Context context, AttributeSet attrs) {
    return new MaterialTextView(context, attrs);
  }
  ...
}
```

> 출처 : https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/theme/MaterialComponentsViewInflater.java

**AppCompatDelegateImpl**

AppCompatDelegateImpl는 앞서 언급한 View를 생성하는 ViewInflater가 사용되는 클래스입니다. `AppCompatDelegateImpl#createView` 함수에서 ViewInflater가 사용됩니다. 

```java
class AppCompatDelegateImpl extends AppCompatDelegate
        implements MenuBuilder.Callback, LayoutInflater.Factory2 {
  @Override
  public View createView(View parent, final String name, @NonNull Context context,
      @NonNull AttributeSet attrs) {
    if (mAppCompatViewInflater == null) {
      TypedArray a = mContext.obtainStyledAttributes(R.styleable.AppCompatTheme);
      
      // ViewInflater를 사용할 Class명을 취득
      String viewInflaterClassName =
          a.getString(R.styleable.AppCompatTheme_viewInflaterClass);
      
      // Theme에서 정의된 ViewInflater가 있다면 해당 View Inflater가 사용되며
      // 미정의한 경우 기본으로 AppCompatViewInflater를 사용
      if (viewInflaterClassName == null) {
        mAppCompatViewInflater = new AppCompatViewInflater();
      } else {
        try {
          Class<?> viewInflaterClass = Class.forName(viewInflaterClassName);
          mAppCompatViewInflater = 
              (AppCompatViewInflater) viewInflaterClass.getDeclaredConstructor()
                    .newInstance();
        } catch (Throwable t) {
          Log.i(TAG, "Failed to instantiate custom view inflater "
                + viewInflaterClassName + ". Falling back to default.", t);
          mAppCompatViewInflater = new AppCompatViewInflater();
        }
      }
    }    
    ...    
    return mAppCompatViewInflater.createView(parent, name, context, attrs, inheritContext,
            IS_PRE_LOLLIPOP, /* Only read android:theme pre-L (L+ handles this anyway) */
            true, /* Read read app:theme as a fallback at all times for legacy reasons */
            VectorEnabledTintResources.shouldBeUsed() /* Only tint wrap the context if enabled */
    );
  }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/app/AppCompatDelegateImpl.java

그리고, MaterialComponentsViewInflater는 MDC Theme의 `viewInflaterClass` 속성에 정의되어 있습니다. 해당 속성은 AppCompatDelegateImpl#createView 함수에서 사용됩니다.

```xml
<resources>
  <style name="Base.V14.Theme.MaterialComponents" parent="Base.V14.Theme.MaterialComponents.Bridge">
    <item name="viewInflaterClass">com.google.android.material.theme.MaterialComponentsViewInflater</item>
    ...
  </style>
  <style name="Base.V14.Theme.MaterialComponents.Light" parent="Base.V14.Theme.MaterialComponents.Light.Bridge">
    <item name="viewInflaterClass">com.google.android.material.theme.MaterialComponentsViewInflater</item>
    ...
  </style>
</resources>

<resources>
  <style name="Base.V14.Theme.MaterialComponents.Dialog" parent="Base.V14.Theme.MaterialComponents.Dialog.Bridge">
    <item name="viewInflaterClass">com.google.android.material.theme.MaterialComponentsViewInflater</item>
    ...
  </style>
  <style name="Base.V14.Theme.MaterialComponents.Light.Dialog" parent="Base.V14.Theme.MaterialComponents.Light.Dialog.Bridge">
    <item name="viewInflaterClass">com.google.android.material.theme.MaterialComponentsViewInflater</item>
      ...
  </style>
</resources>
```

> 출처 : https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/theme/res/values/themes_base.xml
>
> 출처 : https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/dialog/res/values/themes_base.xml

------

지금까지 체크한 정보를 토대로 정리하면,

AppCompat / MDC 이외의 독립적인 Theme와 View 세트를 만들고 `ViewInflater`를 제공하면 XML에 매번 CustomView를 선언하지 않아도 됩니다.

------

## 해결하기 어려운 호환성

안드로이드는 하드웨어와 소프트웨어적으로 몇 가지의 파편화가 있습니다. 이 사실을 기반으로 다양한 단말에서 동작하도록 하는 것이 개발자가 고민해야 하는 영역입니다. 그러나 모든 것을 다 품을 수 없다는 것 또한 현실입니다. 하드웨어 유무, 안드로이드 버전에 따른 조건이 대부분이지만 특수한 사례도 있습니다. 

### 제조사 혹은 런처에서 제공하는 기능

국가에 따라서는 특정 제조사의 사용자 비율이 높아서 레퍼런스 폰처럼 여기는 경우가 많습니다. 한국의 경우에는 삼성 갤럭시 폰이 국내의 레퍼런스 폰으로 취급하는 경우를 보셨을 겁니다. 

안드로이드 개발을 하다 보면 마주치는 케이스 중 하나로 공식적인 API가 없는 케이스입니다. 대표적인 사례가 바로 뱃지에 카운트를 붙이는 기능입니다. 픽셀 및 안드로이드 원 이외의 폰을 사용하신다면 앱 아이콘에 `빨간색 뱃지와 숫자 카운트`가 노출되는 것을 자주 보셨을 겁니다. 뱃지에 대한 개발 경험이 없는 경우, 이 기능이 공식적으로 제공하는 기능으로 생각하는 사람도 있지만 특정 제조사나 런처에서 제공하는 기능의 일부입니다. 그래서 복잡한 케이스를 모두 커버하기보다는 아래의 라이브러리를 사용하는 것도 좋은 선택입니다.

> leolin310148 / ShortcutBadger : https://github.com/leolin310148/ShortcutBadger

## 마무리하며

이전 [언어편](http://pluu.github.io/blog/android/2021/01/27/compatibility-language/)에 이어서 안드로이드 개발자들이 챙겨야 할 SDK/라이브러리편의 호환성 구현 방법을 살펴봤습니다. 

안드로이드 생태계는 다양한 버전과 제조사가 존재하는 사실이 `양날의 칼날`일 수 있습니다. 팀과 본인의 능력 여하에 따라서 챙길 수 있는 부분도 많지만, 시간 대비 결과가 미미할 수도 있습니다. 그렇지만, 이미 많은 케이스가 먼저 경험한 사람들에 의해서 StackOverflow나 라이브러리 등으로 공유되었거나 해결한 사항일 수도 있으니 걱정하지 않으셔도 됩니다.

호환성에 대한 주제는 여기까지입니다.

## 참고 사이트

- <uses-sdk> - 개발 고려 사항 : https://developer.android.com/guide/topics/manifest/uses-sdk-element#considerations
- <uses-feature> : https://developer.android.com/guide/topics/manifest/uses-feature-element
- Android Global View Style에 대한 정리 : https://pluu.github.io/blog/android/2020/08/02/global-style/
- material-components / material-components-android : https://github.com/material-components/material-components-android
