---
layout: post
title: "[번역] DroidKaigi 2019 ~ `LiveData와 Coroutines로 구현하는 DDD 전술적 설계`에 대해서 이야기 했습니다"
date: 2019-05-16 23:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2019 ~ DroidKaigi 2019 で「LiveData と Coroutines で 実装する DDD の戦術的設計」について話してきました。](http://y-anz-m.blogspot.com/2019/02/droidkaigi-2019-livedata-coroutines-ddd.html) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

일부 이미지는 이해를 돕고자 한국어로 수정했습니다.

<!--more-->

- - -

[이전](https://y-anz-m.blogspot.com/2018/02/android.html), [전전회](https://y-anz-m.blogspot.com/2017/03/droidkaigi-2017_9.html)에 이어서 발표 원고와 함께 공개합니다

(강연에서는 애드립도 있으므로 원고와 약간 다르다는 것을 양해바랍니다.)

## 1p

> LiveData와 Coroutines로 구현하는 DDD 전술적 설계
>
> DroidKaigi 2019 @yanzm Anzai Yuki

여러분 안녕하세요. Anzai Yuki 입니다. Y.A.M 잡담록이라는 블로그를 적고 있습니다. Android Google Develoepr Experts도 하고 있습니다. 그리고, TechBooster 에서 Android 동인지를 적고 있습니다.

twitter id는 yanzm으로 yamuzamu 로 읽습니다. Anzai입니다. yamuzamu 이든 편한대로 불러주세요.

DroidKaigi에서 도메인 주도 설계를 다루는 것은 3번째입니다. 처음 들으시는 분들도, 지금까지 들으셨던 분들도 감사합니다. 

## 2p

> 지금까지의 복습

그럼, 시작합니다

먼저 지금까지의 복습을 해보겠습니다

## 3p

> 도메인 주도 설계는 무엇인가?
>
> 이전전의 이야기 → [bit.ly/2tbAOLP](bit.ly/2tbAOLP)

## 4p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.004.png" }}" />

도메인 주도 설계란

도메인 전문가의 말을 관찰하고 도메인을 구성하는 유비쿼터스 언어를 찾고,

그 다음으로 유비쿼터스 언어를 사용해 도메인을 적절하게 반영하고,

우리의 소프트웨어에 도움이 되는 도메인 모델을 만들고,

그리고 만든 도메인 모델을 정확하게 표현하도록 코드를 구현하고, 이를 반복해서 도메인 모델 과 구현 모두를 세련시켜나가는 설계 방법입니다.

## 5p

> 전략적 설계 / 전술적 설계

도메인 주도 설계에서는 실천하는 다양한 방법이 나옵니다. 이들은 주로 전략적 설계와 전술적 설계 2가지로 나눌 수 잇습니다

## 6p

도메인 모델을 만들어내는 데 도움되는 방법이 전략적 설계, 도메인 모델로부터 그것을 표현한 구현을 해나가는 방법이 전술적 설계입니다.

## 7p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.007.png" }}" /> 

전술적 설계의 유비쿼터스 언어, Bounded Contet, Context Map은 이전전에 이야기 했습니다

## 8p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.009.png" }}" /> 

도메인 주도 설계에서는 도메인 모델을 그대로 표현하도록 구현합니다.

궁극적으로는 코드를 읽으면 그 도메인 모델을 알 수 있고, 그 도메인 모델을 이해하고 있다면 엔지니어가 아니어도 대충 테스트 코드를 읽을 수 있는 상황입니다.

## 9p, 전술적 설계

> "이렇게 구현하면 제대로 도메인 모델을 표현했다"라는 구현 패턴
>
> - Value Object
> - Entity
> - Domain Service
> - Domain Event
> - Application Service
> - Factory
> - Repository
> - …

구체적으로 어떻게 도메인 모델을 그대로 표현해 구현하는가? 

그를 위해 이런 식으로 구현하면 제대로 도메인 모델을 표현할 수 있어요라는 구현 패턴이 전술적 설계입니다. 


여기에 일부 언급했습니다만, 전술적 설계로 많은 패턴이 소개되어 있습니다. 

이들을 모두 도입해야만 한다는 것은 아닙니다. 

오히려 하나도 도입하지않아도 도메인 모델을 잘 표현해서 구현할 수 있다면, 그것은 제대로 도메인 주도 설계입니다. 

## 10p

> 이전의 정리

이전은 무엇을 이야기했냐면

## 11p

도메인 주도 설계를 염두해 기존의 Android 앱을 리팩토링해서 좋았다는 전술적 설계 패턴을 소개했습니다.

## 12p ~ 14p

> 1. 도메인을 격리한다 → domain module
> 2. Value Object를 찾는다 →
>    - ID는 Value Object (UserId, ItemId, ProductId, OrderId, ...)
>    - 식별은 Value Object (종류, 유형, 선택지가 정해진 것)
>    - 날짜는 Value Object (요일, 시간, 기간)
> 3. Entity를 찾는다 → 동일성이 있는 것

"도메인 격리한다"라는 전술적 설계 패턴은 Android에서는 gradle 모듈로 분리하는 방법이 있고 모듈로 나누는 것으로 의존방향을 강제화 가능하고 도메인이 UI 등의 기타 다른 부분을 모르는 상태로 될 수 있습니다.

Value Object 이야기도 했습니다. 동일한 속성 값을 가지고 있다면 구별할 필요가 없는 모델은 Value Object로 표현합시다. 

문자열로 처리 요소가 Value Object가 아닌지 생각합시다.

ID, 종류, 유형, 날짜 및 크기 등은 Value Object를 도입하는 좋은 출발점입니다.

Entity에 대해서도 조금 이야기했습니다. 속성 값이 아니라 동일성으로 구별되는 것이 엔티티입니다. 

예를 들어, A씨와 B씨가 같은 야마다 타로라는 이름이라도 다른 사람으로 구별됩니다.

## 15p, 오늘 이야기할 것

여기까지가 복습입니다.

## 16p, 실제로 해봅시다!

> - 대상 도메인 : DroidKaigi 2019
> - 전제 조건
>   - 컨퍼런스 참가사용 Android 앱
>   - 마스터 데이터는 서버에 있다
>   - 앱은 서버와 API를 통해 데이터를 받는다
>   - API 포맷은 바뀌지 않는다

이번에는 강연 중에 실제로 모델링 및 구현을 생각해보고자 합니다. 

대상 도메인은 여러분과 관계있는 이 DroidKaigi 2019합니다. 

마스터 데이터는 서버에 있고, API를 통해 앱이 서버에서 데이터를 받고 그 API 사양을 변경할 수 없다는 가정입니다.

## 17p, 샘플 코드

> [github.com/yanzm/DroidKaigi2019](github.com/yanzm/DroidKaigi2019)

이후에 나오는 코드를 github에 공개했습니다.

## 18p, 전략적 설계

첫째, 전략적 설계의

## 19p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.023.png" }}" />

Context Map을 써 보았습니다. 

DroidKaigi 2019이라는 도메인에는 응모된 세션을 관리하고 스탭의 관리 등 컨퍼런스를 관리하는 문제 공간이 있습니다. 한편, 참가자가 컨퍼런스 정보를 열람하는 문제 공간도 있습니다. 

컨퍼런스를 관리하는 특정 솔루션으로 서버에서 어떤 구현이 있고 컨퍼런스 정보를 열람하기 위한 솔루션으로 Android 앱이 그것을 주고 받습니다. 

Android 앱은 서버와 주고 받는 사양을 바꿀 수 없기 때문에, 문맥의 통합의 관계는 Android가 Client가 됩니다. 

> 원문에서는 順応者라고 작성된 표현을 번역에서 Client로 표현했습니다.

## 20p, 전략적 설계

> - 대상 도메인 : DroidKaigi 2019
>   - 컨퍼런스 정보 열람
> - 해결 공간 : Android 앱 (Kotlin multiplatform project는 아니다)
> - 도메인 전문가 : 컨퍼런스 참가자 ・ 운영자
> - 서버와의 관계 : 앱이 Client

정리하면, 

DroidKaigi 2019라는 대상 도메인의 컨퍼런스 정보를 열람하는 문제에 대해 Android 앱이라는 솔루션을 생각합니다. 도메인 전문가는 컨퍼런스 참가자와 운영자입니다.

## 21p, 유비쿼터스 언어

다음으로 유비쿼터스 언어를 확인합니다.

## 22p, 유비쿼터스 언어를 찾기

> - 도메인 전문가의 언어, 대상 도메인에서 쓰여지는 언어
>   - → DroidKaigi 소식, Web 사이트 등을 확인

도메인 전문가는 컨퍼런스 참가자와 운영자이지만, 자신도 참가자이므로, 우선은 운영자의 말을 확인합시다. 

운영자에게 인터뷰하는 것이 가장 좋지만, 운영자는 바빠서 운영으로부터의 소식이나 Web 사이트의 말을 확인하겠습니다.

## 23p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.027.png" }}" />

스폰서, 시간표, 세션, 엔지니어, Android, 컨퍼런스, 개최 개요 등 

대충 정리하고 모델링합시다.

## 24p, 세션 모델링

컨퍼런스 정보를 열람하는 문제에 대해 가장 중요한 것은 역시 세션 정보일 것입니다. 

그러므로, 세션에 대해 생각합니다.

## 25p, 세션의 유비쿼터스 언어

> - 타이틀 : Title
> - 발표자 : Speaker
> - 방 : Room
> - 날짜 ・ 시간 : Time and date
> - 동시 통역 대상 : Simultaneous interpretation target

우선 말의 확인부터. 

제목이나 발표자라든지 실제 사용되고있는 언어가 무엇인가를 확인합니다.

## 26p, 세션에 대한 애매한 언어

> - 모집 요강
>   - 요약 : Abstract
> - Sessionize
>   - Description

DroidKaigi 2019이라는 비교적 복잡하지 도메인이고 말의 흔들림이 일어나는 것 같습니다.

세션 내용을 설명하는 항목은 모집 요강은 요약인데, Sessionize는 세션 정보를 관리하는 서비스를 DroidKaigi는 이용하는데, 이 항목 이름은 Description으로 되어 있습니다. 이것은 모집 요강을 우선시해서 요약을 사용합니다.

## 27p, 세션에 대한 애매한 언어

> - 모집 요강
>   - 카테고리 : Topic
> - Sessionize 설명
>   - 토픽 : Topic
> - Sessionize 항목 이름
>   - 카테고리 : Category

세션 내용에 대한 카테고리를 응모시에 선택합니다만, 이것도 장소에 따라 카테고리이거나 토픽이거나 합니다. 

이것도 모집 요강을 우선시하여 카테고리, 그러나 영어쪽도 Category를 사용합시다.

## 28p, 해당되는 일본어가 불명확한 유비쿼터스 언어

SessionFormat은 발표 시간, 30분 또는 50분, 

Language는 발표 언어, 일본어 또는 영어 

라는 항목인데 해당되는 일본어가 Web이나 메일에는 없었기때문에 그대로 영어 표기로 진행합니다. 본래라면 여기에서 운영자에게 인터뷰를 해서 일본어로 뭐라하는지 확인합시다.

## 29p

> - 타이틀 : Title
> - 카테고리 : Category
> - 요약 : Abstract
> - 방 : Room
> - 발표자 : Speaker
> - 날짜 ・ 시간 : Time and date
> - Session format
> - 동시 통역 대상 : Simultaneous interpretation target
> - Language

이것으로 세션에 대한 항목 이름이 정리했습니다.

## 30p, Value Object or Entity

> - 속성값에 따라 구별되는 것 → Value Object
> - 동일성에 따라 구별되는 것 → Entity

세션을 모델링함에있어서, 세션이 Value object인지 Entity인지를 생각해 봅시다. 

처음 복습한 곳에서도 언급했지만, 속성 값에 의해 구별되는 되는 것이 Value Object, 동일성에 의해 구별되는 것이 Entity입니다.

## 31p, Value Object or Entity

> - 동일한 속성값 (타이틀, 발표자 등)이라면 같은 세션?
>   - → No : 속성값으로 판별하지 않는다
> - 속성값 (요약 등)이 바뀌어도 동일한 세션?
>   - → Yes : 동일성이 있다
>
> 세션은 Entity

똑같은 제목이라면 동일한 세션인가하면, 별도의 세션에서 같은 제목은 있을 수 있으므로 No 

컨퍼런스 당일까지 요약이 바뀌더라도 같은 세션이므로 Yes 

따라서 세션은 Entity입니다.

## 32p, 세션은 Entity

> - 세션을 고유하게 식별하기 위한 ID가 필요

동일성있는 세션을 도메인 모델로 표현하기 위해 고유하게 식별할 ID가 필요합니다.

## 33p, 세션을 구성하는 것

> - 타이틀 : Title
> - 카테고리 : Category
> - 요약 : Abstract
> - 방 : Room
> - 발표자 : Speaker
> - 날짜 ・ 시간 : Time and date
> - Session format
> - 동시 통역 대상 : Simultaneous interpretation target
> - Language

이렇게, 세션을 구성하는 것이 모여졌습니다.

## 34p, 세션을 구현해보기

> branch : step1

```kotlin
data class Session(
)
```

이것을 실제로 구현하자.

## 35p

```kotlin
data class Session(
  val id: SessionId
)
```

```kotlin
data class SessionId(val value: String)
```

> ID는 Value Object

id 타입은 Value Object입니다. 여기에서는 data class하고 있습니다만, Kotlin의 inline class를 사용하는 것도 방법입니다.

## 36p

```kotlin
data class Session(
  val id: SessionId,
  val title: String
)
```

타이틀

## 37p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String
)
```

요약

프로필 이름에는 유비쿼터스 언어를 사용합니다.

## 38p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>
)
```

>  발표자는 여러 사람인 경우가 있을 수 있다

```kotlin
class Speaker
```

>  아직 모델링하지 않았으므로 빈 클래스

발표자는 여러 사람인 경우가 있을 수 있으므로 List로 했습니다. 

발표자에 대해 아직 모델링하지 않았기때문에 Speaker는 빈 클래스로 둡니다.

## 39p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat
)
```

```kotlin
enum class SessionFormat {
  MIN_30,
  MIN_50
}
```

> 30분 or 50분

SessionFormat은 선택지가 30분 혹은 50분으로 정해져 있으므로 enum으로 했습니다.

## 40p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language
)
```

