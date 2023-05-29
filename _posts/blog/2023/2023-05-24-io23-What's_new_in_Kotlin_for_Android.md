---
layout: post
title: "[요약] What's new in Kotlin for Android (Google I/O '23)"
date: 2023-05-24 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io23
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/QGtB--ABiNM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

## State of Kotlin

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/001.png" %}

- Kotlin은 2017년부터 Android의 공식적으로 지원되는 언어였습니다.
- 최근 4년 동안 Android 개발에서 Kotlin이 우선시 되어 라이브러리/문서/컨텐츠 모두 Kotlin을 위해 주로 설계되었습니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/002.png" %}

- 간결성, 타입 안정성, 풍부한 언어의 기능으로 Kotlin을 좋아합니다.
- Play Store에서 상위 1,000개 앱 중 95% 이상이 Kotlin을 사용하고 있습니다.
- Kotlin을 사용하는 앱의 55%에서 Coroutine이 사용됩니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/003.png" %}

- 최신 UI Toolkit인 Jetpack Compose는 Kotlin으로 만들어졌습니다.
- Coroutine, Lambda, Extension과 같은 다양한 언어 기능을 활용하니다.

## Kotlin 2.0 compiler

새로운 Kotlin Compiler K2는 Kotlin 2.0의 기본 컴파일러가 될 것입니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/004.png" %}

- Kotlin 2.0의 컴파일 속도는 현재 Kotlin 컴파일러보다 최대 2배 빠릅니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/005.png" %}

- 새로운 컴파일러 플러그인을 사용하기 위해서는 지원을 추가해야 합니다.
- Kotlin 1.9 릴리즈 시점에 Compose 및 KSP에 새로운 컴파일러를 실험적으로 사용할 수 있도록 노력하고 있습니다.
- 내부적으로 Android Studio에서 code intelligence, refactoring 등에서 Kotlin Compiler를 사용합니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/006.png" %}

- 최신 Kotlin 버전에서 language version을 2.0으로 설정하면 새 컴파일러를 사용할 수 있습니다.

## Kotlin DSL as the default for Gradle builds

Gradle build 정의에도 Kotlin을 사용할 수 있습니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/007.png" %}

- Android Studio Giraffe부터 Kotlin DSL을 기본으로 사용하고 있습니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/008.png" %}

- New Project Wizard에서 build script도 Kotlin/Groovy 모두 사용할 수 있습니다

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/009.png" %}

- Kotlin build script에서는 Groovy보다 더 정확한 Code Hint를 사용합니다.
- Syntax 에러도 코드 수정 시에 확인할 수 있습니다.
- 프로젝트의 종속성을 Gradle version catalogs를 실험적인 옵션으로 추가했습니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/010.png" %}

## KSP

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/011.png" %}

- Kotlin 코드 생성은 Java 프로그래밍 언어용으로 작성된 Annotation Processor를 사용할 수 있도록 하는 Kotlin Annotation Processing 도구인 KAPT로 시작되었습니다.
- KAPT
  - Kotlin 파일에서 Java Stub을 생성하는 방식으로 작동합니다.
  - 이 스텁 생성은 시간이 오래 걸리는 작업이며 Annotation 처리를 사용하는 프로젝트의 빌드 속도에 영향을 미칩니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/012.png" %}

KSP

- Kotlin 코드를 직접 분석하며 Stub 생성을 하지 않으므로 Clean Build에서 최대 2배 더 빠릅니다.
- Kotlin의 언어를 더 잘 이해합니다.
- Java에 의존하지 않으므로 멀티플랫폼 프로젝트를 지원합니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/013.png" %}

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/014.png" %}

- 먼저 root의 build.gradle 파일에 KSP 플러그인을 추가합니다. 사용하는 버전이 프로젝트의 Kotlin 버전과 일치해야 합니다.
- Module에 KSP 플러그인을 적용하고 KAPT로 선언된 종속성을 KSP를 대신 사용하도록 변경합니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/015.png" %}

- KSP지원은 각 라이브러리의 몫이므로 모든 KAPT를 KSP로 마이그레이션하지 못할 수도 있습니다.
- KSP 지원 중 : Room, Glide, Moshi 등
- Dagger/Hilt의 KSP 지원은 현재 진행 중입니다.

## Kotlin Multiplatform

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/016.png" %}

- Kotlin 멀티플랫폼을 사용하면 Kotlin 코드로 Android와 iOS 플랫폼에 맞게 컴파일하여 비즈니스 로직을 공유할 수 있습니다.
- JetBrain에서 개발 중이며 현재 베타 버전입니다.
- Google Workspace에서도 이 기술을 채택하여 실험하고 있습니다.

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/017.png" %}

Jetpack 라이브러리의 일부를 멀티 플랫폼에서 사용할 수 있습니다.

- Annotations
- Collections
- DataStore

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/018.png" %}

- Multiplatform용 DataStore가 동작하는 사례는 샘플 앱에서 확인할 수 있습니다.

> Kotlin Multiplatform Samples : https://goo.gle/kmm-samples

{% include img_assets.html id="/blog/io/io23/What's_new_in_Kotlin_for_Android/019.png" %}
