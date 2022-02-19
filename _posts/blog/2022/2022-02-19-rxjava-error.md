---
layout: post
title: "RxJava의 단위 테스트 ~ subscribe 엣지 케이스"
date: 2022-02-18 20:30:00 +09:00
tag: [Android, RxJava]
categories:
- blog
- Android
- RxJava
---

본 글에서는 RxJava의 subscribe에서 전달된 값 테스트를 소개합니다.

<!--more-->

사전 조건

- rxjava:3.1.3
- mockito-kotlin:4.0.0

## 기본편

먼저 간단하게 RxJava 단위 테스트를 살펴보겠습니다.

아래와 같이 map으로 넘어온 값을 0으로 나눌 경우, **ArithmeticException: / by zero**이라는 에러 메시지와 함께 테스트는 실패합니다.

```kotlin
@Test
fun sample1() {
  Single.just(1)
    .map { it / 0 }
    .blockingGet()
}
```

> 테스트 결과
>
> / by zero
> java.lang.ArithmeticException: / by zero
> 	at com.pluu.sample.rxjavajunit.SampleTest.sample1$lambda-2(SampleTest.kt:52)

위 케이스는 throw로 던져진 `ArithmeticException`를 확인하는 것으로 테스트는 통과합니다.

```kotlin
@Test(expected = ArithmeticException::class)
fun sample1() {
  Single.just(1)
    .map { it / 0 }
    .blockingGet()
}
```

## subscribe 엣지 케이스

### Case 1. subscribe 테스트

```kotlin
@Test(expected = AssertionError::class)
fun sample1() {
  Single.just(1)
    .subscribe { value ->
      fail("Result:$value")
    }
}
```

> 테스트 결과
>
> Expected exception: java.lang.AssertionError
> java.lang.AssertionError: Expected exception: java.lang.AssertionError
>     at org.junit.internal.runners.statements.ExpectException.evaluate(ExpectException.java:34)

위 케이스는 Single#subscribe의 onSuccess에서 `Assert#fail`를 사용해서 항상 테스트를 실패하도록 합니다. 그러나 해당 테스트는 실패합니다. 이전과 다르게 AssertionError가 throw 되지 않아서 실패한 것으로 메시지를 노출합니다.

결국 Test의 `expected`를 제거하면 테스트는 통과하지만, 이것은 우리가 생각한 결과가 아닙니다.

### Case 2. subscribe 테스트2

```kotlin
private fun testCase(callback: (Int) -> Int) {
  Single.just(1)
    .subscribe { value ->
      callback(value)
    }
}

@Test(expected = AssertionError::class)
fun sample1() {
  testCase { value ->
    fail("Result:$value")
  }
}
```

코드 설계에 따라서 테스트하려는 함수 내부에서 Rx를 사용할 수도 있습니다. 파라미터로 전달한 callback이 onSuccess인 경우에 호출되는 형태입니다. Case 2도 Case 1과 형태는 다르지만 둘 다 **subscribe의 결과값을 확인**합니다. 그러므로 `expected`로 throw를 체크하면 테스트는 실패합니다.

### subscribe에서의 테스트 코드가 예상과 다르게 실패하는 원인

#### JUnit 동작 확인

먼저 JUnit의 테스트 실패를 체크하는 expected는 `throw`를 기준으로 작동한다는 사실을 기억해 주세요.

> Optionally specify expected, a Throwable, to cause a test method to succeed if and only if an exception of the specified class is thrown by the method.
>
> https://junit.org/junit4/javadoc/4.13.2/org/junit/Test.html

다음으로 JUnit의 검증을 위해서 사용하는 Assert API 내부를 확인해 볼 필요가 있습니다. 간단하게 assertTrue/fail은 조건이 fail 이면 `AssertionError를 throw` 합니다.

```java
public class Assert {
  public static void assertTrue(String message, boolean condition) {
    if (!condition) {
      fail(message);
    }
  }
  
  public static void fail(String message) {
    if (message == null) {
      throw new AssertionError();
    }
    throw new AssertionError(message);
  }
}
```

> 소스 출처 : https://github.com/junit-team/junit4/blob/main/src/main/java/org/junit/Assert.java

#### RxJava 동작 확인

> An Observable typically does not *throw* exceptions.
>
> https://github.com/ReactiveX/RxJava/wiki/Error-Handling

우리가 RxJava를 사용하면서 기억해야 할 사실 중 하나로 **RxJava의 Observable은 기본 throw를 일으키지 않는다**는 점이다. 그로 인해 subscribe에서 Exception을 발생시키더라도 예상대로 테스트가 동작하지 않는 이유입니다. 

subscribe는 내부적으로 `ConsumerSingleObserver`가 사용됩니다. 내부의 onSuccess/onError 동작은 try~catch 블록으로 감싸져있으며 Exception이 발생 시 일반적으로 `RxJavaPlugins#onError`로만 전달합니다. 