```kotlin
enum class Language {
  JA,
  EN,
  MIX
}
```

> 일본어 or 영어 or 일본어 영어 혼합

Language도 동일하게 enum

## 41p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category
)
```

```kotlin
enum class Category {
  XR,
  SECURITY,
  UI_AND_DESIGN,
  DESIGNING_APP_ARCHITECTURE,
  HARDWARE,
  ANDROID_PLATFORMS,
  MAINTENANCE_OPERATIONS_TESTING,
  DEVELOPMENT_PROCESSES,
  ANDROID_FRAMEWORK_AND_JETPACK,
  PRODUCTIVITY_AND_DEVELOPMENT,
  CROSS_PLATFORM_DEVELOPMENT,
  OTHER
}
```

카테고리도 동일하게 enum으로 했습니다.

## 42p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category,
  val simultaneousInterpretationTarget: Boolean
)
```

> 동시 통역 대상

동시 번역은 대상인가 아닌가의 2택이므로 Boolean으로 했습니다.

## 43p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category,
  val simultaneousInterpretationTarget: Boolean,
  val room: Room
)
```

```kotlin
enum class Room {
  HALL_A,
  HALL_B,
  ROOM_1,
  ROOM_2,
  ROOM_3,
  ROOM_4,
  ROOM_5,
  ROOM_6,
  ROOM_7
}
```

방도 선택지가 정해져 있으므로 enum으로 했습니다.

## 44p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category,
  val simultaneousInterpretationTarget: Boolean,
  val room: Room,
  val timeAndDate: TimeAndDate
)
```

```kotlin
class TimeAndDate
```

