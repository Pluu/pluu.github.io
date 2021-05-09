---
layout: post
title: "[고찰] ViewBinding / DataBinding에서 불안한 ID 정의"
date: 2021-05-09 17:00:00 +09:00
tag: [Android, AndroidX, ViewBinding]
categories:
- blog
- Android
---

ViewBinding과 DataBinding은 Android 앱 개발 시에 View를 접근 시에 사용하는 `findViewById` 상용 문구 제거와 데이터를 View에 바인딩 할 수 있는 Support 라이브러리입니다.

<!--more-->

------

기본적인 View Binding/Data Binding에 대한 내용은 아래 링크를 참고 해주세요.

- View Binding 개요 : https://developer.android.com/topic/libraries/view-binding
- Data Binding 개요 : https://developer.android.com/topic/libraries/data-binding

## Sample (1) 기본 ViewGroup

먼저 아래의 XML로 ViewBinding을 사용해봅니다.

- ConstraintLayout : View ID 미정의
- TextView : text1 View ID 정의

```xml
<!-- activity_view_sample.xml -->
<androidx.constraintlayout.widget.ConstraintLayout
   ...>
   <TextView
      android:id="@+id/text1"
      ... />
</androidx.constraintlayout.widget.ConstraintLayout>
```

```kotlin
class ViewBindingActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      val binding = ActivityViewSampleBinding.inflate(layoutInflater)
      setContentView(binding.root) // ConstraintLayout

      val root1 = binding.root // ConstraintLayout
      val root2 = binding.getRoot() // ConstraintLayout
      val text1 = binding.text1 // TextView
   }
}
```

