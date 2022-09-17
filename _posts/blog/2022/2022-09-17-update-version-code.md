---
layout: post
title: "[메모] 앱의 Version Code 변경"
date: 2022-09-17 19:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

> 샘플 코드 : https://github.com/Pluu/VersionCodeUpdaterSample

## 방법 1) defaultConfig 속성 수정

```kotlin
// app/build.gradle.kts
android {
  defaultConfig {
    versionCode = 1 // 적용되는 Version Code
  }
}
```

## 방법 2) Flavor를 통해서 정의

```kotlin
// app/build.gradle.kts
android {
  defaultConfig {
    versionCode = 1
  }

  flavorDimensions += "version"
  productFlavors {
    create("demo") {
      dimension = "version"
      versionCode = 1234 // 최종 적용되는 Version Code
    }
  }
}
```

## 방법 3) androidComponents의 onVariants를 사용

```kotlin
// app/build.gradle.kts
android {
  defaultConfig {
    versionCode = 1
  }

  flavorDimensions += "version"
  productFlavors {
    create("demo") {
      dimension = "version"
      versionCode = 3
    }
  }
}

androidComponents {
  finalizeDsl {
    it.defaultConfig.versionCode = 2
  }
  onVariants { variant ->
    variant.outputs.forEach { output ->
      output.versionCode.set(1234) // 최종 적용되는 Version Code
    }
  }
}
```

방법 4에서 적용되는 Version Code가 순서

1. android.defaultConfig.versionCode : `1` 적용
2. androidComponents.finalizeDsl : `2` 적용
3. android.productFlavors : `3` 적용
4. androidComponents.onVariants : `1234` 적용

### 적용 결과

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2022/09017-versioncode/001.png" }}" />

## 참고

- Extend the Android Gradle plugin : https://developer.android.com/studio/build/extend-agp