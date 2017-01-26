---
layout: post
title: "[번역] FragmentTransaction에 새롭게 추가된 commitNow()에 대해"
date: 2017-01-26 11:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [FragmentTransactionに新たに追加されたcommitNow()について](http://qiita.com/kakajika/items/7a7e08ec9923ff478ade) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

[Android 제 3 Advent Calendar](http://qiita.com/advent-calendar/2016/android_third)의 8일째를 담당하고 있는 kakajika라고 합니다.

전자 서적 뷰어 어플같은 것을 만들고 있습니다.

며칠 전 Android 제 2 Advent Calendar에서 [kikuchy 씨로 인해 Fragment에 관한 기사](http://qiita.com/kikuchy/items/ea2da334384cf34ba823)에 자극받아, Advent Calendar에 처음 참가해봤습니다. Android를 시작한 것이 Fragment 전성기? Android 4.0 (Ice Cream Sandwich) 때이기도 했고, Fragment와는 오랫동안 알고 지낸 관계입니다. :sweat_smile:

기사 중에 `FragmentTransaction#commit()`의 처리 타이밍에 관한 이야기가 있었습니다만 조금 정보가 오래되었다고 생각해서 support-v4:24.0.0에 추가된 비교적 새로운 API로 그다지 정보가 보이지 않는 `FragmentTransaction#commitNow()`에 대한 동작 검증도 엮어서 소개할까 합니다.

또한 검증에 사용한 서포트 라이브러리는 현재 최신 25.0.1입니다.

## 먼저 공식 Javadoc의 설명

[https://developer.android.com/reference/android/support/v4/app/FragmentTransaction.html#commitNow()](https://developer.android.com/reference/android/support/v4/app/FragmentTransaction.html#commitNow())

> Commits this transaction synchronously. Any added fragments will be initialized and brought completely to the lifecycle state of their host and any removed fragments will be torn down accordingly before this call returns.

commitNow()라는 메소드 이름 그대로이지만 동기적으로 트랜잭션 처리를 해주는 것 같습니다.

> Committing a transaction in this way allows fragments to be added as dedicated, encapsulated components that monitor the lifecycle state of their host while providing firmer ordering guarantees around when those fragments are fully initialized and ready. Fragments that manage views will have those views created and attached.

또한, 호스트의 생명 주기를 감시하고 적절한 타이밍에 View를 생성하고 연결해주는 것 같습니다.

이것만으로는 어떻게 움직이는지 확실히는 모르기 때문에 실제로 움직여 검증해 봅시다.

## 실제 어떤 움직임을 하는가

다음과 같은 코드로 검증합니다 (layout에 이미 Fragment1 이 추가되어있는 것으로 합니다)

```
// Activity.kt
log("Transaction: begin")
supportFragmentManager
        .beginTransaction()
        .replace(R.id.layout, Fragment2())
        .commitNow()
log("Transaction: end")
```

Fragment의 생명 주기를 로그에 출력해 봅니다

```
// Logcat
Transaction: begin
Fragment2: onAttach
Fragment2: onCreate
Fragment1: onPause
Fragment1: onStop
Fragment1: onDestroyView
Fragment2: onCreateView
Fragment2: onViewCreated
Fragment2: onActivityCreated
Fragment2: onStart
Fragment2: onResume
Transaction: end
Fragment1: onDestroy
Fragment1: onDetach
```

commitNow()가 끝난 시점에서 Fragment의 교체가 완료되어 있는 것을 알 수 있군요! :smile_cat:

또한, Activity의 `onCreate()`에서 commitNow()를 부른 경우 이렇게 됩니다

```
// Logcat
Transaction: begin
Fragment2: onAttach
Fragment2: onCreate
Fragment1: onDestroy
Fragment1: onDetach
Transaction: end
Fragment2: onCreateView
Fragment2: onViewCreated
Fragment2: onActivityCreated
Fragment2: onStart
Fragment2: onResume
```

Activity 측의 준비가 끝날 때까지는 View의 생성 및 추가할 수 없기 때문에, `onCreateView()` 이후로 미뤄주는 것 같습니다.

어쨌든 commitNow()가 끝난 시점에서 적어도 `onAttach()`와 `onCreate()`까지 완료되어 있는지 알 수 있습니다. commitNow() 직후에 `FragmentManager#findFragmentById()` 를 부른 경우도 제대로 최신의 항목을 얻을 수 있습니다.

지금까지 Fragment가 추가되는 타이밍때문에 골머리를 썩이고 온 분들에게는 기쁜 소식이네요. :innocent:

### childFragmentManager를 사용한 경우

조금 복잡하지만 레이아웃이 Nested 되어있는 경우를 고려하여 Fragment2의 onCreate()에서 childFragmentManager를 사용하여 ChildFragment를 추가해 봅니다

```
// Fragment2.kt
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    log("TransactionChild: begin")
    childFragmentManager
            .beginTransaction()
            .replace(R.id.layout_inner, ChildFragment())
            .commitNow()
    log("TransactionChild: end")
}
```
```
// Logcat
Transaction: begin
Fragment2: onAttach
Fragment2: onCreate
    TransactionChild: begin
    ChildFragment: onAttach
Fragment2: onAttachFragment
    ChildFragment: onCreate
    TransactionChild: end
Fragment1: onPause
Fragment1: onStop
Fragment1: onDestroyView
Fragment2: onCreateView
Fragment2: onViewCreated
Fragment2: onActivityCreated
    ChildFragment: onCreateView
    ChildFragment: onViewCreated
    ChildFragment: onActivityCreated
Fragment2: onStart
    ChildFragment: onStart
Fragment2: onResume
    ChildFragment: onResume
Transaction: end
Fragment1: onDestroy
Fragment1: onDetach
```

이쪽도 childFragmentManager의 commitNow()가 끝난 시점에서 ChildFragment가 추가되어있어 문제없을 것입니다. 생명주기도 부모의 Fragment에 제대로 bind 되어있는 것을 알 수 있습니다.

### 덤 : FragmentTransaction#commit() 이라면...

일단 commitNow() 대신 `commit()` 을 사용한 경우의 로그는 이렇게 되었습니다

```
// Logcat
Transaction: begin
Transaction: end
Fragment2: onAttach
Fragment2: onCreate
Fragment1: onPause
Fragment1: onStop
Fragment1: onDestroyView
Fragment2: onCreateView
Fragment2: onViewCreated
Fragment2: onActivityCreated
Fragment2: onStart
Fragment2: onResume
Fragment1: onDestroy
Fragment1: onDetach
```

Handler에 post해서 처리를 뒤로 미뤘기 때문에 당연하네요.

물론, commit() 직후에 `FragmentManager#findFragmentById()`를 호출해도 기대한 결과는 반환되지 않습니다.

## executePendingTransactions()와 비교한 장점

Javadoc에는

> Calling commitNow is preferable to calling commit() followed by executePendingTransactions() as the latter will have the side effect of attempting to commit all currently pending transactions whether that is the desired behavior or not.

이전에는 commit()을 한 후 `executePendingTransactions()`를 불러 트랜잭션 실행을 기다리는 방법이 있었지만, 이 방법은 자신과는 관계없는 모든 트랜잭션에 대해서도 그 자리에서 실행해 버리기 때문에 그 점에서 자신만 즉시 실행하는 `commitNow()` 쪽이 낫다는 것입니다.

## 주의해야 할 점

### commit()과 같이 사용하지 않는 것이 좋을 듯

동기적으로 처리하는 `commitNow()`에 대해서 `commit()`은 Handler에 처리를 post 하므로 2개를 연속으로 사용한 경우에 순서대로 처리되지 않는 문제가 발생합니다.

예를 들어 다음과 같은 코드를 실행하면

```
// Activity.kt
log("Transaction1: begin")
supportFragmentManager
        .beginTransaction()
        .replace(R.id.layout, Fragment2())
        .commit()
log("Transaction1: end")

log("Transaction2: begin")
supportFragmentManager
        .beginTransaction()
        .replace(R.id.layout, Fragment3())
        .commitNow()
log("Transaction2: end")
```
```
// Logcat
Transaction1: begin
Transaction1: end
Transaction2: begin
Fragment3: onAttach
Fragment3: onCreate
Fragment1: onPause
Fragment1: onStop
Fragment1: onDestroyView
Fragment3: onCreateView
Fragment3: onViewCreated
Fragment3: onActivityCreated
Fragment3: onStart
Fragment3: onResume
Transaction2: end
Fragment2: onAttach
Fragment2: onCreate
Fragment3: onPause
Fragment3: onStop
Fragment3: onDestroyView
Fragment2: onCreateView
Fragment2: onViewCreated
Fragment2: onActivityCreated
Fragment2: onStart
Fragment2: onResume
Fragment1: onDestroy
Fragment1: onDetach
Fragment3: onDestroy
Fragment3: onDetach
```

이처럼 두 번째 처리가 선행되는 결과로 화면에는 Fragment2가 표시되어 버렸습니다.

향후 서포트 라이브러리측이 수정될 가능성도 있지만, commitNow()를 사용하는 경우에는 동일한 대상에 대해서 `commit()`은 사용하지 않도록 하는 것이 무난한 것 같습니다.

### BackStack은 사용할 수 없다

> Transactions committed in this way may not be added to the FragmentManager's back stack, as doing so would break other expected ordering guarantees for other asynchronously committed transactions. This method will throw IllegalStateException if the transaction previously requested to be added to the back stack with addToBackStack(String).

## 요약: commitNow 편리!

이상으로 Fragment의 곤란한 포인트를 하나 해소해 주는 (그럴지도 모르는) commitNow()의 소개였습니다!

실제로 프로젝트에서도 사용하고 있습니다만 Fragment 전환시의 처리 흐름이 알기쉬워 상당히 편리하게 느꼈습니다.

첫 Advent Calendar에 서투른 기사였지만, 조금이라도 여러분의 도움이 되었으면 합니다.