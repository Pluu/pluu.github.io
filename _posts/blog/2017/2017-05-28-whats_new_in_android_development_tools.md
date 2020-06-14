---
layout: post
title: "[요약] Google I/O 2017 ~ What's New in Android Development Tools"
date: 2017-05-28 21:25:00 +09:00
tag: [Android, Google I/O]
categories:
- blog
- Android
- Google
- io17
---

# What's New in Android Development Tools (Google I/O '17)

<!--more-->

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/Hx_rwS1NTiI" frameborder="0" allowfullscreen></iframe>
</div>

## Android Studio

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-02.png" }}" />

### '16 I/O '16 2.2 Preview 공개

- 새로운 Layout Editor
- Espresso Test Recorder 추가
- C++ 프로젝트를 위한 CMake 지원

### '16 11월 2.3 Preview 공개

- Instant Run
- Lint Baseline 지원
- ConstraintLayout 안정화 

### '17 3월 2.4 Preview 공개

어제부터 더이상 Android Studio 2.4는 릴리즈하지 않는다. 대신 `Android Studio 3.0`을 출시할 예정이다.

## Android Studio 3.0

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-03.png" }}" />

2가지 이유

- 기능 개발시 모든 작업이 점진적인 변화를 나타내는 것이 아니라는 사실을 깨달음
- Gradle API가 혁신적으로 바뀌기는 어렵다는 결정을 함

이러한 변화로 규모를 확장하며 보다 빠른 Gradle 빌드 속도를 얻을 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-04.png" }}" />

## Demo

- 최신 IntelliJ 2017.1의 Lasted Stable Version 기반
- Parameter Hint
- 주석에 이모티콘 노출

## Demo ~ Kotlin

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-05.png" }}" />

- Create Android Project에서 Kotlin 사용 여부 체크 가능
- 기존 프로젝트에서 직접 파일 생성 가능
  - Kotlin 설정이 없는 경우 프로젝트 종속성 업그레이드 안내한다

### Converter

- `[Code]` - `[Convert Java File to Kotlin File]` 를 사용해 기존 Java 클래스를 Kotlin 코드로 변환

> 데모 : 문자열 보간(string interpolation), 구조화되지 않은 선언(de-structuring declarations)

- 변환이 완벽하지 않아 때때로 경고를 노출

> 데모 : qauls, hashCode, toString 함수 처리

### Language Features

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-06.png" }}" />

Show Kotlin Bytecode : 시작시 성능에 대한 우려가 있으면 현재 문장의 바이트 코드를 보여준다

- 디컴파일 기능을 통해 현재 바이트 코드에 상응하는 Java 코드가 생긴다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-07.png" }}" />

- 조기에 최적하는 권장하지 않는다, 가장 아름다운 Kotlin 코드를 작성하라

### Etc

Java 파일에서 실행되는 Android 링크 검사 (약 80개)는 모두 Kotlin 에서도 동일하게 적용된다.

## Demo ~ Layout Editor

### Constraintlayout

- chains 추가
  - chain : 축을 따라 위젯을 배치하는 방법
- chain cycle button
    
<video poster="/training/constraint-layout/images/thumbnail-constraint-chains.png" width="460" data-vivaldi-spatnav-clickable="1" controls="">
    <source src="https://storage.googleapis.com/androiddevelopers/videos/studio/constraint-chains.mp4" type="video/mp4">
</video>

### Sample Resource Type

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-08.png" }}" />

`tools:listitem="@layout_activity_item1"`과 디자인 관련 `tools attributes`을 추가했지만 리스트뷰의 Preview는 끔찍했다. 디자인 관련 샘플 데이터 표시를 위해서 새롭게 `Sample Resource Type`이 추가되었다.

```
tools:text="@tools:sample/lorem"  
tools:text="@tools:sample/date_day_of_week" 
```

문자열, icon 정의 등의 모델링을 가질 수 있다.

> 데모 영상 기준으로 샘플 데이터 위치는 `app` 폴더 하단에 `sampledata` 폴더 하단에 샘플 리소스용 icon, json 파일이 위치

```
// activity.json
{
    "activities": [
        {
            "icon": "@sample/activity_icons[ic_biking.png]",
            "description": "Biking",
            "location": "Pleasant Hill, CA",
            "distance": "48 miles",
            "date": "Yesterday"
        },
        ...
    ]
}
```

샘플 리소스를 상용해 ItemLayout에 바인딩을 할 수 있다.

