---
layout: post
title: "Android Studio Flamingo ~ New settings plugin"
date: 2023-01-24 11:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

AGP 8.0.0-alpha09에는 새로운 설정 플러그인이 도입된다는 내용이 Flamingo 릴리즈 노트에 추가되었습니다.

<!--more-->

> New settings plugin : https://developer.android.com/studio/preview/features/#settings-plugin

모듈마다 동일하게 작성해야 했던 android 정보를 `settings plugin`을 사용하여 settings.gradle 파일에 작성할 수 있다고 소개하고 있습니다.

------

포스팅에 사용한 환경 및 샘플

- Android Studio Flamingo beta 1
- Github ~ [New Settings PluginS ample](https://github.com/Pluu/NewSettingsPluginSample)

------

## settings plugin 적용

> 공식 문서를 토대로 정리한 부분이니 업데이트 후에 따라서 설정이 달라질 수 있습니다.

### Step 0. SettingsExtension

새로운 `settings plugin(com.android.settings)` 플러그인에서는 [SettingsExtension](https://developer.android.com/reference/tools/gradle-api/8.0/com/android/build/api/dsl/SettingsExtension) 인터페이스에 있는 프로퍼티를 사용할 수 있습니다. [SettingsExtension](https://developer.android.com/reference/tools/gradle-api/8.0/com/android/build/api/dsl/SettingsExtension) 인터페이스는 현재 Groovy에서만 사용할 수 있지만, 추후에 Kotlin DSL(kts)에서도 Android DSL에 사용될 것이라고 소개하고 있습니다.

몇 가지 프로퍼티가 있지만, buildToolsVersion/compileSdk/minSdk/ndkVersion가 자주 사용될 것으로 보입니다.

### Step 1. root/settings.gradle에 settings plugin 추가

모든 Android 모듈에 공통으로 적용할 수 있는 settings plugin은 프로젝트의 settings.gradle에 작성하여 적용할 수 있습니다. 다만, 현재 settigns plugin은 `Groovy`만 지원하며, **Kotlin DSL(kts)**은 미지원하고 있습니다.

```groovy
// root의 settings.gradle
pluginManagement {
  ...
}

// settings plugin 사용하도록 플러그인 정의
plugins {
  id 'com.android.settings' version '8.0.0-beta01'
}

// android dsl에 필요한 내용 작성
android {
  compileSdk 33
  minSdk 24
}

dependencyResolutionManagement {
  ...
}
```

### Step 2. app/build.gradle 수정

app의 build.gradle에는 setting plugin으로 적용한 항목을 제외한 내용을 정의하면 됩니다.

```groovy
android {
  ...
  defaultConfig {
    ...
    targetSdk 33
    versionCode 1
    versionName "1.0"
  }
  ...
}
```

### Step 3. 결과 확인 

올바르게 적용되었는지 여부는 빌드 결과물의 Manifest 정보를 통해 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0124-setting-plugin/001.png" }}" />

### 번외. app/build.gradle에 재정의 테스트

앞서 소개한 케이스 외에 root/settings.gradle에 정의된 항목을 app/build.gradle에서 재정의할 수도 있습니다.

이 경우에는 최종적으로 app/build.gradle에 적용한 속성이 사용됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2023/0124-setting-plugin/002.png" }}" />