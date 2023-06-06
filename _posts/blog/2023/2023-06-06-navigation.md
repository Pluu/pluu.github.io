---
layout: post
title: "[메모] Navigation 2.6.0부터의 변화 ~ Serializable/Parcelable 데이터 전달"
date: 2023-06-06 16:30:00 +09:00
tag: [Android, AndroidX, Navigation, Compose]
categories:
- blog
- Android
---

<!--more-->

------

사전 조건

- AndroidX Navigation 2.6.0이상

------

Navigation에서 Serializable/Parcelable 데이터 전달은 매우 귀찮은 일이다. 이전 블로그 2개를 먼저 읽어보면 도움이 된다.

> Navigating with Compose ~ Serializable/Parcelable 데이터 전달
>
> - http://pluu.github.io/blog/android/2022/02/03/compose-pending-argument-part-1/
> - http://pluu.github.io/blog/android/2022/02/04/compose-pending-argument-part-2/

------

AndroidX **Navigation 2.6.0 alpha01**부터 NavBackStackEntry의 `Argument가 불변으로 변경`되었다.

Serializable/Parcelable 전달로 회유책으로 사용하던 NavController의 backQueue에 담긴 NavBackStackEntry를 가져와서 데이터 전달하는 방법은 더 이상 사용이 불가능하다.

> Added new NavDestination extension function to parse dynamic labels with arguments in the form of android:label="{arg}" into String. Supports ReferenceType arguments by parsing R.string values into their String values. 
>
> https://developer.android.com/jetpack/androidx/releases/navigation?hl=en#2.6.0-alpha01

## DeepLink 해결법

아직 Destination ID 기반이 아니라면 Navigation은 제약이 크다. 결국 DeepLink 지원을 필수로 생각하는 AndroidX navigation이므로 그 스펙을 맞추는 방법뿐이다. 이전 블로그 글에서 작성한 대로 Custom NavType이다.

> - 샘플 앱에 적용 : https://github.com/Pluu/WebToon/commit/0d807cf4961d152611fc3430fee92f0e42b91097
> - AndroidX 샘플 모습 : https://github.com/androidx/androidx/blob/androidx-main/navigation/navigation-compose/samples/src/main/java/androidx/navigation/compose/samples/NavigationSamples.kt#L304-L326

적용 방법은 아래의 순서로 진행하면 된다.

1. Custom NavType 정의
2. Compose NavGraphBuilder로 argument에 navArgument API를 사용하여 Custom NavType 적용
3. 전달하려는 아이템의 직렬화/역직렬화 처리

```kotlin
// Custom Serializable Type
class SerializableType<T : java.io.Serializable>(
  type: Class<T>,
  private val parser: (String) -> T
) : NavType.SerializableType<T>(type) {
  override fun parseValue(value: String): T {
    return parser(value)
  }
}

// Use Composable 
composable(
  route = Screen.Episode.route + "/{${/** Argument Key */}}",
  arguments = listOf(
    navArgument(/** Argument Key */) {
      type = SerializableType(
        type = ToonInfoWithFavorite::class.java,
        parser = /** 역직렬화 */
      )
    },
    ...
  )
) { entry ->
  // Read, Bundle data
  val arguments = requireNotNull(entry.arguments)
  val toon = arguments.getSerializable(/** Argument Key */) as ToonInfoWithFavorite
  ...
}

// Use navigate
val toonItem: String = /** 직렬화 */
navController.navigate("${Screen.Episode.route}/${toonItem}")
```
