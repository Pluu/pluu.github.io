---
layout: post
title: "[요약] What’s new in Android privacy (Google I/O '21)"
date: 2021-05-23 15:50:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/gTUt9mwfPS8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/001.png" }}" /> 

- 사용자는 스마트폰을 사용할 때 생활에 편리할 뿐만 아니라 위협으로부터 안전하게 보호되길 원한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/002.png" }}" /> 

- Android에는 제품 개발의 지침이 되는 개인 정보 보호 원칙이 존재한다
  - Transparency : 앱에서 액세스하는 데이터의 종류와 시점을 투명하게 밝힌다
  - Control : 사용자에게 단순한 컨트롤을 제공해 앱이 사용자의 데이터에 액세스할 권한을 요청할 때 사용자가 인지하고 결정을 내릴 수 있도록 한다
  - Data Minimization : 데이터를 최소화하면 권한의 범위를 줄여주므로 데이터가 사용자의 기기를 벗어나도 사용자가 놀라지 않는다
  - Private Compute Core : 중요한 센서 데이터를 OS의 나머지 부분 및 앱과 별개로 구분한다
- 사용자는 어떤 앱이 자신의 디바이스에 액세스했는지 알고 싶어 한다
- Android 12에서는 투명성 강화에 여러 기능이 도입되었다

### 투명성 (Transparency)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/003.png" }}" /> 

- 이번 버전에서는 마이크와 카메라의 액세스 투명성을 강화했다
- 그로 인해 사용자는 어떤 앱이 마이크나 카메라에 액세스할 때마다 실시간으로 알 수 있다.
- 사용자는 Quick Settings에서 데이터에 액세스하는 앱을 조회할 수 있는데 부적절한 액세스인 경우에는 권한을 철회하면 된다

<img src="https://storage.googleapis.com/gweb-uniblog-publish-prod/original_images/2._Android_12_Privacy_Indicators__Toggles.gif" />

> 이미지 출처 : Android 12 Beta: Designed for you https://blog.google/products/android/android-12-beta/

#### Privacy dashboard

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/004.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/005.png" }}" /> 

- 새로운 Privacy Dashboard는 사용자가 간단하게 타임라인 조회를 통해 지난 24시간 동안 마이크/카메라/위치에 접근한 기록을 볼 수 있다
- 일회성 권한의 경우는 사용자에게 지난 24시간 동안 앱이 데이터에 접근했는지 표시된다
- 앱뿐만 아니라 타사의 SDK도 정당하게 사용되고 있는지 확인해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/006.png" }}" /> 

- Android 11의 경우 데이터 액세스 분석 API를 추가해 최신 데이터 액세스를 쉽게 분석할 수 있었다
- 이 API를 사용하면 코드의 어느 부분이 비공개 데이터에 액세스하는지 추적하고 타사 SDK에 의한 데이터 액세스를 추적 및 관리하는 방식이었다.
- API가 시스템에 앱별 콜백을 추적하도록 해 앱이 중요 데이터에 액세스할 때마다 추적하게 한다

### Clipboard

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/007.png" }}" /> 

- 사용자는 이메일, 주소, 비밀번호까지 복사하므로 클립보드에 저장되는 정보는 매우 중요하다
- Android 12는 앱이 클립보드에서 읽기 작업을 할 때마다(어떤 앱이 `getPrimaryClip`을 호출할 때마다 ) 사용자에게 Toast로 알린다.
- 클립보드 데이터 출처가 같은 앱이면 Toast가 표시되지 않는다
- `getPrimaryClipDescription`으로 클립보드에 포함된 데이터 유형을 체크함으로 액세스를 최소화할 수 있다

### Control

#### Location

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/008.png" }}" /> 

- 위치 권한을 Background/Foreground 액세스를 분리
- Only this time 옵션 추가 (마이크 및 카메라에도 적용)
- Background 위치에 대한 액세스 제한 : 사용자가 Foreground 위치를 선택하는 경우가 전체의 80%에 해당

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/009.png" }}" /> 

- 자신의 위치 데이터를 더 컨트롤할 수 있도록 `Approximate location` 옵션 추가
- 앱에 제공할 위치를 대략적으로만 전달할 수 있다
- 정확한 위치가 필요한 경우가 아니라면 `ACCESS_COARSE_LOCATION`만 요청해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/010.png" }}" /> 

- 정확한 위치가 필요한 경우, `ACCESS_FINE_LOCATION과 ACCESS_COARSE_LOCATION 권한을 모두 요청`해야 한다.
- 사용자 입장에서는 대략적인 위치만으로 대부분의 작업이 수행되어야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/011.png" }}" /> 

- 정확한 위치가 필요한 경우, 앱이 사용자에게 정확한 위치 허용을 요청할 수 있다
- 이미 ACCESS_COARSE_LOCATION가 부여되어 있는 경우에 사용해야 한다.

