---
layout: post
title: "Lifecycle-ktx flowWithLifecycle API"
date: 2021-04-03 23:00:00 +09:00
tag: [Android, AndroidX, Lifecycle]
categories:
- blog
- Android
---

Android Jetpack 라이브러리인 AndroidX는 다양한 카테고리의 내용들을 대응하고 있습니다. 그중 생명주기와 관련있는 AndroidX가 바로 Lifecycle입니다. 그리고, 최근 AndroidX Lifecycle 2.4.0-alpha01 버전이 새롭게 출시되었습니다. 

<!--more-->

------

> 사전에 읽으면 좋은 문서
>
> A safer way to collect flows from Android UIs : https://medium.com/androiddevelopers/a-safer-way-to-collect-flows-from-android-uis-23080b1f8bda

------

본 글에서는 `Lifecycle 2.4.0-alpha01`에서 추가된 API를 살펴보겠습니다. 이 버전에서는 새로운 KTX들도 추가되었으며, 아래와 같이 추가된 API에 대한 내용을 설명하고 있습니다.

> Added a Flow.flowWithLifecycle API that emits values from the upstream Flow when the lifecycle is at least in a certain state using the Lifecycle.repeatOnLifecycle API. This is an alternative to the also new LifecycleOwner.addRepeatinJob API
>
> 출처 : https://developer.android.com/jetpack/androidx/releases/lifecycle#2.4.0-alpha01

요약하면 Lifecycle.`repeatOnLifecycle` API를 사용하여 특정 생명주기 상태 이후 일 때에만 업스트림의 Flow의 값을 내보내는 API가 추가되었습니다. API 설명에서의 `repeat`라는 단어가 언급되는 것으로 `반복 작업`을 위한 기능이라는 것을 알 수 있습니다.

실제로 AndroidX Lifecycle 2.4.0-alpha01에서는 아래의 KTX API가 추가되었습니다.

