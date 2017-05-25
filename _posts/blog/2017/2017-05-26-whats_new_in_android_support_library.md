---
layout: post
title: "[요약] Google I/O 2017 ~ What's New in Android Support Library"
date: 2017-05-26 00:30:00 +09:00
tag: [Android, Google I/O]
categories:
- blog
- Android
- Google
- io17
---


# What's New in Android Support Library (Google I/O '17)

Support Library 26.0 Beta 1에 대한 이야기이다.

## Support Library

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-01.png" }}" />

Support Library는 유틸리티 및 클래스 모음이며, 이전 버전의 플랫폼을 타깃으로 쉽게 머티리얼 디자인 위젯과 같은 새로운 개념을 사용 가능하며, Android 앱 개발의 필수 요소이다.

## What's old in Android Support Library

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-03.png" }}" />

작년에 9보다 낮은 SDK에 대한 지원을 중단했다는 것을 기억할 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-04.png" }}" />

오늘 Play Store 체크인에 따르면 14 미만의 API에 대해 1% 미만의 활성 Android 기기가 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-05.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-06.png" }}" />

14보다 낮은 API에 대해서 지원을 삭제한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-07.png" }}" />

몇 가지 커다란 이점을 얻었는데, 가장 중요한 점은 minSDK가 14가 된다는 점이다.

진저 브레드를 대상으로 할 경우 기존 25.3 Support Library 를 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-08.png" }}" />

메소드나 클래스를 삭제해서, 메소드 카운트가 약 1.4k 줄었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-09.png" }}" />

이후보다 많은 메소드나 클래스를 삭제하기 위해 약 30 클래스 / 인터페이스, 약 400 메소드가 deprecate 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-10.png" }}" />

예로는 위와 같다

## Getting the Android Support Library

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-12.png" }}" />

Support Library 를 `Google Maven Repository` 로 배포하게 되었다. Support Library, Constraint Layout Library, Architecture Components Library 도 들어있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-13.png" }}" />

26.1 Beta 1을 포함하여 과거 모든 버전도 포함하고 있다. 

```
// bundle.gradle
repositories {
    maven {  
        url "https://maven.google.com"
    }
}  
  
dependencies {
    compile 'com.android.support:appcopmat-v7:26.0.0-beta1'
    ...
}  
```

build.gradle에 간단하게 의존성을 설정할 수 있다.

## Developing the Android Support Library

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-16.png" }}" />

New issue tracker 는 버그 제출 시 더 안정적이고 더 빠른 응답을 제공할 것이다.

