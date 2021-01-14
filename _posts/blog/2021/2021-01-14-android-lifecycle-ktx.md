---
layout: post
title: "Lifecycle-ktx whenStateAtLeast와 withStateAtLeast ~ 2부"
date: 2021-01-14 23:00:00 +09:00
tag: [Android, AndroidX, Lifecycle]
categories:
- blog
- Android
---

지난 Lifecycle-ktx 1부에서는 whenStateAtLeast와 withStateAtLeast의 개념과 동작 방식을 살펴봤습니다. 2부에서는 각 기능의 내부 구현 코드를 살펴보겠습니다.

<!--more-->

- 1부 : http://pluu.github.io/blog/android/2021/01/12/androidx-lifecycle-ktx/
- 2부 : http://pluu.github.io/blog/android/2021/01/14/android-lifecycle-ktx/

## whenStateAtLeast 살펴보기

시작 전 1부에서 살펴본 whenStateAtLeast KTX의 설명을 다시 한번 보겠습니다.

- Main 스레드에서 블록을 실행하고 Lifecycle의 상태가 최소 상태(minState)가 아닐 경우 일시 중단
- 블록이 실행 중 생명 주기가 더 낮은 상태로 이동하면 생명 주기가 최소 상태보다 크거나 같은 상태에 도달할 때까지 블록을 일시 중단

이 내용을 기억하며 내부 코드를 살펴보겠습니다.

```kotlin
public suspend fun <T> Lifecycle.whenStateAtLeast(
   minState: Lifecycle.State,
   block: suspend CoroutineScope.() -> T
): T = withContext(Dispatchers.Main.immediate) {
    val job = coroutineContext[Job] ?: error("when[State] methods should have a parent job")
    val dispatcher = PausingDispatcher()
    val controller =
        LifecycleController(this@whenStateAtLeast, minState, dispatcher.dispatchQueue, job)
    try {
        withContext(dispatcher, block)
    } finally {
        controller.finish()
    }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/PausingDispatcher.kt

### Function Syntax

whenStateAtLeast의 주요 특징으로 블록을 `일시 중단`한다는 언급을 했습니다. 파라미터 중 block 이란 이름으로 정의된 syntax를 보면 `suspend` function입니다. 기본 API만 보더라도 일시 중단이 가능하다는 것을 노출하고 있습니다.

### Body

whenStateAtLeast 함수에서 살펴볼 클래스는 아래의 2가지 입니다.

- PausingDispatcher : Dispatch 필요 여부나 큐에 등록시키는 역할을 하는 Dispatcher (CoroutineDispatcher 클래스를 상속)
- LifecycleController : 지정한 생명 주기에 따라서 큐의 작업을 pause/resume/finish 호출

#### PausingDispatcher

PausingDispatcher는 처리할 작업들을 가진 CoroutineDispatcher입니다. `dispatch` 함수로 dispatchQueue에 전달하여 내부적으로 실행 혹은 작업 리스트에 등록합니다. `DispatchQueue#canRun()`을 통해서 작업 가능 여부를 판단합니다.

```kotlin
internal class PausingDispatcher : CoroutineDispatcher() {
    @JvmField
    internal val dispatchQueue = DispatchQueue()

    override fun isDispatchNeeded(context: CoroutineContext): Boolean {
        if (Dispatchers.Main.immediate.isDispatchNeeded(context)) {
            return true
        }
        return !dispatchQueue.canRun()
    }

    override fun dispatch(context: CoroutineContext, block: Runnable) {
        dispatchQueue.dispatchAndEnqueue(context, block)
    }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/PausingDispatcher.kt

#### DispatchQueue

DispatchQueue 클래스는 실제 Queue 인터페이스를 구현한 클래스가 아니라 내부에서 `dispatchAndEnqueue()`를 통해서 작업할 동작을 등록합니다. 여기에서는 주요 로직들만 살펴보겠습니다.

```kotlin
internal class DispatchQueue {
   private var paused: Boolean = true
   private var finished: Boolean = false
   ...
   private val queue: Queue<Runnable> = ArrayDeque<Runnable>()
  
   // 동작 제어를 pause/resume/finish 함수로 중지와 완료 플래그를 on/off 설정.

