---
layout: post
title: "[번역] DroidKaigi 2017 ~ 건장한 Activity를 개선한 이야기"
date: 2017-04-15 18:45:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 💪🏻Activityを改善した話](https://speakerdeck.com/lvla/activitywogai-shan-sitahua) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

**Activity를 개선한 이야기**

@lvla0805

## 2p

**Moyuru Aizawa**

> Lead Kotlin engineer of Pairs Div. Eureka, Inc.

## 3p

**eureka**

- Pairs
- Couples
- a member of IAC/Match Group

## 4p ~ 5p

Pairs

## 6p

먼저 이상적인 상대를 찾습니다

## 7p

관심이 가는 상대에게 "좋아요!"를 보낸다

## 8p

매칭 후, 메시지 교환

## 9p

샘플 코드에 대해

## 10p

Pairs는 Java/Kotlin이 섞여 있습니다. 그래서, 샘플 코드에도 두 언어가 이용되고 있습니다.

## 11p

Kotlin이 어려운 친구 여러분

## 12p

도서관에서 Kotlin에 대해 찾아봐요!

## 13p ~ 16p

**Instance 생성**

```
// Java
final Serval serval = new Serval();
Kaban kaban = new Kaban();
```
```
// Kotlin
val serval = Serval()
var kaban = Kaban()
```

## 17p ~ 19p

```
// Java
public class JapariBus {
    private final Trailer trailer;
    private final Container container;

    public JapariBus(Trailer trailer, Container container) {
        this.trailer = trailer;
        this.container = container;
    }
}
```
```
// Kotlin
class JapariBus(private val trailer: Trailer,
                private val container: Container)
```

## 20p ~ 23p

**Lambda**

```
// Java
observable.map(new Fun1<Foo, Bar>() {
    @Override
    public Bar call(Foo foo) {
        return foo.toBar();
    }
});
```
```
// Kotlin
observable.map { foo -> foo.toBar() }
```

## 24p

본론

## 25p

Pairs에는 Activity가 가득(했다)!

## 26p

사용 기술에 대해

## 27p

**기술개요**

| Languages | Java/Kotlin |
| Network | Retrofit2, OkHttp3 |
| O/R Mapper | Orma |
| Reactive Programming | RxJava1 |
| Dependency Injection | Dagger2 |

## 28p

Activity?

## 29p

- 비즈니스 로직을 가지고 있다
- IO 처리가 가득 적혀 있다
- 어쨌든 라인이 많다

## 30p

비즈니스 로직

## 31p

**비즈니스 로직**

```
if (isPaidUser) {
    // 유료 회원만 사용할 수 있는 기능을 유효화한다
} else {
    // 유료 회원만 사용할 수 있는 기능을 무효화한다
}
```

## 32p

**비즈니스 로직**

```
if (isLikedByPartner) {
    // 상대방으로부터 좋아요! 를 받았을 때 상태
} else if (iisLikedByMe) {
    // 좋아요! 를 했을 상태
} else if (isLikedWithMessage) {
    // 메시지 포함한 좋아요! 를 했을 상태
} else if (isLooked) {
    // 봐줘! 를 했을 상태
} else if (isLookedWithMessage) {
    // 메시지 포함 봐줘! 를 했을 상태
} else if (isHidden) {
    // 비표시 설정을 한 직후
} else if (isBlocked) {
    // 차단 설정을 한 직후
} else if (...) {
    ...
}
```

## 33p

**비즈니스 로직**

- 이것뿐이라면 문제는 적을 거라고 보이지만
- 비즈니스 로직이 겹쳐져 어플리케이션이 만들어진다
- 복수 비즈니스 로직이 Activity/Fragment/Adapter에 넘치면, 코드를 따라가는 것이 어렵다... 

## 34p

IO

## 35p

**IO**

```
userClient.fetchMathingUsers()
    .subscribeOnIO()
    .doOnNext { users -> userDao.insertAll(users) }
    .onError { userDao.findAll() }
    .observeOnMain()
    .subscribe(
        { users -> showUsers(users) },
        { ... })
```

## 36p

어쨌든 라인이 많아 괴롭다

## 37p

적은 Activity 만이 아니다!

## 38p

**힘든 점**

- 엄청난 책임
- 神 클래스
- static 아저씨

## 39p

엄청난 책임

## 40p

**엄청난 책임**

- Converter
  - Json을 맵핑한 클래스로부터 앱 내에서 사용하기 쉬운 데이터 클래스로 변환하는 클래스
  - 변환을 하는 것만이 책임이다

```
class UserConverter {
    fun convert(res: MatchingUsersResponse): List<User> {
        return res.users.map { resUser -> User(resUser.name, ...) }
    }
}
```

## 41p

그런데

## 42p

**엄청난 책임**

- Convert하는 과정에서 유저 필터링을 하는 Converter

```
class UserConverter {
    fun convert(res: MatchingUsersResponse): List<User> {
        return res.users.map { resUser -> User(resUser.name, ...) }
            .filter { ... }
    }
}
```

## 43p ~ 44p

神 클래스

## 45p

**神 클래스**

XxxManager

## 46p

**神 클래스**

- SearchManager
  - 검색 조건 보유
  - 검색 결과 보유
  - 검색결과를 얻는 처리 관리
  - ...

## 47p

**神 클래스**

- 신을 두려워
- 신에게 기도하고
- 신에게 목숨을 바치는 나날

## 48p

Static 아저씨

## 49p

**static 아저씨**

- API이나 Database를 조작하는 메소드 등, 곳곳에서 static 메소드를 사용한 구현이 되어있다

## 50p ~ 53p

**static 아저씨**

```
public static Observable<List<User>> fetchMathingUsers() {
    return PairsClient.getRetrofit()
        .create(MatchingUsersService.class)
        .fetch()
        ...
}
```

## 54p

**static 아저씨**

- 퍼포먼스가 좋지 않다
- "static 메소드에서 static 메소드를 사용해 Retrofit을 얻어 Interface 구현 생성을 한다"라는 숨은 입력값이 있다
- 숨어있어서는 Mock을 할 수 없다
  - Unit 테스트가 어렵다...

## 55p

**static 아저씨**

```
class MatchingUsersClient(
    private val service: MatchingUsersService) {

    fun fetch(): Observable<List<User>> {
        return service.fetch().....
    }
}
```

## 56p

위험해! 어떻게 해야 한다!

## 57p

EMERGENCY!!

## 58p

**Emergency**

- Retorift1 -> 2로 전환시
- 원래 POST로 해야 할 곳을 GET로 했다
- 중요한 기능이 사용 불가능한 상태로

## 59p

- 이후 같은 실패를 반복하지 않기 위해서는?
- 수동 테스트를 늘리는 것은 의미가 없어
- 테스트 코드를 작성해 자동화하고 싶네

## 60p

테스트 코드를 쓰자!

## 61p

... 흠

## 62p

못 적지않나?

## 63p

**테스트 못하지요**

- 숨겨진 입력값이나 출력값
- 서로 관련된 static 메소드
- DB에 의존하고 있는 Client
- 여러 가지의 역할을 가지고, 다양한 상태를 가지는 신들
- Activity에 작성된 비즈니스 로직들

## 64p

**과제**

- 책임 분할
- Activity 개선
  - 비즈니스 로직 배제
  - IO 배제
- Static 메소드들과 신들을 은퇴시키기

## 65p

대대적인 리팩터링

## 66p

Before

## 67p

**책임 분할**

- 책임마다 레이어를 나눈다
  - Retrofit이 생성한 Interface의 구현을 통해서 Server와 교환을 하는 Client
  - Database와 교환을 하는 DAO
  - 데이터 소스를 은폐하고 데이터의 보존/취득을 하는 Repository
  - UseCase와 View를 연결하는 PResenter
- 각 레이어는 Observable을 통해서 교환한다

## 68p

After

## 69p

Retrofit이 구현하는 Interface

## 70p

Server와 데이터 송수신

## 71p

DB와 데이터 송수신

## 72p

데이터 수신/보존

## 73p

비즈니스 로직

## 74p

비즈니스 로직을 사용, Activity/Fragment 조작

## 75p ~ 76p

View의 조작, Activity 의존하는 기능 조작

## 77p

Matching

## 78p

Cient

## 79p

**Client**

- Retrofit이 생성한 Interface 구현을 이용해 통신한다
- Json 맵핑 클래스를 앱 내에서 이용하기 쉬운 데이터 클래스로 변환한다

## 80p ~ 82p

**Client**

```
class UserClient(private val service: UserService) {
    fun fetchMatchingUsers(offset: Int): Observable<List<User<< {
        return service.fetchMatchingUsers(offset)
            .map { response -> UserConverter.convert(response) }
    }
}
```

## 83p

**Client Test**

```
val userService = mock<UserService>()
val client = Userclient(userService)

userService.invoked.theReturn(...)
client.fetchMathingUsers().test().run {
    ...
}
```

## 84p

DAO

## 85p

**DAO**

- OrmaDatabase를 이용해서 Database로부터 데이터 취득을 한다
- OrmaDatabase를 이용해서 Database에 데이터를 보존한다

## 86p ~ 89p

**DAO**

```
class UserDao(private val orma: OrmaDatabase) {
    fun insert(users: List<User>) {
        orma.transactionSync {
            orma.prepareInsertIntoUser(OnConflict.REPLACE)
                .executeAll(contributors)
        }
    }
    fun findAll(): Observable<List<User>> {
        return orma.selectFromUser()
            .executeAsObservable()
            .toList()
    }
}
```

## 90p

**Dao Test**

```
val dao = UserDoa(orma)

dao.insert(...)
orma.selectFromUser()
    .executeAsObservable()
    .toList()
    .test()
    .run {
        ...
    }
orma.insertIntoUser()...
dao.findAll().test().run {
    ...
}
```

## 91p

Repository

## 92p

**Repository**

- Client와 Dao 중에서 데이터를 취득한다
- Client 경우로 API로부터 데이터 취득을 한 경우에는 Database에 데이터를 보존한다

## 93p ~ 99p

**UserRepository**

```
class UserRepository (
    private val dao: UserDao,
    private val userClient: UserClient) {

    fun getMatchingUsers(offset: Int): Observable<List<User>> {
        return userClient.fetchMatchingUsers(offset)
            .doOnNext { users -> dao.insert(users) }
            .onErrorResumeNext { dao.findAll() }
    }
}
```

## 100p

UseCase

## 101p

**UseCase**

- 비즈니스 로직을 구현한다

## 102p ~ 108p

**MatchingUsersUseCase**

```
class MatchingUsersUseCase(private val repo: UserRepository) {
    fun getUsers(offset: Int) = repo.getMatchingUsers(offset)

    fun getFacebookPublicSetting(me: Me, user: User): FacebookPublicSetting {
        return if (shouldShowMeFacebook(me, user)) {
            if (shouldShowPartnerFacebook(user)) {
                FacebookPublicSetting.BOTH
            } else {
                FacebookPublicSetting.ONLY_ME
            }
        } else {
            if (shouldShowPartnerFacebook(user)) {
                FacebookPublicSetting.ONLY_USER
            } else {
                FacebookPublicSetting.NEITHER
            } 
        }
    }
}
```

## 109p

Presenter

## 110p

**Presenter**

- UserCase를 이용해 비즈니스 로직을 구현한다
- 비즈니스 로직의 반영을 Activity/Fragment에 대해서 이루어진다
- Activity/Fragment는 Presenter를 제공하는 Contract 인터페이스를 통해서 이루어진다

## 111p ~ 118p

**Presenter**

```
class MatchingPresenter(
    private val contract: Contract,
    private val useCase: MatchingUserUseCase) {
    
    fun init() {
        useCase.getUsers().applySchedulers()
            .doOnSubscribe { contract.showProgress() }
            .doOnUnsubscribe { contract.hideProgress() }
            .subscribe(
                { users -> contract.showMatchingUsers(users) },
                { ... }
            )
    }

    interface Contract {
        fun showMatchingUsers(users List<User>)
        fun showProgress()
        fun hideProgress()
    }
    }
)
```

## 119p

Activity, Fragment

## 120p

**Activity/Fragment**

- View 조작
- Activity에 의존하는 기능 처리
- 이러한 Presenter가 가진 Contract 인터페이스를 통해 제공한다

## 121p ~ 123p

**Activity/Fragment**

```
class MatchingFragment: Fragment(), MatchingPresenter.Contract {
    ...

    override fun onViewCreated(...) {
        ...
        presenter.init()
    }

    override fun showMatchingUsers(users List<User>) {
        listView.adapter = MatchingUsersAdapter(activity, users)
    }
    override fun showProgress() {
        progress.toVisible()
    }
    override fun hideProgress() {
        progress.toGone()
    }
}
```

## 124p

Dependency Injection

## 125p

의존관계 Graph

## 126p

**DI**

- 클래스 내에서 의존하는 클래스의 인터페이스 생성을 하는 것은 안 좋다
  - 테스트 시에 바꾸는 것은 불가능하다
- 밖에서 생성하고, 생성자 혹은 멤버로서 의존성을 넣는다
- 의존성을 관리하는 클래스를 만든다
- 의존성을 관리하는 클래스 구현 / 멤버가 힘들다
- DI을 사용하자 -> Dagger2

## 127p

그래!

이런 느낌으로 하자!

## 128p

**어떻게 진행했는가**

- Pairs JP Android 팀은 당시 3명
- 2명은 이전대로 구현
- 내가 담당
  - Pairs Globla의 @yuyakaido 에게도 도움을 받았다
  - 총 1.5명으로 구현

## 129p

**어떻게 진행했는가**

- 멤버 스트림과는 별개로 refactor 브런치
- 메인 스트림과는 conflict를 피하고자 Activity/Fragment의 변경은 최소한으로 억제한다
  - Presenter를 구현하고 Activity/Fragment에 Contract 인터페이스를 구현하려니 변경이 방대해지므로 Presenter 구현은 나중에 하기로
  - Activity/Fragment는 일단 UseCase를 직접 다루는 것으로 허용

## 130p

**어떻게 진행했는가**

- 의존관계 Graph의 Root부터 변경한다
- 먼저 Dagger2의 Module/Component를 작성
- OkHttp, Retrofit, Orma의 provide 멤버를 구현

## 131p

**어떻게 진행했는가**

- 데이터 소스마다 Dao, Client, Repository를 구현
  - UserDao, UserClient, UserRepository (상대의 데이터 클래스)
  - MeDao, MeClient, MeRepository (나의 데이터 클래스)
  - ...
- 데이터 소스마다 Repository가 구현 완료할 때마다 UseCase를 구현
- Activity/Fragment에 변경을 추가한다

 ## 132p

 **힘든 점**

 - 갑자기 골을 향하지 않는다
 - 가능한 한 정상 동작하는 상태를 유지한다
 - 작은 변경을 쌓아나간다
 - 인터페이스가 변경되면 호출하는 곳의 변경도 필요하므로, 일단 우회해서 목적을 달성한다
 - 그 후에 인터페이스를 수정해서 호출하는 곳의 변경을 해나간다.

 ## 133p

 **힘든 점**

 - 새로운 설계에 관해서 팀원이 이해할 때까지 차분히 가르친다
 - 언제라도 다시 읽을 수 있도록, Qiita:team 등에 정리한다

## 134p

1.5개월 후...

## 135p

Release

## 136p

개선 후

## 137p

**이 구현의 장점**

- 테스트 코드가 현격히 쓰기 쉽게 된다
- 전체 코드 상태가 좋아진다
  - 어디에, 무엇을 적으면 되는지 알기 쉽다
  - 어디에, 무엇이 있는지 알기 쉽다
- 라이브러리의 교체가 쉽게 된다
  - e.g. ORM를 교체하고 싶으면 Dao의 변경만으로 끝난다.

## 138p

**이 구현의 단점**

- 클래스 수, 메소드 수가 많다
  - Dex Count 씨
- 구현 비용
- 학습 비용

## 139p

Conclusion

## 140p

**정리**

- Dao, Client Repository UseCase 등 책임마다 레이어를 나눈다
- Model과 View 간의 Presenter를 두어 View와 Model을 명확하게 나눈다
- Dagger2에 의존성 해결을 위임한다
- 데이터 소스마다 아래 레이어로부터 순서대로 구현해나간다
- 팀원에의 교육은 빼놓지 않는다
- 문장으로 남기고 언제라도 다시 볼 수 있게 했다