---
layout: post
title: "Yanolja + MotionLayout #Part2 ~ CollapsibleToolbar"
date: 2019-01-18 00:02:00 +09:00
tag: [Android, ConstraintLayout, MotionLayout]
categories:
- blog
- Android
---

Yanolja + MotionLayout #Part1 ~ MotionLayout 에서는 MotionLayout에 대한 간단한 이야기와 기본적인 적용에 관해 설명했습니다. Part2에서는 야놀자 서비스에 도입된 `CollapsibleToolbar` 내용을 더 설명하겠습니다. 실제로 Part2에 해당하는 내용으로 많은 트러블 슈팅을 했습니다.

좀 더 MotionLayout을 다뤄보겠습니다.

<!--more-->

## Constraint

먼저 리스트 화면에서는 `Expand/Collapsing` 되었을 때의 차이는 아래와 같습니다.

| Expand                                                       | Collapsing                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0118-motionlayout/01.png" }}" />  |  <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0118-motionlayout/02.png" }}" /> |

| 항목                                                 | 위치 변화 | 크기 변화 | 노출 변화 |
| ---------------------------------------------------- | --------- | --------- | --------- |
| 전체 높이                                            |           | O         |           |
| 타이틀 텍스트<br />(CollapsingToolbarLayout 과 동일) | O         | O         |           |
| Home 버튼                                            |           |           | O         |
| Search 버튼                                          |           |           | O         |
| 요일 텍스트                                          | O         | O         |           |
| 인원 텍스트                                          | O         | O         |           |
| 쿠폰 버튼                                            |           |           | O         |
| 필터 버튼                                            |           |           | O         |
| 맵 버튼                                              | O         |           |           |

`CollapsibleToolbar` 의 ViewGroup 아래에 다양한 항목 및 그에 따른 처리를 하고 있습니다.

## 트러블 슈팅 #1 CollapsibleToolbar 특성 문제

Collapsing 을 지원하는 View인 경우 높이가 변한다는 것을 추측할 수 있습니다. 

일반적으로 ConstraintLayout 작업시 대부분은 `Top-To-Bottom` 방식으로 위에서 아래로 Anchor를 처리하면서 레이아웃을 구성하는 방식을 사용합니다. 그러나,  `CollapsibleToolbar` 사용 시에는 동일하게 Start/End에 대한 처리를 해서 동작시켜보시면 실제로 원하던 동작을 하지 않습니다. MotionLayout의 `Show Path`를 활성시 움직이는 궤적도 원하던 형태가 아닐 것입니다.

정확한 이유는 파악하지 못했지만, `CollapsibleToolbar` 를 사용하는 소스를 보면 모두 `Bottom-To-Top` 형태로 레이아웃을 구성되어 있는 것을 볼 수 있습니다.  `Top-To-Bottom` 로 안되는 이유는 AppBarLayout이 줄어들 때 상단 부분이 사라지는 기능의 연장선이라고 추측하고 있습니다. (개인적인 생각입니다) 

| Bottom-To-Top                                                | Top-To-Bottom                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0118-motionlayout/03.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0118-motionlayout/04.png" }}" /> |

