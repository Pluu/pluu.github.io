---
layout: post
title: "[번역] DroidKaigi 2016 ~ DroidKaigi 기존 Android 프로젝트에 Kotlin을 도입한 이야기"
date: 2016-07-09 23:20:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 既存のAndroidプロジェクトに Kotlinを導入した話](https://speakerdeck.com/boohbah/number-droidkaigi-ji-cun-falseandroidpuroziekutoni-kotlinwodao-ru-sitahua) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

기존 Android 프로젝트에 Kotlin을 도입한 이야기

#DroidKaigi #DroidKaigiB Jumpei Yamamoto

## 2p

**자기소개**

- Yamamoto Jumpei
- Sansan 주식회사 Eight 사업부
- Eight의 Android 앱 개발

- twitter: @boohbah
- github: [https://github.com/yamamotoj](https://github.com/yamamotoj)

## 3p

**Android로 Kotlin 스터디 @Sansan**

2016년 1월 15일 Kotlin 에반젤리스트인 타로씨를 초대했습니다!

## 4p

**Kotlin 1.0**

Programming Language for JVM and Android

제2회 Kotlin 스터디 @Sansan 3/23 개최결정!!

## 5p

**이야기할 내용**

Sansan사의 Eight앱에서의 개발사례를 예로서 Kotlin을 기존 Java 프로젝트에 도입할 때에 배웠던 것을 이야기합니다.

## 6p

**Agenda**

- Eight 소개
- 자사 앱에 Kotlin 도입 경위, 실제 기록
- 사용해서 좋았던 부분
- 힘들었던 부분
- Java 환경과 잘 공존하기 위한 Tips

## 7p ~ 8p

**Eight**

2015년 Google Play Store에 베스트 앱으로 선정되었다! (2년 연속)

## 9p

**Eight Android 앱**

- 2012년부터 계속 개발
- 2주간 ~ 1개월 간격으로 신기능 릴리즈
- 2015년 8월부터 Kotlin 도입
- 앱 내의 Kotlin 비율은 약 15%

|  | Files | Total Lines |
| :- | :- | :- |
| Java | 429 | 68527 |
| Kotlin | 140 | 10687 |

## 11p

도입 경위

## 12p

**도입 계기**

- 전직은 iOS 개발로 Swift 메인
- 애초에 Java 코드에 불만
  - 표준 문안(Boilerplate)이 많다
  - Null 안전하지 않다
  - 형 추론되지 않는다
  - RxJava으로 무명 클래스가 괴롭다
- 프로젝트 멤버가 이미 Kotlin을 사용하기 시작하고 있다

## 13p

**첫 커밋**

- 샘플 구현 프로젝트로 시험 도입
- Java -> Kotlin으로 변환
- 도입 시에 증가되는 apk의 사이즈는 823KB(1.0.0 현재)

```
class SampleClass {
  val name; String? = null
}
```

## 14p

- Kotlin 첫 커밋 (8/27)
- 2번째 커밋 (10/5)
- 처음 Activity (10/20)
- 본격적인 Kotlin화 (11/M)
- 신규 코드는 전부 Kotlin

손을 대기 시작하고서 궤도에 오르기까지 2-2.5개월

## 15p

**도입 시작 멤버의 반응**

- 처음에는 Kotlin에 엉거주춤
- 무심코 익숙한 Java로 쓰게된다
- 리뷰에 시간이 걸린다

시작은 힘들지만 사격하면서 전진!!

## 16p

**도입 추진력**

- 개인 흥미
  - 매력에 깨닫기에는 이르다
  - m13에서 sealed class 도입으로 할 마음이 생겼다
- 리뷰에 의한 지식 공유
  - Kotlin의 편리한 기능을 안다 -> 게다가 Kotlin에 흥미가 나타난다
- iOS 엔지니어한테도 반응이 좋다
  - Swift와 비슷하므로 iOS 엔지니어라도 리뷰하기 쉽다
  - 구현 지식을 Android / iOS로 공유 가능하다

## 17p

좋았던 부분

## 18p

**Java**

Ave. 160lines / File

## 19p

**Kotlin**

Ave. 76lines / File

## 20p

압도적인 효율과 안정성

## 21p

**코드 리뷰가 효율적**

- 만드는 기능에 대해 코드량이 적다
- 표준 문안(Boilerplate)이 쓰기 때문에, 코드상에서 읽어야 할 항목이 알기 쉽다
- 코드상에 냄새가 나는 부분이 부각되기 쉽게 된다
  - 왜 var를 사용하고 있는가?
  - Single expression으로 쓰지 못하는 메소드는?
  - !!를 사용하고 있는 부분

## 22p

함정에 빠진 부분

## 23p

**버전 업에 관한 문제**

- 어느 정도 메이저 버전 업 직후는 문제가 생기는 일이 많았다
  - 0.13.1513 <- 앱이 시작 안되는 중대한 문제
  - 0.13.1514 <- 직후에 마이너 버전 업
- 갑자기 Proguard에서 에러가 발생

## 24p

**SNAPSHOT 버전 지정 문제**

```
compile 'com.jakewharton:kotterknife:0.1.0-SNAPSHOT'
```

- 버전에 SNAPSHOT이 지정된 경우, 같은 버전에서도 다른 라이브러리가 릴리즈 가능.
- 사용하는 측에서도 항상 최신 라이브러리를 사용한다.
- 자동으로 다운로드

## 25p

**JitPack**

JVM / Android 라이브러리의 특정 커밋을 얻어서 jar을 빌드해서 배포해주는 서비스

```
allprojects {
  repositories {
    ...
    maven { url "https://jitpack.io" }
  }
}

dependencies {
  compile 'com.github.JakeWharton:kotterknife:36ae5d5ecb'
}
```

## 26p

**Kotlin 1.0**

Programming Language for JVM and Android

## 27p

함정에 빠진 라이브러리

## 28p

**kotterknife**

Jake Wharton씨가 작성한 view injection 라이브러리 Kotlin 버전 Butter Knife

```
class MainActivity : AppCompatActivity() {
  val textView: TextView by bindView(R.id.textView)

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)
  }
}
```

## 29p

**Fragment에서는**

```
class MyFragment : Fragment() {
  // View에서 재생성되어도 재생성전의 View가 남는다
  val textView: TextView by bindView(R.id.textView)

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // retainInstance = true를 하면 화면이 회전했을 때에는 Fragment 인스턴스는 해방되지 않고 View가 재생성된다
    retainInstance = true
  }

  override fun onCreateView(
    inflater: LayoutInflater?,
    container: ViewGroup?,
    savedInstanceState: Bundle?): View? {
      return inflater?.inflate(R.layout.fragment_main, container, false);
  }
}
```

## 30p

**Kotter Knife에서는 issue 등록된 상태**

[https://github.com/JakeWharton/kotterknife/issues/5](https://github.com/JakeWharton/kotterknife/issues/5)

## 31p

**kapt**

- Kotlin Annotation Processing Tool
- Kotlin상에서 Pluggable Annotation Processing API (JSR 269)를 사용해서 구현된 라이브러리 사용 시에 필요하다
- Kotlin의 소스에 부여된 Annotation을 해석한다
- Kotlin에서 Annotation으로 생성된 코드를 참조할 수 있도록 한다
- DataBinding 라이브러리와의 상성이 나빠 도입 안되어 있다
- 현재 Annotation으로 생성된 클래스에의 참조는 Java에서만 참조 가능하다

## 32p

Java와 Kotlin의 공존

## 33p

**Kotlin은 100% Java 호환**

- Kotlin 코드는 전부 Java에서 참조 가능하다.
- Java 코드도 Kotlin에서 참조 가능하다.
- Kotlin 코드를 Java에서 참조시에 쓸 수 있는 Annotation
  - @JvnStatic
  - @JvmField
  - @Field:JvmName("name")
  - @JvmOverrides

## 34p

**@JvmField**

```
class Bar {
  val name = "name"
  @JvmField val password = "password"
  companion object {
    val staticName = "name"
    @JvmField val staticPassword = "password"
  }
}
```

```
// Java
Bar bar = new Bar();
String name = bar.getName();
String password = bar.password;
String staticName = Bar.Companion.getStaticName()
String staticPassword = Bar.staticPassword
```

## 35p ~ 36p

**Parcelable**

```
class MyParcelable(var name: String) : Parcelable {
  protected constructor(src: Parcel) : this(src.readString())

  override fun describeContents(): Int = 0
  override fun writeToParcel(dest: Parcel, flags: Int) {
    dest.writeString(name)
  }

  companion object {
    @JvmField
    val CREATOR: Parcelable.Creator<MyParcelable> =
            object : Parcelable.Creator<MyParcelable> {
              override fun createFromParcel('in': Parcel): MyParcelable {
                return MyParcelable('in')
              }
              override fun newArray(size: Int): Array<MyParcelable?> {
                return arrayOfNulls(size)
              }
            }
  }
}
```

## 37p

**@file:JvmName()**

```
// KotlinExtensions.kt
@file:JvmName("StringUtil")

fun String.prepend(str:String) = str + this

"Kotlin".prepend("Hello! ") // -> Hello! Kotlin
```

```
// Java

StringUtil.prepend("Kotlin", "Hello! ");
// > Hello! Kotlin
```

## 38p

Null 안전과 Java

## 39p

**Null safety**

```
val nullable: String? = null // Null을 대입할 수 있다
val nonNull: String = "string" // Null을 대입할 수 없다
val nonNull: String = null // 컴파일 에러
```

notNull한 파라매터에 null을 대입하려고 하면 컴파일 에러

## 40p

**Kotlin관련의 crash원인 TOP**

Parameter specified as non-null is null;

non-null으로 지정된 변수가 null

## 41p

**사실은 Java에서 넘겨진 변수**

```
// Java
public class Hoge {
  public String getString() {
    return null;
  }
}
```

String!은 String으로도 String?으로도 참조 가능하다

## 42p

**@Nullable / @NotNull Annotation**

```
// Java
public class Hoge {
  @NonNull
  public String getString() {
    return "hoge";
  }

  @Nullable
  public String getNullable() {
    return null;
  }
}
```

```
// Kotlin
var hoge = Hoge()
val s0:String? = hoge.nullable
val s2:String = hoge.nullable // @Nullable Annotation을 붙이는 것으로 Kotlin에서 NonNull한 프로퍼티로 받고자 한다면 컴파일 에러
```

## 43p

**하지만**

Java에서는 @NonNull Annotation을 붙인 프로퍼티가 null을 반환해도 정적 체크에 걸려도 에러는 안되므로 주의.

```
// Java

public class Hoge {
  @NonNull
  public String getString() {
    return null;
  }
}
```

## 44p

**정리**

- 축 Kotlin 1.0.0 !
- 힘들었던 것의 대부분은 버전 업에 따른 문제였다
- 지금 Java 프로젝트를 하는 사람이라도 안심하고 Kotlin을 도입할 수 있다
