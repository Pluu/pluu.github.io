---
layout: post
title: "[번역] DroidKaigi 2017 ~ How to implement material design animation"
date: 2017-11-12 16:20:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ How to implement material design animation](https://speakerdeck.com/takahirom/how-to-implement-material-design-animation) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p

How to implement material design animation

takahirom

## 2p, 자기소개

- Yahoo! JAPAN Android 엔지니어
- 본명은 毛受崇洋 (めんじゅたかひろ)
- Android가 좋다

- takahirom(@new_runnable)
- Qiita도 쓰고 있으니 잘 부탁드립니다.

## 3p

"one of the main components of what makes material, material."

- Motion Lead @Google. John Schlemmer

## 4p, 목차

- Motion의 중요성
- Motion의 원칙
- 가이드라인과 구현
- Android 5.0 미만의 단말에서 어떻게 구현할까
- 정리

## 5p

왜 애니메이션 시키는가?

## 6p ~ 7p, Motion의 중요성

- View 간의 초점 가이드
- 사용자가 조작을 완료하면 무엇이 일어나는지 힌트를 보여준다
- 요소 간의 계층적, 공간적인 관계
- Background에서 일어나고 있는 처리 (컨텐츠 취득, 다음 뷰 로딩 등) 로부터 주목을 딴 데로 돌린다
- 캐릭터, 세련, 즐거움

> Material Design Guidelines으로부터

생각할 것을 줄이고 알기쉽게

## 8p

어떻게 Material Design으로 애니메이션 시킬까? 

## 9p ~ 12p, Motion의 원칙

- Responsive → 즉시 반응해서 속도가 빠르다
- Natural → 자연스러운 움직임
- Aware → 다른 Material과 강조 동작
- Intentional → 의도가 있다

> Material Design Guidelines으로부터

> DroidKaigi 2017 official Android app으로부터

## 13p

어떻게 구현할까?

## 14p ~ 16p, 샘플 앱 만들었습니다

material-element

[http://git.io/element](http://git.io/element)

Material Design Guidelines을 기준으로 작성

## 17p

하나씩 가이드라인부터 따라가보자!

## 18p, Material Design Guidelines

- Material Design
- Motion
- Style
- Layout
- Components
- Patterns
- Growth & communications
- Usability
- Resources

> 9개의 장으로 구성되어있다

## 19p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 20p, Guidelines 내의 설명하는 부분

- Material Design
   - `Elevation & shadows`
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 21p, Elevation & shadows

그림자에 주목

TAP시에 떠올라 보인다

> DroidKaigi 2017 official Android app으로부터

## 22p, Elevation & shadows

### Responsive elevation and dynamic elevation offsets Guidelines

|   | Resting state | Pressed state |
| :--: | :--: | :--: |
| Floating Action Button | 6dp | 12dp |
| Button | 2dp | 8dp |
| Card | 2dp | 8dp |

TAP시에 View를 6dp 올라간다

`6dp = dynamic elevation offsets`

## 23p, Responsive elevation and dynamic elevation offsets 구현

Layout XML 내부

```
<ImageView
   android:id="@+id/shot"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:elevation="@dimen/z_card"
   android:stateListAnimator="@animator/raise"
   android:foreground="@drawable/mid_grey_ripple"
   app:badgeGravity="end|bottom"
   app:badgePadding="@dimen/padding_normal" />
```

`stateListAnimator를 쓰자`

API Level 21 (Android 5.0)

(stateListAnimator는 API Level 21 미만에서 무시된다)

## 24p, Responsive elevation and dynamic elevation offsets 구현

animator_raise.xml

```
<selector xmlns:android="http://schemas.android.com/apk/res/android">
   <item
      android:state_enabled="true"
      android:state_pressed="true">
      <objectAnimator
         android:duration="@android:integer/config_shortAnimTime"
         android:propertyName="translationZ"
         android:valueTo="@dimen/touch_raise" />
   </item>
   <item>
      <objectAnimator
         android:duration="@android:integer/config_shortAnimTime"
         android:propertyName="translationZ"
         android:valueTo="0dp" />
   </item>
</selector>
```

## 25p, Responsive elevation and dynamic elevation offsets 구현

animator_raise.xml

```
<selector xmlns:android="http://schemas.android.com/apk/res/android">
   <item
      android:state_enabled="true"
      android:state_pressed="true">
```

누르고 있을 때의 애니메이션을 지정한다

## 26p ~ 27p, Responsive elevation and dynamic elevation offsets 구현

animator_raise.xml

```
      <objectAnimator
         android:duration="@android:integer/config_shortAnimTime"
         android:propertyName="translationZ"
         android:valueTo="@dimen/touch_raise" />
```

translationZ 을 6dp로 지정한다

2dp (기존의 Elevation) + 6dp (dynamic elevation offsets) = 8dp 가 된다

## 28p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - `Duration & easing`
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 29p, Duration

Dynamic durations

거리가 길수록 애니메이션 시간이 길다

## 30p ~ 34p, Duration

- 400ms를 넘지 않도록 한다
- 175ms부터 375ms 사이에 움직일 거리에 따라 조절
- 태블릿 등의 단말에 따라 바꾸는 편이 좋다 (큰 단말일수록 길게)
- setDuration()을 이용한다

## 35p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - `Duration & easing`
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 36p, easing

EasingCurves는 애니메이션의 속도나 투명도, 크기 등에 적응된다

## 37p, Motion / easing Guidelines

|   | 어디에서 사용할까 |
| :--: | :--: |
| 표준 커브 Standard curve | 화면 내의 운동 |
| 가속 커브 Deceleration curve | 화면 내에 들어오는 운동 |
| 가속 커브 Acceleration curve | 화면에서 나갈 때 운동 |
| 급커브 Sharp curve | 언제라도 화면에 넣는 객체의 운동 |

## 38p, Motion / easing Guidelines

|   | 어떻게 구현할까 |
| :--: | :--: |
| 표준 커브 Standard curve | FastOutSlowInInterpolator |
| 가속 커브 Deceleration curve | LinearOutSlowInInterpolator |
| 가속 커브 Acceleration curve | FastOutLinearInInterpolator |
| 급 커브 Sharp curve | PathInterpolatorCompat.create(0.4f, 0, 0.6f, 1); |

ViewPropertyAnimator를 사용한 지정 방법

```
view.animate()
   .translationX(100)
   .setDuration(290)
   .setInterpolator(new FastOutSlowInInterpolator())
   .start();
```

> API Level 14

## 39p, Material Design Guidelines

### 이번에 다룰 Animation 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - `Movement`
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 40p, Movement

현실 세계와 동일하게 아래쪽으로 중력이 있으므로 `아래쪽이 불룩한 형태`가 된다

## 41p ~ 43p, Movement

### 구현

## 44p, MainActivity

```
Intent intent = new Intent(context, TransformingActivity.class);
Bundle options = ActivityOptionsCompat.makeSceneTransitionAnimation(
      context, fromView, getString(R.string.transition_name)).toBundle(); 
ActivityCompat.startActivity(context, intent, options);
```

ActivityOptionsCompat으로 이동 전 View와 이동 후 View를 묶어서 Activity 시작

## 45p ~ 47p, TransformingActivity

Layout

```
<ImageView
   android:layout_width="math_parent"
   android:layout_height="wrap_content"
   android:transitionName="@string/transition_name"/>
```

> 레이아웃에서 transitionName을 지정

Theme

```
<style name="AppTheme.NoActionBar.Detail">
   <item name="android:windowSharedElementEnterTransition">@transition/default_share</item>
   <item name="android:windowSharedElementReturnTransition">@transition/default_share</item>
</style>
```

> 테마에서 Transition을 지정

Transition

```
<?xml version="1.0" encoding="utf-8"?>
<transitionSet ..
   android:duration="350"
   android:interpolator="...">
    <changeBounds/>
    <pathMotion class="*.GravityArcMotion" />
</transitionSet>
```

> changeBounds로 이동 + 크기를 변화

> pathMotion을 지정, 이걸로 타원형이 된다!

## 48p, Movement

### 구현

pathMotion을 이용한다. 하지만 표준 ArcMotion 클래스를 이용하면 위쪽으로 불룩한 애니메이션으로 `부적절한 움직임이 된다`

```
// X Transition 지정 사례
<changeBounds>
   <arcMotion android:minimumHorizontalAngle="15"
              android:minimumVerticalAngle="0"
              android:maximumAngle="90"/>
</changeBounds>
```

> API Level 21

> [https://developer.android.com/reference/android/transition/ArcMotion.html](https://developer.android.com/reference/android/transition/ArcMotion.html)

## 49p ~ 52p, 자연스러운 곡선을 만들려면?

```
<?xml version="1.0" encoding="utf-8"?>
<transitionSet ..
   android:duration="350"
   android:interpolator="...">
    <changeBounds/>
    <pathMotion class="*.GravityArcMotion" />
</transitionSet>
```

- Plaid에 있는 ArcMotion 클래스를 확장한 GravityArcMotion 클래스가 있다

[plaid/GravityArcMotion.java](https://github.com/nickbutcher/plaid/blob/master/app/src/main/java/io/plaidapp/ui/transitions/GravityArcMotion.java)

※ Plaid는 Google의 Material Design의 오픈 소스 참고 구현이며 Design 뉴스 앱

- 하지만, 기본으로 쓰고 있는 프레임워크 코드가 오래되고, 특정 조건시에 적절히 애니메이션하지 않으므로 다시 만들었다

[material-element/GravityArcMotion.java](https://github.com/takahirom/material-element/blob/master/app/src/main/java/com/github/takahirom/materialelement/animation/motion/GravityArcMotion.java)

## 53p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - `Transforming material`
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 54p, Transforming material

### Radial transformation

탭한 곳부터 원을 그리는 것처럼 표시된다

## 55p, Transforming material

### Radial transformation 구현

SharedElementTransition으로 `Custom Transition`을 이용한다

## 56p ~ 67p, Radial transformation

### 구현 사례

TransformingMaterialActivity

```
Intent intent = new Intent(TransformingActivity.this, LoginActivity.class);
...
ActivityOptionsCompat optionsCompat = ActivityOptionsCompat
   .makeSceneTransitionAnimation(context, 
      fab, 
      getString(R.string.transition_name_login));
ActivityCompat.startActivity(context, 
   intent, 
   optionsCompat.toBundle());
```

> ActivityOptionsCompat으로 이동 전 View와 이동 후 View를 묶어서 Activity 시작

LoginActivity

```
<FrameLayout
   android:layout_width="match_parent"
   android:layout_height="match_parent"   
   android:onClick="dismiss">

   <LinearLayout
      android:id="@+id/container"
      android:transitionName="@string/transition_name_login"
...
```

> 레이아웃에서 transitionName을 지정

LoginActivity

```
final FabTransform sharedEnter = new FabTransform(color, icon);
activity.getWindow().setSharedElementEnterTransition(sharedEnter);
```

> FabTransform 라는 Custom Transition을 지정

FabTransform.java

```
public class FabTransform extends Transition {
    @Override
    public void captureStartValues(TransitionValues transitionValues) {
        // 처음 위치를 저장
        captureValues(transitionValues);
    }    

    @Override
    public void captureEndValues(TransitionValues transitionValues) {
        // 종료 위치를 저장
        captureValues(transitionValues);
    }

    private void captureValues(TransitionValues transitionValues) {
        final View view = transitionValues.view;
        if (view == null || view.getWidth() <= 0 || view.getHeight() <= 0) return;

        // transitionValues 에 위치를 저장
        transitionValues.values.put(PROP_BOUNDS, new Rect(view.getLeft(), view.getTop(),
                view.getRight(), view.getBottom()));
    }    

    @Override
    public Animator createAnimator(final ViewGroup sceneRoot,
                                   final TransitionValues startValues,
                                   final TransitionValues endValues) {
        // 만든 Bounds를 취득
        final Rect startBounds = (Rect) startValues.values.get(PROP_BOUNDS);
        final Rect endBounds = (Rect) endValues.values.get(PROP_BOUNDS);
        ...
        final View view = endValues.view;
        // Bounds를 사용해 CircularReveal를 만든다
        circularReveal = ViewAnimationUtils.createCircularReveal(view,
            view.getWidth() / 2,
            view.getHeight() / 2,
            startBounds.width() / 2,
            (float) Math.hypot(endBounds.width() / 2, endBounds.height() / 2));


        ...
        final AnimatorSet transition = new AnimatorSet();
        transition.playTogether(circularReveal, translate, colorFade, iconFade);
        transition.playTogether(fadeContents);
        ...
        // 이동 전의 View Bound와 이동 후의 Bound를 사용해 Animator를 만든다
        return new AnimatorUtils.NoPauseAnimator(transition);
    }
}
```

## 68p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement                
   - Transforming material
   - `Choreography`
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

## 69p, Choreography

- 기존 이름은 Meaningful transition (의미있는 화면 전환)
- "움직임이 있는 Material에는 전환 중에 요소를 공유하는 것으로 조작 중 사용자의 초점을 이끈다."

## 70p, Choreography

### 연속성 Guidelines

- 컨텐츠의 모든 요소가 공유되는 경우
- 컨텐츠 요소가 대부분 혹은 전혀 공유되지 않는 경우

> API Level 21

## 71p, Choreography

### 연속성 Guidelines

|   | 시작 시간 | 종료 시간 |
| :--: | :--: | :--: |
| Card 너비 | 0ms | 275ms |
| Card 높이 | 30ms | 375ms |
| SharedElement x 위치 | 0ms | 275ms |
| SharedElement y 위치 | 30ms | 375ms |
| 표시되는 View의 투명도 | 75ms | 225ms |

## 72p, Choreography

### 연속성 구현

Fab가 퍼지는 애니메이션과 동일하게 Shared Element Transition을 이용한다

높이와 너비 애니메이션의 시작 시간의 차이를 표현하기위해 `CustomTransition을 작성`

```
AnimatorSet animatorSet = new AnimatorSet();
...
widthAnim.setDuration(275);
heightAnim.setStartDelay(30);
heightAnim.setDuration(345);
animatorSet.playTogether(widthAnim, heightAnim);
```

> API Level 21

## 73p

Shared Element Transition을 사용한 패턴이 많으므로 좀 더 깊이 파봅니다

## 74p ~ 77p, 연속성을 구현하기 위해 ActivityTransition 기초 지식

Activity A -> B로 이동하는 경우

| Activity A | --- startActivity ---> |  Activity B |
| :--: | :--: | :--: |
| ExitTransition |  | EnterTransition |
| SharedElementExitTransition |   | SharedElementEnterTransition |

하나의 전환에 4개의 Transition이 움직인다

> API Level 21

## 78p ~ 81p, 연속성을 구현하기 위해 ActivityTransition 기초 지식

Activity B -> A로 돌아오는 경우

| Activity A | <--- Back 키 --- |  Activity B |
| :--: | :--: | :--: |
| ReenterTransition |  | ReturnTransition |
| SharedElementReenterTransition |   | SharedElementReturnTransition |

하나의 전환에 4개의 다른 Transition이 움직인다

> API Level 21

## 82p, Transition 디버그 1

지금 어느 Transition이 움직이고 있나?

→ 모든 Transition 및 WindowAnimation을 출력

샘플 앱의 메뉴로부터 "Debug"로 활성화할 수 있다

## 83p, Transition 디버그 2

- 애니메이션이 빨라 잘 모르겠다!

→ 개발자용 옵션으로 Animator 재생시간 비율을 변경한다

## 84p, Transition 디버그 3

- View가 Transition 대상이 되어있는지 잘 모르겠다!

→ BlinkDebugTransition 클래스를 이용해 Transition이 움직이고 있는지 확인해보면 좋다

```
<transitionSet>
   <targets>
      <target android:targetId="@id/image" />
   </targets>
   <transition class="*.BlinkDebugTransition" />
</transitionSet>
```

## 85p ~ 91p, Transition이 제대로 동작하지 않을 때 체크 리스트 1

- theme의 windowActivityTransitions이 유효한가?

(AppCompatTheme 등 부모 Theme가 Theme.Material이면 문제 없다)

```
<item name="android:windowContentTransitions">true</item>
```

- ImageVIew의 scaleType을 건드려봤나요?
- View의 Background에 제대로 색을 지정했나요?

## 92p ~ 96p, Transition이 제대로 동작하지 않을 때 체크 리스트 2

- RecyclerView의 Adapter 읽기나 이미지 로딩 후 Layout를 기다리고 Transition을 시작시키고 싶나요?
- ActivityCompat.postponeEnterTransition(activity);로 Transition 시작을 기다린다
- ActivityCompat.startPostponedEnterTransition(activity);로 시작
   - ViewTreeObserver.OnPreDrawListener과 같이 쓴다

## 97p ~ 101p, Transition이 제대로 동작하지 않을 때 체크 리스트 3

- SharedElementTransition의 경우에 Visibility를 상속하지 않는 Transition인가요?
   - Fade Class가 안된다 (2주간 고민했다)
- Share가 아닌 WindowTransition의 경우에 Visibility나 TransitionSet을 상속한 Transition인가요?
- → 조금 전에 설명한 BlinkDebugTransition이나 그 Visibility를 상속한 버전의 BlinkVisibilityDebugTransition를 사용해 디버그해보세요.

`복잡하므로, 샘플 앱에서도 아직 완벽하게 움직이지 않고 솔직히 꽤 힘들다`

## 102p, Choreography

### Radial reaction

ViewAnimationUtils.createCircularReveal로 한다

Transition을 사용하면 Pause시에 Crash (OperationNotSupportedException) 되므로, NoPauseAnimator Class 등을 만들어 Wrapper 해서 사용한다

> API Level 21

> 참고 : [https://halfthought.wordpress.com/2014/11/07/reveal-transition/](https://halfthought.wordpress.com/2014/11/07/reveal-transition/)

## 103p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - `Creative customization`
- Patterns
   - Loading images
   - Navigational transitions

## 104p, Creative customization

### Icon

- System icons
   - 2개의 기능을 가질 수 있다
- Product icons
   - 앱을 최초 실행시에 표시되는 앱 아이콘

## 105p, Creative customization

### 구현 방법

- AnimatedVectorDrawable을 사용하는 방법
- Lottie 등 3rd party 라이브러리를 사용하는 방법

## 106p, 아이콘 동작 방법

### AnimatedVectorDrawable을 사용하는 방법

- AnimatedVectorDrawable(xml)을 만들어 Android 프로젝트에 도입한다
- AnimatedVectorDrawable은 어떻게 만드는가?
   - [https://romannurik.github.io/AndroidIconAnimator/](https://romannurik.github.io/AndroidIconAnimator/)

`구체적인 도입 방법에 대해서 설명하겠습니다`

## 107p, 아이콘 동작 방법 1

### AnimatedVectorDrawable을 준비한다

1. 움직이고 싶은 SVG 파일을 Android Icon Animator에 Drag & Drop 한다
2. Animation 시킨다

※ Path 변경에 따른 Animation (PathMorth) 은 대응 API Level이 21이므로 주의한다

애니메이션 방법은 아래에 있습니다.

Qiita: [애니메이션 아이콘을 만든다](https://qiita.com/takahirom/items/3deee8b73e0a2bc1a50b)

Android Icon Animator를 다뤄본다

> API Level 14

## 108p, 아이콘 동작 방법 2

### AnimatedVectorDrawable을 도입한다

Module의 build.gradle에 활성화한다

```
android {
   ...
   defaultConfig {
      ...
      vectorDrawables.useSupportLibrary true
   }
}
```

> API Level 14

## 109p, 아이콘 동작 방법 3

### AnimatedVectorDrawable을 도입한다

Export해서 VectorDrawable 파일을 적는다

res/draweable 폴더에 넣는다

> API Level 14

## 110p, 아이콘 동작 방법 4

### AnimatedVectorDrawable을 도입한다

AppCompatActivity를 사용하는 Layout으로 ImageView에 app:srcCompat으로 이미지를 설정

```
<ImageView
   app:srcCompat="@drawable/avd_menu_back_menu_to_back"
.../>
```

> API Level 14

## 111p, 아이콘 동작 방법 5

### AnimatedVectorDrawable을 도입한다

나머지는 ImageView에서 Drawable를 얻어서 start() 메소드를 호출하면 OK

샘플내의 CreativeCustomizationActivity.java

```
((Animatable) imageView.getDrawable()).start();
```

> API Level 14

## 112p, AnimatedVectorDrawable 함정 포인트

Android 4.x와 Android 5.x와 Android 7.x에서 동작을 확인할 것

startOffset을 넣으면 Android 4.x에서 Animation 안되므로, 대안으로 아무것도 하지 않는 Animation을 중간에 넣어 속인다

[참고 : Android Open Source Projct의 이슈](https://code.google.com/p/android/issues/detail?id=231154&q=svg&colspec=ID%20Type%20Status%20Owner%20Summary%20Stars)

Animation 지정이 안좋으면 targetSDK N 이상이면 Crash가 발생하므로 주의

[참고: Plaid의 issue](https://github.com/nickbutcher/plaid/issues/132#issuecomment-257926080)

> API Level 14

## 113p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - `Loading images`
   - Navigational transitions

## 114p, Loading images

- Progressive fade-in
   - 멋있는 fade in
- 사진 현상 처리중의 Printer 같이 된다
- Animation Duration은 Loading images의 경우
   - 길게 한다

## 115p, Loading images

샘플의 AnimatorUtils.java

```
ﬁnal ObservableColorMatrix cm = new ObservableColorMatrix();
ObjectAnimator saturation = ObjectAnimator.ofFloat(cm, ObservableColorMatrix.SATURATION, 0f, 1f); 
saturation.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
   @Override
   public void onAnimationUpdate(ValueAnimator valueAnimator) {
      imageView.setColorFilter(new ColorMatrixColorFilter(cm));
   }
});
```

ImageView#setColorFilter를 사용한 ColorFilter에는 setSaturation() 메소드가 있으므로 애니메이션 프레임마다 호출한다

> Plaid 코드로부터

> API Level 14

## 116p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - `Navigational transitions`

## 117p ~ 118p, Navigational transitions

- MaterialDesign 에는 `Elevation 변화`하는 것으로 부모 요소로부터 자식 요소에 포커스 변화를 나타낸다
- Material Motion 곡선을 사용한다

`그림자가 점점 짙어진다`

## 119p, Navigational transitions

- 커스텀 Transition내에서 Elevation을 ObjectAnimator로 변화시키면 OK

```
@Override 
public Animator createAnimator(ViewGroup sceneRoot, TransitionValues startValues, TransitionValues endValues) {
   return ObjectAnimator.ofFloat(endValues.view, View.TRANSLATION_Z, initialElevation, ﬁnalElevation); 
} 
```

> API Level 21

## 120p, Guidelines 내의 설명하는 부분

- Material Design
   - Elevation & shadows
- Motion
   - Duration & easing
   - Movement
   - Transforming material
   - Choreography
   - Creative customization
- Patterns
   - Loading images
   - Navigational transitions

`전부 훑어봤습니다`

## 121p, Android 5.0 미만의 단말 대응

현재 상황

- Android 5.0 = API Level 21
- Android Dashboard에 따르면 66% 사용자가 Android 5.0 이상
- 순조롭게 늘고 있다

> Data collected during a 7-day period ending on February 6, 2017. 

> Dashboards : [https://developer.android.com/about/dashboards/index.html](https://developer.android.com/about/dashboards/index.html)

## 122p, Android 5.0 미만의 단말 대응

- Android 5.0 미만을 포기한다
- Android 5.0 사용자는 애니메이션을 하지 않는다
- 3rd Party 하위호환 라이브러리를 사용한다

## 123p, Android 5.0 미만을 포기한다

- 개요
   - minSdkVersion=21로 한다
   - Androdi 5.0 미만은 설치할 수 없게 한다
- 장점
   - 구현하기 쉽다
- 단점
   - 그만큼 사용자가 있다

`기본적으로 현재로는 상당히 어렵다`

## 124p, Android 5.0 사용자는 애니메이션을 하지 않는다

- 개요
   - Android 버전에 따라 if 문 등응로 분기시킨다
   - Support Library 등으로 가능하면 그것을 사용한다
- 장점
   - 그다지 구현 비용이 높지 않다
- 단점
   - 일부 사용자는 사용 느낌이 다르다

`타당한 라인일지도?`

## 125p, 3rd Party 하위호환 라이브러리를 사용한다

- 개요
   - 3rd Party 라이브러리를 사용한다
- 장점
   - 모든 사용자가 애니메이션이 가능
- 단점
   - 세밀한 움직임이 다르거나 문제가 되거나 그 경우에 시간을 뺏기는 경우가 있다

`균형있게 도입하면 좋을 것 같다`

## 126p ~ 132p, 정리

- 애니메이션은 중요합니다
- 가이드라인과 구현을 봤습니다
   - 샘플 앱의 코드를 봐주세요
- Shared Element Transition에 따른 구현이 많습니다
   - 함정 포인트가 많지만, 시도해보세요
- Android 5.0 미만의 대응에 대해서는 무리해서 모든 OS에서 움직이지 않아도 좋을 듯 합니다
- `Material Design 애니메이션은 가능합니다`
- [material-element(http://git.io/element)](http://git.io/element)을 GitHub에서 Star 해주세요!

## 133p ~ 138p, Thanks

- Designer sorashin
   - [https://github.com/sorashin](https://github.com/sorashin)
- Plaid
   - [https://github.com/nickbutcher/plaid](https://github.com/nickbutcher/plaid)
- Android Open Source Project
   - [https://source.android.com/licenses.html](https://source.android.com/licenses.html)
- DroidKaigi 2017 official Android app
   - [https://github.com/DroidKaigi/conference-app-2017](https://github.com/DroidKaigi/conference-app-2017)