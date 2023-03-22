---
layout: post
title: "[메모] Kotlin의 val 프로퍼티 Smart Cast는 동일 모듈에서 더 잘 판단함"
date: 2023-03-22 23:45:00 +09:00
tag: [Kotlin]
categories:
- blog
- Kotlin
---

<!--more-->

Smart Cast시 `val 프로퍼티`에 대한 설명은 아래처럼 공식 문서에 기술되어 있다. 

> val properties - if the property is private or internal or if the check is performed in the same module where the property is declared. Smart casts cannot be used on open properties or properties that have custom getters.
>
> 출처 : https://kotlinlang.org/docs/typecasts.html#smart-casts

설명 중에 `동일 모듈`에 대한 언급은 있지만, 어느 정도인지 다시 체크해 봤다.

간단하게 함수의 파라미터로 전달한 클래스 내에 nullable List 타입 프로퍼티 정보가 있다. null 체크 후 map 함수를 호출하는 코드를 동작시켜 봤다.

```kotlin
// 다른 모듈에 정의
data class AnotherSample(
    val list: List<String>?
)
```

```kotlin
// 아래 test 함수와 동일한 모듈에 작성
data class SameSample(
    val list: List<String>?
)

fun test(
    same: SameSample
) {
    if (same.list == null) return
    val result = same.list.map { // ⬅ 정상적으로 Smart Cast
        it
    }
    println(result)
}

fun test(
    another: AnotherSample
) {
    if (another.list == null) return
    val result = another.list.map { // ⬅ 컴파일 에러 발생
        it
    }
    println(result)
}
```

### Android Studio에서 작성한 모습

{% include img_assets.html id="/blog/2023/0322-smart-cast/001.png" %}

> 빌드 결과
>
> file:///Users/pluu/AndroidStudioProjects/ModuleSmartCastSample/app/src/main/java/com/pluu/kotlin/Test.kt:19:18 Smart cast to 'List<String>' is impossible, because 'another.list' is a public API property declared in different module

