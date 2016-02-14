---
layout: post
title: "[번역] Activity LifeCycle (LOG)"
date: 2015-06-07 12:00:00
tag: [Android, LifeCycle]
categories:
- blog
- Android
---

<!--more-->

이 포스팅은 [Activityのライフサイクル(ログ)](http://qiita.com/u-16/items/779eb48441b0bcbe43cb) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

왠지모르게 신경쓰이는 라이프 사이클

관련이슈로 상당히 신경써야하므로 로그를 뽑아봤습니다.

[@calciolife](http://qiita.com/calciolife)　씨의 기사에 자세한 내용이 적혀있습니다.

[http://qiita.com/calciolife/items/39b2696a9a03e8591d40](http://qiita.com/calciolife/items/39b2696a9a03e8591d40)

이 기사는 단순한 로그를 붙인것입니다.

lauchMode 를 바꾸거나, AppcompatActivity 로 해보거나, 이외에도 누락된 콜백이 있거나, 즉시 추가할 예정입니다.

### 설정
- - -

검증단말은 Nexus5

OS는 4.4.4

U_16_main : 이동전인 Activity

U_16_sub : 이동하는 Activity

U_16_fragment : Activity에 add(replace) 되는 ragment

U_16_View : Activity에 add 되는 View

Activity는 2개 모두 ActionBarActivity

launchMode는 SingleTop

Fragment는 supportFragment을 사용

View는 FrameLayout에 TextView를 1개 추가

### 이하 로그
- - -

#### Activity立ち上げ

- D/U_16_main﹕ onContentChanged
- D/U_16_main﹕ oncreate
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onPostCreate
- D/U_16_main﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume
- D/U_16_main﹕ onAttachedToWindow

#### Activity 이동

- D/U_16_main﹕ onUserInteraction
- D/U_16_main﹕ onUserInteraction
- D/U_16_main﹕ onUserLeaveHint
- D/U_16_main﹕ onPause
- D/U_16_sub﹕ onContentChanged
- D/U_16_sub﹕ onCreate
- D/U_16_sub﹕ onStart
- D/U_16_sub﹕ onPostCreate
- D/U_16_sub﹕ onResume
- D/U_16_sub﹕ onResumeFragments
- D/U_16_sub﹕ onPostResume
- D/U_16_sub﹕ onAttachedToWindow
- D/U_16_main﹕ onSaveInstanceState
- D/U_16_main﹕ onStop

#### Backkey 로 복귀

- D/U_16_sub﹕ onUserInteraction
- D/U_16_sub﹕ onKeyDown
- D/U_16_sub﹕ onUserInteraction
- D/U_16_sub﹕ onBackPressed
- D/U_16_sub﹕ onPause
- D/U_16_main﹕ onRestart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume
- D/U_16_sub﹕ onStop
- D/U_16_sub﹕ onDestroy

#### Recent 버튼 / HomeButton / 다른 어플리케이션으로 이동

- D/U_16_main﹕ onUserInteraction
- D/U_16_main﹕ onUserLeaveHint
- --------- beginning of /dev/log/system
- D/U_16_main﹕ onPause
- D/U_16_main﹕ onSaveInstanceState
- D/U_16_main﹕ onStop

#### 슬립모드

- D/U_16_main﹕ onPause
- D/U_16_main﹕ onSaveInstanceState
- D/U_16_main﹕ onStop

#### Recent로부터 복귀

- D/U_16_main﹕ onRestart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume

#### Fragment 을 동적으로 추가

- D/U_16_main﹕ onUserInteraction
- D/U_16_fragment﹕ onAttach
- D/U_16_main﹕ onAttachFragment
- D/U_16_fragment﹕ onCreate
- D/U_16_fragment﹕ onCreateView
- D/U_16_fragment﹕ onViewCreated
- D/U_16_fragment﹕ onActivityCreated
- D/U_16_fragment﹕ onViewStateRestored
- D/U_16_fragment﹕ onStart
- D/U_16_fragment﹕ onResume

#### Fragment 가 있는 경우의 back → fore

- D/U_16_main﹕ onUserInteraction
- D/U_16_main﹕ onUserLeaveHint
- D/U_16_fragment﹕ onPause
- D/U_16_main﹕ onPause
- D/U_16_main﹕ onSaveInstanceState
- D/U_16_main﹕ onStop
- D/U_16_main﹕ onRestart
- D/U_16_fragment﹕ onStart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onResume
- D/U_16_fragment﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume

#### Fragment 가 있는 경우 화면회전

- D/U_16_fragment﹕ onPause
- D/U_16_main﹕ onPause
- D/U_16_main﹕ onSaveInstanceState
- D/U_16_main﹕ onStop
- D/U_16_fragment﹕ onDestroyView
- D/U_16_fragment﹕ onDestroy
- D/U_16_fragment﹕ onDetach
- D/U_16_main﹕ onDestroy
- D/U_16_fragment﹕ onAttach
- D/U_16_main﹕ onAttachFragment
- D/U_16_fragment﹕ onCreate
- D/U_16_main﹕ oncreate
- D/U_16_fragment﹕ onCreateView
- D/U_16_fragment﹕ onViewCreated
- D/U_16_fragment﹕ onActivityCreated
- D/U_16_fragment﹕ onViewStateRestored
- D/U_16_fragment﹕ onStart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onRestoreInstanceState
- D/U_16_main﹕ onPostCreate
- D/U_16_main﹕ onResume
- D/U_16_fragment﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume
- D/U_16_main﹕ onAttachedToWindow

#### onCreate에 addFragment + addView 를 넣은 경우의 로그

- D/U_16_main﹕ onContentChanged
- D/U_16_main﹕ oncreate
- D/U_16_fragment﹕ onAttach
- D/U_16_main﹕ onAttachFragment
- D/U_16_fragment﹕ onCreate
- D/U_16_fragment﹕ onCreateView
- D/U_16_fragment﹕ onViewCreated
- D/U_16_fragment﹕ onActivityCreated
- D/U_16_fragment﹕ onViewStateRestored
- D/U_16_fragment﹕ onStart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onPostCreate
- D/U_16_main﹕ onResume
- D/U_16_fragment﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume
- D/U_16_main﹕ onAttachedToWindow
- D/U_16_View﹕ onAttachedToWindow
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onSizeChanged
- D/U_16_View﹕ onLayout
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onLayout

#### fragment + view + Menu 있는 경우

- D/U_16_main﹕ oncreate
- D/U_16_main﹕ onContentChanged
- D/U_16_fragment﹕ onAttach
- D/U_16_main﹕ onAttachFragment
- D/U_16_fragment﹕ onCreate
- D/U_16_fragment﹕ onCreateView
- D/U_16_fragment﹕ onViewCreated
- D/U_16_fragment﹕ onActivityCreated
- D/U_16_fragment﹕ onViewStateRestored
- D/U_16_fragment﹕ onStart
- D/U_16_main﹕ onStart
- D/U_16_main﹕ onPostCreate
- D/U_16_main﹕ onResume
- D/U_16_fragment﹕ onResume
- D/U_16_main﹕ onResumeFragments
- D/U_16_main﹕ onPostResume
- D/U_16_main﹕ onAttachedToWindow
- D/U_16_View﹕ onAttachedToWindow
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onSizeChanged
- D/U_16_View﹕ onLayout
- D/U_16_main﹕ onCreateOptionsMenu
- D/U_16_main﹕ onPrepareOptionsMenu
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onMeasure
- D/U_16_View﹕ onLayout
