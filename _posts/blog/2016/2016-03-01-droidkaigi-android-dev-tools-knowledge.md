---
layout: post
title: "[번역] DroidKaigi 2016 ~ Android Dev Tools Knowledge"
date: 2016-03-01 02:00:00 +09:00
tag: [Android, DroidKaigi, Tools]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [Android Dev Tools Knowledge](http://www.slideshare.net/shinobuokano7/android-dev-tools-knowledge) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

## 4p

**shinobu.apk**

shinobu.apk#1의 공개 토론회 녹음 데이터와 Show Notes를 공개합니다!

[http://hack-it-iron.hatenablog.com/entry/2016/02/08/142322](http://hack-it-iron.hatenablog.com/entry/2016/02/08/142322)

## 5p

화기애애한 Android Framework Code Reading

화기애애한 Android Framework Code Reading #2를 개최했습니다

[http://hack-it-iron.hatenablog.com/entry/2015/11/28/185529](http://hack-it-iron.hatenablog.com/entry/2015/11/28/185529)

## 6p

**우선**

- 표준 Dev Tool의 이야기는 조금일지도
- 여러 가지 Tool이 있다는 것을 알았으면 좋겠다
- 게다가 좋은 툴을 만들었으면 좋겠다
  - 나도 힘낼께
- 알고 있으면서 쓰지 않는 것과 몰라서 쓰지 않는 것은 다르다
  - 기회손실

## 7p

**편리한 명령어**

※ Nexus 5 -version 6.0에서 동작 확인!

Marshmallow!!

## 8p

adb

## 9p ~ 10p

**간단하게 adb 환경을 준비한다**

brew install android-sdk

## 11p

먼저 adb 사용 용이성을 향상 시키자

## 12p ~ 13p

**adb-peco**

- 복수 Android 단말을 동시 연결할 때 편리
- adb-peco
- alias adb='adbp'
- [https://github.com/tomorrowkey/adb-peco](https://github.com/tomorrowkey/adb-peco)

## 14p

감사....!

대단히 감사....!

※ 그림은 안나옵니다

## 15p

**adb-peco**

- 복수의 Android 단말을 동시 연결로 곤란해 있지 않습니까? 그건 adb-peco로 선택할 수 있어요!
- [http://techlife.cookpad.com/entry/2014/09/09/172449](http://techlife.cookpad.com/entry/2014/09/09/172449)

## 16p

**inpu text**

- 입력을 편하게 할 수 있다
- 스마트폰의 키보드로 입력은 없다
- adb shell input text droidkaigi

## 17p

**dumpsys**

- dump system services status
- adb shell dumpsys \| grep "DUMP Of SERVICE"

## 18p

**dumpsys activity**

- Activity 상태를 Dump할 수 있다

## 19p

**dumpsys activity**

- **adb shell dumpsys activity top**
- adb shell dumpsys activity \| grep -B 1 "Run #[0-9]*:"
- adb shell dumpsys activity activities \| grep apk

## 20p

**Settings**

- 설정에 어떤 값이 들어있는가 확인 가능하다
- adb shell settings list [system/global/secure]

## 21p

**screenrecord**

- 화면녹화 기능
- adb shell screenrecord /sdcard/launch.mp4
- adb shell screenrecord --bugreport /sdcard/launch.mp4
- adb pull /sdcard/launch.mp4

## 22p

**Systrace**

The Systrace tool helps analyze the performance of your application by capturing and displaying execution times of your applications processes and other Android system processes

## 23p

**Systrace**

- generate an HTML report
- [http://developer.android.com/intl/ja/tools/help/systrace.html](http://developer.android.com/intl/ja/tools/help/systrace.html)

## 24p

**Systrace**

- python systrace.py
- /sdk/platform-tools/systrace

## 25p

**Analyzing UI Performance with Systrace**

- Analyzing UI Performance with Systrace
- [http://developer.android.com/tools/debugging/systrace.html](http://developer.android.com/tools/debugging/systrace.html)

## 26p

**atrace**

- atrace = Android System Trace
- adb shell atrace --list_categories

## 27p

**atrace**

- adb shell atrace --async_start -a com.kouzoh.mercari -c -b 16000 res
- adb shell atrace --async_stop -a com.kouzoh.mercari -c -b 16000 res

## 28p

**atrace source code**

[http://tools.oesf.biz/android-6.0.0_r1.0/xref/frameworks/native/cmds/atrace/atrace.cpp](http://tools.oesf.biz/android-6.0.0_r1.0/xref/frameworks/native/cmds/atrace/atrace.cpp)

## 29p

adb / adb shell

etc.

## 30p

솔직히 말하려고 하면 끝도 없지만...

## 31p

**Android-Command-Note**

[https://github.com/operando/Android-Command-Note](https://github.com/operando/Android-Command-Note)

## 32p

**AndroidShell**

[https://github.com/cesards/AndroidShell](https://github.com/cesards/AndroidShell)

## 33p

Gradle plugin

## 34p

**dexcount-gradle-plugin**

- 이름 그대로
- 메소드명을 카운트해준다
- [https://github.com/KeepSafe/dexcount-gradle-plugin](https://github.com/KeepSafe/dexcount-gradle-plugin)

## 35p

**gradle-versions-plugin**

- 사용하고 있는 라이브러리에 새로운 버전이 있는지를 체크해준다
- dependencyUpdates
- [https://github.com/ben-manes/gradle-versions-plugin](https://github.com/ben-manes/gradle-versions-plugin)

## 36p

**build-time-tracker-plugin**

- 빌드시간을 트랙킹해준다
- [https://github.com/passy/build-time-tracker-plugin](https://github.com/passy/build-time-tracker-plugin)

## 37p

**gradle-slack-plugin**

- Task가 끝나면 Slack으로 통지해준다
- [https://github.com/Mindera/gradle-slack-plugin](https://github.com/Mindera/gradle-slack-plugin)

## 38p

**gradle-android-command-plugin**

- gradle-android-command-plugin
- [https://github.com/novoda/gradle-android-command-plugin](https://github.com/novoda/gradle-android-command-plugin)

## 39p

**gradle-android-ribbonizer-plugin**

- gradle-android-ribbonizer-plugin
- [https://github.com/gfx/gradle-android-ribbonizer-plugin](https://github.com/gfx/gradle-android-ribbonizer-plugin)

## 40p

Android Studio plugin

## 41p

**AndroidWifiADB**

- AndroidWifiADB
- [https://github.com/pedrovgs/AndroidWiFiADB](https://github.com/pedrovgs/AndroidWiFiADB)

## 42p

**ADB Idea**

- ADB Idea
- [https://github.com/pbreault/adb-idea](https://github.com/pbreault/adb-idea)

## 43p

**Android-DPI-Calculator**

- Android-DPI-Calculator
- [https://github.com/JerzyPuchalski/Android-DPI-Calculator](https://github.com/JerzyPuchalski/Android-DPI-Calculator)

## 44p

**android-parcelable-intellij-plugin**

- android-parcelable-intellij-plugin
- [https://github.com/mcharmas/android-parcelable-intellij-plugin](https://github.com/mcharmas/android-parcelable-intellij-plugin)

## 45p

**AdbCommander for Android**

- AdbCommander for Android
- [https://plugins.jetbrains.com/plugin/7578](https://plugins.jetbrains.com/plugin/7578)

## 46p

**Genymotion Plugin**

- Genymotion Plugin
- [https://plugins.jetbrains.com/plugin/7269](https://plugins.jetbrains.com/plugin/7269)

## 47p

**eventbus-intellij-plugin**

- eventbus-intellij-plugin
- [https://github.com/kgmyshin/eventbus-intellij-plugin](https://github.com/kgmyshin/eventbus-intellij-plugin)

## 48p

**eventbus3-intellij-plugin**

- eventbus3-intellij-plugin
- [https://github.com/kgmyshin/eventbus3-intellij-plugin](https://github.com/kgmyshin/eventbus3-intellij-plugin)

## 49p

**android-postfix-plugin**

- android-postfix-plugin
- [https://github.com/takahirom/android-postfix-plugin](https://github.com/takahirom/android-postfix-plugin)

## 50p

**Android File Grouping Plugin**

- Android File Grouping Plugin
- [https://github.com/dmytrodanylyk/folding-plugin](https://github.com/dmytrodanylyk/folding-plugin)

## 51p

**GsonFormat(보너스)**

- GsonFormat
- [https://github.com/zzz40500/GsonFormat](https://github.com/zzz40500/GsonFormat)

## 52p

Android Studio 보너스

## 53p

**Google Developers color scheme**

- Google Developers color scheme
- [https://github.com/LouisCAD/GoogleDevelopersColorScheme](https://github.com/LouisCAD/GoogleDevelopersColorScheme)

## 54p

이외 개발에 편리한 도구

## 55p

**androidtool-mac**

- androidtool-mac
- [https://github.com/mortenjust/androidtool-mac](https://github.com/mortenjust/androidtool-mac)

## 56p

**tonkotsu**

- tonkotsu
- [https://github.com/operando/tonkotsu](https://github.com/operando/tonkotsu)
- [http://www.slideshare.net/shinobuokano7/ss-52089397](http://www.slideshare.net/shinobuokano7/ss-52089397)

## 57p

**vysor**

- vysor
- [https://chrome.google.com/webstore/detail/vysor-beta/gidgenkbbabolejbgbpnhbimgjbffefm](https://chrome.google.com/webstore/detail/vysor-beta/gidgenkbbabolejbgbpnhbimgjbffefm)

## 58p

**Android SDK Search**

- Android SDK Search
- [https://chrome.google.com/webstore/detail/android-sdk-search/hgcbffeicehlpmgmnhnkjbjoldkfhoin](https://chrome.google.com/webstore/detail/android-sdk-search/hgcbffeicehlpmgmnhnkjbjoldkfhoin)

## 59p

**DPI Calculator**

- DPI Calculator
- [https://chrome.google.com/webstore/detail/dpi-calculator/dldofgjemhkpilajnlenfijjpkabilcg](https://chrome.google.com/webstore/detail/dpi-calculator/dldofgjemhkpilajnlenfijjpkabilcg)
- [http://jennift.com/dpical.html](http://jennift.com/dpical.html)

## 60p

**Android Resource Navigator**

- Android Resource Navigator
- [https://chrome.google.com/webstore/detail/android-resource-navigato/agoomkionjjbejegcejiefodgbckeebo](https://chrome.google.com/webstore/detail/android-resource-navigato/agoomkionjjbejegcejiefodgbckeebo)

## 61p

**Material Terminal**

- Material Terminal
- [https://play.google.com/store/apps/details?id=yarolegovich.materialterminal](https://play.google.com/store/apps/details?id=yarolegovich.materialterminal)

## 62p

**materialdoc.com**

- materialdoc.com
- [https://play.google.com/store/apps/details?id=com.materialdoc](https://play.google.com/store/apps/details?id=com.materialdoc)
- [http://www.materialdoc.com/](http://www.materialdoc.com/)
- Material Design로 할 때 편리!!

## 63p

**DesignOverlay**

- DesignOverlay
- [https://github.com/Manabu-GT/DesignOverlay-Android](https://github.com/Manabu-GT/DesignOverlay-Android)
- [https://play.google.com/store/apps/details?id=com.ms_square.android.design.overlay](https://play.google.com/store/apps/details?id=com.ms_square.android.design.overlay)
- Material Design로 할 때 편리!!
- 미쳤어! 신이다!

## 64p

디버그에 편리한 라이브러리

## 65p

**stetho**

- stetho
- [http://facebook.github.io/stetho/](http://facebook.github.io/stetho/)

## 66p

**ViewDebug**

- View 내부를 Log로 확인할 수 있는 ViewDebug의 dumpCapturedView가 편리
- [http://developer.android.com/intl/ja/reference/android/view/ViewDebug.html](http://developer.android.com/intl/ja/reference/android/view/ViewDebug.html)

## 67p

**KLog**

- KLog
- timber도 동일하게 된다??
- [https://github.com/ZhaoKaiQiang/KLog](https://github.com/ZhaoKaiQiang/KLog)

## 68p

**IntentLogger**

- IntentLogger
- 그냥 편리 (웃음)
- [https://github.com/Drivemode/IntentLogger](https://github.com/Drivemode/IntentLogger)

## 69p

**어디서 정보를 모으는가?**

- 코드를 읽는다
- Google+
- Twitter
- Github
- 등등 ...

## 70p

정리

## 71p

Thanks!!
