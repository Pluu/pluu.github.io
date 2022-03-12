---
layout: post
title: "ViewModel CreationExtras"
date: 2022-03-12 16:00:00 +09:00
tag: [Android, AndroidX, ViewModel]
categories:
- blog
- Android
---

본 글에서는 새롭게 도입된 ViewModel CreationExtras에 대해서 소개합니다.

<!--more-->

**테스트 환경**

- androidx.lifecycle 2.5.0-alpha04
- androidx.activity:activity-ktx:1.5.0-alpha03

------

Android의 ViewModel을 생성하는 방법 중 하나인 ViewModelProvider.Factory의 API가 lifecycle-viewmodel 2.5.0-alpha01부터 변경되었습니다.

> 2.5.0-alpha01 릴리즈 노트 : https://developer.android.com/jetpack/androidx/releases/lifecycle#2.5.0-alpha01

기존 Factory 내부에서 상태 저장이 가능 유무를 판단하여 처리하던 것과 추가 데이터 전달에 불편함을 해소를 위해서 적용된 내용으로 보입니다.

> 참고
>
> - Issue Tracker ~ [Allow easily pass additional data to ViewModelProvider.Factory.create()](https://issuetracker.google.com/issues/188541057)
> - Android Review ~ [1748315: Introduce CreationExtras](https://android-review.googlesource.com/c/platform/frameworks/support/+/1748315/19/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.kt#b168)

**Component에 추가된 정보**

View Component 측면에서 ViewModel CreationExtras 처리가 기본적으로 제공되는 버전은 다음과 같습니다.

- Activity 1.5.0-alpha01 이상
- Fragment 1.5.0-alpha01 이상
- Navigation 2.5.0-alpha01 이상

------

## CreationExtras 적용으로 변경된 예제 코드

```kotlin
class CustomFactory : ViewModelProvider.Factory {
  override fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T {
    return when (modelClass) {
      HomeViewModel::class -> {
        // extras에서 Application 객체 가져오기
        val application = checkNotNull(extras[ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY])
        // HomeViewModel에 직접 전달
        HomeViewModel(application)
      }
      DetailViewModel::class -> {
        // extras에서 ViewModel에 전달할 SavedStateHandle 생성
        val savedStateHandle = extras.createSavedStateHandle()
        DetailViewModel(savedStateHandle)
      }
      else -> throw IllegalArgumentException("Unknown class $modelClass")
    } as T
  }
}
```

> 소스 출처 : https://developer.android.com/jetpack/androidx/releases/lifecycle#2.5.0-alpha01

간략한 변경된 내용은 아래와 같습니다

- create 함수에 `CreationExtras` 파라미터 추가
- CreationExtras에 `ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY`를 전달하여 Application 취득
- CreationExtras#`createSavedStateHandle` 확장 함수를 통해 SavedStateHandle로 변환

기존 Factory에 필요한 파라미터 전달이 CreationExtras를 통해서 전달되는 형태로 변경되었습니다.

## ViewModelProvider

변경된 ViewModelProvider는 아래와 같습니다.

```kotlin
public open class ViewModelProvider {
  // ...  
  /**
   * Implementations of `Factory` interface are responsible to instantiate ViewModels.
   */
  public interface Factory {
    public fun <T : ViewModel> create(modelClass: Class<T>): T {
      throw UnsupportedOperationException(
          "Factory.create(String) is unsupported.  This Factory requires " +
          "`CreationExtras` to be passed into `create` method."
      )
    }

    public fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T =
      create(modelClass)
    }
  // ...
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/ViewModelProvider.kt#L59

기존과 변경된 부분으로 ViewModelProvider.Factory에 `CreationExtras` 항목이 추가되었습니다. 그리고 단순 interface였지만, Default Method를 가지는 Interface로 변경되었습니다. 그로 인해 Default Method를 호출 시 **UnsupportedOperationException**가 발생합니다. [CreationExtras](https://developer.android.com/reference/androidx/lifecycle/viewmodel/CreationExtras)는 ViewModelProvider.Factory에 데이터 전달을 위해서 만들어진 객체입니다. 상세 내용은 이후의 섹션에서 다루겠습니다.

ViewModelProvider.Factory API 변경으로 인해서 Interface를 `SavedStateViewModelFactory`/`AbstractSavedStateViewModelFactory`도 영향을 받습니다.

### viewModels KTX

기존 viewModels을 가져오는 KTX 또한 CreationExtras를 전달받을 수 있는 형태로 변경되었습니다.

```kotlin
@MainThread
public inline fun <reified VM : ViewModel> ComponentActivity.viewModels(
  noinline extrasProducer: (() -> CreationExtras)? = null,
  noinline factoryProducer: (() -> Factory)? = null
): Lazy<VM> {
  val factoryPromise = factoryProducer ?: {
    defaultViewModelProviderFactory
  }

  return ViewModelLazy(
    VM::class,
    { viewModelStore },
    factoryPromise,
    { extrasProducer?.invoke() ?: this.defaultViewModelCreationExtras }
  )
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/activity/activity-ktx/src/main/java/androidx/activity/ActivityViewModelLazy.kt#L75

CreationExtras를 전달받을 수 있는 람다 `extrasProducer`는 기본 nullable이며, 값이 없는 경우 HasDefaultViewModelProviderFactory의 `defaultViewModelCreationExtras` 함수를 통해서 기본값을 가져옵니다.

혹시 HasDefaultViewModelProviderFactory를 구현하는 Component(Activity/Fragment 등)에서 extrasProducer 람다를 사용할 경우 defaultViewModelCreationExtras 전달도 잊지 말아야 합니다.

### defaultViewModelCreationExtras

이전부터 HasDefaultViewModelProviderFactory에는 ViewModelProvider.Factory를 관리하는 getDefaultViewModelProviderFactory이 이미 존재했습니다. 이번 업데이트로 ViewModelProvider에서 사용될 기본 데이터를 정의하는 `getDefaultViewModelCreationExtras` 함수가 새롭게 추가되었습니다.

```java
public interface HasDefaultViewModelProviderFactory {
  @NonNull
  ViewModelProvider.Factory getDefaultViewModelProviderFactory();

  /**
   * Returns the default {@link CreationExtras} that should be passed into the
   * {@link ViewModelProvider.Factory#create(Class, CreationExtras)} when no overriding
   * {@link CreationExtras} were passed to the
   * {@link androidx.lifecycle.ViewModelProvider} constructors.
   */
  @NonNull
  default CreationExtras getDefaultViewModelCreationExtras() {
    return CreationExtras.Empty.INSTANCE;
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/HasDefaultViewModelProviderFactory.java

위의 HasDefaultViewModelProviderFactory 인터페이스를 구현한 사례 중 하나인 ComponentActivity를 살펴보겠습니다.

```java
public class ComponentActivity ... {
  @NonNull
  @Override
  @CallSuper
  public CreationExtras getDefaultViewModelCreationExtras() {
    MutableCreationExtras extras = new MutableCreationExtras();
    if (getApplication() != null) {
      extras.set(ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY, getApplication());
    }
    extras.set(SavedStateHandleSupport.SAVED_STATE_REGISTRY_OWNER_KEY, this);
    extras.set(SavedStateHandleSupport.VIEW_MODEL_STORE_OWNER_KEY, this);
    if (getIntent() != null && getIntent().getExtras() != null) {
      extras.set(SavedStateHandleSupport.DEFAULT_ARGS_KEY, getIntent().getExtras());
    }
    return extras;
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/activity/activity/src/main/java/androidx/activity/ComponentActivity.java#L615

ComponentActivity에서는 아래의 값을 ViewModelProvider.Factory에 전달합니다.

| KEY                                                       | Value                   | Required |
| --------------------------------------------------------- | ----------------------- | :------: |
| ViewModelProvider.AndroidViewModelFactory.APPLICATION_KEY | Application             |          |
| SavedStateHandleSupport.SAVED_STATE_REGISTRY_OWNER_KEY    | SavedStateRegistryOwner | ○        |
| SavedStateHandleSupport.VIEW_MODEL_STORE_OWNER_KEY        | ViewModelStoreOwner     | ○        |
| SavedStateHandleSupport.DEFAULT_ARGS_KEY                  | Bundle                  |          |

SavedStateHandleSupport.DEFAULT_ARGS_KEY에는 Activity 시작 시 전달된 Bundle 정보들이 그대로 전달됩니다. 추후에 Intent의 Extra 값이 SavedStateHandle에 담겨 ViewModel로 전달됩니다.

## CreationExtras

ViewModelProvider.Factory에 추가 정보를 제공하기 위해 `ViewModelProvider.Factory.create`에 전달되는 Map과 유사한 객체입니다. 

```kotlin
public sealed class CreationExtras {
  internal val map: MutableMap<Key<*>, Any?> = mutableMapOf()

  public interface Key<T>

  public abstract operator fun <T> get(key: Key<T>): T?

  object Empty : CreationExtras() {
    override fun <T> get(key: Key<T>): T? = null
  }
}

public class MutableCreationExtras(initialExtras: CreationExtras = Empty) : CreationExtras() {
  init {
    vmap.putAll(initialExtras.map)
  }
  
  public operator fun <T> set(key: Key<T>, t: T) {
    map[key] = t
  }

  public override fun <T> get(key: Key<T>): T? {
    @Suppress("UNCHECKED_CAST")
    return map[key] as T?
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/viewmodel/CreationExtras.kt

CreationExtras에는 Read-only의 CreationExtras와 Read-Write MutableCreationExtras가 존재합니다. get/set을 원하는 타입으로 처리하기 위해서 제네릭이 사용되었습니다.

### CreationExtras를 SavedStateHandle로 변환하는 createSavedStateHandle 확장 함수

CreationExtras는 ViewModelProvider.Factory에 데이터를 전달하는 용도였다면, SavedStateHandle는 ViewModel에서 필요한 데이터를 담아두는 용도입니다. 이때 변환 가능한 `createSavedStateHandle` 확장 함수가 있습니다.

```kotlin
@MainThread
public fun CreationExtras.createSavedStateHandle(): SavedStateHandle {
  val savedStateRegistryOwner = this[SAVED_STATE_REGISTRY_OWNER_KEY]
    ?: throw IllegalArgumentException(
      "CreationExtras must have a value by `SAVED_STATE_REGISTRY_OWNER_KEY`"
    )
  val viewModelStateRegistryOwner = this[VIEW_MODEL_STORE_OWNER_KEY]
    ?: throw IllegalArgumentException(
      "CreationExtras must have a value by `VIEW_MODEL_STORE_OWNER_KEY`"
    )

  val defaultArgs = this[DEFAULT_ARGS_KEY]
  val key = this[VIEW_MODEL_KEY] ?: throw IllegalArgumentException(
    "CreationExtras must have a value by `VIEW_MODEL_KEY`"
  )
  return createSavedStateHandle(
    savedStateRegistryOwner, viewModelStateRegistryOwner, key, defaultArgs
  )
}

private fun createSavedStateHandle(
  savedStateRegistryOwner: SavedStateRegistryOwner,
  viewModelStoreOwner: ViewModelStoreOwner,
  key: String,
  defaultArgs: Bundle?
): SavedStateHandle {
  val vm = viewModelStoreOwner.savedStateHandlesVM
  val savedStateRegistry = savedStateRegistryOwner.savedStateRegistry

  // restoredState와 defaultState Bundle로 SavedStateHandle를 생성
  val handle = SavedStateHandle.createHandle(
    savedStateRegistry.consumeRestoredStateForKey(key), defaultArgs
  )
  val controller = SavedStateHandleController(key, handle)
  controller.attachToLifecycle(savedStateRegistry, savedStateRegistryOwner.lifecycle)
  vm.controllers.add(controller)

  return handle
}

// 생성할 ViewModel의 ViewModelStoreOwner에 해당하는 SavedStateRegistryOwner의 키
@JvmField
val SAVED_STATE_REGISTRY_OWNER_KEY = object : CreationExtras.Key<SavedStateRegistryOwner> {}

// 생성할 ViewModel의 Owner인 ViewModelStoreOwner의 키
@JvmField
val VIEW_MODEL_STORE_OWNER_KEY = object : CreationExtras.Key<ViewModelStoreOwner> {}

// 필요한 경우 SavedStateHandle에 전달되어야 하는 기본 값에 대한 키
@JvmField
val DEFAULT_ARGS_KEY = object : CreationExtras.Key<Bundle> {}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-viewmodel-savedstate/src/main/java/androidx/lifecycle/SavedStateHandleSupport.kt#L90

위 코드를 통해서 알 수 있는 사실은, CreationExtras에는 복수의 정보가 포함되어 있으며 대부분 필수 값에 해당합니다.

| KEY                            | Value Type              | Required |
| ------------------------------ | ----------------------- | :------: |
| SAVED_STATE_REGISTRY_OWNER_KEY | SavedStateRegistryOwner | ○        |
| VIEW_MODEL_STORE_OWNER_KEY     | ViewModelStoreOwner     | ○        |
| DEFAULT_ARGS_KEY               | Bundle                  | ○        |
| VIEW_MODEL_KEY                 | String                  | ○        |

`DEFAULT_ARGS_KEY` 키 정보에 값을 추가하면 SavedStateHandle에 포함되며 최종적으로 ViewModel에 전달됩니다.

## 최종 예제 + 결과

샘플로 보는 CreationExtras에 값 전달

- DEFAULT_ARGS_KEY (SavedStateHandle에 포함)
  - "self_extra_key" : "test"
- 개별 CreationExtras.Key (SavedStateHandle에 미포함)
  - 1234 값 반영

```kotlin
///////////////////////////////////////////////////////////////////////////
// Activity
///////////////////////////////////////////////////////////////////////////
class MainActivity : AppCompatActivity() {
  // CreationExtras Key
  private val testExtraKey = object : CreationExtras.Key<Int> {}

  override fun onCreate(savedInstanceState: Bundle?) {
    // ...
    // Create, ViewModelProvider.Factory
    val factory = object : ViewModelProvider.Factory {
      @Suppress("UNCHECKED_CAST")
      override fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T {
        // Convert, SavedStateHandle
        val savedStateHandle = extras.createSavedStateHandle()
        // CreationExtras.Key로 정의한 값을 추출 (기본값 -1)
        val id = extras[testExtraKey] ?: -1
        return MainViewModel(
          savedStateHandle = savedStateHandle,
          id = id
        ) as T
      }
    }

    // Create, ViewModel
    val viewModel: MainViewModel by viewModels(
      extrasProducer = {
        MutableCreationExtras(defaultViewModelCreationExtras).apply {
          // CreationExtras Key에 1234 값 반영
          set(testExtraKey, 1234)
          // MainViewModel 생성시 기본 데이터 반영
          set(DEFAULT_ARGS_KEY, bundleOf("self_extra_key" to "test"))
        }
      },
      factoryProducer = { factory }
    )
    viewModel.toString()
  }
}

///////////////////////////////////////////////////////////////////////////
// ViewModel
///////////////////////////////////////////////////////////////////////////
class MainViewModel(
    private val savedStateHandle: SavedStateHandle,
    private val id: Int
) : ViewModel() {
    init {
        logcat {
            "savedStateHandle = (" + savedStateHandle.keys()
                .joinToString(separator = ", ") {
                    "${it}:${savedStateHandle.get<Any>(it)}"
                } + ")"
        }
        logcat { "id = $id" }
    }
}
```

Logcat에 출력된 결과는 다음과 같습니다.

```bash
D/MainViewModel: savedStateHandle = (self_extra_key:test)
D/MainViewModel: id = 1234
```