> 위 결과는 다음 소스를 수정한 결과입니다
>
> [https://github.com/googlesamples/android-ConstraintLayoutExamples/blob/master/motionlayout/src/main/res/xml/scene_09.xml](https://github.com/googlesamples/android-ConstraintLayoutExamples/blob/master/motionlayout/src/main/res/xml/scene_09.xml)

AppBarLayout + CollapsibleToolbar 사용시에는 `Bottom-To-Top` 로 레이아웃 구성하면 됩니다.

## 트러블 슈팅 #2 텍스트 크기 변경

헤더에서 사용하는 타이틀은 `Expand/Collapsing` 시의 텍스트 크기가 다릅니다. MotionLayout의 Start/End 부분에 다른 텍스트 사이즈를 정의하는 것이 빠른 접근이지만, 실제로 동작 시에는 텍스트의 렌더링이 매끄럽게 그려지지 않습니다. 이 부분은 TextView의 Size 변경 시 일어나는 내부 처리로 인해 일어납니다.

실제 텍스트 사이즈 변경 시에는 TextView는 아래 작업을 합니다.

1. Resources 취득
2. 현재 텍스트 사이즈와 다른지 비교
3. 텍스트 뷰 내부 필드 Null 처리
4. requestLayout() 호출
5. invalidate() 호출

> 참고 : [https://android.googlesource.com/platform/frameworks/base/+/jb-mr0-release/core/java/android/widget/TextView.java#2244](https://android.googlesource.com/platform/frameworks/base/+/jb-mr0-release/core/java/android/widget/TextView.java#2244)

실제로 View 처리 시 `4` / `5`에 해당하는 항목이 가장 큰 부하가 걸리는 항목입니다. TextView 사이즈가 최소~최대 사이즈의 0.0 ~ 1.0 의 비율로 적용되므로 스크롤 시마다 위의 1~5번 항목이 매번 처리됩니다. 그래서 `Scale` / `Pivot` 을 이용해 부하를 줄이는 방법으로 빠르게 렌더링할 수 있었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0118-motionlayout/05.png" }}" />

> 참고 : [MotionLayout – Collapsing Toolbar – Part 1](https://blog.stylingandroid.com/motionlayout-collapsing-toolbar-part-1/)

## 트러블 슈팅 #3 텍스트 변경 시 레이아웃 갱신 문제

MotionLayout 이 포함된 뷰의 내용을 변경할 경우에 레이아웃이 갱신되지 않습니다. 이 이유는 MotionLayout의 내부 로직을 보면 좀 더 알 수 있습니다. MotionLayout은 빠른 렌더링을 위해서 View와 각 View에 설정된 MotionController을 임시 저장해서 사용하고 있습니다. 그리고 MotionController 에 정의된 필드조차 많으며 컨트롤에 많은 처리를 해준다는 것을 알 수 있습니다. 

```java
public class MotionLayout extends ConstraintLayout implements NestedScrollingParent2 {
    ...
    HashMap<View, MotionController> mFrameArrayList = new HashMap();
    ...
	private void setupMotionViews() {
        if (!this.mSetup) {
            if (VERSION.SDK_INT < 18 || !this.isInLayout()) {
                ...
                this.mFrameArrayList.clear();

                int layoutWidth;
                for(layoutWidth = 0; layoutWidth < n; ++layoutWidth) {
                    View v = this.getChildAt(layoutWidth);
                    MotionController f = new MotionController(v);
                    this.mFrameArrayList.put(v, f);
                }
                ...
                this.requestLayout();
                this.mSetup = true;
            }
        }
    }
    ...
}
```

```java
public class MotionController {
    ...
    View mView;
    int mId;
    private int mCurveFitType = -1;
    private MotionPaths mStartMotionPath = new MotionPaths();
    private MotionPaths mEndMotionPath = new MotionPaths();
    private MotionConstrainedPoint mStartPoint = new MotionConstrainedPoint();
    private MotionConstrainedPoint mEndPoint = new MotionConstrainedPoint();
    private CurveFit[] mSpline;
    private CurveFit mArcSpline;
    float stagger_offset = 0.0F;
    float stagger_scale = 1.0F;
    private int[] mInterpolateVariables;
    private double[] mInterpolateData;
    private double[] mInterpolateVelocity;
    double[] mCycleData = new double[18];
    double[] mmCycleVelocity;
    private String[] mAttributeNames;
    private int[] mAttributeInterpCount;
    private int MAX_DIMENSION = 4;
    private float[] buff;
    private ArrayList<MotionPaths> mMotionPaths;
    private int mDrawPath;
    private float[] mVelocity;
    private ArrayList<Key> mKeyList;
    private HashMap<String, TimeCycleSplineSet> mTimeCycleAttributesMap;
    private HashMap<String, SplineSet> mAttributesMap;
    private HashMap<String, KeyCycleOscillator> mCycleMap;
    private KeyTrigger[] mKeyTriggers;
    String[] attributeTable;
```

핵심은, `MotionLayout#setupMotionViews` 의 내부 리소스가 갱신되도록 호출해주는 방법입니다. 버전에 따라 더 빠른 처리가 가능하겠지만, alpha2 작업시는 `MotionLayout#setTransition` 를 MotionLayout Setup을 재호출하여 문제를 해결할 수 있습니다. 그로 인해 MotionScene 및 레이아웃의 대대적인 작업도 동반되었습니다.

> MotionLayout의 셋업처리를 미리 알았다면 많은 트러블 슈팅이 줄었을 텐데... 눈물이 흐릅니다.

## 트러블 슈팅 #4 Elevation 문제

안드로이드에서 `elevation` 은 그림자를 노출하는 역할을 합니다. 아쉽게도 `elevation` 은 Android 5.0부터 추가되었습니다. (~~많은 안드로이드 개발자들의 애증이 담긴 기능입니다.~~) 보통 4.x의 단말에도 `elevation` Field에 값을 부여하더라도 서비스가 죽는 경우는 없습니다. 그림자 효과가 노출이 되지 않을 뿐 특별히 문제가 되는 경우는 적습니다. 

그러나, `Samsung 4.4.x` 에서 MotionLayout 사용시는 이야기가 다릅니다. 결과부터 이야기드리면 100% Crash입니다. 더 슬픈 것은 현재 이슈가 해결 혹은 진행 중인 상태가 아닙니다. 그러니 `Android 4.x를 포기`하는 것이 해결법입니다. MotionLayout 내부 문제로 단시간에 해결될 것으로는 보이지 않습니다. 

> [Issue Tracker > ConstraintLayout 2.0.0-alpha2 broke compatability](https://issuetracker.google.com/issues/119271613)

## 결과 화면 (Ver. Slow)

<iframe width="560" height="315" src="https://www.youtube.com/embed/pGofoAJf4Is" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 실제로 위의 영상은 추가적인 MotionLayout 처리와 + Custom Behavior 를 이용한 화면입니다.

## 장단점

### 장점

- Start/End의 상태가 있는 경우, Layout 애니메이션 처리시에 작업 난이도가 낮다 (★★★★)

### 단점

- 아직 Alpha 버전이므로 도입의 용기가 필요합니다. 언제 정식 버전이 될지는 알 수 없습니다.
- MotionLayout Editor가 없어, 실제로 빌드 후 실행하면서 정상적으로 움직임을 체크해야한다
- MotionLayout 내의 데이터가 변경되지 않는다면 추천합니다. 그러나, View의 사이즈/Visibility가 갱신된다면 레이아웃 구성을 변경하거나 Transition 갱신해야지만 올바르게 노출됩니다. 

## 마무리

`MotionLayout`을 실제 프로덕션에 적용해볼 기회가 있어서 좋았습니다. Alpha 버전을 넣을 수 있는 경험도 했습니다. 그리고, 아직 안정 버전이 아니라서 생기는 다양한 트러블 슈팅과 버그로 수많은 고통도 함께했습니다.

Android 개발 시 애니메이션 처리에 대해 아쉬움이 있었지만, `MotionLayout` 을 이용해 더 쉽게 애니메이션을 적용할 수 있어 기대되는 라이브러리입니다.