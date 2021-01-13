---
layout: post
title: "Lifecycle-ktx whenStateAtLeast와 withStateAtLeast ~ 1부"
date: 2021-01-12 23:00:00 +09:00
tag: [Android, AndroidX, Lifecycle]
categories:
- blog
- Android
---

최근 안드로이드 개발 시에 Kotlin `Coroutine` 도입을 긍정적으로 생각하는 곳이 늘어가고 있습니다. 그리고 AndroidX에도 Coroutine 사용을 돕고자 여러 가지 기능이 추가된 것을 아실 겁니다. 그중에서도 Activity/Fragment에서 사용되는 `lifecycleScope`와 ViewModel을 위한 `viewModelScope`가 흔하게 사용되는 기능일 것입니다.

<!--more-->

주제와 관련된 Lifecycle-ktx는 현재 2.3.0-rc01이 최신 버전입니다. 그중에서 생명주기에 따른 Coroutine을 처리하는 ktx도 존재하는데 바로 아래 2가지입니다.

- whenStateAtLeast 
- withStateAtLeast

이 2가지의 Lifecycle-ktx를 동작 방식에 대해서 알아보겠습니다.

## whenStateAtLeast

안드로이드 주요 컴포넌트 중에서 Activity/Fragment는 사용자와 밀접하게 상호 작용을 하며 `메인 스레드`에서만 UI를 변경할 수 있다는 특성도 가지고 있습니다. 그리고 Activity/Fragment의 UI 변경 요청을 `CREATE ~ RESUME` 생명주기에서 합니다. UI가 화면에서 사라졌거나 종료된 이후에 UI 변경을 하지는 것은 불필요한 처리일 수 있으며, 앱이 종료 (생명 주기가 Destroy인 상태에서 변경한 경우) 될 수 도 있습니다. 

이때 도움이 되는 Lifecycle-ktx가 `whenStateAtLeast`입니다. 이어서 살펴보도록 하겠습니다.

먼저 Android Developers 사이트에 기재되어 있는 whenStateAtLeast KTX의 설명을 정리를 하면 아래와 같습니다.

- Main 스레드에서 블록을 실행하고 Lifecycle의 상태가 최소 상태(minState)가 아닐 경우 일시 중단
- 블록이 실행 중 생명주기가 더 낮은 상태로 이동하면 생명주기가 최소 상태보다 크거나 같은 상태에 도달할 때까지 블록을 일시 중단

> 추가로 자세한 설명은 아래 링크를 참고하세요.
>
> - Android Developers : https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#whenstateatleast
> - 실제 코드 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/PausingDispatcher.kt;l=81?q=whenStateAtLeast

즉, Coroutine Scope 함수는 생명주기가 `지정한 범위 내에서만 유효`하며 범위를 벗어난 경우 일시 중단하는 기능입니다. 

#### whenStateAtLeast 함수의 종류

```kotlin
suspend fun <T> Lifecycle.whenStateAtLeast(
    minState: Lifecycle.State, 
    block: suspend CoroutineScope.() -> T
): T
```

기본 whenStateAtLeast 함수의 형태는 위와 같이 최소 생명주기 상태와 Coroutine Scope 함수 블록을 파라미터로 전달받는 구조입니다. 

**생명주기를 기본 정의한 ktx**

개발자는 whenStateAtLeast 함수를 원하는 형태로 사용할 수 있으며, 아래의 3가지 ktx를 제공합니다.

- whenCreated
- whenStarted
- whenResumed

`whenStateAtLeast` 함수를 사용하면서 minState로 Lifecycle.State의 값을 각각 CREATED/STARTED/RESUMED로 전달하는 간단한 extension 함수입니다.

```kotlin
public suspend fun <T> Lifecycle.whenCreated(block: suspend CoroutineScope.() -> T): T {
    return whenStateAtLeast(Lifecycle.State.CREATED, block)
}
public suspend fun <T> Lifecycle.whenStarted(block: suspend CoroutineScope.() -> T): T {
    return whenStateAtLeast(Lifecycle.State.STARTED, block)
}
public suspend fun <T> Lifecycle.whenResumed(block: suspend CoroutineScope.() -> T): T {
    return whenStateAtLeast(Lifecycle.State.RESUMED, block)
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/PausingDispatcher.kt

### whenStateAtLeast 적용

whenStateAtLeast의 여러 동작 중 `whenStarted`을 사용 시 어떤 결과가 일어나는지 살펴보겠습니다. 샘플로 테스트할 코드는 아래와 같습니다.

```kotlin
class PausingDispatcherActivity : AppCompatActivity() {
    private val viewModel: SampleViewModel by viewModels()
  
