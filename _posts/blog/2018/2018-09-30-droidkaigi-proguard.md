---
layout: post
title: "[번역] DroidKaigi 2018 ~ 왠지 모르게 움직이는 Proguard에서 탈출하기 위해"
date: 2018-09-30 21:45:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ なんとなく動いているProGuardから脱出するために](https://docs.google.com/presentation/d/1r53A3Qr4j7GetCaq7LbvVSFKlPdKdCvn4M08AWM16N8/edit#slide=id.p) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 왠지 모르게 움직이는 Proguard에서 탈출하기 위해

DroidKaigi 2018

Sato Shun

## 2p

서론

## 3p, Proguard는 힘들다

- 설정 파일이 어렵다 (잘 모르겠다)

```properties
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

- Release Build로 Proguard를 유효로 하면 수많은 Compile/Runtime Error

## 4p, 외워야 하는 것이 많다

단, 빈번한 패턴이 있고, 그 패턴 몇 가지를 이해하면 의외로 어떻게든 된다.

- 문제가 발생해도 Proguard의 움직임, 노하우에 맞춰보면 납득할 수 있는게 대부분 (내가 알아본 바로는)

## 5p, 본 세션의 목적

Proguard의 기본적인 움직임과 UseCase를 보면서 Proguard를 깊게 이해하는 것

## 6p

그런데 정말로 Proguard는 필요한가?

## 7p, Proguard 장점

코드 사이즈 축소/Method 수 축소

- 메모리 사용량 감소
- MultiDex를 사용하지 않고 끝 (날지도)
- Instant App 4MB 제한

→ 구체적으로 어느 정도 삭제 가능한가?

## 8p, 실제 사례: DroidKaigi 2018

Before (2 dex files)

- classes: 8600 + 3319 = 11919
- methods: 54219 + 19113 = 73332
- dex size: 3.5 + 1.3 = 4.8MB

After (1 dex file)

- classes: 7312
- methods: 40389
- dex size: 2.48MB

## 9p, 실제 사례 : Ameba Blog 앱 (담당 앱)

Before (3 dex files)

- classes: 8402 + 8514 + 6368 = 23284
- methods: 52260 + 53648 + 37456 = 143364
- dex size: 3.7 + 3.2 + 2.3 = 9.2MB

After (2 dex file)

- classes: 8890 + 7523 = 16413
- methods: 53237 + 38572 = 91809
- dex size: 3.2 + 1.8 = 5.0MB

## 10p

Proguard 구조/기능

## 11p ~ 12p, shrink(삭제)와 obfuscate(난독화)가 중요 (어려운 부분)

![https://www.guardsquare.com/files/media/guardsquare2016/Website/ProGuard/ProGuard_build_process_b.png](https://www.guardsquare.com/files/media/guardsquare2016/Website/ProGuard/ProGuard_build_process_b.png)

[https://www.guardsquare.com/files/media/guardsquare2016/Website/ProGuard/ProGuard_build_process_b.png](https://www.guardsquare.com/files/media/guardsquare2016/Website/ProGuard/ProGuard_build_process_b.png)

## 13p, 삭제와 난독화

- 삭제(shrink)
  - 설정한 EntryPoint로부터 모든 미참조 Class, Member를 삭제
- 난독화(obfuscate)
  - Class, Member 명의 이름 변경 처리
    - ex, class User → class a
    - ex, getUserByName → a

## 14p, EntryPoint

![https://cdn-images-1.medium.com/max/1600/0*Y0tJVDd5RnFy_qUL.](https://cdn-images-1.medium.com/max/1600/0*Y0tJVDd5RnFy_qUL.)

[https://cdn-images-1.medium.com/max/1600/0*Y0tJVDd5RnFy_qUL.](https://cdn-images-1.medium.com/max/1600/0*Y0tJVDd5RnFy_qUL.)

## 15p

어떻게 EntryPoint 혹은 난독화 유무를 지정하는가

## 16p, 삭제, 난독화를 방지하는 Keep Rule

|                                           | 삭제/난독화 무효          | 난독화 무효                   |
| ----------------------------------------- | ------------------------- | ----------------------------- |
| Class, Member                             | -keep                     | -keepnames                    |
| Member                                    | -keepclassmembers         | -keepclassmembernames         |
| Member가 존재할 경우의<br />Class, Member | -keepclasseswithmemembers | -keepclasseswithmemembernames |

## 17p

Android에서 구체적인 UseCase

## 18p

사례 1 : OkHttp

## 19p, 공식 OkHttp Proguard

```properties
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

## 20p, OkHttp Proguard Rule

```properties
-dontwarn
-keepnames
```

2 종류의 Rule을 지정하고 있다

## 21p

이것들을 Proguard를 지정하지 않은 경우

## 22p

[https://docs.google.com/presentation/d/1r53A3Qr4j7GetCaq7LbvVSFKlPdKdCvn4M08AWM16N8/edit#slide=id.g2e4857ce54_0_153](https://docs.google.com/presentation/d/1r53A3Qr4j7GetCaq7LbvVSFKlPdKdCvn4M08AWM16N8/edit#slide=id.g2e4857ce54_0_153)

## 23p, Warning 지옥

100줄 이상 Warning 이 나온다

하지만 Warning 을 보면 can't find referenced class Class 명 뿐이다

> can't find referenced class?

## 24p, can't find referenced class Nullable?

javax.annotation.Nullable이 참조 불가능하므로 Warning이 나온다

- Nullable Annotation이 참조 불가능?

## 25p, 왜 Nullable이 참조 불가능한가?

- Nullable Annotation은 findbugs:jsr305에 엮여있다
- OkHttp에는  findbugs:jsr305를 provided로 의존관계를 지정하고 있다
- provided 지정한 경우, 최종적으로 jar에는 포함되지 않는다
- jar에 포함되지 않으므로 사용한 쪽에서 참조할 수 없다
- Warning:  Can't find referenced class

## 26p, 왜 provided 지정인가?

- JAR에 포함하면 좋을텐데?
- Nullable 등은 IDE, 사람에게 Hint를 위한 Annotation
  - Runtime시에는 필요 없으므로 JAR에 포함할 필요가 없다. 오히려 포함하지 않는 편이 좋다

## 27p, 결론

- javax.annotation.Nullable은 Runtime시에 필요 없으므로 참조 불가능하므로 문제없다
- 이 Warning은 무시해도 괜찮다는 것을 알았다

## 28p, dontwarn Rule

Warning을 무시하는 Rule

```properties
-dontwarn javax.annotation.Nullable
↓
-dontwarn javax.annotation.**
```

javax.annotation Pacakge 아래에 대한 Warning을 모두 무시한다

## 29p

```properties
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
```

를 지정해 Warning이 사라지고 무사히 컴파일이 통과된다

## 30p, 아직 Rule을 지정

```properties
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

컴파일은 통과하지만 Document에는 위와 같이 필요하다고 적혀있다

- 이건 정말로 필요한가?

## 31p, keepnames Rule

지정한 Class, Member를 낙독화하지 않는다

okhttp3.internal.publicsuffix.PublicSuffixDatabase

↓

~~a.a.a.p~~

와 같이 낙독화되는 것을 방지

## 32p, 왜 이 Class를 낙독화하면 안되는가?

PublicSuffixDatabase.java

```kotlin
PublicSuffixDatabase::class.java.getResourceAsStream("publicsuffixes.gz")
```

PublicSuffixDatabase Class의 상대 경로로부터 gz 파일을 읽고 있다 (gz 파일은 OkHttp jar에 포함된다)

## 33p, PublicSuffixDatabase가 난독화되면

- Class 경로가 a.a.a.p로 변경된다
- 하지만, gz파일이 있는 곳은 okhttp3.internal.publicsuffix 패키지 아래
- 상대 경로로 파일을 읽을 수 없다
  - gz 파일과 같은 패키지를 가질 필요가 있다

## 34p, Class 경로를 변경하면 안된다

```properties
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

난독화를 막고, Class 경로를 유지

- 무사히 gz 파일을 열 수 있다

## 35p

```properties
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

## 36p

사례 2 : moshi

## 37p, moshi 란?

- A modern JSON library for Android and Java
  - 비슷한 라이브러리로는 Gson 이나 Jackson 등
- serialize/deserialize Library + Proguard는 난항을 겪는 부분이 있다
  - Reflection 을 사용하는 곳이 많기 때문에

## 38p, 공식 moshi Proguard

```properties
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepclasseswithmembers class * {
    @com.squareup.moshi.* <methods>;
}
-keep @com.squareup.moshi.JsonQualifier interface *
```

## 39p, mocha 공식 Proguard Rule

```properties
-dontwarn
-keepclasseswithmembers
-keep
```

3종류의 Rule을 사용하고 있다

- dontwarn은 OkHttp와 같은 이유로 필요 (can't find referenced class)

## 40p, moshi: 샘플 코드

```kotlin
val moshi = Moshi.Builder()
	.add(ColorAdapter())
	.build()
val r = moshi
	.adapter(Rectangle::class.java)
	.fromJson("{\"width\":1,\"color\":\"#ff0000\"}")
```

## 41p, Proguard 적용 전

```kotlin
@Retention(AnnotationRetention.RUNTIME)
@JsonQualifier
annotation class HexColor

class Rectangle(
	@field:Json(name = "width") val w: Int,
    @field:HexColor @field:Json(name = "color") val c: Int
)

class ColorAdapter(
    @ToJson fun toJson(@HexColor rgb: Int): String {
        return String.format("#%06x", rgb)
    }
    @FromJson @HexColor fun fromJson(rgb: String): Int {
        return Integer.parseInt(rgb.substring(1), 16)
    }
)
```

## 42p, Proguard 적용 후

```kotlin
class Rectangle(
	@field:Json(name = "width") val w: Int,
    @field:Json(name = "color") val c: Int
)

class ColorAdapter(
)
```

+ +Class, Member 난독화

## 43p, 2가지 문제가 발생

1. ColorAdapter 멤버가 삭제된다
2. @HexColor가 삭제된다

이것은 Runtime시에 필요하므로 삭제되면 안된다

- 과잉으로 삭제되었다

## 44p, ColorAdapter 멤버가 삭제된다

- moshi에서는 @ToJson, @FromJson을 트리거로 Method를 호출한다
  - 직접 Java 코드상에서 Method 호출을 하지 않으므로 삭제된다
- @ToJson, @FromJson이 붙은 Method를 삭제되지 않도록 할 필요가 있다

## 45p ~ 46p

```properties
-keepclasseswithmembers class ColorAdapter {
	@com.squareup.moshi.ToJson <methods>;
	@com.squareup.moshi.FromJson <methods>;
}
```

↓

```properties
-keepclasseswithmembers class * {
	@com.squareup.moshi.* <members>;   
}
```

## 47p

~~@Retention(AnnotationRetention.RUNTIME)~~
~~@JsonQualifier~~
~~annotation class HexColor~~

class Rectangle(
​	@field:Json(name = "width") val w: Int,
​	~~@field:HexColor~~ @field:Json(name = "color") val c: Int
)

class ColorAdapter {
​	@ToJson fun toJson(~~@HexColor~~ rgb: Int): String {
​		return String.format("#%06x", rgb)
​	}
​	@FromJson ~~@HexColor~~ fun fromJson(rgb: String): Int {
​		return Integer.parseInt(rgb.substring(1), 16)
​	}
}

## 48p, @HexColor 삭제 문제

@HexColor는 Method, 필드에 붙어있을 뿐, Java 코드상에서 참조하지 않는다

→ 결과, Proguard가 삭제한다

→ 왜 삭제되는지 않겠나요?

## 49p, APK Analyzer

APK 내부를 분석하는 도구

![](https://developer.android.com/studio/images/build/apk-file-sizes_2x.png)

[https://developer.android.com/studio/build/apk-analyzer#load_proguard_mappings](https://developer.android.com/studio/build/apk-analyzer#load_proguard_mappings)

## 50p, APK Analyzer: Show Bytecode

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-09-30-proguard-01.png" }}" /> 

Method 정보에 FromJson Annotation 정보뿐이고 HexColor Annotation이 삭제된 것을 알 수 있다

> 해당 발표 자료의 이미지를 부분 캡쳐했습니다.

## 51p ~ 52p

```properties
-keep interface HexColor
```

↓

```properties
-keep @com.squareup.moshi.JsonQualifier interface *
```

JsonQualifier Annotation를 가진 모든 interface를 삭제/난독화하지 않는다

## 53p

```kotlin
@Retention(AnnotationRetention.RUNTIME)
@JsonQualifier
annotation class HexColor

class Rectangle(
	@field:Json(name = "width") val w: Int,
	@field:HexColor @field:Json(name = "color") val c: Int
)

class ColorAdapter {
	@ToJson fun toJson(@HexColor rgb: Int): String {
		return String.format("#%06x", rgb)
	}
	@FromJson @HexColor fun fromJson(rgb: String): Int {
		return Integer.parseInt(rgb.substring(1), 16)
	}
}
```

## 54p

```properties
-dontwarn okio.**
-dontwarn javax.annotation.** -keepclasseswithmembers class * {
@com.squareup.moshi.* <methods>;
}
-keep @com.squareup.moshi.JsonQualifier interface *
```

## 55p

사례 3 : Keep Annotation

## 56p, Keep Annotation

Class, Member에 붙이는 것으로 삭제, 난독화를 방지할 수 있다

```kotlin
@Keep
class User { ... }
```

어떻게 구현하고 있는가?

## 57p, Proguard Rule 만으로 구현하고 있다

- @Keep 용 Proguard Rule이 기본 pro guard-android.txt 에 포함되어 있다
  - Proguard keep Rule을 사용해 구현하고 있다
- @Keep을 위한 특별한 것은 별도로 하지 않았다!!

## 58p, @Keep을 위한 Rule

```properties
-keep class android.support.annotation.Keep
-keep @android.support.annotation.Keep class * {*;}
-keepclasseswithmembers class * {
	@android.support.annotation.Keep <methods>;
}
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <fields>;
}
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <init>(...);
}
```

## 59p

```properties
-keep class android.support.annotation.Keep
```

Keep Annotation을 삭제/난독화하지 않는다

## 60p

```properties
-keep @android.support.annotation.Keep class * {*;}
```

Keep Annotation이 있는 Class가 대상

Class, Member 삭제/난독화하지 않는다

## 61p

```properties
-keepclasseswithmembers class * {
	@android.support.annotation.Keep <methods>;
}
```

Keep Annotation이 있는 Method가 대상

Class를 난독화, Member를 삭제/난독화하지 않는다

## 62p

```properties
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <fields>;
}
```

Keep Annotation이 있는 Field가 대상

Class를 난독화, Field를 삭제/난독화하지 않는다

```properties
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <init>(...);
}
```

Keep Annotation이 있는 생성자가 대상

Class를 난독화, 생성자를 삭제//난독화하지 않는다

## 63p, @Keep을 위한 Rule

```properties
-keep class android.support.annotation.Keep
-keep @android.support.annotation.Keep class * {*;}
-keepclasseswithmembers class * {
	@android.support.annotation.Keep <methods>;
}
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <fields>;
}
-keepclasseswithmembers class * { 
	@android.support.annotation.Keep <init>(...);
}
```

## 64p

사례 4 : AAPT

## 65p

Activity나 View의 Keep Rule은 (거의) 자동생성된다

## 66p, AAPT

AAPT = Android Asset Packaging tool

- Android Manifest, Layout(Menu) XML을 해석해서 자동으로 Proguard Rule을 생성한다
  - Activity 등 Components, View에 대해서는 기본적으로 Proguard Rule 지정은 필요 없다

하지만 예외는 있다

## 67p, APPT가 대응하지 않는 사례

DroidKaigi 2018에서 Proguard 대응 PR

```
Process: io.github.droidkaigi.confsched2018.debug
b.h: null cannot be cast to non-null type
android.support.v7.widget.SearchView
at io.github.droidkaigi.confsched2018.presentation.search.c.a(SearchFragment.kt:135)
```

[https://github.com/DroidKaigi/conference-app-2018/pull/198#issuecomment-358142894](https://github.com/DroidKaigi/conference-app-2018/pull/198#issuecomment-358142894)

## 68p, v7.SearchView를 얻을 수 없다

```xml
<item
	android:id="@+id/action_search"
	android:title="@string/search_title"
	app:actionViewClass="....widget.SearchView"
	app:showAsAction="always" />
