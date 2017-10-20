---
layout: post
title: "[번역] DroidKaigi 2017 ~ AccessibilityService 를 사용해 앱의 가능성을 넓히자"
date: 2017-10-20 22:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ AccessibilityServiceを使ってアプリの可能性を広げよう](https://speakerdeck.com/litmon/accessibilityservicewoshi-tuteapurifalseke-neng-xing-woguang-geyou) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, AccessibilityService 를 사용해 앱의 가능성을 넓히자

門田福男 @_litmon_

## 2p, 자기소개

- 門田福男 (몬짱) 이라고 부릅니다
- Android 엔지니어 1년차
- twitter [@_litmon_](https://twitter.com/_litmon_)

## 4p

첫 컨퍼런스 발표로 `엄청 긴장`하고 있습니다. `상냥한 눈으로` 봐주세요 

## 5p, Agenda

- Accessibility Service란
- 첫 Accessibility Service
   - Lifecycle에 대해서
   - Multi-window 에서의 동작
- 어떻게 도움이 되는가
- 실제로 앱을 만들어 봤다
- 정리

## 6p ~ 7p, Accessibility Service란

 - 시각에 불편함이 있는 분들을 위한 보조 기능
 - Android 1.6부터 지원되고 있다
 - 손으로 만진 항목을 음성으로 읽어주는 TalkBack 등
    - ImageView 이거나 텍스트가 없는 것에 대해서는 `contentDescription`을 읽어준다
    - EditText 등의 편집 가능한 항목은 `hint`를 읽어준다

이거 스스로 만들 수 있다는 거 알고 계시는가요?

저는 몰랐습니다

## 8p ~ 9p, 어떤게 가능한가?

- 사용자의 행동을 감시할 수 있다
   - 사용자의 조작시의 이벤트를 취득
- 앱의 View 구조를 얻을 수 있다
   - 이벤트 발행시의 View 정보를 얻거나 (id, class, text 등)
   - 현재의 Window의 View 구조를 얻거나 (view tree)
- 얻어진 View를 Service 내에서 클릭하는 것도 가능하다
   - 위에서 얻은 View 정보로부터 사용자 조작을 모방할 수 있다

이것으로 여러가지가 될 것 같지 않나요?

## 10p

Hello Accessibility Service

## 11p, Hello Accessibility Service

필요한 작업은 아래와 같다

- AccessibilityService 작성
- Manifest에 등록
- AccessibilityService 설정 파일을 작성
- 시작 ∙ AccessibilityService 을 ON으로 한다

이것뿐!

## 12p, AccessibilityService 작성

MyAccessibilityService.java

```
public class MyAccessibilityService extends AccessibilityService {
   @Override
   public void onAccessibilityEvent(AccessibilityEvent e) {
      // accessibility service 이벤트를 얻었을 때 호출
   }
   @Override
   public void onInterrupt() {
      // accessibility servic이 예외로 멈췄을 때 호출
   }
}
```

## 13p, Manifest에 등록

AndroidManifest.xml

```
<application>
<service android:name=".MyAccessibilityService">
   <intent-filter>
      <!-- action 설정 -->
      <action android:name="android.accessibilityservice.AccessibilityService" />
   </intent-filter>
   <!-- AccessibilityService 설정을 xml에 작성 -->
   <meta-data
      android:name="android.accessibilityservice"
      android:resource="@xml/accessibility_service_config" />
</service>     
</application>
```

## 14p, AccessibilityService 설정 파일을 작성

res/xml/accessibility_service_config.xml

```
<accessibility-service
   android:accessibilityEventTypes="typeWindowStateChanged"
   android:accessibilityFeedbackType="feedbackAllMask"
   android:accessibilityFlags="flagDefault"
   android:notificationTimeout="100"
   android:description="My Accessibility Service"
   />
```

## 15p, res/xml/accessibility_service_config.xml

```
<accessibility-service
   android:accessibilityEventTypes="typeWindowStateChanged"
```

- Accessibility Service 로 얻을 수 있는 이벤트 타입을 설정
- Window 상태 변경, View의 이벤트 등을 설정할 수 있다
- 전부 원하는 경우는 `typeAllMask`로 해둔다

## 16p, res/xml/accessibility_service_config.xml

```
<accessibility-service
   android:accessibilityFeedbackType="feedbackAllMask"
```

- Accessibility Service 로 얻을 수 있는 Feedback 타입을 설정
- SPOKEN(음성), HAPTIC(촉각), VISUAL(시각) 등
- 우선 전부 설정하는 것은 `feedbackAllMask``

## 17p, res/xml/accessibility_service_config.xml

```
<accessibility-service
   android:accessibilityFlags="flagDefault"
```

- Accessibility Service 기능을 설정 가능 하다
- Window 변경 이벤트 취득, Touch Exploration Mode로 변경 등
- 원하는 flag 를 복수 나열도 가능하다

## 18p, 설정은 Service내에서 동적으로 하는 것도 가능하다

MyAccessibilityService.java

```
@Override
protected void onServiceConnected() {
   // AccessibilityService 를 ON으로 한 타이밍에 호출된다
   AccessibilityServiceInfo serviceInfo = AccessibilityServiceInfo();

   // ... some settings
   serviceInfo.eventTypes = AccessibilityEvent.TYPES_ALL_MASK;

   setServiceInfo(serviceInfo);
}
```

## 19p, 시작 ∙ AccessibilityService 을 ON으로 한다

(앱을 설치한 상태에서)

설정 앱 > System > Accessibility > Services > 자신의 앱에서 Accessibility Service를 켠다

## 20p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 반드시 null 체크를 할 것! (화면 이동 등의 타이밍에 null이 오는 경우가 있다)
   if (nodeInfo == null) {
      return;
   }
   
   // 뒤는 원하는 대로...
}
```

## 21p ~ 22p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 뒤는 원하는 대로...
   String id = nodeInfo.getViewIdResourceName();   // View의 ID를 취득
   String className = nodeInfo.getClassName();   // Class명을 취득
}
```

- id는 `<package-name>:id/<id>` 형태로 되어있다
   - ex. `com.litmon.app:id/text_view`
- `android:accessibilityFlags="flagReportViewIds"`, `android:canRetrieveWindowContent="true"`가 필요

## 23p

여기에서 예상하지 못한 함정이...

## 24p, View ID가 왜인지 얻을 수 없다

- 아무래도 `event.getSource()`가 얻은 NodeInfo에는 ID가 없는 것 같다(?!)
- `event.getSource().getChildAt(0).getParent()`로 하면 ID가 들어있는 NodeInfo가 얻을 수 있다
   - `event.getSource().getChildAt(0)` 로 해도 OK
- 단지 `getChildAt`, `getParent` 로 얻은 View는 계층이 하나의 Depth이라고는 할 수 없다
   - 게다가 더 위의 계층의 View 가 얻어지는 것도 있다 (`flagNotImportantViews`로 안되어 있어서?)
   - 원인은 잘 모르겠다

## 25p

```
public static String getNodeInfoTree(AccessibilityNodeInfo node) {
   if (node != null && node.getParent() != null) {
      AccessibilityNodeInfo parentNode = node.getParent();
      // 재귀적으로 같은 Nodeinfo를 찾는다
      node = findNodeInfoTree(parentNode, node);
   }

   if (node != null && node.getChildCount() > 0) {
      AccessibilityNodeInfo childNode = node.getChild(0);
      if (childNode != null) {
         AccessibilityNodeInfo parentNode = childNode.getParent();
         // 거슬러 올라가 동일한 parentNode를 찾는다
         while (parentNode.hasCode() != node.hasCode()) {
            parentNode = parentNode.getParent();
         }
         node = parentNode;
      }
   }
   return getNodeInfoTree(node, 0);
}
```

## 26p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 뒤는 원하는 대로...
   Rect rect = new Rect();
   nodeInfo.getBoundsInParent(rect);
   int w = rect.width();   // View 사이즈(px)를 취득
   int h = rect.height();
}
```

## 27p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 뒤는 원하는 대로...
   // 부모 View의 NodeInfo를 취득
   AccessibilityNodeInfo parentNodeInfo = nodeInfo.getParent();

   for(int i = 0; i < nodeInfo.getChildCount(); i++) {
      // 자식 View의 NodeInfo를 취득
      AccessibilityNodeInfo childNodeInfo = nodeInfo.getChildAt(i);
   }
}
```

## 28p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 뒤는 원하는 대로...
   // 이벤트명을 String으로 취득
   String eventType = AccessibilityEvent.eventTypeToString(event.getEventType());
}
```

