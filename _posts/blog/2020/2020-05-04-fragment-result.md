---
layout: post
title: "Fragment의 새로운 도약, FragmentResult"
date: 2020-05-04 15:15:00 +09:00
tag: [Android, AndroidX, FragmentResult]
categories:
- blog
- Android
---

본 글에서는 [Fragment 1.3.0-alpha04](https://developer.android.com/jetpack/androidx/releases/fragment#1.3.0-alpha04) 에서 추가된 Fragment Result을 다룹니다.

<!--more-->

## 기존 Fragment간 데이터 전달

Fragment간 데이터 전달시 Listener를 사용하는 것은 쉬운 방법 중 하나입니다. 혹은 [Shared ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel#sharing)을 이용해서 데이터 전달하는 방법도 있습니다. 이 섹션에서는 기본적인 방법인 Listener를 사용합니다. 샘플에서 전달할 데이터 타입은 `String` 형태입니다.

```kotlin
class FragmentB : Fragment() {
  interface OnResultListener { // Fragment 간의 통신용 Listener 정의 
    fun onResult(value: String)
  }
  
  private var listener: OnResultListener? = null
  ...
  fun setListener(listener: OnResultListener) { // 외부에서 전달할 Setter Listener
    this.listener = listener
  }

  private fun clickDone() {
    listener?.onResult(/** Write result */)
    parentFragmentManager.popBackStack()
  }  
}
```

FragmentA보다 FragmentB를 먼저 살펴봅니다. 데이터를 전달하는 주체는 `FragmentB`이므로 Listener 정의(`OnResultListener`)를 합니다. FragmentB를 사용하는 쪽에서는 setListener(OnResultListener) 함수를 사용해서 데이터를 전달받습니다.

```kotlin
class FragmentA : Fragment(), FragmentB.OnResultListener {
  ...
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    ...
    val restoreValue = arguments?.getString(keyRestore) // View가 Recreate시 처리
    if (restoreValue != null) {
      /** action to do something */
    }
  }
  
  private fun showFragmentB() {
    parentFragmentManager.commit {
        replace(R.id.container, OldBasicChild2Fragment().apply {
          setListener(this@OldBasicChild1Fragment) // FragmentB 표시할때 Listener를 전달
        })
        addToBackStack(null)
      }
  }

  override fun onResult(value: String) { // Implement FragmentB.OnResultListener
    if (isVisible) { // Fragment가 Visible 중일때만 처리
      /** action to do something */
    } else {
      // Visible이 아닐 경우 Fragment#Arguemtn에 데이터 저장
      arguments = (arguments ?: Bundle()).also {
        it.putString(keyRestore, value)
      }
    }
  }
  companion object {
    private const val keyRestore = "resultRestore"
  }
}
```

위 예제는 FragmentA에서 FragmetnB 호출하는 예제입니다. 단순하게 Fragment의 `OnResultListener`를 호출하면 FragmentA는 [FragmentTransaction#replace(Int, Fragment)](https://developer.android.com/reference/androidx/fragment/app/FragmentTransaction#replace(int,%20androidx.fragment.app.Fragment)) 사용으로 FragmentManager에 추가되어 있지않아서 [Fragment#isVisible()](https://developer.android.com/reference/androidx/fragment/app/Fragment#isVisible())이 false가 됩니다. 그래서 Fragment View가 생성된 후, FragmentB로부터 전달된 데이터를 노출하기 위해서 Fragment의 arguments에 데이터를 임시 저장합니다.

> 이 패턴은 방법 중 하나이므로 이 방식이 100% 정답이 되지않습니다. 각자의 프로젝트의 상황에 맞게 구성하면 됩니다.

## FragmentResult

Fragment간의 데이터 전달은 앞서 소개한 Listener를 사용하는 방법이나 [Shared ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel#sharing) 를 사용하는 방법이 있습니다. 다만 몇가지의 부가적인 코드가 필요합니다. Android 개발시에 부족한 부분을 부가적인 코드와 주입으로 해결한 형태였습니다. 그 대신 [Fragment 1.3.0-alpha04](https://developer.android.com/jetpack/androidx/releases/fragment#1.3.0-alpha04) 에서 Fragment 결과 전달을 위한 기능이 추가되었습니다. 

업데이트 내역은 다음과 같습니다.

> Added support for passing results between two Fragments via new APIs on `FragmentManager`. This works for hierarchy fragments (parent/child), DialogFragments, and fragments in Navigation and ensures that results are only sent to your Fragment while it is at least `STARTED`. ([b/149787344](https://issuetracker.google.com/issues/149787344))

> 출처 : https://developer.android.com/jetpack/androidx/releases/fragment#1.3.0-alpha04

업데이트 내역에서는 동일한 `FragmentManager` 를 참조하는 Fragment에 대해서 데이터를 전달할 수 있다고 설명하고 있습니다. 그 결과는 Fragment Lifecycle이 STARTED 상태일때 수신됩니다. 이 기능은 parent/child 형태의 Fragment, DialogFragment 그리고 Navigation에서도 사용할 수 있습니다.

위 설명을 간단하게 그림으로 표현하면 아래와 같습니다.

<img src="https://developer.android.com/images/training/basics/fragments/fragment-b-to-a.png" width="400" />

> 이미지 출처 : https://developer.android.com/training/basics/fragments/pass-data-between

그림을 통해서 알 수 있는것처럼 FragmentManager를 통해서 Fragment의 결과가 전달된다는 사실을 알 수 있습니다.

### 전제조건

이후에 언급되는 코드에는 아래와 같은 기능을 사용했습니다.

- Kotlin
- AndroidX : fragment-ktx:1.3.0-alpha04
- View Binding

### FragmentResut API

Fragment에서 Result를 설정하는 API와 Result를 수신하는 API는 다음과 같습니다. `fragment-ktx` 소스이지만 확인하는 것은 어렵지 않을겁니다.

```kotlin
// Result API
fun Fragment.setFragmentResult(
    requestKey: String,
    result: Bundle?
) = parentFragmentManager.setFragmentResult(requestKey, result)
```

```kotlin
// Result Listener API
fun Fragment.setFragmentResultListener(
    requestKey: String,
    listener: ((resultKey: String, bundle: Bundle) -> Unit)?
) {
    parentFragmentManager.setFragmentResultListener(requestKey, this, listener)
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/fragment/fragment-ktx/src/main/java/androidx/fragment/app/Fragment.kt

실제 해당 사례를 어떻게 적용가능한지 몇가지의 사례를 살펴보겠습니다.

### 샘플1. 기존 Listener 방식에서 FragmentResult로 전환

```kotlin
class FragmentA : Fragment() {
  ...  
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    ...
    setFragmentResultListener("requestKey") { resultKey, result ->
      // Bundle[{key=value}]
      // action to do something
    }
    ...
  }
}
```

결과를 수신하는 FragmentA에서는 기존 FragmentB에서 정의한 Listener관련 코드가 제거되었습니다. 대신 기존 Listener를 대신할 [setFragmentResultListener(String, (String, Bundle) -> Unit)](https://developer.android.com/reference/kotlin/androidx/fragment/app/package-summary#setfragmentresultlistener) API 가 추가되었습니다.

```kotlin
class FragmentB : Fragment() {
  ...
  private fun clickDone() {
    setFragmentResult("requestKey", bundleOf("key" to "value"))
    ...
  }  
  ...
}
```

결과를 전달하는 FragmentB는 Listener 대신 [setFragmentResult(String, Bundle?)](https://developer.android.com/reference/kotlin/androidx/fragment/app/package-summary#setfragmentresult) API가 사용되었습니다. 기존 Listener와 [Shared ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel#sharing) 를 사용하는 방법보다 코드량이 간소화된 것을 볼 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0504-fragmentresult/sample_navigation.gif" }}" width="400" />

> Navigation Component를 사용한 예제이지만, 사용법은 동일합니다.

### 샘플2. Master/Detail 관계

또 다른 사용 패턴으로는 한 화면에 Fragment가 2개가 있는 케이스도 있습니다. 태블릿과 같은 큰화면에서 리스트와 상세화면으로 나눠 더 많은 정보를 표시할 때 사용하는 패턴입니다.

<img src="https://developer.android.com/images/training/basics/fragments-screen-mock.png" width="400" />

> 이미지 출처 : https://developer.android.com/training/basics/fragments/fragment-ui

먼저 단순하게 1:1 비율로 위아래로 Fragment를 배치하는 레이아웃을 구성합니다.

```xml
<LinearLayout ...>
    <androidx.fragment.app.FragmentContainerView
        android:id="@+id/master_fragment"
        android:name="com.pluu.fragmentresult.sample.flexible.FlexibleMasterFragment"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1" />

    <androidx.fragment.app.FragmentContainerView
        android:id="@+id/detail_fragment"
        android:name="com.pluu.fragmentresult.sample.flexible.FlexibleDetailFragment"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_marginTop="20dp"
        android:layout_weight="1" />
</LinearLayout>
```

#### MasterFragment

Fragment 데이터를 전달하는 MasterFragment는 ListFragment를 사용해 리스트 형태로 그리는 구조를 만듭니다. 

```kotlin
import androidx.fragment.app.setFragmentResult

class FlexibleMasterFragment : ListFragment() {
  private val list = (0..20).map {
    "Item $it"
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    listAdapter = ArrayAdapter(requireContext(), android.R.layout.simple_list_item_1, list)
  }

  override fun onListItemClick(l: ListView, v: View, position: Int, id: Long) {
    super.onListItemClick(l, v, position, id)
    setFragmentResult(requestKey, bundleOf(resultKey to list[position])) // Item Click시 setFragmentResult로 결과 전달
  }

  companion object {
    const val requestKey = "flexible" // FragmentResult에 데이터 전달을 위한 RequestKey
    const val resultKey = "item" // Bundle에 저장할 데이터 Key
  }
}
```

샘플 구성을 위해서 코드가 나열되어 있지만, 핵심인 부분은 `onListItemClick()` 함수입니다. 선택한 항목을 [setFragmentResult(String, Bundle?)](https://developer.android.com/reference/kotlin/androidx/fragment/app/package-summary#setfragmentresult) API를 사용해서 데이터를 전달합니다.

#### Detail Fragment

```kotlin
class FlexibleDetailFragment : Fragment(R.layout.fragment_flexible_detail) {
  ...
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    setFragmentResultListener(FlexibleMasterFragment.requestKey) { _, bundle ->
      binding.tvLabel.text = bundle.getString(FlexibleMasterFragment.resultKey)
    }
  }
}
```

FlexibleMasterFragment에 미리 정의한  `requestKey` 를 이용해서 Fragment로부터 데이터 수신을 등록합니다. 수신된 데이터를 사용해서 화면에 노출하는 간단한 코드입니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0504-fragmentresult/sample_flexible.gif" }}" width="400" />

> Master/Defail 구조의 샘플

샘플1의 화면 전환에 사용된 FragmentResult도 간단한 코드입니다.

## Parent/Child Fragment 간의 데이터 전달

앞서 소개한 FragmentResult는 부모의 FragmentManager를 통해서 데이터가 전달가능했습니다. Fragment의 또다른 특성에는 Fragment를 내포할 수 있다는 구조입니다. 그래서 자식 Fragment의 결과를 부모 Fragmetn로 결과를 전달해야하는 케이스도 있습니다.

<img src="https://developer.android.com/images/training/basics/fragments/parent-to-child.png" width="400" />

> 이미지 출처 : https://developer.android.com/training/basics/fragments/pass-data-between#child

앞서 FrgmentResult는 FragmentManager를 통해서 결과를 전달한다는 사실을 소개했습니다. 그리고 Fragment는 [Fragment#getChildFragmentManager()](https://developer.android.com/reference/androidx/fragment/app/Fragment#getChildFragmentManager()) 와 [Fragment#getParentFragmentManager()](https://developer.android.com/reference/androidx/fragment/app/Fragment#getParentFragmentManager()) 를 가지고 있습니다.

그럼 자식 Fragment에서 전달된 결과를 부모 Fragment로 전달하기 위해서는 두 FragmentManager를 사용해서 데이터를 전달한다는 사실을 알 수 있습니다. 복잡하게 Fragment가 중첩되더라도 각 `FragmentManager`를 통해 데이터 수신/송신만 작성한다면 스펙대로 동작을 합니다.

- ChildFragmentManager를 통해 FragmentResult 수신
- ParentFragmentManager로 FragmentResult 송신

다음 샘플을 통해서 어떻게 처리할지 살펴보겠습니다.

### 샘플3. Stack으로 쌓은 Fragment

#### ChildFragmentManager Kotlin-Extension

먼저 알아야할 내용은 [Fragment 1.3.0-alpha04](https://developer.android.com/jetpack/androidx/releases/fragment#1.3.0-alpha04) Fragment-ktx에서 제공하는 [FragmentResultListener](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/fragment/fragment-ktx/src/main/java/androidx/fragment/app/Fragment.kt)는 ParentFragmentManager의 데이터를 수신하고 있습니다. 그러나 우리가 필요한 것은 ChildFragmentManager를 사용하는 것입니다. 여기에서는 코드 작성을 좀 더 쉽게하기 위해서 아래와 같은 ChildFragmentManager로 부터 데이터를 수신하는 kotlin extension을 만듭니다. 또한 FragmentActivity에서 데이터를 수신하는 용도의 extension 도 추가합니다.

```kotlin
// Fragment 에서 childFragmentManager를 사용한 FragmentResultListener Extension 
fun Fragment.setChildFragmentResultListener(
  requestKey: String,
  listener: ((resultKey: String, bundle: Bundle) -> Unit)?
) {
  childFragmentManager.setFragmentResultListener(requestKey, this, listener)
}

// FragmentActivity 에서 FragmentResultListener Extension 
fun FragmentActivity.setFragmentResultListener(
  requestKey: String,
  listener: ((resultKey: String, bundle: Bundle) -> Unit)?
) {
  supportFragmentManager.setFragmentResultListener(requestKey, this, listener)
}
```

#### 시도하려는 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0504-fragmentresult/stack1.png" }}" />

이번 샘플에서 시도해보려는 것은 Activity에서 시작하여 Fragment가 총 3개의 피라미드 형태로 쌓인 구조입니다. 그리고 각 Activity/Fragment마다 TextView를 하나씩 들고 있습니다. 이 FragmentResult API를 통해 수신된 데이터를 TextView 에 노출할겁니다. 실제로 이렇게 구성해야하는 경우는 거의 없겠지만, Parent/Child FragmentManager를 위한 테스트입니다.

#### Layout Structure

각 화면에서 수신할 FragmentResult의 RequestKey는 다음과 같습니다

- Activity : keyRoot
- BetweenStack1Fragment : keyStep1
- BetweenStack2Fragment : keyStep2
- BetweenStackLastFragment : current

FragmentResult에는 Activity관련 설명은 없습니다만, 최상위 FragmentManager는 결국 FragmentActivity가 들고있는 FragmentManager이므로 결과를 전달받을 수 있습니다. 실제 코드를 구현하기전 다시 기억해야할 사항은 FragmentResult는 동일한 `FragmentManager` 간의 데이터만 수신할 수 있습니다. 

이것을 토대로 각 result마다 어떤 형태로 데이터가 전달되는지 생각해봅니다.

|                          | current       | keyStep2       | keyStep1       | keyRoot        |
| ------------------------ | ------------- | -------------- | -------------- | -------------- |
| BetweenStackLastFragment | (데이터 처리) | ⇣ Pending Data | ⇣ Pending Data | ⇣ Pending Data |
| BetweenStack2Fragment    |               | (데이터 처리)  | ⇣ Pending Data | ⇣ Pending Data |
| BetweenStack1Fragment    |               |                | (데이터 처리)  | ⇣ Pending Data |
| BetweenStackActivity     |               |                |                | (데이터 처리)  |

각 Fragment는 Parent/Child FragmentManager만 알 수있고, FragmentActivity는 자신이 소유하고있는 FragmentManager만 알고 있습니다. 그로인해 위의 표와같이 데이터를 ParentFragmentManager로 전달해야합니다. 

위의 표를 어떻게 구현했는지는 이후 코드를 통해서 확인할 수 있습니다.

#### Code

BetweenStackActivity

```kotlin
import com.pluu.util.setFragmentResultListener

class BetweenStackActivity : AppCompatActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    ...
    setFragmentResultListener(ResultConstract.keyRoot) { resultKey, result ->
      /** action to do something */ 
    }
  }
}
```

BetweenStack1Fragment

```kotlin
import androidx.fragment.app.setFragmentResult
import com.pluu.util.setChildFragmentResultListener

class BetweenStack1Fragment : Fragment(R.layout.fragment_between_stack1) {
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    ...
    setChildFragmentResultListener(ResultConstract.keyStep1) { resultKey, result ->
      /** action to do something */ 
    }
    setChildFragmentResultListener(ResultConstract.keyRoot) { resultKey, result ->
      // ChildFragment인 BetweenStack2Fragment로부터 전달된 데이터를 ParentFragment로 전달
      setFragmentResult(resultKey, result)
    }
  }
}
```

BetweenStack2Fragment

```kotlin
import androidx.fragment.app.setFragmentResult
import com.pluu.util.setChildFragmentResultListener

class BetweenStack2Fragment : Fragment(R.layout.fragment_between_stack2) {
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    ...
    setChildFragmentResultListener(ResultConstract.keyStep2) { resultKey, result ->
      /** action to do something */ 
    }
    setChildFragmentResultListener(ResultConstract.keyRoot) { resultKey, result ->
      // ChildFragment인 BetweenStack3Fragment로부터 전달된 데이터를 ParentFragment로 전달
      setFragmentResult(resultKey, result)
    }
    setChildFragmentResultListener(ResultConstract.keyStep1) { resultKey, result ->
      // ChildFragment인 BetweenStack3Fragment로부터 전달된 데이터를 ParentFragment로 전달
      setFragmentResult(resultKey, result)
    }
  }
}
```

BetweenStackLastFragment

```kotlin
import androidx.fragment.app.setFragmentResult
import androidx.fragment.app.setFragmentResultListener

