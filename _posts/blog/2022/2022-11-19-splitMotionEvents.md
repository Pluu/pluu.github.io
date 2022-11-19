---
layout: post
title: "[메모] splitMotionEvents=false 처리 테스트"
date: 2022-11-19 22:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

멀티터치를 막는 것은 `splitMotionEvents=false` 옵션을 지정으로 일부 해결이 됩니다.

다만, 이 옵션을 지정을 어떻게 하는지에 따라서 동작이 달라지는 것 같습니다

> 테스트한 샘플 소스 : https://github.com/Pluu/SplitMotionEventsSample

- - -

## 수정 전 (=기본 동작)

{% include youtube.html id="KyMaCrW4O38" %}

## splitMotionEvents=false를 RecyclerView에만 기입

{% include youtube.html id="TUpaEzZufz4" %}

## 수정 후

{% include youtube.html id="w7zo-YvJdwo" %}

적용한 곳

- Activit Root
- 개별 ViewGroup
- RecyclerView