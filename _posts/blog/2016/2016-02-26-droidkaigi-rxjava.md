---
layout: post
title: "[번역] DroidKaigi 2016 ~ 내일부터 사용할 수 있는 Rxjava 자주 사용하는 패턴"
date: 2016-02-26 02:35:00 +09:00
tag: [Android, DroidKaigi, RxJava]
categories:
- blog
- Rx
- DroidKaigi
---

<!--more-->

본 포스팅은 [droidkaigi-rxjava](http://www.slideshare.net/KazukiYoshida/droidkaigi-rxjava) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

코드는 생략하고 `슬라이드의 일본어 부분만 번역` 했다는 점 양해바랍니다.

<!--more-->

## 1p

내일부터 사용할 수 있는 RxJava 자주 사용하는 패턴

## 5p

RxJava 입문기사를 읽고, 업무에서도 사용하고 싶으신 분

or

복잡한 작업을 하는 어플리케이션을 개발 도중 최근 구현방법의 예측하기가 어렵게 되었다고 느끼는 분

## 6p

오늘은 RxJava를 사용한 API와의 비동기처리에 대해서 이야기합니다

## 7p

왜 API와의 비동기처리로 주제를 좁혔는가

1. 여러 가지 문맥 이야기를 하면 뭐가 뭔지 모르게 된다
2. API와의 비동기처리에 어려워하는 사람이 가장 많을 것 같다
3. API와의 비동기처리부터 RxJava를 시작하는 것을 추천

## 8p

RxJava는 어떤 문제를 해결할 수 있는가

## 9p

**비동기 콜백 시대의 과제**

getActivity() == null 문제 (Fragment내의 콜백처리로는 NullPointException)

비동기 콜백의 병렬/직렬화 등 복잡한 구현할 경우 가독성도 낮아지고, 사내에서도 모범 사례가 정해지지 않았다

## 10p

**RxJava를 사용하면**

간단하게 처리가 LifeCycle에 bind 가능하다.

and

복잡한 작업에도 강력한 오퍼레이터를 사용하는 것으로 선언적(宣言的)으로 기술이 가능해져 가독성도 보장된다.

## 11p

어느 레시피 서비스의 검색 화면을 작성하는 이야기를 예로 RxJava의 자주 사용하는 패턴을 몇 가지 소개합니다 (cookpad.com과는 전혀 관계가 없습니다)

## 12p

먼저 비동기 콜백을 사용해서 검색화면을 구현해봅니다

## 13p

예) 레시피를 검색하는 비동기 처리 코드

## 14p ~ 21p

예) "스테이크" 레시피를 검색해서 리스트에 추가

## 22p ~ 26p

예) "스테이크" 레시피를 검색 실패했을 경우

## 27p

지금의 처리를 RxJava로 바꿔봅니다

## 28p

RxJava의 클래스를 사용하기 위해서는 build.gradle에 Dependencies를 추가합니다

> 2016/02 현재 ver 1.1.1이 최신입니다. rxAndroid에 대해서는 추후에 소개합니다.

## 29p ~ 31p

searchRecipe 함수를 Observable로 변환합니다

## 32p ~ 33p

1.
2번째 파라매터의 callback를 제거하고 내부에 이름없는 클래스를 작성합니다

## 34p ~ 35p

2.
반환 값을 Observable<List<Recipe>>로 변경합니다

> 이 시점에서는 컴파일 에러가 됩니다

## 36p

3.
내부 처리를 Observable로 감쌉니다.

> Observable은 Constructor가 은폐되어 있기 때문에, Observable#create 경유로 인스턴스를 만듭니다.

## 37p

4.
Observable 안에 로직을 작성합시다

## 38p ~ 40p

5.
subscriber에 이벤트를 통지하게 합니다

```
subscriber.onNext(recipes); // 이벤트 통지
subscriber.onCompleted(); // 모든 이벤트가 종료했다는 통지
subscriber.onError(t); // 처리 내부에서 실패했다고 통지
```

> 이걸로 Observable은 완성입니다

## 41p

**여담) 동기 메소드를 Observable할 경우**

