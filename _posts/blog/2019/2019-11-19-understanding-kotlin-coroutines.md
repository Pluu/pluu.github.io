---
layout: post
title: "[번역] DroidKaigi 2019 ~ Understanding Kotlin Coroutines: 코루틴으로 진화하는 앱 개발"
date: 2019-11-20 09:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2019 ~ Understanding Kotlin Coroutines: コルーチンで進化するアプリケーション開発](https://speakerdeck.com/mhidaka/understanding-kotlin-coroutines-korutindejin-hua-suruapurikesiyonkai-fa) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

일부 이미지는 이해를 돕고자 한국어로 수정했습니다.

<!--more-->

- - -

## 1p, Understanding Kotlin Coroutines

Coroutine으로 진화하는 앱 개발

> @mhidaka

## 2p, 자료 정오표

발표시에 오류가 있는 곳을 다음과 같이 수정했습니다.

- P17 : 스레드와 연속의 잘못된 이해 • 표기 삭제
- P70, 73 : 병렬성 (잘못 변환)
- P21, 36, 65 : Coroutine (typo)
- P52 : Fragment (typo)
- P73 : Session Keyword (typo)

## 3p, @mhidaka

DroidKaigi / TechBooster / 기술서전

## 4p, PEAKS

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![https://s3-ap-northeast-1.amazonaws.com/peaks-images/architecture_patterns_book_cover_alpha.png](https://s3-ap-northeast-1.amazonaws.com/peaks-images/architecture_patterns_book_cover_alpha.png) | ![https://s3-ap-northeast-1.amazonaws.com/peaks-images/android_testing_book_cover_wide_alpha.png](https://s3-ap-northeast-1.amazonaws.com/peaks-images/android_testing_book_cover_wide_alpha.png) |

## 5p

Main points

## 6p, 오늘 전달하려는 것

- How to use Kotlin Coroutines
- Apply Coroutines to Android App
- When should I use Coroutines

## 7p, 서론 : 코루틴 등장 배경

The first step is always the hardest

## 8p, 코루틴

- Coroutine are light-weight threads
- Coroutine are new way of managing background threads

## 9p ~ 10p, 첫 코루틴

```kotlin
import kotlinx.coroutines.*

fun main() {
  GlobalScope.launch {   // Coroutine 시작
    delay(1000L)   // Coroutine을 1초 중단
    println("World!")   // "World" 출력
  }
  println("Hello,")   // 메인 스레드에서 "Hello," 출력
  Thread.sleep(2000L)   // 스레드를 2초 정지(JVM이 종료되지 않도록)
}
```

$ > Hello, World!

> [https://kotlinlang.org/docs/reference/coroutines/basics.html](https://kotlinlang.org/docs/reference/coroutines/basics.html)

## 11p, **Suspending Coroutines, Blocking Threads** 

> CC BY SA 2.0 [https://www.flickr.com/photos/librariesrock/44436145281/](https://www.flickr.com/photos/librariesrock/44436145281/)

## 12p, 코루틴 특징 : 중단 가능

일괄 처리에 대해 중단과 재시작을 제공

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/001.png" }}" />

> source : [Understanding Kotlin Coroutines: コルーチンで進化するアプリケーション開発](https://speakerdeck.com/mhidaka/understanding-kotlin-coroutines-korutindejin-hua-suruapurikesiyonkai-fa)

Job A~C에 대해 처리 중단/재시작을 제공한다 (스레드를 블록하지 않는다!)

## 13p ~ 14p, Suspend 함수 - Suspending Functions

```kotlin
GlobalScope.launch {   // Coroutine 시작
  delay(1000L)   // Coroutine을 1초 중단
  println("World!")   // "World" 출력
}
```

```kotlin
suspend fun delay(timeMillis: Long): Unit (source)
```

> [https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/delay.html](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/delay.html)

- 코루틴은 suspend 함수 타이밍에만 중단
- 작성한 처리를 순서대로 평가하고 실행하는 점은 변하지 않는다
- launch 블록이 중단 가능한 함수와 일반적인 코드를 연결

## 15p ~ 16p, 코루틴 특징 (Image)

복수 코루틴이 협조하고 자원을 유효하게 활용

Coroutine1 함수가 분할해서 실행하는 부분에 주의

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/002.jpg" }}" />

## 17p, 연속 - Continuation

앞의 상태를 이어받는 것.

컴퓨터 사이언스에서는 프로그램의 실행 중에 아직 평가되지 않은 남은 프로그램이나 처리를 완료하기 위한 처리나 구조를 가리킨다.

## 18p, memo

> 2019/2/11, 슬라이드에 잘못된 지식으로 오류가 있었으므로 정정합니다. 연속의 이해에는 다음 자료를 추천합니다. [http://practical-scheme.net/docs/cont-j.html](http://practical-scheme.net/docs/cont-j.html)

~~스레드도 연속의 구현 형태의 하나.~~ 서브 루틴에는 코루틴같은 중단은 없으므로 반드시 끝나지 않으면 다음 함수는 호출되지 않습니다. 멀티 스레드 프로그래밍에 따른 협조 동작과 동시성을 확보하고 있습니다.

## 19p, 콜백 해결 (의사  코드)

```kotlin
callbackA ( a -> {
  callbackB ( b -> {
    callbackC ( c -> {
      sum = a + b + c 
    })
  })
})
launch {  // 코루틴 시작
  val a = callbackA()
  val b = callbackB()
  val c = callbackC()
  val sum = a + b + c
}
```

## 20p

Cancellation

## 21p, 코루틴 중지 - Cancellation

- 코루틴을 실행하는 정원 : CoroutineScope
- 중지할 때는 CoroutineScope를 제공하는 Job이 필요
- launch 함수는 코루틴을 만드는 빌더

> [https://kotlinlang.org/docs/reference/coroutines/cancellation-and-timeouts.html](https://kotlinlang.org/docs/reference/coroutines/cancellation-and-timeouts.html)

## 22p ~ 23p, CoroutineScope

```kotlin
GlobalScope.launch {  // Coroutine 시작
  delay(1000L)        // Coroutine을 1초 중단  → Job A
  println("World!")    // "World" 출력        → Job B
}
```

```kotlin
object GlobalScope : CoroutineScope { ... }
```

> [https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-scope/index.html](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-coroutine-scope/index.html)

## 24p, memo

앱  개발에 있어서는 일반적으로 GrobalScope는 사용하지 않습니다. 앱 내의 생명주기에 따라 CoroutineScope를 자체 정의하는 것을 적극적으로 추천합니다.

## 25p ~ 27p, 취소 처리 사례

```kotlin
val job = CoroutineScope(Dispatchers.Default).launch{
  repeat(1000) { i ->
    println(“I‘m sleeping $i ...”) 
    delay(500L)
  }
}
delay(1300L) // 1.3초 중단
println("main: I’m tired of waiting!")
job.cancel() // Job 중지
job.join() // 중지 처리 종료 대기
println("main: Now I can quit.")
```

> [https://kotlinlang.org/docs/reference/coroutines/cancellation-and-timeouts.html](https://kotlinlang.org/docs/reference/coroutines/cancellation-and-timeouts.html)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/003.jpg" }}" />

## 28p, **Concurrency** **(and Parallels)** 

CC BY-SA 2.0 [https://www.flickr.com/photos/bobellaphotography/8494268626/](https://www.flickr.com/photos/bobellaphotography/8494268626/)

## 29p, 동시성과 병렬성 ~ Concurrency and Parallels 

동시성 : 프로그램이나 문제 해결에서 순서에 의존하지 않고, 부분적인 컴포넌트로 나눠서 리소스를 최대한 활용 (문제를 해결) 하는 구성

병렬성 : 동시에 복수 처리를 실행 (Execution) 하는 것

## 30p, 동시성과 병렬성 ~ Concurrency and Parallels 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/004.jpg" }}" />

## 31p, 동시성과 병렬성 ~ Concurrency and Parallels 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/005.png" }}" />

이 그림은 프로그래밍에서 말하는 Sequence 처리입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/006.png" }}" />

이 그림은 동시성일까요? 병렬성일까요?

실은 두 가지 모두 가지고 있습니다. 책을 책장으로 옮긴다는 의미에서는 병렬로 실행이 가능합니다. 옮기는 사람이 넘어져도, 다른 한쪽은 실행 가능한 병렬성입니다. 실제로 2배의 속도로 처리되는 것처럼 보이므로 동시성이기도 합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/007.png" }}" />

위 부분에 2명을 더 투입해서 시간을 나눠서 진행해 더 효율적으로 처리하는 부분에서는 동시성입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/008.png" }}" />

이 그림에서는 책장은 병렬성이 있습니다. 그러나, 책을 옮기는 부분에는 복수의 인원이 작업하므로 동시성을 가집니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/009.png" }}" />

보다 효율적으로 작업한다면 책장에 책을 넣는 사람을 투입해서 병렬성을 확보할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/010.png" }}" />

책을 넣는 사람이 한 명이 쓰러져도 남은 한 명으로 처리를 이어나갈 수 있습니다.

> [https://talks.golang.org/2012/waza.slide](https://talks.golang.org/2012/waza.slide)

## 37p, 구조화 Concurrency / Structured Concurrency 

복수 코루틴의 동시처리 / 제어를 도와주는 구성

버전 0.26.0에서 CoroutineScope를 도입

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/011.jpg" }}" />

## 38p,  코루틴은 순차처리가 기본

```kotlin
suspend fun loadFromNetwork(endPoint1: String, endPoint2: String): ResultData {
  val result1 = callApi(endPoint1)
  val result2 = callApi(endPoint2, result1) // 최초 결과를 사용
  return combineResults(result1, result2) // 결과를 합쳐서 반환
}

suspend fun callApi(endPoint: String): ResultData { ... } // 네트워크 처리
```

## 39p ~ 40p, async에서 코루틴화해서 대기 (1/2)

```kotlin
suspend fun loadFromNetwork(endPoint1: String, endPoint2: String): ResultData {
  val result1 = async { callApi(endPoint1) }
  val result2 = async { callApi(endPoint2, result1) }
  return combineResults(result1.await(), result2.await())
}
```

```kotlin
fun <T> CoroutineScope.async(
  context: CoroutineContext = EmptyCoroutineContext,
  start: CoroutineStart = CoroutineStart.DEFAULT,
  block: suspend CoroutineScope.() -> T
): Deferred<T> (source)
```

> [https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/async.html](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/async.html)

## 41p, CoroutineScope로 구조화 (2/2)

```kotlin
suspend fun loadFromNetwork(endPoint1: String, endPoint2: String): ResultData = coroutineScope {
  val deferred1 = async { callApi(endPoint1) } 
  val deferred2 = async { callApi(endPoint2) }

  combineResults(deferred1.await(), deferred2.await())
}
```

```kotlin
interface Deferred<out T> : Job (source) 

abstract suspend fun await(): T
```

> [https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/async.html](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/async.html)

## 42p

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| !<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/012.jpg" }}" /> | 코루틴은 기본 위에서 아래로 순차처리입니다. 동시 처리하고 싶은 경우에 async/await로 기다리게 한다. 이것은 동시 처리의 개념이 어렵고 join을 잘못썼을 때에는 복잡한 문제가 발생하기 위한 조치이다.<br /><br />여담 : C#은 동시 처리가 기본이므로 "Classic way"라고 부른다 |

## 43p, 현대 앱 개발의 과제

Introduction of application problem to be solved 

## 44p, 빠르게, 고품질, 가치 있는 것을

직면하는 과제

- 규모가 커지는 앱 개발
- 개발 효율화와 높은 확장성을 요구한다
- 라이브러리 이용에 따른 초기 비용

## 45p, 메인 스레드를 멈추지마!

CC BY-SA 2.0 [https://www.flickr.com/photos/ooocha/2849172733/](https://www.flickr.com/photos/ooocha/2849172733/ ) 

## 46p, 메인 스레드의 보호

좋은 UX를 제공하기 위해서는 통신, 처리　시간이 걸리는 것을 백그라운드 태스크로 해서 UI 스레드를 블록킹하지 않는 구조를 요구한다

## 47p, 독립 복수 모듈이 연동해 동작

관심 분리 (Separation of concerns)
단일 책무 원칙 (Single Responsibility Principle) 

이것에 근거해 설계된 모듈이 유기적으로 연계한다

## 48p

기대되는 코루틴 역할

## 49p, 코루틴 특징 (복습)

중단/재시작에 따른 리소스 보호

CoroutineScope에 의한 명확한 구조화

고효율 동시성을 획득

## 50p, 전형적인 앱 구조의 과제 설정

모듈간의 시퀀스를 생각한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/013.jpg" }}" />

## 51p

앱에 적용

## 52p ~ 53p, Android-sunflower 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/014.jpg" }}" />

> [https://github.com/googlesamples/android-sunflower](https://github.com/googlesamples/android-sunflower ) 

## 54p

MVVM 아키텍쳐에서 실천하는 코루틴

## 55p, UI

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/027.png" }}" />

```kotlin
fab.setOnClickListener { view ->
  plantDeailViewModel.addPlantToGarden()
  Snackbar.make(view, R.string.add_plant_to_garden, Snackbar.LENGTH_LONG).show()
}
```

## 56p ~ 57p, ViewModel - Launch Coroutine

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/015.jpg" }}" />

## 58p, Repository – Suspending functions 

```kotlin
suspend fun createGardenPlanting(plantId: String) {
  withContext(IO) {
    val gardenPlanting = GardenPlanting(plantId)
    gardenPlanting.insertGardenPlanting(gardenPlanting)
  }
}
```

## 59p, Database - Room

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/016.jpg" }}" />

## 60p

Coroutines의 편리한 사용법

## 61p, Suspend 함수의 테스트 코드

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/017.jpg" }}" />

## 62p, 보일러플레이트 작성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/018.jpg" }}" />

## 63p, 보일러플레이트 작성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/019.jpg" }}" />

## 64p, 보일러플레이트 작성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/020.jpg" }}" />

## 65p, 리스너로부터 값을 취득

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/021.jpg" }}" />

[> https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.coroutines/suspend-coroutine.html](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.coroutines/suspend-coroutine.html)

## 66p, Coroutines을 사용하게 쉽게하는 라이브러리

- kotlinx-coroutines-rx2 : RxJava와의 연속성 확보. Completable, MayBe, Single등 교체용 라이브러리
- Android KTX :  androidx.lifecycle:lifecycle-viewmodel-ktx에서는 viewModelScope을 제공

> [https://github.com/Kotlin/kotlinx.coroutines/tree/master/reactive/kotlinx-coroutines-rx2](https://github.com/Kotlin/kotlinx.coroutines/tree/master/reactive/kotlinx-coroutines-rx2)
>
> [https://developer.android.com/kotlin/ktx](https://developer.android.com/kotlin/ktx)

## 67p

다른 아키텍쳐에서의 사용지표

## 68p, 문제를 되돌아보기

모듈간의 시퀀스를 봅시다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/022.jpg" }}" />

## 69p, 문제를 파악하기 (1)

데이터 흐름의 문제로서 아키텍처를 구성한다면 스트림으로 파악하고 RxJava 등을 사용해 해결

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/023.jpg" }}" />

## 70p, 문제를 파악하기 (2)

모듈 단위로 관심을 분리하고 독립성이 높은 개발 모델을 주관으로 하는 경우에는 관심을 모듈이라는 단위로 분리한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/024.jpg" }}" />

## 71p, 문제를 파악하기 (3)

동시성을 도입하고 책무를 단일로 분해하기 위한 제약을 구한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/025.jpg" }}" />

## 72p, 문제를 파악하기 (4)

생명주기에 밀접하게 관련된 책임의 분리

Android specified한 기능을 추상화하고 인터페이스를 제공

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1117-droidkaigi-understanding-kotlin-coroutines/026.jpg" }}" />
## 73p

정리 : Android 앱에 있어서 Corutines의 역할

## 74p, 정리

- 코루틴은 동시성을 고품질로 다루기 위한 구성
  ​  가볍고 중단 가능, Android 앱 개발의 향후 표준

- 코루틴을 알고, 혼자라도 코드 속을 이해할 수 있는 기초와 앱에의 응용을
  ​  Kotlin Coroutines이 복잡한 비동기 처리 과제를 해결하고,
  ​  누구도 이해할 수 있는 클린 코드의 초석이 될 거라고 기대합니다

- 예외의 전파나 코루틴 간의 통신을 하는 Channel, Select 등은 다루지 않았습니다.
  ​  Channel 등은 Experimental 구현으로 존재합니다. 코루틴의 연계를 실현하는 기능

> **Session keyword**: continuation, concurrency, cancellation, launch, suspend, coroutine scope, async, await, job, coroutine context, withContext, suspendCoroutine 

## 75p, 정리

코루틴을 사용해
앱 개발을 더 재미있도록!

Enjoy Coroutines
More fun app development 

## 76p

Thank You!
[rabbitlog@gmail.com]() 

## 77p, Reference

- https://github.com/Kotlin/kotlinx.coroutines 코루틴 사이트. 언제나 함수 레퍼런스에 도움을 받고 있습니다.
- https://kotlinlang.org/docs/reference/coroutines/coroutines-guide.html 가이드라인. 처음인 사람은 여기에서 배울 수 있다. Android 특유의 사정은 다루지않는다.
- https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/launch.html 메소드 레퍼런스
- https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-deferred/ Deferred 메소드 레퍼런스
- https://medium.com/@elizarov/blocking-threads-suspending-coroutines-d33e11bf4761 Roman Elizarov님의 「Blocking threads, suspending coroutines」 
- https://talks.golang.org/2012/waza.slide#1 Rob Pike님의 동시성에 대해 알기쉬운 표현「Concurrency is not Parallelism」 
- https://ja.wikipedia.org/wiki/%E4%B8%A6%E8%A1%8C%E6%80%A7 Wikipedia 동시성 
- https://ja.wikipedia.org/wiki/%E3%82%B3%E3%83%AB%E3%83%BC%E3%83%81%E3%83%B3 Wikipedia 코루틴. 첫 언급은 콘웨이의 1963년 논문
- https://medium.com/@elizarov/structured-concurrency-722d765aa952 Roman Elizarov님의 「Structured concurrency」 구조화 동시성에 대한 해설
- https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/ Go에서의 Structured concurrency 해설
- http://sys1yagi.hatenablog.com/entry/2018/12/12/224116 yagi님의 블로그
- https://ja.wikipedia.org/wiki/%E9%96%A2%E5%BF%83%E3%81%AE%E5%88%86%E9%9B%A2 관심의 분리
- [https://xn--97-273ae6a4irb6e2hsoiozc2g4b8082p.com/%E3%82%A8%E3%83%83%E3%82%BB%E3%82%A4/%E5%8D%98%E4%B8%80%E8%B2%AC%E4%BB%BB%E5%8E%9F%20%E5%89%87/](https://xn--97-273ae6a4irb6e2hsoiozc2g4b8082p.com/エッセイ/単一責任原 則/) 단일책임원리
- https://codelabs.developers.google.com/codelabs/kotlin-coroutines/ Android 앱. 코루틴의 콜라보. 추천
- https://kotlinlang.org/docs/reference/coroutines/basics.html 공식 레퍼런스의 기초편

- https://qiita.com/takahirom/items/22a6c6ab4c879dd472e4 takahirom님의 Rx와Coroutines 바인드 이야기
- https://resources.jetbrains.com/storage/products/kotlinconf2018/slides/3_Android%20Suspenders.pdf KotlinConf 2018 발표 자료 Android Suspenders 
- https://www.youtube.com/watch?v=P7ov_r1JZ1g KotlinConf 2018 - Android Suspenders by Chris Banes

- https://www.youtube.com/watch?v=a3agLJQ6vt8 KotlinConf 2018 - Kotlin Coroutines in Practice by Roman Elizarov 