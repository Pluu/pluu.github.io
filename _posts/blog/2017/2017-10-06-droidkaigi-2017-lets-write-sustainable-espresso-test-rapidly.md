---
layout: post
title: "[번역] DroidKaigi 2017 ~ 더욱 강력한 Espresso 테스트 코드를 효율 높게 적자"
date: 2017-10-06 21:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 変更に強いEspressoテストコードを効率良く書こう](https://speakerdeck.com/sumio/droidkaigi2017-lets-write-sustainable-espresso-test-rapidly) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 더욱 강력한 Espresso 테스트 코드를 효율 높게 적자

2017.03.09

sumio_tym

## 2p, 자기소개

- 이름 : TOYAMA Sumio
   - @sumio_tym (Twitter) / @sumio (GitHub) 
- 소속 : NTT 소프트웨어 주식회사
- 업무 내용
   - 사내 Android 프로젝트 기술 지원
   - 사내 Android 프로젝트 테스트 자동화 지원
- 프라이베이트
   - STAR(테스트 자동화 연구회)
   - @IT관련 "스마트폰용 무료 시스템 테스트 자동화 도구" (UI Automator / Appium회 담당)

## 3p, 이야기할 주제

Android UI 테스트 도구 Espresso에 대해서 아래를 소개합니다

> 제품의 `사양 변경에 강한` 테스트를 Espresso Test Recorder를 사용해 `효율적으로` 적는 방법

## 4p, 이야기 흐름

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. 실천! 변경에 강한 테스트를 효율적으로 적기
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 5p

1. **`소개`**
   - **`효율적으로 테스트를 적는 것`**
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. 실천! 변경에 강한 테스트를 효율적으로 적기
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 6p, 효율적으로 테스트를 작성하는 소중함

테스트 자동화의 목적은 여러 가지 있다

- 테스트 실시 `공수를 줄이고` 싶다
- 절차 오류, 확인 `오류를 없애고 싶다`
- 회귀 테스트를 자동화해서 `안심하고 싶다`
- etc

## 7p, 효율적으로 테스트를 작성하는 소중함

- 어떤 케이스라도 `테스트를 쓰는데 시간을 소비한다`면 목적 달성이 어렵게 된다
- 특히, 착수시에는 `효율적으로(즐겁게) 테스트를 작성`하는 것도 중요

## 8p, UI 테스트 구현시의 병목 (이미지)

조작 대상의 특정이 어렵다

(예) 다이얼로그의 메시지 문자열을 검증한다

- 다이얼로그 타이틀: "결과"
- 다이얼로그 메시지 : "6 + 7 = 13"

## 9p, UI 테스트 구현시의 병목 (이미지)

조건 : 자손에게 "결과"라는 text를 가진 View의 형제가 자신의 조상에 있으며, 또한 자신은 TextView이다

## 10p, UI 테스트 구현시의 병목 (이미지)

↓ 를 스스로 생각해내는 것은 솔직히 어렵다...

```
onView(allOf(
    withClassName(
        is(TextView.class.getName())),
        isDescendantOfA(hasSibling(
            hasDescendant(
                withText("결과"))))))
    .check(matches(
        withText("3 + 4 = 7")));
```

## 11p, 병목 해소의 카드

`Espresso Test Recorder`

- Android Studio 2.2부터 탑재
- 아래를 Espresso 테스트 코드로 출력
   - UI 조작
   - 결과 검증(assertion)

그렇지만, 잘 안되는 케이스도...

## 12p, 효율적으로 테스트를 쓰기 위해서는?

`가능한`

Espresso Test Recorder가 `잘하는` 테스트 케이스를 자동화 대상으로 한다

- 물론
   - `자동화의 목적에서 벗어나지 않았는가`의 검토는 필요합니다.

## 13p, 효율적으로 테스트를 쓰기 위해서는?

그래서 알아두면 좋은 것은?

- Espresso Test Recorder가 잘하는 케이스 / 잘 못하는 케이스
- Espresso의 코드를 손으로 쓰면 간단한 케이스 / 어렵고·불가능한 케이스

나중에 소개합니다!

## 14p

1. `소개`
   - 효율적으로 테스트를 적는 것
   - `변경에 강한 테스트를 적는 것`
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. 실천! 변경에 강한 테스트를 효율적으로 적기
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 15p, 변경에 강한 테스트란?

화면의 사양 변경이 발생했을 때에 `테스트 코드 수정 임팩트가 작은` 것

## 16p, 변경에 `약한` 테스트의 전형적인 사례

- 조작 대상을 특성하는 코드가 `많은 테스트 케이스에 복사`되어 있는 경우

## 17p ~ 18p, 변경에 `약한` 테스트의 전형적인 사례

로그인 화면의 테스트 케이스를 생각한다

1. ID/PW를 넣어서 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것
2. PW를 미입력시 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것
3. ID를 미입력시 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것

나중에 "로그인" 버튼이 "OK" 버튼으로 사양 변경되면 전부 수정이 필요!

Espresso Test Recorder로 평범하게 기록하면 이렇게 된다!

## 19p ~ 20p, 변경에 `강하게`하기 위해서는? (이미지)

같은 조작을 공통부분으로 추출한다

1. ID/PW를 넣어서 `로그인하면` ~ 되는 것
2. PW가 미입력시 `로그인하면` ~ 되는 것
3. ID가 미입력시 `로그인하면` ~ 되는 것

※ 여기에서, "로그인한다" = "로그인"이라고 표시된 버튼을 누른다

나중에 "로그인" 버튼이 "OK" 버튼으로 사양 변경되어도 "※" 만 수정하면 OK

cf. PageObject 디자인 패턴

Espresso Test Recorder로 기록한 경우, 공통부분의 추출은 수작업으로 해야할 필요가 있다!

## 21p, 변경에 강한 코드로 고치는 방법은?

아래를 숙달되면 부담이 줄어든다

- Espresso Test Recorder 출력에 대해서 `구체적인 수정방침`을 생각한다
- 수정 작업에 `자주 사용하는` Android Studio의 `리팩터 기능`을 외운다(`키보드 단축키`도 외운다)

나중에 소개합니다!

## 22p, 여기까지 정리

`효율적으로 테스트를 쓰기 위해서는`

- Espresso Test Recorder의 장점 부분부터 착수
   - 잘되는 것 여부를 알아둘 필요가 있다

`변경에 강한 테스트로 하기 위해서는`

- Espresso Test Recorder 출력 코드에서 수작업으로 공통부분을 추출
   - 리팩터 기능을 구사한 구체적인 수정방법을 숙달할 필요가 있다

## 23p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. `Espresso 기본`
3. Espresso Test Recorder 와 그 경계
4. 실천! 변경에 강한 테스트를 효율적으로 적기
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 24p, Espresso 개요

- Android 공식 UI 테스트 프레임워크
- 코드 간결함·신뢰성이 높은 것에 정평이 나있다
- 테스트 실행 속도가 비교적 빠르다
- WebView에도 대응
- URL
   - [https://goo.gl/x8eP5C](https://goo.gl/x8eP5C)
   - [phttps://goo.gl/lmrlJI](phttps://goo.gl/lmrlJI)

(※) [https://developer.android.com/training/testing/espresso/cheat-sheet.html](https://developer.android.com/training/testing/espresso/cheat-sheet.html) 로부터 로고를 인용

## 25p, Espresso 설치

`빌드 환경 설정`([https://goo.gl/WlXSCq](https://goo.gl/WlXSCq))

- Android Support Repository 설치
- build.gradle의 dependencies 블록 (아래 2개의 모듈을 선언)
   - configuration : androidTestCompile
   - group : com.android.support.test.esporesso
   - module:
      - 1. espresso-core (Recorder가 자동설정)
      - 2. espresso-contrib (수동으로 추가)
    
## 26p, Espresso 설치

```
androidTestCompile('com.android.support.test.espresso:espresso-core:2.2.2',
   { 
      exclude group: 'com.android.support', module: 'support-annotations' 
   }
)
```

프로덕트 코드와 충돌하는 모듈을 제외한다. (빌드 에러시의 메시지 참조)

## 27p, Espresso 설치

```
androidTestCompile( 'com.android.support.test.espresso:espresso-contrib:2.2.2', { 
   exclude group: 'com.android.support', module: 'support-annotations' 
   exclude group: 'com.android.support', module: 'support-v4' 
   exclude group: 'com.android.support', module: 'appcompat-v7' 
   exclude group: 'com.android.support', module: 'design' 
   exclude group: 'com.android.support', module: 'recyclerview-v7' 
   } 
)
```

## 28p, Espresso 설치

`테스트 실행 단말의 애니메이션 설정` ("개발자 옵션"의 아래를 OFF한다)

- 창 애니메이션 배율
- 전한 애니메이션 배율
- Animator 길이 배율

## 29p, Espresso 테스트 코드

- src/androidTest/java 에 배치
- Android Testing Support Library에 따른다

※ Espresso Test Recorder가 서식을 자동 생성

```
@RunWith(AndroidJUnit4.class) 
public class MyEspressoTest { 
   @Rule public ActivityTestRule<...> activityTestRule = ...; 
   ... 
}
```

## 30p ~ 31p, Espresso API 개요

- 아래의 기본형을 이해
   - ※ perform() · check()는 생략가능

```
onView(ViewMatcher)
   .perform(ViewAction)
   .check(ViewAssertion); 
```

- "ViewMatcher"에 해당하는 View에 대해서
- "ViewAction"을 실행한 결과
- 그 View가 "ViewAssertion"에 만족한 것을 확인한다

이미 존재하는 API 목록은 치트 시트([https://goo.gl/sH9eax](https://goo.gl/sH9eax) 참조

## 32p, Esspresso에서 조작 · 확인 가능한 것

- Button, EditText, TextView, 다이얼로그 등 기본적인 컴포넌트
- ListView - `onData()`
- RecyclerView - `RecyclerViewActions`
   - ※ ViewHolder내의 View 확인에는 머리를 짜내야 할 필요
- NavigationDrawer · NavigationView - `DrawerActions · NavigationViewActions`
- DatePicker · TimePicker - `PickerActions`
- WebView내 HTML - `onWebView()`
   - [https://goo.gl/OMfVyZ](https://goo.gl/OMfVyZ) 참조

## 33p, Espresso로는 잘 안되거나 어려운 것

`View 프로퍼티를 동적으로 취득` (사전에 알고 있는 값과 일치확인은 가능하다)

- View A와 View B에 동일한 텍스트 (사전에는 모른다)가 표시되고 있는 것을 확인한다, 등

`조작 · 확인대상이 명확하지 않은 케이스`

- 복잡한 제스처 (화면을 손으로 그리는 등)
- 이미지 비교 (ImageView 등)

## 34p, Espresso로는 잘 안되거나 어려운 것

`AsyncTask이외의 비동기 대기`

- IdlingResource를 구현하면 가능
- 다른 Activity에 이동하면 "UI가 변화할 때까지 대기" 가 어렵다

## 35p, 여기까지의 정리

`환경설정은`

- `Espresso Test Recorder에 맡기는 것이 편하다`
   - 단말 애니메이션 OFF 등 수동설정도 필요
- `대부분의 UI 부품 조작 · 확인을 지원`
   - 공식으로 튜토리얼이 있다
- `아래에 대해서는 다가가지 않는 것이 무난`
   - View 프로퍼티를 동적으로 취득
   - 조작 · 확인대상이 명확하지 않은 케이스
   - 다른 화면 이동 후의 비동기 대기

## 36p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. `Espresso Test Recorder 와 그 경계`
4. 실천! 변경에 강한 테스트를 효율적으로 적기
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 37p, 동작에 필요한 것

- 테스트 대상 앱의 소스 코드
- Android Studio 2.2 이상
- 에뮬레이터 / 실제 단말 (테스트 기록시에 사용)

## 38p, 동작 방법

1. 에뮬레이터 / 실제 단말를 adb 접속해둔다
2. 테스트 대상 앱의 프로젝트를 Android Studio로 연다
3. 메뉴 Run > Record Espresso Test

## 39p, 동작 기록

- 기동한 테스트 대상 앱을 직접 동작한다
- 동작한 내용은 "Record Your Test" 다이얼로그에 반영해준다 (반응이 느리므로, 1 액션마다, 반영될 때까지 기다리는 것을 추천)

※ 이후, [https://github.com/googlecodelabs/android-testing](https://github.com/googlecodelabs/android-testing) 에서 공개된 샘플 앱을 사용한 스크린샷을 게재하고 있습니다

## 40p, Assertion 기록

- "Record Your Test" > "Add Assertion"

## 41p, Assertion 기록

- 화면 캡처가 표시된 Assertion 을 기록하는 모드로 이행

## 42p, Assertion 기록

- 화면 캡처하는 곳 위에서 검증하고 싶은 항목을 선택
- 검증 내용을 선택하고 "Save Assertion"

## 43p, 기록 종료

- "Record Your Test" > "OK"
- 테스트 클래스명을 입력

※ build.gradle이 미설정이면 이 순간에 자동 설정 여부가 확인된다.

## 44p, 한계 - 주의점

- 조작이 엉성하다 (가능하면 실제 단말에서 기록하는 것이 좋다)
- 비대응 컴포넌트가 있다
- 확인 수단이 한정되어 있다 "텍스트 일치 · 표시되어 있는가 여부" 뿐
- 조작 실수를 취소할 수 없다
- 반드시 최초의 Activity 기동부터 기록된다
- Landscape 비대응 (Assertion)

## 45p, 한계 - 컴포넌트별 대응 상항

| 컴포넌트 | 대응 상황 |
| :-- | :-- |
| TextView | ○ |
| EditText | ○ |
| Button | ○ |
| NavigationDrawer | ○ `(전용API는 사용되지 않는다)` |
| `RecyclerView` | △ `(전용API는 사용되지 않는다)` |
| `ListView` | △ `(onData()가 사용되지 않는다)` |
| `Picker계열` | △ `(spinner계열만 가능)` |
| `WebView내 HTML` | `X` |

## 46p, 한계 - 버그라고 생각되는 것

- 자동생성되는 childAtPosition()이 제대로 위치를 카운트하지 않는다 (Issue 231461) MoreViewMatchers 클래스 (자작) 수정판이 있다
- AsyncTask이의 백그라운드 스레드(OkHttp나 RxJava 등)를 사용하고 있으면 거대한 sleep 코드가 투입되는 일이 있다
   - 예: Thread.sleep(3596585) `←약 1시간`

## 47p, 여기까지의 정리

- Espresso Test Recorder 조작은 직감적으로 알기 쉽다
- 하지만, 뭐든 기록 가능한 것은 아니므로 사전에 한계를 알아두면 좋다
   - RecyclerView, ListView, Picker계열, WebView가 있는 화면은 주의가 필요 (필요에 따라서 소스를 교체한다)

## 48p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. `실천! 변경에 강한 테스트를 효율적으로 적기`
   - `샘플 앱에 대해서`
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - 수정

## 49p, 샘플 앱

즐겨찾기 목록 ↔ Qiita 기사 목록 

→→(타이틀 탭으로 상세화면으로)→→ 기사 상세 화면

→→★(CheckBox)탭으로 즐겨찾기 목록에 들어간다

## 50p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. `실천! 변경에 강한 테스트를 효율적으로 적기`
   - 샘플 앱에 대해서
   - `테스트 자동화 대상의 선정`
   - 조작 · 검증 기록
   - 수정

## 51p, (다시 게재) 효율적으로 테스트를 쓰기 위해서는?

- `가능한한`
   - Espresso Test Recorder가 `잘하는` 테스트 케이스를 자동화 대상으로 한다
- 물론
   - `자동화의 목적에서 벗어나지 않았는가`의 검토는 필요합니다

## 52p, 테스트 자동화 대상의 선택 방침

아래의 조건에 맞는 `화면`의 테스트를 먼저 자동화한다 `(Espresso는 화면 단위로 시험한다)`

- Espresso Test Recorder가 대응하는 컴포넌트가 많다
- (대응하지 않는 컴포넌트는) 수동으로 Espresso API를 호출하면 간단하게 적을 수 있다

## 53p, 컴포넌트별 대응 상황 정리

| 컴포넌트 | Recorder | 수동 |   |
| :-- | :--: | :--: | :-- |
| TextView | ○ | ○ | 보다 많이 |
| EditText | ○ | ○ | 보다 많이 |
| Button | ○ | ○ | 보다 많이 |
| NavigationDrawer | ○ | ○ | 보다 많이 |
| RecyclerView | △ | △ | 보다 적게 | 
| ListView | △ | ○ | 보다 적게 |
| Picker 계열 | △ | ○ | 보다 적게 |
| WebView내 HTML | X | ○ | 보다 적게 |

## 54p, 그외 대응 상황 정리

| 하고 싶은 것 | Recorder | 수동 |   |
| :-- | :--: | :--: | :-- |
| 표시 텍스트 일치 확인 | ○ | ○ | 보다 많이 |
| View의 표시/비표시 확인 | ○ | ○ | 보다 많이 |
| 그외의 확인 | X | △ | 보다 적게 |
| (이미지 일치 확인) | X | X | 대상외 |
| View 프로퍼티의 동적인 취득 | X | X | 대상외 |
| 복잡한 제스쳐 | X | X | 대상외 |
| AsyncTask이외의 비동기 대기 | X | △ | 보다 적게 |

## 55p, 샘플앱에서 생각한다

즐겨찾기 목록 ↔ Qiita 기사 목록 (O)

→→(타이틀 탭으로 상세화면으로)→→ 기사 상세 화면 (X 별도 프로세스)

→→★(CheckBox)탭으로 즐겨찾기 목록에 들어간다 (△)

## 56p ~ 58p, 샘플 앱에서 생각한다 (★ 탭 조작)

- 이미지의 변화는 확인 불가
   - CheckBox 이므로 "체크 상태 여부(isChecked())"로 판단한다
- RecyclerView의 뷰 아이템의 조작 · 확인이 어렵다
   - 범용 메소드를 준비해서 대응한다 (나중에 기술)
- 즐겨찾기에 넣은 것과 동일한 타이틀 `(사전에 정하지 않는다)` 이 있는지 확인은 불가능
   - 서버 응답을 고정 (사전에 정하도록 한다)
   - 즐겨찾기의 수가 0 → 1가 되는 것의 확인에 그친다 (이번에는 이쪽을 채용)

## 59p, 이번에 자동화하는 테스트 케이스

1. ☆를 탭하면 ★로 바뀐다
2. ★를 탭하면 ☆로 바뀐다
3. 즐겨찾기가 0건의 상태에서 ☆을 탭해서 ★로 하면 즐겨찾기 화면의 표시 건수가 1건이 된다 (1건이 존재하고 2건이 존재하지 않도록)

## 60p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. `실천! 변경에 강한 테스트를 효율적으로 적기`
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - `조작 · 검증 기록`
   - 수정

## 61p, (다시 게재) 변경에 `약한` 테스트의 전형 사례 (이미지)

로그인 화면의 테스트 케이스를 생각한다

1. ID/PW를 넣어서 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것
2. PW를 미입력시 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것
3. ID를 미입력시 `"로그인"`이라고 표시된 버튼을 누르면 ~ 되는 것

Espresso Test Recorder로 평범하게 기록하면 이렇게 된다!

## 62p, (다시 게재) 변경에 `강한` 하는 것은? (이미지)

같은 조작을 공통부분으로 추출한다

1. ID/PW를 넣어서 `로그인하면` ~ 되는 것
2. PW가 미입력시 `로그인하면` ~ 되는 것
3. ID가 미입력시 `로그인하면` ~ 되는 것

※ 여기에서, "로그인한다" = "로그인"이라고 표시된 버튼을 누른다

나중에 "로그인" 버튼이 "OK" 버튼으로 사양 변경되어도 "※" 만 수정하면 OK

cf. PageObject 디자인 패턴

## 63p, Recorder로 기록하는 것

`테스트시에 조작 · 확인할 가능성이 있는 것을 한번만 기록한다`

- 로그인의 사레로는 ...
   - ID 를 입력한다
   - PW 를 입력한다
   - 로그인 버튼을 누른다
   - 로그인 에러 메시지를 확인한다

## 64p, (데모) 샘플 앱으로 맞추면

- NavigationDrawer를 열어서 기사 목록 화면으로 바꾼다
- 기사 목록 화면에서 ☆을 탭한다
- 기사 목록 화면에서 ☆의 존재를 확인한다
- NavigationDrawer를 열어서 즐겨찾기 목록 화면으로 바꾼다
- 즐겨찾기 목록 화면에서 리스트 아이템의 존재를 확인한다

## 65p

1. 소개
   - 효율적으로 테스트를 적는 것
   - 변경에 강한 테스트를 적는 것
2. Espresso 기본
3. Espresso Test Recorder 와 그 경계
4. `실천! 변경에 강한 테스트를 효율적으로 적기`
   - 샘플 앱에 대해서
   - 테스트 자동화 대상의 선정
   - 조작 · 검증 기록
   - `수정`

## 66p, 기억줬으면 하는 IDE의 기술

Help > Find Action으로 입력

| Command | Mac | Windows |
| :-- | :-- | :-- |
| Extract Variable | Cmd+Opt+V | Ctrl+Alt+V |
| Extract Method | Cmd+Opt+M | Ctrl+Alt+M |
| Inline | Cmd+Opt+N | Ctrl+Alt+N |
| Move Line UP | Ctrl+Shift+↑ | Alt+Shift+↑ |
| Duplicate Line or Selection | Cmd+D | Ctrl+D |
| Generate | Cmd+N | Alt+Insert |

## 67p, (데모) 수정방침 (Recorder 출력 결과를 참고로)

`Recorder출력으로 움직이지 않는 항목을 수정한다` (RecyclerView 관련)

- CheckBox 토글
   - RecyclerViewActions.actionOnItemAtPosition() 은 아이템 뷰만 조작가능하다
   - 스스로 구현한 clickDescendantViewWithId()를 사용해 아이템 뷰의 자식을 조작 (샘플에서는 RecyclerViewUtils 클래스로 정의)

## 68p, (데모) 수정방침 (Recorder 출력 결과를 참고로)

 `Recorder출력으로 움직이지 않는 항목을 수정한다` (RecyclerView 관련)

 - CheckBox 상태 확인
    - 지정 position의 아이템 뷰를 검색하는 API가 없다
    - 스스로 구현한 withItemViewAtPosition(recyclerView, pos) 으로 실현

## 69p, (데모) 수정방침 (Recorder 출력 결과를 참고로)

 `Recorder출력으로 움직이지 않는 항목을 수정한다` (RecyclerView 관련)

 - CheckBox 상태 확인
    - withItemViewAtPosition()과 isDescendantOfA() 를 사용해 더욱 아래의 계층에 있는 CheckBox를 검색
       - allOf(isDescendantOfA(root), target) → root 아래의 target을 검색
    - 사전에 RecyclerViewActions.scrollToPosition()으로 아이템 뷰를 화면에 넣어둔다

## 70p, (데모) 수정방침 (Recorder 출력 결과를 참고로)

 `Recorder의 이상한 출력을 수정한다` (RecyclerView 관련)

 - 리스트 아이템의 존재 여부 확인
    - CheckBox 상태확인과 동일 사양
    - 사전에 RecyclerViewActions.scrollToPosition() 으로 스크롤해둘 것을 잊지 않는다

## 71p, (데모) 수정방침 (Recorder 출력 결과를 참고로)

`아래의 메소드를 꺼낸다` (int 인수는 위치)

| 메소드 | 개요 |
| :-- | :-- |
| goArticleList() | 기사 목록 페이지로 |
| goFavsList() |  Fav 목록 페이지로 |
| toggleFavStatus(int) | Fav 버튼의 토글 |
| assertFavStatus (int, boolean) | Fav 버튼 상태 확인 |
| assertItemExists(int) | 리스트 아이템 존재 확인 |
| assertItemDoesntExist (int) | 리스트 아이템 없는 지 확인 |

## 72p, (데모) 테스트 케이스 구현

조금 전 정의한 `메소드만을 사용해` 테스트 케이스를 구현한다

1. ☆를 탭하면 ★로 바뀌는 것
2. ★를 탭하면 ☆로 바뀌는 것
3. 즐겨찾기가 0건의 상태에서 ☆을 탭해서 ★로 하면 즐겨찾기 화면의 표시 건수가 1건이 되는 것 (1건이 존재하고 2건이 존재하지 않도록)

## 73p, 부록: RxJava의 대기에 대해서

대응 방법은 여러 가지 있다

Schedulers.io()만 이용하는 경우는 ③이 좋아 보인다

1. RxAndroid 의 Issue #149 (결론은 없지만 샘플 코드가 있다)
   - [https://github.com/ReactiveX/RxAndroid/issues/149](https://github.com/ReactiveX/RxAndroid/issues/149)
2. RxEspresso (sub/unsub을 카운트한다) 
   - [https://github.com/stablekernel/RxEspresso](https://github.com/stablekernel/RxEspresso)
3. Retrofitting Espresso (Schedulers.io()을 AsyncTask로 바꾼다)
   - [https://goo.gl/2p3E6S](https://goo.gl/2p3E6S)

## 74p, 부록: Espresso-Commons

이번에 소개한 제가 제작한 유틸리티만 빼낸 것을 "Espresso-Commons"으로 공개하고 있습니다.

[https://github.com/sumio/espresso-commons](https://github.com/sumio/espresso-commons)

## 75p, 여기까지의 정리

변경에 강한 테스트 코드를 효율 높게 적는 방법을 실연을 포함해서 설명했습니다

1. "Espresso로 간단하게 기록할 수 있다 or 쓸 수 있다" 라는 관점으로 테스트 자동화 대상을 정한다
2. 테스트에 필요한 조작 · 검증을 Recorder로 `한번만`기록한다
3. 움직이지 않는 출력을 수정한다
4. 조작 · 검증 단위로 메소드 추출한다
5. 추출한 메소드만을 사용해 테스트를 적는다

## 76p, 마지막으로

변경에 강한 테스트 코드를 효율적으로 쓰기에는 마지막으로 실연한 방법에다가 지식과 경험 `(경험을 늘리다)`도 중요합니다. 

이번에 소개한 기술을 토대로 우선 하나 써보는 것을 추천합니다. 

어느 정도 궤도에 오르고 나서 "난이도가 높지만, 효과도 높은 항목"에 도전하는 것을 추천합니다.