기본적으로 ViewBinding/DataBinding에서는 최상위 ViewGroup 접근 시에 별도 View ID가 정의하지 않아도 getRoot로 접근할 수 있습니다. 그 이유는 빌드로 생성된 Binding 클래스의 상위 인터페이스인 `ViewBinding`에 `getRoot()`가 선언되어 있기 때문입니다. 또한 Kotlin의 경우 `getter` 함수는 [Properties](https://kotlinlang.org/docs/properties.html#overriding-properties) 로 접근하여 binding.root로도 접근할 수 있습니다.

```java
public final class ActivityViewSampleBinding implements ViewBinding {
  @NonNull
  private final ConstraintLayout rootView;

  @NonNull
  public final TextView text1;

  private ActivityViewSampleBinding(@NonNull ConstraintLayout rootView, @NonNull TextView text1) {
    this.rootView = rootView;
    this.text1 = text1;
  }

  @Override
  @NonNull
  public ConstraintLayout getRoot() {
    return rootView;
  }
  ...
    
  @NonNull
  public static ActivityViewSampleBinding bind(@NonNull View rootView) {
    // The body of this method is generated in a way you would not otherwise write.
    // This is done to optimize the compiled bytecode for size and performance.
    int id;
    missingId: {
      id = R.id.text1;
      TextView text1 = rootView.findViewById(id);
      if (text1 == null) {
        break missingId;
      }

      return new ActivityViewSampleBinding((ConstraintLayout) rootView, text1);
    }
    String missingId = rootView.getResources().getResourceName(id);
    throw new NullPointerException("Missing required view with ID: ".concat(missingId));
  }
}
```

> ViewBinding/DataBinding 사용시 생성되는 클래스 위치
>
> - app/build/generated/data_binding_base_class_source_out/{package}

```java
public interface ViewBinding {
    @NonNull
    View getRoot();
}
```

> 소스 출처 : https://cs.android.com/androidx/platform/frameworks/data-binding/+/mirror-goog-studio-master-dev:extensions/viewbinding/src/main/java/androidx/viewbinding/ViewBinding.java

| ViewBinding                                       | DataBinding                                                  |
| ------------------------------------------------- | ------------------------------------------------------------ |
| ViewBinding<br />ㄴ Generated된 View Binding클래스 | ViewBinding<br />ㄴ ViewDataBinding<br />___ㄴ Generated된 Data Binding 클래스 |

DataBinding 또한 ViewBinding Interface를 구현하도록 선언되어 있습니다.

> ViewDataBinding
>
> - Reference : https://developer.android.com/reference/android/databinding/ViewDataBinding

## Sample (2) 불안한 ID 정의 케이스 (root ... not recommend)

- ConstraintLayout : root View ID 정의
- TextView : text1 View ID 정의

기본적으로 Android의 레이아웃에 정의된 특정 View에 접근하기 위해서는 해당 View에 View ID를 정의해야 합니다. ViewBinding/DatatBinding도 특정 View에 접근하기 위해서는 `android:id=@+id/` 를 사용해서 View ID를 선언해야 합니다. 

```xml
<!-- activity_view_sample.xml -->
<androidx.constraintlayout.widget.ConstraintLayout
   android:id="@+id/root" 
   ...>
   <TextView
      android:id="@+id/text1"
      ... />
</androidx.constraintlayout.widget.ConstraintLayout>
```

예제로 최상위 ViewGroup인 ConstraintLayout에 `root`로 View ID를 정의했습니다. 프로젝트마다 다르겠지만, 관습적으로 최상의 View Group의 View ID를 root/container 등의 이름으로 정의하기도 합니다. 

ViewBinding/DataBinding를 미사용하는 곳이라면 문제가 없지만, 최근 Android 개발 시에는 처음부터 ViewBinding/DataBinding를 사용하거나 전환하는 경우도 많습니다.

```kotlin
class ViewBindingActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      val binding = ActivityViewSampleBinding.inflate(layoutInflater)
      setContentView(binding.root) // ConstraintLayout

      val root1 = binding.root // ConstraintLayout
      val root2 = binding.getRoot() // ConstraintLayout
      val text1 = binding.text1 // TextView
   }
}
```

ViewBindingActivity의 코드는 **Sample (1)**과 변경된 것이 없습니다. 대신 `ActivityViewSampleBinding`의 내부에 추가된 코드가 일부 있습니다.

```java
public final class ActivityViewSampleBinding implements ViewBinding {
  @NonNull
  private final ConstraintLayout rootView;

  @NonNull
  public final ConstraintLayout root; // 추가된 코드

  @NonNull
  public final TextView text1;

  private ActivityViewSampleBinding(@NonNull ConstraintLayout rootView,
      @NonNull ConstraintLayout root, @NonNull TextView text1) {
    this.rootView = rootView;
    this.root = root; // 추가된 코드
    this.text1 = text1;
  }

  @Override
  @NonNull
  public ConstraintLayout getRoot() {
    return rootView;
  }

  ...

  @NonNull
  public static ActivityViewSampleBinding bind(@NonNull View rootView) {
    // The body of this method is generated in a way you would not otherwise write.
    // This is done to optimize the compiled bytecode for size and performance.
    int id;
    missingId: {
      ConstraintLayout root = (ConstraintLayout) rootView; // 추가된 코드

      id = R.id.text1;
      TextView text1 = rootView.findViewById(id);
      if (text1 == null) {
        break missingId;
      }

      return new ActivityViewSampleBinding((ConstraintLayout) rootView, root, text1);
    }
    String missingId = rootView.getResources().getResourceName(id);
    throw new NullPointerException("Missing required view with ID: ".concat(missingId));
  }
}
```

앞서 살펴본 Sample (1)/(2)에서의 ViewBindingActivity 코드는 binding으로 root/getRoot()로 접근하는 객체는 실제로 동일한 객체이지만 어떤 Instance를 참조하는지가 실제로 다릅니다

|                   | root View ID 미선언                                          | root View ID 선언                                            |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| binding.root      | ActivityViewSampleBinding#getRoot()<br />ActivityViewSampleBinding에 선언된 rootView Field | ActivityViewSampleBinding에 선언된 root Field                |
| binding.getRoot() | ActivityViewSampleBinding#getRoot()<br />ActivityViewSampleBinding에 선언된 rootView Field | ActivityViewSampleBinding#getRoot()<br />ActivityViewSampleBinding에 선언된 rootView Field |

## Sample (3) 최상위 이외의 곳에 root 선언

- ConstraintLayout : View ID 미정의
- TextView : text1 View ID 정의
- LinearLayout : rootView ID 정의

이번에는 최상위 ViewGroup이 아닌 다른 곳에 View ID를 `root`로 선언한 경우를 살펴봅니다. 아래 샘플에서는 LinearLayout에 root로 선언했습니다. ViewBindingActivity는 이전과 동일한 코드입니다.

```xml
<!-- activity_view_sample.xml -->
<androidx.constraintlayout.widget.ConstraintLayout
   ...>
   <TextView
      android:id="@+id/text1"
      ... />

   <LinearLayout
      android:id="@+id/root"
      ...>
      <!-- Views -->
   </LinearLayout>
</androidx.constraintlayout.widget.ConstraintLayout>
```

```kotlin
class ViewBindingActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      val binding = ActivityViewSampleBinding.inflate(layoutInflater)
      setContentView(binding.root) // LinearLayout

      val root1 = binding.root // LinearLayout
      val root2 = binding.getRoot() // ConstraintLayout
      val text1 = binding.text1 // TextView
   }
}
```

해당 코드는 컴파일은 성공하지만, 실행 시 `IllegalStateException` 크래시가 발생합니다. 에러 내용은 `setContentView`의 내부 동작에 의해서 Parent가 존재하는 View는 추가할 수 없다는 에러 내용입니다.

```
E/AndroidRuntime: FATAL EXCEPTION: main
   Process: com.pluu.bindingrootsample, PID: 6802
   java.lang.RuntimeException: Unable to start activity ComponentInfo{com.pluu.bindingrootsample/com.pluu.bindingrootsample.ViewBindingActivity}: java.lang.IllegalStateException: The specified child already has a parent. You must call removeView() on the child's parent first.
      ...
   Caused by: java.lang.IllegalStateException: The specified child already has a parent. You must call removeView() on the child's parent first.
      at android.view.ViewGroup.addViewInner(ViewGroup.java:5235)
      at android.view.ViewGroup.addView(ViewGroup.java:5064)
      at android.view.ViewGroup.addView(ViewGroup.java:5004)
      at android.view.ViewGroup.addView(ViewGroup.java:4976)
      at androidx.appcompat.app.AppCompatDelegateImpl.setContentView(AppCompatDelegateImpl.java:687)
      at androidx.appcompat.app.AppCompatActivity.setContentView(AppCompatActivity.java:175)
      at com.pluu.bindingrootsample.ViewBindingActivity.onCreate(ViewBindingActivity.kt:11)
      ...
```

> ViewGroup#addViewInner() : https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/view/ViewGroup.java;l=5234?q=ViewGroup%20addViewInner

## 결론

본 글에서는 몇 가지의 사례를 통해서 동일한 코드라도 XML에 정의에 따라서 다른 결과를 만날 수 있다는 사실을 알아봤습니다. ViewBinding/DataBindign의 경우에는 자동 생성된 코드로 같은 필드라고 오해할 수 있는 부분이 숨어있습니다. 

이번과 같은 패턴이 발생하지 않기 위해서 블로그에 기록을 남겨둡니다.
