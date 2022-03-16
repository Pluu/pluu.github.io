---
layout: post
title: "ViewModel InitializerViewModelFactory"
date: 2022-03-16 22:00:00 +09:00
tag: [Android, AndroidX, ViewModel]
categories:
- blog
- Android
---

본 글에서는 새롭게 도입된 InitializerViewModelFactory에 대해서 소개합니다.

<!--more-->

------

**테스트 환경**

- androidx.lifecycle 2.5.0-alpha04
- androidx.activity:activity-ktx:1.5.0-alpha03

------

Androidx lifecycle-viewmodel 2.5.0-alpha03에서 새롭게 ViewModelProvider.Factory 중 하나인 `InitializerViewModelFactory`가 추가되었습니다.

* 2.5.0-alpha03 릴리즈 노트 : https://developer.android.com/jetpack/androidx/releases/lifecycle#2.5.0-alpha03

## InitializerViewModelFactory

먼저 아래의 InitializerViewModelFactory의 실제 코드를 살펴봅니다.

```kotlin
// ViewModel 클래스와 해당 클래스에 대한 Initializer Holder
class ViewModelInitializer<T : ViewModel>(
  internal val clazz: Class<T>,
  internal val initializer: CreationExtras.() -> T,
)

internal class InitializerViewModelFactory(
    private vararg val initializers: ViewModelInitializer<*>
) : ViewModelProvider.Factory {
  override fun <T : ViewModel> create(modelClass: Class<T>, extras: CreationExtras): T {
    var viewModel: T? = null
    @Suppress("UNCHECKED_CAST")
    // 가변 인자 initializers에서 생성하려는 modelClass를 찾은 후, 생성을 요청
    initializers.forEach {
      if (it.clazz == modelClass) {
        viewModel = it.initializer.invoke(extras) as? T
      }
    }
    // viewModel가 생성되지 않았다면 IllegalArgumentException 에러 발생
    return viewModel ?: throw IllegalArgumentException(
      "No initializer set for given class ${modelClass.name}"
    )
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-viewmodel/src/main/java/androidx/lifecycle/viewmodel/InitializerViewModelFactory.kt

InitializerViewModelFactory의 내부 코드는 매우 간단합니다. 단순히 **loop를 돌면서 생성할 수 있는 ViewModel class를 찾아서 생성**하는 로직입니다. 

하지만, InitializerViewModelFactory는 `internal`이므로 androidx 외부에서는 접근할 수 없습니다. 대신 Kotlin에 더 친화적인 DSL 패턴으로 작성할 수 있는 API를 제공합니다.

## InitializerViewModelFactoryBuilder

InitializerViewModelFactoryBuilder는 InitializerViewModelFactory의 DSL Builder로 작성할 수 있도록 해주는 클래스입니다.

### DSL 형태 예제

```kotlin
val factory: ViewModelProvider.Factory = viewModelFactory {
  initializer { // this : CreationExtras
    // Create, ViewModel A
  }

  initializer { // this : CreationExtras
    // Create, ViewModel B
  }
}
```

viewModelFactory 함수로 전달되는 Builder 내부에서 `initializer` DSL을 정의한 후, ViewModel을 반환하도록 만드는 형태입니다.

### InitializerViewModelFactoryBuilder 

가장 먼저 사용하는 기능은 `viewModelFactory`입니다. 이 함수는 Builder에서 제공되는 initializer를 사용하여 InitializerViewModelFactory를 생성합니다. 이후 함수를 호출한 곳에서는 ViewModelProvider.Factory 타입으로만 다룰 수 있습니다.

```kotlin
public inline fun viewModelFactory(
    builder: InitializerViewModelFactoryBuilder.() -> Unit
): ViewModelProvider.Factory = InitializerViewModelFactoryBuilder().apply(builder).build()
```

viewModelFactory로 넘겨지는 builder 파라미터는 **리시버를 가진 함수 리터럴(Function literals with Receiver)**형태입니다. 해당 builder를 사용하는 곳에서는 InitializerViewModelFactoryBuilder의 기능을 사용할 수 있습니다.

```kotlin
// ViewModelProvider.Factory 생성을 위한 DSL
@ViewModelFactoryDsl
public class InitializerViewModelFactoryBuilder {
    private val initializers = mutableListOf<ViewModelInitializer<*>>()