class BetweenStackLastFragment : Fragment(R.layout.fragment_between_stack_last) {
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    ...
    binding.btnConfirm.setOnClickListener {
      // End Point : BetweenStackActivity
      setFragmentResult(
        ResultConstract.keyRoot, bundleOf("key_string" to "==> root", "Int" to 0)
      )
      // End Point : BetweenStack1Fragment
      setFragmentResult(
        ResultConstract.keyStep1, bundleOf("key_string" to "==> stack1", "Int" to 1)
      )
      // End Point : BetweenStack2Fragment
      setFragmentResult(
        ResultConstract.keyStep2, bundleOf("key_string" to "==> stack2", "Int" to 2)
      )
      // End Point : BetweenStackLastFragment
      setFragmentResult(
        "current", bundleOf("key_string" to "==> current", "Int" to 3)
      )
    }

    setFragmentResultListener("current") { _, result ->
      /** action to do something */ 
    }
  }
}
```

이 코드를 적용하면 아래 그림과같이 Fragment간의 데이터 전달이 예상한대로 동작합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0504-fragmentresult/stack2.png" }}" />

## 정리

- Fragment에서 데이터를 전달하기 및 수신하는 방법이 모두 간단해졌습니다. 
- FragmentManager를 접근할 수 있는 곳에서는 `FragmentResultListener` 를 사용해서 결과를 얻을 수 있습니다.
- 동일한 requestKey에 대해서 2번 옵저빙을 하는 경우, 한곳에서만 수신됩니다.
- Navigation Component의 기본 API로는 결과값을 전달할 수 없었지만, 새로운 API로 문제도 해결됩니다.

샘플 소스 : https://github.com/Pluu/FragmentResultSample

## 참고

Android Developers > Docs > Guides

- [Pass data between fragments](https://developer.android.com/training/basics/fragments/pass-data-between)
