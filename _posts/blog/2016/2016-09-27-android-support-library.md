---
layout: post
title: "Android Support Library 24.2.0의 버그"
date: 2016-09-27 23:50:00 +09:00
tag: [Android, SupportLibrary]
categories:
- blog
- Android
---

얼마전 회사에서 개발하면서 Android Support Library를 `24.2.0`으로 올렸을때의 버그에 대해서 이야기이다.

결론부터 말하자면 `24.2.1`에 고쳐졌다.

<!--more-->

## 원하던 결과 (24.2.0 이외)

야놀자의 바로예약에서는 여러가지 3rd party Library를 사용하는데, 그중 Android Support Library도 당연히 쓰고있다.

먼저 원하던 화면을 먼저 보자.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-09-28-device-2016-09-27-225652.png" }}" />

화면 구성은 우리앱뿐만 아니라 다른 많은곳에서 쓰이고 있으며, 레이아웃 구조는 다음과 같다.

```
<android.support.design.widget.CoordinatorLayout
   android:fitsSystemWindows="true"
   >
   <android.support.design.widget.AppBarLayout
       android:fitsSystemWindows="true"
       >
       <android.support.design.widget.CollapsingToolbarLayout
          android:fitsSystemWindows="true"
          app:layout_scrollFlags="scroll|exitUntilCollapsed"
          >

          <include ... />

          <android.support.v7.widget.Toolbar
              app:layout_collapseMode="pin"
              app:layout_scrollFlags="scroll|enterAlways"
              />

       </android.support.design.widget.CollapsingToolbarLayout>
    </android.support.design.widget.AppBarLayout>

    <!-- Content -->
</android.support.design.widget.CoordinatorLayout>
``` 

단순한 구조만을 표현하기 위해서 간략하게 표시했다.

include가 되는 레이아웃은 다음과 같은 XML 구조이다

```
<RelativeLayout
   app:layout_collapseMode="parallax"
   app:layout_scrollFlags="scroll|enterAlways|enterAlwaysCollapsed"
   >
   <android.support.v4.view.ViewPager/>
   <ImageView/>
   ...   
</RelativeLayout>
```

스크롤을 하는 경우 `CollapsingToolbarLayout` 내부의 데이터들은 각각 `layout_collapseMode`와 `layout_scrollFlags`에 따라서 화면 렌딩이 되며 `fitsSystemWindows`의 값에 따라 `StatusBar`까지 꽉채운 화면을 구성한다.

## 24.2.0

하지만, `24.2.0`에서는 다음과 같이 적용된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-09-28-device-2016-09-27-233129.png" }}" />

웹페이지 배경이 흰색이라서 별 차이 없으리라 생각하지만, 다른 사소한것들은 제쳐두고 가장 뚜렷하게 차이나는것이 `StatusBar`이다.

| 24.2.0 | 24.2.1 |
| :--: | :--: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-09-28-24-2-0.gif" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2016/2016-09-28-24-2-1.gif" }}" /> |

StatusBar 부근이 확연히 차이나는 것을 알수 있다

위 내용은 `24.2.1`에 수정이 되었다.

## Android Support Library, revision 24.2.1 (September 2016)

Fixed issues:

Image inside [CollapsingToolbarLayout](https://developer.android.com/reference/android/support/design/widget/CollapsingToolbarLayout.html) doesn’t scale properly with fitsSystemWindows=true. (AOSP issue [220389](https://code.google.com/p/android/issues/detail?id=220389))
