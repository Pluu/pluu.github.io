---
layout: post
title: "줄 바꿈, 뭐가 문제인데?"
date: 2025-12-30 22:00:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

Android 앱 개발자라면 누구나 한 번쯤은 텍스트 줄 바꿈 문제로 고통받은 경험이 있을 겁니다. 텍스트 줄바꿈은 단순히 글자가 화면 밖으로 튀어나가지 않게 하는 것 이상의 의미를 가집니다. 사용자가 내용을 편안하게 읽을 수 있도록 `가독성`을 높이는 핵심 요소입니다.

<!--more-->

------

하지만 안드로이드에서는 이 줄바꿈이 생각보다 복잡한 난이도를 자랑합니다. XML과 Compose 둘 다 까다로운 것은 비슷할 것입니다.

## 디자이너와의 개발 고충

```
"여기서는 두 줄로 보이게 해주세요."
"아니요, 이 문장은 여기서 꼭 끊어져야 해요."
"기종이 달라도 동일해야 해요."
```

디자이너에게 텍스트의 줄바꿈은 단순한 기능이 아니라, 사용성, 가독성, 그리고 전체적인 UI의 미학을 결정하는 중요한 요소입니다. 

디자이너의 관점에서 줄바꿈은 보통 이렇게 정의됩니다.

- 특정 단어 뒤에서 끊기길 원함
- 문장이 두 줄로 정확히 떨어지길 원함
- 시각적으로 균형이 맞아야 함

하지만 Android 개발자 입장에서 줄바꿈은 다음 요소들의 **복합 결과**입니다.

- 화면 너비 (기종별)
- 폰트 크기 (시스템 설정)
- 글꼴(Font Family)
- 자간, 행간
- 언어 (한글/영문/혼합)
- 접근성 설정 (Font scale)

즉, "여기서 줄이 바뀐다"라는 보장을 할 수 없습니다.

## Android 개발시의 주요 문제

### 1. 언어별 문법 구조의 복잡성 (CJK vs Latin)

가장 큰 이유는 언어마다 **`단어`를 정의하는 기준**이 다르다는 점입니다.

- **영어(Latin):** 띄어쓰기(Space)가 명확한 단어의 구분점입니다. 단어가 잘리지 않게 줄을 바꾸는 `BreakStrategy`가 비교적 단순합니다.
  - **하이픈(Hyphenation):** 영어 단어가 너무 길 때 중간에 `-`를 넣고 줄을 바꾸는 기능은 CPU 연산 비용이 높아 안드로이드에서 기본적으로 꺼져 있거나 설정이 까다롭습니다.
- **한국어/일본어/중국어(CJK):** 한국어는 띄어쓰기가 있지만, 단어 중간에서도 줄바꿈이 허용되는 경우가 많습니다(음절 단위). 반면 일본어나 중국어는 아예 띄어쓰기가 없어 어디서 줄을 바꿀지 판단하기 위해 복잡한 사전 기반 알고리즘이나 규칙이 필요합니다.

### 2. 안드로이드 OS 버전별 파편화

안드로이드는 버전이 올라갈수록 텍스트 렌더링 엔진을 개선해 왔지만, 이는 곧 **"버전마다 줄바꿈 결과가 다르다"**는 문제를 낳았습니다.

