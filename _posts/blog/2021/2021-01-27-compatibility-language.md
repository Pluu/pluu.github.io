---
layout: post
title: "Android 호환성 유지에 대한 고찰 ~ 언어편"
date: 2021-01-27 23:00:00 +09:00
tag: [Android, Java, Kotlin]
categories:
- blog
- Android
---

안드로이드 개발자가 작성한 코드의 결과물은 다양한 디바이스에서 설치됩니다. 현재 약 25억 개의 활성화된 디바이스를 비롯하여 스마트폰/태블릿/Wear/Auto/TV 등 다양한 디바이스에서 실행되는 OS입니다. 다양하게 쓰일 수 있다는 점이야말로 안드로이드의 장점 중 하나입니다.

다만 다른 시각으로 봤을 때는 우리 손을 떠나면 어떤 디바이스에 설치될지 모른다는 점입니다. 실제로 한국만 벗어나더라도 처음 들어보는 제조사나 디바이스 등으로 확인하기 어려운 점도 있습니다.

이번 글에서는 다양한 하드웨어와 소프트웨어 특성을 가지는 안드로이드 생태계에서 의도대로 실행되는데 중요한 `호환성 유지`에 대해서 다룹니다.

<!--more-->

------

**Java 호환성**

먼저 살펴볼 내용은 현재는 중요도가 다소 낮지만, 영향력이 큰 Java 버전에 대한 호환성입니다. 이어서 몇 가지의 내용을 다뤄보겠습니다.

현재 여러분이 작업하는 프로젝트에서 사용하는 Java 버전은 대부분 Java 8 버전일 것입니다. 몇 년 전만 하더라도 안드로이드 개발은 Java 7 사용이 대부분이었습니다. 그리고, Github에서 아래와 같이 compileOptions이 Java 7로 지정하는 케이스를 만날 수 있습니다.

> 몇몇분들은 머릿속으로 직접 경험한 시간들이 스쳐 지나가겠죠

```groovy
// app:build.gradle
android {
   compileOptions {
      sourceCompatibility JavaVersion.VERSION_1_7
      targetCompatibility JavaVersion.VERSION_1_7
   }
}
```

## Java 7 시절

Java 7로 안드로이드 개발을 하던 시절로 가보겠습니다. 불과 3~4년 전의 개발 환경이었습니다. 이 시절의 안드로이드 개발 환경은 아래와 같았습니다.

- Android Studio 2.4 이전 버전 사용
- Java 8은 출시되었지만, 안드로이드에서는 사용 불가능
- minSdkVersion 16 이상 (Ice Cream Sandwich - 4.0)
- targetSdkVersion 23 (Marshmallow) 혹은 24 (Nougat)

이 시절의 안드로이드 개발은 지금보다 더 많은 코드가 필요했습니다. 그렇지만 우리들은 개발자이니 더 적은 코드와 최신 언어 사용을 원했고 다양한 라이브러리의 도움으로 이겨냈습니다. 간단하게는 다음과 같은 2가지 패턴이 있습니다.

