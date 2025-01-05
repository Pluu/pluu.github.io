---
layout: post
title: "Library 모듈에서 Instrumentation Test시 볼 수 있는 현상"
date: 2024-12-28 21:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

최근 Library 모듈에서 Instrumentation Test시에 경험한 기록을 남겨봅니다. 해당 작업은 오랜만에 0부터 작업해서 변경된 부분을 놓쳐서 간단하게 남겨둡니다.

<!--more-->

---

## 문제의 현상

안드로이드 개발 시에 테스트는 중요한 부분 중 하나입니다. 멀티 모듈 환경에서 테스트는 더 빛난다는 것은 안드로이드를 개발하는 앱 개발자라면 대부분 알고 있는 사실입니다. 필요한 모듈만 연결되어 빌드되므로 더 빠르게 확인할 수 있다는 점입니다.

각자의 프로젝트 환경마다 다르겠지만, Library 모듈에서 Activity/Compose로 UI 테스트시에 아래와 같은 팝업이 노출될 수 있습니다. 저 같은 경우에는 해당 팝업이 없다면 정상적인 테스트가 통과했지만, 진입 시에 노출되어 올바른 테스트 진행이 안 되었습니다.

{% include img_assets.html id="/blog/2024/1228-playprotect/01.png" %}

> 이 앱은 Android 이전 버전에 맞게 설계되었습니다. 정상 동작하지 않을 수 있으며 최신 보안 및 개인 정보 보호 기능을 포함하지 않습니다. 업데이트를 확인하거나 앱 개발자에게 문의하세요.
>
> This app was built for an older version of Android. It might not work properly and doesn't include the latest security and privacy protections. Check for an update, or contact the app's developer.

아래처럼 Library 모듈의 설정은 기본 설정 상태입니다. 특별한 설정은 없으며, 기본 라이브러리 모듈 생성 시에 정의된 설정 그대로입니다. 그리고 UI 테스트에 사용했던 단말은 `Android Emulator`, `Pixel 8 API 35`입니다.

```kotlin
android {
  namespace = "com.pluu.sample.mylibrary"
  compileSdk = 35

  defaultConfig {
    minSdk = 24
  }
}
```

## 문제 파악

먼저 구글에서 노출된 팝업의 문구를 찾아보면, Google Play protect 사이트에서 [Android App Compatibility Too Low Warning](https://developers.google.com/android/play-protect/warning-dev-guidance#android_app_compatibility_too_low_warning) 섹션에서 관련된 내용을 찾아볼 수 있습니다. 

> 앱의 [targetSdkVersion](https://developer.android.com/guide/topics/manifest/uses-sdk-element.html?hl=ko#target)이 현재 Android API 수준보다 2개 이상 낮은 경우에만 표시

targetSdk 선언과 어떤 관련이 있다고 보이므로, Library 모듈에서 targetSdk에 설명을 찾아보면 아래와 같이 기술되어 있습니다. 명시적으로 기입은 안 했지만, 어떤(?)것과 관련 있어 보입니다.

> 테스트 APK를 빌드하는 데 사용된 대상 SDK 버전입니다. 이는 라이브러리 매니페스트에 전파되지만, 이 라이브러리에 의존하는 라이브러리에 대한 권고 사항일 뿐입니다.

이어서 App 모듈과 동일하게 [targetSdk](https://developer.android.com/reference/tools/gradle-api/8.9/com/android/build/api/dsl/LibraryBaseFlavor?hl=en#targetSdk())를 선언하면 Deprecated 되었다고 나옵니다. 대신 [testOptions.targetSdk](https://developer.android.com/reference/tools/gradle-api/8.3/null/com/android/build/api/dsl/TestOptions#setTargetSdk(kotlin.Int)) 혹은 또는/및 [lint.targetSdk](https://developer.android.com/reference/tools/gradle-api/8.9/com/android/build/api/dsl/Lint?hl=en#targetSdk())를 사용을 요구하고 있습니다.

```
android {
  defaultConfig {
    targetSdk = 35 // Deprecated API
  }
}
```

Lint는 이번 내용과 무관하니 [testOptions.targetSdk](https://developer.android.com/reference/tools/gradle-api/8.3/null/com/android/build/api/dsl/TestOptions#setTargetSdk(kotlin.Int))의 주석을 찾아보면 아래와 같습니다

> 라이브러리의 테스트에 대한 target SDK 버전 번호를 재정의하는 값을 지정합니다. 기본값은 minSdk로 설정됩니다. 
>
> 중요: 이 값을 설정하면 애플리케이션 및 기타 모듈 유형에 오류가 발생합니다.

테스트 프로젝트의 minSdk는 `24`로 지정했으므로, 이 설명대로라면 targetSdk는 `24`일 것입니다.

### 빌드된 결과물 체크

Library 모듈의 빌드 결과물을 보면 [testOptions.targetSdk](https://developer.android.com/reference/tools/gradle-api/8.3/null/com/android/build/api/dsl/TestOptions#setTargetSdk(kotlin.Int))에서 언급한 정보와 동일하게 targetSdk가 `24`로 지정되어 있습니다. 그럼, 이제 제대로 수정해 봅니다.

|         packaged_manifests 내의 AndroidManifest.xml          |       apk내의 apk 파일에서 살펴본 AndroidManifest.xml        |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2024/1228-playprotect/02.png" %} | {% include img_assets.html id="/blog/2024/1228-playprotect/03.png" %} |

## 해결

여러 가지 테스트해 본 결과로는 아래의 2가지 방법이 통과했습니다. 특이했던 건 API Level 28로 지정했을 때는 둘 다 문제없이 통과했다는 점입니다.

### (추천) 방법 1. targetSdk를 명시적으로 지정

```kotlin
android {
  defaultConfig {
    testOptions.targetSdk = 35 // 28 이상의로 정의
  }
}
```

### 방법 2. minSdk 상향

```kotlin
android {
  defaultConfig {
    minSdk = 28 // 28 이상의로 정의
  }
}
```

테스트 단말 및 Target Level 등이 변경됨에 따라서 지정해야 하는 버전은 달라질 수 있습니다.

## (2025.01.03 추가) 체크

> ganachoco(Young-Ho Cha)님이 제공해 주신 정보도 기록으로 남깁니다.

기기마다 앱 설치 시 확인하는 targetSdk의 최소 버전 체크

```shell
$ adb shell getprop ro.build.version.min_supported_target_sdk
28
```

경고 팝업 막기

```shell
$ adb shell setprop debug.wm.disable_deprecated_target_sdk_dialog 1
```

> 참고 자료 : [AppWarnings.java](https://cs.android.com/android/platform/superproject/main/+/main:frameworks/base/services/core/java/com/android/server/wm/AppWarnings.java;l=212?q=disable_deprecated_target_sdk_dialog&ss=android&start=11&fbclid=IwY2xjawHkz_pleHRuA2FlbQIxMAABHZI9Z-Kur6f7P9ssZuFxhNBpMNVP-dcosktZzk95BxY_ftKxbTaIlKpVmg_aem_cvAiV5VkMpBA7zjxc59vpQ)
