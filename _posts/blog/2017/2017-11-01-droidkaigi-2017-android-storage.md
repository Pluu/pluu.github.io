---
layout: post
title: "[번역] DroidKaigi 2017 ~ Android 앱 저장소 전략"
date: 2017-11-01 00:50:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ Androidアプリのストレージ戦略](https://www.slideshare.net/mhidaka/android-73008326) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Android 앱 저장소 전략

~ Android에서 SD 카드 사용할 수 있죠? ~

## 2p

@mihidaka

## 3p

SD Card

## 4p

SD 카드는 개념

## 5p, 사용자가 생각하는 SD 카드

- 들고 다닐 수 있다
- 바꿀 수 있다
- 확장할 수 있다

> 완벽하네

## 6p, 개발자가 생각하는 SD 카드

- 없을 때가 있다
- 파일을 바꿀 수 있다 
- 누군가가 바꿔칠 수 있다

> 지옥이네

## 7p 

갭을 줄여보자

> 과연 줄여질까

## 8p, Goal

- Android 저장소 제약을 이해한다
- 제약과 기능 요건의 균형을 생각한다

> 이거라면 될 것 같다

## 9p ~ 10p

android one

## 11p, SDK 카드를 내부 저장소로

- Marshmallow의 신기능
- Android One에서 유효화

> 위험하다

## 12p, Keywords

- 내부 저장소
- 외부 저장소
- 확장 저장소

> 추후에 설명합니다

## 13p, Keywords

- Permission
- Multi User
- Storage Access Framework
- Scoped Directory Access

> 어려워 보인다

## 14p

Android 저장소의 진화

## 15p, Q, SD 카드를 사용하면 대용량 앱이 가능해집니까?

하지 않는 편이 좋습니다. Export / Import라면 선택지의 하나로 생각해도 좋습니다.

> 독자로부터의 편지

## 16p, Standard Strategy

```
<manifest
   xmlns:android="http://schemas.android.com/apk/res/android"
   android:installLocation="internalOnly"
   ... >
```

내부 저장소에 설치를 추천 (디폴트값) 

※ API Level 8이 그리운 페이지입니다.

## 17p, Standard Strategy

외부 저장소에 설치하면 다음 기능은 동작하지 않고, 지금은 누구도 하고 있지 않습니다.

```
- Service
- Alarm Service
- IME
- Account Manager
- Sync Adapters
- Device Administrators
- listening for "boot completed"
```

## 18p, Q. 그러면 캐시 데이터가 적합하다고 들었는데, SD 카드를 사용해도 됩니까?

캐시로는 사용하지 않는다

> 다른 방법이 있다

## 19p, Standard Strategy

내부 저장소에 여유가 있는 앱 캐시는 스스로 관리

하지만 캐시를 삭제하는 앱이 적고, 내부 저장소를 압박하는 일이 많다

## 20p, Q. 무슨 일이 있어도 외부 저장소를 쓰고 싶습니다. SD 카드에 접근은 이렇게 합니까?

```
/sdcard
/mnt/sdcard
/mnt/sdcard/external_sd
/storage/sdcard0
```

> 목가적 (牧歌的)

## 21p ~ 22p, Standard Strategy

Android 4.4 이후, 외부 저장소 이용방법이 변경되었습니다.

Storage Access Framework

## 23p, 파일 표현의 추상화

DocumentsProvider : 외부 저장소이나 온라인 등 저장소를 추상화한다

> Dropbox이라던가 Google Drive라던가

## 24p

<img src="https://developer.android.com/images/providers/storage_dataflow.png?hl=ko" />

## 25p, Standard Strategy

파일을 만든다

```
private void createNewFile() {
   Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
   intent.setType("text/plain");
   intent.putExtra(Intent.EXTRA_TITLE, "Untitled.txt");
   startActivityForResult(intent, CREATE_DOCUMENT_REQUEST);
}
```

## 26p, Standard Strategy

쓰기

```
private void save(Uri uri, String text) throws FileNotFoundException, IOException {
   OutputStream outputStream = null;
   try {
      outputStream = getContentResolver().openOutputStream(uri);
      BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
      writer.write(text);
      writer.flush();
   } finally {
   	  IOUtil.forceClose(outputStream);
   }
}
```

## 27p, Q. 왜 외부 저장소 접근이 추상화되었습니까?

다중 사용자 대응을 위해 지금과 같은 권한 제어로는 한계가 왔다

> Android 4.4부터 도입

## 28p, Permission 제어 변화

파일 접근 제어부터 피커에서 사용자 권한에

제공자 쪽은 DocumentProvider를 통해 저장소에 접근을 허가 & 쓰기를 한다

## 29p, WRITE_EXTERNAL_STORAGE

Android 4.1에서 추가

이 권한의 적용 범위에 포터블한 외부 저장소를 포함하지 않는다 (4.4~ 적용)

## 30p, 다중 사용자의 보안

전통적인 Mount Point로 접근 제한으로는 다중 사용자 대응에 한계 (앱 데이터를 지킬 수 없다)

다중 사용자의 저장소 구성

```
root(/) → storage / emulated/0
root(/) → storage / emulated/10
```

사용자마다 `/storage/emulated/id/`는 독립 다운로드 데이터도 공유할 수 없다

## 31p, Android 저장소 전략

- 내부 저장소 : 앱용, 기본적으로 은폐
- 확장 저장소 : 디바이스의 첫 번째 저장소
- 외부 저장소 : 빼고 집어넣을 수 있는 포터블 저장소 

> 그렇군 모르겠다

## 32p, 내부 저장소

접근 관리를 강화. 애플리케이션 영역마다 접근 권한을 설정

다른 사용자, 앱에서는 볼 수 없다

> 커맨드 실행도 제한

## 33p, 확장 저장소

다중 사용자 대응에 있어서, 사용자마다 독립된 확장 저장소가 필요하게 되었다.

지금까지는 단일 사용자를 위해 파일 구조가 보여도 문제없었다. 현재는 PC 접속시에 USB 디바이스 (MTP)로 표시.

음악이나 동영상, 사진, 데이터를 둔다. 디바이스의 첫 번째 저장소

> WRITE_EXTERNAL_STORAGE 적용 범위

## 34p, 외부 저장소

디바이스의 두 번째 저장소. 기본적으로는 USB 메모리 같은 포터블 저장소가 대상.

접근은 제한. Storage Access Framework 경유로만 허가

> 비밀 데이터는 둘 수 없다

## 35p, Q. 확장 저장소라는 구분은 왜 필요합니까?

A. 제품과 동일하게 생명주기의 기억 메모리 (배터리의 뒤에 있는 SD 카드)에 대응하기 때문입니다.

## 36p, Standard Strategy

Android 4.4~에서는 복수 확장 저장소에 대응

```
Context.getExternalFilesDirs()
Context.getExternalCacheDirs()
Context.getObbDirs()
```

## 37p, Standard Strategy

Android 6.0~에서는 USB 미디어 지원도 시작

Storage Access Framework로 제어 가능 (외부 저장서로서)

## 38p, SD 카드의 내부 저장소화

외부 저장소를 외부 저장소로 사용할 수 있다

## 39p, SD 카드 (외부 저장소인채로)

포터블 가능한 외부 저장소로써 사용하고 싶은 경우는 Storage Access Framework 경우로 접근

```
쓰기는 제어된다
```

## 40p ~ 41p, SD 카드의 내부 저장소화

배터리 팩의 안쪽이나 SIM과 동일하게 넣고 빼고 집어넣는 것을 고려하지 않는 SD 카드는 내부 저장소로서 다룰 수 있다

암호화 및 포맷되고 제품의 생명 주기에 들어가는 대신 내부 저장소로서 쓸 수 있다 (앱 설치 가능)

포맷은 ext4, f2fs

> SD 카드를 너무 좋아하는거 아닌가...

## 43p, What's New in Android 7.0

- FileSystem 퍼미션 변경
- 앱간의 파일 공유 변경
- Scoped Directory Access

## 44p, Standard Strategy

앱의 Private Directory에 접근 제한 (700)을 추가

- 소유자에게도 느슨하지 않다
- MODE_WORLD_READBLE이나 MODE_WORLD_WRITEBLE을 사용하면 SecurityException이 발생

## 45p, Standard Strategy

자신의 앱 밖으로 file://URI 공개를 금지하는 StrictMode가 적용

파일 URI를 포함하는 Intent는 FileUriExposedException이 된다

FileProvider로 회피

## 46p ~ 47p, Scoped Directory Access

디렉토리를 직접 호출

```
StorageManager sm = (StorageManager) getSystemService (Context.STORAGE_SERVICE);
StorageVolume volume = sm.getPrimaryStorageVolume();
Intent intent = volume.createaccessIntent(Environment.DIRECTORY_PICTURES);
startActivityForResult(intent, request_code);
```

> similar to using URIs returned by the Storage Access Framework

## 48p, 정리

## 49p, Q. 즉 무엇을 의미합니까?

|   | 내부 | 확장 | 외부 |
| :-- | :-- | :-- | :-- |
| 포맷 | Ext4, f2fx | Ext4, f2fx | exFAT 등 |
| 접근 | File IO | File IO | Storage Access Framework |
| 앱에서 본 공개 | private | private / public | public |
| 다중 사용자 대응 | OK | OK | NG |

> 대충

## 50p, Q. 백업 용도로 SD 카드는 괜찮습니까?

양날의 검입니다. 작게는 SharedPreferences으로 Backup 옵션을 사용하면 편합니다. 서버가 있으면 인터넷의 건너편도 편하지만 기본적으로 앱 이외에서 동일한 고생을 하는 것과 다름없습니다

> 선택지는 많다

## 51p, Q. SD 카드의 마운트 상태는 알 수 있습니까?

Environment 에 API가 있습니다. 결국 파일 제어이므로 R/W의 에러 핸들링을 제대로 하면 좋습니다

> 신뢰성은 낮다

## 52p, Q. USB 메모리에도 앱에서 접근하고 싶습니다

앱 독자적으로 한다면 USB 호스트 기능을 사용해 이야기하는 느낌입니다 (파일 매니저도 필요하므로 무겁다)

> 외부 저장소

## 53p, Thank you!

공식 앱에서 세션 피드백을 기다리고 있습니다

@mhidaka