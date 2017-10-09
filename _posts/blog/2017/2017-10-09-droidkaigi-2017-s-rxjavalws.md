---
layout: post
title: "[번역] DroidKaigi 2017 ~ 전부 S가 된다 ~ RxJava와 LWS 도입의 즐거움"
date: 2017-10-09 15:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 全てSになる -RxJavaとLWSを持ち込む楽しさ](https://www.slideshare.net/ryugoo/s-rxjavalws) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 전부 S가 된다 ~ RxJava와 LWS 도입의 즐거움

DROIDKAIGi 2017 / DAY.1 / RYUTARO MIYASHITA

## 2p

ryugoo / 宮下竜太郎

ChatWork 애플리케이션 개발부 리더

## 3p

전부 `S` 가 된다

## 4p ~ 5p

전부 `Stream` 가 된다

## 6p, 자바 8의 사례

`Java 8` 에서는 다양한 언어 기능이 강화되어있다

```
// Lambda 식
view.setOnClickListener(v -> {
})

// Method Reference
view.setOnClickListener(this::proc);
public void proc(View v) {}

// Stream/Optional API
Stream.of(Arrays.asList("1", "2", "3"));
Optional.ofNullable(getSupportActionBar());
```

## 7p, Java 버전

Android N 과 함께 Android 에도 `Java 8`이 왔다

```
android {
   defaultConfig {
      jackOPtions { enabled true }
   }
}
compatibilityOptions {
   sourceCompatibility JavaVersion.VERSION_1_8
   targetCompatibility JavaVersion.VERSION_1_8
}
```

> [https://developer.android.com/guide/platform/j8-jack.html](https://developer.android.com/guide/platform/j8-jack.html)

## 8p, Jack의 제약

Jack is `not` silver bullet

- Instant Run을 사용할 수 없다
- 빌드가 느립니다
- 일부 빌드 기능을 사용할 수 없다
   - 예) shrinkResources
- 앱의 바이너리 사이즈도 커진다 ①
- Stream이나 Optional은 `API Lv.24이상`이 필요합니다
   - 3/8 현재 Android 7.x 점유율은 2.6% 입니다 ②
   - 사용하게 되는 것은 `다음 생애` ?

> ① : https://github.com/sys1yagi/android-method-counts
>
> ② : https://developer.android.com/about/dashboards/index.html

## 9p

미래를 `선취(先取り)`한다

## 10p

Retrolambda

RxJava

Lightweight Stream API

## 11p

`Retrolambda`

RxJava

Lightweight Stream API

## 12p, Retrolambda 로 손에 넣는 Java 8 기능

Lambda 식과 Reference Method 전제로 이야기를 하겠습니다

- `Lambda 식`
- `Reference Method`
- try-with-resources
- Objects.requireNonNull
- Default Method
- interface 내의 static 메소드

손에 넣는 것은 언어 기능 부분

[https://github.com/evant/gradle-retrolambda](https://github.com/evant/gradle-retrolambda)

## 13p, Retrolambda

Java 8의 Lambda 식을 Android 에

```
buildscript {
   repositories { mavenCentral() }
   dependencies {
      classpath 'me.tatarka:gradle-retrolambda:3.6.0'
   }
}
repositories { mavenCentral() }

apply plugin: 'com.android.application'
apply plugin: 'me.tatarka.retrolambda'
```

## 14p, Retrolambda

Jack과 동일하게 compatibilityOptions에 Java 8을 지정한다

```
android {
   defaultConfig {
      jackOPtions { enabled false }
   }
}
compatibilityOptions {
   sourceCompatibility JavaVersion.VERSION_1_8
   targetCompatibility JavaVersion.VERSION_1_8
}
```

## 15p

Retrolambda

`RxJava`

Lightweight Stream API

## 16p, RxJava

Reactive Extensions for JVM

- Android API의 가려운 곳을 채워준다
   - 비동기 처리
   - 이벤트 알림
- `Stream API`도 가능합니다
   - Collection 조작
- 비동기 · 동기를 의식하지 않고 처리를 적을 수 있다
   - 메소드 체인으로 기술
   - Scheduler를 사용해 Thread 전환

[https://github.com/ReactiveX/RxJava](https://github.com/ReactiveX/RxJava)

## 17p, RxJava with ......

Reactive Extensions for JVM

- RxBinding ①
   - Android의 Viw와 RxJava를 연결
- RxAndroid ②
   - UI 스레드용 스케쥴러를 제공한다
- RxLifecycle ③
   - Android 화면 Lifecycle과 연결

> ① : https://github.com/JakeWharton/RxBinding
> 
> ② : https://github.com/ReactiveX/RxAndroid
>
> ③ : https://github.com/trello/RxLifecycle

## 18p, RxJava

Java8 Stream API 같은 Collection 조작

```
// RxJava
Observable.fromArray("1", "2", "3")
   .map(Integer::valueOf)
   .filter(num -> num % 2 == 0)
   .toList()
   .blockingGet();   // [2]
```
```
// Stream
Stream.of("1", "2", "3")
.map(Integer::valueOf)
   .filter(num -> num % 2 == 0)
   .toList();   // [2]
```

## 19p, RxJava

심플한 비동기 처리

```
Single.fromCallable(() -> {
   Thread.sleep(2000L);
   return "finish";
})
.subscribeOn(Schedulers.computation())
.observeOn(AndroidSchedulers.mainThread())
.subscribe(
   text -> Log.d(TAG, text);
   Throwable::printStackTrace
);
```

## 20p, RxJava

```
Single.fromCallable(() -> {
   Thread.sleep(2000L);
   return "finish";
})
.subscribeOn(Schedulers.computation())
```

프리셋된 ThreadPool을 사용해 Single#fromCallable 처리를 실행

## 21p, RxJava

```
.observeOn(AndroidSchedulers.mainThread())
.subscribe(
   text -> Log.d(TAG, text);
   Throwable::printStackTrace
);
```

RxAndroid를 사용해 UI 스레드로 결과를 취득

## 22p, RxJava

동일한 처리를 AsyncTask로 적으면

```
new AsyncTask<Void, Void, String>() {
   @Override
   protected String doInBackground(Void... parmas) {
      try {
         Thread.sleep(2000L);
      } catch (InterruptedException e) {
         e.printStackTrance();
      }
      return "finish";
   }
   @Override
   protected void doPostExecute(String text) {
      Log.d(TAG, text);
   }
}.execute();
```

```
Single.fromCallable(() -> {
   Thread.sleep(2000L);
   return "finish";
})
.subscribeOn(Schedulers.computation())
.observeOn(AndroidSchedulers.mainThread())
.subscribe(
   text -> Log.d(TAG, text);
   Throwable::printStackTrace
);
```

## 23p, RxJava

Use case : 버튼을 누르면 Web API와 통신해서 결과를 표시

```
findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {
   @Override
   public void onClick(View v) {
      new AsyncTask<String, Void, String>() {
         @Override
         protected String doInBackground(String... parmas) {
            return new WebAPIClient(params[0]);
         }
         @Override
         protected void doPostExecute(String result) {
            Log.d(TAG, result);
         }  
      }.execute("Send parameter");
   }
});
```

## 24p, RxJava

Use case : 버튼을 누르면 Web API와 통신해서 결과를 표시

```
final String params = "Send parameter";
RxView.clicks(findViewById(R.id.button))
   .subscribeOn(AndroidSchedulers.mainThread())
   .observeOn(Schedulers.computation())
   .map(event -> new WebAPIClient(params))
   .observeOn(AndroidSchedulers.mainThread())
   .subscribe(
      result -> Log.d(TAG, result),
      Throwable::printStackTrace
   );
```

## 25p, RxJava

```
RxView.clicks(findViewById(R.id.button))
   .subscribeOn(AndroidSchedulers.mainThread())
```

RxBinding을 사용해 클릭 이벤트를 RxJava로 처리 (UI Thread)

## 26p, RxJava

```
   .observeOn(Schedulers.computation())
```

아래의 처리를 Worker Thread 로 전환

## 27p, RxJava

```
   .map(event -> new WebAPIClient(params))
```

클릭 이벤트를 Web API 통신 결과로 변환

## 28p, RxJava

```
   .observeOn(AndroidSchedulers.mainThread())
```

아래 처리는 UI Thread로 전환

## 29p, RxJava

```
   .subscribe(
      result -> Log.d(TAG, result),
      Throwable::printStackTrace
   );
```

결과 취득과 처리

## 30p, RxJava

Use case : 버튼을 누르면 Web API와 통신해서 결과를 표시

```
final String params = "Send parameter";
RxView.clicks(findViewById(R.id.button))
   .subscribeOn(AndroidSchedulers.mainThread())
   .observeOn(Schedulers.computation())
   .map(event -> new WebAPIClient(params))
   .observeOn(AndroidSchedulers.mainThread())
   .subscribe(
      result -> Log.d(TAG, result),
      Throwable::printStackTrace
   );
```

## 31p, RxJava 도입의 즐거움

- Collection 조작이나 비동기 처리가 깔끔하게 적을 수 있습니다
   - Nest가 깊어지지 않는다
   - 위에서 밑으로 처리를 적어나가면 OK 입니다
      - Observable `Stream`
      - Fluent Interface
- RxBinding 등 Android 연계 라이브러리가 충실합니다
   - View의 다양한 이벤트를 RxJava로 처리 가능합니다
   - 이벤트 갯수 제약도 간단하게 가능합니다
      - 예) 문자입력을 200ms 간격으로 제어한다

## 32p

Retrolambda

RxJava

`Lightweight Stream API`

## 33p, Lightweight-Stream-API

Stream API from Java 8 rewritten on iterators for Java 7 and below

- Java 8로 제공되는 Stream API의 Backport입니다
- Stream뿐만 아니라 `Optional`이나 Objects도 있습니다
- `자체적으로 확장된 API`가 있습니다
- RxJava과 쓰면 좋습니다 :)

> [https://github.com/aNNiMON/Lightweight-Stream-API](https://github.com/aNNiMON/Lightweight-Stream-API)

## 34p, Lightweight-Stream-API

Stream API from Java 8 rewritten on iterators for Java 7 and below

- `Stream API`
   - Collection 조작 API
- `Optional API`
   - 값이 없을지도 모르는 것을 표현 가능한 API
- `Exceptional API` (자체)
   - 선언적으로 사용 가능한 try-catch 대체 API

> [https://github.com/aNNiMON/Lightweight-Stream-API](https://github.com/aNNiMON/Lightweight-Stream-API)

## 35p, Lightweight-Stream-API

Stream API

```
Stream<String> stream = Stream.of(3, 3, 3);

// collect는 단 1번만
stream.collect(Collectors.toList()); // [3,3,3]
stream.collect(Collectors.toSet());  // (3)
stream.collect(Collectors.toMap(     // {"3"=3}
   String::valueOf,
   num -> num,
   HashMap::new
));
stream.map(String::valueOf)
   .collect(Collectors.joining(",")); // 3,3,3
```

## 36p, Lightweight-Stream-API

Optional API

```
// 기존의 작성 방법
ActionBar actionBar = getSupportActionBar();
if (actionBar != null) { actionBar.setTitle("Hello"); }

// Optional을 사용한 작성 방법
Optional.ofNullable(getSupportActionBar())
   .ifPresent(actionBar -> actionBar.setTitle("Hello"));
```

## 37p, Lightweight-Stream-API

Use case: FragmentManagere#findFragmentByTag

```
FragmentManager fm = getSupportFragmentManager();
Fragment f = fm.findFragmentByTag(FTAG);
MyFragment myF;
if (f != null && f instanceof MyFragment) {
   myF = (MyFragment) f;
} else {
   myF = MyFragment.newInstance();
}
```

MyFramgnet 인스턴스를 얻을 때까지의 처리를 절차적으로 기술합니다

## 38p, Lightweight-Stream-API

Use case: FragmentManagere#findFragmentByTag

```
FragmentManager fm = getSupportFragmentManager();
MyFragment myF =
   Optional.ofNullable(fm.findFragmentByTag(FTAG))
      .filter(MyFragment.class::isInstance)
      .my(f -> (MyFragment) f)
      .orElseGet(MyFragment::newInstance);
```

MyFramgnet 인스턴스를 얻을 때까지의 흐름을 선언적으로 기술 가능합니다.

## 39p, Lightweight-Stream-API

Use case: FragmentManagere#findFragmentByTag

```
FragmentManager fm = getSupportFragmentManager();
MyFragment myF =
   Optional.ofNullable(fm.findFragmentByTag(FTAG))
      .select(MyFragment.class)   // LWS 자체
      .orElseGet(MyFragment::newInstance);
```

MyFramgnet 인스턴스를 얻을 때까지의 흐름을 선언적으로 기술 가능합니다.

## 40p, Lightweight-Stream-API

Optional API의 주의점

```
// 위험
private Optional<String> optString;
optString.ifPresent(text -> {}); // NPE

// 초기화시에 empty를 대입한다
private Optional<String> optString = Optional.empty();
optString.ifPresent(text -> {}); // Works
```

## 41p, LWS 도입의 즐거움

The fun of Lightweight Stream API

- Nest가 깊어지지 않는다
   - 위에서 밑으로 처리를 적어나가면 OK 입니다
   - Fluent Interface
- Collection 조작을 "편리하게" 할 수 있습니다
   - 값의 계산을 다양한 형태로 할 수 있습니다
- `Optional`은 NPE와 싸우는 강력한 무기가 됩니다
   - Android SDK는 무엇이 null을 반환할지 모릅니다
   - 또한 Fragment의 취득 등 절차가 번잡한 처리를 깔끔하게 기술할 수 있게 됩니다.

## 42p

RxJava + Lightweight Stream API

## 43p, 에러 처리 문제

Error handling problem of RxJava

```
protected void onCreate(Bundle saveInstanceState) {
   ~~~
   RxView.clicks(findViewById(R.id.button))
      .subscribeOn(AndroidSchedulers.mainThread())
      .map(event -> {
         throw new IllegalStateException("Exception");
      })
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe(success -> {
         Log.d(TAG, "Success");
      }, error -> {
         Log.d(TAG, "error");
      });
}
```

## 44p, 에러 처리 문제

```
      .map(event -> {
         throw new IllegalStateException("Exception");
      })
```

도중에 에러가 발생한 경우

## 45p, 에러 처리 문제

```
      }, error -> {
         Log.d(TAG, "error");
      });
```

onError가 실행되 "구독이 종료" 된다

## 46p, 에러 처리 문제

Error handling problem of RxJava

- RxJava의 실패는 onError에 Throwable을 던진다
   - `onError가 오면 일련의 구독은 종료`합니다
   - 예를 들어 Web API의 요청에 실패하면?
      - 다시 한번 사용자가 재시도하면 성공할지도
      - 하지만 버튼 클릭 이벤트는 이미 구독 종료 ......
- `예상내의 실패`와 `의도하지 않은 예외`를 나누고 싶다
   - Pair<Boolean, T>를 사용해 옳고 그림을 진위 값으로 확인한다?
   - Pair<Integer, T>를 사용해 에러 코드를 만든다?
   - onErrorReturn 이나 onErrorResumeNext를 사용?

## 47p, Either Type

More better RxJava error handling

```
public final class Either<Left, Right> {
   private final Optional<Left> left;
   private final Optional<Right> right;

   private Either(Optional<Left> left, Optional<Right> right) {
      this.left = left;
      this.right = right;
   }
   public static Either<Left, Right> left(@NonNull Left value) {
      return new Either<>(Optional.of(value), Optional.empty());
   }
   public static Either<Left, Right> right(@NonNull Right value) {
      return new Either<>(Optional.empty(), Optional.of(value));
   }
   public <T> Either<T, Right> mapLeft(<Function<? super Left, ? extends T> func>) {
      return new Either<>(this.left.map(func), this.right);
   }
   public <T> Either<T, Right> mapRight(<Function<? super Right, ? extends T> func>) {
      return new Either<>(this.left, this.right.map(func));
   }
   public void apply(Consumer<? super Left> lConsumer, Consumer<? super Right> rConsumer) {
      this.left.ifPresent(lConsumer);
      this.right.ifPresent(rConsumer);
   }
}
```

- Left 타입 혹은 Right 타입의 값을 반드시 가지고 있다
- 바꿔말하면 어느 쪽의 값은 반드시 가지고 있지 않다
- 값을 가지지 않는다는 것을 Optional로 표현한다
- 관례로 Right 쪽에 정답이 되는 값을 넣는다

> [https://gist.github.com/ryugoo/8de36d41c249165b0b3344ba8ccbcf59](https://gist.github.com/ryugoo/8de36d41c249165b0b3344ba8ccbcf59)

## 48p, Either Type

More better RxJava error handling

```
public Observable<Either<Throwable, String>> webApiRequest() {
   return Observable.create(emitter -> {
      try {
         APIClient.request(success -> {
            if (success) {
               emitter.onNext(Either.right("Success"));
            } else {
               emitter.onNext(Either.left(new RuntimeException()));
            }
         });
      } catch (IOException e) {
         emitter.onError(e);
      }
   });
}
```

## 49p, Either Type

```
public Observable<Either<Throwable, String>> webApiRequest() {
```

올바른 값은 String, 실패의 값은 Throwable를 가지는 Either 타입을 알리는 Observable을 정의한다

## 50p, Either Type

```
            if (success) {
               emitter.onNext(Either.right("Success"));
```

요청 성공의 경우는 Either#right 를 알림

## 51p, Either Type

```
            } else {
               emitter.onNext(Either.left(new RuntimeException()));
```

요청 실패의 경우는 Either#left 를 알림

## 52p, Either Type

```
      } catch (IOException e) {
         emitter.onError(e);
```

의도하지 않은 실패의 경우는 onError로 예외를 알림

## 53p, Either Type

More better RxJava error handling

```
webApiRequest()
   .subscribeOn(Schedules.computation())
   .observeOn(AndroidSchedulers.mainThread())
   .subscribe(either -> either.apply(
      failure -> {},   // API Request 의 실패
      success -> {}),  // API Request 의 성공
      error -> {}      // API Request 이외에서 발생한 예외
   );
```

## 54p, Either Type

```
   .subscribe(either -> either.apply(
      failure -> {},   // API Request 의 실패
      success -> {}),  // API Request 의 성공
      error -> {}      // API Request 이외에서 발생한 예외
   );
```

"예상 범위 내의 실패"를 얻도록 된다

## 55p

전부 `Stream` 가 된다

## 56p, 전부 `Stream` 가 된다

```
// Stream
List<String> result = Stream.of(1, 2, 3)
   .filterNot(num -> num % 2 == 0)
   .map(String::valueOf)
   .toList();
```
↓
```
// Optional
MyFragment myFragment = 
   Optional.ofNullable(getSupportFragmentManager().findFragmentByTag("Fragment))
      .select(MyFragment.class)
      .orElseGet(MyFragment::newInstance);
```
↓
```
// RxJava
Single.fromCallable(() -> {
   Thread.sleep(2000L);
   return "finish";
})
.subscribeOn(Schedulers.computation())
.observeOn(AndroidSchedulers.mainThread())
.subscribe(
   System.out::println,
   Throwable::printStackTrace
);
```

## 57p, 전부 `Stream` 가 된다

- Android 앱도 Java8의 은혜를 받을 수 있다
   - Jack은 아직 실용 단계는 아니다
   - Retrolambda로
      - Lambda 식과 Method Reference
- Java 8의 Stream API / Optional API는 강력
   - Collection 조작은 Stream API
   - 값이 존재하지 않는 것을 표현 가능한 Optional API
      -  특히 Optional은 Android SDK와 상성이 좋다
         - 예) FragmentManager
- RxJava와 Android SDK의 가려운 곳에 손이 닿는다
   - 비동기 처리와 EventBus
   - Collection 조작도 가능

## 58p, 전부 `Stream` 가 된다

- RxJava / Lightweight Stream API
   - Observable Stream 이나 Stream 을 다룬다
   - 다양한 값과 이벤트를 변화시켜 결과를 취득한다
      - Fluent interface에 의한 흐르는 코드
      - 위에서 밑으로 처리가 흘러간다
         - 메소드 체인으로 표현
- 뷰의 이벤트와 비즈니스 로직에 의지하지 않는다
   - 모든 처리가 동일한 형태로 표현 가능하게 된다
      - 모두 Stream 이 된다 = 모두 `S`가 된다

## 59p, 데모 앱

Demo apps

[https://github.com/ryugoo/StreamDemo](https://github.com/ryugoo/StreamDemo)