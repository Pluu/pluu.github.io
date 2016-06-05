---
layout: post
title: "[번역] DroidKaigi 2016 ~ 다시 태어난 UI Automator를 자유자재로 다루기"
date: 2016-06-05 20:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [生まれ変わったUI Automatorを使いこなす / How to Use Brand New UI Automator Perfectly
](https://speakerdeck.com/sumio/how-to-use-brand-new-ui-automator-perfectly) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

**다시 태어난 UI Automator를 자유자재로 다루기**

2016.2.19

@sumio_tym (TOYAMA Sumio)

## 2p

**자기소개**

- 이름 : 外山 純生 (TOYAMA Sumio)
  - @sumio_tym (Twittere) / @sumio (GitHub)
- 소속 : NTT 소프트웨어 주식회사
- 업무 내용 : 사내 Android 관련 프로젝트 기술지원
- 그외
  - STAR (테스트 자동화 연구회)
  - @ITrhksfus 「스마트폰용 무료 시스템 테스트 자동화 도구」

> uiautomator/Appium 이야기를 적었습니다 [http://www.atmarkit.co.jp/ait/kw/smapho_testtopl.html](http://www.atmarkit.co.jp/ait/kw/smapho_testtopl.html)

## 3p

**발표내용**

- 새로워진 자동 테스트 도구 UI Automator 2에 대해서 설명합니다. (아무래도 정보가 적다)
 - 구 버전 (uiautomator) 과의 차이
 - API의 기본적인 사용 방법
 - Tips
 - UI Automator2의 사용처

## 4p

**이야기 흐름**

1. 개요
2. 기본적인 사용방법
  - 준비
  - UI Component 검색과 조작
  - Synchronous
3. Tips
4. UI Automator2의 사용처
5. 정리

## 5p

**1. 개요**

## 6p

**UI Automator2의 개요**

- Android SDK 표준 테스트 도구
  -  [http://goo.gl/E5DH9y](http://goo.gl/E5DH9y)(developer.android.com)
- 특징
  - `BlackBox 테스트` 용
  - `복수 어플에 걸친` 테스트(조작)가 가능 (소스나 apk가 지금 없어도 테스트 가능)
- Source Code Repogitory
  - https://goo.gl/ONCIV1(https://goo.gl/ONCIV1)(android.googlesource.com)

> 구 uiautomator에서 Repogitory 위치가 이동되었기때문에 주의

- API Reference
  - [http://goo.gl/alp382](http://goo.gl/alp382)(android.googlesource.com)

## 7p

**구 uiautomator와의 차이**

|  | 구 uiautomator | UI Automator2 | UI Automator2 |
| :- |  :-: | :-: | :-: |
| 대응 API 버전 | 16 이상 | 18, 19 | 21 이상 |
| IDE / Build Tool | Eclipse/ant | Android Studio / Gradle | Android Studio / Gradle |
| 실행방법 | uiautomator 커맨드 | Instrumentation Test | Instrumentation Test |
| 텍스트 입력 | ASCII 뿐 | ASCII 뿐 | Unicode |
| 퍼포먼스 | 조금 느리다 | 빠르다 | 빠르다 |
| 구 API 사용 | ○ | △ | ○ |
| 신 API 사용 | × | △ | ○ |

> 자세한것은 [https://goo.gl/mTP8ig](https://goo.gl/mTP8ig)

## 8p

**기본적인 사용방법 - 준비**

## 9p

**준비: File 배치와 build.gradle**

- 테스트 코드 작성하는 곳
  - $MODULE_DIR$/src/`androidTest`/
- build.gradle

```
dependencies {
  // for Instrumentation Test
  androidTestCompile 'com.android.suuport.test:runner:0.4.1'
  androidTestCompile 'com.android.suuport.test:rules:0.4.1'

  // for UI Automator2
  androidTestCompile \
    'com.android.suuport.test.uiautomator:uiautomator-v18:2.1.2'
}
```

## 10p

**준비: 초기화**

```
@RunWith(AndroidJUnit4.class)
public class MyUiautomatorTest {
  @Rule
  public ActivityTestRule<...> activityTestRule = ...;

  private UiDevice uiDeivce; // UiDevice를 초기화해둔다

  @Before
  public void setUp() throws Exception {
    uiDevice = UiDevice
      .getInstance(InstrumentationRegistry.getInstrumentation());
  }
  ...
}
```

## 11p

**준비: 정리**

- 기본적인 개념은 Instrumentation Test (Espresso등)과 동일
- setUp()으로 UiDevice의 초기화를 잊지 않도록

## 12p

**2. 기본적인 사용방법 - UI Component의 검색과 조작**

## 13p

**UI Component의 검색과 조작: 기본형**

- <검색조건>에 맞는 UI Component를 <조작> 한다

```
uiDevice.findObject(<검색조건>).<조작>;
```

- findObject() 메소드가 2개
  - UiObject findObject(UiSelector)
  - UiObject2 findObject(BySelector)

> 파라매터 · 리턴형에 주목!

## 14p

**UI Component의 검색과 조작: 검색(1/2)**

- findObject() 메소드가 2개
  - UiObject findObject(UiSelector)
  - UiObject2 findObject(BySelector)

- UiSelector 검색조건의 예 (구 uiautomator 호환)

```
new UiSelector().text("OK").className(Button.class)
```

- BySelector 검색조건의 예 (UI Automator2 신 API)

```
By.text("OK").clazz(Button.class)
```

## 15p

**UI Component의 검색과 조작: 검색(2/2)**

- UiSelector 검색조건 API

| 메소드 | 개요 |
| :- | :- |
| className(Class) | View의 클래스 (EditText나 Button 등) 를 조건으로 지정한다 |
| text(String) | View의 표시 문자열을 조건으로 지정한다 |
| description(String) | View의 contentDescription 속성값을 조건으로 지정한다 |
| resourceId(String) | View의 Resource ID (문자열 표현)을 조건으로 지정한다 |

- BySelector 검색 조건 API

| 메소드 | 개요 |
| :- | :- |
| clazz(Class) | View의 클래스 (EditText나 Button 등) 를 조건으로 지정한다 |
| text(String) | View의 표시 문자열을 조건으로 지정한다 |
| desc(String) | View의 contentDescription 속성값을 조건으로 지정한다 |
| res(String) | View의 Resource ID (문자열 표현)을 조건으로 지정한다 |

## 16p

**UI Component의 검색과 조작: 조작**

(UiObject/UiObject2 모두 동일한 함수명)

| 메소드 | 개요 |
| :- | :- |
| click() | Click 한다 |
| setText(String) | 지정된 문자열을 입력한다 |
| getText() | 지정되어있는 문자열을 취득한다 |
| isFocused() | 포커스가 On 되어있는지를 취득한다 |

## 17p

**UI Component의 검색과 조작: 사용 예**

「"OK" 버튼」을 클릭하는 예

```
// UiSelector/UiObject를 사용하는 경우
UiObject okButton = uiDevice.findObject(new UiSelector()
        .text("OK")
        .className(Button.class));
okButton.click();

// BySelector/UiObject2를 사용하는 경우
UiObject2 okButton2 = uiDevice.findObject(By.
        .text("OK")
        .clazz(Button.class));
okButton2.click();
```

## 18p

**UI Component의 검색과 조작: 검색 타이밍**

UiSelector/UiObject를 사용하는 경우

- UiObject의 조작 메소드를 호출할 때
  - ※ findObject(UiSelector)호출시에는 `불가능`
- 찾을 수 없다면 UiObjectNotFoundException
- 화면 레이아웃이 바뀌어도 동일한 UiObject를 사용할 수 있다

BySelector/UiObject2를 사용하는 경우

- findObject(BySelector)를 호출할 때
- 찾을 수 없다면 null을 반환
- 화면 레이아웃이 바뀌면 UiObject2는 무효처리 됨 → StaleObjectException

## 19p

**UI Component의 검색과 조작: 검색 범위 지정**

어느 UI SubTree의 아래만 검색한다

> 검색 시작점

- UiSelector/UiObject를 사용하는 경우:

```
UiSelector criteria = <검색 시작점>.childSelector(<검색조건>);
UiObject target = uiDevice.findObject(criteria);
```

- BySelector/UiObject2를 사용하는 경우:

```
UiObject2 root = uiDevice.findObject(<검색 시작점>);
UiObject2 target = root.findObject(<검색조건>);
```

## 20p

**UI Component의 검색과 조작: 검색 범위 지정**

어느 UI SubTree의 아래만 검색한다

> 「layout2」의 아래에 있는 「OK」 버튼을 누른다

- UiSelector/UiObject를 사용하는 경우:

```
UiSelector criteria = new UiSelector()
        .resourceIdMatches(".*:id/layout2")
        .childSelector(new UiSelector().text("OK"));
uiDevice.findObject(criteria).click();
```

- BySelector/UiObject2를 사용하는 경우:

```
UiObject2 root = uiDevice.findObject(By.res(Pattern.compile(".*:id/layout2")));
root.findObject(By.text("OK")).click();
```

## 21p

**UI Component의 검색과 조작: 검색 범위 지정**

주의점 : 「`탐색 깊이`」를 지정하고 싶을 경우

> 「layout1」의 직접의 자식 (탐색 깊이 1 한정)의 「OK」 버튼을 누르고 싶다

- UiSelector/UiObject를 사용하는 경우 : **불가능**
- BySelector/UiObject2를 사용하는 경

```
UiObject2 root = uiDevice.findObject(By.res(Pattern.compile("*.id:/layout1")));
root.findObject(By.text("OK").depth(1)).click();
```

## 22p

**UI Component의 검색과 조작: 스크롤**

스크롤하면 나타나는 화면 밖의 Component 조작

```
// findObject() 미사용
UiScrollable list = new UiScrollable(new UiSelector().className(ListView.class));
devOptionsList.setAsVerticalList();

// 「"Show touches"를 가지는 자식 LinearLayout」를 찾는다
UiObject showTouches = list.getChildByText(new UiSelector().className(LinearLayout.class), "Show touches");
showTouches.click();
```

> [Developer options] → [Show touches]를 탭하고 싶다

## 23p

**UI Component의 검색과 조작: 스크롤**

스크롤하면 나타나는 화면 밖의 Component 조작

- 구 uiautomator 시대의 API밖에 없다
  - UiScrollable는 UiObject의 서브 클래스
  - 갑자기 new 하는 스타일
- 기분 나쁘지만 딱 잘라 사용할 수밖에 없다

## 24p

**UI Component의 검색과 조작: 정리**

- 목적과 비슷한 API가 `2종류` 존재
  - UiSelector/UiObject (구 uiautomator 호환)
  - BySelector/UiObject2 (신규 추가)
- 둘 다 `검색 타이밍`이 미묘하게 다르다
  - 조작 시 vs findObject() 시
- 새로운 BySelector/UiObject2는 `세심한 부분을 개선`
  - 직접 자식의 검색 (Depth 1 깊이)
- 스크롤 지원은 `구 API뿐`

## 25p

**기본적인 사용 방법 - Synchronous**

## 26p

**Synchronous: 개요**

- 원칙: 조작에 따른 화면 갱신을 기다리지 않고 다음으로 진행
  - 독립된 복수의 버튼 · 텍스트 박스를 연속으로 조작시에는 빠르고 편리
- 아래 같은 경우에는 `Synchronous가 필요`
  - 직전의 조작에 따른 화면 변화에 의존하는 조작
    - 버튼을 누르면 TextView의 표시가 바뀌는 것을 확인하고 싶다
    - 텍스트 박스에 문자를 입력하고, enable인 버튼을 누르고 싶다
    - etc.
  - 어느 조작으로 화면 이동 · Dialog 표시가 발생 시
    - 화면 이동 · Dialog 표시를 완료된 후 다음 조작을 하고 싶다

## 27p

**Synchronous: UiSelector/UiObject**

UiObject의 `「조작 + 동기」` 메소드를 호출

| 메소드 (매개변수는 Timeout 값) | 개요 |
| :- | :- |
| clickAndWaitForNewWindow(long) | 클릭하고 나서 새로운 Window (Dialog 등)가 표시될 때까지 대기 |
| waitForExists(long) | View가 표시될 때까지 대기 |
| waitUntilGone(long) | View가 사라질 때까지 대기 |

※ Timeout한 경우는 false가 반환된다

```
// 「OK」 버튼을 누르고, Dialog가 표현될 때까지 대기
UiObject okButton = uiDevice.findObject(new UiSelector()
        .text("OK")
        .className(Button.class));

// Dialog가 표실될 때까지 2000msec 대기. Timeout시는 테스트 실패
assertThat(okButton.clickAndWaitForNewWindow(2000L), is(true));
// 여기서부터 표시된 Dialog에 대해 조작을 한다
```

## 28p

**Synchronous: BySelector/UiObject2**

UiObject2의 `범용적인` 메소드를 호출

| 메소드 (매개변수는 Timeout 값) | 개요 |
| :- | :- |
| clickAndWait(EventCondition, long) | 클릭하고 나서 지정된 조건이 만족할 때까지 대기 |
| wait(SearchCondition, long) | 지정된 조건이 만족할 때까지 대기 |
| wait(UiObject2Condition, long) | 지정된 조건이 만족할 때까지 대기 |

※ Timeout한 경우는 null/0/false가 반환된다

자주 사용하는 「조건」은 `Until Class`가 준비되어 있다

| Until Class의 static 함수 | 개요 |
| :- | :- |
| newWindow() | 새로운 Window(Dialog)가 표시될 때까지 대기 |
| gone(BySelector) | 조건에 일치하는 View를 찾을 수  없을 때까지 |
| textEquals(String) | 표시 문자열이 매개변수대로 지정될 때까지 |

## 29p

**Synchronous: BySelector/UiObject2**

```
// 「OK」 버튼을 누르고, Dialog가 표시될 때까지 대기
UiObject2 okButton2 = uiDevice.findObject(By.text("OK").clazz(Button.class));

// Dialog가 표시될 때까지 2000msec 대기
boolean result = okButton2.clickAndWait(Until.newWindow(), 2000L);

// Timeout 되었을 때는 테스트를 실패시킨다
assertThat(result, is(true));

//여기서부터 Dialog에 대해 조작을 한다
```

## 30p

**Synchronous: 언제든지 사용가능한 것**

UiDevice Class의 메소드를 호출

| 메소드 (매개변수는 Timeout 값) | 개요 |
| :- | :- |
| wait(SearchCondition, long) | 지정된 조건이 만족할 때까지 대기 |
| waitForWindowUpdate(Strimg, long) | 동일 화면 내의 UI가 갱신될 때까지 대기 ※ 첫 번째 매개변수는 어플의 Package 명 |
| performActionAndWait(Runnable, EventCondition, long) | 지정된 액션(Runnable)을 실행하고 조건이 만족할 때까지 대기 |
| waitForIdle(long) | 이 어플이 IDle 상태가 될 때까지 대기 |

## 31p

**Synchronous: 주의**

- newWindow와 windowUpdate와의 차이 (`※ 틀리면 Timeout하므로 주의`)
  - 새로운 Window(Dialog 포함)가 표시될 때 : newWindow
  - 동일 Window내가 변화될 때 : windowUpdate
- Synchronous 메소드의 반환값은 반드시 assert한다
  - Timeout해도 예외는 발생 안한다
- 「Back」 키 누른 후의 Synchronous 하기 위해서는 UiDeivce#wait(SearchCondition, long)을 사용 (예, `wait(Until.hasObject(By.pkg(...)), timeout)`)
  - 기존 Activity의 resume은 「새로운 Window」가 아니다

## 32p

**Synchronous: 정리**

- 화면 변화를 기다리고 나서 조작하는 경우는 Synchronous가 필요
- UiSelector/UiObject: Synchronous에 사용하는 조건이 적다
  - 어느 정도는 UiDeivce 메소드로 커버 가능
- BySelector/UiObject2: Synchronous 조건을 유연하게 지정 가능
  - Until Class에 조건이 자주 사용하는 Synchronous 조건이 모여있다
- 자세한 주의사항
  - newWindow vs windowUpdate
  - Synchronous 성공확인은 중요!
  - Back 버튼 후의 화면 이동

## 33p

**3. Tips**

## 34p

**UI 감시: UiWatcher**

- UiWatcher: 타깃 UI Component가 `찾을 수 없을 때`에 발동하는 Listener
  - Listener 발동 후에 UI Component의 검색 · 조작을 Retry 한다
- UseCase: `테스트를 실패시키기 어렵게 하는 것에 유효!`
  - 여러 화면에서 표시된 Dialog을 조작한다 (Session 절단 시의 로그인 화면, Review 요청 화면, etc)
  - ANR/강제종료 Dialog를 닫는 테스트를 속행한다
  - etc.
- 상세는 아래 URL! (※ 오래된 기사이지만 개념은 같습니다)
  - [http://sumio.hatenablog.com/entry/2014/04/06/014941](http://sumio.hatenablog.com/entry/2014/04/06/014941)

## 35p

**UI 감시: 주의점**

- Listener 발동 타이밍
  - UiObject의 조작 메소드 호출시
    - UI Component를 찾거나, Timeout이 될 때까지 1초 간격으로 `몇 번이라도 호출할 수 있다`
  - findObject(BySelector) 호출시
    - Ui Component를 찾지 못하면 Window 하나에 대해서 `1번만` 호출할 수 있다
- Espresso와 연동하지 않는다
  - Espresso의 API(onView()로 찾지 못할 때)로는 발동하지 않는다 (※ 혼용하여 사용시에 주의!)

## 36p

**Timeout 값: 정의**

- Configurator Class에 4종류 존재
  - Idle Timeout: Accessibility 이벤트 큐의 Idle 대기 시간
  - Selector Timeout : UI Component가 보일 때까지의 대기 시간
  - Action Acknowledgment Timeout: UI Component가 완료될 때까지의 대기 시간
  - Scroll Acknowledgment Timeout: 스크롤 조작이 완료될 때까지의 대기 시간

## 37p

**Timeout 값: 대기 타이밍**

- Idle Timeout
  - `Home/Back 키` 등 누르기 직전 (이 시간내에 Idle 상태가 되지 않으면 그만두고 키를 누름)
  - `UiObject2`를 검색 · 조작하기 직전 (이 시간내에 Idle 상태가 되지 않으면 그만두고 검색 · 조작한다)
- Selector Timeout
  - `UiObject`를 검색할 때 (이 시간내에 찾지 못하면 그만둔다)
- Action Acknowledgment Timeout
  - `UiObject`를 조작할 때 (이 시간내에 조작이 완료하지 않으면 그만둔다)

## 38p

**Timeout 값: 대기 타이밍**

사용하는 API(Class)에 따라서 사용되는 Timeout 값이 다른 점에 주의!

|  | UiDevice | UiObject | UiObject2 |
| :- | :-: | :-: | :-: |
| Idle Timeout | ○ | × | ○ |
| Selector Timeout | × | ○ | × |
| Action Acknowledgment Timeout | × | ○ | × |

## 39p

**WebView 조작**

- 검색 · 조작 가능한 API는 없다**
- UiDevice.getLastTraversedText()?
  - 「마지막으로 선택된 Text를 반환」
  - D-Pad로 포커스를 이동 → 이동할 때마다 이 메소드를 호출하면 현재 위치를 안다(?) → 타깃 텍스트에 다다르면 D-Pad로 조작한다
  - 여러 가지 해봐도 null밖에 반환되지 않는다
- WebView도 조작하고 싶은 경우는 Appium를 추천
  - [http://goo.gl/lsw8xf](http://goo.gl/lsw8xf)
  - [http://goo.gl/rUHIb8](http://goo.gl/rUHIb8)

## 40p

**4. UI Automator2의 사용처**

## 41p

**사용처: Espresso와의 겸용**

- `하나의 테스트 메소드`에서 Espresso · UI Automator 양쪽의 API를 `겸용 가능`
  - 기본 Espresso에서 테스트를 작성
  - Espresso에서 테스트 불가능한 항목만 UI Automator를 사용
- 겸용은 간단
  - UiDevice를 setUp()시에 초기화하면 OK
  - 자유롭게 혼용해서 사용 가능

## 42p

**사용처: Use Case**

- 사전조건 준비
  - 로케일을 변경한 후 테스트를 시작한다
  - Wifi를 OFF로 변경한 후 테스트를 시작한다
  - etc.
- System Dialog 조작
  - Marshmallow의 Runtime Permission Dialog 조작
  - ANR/강제종료 Dialog 조작
- 연동 어플이 조작

## 43p

**사용처: Espresso겸용시의 주의점**

`변경시`에는 Synchronous를 잊지 않도록 (`Espresso ↔ UI Automator`)

```
// 주소록에 접근하기 위한 버튼을 누른다
onView(withId(R.id.button_contacts)).perform(click());

// Permission 확인 Dialog를 조작
// UI Automator로 조작할 버튼이 표시될 때까지 대기
uiDevice.wait(Until.findObject(
        By.res("com.android.packageinstaller", "permission_allow_button")),
        TIMEOUT_VALUE).click();

// 재차 주소록 접근 버튼을 누른다
// Espresso로 조작할 버튼이 표시될 때까지 대기
uiDevice.wait(Until.hasObject(
        By.res(Pattern.compile(".*:id/button_contacts"))),
        TIMEOUT_VALUE));
onView(withId(R.id.button_contacts)).perform(click());
```

## 44p

**5. 정리**

## 45p

**정리**

- UI Automator2에 대해서 설명했습니다
- Espresso로 테스트 불가능한 항목만 UI Automator2의 힘을 빌리면 Small Smart 가능합니다
- UiObject vs UiObject2의 미묘한 차이에 주의!
  - 스크롤이 필요한 곳 이외는 UiObject2를 사용하면 안심
- 자세한 부분으로 곤란하다면 이 자료를 기억해주세요.
