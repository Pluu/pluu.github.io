---
layout: post
title: "[번역] DroidKaigi 2017 ~ 해부 Kotlin ~ 바이트코드를 이해하자 ~"
date: 2017-10-02 22:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 解剖Kotlin ~バイトコードを読み解く](https://speakerdeck.com/sys1yagi/jie-pou-kotlin-baitokodowodu-mijie-ku) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 해부 Kotlin ~ 바이트코드를 이해하자 ~

DroidKaigi 2017 03.09 

Room3 15:10~ 

Toshihiro Yagi

## 2p, About Me

- Toshihiro Yagi (@sys1yagi) 
- cookpad -> tokubai <img src="https://tokubai.co.jp/assets/themes/bargain_shops/pc_tokubai_logo_header@2x-a9a7d0af695fda0e6509a841be5261cbb3233d1e296cfa9be1c1109871b5b1e3.png"/>
- Androidエンジニア, 技術部長

## 3p

tokubai

## 4p

슈퍼 게재 점포수 No.1

## 5p, 식품 업종 이외에도 전개

- 드럭 스토어
- 홈 센터
- 클리닝
- 균일 쇼핑

## 6p, 식품 업종 이외에도 전개

100% Kotlin

## 7p

즐거운 장보기를 하자

## 8p

Kotlin 하고 있나요?

## 9p

Java에 비해 편리한 것은 알겠지만, 그래도 뭐 별로 Java를 사용하고 크리티컬로 곤란한 것도 아니고 ~ 학습 비용이나 팀에 도입 비용을 생각하면 거기까지 좋다고 느껴지지도 않고 ~

## 10p, 본 세션의 목적

- Kotlin 컴파일러가 생성한 Java 바이트 코드를 읽는 것으로 Kotlin이 해주는 일을 이해
- Kotlin을 쓸 때 Java라면 어떻게 되어있을까 생각할 수 있게된다. 스스로 확인할 수 있게 된다
- Kotlin을 사용함으로써 생략한 보일러 boilerplate 코드가 가독성을 어떻게 높이고 설계에 영향을 주는지에 대한 이미지가 솟는다

## 11p

최종적으로 아셨으면 하는 것

## 12p

음, Java로 하면 이런 느낌이구나

## 13p

Kotlin 간단하고 편리하네

## 14p

Kotlin 해볼까~

## 15p, 본 세션의 어프로치

- Kotlin의 특정 언어 기능에 대해 간략하게 설명한다
- 언어 기능을 사용한 코드를 디컴파일하고 결과보기
- Java로 쓸 때와 비교해 무엇을 해주고 있는지를 본다

## 16p ~ 19p, 디컴파일 방법

Tools > Kotlin > Show Kotlin Bytecode

## 20p, 아젠다 전편

- nullable 타입
- 함수형과 람다식
- 확장함수
- 프로퍼티

## 21p, 아젠다 후편

- 설계에 미치는 영향
   - nullable 타입
   - 확장함수

## 22p

nullable 타입

## 23p, nullable 타입이란

nullable 타입은 파라매터, 변수, 반환값이 null이 될 수 있는지 여부를 명시적으로 선언하는 기능

```
val name:String? = null
```

? : 타입 끝에 ?를 붙이는 것으로 선언할 수 있다

## 24p, nullable 타입이란

한편으로 비 null 타입은 null을 대입할 수 없다. 변수, 파라매터, 반환값이 비 null 타입이라면, 값이 반드시 비 null이라는 것을 보증한다

```
val name:String = "Hello"   // OK
val name:String = null   // Error

fun toString() :String   // 반환값이 비 null이라는 것을 보증한다
```

## 25p, nullable 타입이란

- nullable 타입은 그대로 사용할 수 없다

```
str.length   // 컴파일 에러가 된다
```

## 26p, nullable 타입이란

- nullable 타입에 대해서 안전한 호출과 위험한 호출을 선택한다

```
// null이라면 무시한다
str?.length

// null의 경우 NullPointerException
str!!.length
```

## 27p, nullable 타입이란

- 변수, 반환값을 비 null 타입으로 하는 것으로 함수내에서는 로직에 집중할 수 있다

```
fun semitransparent(view: View) {
   view.alpha = 0.5f
}
```

View: 함수내에서 view가 null이 아니라는 것을 보증한다

## 28p, nullable 타입이란

- null의 경계에 위반되면 컴파일러가 알려준다

```
val text: View? = findViewById(R.id.text)
semitransparent(text)
```

Type missmatch로 컴파일 에러

## 29p, nullable 타입이란

위험한 호출은 위험하므로 고쳐야 한다라는 것을 알 수 있다

```
val text: View? = findViewById(R.id.text)
semitransparent(text!!)   // 위험한 호출. 개선 신호
```

## 30p, nullable 타입이란

위험한 호출은 위험하므로 고쳐야 한다라는 것을 알 수 있다

```
val text: View? = findViewById(R.id.text) 
text?.let { semitransparent(it) }   // null이 아니면 실행
```

## 31p

nullable 타입은 Java에서 어떻게 실현되어 있는가?

## 32p ~ 33p

```
val nonNull: String = ”nonNull”	
nonNull.length
```
↓ Java로 되는것뿐
```
String nonNull = “nonNull";	
nonNull.length();

```

## 34p ~ 35p

```
val nullable: String? = null
nullable?.length
```
↓
```
String nullable = (String)null;	

if(nullable != null) {
   nullable.length();
} 
```
null 체크가 추가된다

## 36p ~ 37p

```
nullable!!.length
```
↓
```
if(nullable == null) {
   Intrinsics.throwNpe();
}
nullable.length()
```

null이라면 예외를 throw

## 38p ~ 39p

```
fun length(text: String) = text.length
```
↓
```
public final int length(@NotNull String text) {
   Intrinsics.checkParameterIsNotNull(text, “text");
   return text.length();
}
```

파라매터가 null이라면 예외를 throw

## 40p, nullable 타입이 하는 것

- `?.`라면 null 체크를 추가한다
- `!!`라면 null 체크와 예외 throw를 추가한다
- 함수 파라매터가 비 null 타입이라면 사전조건 체크를 추가한다
- 결국 null 체크가 필요한 곳에 null 체크를 자동으로 넣어준다

## 41p

함수 타입, 람다식

## 42p, 함수 타입이란

- 퍼스트 클래스 객체. 함수를 변수에 대입하거나 함수의 인수로 하거나 반환하거나 가능하다

```
val onClick: (View) -> Unit   // 인수에 View를 받고, 반환값이 없는 함수를 나타낸다
```

## 43p, 함수 타입이란

- Higher-Order Functions을 작성할 수 있다

```
fun calc(a: Int, b: Int, op: (Int, Int) -> Int): Int {
   return op(a, b)
}
```

## 44p, 람다식이란

- 함수 리터럴. 함수 타입 구현을 식으로써 작성할 수 있다

```
calc(1, 2, { a, b -> a + b })
```

-> (Int, Int) -> Int 타입을 그대로 작성할 수 있다

## 45p, 함수 타입과 람다식

- 강력한 처리를 간결하게 작성할 수 있다

```
listOf(1, 2, 3)
   .filter { it % 2 == 0 }
   .map { it * 2 }   // 4
```

## 46p

함수 타입과 람다식은 Java로 어떻게 실현되고 있는지?

## 47p ~ 48p

```
val onClick: (View) -> Unit
```
↓
```
@NotNull
private final Function1 onClick;   // 정확하게는 Function1<View, Unit>
```

## 49p

```
public interface Function1<in P1, out R> : Function<R> {
   public operator fun invoke(p1: P1): R
}
```

Function1은 단순한 인터페이스

함수 타입은 인수의 수에 따라 FunctionN으로 변환된다

## 50p ~ 52p

```
calc(1, 2, { a, b -> a + b })
```
↓
```
calc(1, 2, (Function2)null.INSTANCE);
```
컴파일러가 람다식을 정적이라고 판단한 경우는 싱글톤 클래스를 생성한다

## 54p ~ 58p

```
final class call$1 extends kotlin.jvm.internal.Lambda implements Function1 {   // Lambda를 상속
   public call$1() {
      super(2);   // 인수의 갯수를 부모 클래스에 전달
   }
   public final int invoke(int a, int b) {   // Function2를 구현
      return a + b;
   }
   public final static $call$1 INSTANCE = new call$1();	   // 싱글톤
} 
```
수동으로 고치면 이런 느낌

## 59p ~ 60p

```
val seed = 10
calc(1, 2, { a, b -> a + b + seed }
```
↓
```
final byte seed = 10;
calc(1, 2, (Function2)(new Function2(2) {
   public final int invoke(int a, int b) {
      return a + b + seed;
   }
}));
```
클로저의 경우는 무명 클래스를 생성한다

## 61p ~ 62p

```
var seed = 10
calc(1, 2, { a, b -> seed++; a + b })
```
↓
```
final IntRef seed = new IntRef();
seed.element = 10;
calc(1, 2, (Function2)(new Function2(2) {
   public final int invoke(int a, int b) {
      int var3 = seed.element++;
      return a + b;
   }
})); 
```
캡쳐한 변수를 변경하는 경우는 Ref 클래스가 사용된다

## 63p, 합수 타입, 람다식이 하는 것

- 함수 타입을 인수 개수에 따라 FunctionN 인터페이스로 변환
- 람다식을, Lambda를 상속하고 FunctionN을 구현하는 클래스로 변환
- 람다식의 내용에 따라 최적의 코드를 생성
- 기본적으로 retrolambda와 jack 등의 Java8 람다식 지원과 같은 방식으로 함수 타입을 실현해준다. 차이점은 클로저가 좀 더 유연한 정도이다

## 64p

확장 함수

## 65p, 확장 함수란

- 기존 클래스에 대해 새로운 함수를 추가할 수 있는 기능

```
fun Int.reversed(): Int {
   return toString().reversed().toInt()
}
```

## 66p, 확장 함수란

- 대상 클래스의 인스턴스에서 추가된 함수를 호출할 수 있게 된다

```
334017.reversed()   // 710433
```

## 67p ~ 68p, 확장 함수란

- 장황하게 긴 처리를 확장 함수에 정리하거나 책임을 추가할 수 있다

```
context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
```
↓
```
context.getWindowService()
```

## 69p

확장 함수는 Java로 어떻게 실현되고 있는지?

## 70p ~ 71p

```
fun Context.getWindowService() = getSystemService(Context.WINDOW_SERVICE) as WindowManager
```
↓
```
@NotNull
public static final WindowManager getWindowService(@NotNull Context $receiver) {
   Intrinsics.checkParameterIsNotNull($receiver, “$receiver");
   Object var10000 = $receiver.getSystemService(“window");
   if(var10000 == null) {
      throw new TypeCastException("null cannot be cast to non-null type android.view.WindowManager”);
   } else {
      return (WindowManager)var10000;
   }
}
```

## 72p

```
fun Context.getWindowService() = getSystemService(Context.WINDOW_SERVICE) as WindowManager
```
↓
※ 싱글톤으로 한 것

```
public static final WindowManager getWindowService(Context $receiver) {
   Object var10000 = $receiver.getSystemService(“window");
   return (WindowManager)var10000;
}
```
대상 클래스를 첫 인수로 받는 정적 함수가 생성된다

## 73p ~ 74p

```
context.getWindowService()
```
↓
```
ExtensionsKt.getWindowService(context)
```
여기는 확장 함수를 정의한 클래스에 의존한다

## 75p, 확장 함수가 하는 것

- 대상 클래스를 첫 인수에 받는 정적 함수를 생성
- 확장 함수 호출을 정적 함수의 호출로 변환
- 내부적으로는 정적 함수를 모은 Util 클래스와 같다. 대상 클래스에 책임을 추가한 것처럼 보이도록 하고 있다

## 76p

프로퍼티

## 77p, 프로퍼티란

- 클래스가 가진 데이터로서 선언한다. 필드의 대체로 사용

```
class Product(val id: Int, var name: String)
```

## 78p, 프로퍼티란

- 코드상에서는 직접 프로퍼티에 접근하는 것처럼 보이지만, 암묵적으로 accessor를 가지고 있다

```
val product = Product(1, “tomato")

val id = product.id
product.name = "meat"
```

## 79p, 프로퍼티란

- 커스텀 accessor를 구현할 수 있다

```
class Product(val id: Int) {
   var name: String = ""
      get() = field
      set(value) {
         field = value
      }
}
```
프로퍼티 accessor는 반드시 accessor를 거친다. accessor 내에서만 접근가능한 Backing Field 라는 실체가 있다.

## 80p

프로퍼티는 Java로 어떻게 실현되고 있는지?

## 81p ~ 85p

```
class Product(val id: Int, var name: String)
```
↓
```
private final int id;
@NotNull   // private인 field가 선언된다
private String name;

public final int getId() {   // val의 경우 getter만 생성된다
   return this.id;
}

@NotNull
public final String getName() {   // var의 경우 getter/setter가 생성된다
   return this.name;
}
public final void setName(@NotNull String var1) {
   Intrinsics.checkParameterIsNotNull(var1, “<set-?>");
   this.name = var1;
}
```

## 86p ~ 87p

```
val id = product.id
product.name = "meat"
```
↓
```
int id = product.getId();
product.setName("meat");
```

## 88p, 프로퍼티가 하는 것

- 필드와 accessor를 자동 생성
- 프로퍼티 액세스를 accessor 호출로 변환
- 동작으로는 lombok에 가깝다. 외형은 직접 액세스이지만 반드시 accessor를 통해서 호출된다. 또한 equals와 hashCode를 구현해주는 데이터 클래스 등이 있다

## 89p

여기까지 정리

## 90p, 여기까지 정리

- Java로 보면 그리 어려운 것은 하고 있지 않다
- 약간의 코드 생성을 대신하는 것으로 간결한 작성을 도와주고 있다
- 언어 기능을 모두 포함하면 상당한 양의 코드를 절감할 수 있게된다

## 91p

설계에 미치는 영향

## 92p

nullable 타입

## 93p

null 체크를 추가하고 처리를 건너뛰거나 예외를 throw 하는 것뿐인 간단한 구조이지만 단지 그것만으로 설계에 영향이 있는것일까?

## 94p

@Nullable, @NonNull을 활용하거나 null 체크를 제대로 구현하면 되지 않나??

## 95p ~ 97p

```
fun semitransparent(view: View) {
   view.alpha = 0.5f
} 
```
함수내에 view가 비 null이라는 것을 보증한다

```
val text: View? = findViewById(R.id.text)
semitransparent(text)   // Type missmatch로 컴파일 에러
```

## 98p

```
fun semitransparent(view: View) {
   view.alpha = 0.5f
}
```
```
val text: View? = findViewById(R.id.text)
semitransparent(text!!)   // 위험한 호출. 개선 신호
```

## 99p ~ 101p

```
fun semitransparent(view: View) {
   view.alpha = 0.5f
}
```
```
val text: View? = findViewById(R.id.text) 
text?.let { semitransparent(it) }
```

null이 아니면 실행 

-> 왠지 장황하고, 애초에 null의 경우는 가정하고 있지 않은가?

-> DataBinding이나 Kotlin Android Extensions 이용을 검토

## 102p

```
fun semitransparent(view: View) {
   view.alpha = 0.5f
}
```
```
semitransparent(binding.text)
```
nullable 타입이 나타나는 곳을 줄여주는 것으로, null 대해 안전한 범위가 퍼져간다

## 103p, nullable 타입이 설계에 미치는 영향

- null에 관한 계약을 언어 수준에서 대행해 준다. 그로 인하여 null의 경계의 설계에 집중할 수 있다
- null의 경계가 코드상에 가시화되므로 설계 개선의 재료가 된다
- 비 null의 영역을 넓혀가는 것으로, 가독성 및 변경 용이성이 향상되고 null 안전으로 된다

## 104p

확장 함수

## 105p

각각의 함수의 구현 자체는 매번하지 않으면 안되고, 결국 정적 함수 호출을 바꿀 뿐이고 의미있어??

## 106p

정적 함수를 모은 Util 클래스들을 적절하게 운용하면 좋지 않나??

## 107p ~ 108p

```
val id = intent.getIntExtra("id", -1)
```
이 Intent 매개 변수가 필수인지 여부가 여기서는 읽을 수 없다

## 109p

```
inline fun <reified T> Intent.getRequired(key: String): T {
   extras?.get(key).let {
      if (it !is T) {
         throw IllegalArgumentException("$key")
      }
      return it
   }
}
```
key가 없는 경우 예외를 throw하는 getRequired 함수를 Intent에 추가

## 110p ~ 111p

```
val id:Int = intent.getRequired("id")
```
Intent 자체에 필수값을 추출하는 책무를 추가함으로써 의도가 분명한 호출이 가능하다

## 112p, 확장함수가 설계에 미치는 영향

- 대상 클래스가 가지는 편이 좋다고 생각되는 책무를 실제로 대상 클래스에 갖게 하는 것이 가능하다.
- 기존의 클래스를 나중에 확장할 수 있기 때문에 플랫폼의 사정으로 가독성이 희생될 수 있는 부분을 제거하고 본래 있어야할 모습으로 생각되는 상태에 접근해 나간다

## 113p, 전체 정리

- Kotlin은 Java
- boilerplate 코드를 언어의 뒤로 숨기는 것으로 정말 만들어야 하는 부분에 집중할 수 있게 되었다
- null의 경계의 설계, 책임을 추가하여 가독성 향상 등 언어 기능이 소프트웨어 전체의 설계 개선에 기여하고있다

## 114p

Let’s enjoy Kotlin!

## 115p, 아직도 있는 Kotlin 기능

- Delegated Properties
- Operator Overload
- Companion Objects
- Singleton
- when식
- Coroutines
- Type aliases
- Reified Type Parameter
- Data Class
- Named Arguments
- Smart Casts
- Destructuring Declaration
- Local Function
- Tail recursive functions
- lateinit
- 인스턴스 함수 참조 etc...

## 116p

이 앞은 당신의 눈으로 확인해줘!

## 117p

THANK YOU