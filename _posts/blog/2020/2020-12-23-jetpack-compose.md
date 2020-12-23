---
layout: post
title: "Jetpack Compose 공부 ~ 7주차"
date: 2020-12-23 21:45:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog

---

본 글은 개인적으로 Jetpack AndroidX Compose의 스터디한 내용을 정리하는 아카이브용입니다.

<!--more-->

`지극히 개인적인` 의견입니다.

- - -

테스트 전제 조건

- Android Studio Arctic Fox \| 2020.3.1 Canary 3
- Jetpack Compose 1.0.0-alpha08

실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. compose alpha09

> https://developer.android.com/jetpack/androidx/versions/all-channel#december_16_2020

Transition V2

- https://android-review.googlesource.com/c/platform/frameworks/support/+/1516022

Deprecated : LazyColumnFor, LazyRowFor, LazyColumnForIndexed and LazyRowForIndexed → LazyColumn, LazyRow

- https://android-review.googlesource.com/#/q/I5b48c8a3b1fef2f603ab69ded1d19709aa9f87fb

Added, LazyVerticalGrid

- https://android-review.googlesource.com/c/platform/frameworks/support/+/1480539

Added, androidx.compose.material:material-ripple

Renamed *Constants objects such as ButtonConstants to end with Defaults instead, such as ButtonDefaults. Also removes unnecessary default prefixes from properties in these new objects

- https://android-review.googlesource.com/c/platform/frameworks/support/+/1515511

### 2. Activity/Fragment에서의 Compose 객체에 생명주기 연결 흐름

```kotlin
fun ComponentActivity.setContent(
    // Note: Recomposer.current() is the default here since all Activity view trees are hosted
    // on the main thread.
    parent: CompositionReference = Recomposer.current(),
    content: @Composable () -> Unit
): Composition {
    GlobalSnapshotManager.ensureStarted()
    val composeView: AndroidComposeView = window.decorView
        .findViewById<ViewGroup>(android.R.id.content)
        .getChildAt(0) as? AndroidComposeView
        ?: AndroidComposeView(this).also {
            setContentView(it.view, DefaultLayoutParams)
        }
    return doSetContent(composeView, parent, content)
}

@Deprecated("Use ComposeView or AbstractComposeView instead.")
fun ViewGroup.setContent(
    parent: CompositionReference = Recomposer.current(),
    content: @Composable () -> Unit
): Composition {
    GlobalSnapshotManager.ensureStarted()
    val composeView =
        if (childCount > 0) {
            getChildAt(0) as? AndroidComposeView
        } else {
            removeAllViews(); null
        } ?: AndroidComposeView(context).also { addView(it.view, DefaultLayoutParams) }
    return doSetContent(composeView, parent, content)
}
```

> https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui/src/androidMain/kotlin/androidx/compose/ui/platform/Wrapper.kt#L130

```kotlin
internal class AndroidComposeView(context: Context) :
    ViewGroup(context), Owner, ViewRootForTest {
    ...
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        ...
        if (viewTreeOwners == null) {
            val lifecycleOwner = ViewTreeLifecycleOwner.get(this) ?: throw IllegalStateException(
                "Composed into the View which doesn't propagate ViewTreeLifecycleOwner!"
            )
            val viewModelStoreOwner =
                ViewTreeViewModelStoreOwner.get(this) ?: throw IllegalStateException(
                    "Composed into the View which doesn't propagate ViewTreeViewModelStoreOwner!"
                )
            val savedStateRegistryOwner =
                ViewTreeSavedStateRegistryOwner.get(this) ?: throw IllegalStateException(
                    "Composed into the View which doesn't propagate" +
                        "ViewTreeSavedStateRegistryOwner!"
                )
            val viewTreeOwners = ViewTreeOwners(
                lifecycleOwner = lifecycleOwner,
                viewModelStoreOwner = viewModelStoreOwner,
                savedStateRegistryOwner = savedStateRegistryOwner
            )
            this.viewTreeOwners = viewTreeOwners
            onViewTreeOwnersAvailable?.invoke(viewTreeOwners)
            onViewTreeOwnersAvailable = null
        }
        viewTreeObserver.addOnGlobalLayoutListener(globalLayoutListener)
        viewTreeObserver.addOnScrollChangedListener(scrollChangedListener)
    }      
}
```

> https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui/src/androidMain/kotlin/androidx/compose/ui/platform/AndroidComposeView.kt#L599

