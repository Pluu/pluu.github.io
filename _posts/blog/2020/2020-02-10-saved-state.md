---
layout: post
title: "Android 상태 저장의 기본에서 Savedstate까지"
date: 2020-02-10 23:40:00 +09:00
tag: [Android, SavedState]
categories:
- blog
- Android
---

최근 AndroidX ViewModel-Savedstate이 2.2.0으로 업데이트되었습니다. Android에서 상태 저장을 좀 더 쉽게 하는 방법으로 다양한 라이브러리들이 존재하지만, 본 글에서는 Android에서의 상태 저장과 SavedStateViewModel에 포커스를 두겠습니다.

> [AndroidX Update ~ Feb 5, 2020](https://developer.android.com/jetpack/androidx/versions/all-channel?hl=en#february_5_2020)

<!--more-->

블로그 글에는 Kotlin, Timber, View Binding를 사용합니다. 각 내용에 대해서는 본 글에서는 다루지 않습니다.

- - -

ViewModel 에 대해서 총 5개의 글을 소개합니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ page.url }}) <-- 현재 글
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ site.url }}/blog/android/2020/03/15/savedstate-flow/)
- 5부 : [ViewModel의 탄생에서 죽음까지]({{ page.url }}/blog/android/2020/05/04/viewmodel-b-to-d/)

- - -

## Android에서 상태 저장

### 상태 저장이 필요한 이유

Android 사용 시 화면 회전을 하거나 메모리 부족으로 앱이 종료될 수 있습니다. 또한 백그라운드에서 Android OS에서 의해서 앱이 종료될 수 있습니다. OS에서 주요 관심사는 포그라운드의 앱입니다. 지금 사용자가 사용하고 있는 A 앱이 중요한 것이며, 며칠간 보지 않고 백그라운드에서 돌고 있는 B 앱이 잘 동작하는 것에는 중요도가 낮습니다. 기본적인 방법은 백그라운드 앱을 조절해서 포그라운드 앱이 잘 동작하도록 만듭니다. 

적은 확률이지만 시스템의 UI에 지연이 발생하는 경우 사용하는 앱과 앱의 액티비티를 관리하는 프로세스를 종료하기도 합니다.

### 상태 저장을 하지 않는 경우

간단한 예로는 버튼을 누른 카운트를 세는 앱을 생각할 수 있습니다. 버튼을 누를 때마다 카운트를 증가시켜서 텍스트 뷰에 노출하는 샘플입니다.

```kotlin
class CounterActivity : AppCompatActivity() {
  private var count = 0

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = ActivityCounterBinding.inflate(layoutInflater)
    setContentView(binding.root)

    binding.fab.setOnClickListener {
      // Count 증가
      ++count
      binding.counter.text = count.toString()
    }
  }
}
```

| 초기 실행                                                    | Count 3번 증가                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/01.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/02.png" }}" /> |

이 상태에서 화면을 회전하면 다음과 같이 TextView의 Counter값이 초기화되어있습니다.

| 화면 회전                                                    |
| ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/03.png" }}" /> |

이 현상은 Android 개발 시 다양한 자료를 통해서 많이 본 내용입니다. 왜 이 현상이 일어나는지 로그를 보면 이야기를 다루겠습니다.

먼저 Activity의 활동을 추적하는 방법 중에서 Application에서 `registerActivityLifecycleCallbacks` 콜백을 등록해서 로그를 출력할 수 있습니다.

```kotlin
class App : Application() {
  override fun onCreate() {
    ...
    registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks {
      // Logging
    })
  }
}
```

그 후, 위 예제와 동일하게 아래의 절차를 합니다.

1. CounterActivity 실행
2. Counter 3번 클릭
3. 화면 회전
4. Counter 3번 클릭
5. 화면 회전

위 절차에 따라서 출력된 로그는 아래와 같습니다.

```
// CounterActivity 실행
Created : CounterActivity
Started : CounterActivity
Resumed : CounterActivity

// Counter 3번 클릭
Click => Count = 1
Click => Count = 2
Click => Count = 3

// 화면 회전
Paused : CounterActivity
Stopped : CounterActivity
SaveInstanceState : CounterActivity
Destroyed : CounterActivity
Created : CounterActivity
Started : CounterActivity
Resumed : CounterActivity

// Counter 3번 클릭
Click => Count = 1
Click => Count = 2
Click => Count = 3

// 화면 회전
Paused : CounterActivity
Stopped : CounterActivity
SaveInstanceState : CounterActivity
Destroyed : CounterActivity
Created : CounterActivity
Started : CounterActivity
Resumed : CounterActivity
```

