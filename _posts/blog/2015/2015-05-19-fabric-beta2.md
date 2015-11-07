---
layout: post
title: "[번역] [Android] Fabric를 사용해서 개발중인 어플리케이션을 배포해보자"
date: 2015-05-19 02:00:00
tag: [Android, Fabric.io, Fabric, beta]
categories:
- blog
- Android
- Fabric
---

이 포스팅은 [[Android] Fabricを使って開発中のアプリを配布してみる](http://qiita.com/rei-m/items/6a50738a431ffbac7d1e) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

Fabric를 사용해서 릴리즈 전 어플리케이션을 유저 테스트용으로 배포할 기회가 있어서 비망록 대신해서 남깁니다. 개발환경은 Android Studio 1.1.0입니다.


### Fabric란 뭐지

- Twitter가 개발하고있는 모바일 개발용 플랫폼. 사이트는 [이곳](https://get.fabric.io/). CrashReport의 수집ㅈ이나 릴리즈 전 어플리케이션의 배포 등 여러가지 편리한것이 가능합니다. 무료라서 사용합니다.

### 준비

- - -

#### 계정 등록

- 아무튼 계정을 등록합니다. Fabric 페이지를 열어 Get Started with Fabric에서 이름과 메일을 입력해서 등록합니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/29dec2d8-46f6-4b70-983a-5a47b3edb204.png" />

- 조금 기다리면 Activate용 링크가 포함된 메일이 도착하므로 클릭해서 등록을 완료합니다. 메일을 입력해고 이 메일이 도착할때까지 미묘하게 시간이 걸리기때문에 느긋하게 기다립니다. (우연일까나?)
- 끝나면 아래 이미지의 메일이 도착하므로 Get Started with Fabric을 클릭합니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/a0a14a1d-8713-d618-6b75-ae74c1fa32ba.png" />

#### Fabric Pluginのインストール

- IDE에 맞춘 Fabric용 Tool을 다운로드합니다. 이번은 Android Studio이므로 Droid군을 선택. Plugin용 jar zip파일 다운로드가 시작되므로 끝날때까지 기다립니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/9d769e52-ba2d-c212-58d1-3159b3a051c5.png" />

- 이후는 화면 안내에 따라서 AndroidStudio를 열어서 Preferences → Plugins 을 열고, Install plugin from disk로부터 다운로드한 zip을 선택하면 완료입니다.
- AndroidStudio를 재기동해서 Fabric 아이콘이 표시되있으면 OK입니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/a1f0df9c-0852-6d62-29cc-79055b1a0148.png" />

### 어플리케이션 배포

- - -

#### Fabric에 어플리케이션을 등록

- Android Studio에서 배포하고싶은 어플리케이션 프로젝트를 열고, Fabric 아이콘을 클릭합니다. 인증을 요구하므로 등록한 계정으로 로그인합니다.
- 그대로 진행하면 아래 이미지가 표시되므로 Crashlytics의 install를 선택합니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/7083f42a-61d1-58b1-8089-6b325ea4a986.png" />

- Fabric를 사용하기위해서 코드가 표시되므로, 수정항목을 확인한 후 Apply를 선택합니다.
- 선택후, 확인한 내용이 코드에 반영되고 Gradle의 Build가 실행됩니다. 끝나면 그 상태로 빌드해서 어플리케이션을 하나, 기동합니다. 기동완료 후, 브라우저에서 Fabric 콘솔을 열어, 어플리케이션이 등록되어있으면 종료입니다.

#### 어플리케이션 배포

- Android Studio에 돌아와 Fabric을 실행합니다. Share 아이콘 메뉴가 있으므로 선택합니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/0b76aa6b-4437-6e27-4937-1bcd1802b200.png" />

- 아래에 upload 버튼이 있으므로, 배포하고싶은 apk를 선택합니다.
- Release Note를 적어서 Distribute를 선택하면 업로드 완료입니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/910f5243-c0e7-691f-09a7-328ead9e9376.png" />

- 여기까지 온다면 준비 완료입니다. 브라우저에서 Fabric 콘솔을 열어 Share Links → Create New 에서 배포용 링크를 작성할수 있습니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/25841/7fa0b5f9-620a-d6f1-f304-43425cb34348.png" />

- 이후는 테스터한테 이 링크를 알려주면, 조금전 업로드한 apk가 다운로드 가능합니다. 인스톨시에 제공 불명확한 어플리케이션의 인스톨 허가를 요구하기때문에 개발중에는は 수락하십시오.
