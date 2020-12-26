---
layout: post
title: "[잡담] 시작하는 안드로이드 개발자를 위해"
date: 2020-12-26 14:30:00 +09:00
tag: [주인장 이야기]
categories:
- blog
- owner
---

본 글은 안드로이드 개발을 시작하는 사람을 위해서 작성해본 개인적인 생각을 정리한 글입니다.

<!--more-->

먼저 이 글의 주인공이 될 사람은 `안드로이드 개발을 시작한 기간이 없거나 얼마 되지 않은 사람`입니다. 안드로이드 개발 시작 시에 작게나마 도움이 되었으면 합니다.

<img src="https://images.unsplash.com/photo-1551985812-03adaf5b5c7b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80" />

> 이미지 출처 : https://unsplash.com/photos/SwLyFhlch_k

우리 모두 안드로이드 개발을 시작하게 된 이유는 다양할 것입니다. 안드로이드가 궁금해서... 과제 때문에... 등 저마다 다양한 이유로 시작했을 것입니다. 저 또한 우연히 일을 시작한 곳에서 안드로이드를 가볍게 접했고 실제로 업무로써 안드로이드 개발을 한 것은 그로부터 1년 뒤였습니다. 

시작은 다르지만 중요한 것은 **`안드로이드 앱을 완성`시키는 것이 목표**입니다. 그리고, 그 과정속에서 다양한 분야의 사람들과 **함께 만들어가는 과정**을 경험할 것입니다. 

모든 과정에서 맞보는 경험이 이후의 개발 삶에 큰 영향을 주는 포인트일 수도 있으며 본인의 생각을 변화시키는 변곡점일 수도 있습니다.

## 내 머리속의 안드로이드

대다수의 사람이 안드로이드를 생각하면 떠오르는 것은 `스마트폰`입니다. 실제로 안드로이드 진형에서 스마트폰이 차지하는 비율이 높습니다. 일반적으로 안드로이드가 사용되는 곳은 아래와 같은 곳이 있습니다.

- 스마트폰
- 태블릿
- Wear
- TV
- Auto
- IoT

이렇게 다양하게 사용된다는 사실을 알았다는 것만으로도 한걸음 나아간 것입니다. 하지만, 대부분의 안드로이드 앱이 스마트폰을 기준으로 개발 작업이 진행됩니다. 여러분의 노력 여하에 따라서 모든 플랫폼에 설치되어 사용될 수 있습니다만, 다양한 플랫폼에서 요구하는 모든 사항을 맞추는 것은 고난의 길이기도 합니다.

주요 플랫폼으로 어떤 것을 할 것인지, 필요한 것은 **선택과 집중**입니다. 특정 플랫폼만 선택을 함으로써 일부 영역의 사용자는 잃게 되지만, 선택된 사용자에게 질 좋은 서비스를 제공할 수 있게 됩니다. 사실 모든 것을 얻고자 하는 것은 욕심이겠죠.

### 안드로이드 생태계

안드로이드의 생태계는 다양한 이해관계로 구글, 제조사, 통신사 간의 복잡한 관계로 엮여있습니다. 기본적으로 안드로이드는 구글은 소프트웨어를 담당하고 나머지 하드웨어와 추가 소프트웨어는 기존 제조사와 통신사의 역할로 해당 분야에 전문적인 회사가 담당하여 사업을 확장과 추진하는 전략입니다. 본 글에서는 해당 내용보다는 가볍게 전달하는 것이 목적이므로 생략하겠습니다. 

> 과거 Project ARA를 떠올리신다면 여러분은 고인물입니다.

<img src="https://3.bp.blogspot.com/-YwBharjZ1kI/WRXgRQKZOyI/AAAAAAAAEH0/aJrPyg8hLnM0D5EicpZyUPX5prD1hwVJgCLcB/s640/image_1_flowchart.png" />

> 이미지 출처 : Here comes Treble: A modular base for Android, https://android-developers.googleblog.com/2017/05/here-comes-treble-modular-base-for.html

대략적으로 안드로이드 스마트폰은 아래와 같이 소비자에게 전달됩니다. 

1. 순정 안드로이드 OS 혹은 AOSP : 소프트웨어
2. 제조사 + 통신사 : 소프트웨어, 하드웨어
3. 소비자