> 아직 모델링하지 않았으므로 빈 클래스

날짜 · 시간에 대해서는 아직 모델링하지 않기 때문에 Speaker와 같이 빈 클래스로 둡니다.

## 45p

```kotlin
data class Session(
  val id: SessionId,
  val title: String,
  val abstract: String,
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category,
  val simultaneousInterpretationTarget: Boolean,
  val room: Room,
  val timeAndDate: TimeAndDate
)
```

완성 했습니다.

## 46p

```kotlin
Session(
  SessionId("78866"),
  "LiveData와 Coroutine으로 구현하는 DDD 전술적 설계",
  "DroidKaigi 2017과 2018에서...",
  listOf(Speaker()),
  SessionFormat.MIN_50,
  Language.JA,
  Category.OTHER,
  false,
  Room.ROOM_1,
  TimeAndDate()
)
```

이것을 사용해 더미 데이터를 준비합니다.

## 47p, 세션 상세 화면을 구현해보기

> branch: stage2

지금 만든 Session 클래스 및 더미 데이터를 사용하여 세션 상세 화면을 만들어 봅시다.

## 48p ~ 49p

<img src="https://4.bp.blogspot.com/-WtvkQY0GC2I/XFy5ngTT2wI/AAAAAAAA8Nw/-GHeE6Lu6LMoB9JmNr8KMjBnRH2O7_EjQCLcBGAs/s1600/DroidKaigi2019.057.png" />

TextView를 늘려놓고, String의 항목은 그대로 set하고, 그이외는 toString()으로 set하면

이런 느낌입니다.

## 50p

제목과 요약이외의 곳의 문자열 표현을 생각해야합니다. 우선 enum부터 생각해 봅시다.

## 51p, 유형 (enum) 텍스트 표현을 어디에 적을까?

> - 대안 1) 유형 (enum)에 string resources를 가지게 한다
> - 대안 2) 유형 (enum)에 문자열을 가지게한다
> - 대안 3) UI에 string resources를 가지게 한다

이 유형의 텍스트 표현을 어디에 둘지가 문제이지만, 3개 정도 안이 있습니다.

## 52p ~ 53p, 대안 1) 유형 (enum)에 string resources를 가지게 한다

```kotlin
enum class SessionFormat(@StringRes val text: Int) {
  MIN_30(R.string.minutes_30),
  MIN_50(R.string.minutes_50)
}
```

> domain module이 Android Framework에 의존

우선 enum에 string resources를 갖게하는 방법은 어떨까요 

UI는 TextView의 setText()에게 string resrouce id를 그대로 건네주면 좋기때문에 간단합니다.

그러나 이 enum이 놓여질 domain module이 Android Framework에 의존하게 됩니다. 

Kotlin multiplatform project는 이 enum을 shared code에 둘 수 없습니다.

## 54p, 대안 2) 유형 (enum)에 문자열을 가지게한다 ①

```kotlin
enum class SessionFormat(
  private val en: String,
  private val ja: String
) {
  MIN_30("30minutes", "30분"),
  MIN_50("50minutes", "50분");
  
  fun text(local: Locale) = if (locale.language = "ja") ja else en
}

sessionFormatView.text = session.sessionFormat.text(Locale.getDefault());
```

enum에 문자열을 갖게하는 것은 어떨까요. 

다국어 대응으로 Locale에 따라 문자를 다양하게 나눌 필요가 있습니다. 

UI에서 Locale을 전달해야하기 때문에 대안 1보다 UI는 복잡합니다. 

또한, java.util 패키지의 Locale에 의존하면, Kotlin multiplatform project의 shared code에 둘 수 없습니다. 둔다면 Locale에 해당하는 것을 expect로 제공하거나

## 55p, 대안 2) 유형 (enum)에 문자열을 가지게한다 ②

```kotlin
enum class SessionFormat(
  private val en: String,
  private val ja: String
) {
  MIN_30("30minutes", "30분"),
  MIN_50("50minutes", "50분")
}


fun text(local: Locale) = if (locale.language = "ja") ja else en

sessionFormatView.text = session.sessionFormat.text(Locale.getDefault());
```

이와 같이 Locale에 따른 판정을 UI에서 하도록 해야합니다.

## 56p, 대안 3) UI에 string resources를 가지게 한다

```kotlin
@get:StringRes
val SessionFormat.text: Int
  get() = when (this) {
    SessionFormat.MIN_30 -> R.string.minutes_30
    SessionFormat.MIN_50 -> R.string.minutes_50
  }

sessionFormatView.setText(session.sessionFormat.text)
```

세 번째로 UI에 string resoures을 갖게하는 방법은 어떨까요. 

확장 함수로 string resoure id를 반환하는 함수를 정의하면, UI에서 enum이 string resources를 가지는 것처럼 작성할 수 있습니다. 

일일이 Locale를 전달않아도 되지만 Kotlin multiplatform project의 경우 각 플랫폼마다 문자열을 정의해야 합니다.

## 57p ~ 60p

>  enum의 텍스트 표현을 어디에 두는가
>
> - 도메인 모델의 표현으로 모델이 문자열을 가지는 것은 자연스럽다
>   - → 유형 (enum)에 문자열을 가지게 한다
> - 문자열 표현은 UI의 관심사로서 자연스럽다
>   - → UI에 string resouces를 가지게 한다
> - 구현의 피드백이 문자열에 영향을 준다

도메인 모델의 표현으로 모델이 문자열을 가지는 것은 자연스럽다면 enum에 문자열을 가지게 하면 되고

문자열 표현은 UI의 관심사로 두는것이 자연스럽다면 UI에 문자열을 정의하면 됩니다.

컨퍼런스 정보를 열람할 도메인에서는 어떨까라는 관점도 있고, Kotlin multiplatform project으로 할지 여부는 구현의 피드백이 모델에 영향을 주는 것이기도 합니다. 

한번에 이거라고 결정할 수 있는 것은 아닙니다.

## 61p, UI에 string resources를 가지게 한다

> branch: stage3

구현의 전제 조건으로 Kotlin multiplatform project가 아니기 때문에 여기에서는 UI에 string resources를 가지게 합시다.

## 62p

<img src="https://1.bp.blogspot.com/-0nDxtPimmWU/XFy5sOzIxPI/AAAAAAAA8Ok/9ZdXjcGGKncXVOGXNTWMV4hjBc_wMVbwACLcBGAs/s1600/DroidKaigi2019.070.png" />

SessionFormat, Language, 카테고리, 룸 타입을 문자열 리소스에 매핑하는 확장 함수를 준비하고

## 63p

<img src="https://1.bp.blogspot.com/-vd8Vq9dN-bY/XFy5sBu75RI/AAAAAAAA8Oo/WiNCLj-OwvU4Yooz-rlzbrq4Xpdg6K3swCLcBGAs/s1600/DroidKaigi2019.071.png" />

그것을 이용하도록 UI쪽을 바꾸면

## 64p

<img src="https://2.bp.blogspot.com/-dtHWVXiIdMQ/XFy5sZYovdI/AAAAAAAA8Os/nBDvhk7v-uc9UcKG53aKoOnQ0sr0LXYAwCLcBGAs/s1600/DroidKaigi2019.072.png" />

유형 부분의 표시도 좋아졌습니다

## 65p

<img src="https://4.bp.blogspot.com/-xMVxdEWJBFs/XFy5tDLjU4I/AAAAAAAA8Ow/XtpqIlyLNe0sVb_NC6PDcHqQlb-6NjWdACLcBGAs/s1600/DroidKaigi2019.073.png" />

나머지는 발표자와 날짜 · 시간 부분입니다.

## 66p, 날짜 · 시간 모델링

> branch: step4

먼저 날짜와 시간을 생각해봅시다.

## 67p ~ 68p, 세션의 날짜 · 시간

> - 세션은 시작 시간과 종료 시간이 있다

```kotlin
data class TimeAnddate(
  val start: Date,
  val end: Date
)

data class TimeAnddate(
  val start: Long,
  val end: Long
)
```

단순히 start와 end를 가지게 했습니다.

