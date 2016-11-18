---
layout: post
title: "Android Resource Formatting Strings"
date: 2016-11-18 21:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

Android 개발 시 문자열 서식 포맷으로 많이 사용하는 것이 `String.foramt` 이다.

<!--more-->

## String.format

```
String.format("%s / %,d", "안녕", 123456);
// 안녕 / 123,456
```

하지만 위의 경우 `Lint > Correctness`의 `Implied default locale in case conversion` 관련으로 warning을 을 나타내며 **Locale**을 사용하라고 안내한다.

그리고, **"%s / %,d"** 항목을 단순히 `string.xml`에 추가하는 경우, **processDebugResources** Task 실행 결과로 에러로 처리된다.

```
<string name="welcome_begin">%s / %,d</string>

...\MyApplication\app\build\intermediates\res\merged\debug\values\values.xml
    Error:(352) Multiple substitutions specified in non-positional format; did you mean to add the formatted="false" attribute?
    Error:(352) Unexpected end tag string
    Error:(352) Multiple substitutions specified in non-positional format; did you mean to add the formatted="false" attribute?
    Error:(352) Unexpected end tag string
Error:Execution failed for task ':app:processDebugResources'.
    > com.android.ide.common.process.ProcessException: Failed to execute aapt
```

그래서 다음과 같이 처리한다.

```
<string name="welcome_begin" formatted="false">%s / %,d</string>
```

실제로 이렇게 하는 것이 올바른가에 대한 생각을 해봐야 한다.

## Formatting strings

위 관련 내용으로 가장 문제 되는 것은 `다국어` 관련이다.

나라마다 다르게 표현되며, 특히 RTL에 해당하고, 인수가 다른 위치에 들어가야 한다.

그래서, 안드로이드에서는 다음과 같이 인수를 지정할 수 있다.

```
<string name="welcome_messages">%1$s / %2$,d</string>
```

두 개의 인수 중, `%1$s`는 첫 번째 인수이며 문자열이고, `%2$,d`는 두 번째 인수이며 10진수 숫자이다.

## 사용 방법

그래서 다음과 같이 사용할 수 있다.

```
<string name="welcome_messages2">%1$s / %2$,d</string>
```

다음과 같이 두 가지의 사용방법으로 같은 결과를 얻을 수 있다.

> getString(R.string.welcome_messages2, "안녕", 123456)

> String.format(getString(R.string.welcome_messages2), "안녕", 123456)

> 결과 : 안녕 / 123,456


### 참고
- Android FormattingAndStyling : [링크](https://developer.android.com/guide/topics/resources/string-resource.html#FormattingAndStyling)
