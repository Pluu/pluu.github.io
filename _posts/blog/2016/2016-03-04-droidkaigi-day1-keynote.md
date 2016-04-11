---
layout: post
title: "[번역] DroidKaigi 2016 ~ OSS 동향을 파악한 구현 방침"
date: 2016-03-04 17:30:00 +09:00
tag: [Android, DroidKaigi, Keynote]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [Day1 Keynote in DroidKaigi 2016](https://speakerdeck.com/wasabeef/day1-keynote-in-droidkaigi-2016) 과 발표영상 [主催者挨拶 + 基調講演: OSSの動向を捉えた実装方針 by CyberAgent wasabeef at DroidKaigi 2016 ](https://www.youtube.com/watch?v=kArtZzDz1xU&t=7m)을 기본으로 번역하여 작성했습니다

자료와 연관된 발표 영상은 8분 30분부터 보시면 됩니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드와 발표 설명`의 부분을 혼합하여 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

OSS 동향을 파악한 구현 방침

## 2p

**About me**

- Daichi Furiya
- @wasabeef_jp
- wasabeef
- CyberAgent, Inc

> CyberAgent 소속으로 동영상 관련 서비스를 만들고 있으며, 3월에 릴리즈 예정인 어플리케이션을 만드는 도중에 라이브러리를 써보면서 어떤 현상이 일어나서 어느 라이브러리를 사용한 이야기합니다.

## 3p

OSS 동향을 파악한 구현 방침?

> 사용한 라이브러리 중심으로 소개할 예정입니다. 파악했다고 해서 새로운 라이브러리를 사용하는 것이 아니라 안정적인 것이 좋다고 판단하면 그것을 선택했습니다. 설계 관련으로 MVC라든가 TDD관련 이야기는 하지 않습니다.

## 4p

Research

> 동향을 파악하기 위해서 어떻게 찾으면 되는지

## 5p

**Research**

- GitHub/trending
- Android Weekly
- Android Arsenal
- Twitter

## 6p

Introduction

> 이전에는 단말기 관련 버그 등 많았지만, 최근에는 4.x 이상을 지원하는 곳에서는 단말기 관련 버그 등은 이전처럼 많지 않다고 생각합니다. RxJava, Dagger, DataBinding, Annotation Processing 등 개발이 주목되고 있습니다.

## 7p

Languages

## 8p

**Languages**

- Kotlin
- Java
  - RetroLambda
  - Lightweight-Stream-API
  - ThreeTen Android

> 저희는 Java를 선택했지만, 자사의 다른 서비스에서는 Kotlin을 85% 정도 사용하고 있습니다. Java6으로 개발하기는 어려우므로 Java8와 비슷한 라이브러리를 사용했습니다.

## 9p

**Kotlin** by JetBrains

## 10p

**Kotlin**

- Kotlin 1.0
- Java 연동
- ...more

## 11p

**RetroLambda** by Esko Luontola

## 12p

**RetroLambda**

- Lambda

```java
view.setOnClikListener(v -> {
  finish();
});
```

- Method Reference

```
view.setOnClikListener(this::something);
```

> RxJava를 사용 시 Lambda를 못 쓰는 경우에는 코드가 길게 되어버립니다. Method Reference는 메소드 호출을 생략할 수 있습니다.

## 13p

**Lightweight-Stream-API** by Victor Melnik

> RetroLambda만으로는 Java8다운 개발이 아니므로, Stream API이나 Optional를 사용하고 싶을 것입니다.

## 14p

**Lightweight-Stream-API**

- Steam API

```
Stream.of(lines)
  .map(str -> str.split(t))
  .filter(arr -> arr.length == 2)
  .map(arr -> new Word(arr[0], arr[1]))
  .collect(Collectors.toList());
```

> Java8와 비슷하게 작성할 수 있고, RxJava를 사용해본 사람이라면 비슷하게 함수를 사용할 수 있을 거라고 생각합니다. RxJava에서도 가능하지만, 심플하게 작성할 수 있습니다.

## 15p

**Lightweight-Stream-API**

- Optional

```
Optional.ofNullable(i.getStringExtra(EXTRA_URI))
  .map(Uri::parse)
  .orElse(null);
```
```
Optional.ofNullable(getSupportActionBar())
  .ifPresent(ab -> {
    ab.setDisplayHomeAsUpEnabled(true);
    ab.setHomeButtonEnabled(true);  
});
```

> 개인적으로는 Stream API보다 Optional이 편리하다고 생각합니다. Intent로부터 데이터를 꺼내거나 Null 체크를 할 수 있으므로 보기 쉬울 것입니다.

## 16p

**ThreeTen Android** by Jake Wharton

## 17p

**ThreeTen Android**

- JSR-310

```
// Now
LocalDateTime.now();

// 2016.2.18 10:30:40
LocalDateTime.of(2016, 2, 18, 10, 30, 40);

// +1 truncated second
LocalDateTime.now()
  .plusHours(1).truncatedTo(ChronoUnit.HOURS);

// Epoch
LocalDateTime.now()
  .toInstant(ZoneOffset.UTC).toEpochMilli();
```

> Android에서 시간 조작 시 Time, Calendar Class가 있습니다만, Time은 API 22에서 Deprecated 되어 사용하지 않을 것이고, jodatime 등이 있지만 메소드 수 및 Zone 관련 처리 문제가 있습니다. 사용하기 어렵지 않은 부분이 좋았습니다.

## 18p

Views

## 19p

**View**

- Support Library
- Android-ObservableScrollView
- Calligraphy
- florent37/ViewAnimator

> 여러 프로젝트에서 이 정도는 쓸 것이라고 판단되어 정했습니다

## 20p

**Support Library** by Google

## 21p

**Support Library**

- View (RecyclerView...etc)
- RenderScript
- MultiDex
- Annotations

> 이미지 관련 처리라면 RenderScript를 이용하면 좋습니다

## 22p

**Support Library**

- Sample...

```groovy
compile 'com.android.support:support-v4:+'
compile 'com.android.support:appcompat-v7:+'
compile 'com.android.support:design:+'
compile 'com.android.support:recyclerview-v7:+'
compile 'com.android.support:cardview-v7:+'
compile 'com.android.support:support-annotations:+'
compile 'com.android.support:percent:+'
```

> 기존 weight를 대체하여 percent를 이용해서 구현 가능합니다

## 23p

**Android-ObservableScrollView** by ksoichiro

## 24p

**Android-ObservableScrollView**

- ScrollView, ListView, RecyclerView 등 스크롤 제어를 감시

## 25p

**Calligraphy** by Christopher Jenkins

> Marshmallow부터는 Roboto를 이용하고, 4.x에는 다르므로 폰트를 통일하기 위해서 사용합니다.

## 26p

**Calligraphy**

- 어플 전체에 폰트 적용
- xml에서도 java에서도 가능
- 간단

## 27p

**CalligraphyConfig**

```
CalligraphyConfig.initDefault(new CalligraphyConfig.Builder())
  .setDefaultFontPath("fonts/mplus-2p-regular.ttf")
  .setFontAttriId(R.attr.fontPath)
  .build();
```

## 28p

**ViewAnimator** by Florent CHAMPIGNY

## 29p

**ViewAnimator**

```
AnimatorSet animSet = new AnimatorSet();
animSet.playTogether(
  ObjectAnimator.ofFloat(image, View.TRANSLATION_Y, -1000,0),
  ObjectAnimator.ofFloat(image, View.ALPHA, 0,1),
  ObjectAnimator.ofFloat(text, View.TRANSLATION_X, -200,0)
);
animSet.setInterpolator(new DescelerateInterpolator());
animSet.setDuration(2000);
animSet.addListener(new AnimatorListenerAdapter() {
  @Override public void onAnimationEnd(Animator animation) {
      AnimatorSet anim = new AnimatorSet();
      anim.playTogether(
          ObjectAnimator.ofFloat(image, View.SCALE_X, 1f, 0.5f, 1f),
          ObjectAnimator.ofFloat(image, View.SCALE_Y, 1f, 0.5f, 1f)
      );
      anim.setInterpolator(new AccelerateInterpolator());
      anim.setDuration(1000);
      anim.start();
    }
});
animSet.start();
```

## 30p

**ViewAnimator**

```
ViewAnimator
  .animate(image)
    .translationY(-1000, 0)
    .alpha(0, 1)
  .andAnimate(text)
    .dp().translationX(-200, 0)
  .descelerate()
  .duration(2000)
  .thenAnimate(image)
    .scale(1f, 0.5f, 1f)
  .accelerate()
  .duration(1000)
  .start();
```

> dp 지정 및 Path Animation도 지원합니다

## 31p

DataBinding

## 32p

**Android Data Binding** by Google

> 작년 Google I/O에서 발표되었습니다.

## 33p

**Android Data Binding**

- xml과 java의 Binding
- Annotation Processing
- 가끔 빌드 에러가 나온다

> 이전은 빌드 에러가 자주 나왔지만, 최근에는 가끔 나타난다.

## 34p

**Android Data Binding**

```
<LinearLayout
  xmlns:android="http://schemas.android.com/apk/res/android"
  android:orientation="vertical"
  android:layout_width="match_parent"
  android:layout_height="match_parent">

  <TextView android:id="@+id/user_name"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>

  <ImageView android:id="@+id/user_thumbnail"
    android:layout_width="160dp"
    android:layout_height="120dp"/>
</LinearLayout>
```

## 35p

**Android Data Binding**

```
<layout xmlns:android="http://schemas.android.com/apk/res/android">

  <LinearLayout
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

  <TextView android:id="@+id/user_name"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>

  <ImageView android:id="@+id/user_thumbnail"
    android:layout_width="160dp"
    android:layout_height="120dp"/>

  </LinearLayout>
</layout>
```

## 36p

**Android Data Binding**

```
<layout xmlns:android="http://schemas.android.com/apk/res/android">
  <data name="MainBinding">
    <variable name="user" type="com.example.User"/>
  </data>
  <LinearLayout
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

  <TextView android:id="@+id/user_name"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@{user.name}"
    android:textColor="@{user.isWomen? @color/pink : @color:blue}"/>

  <ImageView android:id="@+id/user_thumbnail"
    android:layout_width="160dp"
    android:layout_height="120dp"
    bind:imageUrl="@{user.thumbnail}"/>
  </LinearLayout>
</layout>
```

## 37p

**Android Data Binding**

- Custom Setters

```
public final class ImageBindingAdapters {
  @BindingAdapter({ "bind:image" })
  public static void loadImage(ImageView view, String url) {
    Glide.with(view.getContext().getApplicationContext())
    .load(url)
    .into(view);
  }
}
```
```
<ImageView
  android:layout_width="160dp"
  android:layout_height="120dp"
  bind:imageUrl="@{user.thumbnail}"/>
```

> 이전까지 attribute 추가를 위해 XML 작성하거나 2~3파일 편집이 필요했지만, Custom Setters로 간단하게 정의할 수 있습니다.

## 38p

**Android Data Binding**

- DataBindingUtil

```
<layout xmlns:android="http://schemas.android.com/apk/res/android">
  <data name="MainBinding">
    <variable name="user" type="com.example.User"/>
  </data>
  <!-- ... --
</layout>
```
```
@Override protected void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);

  MainBinding binding =
    DataBindingUtil.setContentView(this, R.layout.activity_main);

  binding.userName.setOnClickListener(v -> ...);
}
```

> View에 데이터 이름을 이용해서 데이터를 적용할 수 있다면, 다수가 작업하더라도 ID 지정으로 생기는 문제를 줄일 수 있다고 생각합니다.

## 39p

Networking

## 40p

**Networking**

- (Volley)
- Retrofit+OkHttp

> Volley는 Git으로부터 Clone하지 않으면 안 되고, 최근 Marshmallow에서 Apache가 없어졌으며, 쓰고 싶다면 Legacy를 쓸 수밖에 없습니다.

## 41p

**Retrofit+OkHttp** by Square

## 42p

**Retrofit+OkHttp**

- REST
- RxJava support
- Pluggable client
- Converters(Gson, Wire...)

> 현재 저희는 OkHttp 2.3을 사용 중인 이유는 OkHttp 2.4부터 POST 전송 시 Body가 비어있으면 처리해주지 않는 것으로 사양이 변경되었습니다. 위의 이슈가 Twitter SDK쪽의 OkHttp쪽에서 발생했습니다. 현재 이 이슈는 최근 1~2주 전에 수정되었습니다.

## 43p

**Retrofit**

```
public interface GitHubService {
  @GET(/users/{user}/repos)
  Observable<List<Repo>> repos(@Path(user) String user);
}
```
```
Retrofit retrofit = new Retrofit.Builder()
    .client(okHttpClient)
    .baseUrl("https://api.github.com")
    .addConverterFactory(GsonConverterFactory.create())
    .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
    .build();

