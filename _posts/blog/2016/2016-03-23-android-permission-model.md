---
layout: post
title: "[번역] DroidKaigi 2016 ~ Permission 모델의 과도기에 대응"
date: 2016-03-23 20:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [パーミッションモデルの過渡期への対応
](http://www.slideshare.net/ak_shio_555/ss-58412835) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

**Permission 모델의 과도기에 대응**

DroidKaigi 2016-03

2016/2/18

aki_sh_7

## 2p

**자기소개**

- aki_sh_7(塩田 明弘)
- 주식회사 NTT 데이터 소속
- 보안 비지니스 추진회 (2013/4~)
- 2014/4부터 사내 Android 어플 개발자용 보안 가이드라인 작성이나 지원일에 종사

## 3p

**목차**

1. Runtime Permission에 대해서
2. Android 5.1 이전 단말로 대응한 targetSDKversion=23의 어플 작성방법
3. targetSDKversion=23로 적용 불가능한 어플이 Android 6.0 미만에서 문제를 일으키지 않는 방법
4. 정리

## 4p

1. Runtime Permission에 대해서

## 5p

**Android6.0의 큰 변경점**

새로운 Permission 모델인 Runtime Permission 도입

## 6p

**이전의 Permission 모델**

- 설치 시에 허가 확인
  - 허가하고 싶지 않은 Permission이 있어도 사용하려면 허가할 수밖에 없다
- 설치 후에 취소 불가능
  - 한번 허가했다면 삭제하지 않으면 취소할 수 없다

## 7p

**Runtime Permission**

- 실행 시에 허가 확인
  - ProtectionLevel=dangerous만 해당
  - Permission Group 단위
  - 체크 등의 처리를 작성할 필요가 있다
  - 사용자가 "다시 묻지 않음"을 할 수도 있다(한번 거부가 필요)
- 설치 후에 취소 가능
  - 잘못해서 허가하여도 대응 가능
- Android 6.0에서도 targetSdkVersion<23이라면 Runtime Permission은 아니다

## 8p

**각 Model의 특징**

|  | ~Android5.1 | Android6.0~ (targetSdkVersion<23) | Android6.0~ (targetSdkVersion>=23) |
| :- | :- | :- | :- |
| Install | 허가 | 허가 | Dangerous이외 허가(확인없음) |
| Rumtime | - | - | 요구에 따라 허가 |
| Setting | - | Dangerous는 제한 가능 | Dangerous은 취소 가능 |

## 9p

**Permission이 필요한 API의 대응**

- 허가하지 않은 상태에서 API를 사용
  - 결과는 Permission Denial
  - 자동으로 요구처리를 해주지 않는다
- API 사용 전에 3가지의 처리가 필요
  - Step1. Check
  - Step2. Request
  - Step3. Handling

## 10p

**API 사용전에 간단한 FlowChart**

- 開始 : 시작
- 許可有り？ : 허가함?
- 過去に拒否した : 과거에 거부함
- 追加説明 : 추가 설명
- パーミッション要求 : Permission 요구
- 要求結果受け取り : 요구결과 받음
- 許可された？ : 허가되었다?
- 今後表示しない？ : 다시 표시하지 않는가?
- API使用 : API 사용
- 呼び出し不可表示 : 호출 불가능 표시
- 呼出し不可表示２ : 호출 불가능 표시2
- 終了 : 종료

> 차트를 수정하기 힘드므로 일률적으로 적어봅니다

## 11p

**Step1. 체크 처리**

- Permission 체크는 다음 API를 사용한다
  - context#checkSelfPermission(String permission_name)
    - 허가 : PERMISSION_GRANTED(=0)
    - 불허가 : PERMISSION_DENIED(=-1)

```
public void showContacts(View v){
  if (checkSelfPermission(Manifest.permission.READ_CONTACTS)
          != PackageManager.PERMISSION_GRANTED) {
    if(shouldShowRequestRermissionRationale(Manifest.permission.READ_CONTACTS)) {
        // Explain to the user why we need to read the contacts
    }
    //Popup등으로 요구에 대한 설명을 적는다
    requestPermissions(new String[]{Manifest.permission.READ_CONTACTS},
        MY_PERMISSIONS_REQUEST_READ_CONTACTS);
  }else{
    showContactsDetails(); // 이미 허가되어있는 경우의 처리
  }
}
```

복수 Permission을 체크하는 경우는 문자열 배열을 받아 for문 등으로 체크하는 Class를 만들어도 됩니다.

## 12p

**Step.2 Request 처리**

- Permission이 허가되어 있지 않다면, 다음 API로 요구한다
  - Activity#requestPermissions(String[] permissions, int requestCode)
    - Permission을 복수 지정한 경우, 그룹 수마다 요구 Dialog가 표시된다
    - requestCode를 설정하고 핸들링시의 케이스 처리로 사용

```
public void showContacts(View v){
  if (checkSelfPermission(Manifest.permission.READ_CONTACTS)
          != PackageManager.PERMISSION_GRANTED) {
    if(shouldShowRequestRermissionRationale(Manifest.permission.READ_CONTACTS)) {
        // Permission 필요성을 설명하기 위한 처리를 적는다
    }
    //Popup등으로 요구에 대한 설명을 적는다
    requestPermissions(new String[]{Manifest.permission.READ_CONTACTS},
        MY_PERMISSIONS_REQUEST_READ_CONTACTS);
  }else{
    showContactsDetails(); // 이미 허가되어있는 경우의 처리
  }
}
```

shouldShowRequestRermissionRationale(String permission)은 Permission이 과거에 Request를 거부하고 또한 "다시 묻지 않기"를 체크했는지를 확인할 수 있다

## 13p

**Step.3 Handling 처리**

- 다음 메소드로 Request 결과를 받는다
  - onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults)
    - 요청 시 각 Permission에 대한 결과를 배열 grantResults에 포함되어 있다

