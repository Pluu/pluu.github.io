---
layout: post
title: "[번역] StackOverFlow의 「MVP와 MVC의 차이점」에 대한 답을 읽어봤다"
date: 2016-12-30 15:50:00 +09:00
tag: [Android, MVC, MVP]
categories:
- blog
- Android
---

본 포스팅은 [StackOverFlowの「MVPとMVCの違い」についての回答を読んでみた](http://qiita.com/takahirom/items/597c48ece57b4623cdee) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

MVP와 MVC와 MVVM와의 차이점에 대해서 나는 제대로 알고 있지 않았습니다.

StackOverFlow의 「What are MVP and MVC and what is the difference?」라고 질문의 답변이 2015/09/23 현재, 1213명이 Useful하고, 다른 곳에서도 소개되고 있어서 읽어보려고 했습니다.

자신이 없는 곳이 많으므로 착각이나 잘못된 부분이 많을 거라고 생각하기 때문에, 상냥하게 지적을 부탁드립니다.

나는 읽어보고, 어딘지 모르게 차이를 알았다고 그리고 MVP 및 Presentation Model(Model-View-ViewModel)의 차이에 대해서도 나오기 때문에 도움이 되었습니다.

What are MVP and MVC and what is the difference?

[http://stackoverflow.com/a/101561](http://stackoverflow.com/a/101561)

## Model-View-Presenter

Presenter는 View를 위한 UI 비즈니스 로직을 작성

- Presenter는 View를 위임하고 이벤트를 받는다
- Presenter는 View에서 분리되어있다. View를 interface를 통해 조작
  - 그래서 View를 Mock하여 테스트하기 쉽다

Presenter의 특징

- View → Presenter와 Presenter → View를 많이 가지고 있다.
  - 예 : "Save"Button 클릭 → View의 이벤트 핸들러는 Presenter에 위임되어 있으므로 Presenter에서 "OnSave"가 불린다 → 세이브가 끝나면 Presenter에서 Interface를 통해 View에 저장되고 따라서 표시한다.

### 2가지의 MPV 변형

MVP에는 두 종류가 있습니다.

#### Passive View

View 안의 로직은 될 수 있는 대로 없애고, Presenter를 View와 Model을 중개하도록 하여 Model이 데이터 변경이 있는 등의 이벤트를 실행하고 Presenter가 그것을 받아 Presenter가 View를 업데이트합니다. 완전히 Model과 View가 분리되어 있습니다.

View에는 다양한 Setter가 존재하여 View 자체에서는 상태를 관리하지 않고 Presenter가 상태를 관리합니다.

좋은 점 View와 Model이 예쁘게 나누어져 있어 테스트하기 매우 쉽다.

나쁜 점 많은 Setter를 써야만하여 힘듭니다.

이미지

<img src="https://qiita-image-store.s3.amazonaws.com/0/27388/e6dec446-85c5-eaaf-e27f-1880f67e11cf.png"/>

#### Supervising Controller

데이터 바인딩하는 구조를 이용하여 Model에서 View에 바인딩하는 방법입니다. 이 경우 Presenter에서 행하던 Model에서 View로 데이터를 전달하는 코드가 필요없습니다. Presenter는 버튼을 눌렀을 때의 로직과 어디로 이동할지의 로직 등이 적혀있는 것입니다.

좋은 점 : 데이터 바인딩의 힘에 의해 코드를 줄일 수 있다

나쁜 점 : 데이터 바인딩으로 테스트의 용이성이 줄어든다. Model과 View가 직접 연결되므로 캡슐화가 잘할 수 있지 않다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/27388/65f06862-9921-68ee-56c1-6e509553a797.png"/>

### Model-View-Controller

MVC에서 Controller는 모든 액션에 응답하는 View를 결정할 책임이 있습니다.

MVC와 MVP의 차이는 두가지 있습니다.

- View에서 Presenter(Controller)에 대한 호출의 흐름이 다르다

> MVC에서는 View 안의 액션이 Controller를 호출 관계입니다.
>
> 예를 들어, Web에서 View 안의 액션은 URL 호출하고 그에 응답하는 Controller가 처리합니다. 그리고 컨트롤러가 처리가 끝나면 올바른 View를 반환합니다. 다음과 같은 흐름입니다.

```
View 안의 액션
    -> Controller 호출
    -> Controller 로직
    -> View를 반환
```

- View가 Model에 (직접) 연결되지 않는다

> MVC에서는 View는 간단하게 표시할 뿐입니다. 그리고 완전히 상태를 가지지 않습니다. View만을 위한 로직이 없어, 즉 MVC의 구현은 MVP라면 절대 필요한 View에서 Presenter에 대한 대리자가 없다는 점입니다.

이미지

<img src="https://qiita-image-store.s3.amazonaws.com/0/27388/a5846c19-c18b-09aa-8f31-57946079c1c3.png"/>

### Presentation Model(Model-View-ViewModel)

또 하나 봐두어야 할 패턴으로 Presentation Model 패턴이 있습니다. 이 패턴에서 Presenter는 존재하지 않습니다. 대신 View는 Presentation Model과 직접 바인딩합니다.

Presentation Model은 표시하는 View를 위해 만들어져 있습니다. 따라서 Model과 View가 직접 연결되지 않기 때문에 MVP의 Supervising Controller의 문제점인 캡슐화 문제도 해소할 수 있습니다.

이 경우 Presentation Model은 Model에서 이벤트를 구독하고 있습니다. View는 Presentation Model에서 온 이벤트를 구독하고 그것을 받아 업데이트합니다.

Presentation Model은 여러 명령을 게시할 수 있습니다. 그 명령은 View의 액션을 호출하기 위한 것입니다. 이 방법의 좋은 점은 Presentation Model이 View의 행동을 완전히 캡슐화하여 CodeBehind를 제거할 수 있다는 것입니다. 또한, Model-View-ViewModel 패턴이라고도 말합니다.

이미지

<img src="https://qiita-image-store.s3.amazonaws.com/0/27388/b7db2e31-6f41-67a4-39ca-6809c8414bd7.png"/>