GitHubService service = retrofit.create(GitHubService.class);
service.repos("wasabeef")
  .subscribe(repo -> {
    // ...
  }, e -> {
    Timber.w(e);
  });
```

## 44p

JSON & ProtoBuf

## 45p

**Serialisations**

- (Gson)
- (Jackson)
- (Moshi)
- Wire

> Jackson은 퍼포먼스 및 기능은 다양하지만, 메소드 수가 9천개 정도입니다. Gson은 최근에 1300 정도입니다. Moshi는 아마도 okio를 사용하는데 okio 이외의 부분이 300개 정도입니다.

## 46p

**Wire** by Square

## 47p

**Wire**

- Protocol Buffers
- okio를 이용
- Server/Client에서 정의를 공통화
- Web에서는 다루기 어렵다

> Web에서 API를 사용하기 위해서는 JSON 형식을 구현하지 않으면 안된다. Web에도 Proto Json이 있어서 써보았지만, 실용적으로 보이지 않아 JSON 형식을 추천합니다.

## 48p

**Wire**

- hello.proto

```
syntax = "proto3";

package helloworld;

message HelloRequest {
  string name = 1;
}

message HelloReply {
  string message = 1;
}
```

## 49p

**Wire**

- Build

```
# java -jar wire-compiler-2.0.1-jar-with-dependencies.jar \
  —proto_path=. \
  —java_out=. hello.proto

