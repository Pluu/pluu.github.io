---
layout: post
title: "[번역] Toolbar에 13줄로 SearchView을 구현한다"
date: 2015-05-19 00:30:00
tag: [Android, SupportLibrary, ToolBar, SearchView]
categories:
- blog
- Android
---

이 포스팅은 [Toolbar に 13行で SearchView を実装する](http://qiita.com/suzukihr/items/9042ae3416ed5ae1cca2) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

### 이미지

- - -

이런거 입니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/39324/7c3f7573-623a-6363-f539-abaa3ce7ebd3.png" />

ActionBar 에도 같은 요령으로 대응가능하다고 생각합니다.

### Code & XML

- - -

onQueryTextSubmit, onQueryTextChange 설명은 이쪽

[http://developer.android.com/reference/android/support/v7/widget/SearchView.OnQueryTextListener.html](http://developer.android.com/reference/android/support/v7/widget/SearchView.OnQueryTextListener.html)


```java
Toolbar toolbar = (Toolbar) view.findViewById(R.id.toolbar);
toolbar.inflateMenu(R.menu.search);

mSearchView = (SearchView) toolbar.getMenu().findItem(R.id.menu_search).getActionView();
mSearchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
    @Override
    public boolean onQueryTextSubmit(String s) {
        return false;
    }
    @Override
    public boolean onQueryTextChange(String s) {
        return false;
    }
});
```


```xml
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    <item
        android:id="@+id/menu_search"
        android:icon="@drawable/ic_menu_search"
        android:title="@string/menu_search"
        app:actionViewClass="android.support.v7.widget.SearchView"
        app:showAsAction="always" />
</menu>
```

### 보충설명

- - -

#### 메뉴를 프로그램으로 작성


```java
Menu menu = toolbar.getMenu();
MenuItem item = menu.add("検索");
item.setIcon(R.drawable.ic_menu_search);
item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
item.setActionView(mSearchView);
```

#### SearchView 를 알린 상태로 한다

[http://developer.android.com/reference/android/widget/SearchView.html#setIconified(boolean)](http://developer.android.com/reference/android/widget/SearchView.html#setIconified(boolean))


```java
mSearchView.setIconfied(false);
```

#### SearchView 에서 포커스를 제거하기（소프트웨어 키보드를 닫기）

[http://developer.android.com/reference/android/view/ViewGroup.html#clearFocus()](http://developer.android.com/reference/android/view/ViewGroup.html#clearFocus())


```java
mSearchView.clearFocus();
```

#### QueryHint를 표시

[http://developer.android.com/reference/android/widget/SearchView.html#setQueryHint(java.lang.CharSequence)](http://developer.android.com/reference/android/widget/SearchView.html#setQueryHint(java.lang.CharSequence))

mSearchView.setQueryHint("Hint");

#### SearchView 를 커스터마이징하기

페이지 하단의 SearchView Widget 쪽

[http://android-developers.blogspot.jp/2014/10/appcompat-v21-material-design-for-pre.html](http://android-developers.blogspot.jp/2014/10/appcompat-v21-material-design-for-pre.html)
