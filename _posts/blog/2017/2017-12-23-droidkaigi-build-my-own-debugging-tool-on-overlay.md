---
layout: post
title: "[번역] DroidKaigi 2017 ~ Build my own debugging tool on overlay"
date: 2017-12-23 17:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ Build my own debugging tool on overlay](https://speakerdeck.com/keithyokoma/build-my-own-debugging-tool-on-overlay) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Build my own debugging tool on overlay

Keishin Yokomaku

~ DroidKaigi 2017 DAY.02 - Room 2

## 2p, About me

- 横幕圭真 (Keishin Yokomaku)
- Drivemode, Inc. / 엔지니어
- KithYokoma: [GitHub](https://github.com/keithyokoma) / [Twitter](https://twitter.com/keithyokoma) / [Qiita](https://qiita.com/keithyokoma) / [Stack Overflow](https://stackoverflow.com/users/1736646/keithyokoma)
   - Books: [Android Academia](https://booth.pm/ja/items/299593) / [AZ 색다른 책(異本)](https://booth.pm/ja/items/275296) / [무지개색 Android](https://booth.pm/ja/items/392257)
   - Fun : 기계체조 / 자전거 / 사진 / 근육 운동 / 🍻 / 🍶
   - Today's Quote: "Happy DroidKaigi!"

## 3p

 BUILDING MY OWN DEBUGGING TOOL ON OVERLAY

## 4p, 서론으로

 - 이 내용에는 약간 흑마술 같은 내용이 들어있습니다
 - 응용할 시, 사용법 · 사용 정도를 지키면서 즐겁게 사용해 주세요

## 5p ~ 7p, 이건 뭐지? 

- 항상 앞에 계속 표시되는 View
   - 개발자 옵션
   - 어떤 앱을 열어도 보인다
   - 정기적으로 정보를 갱신된다

> 내가 만들고 싶어 😄

## 8p ~ 12p, 어떻게 만드는가

- 하는 것
   - 특별한 Layer에 View를 표시한다
   - Background에서 View를 계속 갱신한다
- 고려해야 할 것
   - 프로세스를 계속 움직인다
   - Activity 등을 연결한다

  ## 13p, 본론으로 들어가기 전에

  - DroidKaigi 앱에 샘플 구현을 넣어봤습니다
     - Repogitory : [http://bit.ly/2lGA6Aj](http://bit.ly/2lGA6Aj)
     - 설정 -> Developer Menu -> Debug Overlay View
     - 언어 설정을 변경하거나, 화면 회전하는 등...

## 14p

 특별한 Layer에 View를 표시한다

## 15p ~ 17p 언급되는 Class

- [android.view.WindowManager](https://developer.android.com/reference/android/view/WindowManager.html)
   - System Service
   - View를 추가 · 삭제 · 갱신하는 메소드를 가진다
 - [android.view.WindowManager.LayoutParams](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html)
    - WindowManager에서 그릴 View를 위한 Parameter

## 18p, WindowManager와 Permission

- 특별한 Permission
   - "다른 앱에 중첩되어 표시"
   - `<uses-permission>`
      - android.permission.SYSTEM_ALERT_WINDOW
   - 설치 시에 자동으로 허가된다
   - 추후에 사용을 취소할 수도 있다

## 19p, WindowManager와 Permission

- 설정 화면을 여는 Intent Action
    - [android.settings.action.MANAGE_OVERLAY_PERMISSION](https://developer.android.com/reference/android/provider/Settings.html#ACTION_MANAGE_OVERLAY_PERMISSION)
- 허가 여부를 체크하는 메소드
    - [Settings.canDrawOverlays(Context)](https://developer.android.com/reference/android/provider/Settings.html#canDrawOverlays(android.content.Context))
- Permission을 얻은 앱의 프로세스가 살아있으면 다른 앱의 설치 버튼을 누를수 없게되는 점을 주의

## 20p, WindowManager 메소드

- [WindowManager#addView(View, LayoutParams)](https://developer.android.com/reference/android/view/ViewManager.html#addView)
   - View 추가
- [WindowManager#removeView(View)](https://developer.android.com/reference/android/view/ViewManager.html#removeView(android.view.View))
   - View 삭제
- [WindowManager#updateViewLayout(View, LayoutParams)](https://developer.android.com/reference/android/view/ViewManager.html#updateViewLayout)
   - View Parameter 갱신

## 21p, WindowManager에서 사용하는 Parameter

- WindowManager.LayoutParams
   - 세로 · 가로 사이즈
   - Layer
   - Flag
   - Pixel Format

## 22p ~ 23p, WindowManager Layer

- TYPE_SYSTEM_ERROR 
- TYPE_SYSTEM_OVERLAY
- TYPE_KEYGUARD_DIALOG
- TYPE_INPUT_METHOD
- TYPE_SYSTEM_ALERT
- TYPE_TOAST
- TYPE_SYSTEM_DIALOG
- TYPE_PHONE
- TYPE_APPLICATION
- TYPE_WALLPAPER

> 너무 많다 😂😂

## 24p, (아마도) 자주 사용하는 WindowManager Layer

- TYPE_SYSTEM_OVERLAY
- TYPE_SYSTEM_ALERT
- TYPE_SYSTEM_DIALOG
- TYPE_APPLICATION

## 25p, (아마도) 자주 사용하는 WindowManager Layer

- [TYPE_SYSTEM_OVERLAY](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#TYPE_SYSTEM_OVERLAY)
   - 잠금 화면의 위. 터치 이벤트를 취득하면 안 됨
- [TYPE_SYSTEM_ALERT](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#TYPE_SYSTEM_ALERT)
   - Toast 보다 위
- [TYPE_SYSTEM_DIALOG](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#TYPE_SYSTEM_DIALOG)
   - 애플리케이션 보다 위

## 26p, (아마도) 자주 사용하는 WindowManager Layer

- WindowManager에 추가하는 View의 동작을 정한다
   - 터치 이벤트나 포커스 취득을 할지 여부
   - 영역 밖의 그리기 여부

## 27p, 터치 이벤트나 포커스 Flag

- [FLAG_NOT_FOCUSABLE](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_NOT_FOCUSABLE)
   - 포커스를 뺏지 않는다
   - FLAG_NOT_TOUCH_MODAL 도 자동으로 추가된다
- [FLAG_NOT_TOUCH_MODAL](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_NOT_TOUCH_MODAL)
   - WindowManager 에 추가한 View 영역 밖의 터치 이벤트를 Background 앱에 보낸다

## 28p, 터치 이벤트나 포커스 Flag

- [FLAG_NOT_TOUCHABLE](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_NOT_TOUCHABLE)
   - 터치 이벤트를 모두 Background 앱에 보낸다

## 29p, 영역 밖의 그리기 여부를 정하는 Flag

- [FLAG_LAYOUT_IN_SCREEN](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_LAYOUT_IN_SCREEN)
   - 화면 사이즈가 View 크기의 최대치가 된다
- [FLAG_LAYOUT_NO_LIMITS](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html#FLAG_LAYOUT_NO_LIMITS)
   - 화면 사이즈를 넘어 View 사이즈를 설정할 수 있다
   - 왼쪽 위를 원점으로 해서, 마이너스 방향에도 View를 배치할 수 있다

## 30p, PixelFormat

- 그리려는 View의 픽셀이 가지는 알파값
   - [android.graphics.PixelFormat](https://developer.android.com/reference/android/graphics/PixelFormat.html)
      - [OPAQUE](https://developer.android.com/reference/android/graphics/PixelFormat.html#OPAQUE) : 알파값 없음 · 불투명
      - [TRANSLUCENT](https://developer.android.com/reference/android/graphics/PixelFormat.html#TRANSLUCENT) : 복수 비트로 픽셀값 표현
      - [TRANSPARENT](https://developer.android.com/reference/android/graphics/PixelFormat.html#TRANSPARENT) : 최저 1비트로 알파값 표현

## 31p ~ 36p, View 추가 코드

```
public class MainActivity extends Activity {
   private View mOverlayView;
   private WindowManager mWindowManager;

   @Override
   protected void onCreate(Bundle icicle) {
      // ……
      WindowManager.LayoutParams p = new WM.LP(
         WRAP_CONTENT, WRAP_CONTENT, TYPE_SYSTEM_DIALOG,
         FLAG_NOT_FOCUSABLE, PicelFormat.TRANSLUCENT
      );
      mWindowManager.addView(mOverlayView, p);
   }
}
```

## 37p ~ 38p, View 삭제 코드

```
public class MainActivity extends Activity {
   private View mOverlayView;
   private WindowManager mWindowManager;

   @Override
   protected void onDestroy() {
      // ……
      mWindowManager.removeView(mOverlayView);
   }
}
```

## 39p, 그리려는 View 관리

- WindowManager는 View의 추가·삭제·갱신만 한다
   - 어느 타이밍에 추가·삭제·갱신할지는 스스로 관리
   - WindowManager에 findViewById같은 것은 없다
   - View의 인스턴스를 멤버가 가지지 않으면 삭제할 수 없다
   - View 프로퍼티 변경을 위해서도 필요

## 40p, 모든 것은 View 이다

## 41p ~ 42p, 다른 앱에도 View를 겹치고 싶다?

- Activity로 관리하는 경우는 자신의 앱밖에 올릴 수 없다
   - Lifecycle을 넘은 View 관리를 할 필요성
   - View 자체는 Activity와 독립되어 있다
   - Lifecycle을 넘을 수 있는 View 관리 방법?
      - Service

## 43p

Background에서 View를 계속 갱신

## 44p, Background에서 View를 계속 표시하려면?

- View는 Service로도 생성할 수 있다
   - Service는 Main Thread에서 동작한다
- Activity와는 다른 Lifecycle로 움직인다
   - Background에서 항상 움직일 수 있다

→ Service로 View를 WindowManager에 건네면 다른 앱에 겹쳐서 계속 표시할 수 있다

## 45p, Service로 View를 그릴 때의 설계

- 그리려는 View의 Lifecycle 관리
   - `Activity가 해주는 것을 Service로 재구현한다`
      - Lifecycle 시작 : Service#onCreate 등
      - Lifecycle 종료 : Service#onDestroy
      - ConfigurationChange : BroadcastReceiver

## 46p ~ 47p, Sort of …

```
<manifest package=“”>
   <application>
      <activity
         android:name=“.MyActivity”
         android:configChanges=“keyboard|
         keyboardHidden|screenLayout|screenSize|
         orientation|density|fontScale|layoutDirection|
         locale|mcc|mnc|navigation|smallestScreenSize|
         touchScreen|uiMode”/>
   </application>
</manifest>
```

## 48p, Service로 View를 그릴 때의 설계

- DroidKaigi 앱으로 구현
   - [OverlayViewManager](https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/service/helper/OverlayViewManager.java)
      - Service내에서 View의 Lifecycle을 가지고 있다
      - 화면 이동 등은 미고려
- 화면 이동 등을 포함한 View 기반의 화면 구축 프레임워크
   - e.g. [square/flow](https://github.com/square/flow) and [square/mortar](https://github.com/square/mortar)

## 49p, Service로 View를 그릴때의 설계

| Service |  | OverlayViewManager |  | WindowManager |
| :--: | :--: | :--: | :--: | :--: |
| onCreate | ▶ | create | ▶ | addView |
| configChanges | ▶ | configChanges | ▶ | updateViewLayout | 
| onDestroy | ▶ | destroy | ▶ | removeView |

## 50p, OverlayViewManger 가 하는 것

- [OverlayViewManger#create](https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/service/helper/OverlayViewManager.java#L39)
   - WindowManager#addView 를 호출
- [OverlayViewManger#changeConfiguration](https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/service/helper/OverlayViewManager.java#L46)
   - WindowManager#updateViewLayout 를 호출
- [OverlayViewManger#destroy](https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/service/helper/OverlayViewManager.java#L52)
   - WindowManager#removeView 를 호출

## 51p ~ 52p, OverlayViewManager 구현

```
public class OverlayViewManager {
   private final Context mContext; // Service
   private final WindowManager mWindowManager;
   private final WindowManager.LayoutParams mParams;
   private View mRootView;

   public void create() {
      mRootView = LayoutInflater.from(mContext).inflate(R.layout.view_root_overlay, null, false);
      mWindowManager.addView(mRootView, mParams)
   }
}
```

## 53p, Service로 ConfigurationChange를 다루기

- BroadcastReceiver 로 ConfigurationChange 를 탐지
   - BroadcastReceiver#onReceive 로 View 를 다시 그리기
   - ref. WindowManager#updateViewLayout

## 54p, Service로 ConfigurationChange를 다루기

```
public class OverlayViewService extends Service {
   private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
      @Override
      public void onReceive(Context c, Intent i) {
         mOverlayViewManager.changeConfiguration();
      }
   }
}
```

## 55p ~ 56p, Service로 ConfigurationChange를 다루기

```
public class OverlayViewService extends Service {
   private final BroadcastReceiver mReceiver = //…

   @Override
   public void onCreate() {
      //……
      IntentFilter filter = new IntentFilter(Intent.ACTION_CONFIGURATION_CHANGE);
      registerReceiver(mReceiver, filter);
   }
}
```

## 57p, Service로 ConfigurationChange를 다루기

```
public class OverlayViewService extends Service {
   private final BroadcastReceiver mReceiver = //…

   @Override
   public void onDestroy() {
      //……
      unregisterReceiver(mReceiver);
   }
}
```

## 58p, LayoutInflater.from(Context) 의 매개변수

- Context로부터 LayoutInflater를 꺼낸다
   - LayoutInflater로부터 생성된 View는 항상 같지 않다
   - Context에따라 동작이 다르다
   - 적절한 Context를 사용하지 않으면 모양이 바뀐다

## 59p, Activity 와 Service 의 차이

- Activity
   - [ContextThemeWrapper](https://developer.android.com/reference/android/view/ContextThemeWrapper.html) 의 자식 클래스
   - 테마로 설정한 속성값을 가지고 있다
- Service
   - [ContextWrapper](https://developer.android.com/reference/android/content/ContextWrapper.html) 의 자식 클래스
   - 테마는 없다

## 60p, Context의 Wrapper

- Service를 ContextThemeWrapper로 Wrapper 하자
   - Composite 패턴
   - Wrapper 한 Context를 사용하면 Service 내에서도 테마가 적용된다

## 61p ~ 62p, 다시 OverlayViewManager 구현

```
public class OverlayViewManager {
   private final Context mContext; // Service
   private Context mThemedContext;
   private View mRootView;

   public void create() {
      mThemedContext = new OverlayViewContext(mContext);
      mRootView = LayoutInflater.from(mThemedContext).inflate(R.layout.view_root_overlay, null, false);
   }
}
```

## 63p ~ 64p, 다시 OverlayViewManager 구현

```
/* package */ class OverlayViewContext extends ContextThemeWrapper {
   public OverlayViewContext(Context base) {
      super(context, R.style.AppTheme);
   }
}
```

## 65p, 다시 OverlayViewManager 구현

```
/* package */ class OverlayViewContext extends ContextThemeWrapper {
   private LayoutInflater mInflater;

   @Override
   public Object getSystemServcie(String name) {
      // ……
   }
}
```

## 66p ~ 69p, 다시 OverlayViewManager 구현

```
private LayoutInflater mInflater;

@Override
public Object getSystemServcie(String name) {
   if (LAYOUT_INFLATER_SERVICE.equals(name)) {
      if (mInflater == null) {
         mInflater = LayoutInflater.from(
         getBaseContext()).cloneInContext(this);
      }
      return mInflater;
   }
   return super.getSystemService(name);
}
```

## 70p, Service 종료와 프로세스 종료

- Service가 움직이는 한 프로세스는 살아 있다
   - Service를 멈추는 방법
      - Context#stopService(Intent)
      - Service#stopSelf()
- 프로세스를 멈추기위해 사용자가 취하는 행동
   - Task List 에서 앱을 지운다

## 71p, Service 종료와 프로세스 종료

- Task List 에서 앱을 종료
   - [Service#onTaskRemoved](https://developer.android.com/reference/android/app/Service.html#onTaskRemoved(android.content.Intent))
   - 여기에서 Service를 멈추지 않으면 프로세스는 계속 살아있다
   - 왠지모르게 계속 살아있는 앱이 있다 => ☆1

## 72p ~ 73p, Service 종료와 프로세스 종료

- 시스템이 강제적으로 프로세스를 종료하는 경우도 있다
   - 표시하고 있던 View가 갑자기 없어진다
   - 사용자의 상호 작용이 있을 때는 치명적...
   - 가능한 프로세스를 오래살리고 싶다

## 74p

프로세스를 계속 움직이게 한다

## 75p, Android 에서 프로세스의 우선순위

- 4종류의 우선순위
   - Foreground Process
   - Visible Process
   - Service Process
   - Cached Process
- 아래일수록 우선순위도 낮으므로, kill의 대상이 된다

## 76p ~ 77p, Android 에서 프로세스의 우선순위

- Service가 관련된 프로세스의 우선순위
   - Visible Process
   - Service Process
- 어떻게든 Visible Process에 승격하면 오래 살수 있다

## 78p, Service Process

- Service#startService로 상주하는 Service를 가지는 프로세스
   - 메모리가 모자라면 kill 된다
   - 오래 살 수 있는 프로세스는 kill의 대상이 된다
      - 만약 메모리 누수 등으로 Service가 정상적으로 종료하지 못하는 경우에 메모리를 계속 소유하므로

## 79p, Android 에서 프로세스의 우선순위

- Service가 관련된 프로세스의 우선순위
   - Visible Process
   - Service Process
- 어떻게든 Visible Process에 승격하면 오래 살 수 있다

## 80p ~ 81p, Visible Process

- 사용자에게 중요한 정보를 표시하는 프로세스
   - e.g. 다이얼로그의 뒷면에 있는 Activity를 가지고 있다
   - e.g. Service#startForeground로 알림을 보내고 있다
- WindowManager에 View를 만들어도 직접적으로 Visible Process가 되지 않는다

## 82p, 메모리에 상냥한 Service

- Visible Service 이라도 메모리가 부족하면 kill 된다
   - 메모리에 상냥한 Service를 만들자
   - 메모리 누수에는 주의
   - Service에도 Lifecycle이 있다는 점에 유의
   - 화면 전환을 만들 경우, 매번 필요 없는 View를 remove 한다

## 83p ~ 84p, 겹쳐진 View에 정보를 표시한다

- 구축한 View에 데이터를 넘기고 싶다
   - 디버그용 정보를 보낸다
   - 앱에 여러 부분으로부터 데이터를 넘기는 설계가 필요

## 85p

Activity 등과 연결

## 86p, Service에 연결하는 3가지 방법

- Service에 데이터를 전달하는 3가지 방법
   - startService의 Intent에 데이터를 넣는다
   - EventBus 를 활용해 데이터를 넘긴다
   - Dagger 등의 DI로 Scope를 끊는다 & Rx 를 사용한다

## 86p, startService의 Intent에 데이터를 넣는다

- Intent#putExtra()를 활용
   - [Service#onStartCommand()](http://www.apple.com/jp) 로 받는다
- pros & cons
   - Android 프레임워크 구조로 완결
   - 데이터 타입에 Parcelable 구현이 필요
   - View를 관리하는 추상 계층에 구체적인 처리가 들어간다

## 87p ~ 90p, startService의 Intent에 데이터를 넣는다

```
public class DebugOverlayService extends Service {
   public static final String EXTRA_DATA = // ……
   private OverlayViewManager mManager;

   @Override
   public int onStartCommand(Intent i, int flags, int startId) {
      // ……
      Data data = i.getParcelableExtra(EXTRA_DATA);
      mManager.onReceiveData(data);
   }
}
```

## 91p, EventBus 를 활용해 데이터를 넘긴다

- [greenrobot/EventBus](https://github.com/greenrobot/EventBus), [square/otto](https://github.com/square/otto), [reactivex/RxJava](https://github.com/ReactiveX/RxJava/) 등
   - 심플한 publisher/subscriber 패턴
- pros & cons
   - 사용방법을 익히면 간단하게 적용할 수 있다
   - Parcelable 구현이 필요 없다
   - 라이브러리에 따라 Deprecated 되어있다

## 92p ~ 93p, EventBus 를 활용해 데이터를 넘긴다

```
public class DebugOverlayView extends RelativeLayout {
   private EventBus;

   @Subscribe
   public void onDataReceived(Data data) {
      // draw something from data
   }
}
```

## 94p, Dagger 등의 DI로 Scope를 끊는다 & Rx 를 사용한다

- Scope 차단 방법
   - Application의 Lifecycle에 맞춘 Scope
   - Activity의 Lifecycle에 맞춘 Scope
   - Service의 Lifecycle에 맞춘 Scope
- DroidKaigi 앱
   - Application의 Scope에 있는 것이 라우팅을 담당

## 95p, Dagger 등의 DI로 Scope를 끊는다 & Rx 를 사용한다

| ServiceScope |  | ApplicationScope |  | ActivityScope |
| :--: | :--: | :--: | :--: | :--: |
| listen | ◀ | LogEmitter | ◀ | send |

## 96p, Dagger 등의 DI로 Scope를 끊는다 & Rx 를 사용한다

- pros & cons
   - 객체의 Lifecycle이 명확하게 된다
   - EventBus과 비슷한 패턴이 Rx로 완결한다
   - 스스로 EventBus 구조를 만들 필요가 있다

## 97p

정리

## 98p ~ 102p, 어떻게 구현할 것인가

- 할 일
   - 특별한 레이어에 View를  표시한다
   - Background에서 View를 계속 갱신한다
- 고려해야 할 것
   - 프로세스를 계속 움직인다
   - Activity 등과 연결한다

## 103p, 마지막으로

- 이 이야기에는 약간 흑마술 같은 내용이 포함되어 있습니다
- 활용할 경우, 사용법과 범위를 지켜 재미있게 사용해주세요

## 104p, Build my own debugging tool on overlay

Keishin Yokomaku

~ DroidKaigi 2017 DAY.02 - Room 2

## 105p, Appendix

- 참고 자료
   - [WindowManager - Android Developers](https://developer.android.com/reference/android/view/WindowManager.html)
   - [WindowManager.LayoutParams - Android Developers](https://developer.android.com/reference/android/view/WindowManager.LayoutParams.html)
   - [Whoa, Views can do that? WindowManager ideas and tricks! - @eric_cochran](https://speakerdeck.com/nightlynexus/whoa-views-can-do-that-windowmanager-ideas-and-tricks)
   - [DroidKaigi/conference-app-2017 - GitHub](https://github.com/DroidKaigi/conference-app-2017/)