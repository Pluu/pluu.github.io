---
layout: post
title: "Android Animation, Animator 잡담"
date: 2015-12-08 23:30:00
tag: [Android, Animation, Animator]
categories:
- blog
- Android
---

<!--more-->

## View Animation

안드로이드 View Animation 사용 방법에는 주로 두 가지를 사용합니다.

- Animation
- Animator

## Animation (API level 1)

Android 초기부터 많이 사용하던 방법입니다.

- `AnimationUtils` 를 이용하여 XML 로드하여 사용
- Animation 을 상속받은 `Custom Class` 사용

## Animator (API level 11)

3.0 부터 새롭게 등장한 Animation 으로 기존 View에 대한 Animation 만 정의 가능했던 반면,

View 및 Value, Object에 대한 정의도 가능합니다.

- Animator (3.0.x)
- ViewPropertyAnimator (3.1.x)

- - -

Animator 사용시 필수로 체크할 사항은 아니지만, 가볍게 체크해볼만한 사항을 작성해봅니다.

## OS version

Animator 는 3.0부터 적용되어 11보다 낮은 버전에서는 사용이 불가능합니다.

그래서, 주로 별도 라이브러리인 `NineOldAndroids` 를 사용할 수 있습니다.

이외 동일한 사용방법은 아니지만, support-v4 의 `ViewCompat` 도 적용 가능합니다.

## Animator Scale

Animator 는 Animation 과 다르게 `개발자 모드`로 Animator의 속도가 변경 가능합니다

`개발자 옵션 - Animator 길이 배율` 로 선택 가능합니다.

Animator의 길이를 `Off ~ 10배` 사이의 값을 선택 가능합니다.

`0ff` 로 선택시 Duration의 적용과 무관하게 Animator 가 종료되거나 Animator 적용에 따라서 기존 원하는 화면 결과가 나타나지 않는 현상이 나타납니다.

- - -

## Animator 관련 추천 사이트

- [Animation in Honeycomb](http://android-developers.blogspot.kr/2011/02/animation-in-honeycomb.html)
- [Introducing ViewPropertyAnimator](http://android-developers.blogspot.kr/2011/05/introducing-viewpropertyanimator.html)
- [Android 4.0 Graphics and Animations](http://android-developers.blogspot.kr/2011/11/android-40-graphics-and-animations.html)

- - -

사용자가 직접 바꾼 설정에 의한 Animator 결과가 개발자가 의도한 것과 다르게 나타나므로

어떻게 작업해야하는것이 맞고 안맞다라는 것 보다는

개발자 모드로 `창 애니메이션 비율, 전환 애니메이션 비율, Animator 길이 비율`의 설정에 따라서 이런 결과도 있다는 글을 적어 봤습니다.
