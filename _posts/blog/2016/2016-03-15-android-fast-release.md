---
layout: post
title: "[번역] DroidKaigi 2016 ~ 빠르게 배포를 위한 Android 어플 디자인"
date: 2016-03-15 20:50:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [最速でリリースするためのAndroidアプリデザイン](http://www.slideshare.net/yanAoyama/android-58405721) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

빠르게 배포를 위한 Android 어플 디자인

## 2p

**자기소개**

Aoyama Naoki

디자이너. 소프트웨어 제품의 UI/UX를 중심으로 활동 중이지만 뭐든지 하고 싶다.

Wantedly,Inc. 에는 작년 6월부터 근무, 그 이전은 단말 제조사에서 System UI, FW 주변, Home 등을 담당

> [https://www.wantedly.com/projects/6708/staffings/104038](https://www.wantedly.com/projects/6708/staffings/104038)

## 3p

**Sync**

2015년 8월 릴리즈. 비지니스 채팅 어플

[https://play.google.com/store/apps/details?id=com.wantedly.android.sync](https://play.google.com/store/apps/details?id=com.wantedly.android.sync)

## 4p

**첫 배포까지**

4주간 단기간으로 개발

## 5p

- Designer : Aoyama Naoki
- Engineer : Sumitomo Takao

**개발 체재**

## 6p ~ 7p

**디자인 흐름**

대략적인 사양에 대해서 맞춰보기

| UI 설계 | 어플 설계 |
| 화면 레이아웃 작성 (comprehensive) | 설계 부분 구현 |
| 화면 흐름도 작성 | UI를 대략 구현 |
| 디자인을 수정해서 Pull Request |  |

## 9p

레이아웃을 만드는 편이 좋다

디자이너 스스로의 사고 · 확인을 위해 그림이 없으면 전달할 수 없는 것이 많다

최후 산출물은 어플이므로 어디까지나 전달된다면 OK

## 10p

**디자이너도 코드를 작성하자**

여러 가지 좋은 것이 있다

- 적어보면 어떤 디자인이 효율적으로 만들 수 있는가 알 수 있다
- 공통적인 인식을 할 수 있으므로, 커뮤니케이션이 원활하게
- 다 전달하지 못하는 부분, 고집하고 싶은 부분은 스스로 없앨 수 있다

꼭 디자이너에게 권해보세요!

## 11p

**디자이너도 코드를 작성할 수 있다**

Android Studio의 Content Assist는 우수하므로, 써보면 대체로 나온다

## 12p

**리소스 정의**

디자인 스타일 가이드에 기재하는 내용을 그대로 Values에 먼저 전부 써두고 그 외에는 쓰지 않는다

- Color Palette
- 문자 사이즈 정의
- Layout Grid
- 컴포넌트마다의 스타일

## 13p

**Colors**

Color Palette

## 14p

**Dimens**

Material Design의 8dp를 기준으로 한 값을 넣어둔다. 편리!

## 15p

**Drawables**

9-Patch를 사용 안 한다!

9-Patch 이미지는 디자이너 쪽에서도 작성이 불편하다.

이미지 내에 Padding 등을 포함해버리므로, 수치를 참고하지 않으면 안되는 등 유지보수도 좋지 않다.

디자인 시에 9-Patch를 쓰지 않아도 된다는 것을 의식하는 것만으로도 상당히 만들기 쉽게 된다.

## 16p

**스스로 작성한 아이콘도 Material Icons에 근거**

표준 아이콘과 섞어서 사용해 위화감이 없도록 하는 것으로 작성 횟수를 줄인다

> [design.google.com/icons/](design.google.com/icons/)

## 17p

**이미지 작성 시간 - 해당도 대응 · 이름 변경 등을 줄이자**

Adobe Illustrator에서 각 해상도마다 만들어주는 스크립트를 사용해서 리소스 폴더에 직접 만들어낸다

> [https://github.com/austynmahoney/mobile-export-scripts-illustrator](https://github.com/austynmahoney/mobile-export-scripts-illustrator)

## 18p

**이후로는 Android Studio 2.0의 Vector Assets를 이용 예정**

SVG 파일을 1개 만들어두면 OK, Material Icons를 간단하게 읽어 들일 수 있다

> 현재는 버그가 있어 아직 사용할 수 없다

## 19p

Material Design

## 20p

**지금이라면 Material Design을 기본으로 생각하는 것이 효율적**

- Support library가 충실해졌다
- 문서가 탄탄하고, 공통적인 인식을 만들기 쉽다
- 체계적인 구조가 있으므로, UI로서 파편화가 적다
- 커스터마이징으로 친숙한 표현

## 23p

**문서가 충실**

https://www.google.com/design/spec을 디자이너, 엔지니어간 자주 읽어 두자.

Material Design에 따른 것이라면, 구현 지시를 위한 문서를 작성할 필요가 없다. 커스터마이징할 경우에도 Google의 가이드라인과의 차이를 작성할 수 있고, 그편이 알기 쉽다.

> 갱신빈도가 높으므로 요주의!

## 24p

**문서가 충실**

Google이 공개하고 있는 Sticker Sheet를 기준으로 커스터마이징한 스타일의 데이터를 작성하면 좋다

빠짐없이 커스터마이징한 항목을 명확하게 할 수 있다

## 26p

**정리**

대략적으로

- Material Design을 기준으로 해서 커스터마이징을 생각하자
- 디자이너도 코드를 작성하자(작성해보자)
- 리소스가 깔끔하게 정리되는 디자인을 하자