    // 주어진 ViewModel 클래스에 대한 initializer를 추가
    fun <T : ViewModel> addInitializer(clazz: KClass<T>, initializer: CreationExtras.() -> T) {
        initializers.add(ViewModelInitializer(clazz.java, initializer))
    }

    // InitializerViewModelFactory를 빌드
    fun build(): ViewModelProvider.Factory =
        InitializerViewModelFactory(*initializers.toTypedArray())
}


// InitializerViewModelFactoryBuilder에 initializer 추가
inline fun <reified VM : ViewModel> InitializerViewModelFactoryBuilder.initializer(
    noinline initializer: CreationExtras.() -> VM
) {
    addInitializer(VM::class, initializer)
}
```

InitializerViewModelFactoryBuilder에는 initializer를 추가할 수 있는 **addInitializer**와 DSL 형태로 구현할 수 있는 `initializer` Extension도 제공하고 있습니다. 위와 같은 구현으로 우리가 원하는 생성하려는 ViewModel을 DSL 형태로 코드를 작성할 수 있습니다.

## InitializerViewModelFactory를 적용한 예제 코드

#### Test ViewModel

InitializerViewModelFactory를 사용해서 샘플로 만들어 볼 ViewModel은 다음과 같습니다.

```kotlin
class MainViewModel(
  private val savedStateHandle: SavedStateHandle,
  private val id: Int
) : ViewModel()

class SampleViewModel(
  private val id: Int
) : ViewModel()
```

#### Activity

```kotlin
// CreationExtras Key
private val testExtraKey = object : CreationExtras.Key<Int> {}

// Create, InitializerViewModelFactoryBuilder
val factory: ViewModelProvider.Factory = viewModelFactory {
  // MainViewModel
  initializer {
    // Convert, SavedStateHandle
    val savedStateHandle = createSavedStateHandle()
    val id = get(testExtraKey) ?: -1
    MainViewModel(
      savedStateHandle = savedStateHandle,
      id = id
    )
  }

  // SampleViewModel
  initializer {
    val id = get(testExtraKey) ?: -1
    SampleViewModel(id)
  }
}

///////////////////////////////////////////////////////////////////////////
// Create ViewModel
///////////////////////////////////////////////////////////////////////////

// Create, MainViewModel
val viewModel: MainViewModel = ViewModelProvider(
  viewModelStore,
  factory,
  MutableCreationExtras(defaultViewModelCreationExtras).apply {
    set(testExtraKey, 1234)
    set(DEFAULT_ARGS_KEY, bundleOf("self_extra_key" to "test"))
  }
).get()

// Create, SampleViewModel
val sampleViewModel: SampleViewModel = factory.create(
  SampleViewModel::class.java,
  MutableCreationExtras(defaultViewModelCreationExtras).apply {
    set(testExtraKey, 1234)
  }
)
```

> ViewModel CreationExtras은 다음 링크를 참고해주세요.
>
> - http://pluu.github.io/blog/android/2022/03/12/creationextras/

InitializerViewModelFactory를 사용해서 ViewModel을 생성하는 코드입니다. 1개씩만 정의 가능했던 복수의 ViewModel 생성을 한 번에 정의할 수 있습니다. 

추가로, ViewModel에서 `SavedStateHandle`을 사용할 경우에는 ViewModelProvider#get을 사용하거나 별도로 `VIEW_MODEL_KEY`를 대응한 후 `createSavedStateHandle()`을 사용하여 손쉽게 **SavedStateHandle**를 생성할 수 있습니다.

Dagger2 혹은 AssistedInject를 사용하여 ViewModelProvider.Factory을 대응하는 코드의 변화도 생길 것으로 기대합니다.
