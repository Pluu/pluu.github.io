---
layout: post
title: "Navigating with Compose ~ Serializable/Parcelable 데이터 전달 ~ 1부"
date: 2022-02-03 23:00:00 +09:00
tag: [Android, AndroidX, Navigation, Compose]
categories:
- blog
- Android
---

본 글은 AndroidX Jetpack Navigation x Compose 사용 시 데이터 전달에 대해 살펴보는 글입니다.

<!--more-->

1부에서는 데이터 전달의 기본 지식을 살펴보고, 2부에서는 Serializable/Parcelable 전달의 해결법을 다룹니다.

- 1부 : <-- 현재 글
- [2부 링크]({{ site.url }}/blog/android/2022/02/04/compose-pending-argument-part-2/)

------

**사전 조건**

- navigation-compose : 2.5.0-alpha01
- [Navigating with Compose](https://developer.android.com/jetpack/compose/navigation)의 내용은 다루지 않습니다

------

결론부터 말하면, 여러분은 Navigation과 Compose를 사용할 시 `Serializable/Parcelable` 데이터 전달의 대안을 찾으셔야 합니다.

------

Google에서 Compose 발표 이후, 최근 Android 개발 시 Compose를 채택하는 사례가 늘어가고 있습니다. 기존에 운영하는 프로젝트와의 호환성을 위해서 View 시스템과 결합을 위한 도구들도 다양하게 있습니다.

- AbstractComposeView / ComposeView : Custom View에서 Compose 사용
- Compose Theme Adapter
  - [AppCompat Compose Theme Adapter](https://google.github.io/accompanist/appcompat-theme/)
  - [MDC-Android Compose Theme Adapter](https://material-components.github.io/material-components-android-compose-theme-adapter/)

> 기존 앱에 Compose 채택 : https://developer.android.com/jetpack/compose/interop

## [서론] 데이터 전달

Activity/Fragment 내부에서 단일 Compose를 사용하는 경우, 각 케이스에 데이터 전달을 어떻게 할지 생각해 봅시다.

### Case 1. AndroidX의 ViewModel 생성자

지금까지 AndroidX의 ViewModel 생성자에 다양한 방법으로 데이터를 전달해서 사용했습니다. 이 섹션에서는 Compose는 우선 접어두고, 일반적인 방법은 다음과 같은 2가지 형태입니다.

1. **SavedStateHandle**에 데이터가 포함되도록 처리한 후 **Get**해서 사용
   - Activity/Fragment 생성시에 넘긴 `Bundle` 데이터를 ViewModel에서 직접 받을 경우에 사용합니다.
   - SavedStateHandle는 ViewModelProvider.Factory를 통해서 ViewModel 생성시에 전달됩니다.
2. 명시적으로 **특정 타입**으로 생성자 정의하여 사용
   - [SavedStateHandle#get](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle#get(java.lang.String))을 사용할 경우 nullable이므로 별도 체크가 필요합니다.
   - 별도의 **AssistedFactory** 혹은 수동으로 ViewModel을 사용하여 생성할 수 있습니다.

위처럼 간단하게 ViewModel 생성시에 데이터 전달을 언급했지만, 일반적으로 화면 이동 간에 전달된 데이터를 처음 수신하는 곳은 Activity/Fragment과 같은 View입니다. 결국 ViewModel 생성시에는 View의 도움이 암묵적으로 필요합니다.

> viewModels/activityViewModels ktx도 최종적으로 Activity/Fragment 내부의 객체를 사용합니다.

### Case 2. Composable 함수

[Composable](https://developer.android.com/reference/kotlin/androidx/compose/runtime/Composable) 함수는 Compose를 위한 블록이지만, 기본적으로 함수입니다. 

```kotlin
@Composable
fun SampleUi(
  viewModel: SampleViewModel,
  sampleInt: Int,
  sampleString: String,
  ...
)
```

함수이므로 이전 ViewModel 생성자보다 쉽게 데이터 전달을 할 수 있습니다. ViewModel을 전달하고 싶은 경우에는 Activity/Fragment에서 생성한 후에 전달하면 됩니다.

## [본론] Navigation에서 Compose 사용시의 데이터 전달

먼저 본 섹션에서는 Single Activity 사용을 전제로 합니다. 이 경우의 화면 전이는 **Navigation**을 사용하여 원하는 화면을 노출합니다. 이때 화면 전이 시 데이터 전달에 관한 API를 사용할 수 있습니다.

> Navigate with arguments : https://developer.android.com/jetpack/compose/navigation#nav-with-args

### Primitive Type 데이터 전달

Navigation/Compose를 사용하여 아래처럼 First/Second 화면을 가지는 Navigation Graph를 정의할 수 있습니다. 그리고 Second는 **test**라는 Argument를 전달할 수 있는 샘플 코드입니다. First 화면에서는 Second로 "abcd"를 전달하는 코드입니다.

```kotlin
@Composable
fun SampleNavGraph(
  navController: NavHostController
  // ...
) {
  // ...
  NavHost(
    navController = navController,
    startDestination = "First"
  ) {
    composable(route = "First") { entry ->
      // ...
      navController.navigate("Second?test=abcd")
    }
    composable(route = "Second?test={test}",
      arguments = listOf(
        navArgument("test") {
          type = NavType.StringType
        }
      )
    ) { entry ->
      // ...
      SampleUi()
    }
  }
}


@Composable
fun SampleUi(
  viewModel: SampleViewModel = hiltViewModel()
) {
  // ...
}
```

Second 화면의 UI를 담당하는 `SampleUi` Composable 함수에서 `hiltViewModel`를 통하여 SavedStateHandle에 데이터를 전달할 수 있습니다. 최종적으로 ViewModel에 전달됩니다.

```kotlin
@HiltViewModel
class SampleViewModel @Inject constructor(
  handle: SavedStateHandle
) : ViewModel() {
  // ...
}
```

> Hilt and Navigation : https://developer.android.com/jetpack/compose/libraries#hilt-navigation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0203-compose/001.png" }}" /> 

> 테스트 결과 : 샘플로 전달한 키(test)에 대한 값(abcd)이 올바르게 전달된 것을 확인할 수 있습니다.

### 현실적으로 사용할 수 없는 Serializable/Parcelable

[NavType](https://developer.android.com/reference/androidx/navigation/NavType)에는 기본 타입 외에 Serializable/Parcelable도 정의되어 있습니다. 그러나 해당 타입은 사용할 수 없습니다.

```kotlin
composable(route = /** Route */,
  arguments = listOf(
    navArgument(/** Name */) {
      type = NavType.SerializableType(Sample::class.java)
    }
  )
) {
  // ...
}
```

동일하게 사용한다면, 값을 parse 하는 SerializableType#parseValue 함수 내부에서 **UnsupportedOperationException** 에러로 앱이 종료됩니다. Parcelable도 동일합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0203-compose/002.png" }}" /> 

> NavType.SerializableType#parseValue : https://developer.android.com/reference/androidx/navigation/NavType.SerializableType#parseValue(kotlin.String)

#### Navigate

화면 전이에 데이터 전달을 잘못했다고 생각할 수 있습니다. 먼저 화면 전이 API를 살펴보겠습니다. Navigation의 화면 전이는 `NavController#navigate`를 사용합니다. public으로 공개된 것은 아래와 같이 같습니다.

```kotlin
public open fun navigate(@IdRes Int)
public open fun navigate(@IdRes Int, Bundle?)
public open fun navigate(@IdRes Int, Bundle?, NavOptions?)
public open fun navigate(@IdRes Int, Bundle?, NavOptions?, Navigator.Extras?)
public open fun navigate(Uri)
public open fun navigate(Uri, NavOptions?)
public open fun navigate(Uri, NavOptions?, Navigator.Extras?)
public open fun navigate(NavDeepLinkRequest)
public open fun navigate(NavDeepLinkRequest, NavOptions?)
public open fun navigate(NavDeepLinkRequest, NavOptions?, Navigator.Extras?)
public open fun navigate(NavDirections)
public open fun navigate(NavDirections, NavOptions?)
public open fun navigate(NavDirections, Navigator.Extras)
public open fun navigate(String, NavOptionsBuilder.() -> Unit)
public open fun navigate(String, NavOptions?, Navigator.Extras?)
```

타입 조합에 이상한 점을 느끼셨나요?

지금까지 Serializable/Parcelable 타입의 데이터 전달은 `Bundle` 객체를 사용했습니다. 그러나 `NavController#navigate` API에 Bundle을 다루는 것은 **navigate(@IdRes Int)** 계열의 Resource ID를 가지는 API뿐입니다. 실제 해당 케이스는 XML로 Navigation Graph를 정의한 경우에만 사용 가능해서 Kotlin 코드로 작성한다면 사용 가능한 API는 현재 `2.5.0-alpha01` 버전에는 없습니다.

## [기본편] Navigation API를 사용하여 데이터 전달

### 기본 흐름

지금부터는 Composable 함수/ViewModel에 데이터를 전달하는 흐름을 살펴보도록 하겠습니다. 아래 코드는 본론에서 언급한 코드입니다.

```kotlin
@Composable
fun SampleNavGraph(
  navController: NavHostController
) {
  // ...
  NavHost(
    navController = navController,
    startDestination = "First"
  ) {
    composable(route = "First") { entry ->
      // ...
      navController.navigate("Second?test=abcd")
    }
    composable(route = "Second?test={test}",
      arguments = listOf(
        navArgument("test") {
          type = NavType.StringType
        }
      )
    ) { entry ->
      // ...
    }
  }
}
```

앞서 `hiltViewModel`를 통해서 생성된 ViewModel의 SavedStateHandle 값을 확인했습니다. 이번에는 [NavBackStackEntry](https://developer.android.com/reference/androidx/navigation/NavBackStackEntry)입니다.

### NavBackStackEntry의 Argument를 통해 전달

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0203-compose/003.png" }}" /> 

composable KTX의 람다로 전달되는 **NavBackStackEntry** 내부에 Bundle 형태로 arguments 프로퍼티에 테스트로 전달한 값이 존재합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0203-compose/004.png" }}" /> 

arguments 프로퍼티는 Bundle 타입이므로 Key/Type을 알고 있다면 이전처럼 원하는 값을 가져올 수 있습니다. 

> Navigate with arguments : https://developer.android.com/jetpack/compose/navigation#nav-with-args

### hiltViewModel를 통해 전달

hiltViewModel의 코드를 확인해 봅니다

```kotlin
@Composable
inline fun <reified VM : ViewModel> hiltViewModel(
  viewModelStoreOwner: ViewModelStoreOwner = checkNotNull(LocalViewModelStoreOwner.current) {
      "No ViewModelStoreOwner was provided via LocalViewModelStoreOwner"
  }
): VM {
  val factory = createHiltViewModelFactory(viewModelStoreOwner)
  return viewModel(viewModelStoreOwner, factory = factory)
}

@Composable
@PublishedApi
internal fun createHiltViewModelFactory(
  viewModelStoreOwner: ViewModelStoreOwner
): ViewModelProvider.Factory? = if (viewModelStoreOwner is NavBackStackEntry) {
  HiltViewModelFactory(
    context = LocalContext.current,
    navBackStackEntry = viewModelStoreOwner
  )
} else {
  // Use the default factory provided by the ViewModelStoreOwner
  // and assume it is an @AndroidEntryPoint annotated fragment or activity
  null
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/hilt/hilt-navigation-compose/src/main/java/androidx/hilt/navigation/compose/HiltViewModel.kt

다른 viewModel ktx와 비슷하지만, LocalViewModelStoreOwner와 ViewModelStoreOwner가 NavBackStackEntry 일 경우에 

[HiltViewModelFactory](https://developer.android.com/reference/androidx/hilt/navigation/HiltViewModelFactory)라는 별도의 ViewModelProvider.Factory를 사용하여 ViewModel을 생성합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0203-compose/005.png" }}" /> 

Navigation/Compose를 사용하면 [LocalViewModelStoreOwner](https://developer.android.com/reference/kotlin/androidx/lifecycle/viewmodel/compose/LocalViewModelStoreOwner)의 값은 실제로 [NavBackStackEntry](https://developer.android.com/reference/kotlin/androidx/navigation/NavBackStackEntry)입니다. NavBackStackEntry가 가리키는 화면은 `NavDestination`에 정의되어 있지만, 나머지는 Android의 화면 단위라는 개념에 필요한 인터페이스를 가지고 있습니다.

```kotlin
@JvmName("create")
public fun HiltViewModelFactory(
  context: Context,
  navBackStackEntry: NavBackStackEntry
): ViewModelProvider.Factory {
  val activity = context.let {
    var ctx = it
    while (ctx is ContextWrapper) {
      if (ctx is Activity) {
        return@let ctx
      }
      ctx = ctx.baseContext
    }
    throw IllegalStateException(
        "Expected an activity context for creating a HiltViewModelFactory for a " +
        "NavBackStackEntry but instead found: $ctx"
    )
  }
  return HiltViewModelFactory.createInternal(
    activity,
    navBackStackEntry,
    navBackStackEntry.arguments,
    navBackStackEntry.defaultViewModelProviderFactory,
  )
}
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/hilt/hilt-navigation/src/main/java/androidx/hilt/navigation/HiltNavBackStackEntry.kt

HiltViewModelFactory 내부는 특별한 코드는 없으며 **HiltViewModelFactory.createInternal** 함수 호출하고 있으며, 이 함수는 AndroidX가 아닌 Dagger의 코드입니다.

```java
public final class HiltViewModelFactory implements ViewModelProvider.Factory {

  public static ViewModelProvider.Factory createInternal(
      @NonNull Activity activity,
      @NonNull SavedStateRegistryOwner owner,
      @Nullable Bundle defaultArgs,
      @NonNull ViewModelProvider.Factory delegateFactory) {
    ActivityCreatorEntryPoint entryPoint =
        EntryPoints.get(activity, ActivityCreatorEntryPoint.class);
    return new HiltViewModelFactory(
        owner,
        defaultArgs,
        entryPoint.getViewModelKeys(),
        delegateFactory,
        entryPoint.getViewModelComponentBuilder()
    );
  }

  // ...
  
  public HiltViewModelFactory(
      @NonNull SavedStateRegistryOwner owner,
      @Nullable Bundle defaultArgs,
      @NonNull Set<String> hiltViewModelKeys,
      @NonNull ViewModelProvider.Factory delegateFactory,
      @NonNull ViewModelComponentBuilder viewModelComponentBuilder) {
    this.hiltViewModelKeys = hiltViewModelKeys;
    this.delegateFactory = delegateFactory;
    this.hiltViewModelFactory =
        new AbstractSavedStateViewModelFactory(owner, defaultArgs) {
          // ...
          }
        };
  }
}
```

> 소스 출처 : https://github.com/google/dagger/blob/master/java/dagger/hilt/android/internal/lifecycle/HiltViewModelFactory.java

AndroidX HiltViewModelFactory에서 넘겨진 파라미터가 Dagger의 HiltViewModelFactory에서 어떤 역할을 하는지 정리했습니다.

| AndroidX HiltViewModelFactory                     | Dagger HiltViewModelFactory               |
| ------------------------------------------------- | ----------------------------------------- |
| activity                                          | Hilt관련 EntryPoint 취득용                |
| navBackStackEntry                                 | SavedStateRegistryOwner owner             |
| navBackStackEntry.arguments                       | Bundle defaultArgs                        |
| navBackStackEntry.defaultViewModelProviderFactory | ViewModelProvider.Factory delegateFactory |

Dagger의 HiltViewModelFactory에서 **AbstractSavedStateViewModelFactory**를 사용하여 사용자가 요청한 ViewModel을 생성합니다. 

최종적으로 ViewModel의 `SavedStateHandle은 navBackStackEntry.arguments`를 통해서 생성됩니다.

## 기본 지식 결론

Navigation과 Compose를 사용할 경우, `NavBackStackEntry.arguments`가 데이터 전달의 중요 키포인트입니다. 이곳에 데이터를 전달할 수 있다면, Compose와 ViewModel 두 곳 모두에서 데이터를 GET 할 수 있습니다.

2부에서는 1부의 내용을 기반으로 Serializable/Parcelable를 다뤄보겠습니다.
