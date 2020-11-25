---
layout: post
title: "Jetpack Compose 공부 ~ 5주차"
date: 2020-11-25 22:50:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog

---

본 글은 개인적으로 Jetpack AndroidX Compose의 스터디한 내용을 정리하는 아카이브용입니다.

<!--more-->

`지극히 개인적인` 의견입니다.

- - -

테스트 전제 조건

- Android Studio 4.2 Canary 16
- Jetpack Compose 1.0.0-alpha07

실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. Compose 1.0.0-alpha07에서 Kotlin 1.4.20 사용시 빌드 에러가 발생함

```
IncompatibleClassChangeError: Found class org.jetbrains.kotlin.ir.declarations.IrClass, but interface was expected
```

> JVM / IR: "IncompatibleClassChangeError: Found class org.jetbrains.kotlin.ir.declarations.IrClass, but interface was expected" with Compose 
>
> https://youtrack.jetbrains.com/issue/KT-43350

해결법 : Kotlin plugin 1.4.10 사용

**Merged**

- 1506451: Support for Kotlin 1.4.20 \| https://android-review.googlesource.com/c/platform/frameworks/support/+/1506451

### 2. Drawable에 있는 이미지 로드시 실패하는 케이스

```xml
<!-- drawable/check_circle.xml -->
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item>
        <shape android:shape="oval">
            <solid android:color="#CC222222" />
        </shape>
    </item>  
  	<!-- vector Image -->
    <item android:drawable="@drawable/ic_check_white_24" /> 
</layer-list>
```

#### 테스트 1) imageResource 사용

```kotlin
Image(asset = imageResource(id = R.drawable.check_circle))
```

```
java.lang.NullPointerException: BitmapFactory.decodeResource(res, resId) must not be null
    at androidx.compose.ui.graphics.AndroidImageAssetKt.imageFromResource(AndroidImageAsset.kt:37)
    at androidx.compose.ui.res.ImageResourcesKt.imageResource(ImageResources.kt:44)
    at com.pluu.webtoon.episode.ui.EpisodeItemUiKt$EpisodeItemUiOverlayUi$1.invoke(EpisodeItemUi.kt:105)
```

#### 테스트 2) vectorResource 사용

```kotlin
Image(asset = vectorResource(id = R.drawable.check_circle))
```

```
java.lang.RuntimeException: java.lang.reflect.InvocationTargetException
    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:602)
    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:947)
    Caused by: java.lang.reflect.InvocationTargetException
    at java.lang.reflect.Method.invoke(Native Method)
    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:592)
    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:947) 
Caused by: org.xmlpull.v1.XmlPullParserException: Binary XML file line #2<VectorGraphic> tag requires viewportWidth > 0
    at androidx.compose.ui.graphics.vector.compat.XmlVectorParserKt.createVectorImageBuilder(XmlVectorParser.kt:168)
    at androidx.compose.ui.res.VectorResourcesKt.loadVectorResource(VectorResources.kt:97)
    at androidx.compose.ui.res.VectorResourcesKt.vectorResource(VectorResources.kt:49)
    at com.pluu.webtoon.episode.ui.EpisodeItemUiKt$EpisodeItemUiOverlayUi$1.invoke(EpisodeItemUi.kt:105)
    at com.pluu.webtoon.episode.ui.EpisodeItemUiKt$EpisodeItemUiOverlayUi$1.invoke(Unknown Source:13)
```

#### 쉬운 해결 방법 : `Modifier.drawBehind` 사용

```kotlin
Image(
    asset = vectorResource(id = R.drawable.ic_check_white_24),
    modifier = modifier.drawBehind {
        drawCircle(color = /** ... **/ )
    }
)
```

```kotlin
// Draw into a Canvas behind the modified content.
fun Modifier.drawBehind(onDraw: DrawScope.() -> Unit): Modifier
```

Modifier 기능을 통해서 Content의 뒷부분에 원하는 형태를 Canvas로 그릴 수 있다.

### 3. Lazy + MoreLoad + Append Item 고민

ViewModel로부터 Item이 추가되는 형태에서 무한 스크롤 처리 대응하는 것이 나을지 고민.

전체 리스트 관리를 `ContentUi` 를 호출하는 곳에서 하는 것이 편할지 고민. 데이터 관리가 한쪽으로 집중되는 형태가 되므로 remember 처리를 적절한 곳에서 하는 것이 관리하기 편할 것으로 생각됨.

```kotlin
@Composable
fun ContentUi(
  list: List<Item>
) {
  val rememberItems = remember { mutableStateListOf<Item>() }
  
  onCommit(list) {
    rememberItems.addAll(list)
  }
  
  LazyColumn(items = item, ...) {
    ...
  }
}
```

