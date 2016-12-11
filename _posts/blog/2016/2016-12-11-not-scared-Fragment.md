---
layout: post
title: "[번역] 두렵지않아! Fragment"
date: 2016-12-11 17:50:00 +09:00
tag: [Android, Fragment]
categories:
- blog
- Android
---

본 포스팅은 [こわくない！ Fragment](http://qiita.com/kikuchy/items/ea2da334384cf34ba823) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

이 문서는 [Android ２ Advent Calendar 2016](http://qiita.com/advent-calendar/2016/android_second) 6일째 기사입니다.

- - -

Fragment 두렵나요? 무섭지요.

흥미 혹은 필요에하게되어 Fragment를 사용하여 고생한적이있는 Android 엔지니어가 대부분일거라고 생각합니다.

모두의 트라우마 Fragment.

너무 까다로워 [Square는 Fragment와 결별을 선언하고 있고](http://ninjinkun.hatenablog.com/entry/2014/10/16/234611), [실제로 Fragment를 버리기위한 라이브러리도 만들어 쓰기도]((https://github.com/square/mortar))합니다.

모두 Fragment에 믿는 도끼에 발등 찍히고 있네요.

그러나 Fragment가 유용한 경우나 Fragment의 사용이 적극 권장되는 일도 있지요.

- ViewPager에서 대화형 페이지를 표시하고 싶다
- 다이얼로그를 표시하고 싶다
- 화면을 구성하는 부품의 외형과 로직을 재이용하고 싶다
- etc ...

애초에 CustomeView만으로 모든 것을 하는것도 힘들거나...

제반사정으로 Fragment를 사용하지 않으면 안되는 경우에 제대로 Fragment와 함께하는 방법을 SupportFragment의 구현을 보면서 생각해 봅시다.

구현을 알면 함정도 함정이 아니게됩니다!

## 함정

### 생성자에서 매개변수를 전달 -> 화면회전 후에 파라미터를 취득할수 없다

Fragment 쓰기시작할때 잘 빠지는 함정입니다.

```
// Activity or 부모 Fragment 쪽
HogeFragment f = new HogeFragment();
f.hoge = "hoge";
// commit


// HogeFragment의 구현
public void onSomeCallback() {
    String s = this.hoge;     // -> Fragment의 재생성이 한번이라도 발생하면 null
    textView.setText(s);
}
```

표준 Fragment는 화면 회전시 인스턴스가 재생성됩니다. (Do not keep Activities.이 OFF라도!)

Fragment에 어떤 매개 변수를 전달할 때에는 [setArguments](https://developer.android.com/reference/android/app/Fragment.html#setArguments(android.os.Bundle))를 사용합시다.

```
Bundle arg = new Bundle();
arg.putString("ARG1", "hoge");
arg.putString("ARG2", "fuga");
HogeFragment f = new HogeFragment();
f.setArguments(arg);

// 이러한 작업은 HogeFragment 클래스쪽에 두는것이 괜찮은 구현방법이므로
// HogeFragment f = HogeFragment.newInstance("hoge", "fuga");
// 라는 함수 newInstance를 두는편이 좋네요.
```

는 자주 듣습니다만...

전달 된 Bundle은 어디로 가는것일까요.

Fragment 구현을 조금 들여다 봅시다.

#### Fragment의 메타 상태를 유지하는 FragmentState가 있다

SupportLibrary의 Fragment 파일을 보면 [setArguments()의 구현](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/master/v4/java/android/support/v4/app/Fragment.java#63)은 이렇게 되어 있습니다.

```
// android/support/v4/app/Fragment.java
    public void setArguments(Bundle args) {
        if (mIndex >= 0) {
            throw new IllegalStateException("Fragment already active");
        }
        mArguments = args;
    }
```

`mArguments`에 Bundle을 대입하기만 할뿐입니다. 반대로 `getArguments`는 `mArguments`의 내용을 반환 할 뿐.

라이프 사이클의 사정으로 인스턴스가 사라져도 상태를 유지하기 위해서는 Parcelable에 값을 저장해야한다는 것.
실제 저장은 같은 파일 내의 `FragmentState`에서 이루어지고있는 것 같습니다.

`FragmentState`는 Percelable을 계승하고 CREATOR 클래스를 안고있는 등 전형적인 Percelable로 되어 있습니다.
`savedInstanceState`으로 개발자가 다룰 수 있는 Bundle 외에 Fragment 레이아웃 파일에서 inflate 된 것인지 여부, inflate 대상 ViewGroup의 id 등 Fragment 메타 상태를 취급하는것이 이 클래스의 역할입니다.

그 중 하나로 Arguments의 유지도 하고 있습니다.。

[writeToParcel()에서 Parcel에 쓰고](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/master/v4/java/android/support/v4/app/Fragment.java#142), [Parcel에서 복원시 로드](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/master/v4/java/android/support/v4/app/Fragment.java#92), 더욱이 [Fragment 복원시에 Fragment에 bundle을 재작성](https://android.googlesource.com/platform/frameworks/support/+/refs/heads/master/v4/java/android/support/v4/app/Fragment.java#105)합니다.

```
// android/support/v4/app/Fragment.java
final class FragmentState implements Parcelable {

    ...

    final Bundle mArguments;

    ...

    public FragmentState(Parcel in) {

        ...
        // Parcel에서 arguments를 복원
        mArguments = in.readBundle();

        ...
    }

    // Fragment를 재생성
    public Fragment instantiate(FragmentHostCallback host, Fragment parent,
            FragmentManagerNonConfig childNonConfig) {
        if (mInstance == null) {
            final Context context = host.getContext();
            if (mArguments != null) {
                mArguments.setClassLoader(context.getClassLoader());
            }
            mInstance = Fragment.instantiate(context, mClassName, mArguments);

            ...

        return mInstance;
    }

    public void writeToParcel(Parcel dest, int flags) {

        ...
        // Parcel에 저장
        dest.writeBundle(mArguments);

        ...
    }
```

이렇게하여 setArguments에서 전달된 값은 저장되어있었습니다.

이로서 Fragment가 파기되어도 Arguments가 유지되는 구조가 알게되었습니다.
Arguments를 Bundle에서 취급하는 이유도 왠지 알 것입니다.

이제 다음부터는 잊지않고 setArguments을 사용할 수 있게 되었어요! !

### requestCode를 65535보다 큰 숫자로 startActivityForResult() -> 예외

Fragment에서도 `startActivityForResult()`를 사용할 수 있으며 Activity 결과를 Fragment의 `onActivityResult()`에서 처리 할 수 있습니다.

그 때 `requestCode`를 지정합니다.

여기에 적당히 선택한 값을 사용하면 IlligalStateException가 발생 할 수 있습니다.

```
// MyFragment.java
startActivityForResult(new Intent(getContext(), NextActivity.class), 65536);

// -> java.lang.IllegalArgumentException: Can only use lower 16 bits for requestCode
```

16비트 이하의 값을 사용하라고합니다.
이것도 잘 알려져 있지요.

그러나 Java의 int는 32비트 정수일텐데... 왜 16비트인가 ...

#### FragmentActivity가 `startActivityForResult`를 발행직전에 트릭이 있다

Fragment의 `startActivityForResult`에서 코드를 따라가다보면 이런 코드와 마주칩니다.

```
// android/support/v4/app/FragmentActivity.java
    public void startActivityFromFragment(Fragment fragment, Intent intent,
            int requestCode, @Nullable Bundle options) {

        // Fragment에서의 startActivityForResult인지 판단 플래그
        mStartedActivityFromFragment = true;
        try {
            if (requestCode == -1) {
                ActivityCompat.startActivityForResult(this, intent, -1, options);
                return;
            }

            // checkForValidRequestCode가 16비트 이하인지 검사하고 예외를 던진다
            checkForValidRequestCode(requestCode);

　　　　　　　// Activity가 안고있는 Fragment 중
             // 어떤 Fragment가 startActivityForResult를 호출했는지를 기록하고있다
             // 테이블이 있고 거기에 Fragment(를 고유하게 식별하는 이름)을 추가하고 있다
            int requestIndex = allocateRequestIndex(fragment);

            // 상위 16비트에 테이블의 indext를 채우고
            // 하위 16비트에 원래의 requestCode를 채워 Activity를 호출
            ActivityCompat.startActivityForResult(
                    this, intent, ((requestIndex + 1) << 16) + (requestCode & 0xffff), options);
        } finally {
            // 호출이 끝나면 플래그를 닫는다
            mStartedActivityFromFragment = false;
        }
    }
```

32비트 중 상위 16비트씩 다른 용도로 사용하고 있기때문에 16비트에 맞춰라고 말하는 것이군요.

덧붙여서 FragmentActivity에서 `startActivityForResult()`를 호출할 때에도 [requestCode가 16비트 이하인지 체크됩니다](https://android.googlesource.com/platform/frameworks/support.git/+/master/v4/java/android/support/v4/app/FragmentActivity.java#863).

```
// android/support/v4/app/FragmentActivity.java
    public void startActivityForResult(Intent intent, int requestCode) {
        // Fragment에서의 호출인 경우는 이미 16비트 이하 여부를 체크했습니다.
        // 상위 16비트가 0x0000인 경우에는 Activity에서 호출이라고 판단하기 위해
        // Activity에서 requestCode도 16비트 이하인 것을 확인한다.
        if (!mStartedActivityFromFragment) {
            if (requestCode != -1) {
                checkForValidRequestCode(requestCode);
            }
        }
        super.startActivityForResult(intent, requestCode);
    }
```

`startActivityForResult()` 할 떄 Fragment 말고도 16비트 이하의 requestCode로 하는것이 좋을 것 같네요.

### FragmentTransaction#commit() 직후에 Fragment 내에서의 context 사용 -> NPE

경우에 따라서는 Activity에서 Fragment에 뭔가 작업ㅇ르 의뢰하고 싶을 때가 있지요.

```
getSupportFragmentManager().
        beginTransaction().
        add(R.id.placeholder, HogeFragment.newInstance()).
        commit();
HogeFragment h = (HogeFragment) getSupportFragmentManager().
        findFragmentById(R.id.placeholder);


h.doHoge();   // -> NullPointerException
```

Fragment는 행방불명인 것 같습니다. :innocent:

그렇다면 이것은 어때？

```
// Fragment 인스턴스를 유지한다
HogeFragment h = HogeFragment.newInstance();
getSupportFragmentManager().
        beginTransaction().
        add(R.id.placeholder, h).
        commit();

h.doHoge();   // -> 안에서 getString() 등 context를 사용하는 조작이 있으면 IllegalStateException
```

이렇게 `commit()`는 비동기로 실행되는 것입니다.

Activity에 attach 되는 것은 잠시 후!

그러니 context를 사용할 수있는 것도 잠시 후!

이것도 잘 알려진 함정.
`executePendingTransactions()`를 사용하면 해결할 수 있습니다.

그러나 `executePendingTransactions()`를 호출할 정도로 서두르지 않기 때문에 Fragment가 attach 된 후에 하고 싶은 처리가 있다...
Activity에 뭔가 interface를 구현하여 `Fragment#onAttach()` 쪽에 Activity를 호출하면 좋을지도 모르지만, 거기까지 귀찮은 것은 원치 않아 ...
(업무라면 귀찮아하지말고 구현하자)

#### commit의 비동기 처리는Looper가 담당하고 있다

`FragmentTransaction#commit()`에서 처리를 따라 가다 보면, [FragmentManager#enqueueAction()](https://android.googlesource.com/platform/frameworks/support.git/+/master/v4/java/android/support/v4/app/FragmentManager.java#1543)에 도착합니다.

```
// android/support/v4/app/FragmentManager.java
    // action은 BackStackRecord(Runnable를 구현하고있다)가 들어간다.
    public void enqueueAction(Runnable action, boolean allowStateLoss) {
            ...

            // mPendingActions는 action을 보관할 List
            mPendingActions.add(action);

            // 대기중인 것이 지금 추가 한 action 밖에 없으면,
            // Activity와 같은 스레드 Looper에 메시지를 던지는 Handler에 post
            if (mPendingActions.size() == 1) {
                mHost.getHandler().removeCallbacks(mExecCommit);
                mHost.getHandler().post(mExecCommit);
            }
        }
    }
```

[mExecCommit](https://android.googlesource.com/platform/frameworks/support.git/+/master/v4/java/android/support/v4/app/FragmentManager.java#529)는 `FragmentManager#execPendingActions()`를 호출할 뿐이므로 [execPendingActions()](https://android.googlesource.com/platform/frameworks/support.git/+/master/v4/java/android/support/v4/app/FragmentManager.java#1641)을 살펴보자.

```
// android/support/v4/app/FragmentManager.java
    public boolean execPendingActions() {
        ...

        while (true) {
            int numActions;

            synchronized (this) {
                ...

                // mPendingActions에서 mTmpActions에 Runnable를 옮겨.
                // 아마도 synchronized 되는 시간을 단축하기 위하여.
                numActions = mPendingActions.size();
                if (mTmpActions == null || mTmpActions.length < numActions) {
                    mTmpActions = new Runnable[numActions];
                }
                mPendingActions.toArray(mTmpActions);
                mPendingActions.clear();
                mHost.getHandler().removeCallbacks(mExecCommit);
            }

            // 모여있던 commit 처리를 실행
            mExecutingActions = true;
            for (int i=0; i<numActions; i++) {
                mTmpActions[i].run();
                mTmpActions[i] = null;
            }
            mExecutingActions = false;
            didSomething = true;
        }

        // Fragment의 상태를 변화시키는?
        doPendingDeferredStart();

        return didSomething;
    }
```

비동기 처리라고하면 [Looper와 Handler](https://realm.io/jp/news/android-thread-looper-handler/)네요.
Fragment의 commit은 무거운 처리같기 때문에 비동기로 메인 스레드에서 처리 할 수있는 타이밍이 되었을 때 처리되는 것 같습니다.

그러면 `FragmentTransaction#commit()`의 직후 메인 쓰레드의 Handler에 post하면 Fragment가 attach 된 직후 처리가 실행될 것 ...!
(메인 스레드 이외에서 FragmentManager를 만져해야한다면)

```
getSupportFragmentManager().
        beginTransaction().
        add(R.id.placeholder, HogeFragment.newInstance()).
        commit();
new Handler(Looper.getMainLooper()).post(new Runnable() {
    @Override
    public void run() {
        HogeFragment h = (HogeFragment) getSupportFragmentManager().
            findFragmentById(R.id.placeholder);

        h.doHoge();   // h는 non-null！！
    }
});
```

이런 것도 됩니다 :hugging:

## 정리

frameworks와 SupportLibrary의 코드를 읽으면 다양한 것을 알게되어 즐거워요! !

Java에서의 능숙한 작성 및 설계 방법, 다른 버전에 대한 대응 방법을 배울 수 있으며, 가끔 나쁜 예제로하자고 생각하는 부분도 발견 할 수 있습니다.
평소 Android 개발을하고있는 분이라면 Andorid의 동작을 알고 있기 때문에, 동작을 이미지하면서 코드를 읽을 수있을 것입니다.

나도 이 부근의 코드를 읽게 된 것은 최근 일이므로, 알았던 것이 있으면 수시로 전파하고 싶다고 생각합니다.

## 라이센스

Support Library의 소스 코드는 [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0) 라이센스 되어있습니다.

이 문서에서는 일부 코드를 발췌・수정해 게재하고 있습니다.
