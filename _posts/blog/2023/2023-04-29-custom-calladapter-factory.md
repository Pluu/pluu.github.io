---
layout: post
title: "Retrofit에서 API 성공/응답이 분리된 응답으로 반환하는 Custom Adapter 만들기"
date: 2023-04-29 19:30:00 +09:00
tag: [Android, Retrofit]
categories:
- blog
- Android
---

본 글은 Retrofit에서 Custom [CallAdapter.Factory](https://square.github.io/retrofit/2.x/retrofit/retrofit2/CallAdapter.Factory.html)를 다루는 방법을 소개합니다.

<!--more-->

------

- 샘플 소스 : https://github.com/Pluu/CustomCallAdapterSample
- Arrow의 [EitherCallAdapterFactory](https://github.com/arrow-kt/arrow/tree/main/arrow-libs/core/arrow-core-retrofit)를 참고+수정한 내용입니다.

🚧🚧🚧 CallAdapterFactory를 알아보는 샘플이므로 실제 업무에 사용 시 주의해 주세요. 🚧🚧🚧

------

## CallAdapterFactory

Retrofit 사용 시 응답값을 RxJava로 반환하고 싶을 때 다음과 같이 [RxJava3CallAdapterFactory](https://github.com/square/retrofit/blob/master/retrofit-adapters/rxjava3/README.md)를 CallAdapterFactory에 추가합니다.

```java
interface MyService {
  @GET("/user")
  Observable<User> getUser();
}

Retrofit retrofit = new Retrofit.Builder()
  .baseUrl("https://example.com/")
  .addCallAdapterFactory(RxJava3CallAdapterFactory.create())
  .build();
```

그리고, Coroutine suspend 형태라면, 별도 CallAdapterFactory 없이도 사용할 수 있습니다.

## 에러 분리가 필요하다면?

아래와 같이 Coroutine suspend로 API를 호출을 할 수 있습니다. 그리고, Coroutine suspend 사용할 때 에러로 앱 종료를 막기 위해서 CoroutineExceptionHandler가 필요합니다.

```kotlin
interface GitHubService {
  @GET("/users/Pluu")
  suspend fun getUserDefault(): User
}

fun trySuccessCaseDefault() {
  val ceh = CoroutineExceptionHandler { _, t ->
    // TODO: exception action
  }
  viewModelScope.launch(ceh) {
    val result = api.getUserDefault()
    // TODO: success action
  }
}
```

위 코드에서 CoroutineExceptionHandler이 호출될 수 있는 경우는 몇 가지 케이스가 존재합니다.

- API 요청 실패 (API 서버로 부터 실패 / 네트워크 끊어짐)
- viewModelScope 내부의 로직에 의한 호출

이 2가지의 케이스 모두 CoroutineExceptionHandler에서 단일 처리로 대응하더라도 큰 어려움은 없을 것입니다. 하지만, 필요에 따라서 분리하여 대응할 필요도 있습니다. 이 문제를 해결하는 몇 가지의 방법도 있습니다.

1. (난이도 하) API 요청하는 곳에서 try/catch 처리
2. (난이도 하) CoroutineExceptionHandler의 Throwable로 if/else 처리
3. (난이도 중/상) Retrofit의 CallAdapterFactory로 일괄 처리

1/2번 방법은 필요한 곳마다 사용하게 되면 유사한 코드가 여러 곳에 존재하게 되는 `보일러플레이트 코드`가 생산됩니다. 난이도는 좀 더 높지만, 한 번만 작성면 중복코드를 최소화할 수 있는 **`3번 방법`**을 소개하겠습니다.

## 성공/에러가 분리된 CallAdapterFactory

### Step 1. API 응답 모델 정의

네트워크 요청을 모델로 변환하면 아래와 같이 간략하게 표현할 수 있습니다.

- Success : 서버로부터 API 응답 성공
- Failure > HttpError : 서버로부터 API 응답 실패
- Failure > NetworkError : 네트워크 끊어짐과 같은 IOException이 발생하는 경우
- Failure > UnknownApiError : 알 수 없는 오류

```kotlin
sealed interface ApiResult<out T> {
  data class Success<T>(val data: T) : ApiResult<T>

  sealed interface Failure : ApiResult<Nothing> {
    data class HttpError(val code: Int, val message: String, val body: String) : Failure
    data class NetworkError(val throwable: Throwable) : Failure
    data class UnknownApiError(val throwable: Throwable) : Failure
  }
}

inline fun <T> ApiResult<T>.onSuccess(
  action: (value: T) -> Unit
): ApiResult<T> {
  if (isSuccess()) action(getOrThrow())
  return this
}

inline fun <T> ApiResult<T>.onFailure(
  action: (error: ApiResult.Failure) -> Unit
): ApiResult<T> {
  if (isFailure()) action(failureOrThrow())
  return this
}
```

### Step 2. Service Interface 정의

다음 단계로 Step 1에서 정의한 모델로 Retrofit으로 생성할 Service Interface를 정의합니다. ApiResult라는 Wrapper Class에 응답받을 타입을 정의하는 형태로 선언합니다.

```kotlin
interface GitHubService {
  @GET("/users/Pluu")
  suspend fun getUser(): ApiResult<User>
}
```

기존 정의와 바뀐 것은 응답으로 ApiResult Wrapper Class로 감싸졌다는 것뿐입니다.

다음으로 API를 만들었다면 API를 호출하는 코드를 수정하면 변경된 인터페이스에 대한 사용성은 확보했습니다.

```kotlin
fun trySuccessCase() {
  val ceh = CoroutineExceptionHandler { _, t ->
    // TODO: errors caused by logic
  }

  viewModelScope.launch(ceh) {
    api.getUser()
      .onSuccess { result ->
        // TODO: api success action
      }.onFailure { error ->
        // TODO: api failure action
      }
  }
}
```

### Step 3. CallAdapter.Factory 생성

Retrofit으로 생성할 Service Interface의 결과를 바꾸는 것은 [CallAdapter.Factory](https://square.github.io/retrofit/2.x/retrofit/index.html?retrofit2/CallAdapter.Factory.html)에 커스텀을 주입하여 해결할 수 있습니다.

> 샘플에서는 ResultCallAdapterFactory로 정의했습니다.

```kotlin
Retrofit.Builder()
  ...
  .addCallAdapterFactory(ResultCallAdapterFactory())
  .build()
```

그리고, [CallAdapter.Factory#get](https://square.github.io/retrofit/2.x/retrofit/retrofit2/CallAdapter.Factory.html#get-java.lang.reflect.Type-java.lang.annotation.Annotation:A-retrofit2.Retrofit-) 함수를 통해서 API 응답 타입에 맞게 변환하는 [CallAdapter](https://square.github.io/retrofit/2.x/retrofit/retrofit2/CallAdapter.html)를 반환하거나 처리 불가능할 경우 null을 반환합니다.

```kotlin
class ResultCallAdapterFactory : CallAdapter.Factory() {
  override fun get(
    returnType: Type,
    annotations: Array<out Annotation>,
    retrofit: Retrofit
  ): CallAdapter<*, *>? {
    if (getRawType(returnType) != Call::class.java) return null
    check(returnType is ParameterizedType) {
      val name = parseTypeName(returnType)
      "Return 타입은 ApiResult<Foo> 또는 ApiResult<out Foo>로 정의되어야 합니다."
    }

    val wrapperType = getParameterUpperBound(0, returnType)
    if (getRawType(wrapperType) != ApiResult::class.java) return null
    check(wrapperType is ParameterizedType) {
      val name = parseTypeName(returnType)
      "Return 타입은 ApiResult<ResponseBody>로 정의되어야 합니다."
    }

    val bodyType = getParameterUpperBound(0, wrapperType)
    return ApiResultCallAdapter<Any>(bodyType)
  }
}
```

먼저 Return 타입의 RawType이 [Call](https://square.github.io/retrofit/2.x/retrofit/retrofit2/Call.html)이며 ParameterizedType 인지 체크합니다. 다음으로 0번째 인덱스에서 Generic 파라미터의 upper bound가 ApiResult인지 체크합니다. ApiResult에 정의한 Generic 타입을 알기 위해서 wrapperType를 기준으로 타입을 가져와서 ApiResultCallAdapter에 전달합니다.

요약하면 `Call<ApiResult<T>>`로 정의된 형태인지 체크한 후, 타입 `T` 정보를 ApiResultCallAdapter에 전달합니다. ApiResultCallAdapter는 이어서 작성해 볼 Custom [CallAdapter](https://square.github.io/retrofit/2.x/retrofit/retrofit2/CallAdapter.html)입니다.

### Step 4. CallAdapter 생성

CallAdapter 인터페이스를 구현한 ApiResultCallAdapter에서는 adapt 함수에서 `Call<R>`로 호출된 타입을 `Call<ApiResult<R>>`으로 반환합니다. 이번 예제에서는 ApiResult Wrapper Class로 변환을 위해 [Call](https://square.github.io/retrofit/2.x/retrofit/retrofit2/Call.html) 인터페이스를 구현한 ApiResultCall로 반환합니다.

```kotlin
internal class ApiResultCallAdapter<R>(
  private val successType: Type
) : CallAdapter<R, Call<ApiResult<R>>> {  
  override fun adapt(call: Call<R>): Call<ApiResult<R>> = ApiResultCall(call, successType)

  override fun responseType(): Type = successType
}
```

### Step 5. Call 생성

이번 글의 핵심인 **ApiResultCall** 클래스입니다. ApiResultCall에서는 Call\<R\>로 호출되는 인터페이스를 Call\<ApiResult\<R\>\>로 변환합니다.

ApiResultCall 생성자로 전달된 Call의 [Call#enqueue](https://square.github.io/retrofit/2.x/retrofit/retrofit2/Call.html#enqueue-retrofit2.Callback-)를 사용하여 비동기 호출한 후 onResponse/onFailure 메소드에서 반환 타입인 R을 ApiResult\<R\>로 변환합니다.

- onResponse : 서버로부터 전달받은 호출의 성공/에러 응답을 변환
- onFailure : 네트워크 예외가 발생하거나 요청을 만들거나 응답을 처리하는 데 예외가 발생한 케이스를 변환

```kotlin
private class ApiResultCall<R>(
  private val delegate: Call<R>,
  private val successType: Type
) : Call<ApiResult<R>> {

  override fun enqueue(callback: Callback<ApiResult<R>>) = delegate.enqueue(
    object : Callback<R> {

      override fun onResponse(call: Call<R>, response: Response<R>) {
        callback.onResponse(this@ApiResultCall, Response.success(response.toApiResult()))
      }

      private fun Response<R>.toApiResult(): ApiResult<R> {
        // Http 에러 응답
        if (!isSuccessful) {
          val errorBody = errorBody()!!.string()
          return ApiResult.Failure.HttpError(
            code = code(),
            message = message(),
            body = errorBody
          )
        }

        // Body가 존재하는 Http 성공 응답
        body()?.let { body -> return ApiResult.successOf(body) }

        // successType이 Unit인 경우 Body가 존재하지 않더라도 성공으로 간주합니다.
        return if (successType == Unit::class.java) {
          @Suppress("UNCHECKED_CAST")
          ApiResult.successOf(Unit as R)
        } else {
          ApiResult.Failure.UnknownApiError(
            IllegalStateException(
              "Body가 존재하지 않지만, Unit 이외의 타입으로 정의했습니다. ApiResult<Unit>로 정의하세요."
            )
          )
        }
      }

      override fun onFailure(call: Call<R?>, throwable: Throwable) {
        val error = if (throwable is IOException) {
          ApiResult.Failure.NetworkError(throwable)
        } else {
          ApiResult.Failure.UnknownApiError(throwable)
        }
        callback.onResponse(this@ApiResultCall, Response.success(error))
      }
    }
  )
}
```

## 최종 동작 영상

{% include youtube.html id="JuiHswNTt1U" %}

------

참고 자료

- [EitherCallAdapterFactory](https://github.com/arrow-kt/arrow/tree/main/arrow-libs/core/arrow-core-retrofit)
- [Retrofit CallAdapter for Either type](https://proandroiddev.com/retrofit-calladapter-for-either-type-2145781e1c20)
- [Create Retrofit CallAdapter for Coroutines to handle response as states](https://proandroiddev.com/create-retrofit-calladapter-for-coroutines-to-handle-response-as-states-c102440de37a)
- [Building your own Retrofit Call Adapter](https://medium.com/android-news/building-your-own-retrofit-call-adapter-b198169bab69)