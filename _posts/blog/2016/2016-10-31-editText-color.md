---
layout: post
title: "[번역] EditText 색 변경항목 정리"
date: 2016-10-31 22:15:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [EditTextの色変更箇所まとめ
](http://qiita.com/konifar/items/47d467e3574c9228fdc8) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

EditText의 밑줄이나 커서 색상 등, 어떻게 지정해야 하는가 매번 잊어버리니 메모해둡니다.

### 정리

| 변경항목 | 지정항목 | 설명 |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/076331ba-20b4-71fa-15f7-204d9f00f42e.png"/> | colorControlActivated | 손끝으로 터치되어 있는 부분. text selection handle라고 부른다고 한다 |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/6c2a78ed-44a9-ff37-b63c-b84a74ef7c6e.png"/> | colorControlNormal | 포커스 되어있지 않은 경우의 밑줄 부분 |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/c0cb3c9a-103e-94b1-07b5-3310d3670a07.png"/> | colorControlActivated | 포커스시의 밑줄 부분. Tint 되어있어 지정한 색보다 약간 투명이 적용되어있고, 길게 누르면 지정한 색이된다. |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/b75ed54e-dfec-04c2-4bdf-eef03170e917.png"/> | android:textColorHighlight | 텍스트 선택색 |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/4d0ff221-1804-bfa4-5476-ec454344108d.png"/> | android:textColorHint | 입력전의 Hint (포커스 Holder) |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/8953d22d-a053-6836-819b-0ee7b008c9fa.png"/> | android:textColor | 텍스트 색 |
| <img src="https://qiita-image-store.s3.amazonaws.com/0/15267/83bbfc6f-ef8b-e0e6-a3e1-8541a4017ae4.png"/> | android:textCursorDrawable | 커서 색. drawable 지정되지만, 색을 설정하는것도 된다 |

### 코드

레이아웃 xml의 EditText는 이런 모습입니다. AppCompatEditText를 사용하고 있지만, EditText라도 같습니다.

`style`과 `app:theme` 둘 다 지정하는 것은, `style`만으로는 `colorControlNormal`과 `colorControlActivated`의 적용이 되지않기때문입니다.

이 부근은 내부 코드를 읽어보지 않았지만, Activity나 Application으로 지정한 테마의 스타일이 적용됩니다.

```
// activity_main.xml
<android.support.v7.widget.AppCompatEditText
    android:id="@+id/edit_text"
    style="@style/EditTextStyle"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:hint="ヒント"
    app:theme="@style/EditTextStyle" />
```

style.xml은 이런 모습입니다. 덧붙여서 `android:~`의 attributes는 style이 아니고 직접 레이아웃에 지정해도 적용되지만, `colorControl~`의 attributes는 적용되지 않습니다.

```
// styles.xml
<style name="EditTextStyle" parent="Widget.AppCompat.EditText">
    <item name="colorControlNormal">@color/amber500</item>
    <item name="colorControlActivated">@color/pink500</item>
    <item name="android:textCursorDrawable">@color/indigo500</item>
    <item name="android:textColor">@color/orange500</item>
    <item name="android:textColorHint">@color/teal500</item>
    <item name="android:textColorHighlight">@color/purple500</item>
</style>
```

색상을 알기 쉽도록 style.xml를 캡쳐해서 붙입니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/15267/5c156e3e-14a2-7abe-c6bb-9016f4416606.png"/>

EditText 코드를 읽고 style이나 theme가 어떻게 적용되는가를 찾으면 좀 더 자세하게 알 수 있지만, 우선 이걸로 대부분 색은 변경 가능합니다.


- - -

### 댓글 이야기

`alzybaad` : [http://qiita.com/alzybaad](http://qiita.com/alzybaad)

- 이해하기 쉽게 되어있네요
- `colorControl〜` 부분은 `EditText`의 backgroundDrawable로 사용되어, API Level 21 이상에서는 아래의 XML입니다.

```
// edit_text_material.xml
<inset xmlns:android="http://schemas.android.com/apk/res/android"
  android:inset="@dimen/control_inset_material">
  <ripple android:color="?attr/colorControlActivated">
    <item>
      <selector>
        <item android:state_enabled="false">
          <nine-patch android:src="@drawable/textfield_default_mtrl_alpha"
            android:tint="?attr/colorControlNormal"
            android:alpha="?attr/disabledAlpha" />
        </item>
        <item>
          <nine-patch android:src="@drawable/textfield_default_mtrl_alpha"
            android:tint="?attr/colorControlNormal" />
        </item>
      </selector>
    </item>
    <item android:id="@+id/mask" android:drawable="@drawable/textfield_activated_mtrl_alpha" />
  </ripple>
</inset>
```

`View`의 backgroundDrawable를 로드시에는 그 `View`의 `style`이 사용되는 것이 아니라, `Activity` 등의 테마가 적용되어있어, `app:theme`를 지정하지 않으면 적용되지 않습니다.

```
// TypedArray#getDrawable
@Nullable
public Drawable getDrawable(int index) {
  if (mRecycled) {
    throw new RuntimeException("Cannot make calls to a recycled instance!");
  }

  final TypedValue value = mValue;
  if (getValueAt(index*AssetManager.STYLE_NUM_ENTRIES, value)) {
    if (value.type == TypedValue.TYPE_ATTRIBUTE) {
      throw new UnsupportedOperationException(
          "Failed to resolve attribute at index " + index + ": " + value);
    }
    return mResources.loadDrawable(value, value.resourceId, mTheme);
  }
  return null;
}
```

`app:theme`을 지정해야 적용되는 것은 `AppCompatViewInflater`에서, 그 테마를 적용한 `Context`를 `View`의 생성자에 지정되기 때문이지요.

```
// AppCompatViewInflater
public final View createView(View parent, final String name, @NonNull Context context,
    @NonNull AttributeSet attrs, boolean inheritContext,
    boolean readAndroidTheme, boolean readAppTheme) {
  ...
  if (readAndroidTheme || readAppTheme) {
    // We then apply the theme on the context, if specified
    context = themifyContext(context, attrs, readAndroidTheme, readAppTheme);
  }
  ...
    view = new AppCompatEditText(context, attrs);
  ...
}

private static Context themifyContext(Context context, AttributeSet attrs,
    boolean useAndroidTheme, boolean useAppTheme) {
  final TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.View, 0, 0);
  int themeId = 0;
  if (useAndroidTheme) {
    // First try reading android:theme if enabled
    themeId = a.getResourceId(R.styleable.View_android_theme, 0);
  }
  if (useAppTheme && themeId == 0) {
    // ...if that didn't work, try reading app:theme (for legacy reasons) if enabled
    themeId = a.getResourceId(R.styleable.View_theme, 0);

    if (themeId != 0) {
      Log.i(LOG_TAG, "app:theme is now deprecated. "
          + "Please move to using android:theme instead.");
    }
  }
  a.recycle();

  if (themeId != 0 && (!(context instanceof ContextThemeWrapper)
      || ((ContextThemeWrapper) context).getThemeResId() != themeId)) {
    // If the context isn't a ContextThemeWrapper, or it is but does not have
    // the same theme as we need, wrap it in a new wrapper
    context = new ContextThemeWrapper(context, themeId);
  }
  return context;
}
```
