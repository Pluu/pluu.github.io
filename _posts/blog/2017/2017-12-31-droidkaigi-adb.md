---
layout: post
title: "[번역] DroidKaigi 2017 ~ Command 없이 나는 Android 개발 불가능한 이야기"
date: 2017-12-31 17:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ コマンドなしでぼくはAndroid開発できない話](https://speakerdeck.com/operando/komantonasitehokuhaandroidkai-fa-tekinaihua-1) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p

Command 없이 나는 Android 개발 불가능한 이야기

## 2p, About Me

- Shinobu Okano
- @operandoOS
- Mercari, Inc.
- Souzoh, Inc.

## 3p

자료내의 Command에 `packageName`라고 쓰여있는 부분은 앱 패키지 이름으로 대체해보세요!

## 4p

질문 등이 있으면 [https://github.com/operando/DroidKaigi](https://github.com/operando/DroidKaigi) 에 issue 등으로 올려주세요!

## 5p

Android에서 Command? 🤔

## 6p

Android에서 Command 잘 사용하고 싶어 😆

## 7p

할 수 있습니다 😊

## 8p, 사용하기 위해서는

- Android SDK 쪽에 조금 Path를 넣을 뿐
- 기본, 그것뿐!

## 9p, Android SDK 쪽의 어느 Path 쓰면될까

- sdk/tools
- sdk/tools/bin
- sdk/platform-tools
- sdk/build-tools/<version>
- sdk/platform-tools/systrace (부록)

## 10p

Command 쉽게 사용하자 💪

## 11p, adb-peco

- 여러 Android 기기를 동시 연결 시 유용
- alias adb='adb-peco'
- [https://github.com/tomorrowkey/adb-peco](https://github.com/tomorrowkey/adb-peco)

## 12p, adb-peco

- 여러 Android 기기를 동시 연결로 힘들지 않습니까? adb-peco로 선택할 수 있어요!
- [http://techlife.cookpad.com/entry/2014/09/09/172449](http://techlife.cookpad.com/entry/2014/09/09/172449)

## 13p, adb-peco

- adb-peco를 재수정했습니다 by tomorrowkey
- [http://tomorrowkey.hatenablog.jp/entry/2016/07/31/adb-peco%E3%82%92%E6%9B%B8%E3%81%8D%E7%9B%B4%E3%81%97%E3%81%BE%E3%81%97%E3%81%9F](http://tomorrowkey.hatenablog.jp/entry/2016/07/31/adb-peco%E3%82%92%E6%9B%B8%E3%81%8D%E7%9B%B4%E3%81%97%E3%81%BE%E3%81%97%E3%81%9F)

## 14p, 과거에 사용한 명령을 interactive로 찾으면서 사용

peco select adb history

[https://gist.github.com/operando/250da59cc97d89c33337fe5b129e09f5](https://gist.github.com/operando/250da59cc97d89c33337fe5b129e09f5)

## 15p

adb

## 16p, adb

Android Debug Bridge

## 17p, adb

[https://developer.android.com/studio/command-line/adb.html](https://developer.android.com/studio/command-line/adb.html)

## 18p, 실제 단말 및 에뮬레이터에서 실행할 수 있는 Command는 다르다

- 실제 단말은 없지만, 에뮬레이터에 들어있는 Command는 적당히 있다
- 보안상의 이유이려나?

## 19p, 네트워크를 통해 Command를 실행하기

- adb shell ip addr show wlan0 | grep 'inet ' | cut -d' ' -f6|cut -d/ -f1
   - ip 부분만 추출
- adb tcpip 5555
- adb connect ip:5555

## 20p, AndroidWiFiADB

- Android Studio Plugin
- [https://github.com/pedrovgs/AndroidWiFiADB](https://github.com/pedrovgs/AndroidWiFiADB)
- 이쪽이 편하다

## 21p

input

## 22p, input text

문자 입력이 무척 쉬워지는 최강 Command ✨

## 23p, input text

adb shell input text droidkaigi2017

## 24p, input keyevent

Key event를 내보낼 수 있다

## 25p, input keyevent

- adb shell input keyevent KEYCODE_POWER
   - 전원 키를 누른다
- adb shell input keyevent KEYCODE_SLEEP
   - 스크린 OFF

## 26p, adb shell input 코드
[http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/input/src/com/android/commands/input/Input.java](http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/input/src/com/android/commands/input/Input.java)

## 27p, reboot

- 재부팅 Command
- adb shell reboot

## 28p

am

## 29p, am start

- Activity 시작시키기
- adb shell am start -a android.intent.action.VIEW -d https://google.com

## 30p, am broadcast

- Broadcast 실행하는 Command

## 31p, am broadcast

- adb shell am broadcast -a com.android.systemui.BATTERY_LEVEL_TEST
- 배터리 잔량 0~100%의 이미지를 애니메이션으로 확인할 수 있다!
   - 사용할 일 없겠지~ 😇

## 32p, am hang

- 지금은 안하도록 w
- hang 하므로
- hang 되어 어쩔 수 없게 되면 adb shell reboot입니다!

## 33p, am Source Code

- [http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/am/src/com/android/commands/am/Am.java](http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/am/src/com/android/commands/am/Am.java)
- [http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/services/core/java/com/android/server/am/ActivityManagerShellCommand.java](http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/services/core/java/com/android/server/am/ActivityManagerShellCommand.java)

## 34p

pm

## 35p, pm

PackageManager

## 36p, pm path

- 지정한 패키지 이름의 apk 위치를 알려준다
- adb shell pm path packageName

## 37p, pm clear

- 애플리케이션 데이터를 삭제한다
- adb shell pm clear packageName

## 38p, pm list

- adb shell pm list packages
- adb shell pm list packages -e
- adb shell pm list packages -d
- adb shell pm list packages -s
- adb shell pm list packages -3

## 39p, pm source code

- [http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/pm/src/com/android/commands/pm/Pm.java](http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/cmds/pm/src/com/android/commands/pm/Pm.java)
- [http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/services/core/java/com/android/server/pm/PackageManagerShellCommand.java](http://tools.oesf.biz/android-7.1.1_r1.0/xref/frameworks/base/services/core/java/com/android/server/pm/PackageManagerShellCommand.java)

## 40p

dumpsys

## 41p, dumpsys

- 시스템 서비스의 상태를 덤프
- 여러 가지 있어서 동작 확인하고 싶을 때 굉장히 편리

## 42p, dumpsys

- adb shell dumpsys -l
   - 이것으로 system service 목록을 볼 수 있다
   - 원하는 System Service 를 찾는다

## 43p, dumpsys activity

- Activity 정보를 dump 한다
- adb shell dumpsys activity

## 44p, dumpsys activity top

- adb shell dumpsys activity top
- 지금 표시 중인 Activity 정보가 보인다!
- 레이아웃 구조도 볼 수 있다!
- FragmentManager 정보도 dump 된다

## 45p, dumpsys activity top

- 새로운 프로젝트나 잘 모르는 코드를 읽을 때 도움이 된다
- 이 화면은 어느 Activity? 어느 Fragment? 같은 것을 찾는데 최적
- 다른 사람의 앱의 View 구조를 조사하는데 최적

## 46p, dumpsys usagestats

- adb shell dumpsys usagestats

## 47p, adb shell dumpsys dbinfo

- adb shell dumpsys dbinfo
- adb shell dumpsys dbinfo packageName
- 실행한 SQL 이력을 볼 수 있다
- 테이블 구조 완전 노출 문제 🙈

## 48p

log

## 49p, log

- logcat에 임의의 log를 출력
- shell log DroidKaigi2017 해보자!
- 어떤 동작 범위 logcat을 보고 싶을 때 동작의 시작과 끝에 log를 출력하는데 편리

## 50p

run-as

## 51p, run-as

- 실행하는 프로세스를 바꾼다?
- adb shell run-as packageName
- /data/data/packageName 에 있는 파일을 보고 싶을 때에 편리

## 52p, run-as source code

[http://tools.oesf.biz/android-7.1.1_r1.0/xref/system/core/run-as/](http://tools.oesf.biz/android-7.1.1_r1.0/xref/system/core/run-as/)

## 53p

bugreport

## 54p, bugreport

adb bugreport

## 55p

bugreportz ✨

## 56p, bugreportz

- adb shell bugreportz
- bugreport를 zip 해준 것을 만들어 준다
- bugreport은 매우 크다

## 57p, bugreportz

- 다음에 저장한다
   - /data/user_de/0/com.android.shell/files/bugreports
- OK:/data/user_de/0/com.android.shell/files/bugreports/bugreportNPG05D-2017-03-10-07-41-37.zip
- 만들어지면 adb pull해서 꺼낸다

## 58p, bugreportz Source Code

[https://android.googlesource.com/platform/frameworks/native/+/refs/heads/master/cmds/bugreportz/](https://android.googlesource.com/platform/frameworks/native/+/refs/heads/master/cmds/bugreportz/)

## 59p, adb uninstall

- adb uninstall packageName
- 앱을 언인스톨한다

## 60p, 데이터 및 캐시를 남긴채 언인스톨

- adb shell cmd package uninstall -k packageName

## 61p

그외 많이 있어요!

## 62p

Command 응용해보자 💪

## 63p, 특정 앱의 Setting 화면을 Command 한 번으로 실행!!

- shell am start -a android.settings.APPLICATION_DETAILS_SETTINGS -d package:packageName

## 64p, 설치되어 있는 패키지 이름을 정렬해서 출력!

- adb shell pm list packages | sed 's@^package:@@g' | sort

## 65p, apk 꺼내는 것에 전력을 다했다!

- adb shell dumpsys activity activities| grep apk을 개조해서 peco와 함께 선택해 pull 하는 걸 만든다

## 66p, apk 꺼내는 것에 전력을 다했다!

- adb shell dumpsys activity activities | grep apk | sed -e 's/ *baseDir=//g' | peco | xargs adb pull

## 67p, apk 꺼내는 것에 전력을 다했다!

- dumpsys activity activities와 peco로 조심히 기기에서 apk를 쉽게 꺼낸다
- [http://qiita.com/operandoOS/items/6fa77037560e52d11352](http://qiita.com/operandoOS/items/6fa77037560e52d11352)

## 68p, dryrun

- gem install dryrun
- dryrun 레포지토리 URL

## 69p, dryrun

- [https://github.com/cesarferreira/dryrun](https://github.com/cesarferreira/dryrun)

## 70p, Command 쪽 source code

- [http://tools.oesf.biz/android-7.0.0_r1.0/xref/frameworks/base/cmds/](http://tools.oesf.biz/android-7.0.0_r1.0/xref/frameworks/base/cmds/)
- [http://tools.oesf.biz/android-7.0.0_r1.0/xref/system/core/](http://tools.oesf.biz/android-7.0.0_r1.0/xref/system/core/)

## 71p, Command의 실체를 확인하는 방법

- logcat 보기
- Command 출력 결과로부터 고정값 같은 것을 찾아 그것을 출력하는 작업을 찾는다
   - 거기서부터 계속 파고 들어간다
- 소스 코드에서 열심히 찾는다!

## 72p, Command Line 도구를 여러 언어로 만들기 위한 소재

- DeviceAPI-Android
   - [https://github.com/bbc/device_api-android](https://github.com/bbc/device_api-android)
   - ruby
- adbkit
   - [https://github.com/openstf/adbkit](https://github.com/openstf/adbkit)
   - node.js

## 73p, Android Command Note

소개한 Command 등 정리했습니다! 

[https://github.com/operando/Android-Command-Note](https://github.com/operando/Android-Command-Note)

## 74p

Thanks!!