회전할 때마다 기존 CounterActivity는 종료되고, 새롭게 Activity가 만들어집니다. 이로 인해 실제 Counter의 값과 TextView에 노출되고 있던 상태를 잃습니다. 이제 원인을 알게 되었으니 우리가 해결해야 할 것은 다음 2가지입니다.

1. Counter 저장/복원
2. TextView 값 노출

>  Medium의 [The Android Lifecycle cheat sheet — part I: Single Activities](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)의 **Scenario 3: Configuration changes** 시나리오의 결과를 통해서 동일한 것을 알 수 있습니다.
>
> <img src="https://miro.medium.com/max/964/1*DCo7awxJ3KhnW88h365vhA.png"  />

## 기본적인 방법

### 데이터 저장

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/04.png" }}" width="75%" />

> 이미지 출처 : [Android Kotlin Fundamentals Course ~ 04.2: Complex lifecycle situations](https://codelabs.developers.google.com/codelabs/kotlin-android-training-complex-lifecycle/index.html?index=..%2F..android-kotlin-fundamentals#4)

기본적인 방법은 지금까지 언급한 그림과 로그에 힌트가 있습니다. Activity 회전 시 Stop 후에 호출되는  `onSaveInstanceState` 함수가 있습니다. 이름부터 SaveInstanceState라고 정의되어 있으며 어떤 상태를 저장하는 역할이라는 것을 유추 가능하며, 연관 관계가 있다는 것을 알 수 있습니다.

```shell
// CounterActivity 실행
Created : CounterActivity
Started : CounterActivity
Resumed : CounterActivity

// 화면 회전
Paused : CounterActivity
Stopped : CounterActivity
SaveInstanceState : CounterActivity
Destroyed : CounterActivity
Created : CounterActivity
Started : CounterActivity
Resumed : CounterActivity
```

다음으로 onSaveInstanceState 함수의 정의를 살펴봅니다.

```kotlin
override fun onSaveInstanceState(outState: Bundle) {
  // TODO : something save
}
```

파라미터로 넘어오는 타입이 `Bundle`이므로 Bundle에 넣을 수 있는 형태가 저장 가능하다는 것을 염두에 둡니다. 데이터 저장의 흐름을 알았으니 다음으로 데이터 복원에 대해서 이야기하겠습니다.

### 데이터 복원

많은 경우의 데이터 복원은 `Activity#onCreate` 에서 이루어집니다. 그리고 onCreate 함수에 넘어오는 `savedInstanceState`를 사용합니다.

```java
protected void onCreate(@Nullable Bundle savedInstanceState)
```

우리는 onCreate는 Activity가 실행될 때 처음 진입한다는 것을 알고 있습니다. 또 하나로 시스템에 의해서 종료되어 재생성 후 시작되는 위치이기도 합니다. 재시작되어 진입하는 경우 `savedInstanceState` 의 데이터를 이용해서 데이터를 복원할 수 있습니다. `onSaveInstanceState` 에서 저장된 데이터가 onCreate의 파라매터로 들어온다고 생각하면 됩니다.

> onRestoreInstanceState를 이용해서 복원하는 방법도 존재합니다. 이 함수는 onPostCreate ~ onStart 사이에 호출되며, Activity가 재생성되어 시작시에만 호출됩니다.

### Full Code

아래의 코드가 기본적인 데이터 저장 후 복원하는 방법을 정의한 코드입니다.

```kotlin
class StateCounterActivity : AppCompatActivity() {
  private var count = 0

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = ActivityCounterBinding.inflate(layoutInflater)
    setContentView(binding.root)

    if (savedInstanceState != null) {
      // 데이터 복원
      count = savedInstanceState.getInt("count")
      Timber.d("Restore Count = $count")
      binding.counter.text = count.toString()
    }

    binding.fab.setOnClickListener {
      ++count
      Timber.d("Count = $count")
      binding.counter.text = count.toString()
    }
  }

  override fun onSaveInstanceState(outState: Bundle) {
    // 데이터 저장
    outState.putInt("count", count)
    Timber.d("Save Count = $count")
    super.onSaveInstanceState(outState)
  }
}
```

다시 한번 아래의 흐름으로 진행해보겠습니다.

1. CounterActivity 실행
2. Counter 3번 클릭
3. 화면 회전
4. Counter 3번 클릭
5. 화면 회전

```shell
// CounterActivity 실행
Created : StateCounterActivity
Started : StateCounterActivity
Resumed : StateCounterActivity

// Counter 3번 클릭
Click => Count = 1
Click => Count = 2
Click => Count = 3

// 화면 회전
Paused : StateCounterActivity
Stopped : StateCounterActivity

// 데이터 저장
Save Count = 3
SaveInstanceState : StateCounterActivity
Destroyed : StateCounterActivity
Created : StateCounterActivity

// 데이터 복원
Restore Count = 3
Started : StateCounterActivity
Resumed : StateCounterActivity

// Counter 3번 클릭
Click => Count = 4
Click => Count = 5
Click => Count = 6

// 화면 회전
Paused : StateCounterActivity
Stopped : StateCounterActivity

// 데이터 저장
Save Count = 6
SaveInstanceState : StateCounterActivity
Destroyed : StateCounterActivity
Created : StateCounterActivity

// 데이터 복원
Restore Count = 6
Started : StateCounterActivity
Resumed : StateCounterActivity
```

3번씩 클릭한 데이터를 저장/복원이 올바르게 이루지는 것을 확인했습니다. 별도 라이브러리 및 ViewModel이 알려지기 전에도 기본적으로 onSaveInstanceState/onCreate를 사용해 Activity/Fragment 등이 강제 종료되었을 때에도 데이터를 잃지 않고 사용할 수 있습니다.

- - -

## ViewModel 이용

지금까지 앱이 회전 및 시스템으로부터 종료되고 다시 시작할 때 필요한 앱의 상태 저장과 복원을 알았습니다. [onSaveInstanceState()](https://developer.android.com/guide/components/activities/activity-lifecycle#save-simple-lightweight-ui-state-using-onsaveinstancestate)를 사용하여 저장할 수 있지만, 비즈니스 로직을 위한 데이터 처리나 검색하는 코드를 작성해야 합니다. [onSaveInstanceState()](https://developer.android.com/guide/components/activities/activity-lifecycle#save-simple-lightweight-ui-state-using-onsaveinstancestate) 사용 시에 다루는 Bundle은 Bitmap이나 대량의 데이터에 적합하지 않으며, 직렬화 가능한 작은 데이터에 적합합니다.

### ViewModel 

여기에서 Google이 제안하는 방법으로 [Android Architecture Components](https://developer.android.com/jetpack/#architecture-components) (이하 AAC) 의 [ViewModel](https://developer.android.com/reference/android/arch/lifecycle/ViewModel)입니다. 이미 많은 분들이 AAC 사용으로 앱의 아키텍처를 [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)(Model-View-ViewModel) 아키텍쳐 패턴에 유사한 형태로 개발하고 계실 겁니다. AAC의 ViewModel은 Activity 혹은 Fragment에 표시할 데이터를 가지고 있습니다. 그리고 데이터의 계산과 변환을 해서 UI에 표시할 데이터 처리도 합니다. 

> 참고 자료 : [Android Developers, Architecture Components ~ ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) 

다음 그림은 ViewModel의 생명주기를 나타내는 그림입니다.

<img src="https://2.bp.blogspot.com/-yDA6lQPeUM0/WjMEoM8_qsI/AAAAAAAABrU/aSrk1ePRyugp6Mna8mSPlq5K-4Moz9EcACLcBGAs/s1600/image1.png" width="75%" />

>  이미지 출처 : [ViewModel ~ The lifecycle of a ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel?hl=en#lifecycle) 

Activity에서 사용되는 ViewModel의 생명주기는 눈으로 보이는 Activity 화면의 생명주기보다 더 길게 유지됩니다. [onCreate()](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle)) 메서드를 처음 호출할 때 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html)이 생성되며, 회전 등으로 onCreate() 메서드가 여러 번 호출되더라도 생성된 ViewModel은 계속 존재합니다. 최종적으로 Finished 시점에 생성된 ViewModel이 제거됩니다.

### Activity에서 ViewModel 사용

실제 코드로 좀 더 보겠습니다

```kotlin
class ViewModelCounterActivity : AppCompatActivity() {
  private lateinit var counterViewModel: CounterViewModel

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = ActivityCounterBinding.inflate(layoutInflater)
    setContentView(binding.root)

    counterViewModel = ViewModelProvider(this).get(CounterViewModel::class.java)

    Timber.d("ViewModel = ${counterViewModel.hashCode()}")
    }
}
```

CounterViewModel은 빈 껍때기라도 괜찮습니다. 위 코드를 기준으로 Activity 실행 후 ViewModel의 HashCode를 확인해보면 동일한 결과를 출력하며 동일한 인스턴스라는 것을 알 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/05.png" }}" />

단순 회전 및 Configuration 정보 변화로 Activity가 새로 생성될 때에는 문제없이 ViewModel 인스턴스는 동일한 객체가 반환됩니다. 

### Sample ViewModel

```kotlin
class CounterViewModel : ViewModel() {
  private var counter = 0

  private val _countForm = MutableLiveData<Int>(counter)
  val countState: LiveData<Int> = _countForm

  fun incCounter() {
    ++counter
    Timber.d("Inc Counter => $counter")
    _countForm.value = counter
  }
}
```

### 시스템에 의한 종료

다만, 시스템에 의해서 종료된 경우는 ViewModel이 새롭게 생성됩니다. 그 이유는 ViewModel은 `메모리 내에 위치`하므로 해당 프로세스가 종료되면 인스턴스는 없어집니다. 

이제 시스템에 의한 종료를 확인해 보겠습니다. 먼저 Activity를 열고, 예제와 같이 3번의 클릭 후 홈 키를 누른 후 아래의 명령어를 입력합니다. 이번 테스트에서 샘플 앱의 패키지명은 "com.pluu.savedstate" 입니다. 

```shell
adb shell am kill com.pluu.savedstate
```

시스템에 의해서 종료된 ViewModel의 정보는 복원되지 않는 것을 볼 수 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/NdQwHwV0Vuo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

그리고 출력되는 로그도 체크해봅니다.

```shell
// Activity 실행
I/App$onCreate: Created : ViewModelCounterActivity
D/ViewModelCounterActivity: ViewModel = 196481873
I/App$onCreate: Started : ViewModelCounterActivity
I/App$onCreate: Resumed : ViewModelCounterActivity

// Home키 입력
I/App$onCreate: Paused : ViewModelCounterActivity
I/App$onCreate: Stopped : ViewModelCounterActivity

// adb shell am kill com.pluu.savedstate
    --------- beginning of system
I/ActivityManager: Killing 22984:com.pluu.savedstate/u0a134 (adj 700): kill background
I/WindowManager: WIN DEATH: Window{33d68ae u0 com.pluu.savedstate/com.pluu.savedstate.ui.ViewModelCounterActivity}

// Activity 재실행
I/ActivityManager: Start proc 23056:com.pluu.savedstate/u0a134 for activity {com.pluu.savedstate/com.pluu.savedstate.ui.ViewModelCounterActivity}
I/App$onCreate: Created : ViewModelCounterActivity
D/ViewModelCounterActivity: ViewModel = 248149374
I/App$onCreate: Started : ViewModelCounterActivity
I/App$onCreate: Resumed : ViewModelCounterActivity
```

백그라운드에서 시스템에 종료된 앱을 선택 시 다시 Activity가 생성되고 ViewModel 또한 새롭게 생성되는 것을 알 수 있습니다. 이러한 이유로 ViewModel을 사용하더라도 프로세스에 의해 중단된 경우에 복원이 필요하다면 [onSaveInstanceState()](https://developer.android.com/guide/components/activities/activity-lifecycle#save-simple-lightweight-ui-state-using-onsaveinstancestate)를 사용해서 데이터를 저장해야 합니다.

다음 섹션에서 이 문제의 보완점으로 Google 측에서 나온 솔루션을 살펴보겠습니다.

- - -

## SavedState + ViewModel 이용

이전 섹션에서 언급한 것처럼 [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html?hl=en) 을 사용하더라도 시스템에 의해 프로세스 중단을 처리해야 할 때에는 [`onSaveInstanceState()`](https://developer.android.com/reference/android/app/Activity?hl=en#onSaveInstanceState(android.os.Bundle))를 사용해야 할 수 있습니다. 

이때 사용할 수 있는 방법으로 SavedState ViewModel이 있습니다. SavedState ViewModel은 Google I/O '19에서 처음 소개되었습니다. 

<iframe width="560" height="315" src="https://www.youtube.com/embed/Qxj2eBmXLHg?start=686" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### 설정

[Activity 1.1.0](https://developer.android.com/jetpack/androidx/releases/activity#1.1.0) 혹은 [Fragment 1.2.0](https://developer.android.com/jetpack/androidx/releases/fragment#1.2.0) 을 사용하는 경우 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel) 인스턴스의 기본 팩토리는 추가 구성없이  `SavedStateHandle`을 `ViewModel`에 전달하도록 지원합니다. 본 글에서는 수동으로 전달하는 방법을 설명합니다.

> AndroidX ~ [Activity](https://developer.android.com/jetpack/androidx/releases/activity) / [Fragment](https://developer.android.com/jetpack/androidx/releases/fragment) / [Lifecycle](https://developer.android.com/jetpack/androidx/releases/lifecycle#declaring_dependencies)

SavedState + ViewModel을 위해서는 build.gradle에 아래의 모듈을 추가해서 사용할 수 있습니다.

```groovy
implementation 'androidx.lifecycle:lifecycle-viewmodel-savedstate:2.2.0'
```

### Code

[ViewModelProvider](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider) 을 통해서 데이터를 가져오는 것은 기존과 동일합니다. 대신 두 번째 파라매터로 SavedState를 지원하는 ViewModel Factory를 전달합니다. 샘플에서는 `lifecycle-viewmodel-savedstate`에 포함되어 있는 [SavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/SavedStateViewModelFactory)를 사용했습니다.

```kotlin
val counterViewModel = ViewModelProvider(
  this,
  SavedStateViewModelFactory(application, this)
).get(SavedStateCounterViewModel::class.java)
```

Dagger 등을 사용할 때 [ViewModelProvider.Factory](https://developer.android.com/reference/androidx/lifecycle/ViewModelProvider.Factory.html)를 재정의해서 작성하기도 합니다. 이 경우에는 [AbstractSavedStateViewModelFactory](https://developer.android.com/reference/androidx/lifecycle/AbstractSavedStateViewModelFactory) 를 사용할 수 있습니다.

### ViewModel

SavedState + ViewModel을 하는 코드 ViewModel은 아래와 같습니다.

```kotlin
class SavedStateCounterViewModel(
  private val handle: SavedStateHandle
) : ViewModel()
```

기존 ViewModel 사용과 다른 부분은 인자로  [`SavedStateHandle`](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html) 가 전달되는 부분입니다.

### SavedStateHandle

 [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html?hl=en) 의 생성자로 넘어오는  [`SavedStateHandle`](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html)  객체는 Key-Value 형태인 Map 구조입니다. SavedStateHandle은 프로세스가 시스템에 의해 종료되더라도 유지됩니다.

[get(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#get(java.lang.String)) 을 통해서 값을 가져올 수 있으며 [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String))를 이용해 [LiveData](https://developer.android.com/reference/androidx/lifecycle/LiveData.html)를 리턴할 수도 있습니다. [set(String, Object)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#set(java.lang.String,%20T))를 통해서 값을 저장하거나 [getLiveData(String)](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String)) 를 통해서 반환된 LiveData에 새로운 값을 전달합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0208-savedsate/SavedStateHandle.png" }}" />

> 이미지 출처 : [SavedStateHandle](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html)

## SavedState Sample Code

샘플로 작성한 코드는 아래와 같습니다.

### Activity Code

```kotlin
class SavedStateViewModelCounterActivity : AppCompatActivity() {

  private lateinit var counterViewModel: SavedStateCounterViewModel

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binding = ActivityCounterBinding.inflate(layoutInflater)
    setContentView(binding.root)

    counterViewModel = ViewModelProvider(
      this,
      SavedStateViewModelFactory(application, this)
    ).get(SavedStateCounterViewModel::class.java)

    Timber.d("ViewModel = ${counterViewModel.hashCode()}")

    counterViewModel.countState.observe(this, Observer {
      binding.counter.text = it.toString()
    })

    binding.fab.setOnClickListener {
      counterViewModel.incCounter()
    }
  }
}
```

### ViewModel

```kotlin
class SavedStateCounterViewModel(
  private val handle: SavedStateHandle
) : ViewModel() {

  // Get value of SavedStateHandle
  private var counter = handle.get<Int>("counter") ?: 0
    set(value) {
      // Set value of SavedStateHandle
      handle.set("counter", value)
      field = value
    }

  private val _countForm = MutableLiveData<Int>(counter)
  val countState: LiveData<Int> = _countForm

  // Get LiveData of SavedStateHandle
  val countLiveData: LiveData<Int> = handle.getLiveData("count", 0)

  fun incCounter() {
    ++counter
    Timber.d("Inc Counter => $counter")
    _countForm.value = counter
  }
}
```

### 결과

시스템에 의한 앱 종료가 되어도 기존 데이터가 정상적으로 보관되는 것을 확인할 수 있습니다. 이것으로 ViewModel을 사용하면서 데이터를 보다 안정적으로 보관할 수 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/MXfWkQ_wnYk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## 정리

상태를 저장하기 위해서 Android Developers Guide에서는 다음과 같이 안내되고 있습니다. 

|                                                  | ViewModel                                                    | 저장된 인스턴스 상태                                         | 영구 저장소                                                  |
| ------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 저장소 위치                                      | 메모리 내                                                    | 디스크에 직렬화                                              | 디스크 또는 네트워크 내                                      |
| 구성 변경 시에도 유지                            | 예                                                           | 예                                                           | 예                                                           |
| 시스템에서 시작된 프로세스 중단 시에도 유지      | 아니요                                                       | 예                                                           | 예                                                           |
| 사용자의 완전한 활동 닫기/onFinish() 시에도 유지 | 아니요                                                       | 아니요                                                       | 예                                                           |
| 데이터 제한                                      | 복잡한 개체도 괜찮지만 사용 가능한 메모리에 의해 공간이 제한됨 | 원시(primitive) 유형 및 문자열과 같은 단순하고 작은 개체만 해당 | 디스크 공간 또는 네트워크 리소스에서 검색하는 비용/시간에 의해서만 제한됨 |
| 읽기/쓰기 시간                                   | 빠름(메모리 액세스만)                                        | 느림(직렬화/역직렬화 및 디스크 액세스 필요)                  | 느림(디스크 액세스 또는 네트워크 트랜잭션 필요)              |

> 출처 : [Saving States ~ Options for preserving UI state](https://developer.android.com/topic/libraries/architecture/saving-states.html?hl=en#options_for_preserving_ui_state)

Android에서 상태를 저장하기위해서 ViewModel, onSaveInstanceState(), DB 등을 사용하는 방법이 있습니다. 혹은 다른 라이브러리를 사용해서 프로세스에 의해 앱이 종료되더라도 안정적으로 상태를 관리하는 방법도 존재합니다.

최종적으로는 현재 앱에 적용된 아키텍처와 앞으로의 방향에 따라서 선택할 필요가 있습니다.

> 이번 글에서 사용된 샘플 코드는 다음 [링크](https://github.com/Pluu/Android-UI-SavedState-Sample)에서 확인할 수 있습니다.

## 참고 자료

- [Android Developers ~ Activity](https://developer.android.com/reference/android/app/Activity)
- [Android Developers ~ Saving UI States](https://developer.android.com/topic/libraries/architecture/saving-states)
- [Android Developers ~ Saved State module for ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel-savedstate)
- [Medium ~ The Android Lifecycle cheat sheet — part I: Single Activities](https://medium.com/androiddevelopers/the-android-lifecycle-cheat-sheet-part-i-single-activities-e49fd3d202ab)
- [Medium ~ ViewModels : A Simple Example](https://medium.com/androiddevelopers/viewmodels-a-simple-example-ed5ac416317e) 
- [Medium ~ ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders](https://medium.com/androiddevelopers/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders-fc7cc4a6c090) 
- [Android Kotlin Fundamentals Course ~ 04.2: Complex lifecycle situations](https://codelabs.developers.google.com/codelabs/kotlin-android-training-complex-lifecycle/index.html?index=..%2F..android-kotlin-fundamentals#4)
- [Android Kotlin Fundamentals Course ~ 05.1: ViewModel and ViewModelFactory](https://codelabs.developers.google.com/codelabs/kotlin-android-training-view-model/index.html)
- [Google Codelab ~ Lifecycle-Aware Components](https://codelabs.developers.google.com/codelabs/android-lifecycles/#0)

- - -

ViewModel 에 대해서 총 5개의 글을 소개합니다.

- 1부 : [Android 상태 저장의 기본에서 Savedstate까지]({{ page.url }}) <-- 현재 글
- 2부 : [SavedState is Default]({{ site.url }}/blog/android/2020/02/15/diff-androidx-lifecycle/)
- 3부 : [SavedStateHandle을 다뤄봅니다]({{ site.url }}/blog/android/2020/02/20/savedstatehandle/)
- 4부 : [SavedState 어떻게 저장되고 복원될까?]({{ site.url }}/blog/android/2020/03/15/savedstate-flow/)
- 5부 : [ViewModel의 탄생에서 죽음까지]({{ page.url }}/blog/android/2020/05/04/viewmodel-b-to-d/)
