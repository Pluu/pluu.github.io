---
layout: post
title: "[요약] Google I/O 2017 ~ What's New in Android"
date: 2017-05-22 23:15:00 +09:00
tag: [Android, Google I/O]
categories:
- blog
- Android
- Google
- io17
---


# What's New in Android (Google I/O '17)

## Picture in Picture

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-01.PNG" }}" />

Android O에서는 Android TV에서만 지원된 기능이 모바일에서 가능

```
<activity android:name=".PipActivity"
    android:resizeableActivity="true"   // <- resizeableActivity 제거
    android:supportsPictureInPicture="true"
    android:configChanges="..."
```

더 이상 `resizeableActivity` 를 사용하지 않아도 된다.

```
public void onActionClicked(Action action) {
    if (action.getId() == R.id.start_pip) {
        getActivity().enterPictureInPictureMode();
    }
}
```

PIP 모드 전환은 `Activity.enterPictureInPictureMode()` 를 호출하면 된다.

## Color managemenet

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-02.PNG" }}" />

- 광색역(Wide-Gamut) Display 지원
  - 더 넓은 색상, 채도가 높은 색상을 표현 가능
- 16비트 PNG 지원
  - JPEG/PNG/WebP
- 새로운 유틸리티
  - android.graphics.Color, ColorSpace, ColorLong, Half

> 더 자세한 내용은 `Understanding Color (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Understanding Color (Google I/O '17)](https://www.youtube.com/watch?v=r8NeG0wmFXM)

## Multi-display

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-03.PNG" }}" />

Application이 멀티 윈도우를 지원한다는 것은 멀티 디스플레이를 지원한다는 의미이다.

- 사용자가 제어 가능
- ActivityOptions을 통해서 앱에서 제어 가능

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-04.PNG" }}" />

테스트를 위해서 다음 명령어를 실행할 수 있다

```
$ adb shell dumpsys display  // 현재 사용 가능한 모든 디스플레이를 나열
$ adb shell start <activity> --display <id>  // Shell 을 통해 Activity 시작하는 경우 지정 가능
```

## Media

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-05.PNG" }}" />

getMetrics() 를 통해 미디어 정보를 얻을 수 있다
- 해상도, 코텍, 비트 레이트, 길이 등의 데이터
- MediaPlay, MediaRecorder, MediaCodec, MediaExtractor 에서 가능

```
MediaRecorder recorder = new MediaRecorder();
// ...
PersistableBundle metrics = recorder.getMetrics();
```

## Playback

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-06.PNG" }}" />

버퍼링 제어 가능
- 워터마크 지정 가능
- 크기 또는 시간, 둘 다 지정 가능

DRM playback 지원

## Recording

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-07.PNG" }}" />

- MPEG-2 TS 스트림 포맷 지원
- 오디오/비디오 트랙 추가 가능
- 커스텀 트랙 지원
  - metadata tracks `"application/"` 로 시작하는 MIME type

## WebView

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-08.PNG" }}" />

### Google Safe Browsing API

```
<manifest>
    <meta-data
        android:name="android.webkit.WebView.EnableSafeBrowsing"
        android:value="true" />
    <!-- ... -->
