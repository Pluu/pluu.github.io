---
layout: post
title: "[요약] Android Jetpack: what’s new in Android Support Library (Google I/O '18)"
date: 2018-05-15 00:50:00 +09:00
tag: [Android]
categories:
- blog
- Android
- IO18
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/jdKUm8tGogw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

<!--more-->

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/01.png" }}" /> 

Support 라이브러리가 노후화됨에 따라 Java 패키지가 혼란스러워졌으며, 많은 기술적인 빚을 쌓았습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/02.png" }}" /> 

2011년 Support v4로 첫 릴리즈를 시작으로, 시계∙자동차∙테스트를 위한 13 / 4 / 11 라이브러리를 얻었습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/03.png" }}" /> 

v4 / v13, 각 버전이 무엇을 지원하는지 불투명하며, 모든 SDK 최소 버전이 14이므로 v13의 현재 Support는 아무것도 포함되어 있지 않습니다. v13은 v4로 리다이렉트됩니다. v4는 실제로 다른 컴포넌트로 리다이렉트됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/04.png" }}" /> 

Recommendation은 2003년에 추가된 것이고, 그 이후로 많이 바뀌지 않았습니다. 그래서 30개의 버전이 기본적으로 동일한 라이브러리를 가지고 있습니다. 

그리고 Support Library에 Alpha/Beta 릴리즈가 있다면 좋지 않을까요? 24.0, 25.4에서 실제로 Stable 버전 출시 후 알파/베타에 있어야 하는 버그가 발견되기도 했습니다.

## Packaging

라이브러리를 어떻게 구성하고, 어떻게 변화를 처리하고, 어떻게 개발자들에게 전달할 것인가에 초점을 맞출 것입니다.

이것을 `Jetpack` 의 기초를 만들기 위해 사용하며, Android Extension Libraries 또는 `AndroidX`라고 부릅니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/05.png" }}" /> 

## What's new in AndroidX

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/06.png" }}" /> 

### Jetpack

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/07.png" }}" /> 

Jetpack은 지침, 권장 라이브러리, 도구 모음이며, 훌륭한 애플리케이션을 만드는 방법을 가르쳐줄 것입니다. 여기에 AndroidX 라이브러리가 포함될 수 있습니다. 그리고 AndroidX에 없는 라이브러리가 포함될 수 있습니다.

지침이 변경되고 발전하면 AndroidX의 일부 기능이 쓸모없어지면 Jetpack 권고 사항에 포함되지 않을 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/08.png" }}" /> 

반면 AndroidX는 라이브러리 그 자체입니다. 버전 / API / 의존성에 대한 보증이며, 귀여운 로고가 없습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/09.png" }}" /> 

더 작고, 논리적이며, 많은 Scope를 Artifact를 가질 것입니다. 예를 들어 ViewPager는 v4를 Support가 아닌 ViewPager Artifact로 있게 됩니다. 더이상 다른 위젯들을 끌어들이지 않아도 됩니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/10.png" }}" /> 

나누어진 라이브러리가 있으며, 이것은 단지 샘플입니다. 

- collection : 순수 Java 라이브러리이며 Jar입니다.
- core : SupportV4에서 사용하던 하위 호환성입니다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/11.png" }}" />

Google I/O에 연결된 릴리즈 대신 28.0.0에서 1.0.0으로 새로 시작합니다. 이제 주요 버전 번호가 의미하는 바가 확실해졌습니다. 이전에는 버전이 작을 경우 호환성이 깨졌습니다. Support Library의 특정 버전에 의존하는 라이브러리를 사용하는 경우 실제로 문제가 될 수 있습니다.

엄격한 시맨틱 버전 관리로의 전환은 주요 버전 번호가 바이너리 호환성을 나타낼 것이라고 기대할 수 있습니다. 

monolithic 릴리즈 대신 해당 라이브러리의 버그가 수정되었을 경우, 그 라이브러리만 변경하면 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/12.png" }}" />

레이어와 기능에 따라 `androidx.<feature>.ClassName` 의 일관된 체계를 가지고 Maven Naming Scheme에 반영합니다. 그래서 Group ID는 `androidx.<feature>` 가 될 것입니다. artifact ID는 기능이 됩니다.

명시적 하위 호환성 또는 컴파일 SDk 요구사항을 변경했습니다. 최소 SDK 요구 사항은 라이브러리의 Android Manifests에 내장되어 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/13.png" }}" />

AndroidX 최상위 패키지의 일부입니다. 호환되는 Android Support에 있던 항목이 Android Extension Library에 추가되었습니다. 대부분은 이름을 유지하지만, 단순화된 부분도 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/14.png" }}" />

