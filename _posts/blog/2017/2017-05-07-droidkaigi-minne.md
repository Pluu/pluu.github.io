---
layout: post
title: "[번역] DroidKaigi 2017 ~ minne에서 테스트 ~ 배포 ~ 배포 후에 하고 있는 일의 소개"
date: 2017-05-07 18:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ minneにおけるテスト〜リリース〜リリース後にやっている事の紹介](https://www.slideshare.net/masatakakono1/minne-72969795) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

minne에서 테스트 ~ 배포 ~ 배포 후에 하고 있는 일의 소개

## 2p 자기소개

- PHP/Android
- minne(~2016년 12월)
- 주식회사 스마트 드라이브
- Twitter @mapyo
- GitHub @mapyo

## 3p minne는?

## 4p 

[Google Play Store Link](https://play.google.com/store/apps/details?id=jp.co.paperboy.minne.app)

## 5p minne에서 Android 개발

- 2013년 11월 배포
- Android 팀 3명
- 3명이 하나의 앱을 개발
- 2주에 1회 정기적으로 배포

## 6p 오늘 이야기하려는 것

- 복수 인원으로 앱 개발 사례
- 흐름을 정돈하자
- 여러 가지 논의하고 싶다

## 7p 목차

- 개발 시작부터 배포까지
- 테스트 · CI
- 배포 전 검증
- 배포
- 배포 후 흐름

## 8p 개발 시작부터 배포까지

## 9p~11p 개발부터 배포까지

1. 스프린트 계획
2. 개발 (Unit test, UI test)
3. 검증 시트 작성
4. 검증
5. 단계적 배포
6. 배포 후 흐름

## 12p 테스트 · CI

1. `테스트 종류와 설명`
2. CI로 사용하는 도구와 서비스
3. CI 흐름

## 13p~14p minne 에서의 테스트

- Unit test
- UI test
- 검증 시의 수동 테스트

> 그 전에 Android 테스트 타입 설명을 하겠습니다

## 15p Android 테스트 타입

- Local unit test (test)
- Instrumented test (androidTest)

[https://developer.android.com/studio/test/index.html](https://developer.android.com/studio/test/index.html)

## 16p Local unit test

- JVM 상에서 움직이는 테스트
- Instrumented test와 비교해 빠르다
- Android 프레임워크에 의존하는 테스트는 Mock이 필요

## 17p Instrumented test

- 실제 단말 · 에뮬레이터에서 움직이는 테스트
- Local unit test에 비교해 느리다
- Android 프레임워크에 의존해도 OK

## 18p minne 에서 테슽

- Unit test
- UI test

## 19p Unit test

- Local unit test로 실행
- Robolectric으로 Mock
- UI 테스트는 하지 않는다

※ Mock이 어려운 경우는 Instrumented test

## 20p Unit test로 한 것

- 단순한 모델 테스트
- MVP의 P 테스트
- API를 Mock 한 테스트
- 딥 링크 테스트
- SharedPreferences 부근

## 21p UI test

- Instrumented test로 실행
- Espresso로 기록

## 22p Ui test는 괴롭다

- 실행 타이밍에 따라 알 수 없는 에러
- 실행시간이 길다
- Espresso 작성법

MVP로 작성해 P의 테스트를 Unit test로 하자!!

## 23p 테스트 · CI

1. 테스트 종류와 설명
2. `CI로 사용하는 도구와 서비스`
3. CI 흐름

## 24p CI로 사용하는 도구와 서비스

- Drone
- AWS Device Farm

## 25p Drone

- Travis CI, CircleCI, Wercker와 대등한 CI 도구
- Docker

CI 쪽의 기능과 Unit test

## 26p Drone

open source edition

## 27p 자세한 것은 이쪽에
[https://speakerdeck.com/gs3/pepabowozhi-eruda-tong-ciji-pan-toren](https://speakerdeck.com/gs3/pepabowozhi-eruda-tong-ciji-pan-toren)

## 28p AWS Device Farm

- 클라우드에서 실제 단말을 사용해 테스트
- apk를 업로드해 수동 테스트

UI test를 실행

## 29p 테스트 · CI

1. 테스트 종류와 설명
2. CI로 사용하는 도구와 서비스
3. `CI 흐름`

## 30p~32p CI 흐름 ~Unit test~

Developer ─(PUSH)─> GitHub <─> Drone (Unit test!)

## 33p CI 흐름 ~UI test~

Developer ─(PUSH)─> GitHub ─> Drone

> Unit test를 실행 후에 동작

## 34p CI 흐름 ~UI test~

Developer ─(PUSH)─> GitHub ─> Drone ─> Device Farm

> web hook 구조가 없다

## 35p CI 흐름 ~UI test~

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-05-07-droidkaigi-01.png" }}" />

## 36p 테스트 실행 타이밍

- Unit test
  → PUSH 마다 실행
- Ui test
  → develop, master, release 브런치

## 37p 배포 전의 검증

## 38p 흐름

1. 배포 담당을 사전에 정한다
2. 배포용 issue 를 정한다
3. 검증 시트 작성
4. 검증
5. 검증에서 나온 버그를 수정한다

## 39p 흐름

1. 배포 담당을 사전에 정한다
2. `배포용 issue 를 정한다`
3. 검증 시트 작성
4. 검증
5. 검증에서 나온 버그를 수정한다

## 40p 배포용 issue

- 검증 시트로의 링크
- 검증 시작 ~ 배포까지 흐름
- 이번 배포의 메모

즉시 수정 · 추가해서 다음 배포 시에도 사용

## 43p 흐름

1. 배포 담당을 사전에 정한다
2. 배포용 issue 를 정한다
3. `검증 시트 작성`
4. 검증
5. 검증에서 나온 버그를 수정한다

## 44p 검증 시트란?

- 어느 화면?
- 로그인/로그아웃?
- 어떤 조작?
- 결과로 어떻게 되면 되는가?

다른 사람이 검증하는데 필요한 정보를 작성

## 45p

| 수정항목·시책 | 결제 | 로그인 상태 | 화면 |  | 확인 내용 |
| :-- | : -- | :-- | :-- | :-- | :-- |
| 결제화면 수정 | ○ | 로그인 중 | 카트 화면 | 카드에 작품을 넣는다 | 카트 아이콘에 1 표시가 나온다 |
|  |  |  |  |  | 카트로 이동하는 다이얼로그가 나온다 |
|  |  |  |  | 카트로 이동하는 팝업 | 카트에 넣은 작품 목록이 나온다 | 

| m 씨 | h 씨 | h 씨 | mapyo | mapyo | G 씨 |
| 기종A | 기종B | 기종C | 기종D | 기종E | 기종 F |
| 4.10 | 4.20 | 4.40 | 5.50 | 6.00 | 7.00 |
| :-- | :-- | :-- | :-- | :-- | :-- |
| ○ | ○ | ○ | ○ | ○ | ○ |
| ○ | ○ | ○ | ○ | ○ | △ |
| ○ | ○ | ○ | X | ○ | ○ |

## 46p 흐름

1. 배포 담당을 사전에 정한다
2. 배포용 issue 를 정한다
3. 검증 시트 작성
4. `검증`
5. `검증에서 나온 버그를 수정한다`

## 47p 검증 ~검증하는 사람~

- Android 엔지니어 1~2명
- 디렉터 1명
- 합계 3명 정도

iOS 엔지니어도 검증하자! 라는 흐름도

## 48p 검증한다!

- 검증 시트에 따라 한다
- 버그를 발견하면 재현 순서나 스크린숏 등을 붙인다
- 기능 개발한 사람에게 전달해 고쳐달라고 한다
- 다시 확인

## 49p 배포

## 50p 단계적 공개

- 20% 배포
- 2 영업일 후 50% 배포
- 2 영업일 후 100% 배포

휴일 전날은 가급적 배포 하지 않는다.

## 51p 배포 후의 흐름

## 52p 배포 후의 흐름

- 크래시 감시
- 앱 리뷰 감시와 대응
- 회고

## 53p 크래시 감시

- Crashlytics
- Slack과 연동
- 매일 아침 Slack으로 리마인딩

## 54p 앱 리뷰 감시

- Slack으로 1일 1회 보낸다
- google-play-review-watcher

## 55p 앱 리뷰 감시와 대응
[https://github.com/Konboi/go-google-play-review-watcher](https://github.com/Konboi/go-google-play-review-watcher)

## 56p 리뷰 모습

## 57p 리뷰 대응에 대해

- 애초에는 엔지니어가 선정해서 CS에게 의뢰
- 현재는 CS가 직접 답변

## 58p 회고

- 회고 issue를 정한다
- Android 팀 3명
- 배포 후 (20%)에 실시
- 1시간 정도
- Keep·Good/Problem/Try

## 61p 정리

## 62p 정리

- 테스트·검증·배포·배포 후에 관해 이야기했다
- 팀에 따라 각각 다르다
- 회고는 중요
- 조금이라도 모두에게 참고가 되었으면 좋겠습니다

## 63p 감사합니다!!

## 64p 부록

## 65p CI 흐름 ~UI test~

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-05-07-droidkaigi-01.png" }}" />

## 66p AWS Device Farm Gradle Plugin
[https://github.com/awslabs/aws-device-farm-gradle-plugin](https://github.com/awslabs/aws-device-farm-gradle-plugin)