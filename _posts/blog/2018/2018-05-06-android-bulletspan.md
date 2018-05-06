---
layout: post
title: "BulletSpan … ?!"
date: 2018-05-06 18:45:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

- - -

## BulletSpan … ?!

BulletSpan 에 대해서 설명하기전 먼저 Ordered List 에 대해서 이야기를 하겠습니다.

------

### 기존 방법

Android 에서 `Ordered List` 표시하는 방법은 다양합니다.

- 명시적으로 `텍스트` 추가
- HTML의  `ol`  / `ul` 타입
- `CompoundDrawable` 을 이용
- `CustomView` 를 만들어서 해결

각 방식의 장단점은 아래와 같습니다. 아래 내용은 복잡한 방식을 하지 않고 처리의 내용입니다.

|       Type       |                             장점                             |                             단점                             |
| :--------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|   명시적 추가    |              작성이 쉬움 / TextView 하나로 해결              |             원하는 들여쓰기 Margin 처리가 어려움             |
|  HTML의 ol / ul  | HTML 형식 작성으로 이해하기 쉬움 / 들여쓰기 처리됨 / TextView 하나로 해결 |    HTML 형식으로 작성해야함 / 추가적인 Span 처리가 어려움    |
| CompoundDrawable |                작성이 쉬움 / 들여쓰기 처리됨                 | 원하는 위치에 Drawable 그리기가 불가능 / TextView 하나로 불가능 |
|    CustomView    |                       Custom 가능하다                        |             CustomView 작업 / View 하나로 불가능             |

------

### BulletSpan

사실 `BulletSpan` 이 API Level 1부터 존재했다는 사실을 뒤늦게 알았습니다.

framework의 [BulletSpan.java](https://android.googlesource.com/platform/frameworks/base/+/master/core/java/android/text/style/BulletSpan.java)

사용한 결과는 다음과 같습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-05-06-bulletspan-01.png" }}" /> 

실제 Bullet 처리 들여쓰기의 처리가 잘 적용되었습니다.

`BulletSpan.java` 의 핵심적인 부분만 살펴보겠습니다.

```java
public class BulletSpan implements LeadingMarginSpan, ParcelableSpan {
    private final int mGapWidth;
    private final boolean mWantColor;
    private final int mColor;

    private static final int BULLET_RADIUS = 3;
    private static Path sBulletPath = null;
    public static final int STANDARD_GAP_WIDTH = 2;

    ...

    public int getLeadingMargin(boolean first) {
        return 2 * BULLET_RADIUS + mGapWidth;
    }

    public void drawLeadingMargin(Canvas c, Paint p, int x, int dir,
                                  int top, int baseline, int bottom,
                                  CharSequence text, int start, int end,
                                  boolean first, Layout l) {
        if (((Spanned) text).getSpanStart(this) == start) {
            Paint.Style style = p.getStyle();
            int oldcolor = 0;

            if (mWantColor) {
                oldcolor = p.getColor();
                p.setColor(mColor);
            }

            p.setStyle(Paint.Style.FILL);

            if (c.isHardwareAccelerated()) {
                if (sBulletPath == null) {
                    sBulletPath = new Path();
                    // Bullet is slightly better to avoid aliasing artifacts on mdpi devices.
                    sBulletPath.addCircle(0.0f, 0.0f, 1.2f * BULLET_RADIUS, Direction.CW);
                }

                c.save();
                c.translate(x + dir * BULLET_RADIUS, (top + bottom) / 2.0f);
                c.drawPath(sBulletPath, p);
                c.restore();
            } else {
                c.drawCircle(x + dir * BULLET_RADIUS, (top + bottom) / 2.0f, BULLET_RADIUS, p);
            }

            if (mWantColor) {
                p.setColor(oldcolor);
            }

            p.setStyle(style);
        }
    }
}
```

- int getLeadingMargin (boolean first)
  - Bullet을 제외한, Text로 지정한 부분이 노출되는 시작 Margin을 반환합니다.
- void drawLeadingMargin (Canvas c, Paint p, int x, int dir, int top, int baseline, int bottom, CharSequence text, int start, int end, boolean first, Layout layout)
  - 선행 마진 (ex, 여기에서는 Bullet) 을 랜더링합니다.

### 하지만… BulletSpan의 불편할지도?

framework의 `BulletSpan` 클래스는 사용시 불편하도 생각되는 부분이 있습니다. 

- Bullet의 크기가 가변이 아니다
- Bullet의 크기를 바꿀 수 없다

#### Bullet 가변 확인

텍스트 크기와 Bullet의 크기가 가변적이지 있습니다. 실험적으로 기본 텍스트와 30sp 를 적용한 TextView 사용시 아래와 같습니다. `Bullet의 사이즈는 바뀌지 않습니다.`

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-05-06-bulletspan-02.png" }}" /> 

#### Bullet 크기 변경

BulletSpan의 생성자는 gapWidth과 Buillet 의 컬러 변경만 가능합니다. Bullet의 사이즈 변경의  `bulletRadius` 도 있지만, 실제로 사용 불가능합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-05-06-bulletspan-03.png" }}" /> 

### 마무리

BulletSpan 사용으로 단일 TextView에 원하는 형태로 처리도 가능하므로 커스텀뷰를 사용하지 않고도 HTML 의 `ol` 과 비슷한 처리도 가능합니다. 프레임워크의 소스를 참고하여 크기 가변 등 추가 처리도 가능하므로, 사용 형태에 따라서 다양한 Bullet 처리도 가능합니다.