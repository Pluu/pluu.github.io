---
layout: post
title: "Fragment의 Show/Hide와 함께 Lifecycle 레벨업"
date: 2023-01-20 01:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

Android를 개발해 본 사람이라면 Fragment 다루는 것은 복잡하다는 것은 흔한 이야기입니다.

<!--more-->

그중 하나가 생명주기 관련 처리입니다. 

Fragment의 생명주기는 Activity와 다른 것도 이제는 많이 알려진 내용입니다.

> Fragment 생명주기에 대해서 자세한 내용을 알고 싶다면 아랫글을 추천합니다.
>
> - [The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)

Fragment를 화면에 노출/숨기는 용도로 Add/Replace/Remove/Show/Hide API가 있지만, 본 글에서는 Fragment의 `Show/Hide` 시의 생명주기 개선 방법을 소개해보려 합니다.

------

포스팅에서 소개한 샘플 소스

- https://github.com/Pluu/MaxLifecycleSample

------

## [서론] Fragment의 Show/Hide

### replace의 생명 주기

많은 경우의 Fragment를 Activity에 노출/교체하는 용도로 흔히 replace가 사용됩니다. 이 경우의 생명주기는 아래와 같습니다.

```kotlin
fun FragmentManager.showWithLifecycle(...) {
  commit {
    replace(...)
  }
}
```

```
MenuFragment(220365616) [key=Menu1] Attached
MenuFragment(220365616) [key=Menu1] Created
MenuFragment(220365616) [key=Menu1] ViewCreated
MenuFragment(220365616) [key=Menu1] Started
MenuFragment(220365616) [key=Menu1] Resumed
========== ⬆ Fragment(Menu1) 호출 ==========
MenuFragment(220365616) [key=Menu1] Paused
MenuFragment(220365616) [key=Menu1] Stopped
MenuFragment(174346222) [key=Menu2] Attached
MenuFragment(174346222) [key=Menu2] Created
MenuFragment(174346222) [key=Menu2] ViewCreated
MenuFragment(174346222) [key=Menu2] Started
MenuFragment(220365616) [key=Menu1] ViewDestroyed
MenuFragment(220365616) [key=Menu1] Destroyed
MenuFragment(220365616) [key=Menu1] Detached
MenuFragment(174346222) [key=Menu2] Resumed
========== ⬆ Fragment(Menu2) 호출 ==========
MenuFragment(174346222) [key=Menu2] Paused
MenuFragment(174346222) [key=Menu2] Stopped
MenuFragment(130074662) [key=Menu1] Attached
MenuFragment(130074662) [key=Menu1] Created
MenuFragment(130074662) [key=Menu1] ViewCreated
MenuFragment(130074662) [key=Menu1] Started
MenuFragment(174346222) [key=Menu2] ViewDestroyed
MenuFragment(174346222) [key=Menu2] Destroyed
MenuFragment(174346222) [key=Menu2] Detached
MenuFragment(130074662) [key=Menu1] Resumed
========== ⬆ Fragment(Menu1) 호출 ==========
```

기존 Menu1를 키로 정의한 Fragment가 ViewDestroyed/Destroyed까지 되는 모습을 볼 수 있습니다. 그리고, 다른 Fragment로 replace한 후, Menu1를 키로 정의한 Fragment를 Replace하면 Fragment가 `새롭게 Created`부터 생명주기가 다시 호출됩니다. 위 생명주기 동작은 모바일 앱이라는 제한된 환경에서 효율을 위해 뷰가 정리되는 것이 안드로이드의 올바른 동작이기도 합니다.

다만, 일부 시나리오에서는 Fragment는 재생성이 아니라 보여주고 잠시 숨겨주는 기능을 원할 수도 있습니다. 그럴 때 사용하는 것이 Show/Hide API입니다.

### show/hide로 수정시의 생명 주기

show/hide로 수정시의 생명주기 결과의 모습은 다음과 같습니다.

```kotlin
fun FragmentManager.showWithLifecycle(...) {
  commit {
    if (tag != lastFragmentTag) {
      val lastShowFragment = findFragmentByTag(lastFragmentTag)
      if (lastShowFragment != null && lastShowFragment.isVisible) {
        hide(lastShowFragment)
      }
    }

    if (fragment.isAdded) {
      show(fragment)
    } else {
      add(R.id.fragmentContainer, fragment, tag)
    }
  }
}
```