- **Android 6.0 (Marshmallow):** [BreakStrategy](https://developer.android.com/reference/android/widget/TextView#setBreakStrategy(int)), [HyphenationFrequency](https://developer.android.com/reference/android/widget/TextView#setHyphenationFrequency(int)) 등이 도입되었지만, 제조사나 폰트에 따라 적용 결과가 제각각이었습니다.
- **Android 9.0 (Pie):** 텍스트 측정 속도를 높이기 위해 [PrecomputedText](https://developer.android.com/reference/android/text/PrecomputedText)가 도입되었습니다.
- **최신 버전:** 최근에는 [LineBreakConfig](https://developer.android.com/reference/android/graphics/text/LineBreakConfig)를 통해 텍스트 줄 바꿈에 대한 줄 바꿈 전략을 지정할 수 있게 되었습니다. 그러나, 하위 호환성 문제로 인해 구형 기기에서는 여전히 원하는 대로 보이지 않는 경우가 많습니다.

### 3. 동적 레이아웃과 가변 폰트

안드로이드 기기는 화면 크기가 수천 가지에 달합니다.

- **고정 너비의 부재:** 화면 폭이 기기마다 다르므로 한 줄에 들어가는 글자 수가 달라지며, 이는 레이아웃 깨짐으로 이어집니다.
- **사용자 설정:** 사용자가 시스템 설정에서 폰트 크기를 키우거나 **굵은 텍스트**를 적용하면, 개발자와 디자이너가 의도한 디자인 밸런스가 순식간에 무너집니다. 텍스트가 잘리거나(Ellipsis/Crop), 예상치 못한 위치에서 줄이 바뀌어 UI가 겹치는 현상이 빈번합니다.

### 4. 성능(Performance) 문제

텍스트를 화면에 그리는 작업은 생각보다 비싼 연산입니다.

- **Layout 측정:** 줄바꿈을 계산하려면 폰트의 두께, 자간, 글리프(Glyph)의 너비를 모두 계산해야 합니다. RecyclerView에서 수많은 항목의 줄바꿈을 실시간으로 계산하면 프레임 드랍이 발생할 수 있습니다.
- **측정의 딜레마:** 정확한 줄바꿈을 위해서는 전체 문장을 다 읽어야 하지만, 성능을 위해서는 최소한의 계산만 해야 하는 모순에 빠집니다.

## Compose에서의 줄바꿈

Compose에서의 줄바꿈은 여러 가지 방법이 존재합니다.

### 1) maxLines 사용

```kotlin
Text(
   text = "이 문장은 👉 여기서 끊기길 원해요",
   maxLines = 2
)
```

- "두 줄까지만 허용"이며 특정 위치에서 끊기는 용도가 아닙니다.

### 2) 강제 LineBreak

```kotlin
Text(
   text = "지금 신청하면\n할인 혜택 제공"
)
```

가장 직관적인 방법이지만, 가장 위험한 방법이기도 합니다.

**문제점**

- 번역 시 문장 구조가 깨짐
- 화면 크기에 따라 줄이 3줄이 될 수 있음

### 3) Text를 나눠서 배치하기

```kotlin
Column {
   Text("지금 신청하면")
   Text("할인 혜택 제공")
}
```

요구사항을 강제로 만족시키는 방법입니다.

**문제점**

- 접근성(TalkBack)에서 문장이 끊어짐
- 자연스러운 텍스트 흐름이 사라짐
- 텍스트 복사 시 문장이 이상하게 복사되는 이슈 발생

## 디자이너가 원하는 "비주얼 줄바꿈" vs 개발자의 현실

디자이너는 보통 **픽셀 기준**으로 생각하지만, 개발자는 **상대적 레이아웃**을 다룹니다.

|  디자이너   |      개발자      |
| :---------: | :--------------: |
| 고정된 화면 |    가변 화면     |
|   한 언어   |      다국어      |
|  기본 폰트  | 사용자 설정 폰트 |
|  단일 기기  |    다수 기기     |

그래서 Compose에서도 현실적인 타협이 필요합니다. 이건 XML도 동일한 내용입니다.

### 1. 의도를 명확히 드러내는 텍스트 구조

- 줄바꿈 위치는 맡긴다
- 대신 잘리지 않게 관리

```kotlin
Text(
    text = "지금 신청하면 할인 혜택 제공",
    maxLines = 2,
    overflow = TextOverflow.Ellipsis
)
```

### 2. 디자이너와 "보장 범위" 합의하기

- ❌ "항상 여기서 끊어주세요"
- ✅ "이 정도 느낌이면 괜찮아요"

이 한 문장이 개발자의 수명을 연장시킵니다.

### 3. 정말 중요하다면… 디자인을 바꾼다

- 강조 단어만 따로 스타일링
- 문장을 두 개의 의미 단위로 분리
- 줄바꿈에 의존하지 않는 UI 구조

## 개선하기 1. LineBreak Modifier 사용

앞서 이야기한 대로 협의가 된다면 개발은 훨씬 수월하게 진행될 수 있습니다. 추가로 개선해 볼 부분을 다뤄보겠습니다.

Android 14 (API 34)부터는 [LineBreak](https://developer.android.com/develop/ui/compose/text/style-paragraph#cjk-considerations)라는 Modifier를 통해 CJK 언어의 줄바꿈을 훨씬 정교하게 제어할 수 있습니다. 

- [Strictness](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak.Strictness) : 줄바꿈의 엄격성
- [WordBreak](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak.WordBreak) : 단어 내에 줄바꿈을 삽입하는 방법

각 속성의 기본값(Default)은 언어에 따라 다르게 적용됩니다.

또한, [LineBreak](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak) Modifier API에는 여러 줄로 분할되는 기준이 있으며, 자주 사용되는 API를 제공하고 있습니다.

- Simple : 빠르고 기본적인 줄 바꿈이며, 텍스트 입력란에 권장
- Heading : 더 느슨한 줄바꿈 규칙으로 줄바꿈 제목과 같은 짧은 텍스트에 권장
- Paragraph : 가독성 향상을 위해 더 느리고 고품질의 줄 바꿈을 사용하며, 단락과 같은 많은 양의 텍스트에 권장

### API 테스트

아래는 테스트로 위 테스트는 폭 200dp의 Box에서 텍스트를 그리는 것을 테스트했으며, 테스트로는 총 5개의 텍스트를 사용했습니다.

- "가나다라마바사아자차타파하가나다라마바사아자차타파하"
- "가나다라마바 사아자차타파하ABCDEFGHIJKLMNOP QRSTUVWXYZ1234 567890"
- "가나다라마바사아자차타파하ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
- "<b>가나다라 <font color='#ff00ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b> 12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ<br><b>가나다라 <font color='#0000ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b>"
- "12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ"

```kotlin
Box(modifier = Modifier.width(200.dp)) {
   Text(
      text = AnnotatedString.fromHtml(text),
      style = textStyle.copy(
         lineBreak = /** LineBreak 사용 */
      )
   )
}
```

|                             기본                             |                     LineBreak.Paragraph                      |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2025/1229-LineBreak/01.png" %} | {% include img_assets.html id="/blog/2025/1229-LineBreak/02.png" %} |

|                      LineBreak.Heading                       |
| :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2025/1229-LineBreak/03.png" %} |

Android가 정의하는 언어의 의도와는 별개로 읽기 쉬운 구조로 접근한다면, 예상과 다른 케이스들이 나옵니다. 

> 몇 가지의 케이스를 주관적인 기준으로 분류해 봤습니다.
>
> - ✅ : 어느 정도 정상 노출 범위라고 판단
> - 🤔 : 사람에 따라서 다르게 판단
> - ❌ : 의도하지 않은 개행

- "가나다라마바사아자차타파하가나다라마바사아자차타파하"
  - 기본 : ✅
  - LineBreak.Paragraph : ✅
  - LineBreak.Heading : ❌, `1줄 자/2줄 마` 다음에 개행 발생
- "가나다라마바 사아자차타파하ABCDEFGHIJKLMNOP QRSTUVWXYZ1234 567890"
  - 기본 : ✅
  - LineBreak.Paragraph : ❌, `1줄 사` 다음에 개행 발생
  - LineBreak.Heading : 🤔, `1줄 바` 다음에 개행 발생
- "가나다라마바사아자차타파하ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  - 기본 : ✅
  - LineBreak.Paragraph : ✅
  - LineBreak.Heading : ❌, `1줄 자/2줄 H/3줄 V` 다음에 개행 발생
- "<b>가나다라 <font color='#ff00ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b> 12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ<br><b>가나다라 <font color='#0000ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b>"
  - 기본 : ❌, `1줄 차/3줄 Q/4줄 Z` 다음에 개행 발생
  - LineBreak.Paragraph : ❌, `1줄 아/4줄 4/5줄 0/8줄 아` 다음에 개행 발생
  - LineBreak.Heading : ❌, `2줄 B/3줄 M` 다음에 개행 발생
- "12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ"
  - 기본 : ✅
  - LineBreak.Paragraph : ❌, `1줄 0/2줄 0` 다음에 개행 발생
  - LineBreak.Heading : ✅

> 이어서 커스텀으로 TextMeasurer를 사용하여 커스텀하는 방법을 소개할 예정입니다. 그렇지만, 소요되는 시간을 고려했을 때는 개인적으로 앞서 소개한 [LineBreak](https://developer.android.com/develop/ui/compose/text/style-paragraph#cjk-considerations) Modifier를 사용하는 것을 추천드립니다.

## 개선하기 2. LineBreak Modifier API를 조합하여 사용

LineBreak Modifier가 제공하는 기본 API로도 어느 정도 대응 가능하지만, 각 속성을 사용하여 더욱 세밀한 조합으로 시도해 볼 수 있습니다.

- [HighQuality](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak.Strategy#HighQuality()) : 하이픈이 사용 설정된 경우를 포함하여 텍스트를 더 읽기 쉽도록 단락을 최적화
- [Strict](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak.Strictness#Strict()) : 줄바꿈에 가장 엄격한 규칙
- [Phrase](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/style/LineBreak.WordBreak#Phrase()) : 줄바꿈은 구문을 기반

> CJK 고려사항 : [링크](https://developer.android.com/develop/ui/compose/text/style-paragraph?hl=ko#cjk-considerations)

```kotlin
Text(
   text = AnnotatedString.fromHtml(text),
   style = textStyle.copy(
      lineBreak = LineBreak(
         strategy = LineBreak.Strategy.HighQuality,
         strictness = LineBreak.Strictness.Strict,
         wordBreak = LineBreak.WordBreak.Phrase
      )
   )
)
```

|                        LineBreak 조합                        |
| :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2025/1229-LineBreak/04.png" %} |

LineBreak 속성을 좀 더 특별하게 다룬 결과는 다음과 같습니다.

- "가나다라마바사아자차타파하가나다라마바사아자차타파하"
  - 개선 버전 : ✅
- "가나다라마바 사아자차타파하ABCDEFGHIJKLMNOP QRSTUVWXYZ1234 567890"
  - 개선 버전 : 🤔, `1줄 바` 다음에 개행 발생
- "가나다라마바사아자차타파하ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  - 개선 버전 : ✅
- "<b>가나다라 <font color='#ff00ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b> 12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ<br><b>가나다라 <font color='#0000ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b>"
  - 개선 버전 : ✅
- "12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ"
  - 개선 버전 : ✅

기본적인 LineBreak Modifier API를 사용하면 읽기 좋은 Text 결과를 얻을 수 있습니다.

## 개선하기 3. TextMeasurer를 통한 계산

> 이어서 소개할 TextMeasurer를 사용하는 방법은 다른 방법과 다르게 복잡하게 계산을 통해서 이루어낸 결과입니다. 기대 결과와 차이가 발생한다는 점을 사전에 언급합니다.

먼저 TextMeasurer를 통해서 개선된 모습을 먼저 살펴보겠습니다. Jetpack Compose에서 `TextMeasurer`는 텍스트를 실제로 화면에 그리기 전에, **텍스트가 차지할 크기(너비, 높이)와 레이아웃 정보**를 미리 계산할 때 사용하는 도구입니다. 

먼저 개선된 결과를 살펴보겠습니다. 앞서 소개한 `개선하기 2`의 LineBreak Modifier API 조합형과 결과가 유사하면서 개인적으로 수정한 모습입니다.

|                          개선 버전                           |
| :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2025/1229-LineBreak/05.png" %} |

- "가나다라마바사아자차타파하가나다라마바사아자차타파하"
  - 개선 버전 : ✅
- "가나다라마바 사아자차타파하ABCDEFGHIJKLMNOP QRSTUVWXYZ1234 567890"
  - 개선 버전 : 🤔, `1줄 바/3줄 P` 다음에 개행 발생
- "가나다라마바사아자차타파하ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  - 개선 버전 : ✅
- "<b>가나다라 <font color='#ff00ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b> 12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ<br><b>가나다라 <font color='#0000ff'>마바 사아자 차카</font> 12타               파 하 <i>AB CDEF GH IJKLM NOPQ RSTU VWX YZ</i></b>"
  - 개선 버전 : ✅
- "12345678901234567890 ABCDEFGHIJKL<br>MNOPQRSTUVWXYZ"
  - 개선 버전 : ✅

### TextMeasurer#measure

TextMeasurer.measure() 메서드는 입력된 텍스트와 스타일을 바탕으로 TextLayoutResult 객체를 반환합니다. 이 객체에는 텍스트의 크기, Line 수, 각 글자의 위치, baseline 등의 상세 정보가 포함됩니다.

> 참고 자료 : [텍스트 측정](https://developer.android.com/develop/ui/compose/graphics/draw/overview#measure-text)

### 구현 코드, WordWrapText

WordWrapText Composable 내부에서 계산하기 전 필요한 정보를 취득합니다.

- AnnotatedString.fromHtml(text) : HTML도 지원을 위해서, 전달된 text를 AnnotatedString로 변환
- BoxWithConstraints : 그려질 영역의 최대 넓이를 가져옴
- List<CharSequence>.joinToAnnotatedString : 별도로 만든 API로 `List<AnnotatedString>` 결과를 join 형태로 AnnotatedString를 만드는 확장 함수

```kotlin
@Composable
fun WordWrapText(
   text: String,
   modifier: Modifier = Modifier,
   textStyle: TextStyle = LocalTextStyle.current
) {
   // BoxWithConstraints는 자식 Composable에게 최대 및 최소 너비/높이 제약 조건을 제공합니다.
   // 여기서는 최대 너비를 얻기 위해 사용됩니다.
   BoxWithConstraints(modifier) {
      // 미리 계산된 줄바꿈 리스트를 가져옵니다.
      // rememberMeasuredLines 함수는 주어진 너비와 텍스트 스타일에 따라
      // 텍스트를 여러 줄로 나누는 계산을 수행하고 그 결과를 기억합니다.
      val lines = rememberMeasuredLines(
         AnnotatedString.fromHtml(text),
         maxWidth,
         textStyle
      )

      // 모든 줄을 줄바꿈 문자로 연결하여 하나의 AnnotatedString으로 만듭니다.
      // 이렇게 하면 여러 개의 Text Composable을 사용하는 대신 하나의 Text Composable만으로
      // 여러 줄의 텍스트를 효율적으로 렌더링할 수 있습니다.
      Text(
         text = lines.joinToAnnotatedString(),
         style = textStyle
      )
   }
}
```

### 구현 코드, rememberMeasuredLines

반복 계산을 줄이기 위해서 텍스트 계산 시 remember를 사용했습니다. 

- AnnotatedString#lines : 커스텀 확장 함수로 개행별로 분리를 담당
- Constraints : TextMeasurer#measure에 사용하는 값으로 텍스트가 허용하는 범위를 담당

```kotlin
/**
 * 주어진 너비에 맞게 [AnnotatedString]의 줄바꿈을 미리 계산하여 기억하는 Composable입니다.
 *
 * 이 함수는 텍스트, 너비, 스타일 등이 변경될 때만 줄바꿈 계산을 다시 수행하여
 * 불필요한 계산을 방지하고 성능을 최적화합니다. `remember`를 사용하여 계산 결과를 캐시합니다.
 *
 * @param annotatedString 측정할 [AnnotatedString]입니다.
 * @param width 텍스트의 최대 너비입니다.
 * @param textStyle 텍스트에 적용할 스타일입니다.
 * @return 각 줄을 나타내는 [AnnotatedString]의 리스트입니다.
 */
@Composable
fun rememberMeasuredLines(
   annotatedString: AnnotatedString,
   width: Dp,
   textStyle: TextStyle
): List<AnnotatedString> {
   val textMeasurer = rememberTextMeasurer()
   val density = LocalDensity.current

   // key 값이 변경될 때만 내부 블록의 코드를 다시 실행하여 결과를 계산하고 기억합니다.
   return remember(/** key */) {
      // 너비를 Dp에서 Px 단위로 변환합니다.
      val maxWidthPx = with(density) { width.roundToPx() }
      if (maxWidthPx == 0) return@remember emptyList()

      val constraints = Constraints(maxWidth = maxWidthPx)

      val resultLines = mutableListOf<AnnotatedString>()
      // 원본 텍스트를 줄바꿈 기준으로 분리합니다.
      val sourceLines = annotatedString.lines()

      sourceLines.forEach { line ->
         // 선택된 줄바꿈 전략에 따라 각 줄을 다시 세부적으로 나눕니다.
         resultLines.addAll(
            highQualityStrategy(
               line,
               textMeasurer,
               textStyle,
               constraints
            )
         )
      }
      resultLines
   }
}
```

### 구현 코드, highQualityStrategy

highQualityStrategy 함수가 이번 작업의 핵심 영역입니다. 혹시나 `LineBreak Modifier` API로 해결이 안되는 경우에는 아래 코드를 개선하여 텍스트를 그릴 준비를 하면 됩니다.

아래 로직은 파라미터로 전달된 1줄 정보를 단어 단위로 분리한 뒤, `TextMeasurer#measure` API를 사용하여 어떻게 텍스트를 분리할지 결정합니다. 

- AnnotatedString#splitBySpace : 커스텀 확장 함수로 공백문자를 기준으로 단어 단위로 분리를 담당

```kotlin
/**
 * 각 단어를 개별적으로 측정하여 줄바꿈 처리하는 전략입니다.
 *
 * 이 전략은 각 단어의 너비를 정확하게 측정하고, 한 줄에 들어갈 수 있는 단어들을 조합하여
 * 줄바꿈 위치를 결정합니다. 
 * 단어 자체가 한 줄의 너비를 초과하는 경우에는 해당 단어를 글자 단위로 나누어 
 * 줄바꿈을 수행하여 텍스트가 잘리지 않도록 보장합니다.
 *
 * @param line 줄바꿈을 적용할 [AnnotatedString] 한 줄입니다.
 * @param textMeasurer 텍스트 측정을 위한 [TextMeasurer] 인스턴스입니다.
 * @param textStyle 텍스트에 적용할 스타일입니다.
 * @param constraints 텍스트 레이아웃에 적용할 제약 조건입니다.
 * @return 줄바꿈이 적용된 각 줄을 나타내는 [AnnotatedString]의 리스트입니다.
 */
private fun highQualityStrategy(
   line: AnnotatedString,
   textMeasurer: TextMeasurer,
   textStyle: TextStyle,
   constraints: Constraints
): List<AnnotatedString> {
   if (line.text.isEmpty()) {
      return listOf(AnnotatedString(""))
   }

   // 공백 문자의 너비를 미리 측정하여 계산에 사용합니다.
   val spaceWidth = textMeasurer.measure(
      text = " ",
      style = textStyle
   ).size.width

   val resultLines = mutableListOf<AnnotatedString>()
   // 현재 줄을 공백 기준으로 단어 단위로 분리합니다.
   val words = line.splitBySpace()
   var currentLineBuilder = AnnotatedString.Builder()
   var sumWidth = 0

   words.forEach { item ->
      // 현재 단어의 너비를 측정합니다.
      val textResult = textMeasurer.measure(
         text = item,
         style = textStyle
      ).size.width
      val hasContentOnLine = sumWidth > 0
      val spaceOffset = if (hasContentOnLine) spaceWidth else 0

      if (sumWidth + spaceOffset + textResult <= constraints.maxWidth) {
         // 현재 줄에 단어를 추가할 공간이 충분한 경우, 공백과 함께 단어를 추가합니다.
         if (hasContentOnLine) {
            currentLineBuilder.append(" ")
         }
         currentLineBuilder.append(item)
         sumWidth += (spaceOffset + textResult)
      } else if (textResult > constraints.maxWidth) {
         // 단어 자체가 한 줄의 너비를 초과하는 경우, 글자 단위로 줄바꿈 처리합니다.
         var subWidth = 0
         val items = item.toArray()
         if (currentLineBuilder.length > 0) {
            resultLines.add(currentLineBuilder.toAnnotatedString())
            currentLineBuilder = AnnotatedString.Builder()
         }

         items.forEach { subItem ->
            val subTextResult = textMeasurer.measure(
               text = subItem,
               style = textStyle
            ).size.width

            if (subWidth + subTextResult <= constraints.maxWidth) {
               subWidth += subTextResult
               currentLineBuilder.append(subItem)
            } else {
               subWidth = subTextResult
               resultLines.add(currentLineBuilder.toAnnotatedString())
               currentLineBuilder = AnnotatedString.Builder()
               currentLineBuilder.append(subItem)
            }
         }
         sumWidth = subWidth
      } else {
         // 현재 줄에 단어를 추가할 공간이 부족하여 다음 줄로 넘기는 경우입니다.
         sumWidth = textResult
         resultLines.add(currentLineBuilder.toAnnotatedString())
         currentLineBuilder = AnnotatedString.Builder()
         currentLineBuilder.append(item)
      }
   }

   // 마지막으로 처리된 줄이 남아있으면 결과 리스트에 추가합니다.
   if (currentLineBuilder.length > 0) {
      resultLines.add(currentLineBuilder.toAnnotatedString())
   }

   return resultLines
}
```
