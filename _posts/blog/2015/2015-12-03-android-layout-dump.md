---
layout: post
title: "Android Dump View Hierarchy for UI Automator"
date: 2015-12-03 23:50:00
tag: [Android, Layout]
categories:
- blog
- Android
- Debug
---

<!--more-->

Android 개발을 하면 여러가지 고민들이 많습니다.

그 중 하나는 레이아웃 구조를 어떻게 잡아야 하는것인지라는 의문입니다.

여러가지 다른 앱을 보면서 참고하는 경우도 많이 있습니다.

이번 포스팅에는 다른 앱을 보며 레이아웃 참고시 팁을 적어봅니다.

- - -

# View Hierarchy

실행 파일 (Windows 기준)

- Android SDK Folder
 - tools \ `uiautomatorviewer.bat`

실행시 화면은 아래와 같습니다.

 <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-12-03-android-layout-dump-01.PNG" }}" />

# UI Automator Dump

상단 메뉴에서 2번째 아이콘으로 현재 화면의 Layout Dump 를 취득할 수 있습니다.

사전 조건

- 개발자 모드 - USB 디버깅 ON

샘플로 카카오톡의 이모티콘 화면을 덤프로 받은 화면입니다.

 <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-12-03-android-layout-dump-02.PNG" }}" />

실제 View 의 구조와 어떤 View 를 사용했는지 체크 가능합니다.

좌측 화면을 마우스 포인트를 트래킹해서 오른쪽 레이아웃 화면에 어떤 View 를 사용하는지 알려줍니다.
