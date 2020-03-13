---
layout: post
title: "SavedStateHandle을 다뤄봅니다"
date: 2020-02-21 08:20:00 +09:00
tag: [Android, AndroidX, SavedState]
categories:
- blog
- Android
---

이번 글에서는 ViewModel 에서 UI 상태 저장의 꽃(?)이라고 생각되는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)을 다뤄보겠습니다. 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/) 에서도 가볍게 언급했던 부분을 AndroidX 내부에서 어떤 움직임으로 다뤄지는 살펴볼 예정입니다.

<!--more-->

ViewModel 에 대해서 총 5개의 글을 소개할 예정입니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ page.url }})
- 4부 : SavedStateHandle이 어떻게 저장되고 복원될까?
- 5부 : TBD

------

## SavedState + ViewModel 

1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/) 에서 언급한 내용이지만, 중요한 내용이므로 다시 가볍게 언급하겠습니다. 

ViewModel를 이용해서 화면에 필요한 데이터를 안전하게 보관하는 방법의 하나입니다. [onSaveInstanceState()](https://developer.android.com/guide/components/activities/activity-lifecycle#save-simple-lightweight-ui-state-using-onsaveinstancestate) 을 사용하여 데이터를 저장/복원하지 않고도 편리하게 View에 필요한 데이터를 일시적으로 관리할 수 있습니다. 또한 ViewModel은 Activity가 화면 회전에 의해서 onCreate ~ onDestroy가 여러 번 호출되더라도 데이터는 안전하게 저장됩니다.  그 이유는 ViewModel의 생명주기가 Activity의 일반적인 생명주기보다 더 길게 유지되기 때문입니다.

<img src="https://2.bp.blogspot.com/-yDA6lQPeUM0/WjMEoM8_qsI/AAAAAAAABrU/aSrk1ePRyugp6Mna8mSPlq5K-4Moz9EcACLcBGAs/s1600/image1.png" width="75%" />

> 이미지 출처 : [ViewModel ~ The lifecycle of a ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel#lifecycle)

그러나 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html)은 `메모리 내에서 존재`하므로 프로세스 종료까지는 안전하지 않습니다

## 기본 테스트 환경

```groovy
// app/build.gradle
implementation 'androidx.activity:activity:1.1.0'
implementation 'androidx.fragment:fragment:1.2.0'
implementation 'androidx.lifecycle:lifecycle-viewmodel-savedstate:2.2.0'
```

테스트를 위한 환경은 위와 같이 설정합니다. 현재 AndroidX의 최신 minor 버전을 사용했습니다.

------

## SavedStateHandle 

공식 사이트에서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)는 다음과 갈이 설명하고 있습니다.

