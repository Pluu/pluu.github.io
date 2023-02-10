---
layout: post
title: "재사용 불가능한 Spans"
date: 2023-02-10 23:10:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

TextView에 스타일 적용은 많이 사용되는 패턴입니다.

<!--more-->

스타일 적용에는 XML 속성, TextView 기능과 더불어 많이 사용하는 것이 바로 Spans을 적용하는 방법이 있습니다. 이번 포스팅에서는 Spans의 숨은 특성을 소개하겠습니다.

> Span에 대한 내용은 아래 링크를 참고해 주세요.
>
> - [Spantastic text styling with Spans](https://medium.com/androiddevelopers/spantastic-text-styling-with-spans-17b0c16b4568)
> - [Underspanding spans](https://medium.com/androiddevelopers/underspanding-spans-1b91008b97e4)

------

샘플 소스 : https://github.com/Pluu/ReusableSpanSample

------

## Spans 기본 사용

TextView에 Spans을 적용하기 위해서는 먼저 [Spannable](https://developer.android.com/reference/android/text/Spannable.html) 객체에 [setSpan(Object what, int start, int end, int flags)](https://developer.android.com/reference/android/text/Spannable#setSpan(java.lang.Object,%20int,%20int,%20int)) 함수를 사용하여 Spans을 적용해야합니다. 그 후, [TextView#setText](https://developer.android.com/reference/android/widget/TextView#setText(java.lang.CharSequence,%20android.widget.TextView.BufferType)) 함수에 Spans을 설정한 [Spannable](https://developer.android.com/reference/android/text/Spannable.html) 객체를 전달하면 됩니다. 

예시로 아래 이미지에는 복수의 Spans을 적용한 모습입니다.

- BackgroundColorSpan
- StyleSpan
- ClickableSpan

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0210-span/001.png" }}" />

위 이미지와 같이 문장에서 `Android` 글자를 찾아서 Span을 적용하려면 아래와 같이 여러분은 처리할 것입니다.

1. 문자열에서 Android 문자열을 찾음
2. 1번 결과로 문자열을 찾았다면, 복수의 Spans을 적용
3. 1번 결과의 끝 위치를 시작으로 다음 Android 문자열을 찾을 수 없을 때까지 1~2번을 반복

이것을 단순하게 코드로 작성하면 아래와 같습니다.

```kotlin
// origin : 전체 텍스트
// findText : "Android" 텍스트

val result = SpannableString.valueOf(origin)
findText.toRegex().findAll(result)
  .forEach {
    // 배경색은 어두운 회색
    // 폰트는 Bold체
    // Click 가능한 항목의 색은 노란색, Click시 Toast 노출
    listOf(
      BackgroundColorSpan(Color.DKGRAY),
      StyleSpan(Typeface.BOLD),
      object : ClickableSpan() {
        override fun onClick(widget: View) {
          Toast.makeText(this@MainActivity, "Click", Toast.LENGTH_SHORT).show()
        }

        override fun updateDrawState(ds: TextPaint) {
          super.updateDrawState(ds)
          ds.color = Color.YELLOW
        }
      }
    ).forEach { span ->
      result[it.range.first, it.range.last + 1] = span
    }
  }
```

## 트러블 슈팅

### 도전 1) Spans 재사용...불가능!!

같은 Spans 객체를 매번 생성하는 것은 불필요해 보일 수 있으니 1번 생성 후 재활용을 시도해 봅니다. 정규식으로 찾은 후 list로 Spans을 묶은 부분만 블록 밖으로 빼내어서 객체를 생성해서 사용하면 될 것이라고 예상됩니다.

```kotlin
// 배경색은 어두운 회색
// 폰트는 Bold체
// Click 가능한 항목의 색은 노란색, Click시 Toast 노출
val spans = listOf(
  BackgroundColorSpan(Color.DKGRAY),
  StyleSpan(Typeface.BOLD),
  object : ClickableSpan() {
    override fun onClick(widget: View) {
      Toast.makeText(this@MainActivity, "Click", Toast.LENGTH_SHORT).show()
    }

    override fun updateDrawState(ds: TextPaint) {
      super.updateDrawState(ds)
      ds.color = Color.YELLOW
    }
  }
)

// origin : 전체 텍스트
// findText : "Android" 텍스트
val result = SpannableString.valueOf(origin)
findText.toRegex().findAll(result)
  .forEach {
    spans.forEach { span ->
      result[it.range.first, it.range.last + 1] = span
    }
  }
```

그러나, 결과는 아이러니하게도 마지막 `Android` 문자열에만 Spans이 적용되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0210-span/002.png" }}" />

#### 왜? 동작을 안 할까?

Spans 적용 코드를 추적하면 [SpannableStringInternal](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/text/SpannableStringInternal.java) 클래스에 도달합니다. setSpan 함수 내부에는 추가 적용하려는 Spans과 이미 적용된 Spans을 비교하는 로직이 있습니다. 이때 동일한 Spans이라면 새롭게 호출된 정보로 Spans에 관련된 정보를 업데이트합니다. 

이 동작이라면 동일한 Spans을 재사용한다면 마지막에 호출된 정보만 적용됩니다. 그래서 이전 샘플에서 본 대로 마지막 `Android` 문자열에만 Spans이 적용됩니다.

```java
/* package */ abstract class SpannableStringInternal
{
  private void setSpan(Object what, int start, int end, int flags, boolean enforceParagraph) {
    ...
    int count = mSpanCount;
    Object[] spans = mSpans;
    int[] data = mSpanData;

    for (int i = 0; i < count; i++) {
      if (spans[i] == what) {
        int ostart = data[i * COLUMNS + START];
        int oend = data[i * COLUMNS + END];

        data[i * COLUMNS + START] = start;
        data[i * COLUMNS + END] = end;
        data[i * COLUMNS + FLAGS] = flags;

        sendSpanChanged(what, ostart, oend, nstart, nend);
        return;
      }
    }
    ...
  }
}  
```

> 코드 출처 : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/text/SpannableStringInternal.java;l=221-237?q=SpannableStringInternal

### 도전 2) CharacterStyle#wrap...불가능!!

Spans들의 최상위 항목인 CharacterStyle에는 단일 영역에만 지정할 수 있는 Span을 여러 영역에 사용될 수 있게 해주는 함수 [CharacterStyle#wrap(CharacterStyle cs)](https://developer.android.com/reference/android/text/style/CharacterStyle#wrap(android.text.style.CharacterStyle)) 가 있습니다.

> CharacterStyle#wrap 함수 주석
>
> - 지정된 CharacterStyle은 지정된 Spanned의 단일 영역에만 적용될 수 있습니다. 동일한 CharacterStyle을 여러 영역에 연결해야 하는 경우 이 메서드를 사용하여 효과는 같지만, 별개의 개체인 새 개체로 래핑하여 충돌 없이 연결할 수도 있습니다.

```kotlin
// 배경색은 어두운 회색
// 폰트는 Bold체
// Click 가능한 항목의 색은 노란색, Click시 Toast 노출
val spans = listOf(...)

// origin : 전체 텍스트
// findText : "Android" 텍스트
val result = SpannableString.valueOf(origin)
findText.toRegex().findAll(result)
  .forEach {
    spans.forEach { span ->
      // Spans 재활용을 위해서 CharacterStyle.wrap을 사용
      result[it.range.first, it.range.last + 1] = CharacterStyle.wrap(span) 
    }
  }
```

아래 영상은 위 코드를 실행한 모습입니다. 기대한 대로 Spans이 재활용된 것같아 보이지만, 클릭 시 동작 하지않습니다. 아쉽게도 CharacterStyle.wrap로도 해결되지 않습니다.

{% include youtube.html id="N-qtk-yMf00" %}

**CharacterStyle.wrap 결과**

| Spans               | 적용 여부                                       |
| ------------------- | ----------------------------------------------- |
| BackgroundColorSpan | ○                                               |
| StyleSpan           | ○                                               |
| ClickableSpan       | △<br />- updateDrawState : ○<br />- onClick : X |

#### 왜? 동작을 안 할까?

클릭 시 [ClickableSpan#onClick](https://developer.android.com/reference/android/text/style/ClickableSpan#onClick(android.view.View)) 함수를 호출해주는 것은 [LinkMovementMethod](https://developer.android.com/reference/android/text/method/LinkMovementMethod)입니다. onTouchEvent 함수에서 ACTION_UP 터치 이벤트가 발생한 경우 Spans을 찾는데, 이때 ClickableSpan으로 정의된 Spans만 찾고 있습니다.

```java
public class LinkMovementMethod extends ScrollingMovementMethod {
  @Override
  public boolean onTouchEvent(TextView widget, Spannable buffer,
                                MotionEvent event) {
    int action = event.getAction();
    if (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_DOWN) {
      ...
      // ClickableSpan으로 정의된 것을 검색
      ClickableSpan[] links = buffer.getSpans(off, off, ClickableSpan.class);

      if (links.length != 0) {
        ClickableSpan link = links[0];
        if (action == MotionEvent.ACTION_UP) {
          if (link instanceof TextLinkSpan) {
            ((TextLinkSpan) link).onClick(
              widget, TextLinkSpan.INVOCATION_METHOD_TOUCH);
          } else {
            link.onClick(widget);
          }
        ...
}
```

> 코드 출처 : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/text/method/LinkMovementMethod.java;l=223

우리는 재활용을 위해서 [CharacterStyle#wrap(CharacterStyle cs)](https://developer.android.com/reference/android/text/style/CharacterStyle#wrap(android.text.style.CharacterStyle))을 사용했다는 사실을 기억해야 합니다. 내부적으로 별도의 클래스로 랩핑하는 형태이므로 ClickableSpan로만 찾는다면 결과를 찾을 수 없습니다.

```java
public abstract class CharacterStyle {
  public static CharacterStyle wrap(CharacterStyle cs) {
    if (cs instanceof MetricAffectingSpan) {
      return new MetricAffectingSpan.Passthrough((MetricAffectingSpan) cs);
    } else {
      return new Passthrough(cs);
    }
  }
  ...
}
```

> 코드 출처 : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/text/style/CharacterStyle.java;l=36-42

CharacterStyle와 LinkMovementMethod 둘 다 AndroidX 코드가 아니라 프레임워크에 적재된 코드이므로 프로덕션 환경에서는 해결할 수 없습니다. TextView에 적용된 Spannable에서 ClickableSpan을 찾는다면 [CharacterStyle#getUnderlying](https://developer.android.com/reference/android/text/style/CharacterStyle#getUnderlying()) 함수를 사용해서 랩핑되기 전 타입을 찾을 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0210-span/003.png" }}" />

## 개선 방법은?

트러블 슈팅 1/2를 통해서 우리가 확인한 사실은 Spans은 재활용이나 랩핑 처리로는 원하는 결과를 얻기 어렵다는 것입니다. 결국 Spans을 적용하려는 곳마다 `새롭게 생성하는 방법`을 기준으로 생각해야 한다는 점입니다. 

본 포스팅에서는 간단하게 2가지의 샘플 코드만 공유해봅니다. 개발자 및 팀마다의 스타일은 다양하므로 예시로 소개하는 사례이외에도 시도해보시길 바랍니다.

- Applier 성격의 Lambda
- 텍스트 스타일을 정의하는 클래스 형태
  - ex) Compose에서 Text Composable함수에 텍스트 스타일로 사용하는 [TextStyle](https://developer.android.com/reference/kotlin/androidx/compose/ui/text/TextStyle)

#### Sample. Applier 성격의 Lambda

```kotlin
val applier: Spannable.(Int, Int) -> Unit = { start, end ->
  setSpan(
    BackgroundColorSpan(Color.DKGRAY),
    start, end, Spannable.SPAN_EXCLUSIVE_INCLUSIVE
  )
  setSpan(
    StyleSpan(Typeface.BOLD),
    start, end, Spannable.SPAN_EXCLUSIVE_INCLUSIVE
  )
  setSpan(
    object : ClickableSpan() {
      override fun onClick(widget: View) {
        Toast.makeText(this@MainActivity, "Click", Toast.LENGTH_SHORT).show()
      }

      override fun updateDrawState(ds: TextPaint) {
        super.updateDrawState(ds)
        ds.color = Color.YELLOW
      }
    }, start, end, Spannable.SPAN_EXCLUSIVE_INCLUSIVE
  )
}

val result = SpannableString(origin)
findText.toRegex().findAll(result)
  .forEach {
    result.applier(it.range.first, it.range.last + 1)
  }
```

### Sample. 텍스트 스타일을 정의하는 클래스 형태

```kotlin
// TextStyledSpan 정의
data class TextStyledSpan(
    @ColorInt val background: Int? = null,
    val isBold: Boolean = false,
    val onClickAction: (() -> Unit)? = null,
    @ColorInt val clickableColor: Int? = null
)

// TextStyledSpan로 Span 적용
fun Spannable.setSpanStyle(
    span: TextStyledSpan,
    start: Int,
    end: Int = Int.MIN_VALUE
) {
    // 별도 Spannable 확장 함수를 정의하여 사용
    setBackground(span.background, start, end)
    setBold(span.isBold, start, end)
    setClick(span.onClickAction, span.clickableColor, start, end)
}

val styledSpan = TextStyledSpan(
  background = Color.DKGRAY,
  isBold = true,
  onClickAction = {
    Toast.makeText(this, "Click", Toast.LENGTH_SHORT).show()
  },
  clickableColor = Color.YELLOW
)

val result = SpannableString(origin)
findText.toRegex().findAll(result)
  .forEach {
    result.setSpanStyle(styledSpan, it.range.first, it.range.last + 1)
  }
```

### 참고 자료

- [Why can't use the same Span object to setSpan above twice?](https://stackoverflow.com/q/13118278)
