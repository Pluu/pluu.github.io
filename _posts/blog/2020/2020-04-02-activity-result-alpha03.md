---
layout: post
title: "ActivityResult alpha02 vs alpha03"
date: 2020-04-02 23:30:00 +09:00
tag: [Android, AndroidX, ActivityResultRegistry]
categories:
- blog
- Android
---

2020년 4월 1일, AndroidX Activity-1.2.0-alpha03 / Fragment-1.3.0-alpha03 버전으로 업데이트되었습니다. ActivityResult가 등장 후 두 번째 업데이트입니다.

> 첫 번째 등장에 관한 내용은 다음 글을 참고하세요. [New ActivityResultRegistry](http://pluu.github.io/blog/android/2020/03/24/activity-result/)

<!--more-->

## Update ActivityResultContract

```bash
public abstract class ActivityResultContract<I, O> {
-    public abstract @NonNull Intent createIntent(@SuppressLint("UnknownNullness") I input);
+    public abstract @NonNull Intent createIntent(@NonNull Context context,
+            @SuppressLint("UnknownNullness") I input);
}
```

기존 Intent 생성 시에는 I 타입의 Input만 전달되었지만, Contenxt가 새롭게 추가되었습니다. Context가 필요성의 가장 쉬운 예로는 Activity 이동에 Context를 사용할 수 있습니다.

> Intent(Context, SecondActivity::class.java)

## Permission 문제 수정됨

기존 Activity-1.2.0-alpha02 / Fragment-1.3.0-alpha02에서는 중요한 버그가 하나 있었습니다. Permission 요청에 희한 수락한 후 재요청 시 응답이 반환되지 않는 버그가 발생했습니다. 다행히 두 번째 업데이트인 Activity-1.2.0-alpha03 / Fragment-1.3.0-alpha03에는 정상적으로 수정되었습니다. 어떻게 수정을 했는지 체크해보겠습니다.

Android는 현재 위치에 접근하기 위해서는 권한 취득이 필요합니다. 실제 위치 취득 전, [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract)를 사용해서 권한 요청/응답을 처리를 할 수 있습니다.

```kotlin
val requestLocation = prepareCall(RequestPermission(), ACCESS_FINE_LOCATION) { isGranted ->
  toast("Location granted: $isGranted")
}
```

ComponentActivity에서 구현하고 있는 [ActivityResultRegistry](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry)의 내부가 변경되었습니다. 아래의 코드가 실제 변경이 발생한 부분만 가져왔습니다. 

### ComponentActivity

```java
public class ComponentActivity ... {
  ...
  private ActivityResultRegistry mActivityResultRegistry = new ActivityResultRegistry() {
    @Override
    public <I, O> void invoke(...) {
      // ▼▼▼▼▼ Add Code ▼▼▼▼▼
      // Immediate result path
      final ActivityResultContract.SynchronousResult<O> synchronousResult =
          contract.getSynchronousResult(activity, input);
      if (synchronousResult != null) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
          @Override
          public void run() {
            dispatchResult(requestCode, synchronousResult.getValue());
          }
        });
        return;
      }
      // ▲▲▲▲▲ Add Code ▲▲▲▲▲
      // requestPermissions / startActivityForResult 호출
      ...      
    }
  };
  ...
}
```

기존 버전에서는 [Intent#getAction()](https://developer.android.com/reference/android/content/Intent.html#getAction()) 의 결과에 따라 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) / [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int))을 호출했습니다. 해당 작업을 실행하기 전, 처리 가능 여부를 먼저 처리하는 작업이 추가되었습니다. 그 후 [ActivityResultContract.SynchronousResult(context, input)](https://www.google.com/search?client=firefox-b-d&q=ActivityResultContract.SynchronousResult) 가 null인 경우 [ActivityResultRegistry#dispatchResult(int, int, Intent)](https://developer.android.com/reference/androidx/activity/result/ActivityResultRegistry#dispatchResult(int, int, android.content.Intent)) 를 호출하여 결과를 전달합니다. null 인 경우에는 기존과 동일하게 [requestPermissions()](https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String%5B%5D,%20int)) / [startActivityForResult()](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) 을 처리합니다.

> 현재 AndroidX에서 [ActivityResultContract.SynchronousResult](https://www.google.com/search?client=firefox-b-d&q=ActivityResultContract.SynchronousResult) 를 NonNull로 반환하는 케이스는 Permission을 체크하는 경우입니다.

### ActivityResultContracts

[ActivityResultContracts.RequestPermission](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.RequestPermission#getSynchronousResult(android.content.Context,%20java.lang.String)) 의 경우, 기존 버전에는 없었던 코드로 사전 체크 방식을 확인할 수 있습니다. 반환 타입은 지금에는 무시해도 괜찮습니다. 코드에서 확인 가능한 부분은 input으로 넘겨온 `퍼미션이 유효한지 체크`하는 코드입니다.


```java
public final class ActivityResultContracts {
  ...
  public static final class RequestPermission extends ActivityResultContract<String, Boolean> {
    @Override
    public @Nullable SynchronousResult<Boolean> getSynchronousResult(
           @NonNull Context context, @Nullable String input) {
      if (input == null) {
        return new SynchronousResult<>(false);
      } else if (ContextCompat.checkSelfPermission(context, input)
              == PackageManager.PERMISSION_GRANTED) {
        return new SynchronousResult<>(true);
      } else {
        return null;
      }
    }
  }
  ...
}
```

AndroidX 내부 코드를 사용하지 않고서 직접 [ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 를 커스텀하는 경우 권한 혹은 Intent 요청 전 `사전에 처리가 가능한 경우`에는 위 함수를 제대로 구현할 필요가 있습니다.

### ActivityResultContract

[ActivityResultContract](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract) 내부에 추가된 코드들은 매우 간단합니다. 앞서 설명한 대로 [getSynchronousResult(context, input)](https://www.google.com/search?client=firefox-b-d&q=ActivityResultContract.SynchronousResult) 함수를 통해서 사전 처리하는 함수입니다.

```java
public abstract class ActivityResultContract<I, O> {
  public @Nullable SynchronousResult<O> getSynchronousResult(
         @NonNull Context context,
         @SuppressLint("UnknownNullness") I input) {
    return null;
  }

  public static final class SynchronousResult<T> {
    private final @SuppressLint("UnknownNullness") T mValue;

    public SynchronousResult(@SuppressLint("UnknownNullness") T value) {
      this.mValue = value;
    }

    public @SuppressLint("UnknownNullness") T getValue() {
      return mValue;
    }
  }
}
```

또한 [getSynchronousResult(context, input)](https://www.google.com/search?client=firefox-b-d&q=ActivityResultContract.SynchronousResult) 의 결과로 [ActivityResultContract.SynchronousResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContract.SynchronousResult) 타입을 전달합니다. 이 타입은 단순 결과 타입을 랩핑한 Class입니다.

아주 작은 변화이지만 실제로 내부는 어떻게 변경이 되었는지 파악을 해봤습니다. 다음으로는 Common 형태로 제공되는 [ActivityResultContracts](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts) 의 변경을 살펴보겠습니다.

------

## Update ActivityResultContracts

- (Delete) Dial : `Intent.ACTION_DIAL` 으로 전화 요청을 할 수 있지만, 해당 Intent Action은 Result를 반환하지 않으므로 제거되었습니다.
- (Add) TakePicturePreview (MediaStore.ACTION_IMAGE_CAPTURE)

```java
new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
```

- (Update) TakePicture (MediaStore.ACTION_IMAGE_CAPTURE)

```java
new Intent(MediaStore.ACTION_IMAGE_CAPTURE)
  .putExtra(MediaStore.EXTRA_OUTPUT, input);
```

- (Add) TakeVideo (MediaStore.ACTION_VIDEO_CAPTURE)

```java
new Intent(MediaStore.ACTION_VIDEO_CAPTURE)
  .putExtra(MediaStore.EXTRA_OUTPUT, input);
```

- (Add) PickContact (Intent.ACTION_PICK)

```java
new Intent(Intent.ACTION_PICK)
  .setType(ContactsContract.Contacts.CONTENT_TYPE);
```

- (Add) Email (Intent.ACTION_SEND_MULTIPLE or Intent.ACTION_SEND)
  - Activity-Alpha02 이후에 추가되었지만, `Dial`과 동일하게 Result 미반환이라는 이유로 빛을 보지 못하고 사라진 타입입니다.
- (Add) GetContent (Intent.ACTION_GET_CONTENT)

```java
new Intent(Intent.ACTION_GET_CONTENT)
  .addCategory(Intent.CATEGORY_OPENABLE)
  .setType(input);
```

- (Add) GetContents (Intent.ACTION_GET_CONTENT)

```java
new Intent(Intent.ACTION_GET_CONTENT)
  .addCategory(Intent.CATEGORY_OPENABLE)
  .setType(input)
  .putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
```

- (Add) OpenDocument (Intent.ACTION_OPEN_DOCUMENT)

```java
new Intent(Intent.ACTION_OPEN_DOCUMENT)
  .putExtra(Intent.EXTRA_MIME_TYPES, input)
  .setType("*/*")
```

- (Add) OpenDocuments (Intent.ACTION_OPEN_DOCUMENT)

```java
new Intent(Intent.ACTION_OPEN_DOCUMENT)
  .putExtra(Intent.EXTRA_MIME_TYPES, input)
  .putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
  .setType("*/*");
```

- (Add) OpenDocumentTree (Intent.ACTION_OPEN_DOCUMENT_TREE)

```java
Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
        && input != null) {
    intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, input);
}
```

- (Add) CreateDocument (Intent.ACTION_CREATE_DOCUMENT)

```java
new Intent(Intent.ACTION_CREATE_DOCUMENT)
  .setType("*/*")
  .putExtra(Intent.EXTRA_TITLE, input);
```
