---
layout: post
title: "[번역] DroidKaigi 2016 ~ Android,Brillo,ChromeOS"
date: 2016-07-10 17:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [Android,Brillo,ChromeOS](http://www.slideshare.net/l_b__/androidbrillochromeos) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

Android,Brillo,ChromeOS

2016/2/19

@I_B_

## 2p

**오늘의 개요**

작년 Google I/O에서 발표되고, 11월에 예고 없이 갑자기 소스 코드가 공개된 google 스마트폰용 OS Brillo.

공개된 소스를 보면 Android와 Chrome OS가 가진 기능의 하이브리드라고 이야기할 수 있는 것이 되어있습니다.

Google의 Android 팀과 Chrome 팀이 비밀스럽게 공개한 Brillo. 

Android나 Chrome OS에 비교해서 어떤지, 어떤 OS인지를 보려고 합니다.

## 3p

**주의사항**

- 이 세션의 내용은 Android Open Source Project(AOSP) 등이 공개된 정보를 기준으로 합니다. 소스 코드를 의거한 항목 이외는 추측이 섞여 있으므로 주의해주세요.
- Chrome OS라고 적었지만, 실제로 참고한 것은 오픈 소스판 Chromium OS입니다.

## 4p

**자기소개**

- Twitter ID: @I_B_
- 요코하마 Android and 모바일 OS 플램폼부(통칭 요코하마 PF부 #yapf)라는 스터디를하고 있습니다.
  - [http://www.yokohama.android-pf.org/](http://www.yokohama.android-pf.org/)
- 프레임워크쪽을 좋아합니다
- BeOS 좋아했고 Java-er이니 Be관계자가 많은 (많았던) Android에 끌렸습니다
- 직업은 모 Sler에서 Android 프레임워크 수정부터 앱 작성까지 하고 있지만 최근은 Android 전혀 다루지 않았습니다

## 5p

Android와 ChromeOS의 역사

## 6p

**Android와 ChromeOS의 역사**

|  | Android | Chrome OS |
| :- | :- | :- |
| 2003년 | Android사 설립 |  |
| 2005년 | Google이 Android사 매수 |  |
| 2008년 | Android 1.0 릴리즈, G1 발매 | Chrome 브라우저 릴리즈 |
| 2009년 |  | ChromeOS 발표, ChromiumOS 소스 공개 |
| 2010년 |  | Cr-48 발표 |

## 7p

**Android와 ChromeOS의 역사**

2013년 3월

앤디 루빈씨의 퇴임과 선다 피차이씨의 Android/Chrome 담당 겸임 발표

[http://www.itmedia.co.jp/news/articles/1303/14/news027.html](http://www.itmedia.co.jp/news/articles/1303/14/news027.html)

## 8p

**Android/ChromeOS/Brillo 역사**

|  | Android | Brillo |
| :- | :- | :- |
| 2014년 6월 | Android L Preview 릴리즈 |  |
| 2014년 11월 | Lollipop 5.0 릴리즈 |  |
| 2015년 6월 |  | Brillo 발표 |
| 2015년 10월 | Marshmallow 6.0 릴리즈 |  |
| 2015년 11월 |  | Brillo m7 소스 공개 |

## 9p

Android와 ChromeOS의 구조 복습

## 10p ~ 11p

**Android 구조**

<img src="http://image.slidesharecdn.com/abcdroidkaigi2016-160219070859/95/androidbrillochromeos-10-638.jpg?cb=1455865784" />

- 어플리케이션의 안정된 실행을 목적으로 한 분산 컴포넌트 OS
  - 프로세스에 의한 권한분리
  - 프로세스별 DalvikVM/ART에 의한 실행환경
  - 어플리케이션 프로세스를 고속기동하기 위한 Zygote
  - 프로세스 간 통신을 관리하는 Binder
  - 사용자 공간 (유저랜드, userland) 기동은 독립형식 init
  - 독자적인 폴더 구조 (/system, /data 등)

## 12p ~ 13p

**ChromeOS 구조**

<img src="http://image.slidesharecdn.com/abcdroidkaigi2016-160219070859/95/androidbrillochromeos-12-638.jpg?cb=1455865784" />

- Chrome/Chromium 브라우저를 실행시마다 특화한 시스템
  - GentooLinux가 기반
  - 사용자 공간 (유저랜드, userland) 기동은 upstart
  - 프로세스 간 통신은 D-Bus
  - FHS에따른 폴더 구성

## 14p

그러면 Brillo 이야기를

## 15p

**Brillo란**

- 공식 사이트 "Brillo brings the simplicity and speed of software development to hardware for IoT with an embedded OS, core services, developer kit, and developer console."
- Weave 프로토콜로 디바이스 간 통신을 서포트하며 32MB~64MB 정도의 메모리 탑재 디바이스를 타켓으로한 임베디드 기계용 OS와 개발 환경

## 16p ~ 18p

**Brillo 구조**

<img src="http://image.slidesharecdn.com/abcdroidkaigi2016-160219070859/95/androidbrillochromeos-16-638.jpg?cb=1455865784" />

- Android 사용자 공간(Android Iint와 폴더 구성)으로 디바이스에 독자적 서비스를 쉽게 포함하기 위한 경량 OS
- 개발 보드의 BSP(Board Support Package)로부터 제품용 빌드 환경 작성을 지원하는 BDK가 준비되어있다
- 현재는 웨어러블이지 않고, 그다지 성능이 높은 GUI를 포함하지 않는 플랫폼 제품용
- 어플리케이션을 추가하는 실행 환경 (Dalvik/ART, Zygote, PackageManager, ActivityManager 등)은 없으며 독자 서비스는 Native 데몬으로 들어있다

## 19p ~ 22p

**Brillo에서 실행되는 데몬**

| 데몬 | 개요 |
| :- | :- |
| ueventd | Android init에 포함된 디바이스 관리 데몬 |
| logd | Android에서 Lollipop 이후에 채용된 로그 데몬 |
| dbus-daemon | ChromeOS에서 사용되는 프로세스 간 통신 관리 데몬 |
| servicemanager | Android에서 사용되는 Binder 프로세스 간 통신 관리 데몬 |
| adbd | Android Debug bridge. Brillo도 adb 접속할 수 있다 |
| avahi-daemon | Zeroconf의 Linux용 구현 (Bonjour를 기반으로 한 명칭해결, 서비스 발견 규격) |
| avahi-bluetoothbd | Android에서 Marshmallow 이후에 채용된 Bluetooth 데몬 |
| wpa_supplicant | Android, ChromeOS에서 사용되는 Wifi 인증 데몬 |
| keystore | Android에서 사용되는 안정된 Key-Value 스토리지 |
| mediaserver | Android에서 사용되는 멀티미디어 프레임워크 기동 데몬. Brillo에서는 음성재생에 사용 |
| nativepowerman | Brillo 독자적인 전원관리 데몬 |
| sensorservice | Android에서 사용되는 센서 관리 서비스 |
| metrics_daemon | ChromeOS 유래의 유저 사용 상태 수집 데몬  |
| perfprofd | Android Marshmallow 이후 소스에 포함된 시스템 프로파일링 데몬 |
| shill | ChromeOS에서 사용되는 네트워크 접속 관리 데몬 |
| tlsdated | ChromeOS에서 안정된 시간 동기 데몬 |
| update_engine | ChromeOS에서 사용되는 소프트웨어 업데이트 데몬 |
| weaved | IoT용 프로토콜, Weave 구현 |
| webservd | HTTP 서버 |
| kauditd | ChromeOS |
| dnsmasq | Android에서 사용되는 간단한 DNS 서버 |
| dhcpcd-6.8.2 | DHCP 클라이언트 데몬 |
| firewalld | ChromeOS에서 사용되는 방화벽 |

## 23p

마지막으로 Android에서 채용된 ChromeOS 기능 이야기

## 24p ~ 25p

**Android에 채용된 ChromeOS 기술**

- Verified Boot와 dm-verity
  - Android 4.4부터 도입, 본격적인 도입은 Block-Oriented OTA가 도입된 5.0부터
  - 읽기전용 파티션 (/system이나 /vendor)의 4k마다 블록 해시값을 기반으로 해시 트리를 생성
  - 블록 읽기 시에 해시의 불일치(=개찬)가 있는 경우는 I/O 에러가 된다
  - 상세는 [https://source.android.com/security/verifiedboot/index.html](https://source.android.com/security/verifiedboot/index.html) 참조
- MiniJail
  - User Namespace, CGroup, chroot을 기반으로 한 컨테이너 가상화
    - 즉 LXC나 Dcoekr와 원리는 동일
  - Brillo에서도 Webservd에 적용되어 있다
  - Android에의 도입은 화면 출력이나 유저 입력을 생각하면 어렵다?

## 26p

**참고 리소스**

- AOSP
  - [http://source.android.com/](http://source.android.com/)
- Chromium OS Design Documents
  - [https://www.chromium.org/chromium-os/chromiumos-design-docs](https://www.chromium.org/chromium-os/chromiumos-design-docs)
- Qiita의 brillo Tag
  - [http://qiita.com/tags/brillo](http://qiita.com/tags/brillo)
  - @hidenorly씨가 여러 가지 시험해보고 있습니다