> Exceptions.throwIfFatal는 RxJava에서 정의한 치명적인 에러만 throw 합니다. 

결국, RxJava의 스펙으로 인해 JUnit의 expected를 판단하는 조건에 부합하지 않게 되어 테스트 결과는 예상과 달라지게 됩니다.

```java
public final class ConsumerSingleObserver<T> ... {
  // ...
  
  @Override
  public void onError(Throwable e) {
    lazySet(DisposableHelper.DISPOSED);
    try {
      onError.accept(e);
    } catch (Throwable ex) {
      Exceptions.throwIfFatal(ex);
      RxJavaPlugins.onError(new CompositeException(e, ex));
    }
  }
  
  @Override
  public void onSuccess(T value) {
    lazySet(DisposableHelper.DISPOSED);
    try {
      onSuccess.accept(value);
    } catch (Throwable ex) {
      Exceptions.throwIfFatal(ex);
      RxJavaPlugins.onError(ex);
    }
  }

  // ...
}
```

> 소스 출처 : https://github.com/ReactiveX/RxJava/blob/3.x/src/main/java/io/reactivex/rxjava3/internal/observers/ConsumerSingleObserver.java

## 좀 더 안정적으로 테스트해보자

지금까지 RxJava 사용 시 테스트 실패를 제대로 감지 못하는 케이스와 그 원인을 살펴봤습니다. 이후에는 실제로 테스트가 동작하도록 개선해봅니다.

### 방법 1. Mockito는 대안이 될까?

