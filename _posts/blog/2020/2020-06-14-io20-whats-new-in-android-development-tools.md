---
layout: post
title: "[요약] What's New in Android Development Tools (Android 11 Beta Launch)"
date: 2020-06-14 10:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io20
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/NMFGuy6TRqk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/001.png" }}" /> 

Google I/O '19에서 소개한 Project Marble의 일관으로 메모리와 Freeze 관련 이슈를 추적하고 개선하는데 힘을 싣고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/roadmap.png" }}" /> 

Android Dev Summit 2019에서 Android Studio 3.6발표 했습니다. View Binding, 에뮬레이터에 Google Maps UI도 추가되었으며 메모리 추적과 디자인 도구를 새롭게 출시했습니다.

최근 Android Studio 4.0 Stable 버전을 출시했습니다. MotionLayout을 이용한 애니메이션 제작을 위한 Motion Editor, 앱 UI 디버깅을 위한 Live Layout Inspector, 빌드 속도를 분석하는 Build Analyzer, CPU Profiler도 업데이트되었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/brand_icon.png" }}" /> 

최신 Android Studio의 Canary에서 브랜딩 아이콘이 업데이트되었습니다.

## Profiler

### Systrace

시스템 레벨로 앱을 분석해주는 프로파일러입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/systrace_01.png" }}" /> 

앱의 전반에 걸친 VSYNC 과정을 확인할 수 있습니다. 위 이미지와 같이 `Frame 영역`의 빨간색으로 표시한 부분에서 프레임이 떨어지는 현상이 발생하는 것을 확인할 수 있습니다. 각 CPU의 작업도 확인할 수 있으며 스레드 또한 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/systrace_02.png" }}" /> 

예제로는 Render 스레드와 application main 스레드에서 일어나는 원인을 파악할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/systrace_03.png" }}" /> 

확인하고 싶은 TraceEvent 이름을 선택하면 오른쪽 패널에서 해당 정보를 더 자세하게 확인할 수 있습니다. 이당 이벤트의 통계와 Top Down, Bottom Up, Flame Chart도 확인 가능합니다.

