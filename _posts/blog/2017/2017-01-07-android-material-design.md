---
layout: post
title: "[번역] 너무 세세해서 전해지지 않는 Material Design 구현"
date: 2017-01-07 18:00:00 +09:00
tag: [Android, Material Design]
categories:
- blog
- Android
---

본 포스팅은 [細かすぎて伝わらないMaterial Designの実装](http://qiita.com/hiroyuki-seto/items/e8728e52d48a587939ff) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

신세지고 있습니다. [@seto_hi](https://twitter.com/seto_hi)입니다.

Android 엔지니어들에게 있어서 오늘도 Material Design 구현으로 소모되는 것을 알고 있습니다.

오늘은 Material Design의 가이드라인의 구현을 소개합니다만, 무슨 실수로 참고가 되길 바랍니다.

코드는 모두 [이곳의 Repository](https://github.com/hiroyuki-seto/AndroidAdventCalendar2016)에 올려져 있습니다.

## List의 Top padding과 Bottom padding

[가이드라인의 Lists](https://material.google.com/components/lists.html)를 읽으면, "Add 8dp of padding at the top and bottom of a list"라는 표현이 12번이나 나옵니다.

이것을 간단하게 RecyclerView의 `paddingTop` 및 `paddingBottom`으로 해결하면 

스크롤 끝의 효과가 padding 아래에서 나타나 버리거나 스크롤시 아이템이 잘려버리거나 이쁘지 않습니다.

여기에서는 독자적으로 ItemDecoration을 만들어 해결합시다!

```
@Override
public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);
        if (parent.getChildAdapterPosition(view) == 0) {
                outRect.top += mPadding;
        } else if (parent.getChildAdapterPosition(view) == parent.getAdapter().getItemCount() - 1) {
                outRect.bottom += mPadding;
        }
}
```

<img src="https://qiita-image-store.s3.amazonaws.com/0/103039/00a7a588-62e9-a718-e274-f2171a42329a.png"/>

이걸로 완벽하네요!

## 문자 크기(Dense)

[가이드라인의 Typography](https://material.google.com/style/typography.html)를 읽으면 일본어는 "Dense" 으로 분류된다고 적혀있습니다.

그러나 Support Library에 Dense의 TextAppearance는 없습니다.

만듭시다.

```
<style name="TextAppearance.AppCompat.Body1.Dense" parent="TextAppearance.AppCompat.Body1">
    <item name="android:textSize">15sp</item>
</style>
```

xml의 전체는 [github](https://github.com/hiroyuki-seto/AndroidAdventCalendar2016/blob/master/app/src/main/res/values/text_appearances_dense.xml)를 봐주세요.

TextView에 이렇게 적용합니다

```
<TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:textAppearance="@style/TextAppearance.AppCompat.Body1.Dense" />
```

## NavigationDrawer item의 Background

[가이드라인의 Navigation Drawer](https://material.google.com/patterns/navigation-drawer.html)를 읽으면, 선택되지 않은 항목에 닿으면 Ripple Effect가 나오고, 선택한 항목은 회색 배경이 된듯한 일러스트가 있습니다.

Design Support Library의 [NavigationView](https://developer.android.com/reference/android/support/design/widget/NavigationView.html)를 사용하면 아무것도 안 하고도 실현할 수 있습니다만, 여러 가지 사정때문에 RecyclerView를 사용하여 커스터마이징하고 싶어했을 때에는 약간 불편합니다.

Item의 View에서 `android:background="?attr/selectableItemBackground"`으로 해봐도 선택 시 배경이 나오지 않고,
그렇다고 RippleEffect와 선택 색상을 맞춘 StateListDrawable 만들어도 머리 아픕니다.

그래서 LayerDrawable을 사용합니다.

```
TypedValue value = new TypedValue();
getContext().getTheme().resolveAttribute(R.attr.selectableItemBackground, value, true);
Drawable top = ContextCompat.getDrawable(getContext(), value.resourceId);
Drawable back = ContextCompat.getDrawable(getContext(), R.drawable.bg_checkable_list_item);
Drawable itemBackground = new LayerDrawable(new Drawable[]{back, top});
```
```
// R.drawable.bg_checkable_list_item
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/bgListItemChecked" android:state_checked="true" />
    <item android:drawable="@android:color/transparent" />
</selector>
```

이거라면 선택 색 부분의 StateListDrawable을 만들면 되네요.

덧붙여서 NavigationView는 ForegroundDrawable에 대응 한 LinearLayout을 구현하고 foreground에 `?attr/selectableItemBackground`, background에는 위와 같은 StateListDrawable을 설정했습니다. 게다가 StateListDrawable은 `?attr/colorControlHighlight`을 참조하기 위해서 Java로 억지로 만듭니다. 과연!

## Auto Loading

[가이드라인의 Progress & activity에 있는 Two-phased loads 같은 loading](https://material.google.com/components/progress-activity.html#progress-activity-behavior)을 구현하고 싶지만 RecyclerView라면 수수하며 성가시지 않나요.

Adapter에서 구현하려고하면 ListView의 [HeaderViewListAdapter](https://developer.android.com/reference/android/widget/HeaderViewListAdapter.html) 처럼 Adapter in Adapter 같은 구현이 되지 않을까 생각합니다만, 저는 그다지 확 와닿지않았습니다.

여기도 자체 ItemDecoration을 만들어 해결합시다!

어느 쪽이 올바르다기보다는 ItemDecoration의 한계에 도전하고 싶습니다.

구현을 요약하면,

- ItemDecoration + Drawable 애니메이션으로 해결
- 독자적인 ItemDecoration에 [Drawable.Callback](https://developer.android.com/reference/android/graphics/drawable/Drawable.Callback.html)을 구현
- Handler에는 RecyclerView를 사용

라는 것을 하고 있습니다. 자세한 구현은 [github](https://github.com/hiroyuki-seto/AndroidAdventCalendar2016)를 봐주세요.

덧붙여서 `RecyclerView#removeItemDecoration`을 제대로 부르지 않으면 메모리 누수가 됩니다!

## 마지막으로

ItemDecoration 최고! Drawable 최고!

Material Design의 구현에는 아직도 고통이 많습니다만, 온 힘을 다하여 구현해 사용자를 행복하게 해 나갑시다!