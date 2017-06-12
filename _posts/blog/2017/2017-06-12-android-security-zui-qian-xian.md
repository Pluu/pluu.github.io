---
layout: post
title: "[번역] DroidKaigi 2017 ~ Android Security 최전선"
date: 2017-06-12 10:15:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ Android Security 最前線](https://speakerdeck.com/yanokuro/android-security-zui-qian-xian) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다. 일부 이미지는 원작자의 슬라이드의 일부 화면을 캡쳐한 이미지입니다.

<!--more-->

## 1p Android Security 최전선 

Naoki Yano

## 2p Naoki Yano

YAHOO 주식회사 GAYO 주식회사

Android Framework / Application / CTS / Driver Engineer

Android 경력 3년

관련 경력 2년

## 3p Android Security 최전선??

Android Nougat 에는 Security 관련 업데이트가 가득!!

- Using Scoped Directory Access
- Direct Boot
- Network Security Config
- Key Attestation
- APK Signature Scheme v2

> 언제든지 사용할 수 있도록 준비해 두는 것이 중요!!

## 4p Android N Security

`Using Scoped Directory Access`

`Direct Boot`

`Network Security Config`

Key Attestation

APK Signature Scheme v2

## 5p Using Scoped Directory Acces

Android 6.0 이전:

- Manifest에 Permission를 정의 + PermissionRequest
- 외부 스토리지 모두에 대한 접근을 허용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-01.png" }}" />

## 6p Using Scoped Directory Acces

Android 7.0 :

- 접근하려는 디렉토리의 StorageVolume을 만들고 Request를 던진다.
- 특정 디렉토리 접근만 허용한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-02.png" }}" />

## 7p Using Scoped Directory Acces

신규 API

- StorageVolume
   - 특정 사용자의 공유 / 외부 스토리지 볼륨에 대한 정보.
- createAccessIntent()
   - 사용자의 승인을 얻은 후, 표준 스토리지 디렉토리 또는 전체 볼륨에 대한 접근을 제공하기 위한 인 텐트를 생성한다.
- getState()
   - 스토리지 볼륨의 상태를 가져온다.

## 8p Using Scoped Directory Acces

신규 API

- StorageManager
   - 필요한 StorageVolume를 얻을 수 있다.
- getPrimaryStorageVolume()
- getStorageVolume(File)
- getStorageVolumes()

## 9p Using Scoped Directory Acces

```
// 권한이 필요한 storageVolume 취득
StorageManager sm = getSystemService(StorageManager.class);
StorageVolume sv = sm.getPrimaryStorageVolume();

// 사용자 승인을 얻기 위한 Intent를 생성
Intent i = sv.createAccessIntent(Environment.DIRECTORY_MUSIC);

// Intent를 StartActivityForResult에 던진다
startActivityForResult(i, REQUEST_CODE);
```

## 10p StorageVolume#createAccessIntent(String)

```
package android.os.storage;
public final class StorageVolume implements Parcelable {
…

    public @Nullable Intent createAccessIntent(String directoryName) {
        if ((isPrimary() && directoryName == null) || 
                (directoryName != null && !Environment.isStandardDirectory(directoryName))) {
            return null;
        }
        final Intent intent = new Intent(ACTION_OPEN_EXTERNAL_DIRECTORY);
        intent.putExtra(EXTRA_STORAGE_VOLUME, this);
        intent.putExtra(EXTRA_DIRECTORY_NAME, directoryName);
        return intent;
    }
```

## 11p StorageVolume#createAccessIntent(String)

```
package android.os;
public class Environment {
    public static final String[] STANDARD_DIRECTORIES = {
        DIRECTORY_MUSIC,
        DIRECTORY_PODCASTS,
        DIRECTORY_RINGTONES,
        DIRECTORY_ALARMS,
        DIRECTORY_NOTIFICATIONS,
        DIRECTORY_PICTURES,
        DIRECTORY_MOVIES,
        DIRECTORY_DOWNLOADS,
        DIRECTORY_DCIM,
        DIRECTORY_DOCUMENTS
    };
```

## 12p OpenExternalDirectoryActivity

```
package com.android.documentsui;
public class OpenExternalDirectoryActivity extends Activity {
…
    public void onCreate(Bundle savedInstanceState) {
        // 디렉토리가 지정되지 않은 경우 root 권한을 얻을
        String directoryName = intent.getStringExtra(EXTRA_DIRECTORY_NAME );
        if (directoryName == null) {
            directoryName = DIRECTORY_ROOT;
        }

        // 권한 미획득인지 확인
        final StorageVolume volume = (StorageVolume) storageVolume;
        if (getScopedAccessPermissionStatus(getApplicationContext(), getCallingPackage(),
                volume.getUuid(), directoryName) == PERMISSION_NEVER_ASK) {

        // 사용자 확인 Dialog 표시
        final int userId = UserHandle.myUserId();
        if (!showFragment(this, userId, volume, directoryName)) {
    }
```

## 13p Using Scoped Directory Access

```
@Override
public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == REQUEST_CODE
            && resultCode == Activity.RESULT_OK) {
        // 2번째 이후는 다이얼로그가 나오지 않도록 설정
        getActivity().getContentResolver().takePersistableUriPermission(data.getData(),
            Intent.FLAG_GRANT_READ_URI_PERMISSION | 　　　　
            Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        // read, write
        // data.getData()에 접근 권한을 얻은 디렉토리의 URI가 들어있다
    }
}
```

## 14p Using Scoped Directory Access

- 감상
  - 디렉토리마다 권한을 요구하는 것은, 사용 측면으로도 안심할 수 있다.
  - 기본 스토리지와 그 이외 API 사용법이 달라지므로 주의!

## 15p Direct Boot

Android 6.0 이전 :

- 단말기가 암호화되어있는 경우, 기존의 저장 위치는 사용자가 잠금을 해제한 후에만 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-03.png" }}" />

## 16p Direct Boot

Android 7.0 :

- 잠금 해제되지 않은 상태에서는 Direct Boot 모드로 동작한다. 단말기 암호화 스토리지에 접근할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-04.png" }}" />

## 17p Direct Boot

신규 API

- android : directBootAware
   - 구성 요소가 암호화를 지원하도록 지정한다.
- android.intent.action.LOCKED_BOOT_COMPLETED
   - 단말기 암호화 스토리지가 사용 가능하게 된 것을 통지한다.
- Context#createDeviceProtectedStorageContext()
   - 단말기 암호화 스토리지에 접근하기 위한 Context를 생성한다.

## 18p Direct Boot

```
// 구성 요소가 암호화를 지원하도록 Flag를 지정한다
<receiver android:name=".BootBroadcastReceiver"
    android:exported="false"
    android:directBootAware="true">

    <intent-filter>
        <action android:name="android.intent.action.LOCKED_BOOT_COMPLETED" />
        <action android:name="android.intent.action.BOOT_COMPLETED" />
    </intent-filter>
</receiver>
```

## 19p Direct Boot

```
// ProtectedStorage에 저장
final Context deviceContext = getApplicationContext().createDeviceProtectedStorageContext();

deviceContext.moveSharedPreferencesFrom(context, PREFERENCES_NAME));

SharedPreferences sp = deviceContext.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE);
```

## 20p Direct Boot

```
// LOCKED_BOOT_COMPLETED를 얻어 데이터를 얻는다
public void onReceive(Context context, Intent intent) {
    boolean bootCompleted;
    String action = intent.getAction();
    if (BuildCompat.isAtLeastN()) {
        bootCompleted = Intent.ACTION_LOCKED_BOOT_COMPLETED.equals(action);
    } else {
        bootCompleted = Intent.ACTION_BOOT_COMPLETED.equals(action);
    }
    if (!bootCompleted) {
        return;
    }
}
```

## 21p Direct Boot

Android 6.0 이전 :

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-05.png" }}" />

Android 7.0 :

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2017/2017-06-12-droidkaigi-06.png" }}" />

## 22p Direct Boot

```
ApplicationInfo ai = getApplicationInfo();
Log.i(TAG, “deviceProtectedDataDir: ” + ai.deviceProtectedDataDir);
# deviceProtectedDataDir: /data/user_de/0/com.yanokuro.directboot
```

## 23p Direct Boot

감상

- 단말 암호화 스토리지는 보안 수준이 떨어지기 때문에 무엇을 저장하거나 감시가 필요하다.
- BOOT_COMPLETE이 부르는 위치가 바뀌었다.

## 24p Network Security Config

Android 7.0 :

- 사용자 CA 인증서를 신뢰하는 안전하고 간단한 API를 제공. 
- 기본적으로 사용자가 추가한 CA를 신뢰하지 않는다.

## 25p Network Security Config

- res/xml/network_security_config 를 작성
- manifest에 추가

## 26p Network Security Config

```
<?xml version="1.0" encoding="utf-8"?>
<manifest ... >
    <application ... >
        <meta-data android:name="android.security.net.config"
            android:resource="@xml/network_security_config" />
    </application>
</manifest>
```

## 27p Network Security Config 사용 지정 인증 기관

```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config>
        <domain includeSubdomains="true">example.com</domain>
        <trust-anchors>
            <certificates src="@raw/my_ca"/>
        </trust-anchors>
    </domain-config>
</network-security-config>
```

## 28p Network Security Config 인증서 정의

```
<trust-anchors>
     // 앱이 가지고 있는 CA 인증서를 사용
    <certificates src="@raw/my_ca"/>
    
    // 시스템 기본 CA 인증서를 사용
    <certificates src="system"/>

    // 사용자가 추가한 CA 인증서를 사용
    <certificates src="user"/>
</trust-anchors>
```

## 29p Network Security Config 디버그용 debuggable=true

```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <debug-overrides>
        <trust-anchors>
            <certificates src="@raw/debug_ca"/>
        </trust-anchors>
    </debug-overrides>
</network-security-config>
```

## 30p Network Security Config 일반 텍스트 통신을 금지

```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config usesCleartextTraffic="false">
        <domain includeSubdomains="true">secure.example.com</domain>
    </domain-config>
</network-security-config>
```

## 31p Network Security Config 구성 파일

```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config>
    ...
    </base-config>
    <domain-config>
    ...
    </domain-config>
    <debug-overrides>
    ...
    </debug-overrides>
</network-security-config>
```

## 32p Network Security Config Android 7.0 default

```
<base-config usesCleartextTraffic="true">
    <trust-anchors>
        <certificates src="system" />
    </trust-anchors>
</base-config>
```

## 33p Network Security Config Android 7.0 미만

```
<base-config usesCleartextTraffic="true">
    <trust-anchors>
        <certificates src="system" />
        <certificates src="user" />
    </trust-anchors>
</base-config>
```

## 34p Network Security Config

감상

- 설정 앱에서 CA 넣을 필요가 없어 기쁘다.
- 7.0 이전에도 사용할 수 있으면 좋겠다.

## 35p 정리

각각 주의점은 있지만, 주의해서 사용하면 보다 안전한 앱을 만들 수 있겠어.

각 기능의 움직임을 제대로 이해하고 개발하자.