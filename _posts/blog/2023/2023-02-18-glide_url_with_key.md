---
layout: post
title: "Glide 이미지 로드에 Custom Cache Key 사용하기"
date: 2023-02-18 14:30:00 +09:00
tag: [Android, Glide]
categories:
- blog
- Android
- Glide
---

이번 글에서는 Glide 사용 시에 Cache Key를 커스텀해서 캐싱을 유도하는 방법을 소개하겠습니다.

<!--more-->

ImageLoader로 안드로이드에서 많이 사용하는 Glide는 ImageUrl 기준으로 다운로드하며 캐싱됩니다.

```kotlin
Glide.with(this)
  .load(/** imge url */)
  .into(binding.imageView)
```

로드된 이미지가 어디에서 얻어졌는지도 [RequestListener](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.request/-request-listener/index.html)에 정의된 [DataSource](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load/-data-source/index.html?query=enum%20DataSource)값으로 확인할 수 있습니다.

- LOCAL
- REMOTE
- DATA_DISK_CACHE
- RESOURCE_DISK_CACHE
- MEMORY_CACHE

## Glide의 이미지 로드

실제로 이미지 로드에 사용하는 [load 함수](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide/-request-manager/load.html)에 전달할 수 있는 타입은 Bitmap/Drawable/String/Uri/File/Integer/Array\<Byte\>/Any 형태를 지원하고 있습니다. 다양한 형태로 전달된 데이터는 Glide에 [미리 정의된 타입별로 처리를 정의한 RegistryFactory](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RegistryFactory.java)의 내용대로 동작합니다.

일반적으로 http/https로 시작하는 이미지 주소는 Glide 내부에서 몇 가지의 단계를 거쳐서 이미지가 읽어집니다.

1. Glide에 String 타입의 Image Url로 호출
2. [StringLoader](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-string-loader/index.html?query=open%20class%20StringLoader%3CData%3E%20:%20ModelLoader%3CModel,%20Data%3E) : String인 경우에는 [몇 가지의 Loader가 존재](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RegistryFactory.java#L319-L324)하지만 네트워크를 통한 이미지 로드는 StringLoader가 호출됨
3. [UrlUriLoader](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-url-uri-loader/index.html) : 호출하려는 이미지 주소가 [http/https](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/model/UrlUriLoader.java#L36-L39)로 시작하는 Uri인 경우 호출됨 
4. [HttpGlideUrlLoader](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model.stream/-http-glide-url-loader/index.html?query=open%20class%20HttpGlideUrlLoader%20:%20ModelLoader%3CModel,%20Data%3E) : UrlUriLoader에서 [GlideUrl 클래스로 타입 변경](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/model/UrlUriLoader.java#L29-L34) 후 호출됨
5. [HttpUrlFetcher](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.data/-http-url-fetcher/index.html?query=open%20class%20HttpUrlFetcher%20:%20DataFetcher%3CT%3E) : 네트워크 이미지를 InputStream로 변환

{% include img_assets.html id="/blog/2023/0218-glide/001.png" %}

UrlUriLoader를 디버깅하면 GlideUrl 인스턴스를 생성한 후, HttpGlideUrlLoader에 전달하는 것을 확인할 수 있습니다.

### GlideUrl & Key

HttpGlideUrlLoader에서 사용되는 [GlideUrl](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-glide-url/index.html) 클래스가 이번 글의 핵심 클래스입니다. 이번에 필요한 기능으로 (1) 이미지 캐시 키를 커스텀하면서 (2) 정상적으로 이미지를 호출해야 하는 2가지 조건이 필요합니다. GlideUrl 내부에 이번 내용에 관련된 중요한 함수를 찾을 수 있습니다.

```
open fun getCacheKey(): String
- 디스크 캐시 키로 사용할 문자열을 반환

open fun toStringUrl(): String
- http/https 요청을 만드는 데 사용할 수 있는 문자열 URL을 반환
```

그리고, GlideUrl이 구현하는 [Key](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load/-key/index.html) 인터페이스도 캐싱에 관련된 정의가 있습니다.

```
abstract fun equals(o: Any): Boolean
- 캐싱이 올바르게 작동하려면 구현에서 이 메서드와 hashCode를 구현해야 합니다.

abstract fun hashCode(): Int
- 캐싱이 올바르게 작동하려면 구현에서 이 메서드와 같음을 구현해야 합니다.
```

실제로 GlideUrl 클래스는 [GlideUrl#getCacheKey](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-glide-url/get-cache-key.html)를 사용하여 Key 인터페이스를 구현하고 있습니다.

```java
public class GlideUrl implements Key {
  ...
  @Override
  public boolean equals(Object o) {
    if (o instanceof GlideUrl) {
      GlideUrl other = (GlideUrl) o;
      return getCacheKey().equals(other.getCacheKey()) && headers.equals(other.headers);
    }
    return false;
  }

  @Override
  public int hashCode() {
    if (hashCode == 0) {
      hashCode = getCacheKey().hashCode();
      hashCode = 31 * hashCode + headers.hashCode();
    }
    return hashCode;
  }
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/model/GlideUrl.java#L131-L147

## Custom CacheKey 작업

앞서 UrlUriLoader에서 사용되는 GlideUrl에서 중요한 키 포인트인 [getCacheKey 함수](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-glide-url/get-cache-key.html)를 발견했습니다. 앞으로 할 작업은 매우 간단합니다. Glide에 커스텀 ModelLoader까지 구현하는 것도 방법이지만, 본 글에서는 가볍게 GlideUrl를 상속해서 해결하겠습니다.

```kotlin
class GlideUrlWithCacheKey(
  imageUrl: String,
  private val cacheKey: String
) : GlideUrl(imageUrl) {
  override fun getCacheKey(): String = cacheKey // 생성자로 주입받은 별도 캐시 키를 활용
}
```

그리고, GlideUrlWithCacheKey 클래스를 사용해서 Glide를 사용하면 됩니다.

```kotlin
Glide.with(this)
  .load(GlideUrlWithCacheKey(imageUrl = /** imge url */, cacheKey = /** Cache Key */))
  .into(binding.imageView)
```

### Custom CacheKey 동작 모습

{% include youtube.html id="UiOV5744858" %}

> 샘플 소스 : https://github.com/Pluu/GlideCacheKeySample

위 샘플은 두 개의 버튼에 각각 다른 Image Url과 동일한 캐시 키를 사용한 예제의 모습입니다. 최초 로드된 이미지를 기준으로 캐싱이 일어나므로 데이터 초기화한 후에는 다른 이미지가 캐싱되는 것을 볼 수 있습니다.

### GlideUrlWithCacheKey 동작 원리

Glide에는 타입별로 어떤 처리를 할지 정의하는 [RegistryFactory](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RegistryFactory.java)가 있다고 서두에 언급했습니다. RegistryFactory에 이번에 사용한 GlideUrl이 어떻게 처리할지에 대한 정보도 이미 정의되어 있어서, 별도 수정 없이 기존 Glide가 처리하는 방식 그대로 사용할 수 있습니다.

```java
.append(GlideUrl.class, InputStream.class, new HttpGlideUrlLoader.Factory())
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RegistryFactory.java#L354

만약, GlideUrl을 상속하지 않는다면 Model 처리가 불가능한 것으로 로그가 출력됩니다.

{% include img_assets.html id="/blog/2023/0218-glide/002.png" %}
