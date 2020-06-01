---
layout: post
title: "ViewModel의 B에서 D까지"
date: 2020-05-04 15:15:00 +09:00
tag: [Android, AndroidX, FragmentResult]
categories:
- blog
- Android
---

지금까지 Android의 기본적인 상태 저장에서부터 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)를 사용한 상태 저장에 대해서 몇 가지의 글을 작성했습니다. 그리고, [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)를 어떻게 이루어지는지 AndroidX 내부의 움직임을 살펴봤습니다.

이번 글에서는 ViewModel 객체가 생성되는 순간에서 제거되는 순간을 확인해보려고 합니다.

<!--more-->

ViewModel 에 대해서 총 5개의 글을 소개합니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ site.url }}/blog/android/2020/03/15/savedstate-flow/)
- 5부 : [ViewModel의 탄생에서 죽음까지]({{ page.url }}) <-- 현재 글

------

**전제 조건**

```groovy
// app build.gradle

dependencies {
  implementation 'androidx.activity:activity-ktx:1.1.0'

  def lifecycle_version = "2.2.0"
  implementation "androidx.lifecycle:lifecycle-extensions:$lifecycle_version"
  implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycle_version"
}
```

## Birth. ViewModel 생성 요청

### ViewModel 사용 패턴

ViewModel 을 사용하기 위해서는 ViewModel 요청이 가장 첫 시작 포인트일 것입니다. 

ViewModel 요청은 아래 코드에서 볼 수 있는 것처럼 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 을 사용해서 객체를 요청합니다.

```kotlin
// 패턴1. 기본적인 ViewModelProvider를 사용하여 객체 요청
counterViewModel = ViewModelProvider(this).get(CounterViewModel::class.java)

// 패턴2. ktx
val counterViewModel: CounterViewModel by viewModels()
```

그리고 패턴2의 ktx를 사용한 방법은 `lifecycle-viewmodel-ktx`에 있는 Lazy를 사용한 방법입니다. 이 방법 또한 실제로 패턴1과 동일한 ViewModelProvider를 사용하여 객체 요청합니다.

> 패턴 2에서 사용하는 Kotlin 코드는 다음 클래스로 확인할 수 있습니다.
>
> - activity-ktx : [ActivityViewModelLazy.kt](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:activity/activity-ktx/src/main/java/androidx/activity/ActivityViewModelLazy.kt?q=ActivityViewModelLazy.kt) ◀◀◀ activity에서 `by viewModels()` 사용시 호출되는 코드
> - fragment-ktx : [FragmentViewModelLazy.kt](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:fragment/fragment-ktx/src/main/java/androidx/fragment/app/FragmentViewModelLazy.kt?q=FragmentViewModelLazy.kt) ◀◀◀ fragment에서 `by viewModels()` 사용시 호출되는 코드
> - lifecycle-viewmodel-ktx : [ViewModelProvider.kt](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel-ktx/src/main/java/androidx/lifecycle/ViewModelProvider.kt;l=54?q=ViewModelProvider.kt) ◀◀◀ ActivityViewModelLazy / FragmentViewModelLaz 에서 호출하는 Lazy 코드의 실체

### ViewModelProvider

ViewModel 사용 시 요청하는 곳이 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 이라른 것을 이미 우리는 알고 있습니다. 이전 글에서도 다루었지만, 다시한번 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 의 생성자를 확인해보겠습니다.

#### ViewModelProvider 생성자

