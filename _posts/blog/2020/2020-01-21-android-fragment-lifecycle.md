---
layout: post
title: "Fragment Lifecycle과 LiveData"
date: 2020-01-25 21:00:00 +09:00
tag: [Android, Lifecycle]
categories:
- blog
- Android
---

Android 개발에서 어려운 것 중 하나가 바로 Lifecycle입니다.

이번 글에서는 Fragment의 Lifecycle에 대해서 다룹니다. 그리고, Fragment에서 올바르게 LiveData를 사용법과 `Fragment 1.2.0`의 변경에 관해서 이야기하는 것이 이 글의 목표입니다.

<!--more-->

## 생명주기

### Android의 생명 주기

Android는 사용자에 의해서 화면을 회전하거나 알림에 답장 및 다른 작업으로 전환할 수 있습니다. 그리고, 이런 이벤트가 발생한 후에도 앱을 계속해서 사용할 수 있습니다.

우리가 처음 Android를 공부하면서 보고 들은 생명주기의 시작은 아래와 같은 그림일 것입니다.

<img src="https://developer.android.com/images/topic/libraries/architecture/lifecycle-states.svg" />

> 출처 : https://developer.android.com/topic/libraries/architecture/lifecycle

Activity, Fragment의 생명주기는 큰 흐름은 위와 같은 형태로 동작합니다. Create, Start, Resume, Pause, Stop, Destroy 총 6단계입니다. 

### 현실의 생명주기 흐름

그러나, 우리가 겪는 현실은 Activity뿐만 아니라 Activity와 Fragment를 함께 사용하면서 더욱 복잡한 생명주기를 다루는 문제를 경험합니다. 어떻게 엮이는지 간단한 예로서 Activity와 Fragment를 시작한 후 종료하는 단계의 생명주기는 아래와 같습니다.

<img src="https://miro.medium.com/max/694/1*ALMDBkuAAZ28BJ2abmvniA.png" />

<img src="https://miro.medium.com/max/694/1*ALMDBkuAAZ28BJ2abmvniA.png" />

> 출처 : [The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)

> 좀 더 복잡한 전체 그림을 원하시는 경우에는 다음 링크를 보세요.
>
> https://github.com/xxv/android-lifecycle/blob/master/complete_android_fragment_lifecycle.png?raw=true

## Fragment와 Activity의 생명주기 상관관계

`Fragment`는 Activity 내에서 일어나는 어떤 동작 또는 사용자 인터페이스의 일부를 나타냅니다. 여러 개의 Fragment를 하나의 Activity와 함께 사용할 수 있습니다. 그리고, 하나의 Fragment를 여러 Activity에 재사용도 할 수 있습니다. 또한, Fragment는 Activity와 유사하게 Fragment 자체의 생명주기를 가지고 있습니다.

Fragment의 생명주기는 Attach 되는 Activity의 생명주기에 영향을 받습니다. 예를 들어, Activity가 일시 정지되면 그 안에 모든 Fragment도 일시 정지되며 Activity가 파괴될 때 모드 Fragment도 마찬가지로 파괴됩니다.  Activity가 실행 중인 동안에는 Fragment를 추가 또는 제거를 할 수 있습니다. 이제 Fragment에도 Activity와 동일하게 Lifecycle이 존재한다는 것은 간략하게 전달이 되었다고 생각합니다. 

이제 Lifecycle을 사용에 관해서 이야기합니다.

## Fragment에서 LiveData 사용하기

### Fragment & LiveData 사용 예시

아래 코드는 간단한 샘플로서 ViewModel에서 정의한 `isUpdate`  로 정의한 LiveData를 Observe하는 코드입니다. 아래 코드르 본 후 문제가 될 수 있는 상황을 생각해보세요.

```kotlin
// SampleViewModel.kt
class SampleViewModel : ViewModel() {
    private val _isUpdate = MutableLiveData<Boolean>()
    val isUpdate: LiveData<Boolean>
        get() = _isUpdate
}
```

```kotlin
// SampleFragment.kt
class SampleFragment : Fragment() {
   private val viewModel ...

   override fun onActivityCreated(savedInstanceState: Bundle?) {
      super.onActivityCreated(savedInstanceState)
      viewModel.isUpdate.observe(this, Observer<Boolean> {
         // TODO: something
      })
   }
}
```

예시로 작성한 ViewModel과 Fragment은 매우 간단하며 위 코드로 별다른 문제로 보이지 않을 수 있습니다. 

LiveData를 Oberve시에 사용되는 첫 번째 파라미터는 LifecycleOwner 인터페이스이며, Fragment 또한 LifecycleOwner 인터페이스를 구현하고 있음으로, 사용한다는 점에서는 API 스펙상 잘못된 부분은 없습니다. 

아래는 LiveData와 Fragment 소스의 일부분을 발췌했습니다.

