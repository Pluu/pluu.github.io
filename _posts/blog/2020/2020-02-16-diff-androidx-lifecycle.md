---
layout: post
title: "SavedState is Default"
date: 2020-02-16 08:30:00 +09:00
tag: [Android, AndroidX, SavedState]
categories:
- blog
- Android
---

본 글은 SavedState ViewModel 관련 [Android 상태 저장의 기본에서 Savedstate까지](http://pluu.github.io/blog/android/2020/02/10/saved-state/) 
의 2번째 글입니다.

> [AndroidX Update ~ Feb 5, 2020](https://developer.android.com/jetpack/androidx/versions/all-channel?hl=en#february_5_2020)

<!--more-->

AndroidX는 Stable/RC/Beta/Alpha의 단계를 가지면서 업데이트되고 있습니다. 그리고, 안드로이드 개발자라면 이 내용을 알고 계실 겁니다. AndroidX 사용으로 편해진 부분도 있으며, 조용하게 여러 부분이 변경되고 있습니다.

SavedState 기능도 별도 라이브러리로 존재하지만, AndroidX Activity / Fragment / Lifecycle 최신 버전을 쓰고 계신 분이라면 이미 여러분은 침투(?)당했습니다.

먼저 각 Artifact에서 어떤 변경이 발생했는지 살펴보겠습니다.

## Activity

### Activity 1.0.0 ➡ Activity 1.1.0

>  ComponentActivity.java

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-componentactivity-01.png" }}" /> 

Activity 1.1.0에서 기본 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 를 반환하는  [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) Interafce를 구현하게 되었으며, [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity.html) 내부에  [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 인스턴스를 가지는 private 로컬 변수가 추가되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-componentactivity-02.png" }}" /> 

ComponentActivity에 implements로 선언한 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory.html)에는 하나의 메소드가 정의되어 있습니다. 이 함수가 바로 [getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory.html#getDefaultViewModelProviderFactory()) 입니다. 추후 이 함수는 ViewModel을 생성을 담당하는 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.html)에서 사용됩니다.

이 부분에서 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 를 사용하도록 변경되었습니다. ★★★★★

### Activity-ktx 1.1.0 ➡ Activity-ktx 1.2.0

>  ActivityViewModelLazy.kt

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-ActivityViewModelLazy.png" }}" /> 

AndroidViewModelFactory로 Factory 생성에서 [ComponentActivity#getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/activity/ComponentActivity.html#getDefaultViewModelProviderFactory()) 를 통해서 ViewModelProvider.Factory를 가져오도록 변경되었습니다.

------

## Fragment

### Fragment 1.1.0 ➡ Fragment 1.2.0

> Fragment.java

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-Fragment-01.png" }}" /> 

ComponentActivity와 동일하게 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment.html) 또한 기본 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 를 반환하는  [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) Interafce를 구현되도록 선언되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-Fragment-02.png" }}" /> 

내부에  [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 인스턴스를 가지는 private 로컬 변수가 추가되었습니다.

그리고, [ComponentActivity#getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/activity/ComponentActivity.html#getDefaultViewModelProviderFactory()) 에서 정의된 형태와 비슷하게 기본 ViewModelProvider.Factory를 반환하는 함수가 구현되었습니다.

### Fragment-ktx 1.1.0 ➡ Fragment-ktx 1.2.0

> FragmentViewModelLazy.kt

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-FragmentViewModelLazy-01.png" }}" />

먼저 Fragment에서 `activityViewModels()` 을 사용해서 ViewModel을 가져오는 케이스를 살펴보겠습니다. ComponentActivity에서도 언급했던 것과 동일하게 Activity의 [getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory.html#getDefaultViewModelProviderFactory()) 메소드를 이용해서 Fragment에서 사용될 Factory Producer를 전달합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-FragmentViewModelLazy-02.png" }}" />

다음으로 Fragment에서`viewModels()`를 사용할 경우 별도 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 를 전달하지 않는다면 [Fragment#getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/fragment/app/Fragment.html?hl=en#getDefaultViewModelProviderFactory()) 함수를 사용해서 가져옵니다. 그 후 실제 [ViewModelLazy](https://developer.android.com/reference/kotlin/androidx/lifecycle/ViewModelLazy) 클래스를 사용해서 Lazy로 ViewModel을 가져오는 실제 구현체에 작업을 위임합니다.

------

## Lifecycle

실제로 ViewModel을 생성과 중요 로직이 모여있는 Lifecycle Artifact에 대해서 살펴보겠습니다.

### lifecycle-extension 2.1.0 ➡ lifecycle-extension 2.2.0

> ViewModelProviders.java

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeproviders-01.png" }}" />

먼저 [ViewModelProviders](https://developer.android.com/reference/androidx/lifecycle/ViewModelProviders) 는 **Deprecated** 되었습니다. 실제 내부 구현은 Static 메소드로  ViewModelProvider를 호출하는 Utilities 클래스였습니다. 변경 후에는 명시적으로 ViewModelProvider를 호출하도록 변경되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeproviders-02.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeproviders-03.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeproviders-04.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeproviders-05.png" }}" />

ViewModelProviders.of(...) 를 통해서 ViewModelProvider를 가져오던 로직들이 ViewModelProvider를 new 하는 형태의 Factory로만 변경되었습니다.

### lifecycle-viewmodel 2.1.0 ➡ lifecycle-viewmodel 2.2.0

ViewModel을 사용하기 위한 ViewModelProvider는 직접 호출하여 사용 할 수 있습니다. ViewModelProviders를 사용해서 ViewModelProvider를 얻을 수 있지만 해당 기능은 **Deprecated** 되었습니다.

> ViewModelProvider.java

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeprovider-01.png" }}" />

새롭게 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner.html) 로 ViewModelProvider를 생성하는 생성자가 추가되었습니다. [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner.html) 는 [ViewModelStore](https://developer.android.com/reference/androidx/lifecycle/ViewModelStore.html) 를 반환하는 메소드가 정의된 인터페이스입니다. 

> <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/ViewModelStoreOwner.png" }}" />

여기에서 살펴볼 부분은 `owner` 객체가 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 인터페이스를 타입을 가지는지 체크하는 부분입니다. 해당 체크가 true인 경우, [getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory.html#getDefaultViewModelProviderFactory()) 를 사용해서 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html)를 가져옵니다.

> <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/HasDefaultViewModelProviderFactory.png" }}" />

Android Developer Reference에서 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 를 구현하고 있는 객체를 확인해 봅니다. 우리가 알고 있는 [ComponentActivity](https://developer.android.com/reference/kotlin/androidx/activity/ComponentActivity.html), [Fragment](https://developer.android.com/reference/kotlin/androidx/fragment/app/Fragment.html), [NavBackStackEntry](https://developer.android.com/reference/kotlin/androidx/navigation/NavBackStackEntry.html) 에서 실제 해당 함수를 구현하고 있습니다.

앞서 언급한 Activity, Fragment에서 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 를 구현한 [getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory.html#getDefaultViewModelProviderFactory()) 함수를 통해 기본 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html)를 가져오는 흐름입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/diff-viewmodeprovider-02.png" }}" />

`mViewModelStore.get(...)` 을 통해 저장된 ViewModel 이 있는 경우 OnRequeryFactory인지 체크하는 부분이 추가되었습니다.

해당 인터페이스를 구현하는 클래스는 [AbstractSavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/AbstractSavedStateViewModelFactory), [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 에서 실제로 구현 정의를 하고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/OnRequeryFactory.png" }}" />

OnRequeryFactory
  ㄴ KeyedFactory
        ㄴ [AbstractSavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/AbstractSavedStateViewModelFactory)
        ㄴ [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory)

아쉽게도 OnRequeryFactory / KeyedFactory 는 Public이 아니므로 실제로 개발자가 사용하지 못하고, 플랫폼의 내부적으로 사용됩니다.

> <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0215-diff-savedstate/KeyedFactory.png" }}" />

### lifecycle-viewmodel-savedstate 1.0.0 ➡ lifecycle-viewmodel 2.2.0

lifecycle-viewmodel-savedstate는 다른 Lifecycle artifact와 동일한 버전을 사용하도록 변경되었습니다. 기존 1.0.0의 동작과 동일합니다.