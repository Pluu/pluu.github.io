---
layout: post
title: "SavedState 어떻게 저장되고 복원될까?"
date: 2020-03-15 23:00:00 +09:00
tag: [Android, AndroidX, SavedState]
categories:
- blog
- Android
---

본 글에서는 상태 저장을 위해서 사용되는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 객체가 AndroidX에서 어떻게 저장과 복원이 이루어지는지 그림과 함께 살펴볼 것입니다.

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment)의 흐름을 확인하기 위해서 AndroidX [Activity:1.1.0](https://developer.android.com/jetpack/androidx/releases/activity#version_110_3) / [Fragment:1.2.0](https://developer.android.com/jetpack/androidx/releases/fragment#version_120_3) / [android/platform/frameworks/supports](https://android.googlesource.com/platform/frameworks/support/) androidx-master-dev 소스를 통해서 파악한 정보입니다.

<!--more-->

ViewModel 에 대해서 총 5개의 글을 소개할 예정입니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ page.url }}) <-- 현재 글
- 5부 : TBD

------

지금까지 Android 개발 시 상태 저장을 안전하게 다루기 위해서 SavedState를 언급했습니다. 상태 저장의 과거에서 현재까지 바뀐 변천사를 말했으며 AndroidX의 기본으로 들어온 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)의 소개를 했습니다. 그리고 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)의 내부 모습을 확인을 통해 사용 방법에 관해서 확인했습니다.

------

본 글에서 다루는 FlowChart를 빠르게 확인하기 위해서는 아래 링크를 참고해주세요

