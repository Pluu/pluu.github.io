---
layout: post
title: "[번역] RxJava 에러 처리"
date: 2015-12-11 23:40:00
tag: [RxJava, Error]
categories:
- blog
- RxJava
---

본 포스팅은 [RxJavaのエラーハンドリング](http://qiita.com/boohbah/items/108b378c5cb593c666e6) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

RxJava에서는 비동기처리 등으로 매우 유용한 라이브러리입니다만, 에러 처리도 아주 깔끔하게 할 수 있습니다. 여기에서는 RxJava의 에러 처리에 대해서 설명하려고 합니다.

## subscribe에서 에러 처리

일반적으로는 `subscribe()`에서 에러를 받아 처리합니다.


```java
Observable
  .create(new Observable.OnSubscribe<String>() {
      @Override
      public void call(Subscriber<? super String> subscriber) {
          log("subscribe");
          subscriber.onNext("emit 1");
          subscriber.onNext("emit 2");
          subscriber.onError(new Throwable());
      }
  })
  .subscribe(new Subscriber<String>() {
      @Override
      public void onCompleted() {
          log("completed");
      }

      @Override
      public void onError(Throwable e) {
          // 에러시 처리를 여기로 받음
          log("error:" + e);
      }

      @Override
      public void onNext(String s) {
          log("on next: " + s);
      }
  });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> error:java.lang.Throwable
```

주의할 부분은 아래와 같이 onNext() 처리만을 하고 있으면, onError() 발생 시에 Crash가 됩니다.


```java
Observable
   .create(new Observable.OnSubscribe<String>() {
       @Override
       public void call(Subscriber<? super String> subscriber) {
           log("subscribe");
           subscriber.onNext("emit 1");
           subscriber.onNext("emit 2");
           subscriber.onError(new Throwable());
       }
   })
   .subscribe(new Action1<String>() {
       @Override
       public void call(String s) {
           log("on next: " + s);
       }
   });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2

Crash!!
by rx.exceptions.OnErrorNotImplementedException
```

그러므로 에러가 발생할 가능성이 있는 경우는 확실히 처리합시다.

- - -

## Error 캐치

### onErrorReturn

Observable 체인 안에서 발생한 Error 를 캐치해서, 대체할 Object로 변환하는 것으로 subscriber에 Error가 전달되는 것을 막을 수 있습니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .onErrorReturn(new Func1<Throwable, String>() {
        @Override
        public String call(Throwable throwable) {
            return "return";
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> on next: return
> completed
```

에러시 무사히 return 문자열로 변환됩니다.

### onErrorResumeNext

Observable 체인에서 발생한 Error를 캐치해서, 그 안에서 다시 한 번 Observable를 호출하면 에러시 대체 Stream을 반환할 수 있습니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .onErrorResumeNext(new Func1<Throwable, Observable<? extends String>>() {
        @Override
        public Observable<? extends String> call(Throwable throwable) {
            return Observable.from(new String[]{ "resume 1", "resume 2"});
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> on next: resume 1
> on next: resume 2
> completed
```

에러시 `resume 1`, `resume 2` 의 Stream 으로 변환됩니다.

- - -

## 에러시 Rretry

### retry

`retry()` 함수는 Error가 일어났을 때, 자동으로 subscribe 다시 해주는 매우 유용한 함수입니다.


```java
Observable
   .create(new Observable.OnSubscribe<String>() {
       @Override
       public void call(Subscriber<? super String> subscriber) {
           log("subscribe");
           subscriber.onNext("emit 1");
           subscriber.onNext("emit 2");
           subscriber.onError(new Throwable());
       }
   })
   .retry()
   .subscribe(new Subscriber<String>() {
       @Override
       public void onCompleted() {
           log("completed");
       }

       @Override
       public void onError(Throwable e) {
           log("error:" + e);
       }

       @Override
       public void onNext(String s) {
           log("on next: " + s);
       }
   });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2

...성공할때까지 계속 retry 한다。。。
```

인수가 없는 `retry()` 함수는, 지금까지의 처리를 성공할 때까지 계속 retry 합니다.

이것으로는 복구할 수 없는 문제가 일어났을 때에 무한 루프가 될 수 있으므로, retry의 횟수를 제한하는 함수도 있습니다.


```java
// count: retry 횟수
public final Observable<T> retry(long count);
```

그리고, Error 상황을 보고 retry 할지를 판단할 수 있습니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retry(new Func2<Integer, Throwable, Boolean>() {
        @Override
        public Boolean call(Integer count, Throwable throwable) {
        // 2번까지 무조건 retry 한다
            if(count < 3){
                return true;
            }
        // 그 이후는 IllegalStateException 의 경우일 때만 retry 한다
            return throwable instanceof IllegalStateException;
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2
> error:java.lang.Throwable
```

### retryWhen

`retryWhen()` 함수는 조금 복잡해서 이해하기 어렵습니다만, 보다 세밀하게 retry 처리를 제어하기위한 함수입니다. `retryWhen()`의 Callback은 처음부터 retry후에 일어나는 Error를 Observable로 취득하여, 그것을 변환해서 어떤 Observable로 돌려줍니다. 그리고 Callback으로 되돌려준 Observable로 특정 값이 `onNext()` 되고, 그 타이밍에 retry 됩니다. 그리고, 그 Observable에서 `onComplete()` 혹은 `onError()`을 호출되면, 원래의 Observable가 `onComplete()` 혹은 `onError()` 종료됩니다.

조금 복잡하므로 간단하게 예를 듭니다.

#### 3초후에 retry

3초 후에 retry하는것은 아래와 같이 기술합니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.flatMap(new Func1<Throwable, Observable<?>>() {
                @Override
                public Observable<?> call(Throwable throwable) {
                    return Observable.timer(3, TimeUnit.SECONDS);
                }
            });
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후

> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후
> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후
> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후
> subscribe
> on next: emit 1
> on next: emit 2

....반복
```

#### Error인 채로 종료

Error인 채로 종료하기 위해서는


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.flatMap(new Func1<Throwable, Observable<?>>() {
                @Override
                public Observable<?> call(Throwable throwable) {
                    return Observable.error(throwable);
                }
            });
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> error:java.lang.Throwable
```

이 코드는 retryWhen 함수를 적용하지 않고, Error를 수신한 것과 같은 동작을 합니다.

#### Error를 처리하지 않고 Complete

Error를 처리하지 않고 그 자리에서 Complete하기 위해서는 다음 코드가 좋아 보이지만, 사실은 이것으로는 올바르게 동작하지 않습니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.flatMap(new Func1<Throwable, Observable<?>>() {
                @Override
                public Observable<?> call(Throwable throwable) {
                    return Observable.empty();
                }
            });
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
```

자세한 내용은 [여기](https://github.com/ReactiveX/RxJava/issues/3540)의 코드에도 있습니다만, 여기에서 flatMap해서 empty()로 반환해도, 원래 `Observable<Throwable>`의 흐름을 complete 하는 것은 아니므로, 여기에서는 무시되어 버립니다.

실제로, Error가 발생하면 급하게 `complete` 하고 싶은 처리를 작성하고 싶은 경우, 실제로 아래와 같이, error의 stream을 최초 하나만을 받아 그것을 무시한다는 코드를 작성할 필요가 있습니다. 어렵네요.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.take(1).ignoreElements();
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> completed
```

제대로 Complete 되었습니다!!

덧붙여 `take(0)`를 하면 error가 발생하기전에 갑자기 전체 Observable가 종료되어 버립니다.

여담이지만, 에러일때에 아무것도 하지않고 complete 하고 싶은 경우 onErrorResumeNext()를 사용하는 편이 간결할지도 모릅니다.


```java
.onErrorResumeNext(new Func1<Throwable, Observable<? extends String>>() {
    @Override
    public Observable<? extends String> call(Throwable throwable) {
        return Observable.empty();
    }
})
```

#### 3번 retry 하면 종료

위의 예를 바탕으로 3번 retry 하는 경우에는,


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.take(3);
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```

위와 같이 작성합니다.


```bash
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2
> subscribe
> on next: emit 1
> on next: emit 2
> completed
```

제대로 3번 retry 해서 종료합니다.

이 경우, 앞의 `retry(count)` 함수와의 차이는 `retry(count)`에서는 retry 횟수가 제한에 도달한 후에 error로 종료합니다만, 이 케이스는 completed 에서 종료한다는 점입니다.

#### 3초 후에 retry를 3회하고 종료

위의 예와 retryWhen의 맨 처음의 예를 조합하는 것으로, 3초 후에 retry를 3회하고 종료하는 처리는 아래와 같이 적을 수 있습니다.


```java
Observable
    .create(new Observable.OnSubscribe<String>() {
        @Override
        public void call(Subscriber<? super String> subscriber) {
            log("subscribe");
            subscriber.onNext("emit 1");
            subscriber.onNext("emit 2");
            subscriber.onError(new Throwable());
        }
    })
    .retryWhen(new Func1<Observable<? extends Throwable>, Observable<?>>() {
        @Override
        public Observable<?> call(final Observable<? extends Throwable> observable) {
            return observable.take(3).flatMap(new Func1<Throwable, Observable<?>>() {
                @Override
                public Observable<?> call(Throwable throwable) {
                    return Observable.timer(3, TimeUnit.SECONDS);
                }
            });
        }
    })
    .subscribe(new Subscriber<String>() {
        @Override
        public void onCompleted() {
            log("completed");
        }

        @Override
        public void onError(Throwable e) {
            log("error:" + e);
        }

        @Override
        public void onNext(String s) {
            log("on next: " + s);
        }
    });
```


```text
> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후

> subscribe
> on next: emit 1
> on next: emit 2

// 3초 후

> subscribe
> on next: emit 1
> on next: emit 2
> completed
```

이상입니다. `retryWhen()`를 구사하면 좀 더 자세한 retry 처리를 작성할 수 있겠네요!

## 후기

Advent Calendar의 4일 차에 지원했습니다만, 갑자기 시간에 못 맞춰 구멍이 난듯한 형태가 되어버렸습니다. 대단히 죄송합니다.

이 내용을 작성할 때 매우 곤란한 일이 있었습니다. 처음에는 이 내용의 샘플 코드는 전부 Kotlin으로 작성할 예정이었습니다. 하지만, 시험해봤더니 Kotlin에서는 retryWhen 코드가 컴파일되지 않는다!

아래 코드가 컴파일되지 않는다.


```java
Observable
    .just("hoge")
    .retryWhen { it.flatMap{ Observable.timer(3, TimeUnit.SECONDS) } }
```

이러가지 찾아봤지만, 결국 해결하지 못하고, Kotlin으로 샘플 코드를 작성하는 것을 포기했습니다. orz
