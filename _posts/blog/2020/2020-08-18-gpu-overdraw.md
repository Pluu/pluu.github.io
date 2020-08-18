---
layout: post
title: "GPU Overdraw 1-draw 줄이기"
date: 2020-08-18 21:00:00 +09:00
tag: [Android, Performance]
categories:
- blog
- Android
---

여러분들이 만드신 앱이 사용자에게 전달하고 싶은 내용과 가치를 위해서 다양한 UI, UX, 색상을 사용합니다. 또한 다양한 정보 또한 중요한 앱의 품질 중 하나입니다. 수많은 정보를 간결하게 나타내는 것 또한 중요한 항목입니다. 그렇지 않는다면 리소스가 낭비된다는 것은 우리 모두 알고 있는 사실입니다. 서비스에 담당한 사람들뿐만 아니라 서버 비용 등, 사용자 모두가 다양한 형태로 짊어지게 됩니다.

지난 레이아웃 글에 이어서 본 글에서는 GPU로 그리는 수준을 1단계 줄이는 방법 중 하나를 소개합니다.

<!--more-->

------

아주 조금이라도 앱이 빠르다면 누군가는 행복할 겁니다.

## 간단한 Sample 화면

이번에 테스트할 내용은 아래와 같은 View입니다.

- Background 컬러는 흰색
- 노란색 Box
- 검은색 Text

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default.png" }}" width="200" />

위 화면을 XML로 간단하게 구현한다면 아래와 같이 작성할 수 있습니다. 다양한 방식은 존재하지만, 이번 예제에서는 아래의 코드를 기반으로 진행합니다.

```xml
<androidx.constraintlayout.widget.ConstraintLayout 
		...
    android:background="@android:color/white">
    <TextView
        ...
        android:background="#FFB300"
        android:padding="20dp"
        android:text="@string/app_name"
        android:textColor="@color/black"
        ... />
</androidx.constraintlayout.widget.ConstraintLayout>
```

특별한 문제가 없으므로 대부분은 위 화면에 문제점을 느끼지 못하실 겁니다.

이어서 GPU 관련 항목을 이야기하겠습니다.

## GPU Overdraw 체크

먼저 GPU Overdraw에 대해서 살펴보겠습니다. 

UI는 시각적인 정보를 보여주는 수단입니다. UI의 결과물로는 동일하지만 실제로 다양한 형태로 구성될 수 있습니다. 이때 같은 프레임 내에서 `두 번 이상 같은 픽셀을 그릴 때` Overdraw가 발생합니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/overdraw.png" }}" />

> 출처 : Android Performance Patterns: Understanding Overdraw https://youtu.be/T52v50r-JfE

------

### Overdraw Debugging

Android에서 Overdraw를 체크하는 방법은 다음과 같습니다.

1. 기기에서 **설정**으로 이동하여 **개발자 옵션**을 탭합니다.
2. **하드웨어 가속 렌더링** 섹션으로 스크롤하여 **GPU 오버드로 디버그**를 선택합니다.
3. **GPU 오버드로 디버그** 대화상자에서 **오버드로 영역 표시**를 선택합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/gpu_overdraw.png" }}" width="200" />

### GPU Overdraw

GPU Overdraw 디버깅에서는 UI 요소에 색상을 표현하여 Overdraw 횟수를 나타냅니다.

<table>
  <tr>
    <th>Color</th>
    <th>Overdraw Count</th>
  </tr>
	<tr>
    <td>투명색</td>
    <td>0회</td>
  </tr>
  <tr>
    <td bgcolor="#d0d0ff">Blue</td>
    <td>1회</td>
  </tr>
  <tr>
    <td bgcolor="#cffecf">Green</td>
    <td>2회</td>
  </tr>
  <tr>
    <td bgcolor="#ffbfbe">Pink</td>
    <td>3회</td>
  </tr>
  <tr>
    <td bgcolor="#ff807e">Red</td>
    <td>4회</td>
  </tr>
</table>

> 출처 : https://developer.android.com/topic/performance/rendering/inspect-gpu-rendering#debug_overdraw

Sample 화면을 GPU Overdraw 디버깅 결과는 이어서 확인해보겠습니다.

## Overdraw 체크

먼저, GPU Overdraw 디버깅 결과를 살펴봅니다. 

|                           Default                            |                       GPU Overdraw ON                        |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default_overdraw.png" }}" /> |

GPU Overdraw 디버깅을 활성화했을 때 전체적으로 Overdraw 된 모습을 확인할 수 있습니다. 어떻게 Overdraw가 되었는지 확인하는 방법은 다양하지만, Android Studio 4.0 이상에서 사용할 수 있는 `Layout Inspector`를 사용하면 더 간단하게 확인할 수 있습니다.

### Layout Inspector

Layout Inspector로 확인한 결과는 아래와 같습니다. 여기에서 Sample 화면에 Overdraw가 발생하는 이유를 확인할 수 있습니다. Sample에서 지정한 Activity의 흰색 배경보다 더 아래의 View에서 흰색이 그려지고 있습니다. 그래서 GPU Overdraw가 되고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default_layout_inspector_decor_view_0.png" }}" />

> Layout Inspector 결과

실제 흰색이 그려지는 부분을 다시 한번 체크해보겠습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default_layout_inspector_decor_view.png" }}" />

> DecorView에서 흰색이 그려지고 있는 모습

