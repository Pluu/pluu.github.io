---
layout: post
title: "Dagger DI Graph의 샛별, Scabbard 맛보기"
date: 2019-12-29 11:25:00 +09:00
tag: [Android, Scabbard]
categories:
- blog
- Android
---

<!--more-->

## 들어가기 전 1

- Dependency Injection 설명을 다루지 않습니다.
- Dagger, Koin, Kodein에 대한 설명을 다루지 않습니다.
- 본 글에서 언급하는 Dagger는 Google Dagger입니다.

## 들어가기 전 2

개발 시에 구조를 유연하게 만드는 방법은 다양하다. 그중 오늘 맛보기를 사용할 주제와 관련된 `Dependency Injection (이하 DI)` 또한 많이 사용하는 패턴 중 하나이다. Android 개발에서는 `DI` 를 하는 방법으로 코드를 작성하는 사람이 직접 관리와 주입을 하는 방법도 있다. ~~나의 시간은 소중하기 때문에~~ 많이 알려진 Dagger과 Koin, Kodein 등을 사용해서 DI를 이용한다.

DI의 필요성은 이미 다양한 곳에서 언급되었다. OOP에서 이야기하는 [SOLID](https://en.wikipedia.org/wiki/SOLID) 또한 어디선가 들어본 내용이다. 그리고 올해 열린 [Android Dev Summit 2019](https://developer.android.com/dev-summit)에서도 DI 관련에 세션이 있었으며, Android Developer 가이드에도 관련 문서가 추가되었다.

> ※ [An Opinionated Guide to Dependency Injection on Android (Android Dev Summit '19)](https://www.youtube.com/watch?v=o-ins1nvbDg)
> ※ [Android Developers ~ Dependency injection](https://developer.android.com/training/dependency-injection)

위에서 언급한 DI들은 모두 장단점이 존재하며 적절한 사용이 필요하다. 그렇지만 프로젝트는 점점 커지며 복잡함이 늘어나는 것이 일이라는 것이다. 현재 Google에서 Android 개발자에게 DI를 어떻게 선택할지에 대한 제안하는 방법은 아래와 같다. ~~(Dagger가 많이 보이는 것은 기분 탓일 것이다)~~

![https://developer.android.com/images/training/dependency-injection/1-di-tool.png](https://developer.android.com/images/training/dependency-injection/1-di-tool.png)

> Image Source : https://developer.android.com/training/dependency-injection#choosing-right-di-tool

## 서론

간단하게 DI에 대해 언급했지만, 왜 Scabbard와 무슨 상관이 있는가에 대한 의문이 있을 것이다. Scabbard는 위에서 보이는 Dagger 작업 시 도움이 되는 라이브러리이다.

Dagger의 장점도 다양하지만, 항상 언급되는 단점으로는 아래와 같다.

- Component, Module 간의 구조를 파악하기 어렵다
- 학습 비용이 높다

위의 단점 중 `구조 파악의 어려움`을 해결할 방법으로 며칠 전 공개된 [Scabbard](https://arunkumar9t2.github.io/scabbard/) 이다. [Scabbard](https://arunkumar9t2.github.io/scabbard/) 는 Dagger에서 DI가 어떻게 연결되었는가를 이미지 형태로 결과를 알 수 있는 라이브러리이다. 

> scabbard 공식 사이트 : https://arunkumar9t2.github.io/scabbard/configuration/

Android Dev Summit 2019 소스를 이용해서 Scabbard를 적용해봤을 때 아래의 결과를 이미지 형태로 얻을 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/ads2019_appcomponent.png" }}" />

> AppComponent Dagger Graph

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/ads2019_mainactivity_subcomponent.png" }}" />

> MainActivity Dagger Graph

## Install

### 0. 필수 환경

Scabbard는 GraphViz를 이용해서 그래프 이미지를 생성하므로, 각자의 개발환경에 맞게 설치하면 된다. 

- **Mac** :  `brew install graphviz`.
- **Linux** :  `sudo apt-get install graphviz`.
- **Windows** : [GraphViz installer](https://graphviz.gitlab.io/_pages/Download/Download_windows.html) 설치

Android Project에 Dagger 포함은 당연한 이야기이다.

### 1. IDE Plugin 설치

Android Studio의 plugin market을 이용해 Scabbard plugin을 설치한다.

> Preferences \| Plugins

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/00_plugin.png" }}" />

> Scabbard Plugin Site Link : https://plugins.jetbrains.com/plugin/13548-scabbard--dagger-2-visualizer/

### 2. Gradle Plugin (root/build.gradle)

Plugin DSL 사용 시는 아래와 같이 적용한다.

```groovy
buildscript {
  ...
  repositories {
    jcenter()
    ...
  }
}
plugins {
    id "scabbard.gradle" version "0.1.0"
}
allprojects {
  ...
}
```

Gradle plugin DSL 형태로 적용이 되지 않는 경우에는 아래의 구버전 대응용으로 사용할 수 있다.

```groovy
buildscript {
  ...
  repositories {
    maven {
      url "https://plugins.gradle.org/m2/"
    }
    ...
  }
  dependencies {
    classpath "gradle.plugin.dev.arunkumar:scabbard-gradle-plugin:0.1.0"
    ...
  }
}
```

### 3. App Gradle (app/build.gradle)

Scabbard의 기능을 활성화하는 옵션을 적용한다.

```groovy
apply plugin: "scabbard.gradle"

android {
  ...
}

scabbard {
  enabled true
  failOnError true // default false
  fullBindingGraphValidation true // default false
}
```

- failOnError : 기본적으로 Scabbard는 오류가 발생하더라도 빌드 실패가 되지 않지만, 해당 기능을 변경할 수 있다.
- fullBindingGraphValidation
  - @Component, @Subcomponent 및 @Module에 적용되는 모든 바인딩을 포함하여 전체 그래프의 유효성을 검사할 수 있다. 이걸로 누락된 바인딩을 찾는 데 사용할 수 있다.
  - Scabbard의 기본은 Component/Subcomponent에만 노출되지만, Module에 바인딩하는 그래프를 생성할 수 있다.  

> 현재 Android Dev Summit 2019에 fullBindingGraphValidation 적용시 Graph 이미지는 제대로 생성되지만, 빌드 에러가 발생한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/build_error.png" }}" />

### 4. Use Scabbard

테스트로 Dagger Sample에 있는 CoffeeMaker 소스를 Android Studio에 적용해 봤다.

> Source : https://github.com/google/dagger

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/02_coffee_scabbard.png" }}" />

모든 설정을 적용한 후 Compile Build 후 7번 라인에 보이는 아이콘이 노출된다. 아이콘을 클릭하면 현재 `Component`에서 파악할 수 있는 Module Graph를 얻을 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/01_coffee.png" }}" />

Scabbard를 통해서 생성된 이미지는 build-tmp-kapt3-classes-debug-패키지명 아래에 존재한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/03_coffee_build.png" }}" />

추가로 Android Dev Summit 2019에 적용해보면 아래와 같이 형태의 Graph를 얻을 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1229-scabbard/ads2019_build.png" }}" />

## 테스트 영상

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/s2FYzhBzeAk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## 감상

- 아직 문서가 정리되지 않은 형태로 해당 기능을 어느 파일과 어떻게 적용해야 하는지 쉽게 정리되어 있지 않다.
- 현재 공식문서의 여러 곳에서 `0.0.1` 버전으로 명시해놨지만, 현재는 `0.1.0` 버전이 최신이다.
  사실 이것 때문에 엄청 고생했다. 공식 문서대로 했지만, 빌드 실패를 경험했지만 버전만 제대로 반영하면 문제없이 동작한다.
- 빌드 시간에 어느 정도 영향을 주는지 벤치마킹이 없으며, Annotation Processor로 동작하지만 아직 Incremental Build를 지원하고 있지 않다.
- 이제 `0.1.0` 버전이니 여러모로 기대되는 라이브러리이다.