---
layout: post
title: "AndroidX Lifecycle ~ ViewTreeLifecycleOwner"
date: 2020-12-21 23:30:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

본 글은 Jetpack AndroidX Lifecycle에 추가된 `ViewTreeLifecycleOwner`, `ViewTreeViewModelStoreOwner` 를 다루는 글입니다.

<!--more-->

------

AndroidX Lifecycle은 Activity/Fragment의 컴포넌트 생명 주기와 상태 변경에 필요한 작업을 도와주는 Artifact입니다. 내부에는 ViewModel과 LiveData도 Lifecycle에 포함되어 있습니다.

어느덧 AndroidX Lifecycle도 2.3.0-rc01 버전이 출시되었고, 곧 새로운 기능들이 정식 버전으로 만나볼 수 있습니다.

## ViewTreeLifecycleOwner

새롭게 추가된 `ViewTreeLifecycleOwner.get(View)` API를 사용해 `LifecycleOwner`를 얻을 수 있습니다. **lifecycle-runtime-ktx**에 추가된 `View.findViewTreeLifecycleOwner` KTX를 사용하면 쉽게 사용할 수 있습니다.

또한, `ViewTreeViewModelStoreOwner.get(View)` API를 사용해 `ViewModelStoreOwner`를 얻을 수 있습니다. **lifecycle-viewmodel-ktx**에 추가된 `View.findViewTreeViewModelStoreOwner` KTX를 사용하면 쉽게 사용할 수 있습니다.

자세한 내용은 아래에서 더 살펴보겠습니다.

> ViewTreeSavedStateRegistryOwner 에 해당하는 항목은 생략합니다.

### Release

Lifecycle Version 2.3.0-alpha01

> https://developer.android.com/jetpack/androidx/releases/lifecycle#2.3.0-alpha01

Lifecycle Version 2.3.0-alpha03

> https://developer.android.com/jetpack/androidx/releases/lifecycle#2.3.0-alpha03

#### 사전 조건

사용 시 주의 사항으로 `ViewTreeLifecycleOwner` , 을 올바르게 사용하려면 아래와 같이 Activity, Fragment의 버전을 업그레이드해야 합니다.

- Activity 1.2.0-alpha05
- Fragment 1.3.0-alpha05
- AppCompat 1.3.0-alpha01

## Code

### ViewTreeLifecycleOwner

```java
public class ViewTreeLifecycleOwner {
    ...
    public static void set(@NonNull View view, @Nullable LifecycleOwner lifecycleOwner) {
        view.setTag(R.id.view_tree_lifecycle_owner, lifecycleOwner);
    }

    @Nullable
    public static LifecycleOwner get(@NonNull View view) {
        LifecycleOwner found = (LifecycleOwner) view.getTag(R.id.view_tree_lifecycle_owner);
        if (found != null) return found;
        ViewParent parent = view.getParent();
        while (found == null && parent instanceof View) {
            final View parentView = (View) parent;
            found = (LifecycleOwner) parentView.getTag(R.id.view_tree_lifecycle_owner);
            parent = parentView.getParent();
        }
        return found;
    }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime/src/main/java/androidx/lifecycle/ViewTreeLifecycleOwner.java

ViewTreeLifecycleOwner의 set 함수는 View의 tag에 R.id.view_tree_lifecycle_owner Key로 LifecycleOwner를 저장하는 단순한 기능입니다.

또한 get 함수는 파라미터로 넘겨받은 View와 부모를 방문하면서 R.id.view_tree_lifecycle_owner로 지정한 Tag 정보가 있는지 찾습니다.

### ViewTreeViewModelStoreOwner

```java
public class ViewTreeViewModelStoreOwner {
    ...
    public static void set(@NonNull View view, @Nullable ViewModelStoreOwner viewModelStoreOwner) {
        view.setTag(R.id.view_tree_view_model_store_owner, viewModelStoreOwner);
    }

