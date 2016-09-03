---
layout: post
title: "[번역] DroidKaigi 2016 ~ Chrome과 Android의 과거 ・ 현재 ・ 미래"
date: 2016-09-03 16:25:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [ChromeとAndroidの過去・現在・未来](http://www.slideshare.net/shinobuokano7/chromeandroid-58461091) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

Chrome과 Android의 과거・현재・미래

## 2p

This is the last session of DroidKaigi

## 3p

Thank you for coming to my session

## 4p

마지막까지 즐기세요!

## 5p

**About Me**

Shinobu Okano

@perandoOS

Mercari, Inc

## 6p

Mercari는 간단하게 사고팔수 있어 안심 ・ 안전한 거래가 가능한 무료 앱입니다.

## 7p

**shinobu.apk**

shinobu.apk #1의 공개토론 녹음 파일과 Show Notets를 공개했습니다!

> [http://hack-it-iron.hatenablog.com/entry/2016/02/08/142322](http://hack-it-iron.hatenablog.com/entry/2016/02/08/142322)

## 8p

**여유로운 Android Framework Code Reading**

여유로운 Android Framework Code Reading #2을 개최했습니다

> [http://hack-it-iron.hatenablog.com/entry/2015/11/28/185529](http://hack-it-iron.hatenablog.com/entry/2015/11/28/185529)

## 9p ~ 11p

**WebView**

고통스럽다

## 12p

**WebView History**

| 1.x ~ 4.3.x | 4.4.x | 5.0 ~ |
| :-- | :-- | :-- |
| WebKit | Chromium | System WebView (APK) |

## 13p

**Google I/O 2012 Android WebView**

> [https://www.youtube.com/watch?v=HbOtn5VhGZU](https://www.youtube.com/watch?v=HbOtn5VhGZU)

## 14p

**Migrating to WebView in Android 4.4**

> [https://developer.android.com/guide/webapps/migrating.html](https://developer.android.com/guide/webapps/migrating.html)

## 15p

**Android System WebView**

> [https://play.google.com/store/apps/details?id=com.google.android.webview](https://play.google.com/store/apps/details?id=com.google.android.webview)

## 16p

**Android WebView의 진화와 구현**

> [http://outcesticide.hatenablog.com/entry/android_webview](http://outcesticide.hatenablog.com/entry/android_webview)

## 17p

Chrome Custom tabs

## 18p

Show the Chrome Tab like a my app browser

## 19p

Intent / Chrome Custom Tabs

## 20p ~ 21p

Chrome Custom Tabs

App Process --(Intent)--> Chrome Process

## 22p ~ 27p

**Setup Chrome Custom Tabs**

Custom Tabs Support Library

> [https://developer.android.com/tools/support-library/features.html#custom-tabs](https://developer.android.com/tools/support-library/features.html#custom-tabs)

Shared util module (Optional)

> [https://github.com/GoogleChrome/custom-tabs-client/tree/master/shared](https://github.com/GoogleChrome/custom-tabs-client/tree/master/shared)

Chrome Custom tabs Starter Kit

> [https://github.com/operando/chrome-custom-tabs-starterkit](https://github.com/operando/chrome-custom-tabs-starterkit)

```
dependencies {
  compile 'com.android.support:customtabs:23.1.1'
  compile project(':shared')
}
```

```
Uri URI = Uri.parse("https://android.com/");
CustomTabsIntent tabsIntent = new CustomTabsIntent.Builder().build();
String packageName = CustomTabsHelper.getPackageNameToUse(this);
tabsIntent.intent.setPackage(packageName);
tabsIntent.launchUrl(this, getUri());
```

## 28p

app to customize how Chrome looks and feels

## 29p ~ 30p

**UI customization**

- Toolbar color
- Toolbar close button
- Enter and exit animations
- Add actions to the toolbar
- Add overflow menu

```
CustomTabsIntent tabsIntent = new CustomTabsIntent.Builder()
    .setShowTitle(true)
    .setToolbarColor(0x77C159)
    .setStartAnimations(this, R.anim.slide_in_right, R.anim.slide_out_left)
    .setExitAnimations(this, R.anim.slide_in_left, R.anim.slide_out_right)
    .setCloseButtonIcon(back)
    .setActionButton(droid, "android", getActionButtonIntent())
    .addMenuItem("android menu", getActionButtonIntent()) .build();
String package = CustomTabsHelper.getPackageNameToUse(this);
tabsIntent.intent.setPackage(package);
tabsIntent.launchUrl(this, Uri.parse("https://android.com/"));
```

## 31p

UI Customize

## 32p

No Customize vs UI Customize

## 33p

making the transition from app to web content fast and seamless

## 34p ~ 36p

optimized to load faster than WebViews and traditional methods of launching Chrome

<img src="http://3.bp.blogspot.com/-bsqTJQg_KG8/VecqcRS1SnI/AAAAAAAACAM/nclxZZ1bOxA/s1600/CCT_Large+2.gif"/>

> [http://3.bp.blogspot.com/-bsqTJQg_KG8/VecqcRS1SnI/AAAAAAAACAM/nclxZZ1bOxA/s1600/CCT_Large+2.gif](http://3.bp.blogspot.com/-bsqTJQg_KG8/VecqcRS1SnI/AAAAAAAACAM/nclxZZ1bOxA/s1600/CCT_Large+2.gif)

## 37p

Wram up / Pre-fetch

## 38p

**Use Chrome features**

- Ssecurity
- Saved passwords
- Data Saver
- Shared cookie
- more features…

## 39p ~ 41p

**Chrome Custom Tabs can replace the WebView?**

NO!!!!!!!!!!

## 42p ~ 45p

**Why?**

세밀한 Handling이 안된다

<del>+비전의 WebChromeClient</del>

<del>+비전의 WebViewClient</del>

<del>+JavaScriptInterface</del>

CustomTabsCallback#onNavigationEvent 함수에서 페이지(Tab)을 읽기 시작・종료, 닫기・열었다는 정보라면 알려준다

## 46p

**Best Practices for Custom Tabs**

> [https://medium.com/google-developers/best-practices-for-custom-tabs-5700e55143ee](https://medium.com/google-developers/best-practices-for-custom-tabs-5700e55143ee)

## 47p ~ 51p

**Android Intents with Chrome**

Chrome이Intent Syntac URL을 해석해서 Intent를 실행한다

```
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="mercariapp" android:host="run:" />
</intent-filter>
```

```
<a href= “intent://run/#Intent; scheme=mercariapp;package=com.mercariapp.mercari; end”>Run Mercari</a>
```

> [https://developer.chrome.com/multidevice/android/intents](https://developer.chrome.com/multidevice/android/intents)

## 52p ~ 55p

**Debugging WebViews**

```
webView.setWebContentsDebuggingEnabled(true);
```

Android 4.4 이상

> [https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/webviews](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/webviews)

## 56p ~ 57p

**Web App Manifest**

Deﬁne the metadata associated with your web application in a JSON-based manifest.

## 58p

**Manifest and its members**

- name
- icons
- display
- theme_color
- background_color
- etc.

## 59p ~ 60p

**Manifest by Google IO 2015**

```
{
    "name": "Google I/O 2015",
    "short_name": "I/O 2015",
    "display": "standalone",
    "icons": [{
        "src": "images/touch/homescreen144.png",
        "sizes": "144x144",
        "type": "image/png"
        },…..],
    "gcm_sender_id": "608394197750",
    "gcm_user_visible_only": true
 }
```

> [https://events.google.com/io2015/manifest.json](https://events.google.com/io2015/manifest.json)

```
<link rel="manifest" href="manifest.json">
```

view-source: [https://events.google.com/io2015/](view-source:https://events.google.com/io2015/)

## 61p ~ 62p

**App Install Banner**

- manifest
- HTTPS
- Service Worker
- visited your site twice over two separate days during the course of two weeks

## 63p

**Service Worker**

- Web Push Notiﬁcation(GCM)
- Cache API
- Background Sync API
- etc.

## 64p

스마트폰 체험을 한걸음 앞으로 프로그레시브 웹 앱 작성법

Google Eiji Kitamura

> [https://docs.google.com/presentation/d/1VcXsKDaCUpf2SS35WNcrKslkK6PcXxWsnhcKiLfWCXs/edit#slide=id.gf39949af9_0_0](https://docs.google.com/presentation/d/1VcXsKDaCUpf2SS35WNcrKslkK6PcXxWsnhcKiLfWCXs/edit#slide=id.gf39949af9_0_0)

## 65p

??

## 66p

Web App Manifest = Web Technology

## 67p

but

## 68p ~ 69p

**Native app install banner**

similar to Web app install banners, but instead of adding to the home screen will let the user install your native app without leaving your site

## 70p

**Criteria to Show the Banner**

- You have a web app manifest ﬁle Site
is served over HTTPS
- The user has visited your site twice over two separate days during the course of two weeks

## 71p

**Testingﬂag**

chrome://ﬂags/#bypass-app-banner-engagement-checks

## 72p

**Native app install banner - manifest.json**

```
{
    "name": "Native app install banner Sample",
    "short_name": "Native app install banner Sample",
    "icons": [{
        "src": "image/ic_android_black_48dp.png",
        "sizes": "144x144",
        "type": "image/png"
    }],
    "prefer_related_applications": true,
    "related_applications": [{
        "platform": "play",
        "id": "com.kouzoh.mercari"
    }]
}
```

## 73p

**Web App Manifest**

> [Web App Manifest](Web App Manifest)
> - 草案（Working Draft）

## 74p

**Native app Install Banners**

> [https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/native-app-install](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/native-app-install)

## 75p ~ 77p

**App Stream**

- when Google ﬁnds in-app content that points to a mobile app you don’t already have installed, it will offer you the option to “stream” the app instead.
- To run the application in the `streaming` when application don’t have installed.

## 78p ~ 82p

**Streaming apps?**

Very Cool!!!!!!!!!!

<img src="http://3.bp.blogspot.com/-2Ats2zhc0HQ/Vkyq3JlcEiI/AAAAAAABBrA/hcfu4p02Fn4/s1600/app-stream-w-dots.gif" />

> [http://3.bp.blogspot.com/-2Ats2zhc0HQ/Vkyq3JlcEiI/AAAAAAABBrA/hcfu4p02Fn4/s1600/app-stream-w-dots.gif](http://3.bp.blogspot.com/-2Ats2zhc0HQ/Vkyq3JlcEiI/AAAAAAABBrA/hcfu4p02Fn4/s1600/app-stream-w-dots.gif)

"This uses a new cloud-based technology that we’re currently experimenting wit"

> [http://insidesearch.blogspot.jp/2015/11/new-ways-to-find-and-stream-app-content.html](http://insidesearch.blogspot.jp/2015/11/new-ways-to-find-and-stream-app-content.html)

## 83p

**New ways to ﬁnd (and stream) app content in Google Search**

> [http://insidesearch.blogspot.jp/2015/11/new-ways-to-find-and-stream-app-content.html](http://insidesearch.blogspot.jp/2015/11/new-ways-to-find-and-stream-app-content.html)

## 84p ~ 86p

**Trial Run Ads**

App ad format that lets a user play a game for up to 60 seconds by `streaming` content from the app before downloading

<img src="http://2.bp.blogspot.com/-9v_0t2rKlzM/Vl-wzBxLs8I/AAAAAAAACGo/hU-Nndu-AIg/s1600/Trial%2BRun%2BAd%2Bgif%2Bfor%2BSGN.gif" />

> [http://2.bp.blogspot.com/-9v_0t2rKlzM/Vl-wzBxLs8I/AAAAAAAACGo/hU-Nndu-AIg/s1600/Trial%2BRun%2BAd%2Bgif%2Bfor%2BSGN.gif](http://2.bp.blogspot.com/-9v_0t2rKlzM/Vl-wzBxLs8I/AAAAAAAACGo/hU-Nndu-AIg/s1600/Trial%2BRun%2BAd%2Bgif%2Bfor%2BSGN.gif)

## 87p

**Introducing new interactive ads to drive app installs**

> [https://adwords.googleblog.com/2015/12/trial-run-ads-interactive-interstitials-beta.html](https://adwords.googleblog.com/2015/12/trial-run-ads-interactive-interstitials-beta.html)

## 88p

**Chrome Platform Status**

> [https://www.chromestatus.com/features](https://www.chromestatus.com/features)

## 89p

Chrome와 Android의 향후에 대해서

## 90p

**Thanks!!**

Enjoy After Party!!