---
layout: post
title: "Glide 요청 가로채기"
date: 2021-09-12 13:15:00 +09:00
tag: [Android, Glide]
categories:
- blog
- Android
---

본 글은 Glide 요청을 가로채서 다른 결과로 반환할 수 있다는 것을 다루는 글입니다.

<!--more-->

먼저 본 글에서 다룰 내용의 결과를 보겠습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/m0xRlFLUEG4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

샘플은 Glide를 통해 `ABCD`를 호출했을 때, 다른 이미지가 UI에 노출합니다. 또한 Logcat에 출력된 Glide 로그에서도 확인할 수 있습니다.

## 이미지 처리 방식

기본적으로 Glide는 `load` 함수에 전달된 모델 정보를 사용해서 이미지를 가져옵니다

```kotlin
Glide.with(this)
   .load(/** source */)
   .into(/** target */)
```

그리고, load 함수에서 사용할 수 있는 타입을 기본적으로 제공하고 있습니다.

- Bitmap
- Drawable
- String
- Uri
- File
- Drawable Resource ID
- URL
- Byte[]
- Object

Glide는 다양한 타입을 지원하기 위해서 Glide 객체 생성시에 `이미지 로딩/인코딩/디코딩` 처리를 [**Registry**](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/Registry.java) 에 등록하는 형태로 되어있습니다.

> https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/Registry.java

간략하게 내부 동작을 정리하면 아래와 같은 형태입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0912-glide/002.png" }}" />

## ModelLoader에 대해서 살펴보기

### (1) ModelLoader 기본 개념

**가로채기 기능**을 적용하기 전, 먼저 살펴볼 내용으로 ModelLoader가 있습니다. Glide 공식 문서에서는 아래와 같이 설명하고 있습니다.