    @Nullable
    public static ViewModelStoreOwner get(@NonNull View view) {
        ViewModelStoreOwner found = (ViewModelStoreOwner) view.getTag(
                R.id.view_tree_view_model_store_owner);
        if (found != null) return found;
        ViewParent parent = view.getParent();
        while (found == null && parent instanceof View) {
            final View parentView = (View) parent;
            found = (ViewModelStoreOwner) parentView.getTag(R.id.view_tree_view_model_store_owner);
            parent = parentView.getParent();
        }
        return found;
    }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewTreeViewModelStoreOwner.java

ViewTreeViewModelStoreOwner는 ViewTreeLifecycleOwner와 기본 동작은 같습니다. R.id.view_tree_view_model_store_owner를 View tag의 key로 사용하며 `ViewModelStoreOwner`를 저장하고 가져오는 역할을 담당합니다.

## AndroidX 내부에 적용된 코드

ViewTreeLifecycleOwner#set, ViewTreeViewModelStoreOwner#set 메소드가 적용된 코드를 살펴보겠습니다.

```java
public class ComponentActivity ... {
    private void initViewTreeOwners() {
        // Set the view tree owners before setting the content view so that the inflation process
        // and attach listeners will see them already present
        ViewTreeLifecycleOwner.set(getWindow().getDecorView(), this);
        ViewTreeViewModelStoreOwner.set(getWindow().getDecorView(), this);
        ViewTreeSavedStateRegistryOwner.set(getWindow().getDecorView(), this);
    }
}
```

```java
public class AppCompatActivity ... {
    private void initViewTreeOwners() {
        // Set the view tree owners before setting the content view so that the inflation process
        // and attach listeners will see them already present
        ViewTreeLifecycleOwner.set(getWindow().getDecorView(), this);
        ViewTreeViewModelStoreOwner.set(getWindow().getDecorView(), this);
        ViewTreeSavedStateRegistryOwner.set(getWindow().getDecorView(), this);
    }
}
```

```java
public class Fragment ... {
    void performCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {
        ...
        if (mView != null) {
            ...
            // Tell the fragment's new view about it before we tell anyone listening
            // to mViewLifecycleOwnerLiveData and before onViewCreated, so that calls to
            // ViewTree get() methods return something meaningful
            ViewTreeLifecycleOwner.set(mView, mViewLifecycleOwner);
            ViewTreeViewModelStoreOwner.set(mView, this);
            ViewTreeSavedStateRegistryOwner.set(mView, mViewLifecycleOwner);
            ...
        } else {
            ...
        }
    }
}
```

기본적으로 Android 주요 Component인 ComponentActivity, AppCompatActivity, Fragment에 LifecycleOwner와 ViewModelStoreOwner를 얻을 수 있는 기반 코드가 적용되어 있습니다.

추가로 compose와 관련된 View에도 포함되어 있습니다.

> https://cs.android.com/search?q=ViewTreeLifecycleOwner.set
>
> https://cs.android.com/search?q=ViewTreeViewModelStoreOwner.set

## 동작 검증해보기

ComponentActivity, AppCompatActivity, Fragment에 ViewTreeLifecycleOwner#set, ViewTreeViewModelStoreOwner#set이 적용되어 있는 것을 알았으므로 우리가 할 것은 LifecycleOwner, ViewModelStoreOwner를 get하는 것입니다.

아래는 간단하게 LifecycleOwner, ViewModelStoreOwner 로그를 만드는 코드입니다. 

```kotlin
fun View.getViewTreeLog() = buildString {
    append("ViewTreeLifecycleOwner : ${findViewTreeLifecycleOwner()}")
    append(System.lineSeparator())
    append("ViewTreeViewModelStoreOwner : ${findViewTreeViewModelStoreOwner()}")
}
```

- findViewTreeLifecycleOwner : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/View.kt
- findViewTreeViewModelStoreOwner : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-viewmodel-ktx/src/main/java/androidx/lifecycle/ViewTreeViewModel.kt

Activity, Fragment, Custom View의 조합으로 각 View에서 참조하는 LifecycleOwner, ViewModelStoreOwner를 출력하는 샘플을 살펴보겠습니다.

### Sample

2개의 조합을 살펴보겠습니다.

- Case 1. Activity + Custom View : Activity안에 Custom View를 배치
- Case 2. Activity + Fragment + Custom View : Activity안에 Fragment 배치한 후 Fragment 내부에 CustomView 배치

|                Case 1. Activity + Custom View                |          Case 2. Activity + Fragment + Custom View           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1221-viewtreelifecycle/activity_customview.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1221-viewtreelifecycle/activity_fragment_customview.png" }}" /> |

### 결과 확인

위 결과에서 체크할 사항은 CustomView에 출력한 로그입니다.

- Case 1. Activity + Custom View
  - Activity와 동일한 로그
  - 즉, Activity와 동일한 LifecycleOwner, ViewModelStoreOwner
- Case 2. Activity + Fragment + Custom View
  - Fragment와 동일한 로그
  - 즉, Fragment와 동일한 LifecycleOwner, ViewModelStoreOwner

## 🚧🚧🚧🚧🚧 Another 🚧🚧🚧🚧🚧

> 이제부터는 위 결과를 토대로 어떻게 Android 개발시 응용? 변형? 할 수 있을지에 대한 내용입니다.
>
> 이 내용은 권장 사양은 아닙니다. 이렇게도?! 가능하다를 확인한 사항입니다.

이제 CustomView에서도 LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner를 얻을 수 있게 되었습니다. 이를 통해서 `Lifecycle`, `ViewModelStore`, `SavedStateRegistry`를 얻을 수 있습니다.

**이 사실이 아주 중요합니다.** 

복잡하고 덩치가 큰 Component 급의 View를 만들거나 스스로 다양한 행동을 하는 Custom View에서 아래와 같은 행동을 시도해볼 수 있습니다.

- Lifecycle를 사용해 View의 `생명주기`를 Observe할 수 있습니다.
  - https://developer.android.com/reference/androidx/lifecycle/Lifecycle#addObserver(androidx.lifecycle.LifecycleObserver)
- LifecycleOwner를 통해서 `LifecycleCoroutineScope`를 얻을 수 있습니다. 이것으로 CoroutineScope.launch, launchWhen* 등 함수를 사용 가능합니다.
  - https://developer.android.com/topic/libraries/architecture/coroutines#lifecyclescope
  - https://developer.android.com/reference/kotlin/androidx/lifecycle/LifecycleCoroutineScope
- ViewModelStore를 사용해 ViewModelProvider를 통해 `ViewModel 객체를 생성`할 수 있습니다.
  - https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider#ViewModelProvider(androidx.lifecycle.ViewModelStoreOwner)
- LiveData를 만들고 observe를 할 수 있습니다
  - https://developer.android.com/reference/androidx/lifecycle/LiveData?hl=en#observe(androidx.lifecycle.LifecycleOwner,%20androidx.lifecycle.Observer%3C?%20super%20T%3E)

### 샘플 소스

이번에 검증한 코드는 아래를 참고해주세요.

> https://github.com/Pluu/ViewTreeOwnerSample
