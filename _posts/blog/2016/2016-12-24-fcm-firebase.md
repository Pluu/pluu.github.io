---
layout: post
title: "[번역] FCM(API)을 이용해서 푸시 알림용 사내 라이브러리를 만들었습니다"
date: 2016-12-24 18:00:00 +09:00
tag: [Android, Firebase]
categories:
- blog
- Android
---

본 포스팅은 [FCM(API)を利用したプッシュ通知用の社内ライブラリを作りました](http://qiita.com/evalue/items/2ce443f2b7a9e047d7c5) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 서론

여러분 최근 즐겁게 개발 하고 있습니까? 스마트 장치 횡단 팀의 duan입니다. 이번에는 Firebase의 추진에 따라 푸시 알림 공통 라이브러리를 만든 이야기를 하겠습니다.

## Firebase란

앱 개발자로서 이제는 모르는 사람은 없을 것입니다. 올해 Google I/O에서 발표되어 현재 가장 뜨거운 스마트 폰 개발 플랫폼이기도 합니다. 로그 분석, 데이터베이스, 푸시 알림, A/B 테스트 등 애플리케이션 개발에 필요한 기능을 All In One으로 제공되어 개발·정책, 분석주기를 지금까지보다 효율적으로 실시할 수 있게 되어 있습니다. 또한, 사용자 정보와 이벤트의 결합하여, 보다 고급 타겟팅 사용자 목록을 작성할 수 있고, 애플리케이션 정책 (푸시 알림, 광고 등)에서 쉽게 사용할 수 있습니다.

(공식 사이트 : [Firebase](https://firebase.google.com/))

## 라이브러리 작성

### 경위

회사 사정상 Firebase Notifications를 이용한 전송이 아니라 API를 경유한 방식의 전송이 채용하게 되어, Firebase Notifications의 일부 기능 및 측정 이벤트를 사전에 구현할 필요가 생겼습니다. 그에 따라 공통적인 구현을 모아서 라이브러리로 제공할 수 있게 되었습니다.

### 라이브러리에서 하고자 하는 것

1. FCM API를 통해 배포 공통 기능을 구현
2. Firebase SDK 버전 관리
3. 자사 비즈니스 요구에 충족하는 데이터 측정 기능의 공통 구현

### 전체 구성과 배포 흐름

<img src="https://qiita-image-store.s3.amazonaws.com/0/109089/6d9b1ff8-bb2b-46b0-a4ba-5d679dde9626.png" />

- ① 라이브러리측에서 FCM Token을 얻고 Firebase로 전송한다.
- ② 배포 대상 목록을 추출하기 위한 사용자 정보를 Firebase로 전송한다.
- ③ Firebase의 BigQuery 연계 기능을 이용하여 전송된 데이터를 BigQuery에서 참조할 수 있도록 한다. 또한 사내에서 관리하는 데이터와 결합하여 전달 대상 목록을 생성한다.
- ④ 자사 서버에 메시지 식별자를 생성하고 측정 유효 기간을 포함하여 FCM (API)를 통해 전달을 의뢰한다.
- ⑤ Firebase에서 배포를 실시한다.
- ⑥ 효과 측정 이벤트 (수신, 개봉, 전환 등)를 Firebase로 전송한다.

### 일부 구현 정책

#### 1. Android, iOS 전송 처리의 차이점을 의식한 payload 이용

채용 방침은 아래와 같이되어 있습니다.

| OS | paylaod 이용 | 이유 |
| :-- | :-- | :-- |
| Android | data만 | notification 지정하고 background일 때, 알림이 자동으로 System tray에 들어가서 수신 시 자체 구현할 수 없으므로 |
| iOS | notification, data | background에서 수신하기 위해 notification 지정이 필요하다 |

왜 Android에서 data payload 만 이용하는지를 쉽게 설명합시다.

공식 문서 [Handling messages](https://firebase.google.com/docs/cloud-messaging/android/receive)에 다음 내용이 적혀있고, 실제 기술 검증도 확인할 수 있습니다.

| App state | Notification | Data | Both |
| :-- | :-- | :-- | :-- |
| Foreground | onMessageReceived | onMessageReceived | onMessageReceived |
| Background | System tray | onMessageReceived | Notification: system tray Data: in extras of the intent. |

Android 측에서 Notification payload가 들어있는 경우 background에 있는 경우 알림이 system tray에 자동으로 들어가고, 수신 이벤트 취득 및 알림 표시의 사용자 정의 처리를 할 수 없게 되기 때문에, 어쩔 수 없이 data payload 만 지정 하는 방침이 되었습니다. 따라서 공통 라이브러리 측 Notifications payload를 동일한 기능으로 구현할 필요가 있어, iOS보다 구현 공수 및 고려해야 할 점이 크게 늘었습니다.

#### 2. FCM Token 관리 방식

현재 BigQuery에서 자동으로 전송, 관리되고 있지 않기 때문에, 자사 관리 데이터와 결합 전송 대상 목록을 추출하는 요구 사항을 충족하기 위해 자체적으로 구현하고 관리해야 할 필요가 있습니다. 아래와 같이 세 가지 방안을 검토했습니다.

| 검토 안 | 장점 | 단점 |
| :-- | :-- | :-- |
| 사용자 지정 이벤트 관리 | BigQuery 연계할 수 있는 구현 공수가 적다 | 데이터 추출할 때 연구가 필요 |
| User Property 관리 | BigQuery 연계할 수 있는 구현 공수가 적다 | 길이 제한의 원인, 여러 User Property를 사용할 필요가 있다 |
| 자사 서버에서 매핑 테이블을 보유 | 일반적인 구현 방법 | 구현 공수가 필요하다 |

사내 BigQuery를 이용해 데이터 분석하기도 하며, 가능하면 BigQuery에서 관리하고 싶으며 또한 개수 제한 (최대 25개)도 있고, User Property를 최대한 이용하고 싶지 않습니다. 결국, 사용자 지정 이벤트로 관리하는 방안을 채택했습니다.

#### 3. 공통 계측 이벤트의 구현

현재 FCM API를 통해 전달로는 Firebase Console, BigQuery에서 데이터를 확인할 수 없으므로 스스로 현재 Notifications에서 자동 취득한 다음 이벤트를 Firebase에서 관리 할 수 있도록 구현했습니다.

| OS | 이벤트 | 해당 Notifications 이벤트 |
| :-- | :-- | :-- |
| Android | 수신, 개봉, Dismiss | notification_forground, notification_background,notification_open,notification_dismiss |
| iOS | 수신, 개봉 | notification_forground, notification_open |

## 정리

Firebase가 세상에 나온지는 아직 1년 미만이지만, Google 측에서 적극적으로 개발자의 요구를 받아들여 기능 업데이트를 진행하고 있고, 대단한 장래성을 느끼고 있습니다. 앞으로도 계속 주목하고 이 라이브러리를 진화시키면서 다른 기능도 점점 시도하고 싶습니다. 또 이번 라이브러리 작성을 통해 FCM 전송 사양을 깊게 이해한 것은 물론, 이용자 관점의 인터페이스 설계의 중요성도 재차 확인했습니다.