> Glide는 일반적인 유형의 모델(URL, Uris, 파일 경로 등)에 대한 기본 지원을 제공하지만 때때로 Glide가 지원하지 않는 유형을 실행할 수 있습니다. Glide의 기본 동작을 커스텀하거나 조정하려는 경우에도 실행할 수 있습니다. Glide의 [통합 라이브러리](https://bumptech.github.io/glide/int/about.html)에서 사용할 수 있는 것 외에 이미지를 가져오는 새로운 방법이나 새로운 네트워킹 라이브러리를 통합하고 싶을 수도 있습니다.
>
> 출처 : https://bumptech.github.io/glide/tut/custom-modelloader.html

여기서 언급한 `모델`을 통해 구체적인 이미지/리소스 데이터를 얻는데 사용되는 인터페이스가 `ModelLoader`입니다.

> https://bumptech.github.io/glide/javadocs/440/com/bumptech/glide/load/model/ModelLoader.html

Glide에서 기본적으로 제공하는 타입 또한 Glide 객체 생성시에 ModelLoader가 등록되도록 구현되어 있습니다.

> 자세한 구현 케이스는 다음 링크를 참고해 주세요. 
>
> https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/Glide.java#L376

```kotlin
Glide.with(this)
   .load(/** Image Url */)
   .into(/** target */)
```

`String`으로 전달된 ImageUrl 통해서 Glide의 이미지 로딩은 아래와 같은 흐름을 거쳐 ImageView에 필요한 BitmapDrawable로 변형됩니다.

1. StringLoader.StreamFactory<String, InputStream> // String을 Uri로 변환 후 다른 Loader에 위임
2. UrlUriLoader<Uri, GlideUrl> // Uri를 GlideUrl로 변환
3. OkHttpUrlLoader<GlideUrl, InputStream> // GlideUrl을 InputStream으로 변환
4. OkHttpStreamFetcher // 실제 OkHttp를 통해서 Stream을 가져옴
5. StreamEncoder // InputStream을 File로 저장
6. ByteBufferFileLoader<File, ByteBuffer> // File을 ByteBuffer로 변환
7. ByteBufferFetcher // 실제 Disk로부터 이미지를 읽는 Loader가 동작
8. ByteBufferBitmapDecoder // ByteBuffer를 Bitmap으로 변환
9. BitmapDrawableTranscoder // Bitmap을 Glide의 LazyBitmapDrawableResource로 변환 (지연 BitmapDrawable 생성)

실제로 Glide는 load에 사용된 Model 타입을 통해 처리에 필요한 Loader가 호출되고, 그 처리를 다른 곳으로 `위임`합니다.

> String은 **String > Uri > GlideUrl > InputStream > File > ByteBuffer > BitmapDrawable** 순서로 단계를 거치고 있습니다. 

> 이미지 로딩에 사용된 인터페이스는 아래를 참고해 주세요.
>
> - ModelLoaderFactory : https://bumptech.github.io/glide/javadocs/400/com/bumptech/glide/load/model/ModelLoaderFactory.html
> - ModelLoader : https://bumptech.github.io/glide/javadocs/400/com/bumptech/glide/load/model/ModelLoader.html
> - DataFetcher : https://bumptech.github.io/glide/javadocs/440/com/bumptech/glide/load/data/DataFetcher.html

### (2) Custom ModelLoader 주입

이제 앞서 살펴본 내용은 `ABCD`라는 String을 다른 이미지로 교체하는 예제였습니다. 이후에서는 String으로 들어온 요청을 다른 이미지로 바꾸는 **ModelLoader**를 추가하는 부분을 다룹니다. 이때 ModelLoader을 추가하기 위해서 사용할 객체가 `Registry`입니다. Registry는 GlideModule의 registerComponents 함수로 전달받은 매개변수를 통해서 사용할 수 있습니다.

> Registering Components : https://bumptech.github.io/glide/doc/configuration.html#registering-components

```kotlin
@GlideModule
class MyAppGlideModule : AppGlideModule() {
  override fun registerComponents(context: Context, glide: Glide, registry: Registry) {
    // Add, custom model loader
    registry.append(
      String::class.java, // "ABCD"는 String이므로 Model Class로 String Class를 전달
      InputStream::class.java, // 기존과 동일한 InputStream으로 처리
      CustomAssetModelLoader.Factory() // "가로채기" 기능이 정의된 ModelLoader.Factory를 전달
    )
  }
}
```

registry에는 ModelLoaderFactory를 등록하는 기능으로 2개의 함수가 존재합니다.

- append
- prepend

우리가 할 작업은 기존 동작보다 **먼저 동작**시켜야 합니다. 그렇기에 `prepend` 함수를 통해서 ModelLoader.Factory를 등록합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0912-glide/003.png" }}" />

> registry#prepend를 사용한 결과, glide 내부에 정의된 ModelLoaderFactory보다 List의 앞쪽에 위치합니다.

만약 registry#append 사용할 경우의 결과는 아래와 같습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0912-glide/004.png" }}" />

> registry#append를 사용한 결과, glide 내부에 정의된 ModelLoaderFactory보다 뒤쪽에 위치합니다.

## Custom ModelLoader 구현

지금까지 Glide의 동작과 ModelLoader에 대해서 살펴봤습니다. 이 파트에 실제 `가로채기` 기능을 구현할 단계입니다. 

### CustomAssetModelLoader.Factory 선언

먼저 살펴볼 부분은 CustomAssetModelLoader를 생성할 ModelLoaderFactory입니다. Registry에 별도 Model을 처리하는 ModelLoader를 등록할 때에는 ModelLoaderFactory를 주입하는 형태입니다. 

샘플에서는 **Asset 폴더** 아래에 있는 이미지로 교체해보겠습니다.

> - append : https://bumptech.github.io/glide/javadocs/470/com/bumptech/glide/Registry.html#append-java.lang.Class-java.lang.Class-com.bumptech.glide.load.model.ModelLoaderFactory-
> - prepend : https://bumptech.github.io/glide/javadocs/470/com/bumptech/glide/Registry.html#prepend-java.lang.Class-java.lang.Class-com.bumptech.glide.load.model.ModelLoaderFactory-

```kotlin
class CustomAssetModelLoader(
  private val uriLoader: ModelLoader<Uri, InputStream>
) : ModelLoader<String, InputStream> {
  
  // ModelLoader 구현은 이어서 추가 설명할 예정입니다.
  
  class Factory : ModelLoaderFactory<String, InputStream> {
    override fun build(multiFactory: MultiModelLoaderFactory): ModelLoader<String, InputStream> {
      // 실제 ModelLoader 인스턴스를 반환합니다.
      // 
      // Asset 폴더에 있는 이미지를 접근하기 위해서 Uri 모델을 사용할 것 입니다.
      // 샘플에서는 ModelLoader에서는 별도 DataFetcher를 구현하지 않고
      // Uri를 처리할 수 있는 다른 ModelLoader에 위임하기 위해 ModelLoader#build를 사용했습니다합니다.
      return CustomAssetModelLoader(
        multiFactory.build(Uri::class.java, InputStream::class.java)
      )
    }

    override fun teardown() {
      // Do nothing
    }
  }
}
```

### CustomAssetModelLoader 선언

이제 Glide를 통해서 요청받은 Model을 Asset에 있는 이미지를 읽도록 가로채는 부분입니다. ModelLoader를 구현할 때, 아래 함수의 구현이 필요합니다.

- handles : 파라미터로 전달된 Model이 현재 ModelLoader가 처리 가능한지 반환합니다.
- buildLoadData : Model 처리하는 곳입니다. 직접 처리할 수도 있지만, 다른 ModelLoader로 위임할 수도 있습니다.

> https://bumptech.github.io/glide/javadocs/440/com/bumptech/glide/load/model/ModelLoader.html

```kotlin
class CustomAssetModelLoader(
  private val uriLoader: ModelLoader<Uri, InputStream>
) : ModelLoader<String, InputStream> {
  private val TAG = CustomAssetModelLoader::class.java.simpleName

  private val ASSET_PATH_SEGMENT = "android_asset"
  private val ASSET_PREFIX = ContentResolver.SCHEME_FILE + ":///" + ASSET_PATH_SEGMENT + "/"

  override fun buildLoadData(
    model: String,
    width: Int,
    height: Int,
    options: Options
  ): ModelLoader.LoadData<InputStream>? {
    val uri = getAssetUri()
    return if (uri == null) {
      null
    } else {
      // 샘플에서는 Uri를 직접 처리하지 않고 다른 ModelLoader로 위임합니다.
      // 또한, 직접 LoadData와 DataFetcher를 처리하도록 구현할 수 있습니다.
      return uriLoader.buildLoadData(uri, width, height, options)
    }
  }

  // 교체할 이미지의 Uri를 생성합니다.
  // 여기에서는 Asset 폴더 내부의 샘플 이미지를 사용했습니다.
  private fun getAssetUri(): Uri? {
    return try {
      Uri.parse(ASSET_PREFIX + "pluu.jpeg")
    } catch (e: NotFoundException) {
      Log.w(TAG, "Received invalid asset file: $model", e)
      null
    }
  }

  // Glide load 함수로 String 타입으로 요청된 경우,
  // 해당 ModelLoader에서 처리 여부를 결정합니다.
  // 샘플이므로 항상 true로 선언합니다.
  override fun handles(model: String): Boolean {
    return true
  }
}
```

이것으로 모든 작업이 끝났습니다.

### 결과 화면

Glide로 의미 없는 String 정보를 넘겼을 때에도 가로채기가 성공한 것을 알 수 있습니다. 처리된 DataSource는 `LOCAL`에서 이루어졌으며 `ABCD`가 성공적으로 로드되었다고 로그가 출력됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0912-glide/001.png" }}" />

**안드로이드 로고 이미지를 샘플**

지금까지의 예제를 사용하면 [안드로이드 로고](https://source.android.com/setup/images/Android_symbol_green_RGB.png) 이미지 Url을 다른 이미지로 바꾸더라도 성공한 것으로 이미지와 로그가 보여집니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0912-glide/005.png" }}" />

## Summary

지금까지 Custom ModelLoader를 사용해서 Glide 요청을 임의의 이미지로 반환하는 것을 살펴봤습니다. 

실제 프로젝트에서는 사용할 경우는 매우 드물 것입니다. 간혹 미리 정의된 타입 이외의 Custom Class를 지원하고 싶거나 네트워크가 차단된 환경에서 Glide 동작을 유효하도록 우회해야 할 경우에 유용한 기능일 것입니다.

> 샘플 프로젝트 URL : https://github.com/Pluu/GlideModelLoaderSample

### 참고 자료

- Glide / Writing a custom ModelLoader : https://bumptech.github.io/glide/tut/custom-modelloader.html
- Glide Image Loader: The Advanced : https://medium.com/mobile-app-development-publication/glide-image-loader-the-advanced-9a048624d3e4