Writing helloworld.HelloRequest to .
Writing helloworld.HelloReply to .
```

> Facebook에서도 형식은 다른지만 ProtoBuf를 사용 중 입니다.

## 50p

Parcelables

## 51p

**Parcelables**

- (android-parcelable-intellij-plugin)
- Parceler
- (Auto-Value-Parcel)
- Icepick

## 52p

**Parceler** by John Ericksen

## 53p

- Annotation Processing
- AutoValue

## 54p

**Parceler**

```
@Parcel
public class User {
  public String name;
  public String thumbnail;
  User() {  }
}
```
```
// Wrap
Bundle bundle = new Bundle();
bundle.putParcelable("user", Parcels.wrap(user));

// Unwrap
User user =
Parcels.unwrap(getIntent().getParcelableExtra("user"));
```

> 데이터 모델 클래스에 Annotation @Parcel을 적는 것으로 Parcelables이 됩니다.

## 55p

**Icepick** by Frankie Sardo

## 56p

**Icepick**

- Simple

```
public class MainActivity extends Activity {
  @State String name;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Icepick.restoreInstanceState(this, savedInstanceState);
  }

  @Override
  public void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    Icepick.saveInstanceState(this, outState);
  }
}
```

> Annotation @State를 적는 것으로 지원하며, Clojure를 전반적으로 사용하고 있습니다.

## 57p

Image Loaders

## 58p

**Image Loaders**

- (Universal Image Loader)
- Picasso
- Glide
- Fresco

## 59p

**Picasso** by Square

## 60p

**Picasso**

- Simple
- Cache
- Transformations
- Debug

> Debug 모드시 읽어온 이미지가 어디에서 취득되었는지 알 수 있습니다.

## 61p

**Picasso**

- Simple

```
Picasso.with(context)
  .load("http://i.imgur.com/DvpvklR.png")
  .setIndicatorsEnabled(true)
  .into(imageView);
