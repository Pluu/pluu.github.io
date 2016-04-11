---
layout: post
title: "[번역] Android에서는 MVC보다 MVP 쪽이 좋을지도 몰라"
date: 2016-04-06 15:00:00 +09:00
tag: [Android, MVC, MVP]
categories:
- blog
- Android
---

<!--more-->

본 포스팅은 [AndroidではMVCよりMVPの方がいいかもしれない
](http://konifar.hatenablog.com/entry/2015/04/17/010606) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

# Android 에서는 MVC보다 MVP 쪽이 좋을지도 몰라

Android를 개발하면 왠지 모르게 MVC가 잘 안되는 느낌에 답답해져 갑니다. 슬슬 다른 아키텍처를 모색하는 편이 좋다고 생각하기 시작했고, 어느 정도 생각이 정리되었으므로 저 나름대로 방침을 남겨보려고 합니다.

## 애초에 아키텍처가 필요한가

세상에는 여러 가지 아키텍처가 존재합니다만, 개념을 읽어도 확 와 닿는 것은 적지요. 그건 왜냐하면 **아키텍처가 해결하려고 하는 문제를 이해하지 못하기 때문** 입니다.

극단적으로 말하면, HelloWorld를 표시하는 어플에 MVC를 도입할 필요가 있는가? 라고 말하면 대답은 No이지요. 그러면 고양이 이름을 리스트로 표시하는 어플이라면 어떠냐고 물으면, 그것도 아직 필요 없을 듯 합니다. **즉, 아키텍처를 적용하지 않아도 문제가 없을 정도로 작은 어플에는 그냥 쓸데없이 길어지기만 할 뿐이라 그다지 필요 없는 것입니다.**

그래서, 「아키텍처가 필요해?」「어떤 아키텍처가 필요해?」라는 질문에는 「**애초에 어떤 문제가 있는가**」를 명확하게 할 필요가 있습니다. 그렇지않으면 본질을 이해하지 못한 채, 왜 이런 귀찮은걸 하는가라고 답답함을 가지게 됩니다.

## Android 개발의 어떤 문제

그러면 Android 개발의 어떤 문제는 무엇인지 저 나름대로 3가지 정리해봤습니다.

### 1. 어디에 무엇을 적어야 하는지 모른다

Activity나 Fragment는 비즈니스 로직이 들어가 있어서 방대화되기 쉽습니다. 소위 **Smart한 UI** 라고 불리는 anti-pattern 을 MVC를 의식하고 적을 텐데 Activity를 Controller도 인식한 결과, 처리 대부분을 Activity에 작성하게 되는 것도 많지 않을까요

한편으로 엔지니어는 이 상황을 어떻게 하고 싶다는 생각이 있으므로, 어떤 사람은 Model에 통신처리를 붙이고, 어떤 사람은 Dao를 만들어 맡기는 등 **각각의 Best Practice으로 작업하기 십상입니다**. 이렇게, 어디에 무엇을 적은지 모르는 일관성없는 어플이 커져가게 됩니다.

새로운 기능을 추가할 때 어떤 방침으로 하면 좋을지 모르거나 버그를 수정할 때에 코드 추적에 시간이 걸려 개발 속도가 늦어져 버리게 됩니다

### 2. 비동기 처리쪽에 버그가 발생하기 쉽다

Android에 있어서 성가신 거라고 불리는 것은 LifeCycle의 독특함입니다. 비동기 Request가 돌아온 타이밍에는 이미 Activity가 죽어있거나 합니다. 비동기 처리는 Callback을 전달하는 패턴을 자주 발견합니다만, Callback 안에 Callback 같은 느낌으로 **Callback 지옥** 이 발생해 이벤트 처리가 이곳저곳 남발하기 십상입니다. 결과, 코드의 흐름이 나빠져 작은 수정으로 버그가 만들어지기 쉬운 상황이 발생합니다

또한, Activity를 넘어 Model 갱신도 문제가 되기 쉽습니다. 예를 들면 상세화면에서 좋아요 버튼을 눌러 리스트 화면으로 복귀 시에 좋아요가 반영 안 되어있다, 등입니다.

### 3. 테스트를 적기 어렵다

Android에 의존하는 Class, 예를 들면 Fragment이나 Activity가 연관되면 테스트를 한 번에 적기 어렵게 됩니다. Activity를 무겁게 하면 안 좋다고 듣는 것 이것이 큰 이유입니다. 그래서 비즈니스 로직은 가능한 한 View나 Activity에 의존 안 하는 곳에 적어야 합니다만 **MVC에서 말하는 Controller의 부분을 Android에서 어떻게 할 것인가** 의 방침이 없는 상황에서는 상당히 어렵습니다.

또한, Android는 카메라나 GCMService, API, DB와 외부와의 연계가 많고, 연동의 실제 처리라고 할 기술적인 부분이 비즈니스 로직에 포함되기 쉽지 않을까요. 그 결과, 왠지 모르게 테스트하기 어려운 코드가 되기 쉽습니다

## 비즈니스 로직 분리를 강제하고 싶다

여기까지 들으면 **MVC로 해결할 수 있잖아** 라고 생각할지도 모르지만, 1년 반 정도 팀에서 Android 개발해온 느낌으로는 MVC로는 제대로 하기 어렵지 않겠냐고 느끼고 있습니다. **Android에서의 Controller 개념이 너무 넓어서 View와 뒤섞이기 쉽기** 때문입니다.

예를 들면 리스트를 받아 표시하는 화면을 만드는 데 있어서 Load나 Cache는 어디에서 해야 할 것인가? 라는 부분이 알기 어렵다. 그래서, 결국 Activity에 해버리고 Activity는 View를 가지므로 Callback 결과를 그대로 View에 반영하거나.

그래서 이러한 외부 데이터의 취득이나 View에 반영 등을 누가 봐줄 것인가의 부분이 개념적으로 정의되어있는 아키텍처 쪽이 좋지 않으냐고 생각이 들었습니다. **비즈니스 로직 분리를 강제하는 아키텍처** 가 필요했습니다.

## MVP+DDD와의 만남

여러 가지 아키텍처를 공부하고 Android 코드에 녹이면 어떻게 될지를 생각했습니다만 **Model-View-Presenter** 아키텍처 하나의 해결책으로 되지 않겠느냐고 생각합니다.

아래는 참고한 링크입니다

- [The Clean Architecture](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Architecting Android…The clean way?](http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/)
- [MvpCleanArchitecture](https://github.com/glomadrian/MvpCleanArchitecture)
- [EffectiveAndroidUI](https://github.com/pedrovgs/EffectiveAndroidUI/tree/master/app/src/main/java/com/github/pedrovgs/effectiveandroidui)
- [도메인 모델 중심 아키텍처](http://blog.guildworks.jp/2014/11/14/%E3%83%89%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%A2%E3%83%87%E3%83%AB%E4%B8%AD%E5%BF%83%E3%81%AE%E3%82%A2%E3%83%BC%E3%82%AD%E3%83%86%E3%82%AF%E3%83%81%E3%83%A3/)
- [Android-arch](https://github.com/kgmyshin/Android-arch)

이런 것들의 무엇이 좋으냐고 하면, 개념마다 역할이 명확해 그대로 패키지 구성에 녹여 이해된다는 점이지요. 실로 **비즈니스 로직 분리를 강제한다** 라는 목적에 적합한 아키텍처입니다

## 패키지 구성과 역할

전체적인 개념은 [Architecting Android…The clean way?](http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/) 을 참고해주시고, 패키지 구성에서 간단하게 역할을 설명하겠습니다. 장황하므로 이해하기 어려우시다면 패스해주세요. 미안합니다.

저의 패키지 구성은 아래와 같습니다.

```
├data
│ ├cache
│ │ └TweetCache.java
│ ├entity
│ │ └mapper
│ │   └TwitterUserMapper.java
│ ├exception
│ │ └NetworkConnectionException.java
│ ├executor
│ │ └JobExecutor.java
│ └repository
│   └TweetRepositoryImpl.java
├domain
│ ├exception
│ │ └ErrorBundle.java
│ ├executor
│ │ └ThreadExecutor.java
│ ├model
│ │ └Tweet.java
│ ├repository
│ │ └TweetRepository.java
│ └usecase
│   └GetTweetListUseCase.java
│
├presentation
│ ├di
│ │ ├component
│ │ ├module
│ │ │ ├ActivityModule.java
│ │ │ ├ApplicationModule.java
│ │ │ └TweetModule.java
│ │ ├HasComponent.java
│ │ └PerActivity.java
│ ├presenter
│ │ ├Presenter.java
│ │ └TweetListPresenter.java
│ ├Service
│ │ └GcmService.java
│ └view
│   ├activity
│   │ └TweetListActivity.java
│   ├adapter
│   │ └TweetsAdapter.java
│   ├component
│   │ └ProfileHeaderView.java
│   ├fragment
│   │ └TweetListFragment.java
│   └util
│     └DateUtil.java
│
└MainApplication.java
```

### domain

애플리케이션의 핵심이 되는 부분입니다. 모델이나 비즈니스 로직을 정리하여 작성합니다. **이 패키지에 포함되는 클래스는 모델이 어디에서 얻어져서 어떻게 표시하는가를 나타내는 외부적인 것은 아무것도 모릅니다.** 바깥과의 처리는 모두 Interface로 이루어집니다. 실제로 처리를 하는 클래스는 `data` 패키지 아래에 있고, [Dagger](http://google.github.io/dagger/)를 사용해 DI하게 됩니다. 여담입니다만, 의존성 주입이라는 말은 의미가 알기 어려우므로 싫습니다.

### exception

비즈니스 로직에서의 예외를 핸들링하기 위한 추상 클래스를 놓습니다.  

```
public interface ErrorBundle {
  Exception getException();

  String getErrorMessage();
}
```

구현은 `data/exception/NetworkConnectionException.java` 같은 클래스로 Presenter가 캐치해서 에러 표시등 적절하게 처리합니다

```
private void showErrorView(ErrorBundle errorBundle) {
  // 에러 표시
}
```

### executor

UI 스레드로부터의 처리 시 다른 스레드로 실행시키기 위한 Interface를 놓습니다.

```
public interface ThreadExecutor {
  void execute(final Runnable runnable);
}
```

### model

모델 클래스를 놓습니다. DDD에서는 Ubiquitous 단어로 이해되는 개념을 클래스로 둬야 합니다만, Entity를 그대로 모델 클래스로 해둬 좋을 것 같습니다

### repository

model을 얻어 갱신하는 Interface입니다. CRUD에 따라 작성하는 것이 알기 쉬울 것입니다. `data/repository` 아래에 실제로 처리하는 클래스를 구현합니다. 이곳을 Interface로 해둠으로써 API 경우로 받을지, DB에서 받을지에 대한 기술적인 부분은 domain 패키지에서는 몰라도 됩니다.

```
public interface TweetRepository {
  void getHomeTweetList(Long lastTweetId, TweetListCallback callback);

  void getUserTweetList(long userId, Long lastTweetId, TweetListCallback callback);

  interface TweetListCallback {
    void onTweetListLoaded(Collection<TweetModel> tweets);

    void onError(ErrorBundle errorBundle);
  }
}
```

### usecase

사용자의 Tweet 리스트를 받아오고, 사용자의 프로필을 받아오는 비즈니스 로직을 클래스화합니다. 구현으로는 Repository와 Executor를 사용해 Model를 얻어 반환하도록 합니다. Android에서는 UI 스레드와 같은 곳에서 처리하면 안 되므로 아래의 UseCase Interface를 상속해서 별도 스레드에서 처리하도록 합니다.

```
public interface UseCase extends Runnable {
  void run();
}
```

여기에서의 구현은 Handler나 AsyncTask를 사용해도 좋습니다. 결과 알림으로는 [EventBus](https://github.com/greenrobot/EventBus)를 사용했습니다. `onEventMainThread(Event event)`로 UI 스레드가 이벤트를 받을 수 있습니다. 이 부분은 [RxAndroid](https://github.com/ReactiveX/RxAndroid)를 사용하는 경우도 많습니다만, 조금 Rx는 개념을 이해하는 것이 어려워 우선은 보류입니다.

```
public interface GetHomeTweetListUseCase extends UseCase {
  void execute(Long lastTweetId);

  public class OnLoadedEvent {
    public final Collection<TweetModel> tweetModels;

    public OnLoadedEvent(Collection<TweetModel> tweetModels) {
      this.tweetModels = tweetModels;
    }
  }

  public class OnErrorEvent {
    public final ErrorBundle errorBundle;

    public OnErrorEvent(ErrorBundle errorBundle) {
      this.errorBundle = errorBundle;
    }
  }
}
```

### data

domain 패키지에 정의한 Interface를 구현합니다. API 요청, DB 접근 같은 기술적인 부분은 여기에 모아둡니다.

### cache

Cache 작성, Cache 취득 등을 구현합니다. Cache를 파일로 할 것인가? DB로 할 것인가? 메모리로 할 것인가는 구현하기 나름입니다.

### entity/mapper

entity를 `domain/model`로 변환하는 클래스를 놓습니다. [Retrofit](http://square.github.io/retrofit/)을 사용해 Json 데이터의 Parse까지 라이브러리가 처리해주는 경우에는 필요 없을 것입니다. Facebook이나 Twitter 등 외부의 Entity를 그대로 사용하고 싶지 않을 때에는 mapper를 사용해 domain/model로 변환해 다루는 것이 좋지 않으냐고 생각합니다. 변환의 좋은 처리방법은 모색 중입니다.

```
@Singleton class UserMapper {

  @Inject UserMapper() {
  }

  public UserModel transform(User user) {
    UserModel userModel = null;
    if (user != null) {
      userModel = new UserModel(user.id);
      userModel.setName(user.name);
      // ...
  }
}
```

### repository

`domain/repository`의 Interface를 구협합니다. Cache가 있으면 Cache 데이터를 얻어오거나 API 경우로 가져오거나, 가져온 것을 Cache에 담는 부분도 repository가 담당합니다. **중요한 것은 여기에서 어떤 로직으로 얻어오더라도, `domain/repository`는 알 수가 없다는 것입니다.** 실로 비즈니스 로직을 분리하도록 설계된 패턴입니다.

### presentation

사용자의 입력을 받아 내부 도메인을 처리하여 View에 반영하는 역할을 담당합니다.

### di

[Dagger](http://google.github.io/dagger/)를 사용하여 DI를 하기위한 Module을 놓습니다. Module의 좋은 나누는 방법은 생각 중입니다만, 지금은 [Android-CleanArchitecture](https://github.com/android10/Android-CleanArchitecture)를 참고해서 같은 구성으로 Component, Module을 나눴습니다. new로 Interface화한 클래스를 거의 없앨 수 있으므로 테스트 시에는 간단하게 MockClass로 바꿀 수 있습니다

### presenter

UseCase와 View를 가지고, 입력에 따라 각각을 조작합니다. 예를 들면, Click되면 `presenter#onClicked()`를 호출하도록 하여 `onClicked()` 안에서 UseCase의 갱신처리를 호출하고 Callback 이벤트를 받아 `view.showSuccess()`를 호출하는 방식입니다. presenter는 LifeCycle을 가지는 Fragment나 Activity의 이벤트를 받게 되므로, 동일한 LifeCycle을 나타내는 `onResume()`이나 `onPause()`등의 Domain을 정의해놓습니다

```
public interface Presenter {
  /**
   * Method that control the lifecycle of the view. It should be called in the view's
   * (Activity or Fragment) onResume() method.
   */
  void resume();

  /**
   * Method that control the lifecycle of the view. It should be called in the view's
   * (Activity or Fragment) onPause() method.
   */
  void pause();
}
```

presenter가 가지는 View를 추상화하는 것으로 완전하게 Android와의 의존을 없애 테스트하기 쉽게 되지만, 화면에 따라서는 View의 추상화를 제대로 하지 못하고 장황하게 만들게 되는 가능성도 있으므로, 크게 구애받을 필요는 없습니다

```
@PerActivity
public class TweetListPresenter implements Presenter {

  private final GetHomeTweetListUseCase getHomeTweetListUseCase;
  private TweetListView tweetListView;

  @Inject
  public TweetListPresenter(GetHomeTweetListUseCase getHomeTweetListUseCase) {
    this.getHomeTweetListUseCase = getHomeTweetListUseCase;
  }

  // FragmentはTweetListViewをimplementsしておく
  public void setView(@NonNull TweetListView view) {
    this.tweetListView = view;
  }

  @Override public void resume() {
    EventBus.getDefault().register(this);
  }

  @Override public void pause() {
    EventBus.getDefault().unregister(this);
  }

  public void loadTweetList() {
    this.hideViewRetry();
    this.showViewLoading();
    this.getTweetList();
  }

  public void onTweetClicked(TweetModel tweetModel) {
    this.tweetListView.showTweet(tweetModel);
  }

  private void showViewLoading() {
    this.tweetListView.showLoading();
  }

  private void hideViewLoading() {
    this.tweetListView.hideLoading();
  }

  private void showViewRetry() {
    this.tweetListView.showRetry();
  }

  private void hideViewRetry() {
    this.tweetListView.hideRetry();
  }

  private void showErrorMessage(ErrorBundle errorBundle) {
    this.tweetListView.showError("");
  }

  private void showUsersCollectionInView(Collection<TweetModel> tweets) {
    this.tweetListView.renderTweetList(tweets);
  }

  private void getTweetList() {
    this.getHomeTweetListUseCase.execute(null);
  }

  public void onEventMainThread(GetHomeTweetListUseCase.OnLoadedEvent event) {
    showUsersCollectionInView(event.tweetModels);
    hideViewLoading();
  }

  public void onEventMainThread(GetHomeTweetListUseCase.OnErrorEvent event) {
    hideViewLoading();
    showErrorMessage(event.errorBundle);
    showViewRetry();
  }
}
```

### service

service 클래스를 놓습니다. Presenter를 가지며 처리는 Presenter에 위임하는 형태가 됩니다

### view

activity, adapter, fragment 등 View 관련 Class를 놓습니다. Custom View는 component 아래에 놓습니다. Util Class는 View에 관련되면 `view/util` 에 놓습니다. 여기는 Android에 완전히 의존하게 됩니다. 다른 패키지는 의존하지 않도록 한다면, View를 추상화한 Interface를 두고 Fragment나 Activity에 implements 하면 좋습니다.

```
public interface TweetListView extends LoadDataView {
  void renderTweetList(Collection<TweetModel> tweetModelCollection);

  void showTweet(TweetModel tweetModel);
}
```

## 만들어보지 않으면 이해하기 어렵다

대충 보면 내용은 알겠지만 많은 역활 세분화로 조금 장황해진 느낌입니다. 예를 들면, Presenter가 UseCase를 다뤄 Repository가 데이터를 얻는다고 물으면, Usecase 필요한가?라고 생각할 것입니다. 저도 처음에는 그렇게 생각했습니다.

이러한 세세한 부분은 스스로 적어보지 않으면 이해할 수 없는 부분이 있지요. 어플에 따라서는 일부는 바꾸는 편이 좋은 경우도 있습니다. 우선은 프로젝트를 만들고 사용해보도록 했습니다. 아직 사용해보는 도중입니다만, Twitter Client를 만들어 시행착오를 겪고 있습니다.

> [konifar/twipe](https://github.com/konifar/twipe/tree/bk_mvp)
twipe - Twipe is the fast and easy to use material design Twitter client.

## 개발 속도와의 트레이드 오프

MVP를 도입해본 느낌으로는 역할을 세심하게 나눔에 따라 새로운 기능을 작성 시 Class의 수가 반대로 증가한다는 것입니다. 이것은 판단이 어렵습니다만, 어플에 따라서는 **필요하지 않은 추상화로 개발 속도가 떨어질지도 모릅니다**

예를 들면, API로부터 데이터를 얻어 리스트 표시하는 부분에 Cache를 넣게 될지도 모르는 가정을 합니다. 그 경우, Factory 패턴이나 Strategy 패턴을 도입하여 구현을 바꾸도록 추상화하게 될지도 모릅니다만, 그 변경이 정말로 필요한 것인가 혹은 언제 필요하게 될지도 예측할 수 없는 경우도 많습니다. 일반적으로 추상화는 어렵고, 설계 · 구현과 함께 시간을 들일 필요가 있습니다. 어플이나 조직의 규모로부터 변화의 가능성을 판별하고, 필요하다면 아키텍처 일부를 채용하지 않고 스피드를 우선시키는 편이 좋을 수도 있습니다

저의 경우는 Presenter가 다루는 View는 추상화하지 않고, Android의 View에 의존해도 괜찮지 않으냐고 생각하기도 합니다. 화면마다 Interface를 만들면 엄청난 수가 되어 모으기 어렵게 될 예감도 듭니다. 또한 애초에 변화가 많은 View 부근은 Util 테스트 코드를 작성하지 않고 다른 방법으로 품질을 보증하는 편이 좋다고도 생각합니다. [Espresso](https://code.google.com/p/android-test-kit/wiki/Espresso) 나 [Robolectric](http://robolectric.org/) 를 사용하는 것이 좋을지도 모릅니다.

## 그 외에 생각한 것

- 팀에서 아키텍처를 선정했을 때에는 문서에 남기고, 코드 리뷰를 철저히 하고, 스터디를 하며, 팀 전체에 침투시키는 구조가 필수
- RxAndroid는 Stream 개념을 잡기까지의 코스트가 높기 때문에 팀에 도입하지 않는 것이 좋을지도. 그리고 TwitterSDK등 외부 API는 여태까지와 같이 Callback으로 하므로, 여기는 Reactive로 다른 상태가 되는 것은 미묘.
- Facebook Share 등 외부와의 연동 부분은 아직 생각 중.
- LifeCycle의 Wrapper에 대해서는 필요 없다고 생각하고 있다. 예를들면 [UniversalImageLoader](https://github.com/nostra13/Android-Universal-Image-Loader)를 [Picasso](http://square.github.io/picasso/)로 바꿀 때를 위해서 `displayImage(url)`와 같은 메소드를 추상화해둘 것인가, 라는 이야기. 라이브러리를 교체하는 것은 거의 없으므로 우선은 생각하지 않아도 될 거라고 생각한다. API 부분은 Repository 패턴에 따라 추상화하므로 문제없다.
- [Dagger](http://google.github.io/dagger/), [EventBus](https://github.com/greenrobot/EventBus), [Retrofit](http://square.github.io/retrofit/), [AndroidAnnotation](http://androidannotations.org/), [retrolambda](https://github.com/orfjackal/retrolambda)은 도입하는게 좋다.
