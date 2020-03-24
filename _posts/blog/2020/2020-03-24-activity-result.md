---
layout: post
title: "New ActivityResultRegistry"
date: 2020-03-24 23:00:00 +09:00
tag: [Android, AndroidX, ActivityResultRegistry]
categories:
- blog
- Android
---

최근 AndroidX Activity-1.2.0-alpha02 / Fragment-1.3.0-alpha02으로 새롭게 업데이트되면서 Activity/Fragment에 동일한 기능이 추가되었습니다.

<!--more-->

## ActivityResultRegistry

이전부터 사용하던 Activity/Fragment의 메소드를 오버라이드 하지 않고 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) + [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) 및 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) + [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 를 처리할 수 있게 되었습니다. 안심하셔도 됩니다. 언급한 함수들이 사라지는 것은 아닙니다. 기존 화면/권한 요청 후 결과 반환에 대한 처리를 별도 기능으로 위임하는 형태로 변경되었습니다. 

바로 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry)가 중심이 되는 클래스입니다. 

## 사용 방법

### 전제조건

본 글에서 다루는 내용은 아래 버전을 기반으로 합니다.

```groovy
implementation 'androidx.activity:activity-ktx:1.2.0-alpha02'
implementation 'androidx.fragment:fragment-ktx:1.3.0-alpha02'
```

### 기본 지식

[ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 에는 요청(request)과 반환(responms)을 일관적인 방법으로 사용하기 위해서 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스를 구현하도록 추가되었습니다.

#### ActivityResultCaller

```java
public interface ActivityResultCaller {
  @NonNull
  <I, O> ActivityResultLauncher<I> prepareCall(
      @NonNull ActivityResultContract<I, O> contract,
      @NonNull ActivityResultCallback<O> callback);
  // ▶ ActivityResultCaller를 구현한 곳에서 ActivityResultRegistry 객체를 이용

  @NonNull
  <I, O> ActivityResultLauncher<I> prepareCall(
      @NonNull ActivityResultContract<I, O> contract,
      @NonNull ActivityResultRegistry registry,
      @NonNull ActivityResultCallback<O> callback);
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/3741933f48fc6b866dbafdf7e542ccb92a93e9c8/activity/activity/src/main/java/androidx/activity/result/ActivityResultCaller.java

[ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스는 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 객체를 호출하기 위한 인터페이스 역할을 합니다. 실제 중요한 일을 하는 것은 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry)이며, 이 클래스는 레지스트리의 역할을 하며 요청/결과에 대한 매거니즘을 저장 및 [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)), [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 을 통해서 응답에 대한 처리를 담당합니다. 

앞으로도 여러 번 언급할 예정이지만, [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 는 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 를 호출하기 위한 브릿지정도로 알아둡니다.

#### ActivityResultLauncher

[ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스에서 정의하는 `prepareCall` 함수의 반환형은 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 클래스입니다. 

```java
public interface ActivityResultLauncher<I> {
  void launch(@SuppressLint("UnknownNullness") I input);

  void dispose();
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/3741933f48fc6b866dbafdf7e542ccb92a93e9c8/activity/activity/src/main/java/androidx/activity/result/ActivityResultLauncher.java

이 클래스는 [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 객체를 실행하도록 준비하는 런처 객체입니다. 추후 우리는 이 객체를 이용해서 화면 전환 혹은 퍼미션을 처리를 하는 기능을 호출 예정입니다.

## 샘플

### 샘플 1 (전화걸기)

아래 코드는 `123-456-7890`으로 전화 앱을 호출하는 기능입니다. 전화 앱에서 [setResult](https://developer.android.com/reference/android/app/Activity#setResult(int,%20android.content.Intent)) 로 결과를 반환하거나 취소한 경우 콜백으로 값이 돌아옵니다. 

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

val dial = prepareCall(Dial()) { success: Boolean ->
   // Handle success or failure
}

// 123-456-7890 전화 요청
dial.launch("123-456-7890")
```

위에 작성한 코드는 간단한 샘플 코드입니다. 지금까지 작성한 방법과 매우 다를 것입니다. 전화 앱 호출한 후 결과에 대한 처리를 어떻게 했는지 한 번 떠올려 보시기 바랍니다. 대략적으로 아래와 같은 내용들이 필요합니다.

1. startActivityForResult 함수
2. requestCode
3. onActivityResult 함수

언급한 3가지는 모두 필요합니다. 다만 더욱 숨어있고, AndroidX 내부에서 해당 역할을 해주는 형태로 변경되었을 뿐입니다.

### 샘플 2 (FirstActivity ▶ SecondActivity)

다음 코드는 Activity에서 앱 내의 SecondActivity를 호출한 후 결과를 취득하는 샘플입니다. `샘플 1` 의 전화 앱 호출과 비슷하지만 일부 다른 패턴입니다.

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

class FirstActivity : AppCompatActivity() {
  val requestSecond = prepareCall(StartActivityForResult()) { activityResult : ActivityResult ->
    val resultCode: Int = activityResult.resultCode
    val data: Intent? = activityResult.data
    // Do action
  }
  
  fun showNext() {
    val intent = Intent(context, SecondActivity::class.java)
    requestSecond.launch(intent)
  }
}
```

SecondActivity는 기존과 동일하게 결과를 반환하는 형태입니다. core-ktx에 있는 `bundleOf` 를 이용해서 값 추가를 간단하게 처리할 수도 있습니다.

```kotlin
class SecondActivity : AppCompatActivity() {
  fun confirm() {
    val result = Intent().apply {
      putExtras(bundleOf(
        "typeString" to "ABCD",
        "typeInt" to 1
      ))
    }
    setResult(Activity.RESULT_OK, result)
    finish()
  } 
}
```

먼저 이번 샘플에서는 requestSecond의 launch함수에 전달하는 파라매터로 이동하려는 정보를 가진 Intent를 전달하는 것을 볼 수 있습니다. 그리고, `prepareCall` 함수 호출시 전달되는 콜백 결과로 [ActivityResult](https://developer.android.com/reference/androidx/activity/result/ActivityResult) 를 반환되는 것을 볼 수 있습니다. 이 클래스는 [Activity.onActivityResult(int, int, Intent)](https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int, int, android.content.Intent)) 에서 얻은 정보를 별도의 형태로 저장한 컨테이너 클래스입니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0324-activityresult/startactivity.gif" }}" />

#### ActivityResult

```java
public final class ActivityResult implements Parcelable {
    private final int mResultCode;
    @Nullable
    private final Intent mData;
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-master-dev/activity/activity/src/main/java/androidx/activity/result/ActivityResult.java

ResultCode와 Intent를 담고 있는 클래스입니다. 그러나 한 개의 변수가 빠진 것을 눈치채셨나요?

```java
void onActivityResult (int requestCode, int resultCode, Intent data)
```

[ActivityResult](https://developer.android.com/reference/androidx/activity/result/ActivityResult) 클래스에서는 RequestCode가 없습니다. Result 클래스인데 RequestCode가 없다는 것은 이후의 다른 섹션에서 다루도록 하겠습니다.

### 샘플 1/2의 내부

2가지의 간단한 샘플을 통해서 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 를 사용해봤습니다. 

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

// 샘플 1
val dial = prepareCall(Dial()) { success: Boolean -> 
	... }
dial.launch(...) // Parameter Type : String

// 샘플 2
val requestSecond = prepareCall(StartActivityForResult()) { activityResult : ActivityResult -> 
	... }
requestSecond.launch(...) // Parameter Type : Intent
```

launch의 파라매터 타입이 다르며, prepareCall의 콜백으로 전달되는 타입 또한 다릅니다. 누가 이 형태를 정의하고 있을까요? [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 의 인터페이스 구성이 어떻게 되었는지 다시 살펴보겠습니다.

```kotlin
public interface ActivityResultCaller {
  @NonNull
  <I, O> ActivityResultLauncher<I> prepareCall(
      @NonNull ActivityResultContract<I, O> contract,
      @NonNull ActivityResultCallback<O> callback);
}
```

인터페이스에서 정의한 함수의 contract 에 Input/Output의 형태가 제네릭으로 정의되어 있습니다. 이 정보를 기억하며 샘플 1/2 코드를 다시 살펴본다면 Input/Output을 정의를 누가 하는지 알 수 있습니다. 

바로, [Dial](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.Dial), [StartActivityForResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.StartActivityForResult) 입니다. 샘플에서는 AndroidX 내부에 사전에 정의된 클래스를 사용했습니다.

#### ActivityResultContract

[ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 클래스는 타입 `I`의 Input으로 Activity를 호출하고 타입 `O`로 Output으로 처리한다는 정의된 추상 클래스입니다.

```java
public abstract class ActivityResultContract<I, O> {
  public abstract @NonNull Intent createIntent(@SuppressLint("UnknownNullness") I input);
  
  public abstract @SuppressLint("UnknownNullness") O parseResult(
      int resultCode,
      @Nullable Intent intent);
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/3741933f48fc6b866dbafdf7e542ccb92a93e9c8/activity/activity/src/main/java/androidx/activity/result/contract/ActivityResultContract.java

위 클래스의 정보는 다음과 같습니다.

- createIntent : [Activity.startActivityForResult(Intent, int)](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 함수 호출시 사용되는 Intent를 만들도록 정의한 함수이며 매개변수로 Input 타입의 데이터가 전달
- parseResult : [Activity.onActivityResult(int, int, Intent)](https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent)) 함수를 통해 전달된 결과를 Output 타입으로 만들도록 정의한 함수

#### ActivityResultContracts

[ActivityResultContracts](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts) 클래스는 안드로이드에서 제공하는 표준 Activity 호출과 관련된 기능들을 묶어놓은 클래스입니다. 그럼 [Dial](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.Dial), [StartActivityForResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.StartActivityForResult) 에 대해서 살펴보도록 하겠습니다.

```java
public class ActivityResultContracts {
  private ActivityResultContracts() {}
  ...
  public static class StartActivityForResult
      extends ActivityResultContract<Intent, ActivityResult> {

   @NonNull
   @Override
   public Intent createIntent(@NonNull Intent input) {
     return input;
   }

   @NonNull
   @Override
   public ActivityResult parseResult(int resultCode, @Nullable Intent intent) {
     return new ActivityResult(resultCode, intent);
   }
  }
  ...
  public static class Dial extends ActivityResultContract<String, Boolean> {
    @NonNull
    @Override
    public Intent createIntent(@NonNull String input) {
      return new Intent(Intent.ACTION_DIAL).setData(Uri.parse("tel:" + input));
    }
  
    @NonNull
    @Override
    public Boolean parseResult(int resultCode, @Nullable Intent intent) {
      return resultCode == Activity.RESULT_OK;
    }
  }
  ...
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/3741933f48fc6b866dbafdf7e542ccb92a93e9c8/activity/activity/src/main/java/androidx/activity/result/contract/ActivityResultContracts.java

현재 [ActivityResultContracts](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts) 에는 Common 형태의 클래스가 일부만 제공되고 있습니다. 그러나 다음 버전에서는 더 증가할 것으로 보입니다.

앞서 사용한 [Dial](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.Dial), [StartActivityForResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.StartActivityForResult) 경우 [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 클래스를 상속하여 구현되어 있습니다.

- Dial : Input = String / Output = Boolean
- StartActivityForResult : Input =Intent / Output =ActivityResult

### Permission 관련 샘플

[ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 기능 중 또 다른 활용법으로는 Permission을 체크한 후 활성화 여부에 따라 추가 작업을 할 수 있습니다. 

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

// requestLocation : ActivityResultLauncher<String>
val requestLocation = prepareCall(RequestPermission()) { isGranted ->
	toast("Location granted: $isGranted")
}
requestLocation.launch(ACCESS_FINE_LOCATION)
```

앞서 언급한 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) 을 활용한 샘플 1/2와 비슷한 작성합니다. [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) 과 [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) 없이 Permission 요청과 응답을 처리하고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0324-activityresult/permission.gif" }}" />

```java
public class ActivityResultContracts {
  private ActivityResultContracts() {}
  ...
  public static final String ACTION_REQUEST_PERMISSIONS =
      "androidx.activity.result.contract.action.REQUEST_PERMISSIONS";

  public static final String EXTRA_PERMISSIONS =
      "androidx.activity.result.contract.extra.PERMISSIONS";

  public static final String EXTRA_PERMISSION_GRANT_RESULTS =
      "androidx.activity.result.contract.extra.PERMISSION_GRANT_RESULTS";  
  ... 
  public static class RequestPermission extends ActivityResultContract<String, Boolean> {

    @NonNull
    @Override
    public Intent createIntent(@NonNull String input) {
      return new Intent(ACTION_REQUEST_PERMISSIONS)
          .putExtra(EXTRA_PERMISSIONS, new String[] { input });
    }

    @NonNull
    @Override
    public Boolean parseResult(int resultCode, @Nullable Intent intent) {
      if (resultCode != Activity.RESULT_OK) return false;
      if (intent == null) return false;
      int[] grantResults = intent.getIntArrayExtra(EXTRA_PERMISSION_GRANT_RESULTS);
      if (grantResults == null) return false;
      return grantResults[0] == PackageManager.PERMISSION_GRANTED;
    }
  }
  ...
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/3741933f48fc6b866dbafdf7e542ccb92a93e9c8/activity/activity/src/main/java/androidx/activity/result/contract/ActivityResultContracts.java#154


[ActivityResultContracts.RequestPermissions](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.RequestPermissions) 의 내부를 여기에서도 동일하게 Intent 생성과 [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) 의 결과를 처리하는 parseResult 함수가 존재합니다. [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) 시에 Intent가 필요한 것은 아니지만, Intent에 담은 정보를 활용해서 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) 를 호출하는 구조입니다. 해당 내용은 추후 확인해보겠습니다.

activity-ktx 버전

```kotlin
// requestLocation : () -> Unit
val requestLocation = prepareCall(RequestPermission(), ACCESS_FINE_LOCATION) { isGranted ->
	toast("Location granted: $isGranted")
}
requestLocation()
```

Component/Fragment에 포함된 prepareCall 사용 시에는 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 를 반환합니다. 그리고, ktx 사용 시에는 `() -> Unit` 형태가 반환되어 `launch(...)` 로 함수를 호출하는 방법으로 사용할 수 있습니다.

## Advanced

지금까지 새롭게 추가된 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 를 이용해서 함수를 activity 호출-반환 / permission 호출-반환을 적용한 샘플을 확인했습니다. 

앞으로는 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 내부에서 어떤 변화를 가져왔는지를 살펴보겠습니다.

### Diff - ComponentActivity

```bash
public class ComponentActivity extends androidx.core.app.ComponentActivity imple
     ...
-        OnBackPressedDispatcherOwner {
+        OnBackPressedDispatcherOwner,
+        ActivityResultCaller {
     ...
+    private ActivityResultRegistry mActivityResultRegistry = ...
     ...
     protected void onCreate(@Nullable Bundle savedInstanceState) {
         ...
+        mActivityResultRegistry.onRestoreInstanceState(savedInstanceState);
         ...
     protected void onSaveInstanceState(@NonNull Bundle outState) {
         ...
+        mActivityResultRegistry.onSaveInstanceState(outState);
     }
     ...
+    @CallSuper
+    @Override
+    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
+        if (!mActivityResultRegistry.dispatchResult(requestCode, resultCode, data)) {
+            super.onActivityResult(requestCode, resultCode, data);
+        }
+    }
+    @CallSuper
+    @Override
+    public void onRequestPermissionsResult(
+            int requestCode,
+            @NonNull String[] permissions,
+            @NonNull int[] grantResults) {
+        if (!mActivityResultRegistry.dispatchResult(requestCode, Activity.RESULT_OK, new Intent()
+                .putExtra(EXTRA_PERMISSIONS, permissions)
+                .putExtra(EXTRA_PERMISSION_GRANT_RESULTS, grantResults))) {
+            if (Build.VERSION.SDK_INT >= 23) {
+                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
+            }
+        }
+    }
     ...
 }
```

ComponentActivity 내부의 변화

- [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 가 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스를 구현
- [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 객체를 내부 변수로 정의
- 시스템에 의해서 종료되는 경우, [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 객체를 상태 복원/저장
- [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)), [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) 가 호출되는 경우 [ActivityResultRegistry#dispatchResult(int, int, Intent)](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry#dispatchResult(int,%20int,%20android.content.Intent)) 를 호출하여 결과를 콜백에 전달하거나 콜백이 아직 등록되지 않은 경우 결과를 저장

```bash
public class ComponentActivity extends androidx.core.app.ComponentActivity imple
     ...
-        OnBackPressedDispatcherOwner {
+        OnBackPressedDispatcherOwner,
+        ActivityResultCaller {
     ...
+    private final AtomicInteger mNextLocalRequestCode = new AtomicInteger();
+    private ActivityResultRegistry mActivityResultRegistry = ...
     ...
+    @NonNull
+    @Override
+    public <I, O> ActivityResultLauncher<I> prepareCall(
+            @NonNull final ActivityResultContract<I, O> contract,
+            @NonNull final ActivityResultRegistry registry,
+            @NonNull final ActivityResultCallback<O> callback) {
+        return registry.registerActivityResultCallback(
+                "activity_rq#" + mNextLocalRequestCode.getAndIncrement(), this, contract, callback);
+    }
+    @NonNull
+    @Override
+    public <I, O> ActivityResultLauncher<I> prepareCall(
+            @NonNull ActivityResultContract<I, O> contract,
+            @NonNull ActivityResultCallback<O> callback) {
+        return prepareCall(contract, mActivityResultRegistry, callback);
+    }
     ...
 }
```

ComponentActivity 내부의 변화

- 기존의 고정 Request Code를 두지 않고 Activity에서의 동적의 Request Code를 생성하는 객체를 생성
- [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 가 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스를 구현
- prepareCall 이름의 2개의 함수를 구현
  - `activity_rq#1` 형태로 요청의 키를 생성
  - AtomicInteger를 이용한 현재 시점에 호출하는 Requestcode 생성 처리

```bash
public class ComponentActivity extends androidx.core.app.ComponentActivity imple
     ...
+    private ActivityResultRegistry mActivityResultRegistry = new ActivityResultRegistry() {
+        @Override
+        public <I, O> void invoke(
+                final int requestCode,
+                @NonNull ActivityResultContract<I, O> contract,
+                I input) {
+            Intent intent = contract.createIntent(input);
+            if (ACTION_REQUEST_PERMISSIONS.equals(intent.getAction())) {
+                String[] permissions = intent.getStringArrayExtra(EXTRA_PERMISSIONS);
+                if (SDK_INT < Build.VERSION_CODES.M || permissions == null) {
+                    return;
+                }
+                List<String> nonGrantedPermissions = new ArrayList<>();
+                for (String permission : permissions) {
+                    if (checkPermission(permission,
+                            android.os.Process.myPid(), android.os.Process.myUid())
+                            != PackageManager.PERMISSION_GRANTED) {
+                        nonGrantedPermissions.add(permission);
+                    }
+                }
+                if (!nonGrantedPermissions.isEmpty()) {
+                    requestPermissions(nonGrantedPermissions.toArray(
+                            new String[nonGrantedPermissions.size()]), requestCode);
+                }
+            } else {
+                ComponentActivity.this.startActivityForResult(intent, requestCode);
+            }
+        }
+    };
     ...
 }
```

ComponentActivity의 마지막 변경점입니다. 추상 클래스인 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 객체를 구현하는 부분으로 실제 동작인 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) , [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) 를 호출하는 부분입니다.

### Diff - Fragment

Fragment는 Activity에 비하여 변경점은 적은 편입니다.

```bash
 public class Fragment implements ComponentCallbacks, OnCreateContextMenuListener, LifecycleOwner,
-        ViewModelStoreOwner, HasDefaultViewModelProviderFactory, SavedStateRegistryOwner {
+        ViewModelStoreOwner, HasDefaultViewModelProviderFactory, SavedStateRegistryOwner,
+        ActivityResultCaller {
     ...
     @NonNull
     String mWho = UUID.randomUUID().toString();
     ...
+    private final AtomicInteger mNextLocalRequestCode = new AtomicInteger();
     ...
+    @NonNull
+    @Override
+    public <I, O> ActivityResultLauncher<I> prepareCall(
+            @NonNull final ActivityResultContract<I, O> contract,
+            @NonNull final ActivityResultCallback<O> callback) {
+        final String key = generateActivityResultKey();
+        final AtomicReference<ActivityResultLauncher<I>> ref =
+                new AtomicReference<ActivityResultLauncher<I>>();
+        getLifecycle().addObserver(new LifecycleEventObserver() {
+            @Override
+            public void onStateChanged(@NonNull LifecycleOwner lifecycleOwner,
+                    @NonNull Lifecycle.Event event) {
+                if (Lifecycle.Event.ON_CREATE.equals(event)) {
+                    ref.set(getActivity()
+                            .getActivityResultRegistry()
+                            .registerActivityResultCallback(
+                                    key, Fragment.this, contract, callback));
+                }
+            }
+        });
+        return new ActivityResultLauncher<I>() {
+            @Override
+            public void launch(I input) {
+                ActivityResultLauncher<I> delegate = ref.get();
+                if (delegate == null) {
+                    throw new IllegalStateException("Operation cannot be started before fragment "
+                            + "is in created state");
+                }
+                delegate.launch(input);
+            }
+            @Override
+            public void dispose() {
+                ActivityResultLauncher<I> delegate = ref.getAndSet(null);
+                if (delegate != null) {
+                    delegate.dispose();
+                }
+            }
+        };
+    }
+    @NonNull
+    private String generateActivityResultKey() {
+        return "fragment_" + mWho + "_rq#" + mNextLocalRequestCode.getAndIncrement();
+    }
+    @NonNull
+    @Override
+    public <I, O> ActivityResultLauncher<I> prepareCall(
+            @NonNull final ActivityResultContract<I, O> contract,
+            @NonNull ActivityResultRegistry registry,
+            @NonNull final ActivityResultCallback<O> callback) {
+        return registry.registerActivityResultCallback(
+                generateActivityResultKey(), this, contract, callback);
+    }
}
```

Fragment 내부의 변화

- 기존의 고정 Request Code를 두지 않고 Fragment에서의 동적의 Request Code를 생성하는 객체를 생성
- [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 가 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스를 구현
- prepareCall 이름의 2개의 함수를 구현
  - `fragment_UUID정보_rq#1` 형태로 요청의 키를 생성
  - AtomicInteger를 이용한 현재 시점에 호출하는 Requestcode 생성 처리
  - 파라매터로 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 가 존재하지 않는 경우에는 Fragment Lifecycle이 `ON_CREATE` 일 경우에 Activity가 가지고 있는 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 를 사용하여 AtomicReference에 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 타입으로 등록
  - `launch` 호출 시점에 AtomicReference에 등록된 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 을 꺼내서 사용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0324-activityresult/fragment.gif" }}" />

## ActivityResultRegistry

지금까지 ComponentActivity와 Fragment 내부의 변경과 [ActivityResultCaller](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller) 인터페이스를 이용해서 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) + [onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) 및 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) + [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 조합의 일부를 봤습니다. 하지만 이제 남은 것이 2가지가 있습니다. 

request code는 어디에? [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 에 대한 설명은? 이 2가지를 포함한 정보를 살펴보겠습니다.

```java
public abstract class ActivityResultRegistry {
    ...
    private final AtomicInteger mNextRc = new AtomicInteger(0);
    private final Map<Integer, String> mRcToKey = new HashMap<Integer, String>();
    private final Map<String, Integer> mKeyToRc = new HashMap<String, Integer>();
    private final transient Map<String, CallbackAndContract<?>> mKeyToCallback =
            new HashMap<String, CallbackAndContract<?>>();
    private final Bundle/*<String, ActivityResult>*/ mPendingResults = new Bundle();

    @MainThread
    public abstract <I, O> void invoke(
            int requestCode,
            @NonNull ActivityResultContract<I, O> contract,
            @SuppressLint("UnknownNullness") I input);
 
    @NonNull
    public <I, O> ActivityResultLauncher<I> registerActivityResultCallback(
            @NonNull final String key,
            @NonNull final LifecycleOwner lifecycleOwner,
            @NonNull final ActivityResultContract<I, O> contract,
            @NonNull final ActivityResultCallback<O> callback) {
        final int requestCode = registerKey(key);
        mKeyToCallback.put(key, new CallbackAndContract<O>(callback, contract));
        Lifecycle lifecycle = lifecycleOwner.getLifecycle();
        final ActivityResult pendingResult = mPendingResults.getParcelable(key);
        if (pendingResult != null) {
            mPendingResults.remove(key);
            if (lifecycle.getCurrentState().isAtLeast(Lifecycle.State.STARTED)) {
                callback.onActivityResult(contract.parseResult(
                        pendingResult.getResultCode(),
                        pendingResult.getData()));
            } else {
                lifecycle.addObserver(new LifecycleEventObserver() {
                    @Override
                    public void onStateChanged(
                            @NonNull LifecycleOwner lifecycleOwner,
                            @NonNull Lifecycle.Event event) {
                        if (Lifecycle.Event.ON_CREATE.equals(event)) {
                            callback.onActivityResult(contract.parseResult(
                                    pendingResult.getResultCode(),
                                    pendingResult.getData()));
                        }
                    }
                });
            }
        }
        lifecycle.addObserver(new LifecycleEventObserver() {
            @Override
            public void onStateChanged(@NonNull LifecycleOwner lifecycleOwner,
                    @NonNull Lifecycle.Event event) {
                if (Lifecycle.Event.ON_DESTROY.equals(event)) {
                    unregisterActivityResultCallback(key);
                }
            }
        });
        return new ActivityResultLauncher<I>() {
            @Override
            public void launch(I input) {
                invoke(requestCode, contract, input);
            }
            @Override
            public void dispose() {
                unregisterActivityResultCallback(key);
            }
        };
    }

    @NonNull
    public <I, O> ActivityResultLauncher<I> registerActivityResultCallback(
            @NonNull final String key,
            @NonNull final ActivityResultContract<I, O> contract,
            @NonNull final ActivityResultCallback<O> callback) {
        final int requestCode = registerKey(key);
        mKeyToCallback.put(key, new CallbackAndContract<O>(callback, contract));
        final ActivityResult pendingResult = mPendingResults.getParcelable(key);
        if (pendingResult != null) {
            mPendingResults.remove(key);
            callback.onActivityResult(contract.parseResult(
                    pendingResult.getResultCode(),
                    pendingResult.getData()));
        }
        return new ActivityResultLauncher<I>() {
            @Override
            public void launch(I input) {
                invoke(requestCode, contract, input);
            }
            @Override
            public void dispose() {
                unregisterActivityResultCallback(key);
            }
        };
    }
    ...
    @MainThread
    public boolean dispatchResult(int requestCode, int resultCode, @Nullable Intent data) {
        String key = mRcToKey.get(requestCode);
        if (key == null) {
            return false;
        }
        doDispatch(key, resultCode, data, mKeyToCallback.get(key));
        return true;
    }
    private <O> void doDispatch(String key, int resultCode, @Nullable Intent data,
            CallbackAndContract<O> callbackAndContract) {
        ActivityResultCallback<O> callback = callbackAndContract.mCallback;
        ActivityResultContract<?, O> contract = callbackAndContract.mContract;
        if (callback != null) {
            callback.onActivityResult(contract.parseResult(resultCode, data));
        } else {
            mPendingResults.putParcelable(key, new ActivityResult(resultCode, data));
        }
    }
    ...
    private int registerKey(String key) {
        Integer existing = mKeyToRc.get(key);
        if (existing != null) {
            return existing;
        }
        int rc = mNextRc.getAndIncrement();
        bindRcKey(rc, key);
        return rc;
    }
    ...
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/e0ba16093bd45038cca11cfcc333c916ad52b4b5/activity/activity/src/main/java/androidx/activity/result/ActivityResultRegistry.java

### registerActivityResultCallback

 [ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) 를 등록하기 위해서 총 4개의 매개변수가 사용됩니다. 등록하려는 [ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) 와 관련지은 `키 정보`, Activity/Permission 요청 실행에 필요한 [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 와 콜백으로 구성된 [ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) 이 기본적으로 전달됩니다. 그리고 Lifecycle 에 따라 동적으로 콜백 호출과 레지스터리에 등록된 콜백을 해제하는 역할을 합니다.

[LifecycleOwner](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner)를 전달하지 않는 경우, 콜백을 처리할 필요가 종료된다면 [unregisterActivityResultCallback(String)](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry#unregisterActivityResultCallback(java.lang.String)) 를 호출해야 합니다. 

또한, 파라매터로 전달된 키 정보는 통해서 캐싱되지 않은 키가 추가되는 경우 새로운 `Request Code`가 생성됩니다. 여기서 실제로 우리들이 알고 있는 RequestCode가 생성됩니다. 그 후 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 에서 구현하는 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 에 Request Code를 전달됩니다. 전달된 Request Code를 통해서 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) 혹은 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) 에서 사용됩니다.

registerActivityResultCallback 의 반환값으로 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 가 되며, launch를 호출시 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)와 [Fragment](https://developer.android.com/reference/androidx/fragment/app/Fragment) 에 정의된 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry) 정보를 호출합니다. 이 흐름이 ActivityResultCallback 에서 핵심이 되는 부분입니다.

### dispatchResult

[onRequestPermissionsResult()](https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String%5B%5D,%20int%5B%5D)) , [onActivityResult()](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 으로 넘어온 결과를 dispatchResult로 전달하여 결과를 처리합니다.

## 차기버전을 기다립시다

### 버그?

현재 공개된 버전(Activity-1.2.0-alpha02 / Fragment-1.3.0-alpha02)에는 버그가 존재합니다. 초기에 Permission 관련 함수를 호출할 경우 정상적으로 작동하지만, 재호출할 경우 반응이 없습니다. 

### Interface 변경

차기 버전에서 [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 추상 클래스에서 구현할 createIntent의 함수에는 Context 파라매터가 추가됩니다. 작은 변경이지만, 기존 버전과 호환이 되지 않고 개발자가 구현해야 하는 항목이기도 합니다.

```bash
public abstract class ActivityResultContract<I, O> {
-  public abstract @NonNull Intent createIntent(@SuppressLint("UnknownNullness") I input);
+  public abstract @NonNull Intent createIntent(@NonNull Context context,
+           @SuppressLint("UnknownNullness") I input);
   ...
}
```

### 정리

오늘 파악한 코드로 Android 개발이 갑자기 낯설 수 있습니다. 일정한 패턴을 정리해간다는 느낌이라서 환영이지만, 현재 알파 버전이므로 앞으로 어떻게 변해갈지 기대가 됩니다.

본 글에서 사용된 샘플은 다음 링크를 통해서 확인할 수 있습니다.

- 링크 : https://github.com/Pluu/ActivityResultSample

## 참고

- [Android Developers > Docs > Guides > Getting a result from an activity](https://developer.android.com/training/basics/intents/result)