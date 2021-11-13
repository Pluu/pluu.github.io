---
layout: post
title: "[요약] Implementing Material You using Jetpack Compose (Android Dev Summit '21)"
date: 2021-11-13 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/jrfuHyMlehc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/001.png" }}" />

- Material You는 Material Design의 차세대 버전
- 모든 스타일에 개인화되어 표현 가능

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/002.png" }}" />

Material Design 2는 Material Theming, Material Components, dark theme와 같은 기능을 지원한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/003.png" }}" />

- Compose Material 3 Jetpack 라이브러리 Alpha 버전 공개
- 업데이트된 Material Teming/Components 및 Material Design 3 기반의 Dynamic color가 포함된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/004.png" }}" />

- build.gradle에 위와 같은 종속성을 추가하여 사용할 수 있다

|                          Material 2                          |                          Material 3                          |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/005.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/006.png" }}" /> |

- 기존 대비 넓은 범위의 색조 색상과 Component에 대한 업데이트가 포함되어 있다

### Material Theming

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/007.png" }}" />

- 기존 Material Theme Composable은 Material Design 2기반이였다
- 색상, 타이포그래피, Shape를 수정 가능했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/008.png" }}" />

- Material 3는 색상 스키마와 타이포그래피 시스템을 조정하여 테마를 지정할 수 있다. Shape 관련은 곧 업데이트된다.

### Color scheme

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/009.png" }}" />

- Material 3 구성 요소에서 사용되는 기본, 배경 및 오류와 같은 명명된 색상을 기준으로 Color scheme를 만든다
- Light/Dark 테마에 대한 색상을 제공한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/010.png" }}" />

- 색조 팔레트(Tonal Palettes) 세트에서 그려진다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/011.png" }}" />

> 기본 색상 슬롯

- 슬롯에서 사용하는 색상 값은 접근성 요구 사항을 충족하기 위해 Light/Dark 테마 대해 선택된 기본 색조 팔레트의 색조에서 가져온다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/012.png" }}" />

- Compose에서는 `ColorScheme` 클래스로 모델링 며, Material Design 3의 Color Scheme의 슬롯 이름을 따서 정해졌다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/013.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/014.png" }}" />

- lightColorScheme/darkColorScheme 함수를 사용하여 각 baseline의 기준 값으로 Color Scheme 인스턴스를 만든다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/015.png" }}" />

- `isSystemInDarkTheme` 함수를 사용하여 시스템 설정에 따른 Color Scheme를 선택할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/016.png" }}" />

> Material Theme Builder 도구로 생성한 jetchat의 Color Scheme

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/017.png" }}" />

- primary의 파란색 색조 팔레트와 Color Scheme에서 일치하는 기본 슬롯이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/018.png" }}" />

- Compose에서 Color Scheme 구현 전 Color 선언이 필요하다
-  Material Theme Builder 도구에서 코드 생성도 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/019.png" }}" />

- 색상 값을 사용하여 Light/Dark의 Color Scheme를 선언한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/020.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/021.png" }}" />

- 커스텀하게 만든 Composable을 만들 수 있으며, 테마에 대한 매개변수 및 앱의 콘텐츠 슬롯을 사용하여 내부 MaterialTheme Composable에 전달하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/022.png" }}" />

- UI의 일부는 Color Scheme와 다른 색상 색상을 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/023.png" }}" />

- 사용자에 따라 Avatar의 primary/tertiary 값을 사용한다
- `MaterialTheme.colorScheme` 표기법을 사용하여 Color Theme에 액세스할 수 있다

### Dynamic Color

사용자의 배경화면을 토대로 앱 및 시스템 UI에 적용할 사용자 정의 색상의 하나로 Material You의 핵심 부분이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/024.png" }}" />

- Dynamic Color는 Android 12 이상에서 사용할 수 있다
- dynamicLightColorScheme/dynamicDarkColorScheme 함수를 사용하여 Color Scheme 인스턴스를 생성할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/025.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/026.png" }}" />

