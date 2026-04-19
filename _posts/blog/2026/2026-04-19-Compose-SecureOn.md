---
layout: post
title: "화면 캡처 및 녹화 방지를 위한 커스텀 Modifier.secureOn 구현하기"
date: 2026-04-19 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

Jetpack Compose에서 특정 화면의 보안을 강화하기 위해 화면 캡처 및 녹화를 방지하는 secureOn 커스텀 Modifier를 만드는 방법을 소개합니다.

<!--more-->

## 동작 모습

Modifier.secureOn 적용

{% include youtube.html id="y2h7ZRGOkrk" %}

미적용

{% include youtube.html id="75fLQ4donuQ" %}

## Jetpack Compose에서 화면 캡처 방지하기: Modifier.secureOn

Android 앱을 개발하다 보면 결제 화면, 개인정보 입력창 등 보안이 중요한 페이지에서 사용자의 화면 캡처나 녹화를 제한해야 하는 경우가 있습니다. 기본적으로 Android에서는 Window에 WindowManager.LayoutParams.FLAG_SECURE 플래그를 설정하여 이를 구현합니다.

이번 글에서는 Compose의 Modifier.Node를 사용하여, 선언적으로 화면 보안을 활성화할 수 있는 secureOn Modifier를 구현해 보겠습니다.

구현 코드

```kotlin
fun Modifier.secureOn(): Modifier = this then SecureOnElement

private data object SecureOnElement : ModifierNodeElement<SecureOnNode>() {
   override fun create(): SecureOnNode = SecureOnNode()

   override fun update(node: SecureOnNode) {}

   override fun InspectorInfo.inspectableProperties() {
      name = "secureOn"
   }
}

private class SecureOnNode : Modifier.Node(), CompositionLocalConsumerModifierNode {

   private fun findWindow(): Window? {
      return currentValueOf(LocalContext).findWindow()
   }

   override fun onAttach() {
      findWindow()?.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
   }

   override fun onDetach() {
      findWindow()?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
   }

   private tailrec fun Context.findWindow(): Window? =
      when (this) {
         is Activity -> window
         is ContextWrapper -> baseContext.findWindow()
         else -> null
      }
}

@Preview(showBackground = true)
@Composable
fun SecureOnPreview() {
   ComposeSamplesTheme {
      Text(
         text = "SecureOn",
         modifier = Modifier
            .secureOn()
            .fillMaxSize()
            .background(Color(0xFFC8E6C9))
            .wrapContentSize(Alignment.Center),
         fontSize = 32.sp
      )
   }
}
```

## 주요 내용 설명

### Modifier.Node와 ModifierNodeElement

Modifier.compose 방식보다 성능 면에서 유리한 Modifier.Node를 사용했습니다. `SecureOnElement`는 Modifier의 데이터를 정의하고, 실제 로직이 담긴 `SecureOnNode`를 생성하는 역할을 합니다

### CompositionLocalConsumerModifierNode

Modifier 노드 내부에서 LocalContext와 같은 CompositionLocal 데이터에 접근하기 위해 CompositionLocalConsumerModifierNode 인터페이스를 구현합니다. 이를 통해 currentValueOf(LocalContext)로 현재 Context를 안전하게 가져올 수 있습니다.

> - [커스터 Modifier 만들기](https://developer.android.com/develop/ui/compose/custom-modifiers)
> - [CompositionLocalConsumerModifierNode](https://developer.android.com/reference/kotlin/androidx/compose/ui/node/CompositionLocalConsumerModifierNode)

### 생명 주기 관리 (onAttach & onDetach)

- onAttach : Modifier가 적용된 Composable Tree에 붙을 때 호출됩니다. 이때 FLAG_SECURE를 추가하여 화면 캡처를 차단합니다.
- onDetach : Composable이 제거될 때 호출됩니다. 설정했던 Flag를 제거하여 다른 화면으로 이동했을 때 영향을 줄지 않도록 합니다.

------

### 사용 시 주의사항

`FLAG_SECURE`는 Window 단위로 동작합니다. 따라서 특정 Composable에만 Modifier를 적용하더라도, 해당 Composable이 속한 화면 전체가 캡처 방지 대상이 됩니다. 