## 69p ~ 70p, 세션의 날짜 · 시간

> - 세션은 시작 시간과 종료 시간이 있다
> - 세션의 일시는 개최지 (도쿄) 의 시간입니다

```kotlin
data class TimeAnddate(
  val start: LocalDateTime,
  val end: LocalDateTime
)
    
data class TimeAnddate(
  val start: ZoneDateTime,
  val end: ZoneDateTime
)
```

세션 시간은 도쿄에서의 시간, 즉 관심사는 현지 시간이므

LocalDateTime을 사용하거나 "Asia / Tokyo" Zone으로 고정된 ZonedDateTime을 사용하는 것이 좋을 것 같습니다.

## 71p, 세션의 날짜 · 시간

> - 세션은 시작 시간과 종료 시간이 있다
> - 세션의 일시는 개최지 (도쿄) 의 시간입니다
> - 세션은 날짜를 넘지않는다

```kotlin
data class TimeAnddate(
  val date: LocalDate,
  val startTime: LocalTime,
  val endTime: LocalTime
)
```

DroidKaigi 2019 도메인에서는 일자를 넘는 세션은 없으므로 날짜와 시간을 별도로하면, 날짜를 넘는 세션이 아니라는 것을 표현할 수 있습니다. 

날짜에 LocalDate, 시간에 LocalTime을 사용하면 관심사는 현지 시간이라는 것도 표현할 수 있습니다.

## 72p

<img src="https://1.bp.blogspot.com/-oFsScBhDPPM/XFy5u_Sy_zI/AAAAAAAA8PM/KBK9aD74y4UJKVQOGBZz-ruRXSR69-5xQCLcBGAs/s1600/DroidKaigi2019.080.png" />

```kotlin
Session(
  SessionId("78866"),
  "LiveData와 Coroutine으로 구현하는 DDD 전술적 설계",
  "DroidKaigi 2017과 2018에서...",
  listOf(Speaker()),
  SessionFormat.MIN_50,
  Language.JA,
  Category.OTHER,
  false,
  Room.ROOM_1,
  TimeAndDate(
    LocalDate.of(2019, 2, 7),
    LocalTime.of(12, 50),
    LocalTime.of(13, 40)
  )
)
```

이걸로 세션의 날짜와 시간을 표현할 수 있게됐지만, TimeAndDate의 문자열 표현을 어디에서 할 것인지를 생각해야합니다.

## 73p

> - TimeAndDate 텍스트 표현을 어디에 둘까?
>   - 날짜 · 시간 텍스트 표현은 모둘의 관심사 →

```kotlin
data class TimeAndDate(...) {
  val text: String
    get() "${date.monthValue}/${date.dayOfMonth} $startTime - $endTime"
}
```

날짜 · 시간의 텍스트 표현이 모델의 관심사라면 TimeAndDate에 문자열을 반환하는 메소드를 준비하면 좋을 것 입니다. 

이 경우 텍스트 표현의 로직이 바뀌면 그것을 이용하고 있는 모든 화면에 영향을 줍니다. 영향을 주어도 OK라기보다 영향을 주어야 하는 상황이라면 날짜 · 시간의 텍스트 표현은 모델의 관심사입니다.

## 74p

> - TimeAndDate 텍스트 표현을 어디에 둘까?
>   - 날짜 · 시간 텍스트 표현은 모둘의 관심사 →

```kotlin
data class TimeAndDate(...) {
  val text: String
    get() "${date.monthValue}/${date.dayOfMonth} $startTime - $endTime"
}
```

> - 날짜 · 시간 텍스트 표현은 UI의 관심사 →

```kotlin
val TimeAndDate.text: String
  get() = "${date.monthValue}/${date.dayOfMonth} $startTime - $endTime"
```

한편 화면에 따라 텍스트 표현이 다르다면, 날짜 · 시간의 텍스트 표현은 UI의 관심사 것입니다. 

날짜 · 시간의 텍스트 표현이 UI의 관심사라면, UI 측에 문자열을 반환하는 메소드를 제공합니다.

## 75p

```kotlin
timeAndDateView.text = session.timeAndDate.text
```

어떤 방법이든간에 이걸로 날짜 · 시간의 표시도 좋아졌습니다.

## 76p, 발표자 모델링

> branch: step5

남아있던 발표자에 대해 생각해 봅시다.

## 77p, 발표자는 Entity

> - 발표자를 유일하게 식별하기 위해 ID가 필요

발표자는 Entity이네요. 발표자 A와 발표자 B가 같은 이름이라도 다른 발표자입니다. 이건 이제 괜찮군요.

## 78p, 발표자를 구성하는 것

> - ID
> - 이름 : Name
>   - 표시명 : Screen Name
> - Tagline
> - Biography
> - 프로필 이미지 : Profile icon

> 이름, 표시명은 모호한 언어

발표자에 관한 언어를 확인했습니다. 모호한 단어로 "이름"과 "표시명"이 있습니다만, 여기에서는 성명:Name을 사용하겠습니다.

## 79p

```kotlin
data class SpeakerId(val value: String)

data class Speaker(
  val id: SpeakerId,
  val name: String,
  val tagline: String,
  val biography: String,
  val profileIcon: String
)
```

Speaker의 id도 Value Object로 준비합시다.

## 80p

```kotlin
Session(
  SessionId("78866"),
  "LiveData와 Coroutine으로 구현하는 DDD 전술적 설계",
  "DroidKaigi 2017과 2018에서...",
  listOf(
    Speaker(
      SpeakerId("580fb501-aece-4bf4-b755-32fba033b3bd"),
      "Yuki Anzai",
      "株式会社ウフィカ",
      "...",
      "https://sessionize.com/image..."
    )
  ),
  ...
)
```

더미 데이터를 업데이트하고

## 81p

```kotlin
speakerView.text = session.speaker.joinToString { it.name }
```

발표자 표시도 좋아졌습니다.
이제 더미 데이터를 그만두고 싶네요.

## 82p, Repository

그래서 다음 도입하는 것이 Repository입니다. 

도메인 주도 설계가 아니어도 Repository라는 이름은 자주 듣습니다만, Repository는 결국 뭐일까요. 

"에릭 에반스 도메인 주도 설계"에서는 Repository에 대해 뭐라고하는지 살펴봅시다.

## 83p

> "Repository는 특정 타입의 객체를 모든 개념의 집합 (일반적으로 그것을  모방한 것)으로 표현한다. 이것은 컬렉션처럼 동작하지만, 보다 정교한 쿼리 기능을 가지고 있다."

## 84p

> "Global 접근이 필요로하는 객체의 각 유형에 대해, 어떤 객체를 생성하고 그 형식의 모든 객체로 구성된 컬렉션이 메모리에 있다고 착각시키게 할 수 있게 하는 것"

## 85p

>  잘 알려진 Global Interface를 통해 접근할 수 있게 한다. … 클라이언트를 모델에 집중시켜 모든 객체의 저장과 접근을 Repository에 위임하는 것 

잘 모르겠네요. 

에릭 에반스의 도메인 주도 설계에서 말하는 것을 쉽게 설명합니다.

## 86p, 객체를 참조를 얻기 위해서는

> 1. 객체를 생성한다
> 2. 참조를 찾는다
> 3. 쿼리를 실행하고 속성에 기반해 데이터베이스 내에서 객체의 구성 요소를 찾아 그것을 재구축한다

모델 개체를 사용하여 뭔가를 하려면 그 객체에 대한 참조가 필요합니다. 

참조를 얻는 방법으로 첫 번째는 객체를 생성하는 것이 있습니다. 

지금까지는 세션의 더미 데이터를 생성했으므로, 그것을 사용해 화면에 표시 할 수 있었습니다. 

두 번째가 참조를 추적하는 것입니다. 세션에서 그 발표자 객체를 참조할 수 있습니다. 

세 번째가 데이터베이스에 저장되어 있는 객체를 가져오는 것입니다. 

## 87p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.095.png" }}" />

