---
layout: post
title: "Android Studio의 UI Code Snippet용 Plugin 제작기 ~ 0부"
date: 2024-02-04 14:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

------

최근 UI Code Snippet용 Plugin을 만들면서 기록으로 남기려고 글을 작성합니다. ~~평일은 퇴근하고서… 주말씩 조금씩 하다 보니 0.1 버전 제작에 약 2달 정도 걸렸네요.~~

{% include img_assets.html id="/blog/2024/designsystem_plugin/01.png" %}

> Dark/Light 테마를 적용한 모습

## 서론

UI를 개발하는 Front 개발자라면 프로젝트에서 사용하는 중복 UI를 공통 컴포넌트로 만드는 것은 흔하게 겪을 수 있는 현상입니다. 또한, 디자인과 협업하여 디자인 시스템을 구축하기도 합니다.

중복 코드 방지와 빠르게 UI를 개발한다는 목표는 모든 개발자가 지향하는 부분일 것입니다. 이것을 위해 어떤 선택을 할지는 현재 속한 회사/부서/집단마다 다를 것입니다.

- [개발자와 디자이너의 협업을 위한 LINE 디자인 시스템, LDS 소개](https://engineering.linecorp.com/ko/blog/line-design-system)
- [Jetpack ComposeでLINE Design Systemを実装する](https://engineering.linecorp.com/ja/blog/lind_design_system_with_jetpack_compose)
- [Banksalad Product Language를 소개합니다](https://blog.banksalad.com/tech/banksalad-product-language-ios/)

UI에서 사용하는 컴포넌트 중 큰 카테고리는 익숙해지면 금방 사용하기 쉽지만, 세부적인 케이스들은 사용 경험에 따라서 난이도는 달라집니다. 일반적으로 검색해서 찾기/동료에게 물어보기/새로 만들기를 합니다. 그것이 끝이 아니라 컴포넌트마다 작성 방법도 다양합니다. 이런 흐름은 개발자라면 익숙할 겁니다.

경험과 인지의 영역은 시간이 해결하거나 쉽게 찾거나 사용할 수 있도록 정리하는 것으로도 1차 문제는 해결할 수 있을 것입니다. Figma와 같은 디자인 프로그램을 사용 중이라서 Code로 변환할 수 있는 플러그인을 만들기도 하나의 방법입니다. 또한 별도의 프로그램을 이용하는 것도 방법입니다.

저는 위 내용들을 Android Studio에서 사용할 수 있는 Plugin을 통해서 문제를 해결해보려고 합니다.

### 기대하는 동작

사용 목적이 빠르게 코드를 가져올 수 있어야 한다는 목적이므로 어떤 컴포넌트로 생성되는지 눈에 보이면 좋다고 생각했습니다. 그리하여 아래 3가지 동작을 최우선 순위로 정했습니다.

1. 카테고리 별로 컴포넌트를 구분
2. 컴포넌트의 기본 UI를 확인
3. Code Snippet이 가능

몇 개의 기능은 Plugin으로 만들어본 경험이 있었지만, 필요한 기능에 요구되는 지식을 파악하기 어려운 상황입니다. 다행히 Android Studio의 `Resource Manager`가 제가 생각한 기능과 전체적으로 비슷한 동작을 하고 있습니다. 그래서 `Resource Manager` 코드를 베이스로 작업하기로 합니다.

{% include img_assets.html id="/blog/2024/designsystem_plugin/02.png" %}

## 최종 동작의 일부 모습

2023년 12월 13일에 작업을 시작한 이후로 초기 버전 제작에 약 2달 정도 걸렸네요.

{% include img_assets.html id="/blog/2024/designsystem_plugin/03.png" %}

**최종 동작**

오늘은 가볍게 서론과 최종 모습만 적어봤습니다. 앞으로 내용에 일부 기능들을 나눠서 만드는 방법을 살펴볼 예정입니다.

{% include youtube.html id="iTCfB6zgsI8" %}