```java
class ViewModelProvider {
  public ViewModelProvider(@NonNull ViewModelStoreOwner owner) { // 생성자 패턴 1
    this(owner.getViewModelStore(), owner instanceof HasDefaultViewModelProviderFactory
          ? ((HasDefaultViewModelProviderFactory) owner).getDefaultViewModelProviderFactory()
          : NewInstanceFactory.getInstance());
  }

  public ViewModelProvider(@NonNull ViewModelStoreOwner owner, @NonNull Factory factory) { // 생성자 패턴 2
    this(owner.getViewModelStore(), factory);
  }

  public ViewModelProvider(@NonNull ViewModelStore store, @NonNull Factory factory) { // 생성자 패턴 3
    mFactory = factory;
    mViewModelStore = store;
  }
  ...
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.java?q=ViewModelProvider

생성자 패턴1의 경우 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) 타입을 전달받고 있습니다. 기존 Activity에서는 ViewModelStoreOwner를 전달된 코드는 보이지 않았습니다.

> counterViewModel = ViewModelProvider(this).get(CounterViewModel::class.java)

이때 확인해야 할 사항은 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) 는 인터페이스라는 점입니다. 그리고, ViewModelStoreOwner 인터페이스를 구현하는 클래스 중에서 우리가 자주 사용하는 클래스는 아래의 2 클래스가 주요 클래스입니다.

- ComponentActivity
- Fragment

또한 ComponentActivity, Fragment를 상속하는 클래스도 [ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner) 인터페이스의 성격을 가집니다.

- ComponentActivity
  - FragmentActivity
    - AppCompatActivity
- Fragment
  - DialogFragment
    - AppCompatDialogFragment

#### ViewModelProvider#get()

실제로 [ViewModelProvider#get(String, Class\<T\>)](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider#get(java.lang.String,%20java.lang.Class%3CT%3E)) 함수를 이용해서 ViewModel 인스턴스를 가져오는 처리를 실행합니다. ViewModelProvider에 존재하는 2개의 get함수 중 key 와 modelCalss 를 파라매터로 받는 함수가 메인 함수입니다.

```java
class ViewModelProvider {
  ...  
  @NonNull
  @MainThread
  public <T extends ViewModel> T get(@NonNull String key, @NonNull Class<T> modelClass) {
    ViewModel viewModel = mViewModelStore.get(key);
    
    if (modelClass.isInstance(viewModel)) {
      if (mFactory instanceof OnRequeryFactory) {
        ((OnRequeryFactory) mFactory).onRequery(viewModel);
      }
      return (T) viewModel;
    } else {
      ...
    }
    if (mFactory instanceof KeyedFactory) {
      viewModel = ((KeyedFactory) (mFactory)).create(key, modelClass);
    } else {
      viewModel = (mFactory).create(modelClass);
    }
    mViewModelStore.put(key, viewModel);
    return (T) viewModel;
  }
  ...
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.java;l=170?q=ViewModelProvider

[ViewModelProvider#get(String, Class\<T\>)](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider#get(java.lang.String,%20java.lang.Class%3CT%3E)) 내부의 처리는 다음과 같습니다.

1. ViewModelStore에서 Key에 해당하는 viewModel 정보를 취득
2. viewModel 이 modelClass 타입의 인스턴스 상태이면 반환
3. 인스턴스 상태가 아닌 경우, mFactory의 종류에 따라서 ViewModel 인스턴스 생성을 요청
4. ViewModelStore에 key와 viewModel를 이용해서 저장
5. viewModel 인스턴스를 반환

3번 항목을 통해서 우리가 알아낸 사실은 이름대로 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 또한 Provider(제공자) 역할을 하는 클래스라는 것입니다. [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 가 호출하는 실제 ViewModel 인스턴스 생성을 담당은 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 입니다.

> ViewModelStore는 ViewModel을 임시 저장하는 Store 클래스입니다. 내부 구현과 자세한 움직임은 이후에 살펴보겠습니다.

### ViewModelProvider.Factory

```java
public class ViewModelProvider {
  public interface Factory {
    @NonNull
    <T extends ViewModel> T create(@NonNull Class<T> modelClass);
  }
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.java;l=41?q=ViewModelProvider

[ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 은 새로운 ViewModel 인스턴스를 만드는 역할을 정의한 인터페이스입니다. 이 인터페이스에는 [ViewModelProvider.Factory#create(Class\<T\>)](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory#create(java.lang.Class%3CT%3E)) 메소드만 정의되어 있으며, modelClass에 대한 정보를 전달받은 후 ViewModel 인스턴스를 반환하는 역할을 하고 있습니다. 현재 AndroidX에 정의된 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 의 구현 클래스의 종류는 아래와 같습니다.

ViewModelProvider.Factory
- AbstractSavedStateViewModelFactory ◀◀◀ SavedStateHandle 지원 시 사용하는 추상 클래스
- SavedStateViewModelFactory ◀◀◀ SavedStateHandle 주입에 사용
- ViewModelProvider.AndroidViewModelFactory ◀◀◀ AndroidViewModel 생성을 지원
- ViewModelProvider.NewInstanceFactory◀◀◀ 기본적인 ViewModel을 생성하는 Factory 클래스
- ViewModelProviders.DefaultFactory ◀◀◀ deprecated

### ViewModel 탄생 정리

1. ViewModelProvider 객체 생성
2. ViewModelProvider#get 을 통해 ViewModel 요청
3. ViewModelStore에 없을 경우 ViewModelProvider.Factory을 통해서 객체 생성 후 반환
4. ViewModelStore에 인스턴스화한 ViewModel을 저장

이것으로 ViewModel 생성 시에 중요한 키 역할을 하는 것은 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory) 인터페이스의 구현 클래스라는 것을 알 수 있습니다.

## Death. ViewModel이 사라지기까지

ViewModel은 언제 사라지는가에 대해서 생각해보신적 있으신가요? ViewModel의 소유자(Owner)의 생명주기가 완료되면 리소스 정리를 위해서 [ViewModel#onCleared()](https://developer.android.com/reference/androidx/lifecycle/ViewModel#onCleared()) 가 호출된다는 것을 알고 있습니다.

<img src="https://developer.android.com/images/topic/libraries/architecture/viewmodel-lifecycle.png" width="400" />

> 이미지 출처 : https://developer.android.com/topic/libraries/architecture/viewmodel

이후에서는 [ViewModel#onCleared()](https://developer.android.com/reference/androidx/lifecycle/ViewModel#onCleared()) 을 호출하는 요소, 즉 ViewModel을 Death에 관련된 부분을 살펴보겠습니다.

### ViewModelStore

먼저 ViewModel 탄생에서 생략한 ViewModelStore를 살펴봅니다. 

ViewModelStore는 이름에서 알 수 있듯이 ViewModel을 저장하는 클래스입니다. 

또한, `ViewModel#clear`를 호출하는 역할도 담당하고 있습니다. 호출시 우리가 알고 있는 [ViewModel#onCleared()](https://developer.android.com/reference/androidx/lifecycle/ViewModel#onCleared()) 을 호출합니다. 다만 `ViewModel#clear` 함수는 public은 아닙니다. 오직 AndroidX 내부에서 호출되기 위해서 만들어졌으며 프레임워크에서 사용되는 함수입니다

```java
public class ViewModelStore {
  private final HashMap<String, ViewModel> mMap = new HashMap<>();
  
  final void put(String key, ViewModel viewModel) {
    ViewModel oldViewModel = mMap.put(key, viewModel);
    if (oldViewModel != null) {
      oldViewModel.onCleared(); // ◀◀◀ ViewModel#onCleared() 호출
    }
  }
  ...
  public final void clear() {
    for (ViewModel vm : mMap.values()) {
      vm.clear(); // ◀◀◀ ViewModel#clear() 내부에서 ViewModel#onCleared() 호출
    }
    mMap.clear();
  }
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelStore.java

ViewModelStore는 ViewModel의 소유자(Owner)가 인턴스형태로 가지고 있으며, 생명주기가 종료시에 [ViewModelStore#clear()](https://developer.android.com/reference/androidx/lifecycle/ViewModelStore#clear())를 호출하여 ViewModel이 종료되도록 동작합니다. 또한, `ViewModelStore#put(String, ViewModel)` 할 경우에도 이미 Store 내부에 오래된 ViewModel 존재하는 경우 [ViewModel#onCleared()](https://developer.android.com/reference/androidx/lifecycle/ViewModel#onCleared()) 을 명시적으로 호출합니다.

### ViewModelStore#clear() 호출

지금까지 ViewModelStore가 ViewModel을 저장하는 클래스이며, 종료를 담당하는 클래스라는 것을 알았습니다. 이제 [ViewModelStore#clear()](https://developer.android.com/reference/androidx/lifecycle/ViewModelStore#clear()) 를 호출하는 곳을 살펴보겠습니다. 

#### ComponentActivity

ViewModel의 소유자(=[ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner))는 ComponentActivity/Fragment라는 것을 이전에 설명했습니다. 그중 첫 번째는 ComponentActivity의 생성자에서 생명주기가 Lifecycle.Event.ON_DESTORY일 경우, 즉 Activity가 종료되는 경우에 [ViewModelStore#clear()](https://developer.android.com/reference/androidx/lifecycle/ViewModelStore#clear()) 를 호출합니다.

```java
public class ComponentActivity ... {
  public ComponentActivity() {
    ...
    getLifecycle().addObserver(new LifecycleEventObserver() {
      @Override
      public void onStateChanged(@NonNull LifecycleOwner source, 
        @NonNull Lifecycle.Event event) {
        if (event == Lifecycle.Event.ON_DESTROY) {
          if (!isChangingConfigurations()) {
            getViewModelStore().clear(); // ◀◀◀ ViewModelStore#clear() 호출
          }
        }
      }
    });
    ...
  }
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:activity/activity/src/main/java/androidx/activity/ComponentActivity.java;l=247?q=ComponentActivity

#### FragmentManagerViewModel

ViewModel의 또 다른 소유자(=[ViewModelStoreOwner](https://developer.android.com/reference/androidx/lifecycle/ViewModelStoreOwner)) 중 하나인 Fragment와 관련된 흐름은 ComponentActivity보다 조금 복잡합니다. Fragment가 Activity/Fragment에서 detach되어 종료된 경우에 호출이 됩니다.

1. [FragmentStateManager#destroy()](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:fragment/fragment/src/main/java/androidx/fragment/app/FragmentStateManager.java;l=666?q=FragmentStateManager)
2. FragmentStore#getNonConfig()
3. FragmentManagerViewModel#clearNonConfigState()

```java
final class FragmentManagerViewModel extends ViewModel {
  ...
  void clearNonConfigState(@NonNull Fragment f) {
    ...
    // Clear and remove the Fragment's ViewModelStore
    ViewModelStore viewModelStore = mViewModelStores.get(f.mWho);
    if (viewModelStore != null) {
      viewModelStore.clear();
      mViewModelStores.remove(f.mWho);
    }
  }
  ...
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:fragment/fragment/src/main/java/androidx/fragment/app/FragmentManagerViewModel.java;l=193?q=FragmentManagerViewModel

## 정리

지금까지 ViewModel의 탄생에서부터 죽음까지를 살펴봤습니다. 단편적으로 여러분들이 알고 있던 함수가 주요 키포인트였고, 그 주변 로직들과 연관지어 ViewModel의 B에서 D까지는 가는 것을 살펴봤습니다.

------

이것으로 ViewModel과 상태 저장에 대한 5부작 글을 마칩니다. 

긴 글을 읽어주셔서 감사합니다.

------

ViewModel 에 대해서 총 5개의 글을 소개합니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ site.url }}/blog/android/2020/03/15/savedstate-flow/)
- 5부 : [ViewModel의 탄생에서 죽음까지]({{ page.url }}) <-- 현재 글