세 번째 방법으로, 만약 클라이언트가 직접 쿼리를 작성하고 데이터베이스에서 데이터를 검색하고 객체를 만들면 Entity와 Value Object는 단순한 데이터 컨테이너가 됩니다.

## 88p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.096.png" }}" />

그래서 기술적인 인프라 구조와 데이터베이스 접근 메커니즘을 캡슐화하고 클라이언트에서는 특정 타입의 객체의 개념상의 집합처럼 보이도록 한 것이 Repository입니다.

## 89p, Repository

> - (데이터베이스 등으로 부터) 객체를 재구성하는 것을 책무로 한다
> - "특정 타입의 객체를 모든 개념상의 집합으로서 표현한다"
> - 객체가 메모리상에 있는 것처럼 다룬다
>   - 기술적인 인프라나 데이터베이스 접근 매커니즘을 캡슐화

즉, 클라이언트가 어떻게 영속화되고 있는지 어떤 인프라를 사용하는지 기술적인 세부 사항을 의식하지 않고 필요한 객체 참조를 얻기 위해 이것 저것을 혼자(一手)맡아 캡슐화하는 것이 Repository입니다. 

"에릭 에반스 도메인 주도 설계"에서는 데이터베이스 접근을 염두에 두는 느낌이지만 내부에서 하고 있는 것이 서버 접근이라해도 영속화 위치가 서버일 뿐이고 역할로는 맞습니다. 

## 90p, Repository = 특정 타입 객체의 개념상의 집합

> - SessionRepository는 개념상, 모든 Session의 집합
>   - Session 검색
>     - 지정된 조건에 일치하는 Session 콜렉션을 반환
>     - 지정된 Value Object에 속성값이 일치하는 Session을 반환
>   - Session 추가
>   - Session 삭제

세션의 개념상 집합으로 SessionRepository를 생각해봅시다.

컨퍼런스 정보를 열람하기 위해서는 각 컨퍼런스날에 세션의 컬렉션을 반환하는 기능과 특정 세션 ID와 일치하는 세션을 돌려주는 기능이 필요합니다. 

세션의 추가 및 삭제는 이번 도메인에서는 필요 없기 때문에,

## 91p

```kotlin
interface SessionRepository {
  fun day(day: ConferenceDay): List<Session>
  fun sessionId(id: SessionId): Session
}

enum class ConferenceDay {
  DAY1,
  DAY2
}
```

인터페이스는 다음과 같이됩니다.

## 92p ~ 93p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.101.png" }}" />

이 SessionRepository를 구현한 AssetsSessionRepository가 있다고 합시다.

DetailActivity에서 AssetsSessionRepository 인스턴스를 생성하면 AssetsSessionRepository를 이용하게 됩니다. 

클라이언트는 Global Repository 인터페이스를 이용해야하고 구현면에서 보더라도, 이거라면 테스트시에 Repository를 교체할 수가 있습니다.

## 94p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0512-ddd/DroidKaigi2019.102.png" }}" />

DetailActivity에서 AssetsSessionRepository 인스턴스를 생성하는 것이 아니라 외부에서 SessionRepository 인스턴스를 전달하도록하고 DetailActivity는 SessionRepository의 실제가 무엇인지 모르게합니다.

## 95p ~ 96p, SessionRepository 인터페이스를 어떻게 UI에 전달할까

> - 어플리케이션 경유로 전달
> - 어플리케이션 Scope에서 싱글톤으로 한다
> - → 라이브러리에 맡긴다면 Dagger

이것을 실현하려면 SessionRepository 인스턴스를 어떻게 UI에 전달할 것인가하는 문제를 해결하지 않으면 안됩니다.

Android에서는 UI 측에서 Global로 접근할 수 있는 곳으로 자주 Application을 사용합니다. 

관리하는 것이나 화면이 많아지면 직접하는 것은 어렵기때문에 적절한 Dagger 등 DI 컨테이너를 도입합시다.

## 97p

```kotlin
class MainApplication: Application() {
  val sessionRepository: SessionRepository = AssertsSessionRepository(this)
    private set

  @VisibleForTesting
  fun replaceSessionRepository(sessionRepository: SessionRepository) {
    this.sessionRepository = sessionRepository
  }
}

val Context.sessionRepository: SessionRepository
  get() = (applicationContext as MainApplication).sessionRepository
```

> branch: step7

Application에서 SessionRepository의 인스턴스를 가지고 테스트시에 바꿀 수 있도록합니다. 

확장 함수를 준비해두면 Activity에서 SessionRepository의 인스턴스를 얻는 코드를 단순화할 수 있습니다.

## 98p

<img src="https://3.bp.blogspot.com/-_-IqH11dMQM/XFy52H1Gx5I/AAAAAAAA8Q0/eeQ90nGp6iAlbwGhSFmATBkqOEpSOHmgACLcBGAs/s1600/DroidKaigi2019.106.png" />

Repository에서 데이터베이스 접근 및 서버 접근의 처리를 캡슐화하는 것으로 클라이언트 측, 즉 UI측은 객체가 재구성될 때의 기술적 세부 사항을 신경 쓰지않아도 되었습니다.

## 99p ~ 101p

> - 모델 (Session)의 재구성 과정 (=Repository에서 모델을 얻는 과정)에 디스크 접근이나 서버 접근이 잇다
>   - → Repository에서 모델을 얻는 과정은 Background에서
>   - → Coroutines

그러나 Android에서는 데이터베이스 접근 및 서버 접근 등의 시간이 걸리는 처리를 UI 스레드에서 호출하는 것은 좋지않습니다.

그러기 위해서 Repository에서 모델을 얻는 처리는 백그라운드에서 수행하도록 해야합니다.

그래서 Coroutines을 사용하여 이 문제에 대응해보겠습니다

## 102p

Coroutines

## 103p, Activity에서 Coroutines을 사용시의 패턴

> 자세한 것은 2/7 15:40 ~ Room3의 mhidaka의 세션 "Understanding kotlin Coroutines: 코루틴으로 진화하는 애플리케이션 개발"을 봐주세요!
>
> branch: step8

Activity에서 Coroutines를 사용시의 패턴을 잠깐 소개하니, 자세한 내용은 오늘 15시 40분에 Room3에서 mhidaka의 세션을 보세요.

## 104p

```kotlin
class DetailActivity: AppCompatActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    ...
  }
  ...
}
```

우선 Activity가 있다고 하고

## 105p

```kotlin
class DetailActivity: AppCompatActivity() {
  private lateinit var job: Job

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    ...
  }
  ...
}
```

이 Activity에 Job을 갖게 합니다

## 106p

```kotlin
class DetailActivity: AppCompatActivity(), CoroutineScope {
  private lateinit var job: Job
  
  override val coroutineContext: CoroutineContext
    get() = Dispatchers.MAIN + job

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    ...
  }
  ...
}
```

다음으로 Activity가 CoroutineScope을 구현하도록 합니다

## 107p

```kotlin
public interface CoroutineScope {
  /**
   * Context of this scope.
   */
  public val coroutineContext: CoroutineContext 
}
```

CoroutineScope는 CoroutineContext 프로퍼티를 가진 인터페이스입니다. Activity에서는 Dispathers.Main와 조금 전에 가진 Job으로 구성된 CoroutineContext을 반환하도록 합니다.

## 108p

```kotlin
class DetailActivity: AppCompatActivity(), CoroutineScope {
  private lateinit var job: Job
  
  override val coroutineContext: CoroutineContext
    get() = Dispatchers.MAIN + job

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    job = Job()
    ...
  }
  
  override fun onDestory() {
    job.cancel()
    super.onDestory()
  }
  ...
}
```

onCreate()에서 job의 인스턴스를 생성하고 onDestroy()에서 취소합니다.

## 109p

```kotlin
class DetailActivity: AppCompatActivity(), CoroutineScope {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    job = Job()
    
    val sessionId = ...
    val session = sessionRepository.sessionId(sessionId)
    titleView.text = session.title
    ...
  }
  ...
}
```

Repository에서 모델을 얻어 TextView에 설정 부분을

## 110p ~ 111p