> 추가로 소비자에게 전달되기 전 구글이 제시하는 하드웨어/소프트웨어 테스트를 만족하고, 구글의 Google Mobile Service(GMS)을 포함해야만 구글의 승인을 얻을 수 있습니다.

여러분이 사용하는 안드로이드 스마트폰은 구글, 제조사, 통신사 및 AOSP의 Committer의 도움으로 움직이고 있습니다. 1,2번 과정이 모두 다른 회사가 담당하므로, 기본이 되는 OS에서는 소프트웨어와 하드웨어에서 사용할 수 있도록 기능을 제공하고 있습니다. 다른 진형의 아이폰은 1+2 과정 모두를 애플이 직접 관리하고 있다고 생각하시면 됩니다.

구글과 제조사 함께 하는 전략적인 선택이지만, `순정 OS x 제조사 x 통신사`의 조합으로 여러 개의 케이스가 생기게 됩니다. 여기서 안드로이드 개발자의 고민이 시작됩니다. 바로 `파편화 이슈`일 것입니다.

### 파편화

앞에서 파편화가 발생한 이유에 대해서 알아봤습니다. 현업에서의 안드로이드 개발 시에도 중요하며 항상 끌어안고 가야하는 이슈입니다. 이것이 의미하는 결과는 생각보다 아주 큽니다. 간단하게 스마트폰에서만 나오는 일반적인 파편화 리스트를 나열해보겠습니다.

**소프트웨어 파편화**

- 안드로이드 OS 버전

**하드웨어 파편화**

- 제조사
- 화면 크기 및 갯수, 종류
- CPU / GPU 종류
- 하드웨어 부품 및 센서 유무 (카메라, 자이로 센서, 근접 센서 등등)
- 기타

| Android Version | 2015년 단말기 파편화 |
| :--: | :--: |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1226-android-starter/version_dashboard.png" }}" /> | <img src="https://www.xda-developers.com/files/2016/07/fragmentation.png" /> |

> Android OS Version 체크 : 2020.12.25에 체크
>
> 하드웨어 파편화, 이미지 출처 : https://www.xda-developers.com/the-sorry-state-of-android-fragmentation/

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/1226-android-starter/screen_sizes.png" }}" />

> 화면 크기 대시보드 출처 : https://developer.android.com/about/dashboards

다행히도 안드로이드 OS 자체의 소프트웨어 이슈는 상대적으로 하드웨어에 비해서 낮은 편입니다. 해당 OS 버전에서 지원하지 않는 API를 사용했거나 OS 자체 혹은 구글이 제공하는 라이브러리 버그의 경우가 많습니다. 낮은 것이지 없다는 것은 아닙니다. 여러 이슈로 영향이 큰 경우도 여러 존재합니다.

큰 문제는 `제조사/통신사 소프트웨어 + 하드웨어`입니다. 하드웨어의 파편화로 여러 케이스를 고려하고 개발 작업이 진행되었지만, 생각지 못한 이슈로 대응이 불가피한 경우도 있습니다. 하드웨어의 유무는 개발자가 놓친 이슈이지만, 소프트웨어 버그는 무시할 수 없습니다. 다만 언제 수정될지는 기약을 알 수 없습니다.

추가로 최신 단말과 최신 버전에서는 많이 개선되었지만, 픽셀과 Android ONE을 제외하고 나머지의 스마트폰 기종의 OS 업데이트의 권한은 제조사에게 있습니다. 단말기는 출시를 했지만 OS 업데이트를 지원받지 못하는 경우도 많습니다.

단순 테스트 코딩이나 샘플에서는 파편화 이슈는 무시할 정도이니 너무 무서워하지 않아도 됩니다. 실무에서 파편화 이슈는 어려운 대응이지만, 안드로이드뿐만 아니라 다른 플랫폼과 개발 영역에서도 그곳만의 형태로의 이슈가 있다는 사실을 생각하시면 됩니다.

## 첫걸음도 준비와 연습이 필요하다

