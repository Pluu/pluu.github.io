---
layout: post
title: "AndroidX Activity#1.0.0-alpha06 의 변경 점"
date: 2019-04-20 20:01:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

2019년 4월초 AndroidX의 많은 부분이 업데이트 되었습니다.

그 중에서 `Activity#1.0.0-alpha06`의 변경 점에 대해서 알아보겠습니다.

<!--more-->

## AndroidX ComponentActivity

`Activity#1.0.0-alpha01` 부터 추가된 `ComponentActivity` 라는 새로운 클래스가 추가되었습니다. 아마도, 기존에 있던 `SupportActivity` 의 새로운 이름으로 변경한 형태로 보입니다. 이 클래스는 `FragmentActivity` 와 `AppComatActivity`의 상위 클래스이며, 개발자가 직접 사용할 수 없는 형태입니다.

```java
@RestrictTo(LIBRARY_GROUP_PREFIX)
public class ComponentActivity extends Activity
        implements KeyEventDispatcher.Component {
```

## Activity#1.0.0-alpha01

[Activity#1.0.0-alpha01 Release Note](<https://developer.android.com/jetpack/androidx/releases/activity#1.0.0-alpha01>)

`1.0.0-alpha01` 부터 `onBackPressed` 호출 시 추가적인 BackPressed 판단 가능한 기능이 추가되었습니다. `addOnBackPressedCallback` 라는 메소드 입니다. 덕분에 `Fragment` 에서도 손쉽게  `OnBackPressedCallback` 인터페이스를 이용해 BackKey 처리가 가능해졌습니다.

### 기본 형태

```kotlin
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment

class MainFragment : Fragment() {
    // OnBackPressedCallback 정의
    private val callback = object : OnBackPressedCallback {
        override fun handleOnBackPressed(): Boolean {
            return if (isHandled) {
                doAction()
                true
            } else {
                false
            }
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        // Activity에 BackPressedCallback 등록
        activity?.addOnBackPressedCallback(callback)
        ...
    }

    override fun onDestroy() {
        super.onDestroy()
        // Activity에 BackPressedCallback 제거
        activity?.removeOnBackPressedCallback(callback)
        ...
    }
}
```

### Lifecycle 사용 형태

기본 형태와 다른 부분은 `addOnBackPressedCallback`를 호출 시 파라매터로 `LifecycleOwner`를 전달하는 것입니다.

```kotlin
class MainFragment : Fragment() {
    ...
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        activity?.addOnBackPressedCallback(viewLifecycleOwner, callback)
        ...
    }
    ...
}
```

### ComponentActivity ~ 1.0.0-alpha01

좀 더 `ComponentActivity` 의 내부를 확인해보면 동작을 쉽게 이해할 수 있습니다.

Link : [ComponentActivity](<https://android.googlesource.com/platform/frameworks/support/+/8514bc0f4d930b5470435aa365719b2a6a3ad2f3/activity/src/main/java/androidx/activity/ComponentActivity.java>) 

```java
public class ComponentActivity extends androidx.core.app.ComponentActivity 
		implements LifecycleOwner, ViewModelStoreOwner {
		...
		// OnBackPressedCallback Listener를 보관할 Cache
    final CopyOnWriteArrayList<LifecycleAwareOnBackPressedCallback> mOnBackPressedCallbacks = new CopyOnWriteArrayList<>();    
    ...    
    @Override
    public void onBackPressed() {
    		// 등록한 순차적으로 OnBackPressedCallback#handleOnBackPressed() 를 실행
        for (OnBackPressedCallback onBackPressedCallback : mOnBackPressedCallbacks) {
            if (onBackPressedCallback.handleOnBackPressed()) {
                return;
            }
        }
        ...
    }
    ...
    // Add, OnBackPressedCallback & 현재 Activity의 LifecycleOwner 사용
    public void addOnBackPressedCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
        addOnBackPressedCallback(this, onBackPressedCallback);
    }
    
    // Add, OnBackPressedCallback & LifecycleOwner 사용
    public void addOnBackPressedCallback(@NonNull LifecycleOwner owner,
            @NonNull OnBackPressedCallback onBackPressedCallback) {
        Lifecycle lifecycle = owner.getLifecycle();
        // LifecycleOwner의 Lifecycle을 체크
        if (lifecycle.getCurrentState() == Lifecycle.State.DESTROYED) {
            return;
        }
        // 최근에 추가한 Callback이 우선 순위를 갖도록 가장 앞에 추가
        mOnBackPressedCallbacks.add(0, new LifecycleAwareOnBackPressedCallback(
                lifecycle, onBackPressedCallback));
    }
    
    // Remove, OnBackPressedCallback
    public void removeOnBackPressedCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
        Iterator<LifecycleAwareOnBackPressedCallback> iterator =
                mOnBackPressedCallbacks.iterator();
        LifecycleAwareOnBackPressedCallback callbackToRemove = null;
        while (iterator.hasNext()) {
            LifecycleAwareOnBackPressedCallback callback = iterator.next();
            // Callback 비교
            if (callback.getOnBackPressedCallback().equals(onBackPressedCallback)) {
                callbackToRemove = callback;
                break;
            }
        }
        if (callbackToRemove != null) {
        		// Lifecycle 구독 해지
            callbackToRemove.onRemoved();
            // Cache 목록에서 Callback 제거
            mOnBackPressedCallbacks.remove(callbackToRemove);
        }
    }
    ...
}
```

`Activity#1.0.0-alpha06` 이전까지 OnBackPressedCallback은 `ComponentActivity` 내부의 Add/Remove를 이용해서 관리했습니다.

- - -

## Activity#1.0.0-alpha06

[Activity#1.0.0-alpha06 Release Note](<https://developer.android.com/jetpack/androidx/releases/activity#1.0.0-alpha06>)

`1.0.0-alpha01` 에 추가되었던 `ComponentActivity#addOnBackPressedCallback` 의 기능이 `deprecated` 가 되었습니다.

그 대신 `OnBackPressedDispatcher` 를 이용하는 형태로 변경되었습니다.

### 기본 형태

```kotlin
import androidx.activity.OnBackPressedCallback
import androidx.arch.core.util.Cancellable
import androidx.fragment.app.Fragment

class MainFragment : Fragment() {
    // 취소 가능한 Interface
    private var backPressedCancellable: Cancellable? = null

    // OnBackPressedCallback 정의
    private val callback = object : OnBackPressedCallback {
        override fun handleOnBackPressed(): Boolean {
            return if (isHandled) {
                doAction()
                true
            } else {
                false
            }
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        // onBackPressedDispatcher#addCallback 호출 시
        // Cancellable 인터페이스를 구현한 OnBackPressedCancellable 가 반환
        backPressedCancellable = activity?.onBackPressedDispatcher?.addCallback(callback)
    }

    override fun onDestroy() {
        super.onDestroy()
        backPressedCancellable?.cancel()
    }
    ...
}
```

### Lifecycle 사용 형태

기본 형태와 다른 부분은 `addOnBackPressedCallback`를 호출 시 파라매터로 `LifecycleOwner`를 전달하는 것과 `Cancellable` Callback을 이용해 BackPressedDispatcher 구독을 취소하는 것입니다.

```kotlin
class MainFragment : Fragment() {
    ...
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        // onBackPressedDispatcher#addCallback 호출 시
        // Cancellable 인터페이스를 구현한 LifecycleOnBackPressedCancellable 가 반환
        backPressedCancellable = activity?.onBackPressedDispatcher?.addCallback(viewLifecycleOwner, callback)
        ...
    }
    ...
}
```

### OnBackPressedDispatcher

여기서 OnBackPressedDispatcher의 내부를 한 번 보겠습니다.

```java
public final class OnBackPressedDispatcher {

    @SuppressWarnings("WeakerAccess") /* synthetic access */
    final ArrayDeque<OnBackPressedCallback> mOnBackPressedCallbacks = new ArrayDeque<>();

    OnBackPressedDispatcher() {
    }

    // 기본 형태로 Callback 추가시 호출 됨
    @NonNull
    public Cancellable addCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
        synchronized (mOnBackPressedCallbacks) {
            mOnBackPressedCallbacks.add(onBackPressedCallback);
        }
        return new OnBackPressedCancellable(onBackPressedCallback);
    }

    // Lifecycle을 사용하는 형태로 Callback 추가시 호출 됨
    @NonNull
    public Cancellable addCallback(@NonNull LifecycleOwner owner,
            @NonNull OnBackPressedCallback onBackPressedCallback) {
        Lifecycle lifecycle = owner.getLifecycle();
        if (lifecycle.getCurrentState() == Lifecycle.State.DESTROYED) {
            return Cancellable.CANCELLED;
        }
        return new LifecycleOnBackPressedCancellable(lifecycle, onBackPressedCallback);
    }

    public boolean onBackPressed() {
        synchronized (mOnBackPressedCallbacks) {
            // descendingIterator 형태의 iterator를 이용해서 handleOnBackPressed 체크
            Iterator<OnBackPressedCallback> iterator =
                    mOnBackPressedCallbacks.descendingIterator();
            while (iterator.hasNext()) {
                if (iterator.next().handleOnBackPressed()) {
                    return true;
                }
            }
            return false;
        }
    }
 
  	// 단순 형태의 OnBackPressedCancellable
		private class OnBackPressedCancellable implements Cancellable {
        private final OnBackPressedCallback mOnBackPressedCallback;
        private boolean mCancelled;

        OnBackPressedCancellable(OnBackPressedCallback onBackPressedCallback) {
            mOnBackPressedCallback = onBackPressedCallback;
        }

        @Override
        public void cancel() {
            synchronized (mOnBackPressedCallbacks) {
                // OnBackPressedDispatcher의 mOnBackPressedCallbacks에서 제거
                mOnBackPressedCallbacks.remove(mOnBackPressedCallback);
                mCancelled = true;
            }
        }

        @Override
        public boolean isCancelled() {
            return mCancelled;
        }
    }

    // Lifecycle을 참조하는 OnBackPressedCancellable
    private class LifecycleOnBackPressedCancellable implements GenericLifecycleObserver,
            Cancellable {
        private final Lifecycle mLifecycle;
        private final OnBackPressedCallback mOnBackPressedCallback;

        @Nullable
        private Cancellable mCurrentCancellable;
        private boolean mCancelled = false;

        LifecycleOnBackPressedCancellable(@NonNull Lifecycle lifecycle,
                @NonNull OnBackPressedCallback onBackPressedCallback) {
            mLifecycle = lifecycle;
            mOnBackPressedCallback = onBackPressedCallback;
            lifecycle.addObserver(this);
        }

        @Override
        public void onStateChanged(@NonNull LifecycleOwner source,
                @NonNull Lifecycle.Event event) {
            if (event == Lifecycle.Event.ON_START) {
              	// ON_START, OnBackPressedDispatcher의 mOnBackPressedCallbacks에 추가
                mCurrentCancellable = addCallback(mOnBackPressedCallback);
            } else if (event == Lifecycle.Event.ON_STOP) {
                // ON_STOP, 현재 Cancellable 객체가 유효한 경우 cancel 처리
                if (mCurrentCancellable != null) {
                    // 최종적으로 OnBackPressedCancellable#cancel 이 호출
                    mCurrentCancellable.cancel();
                }
            } else if (event == Lifecycle.Event.ON_DESTROY) {
              	// ON_DESTROY, cancel 처리
                cancel();
            }
        }

        @Override
        public void cancel() {
            // Lifecycle을 미참조
            mLifecycle.removeObserver(this);
            if (mCurrentCancellable != null) {
              	// Cancel 처리
              // 최종적으로 OnBackPressedCancellable#cancel 이 호출
                mCurrentCancellable.cancel();
                mCurrentCancellable = null;
            }
            mCancelled = true;
        }

        @Override
        public boolean isCancelled() {
            return mCancelled;
        }
    }
}
```

이전 버전과 다른 점은 아래와 같습니다.

-  Callback 관리 이동
   - ComponentActivity → OnBackPressedDispatcher
- 기본 형태로 Callback 추가 시 Lifecycle을 미체크
- Callback을 담는 형태가 변경
   - CopyOnWriteArrayList → ArrayDeque

### ComponentActivity ~ 1.0.0-alpha06

ComponentActivity의 내부를 먼저 살펴보겠습니다.

```java
public class ComponentActivity extends androidx.core.app.ComponentActivity 
		implements LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner {
    ...
    private final OnBackPressedDispatcher mOnBackPressedDispatcher = new OnBackPressedDispatcher();
    // deprecated
    private final WeakHashMap<OnBackPressedCallback, Cancellable>
            mOnBackPressedCallbackCancellables = new WeakHashMap<>();
    ...
    @Override
    public void onBackPressed() {
        // BackPressedDispatcher에서 
        if (mOnBackPressedDispatcher.onBackPressed()) {
            return;
        }
        ...
    }
    @NonNull
    public final OnBackPressedDispatcher getOnBackPressedDispatcher() {
        return mOnBackPressedDispatcher;
    }
    @Deprecated
    public void addOnBackPressedCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
    		// OnBackPressedDispatcher에서 생성된 Cancellable을 추가
        mOnBackPressedCallbackCancellables.put(onBackPressedCallback,
                getOnBackPressedDispatcher()
                        .addCallback(this, onBackPressedCallback));
    }
    @Deprecated
    public void addOnBackPressedCallback(@NonNull LifecycleOwner owner,
            @NonNull OnBackPressedCallback onBackPressedCallback) {
        // OnBackPressedDispatcher에서 생성된 Cancellable을 추가
        mOnBackPressedCallbackCancellables.put(onBackPressedCallback,
                getOnBackPressedDispatcher()
                        .addCallback(owner, onBackPressedCallback));
    }
    @Deprecated
    public void removeOnBackPressedCallback(@NonNull OnBackPressedCallback onBackPressedCallback) {
    		// onBackPressedCallback을 Cache Map에서 가져와서 cancel 처리 수행
        Cancellable cancellable = mOnBackPressedCallbackCancellables.remove(onBackPressedCallback);
        if (cancellable != null) {
            cancellable.cancel();
        }
    }
    ...
}
```

기존 버전과 호환을 위해 `addOnBackPressedCallback`/`removeOnBackPressedCallback` 는 그대로 유지하고 있습니다.

변경된 차이점은 다음과 같습니다.

- Callback을 담는 형태 `OnBackPressedDispatcher` 가 추가
- Cancellable Callback을 담는 형태로 변경 : `mOnBackPressedCallbackCancellables`
- Lifecycle과 단순한 형태의 `BackPressedCallback` 가 각자 가지는 동작을 분리

- - -

### Summary

이번 글을 통해서 Back Key 선택 시의 동작과 새로운 변경 점을 알아보았습니다.

1.0.0-alpha06 과 1.0.0-alpha01의 차이는 더 명확하게 구현을 분리한 형태가 된듯 합니다.