</manifest>
```

Android manifest에 위 메타 데이터 태그를 추가하는 것으로 크롬 브라우저에서 사용하는 악성 코드와 안전하지 않은 페이지 체크할 수 있다. Multi 프로세스를 위한 API도 추가된다.

## AnimatorSet

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-09.PNG" }}" />

AnimatorSet은 까다로워 구현하는데, 시간이 걸렸기에 새로운 기능을 추가했다. `setCurrentPlayTime()` 을 사용해 애니메이션 재생 시간을 지정할 수 있다. `reverse()` 로 반대로 애니메이션 재생할 수 있다.

## Autofill

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-10.PNG" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-11.PNG" }}" />

입력 폼에 정보를 제공할 수 있는 프로바이더가 존재하는 경우, 해당 텍스트 필드를 얻었을 때 자동으로 해당 정보를 입력할 수 있다

> 더 자세한 내용은 `Best Practices to Improve Sign-In, Payments, and Forms in Your Apps (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Best Practices to Improve Sign-In, Payments, and Forms in Your Apps (Google I/O '17)](https://www.youtube.com/watch?v=oZxwTiMH0FM)

## Fonts in XML

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-12.PNG" }}" />

Font 정보를 선언하는 XML을 사용할 수 있다.

`res/font` 폴더에 Font 파일을 적재 가능하며, `res/font` 폴더에 `Font families` 를 정의하여 위 그림과 같이 레이아웃/코드에서 사용 가능

## Downloadable Fonts

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-13.PNG" }}" />

코드나 XML 에서 폰트 로드 가능하며, `Google Play Service 11` 버전부터 `Font Provider`으로 사용하여 모든 구글 Font를 이용할 수 있다.

## Auto-Sizing TextView

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-14.PNG" }}" />

자동으로 폰트 사이즈가 변경되는 TextView를 사용할 수 있다. 변경은 코드/XML에서 지정할 수 있다. 

XML 폰트 다운로드, Auto-Sizing TextView 등의 기능은 `O Platform API` 이지만, `Support Library` 도 있다.

## AccessibilityService Utilites

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-15.PNG" }}" />

- 언어 감지
- 다른 버튼과 네비게이션 바의 버튼 등의 접근
- 볼륨 제어
- 커스텀 지문 제스처

## Castaway

```
// View.java : public View findViewById(int id)
TextView tv = (TextView) findViewById(R.id.mytextview);
```

findViewById 를 사용하여 View 를 선언하는데 있어서 뷰를 얻고 원하는 타입으로 캐스팅해야만 했다. 번거로운 캐스팅 문제로 별도 라이브러리를 사용했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-16.PNG" }}" />

```
// View.java : public <T extends View> findViewById(int id)
TextView tv = findViewById(R.id.mytextview);
```

Castaway를 이용하여 위 문제를 해결했다.

## introducing adaptive icons

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-17.PNG" }}" />

background / foreground 이미지를 이용하여 런처에서 지정된 Mask를 이용해 아이콘을 만들 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-18.PNG" }}" />

adaptive icons에 대한 spec 사이즈는 위와 같다.

> 더 자세한 내용은 `What's New in Notifications, Launcher Icons, and Shortcuts (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [What's New in Notifications, Launcher Icons, and Shortcuts (Google I/O '17)](https://www.youtube.com/watch?v=TB-K6OniF68)

## shortcuts & widgets pre-O

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-19.PNG" }}" />

기존에는 사용자의 화면에 바로 가기와 위젯을 얻기 위해서는 바로 가기를 위한 broadcast가 있었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-20.PNG" }}" />

O에서는 위 항목 중 하나를 요청하여 원하는 작업을 할 수 있다.

## notifications

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-21.PNG" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-22.PNG" }}" />

`Jelly Bean` 에서 알림을 차단하는 기능이 추가되었다. 그리고, `Nougat`에서 알림을 조절하도록 수정되었다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-23.PNG" }}" />

사용자와 개발자는 알림 일부를 제어하고 싶어 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-24.PNG" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-25.PNG" }}" />

그래서, Android O 에서는 `Notification Channel` 이 추가되었다. 하나의 앱에 같은 동작을 공유하는 Notification 원하는 Notification Channel에 설정해서 보내면 된다. 사용자가 명시적으로 진동, 소리, 빛, 팝업 여부 등을 세밀하게 제어할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-26.PNG" }}" />

O (API 26)을 Target으로 한 경우 `Notification Channel`을 사용하지 않으면 Notification은 삭제된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-27.PNG" }}" />

> 더 자세한 내용은 `What's New in Notifications, Launcher Icons, and Shortcuts (Google I/O '17)`, `Notifications UX: What's New for Android O (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [What's New in Notifications, Launcher Icons, and Shortcuts (Google I/O '17)](https://www.youtube.com/watch?v=TB-K6OniF68)

> Youtube Link : [Notifications UX: What's New for Android O (Google I/O '17)](https://www.youtube.com/watch?v=vwZi56I0Mi0)

## miscellanea

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-28.PNG" }}" />

시스템 UI에 더 많은 기능이 추가됩니다.

## Strict Mode

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-29.PNG" }}" />

엄격 모드의 API가 확장되어 ThreadPolicy에서 위 작업을 수행할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-30.PNG" }}" />

## Media File Access

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-31.PNG" }}" />

사이즈가 큰 파일을 Document Provider 전달하기 전에 전체 데이터를 다운로드할 필요가 있었다. 그래서 검색 가능한 파일 디스크립터를 생성할 수 있다. 파일 사이즈가 큰 오디오, 비디오에 매우 유용하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-32.PNG" }}" />

## Cached Data

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-33.PNG" }}" />

시스템이 주는 새로운 API 이다. 각각 앱은 캐시 파티션의 일정 크기를 사용할 수 있다. 이를 위해 StorageManager을 사용할 수 있다.

- `getCacheQuotaBytes()` : 할당된 디스크 공간의 바이트 수 조회
- `allocateBytes()` : 데이터를 할당
- `setCacheBehaviorAtomic()` : 디렉토리와 그 안의 모든 컨텐츠가 하나의 최소 단위로 삭제되어야 함을 나타낸다
- 새로운 데이터를 저장할 기기의 디스크 공간이 충분한지 여부를 결정할 때, getUsableSpace()를 사용하는 대신 `getAllocatableBytes(UUID, int)`를 호출할 수 있다. 이 메서드는 시스템이 자동으로 지우는 모든 캐시된 데이터를 고려하기 때문이다.

## Privacy

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-35.PNG" }}" />

`ANDROID_ID` 는 이제 app 마다 사용자마다 다를 수 있다. 그래서 동일한 디바이스의 경우 앱과 사용자를 추적하는 데 사용할 수 없다.

net.hostname 을 얻으면 비어있을 것이다. 필요한 경우 광고 ID를 사용할 필요가 있다.  

## Google Play Protect

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-36.PNG" }}" />

Google Play의 Protect를 이용해 사전 검사와 지속적인 스캔하여 보호한다. Google Play Store이외의 다른 Store나 ADB를 이용해서 설치한 경우도 해당한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-37.PNG" }}" />

> 더 자세한 내용은 `What's New in Android Security (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [What's New in Android Security (Google I/O '17)](https://www.youtube.com/watch?v=C9_ytg6MUP0)

## Kotlin

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-38.PNG" }}" />

공식적으로 Kotlin을 지원할 것이라고 발표했다.

Android Studio 3.0에서 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-39.PNG" }}" />

더 자세한 것은 위 세션에서 소개할 예정이다.

> Youtube Link : [Introduction to Kotlin (Google I/O '17)](https://www.youtube.com/watch?v=X1RVYt2QKQE)

> Youtube Link : [Life is Great and Everything Will Be Ok, Kotlin is Here (Google I/O '17)](https://www.youtube.com/watch?v=fPzxfeDJDzY)

## Java Programming Language Updates

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-40.PNG" }}" />

Android O에서 java.time, java.nio.file, java.lang.invoke 가 추가되었다.

### Files

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-41.PNG" }}" />

## Runtime

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-42.PNG" }}" />

새로운 concurrent-copying collector로 기본적으로 모든 것을 더 빠르고 훌륭하게 만든다.

전체 GC가 일어나는 경우를 제외하고 다른 작업을 하는 동안 백그라운드에서 원하는 작업을 할 수 있다. 그리고, background에서만 가능했던 힙 압축 등의 작업을 foreground 에서도 할 수 있다. 이전에는 Idle 상태에서만 가능했다.

> 더 자세한 내용은 `Performance and Memory Improvements in Android Run Time (ART) (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Performance and Memory Improvements in Android Run Time (ART) (Google I/O '17)](https://www.youtube.com/watch?v=iFE2Utbv1Oo)

## Support Library v26

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-43.PNG" }}" />

Support Library v26 베타 버전이 Developer Preview 2에서 공개된다. 그리고, EmojiCompat을 이용해 볼 수 없었던 이모지를 제공한다. 

> 더 자세한 내용은 `What's New in Android Support Library (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [What's New in Android Support Library (Google I/O '17)](https://www.youtube.com/watch?v=V6-roIeNUY0)

## Physics Animation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-44.PNG" }}" />

새로운 Physics Animation을 사용해 속도 기반의 애니메이션을 사용할 수 있다. 더 많은 상호 작용으로 더 자연스럽고 인터럽트 가능한 애니메이션을 만들 수 있다.

> 더 자세한 내용은 `Android Animations Spring to Life (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Android Animations Spring to Life (Google I/O '17)](https://www.youtube.com/watch?v=BNcODK-Ju0g)

## Architecture Components

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-45.PNG" }}" />

앱의 작동이 화면 회전하거나 백그라운드로 간 후 일련의 동작으로 죽을 수 있다. 그래서, Architecture Component는 이러한 Lifecycle 관련하여 더 쉬운 안드로이드 개발을 할 수 있도록 도와준다.

> 더 자세한 내용은 `Architecture Components - Introduction (Google I/O '17)`, `Architecture Components - Solving the Lifecycle Problem (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Architecture Components - Introduction (Google I/O '17)](https://www.youtube.com/watch?v=FrteWKKVyzI)

> Youtube Link : [Architecture Components - Solving the Lifecycle Problem (Google I/O '17)](https://www.youtube.com/watch?v=bEKNi1JOrNs)

## Behavior Changes

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io17/new-android/io17-new-android-46.PNG" }}" />

Background 에 들어간 앱은 위치, wakelock, 백그라운드 실행 수 제한 등으로 배터리 부분을 개선했다. 경고창이 추가되었으며 Android O를 타깃으로 하는 경우 TYPE_APPLICATION_OVERLAY 창 유형을 사용하여 경고 창을 표시한다.

> 더 자세한 내용은 `Background Check and Other Insights into the Android Operating System Framework (Google I/O '17)` 세션에서 다룹니다.

> Youtube Link : [Background Check and Other Insights into the Android Operating System Framework (Google I/O '17)](https://www.youtube.com/watch?v=hbLAzwhBjFE)