<img src="https://pbs.twimg.com/media/EnWxp8XXUAgcNw-?format=png&name=large" />

> Issues : [Jetsnack] Layer is redrawn for LayoutNode in state NeedsRelayout \| https://github.com/android/compose-samples/issues/236#issue-724049464

왠지 모를 수정 PR

> 1500671: Fix LayoutNode not marking children as not placed \| https://android-review.googlesource.com/c/platform/frameworks/support/+/1500671

### 4. Indicator 복수 컬러 처리 CircularProgressIndicator

기존 API : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-master-dev:compose/material/material/src/commonMain/kotlin/androidx/compose/material/ProgressIndicator.kt

불편함 점

- 현재 API에는 Indicator에 복수 컬러를 지원이 안함
- Circular가 한 바퀴 돌았다라는 시점 처리가 어려움

해결 방법

1. 코드를 복사
2. `currentRotationAngleOffset` 가 변경되었을 때 기존 API에 전달할 Color 값 변경하도록 대응

결과 화면

<iframe width="560" height="315" src="https://www.youtube.com/embed/EDs-0PjQN6c" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### 5. Compose + ViewModel 조합에서 Event (SingleLiveData) 처리는 귀찮을 수도 있다

```kotlin
@Composable
fun xxxx(vm : ViewModel) {
   val livedata_test by viewModel.liveDataTest.observeAsState(...)
   val flow_test by viewModel.flowTest.collectAsState(...)
}
```

- 화면 이동, 다이얼로그 등의 Event 케이스는 흔한 패턴 
- observeAsState / collectAsState 내부에는 값을 항상 가지는 별도 `remember`가 존재하므로 1번만 소비하는 Event같은 패턴은 사용하기 어려울 수 있다.

#### 내부 코드

```kotlin
@Suppress("NOTHING_TO_INLINE")
@Composable
inline fun <T : R, R> Flow<T>.collectAsState(
    initial: R,
    context: CoroutineContext = EmptyCoroutineContext
): State<R> = produceState(initial, this, context) {
    if (context == EmptyCoroutineContext) {
        collect { value = it }
    } else withContext(context) {
        collect { value = it }
    }
}

@Composable
fun <T> produceState(
    initialValue: T,
    subject1: Any?,
    subject2: Any?,
    @BuilderInference producer: suspend ProduceStateScope<T>.() -> Unit
): State<T> {
    val result = remember { mutableStateOf(initialValue) }
    LaunchedEffect(subject1, subject2) {
        ProduceStateScopeImpl(result, coroutineContext).producer()
    }
    return result
}
```

> https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/FlowAdapter.kt
>
> https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime/src/commonMain/kotlin/androidx/compose/runtime/ProduceState.kt

```kotlin
@Composable
fun <R, T : R> LiveData<T>.observeAsState(initial: R): State<R> {
    val lifecycleOwner = LifecycleOwnerAmbient.current
    val state = remember { mutableStateOf(initial) }
    onCommit(this, lifecycleOwner) {
        val observer = Observer<T> { state.value = it }
        observe(lifecycleOwner, observer)
        onDispose { removeObserver(observer) }
    }
    return state
}
```

> https://github.com/androidx/androidx/blob/androidx-master-dev/compose/runtime/runtime-livedata/src/main/java/androidx/compose/runtime/livedata/LiveDataAdapter.kt



------



### Etc. Compose Sample ~ Spotify

<img src="https://camo.githubusercontent.com/c7e337786043c5cfa920104184ac23be5d9f5878071b7f00465d0e0a5596229a/68747470733a2f2f6d656469612e67697068792e636f6d2f6d656469612f4964646c704f7064626f714a776468784d532f67697068792e676966" width="50%" />

https://github.com/Gurupreet/ComposeCookBook

### Etc. Compose Sample ~ Spotify Desktop

|                             Home                             |                       Search & Detail                        |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://camo.githubusercontent.com/b34683f08bb38ec8328a230eeec35084259c5f44873c24d2f812e481810c1396/68747470733a2f2f6d656469612e67697068792e636f6d2f6d656469612f4e4d4c674b316c4a385547744e7878336a612f67697068792e676966" /> | <img src="https://camo.githubusercontent.com/64df5f627c1bec19bf638d64676b9fdfc5049c810f6eec42ff6677c3bede3bd0/68747470733a2f2f6d656469612e67697068792e636f6d2f6d656469612f4f61517931624b6e677974773546766f53672f67697068792e676966" /> |

https://github.com/Gurupreet/ComposeSpotifyDesktop

### Etc.

- Migrating Your Design System to Jetpack Compose : https://speakerdeck.com/ditn/migrating-your-design-system-to-jetpack-compose