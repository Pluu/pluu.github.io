---
layout: post
title: "ViewBinding의 작은 변화"
date: 2020-01-19 20:40:00 +09:00
tag: [Android, ViewBinding]
categories:
- blog
- Android
---

## 서론

최근 ViewBinding의 스펙의 조금 바뀌었습니다. 

<!--more-->

ViewBinding이란 말을 처음 듣는 분도 계실듯해서 간단하게 소개합니다.

### ViewBinding이란?

먼저, 공식 문서로는 다음과 같이 설명합니다.

> View와 상호작용하는 코드를 쉽게 작성할 수 있습니다. ViewBinding은 각 XML 레이아웃 파일의 *바인딩 클래스*를 생성합니다. 바인딩 클래스의 인스턴스에는 상응하는 레이아웃에 ID가 있는 모든 뷰의 직접 참조가 포함됩니다.
>
> 대부분의 경우 뷰 바인딩이 `findViewById`를 대체합니다.

어디서 많이 들은 듯한 내용 아닌가요? DataBinding에서 View 접근에 대한 설명과 비슷하지 않나요?

네. 맞습니다. DataBinding에서 View에 Data를 Binding 하는 기능을 제외한 View의 접근만 가능한 기능이 바로 ViewBinding입니다.

## ViewBinding 사용

**1) ViewBinding 설정**

ViewBinding을 사용하기 위해서는 [Android 스튜디오 3.6 Canary 11 이상](https://developer.android.com/studio/preview) 에서 사용 가능합니다.

그리고, root의 `build.gradle` 에 아래 옵션을 추가합니다.

```groovy
android {
   ...
   viewBinding {
      enabled = true
   }
}
```

**2) XML 적용**

```xml
<!--result_profile.xml-->
<LinearLayout ... >
   <TextView android:id="@+id/name" />
   <ImageView android:cropToPadding="true" />
   <Button android:id="@+id/button" />
</LinearLayout>
```

DataBinding과 다르게 XML에서 \<layout> 태그를 사용하지 않아도 됩니다.

**3) Code**

```kotlin
private lateinit var binding: ResultProfileBinding

override fun onCreate(savedInstanceState: Bundle) {
    super.onCreate(savedInstanceState)
    binding = ResultProfileBinding.inflate(layoutInflater)
    val view = binding.root
    setContentView(view)
}
```

사용법 또한 DataBinding에서 알고 있는 사용법과 동일합니다.

## 본론, ViewBinding의 바뀐 점은?

ViewBinding은 DataBinding과 동일하게 Activity와 Fragment 및 View에서 사용할 수 있습니다. 

> DataBinding은 \<layout> 태그를 적용한 XML만 DataBinding이 적용됩니다. 
>
> 그리고, ViewBinding은 XML 파일에  `tools:viewBindingIgnore="true"` 을 사용하면 해당 XML의 바인딩 클래스가 생성되지 않습니다. 

최근 Fragment에서 ViewBinding 사용 방법이 변경되었습니다. build.gradle과 XML은 바뀌지 않았지만, code 부분이 바뀌었습니다.

### Code

```kotlin
private var _binding: ResultProfileBinding? = null
private val binding get() = _binding!!

override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
): View? {
    _binding = ResultProfileBinding.inflate(inflater, container, false)
    val view = binding.root
    return view
}

override fun onDestroyView() {
    _binding = null
}
```

가장 큰 변화는 `onDestroyView` 에서 Binding Class에 null을 적용하는 부분입니다.

```kotlin
override fun onDestroyView() {
    _binding = null
}
```

먼저, 공식 문서상 아래와 같이 이야기하고 있습니다.

> Fragments outlive their views. Make sure you clean up any references to the binding class instance in the fragment's [`onDestroyView()`](https://developer.android.com/reference/kotlin/androidx/fragment/app/Fragment#ondestroyview) method.

이 부분은 조금만 생각하면 이해되는 부분입니다. Activity와 다르게 Fragment에는 2개의 Lifecycle이 존재합니다. 바로 Fragment Lifecycle과 Fragment View Lifecycle이 달라져서 생기는 문제입니다. 기본적으로 Fragment는 Fragment가 가지는 View보다 오래 유지됩니다.

게다가 ViewBinding은 DataBinding과 다르게 Lifecycle을 모릅니다. 그로 인해 각 Binding의 객체를 적절히 메모리에서 초기화 작업을 해야 합니다. 그러나, 명시적으로 초기화 작업을 하지 않음으로서 `Memory Leak`이 발생합니다. 

## 결론

ViewBinding은 아직 Android Studio 안정판에서 사용되는 기능이 아니므로 좀 더 지켜봐야 하는 이슈도 존재합니다. 지금까지 `findViewById`의 대용으로 ButterKnife, Kotlin Android Extensions ViewBinding, DataBinding 등이 사용되었습니다. 

개인적으로 Android Developers 에서 언급하는 View Binding으로 ButterKnife, Kotlin Android Extensions ViewBinding에 대용이라고 생각합니다. `findViewById`의 귀찮음과 안전하게 View에 접근 시에 적합합니다.

해당 내용에 대한 자세한 내용은 Reddit에서 더 자세히 이야기되고 있습니다.

> Reddit ~ [View Binding docs updated with info on fragment usage](https://www.reddit.com/r/androiddev/comments/eo8rou/view_binding_docs_updated_with_info_on_fragment/)

해당 내용은 [AndroidDagashi 제103회](https://androiddagashi.github.io/issue/103-2020-01-19/)에서 공유된 내용을 시작으로 작성했습니다.