---
layout: post
title: "[요약] Effective background tasks on Android (Google I/O '21)"
date: 2021-05-23 23:15:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/IqnCqHyu1E4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/001.png" }}" /> 

- Android 사용시 여러 개의 앱으로 사용자의 관심이 분산된다
- 사용자는 부가가치를 느껴야만 관심이 생겨난다
- 휴대폰 배터리가 소모되기 전까지 사용 가능한 리소스가 한정되어 있다

### Foreground Services

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/002.png" }}" /> 

- Foreground : 사용자의 관점에서 앱이 UI를 표시하거나 사용자가 인지하는 작업을 할 때
- Background : 사용자가 인지 못하는 작업을 할 때
- 사용자에게 부가가치가 없는 알림을 표시하는 앱은 백그라운드에 속한다
- Foreground Service는 사용자에게 앱이 상호작용할 서비스를 계속 제공한다는 것을 알린다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/003.png" }}" /> 

Foreground Service는 멀티태스킹과 사용자가 시작한 작업을 완료하는 작업 등에 사용된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/004.png" }}" /> 

- 급하지 않거나 사용자가 인식할 필요가 없는 작업에는 Foreground Service가 필요하지 않다
- 또한 앱이 메모리에 유지되는 수단으로 사용해서는 안 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/005.png" }}" /> 

잘못된 Foreground Service를 사용하는 경우

- 사용자가 제거할 수 없다
- 갑자기 노출되고 사라지는 알림은 사용자의 집중력을 방해한다
- 배터리와 메모리 리소스를 사용한다
- Foreground Service 시작 후 유지하는 시간은 앱이 결정하므로 OS에서의 동시 작업 우선순위를 효과적으로 설정할 수 없다

#### Foreground Service 설문 결과

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/006.png" }}" /> 

하루에 사용자가 받은 Foreground Service 알림은 200~500여 개이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/007.png" }}" /> 

사용자가 앱을 사용 중이지 않을 때 46%의 Foreground Service가 Background에서 시작되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/008.png" }}" /> 

- Foreground Service의 약 70%가 10초 이내로 실행되었다.
- 대부분의 세션은 2분 이내로 종료되었다

#### Foreground Service 설문 결과 ~ 대책

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/009.png" }}" /> 

- Android 12에서는 `Background에서 Foreground Service를 시작하는 것을 제한`한다
- API Level 31 이상을 대상으로 하는 앱에 적용된다
- Foreground Service 사용이 유효한 경우에 대해서 긴급 작업에 대한 API가 추가되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/010.png" }}" /> 

- Foreground Service 알림 표시는 `10초` 지연시킬 수 있다. 즉 10초간 Foreground Service 알림을 표시한다.
- 서비스가 이미 완료된 상태면 알림은 표시하지 않는다
- 앱은 알림을 지연하거나 즉시 표시하도록 정의할 수 있다

#### Experdited Jobs

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/011.png" }}" /> 

- 최대한 빠르게 실행해야 하는 짧은 Background 작업은 즉시 실행해야 하는 작업이다. 이런 작업은 OS에서 최대한 빨리 처리한다. 
- 긴급 작업은 잠자기 및 절전 모드에서도 실행할 수 있다
- OS가 일정과 실행을 관리하면 긴급 작업을 대기 처리도 가능하다
  - 자주 사용하지 않는 앱은 Background에서 긴급 작업을 실행할 기회가 적게 부여된다
- WorkManager 2.7.0이후에 긴급 작업용 API가 제공된다
  - 긴급 작업용으로 WorkManager 사용을 권장한다

### Foreground Service Exemptions

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/012.png" }}" /> 

Foreground Service 제한이 강화되면서 몇 가지 예외 사항이 설정되어 있다

- 앱이 사용자에게 보이는 경우
  - Android 10에 도입된 Background Activity 시작 제한과 동일하다. 이 경우 Foreground Service는 앱을 Background로 전환 시 계속 실행할 수 있다
- 사용자 상호 작용에서 시작할 경우
  - 알림을 탭 하거나 위젯을 시작한 경우
- 특정 System Broadcast와 Callback
  - Broadcast : 예) BOOT_COMPLETED, MY_PACKAGE_REPLACED
  - Callback : 예) 지오펜싱 콜백과 우선순위가 높은 FCM 메시지

### Use Cases

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/013.png" }}" /> 

UI에서 Foreground Service를 시작하는 경우

- Started by the user : 사용자가 UI에서 시작하는 경우
- App needs to run in the Bg to complete a task : 이메일 앱에서 대용량 첨부 파일을 보내야 하는 경우

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/014.png" }}" /> 

- 대부분의 Background 작업은 WorkManager를 사용하는 것이 좋다
- 시급한 작업이거나 몇 분 이내로 끝나는 작업 ▶ WorkManager의 긴급작업 API가 적절
- 그 외에는 일반 작업을 사용하여 시스템에서 관리하도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/effective-background-tasks-on-android/015.png" }}" /> 

- Push Message로 FCM을 추천한다
- 우선순위가 높은 FCM 메시지를 사용하면 기기가 잠자기 상태일 때도 앱에서 푸시 알림을 수신할 수 있다
- 메시지 앱은 가능한 FCM 페이로드에 메시지를 넣는다
  - 페이로드 사용이 어려운 경우 긴급 작업으로 서버에서 메시지를 수신할 수도 있다