```java
// LiveData.java
public abstract class LiveData<T> {
   public void observe(
      @NonNull LifecycleOwner owner, @NonNull Observer<? super T> observer) {
      ...
   }
}
```
```
// Fragment.java
public class Fragment implements ComponentCallbacks, OnCreateContextMenuListener, 
   LifecycleOwner, ViewModelStoreOwner, vedStateRegistryOwner {
   ...
}
```

### 문제의 Lifecycle 사용 패턴

Lifecycle과 LiveData의 문제가 처음 언급된 곳은 [android/architecture-components-samples issue #47](https://github.com/android/architecture-components-samples/issues/47) 이슈입니다. 이슈에서 언급하는 내용은 LiveData#observe로 사용된 Observer가 중복으로 호출된다는 내용입니다.

문제가 되는 코드를 다시 한번 보겠습니다.

```kotlin
viewModel.isUpdate.observe(this, Observer<Boolean> {
   // TODO: something
}
```

위 코드는 LiveData#observe의 LifecycleOwner에 해당하는 파라미터로 Fragment 자신을 넘기는 코드입니다. 다음으로 또 다른 Activity와 Fragment의 Lifecycle의 흐름을 살펴보겠습니다.

<img src="https://miro.medium.com/max/1596/1*hK_YRdty1GoafABfug-r4g.png" />

>  출처 : [The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)

위 이미지에서 볼 수 있는 것처럼 Fragment는 Actvitiy와 다르게 `onDestroy` 가 호출되지 않은 상태에서 `onCreateView` 가 여러 번 호출될 수 있습니다. 이로 인해 Fragment의 Lifecycle은 Destroy 되지 않은 상황에서 LiveData에 새로운 Observer가 등록되어 복수의 Observer가 호출되는 현상이 발생할 가능성이 있습니다.

### Google도 실수합니다

이 글을 읽는 여러분들 중에는 "우리는 Google 샘플 및 발표 영상에서 말한대로 작성하고 있어요!!"라고 이야기하시는 분이 계실 겁니다. 

네 맞습니다. 2017년 10월에 공개된 구글의 샘플 소스에서도 동일하게 작성되었습니다. 

```java
public class ProductFragment extends Fragment {
  ...
  private void subscribeToModel(final ProductViewModel model) {
    // Observe product data
    model.getObservableProduct().observe(this, new Observer<ProductEntity>() {
      @Override
      public void onChanged(@Nullable ProductEntity productEntity) {
        model.setProduct(productEntity);
      }
  });
  ...
}
```

> 출처 : https://github.com/android/architecture-components-samples/blob/70a1072ed2/BasicSample/app/src/main/java/com/example/android/persistence/ui/ProductFragment.java#L86

Google 샘플에서도 동일하게 쓰고 있었으니 틀리지 않았으며 출시 당시에 많은 분의 환호를 했다는 기억이 납니다. 그렇지만 해당 내용은 최신 버전이 아니라는 점을 알려드립니다. 아래에서 더 자세히 살펴보도록 하겠습니다.

------

## Fragment의 생명주기 다시 살펴보기

이제 본론입니다. ~~(길고 긴 서론을 읽어주셔서 감사합니다)~~

여러분이 놓치고 있는 정보 중 하나는 바로 `Fragment에는 2개의 Lifecycle이 존재`하는 점입니다. 바로 `Fragment Lifecycle`과 `Fragment View Lifecycle`입니다.

### Fragment View Lifecycle의 시작

Fragment Lifecycle은 본 글의 처음에 언급한 Fragment의 생명 주기에 해당하는 내용입니다. 그리고, Fragment View Lifecycle은 `문제의 Lifecycle 사용 패턴`을 개선하기 위해서 도입된 Lifecycle입니다.

먼저, Google Android Developer인 Ian Lake씨의 Fragment 수정 로그를 보겠습니다.

```
Add Fragment#getViewLifecycleOwner

The Fragment's View lifecycle can diverge
from the Fragment's lifecycle in cases of
detached Fragments. This can cause issues with
LiveData where old observers should be cleared
when the View is destroyed to prevent duplication
with new observers created in onCreateView/onViewCreated.

By exposing a separate LifecycleOwner specifically for
the Fragment's View, developers can use that in place
of the Fragment itself to better model the Lifecycle
they actually care about.

Also adds a getViewLifecycleOwnerLiveData() for
observing changes in the View LifecycleOwner (i.e.,
creation, destruction, and recreation).
```

> 링크 : [https://android.googlesource.com/platform/frameworks/support/+/eb89fcf1decf9044f53330ea4bb689d25d2328b1%5E%21/fragment/src/main/java/androidx/fragment/app/Fragment.java](https://android.googlesource.com/platform/frameworks/support/+/eb89fcf1decf9044f53330ea4bb689d25d2328b1^!/fragment/src/main/java/androidx/fragment/app/Fragment.java)

위 내용이 이번 글의 핵심입니다. 

Fragment는 Fragment View보다 긴 생명주기를 가지며, 일반적으로 UI를 업데이트용으로는 `Fragment View Lifecycle` 이 적절합니다. 그리고, Fragment View Lifecycle 도입으로 LiveData#observe에서 사용하는 Observer 중복 호출 문제도 해결할 수 있습니다. Fragment 사용 시 데이터 갱신에 대한 Lifecycle을 Fragment Lifecycle보다 Fragment View Lifecycle이 올바르다고 언급하고 있습니다.

- Fragment Lifecycle : Create ~ Destroy
- Fragment View Lifecycle : createView ~ destoryView

### 올바른 Fragment에서 LiveData 사용

```kotlin
// Bad 
override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
   viewModel.liveData.observe(this, Observer {
      // Update UI
   })
}
```

기존 LiveData 사용에서 바뀌는 부분은 liveData를 observe 함수의 첫 번째 파라미터를 this에서 viewLifecycleOwner를 호출하도록 수정하면 됩니다.

```kotlin
// Good 
override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
   viewModel.liveData.observe(viewLifecycleOwner, Observer {
      // Update UI
   })
}
```

이렇게 수정함으로써 우리가 생각하는 View의 생명주기에 맞게 데이터가 갱신되는 결과를 얻을 수 있습니다.

------

## Lifecycle 문제에 대한 자세한 발표 영상

아래 영상은 I/O '19 what's new in Architecture Components 세션이며 Fragment와 LiveData 사용에 필요한 Lifecycle에 대해서 언급하고 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/pErTyQpA390?start=214" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

------

## Updated, Fragment 1.2.0

며칠 전 Fragment 1.2.0이 Stable 버전으로 출시되었습니다. FragmentContainerView, ViewModel, FragmentManager 등 몇 가지 변화가 되었습니다. 그중 이번 글과 관련된 기능 하나가 추가되었습니다.

> 링크 : [Fragment 1.2.0 Release note](https://developer.android.com/jetpack/androidx/releases/fragment#1.2.0)

**Fragment Version 1.2.0**

- **New Lint checks**: Added a new Lint check that ensures you are using `getViewLifecycleOwner()` when observing `LiveData` from `onCreateView()`, `onViewCreated()`, or `onActivityCreated()`.

Fragment 1.2.0부터 새로운 Lint가 추가되었습니다.  onCreateView(), onViewCreated(), onActivityCreated()에서 LiveData 사용 시에는 ViewLifecycleOwner를 사용하도록 권장하는 것입니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0124-fragment/01.png" }}" />

LiveData#observe에서 this를 사용하는 경우 위와 같은 메시지를 경험합니다. 빨간 밑줄과 안내 메시지가 노출되지만, 빌드 실패는 아닙니다. 이제 우리가 해야 할 일은 바로 Fragment View Lifecycle 객체를 반환하는 `viewLifecycleOwner`를 사용하는 것입니다.

> 위에서 언급한 Fragment에서 LiveData#observe 사용에 관한 Lint 구현이 궁금하신 분은 아래 링크를 참고하세요.
>
> https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/fragment/fragment-lint/src/main/java/androidx/fragment/lint/UnsafeFragmentLifecycleObserverDetector.kt

------

## Summary

Fragment에서 Livedata#observe의 파라미터로 LifecycleOwner에 this를 쓰는 코드를 많이 봤습니다. 아직도 Github, Stackoverflow, Blog 등등 LiveData & Lifecycle 초기에 나온 정보들이 그대로 사용되고 있는 곳이 많습니다. 또한, Fragment에서 Livedata#observe 사용하면서 이번 글에서 언급한 Observer 중복 호출을 경험하지 않은 분이 계실 수도 있습니다. 구조적으로 발생하지 않는 구조를 사용 중일 수 있으며 [SingleLiveEvent](https://medium.com/androiddevelopers/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case-ac2622673150) 를 사용하시는 분도 계실 겁니다.

우리 모두 Android 개발을 위해서 고군분투하고 계십니다. 👏👏👏👏

이번 글을 통해 Fragment에 Lifecycle이 2가지가 존재한다는 것과 Google이 권장하는 Fragment Lifecycle 사용에 대해서 새롭게 지식을 얻으셨길 바랍니다.

## 유용한 생명주기 글

- [5 common mistakes when using Architecture Components](https://proandroiddev.com/5-common-mistakes-when-using-architecture-components-403e9899f4cb)
- [Architecture Components pitfalls — Part 1](https://medium.com/@BladeCoder/architecture-components-pitfalls-part-1-9300dd969808)
- [The Android Lifecycle cheat sheet — part I: Single Activities](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)
- [The Android Lifecycle cheat sheet — part II: Multiple activities](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-ii-multiple-activities-a411fd139f24)
- [The Android Lifecycle cheat sheet — part III : Fragments](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iii-fragments-afc87d4f37fd)
- [The Android Lifecycle cheat sheet — part IV : ViewModels, Translucent Activities and Launch Modes](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-iv-49946659b094)
