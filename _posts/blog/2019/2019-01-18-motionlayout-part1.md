---
layout: post
title: "Yanolja + MotionLayout #Part1 ~ MotionLayout"
date: 2019-01-18 00:01:00 +09:00
tag: [Android, ConstraintLayout, MotionLayout]
categories:
- blog
- Android
---

2019월 1월 15일 야놀자 7.0.0 버전이 출시되었습니다. 해외 숙박과 홈 개편을 메인이지만, 사용하시면 다양한 부분의 개선이 되었다는 것을 느끼셨을 겁니다. 이번 업데이트 중 리스트의 상단 헤더 부분에 적용된 `MotionLayout` 에 대해서 이야기해보려고 합니다. 

>  공유 가능한 부분만 소개해보려 합니다.

<!--more-->

## MotionLayout?

ConstraintLayout 2.0부터 도입된 MotionLayout에 대해서 알고 계시는가요? 

MotionLayout은 작년 Google I/O 2018에서 발표되었습니다.

간단하게 앱 내에서 레이아웃 및 프로퍼티 변경 시 더 자연스러운 애니메이션을 위해서 태어났습니다.

MotionLayout에 대한 자세한 설명은 아래의 자료를 추천합니다.

#### Medium

- [Introduction to MotionLayout (part I)](https://medium.com/google-developers/introduction-to-motionlayout-part-i-29208674b10d)
- [Introduction to MotionLayout (part II)](https://medium.com/google-developers/introduction-to-motionlayout-part-ii-a31acc084f59)
- [Introduction to MotionLayout (part III)](https://medium.com/google-developers/introduction-to-motionlayout-part-iii-47cd64d51a5)
- [Defining motion paths in MotionLayout](https://medium.com/google-developers/defining-motion-paths-in-motionlayout-6095b874d37)

#### Youtube

<iframe width="560" height="315" src="https://www.youtube.com/embed/ytZteMo4ETk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

>  What's new with ConstraintLayout and Android Studio design tools (Google I/O '18)

#### ConstraintLayout Sample

> https://github.com/googlesamples/android-ConstraintLayoutExamples

작업 당시에는 MotionLayout에 대한 정보를 얻을 수 있는 곳이 Youtube / Medium / Google Sample이 95% 정도의 자료입니다. ~~(정말 😭)~~

## 도입 계기

먼저 이번 야놀자 7.0.0 프로젝트에 도입된 MotionLayout이 도입된 화면을 먼저 감상하겠습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/AxUVJ1XZQos" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

프로젝트 작업 중 자연스러운 애니메이션을 적용해야 하는 미션이 생겼습니다.  `CollapsingToolbarLayout` 느낌을 주면서 `Expand/Collapsing`시에 각 뷰의 위치/노출 처리가 필요한 스펙이었습니다. 복수 뷰를 제어하는 처리라면 CollapsingToolbarLayout로는 해결할 수 없습니다.

이 상황에서 제가 선택해야 할 수 있는 카드는 2가지입니다.

1. CollapsingToolbarLayout 과 비슷한 Custom View 적용
2. MotionLayout 적용

나열한 2가지 모두 어려운 항목일 겁니다.

Custom View를 만드는 것은 복수 View의 위치/노출 등의 처리가 필요하며, 화면마다 노출되는 기능에 맞게 매번 Custom View를 만들어야 하는 이슈가 있죠. 그리고 실제로 해야 하는 작업량과 기반 처리들이 상상 이상일 것입니다.

> Custom View는 어렵기도하며 기간에 대한 예측이 전혀 가늠하기 어려운 것으로 판단했습니다

만약 MotionLayout을 사용한다면?? 이것을 고민할 당시에는 Alpha2, 현재는 Alpha3입니다. 구글의  `Alpha` 버전을 사용해 보신 분들이라면 짐작할 수 있으실테지만, 정식 버전까지 어떻게 변경될지, 언제 정식으로 될지 등 불투명합니다. ConstraintLayout 도 Google I/O 2016에서 1.0.0 Alpha1을 처음 발표한 후 약 2년 가까이 지난 뒤 1.0.0 정식 버전을 발표했습니다. Beta라면 100번 양보해서 사용을 고려 가능합니다. 그러나, DAU가 일정 수준의 서비스이며 주요 리스트 화면에서 적용한다는 것은 큰 도박입니다.

결국 쉬운 수정, 작업 난이도를 고려해 최종적으로 `MotionLayout`을 선택하게 되었습니다.

## 실제 사용하기

MotionLayout 작업시 간단한 레이아웃이라면 아래의 흐름을 추천합니다.

1. Start/End ConstraintLayout 작성
2. MotionLayout 작성 (Path 노출을 추천)
3. MotionScene 작성
4. 실행 후 움직여보기

위 설명을 기준으로 이야기를 진행하겠습니다.

### Start/End ConstraintLayout 정의

```xml
<!-- motion_start.xml / motion_end.xml -->
<?xml version="1.0" encoding="utf-8"?>
<android.support.constraint.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
    <!-- 다양한 뷰 정의 -->
</android.support.constraint.ConstraintLayout>
```

> 자세한 구성은 생략합니다.

MotionLayout의 Start/End시에 그려질 레이아웃을 준비합니다. 

Start/End에 대한 레이아웃의 id 및 ViewType이 동일하도록 정의합니다. 만약 id가 다르다면 애니메이션 처리 시 View 맵핑이 되지 않아 원하던 노출을 할 수 없을 수 있습니다.

### MotionLayout 작성

```xml
<?xml version="1.0" encoding="utf-8"?>
<android.support.design.widget.CoordinatorLayout 
	...>
    <android.support.design.widget.AppBarLayout
        ...>
        <com.google.androidstudio.motionlayoutexample.utils.CollapsibleToolbar
            ...
            app:layoutDescription="@xml/scene_sample"
            tools:showPaths="true" />
    </android.support.design.widget.AppBarLayout>
</android.support.design.widget.CoordinatorLayout>
```

코드를 보시면 MotionLayout 에 대한 정의는 보이지 않아 갸우뚱하셨을 겁니다. 실제 여기서 중요한 부분은 바로 `CollapsibleToolbar` 입니다. `CollapsibleToolbar ` 는 MotionLayout을 상속한 Custom View이며 `AppBarLayout#OnOffsetChangedListener` 을 이용하여 CollapsingToolbarLayout 과 같은 효과를 주도록 설계되었습니다. CollapsingToolbarLayout을 대체하여 사용할 수 있습니다.

Google MotionLayout의 샘플 코드에 있는 기능을 그대로 사용했습니다.

> [https://github.com/googlesamples/android-ConstraintLayoutExamples/blob/master/motionlayout/src/main/java/com/google/androidstudio/motionlayoutexample/utils/CollapsibleToolbar.kt](https://github.com/googlesamples/android-ConstraintLayoutExamples/blob/master/motionlayout/src/main/java/com/google/androidstudio/motionlayoutexample/utils/CollapsibleToolbar.kt)

### MotionScene 작성 

```xml
<!-- scene_sample.xml -->
<MotionScene xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    <Transition
        app:constraintSetEnd="@+id/motion_end"
        app:constraintSetStart="@+id/motion_start"
        app:duration="1000" />
</MotionScene>
```

### 실행 후 움직여보기

위 작업 후 실행하는 것으로 MotionLayout을 적용하여 Animation을 얻을 수 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/L7HKXlxZ2x8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> [야놀자 앱 > 홈 > 내 주변 쿠폰] 화면 샘플 화면

`MotionLayout` 과 `AppBarLatout` 을 함께 사용함으로써 기존 `CollapsingToolbarLayout` 으로는 할 수 없는 다양한 뷰의 애니메이션 효과를 얻을 수 있습니다. 실제로 위와 같은 결과는 추가적인 처리가 더 필요합니다. 

좀 더 트러블 슈팅에 대한 내용은 Part2 에서 이어서 소개하도록 하겠습니다.