한국 속담 중에서 `첫술에 배부르랴`라는 말처럼 안드로이드 개발 처음부터 잘 되는 경우는 극히 드뭅니다. 현재 안드로이드에서는 Activity, Fragment, ViewModel, Intent, AAC, Kotlin, AndroidX 등 이전부터 존재했거나 새롭게 추가된 용어 등으로 첫 입문자들에게는 높은 벽이라는 사실은 변함이 없습니다.

돌이켜보면 현재 마주하는 안드로이드 개발 패러다임은 기존 프로그래밍 지식과 약 10년간 축적된 안드로이드 개발의 이해관계와 지향하는 방향의 집합입니다. 그렇기 때문에 한 번에 모든 것을 이해하는 것은 불가능에 가까울 것입니다. 그러니 포기하지 말고 차근차근 하나씩 해결해나가면 될 것입니다. 오래 걸릴 수도 있지만 지식의 범위를 조금씩 늘리고 또 이겨냄을 반복함으로써 지금보다 나은 위치에 도달할 것입니다. 이것은 안드로이드뿐만아니라 모든 직업에서 동일하게 적용되는 개념입니다.

그렇다면 처음부터 모든 것을 공부해야 할까요? 이 선택을 하시는 분은 없을 거라고 생각합니다. 그렇다면 기초 자료부터 하나씩 챙겨보길 권장합니다. (사실 `제발 읽어보세요`) 모든 지식은 단계가 필요하다는 사실을 기억해 주세요. 기본 자료구조를 모르는데 복잡한 구조를 만들기는 어렵습니다. 그리고 디자인 패턴과 자료구조 없이 처음부터 MVP, MVVM 등 아키텍처에 대한 내용을 깊숙이 이해하는 것 또한 어렵습니다. 필요하다면 가볍게 이해하는 것으로 일단락을 짓는 것도 나쁘지 않습니다.

> 초보인데 준비 없이 보스급 몬스터를 공략하는 것은 무모할 수 있습니다. 레벨업과 무기/방어구가 필요할 수도 있으며, 함께 공략할 팀원이 필요할 수도 있습니다.

**안드로이드 시작시 추천하는 기본 자료**

아래의 자료는 개인적으로 추천하는 자료입니다. 챙겨봐야 할 자료가 많아 보일 수 있지만, 가장 기본이 되는 자료입니다.

Codelab (영어)

- (필수) Java Programming Language : https://developer.android.com/courses/fundamentals-training/overview-v2
  - Android 개발 기초 Codelab : https://developer.android.com/courses/fundamentals-training/toc-v2
  - 기초 자료 Slide : https://drive.google.com/corp/drive/folders/1eu-LXxiHocSktGYpG04PfE9Xmr_pBY5P
- (선택) Kotlin Programming Language : https://developer.android.com/courses/basic-android-kotlin-training/overview

Sample (영어)

- https://developer.android.com/samples

> 책은 개인마다 성향이 다르므로 별도로 작성하지 않았습니다.

## 필요한 것은 분석하는 능력

<img src="https://miro.medium.com/max/4800/1*fsiieKz_0I_MbqYwhXdsrA.png" />

> 이미지 출처 : https://medium.com/androiddevelopers

이미 여러분은 Android Studio를 사용해서 여러 가지 코드를 작성하실 겁니다. 자연스럽게 개발을 진행하는 시기도 있겠지만, 항상 잘 되는 경우는 드물 것입니다. 대체적으로 안드로이드 개발을 시작한 초기에 많이 부딪히는 것으로는 몇 가지 있을 겁니다.

- 빌드 실패
- 실행 중 앱이 종료
- API 통신 후 원하는 결과를 얻을 수 없음
- 개발하고 테스트할 때는 잘 되었지만, 이후에 다시 실행해보니 동작하지 않음
- 앱이 느리다

사실 위 경우는 개발을 시작한 시기와 관계없이 주변에서도 흔하게 이야기가 들리는 이슈들입니다. 이때 여러분은 어떻게 이 문제를 해결할지 한번 생각해 보시길 바랍니다. 경우에 따라서 훌륭한 선택일 수도 있습니다. 하지만, 코드를 조금 수정하고 실행하는 행위를 반복하거나 코드만 보게 되는 `코드에 파묻히는 자신`을 발견하게 됩니다. 정말로 어려운 문제인 경우도 있지만, 오타 혹은 스펙대로 사용하지 않은 등의 간단한 문제인 경우도 있습니다. 그러다가 결국 문제를 해결하지 못하고 포기하게 되는 일도 발생하겠죠.

