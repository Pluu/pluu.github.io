---
layout: post
title: "Android StatusBar 색상 변경"
date: 2015-11-20 23:50:00
tag: [Android, StatusBar]
categories:
- blog
- Android
---

앱 제작시 다양한 테마를 적용해서 StatusBar 를 바꾸는 방법이 있습니다.

<!--more-->

`style.xml`를 수정하는 방법은 앱 전체 테마에 고정적으로 적용되며,

`Code`로 적용한다면 앱의 컨텐츠에 맞게 변경도 가능합니다.

## Theme Style


```xml
<style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
	<item name="colorPrimaryDark">@color/colorPrimaryDark</item>
</style>
```

## Code


```java
public static void setStatusBarColor(Activity activity, int color) {
	if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
		Window window = activity.getWindow();
		window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
		window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
		window.setStatusBarColor(color);
	}
}
```

적용 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-19-01.jpg" }}" />
<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-19-02.jpg" }}" />
