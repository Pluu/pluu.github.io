---
layout: post
title: "[번역] DroidKaigi 2016 ~ 퍼포먼스를 요구하는 Android 어플을 만들기 위해서는"
date: 2016-06-06 21:45:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2016 パフォーマンスを追求したAndroidアプリを作るには](https://speakerdeck.com/t_egg/droidkaigi-2016-pahuomansuwozhui-qiu-sitaandroidapuriwozuo-runiha#) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

**퍼포먼스를 요구하는 Android 어플을 만들기 위해서는**

- EGAWA Takashi
- [t.egawa@gmail.com](t.egawa@gmail.com)
- Smartium(주)
- Google Developer Expert

## 2p

**앙케트 : "퍼포먼스 향상"에 대한 인상**

대상 : 수도권 체류 Android 개발자 (5인)

- 귀찮다 · 지루하다 (40%)
- 따분하다 · 어둡다 (20%)
- 정신이 병약해진다 (20%)
- 해도 고마워하지 않는다 (20%)

## 3p

**따분하고 귀찮고 수면에 잘 나타나지 않는 것**

하지만, 개인적으로는 이것을 신경 쓸지 말지가 개발자로서의 가치를 크게 좌우한다 (그런 느낌이 든다)

...그러므로, `이야기하고 싶다`

## 4p

**서론**

- 이야기할 내용
  - 저의 일상적인 대처를 발췌해서 이야기합니다
  - 합리적으로 작업하는 것을 소개합니다
  - 약간 `dumpsys이 많은 부분`을 차지하고 있습니다
- Context
  - SDK를 사용한 일반적인 어플

## 5p

퍼포먼스를 요구하는 Android 어플을 만들기 `위해서 하는 것`

## 6p

**프로그래밍 기술에 대해서는 Udacity에서 배우자**

Study Jams 프로그램의 참가등록은 이쪽 [https://events.withgoogle.com/studyjams-japan-2016/](https://events.withgoogle.com/studyjams-japan-2016/)

Study Jams 프로그램의 참가 등록하고 Udacity의 코스에 등록하고, 전용 온라인 커뮤니티에 참가할 수 있습니다

## 7p

**퍼포먼스에 대한 개인적인 기본원칙**

### 다방면의 관점

퍼포먼스의 지표나 요인은 매일 복잡화되고 있다.

다양한 관점에서의 다방면으로 생각한다

- 전력소비
- UI
- 그 외 (통신, 메모리, 프로세서, 센서 등)

### 측정 · 계속

추측이나 개인적인 생각은 오류를 포함한다 (도시 전설)

설명할 수 없으면 고생한다

일상적으로 무리 없이 한다 (생각되는 것을 한다)

- 기록
- 가시화
- 간단, 가볍게

## 8p

**측정은 충전하지 않은 상태로**

충전되고 있을 때는 디바이스의 동작이 바뀐다. 기본적으로 미충전 상태로 한다

실제로 충전하지 않는 것이 베스트. 안된다면 갱신정지상태를 사용해서 미충전상태를 만든다

```
dumpsys battery unplug 혹은 set usb 0
```

※ 사용이 끝나면 다시 복원할 것 (reset) 을 잊지 않도록

## 9p

**unplug의 오해**

dumpsys battery unplug (혹은 set usb 0) 는 Doze 에서는 `미충전 상태`가 된다.

하지만 배터리 상태 (BatteryManager)로서는 `갱신정지상태`에 불과하다.

그래서, `미충전 상태로 만들고서 갱신정지`로 한다.

- 나쁜 것 : USB로 ABD 접속 -> 갱신정지
- 좋은 것 : WiFi로 ADB 접속 -> 갱신정지 -> USB로 재접속

※ 다만 실제로는 충전되고 있으므로 현실의 미충전과는 엄밀하게 다르다

## 10p

소비전력에 대해서

## 11p

배터리의 여유와 마음의 여유

전력소비는 가장 중요한 퍼포먼스 지표

## 12p

질문

## 13p

**Nexus5를 이용해**

카메라의 `플래시 라이트`를 `하루 종일` 사용 가능한 어플을 만들고 싶다

실현 가능한가?

그러면 반나절이라면? 6시간은?

## 14p

**Nexus5의 경우**

플래시 라이트의 소비전류 `대략 540 mA`

배터리 방전용량 `2300 mAh`

이론상 `4시간` 정도 (2300 / 540 ≒ 4.2)

당연하지만, 실제로는 다른 어플이나 다른 기기의 소비전력에 의존하므로 더욱 줄어듭니다.

## 15p

**전류소비량을 알기 위해서는**

- framework-res.apk
  - `리소스들의 정의`를 하는 시스템 apk
  - /system/framework/framework-res.apk
- res/xml/power_profile.xml
  - `소비전력량`을 정의한 XML 파일
  - framework-res.apk 내에 있음

## 16p

```
<?xml version="1.0" encoding="utf-8"?>
<device name="Android">
    <item name="none">0</item>
    <item name="screen.on">82.75</item>
    <item name="screen.full">201.16</item>
    <item name="camera.avg">804.85</item>
    <item name="camera.flashlight">546.37</item>
    <item name="bluetooth.active">51.55</item>
    <item name="bluetooth.on">0.79</item>
    <item name="wifi.on">3.5</item>
    <item name="wifi.active">73.24</item>
    <item name="wifi.scan">75.48</item>
    ...
    <item name="gps.on">76.23</item>
    <item name="radio.active">185.19</item>
    <item name="radio.scanning">99.2</item>
    <array name="radio.on">
        <value>4.8</value>
        <value>1.11</value>
    </array>
    <array name="cpu.speeds">
    ...
    </array>
    <item name="battery.capacity">2300</item>
    ...
</device>
```

※ 단위는 mA

## 17p

**소비전력 기준을 파악 · 이해**

최근 하드웨어 기능

| :- | :- | :- | :- |
| NFC | 라디오 | 라이트 | 심장박동 |
| 자이로 | 전화 | 배터리 온도 | 조도 |
| 가속도 | 카메라 | 마이크 | 기온 |
| Bluetooth | GPS | 터치패널 | 습도 |
| Wifi | 자기 | 지문 | 기압 |

- 최근 디바이스 하드웨어 기능은 풍부
- 다양한 기능의 복합에 따라 전력은 소비된다
- 각각 어느 정도 전류 소비하는가를 파악해둔다
- 퍼포먼스를 최적화시 전체를 보는 습관을 지닌다

## 18p

**dumpsys batterystats**

배터리의 다양한 정보를 보는 것이 가능해 매우 편리

매일 봐도 질리지 않는 레벨

## 19p ~ 23p

**dumpsys batterystats --charged**

1. 1% 마다 배터리 소비의 추이 · 상태 내역
2. 매일의 Summary
3. 이전 충전부터의 Summary
4. 현재 전력소비의 예상
5. 어플마다 (Facebook Messenger의 예)
  - 2시간 2분 19초간 Foreground 상태는 약 `35초`
  - CPU를 소비한 것은 `11초` 정도

## 24p

보는 건 귀찮다

## 25p

Battery Historian

## 26p

**Battery Historian**

- 배터리 소비의 가시화 도구
  - 최신판은 2.0, Go lang가 필요

```
# 다운로드
$ go get -u github.com/google/battery-historian/...
$ cd $GOPATH/src/github.com/google/battery-historian
# 컴파일
$ bash setup.sh
# 서버 기동 디폴트는 포트 9999
$ go run cmd/battery-historian/battery-historian.go
# 총계정보취득
$ adb bugreport > hoge.txt
```

[http://localhost:9999](http://localhost:9999)에 접근해서 얻은 총계정보 (hoge.txt)를 업로드하면 볼 수 있다

## 27p

**Background에서의 소비**

Android의 특징으로서 소비전력의 `5~7할`은 IDLE시에 소비되는 경향 (라고 한다)

Background에서의 소비를 줄이는 것이 중요

## 28p

**JobScheduler**

- 배터리에 친절한 Job 실행 API (android 5.0부터)
  - 배터리에 친절한 Scheduler를 실행하는 API
  - TASK의 BackOff아 실행조건 등 유연한 지정이 가능
  - 즉시성이 없는 Background 처리에 최적
  - 사용할 수 있다면 쓰지 않을 리는 없다

```
JobInfo uploadTask = new JobInfo.Builder(mJobId, mServiceComponent)
        .setRequiredNetworkCapabilities(JobInfo.NETWORK_TYPE_UNMETERED)
        .build();

JobScheduler jobScheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
jobScheduler.schedule(uploadTask);
```

## 29p

**GCM Network Manager**

- JobScheduler를 대신하여 사용 가능한 Job API
  - JobScheduler는 5.0 이후 / 이것은 2.3부터 사용 가능
  - Google Play Services 필수
  - GCM 라이브러리에 의존
  - 하지만 GCM 기능을 사용하지 않는 어플에서도 사용할 수 있다

```
mGcmNetworkManager = GcmNetworkManager.getInstance(this);
OneoffTask task = new OneoffTask.Builder()
        .setService(MyTaskService.class)
        .setTag(TASK_TAG_WIFI)
        .setExecutionWindow(0L, 3600L)
        .setRequiredNetwork(Task.NETWORK_TYPE_UNMETERED)
        .build();

mGcmNetworkManager.schedule(task);
```

## 30p ~ 31p

**Doze Framework**

- 소비전력 감소 구조 (Android 6.0부터)
  - 명시적인 타임슬롯을 할당하여 Background에서의 거동을 제한함으로 소비전력을 감소한다

> [http://developer.android.com/intl/ja/training/monitoring-device-state/doze-standby.html](http://developer.android.com/intl/ja/training/monitoring-device-state/doze-standby.html)

> Doze에 대해서는 中西良明(@chun_ryo)님의 어제 발표자료가 알기 쉬우므로 그것을 권장합니다!
Android의 저전력에 대한 생각 [https://goo.gl/yxBYOH](https://goo.gl/yxBYOH)

## 32p

**Doze의 상태 개요**

ACTIVE --화면을 끈다--> INACTIVE
       --일정 시간 경과 (30분)--> IDLE_PENDING
       --일정 시간 경과 (30분)--> IDLE (※ IDLE중에는 여러가지가 중지된다)
       --일정 시간 경과 (점점 길어진다, 1시간, 2시간 ... 6시간)--> IDEL_MAINTENANCE (※ 처리가능한 영역)
       --화면을 켠다 ...등--> ACTIVE

## 33p

**상태 확인**

```
$ dumpsys deviceidle
```

## 34p ~ 35p

**강제상태 변경**

```
$ dumpsys deviceidle step
```

> Doze에 대해서는 中西良明(@chun_ryo)님의 어제 발표자료가 알기 쉬우므로 그것을 권장합니다!
Android의 저전력에 대한 생각 [https://goo.gl/yxBYOH](https://goo.gl/yxBYOH)

## 36p

UI에 대해서

## 37p

많은 퍼포먼스 지표는 UI에 귀결하여 나타나고 있다.

## 38p

**시간과 사용자의 반응 지표**

`250ms`이하를 유지하면 사용자는 빠르다고 느낄 수 있다

`1초`이하를 유지하면 사용자는 집중력을 유지한다

| 지연시간 | 사용자 반응 |
| :-: | :-: |
| 0 - 100ms | Instant |
| 100 - 300ms | Feel sluggish |
| 300ms - 1s | Machine is working... |
| 1s + | Mental context switch |
| 10s + | I'll come back later... |

> Breaking the 1000ms Time to glass Mobile Barrier : [https://www.youtube.com/watch?v=Il4swGfTOSM](https://www.youtube.com/watch?v=Il4swGfTOSM)

## 39p ~ 40p

**렌더링 역사**

| :- | :- |
| GingerBread이전 | CPU 사용 |
| Honeycomb | 하드웨어 가속 추가 |
| ICS | 하드웨어 가속이 디폴트 |
| JellyBean | VSYNC로 프레임 최적화 |

> 이 부분은 대략 60fps로 그린다

## 41p

**Jank**

최근 많은 디바이스에서는 `60fps`로 그려진다고 생각할 수 있다

즉 `16 - 17ms`마다 1회

렌더링이 맞추지 못하면, `Jank`가 발생한다

```
Skipped 136 frames! The application may be doing too much work on its main thread.
```

`Jank`가 발생하면 프레임이 Skip 된다

많은 경우, 애니메이션 생략이나 Jump라는 형태로 사용자에게 보인다

`Jank`를 피하는 (줄이는) 것이 중요

## 42p ~ 43p

**View의 렌더링**

3단계

Measure -> Layout -> Draw

Hierarchy Viewer로 가시화 가능

## 44p

**Nest에 의한 Remeasure**

- Draw에 가장 시간이 걸리는 상태가 일반적
- Measure가 느리는 경우는 대책하는 가치가 있다
- 원인은 대개 레이아웃의 Nest

※ RelativeLayout이나 LinearLayout를 중첩하면 Measure가 여러 번 실행되는 것에 의해

예)

| Nest한 상태 | 개선 후 |
| :- | :- |
| Measure: 33.3338ms | Measure: 0.548ms |
| Layout: 2.810ms | Layout: 0.210ms |
| Draw: 9.526ms | Draw: 2.0.46ms |

## 45p

**Overdraw 회피**

- Draw가 늦는 경우는 `Overdraw`를 의심하는 것이 좋다 (좋았다)
  - Overdraw: 다른 View가 그린 영역을 또 다른 View가 다시 그리는 것
- 개발자용 옵션 -> GPU Overdraw를 Debug
- 빨간 화면에서 파란것으로 노력하면 2배 빨라지는 인상 (개인적으로)
- Kitkat이후는 단순한 Overdraw는 자동으로 무시되므로 그다지 신경질적으로 되지 않는다
- Hierarchy Viewer로 PDS 파일에 출력해서 확인하는 방법도 추천

> [http://developer.android.com/intl/ja/tools/performance/debug-gpu-overdraw/index.html](http://developer.android.com/intl/ja/tools/performance/debug-gpu-overdraw/index.html)

## 46p

**GPU Profiling**

- 개발자용 옵션 -> GPU 렌더링 프로파일 작성
- 화면 하단에 선을 표시

> 16ms Border : 대략 이보다 아래에 맞추면 문제없다

| 색 | 설명 |
| :-: | :- |
| Blue | View의 생성. View 개수나 onDraw 처리에 의존 |
| Purple | 그리는 리소스 전송 |
| Orange  | GPU 처리를 CPU가 기다리는 시간 |
| Green | VSYNC의 연기 |
| Red | GPU의 그리기 실행 |

## 47p ~ 48p

**dumpsys gfxinfo**

- 그리는 상황을 출력한다
- Marshmallow부터 `Jank` 정보가 나오므로 추천

```
dumpsys gfxinfo com.android.chrome
```

- `framestats` 옵션을 적용함으로 CSV로 나온다
  - 어떤 보고를 하고 싶은 사람에게 좋음

```
dumpsys gfxinfo com.android.chrome framestats
```

## 49p

그 외 (통신, 메모리, 프로세서)

## 50p

**통신 최적화**

본격적으로 다루기에는 상당히 어려운 인상

- 어려운 이유
  - 셀룰러(4G, 3G)와 WiFi의 Latency나 소비전력 차이
  - 통신 프로토콜 차이
  - 서버에도 의존한다 ... 등

개인적으로 `간단한 어프로치`로서는 ...

- 나은 통신 라이브러리 / 캐시 라이브러리를 사용
- 나은 프로토콜 사용
- 나은 서버 (Product)를 사용
- 그 후에 측정하고, 문제가 있으면 개선을 생각

## 51p

**AT&T ARO**

- Application Resource Optimizer
  - AT&T 제작 통신 최적화 도구
  - rooted 필요

매우 추천

이걸로 Green이 아닌 항목을 보면 되므로 간단

> [http://developer.att.com/application-resource-optimizer](http://developer.att.com/application-resource-optimizerv)

## 52p

**ARO 평가항목**

- File Download: Text File Compression
- File Download: Duplicate Content
- File Download: Cache Control
- File Download: Cache Expiration
- File Download: Combine JavaScript and CSS Requests
- File Download: Resize Largee Images for Mobile
- File Download: Minify CSS, JS, and HTML
- File Download: Use CSS Sprites for Images
- Connections: Connection Opening
- Connections: Unnecessary Connections - Multiple Simultaneous Connections
- Connections: Inefficient Connections - Periodic Transfers
- Connections: Inefficient Connections - Screen Rotation
- Connections: Inefficient Connections - Connection Closing Problems
- Connections: 400, 500 HTTP Status Response Codes
- Connections: 301, 302 HTTP Status Response Codes
- Connections: 3rd Party Scripts
- HTML: Asynchronous Load of JavaScript in HTML
- HTML: HTTP 1.0 Usage
- HTML: File Order
- HTML: Empty Source and Link Attributes
- HTML: FLASH
- HTML: "display:none" in CSS
- Other: Accessing Peripheral Applications

다양한 통신의 통계 수집 · 가시화이나 통계와 대응한 조작 녹화도 가능

## 53p

**메모리 최적화**

이것도 통신과 같게 본격적으로 다루는 것은 상당히 어렵다

- 어려운 이유:
  - GC 구조의 차이 (STW -> 병렬GC -> ART -> Compacting GC..)
  - 메모리 영역의 종류 차이
  - 디바이스 · 버전에 따른 메모리 용량 차이 등

개인적으로 `간단한 어프로치`로서는 ...

- GC로 pause는 (그다지) 안보인다
  - UI가 충분히 그려진다면 대부분 괜찮다
- Memory Leak만은 제대로 점검한다

## 54p

**dumpsys meminfo**

디자이스 전체의 메모리 사용량 Summary

## 55p

**dumpsys meminfo [pid]**

지정한 프로세스 ID 메모리 사용량

## 56p

**dumpsys procstats [package]**

지정한 어플의 최근 3시간, 최근 24시간의 메모리 사용량 총계 (스크린 On/Off시 등 복수 축으로)

## 57p

**Memory Leak 검출**

Heap dump, Allocation Tracker, Memory Analyzer Tool (MAT) 등이 지름길

## 58p

**개인적인 추천은 LeakCanary**

- Square사 [https://github.com/square/leakcanary](https://github.com/square/leakcanary)
- 상당히 간단하게 정밀한 Memory Leak 검출이 가능
- 어플에 약간의 측정 코드를 포함할 필요가 있다
  - 코드를 포함해도 괜찮은 상황이라면 안쓸리 없다

> [https://corner.squareup.com/2015/05/leak-canary.html](https://corner.squareup.com/2015/05/leak-canary.html)

## 59p

**onTrimMemory**

※ 저는 사용하지 않지만, 사용하고 있는 사람 있습니까?

## 60p

**CPU 최적화 (?)**

라고 해도...

- 최근 ARM 기반 칩셋으로는 처리하는 Task에 따라 할당되는 CPU가 바뀌는 형태 (big.LITTLE Architecture)가 주류. 클럭 주파수도 최적화된다
- 어느새 일반적인 어플리케이션에서는 CPU 최적화를 개발자가 신경쓰지 않아도 된 시대

개인적으로는 어플 개발자로서는

대부분 `ANR`이나 `jank`를 막는 목적으로 어플의 프로세스나 스레드가 어느 정도 CPU를 이용하고 있는가를 파악해두면 좋다고 생각된다.

## 61p

**dumpsys cpuinfo**

디바이스 전체의 CPU 사용량
  - 최근 1분 / 5분 / 15분 로드량
  - 최근 7초의 프로세스마다 사용량

※ 비슷한 것은 개발자용 옵션 -> CPU 사용량 표시로도 가능

## 62p

**Systrace**

CPU 사용량을 가시화하는 지름길 도구

Jank도 알기 쉽다

> [http://developer.android.com/intl/ja/tools/debugging/systrace.html](http://developer.android.com/intl/ja/tools/debugging/systrace.html)

## 63p

**Trepn Power Profiler**

- Qualcomm사의 프로파일링 도구
  - [http://developer.qualcomm.com/software/trepn-power-profiler](http://developer.qualcomm.com/software/trepn-power-profiler)
- Qualcomm 프로세서의 디바이스만 동작하지만, 해당 디바이스라면 상당히 자세한 정보를 간단하게 얻을 수 있다
- CPU나 GPU의 정보에 대해서는 개인적으로 추천
- 메모리나 통신 (Bluetooth도)도 가시화 가능

## 64p

마지막으로

## 65p

- 비기능을 신경 쓰자
  - 비기능은 수면에 나오지 않지만
  - 비기능을 신경 쓸지 말지가 개발자로서의 가치를 크게 좌우한다 (그런 느낌)
- 복수의 관점으로 보는 것이 중요
  - 모바일 디바이스는 그런 물건
  - 추측은 그다지 도움이 안된다. 가시화, 측정이 중요
- 누적이 중요
  - 방 청소와 같다
  - 매일 조금씩 신경쓰면 깨끗한 상태
  - 조금씩이라도 이어나간다 (계속 이어나가도록 한다)
