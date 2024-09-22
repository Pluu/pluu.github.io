---
layout: post
title: "Coil 요청 가로채기"
date: 2024-09-22 09:30:00 +09:00
tag: [Android, Coil]
categories:
- blog
- Android
---

본 글은 Coil 요청을 가로채서 다른 결과로 반환할 수 있다는 것을 다루는 글입니다.

<!--more-->

> Glide에서 이미지 요청을 가로채기는 다음 글을 참고해 주세요.
>
> - [Glide 요청 가로채기](https://pluu.github.io/blog/android/2021/09/12/glide-modelloader/)

먼저 본 글에서 다룰 내용의 결과를 보겠습니다.

{% include youtube.html id="qADHYdrrv4E" %}

샘플은 Coil를 통해 `네트워크로부터 이미지를 가져오도록` 호출했을 때, 다른 이미지가 UI에 노출됩니다. 또한 Logcat에 출력된 Coil 로그에서도 확인할 수 있습니다.

> 샘플 프로젝트 URL : https://github.com/Pluu/CoilFetcherSample

## Coil에서 이미지 처리 방식

Compose에서 Coil은 `AsyncImage` Composable 함수에 로드하려는 Model 정보를 통해서 이미지를 가져옵니다.

```kotlin
AsyncImage(
   model = /** Image model */,
   contentDescription = null,
)
```

model로 여러 타입을 지원하고 있습니다.

- String
- HttpUrl
- Uri (android.resource, content, file, http, and https schemes)
- File
- @DrawableRes Int
- Drawable
- Bitmap
- ByteArray
- ByteBuffer

> 출처 : Coil ~ [Supported Data Types](https://coil-kt.github.io/coil/getting_started/#supported-data-types)

### 이미지 처리 파이프라인

Coil은 이미지 처리에 5단계를 거쳐서 노출하고 있습니다.

1. [Interceptor](https://coil-kt.github.io/coil/api/coil-core/coil3.intercept/-interceptor/) : Coil [ImageLoader](https://coil-kt.github.io/coil/api/coil-core/coil3/-image-loader/index.html)의 이미지 엔진에 대한 요청을 Observe, transform, short circuit, retry requests를 처리
2. [Mapper](https://coil-kt.github.io/coil/api/coil-core/coil3.map/-mapper/) : 타입 T의 데이터를 V로 변환하는 인터페이스
   1. 커스텀 데이터 타입을 Fetcher에서 처리할 수 있는 타입으로 매핑
3. [Keyer](https://coil-kt.github.io/coil/api/coil-core/coil3.key/-keyer/) : 타입 T의 데이터를 메모리 캐시용 문자열 키로 변환하는 인터페이스
4. [Fetcher](https://coil-kt.github.io/coil/api/coil-core/coil3.fetch/-fetcher/) : Data(예: URI, 파일 등)를 FetchResult로 변환
   1. Data를 key로 사용하여 remote source(예: 네트워크, 디스크)에서 가져오서 [ImageSource](https://coil-kt.github.io/coil/api/coil-core/coil3.decode/-image-source/index.html)로 노출
   2. 데이터를 직접 읽고 Coil [Image](https://coil-kt.github.io/coil/api/coil-core/coil3/-image/index.html)로 변환
5. [Decoder](https://coil-kt.github.io/coil/api/coil-core/coil3.decode/-decoder/) : SourceFetchResult를 DecodeResult로 변환
   1. 추가적인 커스텀 파일 타입(예: GIF, SVG, TIFF 등)에 대한 지원 가능

> 출처 : Coil ~ [Image Pipeline](https://coil-kt.github.io/coil/image_pipeline/)

위 단계를 간략하게 정리하면 아래와 같은 형태입니다. 실제 동작을 이해하기 쉽도록 간소화한 형태이므로 참고만 해주세요.

{% include img_assets.html id="/blog/2024/0922-coil/01.png" %}

### String Url이 전달된 경우, 이미지 불러오는 단계

1. EngineInterceptor#intercept
2. StringMapper#map // String을 Uri로 변환
3. UriKeyer#key // Uri를 기준으로 캐시 관련 키를 생성
4. HttpUriFetcher#fetch // Url을 통해 이미지 취득
5. BitmapFactoryDecoder#decode // Fetcher에서 전달된 ImageSource를 사용하여 Bitmap으로 변환하여 반환

## Coil의 커스텀 가능한 단계를 살펴보기

Coil의 [ImageLoader](https://coil-kt.github.io/coil/api/coil-core/coil3/-image-loader/index.html)가 이미지 요청을 처리에 사용하는 모든 컴포넌트가 보관되는 곳이 [ComponentRegistry](https://coil-kt.github.io/coil/api/coil-core/coil3/-component-registry/)입니다. 이 클래스를 사용하여 이미지 처리의 5단계 모두 커스텀 정의를 추가하는 것이 가능합니다.

해당 정의는 [ImageLoader.Builder의 components](https://coil-kt.github.io/coil/api/coil-core/coil3/-image-loader/-builder/index.html)에서 추가하면 됩니다.

```kotlin
val imageLoader = ImageLoader.Builder(context)
   .components { // <- ComponentRegistry.Builder의 Scope DSL 영역
      add(CustomCacheInterceptor())
      add(ItemMapper())
      add(HttpUrlKeyer())
      add(CronetFetcher.Factory())
      add(GifDecoder.Factory())
   }
   .build()
```

> 출처 : Coil ~ [Image Pipeline](https://coil-kt.github.io/coil/image_pipeline/)

그리고, 5단계 중 우리가 원하는 `요청을 가로채서 다른 이미지로 반환`이 가능한 곳은 Interceptor/Fetcher 2곳입니다.

### Interceptor

Interceptor에서는 [intercept](https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/intercept/Interceptor.kt#L14) 함수의 결과로 ImageResult를 반환합니다. ImageResult 인터페이스의 SuccessResult 구현체에는 성공 이미지를 Drawable을 가지고 있습니다. Interceptor에서 바로 결과를 반환한다면 이미지 처리 5단계 중 1단계에서 이루어집니다.

```kotlin
// https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/intercept/Interceptor.kt
fun interface Interceptor {
   suspend fun intercept(chain: Chain): ImageResult
   ...
}

// https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/request/ImageResult.kt
sealed interface ImageResult {
   abstract val drawable: Drawable?
   abstract val request: ImageRequest
}

class SuccessResult(
   override val drawable: Drawable,
   ...
) : ImageResult {
   ...
}
```

### Fetcher

Fetcher에서는 [fetch](https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/fetch/Fetcher.kt#L23) 함수의 결과로 FetchResult를 반환합니다. FetchResult 인터페이스의 구현체로 SourceResult/DrawableResult가 있는데, 둘 다 이미지 정보를 전달할 수 있습니다. 

- SourceResult : ImageSource를 통해서 디코딩할 이미지 데이터를 전달
- DrawableResult : Drawable

```kotlin
// https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/fetch/Fetcher.kt
fun interface Fetcher {
   suspend fun fetch(): FetchResult?
   ...
}

// https://github.com/coil-kt/coil/blob/2.7.0/coil-base/src/main/java/coil/fetch/FetchResult.kt
sealed class FetchResult

class SourceResult(
   val source: ImageSource,
   ...
) : FetchResult() {
   ...
}

class DrawableResult(
   val drawable: Drawable,
   ...
) : FetchResult() {
   ...
}
```

## 커스텀 이미지 반환 구현

참고로 원하는 동작을 위해서는 Interceptor/Fetcher 둘 중 어느 것을 사용해도 됩니다. 생각보다 코드는 매우 단순합니다.

### 방법 1. 커스텀 Interceptor 구현

```kotlin
class CustomInterceptor(
   private val context: Context
) : Interceptor {

   private val httpsSchemes = Collections.unmodifiableSet(
      setOf("http", "https")
   )

   private val imageFile = "pluu.jpeg"

   override suspend fun intercept(chain: Interceptor.Chain): ImageResult {
      val value = chain.request.data.toString()
      if (isApplicable(value)) {
         // intercept할 경우라면, 교체할 이미지 Drawable을 SuccessResult에 전달하여 반환
         return SuccessResult(
            drawable = getInterceptDrawable(),
            request = chain.request,
            dataSource = DataSource.DISK
         )
      }
      return chain.proceed(chain.request)
   }

   // http/https로 유입된 경로만 intercept하도록 정의
   private fun isApplicable(data: String): Boolean {
      return httpsSchemes.any { data.startsWith(it) }
   }
  
   private fun getInterceptDrawable(): Drawable {
      // 여기에서는 Asset 폴더 내부의 샘플 이미지를 사용했습니다.
      return requireNotNull(
         Drawable.createFromStream(
            context.assets.open(imageFile),
            null
         )
      )
   }
}
```

### 방법 2. 커스텀 Fetcher 구현

```kotlin
class CustomFetcher(
   private val data: Uri,
   private val options: Options
) : Fetcher {

   private val httpsSchemes = Collections.unmodifiableSet(
      setOf("http", "https")
   )

   private val imageFile = "pluu.jpeg"

   override suspend fun fetch(): FetchResult? {
      if (!isApplicable(data)) return null

      // intercept할 경우라면, 교체할 이미지 Drawable을 DrawableResult에 전달하여 반환
      return DrawableResult(
         drawable = getInterceptDrawable(options.context),
         isSampled = false, // 샘플에서는 별도 샘플링 처리는 생략합니다.
         dataSource = DataSource.DISK
      )
   }

   // http/https로 유입된 경로만 intercept하도록 정의
   private fun isApplicable(data: Uri): Boolean {
      return httpsSchemes.contains(data.scheme)
   }

   private fun getInterceptDrawable(context: Context): Drawable {
      // 여기에서는 Asset 폴더 내부의 샘플 이미지를 사용했습니다.
      return requireNotNull(
         Drawable.createFromStream(
            context.assets.open(imageFile),
            null
         )
      )
   }

   class Factory : Fetcher.Factory<Uri> {
      override fun create(
         data: Uri,
         options: Options,
         imageLoader: ImageLoader
      ): Fetcher = CustomFetcher(data, options)
   }
}
```

## 결과 화면

### 요청 가로채기 적용 전

요청을 가로채기 전에는 NETWORK를 통해서 이미지를 가져오는 것으로 로그가 출력하고 있습니다.

- Coil을 사용하여 읽어 들일 이미지 URL : https://source.android.com/setup/images/Android_symbol_green_RGB.png 

{% include img_assets.html id="/blog/2024/0922-coil/02.png" %}

### 요청 가로채기 적용 후

요청을 가로챈 이후에는 커스텀 작업 시에 임의로 정의한 DataSource 정책을 따르며, 샘플에서는 DISK를 사용했으므로 로그에도 동일한 DataSource가 출력됩니다.

{% include img_assets.html id="/blog/2024/0922-coil/03.png" %}

## Summary

지금까지 Custom Interceptor과 Fetcher를 사용해서 Coil 요청을 임의의 이미지로 반환하는 것을 살펴봤습니다.

이전 글과 동일하게 이 기능이 유용할 경우는 매우 드물 것입니다. 특수한 요구사항에 맞춰 우회해야 할 경우에 유용한 기능일 것입니다.
