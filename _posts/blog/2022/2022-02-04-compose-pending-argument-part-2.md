---
layout: post
title: "Navigating with Compose ~ Serializable/Parcelable 데이터 전달 ~ 2부"
date: 2022-02-04 20:30:00 +09:00
tag: [Android, AndroidX, Navigation, Compose]
categories:
- blog
- Android
---

본 글은 AndroidX Jetpack Navigation x Compose 사용 시 데이터 전달에 대해 살펴보는 글입니다.

<!--more-->

1부에서는 데이터 전달의 기본 지식을 살펴보고, 2부에서는 Serializable/Parcelable 전달의 해결법을 다룹니다.

- [1부 링크]({{ site.url }}/blog/android/2022/02/03/compose-pending-argument-part-1/)
- 2부 : <-- 현재 글

------

2부에서는 Navigation Compose/hiltViewModel에 데이터를 전달하는 방법 중 몇 가지의 케이스를 다룹니다.

## 0. Navigation의 조건

AndroidX Navigation은 화면의 관계를 Navigation Graph와 DeepLink 이렇게 2가지의 기능이 있습니다. 여기서 사용하는 DeepLink는 `manifest.xml`에 정의할 수도 있으며 graph를 정의할 때 각 항목에 기입할 수 있습니다.

우리가 사용하는 DeepLink는 아래와 같은 구조를 가집니다.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/URI_syntax_diagram.svg/1280px-URI_syntax_diagram.svg.png" />

> 이미지 출처 : https://en.wikipedia.org/wiki/Uniform_Resource_Identifier#Syntax

DeppLink의 데이터는 기본적으로 문자열로 표시합니다. 이 구조에서 적절한 Serializable/Parcelable의 작성법은 어렵습니다. 그리하여 Navigation에서는 미지원을 했을 거라고 생각됩니다.

## 해결법 1. 🚧🚧 API의 흐름을 알고서 이용하는 방법 🚧🚧

> 아래 내용은 API 흐름을 알고서 사용하는 방법입니다. 따라서 AndroidX 업데이트에 따라서 동작하지 않을 수 있습니다.
>
> 🔴🔴🔴 해결법 1은 `Navigation 2.6.0-alpha01` 부터의 스펙 변경으로 동작하지 않습니다. 🔴🔴🔴
>
> 또한, 간단한 케이스에서만 유효한 동작일 수 있습니다.

[1부]({{ site.url }}/blog/android/2022/02/03/compose-pending-argument-part-1/)에서 우리는 NavBackStackEntry#arguments에 포함된 데이터가 ViewModel까지 전달할 수 있다는 사실을 배웠습니다.

```kotlin
@Composable
fun SampleNavGraph(
  // ...
) {
  NavHost(
    // ...
  ) {
    composable(route = /** Route 1 */) { entry ->
      // ...
      navController.navigate(/** Route 2 */)
    }
    composable(route = /** Route 2 */) { entry ->
      // ...
    }
  }
}
```

이제 우리가 해볼 작업은 Route2에 해당하는 NavBackStackEntry의 arguments에 데이터를 직접 추가하는 것입니다.

### ⚠️⚠️ 최종 코드 ⚠️⚠️

먼저 최종 코드를 살펴보겠습니다.

```kotlin
import androidx.core.os.bundleOf
import androidx.navigation.NavController
import androidx.navigation.NavOptions
import androidx.navigation.Navigator
import logcat.LogPriority.WARN
import logcat.logcat

fun NavController.navigateAndArgument(
  route: String,
  args: List<Pair<String, Any>>? = null,
  navOptions: NavOptions? = null,
  navigatorExtras: Navigator.Extras? = null,
) {
  // ⓵ navigate 호출하면, route의 NavBackStackEntry가 backQueue에 추가됨
  navigate(route, navOptions, navigatorExtras)

  if (args == null || args.isEmpty()) {
    return
  }

  // ⓶ backQueue.lastOrNull()의 결과로 route의 NavBackStackEntry가 반환
  val bundle = backQueue.lastOrNull()?.arguments
  if (bundle != null) {
    // ⓷ Bundle 타입의 arguments가 Null이 아니면, 전달하려는 데이터를 추가한다.
    bundle.putAll(bundleOf(*args.toTypedArray()))
  } else {
    logcat(WARN) {
      "The last argument of NavBackStackEntry is null."
    }
  }
}
```

