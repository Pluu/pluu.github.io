---
layout: post
title: "[요약] Top 12 tips to get ready for Android 12 (Google I/O '21)"
date: 2021-05-22 16:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/IgeuXF60Ins" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

안드로이드 12 출시에 대비해 앱에서 필요한 12가지 팁을 소개한다.

### Compatibility Framework

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/001.png" }}" /> 

- 플랫폼의 여러 변경사항이 앱의 각 부분에 영향을 미칠 수 있으므로 특정한 동작 변경 사항을 테스트할 필요가 있다.
- 호환성 프레임워크에서 앱 변경 사항을 선택적으로 활성화 혹은 강제로 활성화할 수 있다. 그래서 개별적인 변경 사항을 해결하는 데 집중할 수 있다
- 개발자 옵션 혹은 ADB 명령으로 설정할 수 있다

> 참고 자료 : https://developer.android.com/guide/app-compatibility/test-debug

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/002.png" }}" /> 

Foreground service는 멀티태스킹이 필요하고 사용자 작업을 완료해야 하는 케이스에 적합하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/003.png" }}" /> 

- 이전 버전까지 Foreground service는 절반 가까이가 Background에서 시작되었다
- 사용자는 Foreground Service 알림에 당황하게 된다.
- Foregroudn service가 시스템 리소스를 차지하므로 OS에서 리소스 우선순위를 효과적으로 배분할 수 없다
- Android 12에서는 Foreground service를 Background에서 시작하지 못한다. 이 변경 사항은 Android 12 이상을 사용하는 앱에 적용된다.

> 참고 자료 : Foreground service launch restrictions https://developer.android.com/about/versions/12/behavior-changes-12#foreground-service-launch-restrictions

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/004.png" }}" /> 

- 빨리 실행해야 하는 짧은 Background 작업의 경우 긴급 작업으로 이전할 수 있다. 
- 긴급 작업은 지연이 낮고 Foreground/Background에서 바로 호출해 실행할 수 있다.

> 참고 영상 : Effective background tasks on Android https://www.youtube.com/watch?v=IqnCqHyu1E4

### 개인정보 관리 방침

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/005.png" }}" /> 

- 사용자가 마이크/카메라 접근을 차단할 수 있는 마이크/카메라 전환 기능이 추가되었다. 
- 앱에서는 마이크/카메라에 계속 접근하는 것으로 간주하지만 마이크/카메라가 비활성화되면 빈 정보를 수신 받는다
- Target SDK 버전과 관계없이 모든 앱에 영향을 준다

### hibernated

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/006.png" }}" /> 

- Android 12에서 오랫동안 사용하지 않는 앱은 이전 버전의 권한 자동 재설정 기능을 확대하여 사용하지 않는 앱은 동면 상태로 전환한다.
- 동면 상태로 들어간 앱의 변화는 다음과 같다
  - 기존에 부여된 권한이 취소된다
  - 앱 캐시를 삭제해 스토리지를 비운다
  - 모든 작업과 푸시 메시지를 중단되고 강제로 정지한 상태가 된다

> 참고 영상 : What’s new in Android privacy https://www.youtube.com/watch?v=gTUt9mwfPS8
>
> 참고 자료 : App hibernation https://developer.android.com/about/versions/12/behavior-changes-12#app-hibernation

### Bluetooth

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/007.png" }}" /> 

- Android 12를 Target으로 하는 앱은 기기 페어링과 같은 사례에서 위치 찾기 권한과 같은 주변 기기 검색 권한을 분리하는 옵션이 제공된다
- 새로운 `BLUETOOTH_SCAN` 권한과 android:usesPermissionFlags 속성을 사용하여 블루투스 기기에서 위치 정보를 가져오지 못하게 할 수 있다
- 이미 페어링 된 기기라면 새로운  `BLUETOOTH_CONNECT` 권한과 상호작용한다.

> 참고 자료 : https://developer.android.com/about/versions/12/features/bluetooth-permissions

