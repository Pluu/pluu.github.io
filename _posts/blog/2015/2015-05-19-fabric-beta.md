---
layout: post
title: "[번역] fabric.io에서 beta테스트 apk배포 구현 (이미지 모음, 초심자용)"
date: 2015-05-19 00:30:00
tag: [Android, Fabric.io, Fabric, beta]
categories:
- blog
- Android
- Fabric
---

이 포스팅은 [fabric.ioでbetaテストapk配布の実装（画像まとめ、初心者向け）](http://qiita.com/eneim/items/4008818e3278760cea2e) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

Android개발에는, beta판 테스트를 하기위해 iOS의 TestFlight과 같은 Tool (simple but powerful)은 거의 없다고 생각합니다.

그래서, 최근, fabric.io이 그 하나의 해결방법입니다.

이번, fabric.io에서 beta테스트 apk를 배포하는 방법에 대해서 이야기하고 싶습니다.

### fabric.io를 도입

- - -

신규 계정을 만들거나 Crashlytic 유저라면 업그레이드라는 방법이 있습니다. 저는 신규 유저입니다. fabric.io의 신규등록 페이지에 메일 계정을 입력하는 화면이 나오고, 초대 메일이 도착하면 계정을 만ㅁ들수 있습니다.

<img class="img-responsive" src="http://i.minus.com/iptGj7MmOnLa1.png" />

### fabric.io에서 Crashlytic를 인스톨

- - -

Android Studio의 Plugin을 인스톨해서 로그인하면 종료. 간단하므로 설명은 생략합니다.

### Project에 Crashlytic를 인스톨

- - -

fabric.io 아이콘을 클릭해서, fabric.io가 제공하는 서비스를 인스톨 할수있습니다. (Twitter API가 Crashlytic등. 나의 경우는 Crashlytic)

fabric.io의 지침에 따르는것만으로 가능하기때문에, 설명을 생략합니다. 종료화면만 올립니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/36601/bf3aa49a-82b4-888e-f8ab-841f12c0cd54.png" />

### beta apk 를 업로드해서, 테스터를 초대 등

- - -

이 포스트의 메인에 들어갑니다. fabric.io의 관리화면에서「Distributions」버튼을 클릭하면, APK 업로드 화면이 나옵니다. 여기에서, debug apk등 테스트용 apk를 업로드하고, 테스터를 초대할 수 있게 됩니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/36601/51836018-f7ca-d3a2-0d0b-0ff763d47d7e.png" />

이번, Google Sample의 Android Universal Music Player 을 사용해서 구현합니다. 테스터를 초대한 후, 테스터의 메일에 초대가 도착합니다. 그리고, 이후의 지침의 상세가 있습니다. 그 내용은,

- 테스트 시작 등

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/36601/efff8e54-ed7f-6706-8db6-108837beed21.png" />

- fabric.io 에 beta 어플리케이션 인스톨

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/36601/e5735334-a951-9276-8585-ebb6609dc99c.png" />

beta 어플리케이션을 열면, 테스트할려는 apk를 다운도록 가능하도록 됩니다. 여기는 TestFlight과 똑같고, 편리합니다.

테스터가 어플리케이션을 인스톨하는 것이 관리화면에서 보입니다.

<img class="img-responsive" src="http://i.minus.com/ibkrJOKeFanu26.png" />

### 정리

- - -

apk를 업로드할 때, gradle Task가 생성됩니다.

gradle

fabric.io 관리화면은 Android Studio 안이나 Web에서도 같으며 편리합니다.

fabric.io에서의 테스트 배포에 관해서는 이상입니다.
