---
layout: post
title: "[번역] RecyclerView에 도입된 ItemPrefetch로 렌더링 퍼포민스를 향상시키자 "
date: 2016-11-26 23:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [RecyclerViewに導入されたItemPrefetchで描画パフォーマンス向上させる](http://qiita.com/tomoima525/items/8855778d3052f964b4f4) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

support-library 25.0.0 이후부터 RecyclerView의 렌더링 퍼포먼스를 향상시키는 ItemPrefetch라는 기능이 추가되어 있습니다.

## ItemPrefetch란

RecyclerView에서는 아래와 같은 처리가 이루어지고 있습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/39433/d0e66fd0-e4d5-ac16-79e4-c092c025d1f0.png" />

UIThread에서 View의 inflation 및 bind/Animation 등 처리

↓

GPU RenderThread에서 렌더링

GPU RenderThread에 넘어온 사이, UIThread는 idle 상태에 들어갑니다.

여기에서 문제가 되는 것은, 스크롤시 새로운 View를 inflate가 필요한 경우, UIThread에서 그 처리됨으로 렌더링 지연의 원인이 되는 것입니다.

25.0.0부터 ItemPrefetch가 활성화됨으로 다음 View의 inflation이 필요한지 여부를 판단하고 **필요한 경우 RenderThread에서 렌더링하는 동안 다음 inflation의 준비를 할 수 있게 되어 부드러운 렌더링이 가능합니다.** 

ItemPrefetch가 활성화되는 조건으로는

- support library가 25이상
- Lollipop이상의 단말

입니다. 위의 조건을 충족하는 경우 기본적으로 활성화됩니다. 이 처리는 ViewCache 메모리를 추가로 소비하는 부작용이 있기 때문에 OFF 할 수 있습니다. 이 경우 `LayoutManager.setItemPrefetchEnabled()`를 호출하고 false를 설정합니다.

자세한 내용은 Docs를 참조하십시오.
[https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#setItemPrefetchEnabled(boolean)](https://developer.android.com/reference/android/support/v7/widget/RecyclerView.LayoutManager.html#setItemPrefetchEnabled(boolean))

## 실제로 어떻게 처리가 바뀌어 있는지

수중에 RecyclerView를 사용한 리스트를 준비하고 Android Monitor에 포함된 퍼포먼스 측정 도구인 [SysTrace](https://developer.android.com/studio/profile/systrace.html)에서 확인했습니다.

### ItemPrefetch가 비활성화인 경우

<img src="https://qiita-image-store.s3.amazonaws.com/0/39433/4601a259-297f-463a-ef66-1b1f6452545b.png"/>

빨간색으로 표시된 부분에서 알 수 있듯이, View의 inflation이 무거우므로 처리에 시간이 걸려있습니다. 노란색 F는 Delay가 있다는 것을 경고하고 있습니다 (딴 곳은 5ms인 결과, 이곳은 약 10ms이 걸려있습니다)

### ItemPrefetch가 활성화인 경우

<img src="https://qiita-image-store.s3.amazonaws.com/0/39433/b30edf0d-4ce0-5144-5624-78b62e7c665b.png"/>

빨간색 부분에서 알 수 있듯이 RenderThread에서 렌더링 처리를 하는 중에 UIThread에서는 다음 View를 inflation하고 있습니다. 

## 정리

별도로 특별한 것을 하지 않고도 RecyclerView를 Support Library 25.0.0 이상으로 올리면 자동적으로 ItemPrefetch가 적용됩니다. 하지만 25.0.0은 버그가 있으므로 특별히 제약이 없는 한 버그픽스가 포함된 25.0.1로 올리는 것을 추천합니다.