**혹시 여러분도 이것저것 수정하거나 실행하거나 하지 않으셨나요?**

이때 필요한 것이 문제를 찾아내고 원인을 밝히고 수정하는 작업 과정이 필요합니다. 그리고 이것을 우리는 이것을 `디버깅`이라고 부릅니다. 안드로이드 개발에도 여러 가지 디버깅에 필요한 도구 및 기능들이 존재합니다. 본 글에서 가장 기본적인 2가지만 언급합니다.

**Android Studio에서의 디버깅 방법**

1. System Log 사용
2. Breakpoint 사용

의외로 기본적인 2가지를 사용하지 않는 경우도 많이 있습니다. 꼭 해당 내용을 사용해보시길 바랍니다. 

<img src="https://developer.android.com/studio/images/debug/logcat_2x.png" />

<img src="https://developer.android.com/studio/images/debug/hybrid-debug-session_2-2_2x.png" />

> 이미지 출처 : https://developer.android.com/studio/debug#systemLogView

유명한 라이브러리의 경우에는 자체적으로 디버깅을 도와주는 로그 기능도 존재하므로 꼭 체크해보세요. 추가로 프로파일링을 통해서 성능을 개선할 수도 있습니다. 

> 통신 라이브러리로 유명한 Retrofit의 디버깅으로는 통신 역할을 하는 OkHttp에서 Logging Interceptor를 사용해서 네트워크 통신 시에 전송/수신하는 값을 확인할 수 있습니다.
>
> https://github.com/square/okhttp/tree/master/okhttp-logging-interceptor

**참고 사이트**

- 앱 디버그 도구 : https://developer.android.com/studio/debug
- 프로파일링 도구 : https://developer.android.com/studio/profile
- Firebase Crashlytics (오류 보고 솔루션) : https://firebase.google.com/docs/crashlytics

## 현재는 꽤 성숙하면서도 성숙하지 않은 상태입니다?!

`(본 섹션은 개인적인 생각을 담았습니다)`

안드로이드 OS 버전도 어느덧 11까지 왔으며, 구글이 제공하는 Android Studio와 기본 라이브러리인 AndroidX도 꾸준히 업데이트되고 있습니다. 이것으로 매일 안드로이드 앱을 위한 코드를 작성하고 있으며, 그로 인해 많은 사람이 도움을 받으면서 새로운 서비스를 만들고 업데이트하고 있습니다.

Android Studio도 Canary - Beta - Stable 버전으로 대응하면서 개발자들에게는 안정된 버전을 제공하려고 많은 사람들이 노력하고 있습니다. 최근에는 Android Studio와 Gradle Plugin 버전을 분리하는 형태로 개선되는 Android Studio Arctic Fox와 Android Studio Gradle Plugin 7.0.0-alpha 버전도 공개되었습니다.

> 본 글을 작성하는 2020.12.26일 시점에서의 Android Studio는 아래와 같은 버전을 제공하고 있습니다.
>
> - Stable : 4.1.1
> - Beta : 4.2 Beta 2
> - Canary : Arctic Fox (2020.3.1) Canary 3

구글에서 제공하는 것만 사용하더라도 앱을 만드는데 많은 도움을 받습니다. AndroidX, Material Design, gson 가 그 사례입니다. 버전 분기의 불편함을 AppCompat의 도움으로 해결 가능하며, room을 통해서 Android DB인 Sqlite를 다소 편하게 사용하는 것도 가능해졌습니다.

> 현재 AndroidX 라이브러리는 83개의 라이브러리를 제공하고 있습니다.
>
> https://developer.android.com/jetpack/androidx/versions

최근에는 간단한 앱을 만들더라도 통신 기능과 어딘가에 존재하는 이미지를 다운로드한 후 표시하는 기능조차 기본 중의 기본 기능으로 자리 잡았습니다. 구글에서도 제공하는 라이브러리에도 통신은 Volley, 이미지는 Glide가 있습니다. 다만 통신의 경우에는 구글의 Volley 대신 Square의 Retrofit과 OkHttp가 사실상 업계 표준에 가깝게 사용되고 있습니다. 그 외에도 훌륭한 오픈 소스 라이브러리가 있으며 꾸준히 업데이트되고 있다는 사실에 안드로이드 생태계가 성숙하다고 생각할 수 있습니다.