또한 시스템이 자동으로 추적하는 사항 이외에도 개발자 스스로가 확인을 원할 때 [Trace](https://developer.android.com/reference/android/os/Trace) 클래스를 사용하면, 화면 멈춤이 발생하는 추가적인 부분을 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/systrace_04.png" }}" /> 

위 이미지를 통해서 알 수 있는 것처럼 [Trace](https://developer.android.com/reference/android/os/Trace) 클래스를 사용하면 프레임을 떨어뜨리는 시점이 특정 코드 부분이라는 것을 확인할 수 있습니다.

또한, Android Stduo 4.1에서는 기본 메모리 프로파일링 기능도 추가되었습니다.

## Jetpack Compose

### Preview

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/compose_01.png" }}" /> 

Jetpack Compose에는 샘플 데이터를 기반으로 위젯을 볼 수 있는 [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview) 기능을 제공하고 있습니다. Android Studio 의 오른쪽 패널에서 확인할 수 있습니다. 실제 실행해서 확인하는 것보다 빠르며 다양한 조건으로 테스트할 수도 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/compose_02.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/compose_03.png" }}" /> 

별도 Component와 조합하여 새로운 컴포넌트를 만들 수도 있습니다. 위 예제에서는 LCD 패널과 숫자패드를 조합했습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/compose_04.png" }}" width="400" /> 

뿐만 아니라 복수 [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview) 를 지정하는 것으로 큰 화면이나 큰 글씨 등을 오른쪽 프리뷰에서 확인할 수 있습니다.

```kotlin
@Preview("Calculator")
@Preview("Calculator landscape", widthDp = 700, heightDp = 400)
@Preview("Calculator Large Fonts", fontScale = 2.0f)
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/compose_05.png" }}" width="400" /> 

Theme 변경으로 다른 스타일로 계산기를 만들 수 있습니다.

### Document

#### Sample

| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/document_01.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/document_02.png" }}" />  |

`Crtl + J`  키를 사용해서 샘플이 제공되는 Document를 확인할 수 있습니다.

```kotlin
package com.android.store

/***
 * @sample com.adnroid.store.SimplePreview
 */
@Composable
fun ShoppingCartItem(
  ...
) { ... }

@Preview
fun SimplePreview() { ... }
```

Kotlin의 KDoc 태그를 `@sample`로 사용하고 Preview 컴포넌트 연결합니다. 예제에서는 `com.adnroid.store` 패키지에 있는 `SimplePreview` Preview Class를 지정했습니다. 해당 컴포넌트는 또 다른 Preview이며 코드와 Preview 결과를 문서 생성 시 자동으로 결합됩니다.

#### Quick Definition

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/quick_definition_01.png" }}" /> 

Preview에서 특정 컴포넌트에 해당하는 코드를 찾고 싶으면, Preview에서 원하는 뷰를 더블 클릭하면 됩니다. 그러면 Android Studio가 일치하는 Component를 찾아줍니다.

#### Sample Data

여러개의 프리뷰를 복사해서 다양한 조건을 확인하는 방법도 있지만, 이것은 반복적인 작업입니다. Preview로 샘플 데이터를 입력할 수 있는 데이터 소스도 제공합니다.

```kotlin
class SimplePostProvider : CollectionPreviewParameterProvider<String>(
    listOf(
        "Sample1",
        "Sample2",
        "Sample3"
    )
)

@Preview
@Composable
fun PreviewPostCardTopDark(
    @PreviewParameter(SimplePostProvider::class) text: String
) {
    ThemedPreview {
        PostCardTop(title = text)
    }
}
```

샘플 데이터로 제공할 데이터를 [CollectionPreviewParameterProvider](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/datasource/CollectionPreviewParameterProvider) 클래스로 정의합니다. 이후 해당 샘플 데이터를 사용할 [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview) 에서  [PreviewParameter](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/PreviewParameter) 로 정의한 후 데이터를 제공하는 형태로 사용하면 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/sample_data_01.png" }}" /> 

샘플 데이터 소스로 정의한 post1, post2, post3이 Preview 형태로 보여집니다.

#### Interactive Preview 

상황에 따라 Preview뿐만 아니라 기능적으로 확인이 필요할 수 있습니다. 그럴 경우 Preview의 `Interactive` 아이콘을 눌러서 Live Preview Mode를 켭니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/Interactive_01.png" }}" /> 

Live Preview Mode에서는 앱의 일부를 즉시 작동시켜볼 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/Interactive_02.png" }}" width="400" /> 

## Emulator

### Embded Emulator (Android Studio 4.1 or Higher)

Emulator는 Android Studio 4.1에 기본 IDE에서 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_01.png" }}" width="400" /> 

빠르게 Emulator를 기동하기 위한 스냅샷 기능도 그대로 이용할 수 있습니다.

| Create Snapshots                                             | Boot                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_02.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_04.png" }}" />  |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_03.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_05.png" }}" />  |

추가로 Zoom 컨트롤러 표시 및 Emulator의 Device Frame 제거도 가능합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/emulator_06.png" }}" /> 

## Database Inspector

먼저 Android Studio 왼쪽 하단에 위치한 `Database Inspector`를 클릭합니다. 그러면 Android Stuio는 현재 확인 중인 앱의 데이터베이스를 발견하면 관련 데이터베이스 정보를 표시해 줍니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/database_inspector_01.png" }}" /> 

`Refresh Table` 버튼으로 값 변경을 수동으로 확인할 수도 있지만, `Live Updates` 체크를 통해서 실시간으로 데이터베이스 변경을 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/database_inspector_02.png" }}" /> 

또한 데이터베이스의 값을 직접 변경할 수도 있습니다.

### Room

앱에서 Room을 사용하고 있을 경우 SQL 쿼리를 실행할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/database_inspector_03.png" }}" /> 

Database Inspector를 통해서 Insert 쿼리를 실행 시 데이터 입력 또한 동작합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/database_inspector_04.png" }}" /> 

## TensorFlow Lite

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/tensorflow_01.png" }}" /> 

```groovy
android {
  buildFeatures {
    mlModelBinding true
  }
}
```

## Device

### Pair Devices Using Wi-Fi

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/pair_device_01.png" }}" /> 

Android 11에 추가된 `무선 디버깅` 을 위해서 Android Studio에서도 관련 기능을 지원합니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/pair_device_02.png" }}" /> 

몇 개의 무선 연결 옵션 중 QR Code와 Pin Code로 연결을 시도할 수 있습니다.

> 개발자 옵션 > 디버깅 > 무선 디버깅

| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/wireless_debugging-01.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/wireless_debugging-02.png" }}" />  |

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/pair_device_03.png" }}" /> 

USB C 케이블 사용하면 더 빠르게 사용할 수 있지만, 선으로부터 편리함을 경험할 수 있습니다.

### Parallel Test

일반적인 Device 관련 테스트는 단일 단말로 테스트를 하지만 복수개의 단말을 연결해서 테스트가 가능합니다. 먼저 메뉴에서 `Modify Device Set` 에 을 선택합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/multiple_devices_01.png" }}" /> 

Android Studio에서 인식하는 디바이스가 노출됩니다. 실제 단말과 에뮬레이터 모두 노출됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/multiple_devices_02.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/multiple_devices_03.png" }}" /> 

그 후 `Multiple Device`로 선택된 상태에서 테스트가 실행되면, 이전 단계에서 선택된 디바이스에 테스트가 실행됩니다. 복수 단말에서 진행되는 테스트 결과를 쉽게 확인할 수 있습니다. 또한 기존 단일 단말로 진행했을 때와 같은 수준의 결과를 볼 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/multiple_devices_04.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/multiple_devices_05.png" }}" /> 

## Design Tools

### Layout Inspector

#### 3D View

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_inspector_01.png" }}" /> 

Layout Inspector를 이용하면 레이아웃 계층을 3D 방식으로 노출해줌으로써 Overdraw 디버깅에 도움이 됩니다.

#### Attributes

다른 사례로 `Lean more` 버튼의 색상이 왜 파란색인지 확인하는 방법은 해당 속성을 찾는 방법도 있지만, Layout Inspector를 통해서 더 쉽게 찾을 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_inspector_02.png" }}" /> 

색상을 변경하고 싶을 때 스타일 우선순위에 따라서 적용되는 컬러가 다르다는 것을 확인할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_inspector_03.png" }}" /> 

### Layout Editor

DrawerLayout 을 사용한 레이아웃의 경우 XML에서 다른 레이아웃보다 `DrawerLayout` 의 우선 순위가 높았습니다. 다른 레이아웃을 보기엔 별도 작업이 필요했습니다.

DrawerLayout를 활성화하는 속성을 임시로 Off 하도록 변경할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_02.png" }}" /> 

이 기능으로 DrawerLayout 아래의 콘텐츠를 확인할 수 있습니다.

| Visibility On                                                | Visibility Off                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_01.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_03.png" }}" />   |


### Visibility

기존 XML 코드에서 작업했던 android/tools visibility 변경을 `Design Mode`에서도 가능합니다. 

| None                                                         | ActionBar Gone 적용                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_04.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_05.png" }}" />  |

### 접근성 확인 (개발중)

Android Accessibiliity Scanner를 통해서 확인 가능했던 사항을 Android Studio에서 알려주도록 변경될 예정입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_06.png" }}" /> 

### Transforms

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/layout_editor_07.png" }}" /> 

View의 Transform 속성을 쉽게 변경하면서 가상의 View를 회전하는 형태로 보여줍니다.

### MotionLayout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/motionlayout_01.png" }}" /> 

기존에는 이미지 전환에 정확한 모션이 이루어지도록 조정했습니다. 그러나 MotionLayout을 사용할 경우에는 Touch Trigger를 작성할 필요 없으며 모션의 디테일을 맞추기 위한 복잡한 코드도 필요 없습니다. Motion Editor를 이용해서 시각적으로 수정할 수도 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/motionlayout_02.gif" }}" /> 

## 기타

### Build Analyzer

기존 빌드가 느린 이유는 아래와 같습니다.

- 매번 동작하는 Task
- Third Party Plugin
- Gradle Task 설정 이슈 (ex, Gradle out 폴더를 잘못 설정)
- 증분 빌드를 지원하지 않는 Annotation Processor

### 기타

#### [Dagger navigation support](https://developer.android.com/studio/preview/features#dagger-navigation)

기본 Dagger와 AndroidX Hilt 라이브러리 모두 지원합니다. 의존성 주입의 제공자와 소비자를 쉽게 이동할 수 있습니다.

<img src="https://developer.android.com/studio/preview/features/images/dagger-navigation-support.gif" width="400" />

> 이미지 출처 : https://developer.android.com/studio/preview/features#dagger-navigation

#### [Proguard](https://developer.android.com/studio/releases#4-0-0-smart-code-shrinker-rules)

Proguard에서 오래된 규칙을 업데이트하는 것을 잊는 경우가 많은데, 이것을 명시적으로 알려주도록 개선되었습니다.

#### [Java 8 library desugaring in D8 and R8](https://developer.android.com/studio/releases#4-0-0-desugar)

Min API Level에 영향받지 않으며 Java 8 API 사용을 지원합니다. D8은 누락된 API의 구현을 포함하고 이를 앱에 포함하는 별도의 라이브러리 DEX 파일을 컴파일합니다. Desugaring 프로세스는 런타임에 라이브러리를 대신 사용하도록 앱의 코드를 다시 작성합니다. 

#### [Support for Kotlin DSL script files](https://developer.android.com/studio/releases#4-0-0-kts)

Kotlin DSL 빌드 스크립트 파일 (* .kts)을 지원합니다.  

#### IntelliJ IDEA 2020.1 

## Developers tools

Android studio 4.1의 빌드 관련 설정 개선으로 빌드 속도를 개선할 수 있습니다.

- Gradle Config Caching
- VFS (Virtual File System for Gradle)

Goolge Santa Tracker에서는 빌드 시간이 60% 감소했습니다.

| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/build_tools_01.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/build_tools_02.png" }}" />  |

## Summary

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io20/whats_new_in_android_development_tools/summary.png" }}" /> 
