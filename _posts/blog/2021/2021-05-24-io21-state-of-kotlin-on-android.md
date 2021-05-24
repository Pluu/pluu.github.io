---
layout: post
title: "[요약] State of Kotlin on Android (Google I/O '21)"
date: 2021-05-24 23:50:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/etLUpHvhNZw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

### Kotlin Momentum

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/001.png" }}" /> 

- Google Play 설치 수 기준 상위 1,000개 앱 중에서 80%에 Kotlin이 사용되고 있다
- Android 개발자의 60%가 Kotlin을 사용 중이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/002.png" }}" /> 

- 작년 수천 명의 개발자가 Android Kotlin 교육 과정과 코드랩을 수료했다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/003.png" }}" /> 

- Google 자체 앱에도 Kotlin을 사용하기 시작했다
- 현재 공개된 앱 중 70개 이상에서 사용 중이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/004.png" }}" /> 

- 동시성을 유지하기 위해 Kotlin으로 작성된 Android 및 서버 앱에 Coroutine을 도입했다
- Google Mono Repo에서 Kotlin 코드가 급격히 늘어나고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/005.png" }}" /> 

Kotlin의 장점

- 프로퍼티,  Extension 등의 풍부한 표현력
- Null 허용 및 문자열 템플릿으로 안전성 강화
- Coroutine으로 기존 코드와의 상호운용성과 구조적 동시성을 쉽게 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/006.png" }}" /> 

- Goolge Play에서 Kotlin을 도입한 앱의 Crash를 경험한 사용자 수가 10% 감소했다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/007.png" }}" /> 

- Kotlin Google Developer Experts 프로그램을 시작했다

### Tools updates

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/008.png" }}" /> 

- Kotlin으로 Gradle Build 파일 스크립트를 작성할 수 있다
- 빌드 파일에서 Kotlin의 장점을 누릴 수 있다.
- 새로운 Android Gradle Plugin인 Kotlin DSL에서 지원한다
- 최근 새로운 DSL 관련 문서를 추가했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/009.png" }}" /> 

- Kotlin과 Gradle 상호작용이 개선되었다
- KAPT에서 증분 지원
- Gradle 구성 캐싱을 적용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/010.png" }}" /> 

- 빌드 시간 단축과 표현력을 개선하기 위한 도구로 KSP가 있다
- KSP의 목표는 기호 처리를 Kotlin 에코 시스템의 1급 기능으로 만드는 것이다
- KAPT로 Java Stub를 생성하기 위해 긴 시간을 보낼 필요가 없다
- KSP는 Kotlin Compiler와 함께 생성되고, 모든 Kotlin 기호에 액세스를 제공한다
- Jetpack Room 라이브러리에서 베타로 KSP를 지원한다
  - KAPT 대비 처리 속도가 두 배 빨라졌다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/011.png" }}" />

- Kotlin 1.5에서 대규모 프로젝트에 영향을 미치는 성능 문제를 다수 해결
- auto-import suggestion 처리 속도는 20배까지 빨라졌다
- 복잡한 종속성 그래프가 있는 프로젝트의 code completion 속도는 2배 빨라졌다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/012.png" }}" />

- 위 그림은 일반적인 Kotlin Compiler 파이프라인이다
- Compiler는 Frontend와 Backend로 나뉜다
- Frontend는 코드가 맞는지 확인, Backend는 코드 생성을 담당한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/013.png" }}" />

- Kotlin 1.5에서 출시된 새로운 JVM IR Backend Compiler로 다시 개발 중이다
- 다양한 Compiler Plugin API가 제공된다. 이 API를 이용해 Jetpack Compose Language Extension을 지원한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/014.png" }}" />

- 새로운 Backend 사용으로 JVM, JS, Native의 Compiler Frontend를 통합할 수 있다

### Libraries and APIs

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/015.png" }}" />

- 현재 KTX는 다양한 Jetpack API를 지원하는 수십 개의 Artifact로 늘어났다
- Kotlin으로 새 라이브러리도 개발함으로 Coroutine/Flow 등의 기능을 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/016.png" }}" />

- AndroidX뿐만 아니라 다양한 곳에서 SDK 용 확장 프로그램이 출시되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/017.png" }}" />

- Kotlin으로 개발한 라이브러리도 있다 (예 : Kotlin gRPC)
- Protobuf를 위한 새로운 Kotlin binding이 출시했으며 Protobuf와 호환되는 Kotlin DSL을 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/018.png" }}" />

- Kotlin Coroutine이 Android에서 Kotlin 사용 시 비동기 작업의 권장 방식으로 지정되었다
- StateFlow, SharedFlow가 Coroutine 라이브러리에 추가되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/019.png" }}" />

- LiveData는 UI에서 편리하게 상태 업데이트를 관찰하는 수단이며 Java 언어 사용자는 이 방식을 사용한다.
- Kotlin에서는 StateFlow가 같은 기능을 할 수 있다. Android Studio 최신 버전에서는 Binding에서 StateFlow의 직접 관찰을 지원한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/020.png" }}" />

- DataBinding 없이 UI Flow를 관찰하고 싶다면 AndroidX Lifecycle KTX 라이브러리를 사용하면 된다.
- launchWhenStarted 등의 함수는 다른 정지 동작 패턴이 있어서 UI가 활성 상태가 아닐 때 리소스가 낭비될 우려가 있다
- UI에서 안전하게 Flow를 관찰할 수 있는 새로운 함수를 추가하고 있다. 새로운 함수는 작업을 자동 취소 및 다시 시작할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/021.png" }}" />

- IntelliJ IDEA의 Coroutines Debugger를 Android에도 출시했다. 향후 Android Studio 버전에 지원될 예정이다
- 활성화된 Dispatch와 Coroutine의 정보를 확인할 수 있다
- UI에서의 실행, 일시정지나 파일로 Dumping과 같은 Coroutine 상태도 검사할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/022.png" }}" />

- Kotlin Android Extension 플러그인을 단계별로 지원하고 있다. 
- Android Views에서 Kotlin synthetics를 사용할 때 지원되었다. 권장하는 마이그레이션은 `Android ViewBinding`이다.
- parcelize 기능은 별도의 플러그인(kotlin-parcelize)으로 옮겨졌다

### Morden language features

모든 Android 플랫폼 API는 Java 프로그래밍 언어로 개발되고 Kotlin/Java 개발자 모두가 사용한다 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/023.png" }}" />

- Java 언어에서도 Kotlin과 비슷한 개선 사항이 적용되고 있다.
- Record는 Kotlin의 Data classes와 비슷하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/024.png" }}" />

Java 언어의 개선으로 시작한 프로젝트로는

- Android Gradle Plugin 7에 추가 언어 기능을 지원하기 시작했다
- Android 12에 새로운 Java 언어 API를 추가한다

라이브러리 desugar 기능으로 오래된 기기에도 API를 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/state-of-kotlin-on-android/025.png" }}" />

Android Runtime(ART)이 Android 12부터 업데이트 가능한 Mainline 모듈이 된다. 즉, 지원되는 언어 기능을 업데이트할 수 있으며 향후 Android 기기에 직접 새 API를 추가할 수 있다. OS 업데이트를 기다리지 않아도 된다
