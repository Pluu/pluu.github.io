---
layout: post
title: "새로운 API ActivityResultContract로 Migration"
date: 2020-05-01 18:00:00 +09:00
tag: [Android, AndroidX, ActivityResultRegistry]
categories:
- blog
- Android
---

최근 androidx의 업데이트로 activity/fragment의 변화는 조금씩 다가오고 있습니다. 그중 눈에 띄는 변화 중 하나는 Activity Result 관련 API 들의 사용입니다. 

<!--more-->

## 서론

Activity Result를 처리하는 ActivityResultContract API는 `activity:1.2.0-alpha02`, `fragment:1.3.0-alpha02` 부터 도입되었습니다. 또한, `activity:1.2.0-alpha04`, `fragment:1.3.0-alpha04` 에서 Activity Result를 요청/수신하기 위한 주요 API가 Deprecated 되었습니다. 

본 글에서는 아직은 알파 버전이지만, 정식 버전을 대비해서 기존 API를 마이그레이션하는 방법을 알아보겠습니다.

> 2020년 5월 1일 시점 ActivityResultContract는 Alpha API이므로 프로덕션 사용에는 신중을 기울여주세요.

### 전제조건

```groovy
implementation 'androidx.activity:activity-ktx:1.2.0-alpha04'
implementation 'androidx.fragment:fragment-ktx:1.3.0-alpha04'
```

본 글에서는 Kotlin으로 작성되었습니다.

### Deprecated APIs

먼저 이번 업데이트를 통해서 Deprecated 된 API는 아래와 같습니다.

|                              | ComponentActivity | FragmentActivity                 | Fragment    |
| ---------------------------- | ----------------- | -------------------------------- | ----------- |
| startActivityForResult()     | @Deprecated       | @SuppressWarnings("deprecation") | @Deprecated |
| onActivityResult()           | @Deprecated       | @SuppressWarnings("deprecation") | @Deprecated |
| requestPermissions()         | -                 | -                                | @Deprecated |
| onRequestPermissionsResult() | @Deprecated       | @SuppressWarnings("deprecation") | @Deprecated |

