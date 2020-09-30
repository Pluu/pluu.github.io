---
layout: post
title: "AndroidX Activity ~ ContextAware"
date: 2020-09-30 16:50:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

본 글은 Jetpack AndroidX Activity에 추가된 `ContextAware` 을 다루는 글입니다.

<!--more-->

------

### AndroidX Activity

`ContextAware` 는 Jetpack AndroidX Activity에 포함된 기능으로 AndroidX Activity 1.2.0-alpha08에 처음 모습을 비췄습니다.

> AndroidX Activity 1.2.0-alpha08 Release Note : https://developer.android.com/jetpack/androidx/releases/activity#1.2.0-alpha08

이름대로 Context를 인식하는 순간을 인식을 담당하는 역할입니다. 먼저, 릴리즈 노트를 통해 ContextAware가 `상태 복원` 을 위한 중요한 역할을 담당하는 것을 알 수 있습니다. 이 내용은 이후에서 다시 살펴보겠습니다. 그리고 기본적으로 `Activity.onCreate()` 이전에 호출된다고 합니다.

또한 `ContextAware`를 통해서 AndroidX를 사용하는 측에서도 Context 활성화 시기를 명시적으로 전달받게 되었습니다. 

## ContextAware Code 분석

ContextAware의 기본은 Interface입니다. 먼저 아래에 보이는 ContextAware, OnContextAvailableListener 인터페이스 코드를 본 후에 다시 보겠습니다.