BuildCompat이 명시적 v4 support에서 android.core.os.BuildCompat으로 옮겨졌습니다. 향후 더 적어진 compat 접미사를 볼 수 있습니다. CardView V7은 이제 cardview.widget이고 클래스는 CardView입니다.

### Refactoring

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/15.png" }}" />

Android Studio를 사용하는 경우 마이그레이션을 위한 자동화된 도구를 제공합니다. Android Studio Canary 14부터 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/16.png" }}" />

`Refactor - Refactor to  AndroidX` 메뉴에서 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/17.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/18.png" }}" />

마이그레이션을 변경되는 내용을 검토할 수 있으며, **Refactor Do** 클릭으로 실제 리팩터링을 할 수 있습니다. 일정한 클래스를 포함한 소스 코드를 처리합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/19.png" }}" />

복잡한 문제가 없는 간단한 build script도 처리합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/20.png" }}" />

마이그레이션은 레이아웃 파일과 같은 리소스도 처리합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/21.png" }}" />

AAR과 JAR에 대한 바이너리 종속성을 마이그레이션 처리할 것입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/22.png" }}" />

바이너리 종속성을 위해 Jetifier라는 도구를 제작했습니다. 이 도구는 ASM을 사용하여 바이너리 변환을 수행합니다. ASM은 기존 Support Library를 새로운 Support Library로 변환하고 재작성합니다. 이것은 JAR 내부 코드를 처리합니다. XML 및 ProGuard 파일도 처리합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/23.png" }}" />

오래된 클래스와 새로운 클래스의 매핑을 가진 거대한 CSV 파일을 제공할 것입니다. 독립 실행형 "Jetifier" 도구외에도 빌드 시스템과 IDE에서 함께 연결하여 수동으로 마이그레이션을 할 수 있습니다.

정리하면 Android Studio 3.2 Canary 14에서 이러한 도구를 제공하고 있습니다. Jetifier는 이미 Google Maven에 있습니다. Canary 14에서 버그를 발견했기때문에 `Canary 15`가 사용 가능할 때까지 기다려주세요.

마이그레이션에는 시간이 걸리므로 AndroidX와 함께 Android Support Library 28.0.0을 계속 제공할 예정입니다. 그러나 이번 버전이 마지막 릴리즈입니다.