> 불필요한 스레드 생성을 피하고자, Observable 내부는 가능한 동기처리로 합시다

## 42p ~ 49p

예) "스테이크" 레시피를 검색해서 리스트에 추가(Rx버전)

## 50p ~ 54p

Observable#subscribe()에는 람다식을 전달하는 것도 가능하다

> Java8을 사용할 수 있는 환경이라면, rx.functions.Action1과 rx.functions.Action0을 람다로 변경할 수 있습니다

## 55p

실은 아직 제대로 움직이지 않습니다

> 정확하게는 Observable의 구현에 따라서 네트워크 처리가 UI 스레드에서 실행되어 Crash가 일어납니다.

## 56p ~ 59p

Observable에 동기 실행 / 비동기 실행의 개념은 없다

→ 지정하지 않은 경우는 (기본적으로) 호출한 스레드에서 실행된다

→ Scheduler를 사용해서 명시적으로 실행 스레드를 지정합시다

> 지정하지 않은 경우의 Observable 실행 스레드 판단은 어려우므로, Scheduler는 매번 지정합시다

## 60p

**Scheduler에 의해 실행 스레드 제어**

- Observable#subscribeOn
- Observable#observeOn

## 61p ~ 62p

**Observable#subscribeOn에 대해서**

```
전체 처리가 Schedulers.io가 할당한 Worker Thread에서 실행된다
```

1. Observable 전체 실행 스레드를 지정하는 오퍼레이터
2. 어디서나 지정해도 관계없다
3. 복수 지정한 경우는, 가장 위에 지정한 것이 적용된다

> Schedulers.io()는 상한이 없는 스레드풀로부터 스레드를 배정해줍니다.

## 63p ~ 64p

**Observable#observeOn에 대해서**

```
Worker Thread(1)에서 실행
UI Thread에서 실행
Worker Thread(2)에서 실행
```

1. Observable로부터 반환된 값을 전달받을 스레드를 새롭게 바꾼다
2. 지정된 곳으로부터 이후의 오버레이터의 스레드가 변경된다
3. 메소드 체이닝 중에 여러 번 호출할 수 있다.

> 다른 개발자가 혼란해 할 수도 있으므로, observeOn을 여러 번 호출하는 것은 그다지 사용하고 싶지 않네요

## 65p

**Scheduler 지정이 자주있는 패턴**

Observable 및 map 등의 오퍼레이터가 Worker Thread에서 실행되고, subscribe에 전달된 Subscriber(Action)가 UI Thread에서 실행된다.

## 66p ~ 69p

**레시피 검색 구현으로 Scheduler 지정을 기술**

> 이것으로, Observable + 호출까지 올바르게 동작하게 됩니다.

## 70p

getActivity == null 문제

## 71p

**getActivity == null 문제는?**

Fragment 내에서 비동기 처리가 반환되기 전에, Activity가 파기되면, 콜백내에서 해제되어 인스턴스에 접근할 경우 NullPointException가 발생한다

## 72p

getActivity() == null 문제에 대응(비동기 콜백 버전)

## 73p

RxJava로 개발할 경우, trello/RxLifecycle을 사용하여 대응합시다

> Subscription을 이용방법이 일반적이지만, 신경 쓸 부분이 적은 RxLifecycle을 소개합니다

## 74p ~ 77p

getActivity() == null 문제에 대응 (Rx버전)

> RxActivity를 상속할 필요가 있습니다만, 기존의 BaseActivity에 추가하는 것도 간단합니다.

## 78p ~ 81p

혹시, 레시피 검색결과가 반환되기 전에 이전 화면으로 간다면

```
subscribe내의 처리가 호출되지 않는다
```

## 82p

Observable을 하는 것으로 복잡한 작업도 선언적으로 작성되었다

→ 시험 삼아 기능을 추가해봅시다!

## 83p

**신기능 추가 1**

"2번째 영역에 키워드 연동형의 광고를 넣자"

## 84p

**키워드 연동형 광고의 사양**

특정 키워드가 검색되었을 경우에만 2번째 영역에 광고로 변경된다

광고 정보는 별도 API로 Request할 필요가 있다