## 29p, AccessibilityService 기본

MyAccessibilityService.java

```
@Override
protected void onAccessibilityEvent(AccessibilityEvent event) {
   // 사용자 조작 이벤트가 온다
   // 조작 대상의 View의 정보가 담긴 객체 취득
   AccessibilityNodeInfo nodeInfo = event.getSource();

   // 뒤는 원하는 대로...
   // 클릭 이벤트를 발생시킨다
   nodeInfo.performAction(AccessibilityEvent.TYPE_VIEW_CLICKED);

   // 홈 버튼을 누르는 것도 가능
   performGlobalAction(AccessibilityService.GLOBAL_ACTION_HOME);
}
```

## 30p, 그 외에도

- 키 이벤트를 얻거나 모방하거나
- 알림이 온 타이밍을 얻거나
- WebView에 javascript를 넣거나
- `왠지 이것저것 가능하다!`

※ 전부 테스트해보지 않아서 틀릴 수도 있습니다

## 31p, Accessibility Service의 Lifecycle
[https://developer.android.com/guide/topics/ui/accessibility/services.html#methods](https://developer.android.com/guide/topics/ui/accessibility/services.html#methods)

- 일반적인 Service와 동일한 동작을 한다
   - AccessibilityService 를 ON으로 하면, 내부에서 뭔가 bind 된다
- 기본적으로 필요한 callback은 이것뿐
   - onServiceConnected
   - onAccessibilityEvent
   - onInterrupt

## 32p, Accessibility Service의 Lifecycle

Accessibility Service를 활성화한다

- onCreate
- onServiceConnected
- (이후, AccessibilityEvent가 발생하면) onAccessibilityEvent
- 재시작후에도 동일하게 onCreate -> onServiceConnected 가 호출된다

## 33p, Accessibility Service의 Lifecycle

Accessibility Service를 활성화한다

```
W: ClassLoader reference unknown path: /data/app/com.litmon
D: onCreate: called
D: onServiceConnected: called
D: onAccessibilityEvent: TYPE_WINDOWS_CHANGED
```

## 34p, Accessibility Service의 Lifecycle

Accessibility Service를 비활성화한다

- onUnbind
- onDestroy

## 35p, Accessibility Service의 Lifecycle

Accessibility Service 내에서 예외가 발생

- 일단 죽고 Accessibility Event에 의해 한번 부활한다
- onCreate -> onServiceConnected
- 이 상태에서 다시 예외가 발생하면, 이후에는 부활하지 않는다 (AccessibilityService를 OFF로 하고 ON으로 하면 다시 부활한다)

## 36p, Accessibility Service의 Lifecycle

- AccessibilityService를 Intent로 시작한다
- onStartCommand
- 일반적인 Service 로서의 움직임이 된다 (Accessibility 기능은 없다)
- 이 상태에서 ON으로 하면 onServiceConnected가 불려진다
   - started && bound Service가 되어버린다, 생각대로 움직이지 않는다
   - [https://developer.android.com/guide/components/bound-services.html](https://developer.android.com/guide/components/bound-services.html)

## 37p

Multi Window 에서의 움직임

## 38p, Multi Window 에서의 움직임

- 기본은 포커스가 있는 Window가 동작한다
- 현재 Active인 Window의 Root의 NodeInfo를 취득한다
   - `AccessibilityService#getRootInActiveWindow()`
- Window 리스트를 취득한다
   - `AccessibilityService#getWindows()``
   - 여기부터 `windowInfo.getRoot()`를 하면 각각의 Window의 Root NodeInfo 가 취득된다
   - `id/content`가 포함되는 Window가 Multi Window 의 아래/위의 View 가 되어있다

## 39p

어떻게 도움이 되는가

## 40p, 어떻게 도움이 되는가

솔직히, 아이디어 따름이다

- 일반적인 앱으로는 얻을 수 없는 정보가 얻어지므로 선택지가 넓어진다
- 예를 들면 : 
   - 터치 조작을 기억해 자동화하는 것을 레코더처럼한다 (일러스터레이터의 작업순서를 자동화하는 것 같이)
   - 탭한 위치의 텍스트를 자신의 앱에 계속 던져 저장한다 (간단 메모)

## 41p ~ 42p, 어떻게 도움이 되는가

- 하지만, 일반적인 어플리케이션에 도입하는 것은 어려워 보인다
   - Service 의 ON/OFF가 귀찮다
   - 큰 거부감이 있어 보이는 다이얼로그
   - 일반적인 사람은 사용하지 않을 것 같은 정보뿐
   - 하지만, 개발자로서는 매력적인 정보가 가득하다

## 43p ~ 44p

그러면 어떻게 할까

디버그용 앱으로서 만들면 되지 않을까?

## 45p, 실제로 자주 사용하는 예

- [Goolge 사용자 보조검증 툴](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor)
   - 특정 화면에 대해 Accessibility 검사를 해준다
- uiautomator, Appium
   - 테스트 도구 ∙ 테스트 프레임워크
   - UI 테스트 자동화 등
- (표준으로 들어있는) ClockBack
   - 시계 설정 시각을 읽어준다

## 46p ~ 47p, 실제로 만들어봤다

- view를 탭하면, 그 view의 position이나 사이즈, id를 표시
- 화면 변경을 검출해 AccessibilityNodeInfo 저장해둔다
   - 저장해둔 NodeInfo의 내용을 사용해 탭한 위치의 View 정보를 표시
   - 탭 위치는 앱에 영향을 끼치지 않도록 View를 오버레이시킨다

## 48p, 어떨때에 사용할 수 있을까

- "처음 이 프로젝트 해보지만, 이 View 도대체 어디에 선언되어 있지"
   - view_id 에서 grep -> 목표의 layout 파일을 발견!
- 디자이너 "이 이미지 몇 dp 요소로 전달하면 좋을지 모르겠다"
   - view를 탭하는 것만으로 view의 사이즈를 알 수 있다 -> 도움 되네!
- 사용해보면 알겠지만, 꽤 `재미있고 도움이 된다` (사내에서도 그럭저럭 감촉이 좋다)

## 49p, 앱의 구성

- AccessibilityService → 화면 랜딩 갱신 타이밍에 AccessibilityNodeInfo를 취득, 변수에 보관
- 어플리케이션 레이어에 Overlay한 View를 탭 → 누른 부분에 있는 View를 AccessibilityNodeInfo로 판단하고 View 정보를 표시
   - View의 클래스 이름, ID, 랜딩 사이즈 (width, height)(dp)

## 50p

```
<?xml version="1.0" encoding="UTF-8" ?>
<accessibility-service
   xmlns:android="http://schemas.android.com/apk/res/android"
   android:accessibilityEventTypes="typeWindowStateChanged|typeWindowContentChanged"
   android:canRetrieveWindowContent="true"
   android:accessibilityFeedbackType="feedbackAllMask"
   android:accessibilityFlags="flagDefault|flagIncludeNotImportantViews/flagReportViewIds"
   android:notificationTimeout="100"
   android:description="@string/accessibility_description" />
```

- eventType으로 Window의 랜딩 갱신을 취득할 수 있도록
- flags로 View의 ID를 취득할 수 있도록 한다

## 51p, View 터치 판정

방침

- AccessibilityNodeInfo 에서 View 트리를 추적한다
   - 자식 View에 대해 터치한 좌표에 View가 포함되어 있으면
      - 그 자식 트리안에 동일하게 View를 찾는다
      - 최종적으로 발견한 자식 View를 보관
   - 모두 보관된 자식 View에 대해 가장 작은 것을 반환

## 52p, View 터치 판정

```
public AccessibilityNodeInfo findNodeInfoByPoint(AccessibilityNodeInfo nodeInfo, int x, int y) {
   if (nodeInfo == null) {
      return null;
   }
   AccessibilityService resultNodeInfo = nodeInfo;
   for (int i = 0; i < nodeInfo.getChildCount(); i++) {
      AccessibilityNodeInfo childInfo = nodeInfo.getChild(i);
      if (childInfo != null && isPointInNodeInfo(childInfo, x, y)) {
         AccessibilityNodeInfo foundNodeInfo = findNodeInfoByPoint(childInfo, x, y);
         resultNodeInfo = getSmallerNodeInfo(resultNodeInfo, foundNodeInfo);
      }
   }
   return resultNodeInfo;
}
``` 

## 53p, View 좌표 취득

```
Rect rect = new Rect();
// 화면에 표시된 부분의 좌표를 취득
nodeInfo.getBoundsInScreen(rect);

// 부모 View로부터 본 부분의 좌표를 취득
nodeInfo.getBoundsInParent(rect);
```

## 54p, 터치한 좌표가 포함되어있는지 판정

```
public static boolean isPointInNodeInfo(AccessibilityNodeInfo nodeInfo, int x, int y) {
   Rect rect = new Rect();
   nodeInfo.getBoundsInScreen(rect);

   // 좌표가 View에 포함되어있는가
   return rect.contains(x, y);
}
```

## 55p, View 사이즈 판정

```
public static AccessibilityNodeInfo getSmallerNodeInfo(AccessibilityNodeInfo leftInfo, AccessibilityNodeInfo rightInfo) {
   Rect leftInfoRect = new Rect();
   leftInfo.getBoundsInScreen(leftInfoRect);

   Rect rightInfoRect = new Rect();
   rightInfo.getBoundsInScreen(rightInfoRect);

   // 사이즈가 작은 NodeInfo를 취득

   return leftInfoRect.width() * leftInfoRect.height() < rightInfoRect.width() * rightInfoRect.height() ? leftInfo : rightInfo;
}
```

## 56p, 사이즈가 작은 View를 선택하는 이유

- 동일한 View 계층이라도 큰 것이 선택되는 경우가 존재한다
   - 아래의 그림의 경우와 같이 A를 선택하고 싶은데 B가 선택되어버린다

## 57p, 함정 포인트 1

- 좌표가 밀린다
   - Root에서 statusBar 부분도 포함된 전체의 절대 좌표가 얻어진다
   - view를 Overlay 하려고 하면 어떻게 해도 그 부분만은 밀려있다
   - 아래와 같이해서 statusBar의 높이를 취득해 그 값만큼 뺀다

```
int id = getResources().getIdentifier("status_bar_height", "dimen", "android");
getResources().getDimensionPixelSize(id);   // statisBar의 높이
```

## 58p, 함정 포인트 2

- AccessibilityNodeInfo는 Parcelable
   - 보존/복원할 수 있고 Intent 경우로 보낼 수 있다
   - 라고 생각되면 Lock이 걸려있으므로 통상적으로는 복원되지 않는다(!?)
   - 최초 Service를 분해해서 만들었기 때문에 어려웠다
   - 결국 이것은 해결 못하고 Service를 분해해서 만드는 것은 포기했다

## 59p, 주의점

- 의외로 API Level이 높다
   - 이번 view-analyzer는 minSdkVersion 16
   - 각종 Compat 클래스가 유능하므로 활용하면 좋다
   - `new AccessibilityNodeInfoCompat(nodeInfo)`
   - Compat 클래스는 Not Parcelable

## 60p, 만들어보고 느낀 점

- 꽤 쓸모있는 경우가 있다
   - 여기의 View는 어디에 선언되어있지, 라는 것을 즉시 찾을 수 있다
   - 개발에 넣었을 때 꽤 도움이 되었다
- 그래도 정말로 원하는 정보가 부족하다
   - 예를 들면, TextAppearance(텍스트 사이즈, 색, 스타일 등)
   - margin/padding 등도 실제로는 얻고 싶다 (하지만 할 수 없다)
   - AccessibilityNodeInfo에 있는 정보에 색등은 없으므로 스스로 어떻게 노력할 수밖에 없다
   - 여기가 해결되면 디자이너와 공유도 더 좋을 것 같다

## 61p, 만들어보고 느낀 점

- OSS화 or 앱 릴리즈하고 싶었다
   - 죄송합니다. 시간이 부족했습니다
   - 더 손봐서 제대로 보여줄 수 있는 상태가 되면 릴리즈도 검토하고 있습니다

## 62p, 오늘의 정리

- AccessibilityService을 사용하면 View 구조와 사용자의 행동을 얻을 수 있다
- 기본적인 움직임은 일반적인 Service와 동일하고 별난 것을 하지 않으면 개발도 그다지 어렵지 않다
- 아이디어의 여하에 따라서는 재미있는 것이 가능하다!