`Layout Inspector`에서 확인한 결과로는 `DecorView`에서 흰색이 그려지고 있습니다.

여기서 확인할 사항이 바로 `DecorView`입니다. Android를 개발하신 분이라면 한 번쯤은 봤을 View입니다.

### DecorView

Activity는 기본적으로 고유 Window를 가지며, 이 Window에서 Root Layout을 생성하는데 이것이 DecorView입니다. 이후 DecorView의 자식 뷰로 Activity#setContentView로 View 혹은 Layout Resource Id의 구현체가 추가됩니다.

> DecorView : https://android.googlesource.com/platform/frameworks/base.git/+/master/core/java/com/android/internal/policy/DecorView.java

> PhoneWindow#setContentView : https://android.googlesource.com/platform/frameworks/base.git/+/master/core/java/com/android/internal/policy/PhoneWindow.java#423

## 1-overdraw 해결

이후에서는 Overdraw가 발생하는 `1-draw`를 제거하는 방법을 확인해보겠습니다.

### Try 1. Activity Background 제거

첫 번째 방법은 매우 간단합니다. Activity에 지정한 Background를 제거하는 방법입니다. Activity에서 불러들일 XML의 Root에서 지정한 android:background 코드를 제거합니다. 

```xml
<androidx.constraintlayout.widget.ConstraintLayout 
    ...
    android:background="@android:color/white"> // <!-- background 제거 -->
    <TextView
        ...
        android:background="#FFB300"
        android:padding="20dp"
        android:text="@string/app_name"
        android:textColor="@color/black"
        ... />
</androidx.constraintlayout.widget.ConstraintLayout>
```

그 후, Layout Inspector를 통해서 결과를 확인해보겠습니다.

|                          DecorView                           |                     Activity Background                      |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/transparent_layout_inspector_root.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/transparent_layout_inspector_root2.png" }}" /> |

이 방법으로는 DecorView에만 흰색 컬러가 지정되어 있고, Activity의 Background에 별도의 색이 지정되어 있지 않아서 아무것도 렌더링하지 않습니다.

### Try 2. DecorView의 Background 제거

두 번째는 Activity의 Background로 흰색은 유지한 채 DecorView에서 Background Color를 제거하는 방법입니다.

```xml
<resources ...>
    <style name="AppTheme" parent="...">
        ...
        <item name="android:windowBackground">@android:color/transparent</item>
    </style>
</resources>
```

Theme의 android:windowBackground가 렌더링되지 않도록 windowBackground 값을 수정합니다. 그 후, Layout Inspector를 통해서 결과를 확인해보겠습니다.

|                          DecorView                           |                     Activity Background                      |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/transparent_layout_inspector_decor_view.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/transparent_layout_inspector_decor_view2.png" }}" /> |

원하는 DecorView에 아무것도 렌더링되지 않았습니다.

#### android:windowBackground 가 호출되는 곳

Theme에서 지정한 `android:windowBackground` 값은 PhoneWindow에서 사용됩니다. PhoneWindow은 Window 추상 클래스의 구현체입니다.

```java
public class PhoneWindow extends Window implements MenuBuilder.Callback {
  ...
  if (a.hasValue(R.styleable.Window_windowBackground)) {
    mBackgroundDrawable = a.getDrawable(R.styleable.Window_windowBackground);
  }
  ...
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/base.git/+/master/core/java/com/android/internal/policy/PhoneWindow.java#2549

## Summary

지금까지 Overdraw가 발생하는 이슈를 2가지의 형태로 수정하는 방법을 살펴봤습니다. 2가지 모두 Overdraw가 수정된 결과로 동일한 Overdraw 표현을 확인할 수 있습니다.

> 실제로 2가지 형태는 여러 곳에서 다른 결과를 노출할 수 있지만 본 글에서는 Overdraw에 대한 해결 방법으로만 다뤘습니다. 

|                          초기 형태                           |                    Overdraw가 수정된 상태                    |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/default_overdraw.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0818-gpu-overdraw/transparent.png" }}" /> |

 `Background` 개선으로 GPU Overdraw가 `1-draw` 해결되었습니다.

------

오늘 소개한 내용은 Android Developers의 `Reduce overdraw`에도 나열되어 있습니다. GPU가 렌더링하는 패턴을 확인하여 최적화함으로써 앱의 렌더링 성능을 빠르게 하는 방법 중 하나입니다.

> 레이아웃에서 불필요한 배경 제거 : https://developer.android.com/topic/performance/rendering/overdraw#rubil

본 글에서 설명한 내용 이외에도 위 사이트에서 Overdraw를 해결하는 방법으로 아래와 같이 설명합니다.

- 레이아웃에서 불필요한 배경 삭제
- 뷰 계층 구조의 평면화
- 투명도 감소

### 추천 영상

<iframe width="560" height="315" src="https://www.youtube.com/embed/T52v50r-JfE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## 참고

- Android Developers Blog ~ [Window Backgrounds & UI Speed](https://android-developers.googleblog.com/2009/03/window-backgrounds-ui-speed.html)
- Android Developers \| Docs \| Guides ~ [Inspect GPU rendering speed and overdraw](https://developer.android.com/topic/performance/rendering/inspect-gpu-rendering#debug_overdraw)
- Android Developers \| Docs \| Guides ~ [Reduce overdraw](https://developer.android.com/topic/performance/rendering/overdraw)