```
public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
  switch(requestCode) {
    casae MY_PERMISSIONS_REQUEST_READ_CONTACTS: {
      if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        showContactsDetails(); // 요청이 허가된 경우의 처리
      } else {
        if(shouldShowRequestRermissionRationale(Manifest.permission.READ_CONTACTS)) {
          // Permission이 허가되지 않은 경우의 처리를 적는다
        }else{
          // "다시 묻지 않기"를 설정했다면 그 부분의 처리로 온다
          // 어플 상세설정화면으로 Intent하는 버튼 표시등을 만들면 좋다
        }
      }
      return;
    }
    // 그 외의 RequestCode시의 동작
  }
}
```

Request에 대해서 허가되어있으면, PERMISSION_GRANTED(=0)가 포함되어 있다

## 14p

**언제 요청하면 좋은가**

- 최초 요청(튜토리얼)
  - 필수로 필요한 기능(이것만으로도 사용할 수 있다)
    - 카메라 어플에서 CAMERA 권한
    - 달력 어플에서 CALENDER 권한
- 실행 시에 요청
  - 어플이 가능한 것을 넓히는 기능
    - 메세지 어플에서 현재 위치 투고 → 현재 위치 버튼을 누를 때에 LOCATION 권한
  - 관계없는 곳에서 요구하면 불신감을 가져온다
    - 알아볼 수 있도록 디자인한다
- 애초에 요청하지 않는 선택지
  - 카메라로 촬영한 이미지가 필요하면, 카메라를 호출해서 촬영한다

## 15p

**설명은 어디까지 할 것인가**

- 최초 설명(튜토리얼)
  - 어플에서 권한이 필요하다고 생각하기 어려운 것
  - 실행 시에 요청 예고
    - SNS 어플 : 메세지 이외에 이미지 투고하는 경우는 허가가 필요
- 실행 중 설명
  - 요청하는 권한에 대한 설명. 여기에서 허가 여부에 따라 어플 전체의 영향을 설명한다.
  - 한번 거부했던 경우는 보다 상세하게
    - Activity#shouldShowRequestRermissionRationale
- 거부된 이후의 설명
  - 허가하지 않으면 기능을 사용할 수 없다는 것을 설명
  - "다시 묻지 않기" 체크한 경우, 어플 상세설정에서만 설정할 수 없다. 유도 버튼 등을 배치

## 16p

**대응의 효율성**

- Permission 허가가 필요한 API 전부에 실패 없이 처리를 적는 것은 어렵다
- 라이브러리(PermissionDispatcher) 사용
  - Annotation Processing을 사용하여 핸들링하는 Class를 작성
    - 조건 분기를 작성하지 않아도 된다!
    - 각 조건으로 처리하고 싶은 메소드에 Annotation을 부여하면 된다
      - @RuntimePermissions : Activity나 Fragment에 부여
      - @NeedPermission : Permission이 필요한 API를 사용하는 메소드에 부여
      - @OnShowRational : 한번 거부한 경우에 설명 등을 표시하는 메소드에 부여
      - @OnPermissionDenied : 거부된 경우에 처리하는 메소드에 부여
      - @OnNeverAskAgain : "다시 묻지 않기" 경우의 처리를 하는 메소드에 부여
    - 독자 Permission은 불가능