> [https://issuetracker.google.com](https://issuetracker.google.com) > Developer Tools > Support Libraries

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-17.png" }}" />

Android Studio 에서 AOSP에 올려져 있는 Support Library 버그를 스스로 수정할 수 있도록 지원한다. Android Studio 에서 열어볼 수 있으며 빨간 오류 줄도 없다. Support Library 개발 경험을 대폭 간소화했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-18.png" }}" />

> 소스 기여에 가이드라인 : [https://android.googlesource.com/platform/frameworks/support/](https://android.googlesource.com/platform/frameworks/support/)

## XML Font (14+)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-20.png" }}" />

XML에서 font를 사용할 수 있게 되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-21.png" }}" />

앱에서 커스텀 글꼴을 사용하려 했다면 고통스러운 과정을 겪어야 했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-22.png" }}" />

지금부터 글꼴은 새로운 리소스 타입입니다. `res/font` 폴더에 폰트 파일을 넣을 수 있다. `font-familiy`의 지원도 추가되었다. 

```
// myfont.xml
<?xml version="1.0" encoding="utf-8"?>
<font-family xmlns:android="http://schemas.android.com/apk/res/android">
    <font
        app:fontStyle="normal" app:fontWeight="400"
        app:font="@font/myfont-regular" />
    <font
        app:fontStyle="normal" app:fontWeight="800"
        app:font="@font/myfont-bold" />
</font-family>
```

`font`와 `font-familiy` 를 위한 새로운 XML 속성을 정의했다. 

```
<TextView ...
    android:fontFamily="@font/myfont"
    android:textStyle="bold"/>
```
```
<style name="myfontstyle">
    <item name="android:fontFamily">@font/myfont</item>
</style>
```
```
Typeface typeface = ResourcesCompat.getFont(context, R.font.myfont);
textView.setTypeface(typeface);
```

font 리소스를 위해 텍스트 스타일에 대한 지원도 추가되었다. 원하는 폰트를 XML, 스타일, 코드에서 사용할 수 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-25.png" }}" />

`API 14`부터 지원한다.

## Downloadable Fonts (14+)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-26.png" }}" />

많은 사람이 APK에 글꼴을 포함했다. 폰트는 큰 파일이며, 모바일용으로 최적화되지 않은 폰트를 포함해있다. 다른 앱에서 동일한 폰트를 번들로 제공한다는 사실을 알 수 없다. 매번 사용자는 이 글꼴을 계속해서 다운로드한다. 그래서 폰트를 다운로드 가능한 `Font Provider` 를 만들었다. `Font Provider`는 앱이 아니고 별도의 엔티티이며 폰트를 가져와서 캐시하고 폰트를 원하는 모든 앱에 제공하는 임무를 가진다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-27.png" }}" />

`FontsContractCompat` API 를 통해 Font Provider에 접근할 수 있다. Font Provider에 대해 단일 엔트리 포인트를 가진다. Font의 사본이 메모리에 하나만 있으므로 `메모리 절약`할 수 있다. Google Play Service를 통해 800개 이상의 Google Font를 사용할 수 있다.

```
FontRequest request = new FontRequest(
    "com.example.fontprovider.authority",
    "com.example.fontprovider",
    "Name of font",
    R.array.certs);

FontsContractCompat.FontRequestCallback callback =
    new FontsContractCompat.FontRequestCallback() {
        @Override
        public void onTypefaceRetrieved(Typeface typeface) {}
        @Override
        public void onTypefaceRequestFailed(int reason) {}
    }
```

> [Developer Reference ~ FontRequest](https://developer.android.com/reference/android/support/v4/provider/FontsContractCompat.html)

> [Developer Reference ~ FontsContractCompat](https://developer.android.com/reference/android/support/v4/provider/FontsContractCompat.html)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-29.png" }}" />

`FontsContractCompat.requestFont`를 호출해서 글꼴을 요청한다. UI 스레드에서 호출하면 안 된다.

```
// downloadedfont.xml

<?xml version="1.0" encoding="utf-8"?>  
<font-family xmlns:app="http://schemas.android.com/apk/res-auto">
    app:fontProviderAuthority="com.example.fontprovider.authority"
    app:fontProviderPackage="com.example.fontprovider"
    app:fontProviderQuery="dancing-script"
    app:fontProviderCerts="@array/certs">  
</font-family>  
```

XML에서 다운로드한 폰트를 지정할 수 있다. font-family 태그에 권한, 패키지, 쿼리 및 인증서에 대한 네 가지 속성을 추가했다. XML에 지정하면 폰트를 가져와서 표시한다. 처리에 오래 걸리는 경우 기본 시스템 폰트로 렌더링 될 수 있다는 점을 염두에 둬야 한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-31.png" }}" />

Android Studio 에서 font-family 섹션하단의 `More Fonts option`을 선택하면 Font Picker를 사용할 수 있다. Font Picker에서 이미 다운로드한 폰트 / 안드로이드 시스템에 있는 폰트 / 다운로드 가능한 폰트를 확인 가능하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-32.png" }}" />

Android Studio는 Font Picker로 선택한 폰트를 미리 렌더링하여 어떤 모습인지 보여준다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-33.png" }}" />

생성한 XML을 열 면 Google Play Services에 필요한 모든 속성과 인증서가 생성되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-34.png" }}" />

> 자세한 내용은 What's New in Android Development Tools 세션에서 확인 가능하다. 

> 유투브 링크 : [What's New in Android Development Tools](https://www.youtube.com/watch?v=Hx_rwS1NTiI)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-35.png" }}" />

```
Sample app
- https://github.com/googlesamples/android-DownloadableFonts

Public Docs
- https://developer.android.com/preview/features/downloadable-fonts.html

Google Fonts docs
- https://developers.google.com/fonts/docs/android

Google Play Services v11 beta
- https://developers.google.com/android/guides/beta-program
```

다운로드 가능한 폰트에 대한 자세한 내용은 GitHub에 게시된 샘플 앱이 공개되었다. 그리고 Google Play Service v11에서 통합되어 Google 폰트 사용하는데 주의해야 한다. 아직 공개되지 않았지만, 링크를 통해 베타 버전에 가입하면 v11을 얻을 수 있으므로 실제로 출시될 때까지 개발자로 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-36.png" }}" />

`API 14`부터 지원한다.

## Emoji Compatibility Library (19+)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-37.png" }}" />

가운데 십자가가 있는 이 상자를 `tofu`라고 부르며, 요청한 glyph 를 렌더링할 수 없을 때 표시한다. `Emoji Compatibility Library`는 최신 이모티콘 글꼴에 접근할 수 있는 Support Library이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-38.png" }}" />

시스템 글꼴로 렌더링할 수 있는지 확인한다. 불가능한 경우 이모티콘으로 대체할 수 있다. `Emoji Compatibility Library`를 사용하는 방법은 두 가지 있다. 폰트를 앱에 포함하거나 다운로드 가능한 폰트를 사용하여 Google Play 서비스 및 Google 글꼴에서 최신 이모티콘 폰트를 사용하는 방법이다.

### Downloaded configuration

```
dependencies {
    ...
    compile "com.android.support:support-emoji:$version"
}  
```
```
FontRequest fontRequest = new FontRequest(
    "com.example.fontprovider",
    "com.example",
    "emoji compat Font Query", CERTIFICATES);
  
EmojiCompat.Config config = new FontRequstEmojiCompatConfig(this, fontRequest);  
EmojiCompat.init(config);  
```

`Google Play Services`를 통한 사용 방법이다.

### Bundle configuration - 7MB

```
dependencies {
    ...
    compile "com.android.support:support-emoji-bundle:$version"
}  
```
```
EmojiCompat.Config config = new FontRequstEmojiCompatConfig(this);  
EmojiCompat.init(config);  
```

`Google Play Service`가 없는 경우의 사용 방법이다. 글꼴은 약 7메가 바이트이므로 주의할 필요가 있다. 앱 출시 후에는 업데이트 되지 않으므로 새로운 폰트를 얻을 수 있도록 앱에 새로운 업데이트를 제공해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-41.png" }}" />

이모티콘을 사용하기 위한 위젯을 제공 (EmojiTextView, EmojiEditText, and EmojiButton)한다. 이 위젯은 `EmojiCompat`을 자동으로 사용하고, 모든 이모티콘을 렌더링한다. 

이것을 사용하고 싶지 않은 경우, `EmojiCompat`를 커스텀 클래스에 통합하는 방법에 대한 세부적인 단계가 작성된 문서를 읽으면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-42.png" }}" />

```
Sample app
- https://github.com/googlesamples/android-EmojiCompat

Public Docs
- https://developer.android.com/preview/features/emoji-compat.html

Google Play Services v11 beta
- https://developers.google.com/android/guides/beta-program
```

이 기능은 `API 19 이상`에서 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-43.png" }}" />

## TextView autosizing

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-44.png" }}" />

자동 크기 조정은 텍스트 뷰의 경계에 따라 텍스트의 크기를 선택한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-45.png" }}" />

TextView에 `autoSizeTextType` 속성을 사용하고 `Uniform`으로 설정한다. 이렇게 하면 x 축과 y 축 모두에서 텍스트의 크기를 일정하게 조정할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-46.png" }}" />

더욱 자세한 지정하고 싶은 경우 미리 정의된 크기의 배열을 제공할 수 있다. 이 경우 주어진 경계에 대해 제공하는 크기 중 가장 일치하는 것을 선택한다. 최소, 최대 크기 및 단계 및 세분성(granularity)을 제공한다

`API 14 이상`에서 사용할 수 있다.

## DynamicAnimation (16+)

> Physics-based animations

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-48.png" }}" />

시간(duration) 대신에 속도(velocity) 를 기반으로 한다. DynamicAnimation은 직접적인 사용자 상호 작용에 응답하여 자연스러운 애니메이션을 제작하는 데 도움이 된다. 기본으로 SpringAnimation, FlingAnimation을 제공한다. 

<img src="https://developer.android.com/preview/images/animation/physics-based-animation/low_stiffness.gif" />

```
// SpringAnimation
final SpringAnimation anim = new SpringAnimation(
    bugdroidImageView, // object to animate  
    TRANSLATION_Y,     // property to animate  
    0);                // equilibrim state  
```

Bugdroid 뷰에서 새로운 SpringAnimation을 만들고 상호작용 추적을 위해서 TRANSLATION_Y 를 애니메이션으로 만든다. 상호작용이 종료되면 0의 상태로 돌아가길 원한다. 그리고 튀어 오르면 `overshoot`이 된다. 그리고 결국 y는 0이 될 것이다.

```
anim.getSpring()
    .setDampingRatio(0.7f /* lower is more bouncy */)
    .setStiffness(1500f /* higher oscillates faster */) 
```

스프링 애니메이션은 스프링의 물리적 특성을 사용한다. `감쇠 비율(damping ratio)`은 Spring이 얼마나 빨리 중지될지 나타낸다. 감쇠 비율이 0이면 무한대로 진동한다. `강성(Stiffness)`은 스프링이 얼마나 빨리 튈지 정한다. 매우 낮은 강성은 느슨한 서스펜션이 있는 자동차와 같을 것이다.

```
anim.setStartVelocity(velocityTracker.getYVelocity())
    .start(); 
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-53.png" }}" />

> 자세한 내용은 Android Animations Spring to Life 세션에서 확인 가능하다. 

> 유투브 링크 : [Android Animations Spring to Life](https://www.youtube.com/watch?v=BNcODK-Ju0g)

## VectorDrawableCompat ~ Fill type (14+)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-56.png" }}" />

최신 플랫폼을 사용하는 것처럼 Asset Studio에서 제대로 렌더링 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-57.png" }}" />

하지만 24보다 낮은 API를 실행하는 기기에 올리면 가장자리에 이상한 아티팩트(artifacting)가 있음을 알 수 있다. 그 이유는 SVG의 형식이 도구에 의해 내보내지기 때문이다. 이 경우 Photoshop에서는 채우기 규칙이 적용된다.

```
// ic_dots.svg
<svg xmlns="http://www.w3.org/2000/svg"
     width="480"
     height="480"
     viewBox="0 0 480 480">
    <path fill="#414141"
          fill-rule="evenodd"
          d="M349.471,167.222a113.228,113.228,0,0,1-12.753..." />
</svg>
```

그 이유는 SVG의 형식이 도구에 의해 내보내지기 때문이다. 이 경우 Photoshop에서는 `채우기 규칙(fill rule)`이 적용된다. 채우기 규칙은 벡터 경로의 내부가 무엇인지 정의한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-59.png" }}" />

API 24의 프레임워크에 추가되었고 API 14로 백포트했다.

## AnimatedVector DrawableCompat ~ Path morphing & interpolation (14+)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-61.png" }}" />

주의할 사항은 경로 형식이 일치해야 한다는 점이다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-62.png" }}" />

기기에서 경로 모핑이 어떻게 생겼는지 보여준다. 

```
// res/drawable/buffalo.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:height="600dp"
    android:width="320dp"
    android:viewportHeight="600"
    android:viewportWidth="320">
    <group>
        <path android:name="buffalo_path"
              android:pathData="@string/buffalo" />  
    </group>  
</vector>  
```

버팔로의 경로 데이터를 추출했다.

```
// res/anim/buffalo_to_hippo.xml
<objectAnimator xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="1000"
    android:propertyName="pathData"
    android:valueFrom="@string/buffalo"
    android:valueTo="@string/hippo"
    android:valueType="pathType" />  
```

APi 14이상의 새로운 기능은 Path 데이터를 속성 유형으로 지정할 수 있는 기능이다. 버팔로 Path에서 값을 애니메이션한 것이다. 실제로 포인트로 변형시키고 모핑 애니메이션을 제공한 것이다.

```
// res/drawable/animal_morph.xml
<animated-vector 
    xmlns:aapt="http://schemas.android.com/aapt"
    xmlns:android="http://schemas.android.com/apk/res/android"  
    android:drawable="@drawable/buffalo">  
    <target android:name="buffalo_path"
            android:animation="@anim/buffalo_to_hippo" />  
</animated-vector>  
```

이것을 모두 모아서 움직일 수 있는 벡터로 만든다. 이 벡터는 Drawable 시작을 버팔로로 지정한 것이다. 그리고 버팔로에서 하마로 Path 데이터를 변형시킬 것이다. 

```
// res/drawable/animal_morph.xml
<animated-vector
    xmlns:aapt="http://schemas.android.com/aapt"
    xmlns:android="http://schemas.android.com/apk/res/android">
    <aapt:attr name="android:drawable">
        <vector android:height="600dp"
                android:width="320dp"
                android:viewportHeight="600"
                android:viewportWidth="320">
            <group>
                <path android:name="buffalo_path"
                      android:pathData="@string/buffalo" />  
            </group>  
        </vector>  
    </aapt:attr>  
    <target android:name="buffalo_path"
            android:animation="@anim/buffalo_to_hippo" />  
</animated-vector>  
```

AAPT의 기능을 이용하여 번들된 XML로 사용할 수 있다.

```
// res/drawable/animal_morph_bundle.xml
<animated-vector xmlns:aapt="http://schemas.android.com/aapt"
    xmlns:android="http://schemas.android.com/apk/res/android">
    <aapt:attr name="android:drawable">
        <vector android:height="600dp"
                android:width="320dp"
                android:viewportHeight="600"
                android:viewportWidth="320">  
            <group>  
                <path android:name="buffalo_path"
                      android:pathData="@string/buffalo" />  
            </group>  
        </vector>  
    </aapt:attr>    
    <target android:name="buffalo_path">  
        <aapt:attr name="android:animation">  
            <objectAnimator android:duration="1000"
                            android:propertyName="pathData"
                            android:valueFrom="@string/buffalo"
                            android:valueTo="@string/hippo"  
                            android:valueType="pathType" />      
        </aapt:attr>  
    </target>  
</animated-vector>
```

하나의 파일에 담아낸 Drawable 이다. 다른 리소스 폴더에 별도의 애니메이션 XML을 유지할 필요없다. 매우 깨끗하고 AAPT를 통해 API 14까지 지원된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-68.png" }}" />

Path를 따라 보간에 대한 Suuport를 백포트했다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-69.png" }}" />

결합된 Path 모핑 및 Path 보간의 예이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-70.png" }}" />

API 26을 통해 API 14에서 사용하는 Path 보간은 다음과 같다.

```
// res/interpolator/path_fastThenSlow.xml
<pathInterpolator  
    xmlns:android="http://schemas.android.com/apk/res/android"  
    android:pathData="M 0.0, 0.0 c 0.08,0.0 0.04,1.0 0.2,0.8 l 0.6,0.1 L 1.0,1.0" />  
```

매우 빨리 축소된 다음 조금 더 커지고 0으로 줄어드는 Path 보간이다. 

```
// res/anim/rect_morph_fastThenSlow.xml
<objectAnimator
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:duration="1000"
    android:interpolator="@interpolator/path_fastThenSlow"
    android:propertyName="pathData"
    android:valueFrom="M0,0L24,0L24,24L0,24z"
    android:valueTo="M0,0L0,0L0,0L0,0z"
    android:valueType="pathType"
    android:repeatCount="2" />
```

동일한 XML로 API 14 및 26에서 호환된다.

```
// res/drawable/rect_path_anim_bundled.xml
<animated-vector 
    xmlns:aapt="http://schemas.android.com/aapt"
    xmlns:android="http://schemas.android.com/apk/res/android">  
    <aapt:attr name="android:drawable">
        <vector android:height="48dp"
                android:width="48dp"
                android:viewportHeight="48"
                android:viewportWidth="48">
            <group>
                <path android:name="rect"
                      android:pathData="M0,0L48,0L48,48L0,48z" />
            </group>
        </vector>
    </aapt:attr>
    <target android:name="rect">
        <aapt:attr name="android:animation">
            <objectAnimator android:duration="1000"
                            android:propertyName="pathData"
                            android:valueFrom="M0,0L48,0L48,48L0,48z"
                            android:valueTo="M0,0L0,0L0,0L0,0z"
                            android:valueType="pathType"> 
                <aapt:attr name="android:interpolator">
                    <pathInterpolator android:pathData="M 0.0,0.0 c 0.08,0.0 0.04,1.0 0.2,0.8 1 0.6,0.1 L 1.0,1.0" />
                </aapt:attr>
            </objectAnimator>
        </aapt>
    </target>     
</animated-vector>  
```

또다시 XML 번들로 할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-73.png" }}" />

Support Library 26은 watche 와 TV와 같은 폼 팩터에 대한 변경 사항을 소개한다.

## Wear

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-74.png" }}" />

Android Wearable Support Library를 기본 Android Support Library에 통합한다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-75.png" }}" />

WearableRecyclerView로 개선 된 원형 스크롤링

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-76.png" }}" />

둥근 화면에서 반응형 레이아웃을 더 잘 지원하는 BoxInsetLayout

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-77.png" }}" />

SwipeDismissFrameLayout 과 같은 클래스의 일관된 사용자 상호 작용 모델

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-78.png" }}" />

> 자세한 내용은 Android Wear UI Development Best Practice 세션에서 확인 가능하다. 

> 유투브 링크 : [Android Wear UI Development Best Practice](https://www.youtube.com/watch?v=q-a1aPHO10g)

## Leanback

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-79.png" }}" />

TV 인터페이스 개발을 위해 Leanback Library 를 추가했다. Leanback Library에는 PlaybackTransportControlGlue가 추가되어 비디오 검색 인터페이스를 제공한다. 미리 보기 기능이 있다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-80.png" }}" />

DetailFragment에 비디오뷰를 임베디드할 수 있다. 사람들이 미디어를 탐색하는 무언가를 쓰고 있고 사람들에게 그 미디어의 설명이나 평가를 보여 주면서 인라인으로 미디어를 재생할 수 있게 하려면 DetailsFragmentB BackgroundController를 사용하는 것이 매우 간단하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-81.png" }}" />

> 자세한 내용은 What's New for Android TV 세션에서 확인 가능하다. 

> 유투브 링크 : [What's New for Android TV](https://www.youtube.com/watch?v=LMB9B6Z__bM)

## PreferenceDataStore

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-83.png" }}" />

기본 Preference Fragment 및 PreferenceManager를 사용하는 경우 다소 힘든 작업을 수행해야 할 수 있다. 따라서 PUT, GET 호출에 대한 기본 설정이 처리된 PreferenceDataStore 를 확장해서 사용할 수 있다. 

```
// CloudDataStore.java
class CloudDataStore extends PreferenceDataStore {  
    @Override  
    public void putBoolean(String key, boolean value) {  
        // Cache value immediately, launch async task to persist  
        // data to cloud service.  
    }  
  
    @Override  
    public void getBoolean(String key, boolean defValue) {  
        // Return cached value.  
        return false;  
    }  
}  
```

이 클래스에서 유의해야 할 점은 Main Thread에서 호출이 발생한다는 것이다. 따라서 긴 트랜잭션을 수행하고 있다면 클라우드에서 뭔가를 하고 디스크에 머물러 있으면 비동기적으로 수행하고 부울을 가져오는 빠른 호출을 처리할 수 있는 방법이 필요하다.

```
// MyPreferenceFragment.java

// Set up this PreferenceFragment to store  
// and retrieve data using CloudDataStore.  
PreferenceManager prefManager = getPreferenceManager();  
CloudDataStore cloudStore = new CloudDataStore();  
prefManager.setPreferenceDataStore(cloudStore);  
```

PreferenceFragment에서 설정하려면 PreferenceManager가 필요하다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-86.png" }}" />

executePendingTransaction, commitNow 와 같은 트랜잭션 호출은 이미 상태가 변경된 상태에서 위험할 수 있다. 이것들은 이제 엄격하게 집행되고 재진입 트랜잭션 호출을 하려고 한다면 예외를 던질 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-87.png" }}" />

UI 성능에 대해 배우고자 하는 개발자를 위해 FrameMetricsAggregator를 추가했다. 따라서 액티비티에 연결하고 드로잉 프레임의 수명주기 동안 마일스톤 렌더링에 대한 정보를 얻을 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-88.png" }}" />

> 자세한 내용은 Android Performance: UI 세션에서 확인 가능하다. 

> 유투브 링크 : [Android Performance: UI](https://www.youtube.com/watch?v=9HtTL_RO2wI)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-89.png" }}" />

실제로는 25.3 API에서 나왔다. ActionBarDrawerToggle은 네비게이션 드로어를 여는데 사용하는 버튼인 Hamburger 버튼을 구현하는데 사용되는 클래스이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-90.png" }}" />

```
// Install drawer toggle
drawerToggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.drawer_open, R.string.drawer_close);

// Disablee animation
drawerToggle.setDrawerSlideAnimationEnabled(false);
```

Hamburger 버튼의 서랍 슬라이드 애니메이션을 비활성화하기 위해서 한 줄만 사용하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-92.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-support-library/io17-new-support-library-93.png" }}" />