## 85p ~ 86p

"스테이크"로 검색하면 표시된다

"계란"으로 검색해도 표시되지 않는다

## 87p ~ 95p

좋지않은 예) 레시피와 광고를 각각 독립적으로 읽어 들여 표시시키는 경우

"스테이크"로 검색

- 스테이크의 레시피를 취득 → 검색화면에 레시피를 추가
- 스테이크 관련 광고를 취득 → 검색화면 2번째에 광고를 추가

**실수로 TAP이 발생하기 쉬운 UI는 피하고 싶다**

## 96p ~ 101p

예) "스테이크"로 검색하면 2번째 영역이 관련된 광고가 된다

"스테이크"로 검색

- 스테이크의 레시피를 취득
- 스테이크 관련 광고를 취득
- 대기 처리
- 스테이크 레시피를 표시하고, 2번째에 광고를 표시시킨다

## 102p

**RxJava에서의 병렬처리**

combineLatest(Observable, Observable, Func2)

```
// 이 경우, 3이 다음 오퍼레이터로 전달
```

> 2개의 Observable 처리를 이용해서, 반환 값을 Func2에서 값을 합성하는 오퍼레이터

## 103p

**combineLatest과 Pair를 사용하여 대기 처리**

> 람다식의 인수와 메소드의 임시 변수가 일치하는 경우에는, 아래와 같이 메소드 Reference라는 문법을 쓸 수 있습니다.

## 104p ~ 111p

**예) "스테이크"의 레시피를 검색 + 관련 광고의 검색**

```
// 광고정보를 취득하는 메소드라고 생각해주세요

pair.first // 레시피의 리스트
pair.second // 광고 정보
```

> combineLatest의 대체로 zip 오퍼레이터를 사용할 수도 있습니다.

## 112p

**combineLatest를 사용시 주의점**

- 한쪽 처리가 실패 시 onError가 호출되는 문제
- 병렬처리하는 Observable의 실행 스레드의 문제

## 113p ~ 118p

예) 레시피 취득에 성공, 광고 취득에 실패한 경우

"스테이크"로 검색

- 스테이크 레시피를 취득
- **광고 정보 읽기에 실패**
 - onError가 호출되어, Reload화면이 표시된다
 - 레시피 정보는 취득했으므로, 광고가 실패해도 리스트는 표시하고 싶다

## 119p

**RxJava에서의 에러 처리 (1)**

> onErrorReturn을 정의하므로, Subscriber에 error가 통지되지 않게 된다.

## 120p ~ 125p

**광고를 검색하는 Observable에 에러처리를 추가한다**

```
예외가 발생한 경우에 빈 데이터를 반환
```

onError가 호출되지 않고, onNext에 빈 광고정보가 전달되게 된다

## 126p ~ 129p

**병렬처리하는 Observable에 실행 스레드 문제**

```
searchRecipe의 처리가 종료한 후에 실행된다
```

- searchRecipe()과 searchAd()는 subscribeOn이 미지정 상태
- 이 경우 combineLatest의 내부는 하나의 스레드로 실행된다

> combineLatest는 병렬처리하지만, 스레드가 블락되어서 병렬처리가 안 되는 경우도 있습니다.

## 130p

내부의 Observable에도 subscribeOn을 지정해서, 각각에 별도 스레드를 할당한다

→ combineLatest의 내부가 병렬처리되게 되었다

## 131p

**갑자기 광고팀으로부터의 요청**

"광고 API 서버는 일시적으로 불안정하므로, 2번까지 재요청 처리를 해주세요"

## 132p

**RxJava에서의 에러 처리 (2)**

```
// 예외가 발생한 경우 한번만 Retry한다
```

## 133p

광고를 검색하는 Observable에 추가로 수정한다(Retry 추가)

## 134p

**신기능 추가 2**

"검색화면에 Like 버튼을 추가합시다"

## 135p ~ 136p

**Like 버튼 사양**

1. 오른쪽 위에 Like 버튼이 추가된다
2. 버튼을 누르면 즐겨찾기에 보존된다
3. Like 상태는 별도 API에서 취득

