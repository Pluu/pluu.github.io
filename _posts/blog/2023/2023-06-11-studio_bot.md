---
layout: post
title: "[요약] Studio Bot - Android Developers Backstage"
date: 2023-06-11 23:30:00 +09:00
tag: [Android Studio]
categories:
- blog
- Android
---

<!--more-->

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/jeuAR8qMePg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Studio Bot이란?

- Studio Bot은 AI 코딩 어시스턴트. 코딩을 위한 제품
- IDE에 도구 창으로 통합된 챗봇
- 자연어 대화를 나누며 필요한 코드나 조언을 얻을 수 있다
- LLM의 대규모 언어 모델로 학습된 데이터 기반으로 동작

<img src="https://static.gosquared.com/images/april/clippy/icon_clippy_01@2x.png" alt="Clippy for your website – GoSquared" style="zoom:25%;" />

> Clippy에서 영감을 얻음

### 도움을 줄 수 있는 케이스

- 프로그래밍 중에 Best Practice나 API가 무엇인지에 대한 질문 또는 이 작업을 하는 방법에 대한 질문이 있는 경우
- 코딩 질문, Best Practice, 코드 생성, 문서화, 테스트 케이스에 도움을 준다
- Studio Bot은 이 함수가 무엇을 하는지, 이 프로그램이 무엇을 하는지 간단히 요약하여 알려줄 수 있다
- 코드를 선택하고 여기에 주석을 추가할 수 있는 특정 기능이 내장되어 있다. (특정 Flag를 켜야만 사용 가능)

> Backstage에서 언급한 케이스
>
> - Editor에서 코드에 대한 코멘트를 요청할 수도 있다.
> - Logcat에서 크래시가 발생하면 "이 크래시에 대해 알려주세요"라고 할 수 있다.
> - Gradle 동기화 실패가 발생하면 "무슨 일이야?"라고 말할 수 있다.
> - 어떻게 해야 하나요? 정확히 어떤 형식의 문자열을 사용해야 하나요?라는 질문을 한다.
> - 그 외에도 이름을 뭐라고 지어야 할까요? 등 다양한 유형의 질문을 할 수 있다. 

**모르거나 이해하지 못하는 것에 대한 답을 찾기 위해 Studio Bot을 사용해서는 안된다.**


> Tor Norbye가 언급한 케이스
>
> - 언어 구문에 대한 구체적인 질문을 했는데 기호와 관련된 질문이었어요. 보통 이런 질문은 검색 엔진에서 찾기가 매우 어렵다.
> - C++에서 이 연산자는 무엇을 의미하나요?"라고 물어볼 수 있었죠. 그리고 바로 답을 얻을 수 있었다.
> - 날짜/시간 서식을 어떻게 지정해야 할지 막막할 때 제가 원하는 것을 명시적으로 설명할 수 있는 기능이 훨씬 더 유용하다.

### 사용 가능한 명령어

슬래시 명령어 : 실제로 텍스트가 아닌 것에도 작동할 수 있다. 리팩터링을 시작하거나 중단점을 설정하는 등의 작업을 수행할 수 있다.

{% include img_assets.html id="/blog/2023/0611-studio-bot/001.png" %}

### 안전성 (비밀 보장)

현재 작업 중인 것은 감시하지 않음. 

Studio Bot은 사용자가 챗봇 창에 입력하지 않는 한 구글로 전송하지 않는다.

- Studio Bot은 사용자가 쿼리에 입력한 내용만 사용하며, 그다음에는 서버로 전송 후 처리한 다음 답변을 전송한다.
- 대화 창에 붙여 넣은 다음 사용자가 보낼지 말지 결정할 수 있다. 마지막에 Enter 키를 눌러야 한다.
- IDE Editor에 있는 코드 정보는 모른다.

### 동작

- 직접 텍스트를 입력하거나 IDE 내의 다양한 서비스를 통해 대화를 시작할 수 있다.
- 일부는 IDE 내부의 로컬에서 처리 / 일부는 백엔드에서 처리된다.

- 무엇을 해야 하는지, 프로젝트를 어떻게 설계해야 하는지 등 일반적인 Android 지침에 대한 권장 사항을 제공하는 것이 최종 목표이다. 하지만, 현재는 인터넷상의 내용의 합의에 더 가깝다고 할 수 있다.
  - 특정 API를 어떻게 사용하는지의 질문에 답을 보여준다기보다 샘플 코드라고 생각해야 한다.

> Smart Action : https://developer.android.com/studio/preview/studio-bot#how-it-helps

## 한계

API, 문서, 이름 지정, 코드에 대한 질문에 답할 수 있다.



Q. 아이콘을 생성해 달라고 요청할 수 있나요? 그렇게 할 수 있나요? 아니면 순전히 텍스트만 입력할 수 있나요? 

A. 현재 버전은 순전히 텍스트로만 응답한다.

- 실제로는 마크다운으로 응답하고 마크다운의 형식을 지정한다.



과거 다양한 다른 코드에서 유사한 패턴을 바탕으로 일반화하여 대략적인 답을 추측할 수 있다.

> Backstage에서 언급 : "그래, 여기서 하려는 것은 아마도 이런 것일 것이다"라고 말할 수 있다.

같은 질문을 하더라도 다른 대답이 나올 수 있다. -> 몇 가지 확률적 설정에 의존한다.

### LLM의 한계

언어 모델이 잘하지 못하는 한 가지는 사실에만 반응하는 것이다. 언어 모델은 훈련을 받는데, 훈련은 과거 어느 시점에 이루어졌다. 훈련 이후의 새로운 지식은 없다.

> Backstage에서 언급 : "Compose의 최신 버전은 무엇인가요?"와 같은 질문이 좋은 예가 될 수 있다.

LLM의 문제 중 하나

- `스스로 답을 내놓으면서도 이것이 정답이라고 확신하는 것이다`. 이것이 실제 정답과는 거리가 멀다는 것을 알고 있다.

### 피드백

- 👍 👎 버튼을 통해서 피드백하면 모델 작업 반영에 사용된다.

### 미래 도입 예정

- Project Migration
- Studio Bot이 Studio 자체를 진단
  - Studio가 느린 이유 (Studio 체크, Thread 덤프, 버그 탐색 등)