    override fun onCreate(savedInstanceState: Bundle?) {
        ...
        // lifecycleScope는 LifecycleCoroutineScope의 구현체
        // 호출 순서
        // 1. LifecycleCoroutineScope#launchWhenStarted
        // 2. Lifecycle.whenStarted
        lifecycleScope.launchWhenStarted {
            viewModel.flowCounter
                .collect {
                    binding.tvFlow.text = it.toString()
                    Timber.tag("Activity").d("Flow $it")
                }
        }
    }
}

class SampleViewModel : ViewModel() {
    val flowCounter: Flow<Int> = flow {
        var value = 0
        while (true) {
            value++
            Timber.tag("ViewModel").d("Flow : $value")
            emit(value)
            delay(1000L)
        }
    }
}
```

ViewModel에서 1초당 한 번씩 값을 내보내고 있으며, Activity에서는 `launchWhenStarted`을 통해서 suspend 함수인 whenStarted를 쉽게 호출합니다. 

> 위 코드에서는 생략되었지만 Activity의 생명 주기도 로그로 출력하도록 설정한 상태입니다.

Activity 시작한 후 일정 시간 후 앱을 홈 키 등으로 Background Process로 이동합니다. 그 후 앱 아이콘을 다시 눌러 Foreground Process로 상태로 만듭니다.

```bash
I/[Lifecycle] PausingDispatcherActivity: Created
I/[Lifecycle] PausingDispatcherActivity: Started <---- Flow 시작
D/ViewModel: Flow : 1
D/Activity: Flow 1
I/[Lifecycle] PausingDispatcherActivity: Resumed
D/ViewModel: Flow : 2
D/Activity: Flow 2
D/ViewModel: Flow : 3
D/Activity: Flow 3
I/[Lifecycle] PausingDispatcherActivity: Paused <---- Flow 일시 중지
I/[Lifecycle] PausingDispatcherActivity: Stopped
I/[Lifecycle] PausingDispatcherActivity: SaveInstanceState
I/[Lifecycle] PausingDispatcherActivity: Started <---- Flow 재개
D/ViewModel: Flow : 4
D/Activity: Flow 4
I/[Lifecycle] PausingDispatcherActivity: Resumed
D/ViewModel: Flow : 5
D/Activity: Flow 5
D/ViewModel: Flow : 6
D/Activity: Flow 6
D/ViewModel: Flow : 7
D/Activity: Flow 7
I/[Lifecycle] PausingDispatcherActivity: Paused <---- Flow 일시 중지
I/[Lifecycle] PausingDispatcherActivity: Stopped
I/[Lifecycle] PausingDispatcherActivity: SaveInstanceState
```

`whenStarted`의 의도대로 Flow를 수신하는 처리가 Activity의 **onStart()** 시점의 상태를 나타내는 **Lifecycle.State.STARTED** 이후부터 값을 수신합니다. 그리고, Activity의 **onPause()** 시점부터 수신을 일시 중지합니다.

Coroutine 함수를 일정한 생명주기에서만 활성화 상태로 하고 싶은 경우에 유용한 것을 알 수 있습니다.

## withStateAtLeast

다음으로 Androidx Lifecycle-ktx 2.3.0-alpha06에 추가된 `withStateAtLeast`입니다. withStateAtLeast의 특징은 아래와 같습니다.

- 지정한 생명주기 상태까지 대기하고, 지정한 생명주기 상태보다 크거나 같으면 일시 중단되지 않는 코드 블록을 실행
- 현재 생명주기가 **Lifecycle.State.DESTROYED**인 경우에 withStateAtLeast 호출 시 LifecycleDestroyedException 발생

> 추가로 자세한 설명은 아래 링크를 참고하세요.
>
> - Android Developers : https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#withstateatleast
> - 실제 코드 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/WithLifecycleState.kt;l=33
> - 릴리즈 노트 : https://developer.android.com/jetpack/androidx/releases/lifecycle#2.3.0-alpha06

**whenStateAtLeast**과 차이점을 눈치채셨나요? 지정한 블록의 `일시 중단`에 대한 처리가 없습니다.

### withStateAtLeast 함수의 종류

```kotlin
public suspend inline fun <R> Lifecycle.withStateAtLeast(
    state: Lifecycle.State,
    crossinline block: () -> R
): R {
    require(state >= Lifecycle.State.CREATED) {
        "target state must be CREATED or greater, found $state"
    }
    return withStateAtLeastUnchecked(state, block)
}
```

기본 withStateAtLeast 함수의 형태는 위와 같이 생명주기와 실행할 `함수 블록`을 파라미터로 전달받는 구조입니다. 함수 구조에서도 `whenStateAtLeast` 과 다른점으로 CoroutineScope 함수 대신 일반 함수 블록을 전달받고 있습니다. 그래서 함수의 구조만 보더라도 일시 중단을 지원하지 않는 것을 알 수 있습니다.

**생명주기를 기본 정의한 ktx**

개발자는 withStateAtLeast 함수를 원하는 형태로 사용할 수 있으며, 아래의 3가지 ktx를 제공합니다.

- withCreated
- withStarted
- withResumed

`withStateAtLeast` 함수를 사용하면서 state로 Lifecycle.State의 값을 각각 CREATED/STARTED/RESUMED로 전달하는 간단한 extension 함수입니다.

```kotlin
public suspend inline fun <R> Lifecycle.withCreated(
    crossinline block: () -> R
): R = withStateAtLeastUnchecked(
    state = Lifecycle.State.CREATED,
    block = block
)