```
MenuFragment(220365616) [key=Menu1] Attached
MenuFragment(220365616) [key=Menu1] Created
MenuFragment(220365616) [key=Menu1] ViewCreated
MenuFragment(220365616) [key=Menu1] Started
MenuFragment(220365616) [key=Menu1] Resumed
========== ⬆ Fragment(Menu1) 호출 ==========
MenuFragment(203309933) [key=Menu2] Attached
MenuFragment(203309933) [key=Menu2] Created
MenuFragment(203309933) [key=Menu2] ViewCreated
MenuFragment(203309933) [key=Menu2] Started
MenuFragment(203309933) [key=Menu2] Resumed
========== ⬆ Fragment(Menu2) 호출 ==========
========== ⬆ Fragment(Menu1) 호출 ==========
```

기존 replace와 다른 점은 add시 생명주기가 Resumed된 이후 show/hide로는 추가적인 생명주기 호출은 없다는 점입니다.

{% include youtube.html id="4p1joyzd39c" %}

## Show/Hide 사용 시 무엇이 문제인가?

이전 섹션에서 Show/Hide의 생명 주기는 Resumed에서 멈춰있습니다. 

일반적으로는 이렇게만 사용하더라도 큰 문제없지만, `repeatOnLifecycle나 LiveData/Flow` 등 데이터의 흐름 시작이나 동작 시작을 알리는 트리거가 되는 `LifecycleOwner`와 연관된 케이스라면 잠재적인 문제를 내포하고 있습니다.

다음 코드는 데이터 호출 후 3초 후에 ViewModel의 LiveData로 데이터가 observe되는 코드를 작성했습니다. 호출 후 Fragment를 Hide하고 다른 Fragment를 Add하여 노출되도록 했습니다.

```kotlin
class SubFragment : SampleFragment() {
  ...
  private fun setUpViewModels() {
    viewModel.test.observe(viewLifecycleOwner) {
      logcat { "[$title] hidden=[$isHidden] viewLifecycleOwner received ==> $it" }
    }
  }
}
```

```
========== ⬇ Fragment(Sub1) 호출 ==========
SubFragment(220365616) [key=Sub1] Attached
SubFragment(220365616) [key=Sub1] Created
SubFragment(220365616) [key=Sub1] ViewCreated
SubFragment(220365616) [key=Sub1] Started
SubFragment(220365616) [key=Sub1] Resumed
Count down 3
========== ⬇ Fragment(Menu2) 호출 ==========
MenuFragment(232883926) [key=Menu2] Attached
MenuFragment(232883926) [key=Menu2] Created
MenuFragment(232883926) [key=Menu2] ViewCreated
MenuFragment(232883926) [key=Menu2] Started
MenuFragment(232883926) [key=Menu2] Resumed
Count down 2
Count down 1
Data Send ==> 874602
[Sub1] hidden=[true] viewLifecycleOwner received ==> 874602
========== ⬇ Fragment(Sub1) 호출 ==========
```

Hide 된 Fragment는 Hidden 상태이지만, 데이터가 수신되었다는 로그가 마지막에 노출되었습니다. 데이터가 수신되는 이유는 Fragment의 viewLifecycleOwner가 Active 상태이기 때문입니다. 

우리는 Fragment의 View의 생명주기 용도인 `viewLifecycleOwner`의 존재를 알고 있습니다. 다만, 이 viewLifecycleOwner에 대한 처리에서는 `Fragment의 Hidden 여부`를 체크하지 않습니다. 

결국엔 AndroidX Fragment에서 수정되지 않으므로 다르게 해결할 수밖에 없습니다.

이후에는 생명주기 관련 일부 케이스와 해결법을 소개하겠습니다.

## 해결 1. MaxLifecycle로 Fragment 생명주기 조절 (실제 해결 X)

