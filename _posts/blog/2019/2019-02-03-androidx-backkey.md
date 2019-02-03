---
layout: post
title: "AndroidX에서 Back Key 제어"
date: 2019-02-03 20:50:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

### AndroidX 이전

지금까지 Back Key 제어라고 하면 예를 들어 아래와 같이 `Activity#onBackPressed()` 로 했습니다

```kotlin
override fun onBackPressed() {
	// Back Key 이벤트로 Fragment에서 무언가를 하고 싶을 때
    val fragment = supportFragmentManager.findFragmentByTag("HogeFragment")
    fragment?.something()

    // Stack에 쌓인 Fragment를 1개 전으로 돌리고 싶을 때
    if (supportFragmentManager.backStackEntryCount > 0) {
        supportFragmentManager.popBackStack()
    } else {
        super.onBackPressed()
    }
```

BackStack은 아직 괜찮지만, Fragment측의 처리를 호출하고 싶을 때 등은 Activity에 특정 Fragment의 의존이 들어가버려, 아쉬웠습니다.

### AndroidX 이후

AndroidX에서 제공하는 Activity에는 Version 1.0.0-alpha01에서 `Activity#addOnBackPressedCallback()` 라는 메소드가 추가되었고 `OnBackPressedCallback` 인터페이스를 통해 Back Key 이벤트를 받을 수 있게 되었습니다.

즉 Fragment 내부에서 Back Key 제어 로직을 넣을 수 있다는 것입니다. 개인적으로는 최고입니다.

[Activity ~ Android Developers](https://developer.android.com/jetpack/androidx/releases/activity?hl=ja#1.0.0-alpha01)

이와 같은 형태로 작성할 수 있습니다.

```kotlin
...
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment
...

class MyFragment : Fragment() {

    private val callback = object : OnBackPressedCallback {
        override fun handleOnBackPressed(): Boolean {
            return if (isHoge) {
                something()
                true
            } else {
                false
            }
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        activity?.addOnBackPressedCallback(callback)
        ...
    }

    override fun onDestroy() {
        super.onDestroy()
        activity?.removeOnBackPressedCallback(callback)
    }
```

이것만으로도 기쁘지만, Reference를 보면 Architecture Component의 Lifecycle에도 대응하고 있습니다.

[ComponentActivity ~ Android Developers](https://developer.android.com/reference/androidx/activity/ComponentActivity.html?hl=ja#addOnBackPressedCallback(androidx.lifecycle.LifecycleOwner,%20androidx.activity.OnBackPressedCallback))

즉, 위의 샘플 코드는 아래와 같은 작성할 수 있습니다.

```kotlin
...
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment
...

class MyFragment : Fragment() {

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        activity?.addOnBackPressedCallback(this, object : OnBackPressedCallback {
            override fun handleOnBackPressed(): Boolean {
                return if (isHoge) {
                    something()
                    true
                } else {
                    false
                }
            }
        })
        ...
    }
```

이걸로 add한 callback의 개방을 신경 쓸 필요가 없어졌습니다. 코드량도 적어지고 읽기 쉽습니다. (OnBackPressedCallback 은 Java로 구현되어 SAM 변환도 가능하고 실제로는 더욱 코드량을 줄일 수 있습니다.)

이것을 발견했을 때 AndroidX로 옮겨서 좋았다고 마음속으로 생각했습니다. AndroidX 최고입니다.