- 사용자의 개인화에 맞게 배경화면 기반으로 Dynamic Color Scheme에 대한 지원을 추가할 경우
- 색조 팔레트는 배경 화면의 색상에서 내부적으로 생성된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/027.png" }}" />

- 먼저 Dynamic Color 지원에 대한 매개변수를 추가한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/028.png" }}" />

- Dynamic Color 사용 가능 여부에 따라 ColorScheme를 선택한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/029.png" }}" />

> Jetchat UI에 Dynamic Color를 적용한 모습

### Typography

Material Design 3에는 Material Design 2의 텍스트 스타일을 포함하여 새로운 유형이 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/030.png" }}" />

- 이름 지정/그룹화는 Display, Headline, Title, Body, Label로 단순화함
- 각각 Large, Medium, Small 크기가 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/031.png" }}" />

- Compose는 새로운 Typography 클래스로 이를 모델링 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/032.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/033.png" }}" />

- Roboto 기준 값으로 Typography의 인스턴스를 만들고 사용자 정의 TextStyles로 기본값을 재정의한다
- MaterialTheme()에 매개변수로 타이포그래피를 전달한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/034.png" }}" />

- 사용자 정의 폰트를 사용할 경우, `FontFamily` 클래스를 사용하여 글꼴을 선언한다
- 폰트 리소스 ID와 FontWeight로 구성할 수도 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/035.png" }}" />

- Typography 및 TextStyle을 사용하여 새롭게 정의할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/036.png" }}" />

- MaterialTheme()에 매개변수로 Typography를 전달한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/037.png" }}" />

- 별도 TextStyle을 사용할 경우, `MaterialTheme.typography`를 통해 Theme 정보에 액세스할 수 있습니다.

### Elevation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/038.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/039.png" }}" />

- Material 2 대비 Material 3에서는 톤 높이(tonal elevation)을 높이면 더 두드러진 색상의 톤이 사용된다
- Elevation 오버레이는 Material 2에서 어두운 테마의 일부였으나, Material 3에서는 `색조 색상 오버레이`로 변경되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/040.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/041.png" }}" />

- 기존 Material Design 2기반의 Suface Composable은 Elevation을 사용해 Dark 테마에서 그림자 및 오버레이 렌더링을 처리했다
- Material Design 3에서 `tonalElevation`으로 Light/Dark 테마 모두에서 `색조 색상 오버레이`로 처리한다

### Updated components

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/042.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/043.png" }}" />

- BottomNavigation에서 `NavigationBar`로 Component 이름이 변경
- Material Design 3 사양에 맞게 파라미터 명칭도 변경

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/044.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/045.png" }}" />

> Jetchat 기준으로 변경된 사항 중 하나의 사례이다

업데이트한 사항

- Composesable에 대한 정보가 Material 3로 변경
- Material 3 colorScheme의 tertiaryr 값을 containerColor에 사용

### Ripple & overscroll

- Ripple : 누를 때 표면을 비추기 위해 미묘한 반짝임을 사용 (Sparkle Ripple)
- overscroll : 스크롤의 가장자리에서 stretch effect 사용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/046.png" }}" />

- Compose Foundation 1.1 이상의 Scroll Container는 기본적으로 켜져 있다
- Sparkle Ripple은 Android 12에서 사용 가능하다

### MDC-Android Compose Theme Adapter

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/047.png" }}" />

- MDC-Android Compose Theme Adapter는 테마 지정을 위해 Jetpack Compose에서 Android XML의 머티리얼 컴포넌트로 재사용 가능한 라이브러리이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/048.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/049.png" }}" />

- 기존 **MdcTheme** Composable은 Material 2 XML 테마와 호환한다. 
- Material 3 XML 테마와 호환되는 새로운 `Mdc3Theme` Composable이 도입되었다

### Docs, samples, templates, and more

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/050.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads21/Material-You/051.png" }}" />
