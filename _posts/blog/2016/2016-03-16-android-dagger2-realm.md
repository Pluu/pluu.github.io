---
layout: post
title: "[번역] DroidKaigi 2016 ~ Dagger2와 Realm을 이용한 모던 개발"
date: 2016-03-16 20:30:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [droidkaigi2016 by funnelbit](https://speakerdeck.com/funnelbit/droidkaigi2016) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

Dagger2와 Realm을 이용한 모던 개발

## 2p

**자기소개**

- Kitamura Ryo
- Hatena id : funnelbit
- Twiiter id : experopero

## 5p

Hatena Bookmaker

## 6p

교토

## 7p

**오늘 주제**

- 프레임워크로부터 로직을 분리
- 영속화
- 서버 사이드와 병행해서 개발
- 제품 체크

## 8p

프레임워크로부터 로직을 분리

## 9p

**프레임워크**

- Android SDK가 제공하는 어플이나 화면 LifeCycle과 강하게 묶여있는 Class

## 10p

**로직을 어디에 작성할 것인가**

- X Activity, Fragment에 직접 작성
  - 비대화, 테스트 불가능
- ▲ CustomView에 직접 작성
  - View의 로직은 이곳에 작성하면 좋다
- 그 이외의 장소

## 11p

**그 이외의 장소?**

- 로직을 추상화해서 분리
- ~ Controller, ~ Manager 등, 로직 담당 클래스를 만든다

## 12p

**로직의 추상 Instance를 어디에 만들 것인가?**

- ▲ 사용하는 Activity에 직접 작성
  - 결합이 상하게 된다
  - 테스트시 동작을 변경하고 싶을 때는?
- ○ 사용하는 외부에서 생성 · 관리
  - 의존시키지 않는다
  - 테스트시 바꾸기 같은 것이 간편
- DI??

## 13p

**소박한 DI**

```
public EntryManager(APIClient apiClient) {
   this.mAPIClient = apiClient;
   ...
}
```

## 14p

**소박한 DI를 사용할 수 없는 문제**

- Activity와 Fragment에 대해서는 무력
  - 생성자에서 Instance를 넘길 수 없다
- Parcelable로하여 굳이 한다면 안 되는 것은 아니지만 굳이 하고 싶지는 않다
- 이 문제는 DI Container가 있으면 해결된다

## 15p

**DI Container**

- 의존주입을 하는 프레임워크
  - 수동으로 구성을 하지 않아도 된다
  - Instance 관리도 할 수 있다

## 16p

**어떤 DI Container를 사용할 것인가?**

- RoboGuide
- Dagger
- Dagger2

## 17p

Dagger2

## 18p

**Dagger2**

- [https://github.com/google/dagger](https://github.com/google/dagger)
- DI Container
- Square가 개발한 Dagger의 google fork

## 19p

**Dagger2 이점**

- Compile시에 코드를 생성하여 의존 해결
  - 실행 중에 퍼포먼스에 영향을 주지 않는다
  - 디버그로 코드를 추적하기 쉽다

## 20p

**DI 구성**

- Module
  - Instance 생성방법을 기술
- Component
  - Module 내 Instance를 어디에 inject 할 것인가를 기술
  - 계층 구조를 가져 역할을 분담해 명확화

## 21p

**Module**

```
@Module
public class MainModule {
...
   @Provides
   EntryManager providedEntryManager() {
     return new EntryManager(mService);
   }
...
```

## 22p

**Component**

```
@Component(modules = MainModule.class)
public interface MainComponent {
   void inject(MainActivity mainActivity)
...
```

## 23p

**Inject**

```
publc class MainActivity extends AppCompatActivity {
  @Inject EntryManager mEntryManager;
  @Override
  protected void onCreate(Bundle b) {
    ...
    ((App)) getApplication())
                 .component()
                 .inject(this);
    ...
```

## 24p

**Test용 Module**

```
@Module
public class MainTestModule {
...
   @Provides
   EntryManager providedEntryManager() {
     return new EntryManager(mStubService);
   }
...
```

## 25p

**테스트용 Component**

```
@Component(modules = MainTestModule.class)
public interface MainTestComponent {
   void inject(EntryManagerTestCase testCase)
...
```

## 26p

**Inject(테스트)**

```
public class EntryManagerTestCase extends InstrumentationTestCase {
...
   @Inject
   EntryManager mEntryManager;
...
   public testGetEntries() {
     assertEquals(
       "Entry 취득할 수 있다",
       false,
       mEntryManager.getEntries().isEmpty());
   }
}
```

## 27p

**Component의 분리방법**

- Activity나 Fragment마다 나누는가?
  - 개수가 점점 늘어간다
- 역할마다 나눈다
  - 계층구조를 만들고 세분화

## 28p

**SubComponent**

```
@Component(modules = MainModule.class)
public interface MainComponent {
  void inject(App app);

  // Activities
  void inject(RootActivity rootActivity);

  // Fragments
  void inject(MainSettingsFragment mainSettingsFragment);

  // Subcomponents
  UserComponent userComponent(UserModule userModule);
}
```

## 29p

**SubComponent**

```
@Subcomponent(modules = UserModule.class)
public interface UserComponent {
  // Fragments
  void inject(MyFragment myFragment);

  UserController userController();
}
```

## 30p

**Component 취득**

```
public class MyFragment extends Fragment {
  MainComponent mainComponent =
      App.get(getActivity())
          .getMainComponent();

  UserComponent userComponent =
      mainComponent.userComponent(
          new UserModule(
                  mainComponent.getRealm(),
                  args.getString(ARGS_USER_ID)));

  userComponent.inject(this);
}
```

## 31p

영속화

## 32p

**영속화하는 목적**

- WebAPI로부터의 Response를 영속화
  - 온라인용 Cache 데이터를 위해
  - Activity나 Fragments의 재생성 시 복구하기 위해
  - 복수 화면에서 동일 데이터를 표시하는 경우 일관성을 가지기 쉽게 하기 위해

## 33p

**영속화하는 수단**

- x Shared Preferences에 넣는다
- ▲ File에 작성
- ○ SQLite에 넣는다
- ○ Realm를 사용

## 34p

**SQLite**

- Android 표준이므로 안심감이 있다
- 직접 작성하는 것은 조금 불편하다
- ORM 사용?
  - 사용 용이성, 속도, 안정, 종래성...

## 35p

**Realm**

- 개발이 활발
- SQLite같은 귀찮음을 하지 않아도 된다
- ▲ 버전 1.0 미만

## 36p

**Realm을 사용**

- iOS 어플(가능한)과 공통 모델을 가지기 위해
- 개발이 활발하니 뭔가 있어도 대처해주겠지

## 37p

Realm

## 38p

**Realm**

- SQLite를 대체할 수 있는 Mobile database
- ORM 기능도 포함
- 고속
- iOS에서도 사용 가능

## 39p

**Realm을 사용**

```
new RealmConfiguration.Builder(context)
         .name("realm")
         .schemaVersion(1L)
         .build();
```

## 40p

**Realm을 사용**

```
RealmResults<Entry> followingEntries =
   mRealm.where(Entry.class)
         .equalTo("isFollowing", true)
         .findAllSortedAsync(
           "createdAt",
           Sort.DESCENDING);
```

## 41p

**Activity 생성 시에 꺼내기**

```
public class MainActivity extends AppCompatActivity {
...
public void onCreate(Bundle saveInstanceState) {
  mRealmResults = mRealm.where().findAllAsync()
...
}
```

- 바로 RealmResults를 얻는다
- 올바르게 복원하기 위해서도 사용

## 42p

**Adapter에 RealmResult**

```
public class EntriesAdapter {
  public EntriesAdapter(RealmResults<Entry> entries) {
    mEntries = entries;
    mRealmChangeListener = new RealmChangeListener() {
      @Override
      public void onChange() {
        mListItems = getItems();
        EpisodesAdapter.this.notifyDataSetChanged();
      }
    };
    ...
  }
...
```

## 43p

**Adapter에 RealmResult**

```
public class EntriesAdapter {
...
  @Override
  public void onAttachedToRecyclerView(RecyclerView recyclerView) {
    super.onAttachedToRecyclerView(recyclerView);
    mResults.addChangeListener(mRealmChangeListener);
  }

  @Override
  public void onDetachedFromRecyclerView(RecyclerView recyclerView) {
    mResults.removeChangeListener(mRealmChangeListener);
    super.onDetachedFromRecyclerView(recyclerView);
  }
...
```

## 44p

**Activity간 데이터를 전달**

```
Intent intent = new Intent(context, EpisodeActivity.class);
intent.putExtra(EXTRA_ID, id);
```

- Realm ID를 전달하게 된다
- 재생성 시를 위해서도 갖추게 된다

## 45p

Realm을 Dagger2로 Thread마다 Inject

## 46p

**스레드 간을 넘을 수 없는 문제**

- RealmInstance가 작성된 스레드로부터 다른 스레드에서 사용할 수 없다
- 하지만 Inject는 onCreate()에서 하고 싶다
- "다른 스레드를 원할 때에 Inect하는 구조"가 필요

## 47p

**Dagger2의 Provider를 사용**

```
...
@Inject public EntryPrefetcher(Provider<Realm> realmProvider) extends ThreadPoolExecutor {
  mRealmProvider = realmProvider;
...
private static class Task implements Callable<String> {
  @Override
  public String call() throws Exception {
    Realm realm = mRealmProvider.get();
    ...
  }
...
```

## 48p

서버 사이드와 병행한 개발

## 49p

**서버 사이드와 병행한 개발**

- API가 반드시 선행한다고는 할 수 없다
- Dummy 데이터를 어플 내부에서 들고 있을까?
  - API에 변경이 있을 때에 불편
  - iOS측도 동시에 변경할 필요가 있다

## 50p

Stub Server

## 51p

**Stub Server**

- Dummy Response를 반환하는 서버를 만든다
- APISchema(Validator로 이용)
  - [https://github.com/hitode909/APISchema](https://github.com/hitode909/APISchema)

## 52p

**Stub Server**

```
resource login_request => {
  type => 'object',
  description => '로그인 Request',
  properties => {
    email_address => {
      type => 'string',
      description => '메일주소',
      example => 'abc@example.com',
    },
    password => {
      type => 'string',
      description => '패스워드',
      example => 'PasswordOrd!',
    },
  },
  requeired => ['email_address', 'password'],
};
```

## 53p

**테스트에서도 StubServer를 사용**

- ▲ Dummy JSON을 내부에 가지고 테스트로 사용
  - API 수정할 때마다 변경하지 않으면 안된다
  - API 변경에 테스트가 알 수 없다
- ○ API 서버를 직접 건드린다
  - Dummy 데이터 불필요
  - 변경 시 테스트가 알 수 있다

## 54p

제품 체크

## 55p

**제품 체크**

- 교토 · 도쿄에 사무실이 있다
  - 도쿄에도 디자이너가 있다
  - 감촉은 직접 만지지 않으면 알 수 없다

## 56p

BetaByCrashlytics + jenkins + fastlane

## 57p

**Beta**

- BetaByCrashlytics를 사용해 Beta 배포
- 배포 타이밍은 jenkins에 맡긴다

## 58p

**jenkins**

- Branch르 보고, master에 merge 되면 Beta를 보낸다
- 스크린샷을 찍어 간단하게 디자인을 확인
  - API마다 차이 등을 확인
- Slack에 알림

## 59p

**fastlane**

Github 연동

```
data = {satate: state, target_url: target_url, context: context, description: ""}

headers = {Authorization: "token #{token}"}

Excon.post(url, headers: headers, body: data.to_json)
```

## 60p

**fastlane**

Github 연동

```
slack(
  message: ":rocket: 빌드가 완료했습니다 :rocket:",
  channel: "#app",
  success: true,
  payload: {
    'Build Data' => Time.new.to_s,
  },
  default_payloads: [:git_branch, :git_author]
)
```

## 61p

**테스트 실행**

```
desc "Runs all the tests"

lane :test do

  gradle(task: "cC")

end
```

## 62p

**정리**

- 프레임워크로부터 로직을 분리
  - 로직의 추상화 Dagger2로 Inject
- 영속화
  - Realm을 이용
- 서버 사이드와 병행한 개발
  - StubServer를 이용
- 제품 체크
  - BetaByCrashlytics, jenkins, fastlane
