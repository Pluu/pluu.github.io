---
layout: post
title: "[번역] DroidKaigi 2018 ~ Kotlin Anti-Pattern"
date: 2018-02-15 22:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ Kotlinアンチパターン](https://www.slideshare.net/RecruitLifestyle/kotlin-87339759) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Kotlin Anti-Pattern

Naoto Nakazato @DroidKaigi2018

## 2p, 자기소개

- Naoto Nakazato
   - Android 개발 경력 7년 정도
- Recruit Lifestyle
   - 2017년6월〜
   - HOT PEPPER Beauty
- Account
   - Twitter: @oxsoft
   - Facebook: naoto.nakazato
   - GitHub: oxsoft
   - Qiita: oxsoft

## 3p, Kotlin과 Android

평소 앱 개발에 Kotlin 사용하고 있습니까?

## 4p, Kotlin과 Android

2017년 5월에 Google I/O에서 공식 지원이 발표된 Kotlin

Java보다도 심플하고 안전한건 틀림없지만

- 다양한 작성 방법이 있어 고민 🤔
- 사용에 따라서는 버그가 발생할지도 😱

## 5p, Kotlin과 Android

공식 문서에 "문법"은 적혀있지만, 그 외에 "Anti-Pattern" 같은 것도 있을 것 같다

이 세션에서는 30분에 10가지 소개합니다!

## 6p

오늘 이야기할 것

## 7p

그 전에 ......

## 8p, Hot Pepper Beauty

Hot Pepper Beauty는 국내 최대의 살롱 검색·예약 서비스

헤어 미용실 이외에도 네일, 숙눈썹, 기분전환, 전신미용이 있습니다

## 9p, Android 앱

| 2010년 | Android 앱 릴리즈 |
|   | 점점 비전 (秘伝) 이 짙어짐 😂 |
| 2016년 05월 | 전체 리뉴얼 결정 💪 |
| 2017년 02월 | 전체 Kotlin으로 방침 전환 |
| 2017년 12월 | 리뉴얼 버전 릴리즈 🎉 |

## 10p, 오늘 이야기할 것

Kotlin에서 Android 앱을 개발하면서 느낀 Anti-Pattern

- 이미 출시된 `거대한` 앱의 전체 리뉴얼
- 멤버의 Android 개발 경험이 `다양`
- 최대 11 명이라는 `대규모` 팀 개발

제품 및 개발 멤버에 의해 장단점이 있을 것

→ 부스에는 실제 소스 코드를 전시하고 있기 때문에, 개발 멤버와 토의하러 오세요!

## 11p, 오늘 이야기할 것

이번에는 Anti-Pattern을 10가지 말하지만, 각각 다음의 4가지 구성으로 이야기하려고 합니다

- 언어기능 설명
- 안티 패턴
- 무엇이 좋은가?
- 해결책의 사례

Kotlin을 평소 사용하고 있는 사람은 "언어기능 설명"은 듣지 않아도 됩니다

## 12p

#01 lateinit와 null 초기화

## 13p, 언어기능 설명 ~ lateinit란

Java에서는 초기화가 없는 변수선언은 null 등이 들어간다

```
TextView message; // null이 들어간다
```

Kotlin에서는 기본적으로 초기값을 적어야 한다

```
var message: TextView // error 가 된다
var message: TextView? = null // OK
```

## 14p, 언어기능 설명 ~ lateinit란

Android 에서는 onCreate 이후에 초기화되는 것이 많다

실질적으로 NonNull 인것이 전부 Nullable이 되어버린다

```
var message: TextView? = null

fun clear() {
   message!!.text = "" // 이상하다
   message?.text = "" // 귀찮다
}
```

## 15p, 언어기능 설명 ~ lateinit란

여기서 lateinit를 사용하면 선언시에 초기값을 넣지 않아도 된다

```
lateinit var message: TextView // OK
```

하지만 값을 대입하지 않은 상태에서 값을 참조하면 UninitializedPropertyAccessException가 던져진다

## 16p, 언어기능 설명 ~ lateinit 사용처

인스턴스 생성시에는 값이 정해지지 않지만, onCreate와 onCreateView에서 대입되는 것

예를 들면,

- findViewById한 View
- DataBinding의 binding
- Dagger등의 DI에 따른 inject 되는 것

그러나, Primitive 타입이나 Nullable에는 사용할 수 없다

## 17p, Anti-Pattern

통신 후에 얻을 수 있는 정보를 lateinit로 한다

```
lateinit var profile: Profile

fun init() {
   fetchProfile().subscribe { profile ->
      this.profile = profile
   }
}
```

## 18p, 뭐가 좋지않은가

사전에 리스너를 설정하는 경우에 통신 중이나 통신 오류시 접근시 UninitializedPropertyAccessException

```
button.setOnClickListener {
   textView.text = profile.name
}
```

## 19p, 해결책 사례

Nullable로 해서 항상 "정보 미취득시 어떻게 할 것인가"를 생각하게 한다

```
var profile: Profile? = null
fun init() {
   fetchProfile().subscribe { profile ->
      this.profile = profile
   }
}
```

## 20p, 해결책 사례

onCreate / onCreateView 에서 초기화 가능

→ lateinit 로 괜찮음

그 이후에서 값이 결정

→ Nullable 로 한다 or 멤버 변수로 하는 것을 피한다

## 21p, 부록 ~ isInitialized

Kotlin 1.2부터 isInitialized가 추가되어 값이 대입되어 있는가를 확인할 수 있다

```
lateinit var str: String

fun foo() {
   val before = ::str.isInitialized // false
   str = "hello"
   val after = ::str.isInitialized // true
}
```

## 22p, 부록 ~ isInitialized

원래는 테스트 코드에서의 이용을 생각해 추가되었다

이를 일상적으로 사용하면 더 이상 null 안전하지 않게 되므로 프로덕션 코드에서의 사용은 피하는 것이 좋다

```
private lateinit var file: File

@After
fun tearDown() {
   // 파일 작성전에 faile로 하면 에러가 된다
   file.delete()
}
```

> 참고 : [https://youtrack.jetbrains.com/issue/KT-9327](https://youtrack.jetbrains.com/issue/KT-9327)

## 23p

#02 Scope 함수

## 24p, 언어기능 설명 ~ Scope 함수

let/run/also/apply/with 5개가 있지만, with을 제외하면 대략 아래와 같이 분류할 수 있다

```
반환값 = 자신.Scope함수 {
   리시버.method()
   결과
}
```

|   | it | this |
| :---: | :---: | :---: |
| 결과 | let | run |
| 자신 | also | apply |

## 25p, 언어기능 설명 ~ 사용처 1

null 관련 제약에 편리

```
str?.let {
   // str이 null이 아닌 경우
}


val r = str ?: run {
   // str이 null인 경우
}
```

## 26p, 언어기능 설명 ~ 사용처 2

초기화 처리를 정리

```
val intent = Intent().apply {
   putExtra("key", "value")
   putExtra("key", "value")
   putExtra("key", "value")
}
```

## 27p, Anti-Pattern

apply 내에서 프로퍼티 접근 형식의 처리를 적는다

```
val button = Button(context)
button.text = "hello" // Java읭 setText(...)가 호출된다
// ... button 설정이 이어진다 ...
```

↓ apply를 사용해 처리를 정리하자!

```
val button = Button(context).apply {
   text = "hello"
   // ... button 설정이 이어진다 ...
}
```

## 28p, 무엇이 안좋은가

로컬 변수를 정의하면, 액세스 포인트가 바뀐다

```
fun init() {
   var text = "" // 나중에 이 행이 추가되면……
   val button = Button(context).apply {
      text = "hello"
   }
   button.text // "hello"가 되지 않는다！
}
```

## 29p, 해결책 사례 1

apply 내에서는 프로퍼티 접근 형식을 사용하지 않고, 일반적의 함수 호출로 한다

```
val button = Button(context).apply {
   setText("hello")
}
```

하지만, 로컬 변수가 정의되어 있으면 같은 문제가 발생한다

## 30p, 해결책 사례 2

this 필수인 규칙으로 한다

```
val button = Button(context).apply {
   this.text = "hello"
}
```

also와 닮은듯한 느낌이 된다

## 31p, 해결책 사례 3

apply 금지 (also를 사용)

```
val button = Button(context).also {
   it.text = "hello"
}
```

저희 팀에서는 let과 also 만으로 한정

## 32p

#03 Nullable과 NonNull

## 33p, 언어기능 설명 ~ Nullable과 NonNull

Nullable / NonNull 은 Kotlin의 큰 매력 중 하나

```
val nullable: String? = null // OK
val nonNull: String = null // NG

nullable.length // NG
nullable!!.length // OK
nullable?.length // OK
nonNull.length // OK
```

## 34p, Anti-Pattern 1

Nullable 그대로 데이터를 이용한다

```
data class User(
   val id: Long? = null,
   val name: String? = null,
   val age: Int? = null
)
```

API --Nullable--> Domain --Nullable--> UI

## 35p, 무엇이 안좋은가 1

Nullable 데이터를 이용하면 쓰이는 곳에서 null 체크나 safe call 하게 된다

```
retrun team?.user?.name?.length
```

- → 실질적으로 조건 분기가 늘고 거동 파악이 어려워진다
- → "null 뭐였지?" 를 매번 생각하게 된다

## 36p, Anti-Pattern 2

모두 NonNull 로 하기위해 무효한 데이터를 넣는다

```
val response = ...

return User(
   id = response.id ?: 0L
   name = response.name.orEmpty(),
   age = response.age ?: 0
)
```

## 37p, 무엇이 안좋은가 2

모두 NonNull 로 하기 위해서 무효한 데이터를 넣으면

```
if (user.name.isNotEmpty()) {
   // ↑ 어렵다 or 잊어버린다
}
```

- → 무효한 데이터인가 아닌가 체크하게 된다
- → 체크를 잊어 표시 오류가 생긴다

## 38p, 해결책 사례

"null이 무엇을 표시하는가" 로 처리하는 레이어를 정한다

- API가 전달해주지 않으니 null → API 레이어에서 처리
- 사용자가 설정하지 않으니 null → UI 레이어에서 처리
- 명백하지 않고 레이어를 넘나드는 → 클래스에서 명확화

데이터 표현으로 어려운 경우, 쉽게 null 에 의지하지 않는다 (예외를 던진다, 다른 클래스로 한다 등)

## 39p

#04 data class

## 40p, 언어기능 설명 ~ data class 란

- equals/hashCode이나 toString 를 올바르게 override
- componentN이나 copy등의 메소드를 생성

```
data class User(val name: String, val age: Int)

val alice = User("Alice", 27)
alice == User("Alice", 27) // true
alice.toString() // "User(name=Alice, age=27)"
val (name, age) = alice
val nextYear = alice.copy(age = 28)
```

## 41p, Anti-Pattern

인스턴스 생성용 메소드로 제약을 보증하고 싶다

```
data class Range(val min: Int, val max: Int) {
   companion object {
      fun getRange(a: Int, b: Int): Range {
         return Range(minOf(a, b), maxOf(a, b))
      }
   }
}
```

## 42p, 무엇이 안좋은가

data class 에는 copy 메소드가 생성된다

→ 임의 데이터를 가지는 인스턴스가 생성 가능

```
val range = Range.getRange(3, 5)
val illegal = range.copy(max = 0)
```
↑ Range(min=3, max=0) 이 되고 제약이 무너진다

## 43p, 해결책 사례

값이 정해져 있으니깐 data class로는 하지 않는다

"값의 내부 표현" == "클래스에 기대되는 동작"

- → 값의 정리에 이름을 붙이는 것뿐
- → data class

"값의 내부 표현" != "클래스에 기대되는 동작"

- → 일반적인 클래스로 좋다

## 44p

#05 interface와 abstract class

## 45p, 언어기능 설명 ~ interface 의 기본 구현

Kotlin에서는 interface에 기본 구현이 가능하다

Java 8에도 있는 기능이지만, Android에서 사용하기 위해서는 minSdkVersion 을 24 이상으로 할 필요가 있다

```
interface Downloadable {
   fun download() {
      // 공통 처리 등
   }
}
```

## 46p, 언어기능 설명 ~ abstract class와 무엇이 다른가?

|   | interface | abstract class |
| :---: | :---: | :---: |
| 상태 | 가질 수 없다 | 가질수 있다 |
| 상속 | Interface 만 | class와 Interface |
| 다중 상속 | 가능 | 불가능 |

|   | default method | class method |
| :---: | :---: | :---: |
| final | 불가능 | 가능 |
| protected | 불가능 | 가능 |

## 47p, Anti-Pattern

Java 시절부터 알려져 있던 Anti-Pattern으로 처리를 공통화시 Base 클래스를 비대화시킨다

```
abstract class BaseActivity : AppCompatActivity() {
   protected fun showNetworkError() {
      // 에러 표시 (에러가 없는 페이지도 있는데...)
   }
}
```

## 48p, 무엇이 안좋은가

몇천줄 레벨인 부모 클래스가 되고, 감당하지 못하게 된다

## 49p, 해결책 사례

Java에서는 "상속보다도 이양" 등으로 말해왔다

Kotlin에서는 인터페이스의 Default 구현도 좋을 것 같다

```
interface NetworkErrorView {
   // 에러용 View와 리로드 처리는 자식 클래스에서 준비
   val networkErrorView: View
   fun onClickReload()

   fun showNetworkError() {
      // 리스너 설정, 에러 표시등의 공통 처리
   }
}
```

## 50p, 해결책 사례

물론 "Base Class = 나쁘다" 이지 않다

abstract 클래스가 유효한 사례

- onCreate 등의 상속 부분에서 처리를 공통화하고 싶다
- 클래스밖에서 호출되고 싶지 않다
- 자식 클래스에서 override 하고 싶지 않다

## 51p, 해결책 사례

Default 구현이 유효한 사례

- 이전에 서술한 것 이외로, 처리를 공통화시키고 싶은 경우
- 다중 상속하고 싶은 경우

상태를 가지고 싶은 경우도, class delegation을 사용하면 된다

```
class UserModel() : DefaultImpl by State() { ... }
class UserModel(s: State) : DefaultImpl by s { ... }
``` 

## 52p, 상태를 가지면서, 일부 처리는 자식 클래스에서 구현시키고 싶은 경우

```
interface IState {
   var state: String
}
```
```
interface DefaultImpl : IState {
   fun abstract(): String
   fun default() { ... }
}
```
```
class State : IState {
   override var state: String = ""
}
```
```
class UserModel : DefaultImpl, IState by State() {
   override fun abstract(): String {
      return "concrete"
   }
}
```

상태를 인터페이스로 나눠, 상태를 구현한 클래스를 준비한다

## 53p

#06 Top Level 함수와 확장 함수

## 54p, 언어기능 설명 ~ Top Level 함수

파일에 직접 함수를 적을 수 있다

```
fun throwOrLog(t: Throwable) {
   // 개발은 Crash, 실제는 로그 전송
}
```

이렇게 하면 어디에서도 호출할 수 있다

```
fun foo() {
   throwOrLog(e)
}
```

## 55p, 언어기능 설명 ~ 확장함수

클래스에 함수를 추가(하는 것처럼 보이게)할 수 있다

```
fun Any?.log() {
   Log.d("DEBUG", this.toString())
}
```

여기저기에서 호출할 수 있게 된다

```
fun foo() {
   123.log()
   "hello".log()
}
```

## 56p, Anti-Pattern 1

일반적이지 않은 · 국소적으로밖에 쓰이지 않는 메소드를 추가한다

```
fun String.decorate() =
   "＿人人人人人＿\n" +
   "＞　$this　＜\n" +
   "￣Y^Y^Y^Y^Y￣"
```

↑ "decorate" 의 의미가 넓고, 문자폭도 고려되어 있지 않다

## 57p, Anti-Pattern 2

공식으로 있을 것 같은 이름인데 엉성하게 구현

```
fun String.isInteger() =
   this.all { it in '0'..'9' }
```

↑ 공백 문자나 음수가 고려되어 있지 않다

## 58p, 무엇이 안좋은가

확장함수가 편리해서 난발하기 쉽다

라이브러리보다도 버그가 있을 가능성이 높다

Java에서 Util 클래스를 마구 만드는 것과 비슷한 문제이지만, Kotlin 이면 통상적인 함수같이 보이므로 피해가 크다

개발 멤버가 많으면 특별히 문제가 없다

## 59p, 해결책 사례

팀 내에서 확장 함수를 만드는 기준·감각을 갖춘다

Interface의 Default 구현으로 scope를 한정 지은다

```
interface BookmarkableActivity {
   fun bookmark() {
      // 공통 Bookmark 처리
   }

   fun String.toLabel() = "★ $this"
}
```

## 60p

#07 lazy와 custom getter

## 61p, 언어기능 설명 ~ lazy 란

최초 접근시에 값이 계산되고 이후는 그 값을 반환, delegated property 의 하나

```
private val userId by lazy {
   intent.getStringExtra("USER_ID")
}
```

## 62p, 언어기능 설명 ~ 통상 대입과 custom getter

- 통상 대입은 `인스턴스 생성시`에 계산된다

```
val isAdmin = userId == ADMIN_ID
```

- lazy는 `최초에 접근시`에 계산된다

```
val isAdmin by lazy { userId == ADMIN_ID }
```

- custom getter는 `접근이 있을 때마다` 계산된다

```
val isAdmin get() = userId == ADMIN_ID
```

## 63p, Anti-Pattern

통상 대입, lazy, custom getter를 애매하게 구분

## 64p, 무엇이 안좋은가

Crash 하거나

```
private val button = findViewById<Button>(R.id.button)
```

오래된 값을 반환하거나

```
val area by lazy { width * height }
```

불필요한 계산을 여러번 실행한다 

```
val user: User get() = User(userId)
```

## 65p, 해결책 사례

값의 설징에 따라 적절히 구분한다

- 클래스 초기화에 값이 결정되고 불변 → 통상 대입
- 어느 시점을 지날때까지 값을 얻을 수 없지만, 불변 → lazy
- 상태가 바뀌면 값이 바뀐다 → custom getter

## 66p, 하는 김에 소개 ~ delegated property

property의 get(과 set)을 다른 클래스에 위임할 수 있다

```
var userId: String by MyClass()
```

→ 보통의 값처럼 보여서 알기 쉽다

- Intent의 extra
- Fragment의 arguments
- savedInstanceState
- SharedPreferences
- FirebaseRemoteConfig

에 사용할 수 있다

## 67p, 하는 김에 소개 ~ delegated property 사용 사례

```
class Extra<out T> : ReadOnlyProperty<Activity, T> {
   override fun getValue(
      thisRef: Activity,
      property: KProperty<*>
   ): T = thisRef.intent.extras.get(property.name) as T
}
```
```
fun Intent.put(
   prop: KProperty1<*, String>, value: String
): Intent = this.putExtra(prop.name, value)
```

## 68p, 하는 김에 소개 ~ delegated property 사용 사례

```
class ProfileActivity : AppCompatActivity() {
   val userId: String by Extra()

   companion object {
      fun createIntent(context: Context, userId: String): Intent {
         return Intent(context, ProfileActivity::class.java)
                   .put(ProfileActivity::userId, userId)
      }
   }
}
```

많은 부분을 은폐할 수 있다

> 참고：[https://speakerdeck.com/sakuna63/kotlins-delegated-properties-x-android](https://speakerdeck.com/sakuna63/kotlins-delegated-properties-x-android)

## 69p

#08 Fragment와 lazy

## 70p, 언어기능 설명 ~ lazy 란 (재게)

최초 접근시에 값이 계산되고 이후는 그 값을 캐시해서 반환

```
private val userId by lazy {
   intent.getStringExtra("USER_ID")
}
```

## 71p, Anti-Pattern

(Anti-Pattern으로 유명하지만) Fragment의 View를 lazy 한다

```
val button by lazy {
   view!!.findViewById<Button>(R.id.button)
}
```

## 72p, 무엇이 안좋은가

Fragment에는 같은 인스턴스에 대해 onCreateView가 다시 불린다

↓

lazy이 처음의 view를 계속 유지하기 때문에, 다시 onCreateView 되어도 값이 업데이트되지 않는다

> 출처 : [https://developer.android.com/guide/components/fragments.html](https://developer.android.com/guide/components/fragments.html)

## 73p, 해결책 사례

lateinit 을 사용해 onCreateView로 대입한다

```
lateinit var button: Button

override fun onCreateView(...): View? {
   val view = ...
   button = view.findViewById(R.id.button)
   return view
}
```

DataBining 의 경우도 binding 자체는 lateinit이 좋다

## 74p

#09 custom getter

## 75p, 언어기능 설명 ~ custom getter 란

val 이나 var의 반환값은 커스터마이즈할 수 있다

문법상으로 인수가 없는 함수는 모두 custom getter로 가능하다

```
var userId: String = ""

val isAdmin get() = userId == ADMIN_ID
```

## 76p, Anti-Pattern 1

값을 취득하는 과정에 부작용이 있다

```
private val itemCount: Int
   get() {
      if (recyclerView.adapter == null) {
         initXXX() // 副作用
      }
      return recyclerView.adapter.itemCount
   }
```

## 77p, Anti-Pattern 2

계산량이 많다

```
private val total: Int
   get() = countView(root)

fun countView(view: View): Int = if (view is ViewGroup) {
   (0 until view.childCount).map {
      countView(view.getChildAt(it))
   }.sum()
} else {
   1
}
```

## 78p, 무엇이 안좋은가

호출측에서는 보통의 변수아 동일하게 보인다

그 때문에, 상태가 바뀌거나, 계산이 무거운것이 예측할 수 없고, 예상밖의 버그나 퍼포먼스 저하를 일으킬 수 있다

```
if (this.itemCount > 20) {
   // ↑ 와 같이 순진하게 접근해버린다
}
```

## 79p, 해결책 사례

- 부작용이 없고, 계산량이 적다 → custom getter
- 부작용이 있고, 계산량이 많다 → 함수

위의 분류로 구현하면 함수명보다도 명확하게 호출측이 부작용 유무나 계산량을 예상할 수 있다

> 공식 레퍼런스에도 같은 기술이 있다 [https://kotlinlang.org/docs/reference/coding-conventions.html#functions-vs-properties](https://kotlinlang.org/docs/reference/coding-conventions.html#functions-vs-properties)

## 80p

#10 custom setter

## 81p, 언어기능 설명 ~ custom setter 란

Kotlin 에는 통상 var을 커스터마이즈할 수 있다

```
var text: String = ""
   set(value) {
      field = value
      notifyDataSetChanged()
   }
```

## 82p, 언어기능 설명 ~ custom setter 사용처

- 값을 설정하는 김에 갱신 처리 등을 한다
- 변수 위임

## 83p, 언어기능 설명 ~ 변수 위임

멤버 변수의 위임을 간단하게 적을 수 있다 (이 경우는 Backing Field도 생성되지 않는다)

```
private val owner = Person()

var ownerName: String
   get() = owner.name
   set(value) {
      owner.name = value
   }
```

※ Backing Field : Java에 변환시에 생성되는 멤버 변수

## 84p, 언어기능 설명 ~ 변수 위임

물론 아래와 같이 적을수도 있지만, 약간 길다

```
private val owner = Person()

var ownerName: String by object : ReadWriteProperty<Any, String> {
   override fun getValue(thisRef: Any, property: KProperty<*>): String = owner.name
   override fun setValue(thisRef: Any, property: KProperty<*>, value: String) {
      owner.name = value
   }
}
```

## 85p, Anti-Pattern

항상 필요로 하지 않은 처리를 하고 있다

예: 값이 변경되면 XXX를 갱신해서 YYY에 알리고 ZZZ의 값도 갱신해서 ...

```
var person: Person = Person()
   set(value) {
      field = value
      updateXXX()
      notifyYYY()
      ZZZ = value.name
   }
```

## 86p, 무엇이 안좋은가

값만 변경할 수 없다 (비록 클래스안이라도)

반영이나 계산을 나중에 한번에 할 수 없다

값을 대입했을 뿐이라고 생각했지만 예상밖의 거동이 된다

## 87p, 해결책 사례

당연하지만 var의 책임은 값의 유지에 두어야 한다

var은 일반적으로 private로 가지고 있고, 갱신용 함수를 공개하는 Java의 패턴쪽이 혼란이 적은 케이스도 많다

## 88p

마지막으로 또 하나

## 89p, 마지막으로 또 하나만 ......

Kotlin의 기능을 억지로 사용하지 않도록 주의가 필요할지도

- operator overload
- infix
- tailrec       etc...

깨끗하게 적으면 무척 기분 좋지만, 실제 프로덕트에서 유효한 예는 그다지 않지 않다

특히 팀 개발에는 알기 쉬움도 중요

## 90p, 정리

Kotlin은 최고! 이지만 작성 방법의 자유도가 높다 → 팀 개발의 경우는 기준·감각을 자주 논의

먼저 이번에 이야기한 10가지의 테마로 🙄

→ 부스에는 실제 소스 코드를 전시하고 있기 때문에, 개발 멤버와 토의하러 오세요! 😆