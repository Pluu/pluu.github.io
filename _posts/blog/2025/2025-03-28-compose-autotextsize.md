---
layout: post
title: "Compose에서 AutoTextSize 사용하기"
date: 2025-03-28 09:00:00 +09:00
tag: [Android, Compose]
categories:
- blog
- Android
---

Android 개발 시 텍스트 크기의 자동 변경은 ellipsize와 더불어 특별하게 텍스트를 표현하는 방법입니다. 제한된 영역에 노출할 텍스트의 중요도에 맞춰 개발자는 다양한 방법 중 하나를 선택할 수 있습니다.

<!--more-->

일반적으로 아래 API 혹은 패턴을 조합하여 사용됩니다.

- ellipsize API 사용
- max lines API 사용
- Auto Text Size API 사용 <-- 이번 블로그의 내용
- `더 보기`와 같이 커스텀 텍스트 노출 

Compose의 TextAutoSize API는 사용할 수 있는 공간에 맞는 `가장 큰 글꼴 크기`로 텍스트 크기를 자동 조정됩니다. 이 스펙은 XML에서도 동일하게 적용됩니다

> XML의 [Autosize TextViews](https://developer.android.com/develop/ui/views/text-and-emoji/autosizing-textview)

곧 Compose에도 [AutoTextSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize)가 정식 지원될 예정이지만, 현재 1.8.0 rc01에서 사용할 수 있습니다.

------

본 글에서 사용된 코드는 아래 버전 기준입니다

- AndroidX compose foundation 1.8.0 rc01

------

테스트로 사용한 코드는 아래와 같습니다.

1. **1234567890** 노출
2. **ABCDEFGHIJKLMNOPQRSTUVWXYZ 3번 반복** 노출

```kotlin
@Composable
fun SampleTextAutoSizePreview() {
   ComposeSamplesTheme {
      Column(
         modifier = Modifier.padding(8.dp),
         verticalArrangement = Arrangement.spacedBy(8.dp)
      ) {
         // 1234567890 노출
         SampleTextAutoSize(
            text = "1234567890"
         )
        
         // ABCDEFGHIJKLMNOPQRSTUVWXYZ 3번 반복 노출
         SampleTextAutoSize(
            text = buildString {
               repeat(3) {
                  append("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
               }
            }
         )
      }
   }
}
```

아쉽게도 아직 [Text](https://developer.android.com/reference/kotlin/androidx/compose/material/package-summary#Text(androidx.compose.ui.text.AnnotatedString,androidx.compose.ui.Modifier,androidx.compose.ui.graphics.Color,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.text.font.FontStyle,androidx.compose.ui.text.font.FontWeight,androidx.compose.ui.text.font.FontFamily,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.text.style.TextDecoration,androidx.compose.ui.text.style.TextAlign,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.text.style.TextOverflow,kotlin.Boolean,kotlin.Int,kotlin.Int,kotlin.collections.Map,kotlin.Function1,androidx.compose.ui.text.TextStyle)) Composable에는 [TextAutoSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize) API는 미지원입니다. 그러므로 [BasicText](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/package-summary#BasicText(kotlin.String,androidx.compose.ui.Modifier,androidx.compose.ui.text.TextStyle,kotlin.Function1,androidx.compose.ui.text.style.TextOverflow,kotlin.Boolean,kotlin.Int,kotlin.Int,androidx.compose.ui.graphics.ColorProducer,androidx.compose.foundation.text.TextAutoSize))를 사용합니다.

## 기본 테스트

기본적으로 Compose에서 [TextAutoSize.StepBase](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#StepBased(androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit)) API를 사용하여 텍스트 자동 크기를 사용할 수 있습니다. 

- minFontSize : 기본값 12sp, [TextAutoSizeDefaults.MinFontSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSizeDefaults#MinFontSize())
- maxFontSize : 기본값 112sp, [TextAutoSizeDefaults.MaxFontSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSizeDefaults#MaxFontSize())
- stepSize : 기본값 0.25sp

아래 샘플에서는 `최소 12sp, 최대 48sp, 1sp 단위로 증감`으로 사용된 코드입니다.

```kotlin
@Composable
fun SampleTextAutoSize(
   text: String,
   backgroundColor: Color,
) {
   BasicText(
      text = text,
      autoSize = TextAutoSize.StepBased(
         minFontSize = 12.sp, // Default, 12.sp
         maxFontSize = 48.sp, // Default, 48.sp
         stepSize = 1.sp // Default, 1.sp
      ),
      modifier = Modifier
         .background(Color(0xFFFFEE58)),
   )
}
```

샘플 결과물처럼 기대와 다르게 AutoTextSize API는 동작하지 않습니다. 기본 Auto Size은 제한된 공간에 텍스트 노출을 위한 스펙인데, 위 샘플은 XML의 wrap_content와 동일하게 가변 영역이기 때문입니다.

{% include img_assets.html id="/blog/2025/0327-compose-autotextsize/01.png" %}

## 기본 테스트 + maxLines = 1

사용 API : [TextAutoSize.StepBase](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#StepBased(androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit))
- 최소 12sp, 최대 48sp, 1sp 단위로 증감
- 최대 라인수 1

```kotlin
@Composable
fun SampleTextAutoSize(
   text: String,
   backgroundColor: Color,
) {
   BasicText(
      text = text,
      maxLines = 1,
      autoSize = TextAutoSize.StepBased(
         minFontSize = 12.sp,
         maxFontSize = 48.sp,
         stepSize = 1.sp
      ),
      modifier = Modifier
         .background(backgroundColor),
   )
}
```

이전 샘플에서 `maxLines을 1로 고정`으로 추가한 경우에는 AutoTextSize API가 유효하게 동작합니다. wrap_content이지만 width가 제한되므로 동작하게 됩니다.

{% include img_assets.html id="/blog/2025/0327-compose-autotextsize/02.png" %}

## Bounds 고정

사용 API : [TextAutoSize.StepBase](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#StepBased(androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit,androidx.compose.ui.unit.TextUnit))

- 최소 12sp, 최대 48sp, 1sp 단위로 증감
- Modifier#size로 150.dp 사용

```kotlin
@Composable
fun SampleTextAutoSize(
   text: String,
   backgroundColor: Color,
) {
   BasicText(
      text = text,
      autoSize = TextAutoSize.StepBased(
         minFontSize = 12.sp,
         maxFontSize = 48.sp,
         stepSize = 1.sp
      ),
      modifier = Modifier
         .size(150.dp, 150.dp)
         .background(backgroundColor),
   )
}
```

이번 샘플에서도 Text의 `영역이 고정`되므로 AutoTextSize API가 유효하게 동작합니다.

{% include img_assets.html id="/blog/2025/0327-compose-autotextsize/03.png" %}

## 커스텀 TextSize 구하기

API : [TextAutoSizeLayoutScope.getFontSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#(androidx.compose.foundation.text.modifiers.TextAutoSizeLayoutScope).getFontSize(androidx.compose.ui.unit.Constraints,androidx.compose.ui.text.AnnotatedString))

기본 제공이 아닌 자신만의 커스텀 텍스트 사이즈 제공도 가능합니다. [TextAutoSizeLayoutScope.getFontSize](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#(androidx.compose.foundation.text.modifiers.TextAutoSizeLayoutScope).getFontSize(androidx.compose.ui.unit.Constraints,androidx.compose.ui.text.AnnotatedString))를 사용하여 폰트 크기를 계산, 텍스트를 layout/measured size를 사용하는 [TextAutoSizeLayoutScope.performLayout](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/modifiers/TextAutoSizeLayoutScope#performLayout(androidx.compose.ui.unit.Constraints,androidx.compose.ui.text.AnnotatedString,androidx.compose.ui.unit.TextUnit))을 사용하여 텍스트 사이즈 계산이 가능합니다.

```kotlin
data class PresetsTextAutoSize(
   private val presets: Array<TextUnit>
) : TextAutoSize {
   override fun TextAutoSizeLayoutScope.getFontSize(
      constraints: Constraints,
      text: AnnotatedString
   ): TextUnit {
      var lastTextSize: TextUnit = TextUnit.Unspecified
      for (presetSize in presets) {
         val layoutResult = performLayout(constraints, text, presetSize)
         if (
            layoutResult.size.width <= constraints.maxWidth &&
               layoutResult.size.height <= constraints.maxHeight
         ) {
            lastTextSize = presetSize
         } else {
            break
         }
      }
      return lastTextSize
   }
}
```

> 소스 출처 : https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/TextAutoSize#(androidx.compose.foundation.text.modifiers.TextAutoSizeLayoutScope).getFontSize(androidx.compose.ui.unit.Constraints,androidx.compose.ui.text.AnnotatedString)