public suspend inline fun <R> Lifecycle.withStarted(
    crossinline block: () -> R
): R = withStateAtLeastUnchecked(
    state = Lifecycle.State.STARTED,
    block = block
)

public suspend inline fun <R> Lifecycle.withResumed(
    crossinline block: () -> R
): R = withStateAtLeastUnchecked(
    state = Lifecycle.State.RESUMED,
    block = block
)
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/PausingDispatcher.kt

### withStateAtLeast 적용

withStateAtLeast의 여러 동작 중 `withStarted`을 사용 시 어떤 결과가 일어나는지 살펴보겠습니다. 샘플로 테스트할 코드는 아래와 같습니다.

```kotlin
class WithLifecycleStateActivity : AppCompatActivity() {
    private val viewModel: SampleViewModel by viewModels()
  
    override fun onCreate(savedInstanceState: Bundle?) {
        ...
        // 1. LifecycleOwner.withStarted
        lifecycleScope.launch {
            withStarted {
                lifecycleScope.launch {
                    viewModel.flowCounter
                        .collect {
                            binding.tvFlow.text = it.toString()
                            Timber.tag("Activity").d("Flow $it")
                        }
                }
            }
        }
    }
}

class SampleViewModel : ViewModel() {
    val flowCounter: Flow<Int> = flow {
        var value = 0
        while (true) {
            value++
            Timber.tag("ViewModel").d("Flow : $value")
            emit(value)
            delay(1000L)
        }
    }
}
```

ViewModel에서 1초당 한번 씩 값을 내보내고 있습니다. 

> 위 코드에서는 생략되었지만 Activity의 생명 주기도 로그로 출력하도록 설정한 상태입니다.

Activity 시작한 후 일정 시간 후 앱을 홈 키 등으로 Background Process로 이동합니다. 그 후 앱 아이콘을 다시 눌러 Foreground Process로 상태로 만듭니다.

```bash
I/[Lifecycle] WithLifecycleStateActivity: Created
I/[Lifecycle] WithLifecycleStateActivity: Started <---- Flow 시작
D/ViewModel: Flow : 1
D/Activity: Flow 1
I/[Lifecycle] WithLifecycleStateActivity: Resumed
D/ViewModel: Flow : 2
D/Activity: Flow 2
D/ViewModel: Flow : 3
D/Activity: Flow 3
I/[Lifecycle] WithLifecycleStateActivity: Paused
I/[Lifecycle] WithLifecycleStateActivity: Stopped
I/[Lifecycle] WithLifecycleStateActivity: SaveInstanceState
D/ViewModel: Flow : 4
D/Activity: Flow 4
D/ViewModel: Flow : 5
D/Activity: Flow 5
D/ViewModel: Flow : 6
D/Activity: Flow 6
D/ViewModel: Flow : 7
D/Activity: Flow 7
I/[Lifecycle] WithLifecycleStateActivity: Started
I/[Lifecycle] WithLifecycleStateActivity: Resumed
D/ViewModel: Flow : 9
D/Activity: Flow 9
D/ViewModel: Flow : 10
D/Activity: Flow 10
D/ViewModel: Flow : 11
D/Activity: Flow 11
I/[Lifecycle] WithLifecycleStateActivity: Paused
D/ViewModel: Flow : 12
D/Activity: Flow 12
I/[Lifecycle] WithLifecycleStateActivity: Stopped
I/[Lifecycle] WithLifecycleStateActivity: Destroyed <---- Flow 종료
```

결과를 통해서 알 수 있듯이 앱이 Background로 넘어가더라도 `withStarted` 내부에서 실행한 Flow는 멈추지 않습니다. 해당 컴포넌트의 LifecycleScope이 Destroy 상태가 되어야지 종료됩니다.

------

이것으로 1부의 내용으로 whenStateAtLeast와 withStateAtLeast의 개념과 동작 방식을 살펴봤습니다. 이어서 2부에서는 whenStateAtLeast와 withStateAtLeast의 내부 구현 코드를 통해서 어떻게 구현되었는지 살펴보겠습니다.

------

본 글에서 사용한 샘플 및 추가 코드는 아래 링크를 참고해주세요.

- 샘플 코드 : https://github.com/Pluu/LifecycleKtxSample
