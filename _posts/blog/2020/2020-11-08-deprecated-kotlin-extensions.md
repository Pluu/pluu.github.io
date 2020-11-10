---
layout: post
title: "Deprecate Kotlin Android Extensions의 준비"
date: 2020-11-08 20:40:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

오늘은 Kotlin 1.4.20에 반영된 Kotlin Android extensions의 변경점에 대한 내용입니다.

<!--more-->

------

### Update, 1.4.20-M2

약 한 달 전에 Kotlin `1.4.20-M2` 이 공개되었고, Android 개발에도 작은 변경점이 발생했습니다.

> Android
>
> - [`KT-42121`](https://youtrack.jetbrains.com/issue/KT-42121) Deprecate Kotlin Android Extensions compiler plugin
> - [`KT-42267`](https://youtrack.jetbrains.com/issue/KT-42267) `Platform declaration clash` error in IDE when using `kotlinx.android.parcel.Parcelize`
> - [`KT-42406`](https://youtrack.jetbrains.com/issue/KT-42406) Long or infinite code analysis on simple files modification
>
> Link : https://github.com/JetBrains/kotlin/releases/tag/v1.4.20-M2

바로, Kotlin Android Extensions이 `Deperecate` 되었습니다. 

이 글을 읽는 분들중 에도 Kotlin Android Extensions을 모르시는 분들도 계실 것이라고 생각되어서 간단하게 언급만 하겠습니다.

- findViewById를 사용하지 않고 View에 접근
- Android에서 사용하는 직렬화인 Parcelable을 쉽게 처리해주는 `Parcelize`

> 자세한 기능에 대한 설명은 아래 링크를 참고해주세요.
>
> - kotlin synthetic : https://github.com/Kotlin/KEEP/blob/master/proposals/android-extensions-entity-caching.md
> - android-parcelable : https://github.com/Kotlin/KEEP/blob/master/proposals/extensions/android-parcelable.md

각각의 기능들이 Android 개발시 편하게 개발하도록 도와줬다는 것을 많이 알고 계실겁니다. 

다만, View Caching 기능은 Fragment에서 뷰 갱신이 일어나지 않는 문제가 있습니다. 이 현상을 경험하지 못하셨다면, Fragment의 교체 및 추가로 Fragment의 View를 재생성하는 케이스를 사용하고 있지 않으실 겁니다.

### Check Configuation

그러므로, 현재 프로젝트에서 `Kotlin Android Extensions`을 사용하는지 체크해볼 필요가 있습니다. 그 이유는 Android Studio 4.0까지 새로운 프로젝트를 생성할 때 Kotlin Android Extensions가 항상 포함되어 있기 때문이죠.

build.gradle (~ Android Studio 4.0)

```groovy
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-android-extensions'
```

build.gradle

> Android Studio 4.1에 맞춰서 마이그레이션 대응했다면 아래와 같을 것입니다.

```groovy
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'kotlin-android-extensions'
}
```

### Kotlin 1.4.20에서 대응할 Migration

`kotlin-android-extensions`을 사용하고 계신다면 2가지만 대응하시면 됩니다.

kotlin synthetic

- Android Studio에서 제공하는 View Bindings 혹은 Data Bindings으로 Migration 해주세요
- `kotlin-android-extensions`을 제거해주세요.

Android Parcelable

- plugin `kotlin-android-extension`을 제거한 후 Parcelable만 포함된 `kotlin-parcelize` Plugin으로 변경해주세요.

### 도움되는 글

- Deprecate Kotlin Android Extensions compiler plugin : https://youtrack.jetbrains.com/issue/KT-42121
- View Binding : https://developer.android.com/topic/libraries/view-binding
- Use view binding to replace findViewById : https://medium.com/androiddevelopers/use-view-binding-to-replace-findviewbyid-c83942471fc
- Exploring View Binding on Android : https://medium.com/google-developer-experts/exploring-view-binding-on-android-44e57ba11635