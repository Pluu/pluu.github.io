---
layout: post
title: "[번역] Java를 사용했던 Android 엔지니어가 처음 Kotlin로 써 보았다"
date: 2016-12-27 22:50:00 +09:00
tag: [Android, Kotlin]
categories:
- blog
- Android
---

본 포스팅은 [Javaで書いてたAndroidエンジニアが初めてKotlinで書いてみた](http://qiita.com/satorufujiwara/items/d3e5fa9fd19de7e4d55c) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

이 문서는 [Kotlin Advent Calendar 2016](http://qiita.com/advent-calendar/2016/kotlin)의 마지막 날의 게시물입니다.

전날 rabitarochan씨의 [Kotlin Compiler Plugin (kotlin-allopen)을 쫓아간다](http://rabitarochan.hatenablog.com/entry/2016/12/24/235955)이었습니다.

첫날은 ngsw_taro씨의 [Kotlin 2016 정리](http://taro.hatenablog.jp/entry/2016/12/01/074754)이었습니다.

## 서론

나는 2015년 3월경부터 Kotlin으로 Andorid 개발을 시작했기 때문에 제목에 위배되지만 Kotlin 경력은 약 2년 정도입니다. 또한 작년에는 다음과 같은 기사를 썼습니다.

- [2016년 Kotlin으로 Android 개발하는 사람에게](http://qiita.com/satorufujiwara/items/871c5b7b66c7691d82a8)

2016년 Kotlin의 기념해야 할 ver1.0를 출시한 해였지만, 팀의 [마이크로 서비스의 하나라도 Kotlin이 사용](http://blog.stormcat.io/entry/kotlin-with-spark) 되거나 신규 서비스 중 일부는 Kotlin으로 개발되어 Android 연수 합숙에서 참가자의 절반이 Kotlin을 선택하는 등 사내에서도 Kotlin이 고조된 한 해였습니다.

이 기사에서는 그 사내에서 실시한 연수 합숙에서 지금까지 Java로 작성했던 Android 엔지니어한테서 독학으로 Kotlin으로 적은 후 그 코드 리뷰에서 "이렇게 하면 더 Kotlin스럽게 될지도?"라는 관점에서 지적한 사항을 정리했습니다.

Kotlin 다양하게 작성할 수 있으므로, 사람이나 팀에 따라서 규칙은 다르다고 생각합니다만, 이 기사에서는 "더 분량을 줄이는" 관점이라고 생각합니다.

앞으로 Kotlin으로 Android를 쓰려고 생각하시는 분에게 조금이라도 도움이 되면 좋겠습니다.

## Java를 사용했던 Android 엔지니어가 처음 Kotlin로 써 보았다

코드 리뷰 전후의 코드 비교를 올립니다.

### getter/setter

Java라면 field에 getter와 setter를 만들거나 합니다만, Kotlin의 클래스는 기본적으로 field는 없고 [property](https://kotlinlang.org/docs/reference/properties.html)를 사용합니다.

Before

```
class MyClass {
   private var size : Int = 0

   fun getSize() {
       return size
   }
}
```

After

```
class MyClass {
   var size : Int = 0
}
```

Kotlin의 property는 getter/setter를 자유롭게 변경할 수 있으므로 다음과 같은 방법도 가능합니다.

```
class MyClass {
    val list = mutableListOf<String>()
    var size = 0
        get() = list.size
        private set
}
```

### Constructor

Kotlin는 primary constructor의 정의, 속성의 정의를 클래스 선언 부분에 모아서 [작성](https://kotlinlang.org/docs/reference/classes.html)할 수 있습니다

Before

```
class Person {
    val firstName: String
    val lastName: String
    private var age: Int

    constructor(firstName: String, lastName: String, age: Int) {
        this.firstName = firstName
        this.lastName = lastName
        this.age = age
    }
}
```

After

```
class Person(val firstName: String, val lastName: String, private var age: Int) {

}
```

### const

Kotlin에는 [Compile-Time constants](https://kotlinlang.org/docs/reference/properties.html#compile-time-constants)를 위한 `const`라는 수식어가 있습니다.

Before

```
class MyClass {
    val TOKEN_KEY = "ACCESS_TOKEN_KEY"
}
```

After

```
class MyClass {
    companion object {
        const val TOKEN_KEY = "ACCESS_TOKEN_KEY"
    }
}
```

### listOf, mutableListOf

Kotlin의 표준 함수에는 [listOf](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/list-of.html), [mutableListOf](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/mutable-list-of.html)와 같은 함수가 있습니다.

Before

```
fun getList(): List<String> {
    val list: MutableList<String> = ArrayList()
    list.add("value1")
    list.add("value2")
    return list
}
```

After

```
fun getList(): List<String> {
    return listOf("value1", "value2")
}
```
```
fun getList() = listOf("value1", "value2")
```

### Pair

Kotlin에는 [Pair](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-pair/)라는 클래스가 있고, 임의의 클래스 두 개의 값의 집합을 가질 수 있습니다.
또한 [to](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/to.html) 이라는 함수가 있고, 이것을 이용하면 `Pair`의 생성을 간단하게 할 수 있습니다.

Before

```
val params : List<Pair<String, Int>> = listOf(Pair("a", 1), Pair("a", 2))
```

After

```
val params = listOf("a" to 1, "a" to 2)
```

`to`는 [infix](https://kotlinlang.org/docs/reference/functions.html#infix-notation)가 붙어있는 확장 함수로 위와 같은 표기를 할 수 있습니다.
Pair는 다음과 같은 방법도 가능합니다.

```
val (k, v) = "a" to 1
v == 1 // true

val map = mapOf("a" to 1, "b" to 2)
map["a"] == 1 // true
```

### Data Class

Entity는 [Data Class](https://kotlinlang.org/docs/reference/data-classes.html)로서 정의하는 것이 좋습니다.

```
data class User(val name: String, val age: Int)
```

### lazy

Delegates property의 [lazy](https://kotlinlang.org/docs/reference/delegated-properties.html#lazy)를 이용하는 것으로, property를 Non-null 및 val으로 할 수 있습니다.

Before

```
var webView: WebView? = null

override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)

    webView = findViewById(R.id.webView) as WebView
    webView?.setWebViewClient(WebViewClient())
    webView?.settings?.javaScriptEnabled = true
    webView?.loadUrl("https://kotlinlang.org/")
}
```

After

```
val webView by lazy {
    (findViewById(R.id.webView) as WebView).apply {
        setWebViewClient(WebViewClient())
        settings?.javaScriptEnabled = true
    }
}
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    webView.loadUrl("https://kotlinlang.org/")
}
```

위와 같은 용도이면 [kotterknife](https://github.com/JakeWharton/kotterknife)를 이용하는 것이 좋을지도 모릅니다. 사용 시에는 [Retained Fragment에 관한 issue](https://github.com/JakeWharton/kotterknife/issues/5)에 귀기울일 필요가 있습니다.

### Smart Cast / Safe Cast

Cast를 사용해야할시에는 [Smart Cast](https://kotlinlang.org/docs/reference/typecasts.html#smart-casts)이나 `as?`에 의한 [Safe Cast](https://kotlinlang.org/docs/reference/typecasts.html#safe-nullable-cast-operator)를 이용하여 간결하게 쓸 수 있습니다.

Before

```
if (recyclerView?.itemAnimator is SimpleItemAnimator) {
    (recyclerView?.itemAnimator as SimpleItemAnimator).supportsChangeAnimations = false
}
```

After (Smart Cast)

```
recyclerView?.itemAnimator?.let {
    if(it is SimpleItemAnimator) it.supportsChangeAnimations = false
}
```

After (Safe Cast)

```
(recyclerView.itemAnimator as? SimpleItemAnimator)?.run {
    supportsChangeAnimations = false
}
```

### kotlin.collections

[kotlin.collections](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/index.html) 패키지에는 다수의 유용한 확장 기능이 있습니다.

Before

```
fun getUrlWithQueryParams(baseUrl: String, param: List<Pair<String, String>>): String {
    var url: String = baseUrl
    var i: Int = 0
    for (pair in param) {
        if (i == 0) {
            url += "?"
        } else {
            url += "&"
        }
        url += (pair.first + "=" + pair.second)
        i++
    }
    return url
}
```

After

```
fun getUrlWithQueryParams(baseUrl: String, params: List<Pair<String, String>>) =
params.foldIndexed(baseUrl, {i, url, param -> "$url${if (i == 0) '?' else '&' }${param.first}=${param.second}"}) 
```

## 마지막으로

Kotlin으로 개발을 시작하고서 ["Kotlin"으로 Twitter 검색](https://twitter.com/search?f=tweets&vertical=default&q=kotlin)을 계속 지켜보고 있지만, 최근 1년은 Kotlin이 널리 보급된 1년으로 이미 여러 곳에서 쓰이구나라는 느낌입니다.

2017년은 더 고조될 것입니다!

올해도 일 년 수고하셨습니다.