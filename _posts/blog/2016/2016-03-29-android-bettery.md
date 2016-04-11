---
layout: post
title: "[번역] DroidKaigi 2016 ~ Android 저전력에 대한 생각"
date: 2016-03-29 14:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2016 Androidの省電力を考える
](https://speakerdeck.com/ynakanishi/droidkaigi-2016-androidfalsesheng-dian-li-wokao-eru) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

DroidKaigi 2016 Android 저전력에 대한 생각

Brightechno 주식회사

대표 Nakanishi Yoshiaki

## 2p

**자기소개(상세버전)**

- Nakanishi Yoshiaki
  - Brightechno 주식회사 대표
    - 2010년 10월 개업
    - 메인 사업 : Android/iOS 어플 개발 및 컨설팅
  - 약력
    - 오사카 대학에서 정보공학을 전공, 석사과정 졸업 후, 마츠시타 전기산업(주)에 입사. 인터넷, 정보 보안, 휴대전화 관련 연구개발에 종사
    - 퇴사 후, McAfee(주)에서 휴대전화 · 스마트폰용 보안 소프트웨어 연규개발 담당
    - 그 후, 소니 · 에릭슨 · 모바일 커뮤니케이션즈(주)에서 Android 단말개발 프로젝트에 참가
    - 퇴직후 개업, 현재에 다다름

## 3p

**자기소개(간략버전)**

- Nakanishi Yoshiaki
  - Twitter: @chun_ryo
  - Android, iOS 둘다 사용

## 4p

**최근 활동**

- 서적
  - "Android 개발자를 위한 Swift 입문"(rictelecom)
    - [http://www.amazon.co.jp/dp/4897979838](http://www.amazon.co.jp/dp/4897979838)
- 동인지
  - "Swift Android"(TechBooster)
    - Android 6.0 퍼미션에 대해서  

## 5p

**본 세션에서 다룰 내용**

- 전력 사용량 감소 역사
  - 단말 제조사의 독자적 대책
  - 통신 작업 경험에서의 방침
  - Google이 제공하는 기능
- Android 6.0의 전력 절약 대책
  - Doze Mode
  - App Standby

## 6p

**본 세션에서 얻으셨으면 하는 것**

- Android 6.0 전력 절약에 대한 이해
  - 배경
  - 그 기능
  - 대책 (어떻게해서라도 피하고싶은 사람에게)

- Job Scheduler 장점

## 7p

전력 사용량 감소 역사

## 8p

**전력 사용량 감소 역사**

- 개요
  - 통신 작업 경험이나 단말 제조사가 독자적인 대책을 실시
  - 통신 작업 경험으로부터 어플 개발자에게 가이드라인을 제공
  - Google에 의한 Android 개선
    - 파편화(fragmentization) 등으로 사용이 진행되지 않음

↓

  - `Android 6.0에서 대개혁`

## 9p

**배터리가 부족한 Android**

- Google 검색으로 2010년경의 기사를 발굴해보기
  - [https://smhn.info/201203-sharp-eco-bcintent-deny](https://smhn.info/201203-sharp-eco-bcintent-deny)
    - "물론, iPhone의 배터리에도 수명은 있지만, Android는 MultiTask성때문에 배터리 수명이 짧은것이 어렵다"
  - [http://call-t.blog.so-net.ne.jp/2010-04-04](http://call-t.blog.so-net.ne.jp/2010-04-04)
    - "그래서... 결국 Google이외는 모든 서비스 정지. 그에따라 Xperia의 근 특징중 하나... Timescape는 보류됨"
- 많은 기사에서 "불필요한 Task를 없애라" 라는 대책을 추천

## 10p

**통신 작업 경험에서의 대책**

- 각 회사가 저전력 설정(어플)을 제공 (2011년경)
  - Wi-Fi/Bluetooth ON/OFF, 화면 밝기 등등을 배터리 잔량에 따라서 자동적으로 조절
    - NTT 도코모
      - eco 모드(어플로 조절, 2015년 3월 31일 종료)
    - au
      - eco 모드 설정
    - 소프트뱅크
      - 저전력 설정(무조건 저전력/수면 저전력)
  - ASCII의 당시 비교 기사
    - [http://ascii.jp/elem/000/000/629/629870/](http://ascii.jp/elem/000/000/629/629870/)

## 11p

**단말 제조상의 대규모 정리**

- SHARP : 에코 기술 (2011년)
  - 설정시에 Broadcast Intent를 어플에 발송하지않게 한다
    - AlarmManager에 대한 설정시간의 처리실행도 멈춘다
    - 특정 어플을 제외하는 설정도 가능
  - 당시 개발자 이벤트에서의 설명에서도 물의를 빚다
    - [http://togetter.com/li/273604](http://togetter.com/li/273604)
      - Broadcast Intent를 멈춤으로 어플의 백그라운드 동작을 제어

> 비슷한 기능, 최근 어디선가 본듯한 기분이 든다

## 12p

**어플 작성 가이드라인 · 도구**

- Android 어플 작성 가이드라인 ~효율적인 통신 제어에 대해서~ (NTT 도코모)
  - 단말이 효율적인 전력소비 등을 하기 위해서, 어플 개발자에 대해 가이드라인을 제시
  - [https://www.nttdocomo.co.jp/service/developer/smart_phone/etc/#p01](https://www.nttdocomo.co.jp/service/developer/smart_phone/etc/#p01)

## 13p

**Google의 대처**

- Fused Location Provider
  - 어플마다 위치정보 취득이 큰 영향을 주기때문에 Google Play service가 중개해서 제어
    - Google Play service에 Lockin되므로 Kindle등에서는 사용할 수 없다
- Sensor Batching (4.4이후)
  - 가능한 CPU를 움직이지않고 센서만으로 정보를 취득
    - 하드웨어도 대응할 필요가 있따
    - iPhone에서도 같은 구조(M9 프로세서 등)가 있음
    - [http://techBooster.org/android/device/16666/](http://techBooster.org/android/device/16666/)

## 14p

**Google의 대처 (계속)**

- Job Scheduler (5.0 이후)
  - 상세한 조건설정할 수 있는 Job의 연기 실행
    - 예 : 단말이 Idle Mode라면 실행하지않고, 네트워크 접속이 없을때는 실행하지않고, 등등
    - [https://www.youtube.com/watch?v=QdINLG5QrJc](https://www.youtube.com/watch?v=QdINLG5QrJc)
- BatterySaver (5.0 이후)
  - OS 표준 저전력 모드
    - 초기 설정으로는 배터리 잔량이 적어지면 자동적으로 발동
      - CPU 클럭 저하, 화면을 어둡게, 동기화 정지 등등
    - 통신 작업 경험의 독자적인 대처로부터 3년 ...

## 15p

**회장에의 질문**

- 어플 개발시에 전력 사용을 고려하고 있는가?
  - Fused Location Provider를 이용하고 있는가?
  - 전력 소비를 배려하는 가이드라인에 따르고 있는가?
  - Sensor Batching을 이용하고 있는가?
  - Job Scheduler를 이용하고 있는가?

## 16p

**예상 응답**

- 어플 개발시에 전력 사용을 고려하고 있는가?
  - Fused Location Provider를 이용하고 있는가?
    - 많다
  - 전력 소비를 배려하는 가이드라인에 따르고 있는가?
    - 거의 없다
  - Sensor Batching을 이용하고 있는가?
    - 적다 (애초에 센서 이용안함도 포함)
  - Job Scheduler를 이용하고 있는가?
    - 적다

## 17p

**어째서 대응하지않는가(할 수 없는가)**

- 몰랐다
- 구 OS 버전도 대응이 필요 (그러므로 사용할 수 없다)
- 대응하면 요구사양을 맞출 수 없다
  - (고객 and/or 상사) is GOD

## 18p

Android 6.0 저전력 대책

## 19p

**Google이 지혜로운 결단(?)**

- 저전력을 위해서 기능을 제공
  - 기능을 가지고 있어도 그다지 사용하지 않는다

↓

- 6.0 부터는 강제적으로 전력소비를 억제한다
  - Doze
  - App Standby

## 20p

**Doze**

- 화면 OFF, 정지상태, 배터리 동작이 일정시간 계속될때에 단말은 Doze(잠시 자는) 모드에 들어간다
  - Doze 중에는 어플 동작에 제한이 걸린다(뒤에 다룹니다)
  - Doze 중, "maintenance window"라는 제한이 해제되는 타이밍이 있고, 그 때에는 제한이 해제된다

> [http://developer.android.com/intl/ko/training/monitoring-device-state/doze-standby.html](http://developer.android.com/intl/ko/training/monitoring-device-state/doze-standby.html)

## 21p

**Doze 중에서의 제한**

- 네트워크 접근 정지
- Wake Lock 무시
- AlarmManager의처리 연기
  - 다음의 maintenance window, 혹은 Doze 해제시에 처리된다
  - Doze 중에도 실행시키는 API도 있다(뒤에 다룹니다)
- Wi-Fi 스캔 없음
- 동기화 (sync adapter) 정지
- Job Scheduler 정지

## 22p

**Doze 중에서의 Alarm 발화**

- API Level 23 이하의 API를 사용하는 것으로, Doze 중일때도 알람을 울릴수 있다
  - setAndAllowWhileIdle()
  - setExactAndAllowWhileIdle()
- 위의 API 사용시, 약 10초간 처리실행이 혀용된다
  - 그사이에 Wake Lock으로 연장 가능
- 하지만, 어플은 짧아도 15분에 1번 간격으로밖에 알름을 설정할 수 없음

## 23p

**Doze 중에서의 Alarm 발화(계속)**

- 그다지 추천하지 않지만, 앞에서의 제한을 회피하는 알람 설정방법도 남아있다
- API Level 21에서 도입된 setAlarmClock()으로 셋팅된 알람은 <font color="red">통상대로</font> 울린다
  - 이 알람이 울리기 전에(shortly before)에, <font color="red">시스템은 Doze에서 빠져나온다</font>

## 24p

**Doze 중에서의 GCM**

- Doze시 통상적인 GCM은 어플에 도달하지 못한다
- Doze시에도 처리되도록, 우선도를 올리는 Flag가 GCM에 추가되어 있다

```
{
  "to" : "...",
  "priority" : "hight",
  "notifiation" : {
    ...
  },
  "data" : {
    ...
  }
}
```

> [https://developers.google.com/cloud-messaging/concept-options](https://developers.google.com/cloud-messaging/concept-options)

## 25p

**Doze 중에서의 GCM(계속)**

- 높은 우선도의 GCM은 실시간 처리가 요구되는 경우에만 이용해야한다
  - Google Play 심사의 영향이나 GCM 이용제한이 될지 여부는 현시점에서는 불명확
  - [https://developers.google.com/cloud-messaging/concept-options](https://developers.google.com/cloud-messaging/concept-options)

## 26p

**Doze 회피 방법의 영향 정리**

|  | 대상 어플 | 이외의 어플 |
| :- | :- | :- |
| AlarmManager setAndAllowWhileIdle() | Doze 일시적 해제 | Doze 유지 |
| setExactAndAllowWhileIdle() | Doze 일시적 해제 | Doze 유지 |
| setAlarmClock() | Doze 해제 | Doze 해제 |
| 높은 우선도 GCM | Doze 일시적 해제 | Doze 유지 |

`AlarmManager#setAlarmClock()은 영향이 크기때문에, 가능한 사용하지않는 것이 바람직하다`

## 27p

**App Standby**

- 어플이 일정기간 명시적으로 이용되지않는 경우, 그 어플을 "Standby 상태"로 둔다
  - 이하가 아니라면 명시적으로 어플이 이용되지않는다고 판정
    - 사용자가 명시적으로 어플을 기동한다
    - 어플이 Forground 상태가 된다
    - 어플이 생성한 알림을 사용자가 본다(연다)
- "Standby 상태"가 된 어플은, 하루에 한번만 네트워크 통신을 실행할 수 없다

## 28p

**어플을 Doze/App Standby 대상밖으로 하는 방법**

- 사용자에 대해서, Whitelist 등록을 요구하는 시스템 다이얼로그를 표시하도록 한다
  - REQUEST_IGNORE_BATTERY_OPTIMAZATIONS 퍼미션을 선언
  - 코드내에서 아래 처리를 호출

```
Intent intent = new Intent();
String packageName = context.getPackageName();
PowerManager pm = (PowerManager)
context.getSystemService(Context.POWER_SERVICE);
if (!pm.isIgnoringBatteryOptimizations(packageName)) {
  intent.setAction(
    Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
  intent.setData(Uri.parse("package:" + packageName)); }
startActivity(intent);
```

## 29p

**Whitelist 등록이 허가되는 조건**

| 종류 | UseCase | GCM 사용가능? | 허가? | 비고 |
| :- | :- | :- | :- | :- |
| Instant Message, 채팅, 호출 | 실시간 메세지가 Doze/App Standby중에도 필수 | O | X | 높은 우선도 GCM을 사용하라 |
| 위 항목 + 법인 VoIP | 위와 같음 | X | O |  |
| Task 자동화 어플 | 어플 코어 기능이 스케쥴되는 자동 Action | 어떤것이라도 된다 (if applicable) | O |  |

- Whitelist에 등록을 요구하는 어플로 Google Play에 공개를 정지된ㄴ 사례의 보고가 있다
  - StackOverflow에서 확인

## 30p

**잠재적 Google Play 리스크**

- AlarmManager#setAlarmClock()
  - 저전력 강화를 위해 Google Play에서 setAlarmClock() 사용 체크를 하게되는 가능성도 생각된다

↓

  - 전력적으로 좋은 어플 사양을 생각한다
    - API Leel 23에서 추가된 AlarmManager API를 사용한다
    - 필요에 따라 높은 우선도 GCM을 이용한다

## 31p

**AlarmManager of Job Scheduler**

- Android 5.0 이상 한정이라면 기본적으로는 Job Scheduler
  - Background 처리에 실시간성이 필수인 어플은 거의 없다
  - 통신 상태에 따라 Job 실행 제어, 단말 재시작시에도 설정한 Job을 남기는 등의 풍부한 설정이 가능
  - PendingIntent를 다루는것 보다 편하다
- Android 5.0 이전버전도 대응해야하는 경우
  - AlarmManager를 이용 OR
  - OS 버전을 체크하고 5.0 이상에서는 JobScheduler를 사용한다

## 32p

**Job Scheduler 사용방법**

- Context#getSystemService()에서 JobScheduler를 취득한다
- JobInfo.Builder로 JonInfo 인스턴스를 생성한다
- 취득한 JonService에 JobInfo 인스턴스를 등록한다

```
Context appContext = getApplicationContext();
JobScheduler scheduler =
  (JobScheduler)appContext.getSystemService(JOB_SCHEDULER_SERVICE);
ComponentName componentName =
  new ComponentName(appContext, MyJobService.class);
JobInfo jobInfo = JobInfo.Builder(jobId, componentName)
  .setPeriod(5000).setNetworkType(JonInfo.NETWORK_TYPE_ANY).build();
scheduler.schedule(jobInfo);
```

## 33p

**JobService**

- 실행하는 Job은 JobService 클래스를 상속한 클래스로 정의한다

```
public class Myservice extends JobService {

  @Override
  public boolean onStartJob(JobParameters params) {
    // TODO: AsyncTask등으로 실제 처리를 별도 스레드에서 실행시킨다

    return true; // true: 별도 스레드에서 처리중, false: 처리 완료
  }

  @Override
  public boolean onStopJob(JobParameters params) {
    // TODO: 시스템으로부터 정지요구가 있다면 별도 스레드 Task를 취소한다
    // 예를들면, onStartJob에서 생성한 AsyncTask에 cancel()를 호출

    return false; // true: Job을 다시 Schedule한다, false: Job을 버린다
  }
}
```

## 34p

**정리**

- Android는 저전력을 위해서 개선을 계속하고 있다
  - 저전력을 위한 API 제공
  - 하드웨어 개선
- 6.0에서 강제적인 저전력을 단행했다
  - 어플 개발자가 저전력에 비협조적이였으므로, Google이 더 이상 참지 못했다

↓

- 어플 개발자는 이후 저전력을 크게 의식한 어플 개발이 요구된다
  - Google을 더 이상 화나게하지 않기위해서라도...

## 35p

시청 감사합니다

## 36p

보조 자료

## 37p

**단말 하드웨어 개선**

- 배터리량 증가
  - Xperia 초기 (1500mAh) → Z2 (3200mAh) → Z5 (2900mAh)
  - 최근 약간 감소경향이 있지만, 초기의 2배 정도
- 프로세서 절전 모드
  - Qualcomm Snapdragon의 절전 모드 대처
    - [http://www.itmedia.co.jp/mobile/articles/1211/30/news032.html](http://www.itmedia.co.jp/mobile/articles/1211/30/news032.html)
- 액정 저전력화
  - IGZO (SHARP)

## 38p

**어플 작성 가이드라인 · 도구**

- Android 어플 작성 가이드라인~효율적인 통신제어를 목표로~(NTT 도코모)
  - [https://www.nttdocomo.co.jp/service/developer/smart_phone/etc/#p01](https://www.nttdocomo.co.jp/service/developer/smart_phone/etc/#p01)
- AT&T Application Resource Optimizer (ARO)
  - [https://developer.att.com/application-resource-optimizer](https://developer.att.com/application-resource-optimizer)
- TS.20 SMARTER APPS FOR SMARTER PHONES V4.0 (GSMA)
  - [http://www.gsma.com/newsroom/all-documents/ts-20-smarter-apps-for-smarter-phones/](http://www.gsma.com/newsroom/all-documents/ts-20-smarter-apps-for-smarter-phones/)

## 39p

**Doze 실현방법**

- Daydream의 하나로서 DozeService가 실시되고 있다
  - Daydream = API Level 17에서 도입된 ScreenSaver 실행을 위한 구조
  - ScreenSaver가 움직일 타이밍에 DozeService가 시작, 나머지 조건이 충족되면 Doze에 들어간다
    - 배터리 동작
    - 일정시간 정지
- 하지만 Car Mode이라면 Doze 모드에는 빠지지않는다

## 40p

**Doze로부터 빠져나오는 조건**

- 화면이 On이 된다
- 펄스(pulse)(※)가 발생한다
  - 하지만 단이 근접상태라면, 가방이나 주머니에 단말이 들어있다고 판단되면 Doze를 유지한다
  - 단말이 움직이고 있어도, 그것이 알림의 진동에 의한 것이라면 무시하고 Doze를 유지한다

(※) 가속도 센서, 픽업 센서 등으로 검축된 동작을 말함

## 41p

**Doze 조정 (단말개발자용)**

- SystemUI내의 DozeParameters.java가 참조하는 conig.xml에서의 파라매터 설정으로 조정이 가능
  - AOSP에서 일부 발췌하여 아래에 표시

```
<!-- Doze: check proximity sensor before pulsing? -->
<bool name="doze_proximity_check_before_pulse">true</bool>

<!-- Doze: duration to avoid false pickup gestures triggered by notification vibrations -->
<integer name="doze_pickup_vibration_threshold">2000</integer>
```

## 42p

**Doze 동작 확인 방법**

- adb를 사용해서 단말을 강제적으로 Doze 모드로 하는것이 가능
  - 디버그시에는 USB 케이블을 연결하고 있으므로, 이상태로는 Doze 상태로는 되지않는다
  - 강제적으로 내부 상태를 배터리로 전환하는 등의 절차가 필요

## 43p

**Doze 동작 확인 방법 (계속)**

- 순서
  - 배터리 모드를 시뮬레이터

```
$ adb shell dumpsys battery unplug
```

  - 화면을 Off로 해서 deviceidle을 IDLE로 이행

```
$ adb shell dumpsys deviceidle step
```  

    - 몇번인가 IDLE이 표시될때까지 호출
    - 이후, step으로 IDLE/IDLE_MAINTENANCE로 변화시키므로 maintenance windows 동작확인도 가능
  - 또는 강제적으로 deviceidle에 이행 (화면 ON인채로)

```
$ adb shell dumpsys deviceidle force-idle
```

## 44p

**Doze 동작 확인 방법 (계속)**

- 원래대로 복원하는 방법
  - 전원접속 상태를 이전으로 돌린다

```
$ adb shell dumpsys battery reset
```

## 45p

**App Standby 동작 확인**

- 비슷하게 App Standby도 시뮬레이터 가능
- 순서
  - 배터리 모드를 시뮬레이터

```
$ adb shell dumpsys battery unplug
```

  - 지정한 패키지 어플을 Standby 상태로 변경

```
$ adb shell am set-inactive <packageName> true
```

## 46p

**App Standby 동작 확인 방법 (계속)**

- 원래대로 복원하는 방법
  - Standby 상태를 해제한다

```
$ adb shell am set-inactive <packageName> false
```

  - 전원 연결 상태를 이전으로 돌린다

```
$ adb shell dumpsys battery reset
```
