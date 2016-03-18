---
layout: post
title: "[번역] DroidKaigi 2016 ~ 용도에 맞는 애니메이션 구현 방법"
date: 2016-03-17 20:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [用途に合わせたアニメーションの実装方法](http://www.slideshare.net/TakaoSumitomo/ss-58409105) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

**용도에 맞는 애니메이션 구현 방법**

Takao Sumitomo

@cattaka_net

## 2p

**자기소개**

- Takao Sumitomo
- Android 어플 개발자
- 개발 경력
  - Android 어플
  - iOS 어플 (조금)
  - 업무 관련 Web 어플리케이션
  - 업무 관련 Windows 어플
- 그 외
  - 전자공학
  - OpenCV
- Wantedly 주식회사 소속
  - 2014년 12월 ~

## 3p

어플에 움직임을 적용하고 있습니까?

## 4p

필요할 때 <font color="red"><strong>구글링하면</strong></font> 된다고 생각하고 있지 않습니까?

## 5p

실은 애니메이션의 구조는 Android의 FW에 많이 있습니다

## 6p

**한마디로 애니메이션이라고 해도 대상은 뭔가 있을 것이지요**

- View의 내부를 움직임
- View 자체를 움직임
- 복수 View를 포함한 레이아웃을 변경한다

## 7p

**현재 Android 프레임워크 현 상황**

- 각각 구조가 준비되어있습니다
- 하지만 새로운 것이나 오래된 것으로 복수로 있고, 까다롭게 되어있다

## 8p

이번에는 그것을 <font color="blue"><strong>정리하고싶다</strong></font>라는 이야기입니다

## 9p

View 의 내부를 움직임

## 10p

**View의 내부를 움직임**

- 2종류
  - Animation Drawable
  - Animated Vector Drawable

## 11p

**Animation Drawable**

- 간단하게 Flip Animation
- 필요한 것 : 복수 이미지 & xml

## 12p

**Animation Drawable**

drawable/roll_cat.xml

```
<?xml version="1.0" encoding="utf-8"?>
<animation-list
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:oneshot="false">
    <item
        android:drawable="@drawable/roll_cat_1"
        adnroid:duration="200"/>
    <item
        android:drawable="@drawable/roll_cat_2"
        adnroid:duration="200"/>
    <item
        android:drawable="@drawable/roll_cat_1"
        adnroid:duration="200"/>
    <item
        android:drawable="@drawable/roll_cat_3"
        adnroid:duration="200"/>
</animation-list>
```

## 13p

**Animation Drawable**

애니메이션을 시작시키는 코드

```
ImageView logoImage
    = (ImageView) findViewById(R.id.image_logo);

logoImage.setBackgroundResoure(R.drawable.roll_cat);

AnimationDrawable rollCatDrawable
    = (AnimationDrawable) logoImage.getDrawable();

rollCatDrawable.start();
```

## 14p

**Animated Vector Drawable**

- SVG를 애니메이션 시킨다
- 필요한 것 : xml

## 15p

**Animated Vector Drawable**

```
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:height="64dp"
    android:width="64dp"
    android:viewportHeight="600"
    android:viewportWidth="600">

    <group android:name="characterGroup">
        <path
            android:name="character"
            android:fillColor="#000000"
            android:pathData="M 80,0 24,24 0,80 l 24,56 56, -생략-" />
    </group>
    <group android:name="feedGroup"
        android:translateX="80">
        <path
            android:fillColor="#000000"
            android:pathData="M 72,64 l -8,8 0,16, 8,8 16,0 8 -생략-" />
    </group
</vector>
```

이것은 움직임이 없는 단순한 SVG

## 16p

**Animated Vector Drawable**

```
<?xml version="1.0" encoding="utf-8"?>
<animated-vector
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:drawable="@drawable/vector_drawable">
    <target
        android:name="feedGroup"
        android:animation="@anim/av_translation" />
    <target
        android:name="character"
        android:animation="@anim/av_path_morph" />
</animated-vector>
```

android:animation으로 움직임을 넣는다

## 17p

View 자체를 움직임

## 18p

**View Animation**

- 필요한 것 : xml & code

## 19p

**View Animation**

```
<?xml version="1.0" encoding="utf-8"?>
<translate
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="3000"
    android:fromXDelta="0%"
    android:fromYDelta="0%"
    android:interpolator="@android:anim/bounce_interpolator"
    android:toXDelta="100%"
    android:toYDelta="100%" />
```

xml에서 애니메이션을 정의

```
Animation anim = AnimationUtils.loadAnimation(this, R.anim.va_move);
mTargetButton.startAnimation(anim);
```

코드로부터 애니메이션을 실행

## 20p

**View Animation**

코드에서 애니메이션을 정의

```
TranslateAnimation anim
    = new TranslateAnimation(0, mTargetView.getWidth(),
                             0, mTargetView.getHeight());
anim.setDuration(3000);

mTargetView.startAnimation(anim);
```

코드에서 애니메이션을 실행

## 21p

**Property Animation**

- 2가지 구현이 FW에 있다
- ObjectAnimator Class
  - 필요한 것 : xml or ode
  - Reflection을 사용해서, 속성 명으로 애니메이션 시킨다
- ViewPropertyAnimator Class
  - 필요한 것 : code
  - code에서만 사용할 수 있으므로, 가볍게 사용할 수 있다

## 22p

**ObjectAnimator**

```
<?xml version="1.0" encoding="utf-8"?>
<objectAnimator
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="3000"
    android:interpolator="@android:anim/bounce_interpolator"
    android:propertyName="translationX"
    android:valueFrom="0"
    android:valueTo="300"
    android:valueType="floatType"/>
```

이 translationX는 어디를 가리키고 있는가?

xml에서 애니메이션을 정의

```
Animator anim
    = AnimatorInflater.loadAnimator(this, R.animator.pa_move);
anim.setTarget(mTargetButton);
anim.start();
```

코드에서 애니메이션을 실행

## 23p

**ObjectAnimator**

```
public void setTranslationX (float translationX)
```

View Class의 메소드를 가리키고 있다. 즉 Reflection으로 접근한다

## 24p

**ObjectAnimator**

코드에서 애니메이션을 정의

```
ObjectAnimator animator
    = ObjectAnimator.ofFloat(mTargetButton, "translationX",
                             0F, mTargetButton.getWidth());
animator.setDuration(3000);

animator.start();
```

코드에서 애니메이션을 실행

이외에도 ofInt이나 ofObject이나 ofMultiFloat 등이 있다

## 25p

**ViewPropertyAnimator**

X 방향으로 평행이동

```
mTargetView.animate()
        .translationX(mTargetView.getWidth())
        .setDuration(3000)
        .start();
```

360도 회전

```
mTargetView.animate()
        .rotation(360f)
        .setDuration(3000)
        .start();
```

이동이나 회전 이외에 확대축소이나 투명도 동일하게 작성할 수 있습니다.

## 26p

복수 View를 포함한 레이아웃

## 27p

**이름 정리**

- Activity Animation
- Fragment Animation

- Transition
- Activity Transition
- Fragment Transition

각각 다른 움직임을 합니다.(정식 명칭으로 정해지지 않은 것은 가칭 이름입니다)

## 28p

Activity/Fragment Animation

## 29p

**Activity Animation**

- 필요한 것 : xml & code
- View를 움직이기 위해 사용한 애니메이션과 같은 것을 사용

```
Intent intent = new Intent(this, At2Activity.class);

startActivity(intent);

overridePendingTransition(R.anim.aa_slide_in, R.anim.aa_slide_out);
```

## 30p

**Fragment Animation**

- 필요한 것 : xml & code
- View를 움직이기 위해 사용한 애니메이션과 같은 것을 사용
- Support Library의 Fragment인지 아닌지에 따라서 함정이 있다
  - Support Library 사용 시
    - View Animation을 사용
  - Support Library 미사용 시
    - Property Animation을 사용

## 31p

**Fragment Animation**

```
Fragment fragment = Fa1Fragment.newInstance();

FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

ft.setCustomAnimations(R.anim.aa_slide_in, R.anim.aa_slide_out);

ft.replae(R.id.layout_fragment, fragment);

ft.commit();
```

BackKey로 돌아올 때의 애니메이션을 지정하는 매개변수가 4개인 것도 존재합니다

## 32p

Transition

## 33p

**3가지 Transition 공통의 생각**

- 이동 전과 이동 후의 레이아웃에 포함되는 View를 3가지의 그룹으로 나눠서 생각한다
  - 전후의 화면과 공통의 View
  - 전 화면에만 있는 View
  - 후 화면에만 있는 View
- 이것들 3그룹에 대해서 각각 움직임을 지정합니다

## 34p

**3가지 Transition 공통의 생각**

- 전후의 화면과 공통의 View : (1)은 이동시킨다
- 전 화면에만 있는 View : (2)(3)은 Fade Out 시킨다
- 후 화면에만 있는 View : (4)는 Fade In 시킨다

## 35p

**Transition**

- 필요한 것 : xml & code
- ViewGroup 내부를 교체할 때에 사용
- 솔직히 ViewGroup을 코드에서 직접 추가·제거하는 것은 그다지 하지 않으므로 애초에 사용이 적다

## 36p

Transition

## 37p

**Transition**

- 대상이 되는 ViewGroup
- 이동 후의 레이아웃

```
Scene scene = Scene.getSceneForLayout(mContainerLayout,
                                      R.layout.activity_ta_child_rb, this);

Transition transition
    = TransitionInflater.from(this).inflateTransition(R.transition.ta);

TransitionManager.go(scene, transition);
```

- 실행
- 어떻게 이동할 것인가 (다음 페이지)

## 38p

**Transition**

```
<?xml version="1.0" encoding="utf-8"?>
<transitionSet
    xmlns:android="http://schemas.android.com/apk/res/android">
    <fade/>
    <changeBounds>
        <targets>
            <target android:excludeId="@id/buttion_excluded"/>
        </targets>
    </changeBounds>
</transitionSet>
```

## 39p

**지정할 수 있는 움직임 종류**

| Class | Tag | 움직임 |
| :- | :- | :- |
| AutoTransition | autoTransition | 자동 |
| Fade | fade | Fade In/Out (옵션으로 지정) |
| ChangeBounds | changeBounds | 이동과 사이즈 |

Javadoc을 보면, 이외에 ChangeClipBound, ChangeImageTransform, ChangeScroll, ChangeTransform, TransitionSet, Visibility, Explode, Slide가 있다

## 40p

**Activity Transition**

- 필요한 것 : xml or code

## 41p

**Activity Transition**

이동 전후에 공통 요소를 지정

```
ActivityOptions options
    = ActivityOptions.makeSceneTransitionAnimation(
      this,
      new Pair<>(view.findViewById(R.id.image_logo),
                 "transition:image_logo")
      );

getWindow().setSharedElementEnterTransition(new ChangeBounds());
getWindow().setSharedElementReturnTransition(new ChangeBounds());
getWindow().setEnterTransition(new Fade());
getWindow().setExitTransition(new Explode());

Intent intent = new Intent(this, At2Activity.class);
startActivity(intent, options.toBoundle());
```

각각 움직임을 지정한다

## 42p

**Activity Transition**

```
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">

    <ImageView
        android:id="@+id/image_logo"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:adjustViewBounds="true"
        android:src="@drawable/logo"
        android:transitionName="transition:image_logo"/>

    <Button
        android:id="@+id/button3"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content
        android:layout_alignParentBottom="true"
        android:layout_centerHorizontal="true"
        android:layout_gravity="center_horizontal"
        android:text="Button 3"/>
</RelativeLayout>
```

## 43p

**Fragment Transition**

- 필요한 것 : xml or code

## 44p

**Fragment Transition**

각각 움직임을 지정한다

```
Fragment fragment = Ft2Fragment.newInstance();
fragment.setEnterTransition(new Fade(Fade.IN));
fragment.setExitTransition(new Fade(Fade.OUT));
fragment.setSharedElementEnterTransition(new ChangeBounds());
fragment.setSharedElementReturnTransition(new ChangeBounds());

FragmentTransaction ft = getFragmentManager().beginTransaction();
ft.replae(R.id.layout_fragment, fragment);

Fragment currentFragment
    = getFragmentManager().findFragmentById(R.id.layout_fragment);
ft.addSharedElement(currentFragment.getView().findViewById(R.id.image_logo)
                    "transition:image_logo");
ft.addSharedElement(currentFragment.getView().findViewById(R.id.button_a),
                    "transition:button_a");

ft.addToBackStack(null);
ft.commit();
```

이동 전후에서 공통 요소를 지정

## 45p

**Fragment Transition**

```
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">
    <!-- 생략 -->
    <ImageView
        android:id="@+id/image_logo"
        ~~~~~~
        android:transitionName="transition:image_logo"/>

    <FrameLayout
        ~~~~~~
        >
        <Button
            android:id="@+id/button_a"
            android:text="Button A"
            android:transitionName="transition:button_a"/>
    </FrameLayout>
    <!-- 생략 -->
</RelativeLayout>
```

## 46p

**API 레벨에 대해서**

| Name | API Level |
| :- | :- |
| Drawable Animation | 1 (Android 1.0) |
| Animated Vector Drawable | 21 (Android 5.0) |
| View Animation | 1 (Android 1.0) |
| Property Animation | 11 (Android 3.0.x) |
| Transition | 19 (Android 4.4) |
| Activity Transition | 21 (Android 5.0) |
| Fragment Transition | 21 (Android 5.0) |

## 47p

**API 레벨에 대해서**

- Android 5.0에서 대강 갖추어졌다
- Transition이 비교적 새로운 버전이 아니면 사용할 수 없다
  - Support Library에 메소드가 있지만 가장 중요한 Transition Class가 없으므로 사용할 수 없다

## 48p

**정리**

- Animation 구조는 소소하게 많다
- 하지만 각각 용도가 다르다
- 용도에 맞는 것을 사용하자
- 사용자에게 알기 쉽게 표현하자

## 49p

**Sample 어플**

[https://github.com/cattaka/LearnAnimation](https://github.com/cattaka/LearnAnimation)

대부분 코드의 Snipper가 들어있다