**Like API 사양**

레시피 id의 리스트를 보내면 이미 보존되어있는 레시피 id가 반환된다

## 137p

**레시피 정보의 취득 흐름**

1. "스테이크"로 검색
2. 스테이크의 레시피 리스트를 취득 (Search API)
 - 비동기처리의 직렬화
3. Like 상태를 취득 (Like API)
4. 레시피 데이터에 Like 상태를 머지

## 138p ~ 142p

RxJava에서의 비동기처리의 직렬화

## 143p ~ 145p

```
// 레시피 리스트를 그대로 전달한다
// 레시피 리스트로부터 Like한 레시피 Id를 취득

// map에서 Like상태를 레시피 인스턴스에 반영시킨다(생략)
```

> Observable.just(x)는 x를 Observable로 감싸는 메소드입니다

## 146p

**(추가자료) 직렬처리만을 연결하는 패턴**

> [https://twitter.com/takuji31/status/700151575948316672](https://twitter.com/takuji31/status/700151575948316672) 씨의 지적대로 map으로 연결해도 괜찮겠네요

## 147p

레시피를 검색 + like 상황을 알아보는 메소드를 작성

```
// Like상태를 레시피 인스턴스에 반영시킨다(생략)
```

## 148p

최종적인 검색 화면의 흐름을 확인해봅시다

## 149p ~ 161p

검색 화면의 최종적인 흐름도

"스테이크"로 검색

- 스테이크 레시피를 취득
 - 레시피의 Like 상태를 취득
- 스테이크 관련 광고를 취득
 - 최대 2회 Retry 처리
 - 실패한 경우 빈 데이터를 반환
- 대기 처리
- 전체 정보 (레시피 + Like 상태 + 광고)가 리스트에 표시된다

## 162p

레시피를 검색 & like 상황을 취득 + 관련 광고 검색

> 복잡한 처리라도 코드의 가독성이 보장되는 것이 RxJava를 사용하는 매력이죠

## 163p

정리 + 보충

## 164p

**RxJava에서의 병렬처리**

위의 예에서는 2개의 Observable의 대기하는 결합이지만, 2~9, N개의 대기하는 결합이 가능한 메소드가 있습니다

## 165p

**RxJava에서의 직렬처리**

> flatMap은 flatMap(Observable::from)으로 리스트를 각 요소를 분할시킬 때에도 사용합니다.

## 166p

**2개이상의 벙렬처리를 하는 경우**

2개의 Observable를 combineLatest로 대기시킨 결합하는 경우에는 Pair로 값을 합성합니다만, 3개　이상의 경우에는 Pair를 확장한 Tuple3, Tuple4를 사전에 만들어서 이용하고 있습니다.

> Tuple5도 잠시 있었지만, Tuple4까지 있으면 대부분의 요구 사항을 충족시킬 것입니다.

## 167p

보다 많은 병렬처리를 하고 싶은 경우

앞서 기술한 대로 combineLatest를 사용하면 복잡한 처리를 병렬로 실행할 수 있지만, Android 환경에서는 최대 16 병렬까지만으로 제한되어 있습니다. 아래와 같이 SystemProperty로 변경이 가능합니다.

> [https://github.com/ReactiveX/RxJava/issues/1820](https://github.com/ReactiveX/RxJava/issues/1820) 에서 자세하게 설명하고 있습니다

## 168p

그 외 / Tips

## 169p

**특수한 용도의 Observable**

Http Request등 한번만 이벤트가 오는 Observable

다른 언어에서 말하는 Promise와 같은 것

> 이번 슬라이드에서 Observable를 사용한 곳에는 전부 Single로 변경할 수가 있습니다.

## 170p

**특수한 용도의 Observable**

POST Request등, 별도로 값이 반환되지 않는 경우의 Observable의 성공 or 실패만을 알고 싶은 경우에 사용한다. 값은 전혀 오지 않는다.

> 특별히 필요하지 않는데 Response이나 null을 전달한다면, Single이나 Completable를 잘 사용하고 싶겠네요

## 171p

감사합니다 (친목회에서 많이 이야기 합시다)