> 더 자세한 세션을 원하면 아래의 세션을 참고해주세요
>
> [What's new with the Android build system (Google I/O '18)](https://www.youtube.com/watch?v=N5xONyp69eU)

## What's new Features

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/24.png" }}" />

### RecyclerView

#### Selection

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/25.png" }}" />

Item 선택을 더 쉽게 처리할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/26.png" }}" />

새로운 Dependency를 build.gradle에 추가합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/27.png" }}" />

새로운 레이아웃, 어댑터를 만듭니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/28.png" }}" />

여기서 중요한 것은 안정된 ID를 처리한다는 것입니다. ID에서 항목으로 일관된 매핑이 가능합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/29.png" }}" />

KeyProvider를 제공합니다. 그리고 안정된 ID와 함께 선택 라이브러리가 선택을 처리할 항목 사이의 빠른 매핑을 가능하게 합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/30.png" }}" />

이제 Selection Tracker를 설정합니다. 이 Selection Tracker가 실제 작업을 담당하며, KeyProvider인 ReclycerView를 전달합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/31.png" }}" />

MyDetailsLookup 은 간단한 클래스이며, 하나의 메소드만 override 하면 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/32.png" }}" />

그리고, 모션 이벤트에 대한 항목의 위치와 선택 키를 반환합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/33.png" }}" />

RecyclerView 에는 기본 선택 메커니즘이 없으므로, onBind에서 처리해야합니다. View의 배경색을 변경하거나 Activate 상태를 설정할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/34.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/35.png" }}" />

Activate 상태의 선택 가능한 Drawable을 사용하여 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/36.png" }}" />

Library에는 더 많은 것이 있습니다. Band Selection, Custom Selection Area 등 다양하게 할 수 있습니다.

#### ListAdapter

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/37.png" }}" />

ListAdapter는 시간이 지남에 따라 내용을 변경하는 RecyclerView로 작업하는데 도움이 됩니다. 단지 새로운 리스트를 등록하기만 하면됩니다.  백그라운드 스레드에서 DiffUtil 도구가 리스트가 어떻게 변경되었는지에 따라 애니메이션을 실행합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/38.png" }}" />

여러분이 해야 할 일은 Diff 콜백을 만드는 것입니다. Diff 콜백은 두 가지 Method를 구현해야 합니다. 먼저 항목 ID를 비교할 때 항목이 동일한지 확인합니다. 그리고 두 번째는 그 내용이 Deep Compare로 항목이 동일한지 확인합니다. 그리고 변화가 있다면 아이템을 Crossfade 합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/39.png" }}" />

그 다음 getItem을 호출하여 바인딩을 수행하고 애니메이션 작업을 시작하면 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/40.png" }}" />

그리고 `submitList` 를 호출하여 리스트를 전달하면 됩니다. 고급 어댑터를 사용해야하는 경우 `AsyncListDiffer` 라는 기본 어댑터도 있습니다.

>  더 자세한 세션을 원하면 아래의 세션을 참고해주세요
>
> [Android Jetpack: manage infinite lists with RecyclerView and Paging (Google I/O '18)](https://www.youtube.com/watch?v=BE5bsyGGLf4)

### WebKit

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/41.png" }}" />

이전 버전의 WebView에서 이전 버전과 호환되는 방식으로 추가한 API를 가져올 수 있습니다. 이 라이브러리는 PlayStore를 통해 업데이트 가능한 WebView가 도입된 API 21 이상에서 작동합니다. 예로서 API 27에서 추가된 Safe Browsing API는 이전에는 API 27 이상에서만 사용할 수 있었지만, 이제는 구형 단말에서 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/42.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/43.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/44.png" }}" />

Gradle을 추가 후 사용 가능합니다. WebViewFeature.isFeatureSupported를 통해 그 기능이 사용할 수 있는지 확인한 후 가능하다면 Safe Browsing을 시작합니다.

### Browser library

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/45.png" }}" />

이전 Custom Tabs은 Android Brwoser가 되었습니다. 실제로 기능이 변경된 것은 아닙니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/46.png" }}" />

Brwoser Action이라는 기능이 추가되었으며 Browser의 Context Menu에 연결할 수 있게 해줍니다. Chrome 66을 시작으로 다른 브라우저에서도 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/47.png" }}" />

브라우저 작업 항목에 대해 PendingIntent를 설정할 수 있습니다. 이것은 선택 사항입니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/48.png" }}" />

그리고, 설정하는 브라우저 작업 추적도 선택할 수 있습니다. 이렇게 하면 Dialog에서 사용자가 선택한 내용을 볼 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/49.png" }}" />

마지막으로 Browser ActionDialog를 열어 결과를 확인합니다.

### HeifWriter

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/50.png" }}" />

Heif 는 고효율 이미지 포맷입니다. Android P에서 Heif 플랫폼 지원을 시작했으며, 라이브러리를 사용하여 ByteBuffers, Surfaces, Bitmap 을 가져와 파일에 쓸 수 있습니다. 현재 API 28 이상에서 유효합니다만, Backport 작업 중입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/51.png" }}" />

사용법은 간단합니다. HeifWriter 객체를 만들어서 Builder를 생성합니다. 이미지 크기나 화질과 같은 옵션을 설정할 수 있습니다. build()를 호출하고, start()로 실제 쓰기 시작합니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/52.png" }}" />

Bitmap을 넣은 다음 디스크에 쓰고 싶으면 타임아웃 값과함께 stop()을 호출하고, 무한대로 원할 경우 0으로 설정할 수 있습니다. 중요한 것은 UIFriend에서 이 작업을 수행하는 것입니다.

### Slices

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/53.png" }}" />

Slices는  앱 외부에서 컨텐츠를 표시할 수 있는 기능입니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/54.png" }}" />

목표는 시스템과 다른 앱이 앱의 콘텐츠를 요청할 수 있는 재사용 가능한 API를 만드는 것입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/55.png" }}" />

실시간 컨텐츠가 있을 때 풍부하고 유연한 레이아웃으로 표시할 수 있도록 템플릿으로 구성되어 있습니다. 컨텐츠는 상호 작용이 가능하며, Slider, Toggle, ScrollView와 같은 기존 컨트롤을 추가하여 인라인 액션이 있는 LiveData 또는 앱의 딥링크를 함께 가질 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/56.png" }}" />

Slices를 검색과 통합하도록 선택할 수 있습니다. 사용자가 앱 이름을 검색하거나 등록한 용어를 검색하여 앱 콘텐츠를 표시할 수 있습니다. 이 기능은 AndroidX에서 구현되었기때문에 API 19에서 바로 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/57.png" }}" />

AndroidX에서 가져올 라이브러리가 세개가 있습니다. Template 형식으로 컨텐츠를 빌드하는 메소드를 포함하는 `slice-builder` 입니다. 컨텐츠를 제공하는 method가 포함되어 있는 `slice-view`이고, 사용 권한을 포함하는 `slice-core` 입니다. Slice를 생성하려면 Slice를 정의하고, 구현하여 동작을 처리해야합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/58.png" }}" />

가장 먼저 해야 할 일은 시스템이나 다른 앱에 제공할 Slice가 있음을 알려주는 것입니다. Slice Provider를 구현하고 AndroidManifest에 등록하면 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/59.png" }}" />

다음으로 SliceProvider를 확장하여 SliceProvider를 구현합니다. 앱에 여러 개의 Slice를 가질 수 있습니다. 비즈니스 로직이 발생하는 곳입니다. 플랫폼, 다른 애플리케이션에서 Slice를 가져오려고 할 때 `onBindSlice` 가 호출됩니다. Slice URI가 있는 요청을 받으면 즉시 Slice를 반환해야 합니다. 로드해야하는 컨텐츠는 시작해야하며 `buildSlice` 로 반환합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/60.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/61.png" }}" />

listBuilder 를 사용하여 매우 간단한 헤더를 추가합니다. 제목과 부제목이 있으며 헤더를 추가하는 메소드가 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/62.png" }}" />

최신 기상 정보를 얻은 다음, `gridRowBuilder` 에 Cell을 추가할 수 있습니다. 그리고 addGridRow를 호출하여 헤더의 나머지 Slice를 추가합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/63.png" }}" />

실제 사용하는 곳의 공간이 허용되는 곳에 따라서 정보가 노출됩니다. 

> 더 자세한 세션을 원하면 아래의 세션을 참고해주세요
>
> [Android Slices: build interactive results for Google Search (Google I/O '18)](https://www.youtube.com/watch?v=a7IVH5aNwwc)

### Material Components

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/64.png" }}" />

3월에 Support Library 28.0.0 alpha1에서 Meterial Components를 출시했으며, AndroidX용으로도 출시했습니다. AndroidX 리팩토링의 일환으로 android.support.design에서 `com.google.android.material` 으로 옮겼습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/65.png" }}" />

오른쪽에는 브랜드 독립적이고, 왼쪽은 구글 브랜드가 있습니다. 모든 컴포넌트가 테마에서 가져올 수 있으므로 프로그램 전체에서 쉽게 테마를 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/66.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/67.png" }}" />

라이브러리를 가져와서 com.google.android.material 에서 제공되는 기준 테마를 사용하려면 테마를 MaterialComponents.Light 로 설정합니다. 이것은 브랜드와 상관없는 테마입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/68.png" }}" />

애플리케이션 내의 모든 위젯이 선택할 수 있도록 재정의할 수 있는 속성을 제공합니다. 예로서 기본 색상과 텍스트를 정의했습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/69.png" }}" />

다른 텍스트 스타일에 대한 속성을 정의할 수 있습니다.

#### TextField 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/70.png" }}" />

터치 타겟을 개선하고 입력을 더 쉽게하며 더 유용하고 접근하기 쉽게 만들었습니다. 또한, 포커스 상태, 오류, 비활성화 및 텍스트 카운터를 포함하는 새로운 상태를 추가했습니다.

#### Button

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/71.png" }}" />

#### Bottom App Bar

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/72.png" }}" />

BottomBar에서 앱에 작업을 추가할 수 있습니다. 휴대전화가 커짐에 따라 원하는 곳에  AppBar 를 두고 싶습니다. 우측 정렬을 위해 애니메이션을 만들 수 있습니다.

#### Bottom Navigation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/73.png" }}" />

BottomAppBar 는 작업을 위한 것이고, Bottom Navigation은 앱 내의 다른 섹션을 위한 것입니다. 

#### Material Card View

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/74.png" }}" />

AndroidX의 Support Library에 있는 기존 CardView의 Wrapper인 MaterialCardView입니다. 더 단순화하여 더 낮은 Elevation과 Shadow를 갖게하고, Theme와 Color도 가져옵니다.

> 해당 부분은 해석이 자연스럽지 않아 원문을 포함했습니다.
> We've simplified how this was built so that it has less elevation and shadow, and it also pulls from the theme and color.

> 더 자세한 세션을 원하면 아래의 세션을 참고해주세요
>
> [How to incorporate what's new with Material Design in your code base (Google I/O '18)](https://www.youtube.com/watch?v=D7LB-QPxH9c&t=514s)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/whats-new-in-android-support-library/75.png" }}" />

AndroidX는 Jetpack의 한 부분입니다. Jetpack은 훌륭한 Android 앱을 빠르고 쉽게 만들 수 있도록 도와주는 일련의 Component, 도구 및 지침입니다. 