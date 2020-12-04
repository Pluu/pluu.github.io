---
layout: post
title: "Jetpack Compose 공부 ~ 6주차"
date: 2020-12-03 21:50:00 +09:00
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

### 1. compose alpha08

> https://developer.android.com/jetpack/androidx/versions/all-channel#december_2_2020

Support Kotlin 1.4.20

#### Library

- androidx.ui:ui-tooling → androidx.compose.ui:ui-tooling

Sample

> https://github.com/android/compose-samples/pull/294

### 2. Layout Inspector

#### Layout Inspector 사용

AndroidComposeView 로 잡힙

> https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/compose/ui/ui/src/androidMain/kotlin/androidx/compose/ui/platform/AndroidComposeView.kt

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1203-jetpack-compose/layout-inspector.png" }}" />

#### 2020.11.29 에는 Layout Inspector는 동작하지 않음

해결되는 것으로 보이는 AOSP의 PR

> 1478828: Add Inspector Info to Modifier.clickable \| https://android-review.googlesource.com/c/platform/frameworks/support/+/1478828

#### Inspector 내부 정의

```kotlin
/**
 * Declare a just-in-time composition of a [Modifier] that will be composed for each element it
 * modifies. [composed] may be used to implement **stateful modifiers** that have
 * instance-specific state for each modified element, allowing the same [Modifier] instance to be
 * safely reused for multiple elements while maintaining element-specific state.
 *
 * If [inspectorInfo] is specified this modifier will be visible to tools during development.
 * Specify the name and arguments of the original modifier.
 *
 * Example usage:
 * @sample androidx.compose.ui.samples.InspectorInfoInComposedModifierSample
 * @sample androidx.compose.ui.samples.InspectorInfoInComposedModifierWithArgumentsSample
 *
 * [materialize] must be called to create instance-specific modifiers if you are directly
 * applying a [Modifier] to an element tree node.
 */
fun Modifier.composed(
    inspectorInfo: InspectorInfo.() -> Unit = NoInspectorInfo,
    factory: @Composable Modifier.() -> Modifier
): Modifier = this.then(ComposedModifier(inspectorInfo, factory))
```

> https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/compose/ui/ui/src/commonMain/kotlin/androidx/compose/ui/ComposedModifier.kt#42

#### Inspector clickable Sample

```kotlin
@Composable
fun Modifier.clickable(
   ...
) = composed(
   factory = { ... },
   inspectorInfo = debugInspectorInfo {
        name = "clickable"
        properties["enabled"] = enabled
        properties["onClickLabel"] = onClickLabel
        properties["onClick"] = onClick
        properties["onDoubleClick"] = onDoubleClick
        properties["onLongClick"] = onLongClick
        properties["onLongClickLabel"] = onLongClickLabel
        properties["indication"] = indication
        properties["interactionState"] = interactionState
    }
)
```

> 1478828: Add Inspector Info to Modifier.clickable \| https://android-review.googlesource.com/c/platform/frameworks/support/+/1478828

### Etc. Article

- Fully cross-platform Kotlin applications (almost)
  - https://proandroiddev.com/fully-cross-platform-kotlin-applications-almost-29c7054f8f28
  - 승욱님이 작업하시는 아키텍쳐의 그림과 비슷해보임

- Jetpack Compose Effect Handlers
  - https://jorgecastillo.dev/jetpack-compose-effect-handlers