```

위 Menu Layout에서 SearchView를 참조하고 있다

## 69p, AAPT가 대응하지 않았다

AAPT 도구는 app:actionViewClass로 지정한 Class에 대해서 Proguard Rule을 생성해주지 않는다

- android:actionViewClass로 지정한 경우는 Proguard Rule을 생성해준다

## 70p, 이 사례는 회피 불가능

- Proguard는 무조건 어떤 문제가 일어난다
  - 문제가 일어난 경우에 처리를 위한 지식∙노하우가 필요

## 71p ~ 72p, 이 사례로 이야기하면

- Error Log에서 SearchView를 얻을 수 없다는 것을 알 수 있다
- Menu Layout에서 지정한 Class이므로 AAPT가 생성한 aapt_rules.txt를 보자
- SearchView의 Proguard가 생성하지않는다는 것을 확인
- 자동 생성해주지 않을 듯하므로, 스스로 적절히 Proguard Rule을 지정한다

## 73p, 혹은

- Error Log에서 SearchView를 얻을 수 없다는 것을 알 수 있다
- Android Studio의 APK Analyzer를 사용해 classes.dex 내부를 확인한다
- SearchView의 생성자가 사라진 것을 알 수 있다

## 74p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-09-30-proguard-02.png" }}" /> 

View에 필요한 생성자가 사라진 것을 알 수 있다

> 해당 발표 자료의 이미지를 부분 캡쳐했습니다.

## 75P

```properties
-keep class android.support.v7.widget.SearchView {
    <init>(...);
}
```

SearchView 의 모든 생성자를 삭제하지 않기 위한 Rule을 추가

## 76p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-09-30-proguard-03.png" }}" /> 

↓ 조금 전의 Proguard를 적용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/2018-09-30-proguard-04.png" }}" /> 

이 Rule을 지정하면 View에 필요한 생성자가 삭제되지 않은 것을 알 수 있다

> 해당 발표 자료의 이미지를 부분 캡쳐했습니다.

## 77p, 이 사례는 회피 불가능

- Proguard는 무조건 어떤 문제가 일어난다
  - 문제가 일어난 경우에 처리를 위한 지식∙노하우가 필요

## 78p, 정리

- Proguard는 기초, 구조를 어느 정도 알아두면 이외로 어떻게든 된다 (중요)
  - 그러나 무조건 어떤 문제가 발생하므로 당황하지 않을 마음이 필요
- keep Rule의 변화는 해나가면서 알아가는 것이 좋다고 생각한다
- Proguard를 사용해 최고의 앱 사이즈를 달성하자!!!!

## 79p, 결론 & 소개

- Sato Shun/佐藤 隼
- Twitter: [@stsn_jp](https://twitter.com/stsn_jp)
- Github: [satoshun](https://github.com/satoshun)
- Organization/소속: CyberAgent, inc.

## 80p

추가 tips

## 81p, 극단적인 사례: RxJava2

아래 코드만 사용

```kotlin
Observable.just(100)
	.map { it.toString() }
	.subscribe() 
```

## 82p, 극단적인 사례: RxJava2

(io.reactivex.** Method 개수)

- Before: 9186
- After: 113

대부분의 Class, Member를 사용하지 않으므로 대부분 삭제된다

## 83p, Proguard 출력 파일

- seeds.txt (Proguard Rule 분석 단계)
  - 대략 어떤 keep Rule에 매칭
- usage.txt (shrink 단계)
  - 삭제된 Class, Member 리스트
- mapping.txt (obfuscate 단계)
  - 난독화된 Class, Member 대응표
- dump.txt
  - Proguard 결과

## 84p, consumer proguard

라이브러리쪽에서 Proguard를 제공할 수 있다

ex. leakcanary

[https://github.com/square/leakcanary/blob/master/leakcanary-android/consumer-proguard-rules.pro](https://github.com/square/leakcanary/blob/master/leakcanary-android/consumer-proguard-rules.pro)

## 85p, R8

- Proguard File과 호환이 있다
- Proguard보다 코드 사이즈 삭제, 바이트코드 최적화가 기대된다