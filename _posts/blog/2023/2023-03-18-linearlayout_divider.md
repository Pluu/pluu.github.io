---
layout: post
title: "[메모] LinearLayout에 Divider 표시"
date: 2023-03-18 22:45:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

## 기본적인 Divider 노출

LinearLayout의 아이템 간에 Divider 노출에 아래 속성을 사용할 수 있다.

- divider
- showDividers
- dividerPadding

```xml
<LinearLayout
  android:divider="..."
  android:showDividers="..."
  android:dividerPadding="...">
  ...
</LinearLayout>
```

```xml
<resources>
  <declare-styleable name="LinearLayout">
    ...
    <!-- 아이템 사이의 Divider로 사용할 수 있는 그리기 -->
    <attr name="divider" />
    <!-- 표시할 Divider 설정 -->
    <attr name="showDividers">
      <flag name="none" value="0" />
      <flag name="beginning" value="1" />
      <flag name="middle" value="2" />
      <flag name="end" value="4" />
    </attr>
    <!-- Divider의 양쪽 끝에 있는 패딩 크기 -->
    <attr name="dividerPadding" format="dimension" />
  </declare-styleable>
</resources>
```

> 소스 출처 : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/res/res/values/attrs.xml;l=4663-4673

## 한쪽 방향에만 Padding 반영하기

```xml
<LinearLayout
  android:divider="@drawable/shape_with_left_padding"
  android:showDividers="...">
  ...
</LinearLayout>
```

```xml
<!-- shape_with_left_padding.xml -->
<?xml version="1.0" encoding="utf-8"?>
<inset xmlns:android="http://schemas.android.com/apk/res/android"
  android:insetLeft="...">
  <shape android:shape="rectangle">
    ...
  </shape>
</inset>
```

## 적용 모습

{% include img_assets.html id="/blog/2023/0318-linearlayout_divider/001.png" %}