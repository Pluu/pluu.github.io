---
layout: post
title: "Glide 3.5부터의 캐시 처리"
date: 2016-01-19 01:00:00 +09:00
tag: [Android, Glide]
categories:
- blog
- Android
---

최근 Glide의 최신버전은 `3.6.1` (현재 2016년 1월 19일 기준)입니다.

기존에 개인 프로젝트로 Glide를 이용 중 `3.5`부터 Cache 부분이 변경되었다는 것을 뒤늦게 알아차리고 포스팅 해봅니다.

<!--more-->

Glide는 이미지 다운로드 및 Disk/Memory 캐시를 이용하여 더 빠른 이미지 접근을 가능하게 해주는 라이브러리입니다.

### 3.5 이전 Cache 처리

```java
private final static int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
private final static int cacheSize = maxMemory / 8;
private final static int DISK_CACHE_SIZE = 1024 * 1024 * 10;

Glide.setup(new GlideBuilder(this)
			.setMemoryCache(new LruResourceCache(cacheSize))
			.setDiskCache(new DiskCache.Factory() {
				@Override
				public DiskCache build() {
					File cacheLocation = new File(getExternalCacheDir(), "cache");
					cacheLocation.mkdirs();
					return DiskLruCacheWrapper.get(cacheLocation, DISK_CACHE_SIZE);
				}
			}));
```

기존에는 GlideBuilder를 이용하여 캐시 작업이 이루어졌습니다.

Disk 캐시는 외부 캐시폴더 `cache`라는 폴더명을 사용

## 3.5 이후 처리

하지만, 3.5부터는 `GlideModule`을 이용하여 캐시를 설정하도록 변경되었습니다.

#### 작업 사항

1. `GlideModule`를 implements 한 Class 작성
2. `applyOptions`함수 내부에서 Disk/Memory 캐시 작업을 작성
3. `AndroidManifest`에 GlideModule를 이용한 Class 등록

```java
public class MyGlideModule implements GlideModule {
  private final int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
  private final int cacheSize = maxMemory / 8;
  private final int DISK_CACHE_SIZE = 1024 * 1024 * 10;

  @Override
  public void applyOptions(Context context, GlideBuilder builder) {
    builder.setDiskCache(new ExternalCacheDiskCacheFactory(context, "cache", DISK_CACHE_SIZE))
           .setMemoryCache(new LruResourceCache(cacheSize));
  }

  @Override
  public void registerComponents(Context context, Glide glide) {

  }
}
```

## 기타

기존 `Glide.setUp`에 대한 기능은 `Gldie 4.0에 제거 될 예정`입니다.

## 참고 링크
- [Glide Configuration](https://github.com/bumptech/glide/wiki/Configuration)
