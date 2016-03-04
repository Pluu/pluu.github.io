---
layout: post
title: "[번역] DroidKaigi 2016 ~ Android Lint로 올바름을 배우자"
date: 2016-02-26 20:25:00 +09:00
tag: [Android, DroidKaigi, Lint]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [AndroidLint #DroidKaigi ](http://www.slideshare.net/Nkzn/androidlint-droidkaigi) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

## 4p

**Target**

- 아직 Android 프로그래밍의 모범 사례를 모르는 초심자
- Android 어플리케이션의 품질을 나타내는 지표를 원하는 품질 담당자

## 5p

**Agenda**

- Android Lint란
- 초보자가 자주하는 실수
- 좀 더 위를 목표로 하는 사람을 위해서
- 품질지표로서의 Android Lint를 생각

## 6p

Android Lint란

## 7p

**Lint란**

| Another HTML-lint | HTML의 구문 체크 Tool |
| JSLint, JSHint, ESLint | JavaScript의 구문 체크 Tool |
| textlint | 일본어 구문 체크 Tool |

## 8p

lint란, 주로 C언어의 소스 코드에 대한 컴파일러보다 상세 및 엄밀한 체크를 하는 프로그램이다

- 타입의 불일치 함수 호출
- 초기화하지 않은 변수의 참조
- 선언되어있지만 사용하지 않는 변수
- 동일한 함수를 참조하는가, 반환값을 사용하는 경우와 사용하지 않는 경우가 있다
- 함수가 반환값을 반환하는 경우와 반환하지 않는 경우가 있다

등등 컴파일러에서는 체크하지 않지만, 버그의 원인이 될듯한 애매한 기술에 대해서도 경고한다.

[https://ja.wikipedia.org/wiki/Lint](https://ja.wikipedia.org/wiki/Lint)

## 9p

Java의 경우는?

## 10p

**Android Lint란**

- Google 공식
- 222개의 규칙 (ver25.0.4 현재)
  - Category, Severity, Priority로 분류된다
- 꽤 광범위
  - 결함 예비군의 검출
  - Usability 체크

## 11p

**Gategory**

| 카테고리명 | 체크 내용|
| :-: | :-: |
| Correctness | 올바른 SDK 사용법 |
| Correctness:Messages | Correctness 중에서 메세지 |
| Security | Security |
| Performance | Performance (동작속도) |
| Usability | Usability (사용성) |
| Usability:Icons | Usability 중에서 아이콘 |
| Usability:Typography | Usability 중에서 문자 |
| Accessibility | Accessibility |
| Internationalization | 국제화, 다국어 |
| Bi-directional Text | Right-to-Left 모드에서의 표시 |

## 12p

**Severity**

| Level | 의미 | 어플리케이션의 영향 |
| :-: | :-: | :-: |
| Fatal | 치명적 | 빌드나 실행에 반드시 실패한다 |
| Error | 에러 | 빌드는 되지만 실행 시 에러를 일으킬 가능성이 크다 |
| Warning | 경고 | 동작은 하지만 수정하는편이 보다 좋은 어플리케이션이 된다 |
| Information | 정보 | 거의 문제없 지만 머속에 두는 편이 좋다 |
| Ignore | 무시 | 문제가 있어도 검출하지 않는다 |

## 13p

**체크 가능한 파일 종류**

- [https://android.googlesource.com/platform/tools/base](https://android.googlesource.com/platform/tools/base)
- com.android.tools.lint.detector.api.detector
  - [https://android.googlesource.com/platform/tools/base/+/master/lint/libs/lint-api/src/main/java/com/android/tools/lint/detector/api/Detector.java](https://android.googlesource.com/platform/tools/base/+/master/lint/libs/lint-api/src/main/java/com/android/tools/lint/detector/api/Detector.java)

## 15p

**Priority**

- 전부
- 불확실하다

## 16p

어떤 문제를 해결하는가

## 17p

**알기어려운 문법 문제**

```
솔직히 Android는 문법을 아는지 모르는지가로 대부분 정해진다고 말할 수 있다고 생각한다.
레이아웃도 스타일도 대충하면 만들 수 있지만, 가장 정확한 것은 이런 방법을 찾아보는데 시간이 걸린다.
머리에 인스톨하고 싶다
```

> [https://twitter.com/konifar/status/698760224409169920](https://twitter.com/konifar/status/698760224409169920)

## 18p

**Android Way is 어디**

```
처음 Android하는 사람이 엄청난 짓을 하는 것도 나무랄 수 없어.
왜냐면 정답이 정리되어있지 않고 정답이 점점 바뀌고 있는 걸
```

> [https://twitter.com/konifar/status/698760496837603328](https://twitter.com/konifar/status/698760496837603328)

## 19p

Google 측의 정답 모음 (혹은 Anti Pattern 모음)

Android Lint

## 20p

사례 소개

Part 1. 초보자가 자주하는 미스

## 21p

Case 1. LinearLayout에 담은 뷰가 표시되지 않는 것은 왠가? (Orientation)

## 22p

**이런 코드 작성하고 있지 않습니까**

어째서 아이템이 하나만 나오지?

## 23p

Orientation

- Summary : Missing explicit orientation
- Priority : 2 / 10
- Severity : Error
- Category : Correctness

## 24p

왜 안되는가?

```
orientation의 기본값은 horizontal
```

## 25p

이렇게 작성합시다

## 26p

Case 2: Fragment가 표시 안 된다

## 27p

**이런 코드 작성하고 있지 않습니까**

어? Fragment가 표시안되네?

## 28p

CommitTransaction

- Summary : Missing commit() calls
- Priority : 7 / 10
- Severity : Warning
- Category : Correctness

## 29p

왜 안되는가?

- beginTransaction()부터 시작하는 메소드 체인은 commit()이 호출되는 시점부터 그리기 처리에 들어간다
- 그거야 commit()을 호출하지 않으면 아무것도 표시되지 않는다
- DB의 트랜잭션 같은 이미지

## 30p

이렇게 작성합시다

## 31p

Case 2: SharedPreference가 저장되지 않는다

## 32p

**이런 코드 작성하고 있지 않습니까**

SharedPreference에 저장했는데 데이터를 불러올 수 없네

## 33p

CommitPrefEdits

- Summary : Missing commit() on SharedPreference editor
- Priority : 6 / 10
- Severity : Warning
- Category : Correctness

## 34p

왜 안되는가?

- SharedPreference에 데이터를 저장하는 경우, 실제로 저장되는 타이밍은 commit() 시
- 그거야 commit()을 호출하지 않으면 아무것도 표시되지 않는다

## 35p

이렇게 작성합시다

## 36p

참고: commit()과 apply()

- SharedPreference는 어플리케이션 내부 영역의 XML을 읽기쓰기하는 것으로 데이터를 영속화할 수 있다

```
commit()은 받는다
apply()는 받지않는다
```

## 37p

이렇게 작성합시다

## 38p

Case 4: Toast가 표시되지 않는다

## 39p

**이런 코드 작성하고 있지 않습니까**

어째서인가, 정말로 이 줄을 통과하는데! 어째서 Toast가 표시되지 않는가!!!

## 40p

ShowToast

- Summary : Toast created but not showwn
- Priority : 6 / 10
- Severity : Warning
- Category : Correctness

## 41p

이렇게 작성합시다

## 42p

Case 5: 왠지 이 OK 버튼 누르기 어렵지않아?

## 43p

**이런 코드 작성하고 있지 않습니까**

## 44p

ButtonOrder

- Summary : Button order
- Priority : 8 / 10
- Severity : Warning
- Category : Usability

## 45p

왜 안되는가?

- 디자인 가이드라인에 적혀있다
  - [https://www.google.com/design/spec/components/dialogs.html#dialogs-specs](https://www.google.com/design/spec/components/dialogs.html#dialogs-specs)
- 단순히 다이얼로그를 닫기만을 위한 "Cancel"과 같은 것은 왼쪽, 본래 하고 싶었던 조작을 계속하는 "OK" 와 같은 것은 오른쪽에 둔다
- "삭제"는 Negative한 이미지이므로 왼쪽에 두기 십상이지만 오른쪽

## 46p

이렇게 작성합시다

## 47p

참고: 검출 조건

1. targetSdk가 API Level 14 이상
  - API Level 13까지는 OK가 왼쪽이 맞았다
2. 라벨이 "OK", "Cancel", android.R.string.ok, android.R.string.cancel 중 하나
3. 부모 레이아웃의 설정상, 정렬은 확실하게
  - LinearLayout이나 TableRow에서는 orientation이 horizontal
  - RelativeLayout에서는 toRightOf, toLeftOf의 관계로 순서를 알 수 있다
  - RelativeLayout에서는 alignParentLeft, alignParentRight의 관계로 순서를 알 수 있다

## 48p

Case 6: 이 어플리케이션 영어도 지원해줘

## 49p

**이런 코드 작성하고 있지 않습니까**

일본어가 표시되는 곳을 전부 찾아서 영어로 고친다...? 하루로는 무리다!

## 50p

HardcodedText

- Summary : Hardcoded text
- Priority : 5 / 10
- Severity : Warning
- Category : Internationalization

## 51p

검출 대상

- 레이아웃 XML (res/layout/)
  - android:text
  - android:contentDescription
  - android:hint
  - android:prompt
- AndroidManifest.xml
  - android:label
- 메뉴 XML (res/menu/)
  - android:title

## 52p

왜 안되는가?

- 문자열 리소스로 뽑아내는 편이 종합적으로 장점이 많다
- Java측에서 언어정보를 바꾸는 것도 불가능한 건 아니지만 꽤 번거롭고 복잡하다
- 리소스 파일의 자동 전환에 의지하는 편이 훨씬 편하다

## 53p

이렇게 작성합시다

## 54p

**참고**

- 데모
  - Quick Fixed
  - 언어 코드마다 string.xml을 준비한 경우의 Android Studio의 움직임

## 55p

사례 소개

Interlude: konifar/droidkaigi2016

## 58p

사례 소개

part2. 좀 더 위를 목표로 하는 사람을 위해서

## 59p

Case 7: 어플리케이션이 관리하는 개인정보가 다른 어플리케이션으로부터 빼앗겼다

## 60p

**이런 코드 작성하고 있지 않습니까**

ContentProvider를 사용할 때는 Manifest에 적지 않나? 그런 건 알고 있어

## 61p

ExportedContentProvider

- Summary : Content provider does not require permission
- Priority : 5 / 10
- Severity : Warning
- Category : Security

## 62p

왜 안되는가?

- 실은 <provider>에는 exported라는 파라매터가 있고, 디폴트는 true
- 외부 어플리케이션에서도 <u>content://hogeoge</u> 와 같은 URI로 데이터에 접근할 수 있다
- Dropbox가 2011년에 저질렀다 [http://codezine.jp/article/detail/6286](http://codezine.jp/article/detail/6286)

## 63p

이렇게 작성합시다

※ minSdkVersion, targetSdkVersion이 둘 다 17 이상이라면, 디폴트는 false가 됩니다 [http://developer.android.com/intl/ja/guide/topics/manifest/provider-element.html](http://developer.android.com/intl/ja/guide/topics/manifest/provider-element.html)

## 64p

Case 8: 이거, 뭐를 입력하는 곳?

## 65p

**이런 코드 작성하고 있지 않습니까**

전화번호를 입력하고 싶은데 일본어 키보드가 나와서 전환하기 귀찮아

## 66p

TextFields

- Summary : Missing inputType or hont
- Priority : 5 / 10
- Severity : Warning
- Category : Usability

## 67p

왜 안되는가?

- 유저는 hint를 보고 무엇을 입력하는 곳인지를 판단하므로, 없으면 불편
- inputType을 지정하면 적절한 키보드가 나타나는 편이 많으므로 키보드를 전환하는 수고를 줄여줘서 편리

## 68p

이렇게 작성합시다

## 69p

Case 9: 역시 아이콘은 컬러풀해야지

## 70p

이런 아이콘 만든적 없습니까

## 71p

IconColors

- Summary : Icon colors do not follow the recommended visual style
- Priority : 6 / 10
- Severity : Warning
- Category : Usability:Icons

## 72p

왜 안되는가?

- 머티리얼 디자인의 등장도 있고, StatusBar이나 ActionBar의 색은 어플리케이션마다 또렷하게 바뀌게 되었다
- 아이콘과 동일 계열 색상의 배경이 되었을 때에 보기 어렵게 된다
- Notification 아이콘은 흰색, Action Icon은 회색으로 해두면, 대체로 대부분 색에 맞는다
- 이런 이야기가 <u>developer.android.com/design</u> 에 게재되어 있었던 것 같지만, <u>www.google.com/design</u> 에 이동되었을 때에 이 이야기가 사라졌던 것 같습니다

## 73p

이렇게 합시다

## 74p

**참고**

1px마다 색을 평가하고 있어서 집념을 느낀다

## 75p

Case 10: 문자는 올바르게 사용합시다

## 76p

**이런 코드 작성하고 있지 않습니까**

Ellipsis(...)를 입력하는 방법을 모르겠으니 점 3개로 괜찮아

## 77p

TypographyEllipsis

- Summary : Ellipsis string can be replaced with ellipsis character
- Priority : 5 / 10
- Severity : Warning
- Category : Usability:Typography

## 78p

왜 안되는가?

- 폰트에 따라서 마침표가 알맞게 ... 로 보일지는 모른다
- ISO-8859-1에서 ... 는 "&#8230;"로 정의되어, 각 폰트도 ... 가 Ellipsis로서 보기 쉽게 해주고 있음
- 준비되어있는 문자는 제대로 사용하려는 자세

## 79p

이렇게 작성합시다

## 80p

품질관리담당자에게 : 품질지표로서 사용하고 있지 않습니까

## 81p

**엔지니어의 변명**

- Google이 "이렇게 하면 안 좋은 어플리케이션이 된다"라고 말하는 것을 모면하고 있기 때문에, 상대적으로 어플리케이션의 품질은 올라갔다고 말하고있지 않는가
- 아무렇게 하더라도 괜찮은 세세한 체크를 200항목 이상이나 모면하는 것은 그 나름의 경험치가 없으면 어렵다
- 올바른 Android SDK를 사용하도록 신경 쓰면서 개발하고 있는 점은 품질상의 성과로서 계상(計上)하고, 거래처나 경영자들이 평가해주면 기쁘다

## 82p

품질지표에 사용할 경우

- 우선도가 낮은 규칙은 사전에 설정해서 ignore해두자 (Bi-directional Text 카테고리 등)
- 예산이나 일정에 따라 사전에 "Fatal, Error는 전부 수정", "Warning은 15건 이내로 검출" 등의 품질지표를 정해두자
- Lint 카테고리 단위로의 채택 여부를 프로젝트마다 정해두는것도 좋다고 생각합니다

## 83p

엔지니어에게: abortOnError를 끄지말아요

## 84p

**abortOnError, checkReleaseBuilds**

- abortOnError: 위험도가 Error 혹은 Fatal의 규칙에 저촉한다면 빌드를 중단
- checkReleaseBuilds: Release 빌드시에 Fatal 규칙에 저촉한다면 빌드를 중단

## 85p

취미로 하거나 프로토타입이라면 몰라도

일로서 할 때 false로 하는 것은 올바르지 않다고 봅니다

정말로 대응하지 않을 규칙만 ignore 합시다

## 87p

**마지막으로**

- Android Studio가 소스 코드에 노란색이나 빨간색으로 태그가 붙는다면, MouseOver해서 무엇이 일어났는가를 보세요!
- 모든 규칙을 해결했다면 자신감을 가지자
- Android Lint와 우리와의 싸움은 지금부터다!
