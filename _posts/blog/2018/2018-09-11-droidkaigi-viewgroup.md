---
layout: post
title: "[번역] DroidKaigi 2018 ~ 해부 ViewGroup의 레이아웃 내부 구현"
date: 2018-09-11 01:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ 詳解 ViewGroupのレイアウト内部実装](https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 해부 ViewGroup 레이아웃 내부 구현

DroidKaigi 2017

주식회사 Nohana Seto HiroYUKI

@seto_hi

## 2p, 자기 소개

- Seto HiroYUKI @seto_hi
- Android 엔지니어 & 앱 디자이너
- 주식회사 Nohana
  - 2년 연속 DroidKaigi 스폰서!
  - 한 그룹이라도 가족들에게 웃는 얼굴을 보여주자
  - 절찬 채용 중
- Material Design 좋아함
-  좋아하는 API는 Canvas#save와 ViewGroup#layout

## 3p, 목차

- View는 어떻게 레이아웃되는가?
  - measure, layout
- 해부 FrameLayout􏰀 내부 구현
- 해부 LinearLayout 내부 구현
- 해부 ConstraintLayout 내부 구현
  - ConstraintLayout를 지탱하는 기술
  - Optimizer
  - ~~각종 기능 구현~~ → 부록에 있습니다
- 부록

## 4p, 참고 환경

코드를 읽은 환경

- FrameLayout, LinearLayout(, RelativeLayout)
  - Android 8.0、일부 Android8.1
- CosntraintLayout
  - constraint-layout:1.1.0-beta3, beta4, beta5
  - 일부 beta2 

## 5p

View는 어떻게 레이아웃되는가?

## 6p, 목차

- 레이아웃의 흐름
- measure
  - measure, onMeasure
  - MeasureSpec
  - measuredWidth, measuredHeight
- layout
  - layout, onLayout

## 7p, 레이아웃의 흐름

1. 레이아웃이 요청된다
   - View#requestLayout
2. View􏰀 사이즈를 계산한다
   - measure, onMeasure
3. View 레이아웃
   - measure한 사이즈를 참고로 한다
   - layout, onLayout 

## 8p ~ 10p

https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang?slide=8

## 11p, measure와 layout의 분리

- View는 스스로 레이아웃 위치가 정해지지 않는다
  - 다른 View의 사이즈로 레이아웃 위치가 바뀐다
- 모든 View를 measure해서 결과에 따라 layout 위치를 바꿀 필요가 있다
  - 고기능 ViewGroup은 measure로 레이아웃 위치를 확정시키고 있다

## 12p

View의 measure

## 13p, measure와 onMeasure

- measure가 onMeasure를 호출
- measure􏰁는 View 클래스의 􏰀final 메소드
- measure은 호출하는 용도
- onMeasures는 각􏰁 View가 override 하는 용도

## 14p, onMeasure

- View의 넓이와 높이를 계산
  - ViewGroup은 자식 View를 measure 한다
- 자신의 사이즈도 설정
  - setMeasuredDimensions으로 measuredWidth/Height를 설정
    - 호출하지않으면 `예외`

## 15p, measuredWidth, measuredHeight 

- onLayout으로 사용
- setMeasureDimensions으로 설정한 수치 ※
- View#getWidth/getHeight는 layout 후의 수치
  - View.mLeft-View.mRight
- layout 이후는 사용하면 안 된다
  - measuredWidth/Height한 대로 layout되지는 않는다
  - layout이후는 getWidth/Height를 사용

※ 엄밀하게는 MeasureSpec

## 16p, MeasureSpec

- onMesure 의 인수
- measure의 조건(Mode)와 Size를 int로 표현한 것
  - Mode가 상위 2byte, Size가 하위 30bit

| Mode        | 의미                                                         |
| ----------- | ------------------------------------------------------------ |
| UNSPECIFIED | View가 좋아하는 사이즈로 해도 좋다                           |
| EXACTLY     | 지정한 사이즈로 해야한다                                     |
| AT_MOST     | View가 좋아하는 사이즈로 해도 좋다<br />하지만 지정한 사이즈는 넘지 않도록 |

## 17p

View의 layout

## 18p, layout과 onLayout

- layout이 onLayout을 호출
- ViewGroup#layout은 final 메소드
- layout이 호출하는 용도
- onLayout이 override하는 용도
- 각 ViewGroup이 onLayout을 override한다
  - View는 onLayout을 override할 필요는 없다

## 19p, ViewGroup#onLayout

- 자식 View의 레이아웃을 시킨다
  - ViewGroup에 대한 상대좌표
- measure한 결과를 사용
- measuredWidth/Height한 대로 layout 되어야 한다
  - 예: TextView는 measuredWidth/Height한 대로 문자개행이 이루어진다

## 20p

해부 FrameLayout 내부 구현

## 21p

FrameLayout#onMeasure

## 22p, FrameLayout#onMeasure

1. 모든 자식 View를 measure
   - FrameLayout 인수와 같은 MeasureSpec
2. MeasureSpec#mode에 따라 자신의 사이즈가 바뀐다
   - AT_MODE → 자식 View의 최대치와 spec의 size의 min
   - EXACTLY → spec의 size
   - UNSPECIFIED → 자식 View의 최대값 

3. match_parent인 자식 View를 measure
   - mode: EXACTLY, size: FrameLayout의 넓이

### 23p, FrameLayout#onMeasure

https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang?slide=23

## 24p

FrameLayout#onLayout

## 25p, FrameLayout#onLayout

- measureWidth/Height의 사이즈로 레이아웃
- Gravity에 따라 레이아웃 위치를 바꾼다

## 26p ~ 27p

https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang?slide=26

## 28p

해부 LinearLayout 내부 구현

## 29p

LinearLayout#onMeasure

## 30p, LinearLayout#onMeasure

measureVertical/Horizontal

1. 모든 자식 View를 measure
   - 자식 View의 높이/넓이의 합계를 기록한다
2. weight가 있는 자식 View가 있는 경우
   - weight를 나눈 사이즈 + EXACTLY로 다시 measure
3. setMeasuredDimension

## 31p, Weight Tips

- 0dp + weight가 왜 빠른가
  - LinearLayout의 MesureSpec이 EXACTLY의 경우
    0dp + weight인 View는 1회째의 measure를 skip 하기때문

## 32p

LinearLayout#onLayout

## 33p, LinearLayout#onLayout

- layoutVertical/Horizontal
  - LtR 대응이 있으므로 horizontal이 약간 복잡
- 좌상단부터 순서대로 layout
- orientation과 역방향의 Gravity가 적용
  - 아쉬운 부분

## 34p

해부 ConstraintLayout 내부 구현

## 35p ~ 36p

그런데

## 37p

UI는 일차방정식과 일차부등식으로 표현된다

## 38p

일차방정식과 일차부등식의 최적해를 구한다

## 39p

선형계획법

## 40p, 선형계획법

선형계획법이란 최적화 문제에서
목적 함수가 선형 함수이며
선형 함수의 등식과 부등식으로
제약 조건을 만족시키는 문제이다.

(wikipedia)

🤔

## 41p, 선형계획법

예:

`원료 A` 1g과 `원료 B` 2g 으로 60엔의 상품 X 를 만든다

`원료 A` 3g과 `원료 B` 1g 으로 40엔의 상품 Y 를 만든다

`원료 A` 90g,  `원료 B` 가 50g 있을 경우
상품 X와 Y를 각각 몇개 만든다면
이익이 최대가 되는가?

## 42p, 선형계획법

상품 X를 x, 상품 Y를 y로 한다

x + 3y < 90

2x + y < 50

x >= 0, y >= 0

일 때

60x + 40y의 최대값을 구한다

## 43p ~ 44p, 선형계획법

https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang?slide=43

## 45p

전부 이해했죠? 🤔

## 46p

🤔

## 47p

심플렉스법

## 48p, 심플렉스법

심플렉스법은
임의의 가능해 (초다면체의 정점)로부터 탐색을 시작해
목적 함수의 값을 가능 한 크게 (작게) 되도록 옮겨가면서 동작을 반복해서
최적해를 발견하는 방법이다.

(wikipedia)

🤔

## 49p, 심플렉스법

https://speakerdeck.com/seto_hi/xiang-jie-viewgroupfalsereiautonei-bu-shi-zhuang?slide=49

## 50p, 심플렉스법

- 심플렉스법
- 2단계 심플렉스법
  - 인공변수와 인공적인 목적 함수를 더하는 것으로 초기 기저해가 간단히 구할 수 없는 경우에 대응
- 쌍대 심플렉스법
  - 쌍대정리를 이용해 쌍대문제를 푸는 것으로 주문제도 푼다

## 51p

완전히 이해했죠? 😊

## 52p

🤔

## 53p

Cassowary

## 54p, Cassowary

- 화식조 - 세계에서 가장 위험한 새
- 선형방정식, 선형부등식의 제약충족문제(constraint solving problem)의 해법
  - 2단계 + 쌍대 심플렉스법을 사용
- 앱의 UI용으로 최적화되어 있다
  - 고속
  - 적은 메모리
  - 선언적
  - 차분갱신가능

## 55p, Cassowary

- 2001년에 개발되었다
  - 최초는 CSS의 레이아웃 확장으로
- 많은 언어에 이식되었다
  - Smalltalk, C++, Java, JavaScript, Dart, Python etc..
- 2011년부터 Mac(OS X)과 iOS(6~)에서 사용됨
  - AutoLayout
- ConstraintLayout에도 채용

## 56p

완전히 이해했죠? 😊

## 57p

🙅‍♀️🙅‍♀️🙅‍♀️

## 58p, 참고 자료

@inamiy 님

iOSDC Japan 2017에서 「Auto Layout 알고리즘」에 대해서 발표했습니다.

https://qiita.com/inamiy/items/a6f73438b32896ffa81e 

AutoLayout Algorithm 

https://speakerdeck.com/inamiy/autolayout-algorithm 

## 59p, ConstraintLayout을 지탱하는 기술

이름만이라도 기억해서 돌아가길

- UI 해결 ≒ 선형계획법
- 선형계획법의 해법
  - 심플렉스법  (2단계, 쌍대)
  - Cassowary
- **Advanced ConstraintLayout**
  [https://academy.realm.io/posts/360-andev-2017-nicolas-roard-advanced-constraintlayout/](https://academy.realm.io/posts/360-andev-2017-nicolas-roard-advanced-constraintlayout/)

## 60p

ConstraintLayout 의 구성

## 61p, ConstraintLayout 의 구성

- constraint-layout
  - 9개 클래스
  - View의 간단한 구현이 메인
- constraint-layout-solver
  - 본체
  - 20개 클래스
  - Android에 비의존
  - 선형계획법의 최적해를 구한다

## 62p, constraint-layout 

- ConstraintLayout
- Constraints, ConstraintSet
- ConstraintHelper
  - Barrier, Group, PlaceHolder
- Guideline
- BuildConfig

## 63p, constraint-layout-solver 

android.support.constraint.solver 

- ArrayLinkedVariable
- ArrayRow
- GoalRow
- LinearSystem → 선형계획문제 계산
- SolverVariable

## 64p, constraint-layout-solver 

android.support.constraint.solver.widgets 

- ConstraintWidgetContainer (≒ ConstraintLayout)
- WidgetContainer (≒ ViewGroup) 
- ConstraintWidget (≒ View) 
- ConstarintAnchor (≒ Constraints + ConstraintSet)

## 65p, constraint-layout-solver 

android.support.constraint.solver.widgets 

- Helper = ConstrantHelper
  - Barrier, Group
- Guideline
- Chain

## 66p, constraint-layout-solver 

android.support.constraint.solver.widgets

- Optimizer

## 67p

ConstraintLayout#onMeasure

## 68p, onMeasure 개요

1. ConstraintWidget으로 같은 View 구조를 만든다
2. ConstraintWidget에 값을 반영
3. 모든 자식 View를 measure (인수 􏰂ViewGroup#getChildMeasureSpec) + ConstraintWidget에 width/height를 반영 
4. ※ solver쪽에서゙ 레이아웃할 위치를 결정한다
5. solver로부터 View에 값을 반환한다 
6. setMeasuredDimensions으로 자신의 사이즈를 결정한다

## 69p, 레이아웃 위치 확정

1. ConstraintWidgetContainter#layout
2. 자신의 사이즈에 의존하는 자식 View가 있는 경우
   - 그 자식 View를 다시 measure
   - 그 결과로 layout의 결과가 맞지 않는 경우
     - 다시 ConstraintWidgetContainter#layout
     - ConstraintLayout이 minWidth/Height보다 작은 경우
       - widget의 size를 설정해서 다시 ConstraintWidgetContainter#layout

## 70p

ConstraintWidgetContainter#layout

## 71p, ConstraintWidgetContainter#layout

선형계획법의 최적해를 구하는 자식 ConstraintWidget에 반영

1. while 루프
   레이아웃 위치를 확정될 때까지 반복
2. 자신의 넓이를 설정
3. while문 내에서 수정한 값을 원래대로 돌린다
   ListDimensionBehaviors ≒ MeasureSpec.Mode
4. 자식 ConstraintWidget 의 레이아웃 위치를 설정

## 72p ~ 75p, #layout while 루프

해결될 때까지 아래의 루프를 반복

1. Optimizer 를 사용하는가 체크
   사용하지 않으면, 선형계획법의 최적해를 구한다
2. 일단 해결 완료로 한다
3. 루프가 8번 미만 및
   자식 View가 제약으로 작게 레이아웃되며
   ConstraintLayout이 WrapContent이며
   자식 View의 사이즈가 ConstraintLayout보다 큰 경우
   - 자식 View의 사이즈 + WrapContent로 해서, 다시 한번 루프
4. minWidth/Height보다 작은 경우
   - width와 height를 minWidth/Height의 고정값으로 해서, 다시 한번 루프
5. 3과 4에 해당되지 않고, WrapContent, 자식 View의 변경이 없는데
   이전보다 width/height가 큰 경우
   - measuredTooSmall Flag를 만든다
   - 자신을 이전의 width/Height의 고정값으로 해서 다시 한번 루프

※ 아마도, 레이아웃의 미세 조절을 하면 자신의 사이즈가 예상 밖으로 변경된 경우.
   초기 사이즈로 재계산한다.

## 76p

ConstraintLayout#onLayout

## 77p, onLayout 개요

1. ConstraintHelper#updatePostLayout
2. 모든 자식 View를 ConstraintWidget의 수치대로 레이아웃
   - measure 로 ConstraintWidget 에 값이 설정되어있다
3. 끝 !

## 78p

What is Optimizer?

## 79p, Optimizer

- 전제 : ConstraintLayout 은 고속!
- 그렇지만 심플한 레이아웃에는 과잉 계산
- 심플한 레이아웃은 Optimizer로 해결
  - 선형계획법의 해결을 하지 않는다

## 80p, Optimizer가 발동하는 조건

- View의 위치가 간단하게 결정될 것
  - 양끝이 부모 View와 일치 + View 넓이가 고정 수치
  - 한쪽 끝이 부모 View와 일치 + View 넓이가 고정 수치 or WrapContent
- 사방의 값이 해결되지 않으면 Optimise 실패
- 모든 View가 해결되지 않으면 Optimise 실패

## 81p

ConstraintLayout를 느리게하지않는 tips

## 82p, 느리게하지않는 tips

- ConstraintLayout을 wrap_content로 하지 않는다
- 넓이가 확정되지 않는 View의 percent를 사용하지 않는다
  - 의존하는 View의 사이즈가 정해지지 않으면 percent를 사용한 View의 사이즈가 정해지지 않는다
- Optimizer 가능한 레이아웃으로 한다

## 83p

끝!

## 84p, 부록

- RelativeLayout 내부 구현
  - https://speakerdeck.com/seto_hi/xiang-jie-relativelayoutfalsenei-bu-shi-zhuang
- ConstraintLayout􏰀 기능 구현
  - https://speakerdeck.com/seto_hi/constraintlayoutfalseji-neng-falseshi-xian
- Nohana 회사 레이아웃 전략
  - https://speakerdeck.com/seto_hi/falsehanashe-falsereiautozhan-lue 