기본적으로 Route에 해당하는 NavBackStackEntry를 가져와서 추가하는 방법입니다.

- ⓵ : NavController#navigate를 호출하면 전달된 Route를 기준으로 매칭되는 DeepLink를 찾은 후 `backQueue`에 추가됩니다.
- ⓶ : ⓵번 동작으로 추가된 NavBackStackEntry의 Argument를 가져옵니다.
- ⓷ : Argument에 필요한 데이터를 추가합니다.

### 코드 설명

NavController 내부에 BackStack에 추가한 Entry가 들어있습니다. 우리는 여기에 포함된 NavBackStackEntry를 가져와서 사용합니다.

```kotlin
public open class NavController {
  // ...
  /**
   * Retrieve the current back stack.
   *
   * @return The current back stack.
   * @hide
   */
  @get:RestrictTo(RestrictTo.Scope.LIBRARY_GROUP)
  public open val backQueue: ArrayDeque<NavBackStackEntry> = ArrayDeque()
  // ...
}
```

> backQueue 프로퍼티는 LIBRARY_GROUP이므로 추후 외부에서 접근되지 않을 수 있습니다.

그리고 NavBackStackEntry에서 데이터를 추가할 arguments를 살펴보겠습니다. arguments 프로퍼티는 nullable 및 read-only로 정의되어 있어서, 실제 접근 시 null 가능성이 있으므로 데이터 전달이 실패할 수 있습니다.

```kotlin
public class NavBackStackEntry private constructor(
  // ...
  /**
   * The arguments used for this entry
   * @return The arguments used when this entry was created
   */
  public val arguments: Bundle? = null,
)
```

그로 인해 해결법 1은 불완전한 해결법입니다. 

## 해결법 2. Shared ViewModel

1번째보다 더 안전한(?) Shared ViewModel을 사용하는 방법입니다. 

Shared ViewModel 생성의 핵심은 동일한 `ViewModelStoreOwner`를 사용해서 생성하는 것이 포인트입니다. 동일한 ViewModel Store라면 항상 같은 ViewModel을 가져오므로 Shared ViewModel 형태가 됩니다. Nested Navigation를 사용할 경우에도 원하는 Scope에 해당하는 `ViewModelStoreOwner`를 가져오도록 대응하면 됩니다.

