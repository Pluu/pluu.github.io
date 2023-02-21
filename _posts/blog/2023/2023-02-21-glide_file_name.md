---
layout: post
title: "Glide에서 디스크 캐싱 시 파일 이름을 정하는 기준"
date: 2023-02-21 23:40:00 +09:00
tag: [Android, Glide]
categories:
- blog
- Android
- Glide
---

본 글에서는 Glide로 로드되는 이미지가 디스크에 캐싱될 때 **이름**을 결정하는 기준을 소개합니다.

<!--more-->

------

사전 조건

- Glide로 로드하려는 이미지는 String으로 된 URL

------

기본적으로 Glide로 이미지를 로드하면 앱 내부에 파일로 캐싱이 됩니다.

```kotlin
Glide.with(this)
  .load(/** imge url */)
  .into(binding.imageView)
```

캐싱될 이미지는 앱의 캐시 폴더 하위 `image_manager_disk_cache`라는 폴더 이름에 적재됩니다. 폴더 아래에 복잡하게 정의된 파일 이름은 어떤 기준으로 생성될까요?

{% include img_assets.html id="/blog/2023/0221-glide/001.png" %}

```java
public class Glide implements ComponentCallbacks2 {
  private static final String DEFAULT_DISK_CACHE_DIR = "image_manager_disk_cache";
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/Glide.java#L54

```java
/** An interface for writing to and reading from a disk cache. */
public interface DiskCache {
  /** An interface for lazily creating a disk cache. */
  interface Factory {
    String DEFAULT_DISK_CACHE_DIR = "image_manager_disk_cache";
  }
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/cache/DiskCache.java#L16

## 파일 생성

### DiskCache

Glide 내부 [DiskCache](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.engine.cache/-disk-cache/index.html?query=interface%20DiskCache) 인터페이스의 구현체인 DiskLrucacheWrapper에 실제로 파일 쓰기 코드가 있습니다. 

{% include img_assets.html id="/blog/2023/0221-glide/002.png" %}

위 스크린샷 기준으로 파일 쓰기를 할 위치와 이름을 보면 앞서 소개한 앱의 캐시 폴더 영역에 암호화된 이름으로 저장하는 모습을 볼 수 있습니다. 이어서 실제로 필요한 코드만 뽑아서 살펴보겠습니다. 

```java
public class DiskLruCacheWrapper implements DiskCache {
  ...
  private final SafeKeyGenerator safeKeyGenerator;
  ...    
  @Override
  public void put(Key key, Writer writer) {
    String safeKey = safeKeyGenerator.getSafeKey(key);
    ...
    DiskLruCache diskCache = getDiskCache();
    ...
    DiskLruCache.Editor editor = diskCache.edit(safeKey);
    ...
    try {
      File file = editor.getFile(0);
      if (writer.write(file)) {
        editor.commit();
      }
    } finally {
      editor.abortUnlessCommitted();
    }
    ...
  }
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/cache/DiskLruCacheWrapper.java#L112-L133

이미지 파일을 쓰기를 위해서 필요한 것은 [DiskLrucacheWrapper#put](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.engine.cache/-disk-lru-cache-wrapper/put.html) 함수의 파라미터로 넘어오는 [Key](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load/-key/index.html) 인터페이스입니다. 그리고, Key 인터페이스를 사용해서 [SafeKeyGenerator#getSafeKey](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.engine.cache/-safe-key-generator/get-safe-key.html) 함수로 `safeKey`를 생성합니다. 

현재 Glide에서는 Key 인터페이스로 아래와 같은 클래스들이 구현하고 있습니다.

{% include img_assets.html id="/blog/2023/0221-glide/003.png" %}

### SafeKeyGenerator

[SafeKeyGenerator](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.engine.cache/-safe-key-generator/index.html)는 [Key](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load/-key/index.html) 인터페이스를 사용해 고유한 문자열 파일 이름을 생성하고 캐싱하는 클래스입니다. getSafeKey 함수에서 캐싱하는 부분도 있지만, 실제로 키를 생성하는 것은 [SafeKeyGenerator#calculateHexStringDigest](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/cache/SafeKeyGenerator.java#L51-L60) 함수입니다.

{% include img_assets.html id="/blog/2023/0221-glide/004.png" %}

아래 이미지를 보면 [SafeKeyGenerator#calculateHexStringDigest](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/cache/SafeKeyGenerator.java#L51-L60) 함수 내부에서 `SHA 256 해시 알고리즘`이 사용된 것을 알 수 있습니다.

{% include img_assets.html id="/blog/2023/0221-glide/005.png" %}

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/cache/SafeKeyGenerator.java#L37-L60

calculateHexStringDigest 함수의 파라미터로 받는 Key 인터페이스의 구현체가 다양하지만, 여기에서는 DataCacheKey가 사용되었습니다. 추가로 DataCacheKey 클래스 내부에는 sourceKey, signature 키 정보가 있습니다. 

이번에는 이미지 로딩에는 String으로 된 URL만 사용했기에 DataCacheKey의 sourceKey에 [GlideUrl](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/model/GlideUrl.java)이 사용되었습니다. 

```java
final class DataCacheKey implements Key {
  private final Key sourceKey;
  private final Key signature;

  DataCacheKey(Key sourceKey, Key signature) {
    this.sourceKey = sourceKey;
    this.signature = signature;
  }
  ...
  @Override
  public void updateDiskCacheKey(@NonNull MessageDigest messageDigest) {
    sourceKey.updateDiskCacheKey(messageDigest);
    signature.updateDiskCacheKey(messageDigest);
  }
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/engine/DataCacheKey.java#L13-L16

### GlideUrl

DataCacheKey에서 [GlideUrl#updateDiskCacheKey](https://bumptech.github.io/glide/javadocs/4140/library/com.bumptech.glide.load.model/-glide-url/update-disk-cache-key.html)를 사용하여 정보를 가져왔습니다. 마지막으로 GlideUrl의 updateDiskCacheKey 함수 코드에서는 `GlideUrl을 생성할 때 주입한 URL`이 최종 사용된 것을 알 수 있습니다.

```java
public class GlideUrl implements Key {
  @Nullable private final URL url;
  @Nullable private final String stringUrl;
  ...
  public String getCacheKey() {
    return stringUrl != null ? stringUrl : Preconditions.checkNotNull(url).toString();
  }

  @Override
  public void updateDiskCacheKey(@NonNull MessageDigest messageDigest) {
    messageDigest.update(getCacheKeyBytes());
  }

  private byte[] getCacheKeyBytes() {
    if (cacheKeyBytes == null) {
      cacheKeyBytes = getCacheKey().getBytes(CHARSET);
    }
    return cacheKeyBytes;
  }
}

```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/load/model/GlideUrl.java

## 정리

지금까지 몇 가지의 단계를 통해서 디스크 캐싱에 적힌 이름이 어떻게 만들어지는지 살펴봤습니다. 단계가 복잡했을 뿐이지 의외로 간단합니다.

load에 사용하는 `이미지 Url`을 **SHA 256 해시 알고리즘**을 통해서 만들어진 문자열이 파일 이름으로 사용됩니다.