> [https://github.com/hotchemi/PermissionsDispatcher](https://github.com/hotchemi/PermissionsDispatcher)

## 17p

몇 명의 사람이 은혜를 받았는가?

## 18p ~ 19p

**Platform Versions(2016/1)**

> Dashboards, [http://developer.android.com/intl/ko/about/dashboards/index.html](http://developer.android.com/intl/ko/about/dashboards/index.html)

## 22p

**Android6.0.x Devices(NTT 도코모)**

3월 초순부터 순차적으로 업데이트 예정

[www.nttdocomo.co.jp/info/notice/page/160210_00_m.html](www.nttdocomo.co.jp/info/notice/page/160210_00_m.html)

## 23p

2 Android 5.1 이전 단말로 대응한 targetSDKversion=23의 어플 작성방법

## 24p

**Android 5.1 이전 단말 대응**

- 대응하는 Support Library 이용
  - Support Library v4
  - Support Library v13

| 체크 | context#checkSelfPermission | ContextCompat#checkSelfPermission, PermissionChecker#checkSelfPermission 조금 동작이 다르다 (추후 설명합니다) |
| 요청 | Activity#requestPermissions, Fragment#requestPermissions | Android 6.0 미만이면 콜백 API로 허가 완료(선언한 것)라면 Granted, 이외는 Denied로 전달된다. ActivityCompat#requestPermissions, FragmentCompat#requestPermissions
| 이외 | Activity#shouldShowRequestRermissionRationale, Fragment#shouldShowRequestRermissionRationale | Activity 6.0 미만에서 동작하면 항상 false. ActivityCompat#shouldShowRequestRermissionRationale, FragmentCompat#shouldShowRequestRermissionRationale |

## 25p

3 targetSDKversion=23로 적용 불가능한 어플이 Android 6.0 미만에서 문제를 일으키지 않는 방법

## 26p

**targetSdkVersion=23에서 불가능한 케이스(예)**

- 인력부족으로 전체 어플에 손을 쓸 수 없다
- 고객으로부터 개선 예산이 나오지 않는다
- targetSdkVersion을 올리면 다른 부분에서 버그가 나온다

## 27p

**재게, 새로운 Permission 모델 특징**

|  | ~Android5.1 | Android6.0~ (targetSdkVersion<23) | Android6.0~ (targetSdkVersion>=23) |
| :- | :- | :- | :- |
| Install | 허가 | 허가 | Dangerous 이외 허가 (확인 없음) |
| Rumtime | - | - | 요구에 따라 허가 |
| Setting | - | Dangerous는 제한 가능 | Dangerous은 취소 가능 |

제한 ≠ 취소

## 28p ~ 29p

**제한 ≠ 취소**

- 취소
  - Permission 허가 자체의 박탈
    - 파일 : `/data/system/user/{user_id}/runtime-permissions.xml`
    - 위에 적혀있는 것은 runtime-permissions의 대상이 되는 Permission만 해당. 그 외의 Permission은 /data/system/packages.xml에 쓰여진다
      - 허가 : granted="true"와 flags="0", 거부 : granted="false"와 flags="1"
      - Dialog를 표시하지 않는 경우 : granted="false"와 flags="2"
- 제한
  - Permission 허가는 남겨둔 채, 기능을 사용할 수 없도록 한다
    - 파일 : `/data/system/packages.xml`
      - 허가 : granted="true"와 flags="0", 제한 : granted="`true`"와 flags="8"
    - 제한은 Android 4.3 이후에 숨겨진 기능으로 존재하는 AppOps(의 변종판?)에 따른 처리를 한다

패키지 혹은 sharedUserId 마다 아래 형식으로 작성된다.

```
<item name="Permission 명칭" granted="true" flag="0">
```

## 30p

**제한 ≠ 취소**

- 취소 시와 제한 시에는 API를 사용했을 때의 응답이 다르다
  - 정보 취득으로 0이나 NULL가 반환된다
  - 변경이 포함된 API는 실제로는 이루어지지 않는다

어떤 대체 처리가 이루어져 실제로 API 사용 불가.

하지만, Expcetion이 발생해서 종료되는 것은 없다 (예외 : 카메라는 Expcetion이 발생)

## 31p

**대응예**

- targetSdkVersion=23으로 올릴 수 없는 이유나 이후 계획에 따라 대응방침이 결정한다

|  | 실행 허용 | 별도 처리 실행 | 실행 거부 |
| :- | :- | :- | :- |
| 개요 | 제한 상태의 응답에 맞춘 핸들링 | 제한상태에서는 API를 사용하지 않고, 대체처리를 실행 | 제한상태에서는 동작하지 않는다(해제를 요구) |
| 체크 | API 사용 후 | API 사용 전 | Activity 시작 · 재시작 |
| 가동 | 大 | 中 | 小 |

## 32p

**제한상태에서 실행을 허용하여 개선**

- 응답에 섬세한 대응이 필요
  - 정보취득시 에 Null이나 0가 반환될 때의 처리
    - 값을 이용한 처리, Null의 경우의 에러 처리를 검토
  - 제한상태의 응답 시에 해제요구 시행
    - `PermissionChecker#checkSelfPermission`를 사용해서 판단
    - SnackBar, Toast 등으로 자연스럽게 요구 · 설명
      - 최초에 허가되어 있으므로, 자신의 의지로 제한하고 있는가?

```
· ContextCompat#checkSelfPermission(Context context, String permission)
  허가한 경우는 "PERMISSION_GRANTED" 를 반환.
  허가하지 않은 경우는 "PERMISSION_DENIED"를 반환.
  (context#checkSelfPermission을 호출하는 것뿐. context#checkSelfPermission도 동일)

· PermissionChecker#checkSelfPermission(Context context, String permission)
  허가한 경우는 "PERMISSION_GRANTED" 를 반환.
  허가하지 않은 경우는 "PERMISSION_DENIED"를 반환.
  허가는 했지만 제한된 경우는 "PERMISSION_DENIED_APP_OP"를 반환.
```

## 33p

**제한상태에서는 별도 처리하여 개선**

- 제한상태의 응답은 받지 않는다
- API 사용 전에 Permission 체크
  - PERMISSION_GRANTED
    - 정상
  - PERMISSION_DENIED_APP_OP
    - 별도 처리
      - 실제로 처리를 하지 않아도 된다
      - 이쪽도 설명이나 변경요구 등을 자연스럽게

## 34p

**제한상태에서 실행을 거부하여 개선**

- android 6.0 미만의 단말과 동일한 동작만 상정
  - android 6.0 미만을 상정해서 설계한 어플은 그대로
  - android 6.0 이후를 상정한 어플 만드는 분에게 리소스를 나눈다
- Activity 시작 시에 제한되어있다면 해제 요구
  - onStart 이후이나 onCreate + onRestart 에서 체크
  - Permission을 설정화면에서 변경하면 프로세스가 Kill 된다. 그 후 어플을 호출하면 설정변경 전의 Activity가 재생성된다

| Android 6.0 이후의 Runtime Permission 사고방식과 정반대! 어디까지나 어쩔 수 없는 경우에 대한 일시적인 조치이며 빠른 단계에 targetSdkVersion=23으로 대응을 |

## 35p

4 정리

## 36p

**정리**

- Android의 Permission 모델은 Android 6.0d 에서 새로운 모델이 되었고, (일부이지만) 사용자가 결정권을 가지게 되었다
- 지금은 아직 사용하는 사람은 적지만, 곧 본격 대응이 필수가 된다. 그때, 오래된 단말에서도 동작하도록 신경 쓸 필요가 있다
- 한편, 새로운 Permission 모델이나 targetSdkVersion을 올릴 수 없는 경우는, 과도기 기간에 응급대처를 하고, 본격대응에 준비한다.

## 37o

추가

## 38p

**그룹 단위로 설정 변경의 영향**

- Permission 설정 변경은 AndroidManifest에서 선언된 그룹 안의 permission 전체에 대해서 일률적으로 행한다
- 설정 화면으로부터의 변경도, requestPermissions에 의한 어플에서의 요구도 동일. 요구는 인수에 Permission을 하나 지정하면, 그룹 전체에 영향을 준다
  - 이미 허가되어 있거나, Never ask가 설정되어있어서 Dialog가 호출되지 않기도 한다.

1. AndroidManifest에서 선언
2. 어플 내에서의 Permission 요구
3. Permission 허가 상황

## 39p

**sharedUserId에 의한 설정 공유**

- sharedUserId를 설정한 어플간에는 허가/불허가의 설정도 공유된다. (지금까지도 Permission은 굥유되어 있다)
- 어플 A엥서 허가를 하면, 어플 B에서도 허가된다
- 어플 B의 Manifest 파일 안에 선언되어있지 않는 Permission도 어플 A에서 선언되어 있다면 허가되지만, 어플 B의 설정화면에서는 변경할 수 없다

선언한 Permission

- 위치 정보에 접근
- 연락처 읽기

## 40p

**어플 버전업시의 주의점**

- 어플리케이션을 버전업할 때, 지금까지 부여되었던 Permission은 계승된다. targetSdkVersion를 22에서 23에 변경할 경우도 동일
  - 그 때문에, 버전 업에 있어서는 runtime-permissions 모델이지만 install-time의 설정이 계속된다
  - 버전 업 후의 최초 기동 시에 대응한 것을 알리고, 확인을 재촉하는 화면 등을 만들어도 좋습니다.