첫 번째로 시도할 방법은 바로 [Mockito](https://site.mockito.org/)입니다. 다양한 API 중 샘플에서 필요한 것은 Argument 값을 체크하는 기능이 필요합니다. 바로 Mockito에서는 [ArgumentMatcher](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/ArgumentMatcher.html)/[ArgumentCaptor](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/ArgumentCaptor.html)가 그 역할을 합니다.

```kotlin
// ArgumentCaptor
@Test(expected = AssertionError::class)
fun sample_mockito1() {
  // given
  val mockCallback: (Int) -> Unit = mock()
  
  // when
  testCase(mockCallback)

  // then
  val paramCapture = argumentCaptor<Int>()
  verify(mockCallback).invoke(paramCapture.capture())

  // 강제로 fail 처리
  fail("Result:${paramCapture.firstValue}")
}

// ArgumentMatcher
@Test(expected = AssertionError::class)
fun sample_mockito2() {
  // given
  val mockCallback: (Int) -> Unit = mock()
  
  // when
  testCase(mockCallback)

  // then
  // argument 불일치 처리
  verify(mockCallback).invoke(eq(0))
}

// 고정으로 callback의 파라미터로 1이 전달됩니다.
private fun testCase(callback: (Int) -> Int) {
  Single.just(1)
    .subscribe { value ->
      callback(value)
    }
}
```

> 위 코드는 정상적으로 테스트 함수 실행 후, 항상 테스트가 실패하는지 확인합니다.

mocking 한 mockCallback를 생성 후, testCase 함수에 전달하여 Argument를 체크합니다. 기존 mock은 의존성 주입과 return/throw하는 용도로 많이 사용하지만, [ArgumentMatcher](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/ArgumentMatcher.html)/[ArgumentCaptor](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/ArgumentCaptor.html) API는 Argument 체크가 주된 역할입니다. 이 API를 사용하면 손쉽게 Argument 값을 사용하여 테스트 코드를 작성할 수 있습니다.

그러나, `Mockito로도 엣지 케이스는 커버할 수 없습니다`.

- onSuccess 호출 후 콜백으로 전달하기 전, 에러가 발생한 경우
- onError 내부에서 에러가 발생한 경우

분명 테스트 코드는 Best 케이스 체크도 중요하지만, 예외 케이스 체크도 필요한 부분입니다. 결국 이 엣지 케이스에서 발생하는 잠재적인 위험을 해소해야 합니다. 

이어서 엣지 케이스를 커버하는 방법을 살펴보겠습니다.

### 방법 2. RxJavaPlugins API 사용 ... PASSED!!

앞서 살펴본 `RxJava 동작 확인` 내용을 기반으로 RxJava에서 발생하는 에러는 최종적으로 `RxJavaPlugins.onError`로 전달된다는 것입니다. 

우리가 시도할 것은 **RxJavaPlugins.setErrorHandler**를 사용하여 예외를 대응하는 방법입니다.

> 방법 2에서는 RxJava Github에 존재하는 [TestHelper](https://github.com/ReactiveX/RxJava/blob/3.x/src/test/java/io/reactivex/rxjava3/testsupport/TestHelper.java)를 인용했습니다.

> JUnit의 Rule을 사용하여 RxJavaPlugins.setErrorHandler를 처리하는 방법도 참고해 보세요.
>
> - [Unit tests with uncaught exceptions in RxJava chains](https://bryanherbst.com/2020/07/15/rxjava-uncaught-exception-tests)

코드를 살펴보겠습니다. 

- TestHelper#trackPluginErrors : RxJavaPlugins.setErrorHandler로 에러가 유입될 때마다 List에 추가합니다.
- TestHelper#assertUndeliverable : trackPluginErrors으로 전달받은 리스트 중 예상한 에러가 존재 존재하는지 체크합니다.

```kotlin
object TestHelper {
  // RxJavaPlugins#setErrorHandler을 사용하여 예외를 수집
  fun trackPluginErrors(): List<Throwable> {
    val list: MutableList<Throwable> = Collections.synchronizedList(ArrayList())
    RxJavaPlugins.setErrorHandler {
      list.add(it)
    }
    return list
  }
  
  // Outer/Inner 에러 정보가 clazz와 동일한지 체크
  fun assertUndeliverable(list: List<Throwable>, index: Int, clazz: Class<out Throwable>) {
    var ex = list[index]
    // RxJavaPlugins.onError를 통해서 유입된 에러인지 체크
    if (ex !is UndeliverableException) {
      val err = AssertionError(
        "Outer exception UndeliverableException expected but got " + list[index]
      )
      err.initCause(list[index])
      throw err
    }
    ex = ex.cause!!
    if (!clazz.isInstance(ex)) {
      val err = AssertionError(
        "Inner exception " + clazz + " expected but got " + list[index]
      )
      err.initCause(list[index])
      throw err
    }
  }
}
```

위 TestHelper를 사용하여 이전 **방법 1. Mockito**에서 사용한 코드에 적용해봅니다.

아래 코드는 파라미터로 전달한 callback이 호출되기 전, testCaseEarlyFail 함수 내부 처리에 의해서 에러가 발생한 경우입니다. 변경된 부분은 TestHelper.trackPluginErrors 사용하여 에러가 실제로 발생하는지 체크하는 부분입니다.

```kotlin
@Test
fun sample_mockito_with_plugin() {
  // given
  val errors = TestHelper.trackPluginErrors() // 에러가 발생하면 errors에 추가 됨

  val mockCallback: (Int) -> Unit = mock()

  // when
  testCaseEarlyFail(mockCallback)

  // then
  // mockCallback가 호출되기 전 Exception 발생으로 미호출 체크
  verifyNoInteractions(mockCallback)

  // errors[0]에 ArithmeticException가 존재하는지 체크
  TestHelper.assertUndeliverable(errors, 0, ArithmeticException::class.java)
}

// 테스트 함수 : onSuccess 단계에서 Exception을 발생
private fun testCaseEarlyFail(callback: (Int) -> Unit) {
  Single.just(1)
    .subscribe { value ->
      value / 0 // <-- callback이 호출되기 전, 0 나누기로 에러 발생
      callback(value)
    }
}
```

위와 같이 작성하면 RxJavaPlugins.onError를 통해서 유입된 에러를 손쉽게 체크할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/0219-rxjava-error/001.png" }}" /> 

------

그리고 남은 것은 Upstream에서 에러가 발생한 경우입니다. 이 경우는 로직상에서 발생할 수 있는 예상 범위의 에러이므로 명시적으로 onError 처리해두는 것이 좋습니다. 만약, subscribe에서 onError를 미정의하면 [OnErrorNotImplementedException](https://github.com/ReactiveX/RxJava/blob/3.x/src/main/java/io/reactivex/rxjava3/exceptions/OnErrorNotImplementedException.java)이 발생합니다.

> Error handling : https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#error-handling

본 글에서 사용한 예제는 아래를 참고해주세요.

- https://github.com/Pluu/RxJavaJUnitSample

## 참고 자료

- [ReactiveX/RxJava ~ 2.x: Uncaught errors fail silently in junit tests](https://github.com/ReactiveX/RxJava/issues/5234)
- [ReactiveX/RxJava ~ TestHelper](https://github.com/ReactiveX/RxJava/blob/3.x/src/test/java/io/reactivex/rxjava3/testsupport/TestHelper.java)
- [Unit tests with uncaught exceptions in RxJava chains](https://bryanherbst.com/2020/07/15/rxjava-uncaught-exception-tests)
- [MERGING RXJAVA OBSERVABLES CONSIDERED HARMFUL — PART II](https://www.droidcon.com/2021/09/13/merging-rxjava-observables-considered-harmful-part-2)
- [uber/AutoDispose ~ RxErrorsRule](https://github.com/uber/AutoDispose/blob/main/test-utils/src/main/java/autodispose2/test/RxErrorsRule.java)
