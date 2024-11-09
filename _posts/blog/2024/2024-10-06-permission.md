---
layout: post
title: "[메모] Google Play의 사진 및 동영상 권한 정책"
date: 2024-10-06 21:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

------

Updated

- Created : 2024-10-06
- **Latest Updated : 2024-11-09 : 정책 업데이트 갱신 반영**

구글에서는 [Photo picker](https://developer.android.com/training/data-storage/shared/photopicker)를 발표한 이후로 사진/비디오 권한에 대한 정책을 발표했다. 개인 정보 강화를 위한 대응이다.

[Google Play의 사진 및 동영상 권한 정책 관련 세부정보](https://support.google.com/googleplay/android-developer/answer/14115180?hl=ko&sjid=16107555177599931278-AP) 문서를 보면 여러 가지 대응 안내를 하고 있다.

다만, 이 내용이 일부 앱을 제외하고는 거의 강제 사항처럼 보인다.

## 기본 가이드

정책 문서의 큰 가이드라인은 아래와 같다.

> Google은 사용자의 개인 정보 보호를 강화하기 위해 Google Play에서 사진 및 동영상에 대한 광범위한 액세스 권한을 획득할 수 있는 범위를 제한하는 [정책을 도입](https://support.google.com/googleplay/android-developer/answer/13986130)했습니다. 사진에 광범위하게 액세스해야 하는 앱만 `READ_MEDIA_IMAGES` 및 `READ_MEDIA_VIDEO` 권한을 유지할 수 있습니다. 사진 및 동영상 파일을 일회성으로 사용하거나 제한적으로 사용하는 앱은 [Android 사진 선택 도구](https://android-developers.googleblog.com/2023/04/photo-picker-everywhere.html)와 같은 시스템 선택 도구를 사용해야 합니다.

사진/비디오의 광범위하게 사용한다는 의미가 모호하지만, FAQ를 보면 좀 더 명확하다.

> - 일회성으로 사용하거나 빈번하지 않게 사용하는 예 : 프로필 사진 업로드, 재생 목록용 이미지 업로드, 은행 업무를 위한 수표 사진 업로드 등
> - 핵심/광범위하게 사용하는 예 : 사진/동영상 편집기 카테고리에 속하는 앱, 사진 편집기, 사용자 제작 콘텐츠 플랫폼, 이미지 검색 기능, QR 코드 스캐너 등

대략 사진/비디오 관련 앱이 아니면 거의 허용하지 않는 것처럼 보인다.

## 정책 일정 정보

이미 10월이므로 할 수 있는 것은 아래 2단계를 지키는 것이다.

- **2025년 1월 22일** : 개발자는 선언 양식을 제출해야 합니다
- **2025년 5월 28일** : 연장을 요청한 개발자를 포함한 모든 개발자는 정책을 전면적으로 준수해야 합니다. 이 날짜 이후로는 정책을 준수하지 않는 모든 앱이 Google Play에서 삭제될 수 있습니다.

또한, FAQ를 읽어보면 Manifest에서 `READ_MEDIA_IMAGES/READ_MEDIA_VIDEO 권한 정의도 삭제`하라고 명시되어 있다.

> 앱 매니페스트에서 READ_MEDIA_IMAGES 및 READ_MEDIA_VIDEO 권한을 삭제해야 하나요?
>
> 예. 앱에서 지원되는 핵심 사용 사례에서 사진 및 동영상에 광범위하게 액세스할 필요가 없는 경우 이 정책을 준수하려면 정책 시행일까지 앱에서 미디어 액세스 권한을 삭제해야 합니다.

## 아쉽지만...

개인적으로는 이런 정책을 개인정보 보호라는 명목으로 제한시키는 것은 조금 아쉽다는 생각이다. 모두가 알고 있듯이 우리들은 사진 선택으로 ACTION_GET_CONTENT/ACTION_OPEN_DOCUMENT를 활용하여 Picker를 사용했다.

시스템으로 전환할 수 있는 케이스들은 이전이 쉽겠지만, 기능이 적고 프로젝트에 따라서 Custom Picker를 만들기도 했다.

~~내용이 모호한 부분은 있지만, 남은 시간이 그렇게 길지 않기 때문에 모두 화이팅입니다.~~

내용이 모호한 부분은 있지만, 최초 2025년 1월에서 5월 말로 기한은 연장되었으므로 남은 기간동안 대응만이 살 길이다.