```kotlin
class DetailActivity: AppCompatActivity(), CoroutineScope {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    job = Job()
    
    val sessionId = ...
    
    launch {
      val session = withContext(Dispatchers.Default) {
        // Background Thread
        sessionRepository.sessionId(sessionId)
      }
      // UI Thread
      titleView.text = session.title
      ...
    }
  }
  ...
}
```

launch의 내부로 이동하고

추가적으로 Repository에서 모델을 얻는 부분은 withContext() 내부로 이동합니다. 

withContext() 내의 처리는 백그라운드에서 실행하고 싶기 때문에 Dispatchers.Default을 지정합니다.

이렇게하면 Repository에서 모델을 얻는 부분은 백그라운드에서 실행되고, 그 처리가 끝나면 UI 스레드에서 TextView에 설정하는 부분이 실행됩니다.

## 112p ~ 115p

> - Rpository에서 모델을 얻는 도중에 onDestory() → job,cancel()
>   - withContext()에서 빠져나온 후의 처리 (TextView에 설정)는 취소된다
>   - Repository에서 모델을 얻는 처리가 끝나때 까지 Coroutines는 멈추지 않는다
>   - Coroutines 취소 처리는 Cooperative

그런데, Rpository에서 모델을 얻는 도중 사용자가 Activity를 닫으면 onDestory()에 작성한 job의 cancel()이 호출됩니다.

이 때 withContext()에서 빠져 나온 후의 처리, 즉 TextView에 설정하는 부분의 처리는 실행되지 않습니다.

그러나 Rpository에서 모델을 얻는 처리가 끝날 때까지, 즉 SessionRepository의 sessionId() 메소드가 값을 돌려줄 때까지 Coroutine은 멈추지 않습니다.

Coroutine 취소 처리는 cooperative이며, 취소되는 쪽이 취소 신호가 오는지 여부를 확인하고, 진행중인 처리를 중지해야 합니다.

## 116p ~ 117p

> - Repository가 Coroutines 취소 처리에 대응하기 위해서는
>
> ```kotlin
> interface SessionRepository {
>   suspend fun day(day: ConferenceDay): List<Session>
>   suspend fun sessionId(id: SessionId): Session
> }
> ```
>
> - 구현측에서 yield(), isActive, CancellableContinuation 등을 사용해 취소 대응
>
> branch: step9

Rpository가 내부에서 하고 있는 디스크 접근 및 서버 접근 처리를 Coroutine 취소 신호에 따라 중지하려면 Rpository의 메소드를 suspend 함수로 합니다.

suspend 함수에서 Coroutine에 취소 신호가 오는지 체크할 수 있기 때문에 그에 따라 내부에서 하고 있던 작업을 중지 할 수 있습니다.

## 118p ~ 119p

> - onCreate()에서 Background 처리 시작
> - onDestory()에서 취소 (처리가 종료되지 않았다면)
> - 문제점
>   - 화면 회전이 잇으면, 이전 처리를 취소하고 다시 Background 처리가 일어난다
>   - → ViewModel을 사용

이걸로 onDestory()에서 처리가 취소될 수 있지만, 여전히 문제가 있습니다. 

onCreate()에서 처리를 시작하고 onDestory()에서 취소하고 있기 때문에, 화면 회전하면 이전 작업을 취소하고 다시 Background 처리를 하게됩니다.

이 문제를 해결하기 위해 ViewModel을 사용합시다.

## 120p

ViewModel

## 121p, ViewModel

> - Android Architecture Components
> - Configuration 변경 (화면 회전, 화면 사이즈 변경 등)에 따른 Activity의 재생성을 넘어 인스턴스가 유지된다
>
> ```kotlin
> val viewModel = ViewModelProviders
> 	.of(activity of fragment, factory)
> 	.get(VM::class.java)
> ```
>
> branch: step10

ViewModel은 Android Architecture Components에서 제공되는 기능입니다. 

화면 회전과 화면 크기 변경 등 Configuration의 변경이 일어나면 Activity가 다시 생성되지만, ViewModel 인스턴스는이 재생성을 넘어 유지됩니다. 

ViewModel 인스턴스를 얻으려면 ViewModelProviders를 이용합니다.

## 122p

<img src="https://developer.android.com/images/topic/libraries/architecture/viewmodel-lifecycle.png" />

ViewModelProviders에서 ViewModel의 인스턴스를 얻을 때, 해당하는 항목이 없으면 생성되고, 화면이 회전해서 Activity가 다시 생성되어도 ViewModel 인스턴스는 그대로 유지되고 Activity가 finish해서 파기되면 ViewModel 의 onCleard()가 호출되어 삭제됩니다.

## 123p

```kotlin
class DetailViewModel: ViewModel() {
}
```

ViewModel을 이용하려면 ViewModel 또는 AndroidViewModel를 상속한 클래스를 만듭니다.

## 124p, ViewModelProvider.Factory

> - ViewModel 생성을 책무로하는 Interface
>
> ```java
> public interface Factory {
>   @NotNull
>   <T extends ViewModule> T create(@NotNull Class<T> modelClass);
> }
> ```
>
> - ViewModelProvider.of()의 두 번째 인자
>
> ```kotlin
> val viewModel = ViewModelProviders
> 	.of(activity of fragment, factory)
> 	.get(VM::class.java)
> ```

ViewModel 인스턴스 생성 타이밍은 라이브러리가 핸들링하므로, 임의의 인수를 ViewModel 생성자에서 전달하고자할 때에는 factory를 지정합니다.

## 125p

```kotlin
class DetailViewModel(
  private val id: SessionId,
  private val repository: SessionRepository
): ViewModel() {

  class Factory(
    private val id: SessionId,
    private val repository: SessionRepository
  ): ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
      @Suppress("UNCHECHKED_CAST")
      return DetailViewModel(id, repository) as T
    }
  }
}
```

DetailViewModel의 생성자에서 세션 ID와 Repository를 전달할 수 있도록 Factory를 준비합니다.

## 126p ~ 127p

```kotlin
class DetailActivity: AppCompatActivity() {
  private lateinit var viewModel: DetailViewModel
  
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    
    val sessionId = ...
    
    viewModel = ViewModelProviders
    	.of(this, DetailViewModel.Factory(sessionId, SessionRepository()))
    	.get(DetailViewModel::class,java)
  }
  // Repository에서 Session을 얻는 처리 (Coroutines 포함)를 ViewModel로 이동
  ...
}
```

Activity에서 준비한 Factory를 사용하여 DetailViewModel를 가져옵니다.

그리고 Repository에서 세션을 얻는 처리를 ViewModel로 이동합니다.

## 128p, ViewModel에서 Couroutines 사용시 패턴

ViewModel에서 Coroutines을 사용시의 패턴도 잠깐 소개합니다.

## 129p ~ 130p

```kotlin
class DetailViewModel(
  private val id: SessionId,
  private val repository: SessionRepository
): ViewModel(), CoroutineScope {
  private val job = Jobs()
  
  override val coroutineContext: CoroutineContext
    get() = Dispatchers.Main + job
  
  override fun onCleared() {
    job.cancel()
    super.onCleared()
  }
  ...
}
```

Activity 때처럼 ViewModel이 CoroutineScope을 구현하도록 Dispatchers.Main과 파라매터를 가지는 Job으로 구성된 CoroutineContext을 반환하도록 합니다.

ViewModel 생성시 Job의 인스턴스를 생성하고 onCleared()에서 job을 취소합니다.

## 131p ~ 132p

```kotlin
class DetailViewModel(
  private val id: SessionId,
  private val repository: SessionRepository
): ViewModel(), CoroutineScope {
	...
  private var session: Session? = null
  var listener: ((Session) -> Unit)? = null
  
  init {
    launch {
      val result = withContext(Dispatchers.Default) {
        // Background Thread
        repository.sessionId(sessionId)
      }
      // UI Thread
      session = result
      listener?.invoke(result)
    }
  }
}
```

그리고 초기화시 Repository에서 세션을 얻는 처리를 시작하고 얻은 결과를 가지고 Listener에게 알립니다.

