---
layout: post
title: "[메모] Actions on Save"
date: 2024-04-28 13:30:00 +09:00
tag: [Android, Android Studio]
categories:
- blog
- Android
---

<!--more-->

------

파일 저장 시 특정 동작을 하도록 트리거를 연결하면 불필요한 코드 정리도 간단하게 가능하다.

IntelliJ/Android Stuido도 이전부터 들어간 것 같지만, 최근에 발견했다.

- Android Studio Iguana에도 사용 가능하다

> Trigger actions when saving changes : https://www.jetbrains.com/help/idea/saving-and-reverting-changes.html#actions-on-save

## Actions on Save

기능을 사용하려면 `Preferences | Tools | Actions on Save`로 접근하면 가능하다.

다양하지는 않지만, 유용한 몇 가지의 기능을 제공하고 있다.

- [Reformat code](https://www.jetbrains.com/help/idea/reformat-and-rearrange-code.html#reformat-on-save)
- [Optimize imports](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#optimize-on-save)
- [Rearrange code](https://www.jetbrains.com/help/idea/reformat-and-rearrange-code.html)
- [Run code cleanup](https://www.jetbrains.com/help/idea/resolving-problems.html#code-cleanup)
- [Update copyright notice](https://www.jetbrains.com/help/idea/copyright.html)
- Live Edit

{% include img_assets.html id="/blog/2024/0428-actions_on_save/01.png" %}


기능 활성화 시, `.idea/workspace.xml` 파일에 관련 정의가 추가되는 방식이다.

정의도 IDE 전체가 아닌, 프로젝트 기반으로 저장되는 것으로 보인다.

{% include img_assets.html id="/blog/2024/0428-actions_on_save/02.png" %}

## 동작 모습

{% include youtube.html id="AZ0Cl4Yx8_M" %}
