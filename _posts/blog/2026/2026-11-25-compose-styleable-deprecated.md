---
layout: post
title: "[메모] Compose Foundation Modifier.styleable() Deprecated 및 styleResolver 전환"
date: 2026-11-25 23:00:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog
- Android
---

Jetpack Compose의 실험적 Styles API([androidx.compose.foundation.style](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/package-summary))가 재설계되면서 `Modifier.styleable()`과 관련 타입들이 deprecated 되었다.

<!--more-->

------

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

## 변경 내용

Compose Foundation **1.14.0-alpha01**(2026년 11월 18일 릴리즈)부터 기존 Modifier.styleable() 기반 API가 deprecated 처리되고 `Modifier.styleResolver` 기반 API로 대체되었다.

- 적용 버전 : androidx.compose.foundation:foundation-*:1.14.0-alpha01 이상
- Deprecated 대상 : [Modifier.styleable()](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/styleable.modifier) 및 [Style](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/Style), StyleScope 등 기존 연관 타입 일체

## 원인

초기 Styles API(Compose 1.11~1.12 알파)는 Foundation 레이어가 색상, 모양, 패딩 등 시각적 스타일 속성을 직접 정의하는 구조였다.

하지만 개발자와 API Council 피드백에서 이 방식이 디자인 시스템의 유연성을 제한한다는 문제가 제기되었다. 이에 따라 핵심 스타일링 엔진이 특정 시각 속성을 강제하지 않도록 아키텍처를 재설계했다.

- Foundation 레이어 개입 축소 : 고정된 스타일 속성 정의 제거
- 디자인 시스템 주도권 이동 : Material 3나 커스텀 디자인 시스템 레이어에서 스타일 속성과 토큰을 직접 정의·제어하는 구조로 전환

## 대체 API 및 샘플 코드

기존 [Modifier.styleable()](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/styleable.modifier)에 [Style](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/Style) 스코프를 직접 연결하던 방식에서 [StyleResolver](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/StyleResolver)와 [CommonStyle](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/CommonStyle) 중심 구조로 전환한다.

- 핵심 Modifier : `Modifier.styleResolver` (레이아웃 노드에 스타일 상태를 동적으로 계산·바인딩)
- Style DSL 개편 : [CommonStyle](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/CommonStyle), CustomStyle, [StyleResolver](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/StyleResolver) 구조 적용
  - `stylePropertyOf` : 디자인 시스템이 자체 스타일 속성 및 토큰을 선언할 때 사용
  - `styleLocalOf` : compositionLocalOf와 유사하게 스타일 엔진 계층 내 로컬 오버라이드 및 컨텍스트 값 전달 담당

### 변경 전 : `Modifier.styleable()` 사용 (Deprecated)

```kotlin
@OptIn(ExperimentalFoundationStyleApi::class)
@Composable
fun CustomButton(
    modifier: Modifier = Modifier,
    style: Style = Style,
) {
    val defaultStyle = Style {
        background(Color.Blue)
        contentPadding(16.dp)
        pressed {
            background(Color.DarkGray)
        }
    }

    Box(
        modifier = modifier.styleable(styleState = null, defaultStyle, style)
    )
}
```

### 변경 후 : `CommonStyle` 및 `Modifier.styleResolver` 전환

```kotlin
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.style.CommonStyle
import androidx.compose.foundation.style.ExperimentalFoundationStyleApi
import androidx.compose.foundation.style.focused
import androidx.compose.foundation.style.pressed
import androidx.compose.foundation.style.styleResolver
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalFoundationStyleApi::class)
@Composable
fun StyledCardExample(onClick: () -> Unit) {
    val cardStyle = remember {
        CommonStyle {
            background(Color.LightGray)
            pressed {
                animate {
                    background(Color.DarkGray)
                }
            }
            focused {
                background(Color.Gray)
            }
        }
    }

    Box(
        modifier = Modifier
            .size(180.dp)
            .styleResolver(cardStyle) {
                onClick()
            }
    )
}
```

## 참고

- [AndroidX Compose Foundation Release Notes](https://developer.android.com/jetpack/androidx/releases/compose-foundation)
- [androidx.compose.foundation.style API Reference](https://developer.android.com/reference/kotlin/androidx/compose/foundation/style/package-summary)