이미 [viewModel](https://developer.android.com/reference/kotlin/androidx/lifecycle/viewmodel/compose/package-summary#viewModel(androidx.lifecycle.ViewModelStoreOwner,%20kotlin.String,%20androidx.lifecycle.ViewModelProvider.Factory))/[hiltViewModel](https://developer.android.com/reference/kotlin/androidx/hilt/navigation/compose/package-summary#hiltViewModel(androidx.lifecycle.ViewModelStoreOwner)) KTX에서도 ViewModelStoreOwner를 파라미터로 받을 수 있으므로, 원하는 KTX를 사용하시면 됩니다.

```kotlin
NavHost(
  navController = navController,
  startDestination = "First",
  modifier = modifier
) {
  composable(route = "First") { entry ->
    entry.print(navController)
    SampleUi(
      title = "First",
      onClick = {
        navController.navigate("Second?test=abcd")
      }
    )
  }
  composable(route = "Second?test={test}",
    arguments = listOf(
      navArgument("test") { type = NavType.StringType }
    )
  ) { entry ->
    entry.print(navController)
    SampleUi(title = "Second")
  }
}

@Composable
private fun NavBackStackEntry.print(navController: NavController) {
  val parentId = destination.parent!!.id
  val parentEntry = remember {
    navController.getBackStackEntry(parentId)
  }
  // 동일한 ViewModelStoreOwner를 사용하도록 처리
  val viewModelStoreOwner: ViewModelStoreOwner = parentEntry
  
  val test1: SampleViewModel = viewModel(viewModelStoreOwner)
  val test2: SampleViewModel = hiltViewModel(viewModelStoreOwner)
  logcat(tag = "logger") {
    "${destination.route} : ViewModelStoreOwner=${viewModelStoreOwner.hashCode()}, vm1=${test1.hashCode()}, vm2=${test2.hashCode()}"
  }
}

// 출력 결과
// First : ViewModelStoreOwner=-218587067, vm1=10245372, vm2=10245372
// Second?test={test} : ViewModelStoreOwner=-218587067, vm1=10245372, vm2=10245372
```

샘플로 살펴본 ViewModel의 HashCode가 모두 동일한 것을 볼 수 있습니다. 이렇게 우리가 원하는 형태로 데이터가 수신되는 것을 확인했습니다.

> StackOverflow에 [ian lake](https://stackoverflow.com/users/1676363/ianhanniballake)가 작성한 코멘트 : https://stackoverflow.com/a/64961032

## 해결법 3. Custom NavType

3번째는 Navigation의 Custom NavType을 정의하는 방법입니다.

Custom Type은 공식 문서상 기준으로 [`ParcelableType`](https://developer.android.com/reference/kotlin/androidx/navigation/NavType.ParcelableType)/[`SerializableType`](https://developer.android.com/reference/kotlin/androidx/navigation/NavType.SerializableType) 지원에 대한 내용이 잘 작성되어 있습니다.

> Providing custom types : https://developer.android.com/guide/navigation/navigation-kotlin-dsl#custom-types

이번 섹션에서는 Serializable/Parcelable을 전달해 보겠습니다. 그리고, 직렬화 처리는 [Kotlin Serialization](https://github.com/Kotlin/kotlinx.serialization)을 사용합니다. 아래 모델링 한 클래스로 간단한 형태가 구현되어 있습니다.

- SampleSerializableModel : Serializable
- SampleParcelableModel : Parcelable

```kotlin
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.Serializable

@Serializable
data class SampleSerializableModel(
  val value: String
): java.io.Serializable

@Serializable
@Parcelize
data class SampleParcelableModel(
  val value: String
): Parcelable
```

그리고, Custom NavType을 작성합니다. 범용성을 위해서 Serializable/Parcelable 타입을 위한 Factory 함수도 만듭니다. 아래 함수에서는 호출 때마다 새로운 NavType을 생성해서 반환합니다.

```kotlin
import android.os.Bundle
import android.os.Parcelable
import androidx.navigation.NavType
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import java.io.Serializable

inline fun <reified T : Serializable> createSerializableNavType(
  isNullableAllowed: Boolean = false
): NavType<T> {
  return object : NavType<T>(isNullableAllowed) {
    override val name: String
      get() = "SupportSerializable"

    override fun put(bundle: Bundle, key: String, value: T) {
      bundle.putSerializable(key, value) // Bundle에 Serializable 타입으로 추가
    }

    override fun get(bundle: Bundle, key: String): T? {
      return bundle.getSerializable(key) as? T // Bundle에서 Serializable 타입으로 꺼낸다
    }

    override fun parseValue(value: String): T {
      return Json.decodeFromString(value) // String 전달된 Parsing 방법을 정의
    }
  }
}

inline fun <reified T : Parcelable> createParcelableNavType(
  isNullableAllowed: Boolean = false
): NavType<T> {
  return object : NavType<T>(isNullableAllowed) {
    override val name: String
      get() = "SupportParcelable"

    override fun put(bundle: Bundle, key: String, value: T) {
      bundle.putParcelable(key, value) // Bundle에 Parcelable 타입으로 추가
    }

    override fun get(bundle: Bundle, key: String): T? {
      return bundle.getParcelable(key) // Bundle에서 Parcelable 타입으로 꺼낸다
    }

    override fun parseValue(value: String): T {
      return Json.decodeFromString(value) // String 전달된 Parsing 방법을 정의
    }
  }
}
```

이어서 앞서 선언한 클래스 모델과 Custom NavType을 사용하여 NavGraphBuilder에 Composable을 정의합니다.

```kotlin
// Navigation 스펙대로 route 및 arguments를 정의
composable(route = "Third?key1={test_serialize}&key2={test_parcelable}",
  arguments = listOf(
    navArgument("test_serialize") {
      // Serializable NavType을 정의
      type = createSerializableNavType<SampleSerializableModel>()
    },
    navArgument("test_parcelable") {
      // Parcelable NavType을 정의
      type = createParcelableNavType<SampleParcelableModel>()
    }
  )
) { entry ->
  val arguments = requireNotNull(entry.arguments)

  // NavController#navigate로 전달된 정보와 Custom NavType으로
  val sample1 = arguments.getSerializable("test_serialize") as SampleSerializableModel
  val sample2 = arguments.getParcelable<SampleParcelableModel>("test_parcelable")!!

  logcat(tag = "logger") {
    "Third : Serializable=${sample1}, Parcelable=${sample2}"
  }
  // (예) Third : Serializable=SampleSerializableModel(value=abcd), Parcelable=SampleParcelableModel(value=efgh) 가 출력
}
```

선언된 정보를 토대로 navigate를 호출할 수 있습니다. 이때 직렬화를 도구를 사용하여 Json String으로 변경한 후 Uri 스펙에 유효하도록 [Uri.encode](https://developer.android.com/reference/android/net/Uri#encode(java.lang.String)) 함수를 사용합니다.

```kotlin
import android.net.Uri
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

val sample1 = Json.encodeToString(SampleSerializableModel("abcd"))
val sample2 = Json.encodeToString(SampleParcelableModel("efgh"))
navController.navigate(
  "Third?key1=${Uri.encode(sample1)}&key2=${Uri.encode(sample2)}"
)
```

이렇게 함으로써 Custom NavType을 사용해서 Serializable/Parcelable 형태의 데이터를 전달할 수 있습니다.

## 해결법 4. Data Layer의 Cache 정책을 사용

4번째는 전달하고자 하는 Item의 ID를 Cache 하여 저장소에서 가져오는 방법입니다.

최근 추가된 Android Develoepr 사이트에 추가된 아키텍처 가이드의 일부분으로 특정 Scope에 해당하는 데이터를 memory cache 하여 사용하도록 가이드하고 있습니다.

> Implement in-memory data caching : https://developer.android.com/jetpack/guide/data-layer#in-memory-cache

이 케이스는 Data Layer에서 내려오는 데이터일 경우에 사용하기 적절한 방법입니다.

그렇지만 항상 이 케이스가 유효하도록 대응할 수도 있지만, Data Layer이 아닌 UI/Domain Layer에서 파생된 데이터 타입일 수도 있습니다. 이 경우에는 이 해결법은 유효하지 않을 수 있습니다.

## 샘플 코드

본 글에서 언급한 코드는 아래 주소를 참고해주세요.

- http://pluu.github.io/blog/android/2022/02/04/compose-pending-argument-part-2/

## 읽으면 좋을 자료

- **Part 3 —** [**Passing multi typed of data with Jetpack Compose navigation component.**](https://zivkest.medium.com/passing-multi-typed-data-between-screens-with-jetpack-compose-navigation-component-39ccbcf901ff)
- [Safe Compose arguments: An improved way to navigate in Jetpack Compose — Part 2](https://proandroiddev.com/safe-compose-arguments-an-improved-way-to-navigate-in-jetpack-compose-part-2-218a6ae7a027)
- (일본어) [Navigation ComposeとParcelable](https://star-zero.medium.com/navigation-compose%E3%81%A8parcelable-9226d2636cdd)
