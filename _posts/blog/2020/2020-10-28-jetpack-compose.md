---
layout: post
title: "Jetpack Compose 공부 ~ 1주차"
date: 2020-10-28 22:30:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog
- Android
---

본 글은 개인적으로 Jetpack AndroidX Compose의 스터디한 내용을 정리하는 아카이브용입니다.

<!--more-->

`지극히 개인적인` 의견입니다.

- - -

테스트 전제 조건

- Android Studio 4.2 Canary 15
- Jetpack Compose 1.0.0-alpha05

- - -

실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. Composable에서 상태 감시

LiveData의 Return은 Nullable이다.

**LiveData**

```kotlin
@Composable
inline fun <T> LiveData<T>.observeAsState(): State<T?>
```

https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime-livedata/src/main/java/androidx/compose/runtime/livedata/LiveDataAdapter.kt

**StateFlow**

```kotlin
@Composable
inline fun <T> StateFlow<T>.collectAsState(
    context: CoroutineContext = EmptyCoroutineContext
): State<T> = collectAsState(value, context)
```

https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/FlowAdapter.kt

### 2. LiveData<T>.observeAsState 값 취득시 Hint로 노출되는 타입만 믿으면 안된다.

```kotlin
val list : List<T>? by viewModel.listEvent.observeAsState(null)
if (list != null) {
    list.isEmpty() // <-- 컴파일 에러
}
```

이 경우 아래와 같이 컴파일 실패가 발생

> Smart cast to 'List<ToonInfoWithFavorite>' is impossible, because 'list' is a property that has open or custom getter

Hint로는 List이지만 실제로는 Delegation + State<T?>라서, list에 접근할때 새로운 getValue 가 호출되므로 스마트 캐스팅이 안된다.

```kotlin
private class SnapshotMutableState<T>(
    value: T,
    val policy: SnapshotMutationPolicy<T>
) : StateObject, MutableState<T> {
    @Suppress("UNCHECKED_CAST")
    override var value: T
        get() = next.readable(this).value
        set(value) = next.withCurrent {
            if (!policy.equivalent(it.value, value)) {
                next.writable(this) { this.value = value }
            }
        }
}
```

https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/MutableState.kt#L293

### 3.CircularProgressIndicator

progress를 사용하는 경우, 자동 Indicator가 동작하지 않음

```kotlin
fun CircularProgressIndicator(
    @FloatRange(from = 0.0, to = 1.0) progress: Float,
    modifier: Modifier = Modifier,
    color: Color = MaterialTheme.colors.primary,
    strokeWidth: Dp = ProgressIndicatorConstants.DefaultStrokeWidth
)

fun CircularProgressIndicator(
    modifier: Modifier = Modifier,
    color: Color = MaterialTheme.colors.primary,
    strokeWidth: Dp = ProgressIndicatorConstants.DefaultStrokeWidth
)
```

### 4. LiveData나 StateFlow 사용시 데이터의 Equals 처리가 중요해진다

- 과거의 내가 문제다.
- DiffUtil과 비슷한 Content Euqlas 비교가 되는 것을 보인다.

### 5. MDC Adapter

기존 앱에서 부분 마이그레이션을 할 경우 앱의 테마 정보를 Compso로 가져올 때 사용할 필요가 있다.

- Codelab : https://developer.android.com/codelabs/jetpack-compose-migration#9
- Theme 호환용 Adapter : https://github.com/material-components/material-components-android-compose-theme-adapter

### 6. Image 로딩시 도움되는 라이브러리

- 이미지 로딩 라이브러리 : https://github.com/chrisbanes/accompanist
   - Glide / Picasso / Coil 대응
   - Glide는 아직 Maven에 없음

### 7. Composable Lifecycle

- https://developer.android.com/reference/kotlin/androidx/compose/runtime/package-summary#oncommit

### 8. Ambient

Scope 단위로 데이터 주입이 가능한 Ambient

- https://developer.android.com/reference/kotlin/androidx/compose/runtime/Ambient
- Implementing a nested screen history with Jetpack Compose
  - https://proandroiddev.com/implementing-back-navigation-with-jetpack-compose-550b544e4205


### 9. Compose Preview

느립니다.
