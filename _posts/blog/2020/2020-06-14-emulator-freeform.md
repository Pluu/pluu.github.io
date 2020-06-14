---
layout: post
title: "Android Emulator 30.0.10 ~ Freeform Window Mode"
date: 2020-06-14 14:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- Emulator
---

Android 11 Beta Launch 이벤트 세션 중 [Screens - large, small and foldable](https://youtu.be/llHMxCz2Jig?t=669)에서 소개된 Freeform Window Mode에 대한 테스트입니다.

<!--more-->

Android Emulator 30.0.10에서 `Freeform Window Mode`가 활성화 되었습니다.

> Emulator Release Note : https://developer.android.com/studio/releases/emulator#freeform_window_mode

## Settings

Android [Emulator 30.0.10](https://developer.android.com/studio/releases/emulator#30-0-10)에서 13.5인치의 태블릿에서 Freeform Window Mode를 지원하는 에뮬레이터를 만들 수 있습니다.

이것으로 단일 폼 형태의 앱뿐만 아니라 다양한 폼의 사용자 경험을 개발자가 좀 더 쉽게 확인해볼 수 있게 되었습니다. 또한 실제 물리 기기 ChromeBook 없이도 Freeform 형태를 테스트해볼 수 있습니다.

AVD Manager에서 `13.5 Freeform`을 확인할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0614-freeform/avd-manager.png" }}" />

## 테스트 영상

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/ZpbpQYy7JCA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### 참고 자료

- Screens - large, small and foldable(Youtube) : https://youtu.be/llHMxCz2Jig?t=669
- Emulator Release Note : https://developer.android.com/studio/releases/emulator#freeform_window_mode
- AndroidX WindowManager : https://medium.com/androiddevelopers/support-new-form-factors-with-the-new-jetpack-windowmanager-library-4be98f5450da