ViewModel 인스턴스는 화면 회전이 일어나도 유지되므로 ViewModel에서 가져오는 처리하면 화면 회전이 일어나도 처리가 계속됩니다.

## 133p ~ 134p

```kotlin
class DetailViewModel(
  private val id: SessionId,
  private val repository: SessionRepository
): ViewModel(), CoroutineScope {
	...
  private var session: Session? = null
  var listener: ((Session) -> Unit)? = null
    set(value) {
      field = value
      // 이미 데이터를 얻었다면 바로 알림
      session?.let { value?.invoke(it) }
    }
  
  init {
    launch {
      val result = withContext(Dispatchers.Default) {
        repository.sessionId(sessionId)
      }
      session = result
      listener?.invoke(result)
    }
  }
}
```

Listener를 설정하면 이미 데이터를 얻은 경우 즉시 알리기 원하기 때문에 그 처리도 추가합니다.

그러나 이 코드는 Listener 호출이 2곳에 있으며, 이미 데이터 취득 여부를 스스로 결정하고 Listener를 호출하고 복잡합니다.

## 135p

> - 이미 데이터를 얻었다면 바로 알리고, 그렇지 않으면 얻은 타이밍에 알리고 싶다
> - Activity나 Fragment의 생명주기에 따라 자동으로 Listener를 해제하고 싶다
> - → LiveData

이미 데이터를 얻었다면 바로 알리고, 그렇지 않으면 얻은 타이밍에 알리고 싶은 경우 LiveData를 사용하는 것이 적합합니다.

## 136p

LiveData

## 137p, LiveData

> - Android Architecture Components
> - DataHolder + Observable
> - Lifecycle에 따라 자동으로 Observer를 해제
>
> branch: step11

LiveData는 한마디로 Observe 가능한 데이터 홀더입니다. 
Lifecycle에 따라 자동으로 Observer를 제거하는 특징이 있습니다.

## 138p, ViewModel + LiveData

<img src="https://4.bp.blogspot.com/-wsUZafvuICs/XFy6CEvogLI/AAAAAAAA8TU/-SHyw8sRkn4f5TsBaw7Zu4zYGbwLZhYjQCLcBGAs/s1600/DroidKaigi2019.146.png" />

ViewModel이 LiveData를 가지고 Activity가 그것을 Observe하게되면 LiveData의 값이 갱신 된 경우 Activity가 onStart()에서 onStop() 사이이면 알리고, 그렇지 않으면 다음 Activity가 onStart()가되었을 때 최신 값을 알립니다.

## 139p

```kotlin
class DetailViewModel(
  private val id: SessionId,
  private val repository: SessionRepository
): ViewModel(), CoroutineScope {
	...
  private val _session = MutableLiveData<Session>()
  var session = LiveData<Session>
    get() = _session
  
  init {
    launch {
      val result = withContext(Dispatchers.Default) {
        repository.sessionId(sessionId)
      }
      _session.value = result
    }
  }
}
```

DetailViewModel에서 세션을 LiveData에서 갖게하려면 세션을 유지하기위한 MutableLiveData 인스턴스를 생성하고 Repository에서 가져온 세션을 MutableLiveData에 설정합니다. 

또한 Activity에는 MutableLiveData 대신 LiveData 타입으로 공개합니다.

## 140p

```kotlin
class DetailActivity: AppCompatActivity() { 
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_detail)
    
    val sessionId = ...
    
    val viewModel = ...
    // LifecycleOwner
    viewModel.session.observe(this, Observer { session ->
    	titleView.text = session.title 
      ...
    })
  }
  ...
}
```

Activity는 LiveData의 observe()에 LifecycleOwner, 이 경우 this를 전달해서 observe합니다.

## 141p, Timetable

이제 모델링, Repository, Coroutines, ViewModel, LiveData로 대충 구현이되었습니다.

## 142p

```kotlin
class TimetableViewModel(
  private val day: ConferenceDay,
  private val repository: SessionRepository
) : ViewModel(), CoroutineScope {
  ...
  
  private val _list = MutableLiveData<List<Session>>()
  val list: LiveData<List<Session>>
    get() = _list
  
  init {
    launch {
      _list.value = withContext(Dispatchers.Default) {
        repository.dat(day)
      }
    }
  }
  ...
}
```

> branch: step12

Repository에는 이미 컨퍼런스 1일차 또는 2일차 세션 목록을 가져올 수 있는 입구가 있으므로 

TimetableViewModel에서 Coroutines을 사용하여 백그라운드에서 Repository에서 세션 목록을 얻어서 LiveData에서 가지고 Activity와 Fragment 에 알리도록하면

## 143p ~ 144p

<img src="https://4.bp.blogspot.com/-ka6K6Pd5-5I/XFy6D7nWxxI/AAAAAAAA8Ts/7TEiAR9ZXOEmu6JKsIIu6xS-iDcBxHKKACLcBGAs/s1600/DroidKaigi2019.152.png" />

> 웰컴 토크가 없다
>
> Codelab이 없다

이런 시간표 화면이 됩니다.

그런데, 이 시간표 화면을 잘 보면 웰컴 토크와 Codelabs가 없습니다. 공개 모집된 세션만 표시되어 있습니다.

## 145p, 세션?

> - 웰컴 토크는 세션?
> - Fireside Chat은 세션?
>   - 공개 모집된 것은 아니다
> - Codelabs은 세션?
> - 파티, 런치는 세션?
>
> 채택된 세션 목록 :  https://droidkaigi.jp/2019/accepted 에는 없다

여기에서 조금 생각해 봅시다. 

타임 테이블을 구성하는 요소로서 공개 모집된 세션 이외로 웰컴 토크와 Fireside Chat, Codelabs, 파티, 점심이 있습니다. 이들은 세션일까요? 

응모된 것이 아니기 때문에, 물론 채택된 세션 목록에는 없습니다.

## 146p

|               | 타이틀 | 요약 | 발표자 | Session Format | Language | 카테고리 | 룸   | 일시 ・ 시간 |
| ------------- | ------ | ------ | ------ | -------------- | -------- | -------- | ---- | ------------ |
| 응모 세션     | O      | O      | O      | O              | O        | O        | O    | O            |
| 웰컴 토크     | O      | ""     | ?      | X              | ?        | X        | O    | O            |
| Fireside Chat | O      | O      | ?      | X              | ?        | X        | O    | O            |
| Codelab       | O      | O      | ?      | X              | ?        | X        | O    | O            |
| 파티          | O      | ""     | X      | X              | X        | X        | O    | O            |
| 점심          | O      | ""     | X      | X              | X        | X        | X    | O            |

각각의 구성을 정리해 보았습니다. 

SessionFormat, Language, 카테고리는 응모된 세션 밖에 없습니다. 

한편, 날짜 · 시간는 모두있고, 룸도 점심이외에는 있습니다.

## 147p, 타입을 도입하면 같은 테이블에 저장할 수 있다

| id   | title                    | abstract | --   | room   | startAt   | endAt     | kind          |
| ---- | ------------------------ | -------- | ---- | ------ | --------- | --------- | ------------- |
| ...  | LiveData와 Coroutines... | ...      | ...  | Room 1 | 2/7 12:50 | 2/7 13:40 | normal        |
| ...  | Wllcome Talk             | ...      | null | Hall A | 2/7 10:00 | 2/7 10:20 | welcome_talk  |
| ...  | Fireside Chat            | ...      | null | Hall A | ...       | ...       | fireside_chat |
| ...  | Codelabs                 | ...      | null | Room 5 | ...       | ...       | codelab       |
| ...  | 점심                     | ...      | null | null   | ...       | ......    | lunch         |
| ...  | 파티                     | ...      | null | Hall A | ...       |           | party         |

그리하여 타입을 도입하면 데이터베이스에는 같은 테이블에 저장할 수 있습니다.

## 148p, 저장 타입을 그대로 모델로 하면 좋은가?

그러나 저장에 적당한 형식을 그대로 모델로하는 것이 좋은 것일까요? 

이것은 서버의 응답을 그대로 모델로 하는 것이 좋은 것인지? 라는 문제와도 공통점이 있지요.