> [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity) 는 [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity), [AppCompatActivity](https://developer.android.com/reference/androidx/appcompat/app/AppCompatActivity) 의 부모 클래스입니다.

> ComponentActivity
>
> __ㄴ FragmentActivity
>
> ____ㄴ AppCompatActivity

ComponentActivity에는 Permission 관련 함수가 이미 Deprecated 되었지만, FragmentActivity는 `@SuppressWarnings("deprecation")` 처리가 되어있어 Kotlin에서는 제대로 표시되나 Java에서는 Deprecated 가 렌더링 안되는 부분도 있습니다.

위에서 언급한 API는 지금도 활발히 사용하고 있는 API입니다. 그러니 더욱더 `Deprecated` 되었다는 것에 눈을 의심하실 수 있습니다. 하지만, 현재 시점에서는 사실입니다. 

------

위 4가지의 API는 2가지의 패턴으로 나눌 수 있습니다. 

- Activity Result : startActivityForResult(), onActivityResult()
- Permission : requestPermissions(), onRequestPermissionsResult()

지금부터 이 2가지를 마이그레이션 하는 방법을 살펴보겠습니다.

## Migration ActivityResult

Activity에는 ResultCode 및 Intent로 데이터를 담아서 자신을 호출한 화면으로 데이터를 전달할 수 있습니다.

### Activity

#### 기존 스타일

```kotlin
class OldActivityResultSampleActivity : AppCompatActivity() {
  private val request_second_code = 100

  private fun startSecondView() {
    val intent = Intent(/** context */, ResultSecondActivity::class.java)
    startActivityForResult(intent, request_second_code) // ◀ Deprecated
  }
  
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data) // ◀ Deprecated
    if (requestCode == request_second_code) {
      // action to do something
    }
  }
}
```

기존 스타일에서는 Activity로부터 데이터를 전달받기 위해서는 [startActivityForResult(Intent, Int)](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) 함수를 이용해서 새로운 화면을 호출합니다. 그 후 [onActivityResult(int, int, Intent)](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 함수로부터 넘어온 데이터를 처리하면 됩니다. 여기서 필연적으로 Request Code의 정의는 필수입니다.

#### New API

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

class ActivityResultSampleActivity : AppCompatActivity() {
  val requestActivity: ActivityResultLauncher<Intent> = registerForActivityResult(
    StartActivityForResult() // ◀ StartActivityForResult 처리를 담당
  ) { activityResult ->
	  // action to do something
  }
  
  private fun startSecondView() {
    val intent = Intent(/** context */, ResultSecondActivity::class.java)
    requestActivity.launch(intent)
  }
}
```

새로운 표기법에서는 Intent를 작성하는 방법은 동일합니다. 큰 차이점은 [startActivityForResult(Intent, Int)](https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int)) 함수를 호출하지 않습니다. 

먼저 [registerForActivityResult()](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller#registerForActivityResult(androidx.activity.result.contract.ActivityResultContract, androidx.activity.result.ActivityResultCallback)) API를 정의하며, 파라매터로 전달하는 [ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) 을 사용하여 기존 [onActivityResult(int, int, Intent)](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) 와 동일한 결과를 처리합니다. 또한, 리턴되는 [ActivityResultLauncher](https://developer.android.com/reference/androidx/activity/result/ActivityResultLauncher) 를 사용하여 Intent 전달로 새로운 Activity를 호출합니다.

> [ActivityResultContracts.StartActivityForResult](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.StartActivityForResult) Document

#### ActivityResult Class

[ActivityResultCallback](https://developer.android.com/reference/androidx/activity/result/ActivityResultCallback) 으로 전달되는 데이터는 [ActivityResult](https://developer.android.com/reference/androidx/activity/result/ActivityResult) 타입입니다. 내부 구현은 다음과 같습니다.

```java
public final class ActivityResult implements Parcelable {
  private final int mResultCode;
  @Nullable
  private final Intent mData;

  public ActivityResult(int resultCode, @Nullable Intent data) {
    mResultCode = resultCode;
    mData = data;
  }
  ...
}
```

클래스에 포함된 내용은 `resultCode`와 `Intent`입니다. 기존 [onActivityResult(int, int, Intent)](https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent)) API에서 존재하던 requestCode는 제외되었습니다. 각 Request 마다의 처리를 콜백으로 전달하므로 필요한 결과 부분만 전달하는 형태로 변경되었습니다.

> 자세한 처리에 대한 내용은 이전 글을 참고해주세요. 
>
> [Blog Post ~ New ActivityResultRegistry](http://pluu.github.io/blog/android/2020/03/24/activity-result/)

### Fragment

#### 기존 스타일

```kotlin
class OldActivityResultSampleFragment : Fragment() {
  private val request_second_code = 100
 
  private fun startSecondView() {
    val intent = Intent(/** context */, ResultSecondActivity::class.java)
    startActivityForResult(intent, request_second_code) // ◀ Deprecated
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data) // ◀ Deprecated
    if (requestCode == request_second_code) {
      // action to do something
    }
  }
}
```

Fragment는 Activity와 동일하게 [startActivityForResult(Intent, Int)](https://developer.android.com/reference/androidx/fragment/app/Fragment#startActivityForResult(android.content.Intent,%20int)) , [onActivityResult(int, int, Intent)](https://developer.android.com/reference/androidx/fragment/app/Fragment#onActivityResult(int, int, android.content.Intent)) API 가 Deprecated 되었습니다.

#### New API

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*

class ActivityResultSampleFragment : Fragment() {
  val requestActivity = registerForActivityResult(
    StartActivityForResult()
  ) { activityResult ->
    // action to do something
  }
  
  private fun startSecondView() {
    val intent = Intent(/** context */, ResultSecondActivity::class.java)
    requestActivity.launch(intent)
  }
}
```

Fragment에서 새로운 API의 사용법은 Activity와 동일합니다.

## Migration Permissions

### Activity

#### 기존 스타일

```kotlin
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

class OldActivityResultSampleActivity : AppCompatActivity() {
  private val request_location_code = 101

  private fun requestLocation() {
    val permission = Manifest.permission.ACCESS_FINE_LOCATION
    if (checkPermissions(permission)) {
      // Permission granted
    } else {
      requestPermissions(arrayOf(permission), request_location_code)
    }
  }

  private fun checkPermissions(vararg permissions: String): Boolean {
    return permissions.all { permission ->
      ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }
  }
  
  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == request_location_code) {
      if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
        // Permission grantd
      } else {
        // Permission denied or canceled
      }
    }
  }
}
```

위 코드는 위치 취득을 위해서 `ACCESS_FINE_LOCATION` 퍼미션을 처리하는 코드입니다. 이미 권한이 허용되었는지 체크하며, 미 허용시에는 권한 요청 후 결과 응답까지의 코드입니다. 퍼미션 처리로 기본적인 사용 방법입니다.

AppCompatActivity의 부모 클래스인 Activity에서 `requestPermissions` 함수가 정의되어 있어 deprecated 표시가 되지 않습니다. 또한 `onRequestPermissionsResult` 함수는 `@SuppressWarnings("deprecation")` 정의로 deprecated 표시가 되지 않습니다.

#### New API

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*
import androidx.activity.registerForActivityResult // ◀ activity-ktx

class ActivityResultSampleActivity : AppCompatActivity() {
  val requestLocation: () -> Unit = registerForActivityResult(
    RequestPermission(), ACCESS_FINE_LOCATION // ◀ 퍼미션 요청 + ACCESS_FINE_LOCATION 지정
  ) { isGranted ->
    // action to do something
  }

  private fun requestLocationAction() {
    requestLocation()
  }
}
```

새로운 ActivityResultContract API에서는 기존 코드보다 매우 심플한 코드를 볼 수 있습니다. 기존 Activity 호출 시 사용했던 패턴과 동일한 모습을 볼 수 있습니다.

Activity 호출과 다른 점은 [registerForActivityResult()](https://developer.android.com/reference/androidx/activity/result/ActivityResultCaller#registerForActivityResult(androidx.activity.result.contract.ActivityResultContract, androidx.activity.result.ActivityResultCallback)) API로 전달되는 데이터가 [ActivityResultContracts.RequestPermission](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.RequestPermission)과 요청할 타입으로 `ACCESS_FINE_LOCATION`을 전달하는 부분입니다.

> [ActivityResultContracts.RequestPermission](https://developer.android.com/reference/androidx/activity/result/contract/ActivityResultContracts.RequestPermission) Document

### Fragment

#### 기존 스타일

```kotlin
class OldActivityResultSampleFragment : Fragment() {
  private val request_location_code = 101

  private fun requestLocation() {
    val permission = Manifest.permission.ACCESS_FINE_LOCATION
    if (checkPermissions(permission)) {
      // Permission grantd
    } else {
      requestPermissions(arrayOf(permission), request_location_code) // ◀ Deprecated
    }
  }

  private fun checkPermissions(vararg permissions: String): Boolean {
    return permissions.all { permission ->
      ContextCompat.checkSelfPermission(
        requireContext(), permission
      ) == PackageManager.PERMISSION_GRANTED
    }
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults) // ◀ Deprecated
    if (requestCode == request_location_code) {
      if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
        // Permission grantd
      } else {
        // Permission denied or canceled
      }
    }
  }
}
```

기존 Activity와 동일하게 권한 요청의 흐름은 동일합니다. 

다른 점은 Fragment에 정의된 [requestPermissions(String[], int)](https://developer.android.com/reference/androidx/fragment/app/Fragment#requestPermissions(java.lang.String[],%20int)) 과 [onRequestPermissionsResult(int, String[], int[])](https://developer.android.com/reference/androidx/fragment/app/Fragment#onRequestPermissionsResult(int,%20java.lang.String[],%20int[])) 은 deprecated 되었습니다.

#### New API

```kotlin
import androidx.activity.result.contract.ActivityResultContracts.*
import androidx.activity.registerForActivityResult // ◀ activity-ktx

class ActivityResultSampleFragment : Fragment() {
  val requestLocation: () -> Unit = registerForActivityResult(
    RequestPermission(), ACCESS_FINE_LOCATION // ◀ 퍼미션 요청 + ACCESS_FINE_LOCATION 지정
  ) { isGranted ->
    // action to do something
  }

  private fun requestLocationAction() {
    requestLocation()
  }
}
```

호출하는 곳이 Fragment 것만 다를 뿐 새로운 ActivityResultContract API로 사용한 코드와 일치합니다.

## 정리

지금까지 새로운 API로 전환하는 방법을 살펴봤습니다. 이것으로 Acitivty 결과와 Permission 결과를 동일한 작성법 및 API로 사용할 수 있게 되었습니다. 

아직은 `알파 버전`이므로 정식 버전까지는 많은 시간이 남아있습니다. 계속적으로 업데이트되면서 어떤 형태로 API가 변경될지 기대되는 스펙입니다.

> 본 글을 위해서 샘플로 사용한 코드의 링크는 아래를 참고해주세요
>
> https://github.com/Pluu/ActivityResultSample

### 참고 사이트

Android Developers > Docs > Guides

- [Getting a result from an activity](https://developer.android.com/training/basics/intents/result)