```

## 62p

**Glide** by Google (unofficial)

## 63p

**Glide**

- Bitmap Pool
- Gif support
- Thumbnail
- Animation support
- Transformations

> 현재 3.7이 릴리즈되어 있고, 이후로 4.x이 나올 예정입니다. Picasso에서는 Gif가 지원되지 않습니다. Transformations과 관계있는 Bitmap Pool에 이미지를 변환시킨 후 캐시 해줍니다. 혹시, Blur 처리가 많다면 Glide를 쓰는 편이 좋다고 생각합니다.

## 64p

- Simple

```
Glide.with(context)
  .load("http://i.imgur.com/DvpvklR.png")
  .crossFade()
  .thumbnail(.1f)
  .into(imageView);
```

## 65p

Picasso? Glide?

## 66p ~ 67p

**Picasso? Glide?**

> [http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en](http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en)

> 설정으로 바꿀 수 있지만, Glide는 CrossFade가 자연스럽지만, Picasso는 갑자기 나오는 형태입니다. Glide의 섬네일은 Progressive JPEG같은 표시를 해줍니다.

## 68p

**Picasso? Glide?**

- Library's size

> [http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en](http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en)

## 69p

**Picasso? Glide?**

- Method Count**

> [http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en](http://inthecheesefactory.com/blog/get-to-know-glide-recommended-by-google/en)

## 70p

**Fresco** by Facebook

## 71p

**Fresco**

- Ashmem heap
- View
- Gif support
- Animation

> Glide와 Picasso와는 다르게 View를 사용할 수 있습니다.

## 72p

**Fresco**

> 이미지가 캐시되면 UI에 표시해주는 부분 이외에는 Picasso, Glide와 같습니다.

## 73p

**Fresco**

```
<com.facebook.drawee.view.SimpleDraweeView  
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  fresco:fadeDuration="300"
  fresco:actualImageScaleType="focusCrop"
  fresco:placeholderImage="@color/wait_color"
  fresco:placeholderImageScaleType="fitCenter"
  fresco:failureImage="@drawable/error"
  fresco:failureImageScaleType="centerInside"
  fresco:retryImage="@drawable/retrying"
  fresco:retryImageScaleType="centerCrop"
  fresco:progressBarImage="@drawable/progress_bar"
  fresco:progressBarImageScaleType="centerInside"
  fresco:progressBarAutoRotateInterval="1000"
  fresco:backgroundImage="@color/blue"
  fresco:overlayImage="@drawable/watermark"
  fresco:pressedStateOverlayImage="@color/red"
  fresco:roundAsCircle="false"
  fresco:roundedCornerRadius="1dp"
  fresco:roundTopLeft="true"
  fresco:roundTopRight="false"
  fresco:roundBottomLeft="false"
  fresco:roundBottomRight="true"
  fresco:roundWithOverlayColor="@color/corner_color"
  fresco:roundingBorderWidth="2dp"
  fresco:roundingBorderColor="@color/border_color"
  />
