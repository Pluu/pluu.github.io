---
layout: post
title: "Android Studio Jetpack Compose & Sample App"
date: 2019-05-19 11:25:00 +09:00
tag: [Android, Jetpack, Compose]
categories:
- blog
- Android
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/VsStyq4Lzxo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

먼저, Android Studio 자체를 빌드해본 것은 처음이라서, 일부 올바르지 않은 내용이 있을 수 있습니다.

<!--more-->

- - -

Google I/O '19'에서 Jetpack Compose는 UI 개발을 더 단순화하게 하기 위한 시도의 형태이다. 

아직 설치 가능한 형태로 존재하지 않아 직접 Android Studio를 빌드 후 실행해야 한다.

환경 자체가 익숙하지 않아서 테스트해 본 내용을 정리했다.

- - -

공식 Jetpack Compose 사이트 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/ui/README.md

## repo

1. Installing Repo

먼저 Android Studio를 빌드하기 위해 build tool인 repo를 설치한다

https://source.android.com/setup/build/downloading#installing-repo

2. Download Repo tool

```bash
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+x ~/bin/repo
```

## AndroidX 

1. 소스 코드 체크아웃

```bash
repo init -u https://android.googlesource.com/platform/manifest -b androidx-master-dev
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/001.png" }}" /> 

2. 소스 Sync

```bash
repo sync -j8 -c
```

- repo sync 작업이 시작되면 실제 저장소와 Local 의 sync 작업이 시작
- 공식 설명상으로는 6GB 정도 다운로드가 진행되므로 커피타임을 하라고 안내 😎 하며, ~정말로 커피 실 시간이 필요하다~

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/002.png" }}" /> 

Sync 작업이 끝나면 아래와 같은 화면을 볼 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/003.png" }}" /> 

> 최신 코드를 얻기 위해서는 `git fetch` 사용

## 빌드

Android Studio를 실행하기 위해서 다운로드한 소스의  `ui` 폴더로 이동 후 `studiow` 스크립트를 실행한다.

### 단순 실행

```bash
cd frameworks/support/ui/
./studiow
```

### Command Line 실행

```bash
cd frameworks/support/ui/
./gradlew :ui-demos:assembleDebug
```

열심히 Android Studio를 Build하고 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/004.png" }}" /> 

## Android Studio

Android Studio Version 3.4.1 Jetpack Compose Preview를 볼 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/005.png" }}" /> 

실제 ui 데모를 확인해 보기 위해서는 아래 데모를 열어서 확인 가능하다

```bash
/frameworks/support/ui/demos
```

아래 이미지의 좌측을 통해서 대략적으로 관련 프로젝트들을 볼 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/006.png" }}" /> 

## Sample

실제로 실행 가능한 것은 `ui-demos`와 `ui-material-studies` 2개이다.

- ui-demos : 실제 위젯의 동작을 확인
- ui-material-studies : [Material Rally 형태 샘플](https://material.io/design/material-studies/rally.html)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/007.png" }}" /> 

### ui-demos

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/008.png" }}" /> 

### ui-material-studies

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0519-jetpack-compose/009.png" }}" /> 

## 참고

- [Jetpack Compose](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/ui/README.md)
- [Android Jetpack](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/README.md)
- [（メモ）Jetpack ComposeデモアプリをWindowsでビルドする](https://qiita.com/teracy/items/6ed708ef90c8ec2663d2)