- ComponentActivity : [download (1.26 MB - 8,486px X 7,084px)](http://bit.ly/33lBmQK)
- Fragment : [download (1.67MB - 8,486px X 10,932px)](http://bit.ly/2TTgsoM)

일부 Flowchart는 화면에 다 담기에 큰 이미지로 인해 위 이미지를 참고하시면 됩니다.

------

⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

⚠️⚠️⚠️ 본 글의 내용은 다소 복잡한 로직을 포함하고 있으며, 조금 긴 Flowchart를 다루고 있습니다 ⚠️⚠️⚠️

⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

------

## 상태 저장/복원을 위한 기본 인터페이스

Android 개발 시에 상태 저장은 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity), [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 이렇게 2가지의 클래스가 담당합니다. 이 클래스에서 상태 저장을 위해서 아래와 같은 인터페이스를 구현하고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/savedstate.png" }}" />

AndroidX의 [Lifecycle](https://developer.android.com/jetpack/androidx/releases/lifecycle)과 [SavedState](https://developer.android.com/jetpack/androidx/releases/savedstate) 라이브러리에서 위 인터페이스를 포함하고 있습니다.

**AndroidX - Lifecycle**

- [LifecycleOwner](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner) : Lifecycle을 반환하도록 정의한 인터페이스
- [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) : ViewModelStore를 반환하도록 정의한 인터페이스
- [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) : 기본적인 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 를 반환하도록 정의한 인터페이스로서 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 를 반환하고 있습니다. [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel) 생성 시 기본적인 Argument를 전달하는 주체이기도 합니다.

**AndroidX - SavedState**

- [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner) : 저장된 상태를 소비/기여하는 컴포넌트를 연결하기 위한 인터페이스로서 주 관리 주체인 [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry) 를 반환하고 있습니다.

더 자세한 내용은 이후에서 다루도록 하겠습니다.

## ComponentActivity

먼저 다뤄 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)는 실제로 개발 시에 직접적으로 접할 기회가 적어서 다소 생소할 수 있습니다. 그리고, Android 개발 시 많이 사용되는 [AppCompatActivity](https://developer.android.com/reference/androidx/appcompat/app/AppCompatActivity) 는 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 를 상속해서 구현되어있습니다. [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 는 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 를 상속해서 구현하고 있습니다.

### Class Information

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/appcompat_class_hierarchy.png" }}" />

> 클래스 정보 출처 : https://developer.android.com/reference/androidx/appcompat/app/AppCompatActivity

Android Framework에서 제공하는 클래스 (ContextWrapper, Activity)를 제외하면 AndroidX 측면에서는 높은 트리의 위치에 있으며 기본적인 구현을 정의한 클래스이기도 합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/appcompat-interface.png" }}" />

> 클래스 정보 출처 : https://developer.android.com/reference/androidx/appcompat/app/AppCompatActivity

그리고 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 클래스는 상태 저장을 위한 인터페이스([LifecycleOwner](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner), [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner), [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory), [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner)) 들을 구현하고 있습니다.

### Flowchart

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/activity-state.png" }}" />

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)의 상태 저장과 복원은 Android 생명주기를 공부할 때 자주 들어본 메소드입니다. 위 그림과 같이 [onCreate](https://developer.android.com/reference/android/app/Activity#onCreate(android.os.Bundle)) 와 [onSaveInstanceState](https://developer.android.com/reference/android/app/Activity#onSaveInstanceState(android.os.Bundle)) 함수가 복원/저장하는 시작점입니다. 

#### 상태 복원

1. ComponentActivity#onCreate(Bundle) ▶ [Activity#onCreate(Bundle)](https://developer.android.com/reference/android/app/Activity#onCreate(android.os.Bundle))
2. [SavedStateRegistryController#performRestore(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performRestore(android.os.Bundle))

#### 상태 저장

1. ComponentActivity#onSaveInstanceState(Bundle) ▶ [Activity#onSaveInstanceState(Bundle)](https://developer.android.com/reference/android/app/Activity#onSaveInstanceState(android.os.Bundle))
2. [SavedStateRegistryController#performSave(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performSave(android.os.Bundle))

상태 저장의 저장/복원은 위 2개의 함수가 진입점이지만, 실제로 상태 저장을 컨트롤하는 별도 객체가 존재합니다. 바로 [SavedStateRegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 클래스입니다. 이 클래스 또한 [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 라는 클래스를 제어하기 위한 컨트롤 객체입니다.  

[SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 객체는 저장된 상태를 소비/기여하는 컴포넌트를 연결하는 클래스입니다. [SavedStateRegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 를 통한 이후의 흐름은 이후의 내용에서 확인해보겠습니다.

## Fragment

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 이외에 또 다른 상태 저장을 담당하는 클래스가 바로 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 입니다. 

### Class Information

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/fragment_class_hierarchy.png" }}" />

> 클래스 정보 출처 : https://developer.android.com/reference/androidx/fragment/app/Fragment

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/fragment-interface.png" }}" />

> 클래스 정보 출처 : https://developer.android.com/reference/androidx/fragment/app/Fragment

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 동일하게 상태 저장을 위한 인터페이스들을 구현하고 있는 모습을 확인할 수 있습니다. 다만 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 는 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 다르게 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 와 [FragmentManager](https://developer.android.com/reference/androidx/fragment/app/FragmentManager) 에 의존하고 있습니다. Flowchart를 보면서 흐름을 확인해보겠습니다.

### Flowchart ~ 상태 복원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/fragment-state-restore.png" }}" />

앞서 언급한 것과 같이 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment)의 상태 복원을 확인해보기 위해서는 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 부터 체크해 볼 필요가 있습니다. 그 이유는 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 는 자신을 사용하는 Activity가 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 이여야하며 [FragmentManager](https://developer.android.com/reference/androidx/fragment/app/FragmentManager) 를 통해서 관리되고 있습니다. 이것은 수많은 안드로이드 개발자들이 이미 알고 있는 내용이기도 합니다. 그로 인해 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 동일하게 [FragmentActivity#onCreate](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity#onCreate(android.os.Bundle)) 함수가 상태 복원의 시작점입니다. 

[FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 에서 [SavedStateRegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 까지의 상태 복원의 흐름은 아래와 같습니다. [SavedStateRegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 를 접근한 이후의 흐름은 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 동일하므로 이후 별도 파트에서 소개하도록 하겠습니다.

1. [FragmentActivity#onCreate(Bundle)](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity#onCreate(android.os.Bundle)) 
2. [FragmentController#restoreSaveState(Parcelable)](https://developer.android.com/reference/androidx/fragment/app/FragmentController#restoreSaveState(android.os.Parcelable))
3. FragmentManager#restoreSaveState(Parcelable)
4. [FragmentController#dispatchCreate()](https://developer.android.com/reference/androidx/fragment/app/FragmentController#dispatchCreate())
5. FragmentManager#dispatchCreate()  ▶▶▶ 상태 변경 처리 ▶▶▶ FragmentManager#dispatchStateChange
6. FragmentStore#dispatchStateChange(int)
7. FragmentStateManager#create()
8. Fragment#performCreate(Bundle)
9. [SavedStateRegistryController#performRestore(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performRestore(android.os.Bundle))

위 이미지를 기준으로 간략하게 흐름을 작성했습니다. 

### Flowchart ~ 상태 저장

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/fragment-state-save.png" }}" />

[Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment)의 상태 저장 또한 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) 부터 시작합니다.

1. [FragmentActivity#onSaveInstanceState(Bundle)](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity#onSaveInstanceState(android.os.Bundle))
2. [FragmentController#saveAllState()](https://developer.android.com/reference/androidx/fragment/app/FragmentController#saveAllState())
3. FragmentManager#saveAllState()
4. FragmentStore#saveActiveFragments()
5. FragmentStateManager#saveBasicState()
6. Fragment#performSaveInstanceState(Bundle)
7. [SavedStateRegistryController#performSave(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performSave(android.os.Bundle))

> [SavedStateRegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 를 접근한 이후의 흐름은 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 동일하므로 이후 별도 파트에서 소개하도록 하겠습니다.

## ViewModel 관련 객체들

지금까지 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)/[Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment)에서 상태 저장/복원의 흐름을 알아보았습니다. 다음으로 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 사용되는 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel) 관련 흐름을 알아보겠습니다.

아래 이미지는 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel)에 관련된 흐름의 일부를 발췌했습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/ViewModel.png" }}" />

위 이미지에서 관련된 객체는 아래와 같습니다.

- [SavedStateHandleController](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandleController.java)
- [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider)
- [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory)
- [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory)
- [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner)

[ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel)은 [Activity](https://developer.android.com/reference/android/app/Activity.html)/[Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment)의 데이터를 관리하는 클래스이며 비즈니스 로직을 호출 처리를 담당합니다. 추가로 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 를 통해서 이번 주제의 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)이 생성된 후 생성자로 주입되어 사용됩니다.

### ViewModelProvider

[ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel)은 생성을 손쉽게 사용하는 유틸리티 클래스로 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider)가 있습니다. 이 클래스에는 총 3개의 생성자가 존재합니다.

```java
public class ViewModelProvider {
  ...
  private final Factory mFactory;
  private final ViewModelStore mViewModelStore;

  // ① Use ViewModelStoreOwner
  public ViewModelProvider(@NonNull ViewModelStoreOwner owner) {  
    this(owner.getViewModelStore(), owner instanceof HasDefaultViewModelProviderFactory
        ? ((HasDefaultViewModelProviderFactory) owner).getDefaultViewModelProviderFactory()
        : NewInstanceFactory.getInstance());
  }

  // ② Use ViewModelStoreOwner, Factory
  public ViewModelProvider(@NonNull ViewModelStoreOwner owner, @NonNull Factory factory) { 
    this(owner.getViewModelStore(), factory);
  }

  // ③ Use ViewModelStore, Factory
  public ViewModelProvider(@NonNull ViewModelStore store, @NonNull Factory factory) {
    mFactory = factory;
    mViewModelStore = store;
  }
  ...
}
```

3개의 생성자에서 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 생성시 최종적으로 필요한 것은 [ViewModelStore](https://developer.android.com/reference/androidx/lifecycle/ViewModelStore) 과 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 라는 것을 알 수 있습니다. 지금까지 글을 읽으신 분들은 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) 을 누가 구현하고 있는지 알고 있습니다. 네! 바로 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 입니다. 

만약  ① 생성자를 사용한 경우 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) 가 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 인터페이스 타입인지 체크합니다. [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 인터페이스 구현한 객체 또한 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 입니다. 

여기서 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 가 구현하는 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 인터페이스를 살펴보겠습니다.

### HasDefaultViewModelProviderFactory

[ComponentActivity.java](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/ComponentActivity.java#396)

```java
@NonNull
@Override
public ViewModelProvider.Factory getDefaultViewModelProviderFactory() {
   ...
   mDefaultFactory = new SavedStateViewModelFactory(
      getApplication(),
      this,
      getIntent() != null ? getIntent().getExtras() : null); // ◀ Activity로 전달받은 Argument가 전달
   ...
   return mDefaultFactory;
}
```

[Fragment.java](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/fragment/fragment/src/main/java/androidx/fragment/app/Fragment.java#392)

```java
@NonNull
@Override
public ViewModelProvider.Factory getDefaultViewModelProviderFactory() {
   ...
   mDefaultFactory = new SavedStateViewModelFactory(
      requireActivity().getApplication(),
      this,
      getArguments()); // ◀ Fragment로 전달받은 Argument가 전달
   }
   return mDefaultFactory;
}
```

두 객체 모두에서 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 라는 클래스가 사용된 것을 확인할 수 있습니다. 이것은 AndroidX [Activity:1.1.0](https://developer.android.com/jetpack/androidx/releases/activity#version_110_3) / [Fragment:1.2.0](https://developer.android.com/jetpack/androidx/releases/fragment#version_120_3) 의 릴리즈 노트를 통해서 두 가지 Artifact 모두 상태 저장을 기본적으로 지원하는 형태로 변경된 모습이기도 합니다.

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 에서 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 인스턴스 생성시 3번째 파라미터 넘겨지는 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 객체를 유심히 살펴볼 필요가 있습니다. 바로 이 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 값이 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 의 기본값으로 사용 (🎉🎉🎉) 됩니다. 이 내용은 이후의 파트에서 더 살펴보겠습니다.

### 사용사례 : activity-ktx

```kotlin
@MainThread
inline fun <reified VM : ViewModel> ComponentActivity.viewModels(
  noinline factoryProducer: (() -> Factory)? = null
): Lazy<VM> {
  val factoryPromise = factoryProducer ?: {
    defaultViewModelProviderFactory
  }

  return ViewModelLazy(VM::class, { viewModelStore }, factoryPromise)
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity-ktx/src/main/java/androidx/activity/ActivityViewModelLazy.kt

activity-ktx 를 이용해서 ViewModel을 가져오는 경우에도 앞서 언급한 viewModelStore과 defaultViewModelProviderFactory을 사용하고 있는 모습을 볼 수 있습니다.

### SavedStateViewModelFactory

가장 먼저 [HasDefaultViewModelProviderFactory](https://developer.android.com/reference/androidx/lifecycle/HasDefaultViewModelProviderFactory) 인터페이스의 구현에 사용되는 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 를 살펴보겠습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/SavedStateViewModelFactory.png" }}" />

[SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 는 [ViewModelProvider.KeyedFactory](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.java#65) 라는 추상 클래스를 상속해서 구현하고 있습니다. 아쉽게도 해당 클래스는 외부로 공개된 클래스가 아니라서 개발자가 직접 상속받아서 구현할 수는 없습니다. 이 클래스는 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 인터페이스를 구현하여 ViewModel을 인스턴스화하는 역할을 가지고 있습니다. 또한 해당 ViewModel에 지정된 키를 수신하는 확장 Factory입니다.

> key 구성 : ViewModelProvider.DEFAULT_KEY + ":" + modelClass.getCanonicalName()
>
> 예시 : androidx.lifecycle.ViewModelProvider.DefaultKey:com.pluu.savedstate.ui.SavedStateCounterViewModel

[SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 에서 구현하는 create 의 구현을 살펴보겠습니다.

```java
@NonNull
@Override
public <T extends ViewModel> T create(@NonNull String key, @NonNull Class<T> modelClass) {
  boolean isAndroidViewModel = AndroidViewModel.class.isAssignableFrom(modelClass);
  ...
  Constructor<T> constructor;
  constructor = ... // Define ViewModel Constructor
  // Case 1, SavedStateHandle가 불필요한 경우
  if (constructor == null) {
    return mFactory.create(modelClass);
  }

  // Case 2, SavedStateHandle가 필요한 경우
  SavedStateHandleController controller = SavedStateHandleController.create(
      mSavedStateRegistry, mLifecycle, key, mDefaultArgs);
  try {
    T viewmodel;
    // SavedStateHandleController를 통해서 SavedStateHandle을 전달
    if (isAndroidViewModel) {
      viewmodel = constructor.newInstance(mApplication, controller.getHandle());
    } else {
      viewmodel = constructor.newInstance(controller.getHandle());
    }
    ...
    return viewmodel;
  }
  ...
}
```

`modelClass` 로 넘어오는 클래스가 [AndroidViewModel](https://developer.android.com/reference/androidx/lifecycle/AndroidViewModel) 여부에 따라서 별도의 생성자 구현을 정합니다. [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 의 필요 여부에 따라서 ViewModel 생성을 진행합니다. [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 가 필요시에는 [SavedStateHandleController](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandleController.java) 를 사용해서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 가져오는 모습을 확인할 수 있습니다. [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel) 에서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 생성자로 넘겨받는 것이 이 코드입니다.

## SavedState

이제 본 글의 후반부입니다. [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 에서 생성하는 클래스는 [SavedStateHandleController](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandleController.java), [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 이 있습니다. 그리고, ComponentActivity/Fragment에서 호출하는 [SavedState
RegistryController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController)가 컨트롤하는 객체인 [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry)가 있습니다. 이 파트에서 언급하는 클래스들이 상태 저장을 위한 중요한 클래스입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/SavedStateHandleController.png" }}" />

### 상태 복원 / 저장 대상 트리거 추가

1. [SavedStateRegistryController#performRestore(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performRestore(android.os.Bundle))
2. SavedStateRegistry#performRestore(Lifecycle, Bundle?) ◀ 상태 저장 복원
3. [ViewModelProvider#get(String, Class\<T\>)](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider#get(java.lang.String,%20java.lang.Class%3CT%3E))
4. [SavedStateViewModelFactory#create(String, Class\<T\>)](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory#create(java.lang.String,%20java.lang.Class%3CT%3E))
5. SavedStateHandleController#create(SavedStateRegistry, Lifecycle, String, Bundle)
6. [SavedStateRegistry#consumeRestoredStateForKey(String)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#consumeRestoredStateForKey(java.lang.String))
7. SavedStateHandle#createHandle(Bundle?, Bundle?) ◀ restoredState 복원, defaultState 값 적용
8. SavedStateHandleController#attachToLifecycle(SavedStateRegistry, Lifecycle)
9. [SavedStateRegistry#registerSavedStateProvider(String, SavedStateProvider)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#registerSavedStateProvider(java.lang.String,%20androidx.savedstate.SavedStateRegistry.SavedStateProvider)) ◀ 상태 저장 대상 추가
10. SavedStateHandleController#tryToAddRecreator(SavedStateRegistry, Lifecycle)
11. [SavedStateRegistry#runOnNextRecreation(Class<? extends AutoRecreated>)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#runOnNextRecreation(java.lang.Class%3C?%20extends%20androidx.savedstate.SavedStateRegistry.AutoRecreated%3E))
12. Create Recreator.SavedStateProvider
13. [SavedStateRegistry#registerSavedStateProvider(Recreator.COMPONENT_KEY, SavedStateProvider)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#registerSavedStateProvider(java.lang.String,%20androidx.savedstate.SavedStateRegistry.SavedStateProvider)) ◀ 상태 저장 대상 추가
14. Recreator.SavedStateProvider#add(String) ◀ Recreator 상태 저장 대상 추가

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 에서 호출되는 [SavedStateRegistryController#performRestore(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performRestore(android.os.Bundle)) 을 통해 상태 복원의 흐름을 살펴봤습니다. 

### 상태 저장

1. [SavedStateRegistryController#performSave(Bundle)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performSave(android.os.Bundle))
2. SavedStateRegistry#performSave(Bundle) ◀ 상태 저장을 위해 등록된 객체만 처리
   1. Save state SavedStateHandle.SavedStateProvider
   2. Save state Recreator.SavedStateProvider

상태 복원에 비해서 상태 저장의 단계는 매우 간단합니다. 

### SavedStateHandle

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0314-savedstate-flow/SavedStateHandle.png" }}" />

#### SavedStateHandle 상태 복원

AndroidX 내부 [SavedStateHandleController](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController) 에서 SavedStateHandle 사용에는 Static 메소드인 `SavedStateHandle#createHandle(Bundle?, Bundle?)`를 사용해서 SavedStateHandle 객체를 생성합니다.

AndroidX의 일부 코드를 살펴보겠습니다.

```java
public final class SavedStateHandle {
  static SavedStateHandle createHandle(@Nullable Bundle restoredState,
    @Nullable Bundle defaultState) {
    ...
    Map<String, Object> state = new HashMap<>();
    if (defaultState != null) {
      for (String key : defaultState.keySet()) {
        state.put(key, defaultState.get(key));
      }
    }
    ...
    ArrayList keys = restoredState.getParcelableArrayList(KEYS);
    ArrayList values = restoredState.getParcelableArrayList(VALUES);
    ...
    for (int i = 0; i < keys.size(); i++) {
      state.put((String) keys.get(i), values.get(i));
    }
    return new SavedStateHandle(state);
  }
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandle.java#99

복원용 데이터와 기본 데이터로 전달된 값을 하나의 Map에 추가되는 간단한 로직입니다. 기본 데이터가 복원 데이터에 의해서 덮어 쓰일 수 있습니다.

#### SavedStateHandle 상태 저장

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 의 상태 저장은 간단합니다. [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 에서 다뤄지는 값은 모두 Map 형태로 되어있는 `mRegular` 변수에 저장되어 있음으로, key/value 를 각각 ArrayList 형태로 Bundle에 저장하고 있습니다.

```java
public final class SavedStateHandle {
  final Map<String, Object> mRegular;
  ...
  private final SavedStateProvider mSavedStateProvider = new SavedStateProvider() {
    @NonNull
    public Bundle saveState() {
      Set<String> keySet = mRegular.keySet();
      ArrayList keys = new ArrayList(keySet.size());
      ArrayList value = new ArrayList(keys.size());
      ...
      Bundle res = new Bundle();
      res.putParcelableArrayList("keys", keys);
      res.putParcelableArrayList("values", value);
      return res;
    }
  };
  ...
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandle.java#63

## 정리

지금까지 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 를 통해서 `SavedState`, 즉 저장된 상태가 어떻게  저장/복원되는지를 살펴봤습니다. 전체적인 흐름을 보았을 때 AndroidX 내부의 코드는 복원보다 저장의 흐름이 상당히 짧은 것을 볼 수 있습니다. 또한 빠른 저장을 위해서 [SavedStateRegistry#registerSavedStateProvider(String, SavedStateProvider)](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#registerSavedStateProvider(java.lang.String,%20androidx.savedstate.SavedStateRegistry.SavedStateProvider)) 에 저장된 상태를 트리거 형태로 저장한 후 사용하는 모습도 보았습니다.

여기까지 긴 글을 읽어주셔서 감사합니다.

------

본 글에서 다루는 FlowChart를 빠르게 확인하기 위해서는 아래 링크를 참고해주세요

- ComponentActivity : [download (1.26 MB - 8,486px X 7,084px)](http://bit.ly/33lBmQK)
- Fragment : [download (1.67MB - 8,486px X 10,932px)](http://bit.ly/2TTgsoM)

일부 Flowchart는 화면에 다 담기에 큰 이미지로 인해 위 이미지를 참고하시면 됩니다.

------

ViewModel 에 대해서 총 5개의 글을 소개할 예정입니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ page.url }}) <-- 현재 글
- 5부 : TBD
