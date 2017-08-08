---
layout: post
title: "[번역] DroidKaigi 2017 ~ 대규모 앱의 리노베이션"
date: 2017-08-05 13:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 大規模アプリのリノベーション](https://speakerdeck.com/funnelbit/droidkaigi-2017-renovation) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p, 대규모 앱의 리노베이션

- 北村 涼

## 2p, 안녕하세요

Ryo Kitramura

- Twitter :@experopero
- Hatena : funnelbit

 ## 3p, Hatena

(교토 오피스)

## 4p, Google I/O 2017 갑니다!

- 가는 사람 있으면 이야기해주세요

## 5p, 오늘 할 이야기

- 거대한 앱의 리팩토링에 대해서
   - 진행 방식
   - 설계

## 6p, 오늘 할 이야기

- 너무 방대해서 시간이 부족합니다
- 나중에 이야기하지 않겠습니까
   - 스티커 드립니다 (선착순 10명)

## 7~8p

대규모!

## 9~10p

2011 - Android 2.3 ~ 2016 - Android 7.1

오래된 코드가 계속 남아있다.

## 11p

리팩터링하고 싶다

## 12, 리팩터링하고 싶다

- 단순히 코드가 크다 + 디자인이 통일되어 있지 않음
   - 기능 추가로 코드를 쫓는 시간 → 증가
   - fix로 코드를 쫓는 시간 → 증가
- 미래의 보안이 걱정

## 13p, 리팩터링하고 싶다

- 틈틈이 하던 때도 있었다
  - 설계를 충분히 할 시간이 없었다
  - 다 바꿀 수 없다!

## 14p, 리팩터링하고 싶다

- 리팩토링에 전념할 기간이 필요
- 리팩토링 改 리노베이션

## 15p

리노베이션의 흐름

## 16p, 리노베이션의 흐름

- 도메인 지식의 획득
- 설계
- 구현 (리팩토링)

## 17p

도메인 지식의 획득

## 18p, 도메인 지식의 획득

- 옛날부터 개발하고 있는 사람은 없다
- 완벽한 도메인 지식을 아무도 가지고 있지 않다.
- 팀 구성원 공통의 도메인 지식이 필요

## 19p, 도메인 지식의 획득

화면을 알자

## 20p, 화면을 알자

- 역사와 함께 화면이 늘었다
- 어느 화면에서 시작되고 어떤 화면이 나오는지를 알자
   - 외부 앱에서 실행될 때의 화면
   - 로그인하면 내용이 바뀌는 화면
   - 오류시 화면

## 21p, 화면을 알자

> 스크린샷을 마구 찍는다

## 22p, 화면을 알자

- Graphviz로 화면 이동을 가시화

## 23p~24p, 화면을 알자

- 매우 많으므로 종이로 인쇄

## 25p, 화면을 알자

- 화면 이름
- Model
- View

## 26p, 화면을 알자

- 화면의 정보를 문서화

## 27p, 도메인 지식의 획득

디자인 의도 확인

## 28p, 디자인 의도 확인

- 화면 목록은 디자이너도 본다
- 각 부분의 디자인의 이유를 안다
   - 필요 없는 곳은 지운다

## 29p, 디자인 의도 확인

## 30p, 디자인 의도 확인

- 신규
- 신규로 즐겨찾기한 유저가 북마크한 것
- 이미지가 없는 것
- 이미지가 없고 즐겨찾기한 유저가 북마크한 것

## 31p~33p, 디자인 의도 확인

## 34p

설계

## 35p, 설계

- 라이브러리 선정
- 아키텍처 결정
- 샘플 앱 만들기
- 문서화
- 리팩토링 시작

## 36p, 설계

라이브러리 선정

## 37p, 라이브러리 선정

- 사용해도 좋은 것, 그렇게 보이는 것을 선정한다
- 설계로 바뀌기 때문에 확정하는 것이 목적이 아니다
- Retrofit 2 RxJava 2, RxLifecycle, Databinding, Realm ... 

## 38p, 설계

아키텍쳐 결정

## 39p, 아키텍쳐 결정

- 어떤 패러다임으로 할지 생각
- MVC? MVP? MVVM?
- 라이브러리와 같이 붙여본다
- **아키텍처를 지키는 것이 목적은 아니다**
   - 필요에 따라 무너뜨린다

## 40p, 설계

샘플 앱 만들기

## 41p, 샘플 앱 만들기

- 완성된 설계를 시험 & 수정

## 42p, 설계

완성된 설계

## 43p, 주요 라이브러리

- Dagger 2
- Realm
- Retrofit 2
- Retrolambda
- RxAndroid
- RxJava 2
- RxLifecycle

## 44p, 주요 래이어

View - ViewModel - Interactor - Repository

## 45p, 전제

- 아래의 레이어는 위에 레이어를 모른다
   - 레이어의 처리를 외부에 누설하지 않는다
- 아래 레이어가 상위 레이어에 결과를 전달할 때는 Observable을 사용
- Dagger2로 Inject하기

## 46p

Repository

## 47p, Repository

- EntryRepository라면 Entry에 관한 처리를 담당한다
- Interface와 그 구현을 제공한다
   - 테스트를 쉽게
- Repository를 제공하는 Dagger의 Module을 같은 패키지 내에 가진다.

## 48p, Repository

### package 구성

- bookmark.domain
   - Entry
      - Entry.java (Model)
      - EntryRepository.java (Interface)
      - EntryRepositoryImpl.java
      - EntryModule.java

## 49p, Repository

### Interface

```
public interface EntryRepository {
   Single<List<Entry>> getGalleryEntries(Category category);
}
```

## 50p, Repository

### Impl

```
public class EntryRepositoryImpl implements EntryRepository {
   BookmarkAPI mBookmarkAPI;
   @Inject
   public EntryRepositoryImpl(BookmarkAPI bookmarkAPI) {
      mBookmarkAPI = bookmarkAPI;
   }

   @Override
   public Single<List<Entry>> getGalleryEntries(Category category) {
      return mBookmarkAPI
         .getEntryListGallery(category.getId())
         .map(entries -> Lists.transform(entries, e ->
         new Entry(e, true)));
   }
}
```

## 51p, Repository

### Module

```
@Module
public abstract class EntryModule {
   @Singleton
   @Binds
   public abstract EntryRepository
   provideEntryRepository(EntryRepositoryImpl impl);
}
```

## 52p

Interactor

## 53p, Interactor

- 내부에 Repository를 가진다
- 반드시 Rx로 반환
- **변경 가능한 상태를 가지지 않는다**
- **스레드를 결정한다**
   - 마지막에는 반드시 메인 스레드로 반환
   - Interactor를 함께 사용하지 않는 전제의 설계

## 54p, Interactor

### package 구성

- bookmark.interactor
   - scheduler
      - SchedulerSwitch.java
      - SchedulerSwitchTransformer.java
   - GetUserPage.java
   - GetEntry.java
   - …

## 55p ~ 57p, Interactor

```
public class GetUserPage {
   private final UserRepository mUserRepository;
   private final SchedulerSwitch mSchedulerSwitch;

   @Inject
   public GetUserPage(UserRepository repository, SchedulerSwitch schedulerSwitch) {
      mUserRepository = repository;
      mSchedulerSwitch = schedulerSwitch;
   }

   public Single<UserPage> execute(HatenaId hatenaId, int limit) {
      return mUserRepository
         .getUserPage(hatenaId, limit)
         .compose(mSchedulerSwitch.fromIOtoUI());
   }
}
```

## 58p, Interactor

### SchedulerSwitch

```
public class SchedulerSwitch {
   private final Scheduler mIOScheduler;
   private final Scheduler mUIScheduler;

   @Inject
   public SchedulerSwitch(@IOScheduler Scheduler ioScheduler, @UIScheduler Scheduler uiScheduler) {
      mIOScheduler = ioScheduler;
      mUIScheduler = uiScheduler;
   }

   public <T> SchedulerSwitchTransformer<T> fromIOtoUI() {
      return new SchedulerSwitchTransformer<>(mIOScheduler, mUIScheduler);
   }
}
```

- IO Thread -> Main Thread

## 59p, Interactor

### SchedulerSwitchTransformer

```
public class SchedulerSwitchTransformer<T> implements
   ObservableTransformer<T, T>,
   FlowableTransformer<T, T>,
   SingleTransformer<T, T>,
   MaybeTransformer<T, T>,
   CompletableTransformer
{
…
   public SchedulerSwitchTransformer(Scheduler from, Scheduler to) {
      mFromScheduler = from;
      mToScheduler = to;
   }

   @Override
   public ObservableSource<T> apply(Observable<T> upstream) {
      return upstream.subscribeOn(mFromScheduler).observeOn(mToScheduler);
   }
…
```

## 60p

ViewModel

## 61p, ViewModel

- 내부에 Interactor을 가진다
- View는 ViewModel을 알고 있다
   - ViewModel의 메소드를 다뤄도 좋다
- ViewModel은 View를 모른다
- Activity Fragment도 View로 본다

## 62p, ViewModel

- 내부에 통지용 Observable을 가진다
   - 상태가 변경되면 통지
- DataBinding으로 자신이 Layout에 세트되는 것도 가정
- (어느 정도는) 반복 사용되는 전제

## 63p, ViewModel

- CommentsFragment - CommentsViewModel

## 64p, ViewModel

### package 구성

- bookmark.presentation
   - viewmodel
      - CommentsViewModel.java
      - …

## 67p, CommentsViewModel

```
public class CommentsViewModel {
   …
   private final BehaviorSubject<Page<BookmarkCommentViewModel>> mPages = BehaviorSubject.create();
   public final Observable<Page<BookmarkCommentViewModel>> pages = mPages.hide();

   private final PublishSubject<Throwable> mErrors = PublishSubject.create();
   public final Observable<Throwable> errors = mErrors.hide();

   @Inject
   public CommentsViewModel(Observable<FragmentEvent> lifecycle, GetEntryCommentList getEntryCommentList, AddStar addStar, Target target) {
      mLifecycle = lifecycle;
      mGetEntryCommentList = getEntryCommentList;
      mAddStar = addStar;
…
``` 

## 68p, CommentsViewModel

```
public void getNextPage() {
   mPager
      .next()
      .subscribe(
         mPages::onNext,
         mErrors::onNext
      );
}
```

- Fragment에서 메소드를 호출

## 71p, ViewModel 계층

- ViewModel은 계층 구조를 가진다 (이기도 한다)
   - CommentsViewModel
      - CommentViewModel
      - CommentViewModel
      - CommentViewModel

## 72p, CommentViewModel

```
public final class CommentViewModel {
   public final String profileImageUrl;
   public final String username;
   public final String comment;
   public final List<String> tags;
   public final String timestamp;

   public ObservableList<HatenaStar> stars;
   private final AddStar mAddStar;

   private final PublishSubject<Throwable> mErrors;

   public CommentViewModel(
      String entryId,
      BookmarkComment bookmarkComment,
      AddStar addStar,
      PublishSubject<Throwable> errorsSubject)
   {
      …
   }
```

## 73p, CommentViewModel

```
public void addStar() {
   // 별 추가중의 표시
   HatenaStar requesting = new HatenaStar(HatenaStar.Color.REQUESTING, null, null, true);
   stars.add(requesting);

   mAddStar.execute(mEntryStarInfo)
            .subscribe(
               () -> {
                  stars.set(stars.size() - 1, new HatenaStar(HatenaStar.Color.YELLOW, null, null, true));
               },
               e -> {
                  mErrors.onNext(new AddStarFailed());
                  stars.remove(requesting);
               }
            );
      }
```

## 74p, CommentLayout

```
…
<FrameLayout
   android:id=“@+id/add_star_button”
   …
   android:onClick="@{() -> viewModel.addStar()}">
</FrameLayout>

<com.hatena.android.view.star.HatenaStarsView
   android:id=“@+id/star_view"
   …
   app:hatenaStars=“@{viewModel.stars}"/>
…
```

## 75p, ViewModel

Navigator

## 76p, ViewModel

### Navigator

- 화면 전환을 나타내는 클래스
   - ViewModel에서 만들지 않고 외부에서 전달된다
   - onClick시 등의 전환에 사용된다

## 77p, ViewModel

### Navigator

#### package 구성

- bookmark.presentation
   - navigator
      - LoginNavigator.java

## 78p, ViewModel

### Navigator

```
public interface LoginNavigator {
   void openLogin();
}
```

## 79p, ViewModel

### Navigator

```
public interface LoginNavigator {
   void openLogin();

   @dagger.Module
   class Module {
      private final LoginNavigator mNavigator;

      public Module(LoginNavigator navigator) {
         mNavigator = navigator;
      }

   @Provides
   public LoginNavigator provideNavigator() {
      return mNavigator;
   }
}
```

## 80p, ViewModel

### Navigator

```
public class TopicFragment extends BaseFragment {
   private final LoginNavigator mNavigator =
      () -> startActivity(
               new Intent(getActivity(),
               LoginActivity.class)
            );
…
```

## 81p, ViewModel

### Navigator

```
@Nullable
@Override
public View onCreateView(...) {
   ((App) getActivity().getApplication())
         …
         .topicFragmentComponent()
         .loginNavigatorModule(
            new LoginNavigator.Module(mNavigator)
         )
         .build()
         .inject(this);
```

## 82p, ViewModel

### Navigator

```
public class TopicViewModel {
   …
   private final LoginNavigator mNavigator;
   public final ObservableField<View.OnClickListener>
      onClickListener = new ObservableField<>(
         new View.OnClickListener(){
            @Override
            public void onClick(View view) {
               mNavigator.openLogin();
            }
         });
```

## 83p, ViewModel

### Navigator

```
<TextView
   android:id="@+id/login"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:onClick="@{viewModel.onClickListener}"
   android:text="ログイン画面へ"/>
```

## 84p

설계의 문서화

## 85p, 설계의 문서화

- 만들기 전에 구성을 문서화한다
   - 사람의 교체에 대비한다
   - 설계를 흔들지 않게 한다.

## 86p, 설계의 문서화

- 이 설계가 된 이유도 적는다
   - 납득하기 위해서

## 87p, 설계의 문서화

### ViewModel
#### 개요

- ViewModel은 표시에 필요한 데이터를 가지고 Observable로 각각의 View에 전달합니다. 그것은 TextView일지도 모르고, RecyclerView에 표시된 Item들, 혹은 Fragment일지도 모릅니다.
- ViewModel은 결코 View에 대해 알아서는 안됩니다. 예를 들어, 다음 예를 봐주세요...

## 88p, 설계의 문서화

#### 규칙

- ViewModel은 View 대해서 알아서는 안된다. 이것은 TextView나 Dialog, Toast, RecyclerView와 그 Adapter 등을 가리킨다.
- ViewModel은 Activity와 Fragment도 View 로 본다.

## 89p, 설계의 문서화

- ViewModel은 화면 전환 작업을 수행하지만, 직접 Intent를 만들거나, FragmentManager를 조작하거나 하지 않고, 그 조작이 구현된 Navigator interface를 이용한다. Navigator는 Activity나 Fragment에서 구현된 ViewModel에 Inject된다.

## 90p

착수

## 91p, 착수

- 진행 방식
   - 화면마다 작업을 자르는 방법

## 92p, 착수

- 선이 많은 곳은 엮이는 것이 많다 -> 힘듬

## 93p, 착수

- 선이 적은 곳은 편할 것 같다

## 94p, 화면마다 진행 방식

- 하나 완성하는데 시간이 걸릴
- 견적을 짜기 어렵고, 분담하기 어렵다

## 95p, 레이어마다 진행 방식

- Repository -> Interactor -> ViewModel로 진행해 간다
- 변경했을 때의 영향을 최소화할 수 있다.
- 비교적 견적 잡기 쉽다.

## 96p, 대체 방법

- 갑자기 전부 변경하지 않는다 (파멸합니다)
   - RxJava 2 화는 나중에 (간단하면 할거야)
   - 마이그레이션 패키지에 임시 클래스를 만든다 (마이그레이션 후 지운다)
   - Component도 조금씩 이동해 나간다

## 97p

견적

## 98p

릴리즈

## 99p, 릴리즈

- 1~2 주마다 릴리즈하고 상태를 본다

## 100p

정리

## 101p, 정리

- 시작하기 전에
   - 도메인 지식을 얻는다
   - 작은 앱을 만들어 시도한다
   - 문서화한다
- 준비가 중요

## 102, 정리

- 시작 후
   - 레이어마다 나누어 아래에서 해나간다.
   - 반드시 견적을 짠다
   - 길어도 2주마다 릴리즈

## 103, 정리

- 설계는 제품에 따라 천차만별
   - 좋은 설계를 부분적으로 도입한다
   - 완벽하게 일치하는 것은 곤란