첫 번째로는 [Retrolambda](https://github.com/evant/gradle-retrolambda)를 이용하여 Java 8코드를 직접 작성하는 패턴으로 코드는 Java 8로 하지만, Java6 혹은 7에서 동작하도록 backport 처리를 해주는 방법입니다.

```java
// Java 7
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        log("Clicked");
    }
});
// Retrolambda
button.setOnClickListener(v -> log("Clicked"));
```

> 출처 : https://android.jlelse.eu/retrolambda-on-android-191cc8151f85

두 번째는 [aNNiMON/Lightweight-Stream-API](https://github.com/aNNiMON/Lightweight-Stream-API) 등과 같은 Wrapper 클래스를 사용하여 Java 8과 유사한 API 형태로 이용하는 패턴입니다. 첫 번째와는 다른 대응이지만 더 많은 라이브러리가 존재했습니다.

```java
// Java 8
stream.filter(((Predicate<String>) String::isEmpty).negate())
// LSA
stream.filterNot(String::isEmpty)
```

> 출처 : https://github.com/aNNiMON/Lightweight-Stream-API#additional-operators

어떤 분에게는 다소 생소할 수 있지만 backport와 wrapper 등 모두 최신 Java 언어 API 작성법에 다가가고자 하는 도와주는 라이브러리였습니다. 실제로 저뿐만 아니라 많은 개발자들이 위 라이브러리의 도움을 많이 받았습니다.

## Java 8

서두에 최근 안드로이드 개발은 Java 8로 주로 개발된다고 언급했습니다. app 모듈의 build.gradle에서 compileOptions 옵션으로도 알 수 있습니다. 

```groovy
// app:build.gradle
android {
   compileOptions {
      sourceCompatibility JavaVersion.VERSION_1_8
      targetCompatibility JavaVersion.VERSION_1_8
   }
}
```

진행하기 전에 여러분에게 Java 8 관련 몇 가지 질문을 해보겠습니다. 안드로이드 개발이란 점을 염두에 두고 체크해보세요. 

1. Lambda와 Method Reference는 사용하시나요? 
2. java.time이 안드로이드 몇 버전에서 동작하는지 아시나요?
3. 혹시 Java 8 API가 필요해서 다른 라이브러리를 사용하시나요?
4. ~~Jack~~, Desugar, R8, D8에 대해서 들어보셨나요?

일부 개발자들은 Java 8로 컴파일할 테니 Java 8 API가 안드로이드에서 문제없이 동작한다고 생각하기도 있습니다. 이 부분은 좀 더 살펴본다면 `아니다`라는 사실을 금방 깨닫게 됩니다. (좀 더 자세한 내용은 이후에 설명합니다)

> 처음 안드로이드 개발할 때 많이 겪는 상황을 한번 이야기해보겠습니다.
>
> 여러분은 Android Studio에서 컴파일이 성공했고 에뮬레이터 혹은 테스트폰에서 모든 기능이 통과해서 앱 출시까지 했습니다. 그런데 앱이 종료된다는 리포트가 Play Store나 Crash Report를 통해서 들어옵니다. `NoSuch~~~`라는 에러로 해당 API를 찾을 수 없다는 이유의 리포트입니다.

위와 같은 일을 한 번쯤 경험하거나 들어봤을 겁니다. 그런데 `NoSuch~~~` 에러 메시지인데 그 내용이 Java API라면 더 혼란스럽습니다.

### 왜 Java API를 찾을 수 없을까요?

이것을 이해하기 위해서는 안드로이드의 개발과 실행의 상관관계를 간단하게 짚어보겠습니다.

1. 사용한 Java API는 컴파일 버전에 따라서 안드로이드에서 실행할 DEX 파일로 만들어집니다.
2. 디바이스에서는 DEX 파일에 정의된 API를 실행합니다.
3. 해당 API는 안드로이드 플랫폼과의 통신을 통해서 동작합니다.

Java 8로 컴파일된 기능은 Java 8 API가 실행 가능한 곳에서 가장 안전합니다. 기본적으로 모든 프로그래밍 언어는 각 API마다 필요로 하는 최소 버전이 존재합니다. 예시와 같이 API가 실패한다면 결국 `해당 디바이스에는 특정 API가 없다는 내용입니다.`

<img src="https://developer.android.com/guide/platform/images/android-stack_2x.png" width="400" />

> 출처 : https://developer.android.com/guide/platform

위 그림을 보면 알 수 있듯이 안드로이드 플랫폼은 각 컴포넌트마다 개별 역할을 담당하고 있으며, 각 컴포넌트의 기능은 안드로이드 버전 업데이트에 맞춰 갱신됩니다. 

Java의 경우에는 Android 7.0 (API Level 24)부터 Java 8 API 기능 중 일부가 추가되었습니다.

- java.util.function
- java.util.stream
- etc

또한 Android 8.0 (API Level 26)에서는 java.time API가 추가되었습니다.

> 업데이트된 Java 지원 : https://developer.android.com/about/versions/oreo/android-8.0#java

이와 같은 이유로 Android 7.0 이전 버전에서는 Java 8 API를 사용할 수 없었습니다. 몇 년 전만 하더라도 minSdkVersion은 Android 4.0에 가까운 버전까지 지원했기 때문에 현실이란 벽에 부딪혔습니다.

### Desugar (deprecated ~~Jack~~)

이후 Android Gradle Plugin 3.0.0을 사용 시 Java 7뿐만 아니라 Java 8의 일부 API를 지원하게 되었습니다. 좀 더 자세하게는 아래 그림과 같이 `.class` 파일을 Dex 코드로 변환하는 D8/R8 컴파일의 일환으로 `desugar`라고 부르는 바이트 코드 변환을 통하여 Java 8 API를 지원하게 되었습니다.

> 초기에는 Jack Compiler를 통해 Java 8 API를 사용할 수 있었지만, 결국 deprecated 되었습니다.
>
> Deperecated the Jack toolchain : https://android-developers.googleblog.com/2017/03/future-of-java-8-language-feature.html

<img src="https://developer.android.com/studio/images/write/desugar_diagram.png" />

> 출처 : https://developer.android.com/studio/write/java8-support

앞서 언급한 것과 같이 desugar 기능을 사용하더라도 다양한 안드로이드 버전에서 Java 8 기능을 사용할 수 있는 것은 일부분입니다. java.util.stream과 java.time이 특정 안드로이드 버전부터 가능하다는 사실은 변하지 않습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0127-compatibility/Java_8_language_feature.png" }}" />

> Android Gradle Plugin 3.0.0+ 에서 대응 가능한 Java 8 API에 대해서는 아래 사이트에서 추가 내용을 확인 할 수 있습니다.
>
> https://developer.android.com/studio/write/java8-support#supported_features

지금까지 Java 7에서의 Java 8의 호환성과 Desugar를 통한 대응을 살펴봤습니다. 많은 안드로이드 개발자가 다소 실망스러울 수 있습니다.

### coreLibraryDesugaring

Android Gradle Plugin 4.0.0부터는 보다 높은 호환성을 제공합니다. 이것으로 안드로이드 버전에 상관없이 Java 8 API를 사용할 수 있게 됩니다. 먼저 사용하기 위해 아래와 같이 설정을 추가해야 합니다.

```groovy
android {
  defaultConfig {
    // Required when setting minSdkVersion to 20 or lower
    multiDexEnabled true
  }

  compileOptions {
    // Flag to enable support for the new language APIs
    coreLibraryDesugaringEnabled true
    // Sets Java compatibility to Java 8
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
}

dependencies {
  coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.0.9'
}
```

> 출처 : https://developer.android.com/studio/write/java8-support#library-desugaring

컴파일 옵션과 dependencies에 `coreLibraryDesugaring` 관련 정의가 추가됩니다.

그리고, Android Gradle Plugin 4.0.0+을 사용할 경우, 아래의 Java API를 지원합니다.

- Sequential streams (**java.util.stream**)
- **java.time** 의 하위 클래스
- **java.util.function**
- 최근에 추가된 **java.util.{Map,Collection,Comparator}**
- **java.util.Optional**, **java.util.OptionalInt** 및 **java.util.OptionalDouble** 과 같은 Optional 클래스
- **java.util.concurrent.atomic** 에 추가된 일부 메소드 (**AtomicInteger**, **AtomicLong**, **AtomicReference**)
- **ConcurrentHashMap** (Android 5.0 버그 수정 포함)

> 출처 : https://developer.android.com/studio/write/java8-support#library-desugaring
>
> Java 8+ APIs available through desugaring : https://developer.android.com/studio/write/java8-support-table

위에 나열한 항목을 봤을 때 `coreLibraryDesugaring`으로 Java 8 기능의 높은 호환성을 얻을 수 있다는 것을 알 수 있습니다. 실제로 coreLibraryDesugaring은 Java 8 API를 지원하기 위해 해당 API의 구현을 포함하는 별도의 라이브러리 Dex 파일을 컴파일하고 이를 앱에 포함합니다. 

결국 앱은 APK 및 AAR의 용량은 조금 증가했지만, Java 8 API의 호환성을 얻게 되었습니다. 뿐만 아니라 coreLibraryDesugaring은 Java 8 이후의 버전에 대해서도 지원한다고 말합니다. 

다양한 버전을 지원한다는 사실이 안드로이드 개발자에게 더욱 기대하는 부분일 것으로 보입니다. 현재 몇몇 회사에서 적극적으로 시도되고 있으므로 여러분도 한번 체크해보시길 바랍니다.

## Kotlin

다음으로는 많은 안드로이드 개발자들이 환호하는 `Kotlin`입니다. 

기본적으로 Kotlin은 Java와의 호환성을 염두에 두고 설계되었습니다. Java와 100% 호환되며 Java와 Kotlin 코드 간의 호출도 원활하게 할 수 있습니다. 더 적은 Kotlin 코드로 기존 코드를 대체 가능하며 Kotlin의 다양한 API 덕분에 더 간결하며 표현력이 높은 개발이 가능하게 되었습니다. 

또한, Google I/O 2019에서 `Kotlin First`의 일관으로 Kotlin을 위한 다양한 기능을 제공한다고 발표했습니다.

### Kotlin First가 의미하는 바는?

많은 분들이 오해하는 부분 중 하나가 바로 `Kotlin First`입니다. 

Kotlin First는 Google에서 제공하는 Jetpack Library, 샘플, 문서, 코드랩 등과 같은 콘텐츠를 만들 때 Kotlin 사용자를 먼저 염두에 두고 준비한다는 의미입니다. 또한 Java 언어를 위한 새로운 API 제공도 계속 지원됩니다.

Android의 Kotlin 전용 API인 KTX, coroutine 관련 기능들은 Kotlin만 위한 기능이므로 Java에서는 사용이 불가능합니다. 실제로 KTX의 내부는 Java API를 활용하여 제공되는 경우가 많습니다. KTX의 동작이 궁금하면 내부 코드를 한번 확인해보시고 적용하시면 됩니다.

아래 표는 Google에서 제공하는 항목과 Java/Kotlin 언어의 관계를 알려줍니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0127-compatibility/What_does_Kotlin_first_mean.png" }}" />

> 출처 : https://developer.android.com/kotlin/first#what

그리고, 안드로이드 개발자가 Kotlin에 대한 다양한 궁금증을 정리한 내용을 아래 링크를 통해 확인해보세요.

- https://developer.android.com/kotlin/faq

Kotlin 언어는 구글의 수십 개 앱에서 사용되고 있으며, Play Store의 인기 순위 상위 앱에서도 사용될 만큼 많은 안드로이드 개발자로부터 긍정적인 평가를 받으며 적용되고 있습니다. 이런 모습을 통해서 우리들은 Kotlin 언어의 안정성과 Java와의 높은 호환성을 기대할 수 있습니다.

------

`호환성 유지에 대한 언어편`은 여기까지입니다. 다음 글에서는 Android SDK의 측면에서 호환성을 고민한 흔적들을 살펴보겠습니다.

------

## 참고 자료

### 참고 영상

<iframe width="560" height="315" src="https://www.youtube.com/embed/zfLKMun94Yc" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 출처 : Android Developers ~ [Java 8 Language Features on Android (Android Development Patterns S3 Ep 9)](https://www.youtube.com/watch?v=zfLKMun94Yc)

<iframe width="560" height="315" src="https://www.youtube.com/embed/B08iLAtS3AQ?start=1620" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 출처 : Android Developers ~ [What's new in Android - Google I/O 2016](https://www.youtube.com/watch?v=B08iLAtS3AQ)

<iframe width="560" height="315" src="https://www.youtube.com/embed/heCvGfOGH0s" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

> 출처 : Android Developers ~ https://www.youtube.com/watch?v=heCvGfOGH0s

### 참고 사이트

- Jack
  - Jack toolchain : https://source.android.com/setup/build/jack
  - Hello World, meet our new experimental toolchain, Jack and Jill : https://android-developers.googleblog.com/2014/12/hello-world-meet-our-new-experimental.html
- Desugar
  - Use Java 8 language features and APIs : https://developer.android.com/studio/write/java8-support
- coreLibraryDesugaring
  - Java 8+ APIs available through desugaring : https://developer.android.com/studio/write/java8-support-table
  - Support for newer Java language APIs : https://medium.com/androiddevelopers/support-for-newer-java-language-apis-bca79fc8ef65
- Use Java 8 language features : https://developer.android.com/studio/write/java8-support
- Device compatibility overview : https://developer.android.com/guide/practices/compatibility
- evant/gradle-retrolambda : https://github.com/evant/gradle-retrolambda
- aNNiMON/Lightweight-Stream-API : https://github.com/aNNiMON/Lightweight-Stream-API
