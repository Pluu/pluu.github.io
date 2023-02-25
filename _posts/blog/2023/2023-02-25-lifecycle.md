---
layout: post
title: "Activity Result API의 ActivityResultCallback과 기존 onActivityResult와의 차이점"
date: 2023-02-25 23:40:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

본 글에서는 Activity 결과 처리를 위해 새로운 Activity Result API 사용 시 주의할 점을 소개합니다.

<!--more-->

새로운 Activity로부터 결과를 전달받기 위해서는 사용된 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int))와 [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 함수는 꾸준히 사용되고 있습니다. 그렇지만, 이미 [onActivityResult](https://developer.android.com/reference/androidx/activity/ComponentActivity#onActivityResult(int,int,android.content.Intent))는 Deprecated 된 함수입니다. 

현재는 새로운 Activity Result API 사용을 권장하고 있습니다. 다양한 Activity Result API 중 Activity 간의 Result 처리에는 [ActivityResultContracts.StartActivityForResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.StartActivityForResult)를 사용해야 합니다.

|          기능          |      Deprecated       |                             New                              |
| :--------------------: | :--------------------: | :----------------------------------------------------------: |
| Launcher/Callback 등록 |           X            | [registerForActivityResult](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller#registerForActivityResult(androidx.activity.result.contract.ActivityResultContract%3CI,O%3E,androidx.activity.result.ActivityResultCallback%3CO%3E)) |
|     Activity 실행      | startActivityForResult | [ActivityResultLauncher#launch](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher#launch(I)) |
|      Result 수신       |    onActivityResult    | [ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) |

> Activity Result 사용에 대한 기본적인 내용은 아래 링크를 참고해 주세요.
>
> - [Getting a result from an activity](https://developer.android.com/training/basics/intents/result)

## 두 API는 호환되지만, 호출 시점은 다릅니다.

onActivityResult 함수 호출과 새로운 Activity Result API의 ActivityResultCallback이 호출되는 시점은 다릅니다.

> Android Developers에 기재된 Activity-lifecycle concepts를 먼저 참고해 보세요.
>
> - [Activity-lifecycle concepts](https://developer.android.com/guide/components/activities/activity-lifecycle)

### Activity Lifecycle와 함수 호출 순서

아래 이미지는 이후에 소개할 Activity의 생명 주기와 일부 함수의 호출 및 Activity Result API의 Callback 시점을 간단하게 요약한 그림입니다.

{% include img_assets.html id="/blog/2023/0225-lifecycle/001.png" %}

기존 onActivityResult와 새로운 Activity Result API의 호출 순서는 아래와 같습니다.

- 기존 방법 : onStop -> onActivityResult (결과 수신)
- 새로운 Activity Result API : onStop -> onActivityResult -> onRestart -> onStart -> ActivityResultCallback (결과 수신)

### Activity Result API의 ActivityResultCallback의 호출 시점

ActivityResultCallback의 호출 시점을 살펴보기 위해서 일부 기능과 함께 생명주기 로그를 살펴보겠습니다. 

> 호출 시점을 살펴보기 위해서 사용된 샘플 코드입니다. Activity 생명주기 체크로 Application.ActivityLifecycleCallbacks를 사용합니다.
>
> - 샘플 코드 : https://github.com/Pluu/ActivityResultCallbackSample

```kotlin
class MainActivity : AppCompatActivity() {
  private val launcher = registerForActivityResult(StartActivityForResult()) {
    logcat(loggerTag) { "[MainActivity] ActivityResultCallback" }
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = ActivityMainBinding.inflate(layoutInflater)
    setContentView(binding.root)

    binding.btnMove.setOnClickListener {
      launcher.launch(Intent(this, SubActivity::class.java))
    }
  }
  ...
  override fun onRestart() {
    super.onRestart()
    logcat(loggerTag) { "[MainActivity] onRestart" }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    logcat(loggerTag) { "[MainActivity] onActivityResult" }
  }
}
```

아래 이미지는 MainActivity에서 SubActivity를 실행한 후, 복귀했을 때의 MainActivity 로그입니다. onActivityResult가 호출되더라도 즉시 호출되지 않고 onStart 이후에 호출됩니다.

{% include img_assets.html id="/blog/2023/0225-lifecycle/002.png" %}

### ActivityResultCallback의 호출 시점은 왜 다를까?

#### onActivityResult

새로운 Activity Result API 처리도 기존 방법인 `onActivityResult()` 함수가 사용됩니다. AppCompatActivity/FragmentActivity의 상위 클래스인 ComponentActivity 내부 코드를 살펴보겠습니다. super.onActivityResult 호출보다 먼저 ActivityResultRegistry#dispatchResult에서 소비할 항목이 있는지 체크한 후 소비된 이력이 없다면 super.onActivityResult를 호출하는 구조입니다. 

```java
public class ComponentActivity extends androidx.core.app.ComponentActivity implements ... {
  ...
  private final ActivityResultRegistry mActivityResultRegistry = new ActivityResultRegistry() {
    ...
  }
  ...  
  @CallSuper
  @Override
  @Deprecated
  protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if (!mActivityResultRegistry.dispatchResult(requestCode, resultCode, data)) {
      super.onActivityResult(requestCode, resultCode, data);
    }
  }
  ..
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/activity/activity/src/main/java/androidx/activity/ComponentActivity.java#L801-L821

#### ActivityResultRegistry 내부의 register/dispatchResult

registerForActivityResult로 등록 시에 대한 ActivityResultCallback 저장을 담당하는 것이 ActivityResultRegistry입니다. 내부에 더 다양한 기능이 있지만 여기에서는 `ActivityResultCallback`에 관련된 내용만 언급하겠습니다.

```java
public abstract class ActivityResultRegistry {
  
  @NonNull
  public final <I, O> ActivityResultLauncher<I> register(
          @NonNull final String key,
          @NonNull final LifecycleOwner lifecycleOwner,
          @NonNull final ActivityResultContract<I, O> contract,
          @NonNull final ActivityResultCallback<O> callback) {

    Lifecycle lifecycle = lifecycleOwner.getLifecycle();
    ...
    registerKey(key);
    LifecycleContainer lifecycleContainer = mKeyToLifecycleContainers.get(key);
    ...
    LifecycleEventObserver observer = new LifecycleEventObserver() {
      @Override
      @SuppressWarnings("deprecation")
      public void onStateChanged(
              @NonNull LifecycleOwner lifecycleOwner,
              @NonNull Lifecycle.Event event) {
        if (Lifecycle.Event.ON_START.equals(event)) {
          // key에 해당하는 Callback을 별도 저장소에 등록
          mKeyToCallback.put(key, new CallbackAndContract<>(callback, contract));
          if (mParsedPendingResults.containsKey(key)) {
            // ON_START에 이미 Result 처리가 완료되었지만,
            // Callback 호출이 안 된 항목이 있다면 Callback 호출
            @SuppressWarnings("unchecked")
            final O parsedPendingResult = (O) mParsedPendingResults.get(key);
            mParsedPendingResults.remove(key);
            callback.onActivityResult(parsedPendingResult);
          }
          final ActivityResult pendingResult = mPendingResults.getParcelable(key);
          if (pendingResult != null) {
            // ON_START에 지연 결과 처리할 항목이 있다면 Callback 호출
            mPendingResults.remove(key);
            callback.onActivityResult(contract.parseResult(
                    pendingResult.getResultCode(),
                    pendingResult.getData()));
          }
        } else if (Lifecycle.Event.ON_STOP.equals(event)) {
          // ON_STOP에 Callback 항목들에서 key를 제거
          mKeyToCallback.remove(key);
        } else if (Lifecycle.Event.ON_DESTROY.equals(event)) {
          // ON_DESTROY에 결과를 반환하지 못하도록 등록된 key를 취소
          unregister(key);
        }
      }
    };
    lifecycleContainer.addObserver(observer);
    mKeyToLifecycleContainers.put(key, lifecycleContainer);
    return new ActivityResultLauncher<I>() {
      ...
    };
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/activity/activity/src/main/java/androidx/activity/result/ActivityResultRegistry.java#L98-L193

ActivityResultCallback 호출에 관련된 중요한 부분으로 registerForActivityResult 호출로 ActivityResultRegistry#register 함수에 전달되는 LifecycleOwner의 생명주기에 맞춰 일련의 처리가 일어납니다. 특히, `Lifecycle.Event.ON_START`시에 callback 호출해야 할 처리가 있는지 체크하며 `Lifecycle.Event.ON_STOP`시에는 callback 처리할 항목에서 제거하고 있습니다. 그로 인해 Activity가 ON_STOP에 해당하는 생명주기 `onStop()` 시점에 callback 제거됩니다.

```java
public abstract class ActivityResultRegistry { 
  @MainThread
  public final boolean dispatchResult(int requestCode, int resultCode, @Nullable Intent data) {
    ...
    doDispatch(key, resultCode, data, mKeyToCallback.get(key));
    return true;
  }
  
  private <O> void doDispatch(String key, int resultCode, @Nullable Intent data,
          @Nullable CallbackAndContract<O> callbackAndContract) {
    if (callbackAndContract != null && callbackAndContract.mCallback != null
          && mLaunchedKeys.contains(key)) {
      ...
    } else {
      // Remove any parsed pending result
      mParsedPendingResults.remove(key);
      // And add these pending results in their place
      mPendingResults.putParcelable(key, new ActivityResult(resultCode, data));
    }
  }
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/activity/activity/src/main/java/androidx/activity/result/ActivityResultRegistry.java#L412-L426

Activity#onActivityResult 함수에서 호출되는 ActivityResultRegistry#dispatchResult에서 즉시 결과를 처리할 것으로 보이지만, 새로운 Activity 호출 시점에 ActivityResultRegistry#register 내부의 LifecycleEventObserver에서 ON_STOP 생명주기 이벤트로 callback이 제거되어 mPendingResults에 지연 처리할 결과로 보관합니다.

이후는 앞서 살펴본 Lifecycle.Event.ON_START시에 mPendingResults에 담긴 항목에서 꺼내어 callback 호출을 위한 처리를 합니다.

## 정리

지금까지 onActivityResult와 ActivityResultCallback의 호출 시점 차이를 살펴봤습니다. 일반적인 사례에서는 큰 문제는 없겠지만, 기존 onActivityResult 이후의 처리에 영향이 없는지 면밀히 살펴볼 필요가 있습니다.

- 기존 방법 : onStop -> onActivityResult -> onRestart
- 새로운 Activity Result API : onStop -> onActivityResult -> onRestart -> onStart -> ActivityResultCallback
