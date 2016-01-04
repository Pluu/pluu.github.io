---
layout: post
title: "[번역] RxAndroid를 가볍게 써보자"
date: 2015-04-28 23:30:00
tag: [Android, RxAndroid, RxJava]
categories:
- blog
- Android
- Rx
---

이 포스팅은 [RxAndroidをカジュアルに使ってみるとか](http://kirimin.hatenablog.com/entry/2015/02/11/221228) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

RxAndroid는 RxJava를 포함하며 Android에서 이용하기위해 기능을 추가한것입니다.

[RxAndroid](https://github.com/ReactiveX/RxAndroid)

RxJava의 개요와 기본적인 사용방법에 대해서는 과거의 포스팅에서 소개하고있습니다.

과거 포스팅내에서「실제 Android 어플에서 UseCase에 맞춘 예를 적어보겠습니다」라고 적고 그뒤로 3개월 이상 방치했습니다.

[RxJavaについて調べた試した](http://kirimin.hatenablog.com/entry/20141012/1413126770)

RxJava는 다기능이며 FRP라는 새로운 개념에 근거해 설계되어, 자유자재로 쓰기에는 상당한 학습 시간이 필요하기때문에, 이용하기에는 진입장벽이 높다고 느끼지않을까요.

하지만, 거기까지 RxJava를 깊게 이해하며 여러 함수를 이용하지않아도, RxAndroid는 마음편하게 이용할수 있지않는가라는 생각이 들었기때문에, RxAndroid의 활용 케이스를 고려해보자고 생각햇습니다.

## AsyncTask등 대체로 비동기 콜백처리를 이용하기

RxAndroid를 사용하면, 비동기 처리를 간단하게 기술할 수가 있습니다.

onCompleted나 onError등의 구조가 정의되어있기때문에 사용하기 쉽습니다.


```java
Observable
        .create(new Observable.OnSubscribe<Integer>() {
            @Override
            public void call(Subscriber<? super Integer> subscriber) {
                for (int i = 0; i < 100; i++) {
                    // 무거운 처리
                    subscriber.onNext(i);
                }
                subscriber.onCompleted();
            }
        })
        .subscribeOn(Schedulers.newThread())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new Observer<Integer>() {
            @Override
            public void onCompleted() {
                // 처리완료 콜백
            }

            @Override
            public void onError(Throwable e) {
                // 처리시 예외가 발생하면 자동적으로 onError가 호출됨
            }

            @Override
            public void onNext(Integer progress) {
            }
        });
```

포인트는 subscribeOn 메소드와 observeOn 메소드에서, 각각의 처리와 콜백을 어떤 스레드에서 실행할건지 지정할 수 있습니다.

즉, 비지니스 로직의 반환값을 Observable로 랩핑함으로, 이용하는 쪽이 간단하게 동기/비동기를 바꾸는것이 가능합니다.

## API 통신의 공통 인터페이스로 이용하기

위의 예를 응용하여, API 통신 처리를 Observable로 랩핑함으로, API 결과를 공통 인터페이스로 간단하게 처리하도록 해봅십니다.

우선 APi 통신 처리를 정의합니다.(예시이므로 세심한 부분은 생략합니다만, 문자열배열을 반환하는 API 형태입니다.)


```java
class SampleApi {

    public static Observable<String> request() {
        return Observable.create(new Observable.OnSubscribe<String>() {
            @Override
            public void call(Subscriber<? super String> subscriber) {
                List<String>　results = xxxx; // 통신처리
                for(String s : results){
                    subscriber.onNext(s);
                }
                subscriber.onCompleted();
            }
        });
    }
}
```

API를 이용하는 쪽은, 위에서 정의한 메소드를 단순하게 호출하는 것으로 간단하게 비동기 콜백처리가 이루어집니다.


```java
SampleApi.request()
        .subscribeOn(Schedulers.newThread())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new Observer<String>() {
            @Override
            public void onCompleted() {
            }

            @Override
            public void onError(Throwable e) {
            }

            @Override
            public void onNext(String s) {
            }
        });
```

또한, Observable로 랩핑함으로, 통신과 콜백의 사이에 여러가지 함수 처리를 두는것이 가능하여 매우 편리합니다. 아래의 예는 「공백 결과는 생략하고, 모두 대문자로 변환하고, 최초 10건만 처리」를 onNext에 전달하도록 처리를 추가한것입니다.


```java
SampleApi.request()
        .subscribeOn(Schedulers.newThread())
        .observeOn(AndroidSchedulers.mainThread())
        .filter(new Func1<String, Boolean>() {
            @Override
            public Boolean call(String s) {
                return !s.isEmpty();
            }
        })
        .map(new Func1<String, String>() {
            @Override
            public String call(String s) {
                return s.toUpperCase();
            }
        })
        .take(10)
        .subscribe(new Observer<String>() {
            @Override
            public void onCompleted() {
            }

            @Override
            public void onError(Throwable e) {
            }

            @Override
            public void onNext(String s) {
            }
        });
```

그외에도 Observable를 합성하는것도 가능함으로, 복수의 API가 엮인 처리도 간결하게 작성할수 있습니다.

## View의 이벤트를 수신

RxAndroid에는 View의 이벤트 수신만을 위한 Observable를 생성하는 클래스가 정의되어 있습니다.

클릭 이벤트를 취득하기위해 ViewObservable.clicks 등, TextView의 변경을 취득하는 WidgetObservable.text, ListView의 onScroll를 취득하기위한 listScrollEvents 등이 있습니다.


```java
WidgetObservable.listScrollEvents(mListView)
        .subscribe(new Action1<OnListViewScrollEvent>() {
            @Override
            public void call(OnListViewScrollEvent onListViewScrollEvent) {

            }
        });
```

이런 이벤트도 여러가지 필터 처리를 사용하거나 복수 이벤트를 사용하는것도 가능하여, 복잡한 요건에 대해서 유연하게 대응할 수 있습니다.

View의 이벤트말고도 SheredPreference, Cursor 이벤트를 알려주는 메소드도 정의되어있습니다.

## 콜백 제거를 일괄처리

그런데 비동기 콜백 처리완료되면, 결과가 반환될때에는 화면이 종료되어 Crash 되는 사태 일어나는 버그를 자주 저지릅니다.

RxJAva에는 Subscription(subscribe 메소드를 호출할때의 반환값)에 대한 unsubscribe 메소드를 호출함으로 콜백을 해제 할수있습니다.

게다가 CompositeSubscription라는 클래스는 복수의 Subscription를 모아두어 한번에 해제 할수가 있기때문에, 아래와 같이 화면이 파기될 순간에 unsubscribe를 처리함으로, 안심하고 콜백을 받을 수 있습니다.


```java
public class MainFragment extends Fragment {

    private CompositeSubscription subscriptions = new CompositeSubscription();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        subscriptions.add(SampleApi.request()
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<String>() {
                    @Override
                    public void onCompleted() {
                    }

                    @Override
                    public void onError(Throwable e) {
                    }

                    @Override
                    public void onNext(String s) {
                    }
                }));
        subscriptions.add(Observable.from(new String[]{"a", "b", "c"})
                .subscribe(new Action1<String>() {
                    @Override
                    public void call(String s) {
                    }
                }));
        return rootView;
    }

    @Override
    public void onDestroyView() {
        subscriptions.unsubscribe();
        super.onDestroyView();
    }
}
```

아무래도 제대로 unsubscribe하지 않으면 메모리 릭이 일어남으로, 좌우간 전부 unsubscribe 하는편이 좋습니다.

※참고

[Android - RxJavaでAPIクライアントを作る - Qiita](http://qiita.com/rejasupotaro/items/18f3b7c62ab071c9fee5)

## 유행할까?

[Mitsumine](https://github.com/kirimin/mitsumine) 개발에 RxAndroid를 도입해보고, 그다지 자유자재로 쓰지않아도 편리했기때문에 소개해봤습니다.

RxJava는 최근 조금씩 화제가 됐다고 생각이 듭니다만, 아직까지는 일부 사용자들만의 인기로 일반적으로는 그다지 알려지지 않았나라고 생각합니다.

개인적으로는 편리하니깐 개인 개발에는 적극적으로 사용해나가겠지만, 역시나 학습 시간이 높기도 하고, RxAndroid는 아직 버전 0.24로 가볍게 메소드의 이동이나 삭제가 이루어지고 있는 상태이므로, 업무 프로젝트에 도입하는 것은 어려울지도 모르겠습니다.

그리고, 역시나 Android의 경우 lambda가 없는것이 치명적입니다. 최근에는 완전히 체념하고 Groovy를 사용할수밖에 없는것이 아닌가라는 생각이 듭니다.

map이나 filter에 전달하는 Func을 메소드의 반환값으로 하거나 static 변수로 정의하거나 하면 호출하는 측의 가독성은 올라가지만 뭔가 본말전도인것 같기도 합니다.