```

## 74p

Effects

## 75p

**Effects**

- Blurry
- Android StckBlur
- GPUImage for Android
- Picasso/Glide Transformations

## 76p

**Blurry** by wasabeef

## 77p

**Blurry**

- Blur
- RenderScript
- DownSampling

## 78p

**Android StackBlur** by Enrique López Maña

## 79p

**Android StackBlur**

- Blur
- RenderScript
- NDK

> 3종류 패턴으로 Blur 적용이 가능합니다.

## 80p ~ 81p

Android StackBlur

## 82p

**GPUImage for Android** by CyberAgent

## 83p

**GPUImage**

- OpenGL ES
- 70 Filters
- Tone Curve

## 84p

**Picasso/Glide Transformations** by Wasabeef

## 85p

**Transformations**

- Picasso, Glide, Fresco
- Crop
- Blur
- Color Filter
- GPU Filter

## 86p

DI

## 87p

**DI**

- (AndroidAnnotations)
- (Square/Dagger)
- Google/Dagger
- Butter Knife

> 작년부터 DI는 일반적으로 사용되기 시작하여, AndroidAnnotations과 Square의 Dagger 사용이 많았지만, 신규 프로젝트에서는 Dagger2를 쓰는 패턴이 많은 것 같습니다. DataBinding을 사용하지 않는 경우에는 Butter Knife를 사용하는 편이 좋은 것 같습니다.

## 88p

**Dagger2** by Google

## 89p

**Dagger2**

- Annotation Processing
- 테스트 · 유지보수

## 90p

**Butter Knife** by Jake Wharton

## 91p

**Butter Knife**

- View Injection

```
public class MainActivity extends Activity {
  @Bind(R.id.user_name) TextView userName;
  @Bind(R.id.user_thumbnail) ImageView thumbnail;

