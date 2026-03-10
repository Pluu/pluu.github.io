---
layout: post
title: "[메모] Android Studio plugin 개발 시 빌드 오류"
date: 2026-03-10 23:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

Android Studio 플러그인 개발 시 버전 업데이트하면서 발생한 내용을 메모로 남긴다.

<!--more-->

## Plugin 빌드 오류

매번 호환되는 Android Studio 버전에 맞춰서 버전 업데이트를 진행했다. 이상하게도 `Panda` 버전부터 Android Studio 이미지를 가져오는 것이 실패했다.

### 빌드 환경 확인

```kotlin
// root build.gralde.kts
plugins {
   ...
   alias(libs.plugins.intelliJPlatform) // org.jetbrains.intellij.platform 2.11.0 버전 사용
   ...
}
```


```kotlin
// 모듈 build.gradle.kts
dependencies {
   intellijPlatform {
      androidStudio("2025.3.2.6")
   }
}
```

### 빌드 실패 로그

```shell
Could not determine the dependencies of task ':compileJava'.
> Could not resolve all files for configuration ':intellijPlatformDependency'.
   > Could not find com.google.android.studio:android-studio:2025.3.2.6.
     Searched in the following locations:
       - https://repo.maven.apache.org/maven2/com/google/android/studio/android-studio/2025.3.2.6/android-studio-2025.3.2.6.pom
       - https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2025.3.2.6/android-studio-2025.3.2.6-https:/edgedl.me.gvt1.com/android/studio/install/2025.3.2.6/android-studio-panda2-mac_arm.dmg
       - https://redirector.gvt1.com/edgedl/android/studio/install/2025.3.2.6/android-studio-2025.3.2.6-https:/edgedl.me.gvt1.com/android/studio/install/2025.3.2.6/android-studio-panda2-mac_arm.dmg
       - https://cache-redirector.jetbrains.com/www.jetbrains.com/intellij-repository/releases/com/google/android/studio/android-studio/2025.3.2.6/android-studio-2025.3.2.6.pom
       - https://cache-redirector.jetbrains.com/www.jetbrains.com/intellij-repository/snapshots/com/google/android/studio/android-studio/2025.3.2.6/android-studio-2025.3.2.6.pom
       - https://cache-redirector.jetbrains.com/intellij-dependencies/com/google/android/studio/android-studio/2025.3.2.6/android-studio-2025.3.2.6.pom
       - https://cache-redirector.jetbrains.com/plugins.jetbrains.com/maven/com/google/android/studio/android-studio/2025.3.2.6/android-studio-2025.3.2.6.pom
```

## 원인

IntelliJ 기반 플러그인에 필요한 [intellij-platform-gradle-plugin](https://github.com/JetBrains/intellij-platform-gradle-plugin) Github에서 해당 이유를 찾을 수 있었다. 

[verifyPlugin failed for Android Studio](https://github.com/JetBrains/intellij-platform-gradle-plugin/issues/2087) 이슈의 내용으로 최근 Android Studio의 아카이브 형식이 변경되었다고 한다.

- 변경 전 : 버전 번호를 사용
- 변경 후 : `panda`와 같은 코드명을 URL 문자열에 포함

[https://developer.android.com/studio/archive](https://developer.android.com/studio/archive) 에서도 동일한 모습을 확인할 수 있다

{% include img_assets.html id="/blog/2026/0310/Otter3.png" %}

{% include img_assets.html id="/blog/2026/0310/Panda2.png" %}

## 해결법

해결법은 너무나도 간단하게 `org.jetbrains.intellij.platform` plugin을 [2.12.0](https://github.com/JetBrains/intellij-platform-gradle-plugin/releases/tag/2.12.0) 버전으로 업데이트하면 된다.

기반 플러그인 측에서 수정되어서 해결되었다.

```kotlin
// root build.gralde.kts
plugins {
   ...
   alias(libs.plugins.intelliJPlatform) // org.jetbrains.intellij.platform 2.12.0 버전 사용
   ...
}
```
