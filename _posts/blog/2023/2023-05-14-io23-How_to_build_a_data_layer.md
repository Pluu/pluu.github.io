---
layout: post
title: "[요약] How to build a data layer (Google I/O '23)"
date: 2023-05-14 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io23
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/P125nWICYps" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/001.png" %}

Data Layer란? 

- Data Layer는 이름에서 알 수 있듯이 애플리케이션 데이터를 관리하는 아키텍처 계층입니다.
- 앱에 가치를 부여하는 비즈니스 로직이 포함되어 있습니다.
  - 애플리케이션 데이터가 생성, 저장 및 업데이트되는 방식을 결정하는 실제 비즈니스 규칙입니다.

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/002.png" %}

Data Layer를 구성하는 컴포넌트

- Repositories
- Data Sources
- Data Models

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/003.png" %}

애플리케이션 데이터는 일반적으로 데이터 모델로 표현됩니다. 데이터 모델의 핵심은 데이터 모델이 불변이라는 점입니다. Task 클래스를 변경하려면 Data Layer를 사용해야 합니다.

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/004.png" %}

Task 클래스는 Data Layer에서 외부로 노출되어 다른 Layer에서 접근할 수 있으므로 외부 Data 모델이라고 할 수 있습니다. 하지만 데이터 계층 내부에서만 사용되는 내부 데이터 모델도 정의할 것입니다. 

데이터가 저장되는 각 위치에 대해 데이터 모델을 정의하는 것이 좋습니다.

> 이 영상에서는 로컬 데이터베이스에 저장된 작업인 LocalTask와 네트워크 서버의 작업인 NetworkTask로 분리하라고 되어있습니다. 이 두 가지 모두 Internal 데이터 모델의 예이며 데이터 소스에서 가져옵니다.

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/005.png" %}

- Data Source : DB나 네트워크 서비스와 같은 단일 소스에 데이터를 읽고 쓰는 작업을 담당하는 객체

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/006.png" %}

- Repositories : 여러 개의 Data Source를 하나로 모으는 곳
  - Task를 노출하고, Task의 업데이트하는 방법을 제공하고, 각 Task에 대한 고유 ID를 만드는 등의 비즈니스 로직을 실행
  - Data Source의 내부 데이터 모델을 작업에 결합하거나 매핑, 데이터 원본을 동기화하여 로컬 데이터베이스와 네트워크 간에 데이터를 복사하는 것입니다.

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/007.png" %}

{% include img_assets.html id="/blog/io/io23/How_to_build_a_data_layer/008.png" %}