[FragmentTransaction#setMaxLifecycle](https://developer.android.com/reference/androidx/fragment/app/FragmentTransaction#setMaxLifecycle(androidx.fragment.app.Fragment,androidx.lifecycle.Lifecycle.State))은 Fragment의 최대 생명주기를 설정할 수 있습니다. 이 기능은 AndroidX Fragment 1.1.0에 추가되었으므로, 현재 대부분의 앱에서는 사용가능합니다.

> AndroidX에서도 적극적으로 사용되지 않으며, FragmentPagerAdapter/FragmentStatePagerAdapter/FragmentScenario 같은 곳에서 사용 중입니다.

아래 이미지는 Fragment 생명주기 상태와 Fragment의 생명 주기 Callback이 어떻게 관련 있는지에 대한 내용입니다.

<img src="https://developer.android.com/static/images/guide/fragments/fragment-view-lifecycle.png" width="50%" />

> 이미지 출처 : https://developer.android.com/guide/fragments/lifecycle#states

Fragment가 BackStack에 추가되면 CREATED -> STARTED -> RESUMED 상태로 이동하며, BackStack에서 빠지면 RESUMED -> STARTED -> CREATED -> DESTROYED 상태로 이동하는 것을 알 수 있습니다.

위 동작을 알았으니 Show/Hide를 할 때도 유사하게 동작을 구현하면 됩니다. 아래 코드는 사용하기 쉽게 FragmentManager의 Extension으로 구현한 예시입니다.

```kotlin
fun FragmentManager.showWithLifecycle(
  fragment: Fragment,
  tag: String,
  lastFragmentTag: String? = null
) {
  ...
  commitNow {
    if (tag != lastFragmentTag) {
      val lastShowFragment = findFragmentByTag(lastFragmentTag)
      if (lastShowFragment != null && lastShowFragment.isVisible) {
        hide(lastShowFragment)
        setMaxLifecycle(lastShowFragment, Lifecycle.State.STARTED)
      }
    }

    if (fragment.isAdded) {
      show(fragment)
    } else {
      add(R.id.fragmentContainer, fragment, tag)
    }
    setMaxLifecycle(fragment, Lifecycle.State.RESUMED)
  }
}
```

위 코드와 동일하지는 않지만, FragmentPagerAdapter/FragmentStatePagerAdapter에서도 유사하게 구현되어 있습니다.

- 현재 노출하는 Fragment에는 Lifecycle.State.RESUMED
- 화면에서 사라지는 Fragment에는 Lifecycle.State.STARTED

> 참고 자료
>
> - [FragmentPagerAdapter#setPrimaryItem](https://github.com/androidx/androidx/blob/androidx-main/fragment/fragment/src/main/java/androidx/fragment/app/FragmentPagerAdapter.java#L208-L236)
> - [FragmentStatePagerAdapter#setPrimaryItem](https://github.com/androidx/androidx/blob/androidx-main/fragment/fragment/src/main/java/androidx/fragment/app/FragmentStatePagerAdapter.java#L233-L261)

{% include youtube.html id="Lh87Hp7_Mvk" %}

> 영상 결과로 Show/Hide시 Resumed/Paused가 호출되고 있습니다.

추가로 **LiveData로 데이터를 수신하는 기능을 추가**한 경우에는 아래와 같은 로그가 출력됩니다.

```
========== ⬇ Fragment(Sub1) 호출 ==========
SubFragment(46749228) [key=Sub1] Attached
SubFragment(46749228) [key=Sub1] Created
SubFragment(46749228) [key=Sub1] ViewCreated
SubFragment(46749228) [key=Sub1] Started
SubFragment(46749228) [key=Sub1] Resumed
Count down 3
========== ⬇ Fragment(Menu2) 호출 ==========
SubFragment(46749228) [key=Sub1] Paused
MenuFragment(137600441) [key=Menu2] Attached
MenuFragment(137600441) [key=Menu2] Created
MenuFragment(137600441) [key=Menu2] ViewCreated
MenuFragment(137600441) [key=Menu2] Started
MenuFragment(137600441) [key=Menu2] Resumed
Count down 2
Count down 1
Data Send ==> 2125239
[Sub1] hidden=[true] viewLifecycleOwner received ==> 2125239
========== ⬇ Fragment(Sub1) 호출 ==========
MenuFragment(246122412) [key=Menu2] Paused
SubFragment(76261656) [key=Sub1] Resumed
```

그러나 ViewModel로부터 데이터를 전달받는 SubFragment는 Paused 상태로 이동했지만, Hidden이여도 LiveData로부터 데이터가 수신되었습니다.

그 이유는 바로 LiveData를 observe시에 전달되는 `LifecycleOwner`가 Active한 상태이기 때문입니다. Active의 기준은 생명 주기의 상태가 `STARTED` 이후인 경우를 가리킵니다.

```java
@Override
boolean shouldBeActive() {
  return mOwner.getLifecycle().getCurrentState().isAtLeast(STARTED);
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-livedata-core/src/main/java/androidx/lifecycle/LiveData.java#L424-L427

위에서 소개한 Fragment 생명주기 상태와 Fragment의 생명 주기 Callback 이미지를 다시 살펴보면, Fragment에서는 **onStart/onResume/onPause**가 Active한 상태 구간입니다. 

원하는 생명주기로 동작하는 결과를 얻어냈지만, 아직 LiveData 이슈는 아직 남아있습니다. 이어서 해결해보겠습니다.

## 해결 2. VisibleLifecycleOwner in Fragment

이제는 MaxLifecycle을 방법을 사용하더라도 해결하지 못한 LiveData를 해결하기 위해서는 `LifecycleOwner`를 사용하는 것은 필수적입니다. 그러나 Fragment에 존재하는 [viewLifecycleOwner](https://developer.android.com/reference/androidx/fragment/app/Fragment#getViewLifecycleOwner())로는 Show/Hide시 Active한 상태를 처리해주지 못하는 것도 확인했습니다.

Fragment에서 기본적으로 제공하는 생명주기와 viewLifecycleOwner로는 해결이 불가능하니 남은 것은 Show/Hide시에 Active 상태를 만들어주는 `LifecycleOwner`를 만드는 것을 선택할 수 있습니다.

### 해결 2-1. Lifecycle.Event를 설정 가능한 LifecycleOwner 만들기

Fragment#viewLifecycleOwner의 생명 주기는 외부에서 변경이 불가능합니다. 그래서, 먼저 할 일은 외부에서도 생명주기를 조작할 수 있도록 Custom LifecycleOwner를 만드는 것으로 시작합니다.

```java
public interface LifecycleOwner {
  @NonNull
  Lifecycle getLifecycle();
}
```

본 글의 예제로는 **handleLifecycleEvent** 함수를 새롭게 추가했습니다.

```kotlin
class SimpleLifecycleOwner : LifecycleOwner {
    private val lifecycle = LifecycleRegistry(this)

    override fun getLifecycle(): Lifecycle {
        return lifecycle
    }

    fun handleLifecycleEvent(event: Lifecycle.Event) {
        lifecycle.handleLifecycleEvent(event)
    }
}
```

### 해결 2-2. Fragment에 커스텀 LifecycleOwner 연결

이제 새롭게 정의한 **SimpleLifecycleOwner**를 사용해서 생명주기를 조작해 봅니다.

기본적으로 커스텀으로 만든 LifecycleOwner도 일반적인 생명주기 동작과 동일하게 해야하므로, ① `viewLifecycleOwner`를 참조하여 동일하게 동작하도록 먼저 대응합니다. ② 그 후, 일부 케이스에서만 Fragment가 Hidden여부에 따라 생명주기를 변경하도록 수정합니다.

```kotlin
abstract class SampleFragment : Fragment() {
  protected val visibleLifecycleOwner: SimpleLifecycleOwner by lazy {
    SimpleLifecycleOwner()
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    // Fragment show/hidden 지원하는 Lifecycle Owner 대응
    // ① 기존 생명주기와 동일하게 동작하도록 Lifecycle 참조하여 handleLifecycleEvent를 호출
    viewLifecycleOwner.lifecycle.addObserver(object : LifecycleEventObserver {
      override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
        when (event) {
          Lifecycle.Event.ON_RESUME,
          Lifecycle.Event.ON_PAUSE -> {
            // ② 생명주기가 ON_RESUME/ON_PAUSE일 때 Hidden 상태라면 ON_STOP으로 변형함
            if (isHidden) {
              visibleLifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
            } else {
              visibleLifecycleOwner.handleLifecycleEvent(event)
            }
          }
          else -> {
            visibleLifecycleOwner.handleLifecycleEvent(event)
          }
        }
      }
    })
  }
}
```

### (마무리) 해결 2-3. LiveData에 visibleLifecycleOwner 적용

이제 마지막 단계입니다. 앞서 문제가 발생한 LiveData에 커스텀으로 만든 visibleLifecycleOwner을 적용하면 끝입니다.

```kotlin
class SubFragment : SampleFragment() {
  ...
  private fun setUpViewModels() {
    // 커스텀으로 만든 visibleLifecycleOwner 적용
    viewModel.test.observe(visibleLifecycleOwner) {
      logcat { "[$title] hidden=[$isHidden] viewLifecycleOwner received ==> $it" }
    }
  }
}
```

적용 후 동일하게 동작시 출력되는 로그는 아래와 같습니다.

```
========== ⬇ Fragment(Sub1) 호출 ==========
SubFragment(76261656) [key=Sub1] Attached
SubFragment(76261656) [key=Sub1] Created
SubFragment(76261656) [key=Sub1] ViewCreated
SubFragment(76261656) [key=Sub1] Started
SubFragment(76261656) [key=Sub1] Resumed
Count down 3
========== ⬇ Fragment(Menu2) 호출 ==========
SubFragment(76261656) [key=Sub1] Paused
MenuFragment(236941976) [key=Menu2] Attached
MenuFragment(236941976) [key=Menu2] Created
MenuFragment(236941976) [key=Menu2] ViewCreated
MenuFragment(236941976) [key=Menu2] Started
MenuFragment(236941976) [key=Menu2] Resumed
Count down 2
Count down 1
Data Send ==> 42964
========== ⬇ Fragment(Sub1) 호출 ==========
MenuFragment(236941976) [key=Menu2] Paused
[Sub1] hidden=[false] viewLifecycleOwner received ==> 42964
SubFragment(76261656) [key=Sub1] Resumed
```

로그 상으로는 지금까지 필요로 했던 Show/Hide 전환에 따른 생명주기 호출과 데이터 수집이 유효하게 수집되는 것을 확인할 수 있습니다. 영상을 통해서도 로그를 확인할 수 있습니다. 

{% include youtube.html id="71ZFNZaLQUQ" %}