```kotlin
private class WrappedComposition(
    val owner: AndroidComposeView,
    val original: Composition
) : Composition, LifecycleEventObserver {

    private var disposed = false
    private var addedToLifecycle: Lifecycle? = null
    private var lastContent: @Composable () -> Unit = emptyContent()

    @OptIn(InternalComposeApi::class)
    override fun setContent(content: @Composable () -> Unit) {
        owner.setOnViewTreeOwnersAvailable {
            if (!disposed) {
                val lifecycle = it.lifecycleOwner.lifecycle
                lastContent = content
                if (addedToLifecycle == null) {
                    addedToLifecycle = lifecycle
                    // this will call ON_CREATE synchronously if we already created
                    lifecycle.addObserver(this)
                } else if (lifecycle.currentState.isAtLeast(Lifecycle.State.CREATED)) {
                    original.setContent {

                        @Suppress("UNCHECKED_CAST")
                        val inspectionTable =
                            owner.getTag(R.id.inspection_slot_table_set) as?
                                MutableSet<CompositionData>
                                ?: (owner.parent as? View)?.getTag(R.id.inspection_slot_table_set)
                                    as? MutableSet<CompositionData>
                        if (inspectionTable != null) {
                            @OptIn(InternalComposeApi::class)
                            inspectionTable.add(currentComposer.compositionData)
                            currentComposer.collectParameterInformation()
                        }

                        LaunchedEffect(owner) { owner.keyboardVisibilityEventLoop() }
                        LaunchedEffect(owner) { owner.boundsUpdatesEventLoop() }

                        Providers(InspectionTables provides inspectionTable) {
                            ProvideAndroidAmbients(owner, content)
                        }
                    }
                }
            }
        }
    }

    override fun dispose() {
        if (!disposed) {
            disposed = true
            owner.view.setTag(R.id.wrapped_composition_tag, null)
            addedToLifecycle?.removeObserver(this)
        }
        original.dispose()
    }

    override fun hasInvalidations() = original.hasInvalidations()

    override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
        if (event == Lifecycle.Event.ON_DESTROY) {
            dispose() // <-- DESTROY 시점에 dispose()
        } else if (event == Lifecycle.Event.ON_CREATE) {
            if (!disposed) {
                setContent(lastContent)
            }
        }
    }
}
```

> https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui/src/androidMain/kotlin/androidx/compose/ui/platform/Wrapper.kt#L223

### 3. Sub-Compose 생성 흐름

Public UI Foundation (Scaffold, LazyList ... )

↓

SubcomposeLayout

↓

SubcomposeLayoutState#subcompose

```kotlin
private fun subcompose(node: LayoutNode, nodeState: NodeState) {
    node.ignoreModelReads {
        val content = nodeState.content
        nodeState.composition = subcomposeInto(
            container = node,
            parent = compositionRef ?: error("parent composition reference not set"),
            // Do not optimize this by passing nodeState.content directly; the additional
            // composable function call from the lambda expression affects the scope of
            // recomposition and recomposition of siblings.
            composable = { content() }
        )
    }
}
```

↓

```kotlin
/**
 * @param parent An optional reference to the parent composition.
 * @param composerFactory A function to create a composer object, for use during composition
 * @param onDispose A callback to be triggered when [dispose] is called.
 */
private class CompositionImpl(
    private val parent: CompositionReference,
    composerFactory: (CompositionReference) -> Composer<*>,
    private val onDispose: () -> Unit
) : Composition {
    private val composer: Composer<*> = composerFactory(parent).also {
        parent.registerComposer(it)
    }

    /**
     * Return true if this is a root (non-sub-) composition.
     */
    val isRoot: Boolean = parent is Recomposer

    private var disposed = false

    var composable: @Composable () -> Unit = emptyContent()

    override fun setContent(content: @Composable () -> Unit) {
        check(!disposed) { "The composition is disposed" }
        this.composable = content
        parent.composeInitial(composer, composable)
    }

    @OptIn(ExperimentalComposeApi::class)
    override fun dispose() {
        if (!disposed) {
            disposed = true
            composable = emptyContent()
            composer.dispose()
            onDispose()
        }
    }

    override fun hasInvalidations() = composer.hasInvalidations()
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1223-jetpack-compose/setContent.png" }}" />

↓

Composer#composeInitial

↓

```kotlin
internal fun invokeComposable(composer: Composer<*>, composable: @Composable () -> Unit) {
    @Suppress("UNCHECKED_CAST")
    val realFn = composable as Function2<Composer<*>, Int, Unit>
    realFn(composer, 1)
}
```

---

## Sample Code

StaggeredVerticalGrid

- https://github.com/android/compose-samples/blob/main/Owl/app/src/main/java/com/example/owl/ui/courses/FeaturedCourses.kt#L171

## Article

### [Compose Snippet] Parallax Scroll 🏙 

- https://medium.com/@theRoshogulla/compose-snippet-parallax-scroll-3bd987a5f8f3

Reference

- https://developer.android.com/reference/kotlin/androidx/compose/foundation/package-summary#horizontalscroll
- 콘텐츠 너비가 최대 제약 조건에서 허용하는 것보다 큰 경우 가로로 스크롤 할 수 있도록 요소를 수정

```kotlin
import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.ui.graphics.HorizontalGradient

val scrollState = rememberScrollState()
val gradient = HorizontalGradient(
    listOf(Color.Red, Color.Blue, Color.Green), 0.0f, 10000.0f, TileMode.Repeated
)
Box(
    Modifier
        .horizontalScroll(scrollState)
        .size(width = 10000.dp, height = 200.dp)
        .background(brush = gradient)
)
```

> 원본 소스 : https://developer.android.com/reference/kotlin/androidx/compose/foundation/package-summary#horizontalscroll

### [Android Jetpack Compose Flappy Bird]

- https://elye-project.medium.com/android-jetpack-compose-flappy-bird-9ac4b1d223df

<img src="https://miro.medium.com/max/640/1*tqyJqY5kq1BSeaQ0je5Dgw.gif" />

- 원본 소스 : https://github.com/elye/demo_android_jetpack_compose_flappy_bird