다만 안드로이드도 성숙해 보이는 부분의 이면도 있다는 사실을 알고 계셔야 합니다. 개인적으로는 **Fragment와 파편화, 구글이 제공하는 라이브러리의 업데이트 부재**가 주요 문제일 것입니다. 

Fragment는 안드로이드 3.0 Honeycomb부터 스마트폰과 태블릿을 적은 수정으로 호환하기 위해 생겨난 생명주기를 가진 조각(Fragment)입니다. Fragment가 처음 나온 이래로 지금까지도 개발자 사이에서도 호불호가 극명하게 나뉘고 있습니다. 지금은 많이 개선되었지만 여러 가지 버그와 사용의 불편함, Activity와 View의 중간쯤에 해당하는 포지션을 담당하고 있어서 생겨난 경향도 있습니다. 

라이브러리 업데이트의 부재도 꽤 신경 쓰이는 항목입니다. AndroidX의 Window Manager는 2020년 2월에 첫 알파 1 버전이 공개된 이후로 약 10개월 동안 새로운 버전이 공개되지 않았습니다. 그리고, 이미지 라이브러리인 Glide 또한 2020년 1월 이후에 업데이트는 없습니다. 안드로이드에서도 새로운 개념이 추가됨에 따라 AndroidX의 기본 라이브러리도 그에 맞춰서 출시가 이루어져야 하는데 이 흐름이 경우에 따라서 상당히 늦게 진행되고 있습니다. 이 부분이 꽤... 불편합니다. 그래서 직접 작성해야 하거나 새로운 라이브러리를 찾아야만 하는 경우도 있습니다.

이 글을 읽고 겁을 먹거나 크게 걱정하지 않으셔도 됩니다. 공식적인 구글 라이브러리와 오픈소스로 나오는 라이브러리가 있으며 지금도 안드로이드 생태계가 움직이고 있다고 볼 수 있습니다. 누군가에게는 구글과 오픈소스 간의 적절한 조화를 통해 새로운 것들이 계속 생겨난다는 것이 행복한 고민일 수 있습니다.

## 당신은 혼자가 아닙니다

프로그래밍은 홀로 외로운 싸움을 하는 것이 아닙니다. 안드로이드에서는 다양한 서적, 구글, 오픈소스, 다양한 커뮤니티 그리고 회사의 동료들과 StackOverflow 등 여러분을 도와주고 밀어주고 이끌어주는 사람들이 있다는 사실을 기억해 주세요. 

<img src="https://images.unsplash.com/photo-1582854050148-651d87fa3319?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1500&q=80" />

> 이미지 출처 : https://unsplash.com/photos/B87zMorEZRo

이미 여러분이 원하는 정보 및 새로운 것을 전달해 주는 수많은 정보의 바다가 인터넷에 가득합니다. 조금만 여러분이 손을 내밀고 노력하는 모습을 보이시면 원하는 결과에 도달할 수 있을 겁니다. 

**P.S**

처음 개발을 시작하거나 초보 안드로이드 개발자를 위해서 생각해 본 것들을 적다 보니 다소 긴 글이 되었네요. 조금이나마 이글이 도움이 되었으면 합니다.

마지막으로 여러분이 어느 곳에서라도 누군가에게 도움이 되고, 그곳에서 빛나는 순간을 경험하시길 기원해봅니다.

## 참고 사이트

- Android Fragmentation 2015 By Kevin Fitchard, August 2015 : https://www.opensignal.com/reports/2015/08/state-of-lte
- The Sorry State of Android Fragmentation: An Example to Understand Developers’ Plight : https://www.xda-developers.com/the-sorry-state-of-android-fragmentation/
- Here comes Treble: A modular base for Android : https://android-developers.googleblog.com/2017/05/here-comes-treble-modular-base-for.html
- Distribution dashboard : https://developer.android.com/about/dashboards
