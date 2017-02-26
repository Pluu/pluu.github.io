---
layout: post
title: "[번역] 【!는 뭐야】 Kotlin과 Java, null과 PlatformType 【Nullable에 NotNull】"
date: 2017-02-26 21:00:00 +09:00
tag: [Java, Kotlin]
categories:
- blog
- Kotlin
---

본 포스팅은 [【!ってなんだ】KotlinとJava、nullとPlatformType【NullableにNotNull】](http://qiita.com/RyotaMurohoshi/items/5fcc10d04fecd7304556) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

이 투고는 Kotlin Advent Calendar 2016 5일째 게시물입니다.

## 소개

Kotlin에서는 null을 더 다루기 쉽게 하도록 Nullable 「`?.`」 그리고 「`?:`」 등 다양한 언어기능과 구문이 제공되고 있습니다.

Kotlin으로만 작성된 코드는, `NullPointerException`을 만나는 것은 그렇게 많이 없을 것입니다.

그런데 실제 개발에서는 Kotlin만으로 제품을 완성하는 것은 거의 없습니다. Java로 작성된 SDK와 외부 라이브러리를 이용하여 제품을 만들어가는 것이 대부분입니다.

이 경우

- Java로 정의된 메소드의 반환 값을 변수에 대입
- Java로 정의된 추상 클래스를 상속
- Java로 정의된 인터페이스를 SAM 변환을 이용하여 처리

를 한 경우, null은 어떻게 처리되는 것일까요?

「Kotlin은 null로부터 안전하니깐」라고 사용 방법을 잘못 사용하면 `NullPointerException`과 `IllegalStateException`을 일으켜 버립니다.

본 글에서는 「[!는 뭐야] Kotlin과 Java, null과 PlatformType [Nullable에 NotNull]'라는 제목으로

Java 및 Kotlin의 상호 운용에 있어서 중요한 포인트가 되는 null과 Platform Type 및 관련 사항을 소개합니다.

## Kotlin의 Nullable 확인

우선 Kotlin의 Nullable에 대해 확인합시다.

### String을 돌려주는 메소드의 예

다음과 같이 String 타입을 반환하는 메서드를 정의합니다.

```
fun returnString(): String = ""
```

이 메소드의 반환 값을 변수에 대입하자.

다음과 같이 변수의 타입을 명시하지 않으면 변수 `str`은 String 타입으로 유추됩니다. String 타입 변수 `str`로 `?.`을 사용하여 멤버에 접근하는 경우 「`?.`은 필요 없다」는 취지의 경고가 나옵니다.

```
val str = returnString()
println(str.length)
// 다음은 ?.은 필요 없다는 취지의 경고가 나온다
// println(str?.length)
```

다음과 같이 변수의 타입을 명시할 수 있습니다.

```
val str: String = returnString()
println(str.length)
// 다음은 ?.은 필요 없다는 취지의 경고가 나온다
// println(str?.length)
```

String 타입을 String? 타입의 변수에 할당할 수 있습니다. 변수 `str`은 String? 로 명시적으로 타입을 선언했습니다. `str`은 String? 타입이므로 멤버에 접근할 때 「`.`」가 아니라 「`?`」 로 하지않으면 컴파일 에러가 발생합니다.

```
// String?에 String를 할당 할 수도있다
val str: String? = returnString()
println(str?.length)
// println(str.length)는 컴파일 에러
```

### String?을 반환하는 메소드의 예

다음은 String? 타입을 반환하는 메소드를 확인합니다.

```
fun returnNullableString(): String? = null
```

이 메소드의 반환 값을 변수에 대입합니다.

다음과 같이 변수의 타입을 명시하지 않으면 변수 `str`은 String? 타입으로 유추됩니다. 멤버에 접근할 때에는 「`?.`」를 사용하지 않으면 컴파일 에러가 발생합니다.

```
val str = returnNullableString()
println(str?.length)
// println(str.length)는 컴파일 에러
```

다음과 같이 String? 타입의 반환 값을 String 타입의 변수에 대입할 수 없습니다. Type Mismatch로 컴파일 에러가 됩니다.

```
// Type Mismatch로 컴파일 에러
// val str: String = returnNullableString()
```

다음과 같이 변수의 타입을 명시할 수 있습니다.

```
val str: String? = returnNullableString()
println(str?.length)
// println(str.length)는 컴파일 에러
```

Kotlin에서 정의된 메소드를 Kotlin에서 사용하는 예를 확인했습니다.

다음은 Java로 만든 메소드를 Kotlin으로 사용하는 경우를 보여줍니다.

## Java 메소드를 Kotlin에서 부르자

Java에서 다음과 같은 클래스·메소드를 정의합니다.

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```

이 「`Utility#returnStringJava`」를 Kotlin에서 호출하면 어떻게 될까요.

여기에서는 다음과 같은 순서로 확인해 보겠습니다.

1. String? 타입과 타입을 명시하는 변수에 대입한 경우
2. String 타입과 타입을 명시하는 변수에 대입한 경우
3. 타입을 명시하지 않는 변수에 대입한 경우

### String? 타입으로 명시한 변수에 대입한 경우

다음 코드는 Java에서 정의한 `Utility#returnStringJava`를 String? 타입의 변수에 할당하는 코드입니다.

String? 타입이므로 멤버에 접근하려면 `.`이 아니라 `?.` 이 아니면 컴파일 에러가 발생합니다.

```
val str: String? = Utility.returnStringJava()

println(str?.length)

// println(str.length)는 컴파일 에러
```

Kotlin에서의 String?는 null일지도 모르는 타입, String은 null이 아닌 타입입니다.

한편, Java의 String는 null일 가능성이 있습니다.

Java로 작성한 String을 반환하는 메소드의 반환 값을 Kotlin에서는 String? 변수에 대입하면 쉽게 다룰 수 있으며, `NullPointerException`을 피할 수 있을 것 같네요.

### String 타입으로 명시한 변수에 대입한 경우

다음 코드는 Java에서 정의한 `Utility#returnStringJava`를 String 타입의 변수에 대입하는 코드입니다.

```
val str: String = Utility.returnStringJava()

// ?.는 필요 없다는 취지의 경고가 나온다
println(str?.length)

println(str.length)
```

이 코드는 컴파일 에러는 아닙니다. ( 「?. 는 필요 없다는」 취지의 경고는 나오지만) 컴파일 에러는 발생하지 않지만 런타임 에러가 발생합니다. 어디에서 런타임 에러가 될지 상상해보세요.

덧붙여서 「`Utility#returnStringJava`」는 다음과 같이 null을 반환하는 메소드이네요.

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```

앞의 코드는

```
val str: String = Utility.returnStringJava()
```

에서 null을 String 타입의 변수에 대입하려는 순간에, `IllegalStateException`이 발생해서 런타임 에러가 발생합니다. 대입하려는 순간에 `IllegalStateException` 런타임 에러입니다! 멤버에 접근한 시점에서 `NullPointerException`이 `아닙니다`.

그런데 만약 「`Utility#returnStringJava`」이

```
public class Utility {
    public static String returnStringJava() {
        return "";
    }
}
```

위와 같이 null을 돌려주지 않고, null이지 않은 값을 돌려주는 경우 런타임 에러가 발생하지 않습니다.

### 타입을 명시하지 않는 변수에 대입한 경우

Java에서 String를 반환하는 메소드를 Kotlin에서

- 「String? 타입으로 명시한 변수에 대입한 경우」
- 「String 타입으로 명시한 변수에 대입한 경우」

를 보고 왔습니다. 그렇다면 타입을 명시하지 않는 변수에 대입한 경우를 살펴보자.

```
val str = Utility.returnStringJava()

println(str.length)

println(str?.length)
```

이 코드는 컴파일 에러는 아닙니다. 경고도 나오지 않습니다.

지금까지와 다른 점에 「뭐지」라고 생각되지 않습니까?

str이 String 타입의 변수로 명시적으로 선언 또는 유추된 경우 「`?.`」의 멤버 접근은 경고가 나오고 있었어요.

str가 String? 타입의 변수로 명시적으로 선언 또는 유추된 경우 「`.`」의 멤버 접근은 컴파일 에러가 되네요.

그 어느 쪽도 아닙니다.

그것은 「Java로 정의 · 선언된 참조 타입을 Kotlin에서는 `Platform Type` 타입이라는 특별한 형태로 처리되기 때문」입니다.

```
val str = Utility.returnStringJava()
```

위의 코드에서 str은 String과 String? 모두 명시적으로 선언되어 있지 않습니다.

str은 String? 하지도 String 하지 않은 타입, `Platform Type`의 `String!` 으로 유추되어있는 것입니다.

`Platform Type`에 대해 자세한 것은 다음 절에서 소개하는 것으로 먼저 실행 결과를 살펴보자.

코드를 다시 올립니다.

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```
```
val str = Utility.returnStringJava()

println(str.length)

println(str?.length)
```

를 실행하면 `NullPointerException`이 발생합니다. 「`.`」 로 멤버에 접근하는 순간입니다.

```
val str:String = Utility.returnStringJava()
```

으로 String 타입임을 명시한 변수에는 변수에 대입할 순간에 `IllegalStateException`이 발생하고 있었어요.

예외가 발생하는 순간과 발생하는 예외가 다르다는 것에 주목해주세요.

만약 `Utility#returnStringJava`가 비 null인 String를 돌려주는 경우

```
public class Utility {
    public static String returnStringJava() {
        return "";
    }
}
```

다음과 같이 `NullPointerException`이 발생하지 않고 성공적으로 프로그램이 종료됩니다.

```
0
0
```

## PlatformType이란?

그럼 `PlatformType`에 대해 설명합니다.

Java의 참조형은 null이 될 수 있습니다. Kotlin만 사용하면 Nullable 또는 비 Nullable인지 명확하고 사용하기 쉽지만, Java와의 경계가 성가십니다. 어떤 참조 타입이 null일지도 모르고, 그렇지 않을지도 모르니깐요.

Kotlin는 (`@Nullable`과 `@NotNull`이 붙지 않은) Java에서 온 참조형은 모두 특별하게 Platform Type으로 처리됩니다.

Platform Type은 T!라고 표현됩니다. 예를 들어, String! 라든가, View! 라든가입니다.

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```

라는 메소드를 Kotlin에서 사용하고자 하는 경우 IDEA 예측 변환에서는 `String!` 타입을 돌려준다는 정보가 표시됩니다.

```
val str = Utility.returnStringJava()
```

또한 IDEA에서 str은 `String!` 타입이라는 정보가 표시됩니다.

`Utility#returnStringJava`의 반환 값의 타입은 `String!`이니 str은 `String!` 타입이지만, 명시적으로 `String!`라는 타입을 변수의 선언 등에는 사용할 수 없습니다. 다음 코드는 컴파일 에러가 발생합니다.

```
// 컴파일 에러!!!!
// val str: String! = Utility.returnStringJava()
```

Platform Type인 String! 타입은 Nullable의 String?이기도하고 비 Nullable인 String이기도 한 타입입니다. 다음과 같이 String?에도 String에도 대입할 수 있습니다.

```
val str = Utility.returnStringJava() // 유추되어 str은 String! 타입
val strNullable: String? = str // strNullable은 String? 타입
val strNotNull: String = str // strNotNull은 String 타입
```

그런데, Java의 참조형은 null이 될 수 있었습니다. 따라서 String! 형식을 String?에 대입하는 것은 문제가 없지만, String 형에 대입할 때는 주의가 필요합니다.

```
val str:String = Utility.returnStringJava() // IllegalStateException이 일어난다
```

(실제로는 null인) String!을 null을 허용하지 String에 대입하고 있습니다. 이 코드는 대입하려고 한 순간에 IllegalStateException가 발생하지요.

Platform Type 그대로 취급하는 경우에도 주의가 필요합니다.

```
val str = Utility.returnStringJava() // 유추되어 str은 String! 타입
println(str.length) // NullPointerException
```

이 코드는 컴파일 에러는 아니지만, NullPointerException가 발생했어요.

정리하면,

「Xyz!라고 쓰여 있는 타입은 Java에서 온 참조형인 Platform Type. Nullable한 Xyz? 타입으로도 다룰 수 있고, 비 Nullable 한 Xyz 형으로도 다룰 수 있다. Xyz으로 취급할 경우 예외가 발생할 수 있다」

또한 여기에서는 설명을 생략했지만 「(Mutable)Collection!」이라는 `Platform Type`도 있습니다. 이 설명은 다음 기회에.

## Kotlin도 NullPointerException이 발생한다

「Kotlin은 null로부터 안전」이라고해도 Java로 정의된 메소드의 Kotlin에서의 사용 방법을 잘못 사용하면 `NullPointerException`이나 `IllegalStateException`이 발생합니다.

어떤 때에 발생하는가 확인합시다.

### IllegalStateException이 발생할 수 있는 비 Nullable 형식에 대입

비 Nullable 형식으로 선언 한 변수에 null을 대입하면, 대입하는 순간에 `IllegalStateException`이 발생합니다.

Java에서 String 형을 반환하는 `Utility#returnStringJava`,

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```

를 Kotlin에서 다음과 같이 사용하면

```
val str:String = Utility.returnStringJava()
```

대입한 순간에 `IllegalStateException`이 발생합니다.

```
Exception in thread "main" java.lang.IllegalStateException: Utility.returnStringJava() must not be null
```

### NullPointerException이 발생할 수 있는 Platform Type 타입의 멤버 접근

PlatformType의 타입에서 내용이 null인 경우의 멤버 접근에서 「`.`」을 사용한 경우 `NullPointerException`이 발생합니다.

Java에서 String 타입을 반환하는 `Utility#returnStringJava`,

```
public class Utility {
    public static String returnStringJava() {
        return null;
    }
}
```

를 Kotlin에서 다음과 같이 사용하면

```
val str = Utility.returnStringJava() // Platform Type로서 취급된다
println(str.length) // 이 시점에 NullPointerException
```

멤버 접근하는 `str.length`에서 `NullPointerException`이 발생합니다.

```
Exception in thread "main" java.lang.NullPointerException
```

## Java의 타입을 Nullable · NotNull 지정

이전에서 설명한 대로, Java로 정의된 메소드를 Kotlin에 호출했을 경우, 잘못 사용하면 `NullPointerException`이나 `IllegalStateException`이 throw 될 수 있습니다.

이것을 피할 수 없을까요? Java로 정의된 메소드를 Kotlin 측에 「이것은 null을 돌려줄지도 모르니깐 Nullable 타입으로 취급 주세요!」라고 전달되면 좋을 것 같네요.

이것은 `Nullable 어노테이션`을 사용하는 것으로 가능합니다.

### Nullable 어노테이션

다음과 같이 Java 메소드를 `org.jetbrains.annotations.Nullable`을 달아 정의합니다.

```
@Nullable
public static String returnStringJavaNullableAnnotation() {
    return null;
}
```

이를 Kotlin 쪽에서 사용합니다.

```
// String? 타입으로 유추된다
val str = Utility.returnStringJavaNullableAnnotation()
println(str?.length)

// 컴파일 에러
// println(str.length)
```

Java에서 `@Nullable` 어노테이션이 붙은 `Utility#returnStringJavaNullableAnnotation`의 반환 값 타입은 Kotlin에서 String? 타입입니다. (String! 타입이 아닙니다.) 따라서 str은 String? 으로 유추됩니다.

String? 타입이므로 멤버 접근시에는 「`?.`」를 사용하지 않으면 안 됩니다. 「`.`」는 컴파일 에러가 발생합니다.

다음과 같이 String? 라고 타입을 명시적으로 쓸 수 있습니다.

```
// String? 으로 타입을 명시적으로 적어도 OK
// val str : String?= Utility.returnStringJavaNullableAnnotation()
```

`Utility#returnStringJavaNullableAnnotation`의 반환 값은 String? 타입이므로 String 타입에 대입할 수 없습니다.

다음 코드는 컴파일 에러가 발생합니다.

```
// 컴파일 에러로 Type Mismatch
// val str: String = Utility.returnStringJavaNullableAnnotation()
```

이처럼, Java의 null을 반환할지도 모르는 Java 메소드에 `Nullable 어노테이션`을 부여해 두는 것으로, Kotlin 측에서 Nullable 형식으로 다룰 수 있는 것이 가능합니다.

### NotNull 어노테이션

null일지도 모르는 `Nullable 어노테이션` 다음으로는 null이 아닌 것을 나타내는 `NotNull 어노테이션`입니다.

다음과 같이 Java 메소드를 `org.jetbrains.annotations.NotNull`을 달아 정의합니다.

```
@NotNull
public static String returnStringJavaNotNullAnnotation() {
    return "";
}
```

이를 Kotlin 쪽에서 사용합니다.

```
// String 타입으로 유추된다
val str = Utility.returnStringJavaNotNullAnnotation()
println(str.length)
// ?. 로도 적을 수 있지만, 필요 없다는 경고가 나온다
// println(str?.length)
```

Java로 [@NotNull](http://qiita.com/NotNull) 어노테이션이 붙은 `Utility#returnStringJavaNotNullAnnotation`의 반환 값 타입은 Kotlin에서 String 타입입니다. (String! 타입이 아닙니다.) 따라서 str은 String라고 유추됩니다.

String 타입이므로 「`.`」로 멤버 접근할 수 있습니다. 「`?.`」라고 적을 수 있지만, 경고가 나옵니다.

다음과 같이 String이라고 타입을 명시적으로 쓸 수 있습니다.

```
// String이라고 타입을 명시적으로 적어도 OK
val str : String = Utility.returnStringJavaNotNullAnnotation()
```

Kotlin에서 String 타입의 인스턴스를 Sting? 변수에 대입가능 한 것처럼, `Utility#returnStringJavaNotNullAnnotation`의 반환 값을 String? 타입의 변수에 대입할 수도 있습니다.

```
// String 타입의 인스턴스를 Sting? 변수에 대입 가능하므로 다음도 OK
val str: String? = Utility.returnStringJavaNotNullAnnotation()
```

그런데 `@NotNull` 어노테이션이 붙은 메소드가 null을 반환할 경우, `IllegalStateException`이 throw 됩니다.

### 많이있을거야, Nullable · NotNull

조금 전

- `org.jetbrains.annotations.Nullable`
- `org.jetbrains.annotations.NotNull`

을 소개했습니다.

그런데, 독자 여러분은 Nullable과 NotNull 듣고 다른 어노테이션을 상상하지 않았습니까?

Android이나 Lombok, FindBugs 같은 여러 SDK 및 Tool · 라이브러리에 Nullable · NotNull 어노테이션이 존재합니다.

조금 전 소개 한

- `org.jetbrains.annotations.Nullable`
- `org.jetbrains.annotations.NotNull`

이 아니더라도 이후에 말하는 어노테이션을 사용하면 같은 효과를 얻을 수 있습니다.

`org.jetbrains.annotations.Nullable`와 같은 효과를 얻을 수 어노테이션 목록

- org.jetbrains.annotations.Nullable
- android.support.annotation.Nullable
- com.android.annotations.Nullable
- org.eclipse.jdt.annotation.Nullable
- org.checkerframework.checker.nullness.qual.Nullable
- javax.annotation.Nullable
- javax.annotation.CheckForNull
- edu.umd.cs.findbugs.annotations.CheckForNull
- edu.umd.cs.findbugs.annotations.Nullable
- edu.umd.cs.findbugs.annotations.PossiblyNull

`org.jetbrains.annotations.NotNull`과 같은 효과를 얻을 수 어노테이션 목록

- org.jetbrains.annotations.NotNull
- edu.umd.cs.findbugs.annotations.NonNull
- android.support.annotation.NonNull
- com.android.annotations.NonNull
- org.eclipse.jdt.annotation.NonNull
- org.checkerframework.checker.nullness.qual.NonNull
- lombok.NonNull

당신이 사용하고 있는 SDK 및 Tool 안의 Nullable, NotNull을 꼭 사용해보세요.

이것은 향후 늘어날 가능성도 있습니다. [공식 문서](https://kotlinlang.org/docs/reference/java-interop.html#nullability-annotations)와 [소스 코드](https://github.com/JetBrains/kotlin/blob/master/core/descriptor.loader.java/src/org/jetbrains/kotlin/load/java/JvmAnnotationNames.kt)를 참고해주세요.

## 메서드 오버라이드는?

Java에서 정의된 인수 없이 반환 값 String를 가지는 메소드를 Kotlin에서 사용하는 예를 봤습니다. 그러나 실제 개발에서 많은 것은 SDK에 정의되어있는 Java 클래스를 상속하는 것입니다.

여기에서는 그 경우를 살펴보겠습니다.

Java로 다음과 같은 클래스를 정의합니다.

```
public class Bundle {}
```
```
public class MyActivity {
    public void onCreate(Bundle savedInstanceState){
    }
}
```

Kotlin에서 이 MyActivity를 상속하여 onCreate 메소드를 오버라이드합니다.

이러한 작성도 가능하며,

```
class MyKActivity : MyActivity(){
    override fun onCreate(savedInstanceState: Bundle) {
        super.onCreate(bundle)
    }
}
```

이러한 작성도 가능합니다.

```
class MyKActivity : MyActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(bundle)
    }
}
```

차이는 onCreate 인수가 Bundle 타입이 Bundle? 타입이라는 점이지요.

인수가 Bundle 타입으로 쓸 경우, savedInstanceState가 null 이었다면, IllegalStateException가 throw 됩니다.

Java의 MyActivity을 다음과 같이 변경합니다.

```
public class MyActivity {
    public void onCreate(@Nullable Bundle savedInstanceState){
    }
}
```

이렇게 `@Nullable`을 부여한 경우

```
class MyKActivity : MyActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(bundle)
    }
}
```

실제로 [android.support.v7.app.AppCompatActivity#onCreate](https://developer.android.com/reference/android/support/v7/app/AppCompatActivity.html#onCreate(android.os.Bundle)) 인수 savedInstanceState에 `@Nullable`가 부여되어 있습니다. 따라서 Bundle?라고 밖에 쓸 수 없습니다.

## 마지막으로

본 글에서는 『【!는 뭐야】 Kotlin과 Java, null과 PlatformType 【Nullable에 NotNull】』 라는 제목으로 Java와 Kotlin의 상호 운용성의 포인트가 되는 Platform Type을 소개했습니다.

- 왠지모르게 ?를 달았었다
- !가 뭔지 궁금했다
- 왜 Bundle! 이라고 쓸 수 없는 것일까
- NotNull과 Nullable 어노테이션의 소중함에 눈치채지 못했다

라는 분들의 이해에 도움이 되었으면 합니다.

## 참고

- [공식 문서 : Calling Java code from Kotlin](https://kotlinlang.org/docs/reference/java-interop.html)
- [슬라이드 : Kotlin과 Java와 null의 가벼운 이야기 by RyotaMurohoshi](https://speakerdeck.com/ryotamurohoshi/kotlintojavatonullfalseraitonahua)
- [블로그 포스트 : Kotlin M9에서 추가된 Platform Type 이야기 by ngsw_taro](http://taro.hatenablog.jp/entry/2014/10/16/233702)