> A handle to saved state passed down to [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html). You should use [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory.html) if you want to receive this object in ViewModel's constructor.
>
> This is a key-value map that will let you write and retrieve objects to and from the saved state. These values will persist after the process is killed by the system and remain available via the same object.
>
> You can read a value from it via [get(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#get(java.lang.String)) or observe it via [LiveData](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) returned by [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String)).
>
> You can write a value to it via [set(String, Object)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#set(java.lang.String,%20T)) or setting a value to [MutableLiveData](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData.html) returned by [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String)).

영어가 어려우니 간단하게 아래와 같이 해석할 수 있습니다.

- Saved State Handle 정보가 ViewModel로 전달됨
- SavedStateViewModelFactory를 사용해야만 ViewModel을 통해서 SvaedStateHandled을 전달 가능
- SvaedStateHandled은 Key-Value로 이루어진 Map 형태
- 시스템이 프로세스를 종료하더라도 동일한 정보를 유지
- get(String) ➡ 값 읽기
- getLiveData(String) ➡ MutableLiveData가 반환, LiveData를 통해 값을 사용 가능
- set(String, Object) ➡ 값 쓰기

위 설명으로 앞으로 살펴볼 내용의 대부분을 언급했습니다.

------

### 가벼운 SavedStateHandle 다루기

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 을 사용하기 위해 사용된 Artifact 주소(androidx.lifecycle:lifecycle-viewmodel-savedstate)만 보더라도 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 와 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) 은 연관이 큽니다. 그리고 아래와 같이 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) 를 구현하는 생성자의 매개변수로 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 가 전달됩니다. 

```kotlin
class SavedStateViewModel(
  private val handle: SavedStateHandle
) : ViewModel()
```

이후에는 매개변수로 전달된 객체를 다음과 같은 메소드로 다룰 수 있습니다.

- get(String key) : T
- contains(String key) : boolean
- remove(String key) : T
- set(String key, T value)
- keys() : Set<String>
- getLiveData(String key) : MutableLiveData

#### 예시

```kotlin
class SavedStateViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {
   private val NAME_KEY = "name"
    
   fun getName(): LiveData<String> {
      return handle.getLiveData(NAME_KEY)
   }

   fun saveNewName(newName: String) {
      handle[NAME_KEY] = newName
   }
}
```

위 예제는 `getName()` 을 통해서 LiveData를 반환하는 메소드와 `saveNewName(String)` 으로 새로운 값을 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 에 저장하는 메소드입니다. `getName()` 을 통해 반환된 LiveData를 Observe하여 Name에 대한 데이터를 옵저빙합니다. 그 후 `saveNewName(String)` 메소드를 호출해서 동일한 키에 데이터를 갱신하는 경우 `getName()` 에서 반환된 LiveData에 새로운 데이터가 흘러갑니다.

### SavedStateHandle 에서 처리가능한 타입

 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 에 저장가능한 데이터는 아래와 같습니다. [SavedStateHandle#set(String, T)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle?hl=en#set(java.lang.String,%20T)) 의 정의로는 무엇이든지(?) 저장가능할 것으로 보입니다. 그러나  [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 에서 관리되는 데이터는 최종적으로 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 에 저장하므로 동일하게 처리가능한 형태이여만 합니다.

 <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0221-savedstate/SavedStateHandle_Support.png" }}" /> 

### ViewModel 생성

```kotlin
import androidx.lifecycle.SavedStateViewModelFactory
import androidx.lifecycle.ViewModelProvider

class SavedStateViewModelActivity : AppCompatActivity() {
  
   private lateinit var counterViewModel: SavedStateViewModel

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
		  ...
      counterViewModel = ViewModelProvider(
         this,
         SavedStateViewModelFactory(application, this, intent?.extras)
      ).get(SavedStateViewModel::class.java)
   }
}
```

[ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) 에서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 을 얻기 위해서는 [ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.html) 에 전달하는 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html) 타입에 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 를 사용합니다. [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 사용 시 중요한 것은 생성자의 3번째 파라미터에 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 타입인 **Intent**로 전달된 **Bundle** 정보를 전달합니다.

```kotlin
import androidx.lifecycle.ViewModelProvider

class SavedStateViewModelActivity : AppCompatActivity() {
  
   private lateinit var counterViewModel: SavedStateViewModel

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
		  ...
      counterViewModel = ViewModelProvider(
         this, defaultViewModelProviderFactory
      ).get(SavedStateViewModel::class.java)
   }
}
```

[SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory) 대신에 Activity/Fragment에서 기본으로 제공하는 [ComponentActivity#getDefaultViewModelProviderFactory()](https://developer.android.com/reference/androidx/activity/ComponentActivity.html#getDefaultViewModelProviderFactory()) / [Fragment#getDefaultViewModelProviderFactory](https://developer.android.com/reference/kotlin/androidx/fragment/app/Fragment.html#getdefaultviewmodelproviderfactory)를 사용하셔도 됩니다.

```kotlin
import androidx.activity.viewModels

class SavedStateViewModelActivity : AppCompatActivity() {

   private val counterViewModel: SavedStateViewModel by viewModels()

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
		  ...
   }
}
```

`androidx.activity:activity-ktx:1.1.0`, `implementation 'androidx.fragment:fragment-ktx:1.2.0` 를 사용하시면 더 쉽게 viewModel을 생성할 수 있습니다.

------

## 사용 방법

여기에서는 UI 상태 저장으로 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 을 간단하게 사용하는 방법을 다뤄보겠습니다.

### Activity에서 사용 (Activity ViewModel)

이전 글에서 사용한 카운트를  저장하는 샘플을 사용하겠습니다.

```kotlin
class SavedStateCounterActivity : AppCompatActivity() {

   // Activity-ktx를 사용하여 ViewModel 지연 생성
   private val counterViewModel: SavedStateCounterViewModel by viewModels()

   override fun onCreate(savedInstanceState: Bundle?) {
      ......
      // Counter 수치가 갱신되는 LiveData
      counterViewModel.countLiveData.observe(this, Observer {
         binding.counter.text = it.toString()
      })

      binding.fab.setOnClickListener {
         // Counter 증가
         counterViewModel.incCounter()
      }
   }
}
```

`countLiveData` 를 LiveData로 수신받도록 등록하며, fab 버튼을 클릭했을 때 `incCounter()` 를 호출해 카운트를 증가하라는 요청을 하는 View입니다. 중요한 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) 의 내부를 한번 살펴보도록 하겠습니다.

```kotlin
// SavedStateCounterViewModel.kt
package com.pluu.savedstate.ui

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import timber.log.Timber

class SavedStateCounterViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {

  private val COUNT_KEY = "count"

  // Get value of SavedStateHandle
  private var counter = handle.get<Int>(COUNT_KEY) ?: 0
    set(value) {
      // Set value of SavedStateHandle
      handle[COUNT_KEY] = value
      field = value
    }

  // Get LiveData of SavedStateHandle
  val countLiveData: LiveData<Int> = handle.getLiveData(COUNT_KEY, 0)

  // 카운트 증가
  fun incCounter() {
    Timber.d("Inc Counter => $counter")
    ++counter
  }
}
```

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 객체에서 Int형의 `count` 키를 가진 객체를 메인으로 아래와 같이 다루고 있습니다.

- private var counter
  - 최초 `count`  키로 부터 값을 가져오거나 없으면 0을 적용
  - 추가로 값이 반영되는 경우는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 객체에 데이터를 저장
-   val countLiveData: LiveData<Int>
  - [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 객체에서  `count` 키를 가진 데이터로 [LiveData](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) 타입으로 반환

이 방법으로 시스템에 의해 프로세스가 종료되더라도 Activity가 재시작될 때 마지막으로 저장된 정보를 그대로 포함하여 복원됩니다.

### Fragment에서 사용 (Fragment/Activity ViewModel)

```kotlin
class SavedFragment : Fragment() {

   // Fragment-ktx를 사용하여 ViewModel 지연 생성
   private val counterViewModel: SavedStateCounterViewModel by viewModels()

   override fun onCreate(savedInstanceState: Bundle?) {
      ......
      // Counter 수치가 갱신되는 LiveData
      counterViewModel.countLiveData.observe(viewLifecycleOwner, Observer {
         binding.counter.text = it.toString()
      })

      binding.fab.setOnClickListener {
         // Counter 증가
         counterViewModel.incCounter()
      }
   }
}
```

이전 Activity에서 사용하는 SavedStateCounterViewModel을 재사용해서 테스트해볼 경우 동일하게 동작합니다.

## 사용 방법 2

### Activity로 데이터 전달

샘플 Activity인 SavedStateCounterActivity 호출 시 [Intent](https://developer.android.com/reference/android/content/Intent.html)로 아래 정보를 전달하는 경우를 생각해봅니다. 

```kotlin
private fun activityIntent(pkg: String, componentName: String) = Intent().apply {
  setClassName(pkg, componentName)
  putExtras(
    bundleOf(
      "case_1" to 1,
      "case_2" to "test",
      "case_3" to (1..10).toList().toTypedArray()
    )
  )
}
```

[Intent](https://developer.android.com/reference/android/content/Intent.html)로 넘어온 데이터를 ViewModel에 전달하고 싶은 경우에는 아래와 같은 코드를 작성해야 했습니다.

```kotlin
class OldStyleActivity : AppCompatActivity() {

   // Activity-ktx를 사용하여 ViewModel 지연 생성
   private val counterViewModel: SavedStateCounterViewModel by viewModels()

   override fun onCreate(savedInstanceState: Bundle?) {
      ......     
      val bundle = intent.extras
     
      val case_1 = bundle?.getInt("case_1")
      val case_2 = bundle?.getString("case_2")
      val case_3 = bundle?.getSerializable("case_3") as Array<Int>
     
      counterViewModel.initValue(case_1, case_2, case_3) // 🤔🤔🤔
   }
}
```

Bundle로부터 값을 꺼내는 로직과 초기화하는 부분이 필요했습니다. 

만약 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 사용한다면 어떻게 될까요? 바로 아래와 같은 코드로 작성할 수 있습니다.

```kotlin
class SavedStateCounterActivity : AppCompatActivity() {

   // Activity-ktx를 사용하여 ViewModel 지연 생성
   private val counterViewModel: SavedStateCounterViewModel by viewModels()

   override fun onCreate(savedInstanceState: Bundle?) {
      ...... 
   }
}
```

intent로부터 데이터를 가져오는 코드가 모두 사라졌습니다. 보시는 것대로 해당 작업은 작성하지 않아도 됩니다. 그러면 어디에 [Intent](https://developer.android.com/reference/android/content/Intent.html)에 추가한 데이터가 들어있을까요?

```kotlin
class SavedStateCounterViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {
  init {
    handle.keys().forEach { key ->
      Timber.d("Received [$key]=[${handle.get<Any>(key)}]")
    }
  }
}
```

위 코드에서는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 사용해 단순하게 데이터를 로그로 출력해보는 형태를 사용했습니다.

```bash
Received [case_1]=[1]
Received [case_2]=[test]
Received [case_3]=[[Ljava.lang.Integer;@b405342]
```

[Intent](https://developer.android.com/reference/android/content/Intent.html)로 전달한 데이터를 ViewModel에서 직접 다룰 수 있게 되어 View 측에서 조금은(?) boilerplate code에 가까운 처리를 제거할 수 있게 되었습니다.

### Fragment로 데이터 전달

두 번째 케이스로 Activity를 통해 Fragment에 데이터를 전달하는 방법을 테스트해봅니다. 샘플로 전달하는 데이터는 Activity의 테스트 케이스와 같은 정보를 전달합니다.

```kotlin
private fun activityIntent(pkg: String, componentName: String) = Intent().apply {
  setClassName(pkg, componentName)
  putExtras(
    bundleOf(
      "case_1" to 1,
      "case_2" to "test",
      "case_3" to (1..10).toList().toTypedArray()
    )
  )
}
```

그리고 Activity로 넘어온 데이터와는 별개로 Fragment의 Arguemtns에 `fragment_case` 키에 데이터를 담아서 전달합니다.

```kotlin
class SavedFragmentActivity : AppCompatActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = SavedActivityBinding.inflate(layoutInflater)
    setContentView(binding.root)

    supportFragmentManager.commit {
      replace(
        R.id.fragmentContainer,
        SavedFragment::class.java,
        bundleOf("fragment_case" to "P1")
      )
    }
  }
}
```

이번에는 과거의 Fragment Argumetn를 가져오는 코드 대신, 바로  fragment-ktx + [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 이용해보는 것으로 작성해봅니다.

```kotlin
class SavedFragment : Fragment() {
    // Fragment-ktx를 사용하여 ViewModel 지연 생성
    private val counterActivityViewModel: SavedStateCounterViewModel by activityViewModels()
    private val counterFragmentViewModel: SavedStateCounterFragmentViewModel by viewModels()
    ...
}
```

Activity ViewModel용 **counterActivityViewModel**, Fragment ViewModel용 **counterFragmentViewModel**을  Fragment-ktx를 사용해서 준비합니다. Activity의 케이스와 마찬가지로 Fragment에서 ViewModel을 위해서 작성할 코드는 없습니다.

```kotlin
// Activity ViewModel
class SavedStateCounterViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {
  init {
    handle.keys().forEach { key ->
      Timber.d("Received [$key]=[${handle.get<Any>(key)}]")
    }
  }
}

// Fragment ViewModel
class SavedStateCounterFragmentViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {
  init {
    handle.keys().forEach { key ->
      Timber.d("Received [$key]=[${handle.get<Any>(key)}]")
    }
  }
}
```

ViewModel의 생성자에 전달되는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 데이터를 로그로 출력해봤습니다.

```bash
D/SavedStateCounterViewModel: Received [case_3]=[[Ljava.lang.Integer;@1b4f114]
D/SavedStateCounterViewModel: Received [case_1]=[1]
D/SavedStateCounterViewModel: Received [case_2]=[test]
D/SavedStateCounterFragmentViewModel: Received [fragment_case]=[P1]
```

Activity 시작 시 [Intent](https://developer.android.com/reference/android/content/Intent.html)로 전달된 데이터와 Fragment 호출 시의 Argument가 제대로 포함된 것을 알 수 있습니다.

- - -

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 를 사용하는 방법으로 Activity/Fragment 시작 시 데이터 전달과 UI 상태 저장이라는 2가지의 이점을 얻을 수 있게 되었습니다. 이어서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 의 내부의 모습을 확인해 보겠습니다.

- - -

## Deep SavedStateHandle

이번에는 SavedStateHandle 실제 구현 코드를 보면서 어떻게 움직이는지 살펴봅니다.

```java
public final class SavedStateHandle {
   final Map<String, Object> mRegular;
   private final Map<String, SavingStateLiveData<?>> mLiveDatas = new HashMap<>();

   private static final String VALUES = "values";
   private static final String KEYS = "keys";

   private final SavedStateProvider mSavedStateProvider = new SavedStateProvider() {
      @SuppressWarnings("unchecked")
      @NonNull
      @Override
      public Bundle saveState() {
         Set<String> keySet = mRegular.keySet();
         ArrayList keys = new ArrayList(keySet.size());
         ArrayList value = new ArrayList(keys.size());
         for (String key : keySet) {
            keys.add(key);
            value.add(mRegular.get(key));
         }

         Bundle res = new Bundle();
         // "parcelable" arraylists - lol
         res.putParcelableArrayList("keys", keys);
         res.putParcelableArrayList("values", value);
         return res;
      }
   };
   ......
}
```

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)은 Key-Value를 가지는 Map 형태라고 언급했지만, 실제로는 아닙니다.

기본적인 상태 저장할 객체(mRegular)와 SavedStatedHandle의 [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String)) 을 통해서 LiveData를 가져올 때 캐싱 용도의 객체(mLiveDatas)가 있습니다.

그리고, [SavedStateProvider](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 타입의 객체 mSavedStateProvider 가 있습니다. [SavedStateProvider](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 타입은 [Bundle](https://developer.android.com/reference/android/os/Bundle.html)을 반환하는 인터페이스로 UI 상세저장에 필요한 실제 구현체가 구현시에 정의하는 인터페이스입니다. [SavedStateProvider](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 인터페이스를 구현하도록 정의되어 있으며, Key/Value를 ArrayList에 담은 후 각각 `keys`, `values`를 Key로 하여 Bundle에 담고 있는 모습을 볼 수 있습니다.

```java
/**
 *  This interface marks a component that contributes to saved state.
 */
public interface SavedStateProvider {
   /**
    * Called to retrieve a state from a component before being killed
    * so later the state can be received from {@link #consumeRestoredStateForKey(String)}
    *
    * @return S with your saved state.
    */
   @NonNull
   Bundle saveState();
}
```

이번 글에는 자세하게 언급하지 않지만, 해당 함수가 정의된 Bundle 정보가 최종적으로 [onSaveInstanceState(Bundle)](https://developer.android.com/reference/android/app/Activity#onSaveInstanceState(android.os.Bundle)) 에 넘겨지는 Bundle에 포함됩니다. [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)에서 저장에 대해 정의를 하고 있다는 정도로 이해하시면 됩니다.

```kotlin
public final class SavedStateHandle {
  /**
   * Creates a handle with the given initial arguments.
   */
  public SavedStateHandle(@NonNull Map<String, Object> initialState) {
    mRegular = new HashMap<>(initialState);
  }

  /**
   * Creates a handle with the empty state.
   */
  public SavedStateHandle() {
    mRegular = new HashMap<>();
  }

  static SavedStateHandle createHandle(@Nullable Bundle restoredState,
      @Nullable Bundle defaultState) {
    if (restoredState == null && defaultState == null) {
      return new SavedStateHandle();
    }

    Map<String, Object> state = new HashMap<>();
    if (defaultState != null) {
      for (String key : defaultState.keySet()) {
        state.put(key, defaultState.get(key));
      }
    }

    if (restoredState == null) {
      return new SavedStateHandle(state);
    }

    ArrayList keys = restoredState.getParcelableArrayList(KEYS);
    ArrayList values = restoredState.getParcelableArrayList(VALUES);
    if (keys == null || values == null || keys.size() != values.size()) {
      throw new IllegalStateException("Invalid bundle passed as restored state");
    }
    for (int i = 0; i < keys.size(); i++) {
      state.put((String) keys.get(i), values.get(i));
    }
    return new SavedStateHandle(state);
  }
  ......
}
```

이번에는 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)의 생성입니다. 필자가 AndroidX Support의 코드를 검색했을 때는 public 생성자 대신 package 로만 공개된 `createHandle(Bundle, Bundle)` 을 통해서 객체를 생성합니다. 파라미터로 넘어온 데이터는 두 개의 Bundle(restoredState/defaultState) 입니다. 두 데이터를 통해서 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 의 생성자로 전달되어 기본적인 상태 저장할 객체(mRegular)에 맵핑됩니다.

defaultState 는 아래 기준으로 데이터가 전달됩니다.

- Activity : startActivity 호출 시 Intent에 추가한 Bundle 정보
- Fragment : Fragment 생성 시 Argument로 추가한 Bundle 정보

restoredState는 객체를 복원 시에 필요한 데이터가 들어있습니다. 

이제 조금(?) 어려웠던 구간이 끝났습니다.

```java
public final class SavedStateHandle {
   /**
    * @return true if there is value associated with the given key.
    */
   @MainThread
   public boolean contains(@NonNull String key) {
      return mRegular.containsKey(key);
   }
  
   /**
    * Removes a value associated with the given key. If there is a {@link LiveData} associated
    * with the given key, it will be removed as well.
    * <p>
    * All changes to {@link androidx.lifecycle.LiveData} previously
    * returned by {@link SavedStateHandle#getLiveData(String)} won't be reflected in
    * the saved state. Also that {@code LiveData} won't receive any updates about new values
    * associated by the given key.
    *
    * @param key a key
    * @return a value that was previously associated with the given key.
    */
   @SuppressWarnings("TypeParameterUnusedInFormals")
   @MainThread
   @Nullable
   public <T> T remove(@NonNull String key) {
      @SuppressWarnings("unchecked")
      T latestValue = (T) mRegular.remove(key);
      SavingStateLiveData<?> liveData = mLiveDatas.remove(key);
      if (liveData != null) {
         liveData.detach();
      }
      return latestValue;
   }
  
   /**
    * Returns all keys contained in this {@link SavedStateHandle}
    */
   @MainThread
   @NonNull
   public Set<String> keys() {
      return Collections.unmodifiableSet(mRegular.keySet());
   }

   /**
    * Returns a value associated with the given key.
    */
   @SuppressWarnings({"unchecked", "TypeParameterUnusedInFormals"})
   @MainThread
   @Nullable
   public <T> T get(@NonNull String key) {
      return (T) mRegular.get(key);
   }

   /**
    * Associate the given value with the key. The value must have a type that could be stored in
    * {@link android.os.Bundle}
    *
    * @param <T> any type that can be accepted by Bundle.
    */
   @MainThread
   public <T> void set(@NonNull String key, @Nullable T value) {
      validateValue(value);
      @SuppressWarnings("unchecked")
      MutableLiveData<T> mutableLiveData = (MutableLiveData<T>) mLiveDatas.get(key);
      if (mutableLiveData != null) {
         // it will set value;
         mutableLiveData.setValue(value);
      } else {
         mRegular.put(key, value);
      }
   }

   private static void validateValue(Object value) {
      if (value == null) {
         return;
      }
      for (Class<?> cl : ACCEPTABLE_CLASSES) {
         if (cl.isInstance(value)) {
            return;
         }
      }
      throw new IllegalArgumentException("Can't put value with type " + value.getClass()
            + " into saved state");
   }  
  ......
}
```

기본적으로 Map의 처리를 가지는 함수들이 구현된 모습을 볼 수 있습니다. contains/remove/keys/get/set 일반적인 기능을 하는 함수입니다. [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle)을 이용해서 [LiveData](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) 를 사용할 경우, 동일한 키로 `remove` 를 호출한다면 기존에 사용한 LiveData로 새로운 값이 전달되지 않습니다.

여기서 눈여겨볼 부분은 `set` 함수입니다. 먼저, `T`로 전달된 데이터가 Saved State처리가 가능한 타입인지 확인합니다. 현재 Saved  State 처리가 가능한 데이터는 `ACCEPTABLE_CLASSES` 객체에 정의되어 있습니다.

```java
// doesn't have Integer, Long etc box types because they are "Serializable"
private static final Class[] ACCEPTABLE_CLASSES = new Class[]{
    //baseBundle
    boolean.class,
    boolean[].class,
    double.class,
    double[].class,
    int.class,
    int[].class,
    long.class,
    long[].class,
    String.class,
    String[].class,
    //bundle
    Binder.class,
    Bundle.class,
    byte.class,
    byte[].class,
    char.class,
    char[].class,
    CharSequence.class,
    CharSequence[].class,
    // type erasure ¯\_(ツ)_/¯, we won't eagerly check elements contents
    ArrayList.class,
    float.class,
    float[].class,
    Parcelable.class,
    Parcelable[].class,
    Serializable.class,
    short.class,
    short[].class,
    SparseArray.class,
    (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP ? Size.class : int.class),
    (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP ? SizeF.class : int.class),
};
```

추가로 `set` 내부를 확인해 보면 파라미터로 넘어온 key를 기준으로 LiveData가 있는지 먼저 체크합니다. 만약 해당 key에 맵핑되는 LiveData가 존재하면 LiveData에 setValue 함수로 값을 전달하며, LiveData가 없는 경우에만 mRegular에 데이터를 저장합니다. `set` 함수만 본다면 mRegular에 데이터 저장을 누락했을 것을 보이나 실제로는 mLiveDatas.get(key)를 통해서 반환되는 [MutableLiveData<T>](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData.html)에 로직을 위임했습니다.

```java
private final Map<String, SavingStateLiveData<?>> mLiveDatas = new HashMap<>();
```

눈치가 빠르신 분이라면 mLiveDatas를 구성하는 Key-Value의 형태에서 Value의 타입이 커스텀 [MutableLiveData](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData.html) 라는 것을 확인했을 겁니다. 해당 내용은 다음에 다시 언급하겠습니다. 지금은 잠시만 무언가를 하는 것으로 생각합니다.

```java
public final class SavedStateHandle {
   /**
    * Returns a {@link androidx.lifecycle.LiveData} that access data associated with the given key.
    *
    * @see #getLiveData(String, Object)
    */
   @SuppressWarnings("unchecked")
   @MainThread
   @NonNull
   public <T> MutableLiveData<T> getLiveData(@NonNull String key) {
      return getLiveDataInternal(key, false, null);
   }

   /**
    * Returns a {@link androidx.lifecycle.LiveData} that access data associated with the given key.
    *
    * <pre>{@code
    *    LiveData<String> liveData = savedStateHandle.get(KEY, "defaultValue");
    * }</pre
    *
    * Keep in mind that {@link LiveData} can have {@code null} as a valid value. If the
    * {@code initialValue} is {@code null} and the data does not already exist in the
    * {@link SavedStateHandle}, the value of the returned {@link LiveData} will be set to
    * {@code null} and observers will be notified. You can call {@link #getLiveData(String)} if
    * you want to avoid dispatching {@code null} to observers.
    * <pre>{@code
    *    String defaultValue = ...; // nullable
    *    LiveData<String> liveData;
    *    if (defaultValue != null) {
    *       liveData = savedStateHandle.get(KEY, defaultValue);
    *    } else {
    *       liveData = savedStateHandle.get(KEY);
    *    }
    * }</pre>
    *
    * @param key        The identifier for the value
    * @param initialValue If no value exists with the given {@code key}, a new one is created
    *                with the given {@code initialValue}. Note that passing {@code null} will
    *                create a {@link LiveData} with {@code null} value.
    */
   @MainThread
   @NonNull
   public <T> MutableLiveData<T> getLiveData(@NonNull String key,
         @SuppressLint("UnknownNullness") T initialValue) {
      return getLiveDataInternal(key, true, initialValue);
   }

   @SuppressWarnings("unchecked")
   @NonNull
   private <T> MutableLiveData<T> getLiveDataInternal(
         @NonNull String key,
         boolean hasInitialValue,
         @Nullable T initialValue) {
      MutableLiveData<T> liveData = (MutableLiveData<T>) mLiveDatas.get(key);
      if (liveData != null) {
         return liveData;
      }
      SavingStateLiveData<T> mutableLd;
      // double hashing but null is valid value
      if (mRegular.containsKey(key)) {
         mutableLd = new SavingStateLiveData<>(this, key, (T) mRegular.get(key));
      } else if (hasInitialValue) {
         mutableLd = new SavingStateLiveData<>(this, key, initialValue);
      } else {
         mutableLd = new SavingStateLiveData<>(this, key);
      }
      mLiveDatas.put(key, mutableLd);
      return mutableLd;
   }
   ......
}
```

다음은 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 을 통해서 [LiveData](https://developer.android.com/reference/androidx/lifecycle/LiveData.html)를 가져온 경우에 모든 반환은 [MediatorLiveData](https://developer.android.com/reference/androidx/lifecycle/MediatorLiveData.html) 입니다. 기본적으로 [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle#getLiveData(java.lang.String)), [getLiveData(String, T)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle#getLiveData(java.lang.String,%20T)) 2가지의 함수를 제공하고 있습니다. 이 두 함수는 `getLiveDataInternal(String, boolean, T)` 형태인 함수를 재 호출하는 구조입니다.

 `getLiveDataInternal(String, boolean, T)` 함수에서 LiveData가 캐싱된 객체(mLiveDatas)를 이용해 사용하거나 캐싱된 LiveData가 없는 경우 새로운 LiveData를 위한 커스텀 객체를 생성합니다. 그 후 캐싱 객체에 주입하는 방식입니다.

`SavingStateLiveData` 타입의 객체는 아래의 조건으로 만듭니다.

1. Bundle을 통해서 저장된 데이터가 있는 경우, 기본값으로 사용하여 생성
2. 기본값(hasInitialValue)이 필요한 경우 initialValue를 기본값으로 사용하여 생성
3. 기본값이 없는 형태로 생성

```java
public final class SavedStateHandle {
   static class SavingStateLiveData<T> extends MutableLiveData<T> {
      private String mKey;
      private SavedStateHandle mHandle;

      SavingStateLiveData(SavedStateHandle handle, String key, T value) {
         super(value);
         mKey = key;
         mHandle = handle;
      }

      SavingStateLiveData(SavedStateHandle handle, String key) {
         super();
         mKey = key;
         mHandle = handle;
      }

      @Override
      public void setValue(T value) {
         if (mHandle != null) {
            mHandle.mRegular.put(mKey, value);
         }
         super.setValue(value);
      }

      void detach() {
         mHandle = null;
      }
   }
}
```

마지막으로 [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 에 숨어있는 `SavingStateLiveData` 입니다. public class가 아니라서 외부에서 참조는 불가능하지만, 기본적인 [MutableLiveData](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData.html) 의 처리를 하며, 새로운 `setValue(T)` 를 호출할 경우 기본적인 상태 저장할 객체(mRegular)에 추가하는 모습을 볼 수 있습니다. [SavedStateHandle#set(String, T)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle#set(java.lang.String,%20T)) 에서 캐싱된 [MutableLiveData](https://developer.android.com/reference/androidx/lifecycle/MutableLiveData.html) 가 존재하는 경우 mRegular.put() 호출누락으로 여겨졌던 부분이 여기에 존재합니다.

------

조금은 길었던 코드 분석까지 함께하시느라 고생 많으셨습니다. 내부 로직을 살펴본 느낌은 어떠셨나요?

[SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle) 사용시 Activity/Fragment 간 이동시 전달되는 데이터 조작의 편리함(?)을 얻을 수 있습니다. 다만, 호출하는 Activity/Fragment와 ViewModel에서 사용될 Key 관리에 대한 부분이 새로운 과제로 떠오를 것으로 여겨집니다.

다음 글은 SavedStateHandle이 만들어지는 과정에 대해서 다룰 예정입니다.

> 본 글에서 다룬 샘플은 다음 링크에 있습니다.
> 
> https://github.com/Pluu/Android-UI-SavedState-Sample

- - -

ViewModel에 대해서 총 5개의 글을 소개할 예정입니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ site.url }}/blog/android/2020/02/10/saved-state/)
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ page.url }})
- 4부 : SavedStateHandle이 어떻게 저장되고 복원될까?
- 5부 : TBD
