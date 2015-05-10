---
layout: post
title: "[번역] 요즘 활용하는 Android 오픈소스 라이브러리 모음"
date: 2015-05-11 02:00:00
tag: [Android, OpenSource]
categories:
- blog
- Android-Study
- OepnSource
---

이 포스팅은 [イマドキなイカした Android のオープンソースライブラリ集](http://qiita.com/KeithYokoma/items/fb6872a72a75e9b6f2e6#view-%E3%81%AE%E7%94%9F%E6%88%90) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

지금부터 Android를 한다면 체크하자, 엄선한 오픈소스 라이브러리 모음.

support-v4나 support-v7-appcompat 등은 공식적인 것이기 때문에 배제.

## 개발 환경

- - -

### Android SDK

- - -

- [Android SDK Installer](https://github.com/embarkmobile/android-sdk-installer)

공식 사이트에서 다운로드하고 체크해서 다운로드하고...가 귀찮다면 이것.

shell로부터 커맨드 한번으로 다운로드가 가능하기때문에 CI에서 사용하기도 편리.

- [ADB Idea](https://github.com/pbreault/adb-idea)

Android Studio와 IntelliJ용 플러그인으로 IDE에서 ADB 커맨드를 간단하게 이용하기 위한 것

메뉴로부터 선택해서 커맨드를 실행하게 해준다.

## 코드 최적화

- - -

### DI Container

- [Dagger](https://github.com/square/dagger)

square사의 Android 및 Java용 DI Container

`javax.inject.Inject` Annotation을 사용한다.

컴파일시에 코드를 생성한다.

- [Proton](https://github.com/hnakagawa/proton)

Android용 DI Container

`javax.inject.Inject` Annotation을 사용한다.

실행시에 인스턴스를 주입한다.

- [ButterKnife](https://github.com/JakeWharton/butterknife)

View의 Injection에 특화되어있다.

- [RoboGuice](https://github.com/roboguice/roboguice)

Google이 제공하는 Guice의 Android용 Wrapper.

`javax.inject.Inject` Annotation을 사용하고, 독자적으로 Injection용 Annotation도 제공하고 있다.

### View 생성

- [Michelangelo](https://github.com/RomainPiel/Michelangelo)

Annotation을 사용해서 Custom View 코드를 관리할수 있다.

View가 inflat된 후에 실행하고 싶은 처리를 Annotation으로 표시할수 있다.

### Resource

- [Paraphrase](https://github.com/JakeWharton/paraphrase)

문자열 리소스의 포맷을 보다 읽기쉽게 하기위해, 보다 디버그하기 쉽게하기 위한 라이브러리.

문자열 리소스의 포맷에 대한 프로그래밍 에러가 런타임이 아니라 컴파일시에 판명된다.

### Utility

- [AndroidAnnotations](https://github.com/excilys/androidannotations)

Annotation을 사용해서 컴파일시에 코드를 자동생성해주는 것으로, 프로그래머가 작성하는 코드량을 줄여주는 라이브러리.

DI Container로서 View나 System Service, Resource, Intent를 포함하는 Extra를 주입할 수 있고, 메소드가 메인 / Background 스레드에서 실행할까도 제어가능하다.

- [Amalgam](https://github.com/nohana/Amalgam/)

Apache Commons과 같은 Commons 라이브러리로, Android용.

`Context#getSystemService(String)` Wrapper나 각종 Manager관련 Wapper가 있다.

- [Guava](https://github.com/google/guava)

Apache Commons과 같은 Commons 라이브러리.

Java용으로 각종 유틸리티가 갖춰져있다.

### 디바이스 의존 해결

- [AndroidDeviceCompatibility](https://github.com/mixi-inc/Android-Device-Compatibility)

디바이스마다 의존을 호환하기위한 라이브러리.

### 모듈화

- [android-promise](https://github.com/hnakagawa/android-promise)

비동기 처리를 모듈화하기위한 라이브러리.

## UI Componet

- - -

### Pull to refresh

- [ActionBar PullToRefresh](https://github.com/chrisbanes/ActionBar-PullToRefresh)

끌어당기면 ActionBar에 갱신 표시가 나타나는 UI Componet.

- [Android PullToRefresh](https://github.com/chrisbanes/Android-PullToRefresh/)

Twitter 스타일로 끌어당겨 갱신하는 UI Componet.

현재 유지보수가 종료되어, 사용한다면 위의 ActionBar PullToRefresh 를 사용하는것이 좋다

### ActionBar

- [FadingActionBar](https://github.com/ManuelPeinado/FadingActionBar)

ActionBar에 FadeOut효과를 적용하기위한 라이브러리.

- [GlassActionBar](https://github.com/ManuelPeinado/GlassActionBar)

ActionBar에 투명효과를 적용하기위한 라이브러리.

### WebView

- [Chromium WebView](https://github.com/mogoweb/chromium_webview)

KitKat에 도입된 Chromium 엔진의 WebView의 backport 라이브러리.

이걸 사용하면, OS 버전이나 기종마다 WebKit 의존문제가 해결될지도 모른다.

### Text, Font

- [emojicon](https://github.com/rockerhieu/emojicon)

TextView에 이모티콘을 표시하기위한 라이브러리.

- [IonIconView](https://github.com/MarsVard/IonIconView)

ionicons.com에서 제공하고있는 아이콘을 View에 표시가능하게 하는 라이브러리.

- [Android Iconify](https://github.com/JoanZapata/android-iconify)

FontAwesome의 각종 폰트를 어플리케이션에서 사용하기위한 라이브러리.

- [Calligraphy](https://github.com/chrisjenx/Calligraphy)

Custom 폰트를 간단하게 사용하게해주는 라이브러리.

### Calendar

- [ExtendedCalendarView](https://github.com/tyczj/ExtendedCalendarView)

Calendar 컨텐츠를 유지하는 DB와 셋트로 이벤트를 표시할수있는 Calendar View를 제공해주는 라이브러리.

- [GoogleCalendarView](https://github.com/tyczj/GoogleCalendarView)

Google 공식 Calendar 어플리케이션의 backport

### Effect

- [Android StackBlur](https://github.com/kikoso/android-stackblur)

Bitmap에 Blur 효과를 적용한다.

- [GPUImage Android](https://github.com/CyberAgent/android-gpuimage)

iOS용으로 만들어져있는 GPU Image의 Android 이식 버전.

### 통지

- [SuperToasts](https://github.com/JohnPersano/SuperToasts)

Toast를 확장해서, 버튼을 배치하거나 표시를 조금 바꿀수 있는 라이브러리.

- [Crouton](https://github.com/keyboardsurfer/Crouton)

표준 Toast의 대체로서, Context에 의존해서 Custom 가능한 Toast를 제공한다.

### Layout

- [ImageLayout](https://github.com/ManuelPeinado/ImageLayout)

이미지위에 View를 배치하기위해 특별한 Layout Component.

톡자적인 좌표계를 가지고 관리하고있다.

### ListView, GridView

- [StickyListHeaders](https://github.com/emilsjolander/StickyListHeaders)

Instagram과 같은 ListView의 Scroll에 연결해오는 Header를 제공한다.

- [StickyGridHeaders](https://github.com/TonicArtos/StickyGridHeaders)

상기 라이브러리의 GridView 버전

- [Android StaggeredGrid](https://github.com/etsy/AndroidStaggeredGrid)

높이가 다른 Grid를 다룬다.

- [AdapterView Animator](https://github.com/SimonVT/adapterviewanimator)

AdapterView의 행을 추가할때의 Animation을 구현하는 Helper 라이브러리.

- [cwac-touchlist](https://github.com/commonsguy/cwac-touchlist)

List의 Drag&Drop을 구현하는 라이브러리.

### ViewPager

- [JazzyViewPager](https://github.com/jfeinstein10/JazzyViewPager)

Swipe시에 Animation을 커스터마이징할수 있다.

- [Android ViewPagerIndicator](https://github.com/JakeWharton/Android-ViewPagerIndicator)

ViewPager에 연결해 위치표시하는 View

### Dialog

- [Android Styled Dialogs](https://github.com/inmite/android-styled-dialogs)

Dialog에 테마로 스타일을 적용하기위한 라이브러리

### ImageView

- [CustomShape ImageView](https://github.com/MostafaGazar/CustomShapeImageView)

이미지를 잘라내서 여러가지 형태로 가능한 ImageView

- [Rounded ImageView](https://github.com/vinc3m1/RoundedImageView)

Rounded ImageView를 만드는 라이브러리

- [PhotoView](https://github.com/chrisbanes/PhotoView)
- [ImageViewZoom](https://github.com/sephiroth74/ImageViewZoom)

이미지의 확대/축소 기능을 가진 ImageView

### Chart

- [Holo Graph Library](https://bitbucket.org/danielnadeau/holographlibrary)

Holo 스타일 Graph Chart를 만드는 라이브러리

- [AChartEngine](https://code.google.com/p/achartengine/)

이것도 Graph Chart를 만드는 라이브러리

### Interaction

- [Android Swipe To Dismiss](https://github.com/romannurik/Android-SwipeToDismiss)

View를 Swipe해서 제거를 위한 라이브러리

- [EnhancedListView](https://github.com/timroes/EnhancedListView)

Gmail과 같이, 행을 Swipe하는 것으로 삭제를 실행하는 Interaction을 구현, 거기에다 Undo 기능도 가지는 ListView의 확장.

### etc

- [Android Sliding Up Panel](https://github.com/umano/AndroidSlidingUpPanel)

Google Play Music와 같이 아래에서 위로 밀어올리는 Panel을 표시하는 라이브러리

- [CardsLib](https://github.com/gabrielemariotti/cardslib)

Card UI를 구축하기위한 라이브러리

- [ProgressWheel](https://github.com/Todd-Davies/ProgressWheel)

빙글빙글 도는 ProgressBar를 커스터마이징하는 라이브러리

- [Android Bootstrap](https://github.com/Bearded-Hen/Android-Bootstrap)

FontAwesome과 함께 Bootstrap 스타일 버튼 종류를 사용할수있게하는 라이브러리

- [Android Satellite Menu](https://github.com/siyamed/android-satellite-menu)

Path 같은 메뉴를 구축하는 라이브러리

- [NineOldAndroids](https://github.com/JakeWharton/NineOldAndroids)

API 11부터 등장한 Animation Framework를 호환하는 라이브러리

- [Holo Everywhere](https://github.com/Prototik/HoloEverywhere)

Holo 테마를 호환하는 라이브러리

- [Holo ColorPicker](https://github.com/LarsWerkman/HoloColorPicker)

색을 선택하는 View 라이브러리

- [Android Validator](https://github.com/throrin19/Android-Validator)

입력 Validation을 위한 라이브러리

- [android-gifview](https://code.google.com/p/android-gifview/)

Gif Animation을 재생가능한 View 라이브러리

## 직렬화

- - -

### Json

- [Google Gson](https://code.google.com/p/google-gson/)

Reflection을 위한 매핑 라이브러리

- [Jackson](http://jackson.codehaus.org/)

초고속으로 직렬화, 역역직렬화 가능한 라이브러리

## Database

- - -

### ORM

- [GreenDAO](https://github.com/greenrobot/greenDAO)

Green이다! 좋다!

스키마, 엔티티를 각각 정의하는 클래스를 사용해서 매핑한다.

- [Active Android](https://github.com/pardom/ActiveAndroid)

엔티티 클래스의 선언에 Annotation을 붙여서 매핑한다.

## Event Bus

- - -

사용법은 [이쪽](http://qiita.com/KeithYokoma/items/793aaac6994c9242808f)

- [otto](https://github.com/square/otto)

Guava 기반의 Android용 경량 Event Bus.

- [EventBus](https://github.com/greenrobot/EventBus)

otto보다 기능적으로 확장한 Event Bus.

## Debug 지원

- - -

### View

- [scalpel](https://github.com/JakeWharton/scalpel)

View의 계층 구조를 3D로 표시하는 Tool

### Resource

- [Madge](https://github.com/JakeWharton/madge)

Bitmap이 원본 사이즈로 표시되어있는가를 한눈으롤 보기쉽게 한다.

### Crash Log

- [Native Crash Handler](https://github.com/SalomonBrys/Native-Crash-Handler)

Native 코드의 에러 핸들링으로, SIGSEGV 등을 검출해서 Java의 예외를 생성해준다. 이로서, Google Play 등에 수집되지못한 Crash Log를 수집할수있게 한다.

### Log 출력

- [hugo](https://github.com/JakeWharton/hugo)

Annotation에 위한 메소드 콜의 로깅 라이브러리

- [deploygate](http://deploygate.com/)

로그 수집뿐만아니라, apk의 배포까지도 구축해주는 서비스.

sdk를 포함하면 많은것이 Web Console상에서 가능하다.

## 이미지

- - -

### 이미지 Load, Cache

- [Android Universal Image Loader](https://github.com/nostra13/Android-Universal-Image-Loader)

각종 설정으로 이미지 Load, Cache, 표시를 해주는 라이브러리

- [picasso](https://github.com/square/picasso)

메소드 체인으로 이미지 Load, Cache, 표시를 해주는 라이브러리

### 가공

- [CropImage](https://github.com/biokys/cropimage)

이미지 자르기를 지원하는 라이브러리

## Hybrid Application 개발

- - -

네이티브 구현을 기본으로 JavaScriptInterface과 연계해서 하이브리드 어플리케이션을 개발하는 프레임워크

- [Hybridge](https://github.com/rejasupotaro/Hybridge)
- [triaina](https://github.com/mixi-inc/triaina)

## Test

- - -

### Test Utility

- [fest-android](https://github.com/square/fest-android)

Android 테스트에 FEST를 도입할수있다.

- [robolectric](https://github.com/robolectric/robolectric)

Android 테스트의 고속화

- [Robotium](https://code.google.com/p/robotium/)

UI 테스트를 Selenium과 같이하고, Android 프레임워크가 가진 UI 테스트 프레임워크를 확장하고 있다.

### Mock

- [Mockito](https://code.google.com/p/mockito/)

여러가지를 Mock하기위한 라이브러리

- [RobotGirl](https://github.com/rejasupotaro/RobotGirl)

ActiveAndroid용 fixtures 라이브러리

## 통신

- - -

### REST

- [Retrofit](https://github.com/square/retrofit)
- [RoboZombie](https://github.com/sahan/RoboZombie)

REST 클라이언트를 간단하게 생성하기위한 라이브러리

### Http통신, SPDY

- [okhttp](https://github.com/square/okhttp)

http(s) 통신과 SPDY에 대응한 클라이언트.

- [volley](https://android.googlesource.com/platform/frameworks/volley/)

통신처리를 여러가지로 이용가능한 유틸리티

## 빌드 스크립트

- - -

### Gradle

- [Gradle Android Utils](https://github.com/gfx/gradle-android-utils)

빌드 스크립트 유틸리티 모음

- [Gradle MVN Push](https://github.com/chrisbanes/gradle-mvn-push)

Maven Repository에 aar같은 성과물을 push하는 Helper

- [Gradle Android Test Plugin](https://github.com/JakeWharton/gradle-android-test-plugin)

Gradle에 Android 테스트를 실행하기위한 Helper Plugin

## 그외 편리한 것

- - -

### Update Check

- [UpdateChecker](https://github.com/rampo/UpdateChecker)

업데이트가 있을때 Dialog를 표시한다.

### Review

- [RateThisApp](https://github.com/kskkbys/Android-RateThisApp)

Review를 재촉하는 Dialog를 표시한다.

### Job Queue

- [Priority JobQueue](https://github.com/path/android-priority-jobqueue)

우선도를 포함한 JobQueue

- [nirai](https://github.com/jfsso/nirai)

IntentService에 의한 JobQueue 구성

자세한것은 [이쪽](http://qiita.com/jfsso/items/106f48de7ec0612038bb)

### SharedPreferences

- [esperandro](https://github.com/dkunzler/esperandro)

SharedPreferences의 Wrapper