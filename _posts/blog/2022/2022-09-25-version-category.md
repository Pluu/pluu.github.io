---
layout: post
title: "[메모] Gradle의 Version Category를 사용하여 Extra Properties 호환성 유지"
date: 2022-09-25 12:00:00 +09:00
tag: [Android, Gradle]
categories:
- blog
- Android
- Gradle
---

<!--more-->

## 단순 속성 형태의 버전 정보

```groovy
// 변경 전
ext {
  core = "1.9.0"
}

// 변경 후
ext {
  // version category로부터 취득
  core = libs.versions.core.get()
}
```

## 맵 형태의 라이브러리

```groovy
// 변경 전
ext {
  libraries = [
    activity: "androidx.activity:activity-ktx:1.6.0"
  ]
}

// 변경 후
ext {
  def libsFromToml = extensions.getByType(VersionCatalogsExtension).named("libs")
  def librariesValue = [:]
  libsFromToml.libraryAliases.each {
    librariesValue[it] = getLibraryByName(libsFromToml, it)
  }
  libraries = librariesValue
}

private getLibraryByName(VersionCatalog libs, String name) {
    def library = libs.findLibrary(name)
    if (library.isPresent()) {
        return library.get().get()
    } else {
        throw GradleException("Could not find a library for `$name`")
    }
}
```

2단계 이상의 깊이를 사용하는 경우에는 Version Category에서 지원하지 않으므로 별도로 구성해야 합니다.

## 참고

- [Sharing dependency versions between projects](https://docs.gradle.org/current/userguide/platforms.html)