```
tools:src="@sample/activity.json/activities/icon"  
tools:text="@sample/activity.json/activities/description" 
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-09.png" }}" />

코드 샘플의 완성은 앱 샘플 태그로 작동한다. JSON 파일과 다른 속성들을 연결할 수 있다. 결국 `tools:listitem`를 사용한 곳에서는 실제 앱과 비슷한 모습을 확인할 수 있다.

### Downloadable Font

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-10.png" }}" />

작동방식은 텍스트 뷰 선택 → Layout Editor에서 `fontFamily` 선택 > 하단에 `more fonts...` 선택 > 사용 가능한 온라인 폰트를 고를 수 있다. Layout Preview에 선택한 폰트가 기대한대로 나타난다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-11.png" }}" />

## Demo ~ Adaptive Icons (O)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-12.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-13.png" }}" />

`[New]` - `[Image Asset]`을 통해서 foreground / background 레이어를 정의할 수 있다. 추가적으로 `Show Safe Zones`, `Show Grid` 옵션도 있다. 

## Demo ~ Device File Explorer

파일 시스템의 파일을 실제로 탐색할 수 있다

## Instant Apps

feature modules 만들기 위한 새로운 도구가 있다. 그러나 인스턴트 앱을 만드는 가장 어려운 부분은 단일 앱(monolithic app)을 해체하는 것이다. 

리팩터링을 위한 도구도 지원 예정이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-14.png" }}" />

- 해당 Activity 에서 `[Modularize]` 를 실행
- module로 이동할 파일 선택
- 현재 개선중

## APK Analyzer

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-15.png" }}" />

- Class 선택 > Show Bytecode 로 바이트 코드를 분해 가능
- `Load Proguard mappings...` 로 매핑파일 연결하면 기존 심볼의 이름이 표시
- `Find Usages`로 Proguard Code에서 사용법을 보여주어 보호/제거해야 할 대상을 식별할 수 있도록 돕는다

## APK Debugging

`[File]` - `[Profile or Debug APK]`

## Profiler

[Android Profiler] 탭으로 이용할 수 있다. CPU, 메모리, 네트워크에서 일어나는 일을 보여준다. 보라색 점들은 터치 이벤트이다. 그리고 하단 청녹색으로 Activity들의 활동을 볼 수 있다. 

활성화 방법 : `[Edit configuration settings]` - `[Profiling]` - `Enable advanced profiling` 체크

### Network Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-16.png" }}" />

- Netowork 영역을 클릭 > 원하는 시간대 영역 선택으로 줌인 > 해당 시간대에 발생한 네트워크/라디오 트래픽을 볼 수 있다. 
- 특정 네트워크 요청을 클릭하고 관련된 call stack을 볼 수 있다
- Http Url Connection 기반의 Volley/OkHttp 지원

### CPU Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-17.png" }}" />

- CPU 영역 선택
- [Record] ~ [Stop Record]
- 관심 있는 특정 스레드 클릭 > 하단 `프레임 차트`가 노출
- Frame의 top-down, bottom-up 표시 가능
- 메소드 호출을 내림차순으로 정렬 가능

### Memory Profiler

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-18.png" }}" />

- 백그라운드에서 힙이 더 크다는 것을 알게 되면 매트릭이 스크롤
- Heap Dump로 힙에 있는 객체의 요약을 확인 가능
- 참조를 추적 가능
- Bitmap Preview 가능

## Build

### Google's maven Repo

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-19.png" }}" />

- Gradle plugin
- Support Libraries
- Data-Binding Library
- Constraint Layout
- Instant App Library
- Architecture Components
- Android Testing Libraries
- Espresso

```
repositories{  
    maven {url 'https://maven.google.com' }  
or  
    google() // 4.0-milestone-2 or later  
}  
```

- URL은 `maven.google.com` 이고 `Gradle 4.0 mileestone 2`로 시작하여 GOogle 바로 가기를 사용할 수 있다. URL을 기억할 필요가 없다
- Support Library의 모든 이전 버전이 올려져 있다.
- 아직 Gradle Plugin이 아니다

## Build Preformance

### Incremental Tasks

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-20.png" }}" />

- Resource Processing (planned for 3.0)
  - APD 2를 사용하여 작업 진행 중
- Java Compilation (Gradle 3.5)
  - Incremental 작업 가능
- Annotation Processor
  - 미지원인 상태. Gradle 팀과 협력 중
- Shrinking (experimental, 2.3)
- Dexing (3.0)
  - Class 단위로 증분되어 큰 차이를 만들 예정
- APK Packaging (2.2)
  - 2.2에서 Incremental 패키지로 릴리즈하여 이전 빌드에서 변경되지 않은 항목을 다시 압축하지 않아도 된다.

### Build Cache

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-21.png" }}" />

- Gradle 3.5에서 빌드 캐시 발표
  - Gradle 4.2에서 안정화, 그 시점에 기본적으로 활성화 적용

Local

- Switch between branches without recompiling

```
// 활성화 방법
--build-cache
org.gradle.caching=true
```

Distributed

- 팀원과 빌드 서버와 빌드 캐시를 공유
  - storage backend 가 필요
- Hazelcast implementation Gradle Enterprise API for custom backend 

Gradle Plugin 3.0 alpha1에는 많은 양의 캐시가 캐시되지 않는다.

## Single Module vs Many Modules?

### Multi-modules Advantages

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-22.png" }}" />

| :-- | :-- |
| Coe Reuse | Improved Caching |
| API / Dependency Control | Compilation Avoidance |

> 더 자세한 내용은 `Speeding Up Your Android Gradle Builds` 세션에서 다룹니다.

> Youtube Link : [Speeding Up Your Android Gradle Builds](https://www.youtube.com/watch?v=7ll-rkLCtyk)

### Build Startup Time

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-23.png" }}" />

약 135 모듈, 220 종속성

- 2.2 / 2.14 : 177s
- 2.3 / 3.3 : 10s
- 3.0 / 4.0 : 2s

### Parallel Build Bottlenecks

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-24.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-25.png" }}" />

- AAR 파일을 압축을 풀지 않도록 하여 효율적인 빌드 처리

## New Build Features ~ Java 8 language features

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-26.png" }}" />

```
android {
  compileOptions {
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }

  defaultConfig.jackOptions.enabled true <-- deperecate
}
```

3.0 에서 완전히 제거되었다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-27.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-28.png" }}" />

3.1 에서는 Java 7 로 class Bytecode 변환과 Transforms 작업의 위치가 변경되어 변환을 수행할 것이다. (Coming later (3.1?))

## New Build Features ~ Dependency Management

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-29.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-30.png" }}" />

현재 앱과 라이브러리가 있는 경우 라이브러리는 항상 릴리즈 버전만 사용했다. 그래서 수동으로 설정했다 (debugCompile, releaseCompile) 하지만 flavors 를 사용하는 경우 잘 작동하지 않는다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-31.png" }}" />

3.0 에서 컴파일 회피를 위해 더 복잡해진다. 라이브러리에 있는 것들은 두 가지 구성을 개시한다. `ApiElements`, `RuntimeElements` 가 사용 되었다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-32.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-33.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-34.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-35.png" }}" />

기본적으로 Configuration 같은 buildType 이나 flavor가 있으면 Gradle이 자동으로 맞춰준다. 

```
android {
  flavorSelection 'color', 'blue'
}
```

라이브러리에 flvor가 있고 앱에 대응하는 flavor가 없는 경우를 위해 새롭게 `flavorSelection`이 추가되었다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-36.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-37.png" }}" />

```
android {
  flavorDimension 'something'
  productFlavors {
    flavor1 {}
    flavor2 {}
  }
}
```

3.0에서는 flavor 가 하나라도 `flavorDimension` 이 필수이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-38.png" }}" />

## Android Instant Apps

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-39.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-40.png" }}" />

애플리케이션 모듈과 일부 라이브러리 모듈 중 일부를 인스턴드 앱의 기능으로 만들고 싶은 경우 가장 먼저 할 일은 플러그인이 아니라 라이브러리로 변경하는 것이다.

- feature `com.android.feature` 모듈로 분리
- feature 모듈을 사용해서 Instant Apps (`com.android.instantapp`) 을 작성

## Test ~ Android Emulator

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-41.png" }}" />

- Google Play Store
  - 기존 Android Emulator 가 가진 문제점
    - end-to-end 흐름을 테스트할 수 없다 (실제로 다운로드할 때의 경험, 인앱 구매)
  - 출시마다 Google Play Service와 Android Emulator 간의 시간차가 존재
  - => Emulator 에 `Google Play Store`를 추가
- OpenGL ES 3.0
- Proxy Support

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-42.png" }}" />

Android Emulator System Images

|  | Google APIs | Google Play | Elevated Privileges |
| Android Open Source Project | X | X | O |
| Google Play Edition | O | O | X |

Android Open Source Project 에서는 루트 접근 권한을 높여 운영 체제와 앱 모두 자유롭게 접근할 수 있다. Google Play Edition 가 의미하는 바는 시스템 이미지에 디지털 서명을 한다는 것이다. 그러면 루트 접근이 불가능해진다.

> Elevated Privileges : 시스템 이미지 프로젝트 버전

## Test ~ App Bug Reporting

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-43.png" }}" />

에뮬레이터에서 버그 보고서와 스크린숏 등을 포함한 버그 레포트를 QA 팀 등에 전달할 수 있다

## Test ~ Android Wear Emulator

### Emulator Rotary Input

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-44.png" }}" />

- 회전을 지원 디바이스를 지원

## Test ~ Layout Inspector

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-45.png" }}" />

## Optimize

### Android Vitals

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-46.png" }}" />

Google Play Console 또는 Firebase를 통해 앱에서 발생할 수 있는 증상 목록을 확인할 수 잇다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-47.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-48.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-49.png" }}" />

- Android Profiler (CPU, Memory, Network)
- APK Analyzer
- WebP support
  - 기존 JPEG/PNG를 자동으로 WebP로 변환/복원 지원

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android-development-tools/io17-tools-50.png" }}" />