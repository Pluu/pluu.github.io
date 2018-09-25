---
layout: post
title: "[번역] DroidKaigi 2018 ~ Dagger2를 활용해 Android SDK 의존관계를 깨끗하게"
date: 2018-09-25 18:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ Dagger2を活用してAndroid SDKの依存関係をクリーンにする](hhttps://speakerdeck.com/kr9ly/dagger2wohuo-yong-siteandroid-sdkfalseyi-cun-guan-xi-wokurinnisuru) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Dagger2를 활용해 Android SDK 의존관계를 깨끗하게

DroidKaigi 2018 Day2 14:00~ Room1

からくり(@kr9ly)

## 2p, 자기 소개

- twitter : からくり(@kr9ly)
- Ice Cream Sandwitch(4.0) 부터 Androider 입니다
- dely라는 五反田 (고탄다) 의 회사에서 근무하고 있습니다
- クラシル(kurashiru) 앱을 만들고 있습니다

## 3p

DI 사용하고 있습니까?

## 4p ~ 5p, Android DI 라이브러리

- RoboGuide (deprecated)
- Dagger (deprecated)
- `Dagger2`
- Kodein
- 기타

## 6p, DI를 사용하는 목적

- 느슨한 결합
- 의존관계 정리
- Testability 향상
- 인스턴스를 런타임 관리
- 기타

## 7p

그런데 Android 앱의 경우

## 8p, Android SDK 의존이 가득

- Context 의존
- SDK 유래의 기능 (화면이동, SystemService, GPS 등)
- FragmentManager
- Actiivty/Fragment Callback (Lifecycle Event 등)

## 9p, DI Container 밖의 세계에 의존하기 쉽다

- Activity/Fragment에 직접 Injection
- 모든 기능이 들어있는 God Activity/Fragment
- Architecture (MVP, MVVM ...) 를 관철할 수 없다 (이 부분의 코드는 어느 Architecture?)
- Robolectric이 없으면 제대로 테스트할 수 없거나
- 결국 지금까지와 다른건 없지 않은가?

## 10p

DI (잘) 사용하고 있습니까?

## 11p, Dagger2 활용 Better Practice 모음

목적

- 로직 부분으로부터 Context와의 의존을 완전히 배제한다
- 코드 대부분을 DI Container 내에서 해결한다
- Robolectric 없이 Presenter, ViewModel 등을 테스트한다
  ※ 테스트에 대해서는 오늘은 이야기하지 않습니다

샘플 레포지토리는 이쪽

[https://github.com/kr9ly/dagger2-sampleapp](https://github.com/kr9ly/dagger2-sampleapp)

## 12p, 주의

- ViewModel은 MVVM의 ViewModel입니다 (Android Architecture Components 이야기는 아니다)
- 가능한 여러 방법의 장점/단점을 소개합니다만
- 어디까지나 하나의 샘플입니다
- 개인적인 취향이 반영된 부분이 많습니다

## 13p ~ 14p, 목차

- `@Scope를 활용`
- Context 의존을 분리
- 화면 이동을 정리
- Activity/Fragment의 Callback Event 정리

## 15p, @Scope를 활용

```
@Scope
@Retention(RetentionPolicy.RUNTIME)
public @interface ViewScope {
}
```

대표적인 것은 @Singleton

## 16p, @Scope를 활용하면

- @Singleton 이외의 Scope 관리가 가능
- Activity/Fragment 마다 고유한 인스턴스를 Provide 가능
- Activity/Fragment 마다 고유한 인스턴스가 관리시 좋은 사례
  - Rx의 dispose 처리
  - 화면 이동
  - FragmentManager 제어
  - Activity/Fragment Callback 메소드 호출

## 17p, @Scope를 사용해 Annotation을 정의

```java
@Scope
@Retention(RetentionPolicy.RUNTIME)
public @interface ViewScope {
}
```

## 18p, Component 정의 사례

```java
@ViewScope
@Subcomponent(module = {FragmentManagerDelegatedModule.class})
public interface ViewScopeComponent {
    ListViewModel listViewModel();
    DetailViewModel detailViewModel();
}
```

스스로 만든 Scope용 Component를 정의한다 (여기부터 참조되는 Module의 @Provides에 스스로 만든 Scope Annotation을 부여한다)

## 19p, Component 정의 사례

```java
@ViewScope
@Component
public interface ApplicationComponent {
    ViewScopeComponent viewScopeComponent(
        FragmentManagerDelegateModule fragmentManagerModule
    );
} 
```

Singleton -> 스스로 만든 Scope Component 생성은 Subcomponent가 편리

## 20p, Subcomponent를 만드는 방법 사례

```java
public class ApplicationComponentManager {
    private static final WeakHashMap<Context, ApplicationComponent> components = new WeakHashMap<>();
    public static synchronized ApplicationComponent get(Context context) {
        Context appContext = context.getApplicationContext();
        ApplicationComponent component = components.get(appContext);
        if (component != null) {
            return component;
        }
        component = DaggerApplicationComponent.builder()
            .resourceProviderModule(new ResourceProviderModule(appContext))
            .build();
        components.put(context, component);
        return component;
    }
}
```

## 21p, Subcomponent를 만드는 방법 사례

```java
public abstract class DaggerBaseActivity extends AppCompatActivity {
@Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ViewScopeComponent viewScopeComponent = ApplicationComponentManager
            .get(this)
            .viewScopeComponent(
            	new FragmentManagerDelegatedModule(
                	new FragmentManagerActivityDelegate(this)
                )
            );
        onComponentPrepared(viewScopeComponent, savedInstanceState);
    }
    protected abstract void onComponentPrepared(ViewScopeComponent component,
        @Nullable Bundle savedInstanceState);
}
```

## 22p, Subcomponent 여러가지 분리 방법

- Activity/Fragment는 별도 Componenet
- Activity/Fragment에서 동일 Componenet
- ...

## 23p, Activity/Fragment는 별도 Componenet

장점

- 의존 Module을 각각 별도로 가능

단점

- Component를 2가지 정의할 필요가 있어서 귀찮다

## 24p, Activity/Fragment에서 동일 Componenet

장점

- Component 정의가 하나로 끝

단점

- 의존 Module을 교체하기 어렵다

## 25P, Componenet 나누는 것은 어떻게?

- 의존 대상 클래스는 Activity와 Fragment로 그다지 바뀌지 않는다
- 개인적으로는 Componenet 정의가 하나로 끝나는 것이 좋을 것 같다
- 단, Componenet 정의를 하나로 끝나는 경우는 의존대상의 Module 내에서 처리를 나눌 필요가 있다

## 26p, Module 내에서 처리를 나누는 방법

```java
@Module
public class FragmentManagerModule {
    @ViewScope
    @Provides
    FragmentManager provideFragmentManager() {
        // Activity도 Fragment도 이 메소드가 호출된다
        return null;
    }
}
```

우선 Module을 정의한다

## 27p, Module 내에서 처리를 나누는 방법

- Delegate Pattern을 적용
- instanceof로 분기

## 28p, Delegate Pattern을 적용

```java
@Module
public class FragmentManagerDelegatedModule {
    private final FragmentManagerDelegate delegate;
    public FragmentManagerDelegatedModule(FragmentManagerDelegate delegate) {
        this.delegate = delegate;
    }
    @ViewScope
    @Provides
    FragmentManager provideFragmentManager() {
        // Delegate interface를 호출
        return delegate.provide();
    }
}
```

## 29p, Delegate용 interface

```java
public interface FragmentManagerDelegate {
    FragmentManager provide();
}
```

단순하게 Provide 대상 인스턴스를 반환할 뿐

여기부터 Activity용과 Fragment용으로 구현을 나눈다

## 30p, Activity용 interface 정의

```java
public class FragmentManagerActivityDelegate implements FragmentManagerDelegate {
    private final FragmentActivity fragmentActivity;
    public FragmentManagerActivityDelegate(FragmentActivity fragmentActivity) {
        this.fragmentActivity = fragmentActivity;
    }
@Override
    public FragmentManager provide() {
        return fragmentActivity.getSupportFragmentManager();
    }
}
```

Activity의 참조를 가진다

## 31p, Fragment용 interface 정의

```java
public class FragmentManagerFragmentDelegate implements FragmentManagerDelegate {
    private final Fragment fragment;
    public FragmentManagerFragmentDelegate(Fragment fragment) {
        this.fragment = fragment;
    }
	@Override
	public FragmentManager provide() {
        // 무심코 부모 FragmentManager를 참조하지 않도록
        return fragment.getChildFragmentManager();
    }
}
```

Fragment의 참조를 가진다

## 32p, instanceof로 분기하는 방법

```java
public class FragmentManagerDynamicModule {
    private final Object scopeObject;
    public FragmentManagerDynamicModule(Object scopeObject) {
        this.scopeObject = scopeObject;
    }
    @ViewScope
    @Provides
    FragmentManager provideFragmentManager() {
        if (scopeObject instanceof FragmentActivity) {
            return ((FragmentActivity) scopeObject).getSupportFragmentManager();
        } else if (scopeObject instanceof Fragment) {
            return ((Fragment) scopeObject).getChildFragmentManager();
        }
        throw new IllegalStateException();
    }
}
```

무엇이 오더라도 가능하도록 동적으로 나눈다

## 33p, 어느 쪽이라도 목적은 달성은 할 수 있다

- 정적으로 해결 or 동적으로 해결
- 개인적으로는 Delegate Pattern으로 정의하는 편이 안심 (코드량은 늘어난다)

## 34p, 목차

- @Scope를 활용
- `Context 의존을 분리`
- 화면 이동을 정리
- Activity/Fragment의 Callback Event 정리

## 35p, Context에 의존하는 경향

- Android는 뭐든 Context에 있다
- 자신도 모르게 Context를 Field에
- 자신도 모르게 Context를 매개변수로
- Context에 밀접한 결합
- 분리합시다

## 36p, 2가지 방법

- Module의 생성자에 Context의 참조를 넘기는 패턴
- Context 자체를 Provide하는 패턴

## 37p, 코드 사례

```java
public class ResourceProvider {
    private final Context context;
    public ResourceProvider(Context context) {
        this.context = context;
    }
    public String getString(@StringRes int resId) {
        return context.getString(resId);
    }
    public String getString(@StringRes int resId, Object... formatArgs) {
        return context.getString(resId, formatArgs);
    }
}
```

예를 들면 string 등의 Resource에 접근하는 클래스

## 38p, Module 생성자에 Context 참조를 전달하는 패턴

```java
@Module
public class ResourceProviderModule {
    private final Context appContext;
    public ResourceProviderModule(Context appContext) {
        this.appContext = appContext;
    }
    @Singleton
    @Provides
    public ResourceProvider provideResourceProvider() {
        return new ResourceProvider(appContext);
    }
}
```

## 39p, Module 생성자에 Context 참조를 전달하는 패턴

장점

- Context에 직접 의존할 필요 없는 레이어에서의 Context 의존을 피할 수 있다 (Context 인스턴스 자체를 숨길 수 있다)

단점

- Context 의존이 발생할 때마다 Module을 정의할 필요가 있고 약간 불편

## 40p, Context 자체를 Provide하는 패턴

```java
@Module
public class AppContextModule {
    private final Context appContext;
    public AppContextModule(Context appContext) {
        this.appContext = appContext;
    }
    @Singleton
    @Provides
    public Context provide() {
        return appContext;
    }
}
```

이런 Module을 정의해둔다

## 41p, Context 자체를 Provide하는 패턴

```java
@Singleton
public class ResourceProvider {
    private final Context context;
@Inject
    public ResourceProvider(Context context) {
        this.context = context;
    }
    public String getString(@StringRes int resId) {
        return context.getString(resId);
    }
    public String getString(@StringRes int resId, Object... formatArgs) {
        return context.getString(resId, formatArgs);
    }
}
```

생성자에 @Inject, 클래스 정의에 @Singleton

## 42p, Context 자체를 Provide하는 패턴

장점

- 의존 관계가 간단하면 생성자 Injection만으로 의존 관계를 정의할 수 있다

단점

- Context에 직접 의존할 필요  없는 레이어에도 Context 의존이 작성되어버린다 (Context 인스턴스 자체를 숨기지 못하고 있다)

## 43p

장단점이 있으니 프로덕션에 맞는 방법을 선택합시다

## 44p, 목차

- @Scope를 활용
- Context 의존을 분리 
- `화면 이동을 정리`
- Activity/Fragment의 Callback Event 정리

## 45p, Android 화면 이동

- Intent
- Intent 생성에 Context 가 필요
- Activity#startActivity, Fragment#startActivity 와 위치에 따라 호출할 메소드가 다르다 (특히 startActivityForResult)

## 46p, 화면 이동용 interface를 정의

```java
public interface TransitionHandler {
    void startActivity(IntentBuilder intentBuilder);
}
```

Intent에 대해서도 생성용 interface를 정의

```java
public interface IntentBuilder {
    Intent build(Context context);
}
```

## 47p, Activity용 구현 정의

```java
public class ActivityTransitionHandler implements TransitionHandler {
    private final FragmentActivity activity;
    public ActivityTransitionHandler(FragmentActivity activity) {
        this.activity = activity;
    }
	@Override
    public void startActivity(IntentBuilder intentBuilder) {
        activity.startActivity(intentBuilder.build(activity));
    }
}
```

## 48p, Fragment용 구현 정의

```java
public class FragmentTransitionHandler implements TransitionHandler {
    private final Fragment fragment;
    public FragmentTransitionHandler(Fragment fragment) {
        this.fragment = fragment;
    }
	@Override
    public void startActivity(IntentBuilder intentBuilder) {
        fragment.startActivity(intentBuilder.build(fragment.getContext()));
    }
}
```

Delegate Pattern 사용하면 간단하게 Module내에서 분리할 수 있습니다

## 49p, Intent 생성에 Context가 필요한 문제를 해결

```java
public interface IntentBuilder {
    Intent build(Context context);
}
```

- Intent 생성을 interface로 표현, 매개변수로 Context 의존을 기술
- Builder 패턴은 의존은 의존할 필요없는 레이어에서의 참조 (이 경우는 ViewModel부터 Context) 를 분리하는데 사용된다

## 50p, Intent 생성에 Context가 필요한 문제를 해결

```java
public class SimpleIntentBuilder implements IntentBuilder {
    private final Class<? extends Activity> targetActivityClass;
    public SimpleIntentBuilder(Class<? extends Activity> targetActivityClass) {
        this.targetActivityClass = targetActivityClass;
    }
	@Override
    public Intent build(Context context) {
        return new Intent(context, targetActivityClass);
    }
}
```

Context가 필요한 패턴도 Intent 생성하는 측은 Context에 의존하지 않을 수 있다

## 51p, Intent에 파라매터를 설정하고 싶은 경우

- Intent#putExtra(String key, String value)
- Intent#putExtra(String key, int value)
- Intent#putExtra(String key, float value)

타입마다 호출할 메소드가 다르고, 괜찮은 느낌으로 파라매터를 가지고 다니기 어려운 경우의 대응 방법 (Bundle 도 같아요)

## 52p, 타입마다 entry를 추상화

```java
public interface ExtraEntry {
    void setExtra(Intent intent);
}
```

예를들면 이런 interface를 정의

## 53p, 타입마다 entry를 추상화

```java
public class StringExtraEntry implements ExtraEntry {
    private final String key;
    private final String value;
    public StringExtraEntry(String key, String value) {
        this.key = key;
        this.value = value;
    }
	@Override
    public void setExtra(Intent intent) {
        intent.putExtra(key, value);
    }
}
```

- 타입마다 각각 구현

## 54p, 사용하는 쪽은 이렇게

```java
public class SimpleIntentBuilder implements IntentBuilder {
    private final List<ExtraEntry> extras = new ArrayList<>();
    private final Class<? extends Activity> targetActivityClass;
    public SimpleIntentBuilder(Class<? extends Activity> targetActivityClass) {
        this.targetActivityClass = targetActivityClass;
    }
    public void putExtra(String key, String value) {
        extras.add(new StringExtraEntry(key, value));
    }
	@Override
    public Intent build(Context context) {
        Intent intent = new Intent(context, targetActivityClass);
        for (ExtraEntry extra : extras) {
            extra.setExtra(intent);
        }
        return intent;
    }
}
```

- Fragment의 Arguments용 Bundle도 비슷하게

## 55p, 목차

- @Scope를 활용
- Context 의존을 분리 
- 화면 이동을 정리
- `Activity/Fragment의 Callback Event 정리`

## 56p, Activity/Fragment Callback Event의 처리를 DI Container 내에서 하고 싶을 때

Activity/Fragment에서 DI Container 내부의 세계에 접근할 필요가 자주 나온다

```java
@Override
public void onStart() {
	// DI Container 밖의 세계에 의존하고 있다
    viewModel.onStart();
}
```

결과 로직이 밖으로 새어나가는 경향 (이 정도로 끝나면 좋지만)

## 57p, Activity/Fragment Callback Event를 정리하는 방법 2가지

- AAC (Android Architecture Components) Lifecycle을 사용
- 스스로 만든 Callback 을 정의

## 58p, AAC Lifeclye을 사용

```java
@Module
public class AacLifecycleModule {
    // FragmentActivity/Fragment
    private final LifecycleOwner lifecycleOwner;
    public AacLifecycleModule(LifecycleOwner lifecycleOwner) {
        this.lifecycleOwner = lifecycleOwner;
    }
    @ViewScope
    @Provides
    Lifecycle provideAacLifecycle() {
        return lifecycleOwner.getLifecycle();
    }
}
```

Lifecycle을 Provide하는 Module을 정의한다

## 59p, AAC Lifeclye을 사용

```java
public class ListViewModel implements LifecycleObserver {
	@Inject
    public ListViewModel(Lifecycle lifecycle ){
        lifecycle.addObserver(this);
    }
    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    public void onStart() {
        // do something
	} 
}
```

사용쪽은 이런 형태

자세하게는 
[https://developer.android.com/topic/libraries/architecture/lifecycle.html](https://developer.android.com/topic/libraries/architecture/lifecycle.html)

## 60p, AAC Lifeclye을 사용

장점

- 표준으로 안심
- 사용은 간단

단점

- 그다지 전부 다 되는 것은 아니다 (생명주기 관련만)
- 이벤트를 추가할 수 없다

## 61p, 스스로 만든 Callback을 정의

- Callback용 기저 interface를 정의
- Callback interface 정의
- 스스로 만든 Callback 호출하는 코드를 추가

## 62p, Callback interface 정의

```java
public interface LifecycleCallback {
	// 기저 interface를 준비해두는 것으로 등록 메소드에 아무거나 넣지않도록 한다
}
```

```java
public interface OnStartCallback extends LifecycleCallback {
    void onStart();
}
```

## 63p, Callback 관리 Class를 만든다

```java
@ViewScope
public class LifecycleCallbackController {
    private final List<OnStartCallback> onStartCallbackList = new ArrayList<>();
    ...
@Inject
    public LifecycleCallbackController() {
    }
    public void register(LifecycleCallback callback) {
        if (callback instanceof OnStartCallback) {
            onStartCallbackList.add((OnStartCallback) callback);
        }
... }
    public void onStart() {
        for (OnStartCallback onStartCallback : onStartCallbackList) {
            onStartCallback.onStart();
        }
}
```

## 64p, Callback 관리 Class를 Activity/Fragment Component로부터 생성

```java
@ViewScope
@Subcomponent(
	modules = {
			FragmentManagerDelegatedModule.class,
			AacLifecycleModule.class
	}
)
public interface LifecycleComponent {
	LifecycleCallbackController lifecycleCallbackController();
}
```

## 65p, Activity/Fragment로부터 Callback 호출

```java
public abstract class DaggerBaseActivity extends AppCompatActivity {
    private LifecycleCallbackController lifecycleCallbackController;
	@Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		// lifecycleComponent를 초기화
        lifecycleCallbackController = lifecycleComponent.lifecycleCallbackController();
    }

    @Override
	protected void onStart() {
    	super.onStart();
		// Callback 호출
    	lifecycleCallbackController.onStart();
	}
```

## 66p, 스스로 만든 Callback Class 사용 방법

```java
public class DetailViewModel implements OnStartCallback {
@Inject
    public DetailViewModel(
            LifecycleCallbackController lifecycleCallbackController){
        lifecycleCallbackController.register(this);
    }
	@Override
    public void onStart() {
		// 뭔가를 한다 
    }
}
```

## 67p, 스스로 만든 Callback Class 사용 방법

```java
public class DetailViewModel {
	@Inject
    public DetailViewModel(LifecycleCallbackController lifecycleCallbackController ){
        lifecycleCallbackController.register(new OnStartCallback() {
            @Override
            public void onStart() {
				// 뭔가를 한다
            }
		});
    }
}
```

깊이가 깊어진다&불필요한 inner class 생성된다

## 68p, 스스로 만든 Callback을 정의

장점

- 스스로 이벤트를 늘리는 것이 간단 (예를 들면 이벤트를 제어하고 싶은 경우)

단점

- 메소드에 Annotation 정의하는 것과 비교하면 코드가 깔끔하지 않다 (스스로 만든 Annotation Processor로 작성하는 것도 있다?)
- Android Architecture Components 의 보급, 개선에 따라 부하가 된다

## 69p

이상 Better Practice 모음였습니다

## 70p, Sample Repository

[https://github.com/kr9ly/dagger2-sampleapp](https://github.com/kr9ly/dagger2-sampleapp)

- 생략한 코드가 모두 들어있습니다
- 오늘 언급한 내용 이외에도 여러 가지 있습니다
  - AutoDispose를 넣는 방법
  - Intent/Bundle에 의존하지 않고 Data를 꺼내는 방법
  - Android Data Binding과 RecyclerView 조합
  - ...
- 관심이 있으면 봐주세요

## 71p, 어디까지나 Better Practice 입니다

- 보다 좋은 방법이 있으면 공유해주세요
- 더욱 DI 가득하게 되도록 하자
- 청취해주셔서 감사합니다