### Network MAC Address

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/008.png" }}" /> 

- Android 12에서는 네트워크 MAC 주소 접근 제한을 강화했다.
- Android 12를 Target으로 하는 앱은 getHardwareAddress API 사용 시 null을 반환한다. 이전 API 레벨의 경우 고정된 자리 표시자 값을 반환한다
- 호환성 플래그를 사용하여 일시적으로 API에서 값을 반환하게 하여 마이그레이션 시간을 벌 수 있다
- 일반적으로 네트워크 연결 작업에 getifaddrs 및 Netlink sockets 같은 Low 레벨의 API를 사용하면 안 된다. 되도록 `ConnectivityManager`를 사용해야 한다

### Safe component

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/009.png" }}" /> 

- App Component의 exprted 속성이 강화되었다.
- Android 12를 대상으로 하는 앱은 Intent Filter가 있는 Component에서는 명시적으로 이 속성을 지정해야 한다. Component를 공유할 때는 의도적이고 명시적이야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/010.png" }}" /> 

- 올바르게 `exprted`를 지정하지 않으면 위와 같은 오류 메시지가 나타난다. 

> 참고 자료 : Safer component exporting https://developer.android.com/about/versions/12/behavior-changes-12#exported

### Notification

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/011.png" }}" /> 

- 완전한 [맞춤 알림](https://developer.android.com/training/notify-user/custom-notification)을 사용하는 앱의 경우 Android 12에서 변경 사항이 있습니다. 예를 들어 Notification.Builder에서 [setCustomContentView](https://developer.android.com/reference/android/app/Notification.Builder#setCustomContentView(android.widget.RemoteViews))를 사용하는 경우이다
- Android 12를 대상으로 하는 앱은 시스템에서 표준 템플릿을 적용하고 일관적인 사용자 경험을 제공한다
- Target SDK 레벨을 업데이트하고, 알림 레이아웃이 올바른지 확인해야 한다

> 참고 자료 : https://developer.android.com/about/versions/12/behavior-changes-12#custom-notifications

### App Link

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/012.png" }}" /> 

- App Links 적용에 문제를 탐지할 도구를 제공한다
- 링크별로 App Links 알림을 세분화하고, 서버 측 통합에 문제가 있으면 인증을 통과하지 못한 링크로만 오류를 제한했다
- ADB 명령으로 테스트도 가능하다
- 기본 앱이 설치되어 있지 않으면 브라우저로 이동
- 도메인 인증 상태를 검사하고 사용자를 설정을 이동시켜 앱에 도메인을 승인할 수 있도록 하는 API가 추가되었다

> 참고 자료 : Android App Links verification changes https://developer.android.com/about/versions/12/behavior-changes-12#android-app-links-verification-changes

### WebView

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/013.png" }}" /> 

- WebView를 사용하거나 Cookie를 사용하는 웹사이트 및 서비스를 관리하는 경우 테스트가 필요하다
- WebView는 Chromium 기반이며 `SameSite` 속성을 통해 타사 쿠키를 처리하는 변경 사항이 적용되었다

> 참고 자료 : Modern SameSite cookies in WebView https://developer.android.com/about/versions/12/behavior-changes-12#samesite

### Overscroll

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/014.png" }}" /> 

- 오버스크롤이란 사용자가 콘텐츠 경계에 닿아도 계속 스크롤 할 때 나타나는 효과이다
- 이전 버전까지의 오버스크롤은 글로우 효과였다.
- Android 12에서의 오버스크롤에 새로운 효과가 적용되었다

> 참고 자료 : Overscroll effect https://developer.android.com/about/versions/12/overscroll

### More

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/top-12-tips-to-get-ready-for-android-12/015.png" }}" /> 

- 특히 터치 이벤트 처리, 알림 트램펄린, 정확한 알림에 업데이트가 있다.
- 변경 사항에 대한 자세한 내용은 [개발자 웹사이트 링크](https://developer.android.com/about/versions/12/summary)를 참조하세요.
