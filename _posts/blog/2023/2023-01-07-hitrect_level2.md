---
layout: post
title: "TouchDelegate/HitRect ~ 제한된 범위로 터치 이벤트 만들기"
date: 2023-01-07 22:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

지난, TouchDelegate를 활용하여 실제 영역보다 더 큰 영역으로 확장하며 터치 이벤트를 처리하는 방법을 소개했습니다.

<!--more-->

> [[삽질] 버튼의 클릭 터치 영역 커스텀 해보기](http://pluu.github.io/blog/android/2022/09/04/hitrect/)

일반적으로 단순 클릭 처리라면 기본적인 TouchDelegate를 사용하더라도 대부분은 문제없습니다. 그래도 터치 이동(=ACTION_MOVE) 처리 등 좀 더 자신의 입맛에 맞는 형태로 사용하고 싶다면 결국 커스텀 TouchDelegate가 필요합니다.

이번 글에서는 기본으로 해결 안 되는 간단한 사례를 소개한 후 해결법을 소개합니다.

------

이번 글에서 사용한 샘플 코드 링크는 아래와 같습니다.

> 샘플 코드 : https://github.com/Pluu/HitRectWithActualBoundsSample

------

테스트 조건

- SampleView를 사용해서 터치 영역을 확장
- 30dp만큼 영역을 확장하여 TouchDelegate에 영역을 전달 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0107-hitrect/001.png" }}" />

## 터치 이벤트 좌표 이상 현상

{% include youtube.html id="qw71ZbrG6B0" %}

영상에서는 onTouchEvent로 넘겨온 터치 좌표를 빨간 원으로 표시하고 있습니다.

그리고, 문제의 커스텀 뷰(=SampleView)에서 30dp 확장한 영역을 클릭하면 전혀 다른 곳인 `SampleView의 가운데로 터치 좌표`가 들어오는 것을 알 수 있습니다.

상세하게는 부모에 적용된 TouchDelegate에서 확장된 영역 부분을 터치하면 delegateView인 SampleView의 onTouchEvent가 호출됩니다.

### 원인 살펴보기

**SampleView의 가운데로 터치 좌표**로 오는 이유를 살펴보겠습니다.

아래 코드를 살펴보면, TouchDelegate 클래스에서 DelegateView로 이벤트를 전달하는 케이스를 이상 동작의 원인입니다.

[MotionEvent#setLocation](https://developer.android.com/reference/android/view/MotionEvent#setLocation(float,%20float)) 함수를 사용해서 이벤트 위치를 보정하는데, DelegateView 뷰 크기의 가운데 지점을 기준으로 보정하고 있습니다.

```java
public class TouchDelegate {
  public boolean onTouchEvent(@NonNull MotionEvent event) {
    ...
    if (sendToDelegate) {
      if (hit) {
        // Offset event coordinates to be inside the target view
        event.setLocation(mDelegateView.getWidth() / 2, mDelegateView.getHeight() / 2);
      } else {
        // Offset event coordinates to be outside the target view (in case it does
        // something like tracking pressed state)
        int slop = mSlop;
        event.setLocation(-(slop * 2), -(slop * 2));
      }
      handled = mDelegateView.dispatchTouchEvent(event);
    }
    return handled;
  }
}
```

> 원본 출처 : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/view/TouchDelegate.java;l=144

대부분일 위와 같이 가운데 좌표로 이벤트가 오더라도 문제없을 것입니다.

### 지정한 영역 안으로 터치가 유입되도록 하기

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0107-hitrect/002.png" }}" />

우리가 할 일은 SampleView에서 확장한 영역으로 들어오는 이벤트를 SampleView의 Bounds로 가두는 것입니다. 

- 빨간색 : SampleView의 Bounds
- 주황색 : TouchDelegate로 확장한 영역 (30dp)
- 노란색 : Parent View

먼저 언급한 내용을 적용한 모습을 보겠습니다.

{% include youtube.html id="2-ApwbDh_M4" %}

#### TouchDelegate를 확장한 ActualBoundsTouchDelegate

여기에서는 간단한 해결법으로는 TouchDelegate을 상속하면서 x/y 좌표를 원하는 영역으로 보정하는 방법을 사용해볼 수 있습니다.

```kotlin
class ActualBoundsTouchDelegate(
  private val targetBounds: Rect,
  private val actualBounds: Rect, // 실제 Bounds로 계산할 Rect
  private val delegateView: View
) : TouchDelegate(targetBounds, delegateView) {
  private var isDelegateTargeted = false

  override fun onTouchEvent(event: MotionEvent): Boolean {
    ...
    if (sendToDelegate) {
      if (hit && !actualBounds.contains(x, y)) {
        // Hit한 좌표가 actualBounds 범위 밖이면 보정 처리
        event.setLocation(
          if (x < actualBounds.left) 0f
          else if (actualBounds.right < x) actualBounds.width().toFloat()
          else (x - actualBounds.left).toFloat(),
          if (y < actualBounds.top) 0f
          else if (actualBounds.bottom < y) actualBounds.height().toFloat()
          else (y - actualBounds.top).toFloat()
        )
      } else {
        ...
      }
      handled = delegateView.dispatchTouchEvent(event)
    }
    return handled
  }
}
```

기본 TouchDelegate는 x/y 좌표를 DelegateView 크기의 가운데 영역으로 좌표 보정을 했습니다. ActualBoundsTouchDelegate에서는 `별도 영역(=actualBounds) 기준으로 좌표를 보정`하면 됩니다.

위 코드만 보더라도 x/y 좌표 모두 약간(?)의 보정만 하면 되므로 큰 어렵지는 않을 것입니다.

- - -

위 사례는 기본 터치 이벤트를 받아서 커스텀으로 터치 처리하면서 TouchDelegate가 필요한 경우와 같이 매우 한정된 사례에서만 사용되겠지만, 필요한 분에게 도움이 되셨으면 좋겠습니다.