- [Lifecycle.repeatOnLifecycle](https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#repeatonlifecycle)
- [LifecycleOwner.addRepeatinJob](https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#addrepeatingjob)
- [Flow.flowWithLifecycle](https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#flowwithlifecycle)

## Lifecycle.repeatOnLifecycle

> Reference Lifecycle.repeatOnLifecycle : https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#repeatonlifecycle

#### 함수 구조

먼저 repeatOnLifecycle API는 Lifecycle의 Exntension Function입니다. 개발 시에서는 `Lifecycle`을 가지는 Activity, Fragment에서 손쉽게 사용할 수 있으며 ViewTreeLifecycleOwner API를 사용하면 View에서도 Lifecycle을 취득해서 사용할 수 있습니다.

```kotlin
public suspend fun Lifecycle.repeatOnLifecycle(
   state: Lifecycle.State,
   block: suspend CoroutineScope.() -> Unit
) {
   ...
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/RepeatOnLifecycle.kt

Lifecycle이 파라미터로 전달된 상태 안팎으로 이동하면 코루틴 블록이 실행/취소됩니다. `repeatOnLifecycle`는 코루틴을 일시 중지할 수 있는 `suspend` 함수입니다. 즉, 해당 함수 호출 시에는 Coroutine Scope 내에서의 호출이 필요합니다.

#### 이벤트가 시작 및 종료되는 시점

앞서 이야기한 것처럼 `repeatOnLifecycle` KTX은 특정 생명주기에 따라 코루틴 블록이 실행되고 취소됩니다. 다만 함수의 파라미터로 받는 것은 `Lifecycle.State`이므로 그에 매칭되는 Lifecycle로 변경이 필요합니다. 그리고 이 처리는 Lifecycle.State의 upTo/downFrom 함수를 통해서 유효한 Lifecycle 범위를 가져옵니다

```kotlin
public suspend fun Lifecycle.repeatOnLifecycle(
   state: Lifecycle.State,
   block: suspend CoroutineScope.() -> Unit
) {
   ...
   coroutineScope {
      withContext(Dispatchers.Main.immediate) {
         try {
            suspendCancellableCoroutine<Unit> { cont ->
               // 시작 이벤트                                 
               val startWorkEvent = Lifecycle.Event.upTo(state)
               // 취소 이벤트
               val cancelWorkEvent = Lifecycle.Event.downFrom(state)
               ...
            }
         }
      }
   }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/RepeatOnLifecycle.kt

Lifecycle.State에 따른 시작/취소되는 생명주기는 아래와 같습니다.

**Lifecycle.Event.upTo에 따른 시작 이벤트**

| 생명주기 상태           | 생명주기 이벤트           |
| ----------------------- | ------------------------- |
| Lifecycle.State.CREATED | Lifecycle.Event.ON_CREATE |
| Lifecycle.State.STARTED | Lifecycle.Event.ON_START  |
| Lifecycle.State.RESUMED | Lifecycle.Event.ON_RESUME |
| 기타                    | null                      |

**Lifecycle.Event.downFrom에 따른 취소 이벤트**

| 생명주기 상태           | 생명주기 이벤트            |
| ----------------------- | -------------------------- |
| Lifecycle.State.CREATED | Lifecycle.Event.ON_DESTROY |
| Lifecycle.State.STARTED | Lifecycle.Event.ON_STOP    |
| Lifecycle.State.RESUMED | Lifecycle.Event.ON_PAUSE   |
| 기타                    | null                       |

#### 내부 코드로 동작 살펴보기

이어서 `repeatOnLifecycle`의 코드를 통해서 동작을 살펴보겠습니다.

```kotlin
public suspend fun Lifecycle.repeatOnLifecycle(
   state: Lifecycle.State,
   block: suspend CoroutineScope.() -> Unit
) {
   // Lifecycle.State.INITIALIZED는 LifecycleOwner의 초기 상태이며
   // Activity의 경우 생성되었지만 아직 onCreate에 진입하지 않은 상태이다.
   // 
   // 현재 repeatOnLifecycle API는 Lifecycle.State.INITIALIZED를 허용하지 않는다.
   require(state !== Lifecycle.State.INITIALIZED) {
      "repeatOnLifecycle cannot start work with the INITIALIZED lifecycle state."
   }

   // LifecycleOwner가 파괴된 상태에서는 코루틴 블록을 실행시키지 않는다.
   if (currentState === Lifecycle.State.DESTROYED) {
      return
   }

   coroutineScope {
      withContext(Dispatchers.Main.immediate) {
         // LifecycleOwner가 파괴된 상태에서는 코루틴 블록을 실행시키지 않는다.
         if (currentState === Lifecycle.State.DESTROYED) return@withContext

         var launchedJob: Job? = null

         var observer: LifecycleEventObserver? = null

         try {
            suspendCancellableCoroutine<Unit> { cont ->
               // 코루틴 블록을 실행/취소할 생명주기를 취득한다.
               val startWorkEvent = Lifecycle.Event.upTo(state)
               val cancelWorkEvent = Lifecycle.Event.downFrom(state)                                               
               // 생명주기 이벤트를 수신할 Observer 생성
               observer = LifecycleEventObserver { _, event ->
                  // 실행할 생명주기와 매칭되면 코루틴 블록을 실행                                
                  if (event == startWorkEvent) {
                     launchedJob = this@coroutineScope.launch(block = block)
                     return@LifecycleEventObserver
                  }
                  // 취소할 생명주기와 매칭되면 코루틴 블록을 실행한 Job을 취소 요청
                  if (event == cancelWorkEvent) {
                     launchedJob?.cancel()
                     launchedJob = null
                  }
                  if (event == Lifecycle.Event.ON_DESTROY) {
                     cont.resume(Unit)
                  }
               }
               // 생명주기 이벤트를 수신할 Observer를 등록
               this@repeatOnLifecycle.addObserver(observer as LifecycleEventObserver)
            }
         } finally {
            // 종료시 코루틴 블록을 실행한 Job을 취소 요청         
            launchedJob?.cancel()
            // 생명주기 이벤트를 수신할 Observer를 해제
            observer?.let {
               this@repeatOnLifecycle.removeObserver(it)
            }
         }
      }
   }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/RepeatOnLifecycle.kt

## LifecycleOwner.addRepeatingJob

앞서 소개한 Lifecycle.`repeatOnLifecycle`는 Coroutine Scope가 필요한 API입니다. Coroutine Scope 생성없이 간편하게 `repeatOnLifecycle`를 호출할 수 있는 KTX가 바로 `addRepeatingJob`입니다.

#### 내부 코드로 동작 살펴보기

실제로 LifecycleOwner의 Coroutine Scope인  `lifecycleScope` 와 CoroutineContext를 이용해서 `repeatOnLifecycle`를 호출하도록 정의되어 있습니다.

```kotlin
public fun LifecycleOwner.addRepeatingJob(
   state: Lifecycle.State,
   coroutineContext: CoroutineContext = EmptyCoroutineContext,
   block: suspend CoroutineScope.() -> Unit
): Job = lifecycleScope.launch(coroutineContext) {
   lifecycle.repeatOnLifecycle(state, block)
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/RepeatOnLifecycle.kt

아래는 `addRepeatingJob` KTX를 사용한 샘플 코드입니다.

```kotlin
lifecycleOwner.addRepeatingJob(Lifecycle.State.STARTED) {
   uiStateFlow.collect { uiState ->
      updateUi(uiState)
   }
}
```

샘플에서는 lifecycleOwner가 STARTED 이상일 때 코루틴 블록을 실행하며, ON_STOP 이벤트가 발생하면 취소되고 lifecycleOwner의 수명주기가 ON_START 이벤트를 다시 수신하면 블록 실행을 다시 시작합니다.

## Flow.flowWithLifecycle

#### 내부 코드로 동작 살펴보기

Flow를 위한 Extension Function인 `flowWithLifecycle` 또한 내부적으로 `repeatOnLifecycle`을 사용하고 있습니다. Flow을 실행하는 생명주기 상태로 Lifecycle.State.`STARTED` 가 기본 파라미터 값으로 지정되어 있습니다. repeatOnLifecycle의 스펙과 동일하게 minActiveState로 전달된 Lifecycle 상태 안팎으로 이동하면 Flow의 수집을 자동으로 시작하고 취소합니다. 또한 Receiver에 해당하는 Flow\<T\>를 `callbackFlow`로 한번 Wrapping 한 형태로 처리하는 모습을 볼 수 있습니다.

```kotlin
@OptIn(ExperimentalCoroutinesApi::class)
public fun <T> Flow<T>.flowWithLifecycle(
   lifecycle: Lifecycle,
   minActiveState: Lifecycle.State = Lifecycle.State.STARTED
): Flow<T> = callbackFlow {
   lifecycle.repeatOnLifecycle(minActiveState) {
      this@flowWithLifecycle.collect {
         // Receiver Flow의 값을 수신한 후 callbackFlow에 값을 전달
         send(it)
      }
   }
   close()
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/FlowExt.kt

아래는 `flowWithLifecycle` KTX를 사용한 샘플 코드입니다.

```kotlin
class MyActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      /* ... */
      lifecycleScope.launch {
         flow
            .flowWithLifecycle(lifecycle, Lifecycle.State.STARTED)
            .collect {
               // Consume flow emissions
            }
      }
   }
}
```

------

참고 자료

- A safer way to collect flows from Android UIs : https://medium.com/androiddevelopers/a-safer-way-to-collect-flows-from-android-uis-23080b1f8bda