   @MainThread
   fun pause() {
      paused = true
   }

   @MainThread
   fun resume() {
      ...
      paused = false
      drainQueue()
   }

   @MainThread
   fun finish() {
      finished = true
      drainQueue()
   }
   ...  
   // 실행 가능 여부를 canRun() 함수로 확인하며,
   // 완료, 정지 flag를 사용해 실행 여부를 체크

   @MainThread
   fun canRun() = finished || !paused
  
   // PausingDispatcher#dispatch를 통해서 호출되는 dispatchAndEnqueue는
   // 실행 가능 여부를 확인한 후 블록을 실행하거나 큐에 추가.

   @AnyThread
   @SuppressLint("WrongThread")
   fun dispatchAndEnqueue(context: CoroutineContext, runnable: Runnable) {
      with(Dispatchers.Main.immediate) {
         if (isDispatchNeeded(context) || canRun()) {
             dispatch(context, Runnable { enqueue(runnable) })
         } else {
            enqueue(runnable)
         }
      }
   }
   ...
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/DispatchQueue.kt

#### LifecycleController

서두에 whenStateAtLeast의 특징으로 `지정한 범위 내의 생명 주기에서만 유효`하다고 언급했습니다. 이때 생명 주기에 따라 처리하는 클래스가 바로 **LifecycleController**입니다.

```kotlin
@MainThread
internal class LifecycleController(
   private val lifecycle: Lifecycle,
   private val minState: Lifecycle.State,
   private val dispatchQueue: DispatchQueue,
   parentJob: Job
) {
   private val observer = LifecycleEventObserver { source, _ ->
      if (source.lifecycle.currentState == Lifecycle.State.DESTROYED) {
         // 현재 생명 주기가 DESTROYED인 경우 종료 처리를 진행.
         handleDestroy(parentJob)
      } else if (source.lifecycle.currentState < minState) {
         // 현재 생명 주기가 지정한 생명 주기(minState)보다 작은 경우 일시 정지.
         dispatchQueue.pause()
      } else {
         // 현재 생명 주기가 지정한 생명 주기(minState)보다 크거나 같은 경우 일시 정지.
         dispatchQueue.resume()
      }
   }

   init {
      // LifecycleController 시작 시 현재 생명 주기가 DESTROYED인 경우 종료 처리를 진행.
      // 그 외에는 Lifecycle에 LifecycleEventObserver를 등록
      if (lifecycle.currentState == Lifecycle.State.DESTROYED) {
         handleDestroy(parentJob)
      } else {
         lifecycle.addObserver(observer)
      }
   }

   // 부모 Job을 취소한 후,
   // Lifecycle에 등록된 Observer 제거와 DispatchQueue#finish 호출
   @Suppress("NOTHING_TO_INLINE") 
   private inline fun handleDestroy(parentJob: Job) {
      parentJob.cancel()
      finish()
   }

   @MainThread
   fun finish() {
      lifecycle.removeObserver(observer)
      dispatchQueue.finish()
   }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/LifecycleController.kt

> DispatchQueue에 대해서 자세하게 알고 싶은 분은 다음 링크를 확인해보세요. 
>
> https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/DispatchQueue.kt

`LifecycleController`의 코드를 살펴봤을 때 주된 처리가 이 클래스를 통해서 이루어진다는 것을 알 수 있습니다.

## withStateAtLeast 살펴보기

시작 전 1부에서 살펴본 withStateAtLeast KTX의 설명을 다시 한번 보겠습니다.

- 지정한 생명 주기 상태까지 대기하고, 지정한 생명 주기 상태보다 크거나 같으면 코드 블록을 실행
- withStateAtLeast 호출 시 현재 생명 주기가 **Lifecycle.State.DESTROYED**인 경우 LifecycleDestroyedException 발생

이 내용을 기억하며 내부 코드를 살펴보겠습니다.

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

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/WithLifecycleState.kt

### Function Syntax

withStateAtLeast이 whenStateAtLeast와 `일시 중단` 지원 여부가 큰 차이점입니다. 파라미터 중 block 이란 이름으로 정의된 syntax를 보면 일반적인 function입니다. 기본 API에서 `suspend`가 없으므로 일시 중단이 없다는 것을 알 수 있습니다.

### Body

#### withStateAtLeastUnchecked

withStateAtLeast의 내부에서 다시 withStateAtLeastUnchecked 함수를 호출하고 있습니다.

```kotlin
@PublishedApi
internal suspend inline fun <R> Lifecycle.withStateAtLeastUnchecked(
   state: Lifecycle.State,
   crossinline block: () -> R
): R {
   val lifecycleDispatcher = Dispatchers.Main.immediate
   val dispatchNeeded = lifecycleDispatcher.isDispatchNeeded(coroutineContext)
   if (!dispatchNeeded) {
      // 생명 주기 Dispatcher가 디스패치가 불필요한 경우
      // 현재 생명 주기가 DESTROYED인 경우, LifecycleDestroyedException를 발생.
      // 현재 생명 주기가 지정한 생명 주기보다 크거나 같은 경우, 파라미터로 전달받은 블록을 실행.
      if (currentState == Lifecycle.State.DESTROYED) throw LifecycleDestroyedException()
      if (currentState >= state) return block()
   }

   // 생명 주기 Dispatcher가 디스패치가 필요한 경우
   // suspendWithStateAtLeastUnchecked 함수 호출
   return suspendWithStateAtLeastUnchecked(state, dispatchNeeded, lifecycleDispatcher) {
      block()
   }
}

// LifecycleDestroyedException는 CancellationException의 하위 클래스.
// CoroutineExceptionHandler를 정의했다면 해당 Exception을 전달받을 수 있습니다.
public class LifecycleDestroyedException : CancellationException()
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/WithLifecycleState.kt

#### suspendWithStateAtLeastUnchecked

이어서 볼 내용은 생명 주기 Dispatcher가 디스패치가 필요한 경우 호출하는 함수입니다.

```kotlin
@PublishedApi
internal suspend fun <R> Lifecycle.suspendWithStateAtLeastUnchecked(
   state: Lifecycle.State,
   dispatchNeeded: Boolean,
   lifecycleDispatcher: CoroutineDispatcher,
   block: () -> R
): R = suspendCancellableCoroutine { co ->
   val observer = object : LifecycleEventObserver {
      override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
         if (event == Lifecycle.Event.upTo(state)) {
            // 현재 생명 주기가 지정한 생명 주기보다 크거나 같다면
            // Lifecycle에 등록된 Observer 제거한 후 블록을 실행 
            removeObserver(this)
            co.resumeWith(runCatching(block))
         } else if (event == Lifecycle.Event.ON_DESTROY) {
            // 현재 생명 주기가 DESTROYED인 경우
            // Lifecycle에 등록된 Observer 제거한 후 LifecycleDestroyedException를 발생
            removeObserver(this)
            co.resumeWithException(LifecycleDestroyedException())
         }
      }
   }

   // Lifecycle 이벤트를 구독
   if (dispatchNeeded) {
      lifecycleDispatcher.dispatch(
         EmptyCoroutineContext,
         Runnable { addObserver(observer) }
      )
   } else addObserver(observer)

   co.invokeOnCancellation {
      // CancellableContinuation(=co)이 취소된 경우, Lifecycle 이벤트 구독을 해지
      if (lifecycleDispatcher.isDispatchNeeded(EmptyCoroutineContext)) {
         lifecycleDispatcher.dispatch(
            EmptyCoroutineContext,
            Runnable { removeObserver(observer) }
         )
      } else removeObserver(observer)
   }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/WithLifecycleState.kt

------

지금까지 whenStateAtLeast와 withStateAtLeast 기능이 어떻게 구현했는지를 살펴봤습니다. 내부 구현을 좀 더 확인해보고자 작성한 2부 글이지만, 많은 개발자는 1부에서 언급한 사용 방법과 동작에 대한 내용이 보다 더 유용할 것 같습니다.

- 1부 : http://pluu.github.io/blog/android/2021/01/12/androidx-lifecycle-ktx/
- 2부 : http://pluu.github.io/blog/android/2021/01/14/android-lifecycle-ktx/
