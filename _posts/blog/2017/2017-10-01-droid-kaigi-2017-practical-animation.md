---
layout: post
title: "[번역] DroidKaigi 2017 ~ 실전 애니메이션"
date: 2017-10-01 23:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 実践アニメーション](https://www.slideshare.net/NaoyaYunoue/practical-animation-72950948) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 실전 애니메이션

~ 복잡한 애니메이션을 향한 방법 ~

Naoya Yunoue

## 2p, 자료에 대해서

PDF에 OOP를 포함되어 있으므로, 다운로드 후 LibreOffice로 열면 애니메이션 gif가 움직입니다

샘플 코드

https://github.com/citrous/practicalanimation

## 3p ~ 4p, 목차

1. 자기소개와 이 강의에 대해서
2. View 애니메이션 기초
3. 다양한 방법 소개
   1. 복수 요소를 엮는다
   2. AnimatedVectorDrawable 만드는 법
   3. 코드로 구현 (여기가 본편)

## 5p

자기소개와 이 강의에 대해서

## 6p

Naoya Yunoue

- Android와 Kotlin 정말 좋아함
- 와인과 일본술도 정말 좋아함
- 최근 Netflix에 몰두

## 7p

주식회사 septeni original 에서 "GANMA!"라는 만화 앱 개발에 종사

Android도 Scala도 쓰고 있습니다

## 8p

Android 애니메이션, 어떻게 해야 할까?

## 9p

애니메이션 이미지 데이터가 있다면 문제없다! 

없다면, 어떻게 만들 것인가?

## 10p, Animation 관련 API가 많다

- Animation 클래스
- Transition Animation
- Property Animation
- 기타 등등

## 11p

복잡한 애니메이션을 구현할 때에 어떤 방법이 존재하는가 소개합니다

## 12p

2. View 애니메이션 기초

## 13p, Android 기본 Animation

- 이동 (Translation)
- 확대·축소 (Scale)
- 회전 (Rotation)
- 투과 (Alpha)

## 14p, 이동 (Translation)

```
view.animate().translationX(128).translationY(128).start();
```

## 15p, 확대·축소 (Scale)

```
view.animate().scaleX(2.0f).scaleY(2.0f).start();
```

## 16p, 회전 (Rotation)

```
view.animate().rotation(180f).start();
```

## 17p, 투과 (Alpha)

```
view.animate().alpha(0f).start();
```

## 18p, Material Design에서 애니메이션 사정

- 물리적인 시각효과를 표현
- 사용자 액션의 피드백이 중요
   - Ripple Effect, Transition Animation

## 19p, 요즘 앱의 디자인

- 심플한 애니메이션에서는 표현력 부족
- 뭔가 아쉽다

## 20p

3. 다양한 방법 소개

## 21p, 복수 요소를 엮는다

res/animator에 AnimatorSet 리소스를 만든다

다른 View에도 사용할 수 있다

## 22p

- typo가 무섭다
- 애니메이션이 복잡하게 되면 읽기 어렵다
- 한번 만든 리소스가 성역이 되기 쉽다

## 23p, AnimatedVectorDrawable

ObjectAnimator를 사용해 VectorDrawable을 애니메이션 시킨다

## 24p, Android Icon Animator

https://romannurik.github.io/AndroidIconAnimator/

Google의 Roman Nurik씨가 만든 신급 도구

작성한 애니메이션 아이콘을 xml로 추출 가능

## 25p, VectorDrawable에 대응

애니메이션 아이콘을 간단하게 작성 가능하다

## 26p, 간단한 애니메이션 아이콘은 간단하게 작성가능하다

프리뷰버전이지만 실용성은 충분

애니메이션시킬 대상이 늘어나면 어렵다...

## 27p

이런 애니메이션은?

## 28p

여기에서부터 본론입니다

## 29p 

ValueAnimator + CustomView 만능설

## 30p, ValueAnimator

- ObjectAnimator 의 부모
- API Level 11 ~
- 지정한 값을 지정한 시간내에 변화시킨다
- 복수 프로퍼티를 가지는 것도 가능

## 31p

여기에서 지정한 시간내에

```
animator.setDuration(ANIMATION_DURATION);
```

## 32p

여기에서 지정한 값이 0 ~ 지정한값까지 바뀐다

```
animator.setFloatValue(100f);
```

## 33p

- setValues는 기본적으로 뭐든 OK
- 복수 값을 Key-Value로 지정할 수 있다
- 시작시의 값을 지정하는것도 가능 (API Level 21 ~ )

```
ValueAnimator animator = new ValueAnimator();
animator.setFloatValue(100f);
animator.setDuration(ANIMATION_DURATION);
animator.setInterpolator(new AccelerateInterpolator());
```

## 34p, setValues의 친구들

- setFloatValues(float... values)   → float 값
- setIntValues(int... values)   → int 값
- setValues(PropertyValuesHolder... values)   → PropertyValuesHolder 를 넣을 수 있다
- setObjectValues(Object... values)   → 뭐든 OK. 추이는 setEvaluator로 지정한다

## 35p, **Interpolator**에 맞춰 변화시키는 것도 가능

처음은 천천히 후반 가속이라든지, 처음과 마지막에 천천히라든가

## 36p, UpdateListener 를 지정

값이 갱신된 타이밍에 View를 갱신해준다

```
animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
   @Override
   public void onAnimationUpdate(ValueAnimator animation) {
      invalidate();
   }
});
```

## 37p

View의 onDraw()에서 ValueAnimator의 값을 기준으로 도형을 그린다

```
@Override
protected void onDraw(Canvas canvas) {
   super.onDraw(canvas);

   if (animator.isRunning()) {
      float value = (float) animator.getAnimatedValue("");
      drawPhotons(canvas, value);   
   }
}
```

## 38p, 각 점의 드로잉

X 좌표 = value * 랜덤 수치 1 + A

Y 좌표 = (value * 랜덤 수치 2)^2 - 2(랜덤수치 2 * 랜덤수치 3) + A

랜덤 수치 : 애니메이션 시작시에 생성

value: ValueAnimator에서 얻을 수 있는 값

A: View의 중심까지의 좌표

## 39p, 완성

## 40p, ValueAnimator를 복수 사용한 사례

## 41p

- 모두 코드내에서 끝낸다
- 드로잉할 상대 좌표 지정이나 랜덤 요소 추가 등이 쉽다
- 애니메이션 대상이 늘어나도 추가하기 쉽다
- 복잡하게 된 경우, 가독성이 xml보다 높다

## 42p, 정리

- 이미지 리소스가 있으면 그것이 제일 낫다
- Android Icon Animator는 편리
- ValueAnimator + CustomView로 뭐든 된다

## 43p

멋진 Android 애니메이션 생활을 즐겨주세요
