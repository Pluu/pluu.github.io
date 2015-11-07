---
layout: post
title: "[번역] 「Androidオープンソースライブラリ徹底活用」에서 소개된 라이브러리"
date: 2015-05-12 01:00:00
tag: [Android, OpenSource]
categories:
- blog
- Android
- OepnSource
---

이 포스팅은 [「Androidオープンソースライブラリ徹底活用」에서 소개된 라이브러리](http://qiita.com/matsu911/items/28198f95026e00df73d1) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

「Androidオープンソースライブラリ徹底活用」에서 소개된 라이브러리의 소개입니다.

【서적정보】
타이틀명 : Androidオープンソースライブラリ徹底活用
저자명 : 八木俊広
출판사명 : (株)秀和システム

서적소개 페이지는 [이곳](http://www.shuwasystem.co.jp/products/7980html/4002.html)

샘플 코드는 [이곳](https://github.com/android-opensource-library-56/android-opensource-library-56)

### UI 관련 라이브러리

- - -

- [android-support-v4](http://developer.android.com/tools/support-library/index.html) Fragment등의 기능을 Android 2.x계열에서도 구현하기위한 공식 서포트 라이브러리
- [ActionBarSherlock](https://github.com/JakeWharton/ActionBarSherlock) ActionBar를 Android 2.x계열에서도 이용하기위한 유명한 라이브러리
- [Android-PullToRefresh](https://github.com/chrisbanes/Android-PullToRefresh) 끌어당겨서 화면을 갱신. Pull To Refresh를 구현하는 라이브러리
- [SlidingMenu](https://github.com/jfeinstein10/SlidingMenu) 옆에서 당겨서 메뉴 표시를 구현하는 라이브러리
- [SwipeListView](https://github.com/47deg/android-swipelistview) ListView의 요소를 Swipe해서 넘기는 라이브러리
- [MultiChoiceAdapter](https://github.com/ManuelPeinado/MultiChoiceAdapter) ListView에서 요소의 복수선택을 가능하게하는 라이브러리
- [StickyListHeaders](https://github.com/emilsjolander/StickyListHeaders) ListView에서 Section마다 Header를 고정시키는 라이브러리
- [android page curl](https://code.google.com/p/android-page-curl/) 책의 페이지를 넘기는것 같은 Effect가 가능한 라이브러리
- [ViewPagerIndicator](https://github.com/JakeWharton/Android-ViewPagerIndicator) ViewPager의 Indicator를 간단하게 커스텀마이징가능한 라이브러리
- [NewQuickAction](https://github.com/lorensiuswlt/NewQuickAction) Popup 메뉴를 구현하는 라이브러리
- [Android ViewBadger](https://github.com/jgilfelt/android-viewbadger) iOS같은 뱃지를 구현하기위한 라이브러리
- [Android ProgressFragment](https://github.com/johnkil/Android-ProgressFragment) Fragment에서 Progress 표시를 간단하게 구현하는 라이브러리
- [HoloEverywhere](https://github.com/Prototik/HoloEverywhere) ICS의 UI 테마인 Holo를 Android 2.1이상에서 이용가능한 라이브러리
- [HoloColorPicker](https://github.com/LarsWerkman/HoloColorPicker) 색을 선택하는 Picker를 구현하는 라이브러리
- [aFileChooser](https://github.com/iPaulPro/aFileChooser) 단말내의 파일을 선택하기위한 Activity를 제공하는 라이브러리
- [Android Validator](https://github.com/throrin19/Android-Validator) 입력내용의 포맷 체크를 하는 라이브러리
- [PhotoView](https://github.com/chrisbanes/PhotoView) 이미지의 줌, 스크롤 조작을 구현하는 라이브러리
- [ImageLayout](https://github.com/ManuelPeinado/ImageLayout) 이미지위에 View를 배치하는 레이아웃
- [StyledDialogs](https://github.com/inmite/android-styled-dialogs) DialogFragment 기반의 다이얼로그를 간단하게 이용가능한 라이브러리

### 이미지 처리 라이브러리

- - -

- [GPUImage for Android](https://github.com/CyberAgent/android-gpuimage) 이미지에 Effect를 적용하기위한 라이브러리
- [ZXing](https://code.google.com/p/zxing/) 바코드나 QR코드를 읽어들이는 라이브러리
- [svg-android](https://code.google.com/p/svg-android/) SVG를 묘사하기위한 라이브러리
- [android gifview](https://code.google.com/p/android-gifview/) 애니메이션 GIF를 재생하는 라이브러리

### 네트워크 관련 라이브러리

- - -

- [Asynchronous Http Client for Android](https://github.com/loopj/android-async-http) 비동기 HTTP 통신처리를 간단하게 구현가능한 라이브러리
- [Volley](https://android.googlesource.com/platform/frameworks/volley/) Google 공식 HTTP 처리용 라이브러리
- [Universal Image Loader for Android](https://github.com/nostra13/Android-Universal-Image-Loader) 대량의 이미지를 처리할때 편리한 라이브러리
- [Scribe](https://github.com/fernandezpablo85/scribe-java) 여러가지 서비스의 OAuth인증을 도와주는 라이브러리

### 데이터 처리 라이브러리

- [JsonPullParser](https://github.com/vvakame/JsonPullParser) JSON을 순차해석하기위한 라이브러리
- [Gson](https://code.google.com/p/google-gson/) Java 오브젝트와 JSON을 상호변환하는 라이브러리
- [dom4j](https://code.google.com/p/dom4j-android/) XML조작으로 유명한 라이브러리
- [jsoup](https://github.com/jhy/jsoup/) HTML을 파싱하기위한 유명한 라이브러리

### 데이터베이스 라이브러리

- [greenDAO](https://github.com/greenrobot/greenDAO) Android에 최적화된 DAO를 생성하는 라이브러리
- [ActiveAndroid](https://github.com/pardom/ActiveAndroid) Annotation을 사용한 O/R Mapper 라이브러리
- [SQLCipher for Android](https://github.com/sqlcipher/sqlcipher) SQLite 데이터베이스의 데이터를 암호화시키는 라이브러리

### 설정 라이브러리

- [UnifiedPreference](https://github.com/saik0/UnifiedPreference) 설정화면의 작성을 지원하는 라이브러리
- [DateTimePicker](https://github.com/flavienlaurent/datetimepicker) 사용하기 쉬운 년월일의 Picker

## 지도 라이브러리

- [Polaris2](https://github.com/cyrilmottier/Polaris2) Google Maps Android API v2를 확장한 지도 라이브러리

### 로그 라이브러리

- [android-logging-log4j](https://code.google.com/p/android-logging-log4j/) Android에서 log4j를 사용하기위한 라이브러리
- [ACRA](https://github.com/ACRA/acra) Crash Report를 수집하는 라이브러리

### 테스트 라이브러리

- [Robotium](https://code.google.com/p/robotium/) BlackBox 테스트를 자동화하는 라이브러리
- [FEST Android](https://github.com/square/fest-android) Android 고유 클래스인 Assert를 제공하는 라이브러리
- [Mockito](https://code.google.com/p/mockito/) Mock Object를 작성하는 라이브러리
- [Robolectric](https://github.com/robolectric/robolectric) 실제 기기나 에뮬레이터없이 Android 어플리케이션을 테스트하는 라이브러리

### 디버그 라이브러리

- [smali](https://code.google.com/p/smali/) dex 파일을 디어셈블해서 해석하는 라이브러리
- [dex2jar](https://code.google.com/p/dex2jar/) dex 파일을 class 파일로 변환시키는 툴

### 애니메이션 라이브러리

- [NineOldAndroids](https://github.com/JakeWharton/NineOldAndroids) Android 3.0에서 추가된 새로운 애니메이션 프레임워크를 Android 2.x에서도 사용가능하게한 라이브러리
- [ListViewAnimations](https://github.com/nhaarman/ListViewAnimations) ListView의 요소를 표시하거나 조작할때의 애니메이션을 구현하는 라이브러리

### 그래프 라이브러리

- [HoloGraphLibrary](https://bitbucket.org/danielnadeau/holographlibrary) Holo 테마같은 Graph를 묘사가능한 라이브러리

### 코드 최적화 라이브러리

- [AndroidAnnotations](https://github.com/excilys/androidannotations) 코드량을 줄여 개발속도나 유지보수성을 향상시키는 라이브러리
- [Android Query](https://code.google.com/p/android-query/) UI 조작이나 통신처리의 호출을 심플하게 작성하는 라이브러리
- [RoboGuice](https://github.com/roboguice/roboguice) Google Guice 기반의 ndroid용 DI Container
- [Butter Knife](https://github.com/JakeWharton/butterknife) View의 Injection에 특화한 라이브러리

### 통지 라이브러리

- [Crouton](https://github.com/keyboardsurfer/Crouton) 심플한 Toast 표시 라이브러리

### Web API 라이브러리

- [Twitter4j](https://github.com/yusuke/twitter4j/) Twitter API로 유명한 Wrapper 라이브러리
- [Evernote SDK for Android](https://github.com/evernote/evernote-sdk-android) Evernote 공식인 Android Plugin
- [flickrj-android](https://code.google.com/p/flickrj-android/) Flickr API에 접근하기위한 라이브러리