> 참고 자료 : Approximate location https://developer.android.com/about/versions/12/behavior-changes-12#approximate-location

#### 마이크/카메라

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/012.png" }}" /> 

- 이전에는 사용자가 직접 마이크와 카메라에 대한 액세스를 차단할 방법은 사실상 없었다
- Android 12에 새로운 컨트롤을 추가해 사용자가 마이크와 카메라 액세스를 손쉽게 차단할 수 있다
- 액세스가 차단된 상태에서 센서에 액세스해야 하는 앱을 실행한 경우 센서를 켜라는 알림이 표시된다
- 마이크 액세스를 차단한 경우 샘플링 레이트를 200Hz로 제한된다. 높은 샘플링 레이트가 필요한 경우에는 Access Higher Sensor Sampling Rate를 요청해야 한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/013.png" }}" /> 

- 개인 정보 보호 관련 설문조사 결과로 미국 응답자의 56%, 인도 응답자의 81%는 친구나 가족과 디바이스를 공유한다고 답했다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/014.png" }}" /> 

- 게스트 모드로 쉽게 전활 할 수 있도록 개선
- 잠금 화면에서 몇 번의 탭만으로 안전하게 디바이스를 공유할 수 있다

### Data Minimization

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/015.png" }}" /> 

- Nearby 연결로 새로운 런타임 권한이 추가됨
- 이전 버전까지는 워치/헤드폰 등 관련으로 Companion 앱을 사용하려면 위치 권한을 얻어야만 근처의 블루투스를 스캔할 수 있었다
- Android 12에서는 새로운 Nearby 권한을 요청하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/016.png" }}" /> 

- Android 11에서는 앱을 오랫동안 사용하지 않으면 권한을 철회하는 "권한 자동 재설정"이 추가되었다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/017.png" }}" /> 

- Android 12에서는 장기간 미사용한 앱은 최대 절전 모드로 전환된다
- 사용자가 허용한 권한을 철회하며 앱은 강제 중단 상태로 만들어서 메모리 스토리지 및 리소스까지 회수한다
- 또한 백그라운드에서 작업을 하거나 푸시 알림을 받지 않도록 차단한다
- 최대 절전 모드를 종료하려면 앱을 실행하기만 하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/018.png" }}" /> 

Scoped storage

- Scoped storage는 자체 스토리지가 아닌 외부 앱 스토리지 폴더의 콘텐츠에 대한 액세스를 제한한다
- 2021년 5월 5일부터 앱에서 MANAGE_EXTERNAL_STORAGE 권한 액세스가 불필요한 경우 Manifest에서 제거해야만 앱을 출시할 수 있다

Package visibility

- 앱이 디바이스의 앱 목록을 쿼리하지 못하게 제한한다. 
- `QUERY_ALL_PACKAGES` 권한을 선언한 경우는 예외이지만 자격에 부합하는 앱에만 한정되게 사용할 수 있다

### Private Compute Core

인텔리전스 기능(대표적으로 Now Playing, Live Caption, Screen Attention)은 모두 Android 디바이스 로컬로 실행되며 네트워크를 사용하거나 Google 데이터를 보내지 않아도 작동합니다.

Private Compute Core는 Android 12에 새롭게 도입된 개념이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/019.png" }}" /> 

- 예를 들어 Now Playing은 음악을 들어야만 음악을 인식할 수 있는데, 주변의 오디오는 중요한 정보일 수 있다.
- Android 12에서는 OS 비공개 컴퓨팅 레이어를 나머지 OS와 기술적으로 격리된 곳에 추가한다. 다른 앱과 네트워크와도 격리된 지점이다.
- 데이터 처리가 안전하며 기밀이 유지된 상태로 이뤄진다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/020.png" }}" /> 

- Smart Reply도 Private Compute Core에 해당된다
- 앱에 텍스트를 입력하면 Gboard가 Smart Reply에 화면에 표시된 대화 내용을 바탕으로 추천을 요청한다. 화면에 표시된 데이터는 Private Compute Core ejrqns에 안전하고 기밀된 상태로 데이터가 처리된다.
- 민감한 데이터를 앱, 키보드, Google과 공유하지 않는다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/whats-new-in-android-privacy/021.png" }}" /> 

- Private Compute Core에 직접적인 네트워크 권한을 제거했다
- Private Compute Core 내 기능은 `Private Compute Services`라고 불리는 새로운 오픈 소스 APK와 통신한다.
- Private Compute Services은 모델을 다운로드하거나 학습을 사용하는 등의 작업을 진행한다
- 중요한 데이터를 처리하는 코드는 Android OS의 격리된 부분에서 실행되며 오픈소스 API로 배치한 채널을 통해서 통신한다