## 149p ~ 150p, 웰컴 토크도 Session으로 표시하기 위해서는

> 대안1) Wellcome Talk에 없는 속성은 Nullable

```kotlin
data class Session(
  val id: SessionId,
  ...,
  val sessionFormat: SessionFormat?,
  val language: Language?.
  val category: Category?,
  ...,
  val kind: Kind
)
```

> 공모 세션에서 잘못해서 null이 설정되는 것을 막을 수 없다
>
> 공모 세션이라면 절대로 SessionFormat이 있는 것을 표현할 수 없다

웰컴 토크도 Session으로 표현하기 위해,

웰컴 토크에 없는 속성을 Nullable으로 하면

공모 세션에 잘못해서 null이 설정되도록 코드를 작성되는 것을 막을 수 없고 

모델, 공모 세션이라면 절대 SessionFormat이 있다는 것을 표현할 수 없습니다.

## 151p ~ 152p, 웰컴 토크도 세션으로 표현하기 위해서는

> 대안2) 유형에 "대상외"를 추가한다
>
> 공모 세션에 잘못해서 대상외가 설정되는 것을 막을 수 없고 
> 모델, 공모 세션이라면 절대 SessionFormat이 있다는 것을 표현할 수 없습니다.

```kotlin
enum class SessionFormat {
  ...,
  NONE
}
enum class Language {
  ...,
  NONE
}
```

유형에 대상외를 추가하는 방법은 어떨까요?

이것도 공모 세션에 실수로 대상외로 설정해버리는 코드를 작성되는 것을 막을 수는 없고, 

공모 세션이라면 절대로 SessionFormat이 대상외가 아니라는 것을 표현할 수 없습니다.

## 153p, 저장 타입과 모델의 표현이 같다고는 단정할 수 없다

저장 타입과 모델의 표현이 같다고는 할 수 없다. 

그럼 어떻게 할까요 ...

## 154p ~ 155p

> - 세션같은 타입 → Session
>   - 응모된 세션 → PublicSession : Session()
>   - 웰컴 토크 → WelcomeTalk : Session()
>   - Codelabs → Codelabs : Session()
>   - Fireside Chat → FiresideChat : Session()
> - 세션같은 것이 아닌 타입
>   - 파티, 런치

> branch: step13

먼저 세션같은 것과 세션같지 않은 것을 나누어 보았습니다. 

세션같은 것은 상세 화면에서 요약 등의 정보를 보고 싶은 것입니다.

세션같은 것을 Session이라고 정의하고, 지금까지 Session으로 했던 응모된 세션은 PublicSession 으로 하고 각각 Session을 상속하도록 했습니다.

## 156p

```kotlin
sealed class Session {
  abstract val id: SessionId
  abstract val title: String
  abstract val abstract: String
  abstract val room: Room
  abstract val timeAndDate: TimeAndDate
}

data class WelcomeTalk(
  override val id: SessionId,
  ...
) : Session()

data class PublicSession(
  override val id: SessionId,
  ...
  val speaker: List<Speaker>,
  val sessionFormat: SessionFormat,
  val language: Language,
  val category: Category,
  ...
) : Session()
```

Session을 sealed class로 구현하고 PublicSession과 WelcomeTalk는 data class로 구현하고 공통 파라미터는 Session 쪽에 abstract로 정의합니다.

## 157p ~ 158p

> - 세션같은 타입 
>   - 응모된 세션
>   - 웰컴 토크
>   - Codelabs
>   - Fireside Chat
> - 세션같은 것이 아닌 타입
>   - 파티, 런치 → Party, Lunch
>
> 타임테이블을 구성하는 요소

그럼 세션같지 않은 것은 어떻게할까요? 

파티와 점심을 각각 클래스로 정의로 하고 세션같은 것과의 관계를 어떻게 표현할까요?

이러한 전체의 공통점은 타임 테이블을 구성하는 요소라는 점입니다. 모두 날짜 · 시간이 정해져 있습니다.

## 159p

```kotlin
sealed class TimetableItem {
  abstract val timeAndDate: TimeAndDate
}

data class Lunch(
  override val timeAndDate: TimeAndDate
) : TimetableItem()

sealed class Session : TimetableItem() {
  ...
}
```

그래서 타임 테이블을 구성하는 요소를 표현하는 TimetableItem을 정의하고 Party, Lunch, Session이 이를 상속하도록했습니다.

## 160p

<img src="https://1.bp.blogspot.com/-L1og7w2mIsg/XFy6JSrH7hI/AAAAAAAA8Uo/_-E38PcwmLozzPBCOAZ0Ova8-mCmTn-9gCLcBGAs/s1600/DroidKaigi2019.168.png" />

관계를 도식화하면 이러한 관계입니다.

## 161p

<img src="https://1.bp.blogspot.com/-98IkG1FHpDc/XFy6Je8UlFI/AAAAAAAA8Us/CPl3gwW5GcoBJ5xomZncV3uW_6VXtOeNQCLcBGAs/s1600/DroidKaigi2019.169.png" />

다음은 Repository가 TimetableItem의 목록을 반환하도록 변경하고, 모델에 따라 표시를 바꾸는 처리를 UI 측에서 하면

## 162p

<img src="https://3.bp.blogspot.com/-cpFfUuxhKrU/XFy6KlRBNlI/AAAAAAAA8Uw/QIPIpro5_iwneWcPyv8ShpEsMGucys20QCLcBGAs/s1600/DroidKaigi2019.170.png" />

타임 테이블에 웰컴 토크와 Codelabs, 점심, Fireside Chat, 파티를 표시할 수 있게 되었습니다. 

하지만, 저는 이 모델링에 자신이 없습니다. 왜냐하면 TimetableItem이라는 말이 유비쿼터스 언어에 없기 때문입니다. 모델링은 항상 고민합니다. Timetable 클래스를 준비하고, 거기에 PublicSession 컬렉션과 파티와 점심을 갖게하면 어떨까라는 등도 생각했습니다.

## 163p

정리

## 164p

> - 유비쿼터스 언어를 찾고, 클래스나 속성명에는 유비쿼터스 언어를 사용
> - ViewModel과 LiveData는 매우 편리
> - Background에서 Repository로부터 모델을 얻는데 Coroutines를 쓸 수 있다
> - Repository가 제공하는 메소드를 suspend 함수로 정의
>   - 비동기 처리가 필요하다는 것을 Client 에 알린다
>   - 취소 처리는 cooperative
> - 모델링에 정답은 없다

유비쿼터스 언어를 찾고, 클래스 및 속성 이름은 유비쿼터스 언어를 사용합시다. 

DroidKaigi 같은 비교적 간단한 도메인에서도 모호한 말이 있습니다. 

모호한 단어를 찾으면 어느 것을 사용할 지는 팀에서 결정하고 항상 그것을 사용하도록 합시다. 

ViewModel과 LiveData는 매우 편리합니다. 꼭 사용해보세요. 

Repository는 데이터베이스 접근 및 서버 접근 등을 캡슐화하고 기술이 아니라 도메인 모델에 초점 맞추도록하기 위한 것입니다. 

데이터베이스 접근 및 서버 접근이 있기 때문에 Android에서는 Repository에서 모델을 얻는 처리는 백그라운드에서 호출할 필요가 있습니다. 

이 문제를 해결하는데 Coroutines를 사용하는 방법이 있습니다. 

또한 Repository가 제공하는 메소드를 suspend 함수로 정의하면 비동기 처리가 요구되고 있음을 클라이언트에 전달할 수 있고, Coroutines 취소 처리에 따라 Repository 내부에서 하고있는 작업을 취소가능한 구현이 됩니다. 

마지막으로, 

이번 DroidKaigi 2019을 소재로 모델링을 시도했지만 모델링에 정답은 없다고 생각합니다. 

특히 타임 테이블 부분에 대해서는 타입을 갖는 모델링도 맞다고 생각합니다. 

## 165p

이번 소재가 여러분의 모델링에 도움이 되었으면 좋겠습니다.

감사합니다. 