```java
public interface ContextAware {
   @Nullable
   Context peekAvailableContext();

   void addOnContextAvailableListener(@NonNull OnContextAvailableListener listener);

   void removeOnContextAvailableListener(@NonNull OnContextAvailableListener listener);
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/contextaware/ContextAware.java

```java
public interface OnContextAvailableListener {
   void onContextAvailable(@NonNull Context context);
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/contextaware/OnContextAvailableListener.java

인터페이스의 기본 구조는 매우 심플합니다. 내용에서도 알 수 있듯이 Context가 유효해지는 시점을 얻기 위한 리스너로 OnContextAvailableListener가 정의되었고, 리스너를 등록/제거를 위한 인터페이스가 ContextAware라는 것을 알 수 있습니다.

## ContextAware가 사용되는 코드

### ContextAwareHelper

먼저 살펴볼 코드는 ContextAware 구현을 위한 헬퍼 클래스인 `ContextAwareHelper`입니다. 이 Helper 클래스를 이용해서 ContextAware 처리를 쉽게 도와줍니다. ContextAwareHelper의 기본 구현은 [Observer pattern](https://en.wikipedia.org/wiki/Observer_pattern) 입니다. Context의 활성화는 [ContextAwareHelper#dispatchOnContextAvailable(Context)](https://developer.android.com/reference/androidx/activity/contextaware/ContextAwareHelper#dispatchOnContextAvailable(android.content.Context)) 함수 호출로 이뤄집니다.

```java
public final class ContextAwareHelper {
   private final Set<OnContextAvailableListener> mListeners = new CopyOnWriteArraySet<>();
   private volatile Context mContext;
   ...

   @Nullable
   public Context peekAvailableContext() {
      return mContext;
   }

   public void addOnContextAvailableListener(@NonNull OnContextAvailableListener listener) {
      if (mContext != null) {
         listener.onContextAvailable(mContext);
      }
      mListeners.add(listener);
   }

   public void removeOnContextAvailableListener(@NonNull OnContextAvailableListener listener) {
      mListeners.remove(listener);
   }

   public void dispatchOnContextAvailable(@NonNull Context context) {
      mContext = context;
      for (OnContextAvailableListener listener : mListeners) {
         listener.onContextAvailable(context);
      }
   }

   public void clearAvailableContext() {
      mContext = null;
   }
}
```

> Reference Document : https://developer.android.com/reference/androidx/activity/contextaware/ContextAwareHelper

> 실세 소스 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/contextaware/ContextAwareHelper.java

### AppCompatActivity, ComponentActivity, FragmentActivity 에서의 사용

먼저, ComponentActivity의 코드를 살펴보겠습니다. ComponentActivity에서는 아래의 처리를 합니다.

1. ContextAwareHelper 클래스를 정의
2. ComponentActivity#onCreate 에서 super.onCreate() 호출 전 [ContextAwareHelper#dispatchOnContextAvailable](https://developer.android.com/reference/androidx/activity/contextaware/ContextAwareHelper#dispatchOnContextAvailable(android.content.Context)) 호출로 Context 활성화를 실행합니다.
3. ComponentActivity의 Lifecycle의 상태가 [ON_DESTROY](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.Event#ON_DESTROY)인 경우, 유효한 Context를 초기화합니다.

> 현재 다루는 ComponentActivity는 `androidx.activity` 패키지의 ComponentActivity이며, 이 클래스의 super는 `androidx.core.app` 패키지의 ComponentActivity입니다. 

```java
public class ComponentActivity extends androidx.core.app.ComponentActivity 
   implements ContextAware, ... {
   ...
   final ContextAwareHelper mContextAwareHelper = new ContextAwareHelper();
   ...

   public ComponentActivity() {
     ...
     getLifecycle().addObserver(new LifecycleEventObserver() {
       @Override
       public void onStateChanged(@NonNull LifecycleOwner source,
            @NonNull Lifecycle.Event event) {
         if (event == Lifecycle.Event.ON_DESTROY) {
            // Clear out the available context
            mContextAwareHelper.clearAvailableContext();
               ...
            }
         }
      });

      ...
   }

   @Override
   protected void onCreate(@Nullable Bundle savedInstanceState) {
      // Restore the Saved State first so that it is available to
      // OnContextAvailableListener instances
      mSavedStateRegistryController.performRestore(savedInstanceState);
      mContextAwareHelper.dispatchOnContextAvailable(this);
      super.onCreate(savedInstanceState);
      ...
   }
}
```

> 소스 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/ComponentActivity.java

FragmentActivity에서는 ComponentActivity와는 다르게 `addOnContextAvailableListener`를 이용하여 Context 활성화 시 Fragment의 `상태 복원 처리`를 합니다. 상태 복원은 기존 FragmentActivity에서도 이루어졌지만, ContextAware를 사용하는 형태로 변경되었습니다.

```java
public class FragmentActivity extends ComponentActivity implements
   ... {
   static final String FRAGMENTS_TAG = "android:support:fragments";

   final FragmentController mFragments = FragmentController.createController(new HostCallbacks());
   ...
   public FragmentActivity() {
      super();
      init();
   }

   @ContentView
   public FragmentActivity(@LayoutRes int contentLayoutId) {
      super(contentLayoutId);
      init();
   }

   private void init() {
      ...
      addOnContextAvailableListener(new OnContextAvailableListener() {
         @Override
         public void onContextAvailable(@NonNull Context context) {
            mFragments.attachHost(null /*parent*/);
            Bundle savedInstanceState = getSavedStateRegistry()
                  .consumeRestoredStateForKey(FRAGMENTS_TAG);

            if (savedInstanceState != null) {
               Parcelable p = savedInstanceState.getParcelable(FRAGMENTS_TAG);
               mFragments.restoreSaveState(p);
            }
         }
      });
   }
}
```

ComponentActivity, FragmentActivity, AppCompatActivity 각 항목에서 어떻게 변경되었는지는 이어서 살펴보겠습니다.

## Gerrit에서 체크

ContextAware는 2020년 7월 23일에 Gerrit에 처음 등록되었습니다.

> 1364176: Add a hook that fires before the Activity's super.onCreate() \| https://android-review.googlesource.com/c/platform/frameworks/support/+/1364176

Gerrit에 등록된 내용으로 가볍게 코드 비교를 해보겠습니다.

### AppCompatActivity

#### Before 

```java
public class AppCompatActivity extends FragmentActivity ... {
   @Override
   protected void onCreate(@Nullable Bundle savedInstanceState) {
      final AppCompatDelegate delegate = getDelegate();
      delegate.installViewFactory();
      legate.onCreate(savedInstanceState);
      super.onCreate(savedInstanceState);
   }
}
```

#### After 

```java
public class AppCompatActivity extends FragmentActivity ... {
   public AppCompatActivity() {
      super();
      initDelegate();
   }
   
   @ContentView
   public AppCompatActivity(@LayoutRes int contentLayoutId) {
      super(contentLayoutId);
      initDelegate();
   }
   
   private void initDelegate() {
      addOnContextAvailableListener(new OnContextAvailableListener() {
         @Override
         public void onContextAvailable(@NonNull ContextAware contextAware,
               @NonNull Context context, @Nullable Bundle savedInstanceState) {
            final AppCompatDelegate delegate = getDelegate();
            delegate.installViewFactory();
            delegate.onCreate(savedInstanceState);
         }
      });
   }
}
```

### FragmentActivity

#### Before

```java
public class FragmentActivity extends ComponentActivity ... {
   @Override
   protected void onCreate(@Nullable Bundle savedInstanceState) {
      mFragments.attachHost(null /*parent*/);
      if (savedInstanceState != null) {
         Parcelable p = savedInstanceState.getParcelable(FRAGMENTS_TAG);
         mFragments.restoreSaveState(p);
      }
      super.onCreate(savedInstanceState);
      ...
   }
}
```

#### After

```java
public class FragmentActivity extends ComponentActivity ... {
   public FragmentActivity() {
      super();
      init();
   }

   @ContentView
   public FragmentActivity(@LayoutRes int contentLayoutId) {
      super(contentLayoutId);
      init();
   }

   private void init() {
      addOnContextAvailableListener(new OnContextAvailableListener() {
         @Override
         public void onContextAvailable(@NonNull ContextAware contextAware,
               @NonNull Context context, @Nullable Bundle savedInstanceState) {
            mFragments.attachHost(null /*parent*/);
            if (savedInstanceState != null) {
               Parcelable p = savedInstanceState.getParcelable(FRAGMENTS_TAG);
               mFragments.restoreSaveState(p);
            }
         }
      });
   }
}
```

AppCompatActivity, AppCompatActivity 둘 다 super.onCreate 호출 이전에 명시적으로 호출하는 부분이 ContextAware의 API를 이용하는 형태로 변경되었습니다. 
