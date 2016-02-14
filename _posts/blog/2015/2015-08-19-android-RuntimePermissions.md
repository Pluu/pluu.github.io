---
layout: post
title: "[번역] 새로운 퍼미션 모델 대응을 조금 편하게하는 Snippet"
date: 2015-08-19 01:30:00
tag: [Android, Marshmallow, RuntimePermissions]
categories:
- blog
- Android
---
<!--more-->

이 포스팅은 [新しいパーミッションモデルの対応が少し楽になるスニペット](http://qiita.com/droibit/items/058842c0b996842417de) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

Android M부터 iOS와 같이 런타임시에 퍼미션을 확인하게 되었습니다.

기존 어플을 M 대응하기위해서는, 처리 전에 Permission Request 처리를 작성하지않으면 않되거나, 거부된 경우에도 적절히 동작시키지않으면 안되거나, 단순해보여도 작업내용이 꽤 있을것같네요.

Google Play Services를 사용하는 경우에는 Google이 대응해주지않으면, 라는 것도있지만, Android　API를 사용하는 부분은 M Preview2 SDK를 사용하여 동작확인을 할 수 있습니다.

대응과 관련있는 일본어 문서도 공개되어있습니다.

- [퍼미션-일본어](https://developer.android.com/intl/ja/preview/features/runtime-permissions.html)
- [퍼미션-한국어](https://developer.android.com/intl/ko/preview/features/runtime-permissions.html)

GitHub에 샘플도 공개되어 있습니다.

- [Android RuntimePermissions Sample](https://github.com/googlesamples/android-RuntimePermissions)

이런것들의 정보를 기준으로 정식공개전에 조금씩 대응하면 좋을듯합니다.

(대응하지않으면, 권한을 거부되었을때에 최악으로는 어플이 강제종료될 가능성도 있습니다.)

### 대응 포인트

런타임 퍼미션에 대응하는데 포인트는 다음 2가지가 있습니다.

1. 퍼미션 그룹에 속하는 퍼미션이 필요한 처리전에, 코드 상에 Permission Request를 추가
2. Request 결과의 허가/거부에 대해서 적절히 처리

퍼미션 그룹에는 무엇이 있는가, 그룹 안에는 어느 퍼미션이 있는가, 어떻게 Request 하는가, 등등의 내용은 상기 문서에 정리되어있습니다.

간단하지만, 소스 코드상의 흐름은 다음과 같습니다.


```java
public class SampleActivity extends Activity {

    private static final int REQUEST_CAMERA = 0;

    // 1. permission Request
    public void requestCameraPermission() {
        // 카메라를 사용하는 권한 유무
        if (checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            // 카메라 표시
            return;
        }
        // 카메라 사용이 허가되지않은 경우
        if (shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)) {
            // 추가 설명이 필요한 경우의 대응 (샘플에는 Toast가 표시됩니다)
        }
        // CAMERA Permission Request (한번에 복수 퍼미션을 Request 하는것도 가능)
        requestPermissions(new String[]{Manifest.permission.CAMERA}, REQUEST_CAMERA);
    }

    // 2. Request Result 를 수신
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode != REQUEST_CAMERA) {
            return;
        }

        // 카메라 퍼미션 사용이 허가된 경우
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            // 카메라 표시
            return;
        }
        // 사용이 거부된 경우의 대응
    }
}
```

#### 유틸리티 도입

앞으로 대응하는데 있어서, Google로부터 공개된 샘플을 기반으로 이후에도 사용할것같은 부분을 공통화해봤습니다. 소스 코드는 Gist에 있습니다.

- [Gist](https://gist.github.com/droibit/3dfa39dc8be3017dc37c)

#### 사용방법

유틸리티를 사용해도 큰 변화는 없지만, 가독성 향상, 하위호환 (정식판 릴리스에 수정될지도) 에 대응하고 있습니다.


```java
import static com.example.android.Permission.hasSelfPermission;
import static com.example.android.Permission.requestAllPermissions;
import static com.example.android.Permission.asArray;

public class SampleActivity extends Activity {

    private static final int REQUEST_CAMERA = 0;

    // 1. Permission Request
    public void requestCameraPermission() {
        // 카메라를 사용하는 권한 유무
        if (Permission.hasGranted(Permission.CAMERA)) {
            // 카메라 표시
            return;
        }
        // 카메라 사용이 허가되지않은 경우
        if (shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)) {
            // 추가 설명이 필요한 경우의 대응 (샘플에는 Toast가 표시됩니다)
        }
        // CAMERA Permission Request (한번에 복수 퍼미션을 Request 하는것도 가능)
        requestAllPermissions(this, asArray(Permission.CAMERA), REQUEST_CAMERA);
        // 복수의 경우
        // requestAllPermissions(this, asArray(Permission.CAMERA, Permission.READ_CONTACTS), -1);
    }

    // 2. Request Result 를 수신
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode != REQUEST_CAMERA) {
            return;
        }

        // CAMERA Permission 사용 허가
        if (!Permission.hasGranted(grantResults[0])) {
            // 카메라 표시
            return;
        }
        // 복수를 동시에 확이할 경우
        // if (Permission.hasGranted(grantResults) {
        // }

        // 사용이 거부된 경우의 대응
    }
}
```

런타임 퍼미션의 대응이 필요한 퍼미션이 무엇인가 헤매지않도록, 필요한 것만 뽑아서 정리했습니다.

유틸리티 클래스로 해두는편이 편리할것 같아서 정리했습니다.

퍼미션 대응이 거부된 경우에 어떻게 할것인가, 이쪽이 메인이 될거라고 생각되지만, 그 이외의 부분이 조금이라도 편해졌으면 합니다.

### P.S

하위호환으로 제1 변수에 Context 를 전달하지않으면 않된다고 생각하신 분은, Kotlin이라면 확장함수로 괜찮은 느낌으로 작성할 수 있습니다.


```java
public fun Context.hasSelfPermission(permission: String): Boolean
    = Permission.hasSelfPermission(this, permission)
public fun Context.hasSelfPermissions(permissions: Array<String>): Boolean
    = Permission.hasSelfPermissions(this, permissions)
```

사용방법은 다음과 같습니다.


```java
public class TestActivity: Activity() {

    companion object {
        val REQUEST_CODE = 0
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode != REQUEST_CODE) {
            return;
        }

        if (hasSelfPermissions(arrayOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION))) {
        }
//        if (hasSelfPermission(Permission.ACCESS_COARSE_LOCATION)) {
//        }
    }

    private fun requestPermission() {
      // Permission#asArray는 내부 arrayOf 함수가 있으므로 사용하지않음
      requestPermissions(arrayOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION), REQUEST_CODE)
    }
```

이상입니다.