  @BindString(R.string.title) String title;
  @BindDrawable(R.drawable.graphic) Drawable graphic;
  @BindColor(R.color.red) int red;
  @BindDimen(R.dimen.spacer) float spacer;
}
```

## 92p

**Butter Knife**

- OnClick, OnTextChange, OnFocusChange...etc

```
@OnClick(R.id.user_name)
public void click(View view) {
  // ...
}

@OnClick({ R.id.user_name, R.id.user_thumbnail })
public void click(View door) {
  // ...
}
```

> DataBinding을 사용하는 경우에는 XML에도 비슷하게 지정할 수 있습니다.

## 93p

FRP

## 94p

**FRP**

- RxJava
- RxAndroid
- (RxBinding)
- (RcLifecycle)

> 최근 여러 곳에서 Rx를 지원하는 라이브러리가 늘었습니다.

## 95p

**RxJava** by Netflix

## 96p

**RxJava**

- 비동기, 리스트 조작이 간단
- Retrolambda가 있으면 좋다
- Leak이 두렵다
- Retrofit과 범용하는 편이 좋다

## 97p ~ 98p

**RxJava**

- Sample

```
Observable.just("Google", "Apple", "MicroSoft")
  .map(String::toUpperCase)
  .subscribe(name -> {
    Timber.d("OnNext " + name);
  }, throwable -> {
    Timber.d("OnError");
  });
```

## 99p

**RxJava**

- lift
- compose
- rxjava-extras (by Dave Moten)

> Map 사용하면서 Index를 원할 때에 참고가 됩니다.

## 100p

**RxAndroid** by RxAndroid authors

## 101p

**RxAndroid**

- Scheduler

## 102p

**RxAndroid**

- Main Thread

```
Observable.just("one", "two", "three", "four", "five")
  .subscribeOn(Schedulers.newThread())
  .observeOn(AndroidSchedulers.mainThread())
  .subscribe(/* an Observer */);
```

- Arbitrary Thread

```
final Handler handler = new Handler();

Observable.just("one", "two", "three", "four", "five")
  .subscribeOn(Schedulers.newThread())
  .observeOn(HandlerScheduler.from(handler))
  .subscribe(/* an Observer */)
