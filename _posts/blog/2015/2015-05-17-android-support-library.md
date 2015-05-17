---
layout: post
title: "[번역] Support Library rev.22.1 소개"
date: 2015-05-17 23:00:00
tag: [Android, SupportLibrary]
categories:
- blog
- Android-Study
- SupportLibrary
---

이 포스팅은 [Introduction to Support Library rev.22.1](http://qiita.com/KeithYokoma/items/ed241048be30698ebedb) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

[Support Library rev.22.1의 Release가 배포되었습니다.](http://android-developers.blogspot.jp/2015/04/android-support-library-221.html)

마이너 버전업이지만, 몇가지인가 포스팅해야할 변경이었습니다.

### Support V4

- - -

`DrawableCompat`가 도입되고, 여러가지 `Drawable`의 기능을 API Level 4까지 서포트합니다. `DrawableCompat#wrap(Drawable)`을 이용해서 `Drawable`를 Wrapper하는 것으로, Tinting 지원이 `Drawable` **리소스 분해를 하지않아도** 가능하게 되었습니다.

그리고, `Palette`의 일부 내부 기능을 `ColorUtils`에서 이용가능하게 되었습니다. Lollipop에서 도입된 각종 애니메이션의 `Interpolator`도 이 리소스에 포함되었습니다.

`Space`는 이 리소스에, `GridLayout` 라이브러리부터 Support V4 라이브러리에 이동했습니다.

### AppCompat(Support V7)

- - -

`ActionBarActivity`가 deprecated 되고, 새롭게 `AppCompatActivity`가 도입되었습니다.

이것은, `AppCompatDialog`라는 Dialog를 위한 호환 클래스가 도입되었기때문입니다. `AppCompatDialog`으로, Material Design을 `Dialog`에 적용가능합니다.

그리고, 내부기능(Lifecycle Callback이나 Theme, Color tinting 등)을 `AppCompatDelegate`으로 컨트롤하는것이 가능합니다. 이 `AppCompat`은 어느 `Activity`에서도 내포가능합니다.

각종 View의 Tint를 자동으로 할 수 있도록, AppCompatButton이나 AppCompatTextView 등의 전용 클래스가 도입되었습니다. 이것들은 레이아웃 XML에 기술 할 수 있고, inflate 시에 자동으로 tint 가 이루어집니다.

`ToolBar`에 대해서는, `android:theme`를 레이아웃에 지정가능합니다. 이외의 View에 대해서는, API Level 11+ 이후에서 동일하게 지정가능합니다.

### Leanback

- - -

Leanback에서, Android TV의 각종 모법사례를 다루고있습니다. 샘플이 갱신되고, 좌측에 가이드, 우측에 액션의 일랆이 표시되도록  변경 되었습니다. 각각 테마를 커스터마이징이 가능하고, `GuidanceStylist`나 `GuidedActionsStylist`를 이용해서 더 확장이 가능합니다.

이외, 버그 수정이나 퍼포먼스 개선도 포함되어있습니다.

### RecyclerView

- - -

버그수정 외, `SortedList`라는 데이터 구조가 도입되었습니다. 이것으로, 정렬된 리스트를 다루기가 간단하게 되고, 콜렉션의 변경에 대한 이벤트 핸들링 (dataset change)도 간단하게 됩니다. 또, `SortedList`는 테마세트의 변경을 배치 처리가 가능하고, 동시에 많은 변경이 있어도 한번의 조작으로 그것을 반영할수있도록 되었습니다.

### Palette

- - -

이번 Release로, 품질열화없이 6~8 배의 고속화 되었습니다.

`Palette`의 객체 생성에 `Builder`를 이용가능하게 되었습니다. `Palette#from(Bitmap)`로 Builder를 얻어, 옵션을 지정해서 `generate`나 `generateAsync`하도록 되었습니다.

### RenderScript

- - -

이번 Release에서는 신뢰성과 퍼포먼스가 향상되고, 가장 빠르게 신뢰성있는 구현을 선택할수 있게 되었습니다. `ScriptIntrinsicHistogram`와 `ScriptIntrinsicResize`가 새롭게 도입되었습니다.
