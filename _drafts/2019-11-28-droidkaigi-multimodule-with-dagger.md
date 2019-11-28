---
layout: post
title: "[번역] DroidKaigi 2019 ~ 
멀티 모듈 프로젝트에서의 Dagger를 사용해 Dependency Injection"
date: 2019-11-27 23:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2019 ~ マルチモジュールプロジェクトでの Dagger2を用いた Dependency Injection](https://speakerdeck.com/kgmyshin/android-multi-module-with-dagger) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

일부 이미지는 이해를 돕고자 한국어로 수정했습니다.

<!--more-->

- - -

번역에서 사용한 이미지는 원본은 [https://speakerdeck.com/kgmyshin/android-multi-module-with-dagger](https://speakerdeck.com/kgmyshin/android-multi-module-with-dagger) 에 있습니다.

- - -

## 1p

### Goal 

Multi Module로 구성된 프로젝트에서 Dagger2를 사용해 Dependency Injection을 할 때의 고민 포인트를 알아보고 그 해결책을 이해한다.

### Agenda

- Dependency Injection이란 (간단하게)
- Dagger2 재입문
- Dagger2 Android 사이드 재입문
- 단일 모듈에서 Dagger2를 사용해 Dependency Injection
- 멀티 모듈에서 Dependency Injection의 어려움
- Dagger2를 사용해 멀티 모듈 프로젝트로 DI 구현하기
- Dynamic Feature Module이 있을 때의 이야기 (시간이 있다면)

## 2p

멀티 모듈 프로젝트에서의 Dagger를 사용해 Dependency Injection

@kgmyshin 
DroidKaigi 2019 

## 3p, 자기 소개

- kgmyshin / 釘宮(kugimiya)
- Android 개발자
- 함동회사 DMM.com CTO실 직속

## 4p

이 세션의 목적지

## 5p, 이 세션의 목적지

멀티 모듈로 구성된 프로젝트에서 Dagger2를 사용해 Dependency Injection을 할 때의 고민 포인트를 알아보고 그 해결책을 이해한다.

## 6p

agenda

## 7p, agenda

- Dependency Injection이란 (간단하게)
- Dagger2 재입문
- Dagger2 Android 사이드 재입문
- 단일 모듈에서 Dagger2를 사용해 Dependency Injection
- 멀티 모듈에서 Dependency Injection의 어려움
- Dagger2를 사용해 멀티 모듈 프로젝트로 DI 구현하기
- Dynamic Feature Module이 있을 때의 이야기

## 8p, 발표하기 전에

혹시 세션을 듣는 도중에 모르는 부분이 있다면, 꼭 DMM.com 부스로 와주세요!

## 9p

Dependency Injection이란

## 10p, Dependency Injection이란 (간단하게)

한마디로, "의존 객체"를 "주입"하는 디자인 패턴입니다

## 11p ~ 13p, Dependency Injection이란 (간단하게)

```kotlin
internal class AllergenRepositoryImpl : AllergenRepository {
  private val apiClient = ApiClient()
  
  override fun findAll(
  ): Single<List<Allergen>> =
  	apiClient.getAllergens()

  override fun findById(
    allergenId: AllergenId
  ): Maybe<Allergen> =
  	apiClient.getAllergen(allergenId.value)
}
```

> DI가 없다

```kotlin
internal class AllergenRepositoryImpl @Inject constructor(
  private val apiClient: ApiClient
) : AllergenRepository {

  override fun findAll(
  ): Single<List<Allergen>> =
  	apiClient.getAllergens()

  override fun findById(
    allergenId: AllergenId
  ): Maybe<Allergen> =
  	apiClient.getAllergen(allergenId.value)
}
```

> DI 적용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/001.jpg" }}" />

## 14p, Dependency Injection이란 (간단하게)

장점

- 결합이 느슨하게 된다.
- 단위 테스트를 하기 쉬워진다
- 특정 라이브러리나 프레임워크의 의존도를 낮출 수 있다

## 15p, 특정 라이브러리나 프레임워크의 의존도를 낮출 수 있다

- Volley or Retrofit or Ktor Client 
- Picasso or Glide 

이외의 의존도를 구상 항목에 가두는 것으로 손쉽게 라이브러리를 교체할 수 있다

## 16p, 더 제대로 알고 싶으면

Day2 14:50~ 지금부터 시작하는 의존성 주입 by kobakei-san

## 17p

Dagger2 재입문

## 18p ~ 22p, 앱에서 DI를 하기 위해서는?

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/002.jpg" }}" />

## 23p, 앱에서 DI를 하기 위해서는?

앱에서 DI를 하기 위해서는?

어디에 무엇을

Inject할지를 망라할 필요가 있다

## 24p ~ 26p, Dagger에서는

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/003.jpg" }}" />

## 27p ~ 28p, Dagger2에서 Dependency Injection 적용

Dagger2를 사용한 구현의 흐름

1. `Module을 준비`
2. Component를 준비
3. Application#onCreate로 Component를 초기화 
4. 각 위치에서 inject

※ 3에서는 상황에 따라서는 여기서는 간략화를 위해서 이 위치에 고정한다
※ 이후의 예에서는 Fragment에 Inject를 대상으로 하지만 다른 클래스로 교체에도 문제없다

## 29p, ① Module을 준비

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/004.jpg" }}" />

## 30p ~ 34p, ① Module을 준비

Module의 작성법 사례 : 타입과 인스턴스를 연결한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/005.jpg" }}" />

## 35p ~ 36p, Dagger2로 Dependency Injection 하기

Dagger2를 사용한 구현의 흐름

1. Module을 준비
2. `Component를 준비`
3. Application#onCreate로 Component를 초기화 
4. 각 위치에서 inject

※ 3에서는 상황에 따라서는 여기서는 간략화를 위해서 이 위치에 고정한다
※ 이후의 예에서는 Fragment에 Inject를 대상으로 하지만 다른 클래스로 교체에도 문제없다

## 37p ~ 39p, ② Component를 준비

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/003.jpg" }}" />

Component에는 "무엇을 제공할까" 이외를 적는다

=> "어디에 제공할 것인가"를 주로 적는다

## 40p ~ 43p, ② Component를 준비

Component 작성법의 예 : inject 하는 곳을 파라미터로 하는 함수를 정의

```kotlin
@Singleton
@Component(modules = [GreetingModule::class]) 
interface GreetingComponent {
  fun inject(activity: GreetingActivity) // GreetingActivity에 inject
  fun inject(fragment: GreetingFragment) // GreetingFragment에 inject
  fun greeter(): Greeter // 어디든지!
}
```

## 44p ~ 45p, Dagger2로 Dependency Injection 하기

Dagger2를 사용한 구현의 흐름

1. Module을 준비
2. Component를 준비
3. `Application#onCreate로 Component를 초기화` 
4. 각 위치에서 inject

※ 3에서는 상황에 따라서는 여기서는 간략화를 위해서 이 위치에 고정한다
※ 이후의 예에서는 Fragment에 Inject를 대상으로 하지만 다른 클래스로 교체에도 문제없다

## 46p ~ 47p, ③ Application#onCreate로 Component를 초기화

```kotlin
class Application : android.app.Application() {
  lateinit var appComponent: AppComponent
  
  override fun onCreate() {
    super.onCreate()
    appComponent = DaggerAppComponent.create() // 초기화
	}
}
```

## 48p ~ 49p, Dagger2로 Dependency Injection 하기

Dagger2를 사용한 구현의 흐름

1. Module을 준비
2. Component를 준비
3. Application#onCreate로 Component를 초기화
4. `각 위치에서 inject`

※ 3에서는 상황에 따라서는 여기서는 간략화를 위해서 이 위치에 고정한다
※ 이후의 예에서는 Fragment에 Inject를 대상으로 하지만 다른 클래스로 교체에도 문제없다

## 50p ~ 52p, ④ 각 위치에서 inject

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/006.png" }}" />

## 53p, Dagger2로 Dependency Injection 하기

Dagger2를 사용한 구현의 흐름

1. Module을 준비
2. Component를 준비
3. Application#onCreate로 Component를 초기화
4. `각 위치에서 inject`

※ 3에서는 상황에 따라서는 여기서는 간략화를 위해서 이 위치에 고정한다
※ 이후의 예에서는 Fragment에 Inject를 대상으로 하지만 다른 클래스로 교체에도 문제없다

## 54p

Dagger-Android 재입문

## 55p ~ 57p, Dagger-Android 모티베이션

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/007.png" }}" />

## 58p, Dagger-Android 모티베이션

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/008.png" }}" />

## 59p, dagger.android로 Dependency Injection

Dagger2를 사용한 구현의 흐름

1. Module을 준비
2. Component를 준비
3. Application#onCreate로 Component를 초기화
4. 각 위치에서 inject

## 60p ~ 62p, dagger.android로 Dependency Injection

`dagger.android` 사용한 구현의 흐름

1. `Module을 준비`
2. FragmentModule을 준비 (New)
3. Component를 준비 (Updated)
4. Application#onCreate로 Component를 초기화 (Updated)
5. 각 위치에서 inject (Updated)

## 63p, ① Module을 준비

```kotlin
@Module
abstract class AppModule {
  @Binds
  abstract fun messageProvider(impl: MessageProviderImpl): MessageProvider 
}
```

## 64p ~ 65p, dagger.android로 Dependency Injection

dagger.android 사용한 구현의 흐름

1. Module을 준비
2. `FragmentModule을 준비`
3. Component를 준비
4. Application#onCreate로 Component를 초기화
5. 각 위치에서 inject

## 66p ~ 68p, ② FragmentModule을 준비

```kotlin
@Module
abstract class MainFragmentModule {
  @ContributesAndroidInjector
  abstract fun mainFragment(): MainFragment 
}
```

## 69p ~ 70p, dagger.android로 Dependency Injection

dagger.android 사용한 구현의 흐름

1. Module을 준비
2. FragmentModule을 준비
3. `Component를 준비`
4. Application#onCreate로 Component를 초기화
5. 각 위치에서 inject

## 71p ~ 75p, ③ Component를 준비

```kotlin
@Singleton
@Component(
  modules = [ 
    AndroidInjectionModule::class, // 추가
    AppModule::class, 
    MainFragmentModule::class // 추가
  ]
)
interface AppComponent : AndroidInjector<Application>
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/009.png" }}" />

## 76p ~ 77p, dagger.android로 Dependency Injection

dagger.android 사용한 구현의 흐름

1. Module을 준비
2. FragmentModule을 준비
3. Component를 준비
4. `Application#onCreate로 Component를 초기화`
5. 각 위치에서 inject

## 78p ~ 79p, ④ Application#onCreate로 Component를 초기화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/010.png" }}" />

## 80p ~ 81p, dagger.android로 Dependency Injection

dagger.android 사용한 구현의 흐름

1. Module을 준비
2. FragmentModule을 준비
3. Component를 준비
4. Application#onCreate로 Component를 초기화
5. `각 위치에서 inject`

## 82p ~ 83p, ⑤ 각 위치에서 inject

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/011.png" }}" />

## 84p, dagger.android로 Dependency Injection

dagger.android 사용한 구현의 흐름

1. Module을 준비
2. FragmentModule을 준비
3. Component를 준비
4. Application#onCreate로 Component를 초기화
5. `각 위치에서 inject`

## 85p ~ 86p, 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/012.png" }}" />

## 87p ~ 88p, 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/013.png" }}" />

## 89p, 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/014.png" }}" />

## 90p ~ 97p, 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/015.png" }}" />

MainFragment에서 Inject 요청 시 먼저 부모 Activity에서 HasSupportFragmentInjector를 구현했는지 확인한 후, Application으로 이동해서 확인한다. 실제 Injector 구현체에 도달하는 흐름이다.

## 98p

멀티 모듈에서 Dependency Injection의 어려움

## 99p ~ 100p, 멀티 모듈에서 DI

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/016.jpg" }}" />

## 101p ~ 102p, dagger.android로 Dependency Injection

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Component를 준비
4. `Application#onCreate로 Component를 초기화`
5. 각 위치에서 inject

## 103p ~ 104p, ④ Application#onCreate로 Component를 초기화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/017.png" }}" />

각각의 Component Inject가 호출한다

## 105p ~ 106p, dagger.android로 Dependency Injection

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Component를 준비
4. Application#onCreate로 Component를 초기화
5. `각 위치에서 inject`

## 107p ~ 108p, ⑤ 각 위치에서 inject

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/018.png" }}" />

## 109p ~ 110p, 어떻게 될까?

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/019.jpg" }}" />

## 111p ~ 112p, Component 초기화 순서를 바꿔보면?

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/020.png" }}" />

## 113p, 어떻게 될까?

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/021.jpg" }}" />

## 114p ~ 116p, Crash 나는 이유

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/022.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/023.png" }}" />

## 117p ~ 118p, 구조

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/024.png" }}" />

## 119p

Dagger2를 사용해 멀티 모듈 프로젝트로 DI 구현하기

## 120p ~ 122p, 다시 한번 집어보면, 문제는?

### 문제

Application에 Fragment용 Injector를 하나밖에 둘 수 없으므로, Injector가 덮어쓰게된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/025.png" }}" />

## 123p, 해결책의 하나

Application에서 가지는 하나의 FragmentInjector가 복수의 Injector를 가지도록 한다

## 124p ~ 127p, 나의 Injector가 복수의 Injector를 가지도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/026.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/027.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/028.png" }}" />

![029](/Users/pluulove/StudioProjects/pluu.github.io/assets/img/blog/2019/1123-droidkaigi-dependency-injection/029.png) 

## 128p ~ 133p, ModuleInjector 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/031.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/032.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/033.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/034.png" }}" />

## 134p ~ 136p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. `Module을 준비`
2. FragmentModule을 준비
3. Injector를 준비 (New)
4. Component를 준비 (Updated)
5. Application#onCreate로 Component를 초기화 (Updated)
6. 각 위치에서 inject

## 137p, ① Module을 준비

```kotlin
@Module
internal abstract class CounterModule {
  @Singleton
  @Binds
  abstract fun provideCounter(impl: CounterImpl): Counter
}

@Module
internal abstract class GreetingModule {
  @Binds
  abstract fun provideGreeter(impl: GreeterImpl): Greeter
}
```

## 138p ~ 139p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. `FragmentModule을 준비`
3. Injector를 준비
4. Component를 준비
5. Application#onCreate로 Component를 초기화
6. 각 위치에서 inject

## 140p, ② FragmentModule을 준비

```kotlin
@Module
internal abstract class GreetingFragmentModule {
  @ContributesAndroidInjector
  abstract fun greetingFragment(): GreetingFragment
}

@Module
internal abstract class CounterFragmentModule {
  @ContributesAndroidInjector
  abstract fun counterFragment(): CounterFragment 
}
```

## 141p ~ 142p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. `Injector를 준비`
4. Component를 준비
5. Application#onCreate로 Component를 초기화
6. 각 위치에서 inject

## 143p, ③ Injector를 준비

```kotlin
class CounterInjector : HasDispatchingInjector<Fragment> {
  @Inject
  lateinit var supportFragmentInjector: DispatchingAndroidInjector<Fragment> 
  override fun dispatchingAndroidInjector(): DispatchingAndroidInjector<Fragment> =
  		supportFragmentInjector
}

class GreetingInjector : HasDispatchingInjector<Fragment> { 
  @Inject
  lateinit var supportFragmentInjector: DispatchingAndroidInjector<Fragment> 
  override fun dispatchingAndroidInjector(): DispatchingAndroidInjector<Fragment> =
  		supportFragmentInjector
}
```

## 144p ~ 145p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Injector를 준비
4. `Component를 준비`
5. Application#onCreate로 Component를 초기화
6. 각 위치에서 inject

## 146p, ④ Component를 준비

```kotlin
@Singleton 
@Component(
  modules = [ 
    AndroidInjectionModule::class,
    CounterModule::class,
    CounterFragmentModule::class])
interface CounterComponent : AndroidInjector<CounterInjector>

@Singleton 
@Component(
  modules = [ 
    AndroidInjectionModule::class,
    GreetingModule::class,
    GreetingFragmentModule::class])
interface GreetingComponent : AndroidInjector<GreetingInjector>
```

## 147p ~ 148p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Injector를 준비
4. Component를 준비
5. `Application#onCreate로 Component를 초기화`
6. 각 위치에서 inject

## 149p ~ 153p, ⑤ Application#onCreate로 Component를 초기화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/035.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/036.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/037.png" }}" />

## 154p ~ 155p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Injector를 준비
4. Component를 준비
5. Application#onCreate로 Component를 초기화
6. `각 위치에서 inject`

## 156p, ⑥ 각 위치에서 inject

```kotlin
class CounterFragment : Fragment() { 
  @Inject
  lateinit var counter: Counter

  override fun onAttach(context: Context?) {
    AndroidSupportInjection.inject(this)
    super.onAttach(context)
  }
  ...
}
```

```kotlin
class GreetingFragment : Fragment() { 
  @Inject
  lateinit var greeter: Greeter

  override fun onAttach(context: Context?) {
    AndroidSupportInjection.inject(this)
    super.onAttach(context)
  }
  ...
}
```

## 157p ~ 166p, 흐름

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/038.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/039.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/040.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/041.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/042.png" }}" />

## 167p

Dynamic Feature Module

## 168p ~ 170p, Dynamic Feature Module이 있는 경우의 DI

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/043.jpg" }}" />

## 171p ~ 172p, dagger.android로 Dependency Injection (multi module)

지금까지와 같은 순서로 dagger.android를 사용해 구현해본다

1. Module을 준비
2. FragmentModule을 준비
3. Injector를 준비
4. Component를 준비
5. `Application#onCreate로 Component를 초기화` ← X 불가능
6. 각 위치에서 inject

## 173p ~ 174p, ⑤ Application#onCreate로 Component를 초기화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/044.png" }}" />

## 175p ~ 176p, 해결책 중 하나

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/045.png" }}" />

## 177p ~ 182p, 예를들면, 이런 함수를 만든다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/046.png" }}" />

1. Application내에 원하는 모듈이 있는지 찾는다
2. 만약 없으면. 원하는 Injector를 만들고 application에 추가한다
3. AndroidSupportInjection#inject을 호출한다

Activity에 moduleInjector가 있는 경우를 고려해서 AndroidSupportInjection과 같은 구현을 할 수도 있다

※ ActivityInjector를 가질 때에는 이 방법은 잘 안되므로 조건 분기할 필요가 있다!

### 183p ~ 184p, 이렇게 하면 inject되는 곳은 이 변경만으로 지금처럼 움직인다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/1123-droidkaigi-dependency-injection/047.jpg" }}" />

## 185p ~ 186p, 언급한 것을 되짚어보기

- Dependency Injection이란
- Dagger2 사용 방법 사례, 순서, 구조
- Dagger Android Support의 사용 방법 사례, 순서, 구조
- 위 내용대로는 멀티 모듈 대응이 안되는 케이스가 있다
- ModuleInjector를 도입하는 것으로 대응 가능
- Dynamic Feature Module일 때는 적절한 타이밍에 Injector를 ModuleInjector에 꽂아 넣는 것을 필요가 있다

## 187p

들어주셔서 감사합니다.