```

## 103p

DB/ORM

## 104p

**DB/ORM**

- (ActiveAndroid)
- Realm
- (SQLBrite)
- Android Orma

> Realm에서 Rx를 지원합니다만, 개인적으로는 Realm에서 오브젝트가 관리되는지 아닌지를 판단하기 어려워져서, 심플하게 SQLite를 사용하고자 Orma를 도입했습니다.

## 105p

**Realm** by Realm

## 106p

**Realm**

- Not SQLite
- RxJava?
- Thread간의 제약

> Thread간의 제약으로 Rx지원 추가 및 `copyFromRealm` 메소드도 추가되어, 관리대상 오브젝트로부터 그렇지않은 오브젝트에 Copy도 가능해졌습니다. 그것이 오히려 이해하기 어렵게 했습니다.

## 107p

**Android Orma** by gfx

## 108p

**Android Orma**

- SQLite
- Annotation Processing
- RxJava
- Semi-automatic migration

## 109p

Event Buses

## 110p

**Event Buses**

- <del>Otto</del>
- EventBus
- (RxJava)

> Otto는 최근 Deprecated 되어 RxJava를 이용하라는 소식이 있었습니다.

## 111p

**<del>Otto</del>** by Suqare

## 112p

**Otto**

- Deprecated!
- Square
- @Produce가 조금 편리

## 113p

**EventBus** by greenrobot

## 114p

**EventBus**

- EventBus3
- Threading Support
- Annotation Processing

## 115p

Debugging

## 116p

**Debugging**

- Timber
- Hugo
- Stetho
- Leak Canary
- Takt
- Crashlytics

## 117p

**Timber** by Jake Wharton

## 118p

**Timber**

- Logger
- Timer.Tree를 상속해서 추가한 것, 출력하는 곳을 자유롭게 변경할 수 있다

```
if (BuildConfig.DEBUG) {
  Timber.plant(new Timber.DebugTree());
} else {
  Timber.plant(new CrashReportingTree());
}
```

## 119p

**Hugo** by Jake Wharton

## 120p

**Hugo**

Annotation으로 Method Class를 Logging 가능하다

```
@DebugLog
public String getName(String first, String last) {
  return first + " " + last;
}
```
```
V/Example: ⇢ getName(first="Daichi", last="Furiya")
V/Example: ⇠ getName [0ms] = “Daichi Furiya"
```

## 121p

**Stetho** by Facebook

## 122p

**Stetho**

- Chrome Developer Tools를 이용해서 Network, Data의 상황을 파악
- Stetho-Realm (by uPhyca)

## 123p ~ 125p

Stetho

## 126p

**Leak Canary** by Square

## 127p

**Leak Canary**

- Memory Leak을 검출

## 128p

**Takt** by Wasabeef

## 129p

**Takt**

- FPS를 표시

> Choreographer를 이용하므로 4.1 이상 지원 가능합니다. Choreographer에서 Vertical Synchronization 타이밍으로 FPS를 계산하므로, 비교적 정확한 계산을 지원합니다.

## 130p

**Crashlytics** by Twitter

## 131p

**Crashlytics**

- Crash 검출
- 실시간 분석
- NDK 지원

## 132p

Crashlytics

## 133p

Others

## 134p

**Others**

- Multi-Dex
- ProGuard

## 135p

**MultiDex** by Google

## 136p

**MultiDex**

- 메소드 수의 65k 제한
- 최근은 안정되었다

> 이전처럼 APK가 2배가 되거나, 극단적으로 속도가 느려지는 경향은 없어졌습니다.

## 137p

**MultiDex**

- Android Methods Count

> [https://plugins.jetbrains.com/plugin/8076](https://plugins.jetbrains.com/plugin/8076)

> 라이브러리의 메소스 수를 표시해주는 plugin입니다.

## 138p

**ProGuard** by GuardSquare

## 139p

**ProGuard**

- 소스 코드 난독화
- 미사용하는 리소스 삭제
- 어렵다

> ProGuard 정의 때문에 수작업으로 해야 하는 부분이 어렵습니다

## 140p

**ProGuard**

- Proguard 없는 경우

```
15M sample-production.apk
Total methods count: 99,280 (multidex enabled)
```

- Proguard 있는 경우

```
13M sample-production-proguard.apk
Total methods count: 54,977
```

## 141p

Conclusion

> 테스트 관련 라이브러리는 시간문제로 이야기 못했습니다만, 안드로이드 개발 시 어느 정도 라이브러리를 파악하지 않으면 안되는 시대가 되었다고 생각합니다. 그중에서 라이브러리를 이용 및 참고해서 얻는 메리트를 아는 것이 중요하다고 생각합니다.

## 142p

Thank you.

- [github.com/wasabeef](http://github.com/wasabeef)
- [twitter.com/wasabeef_jp](http://twitter.com/wasabeef_jp)
- [wasabeef.jp](http://wasabeef.jp/)
