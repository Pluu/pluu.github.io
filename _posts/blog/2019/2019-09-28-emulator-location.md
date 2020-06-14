---
layout: post
title: "Emulator 29.2.2 Canary에서 Location 사용하기"
date: 2019-09-28 19:00:00 +09:00
tag: [Android]
categories:
- blog
- Emulator
---

Android Emulator 29.2.2 Canary 버전부터 구글 지도를 이용하여 위치와 경로를 처리 더 쉽게 할 수 있다.

<!--more-->

| 새로운 버전                                                  | 기존 버전                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/001.png" }}" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/002.png" }}" /> |

Emulator 화면에서 `More` 기능을 선택하면 가장 위에 본 글에서 설명할 `Location` 항목이 있다. 

기존 버전과 차이 나는 부분은 Emulator에 구글 지도가 추가되어 더 정확한 위치를 찾을 수 있게 되었다.

## Single points

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/003.png" }}" /> 

검색창을 통해서 쉽게 내가 원하는 위치를 찾을 수 있다. 기존 구글 지도에서 검색 시 나오는 위치와 동일하다. 검색뿐만 아니라 지도의 지점을 선택하는 것도 가능하다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/004.png" }}" /> 

항목 선택 시 해당 항목의 정확한 위치와 주소를 지도상에 표시해준다. Emulator에서 선택한 위치를 실제 앱으로  전송하는 방법은 우측 하단의 `SET LOCATION` 버튼을 선택하면 된다.

자주 검색해보던 위치도 기존에서는 매번 위도/경도 위치 값을 넣으면서 찾아야 하는 불편함이 있었다. 이번 버전부터는 자주 사용하는 위치를 저장할 수 있는 기능도 추가되었다. 위 예시에서 `SAVE POINT` 를 선택한 경우 우측 `Saved points` 패널에 추가된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/005.png" }}" /> 

원하는 이름으로 지점의 주소, 위도, 경도값을 저장할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/006.png" }}" /> 

`Saved points` 패널에 저장된 지점을 선택 시 왼쪽 구글에 선택한 지점의 정보가 노출된다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/007.png" }}" /> 

저장된 지점을 목적지로 선택, 수정, 삭제 기능도 제공하고 있다. `Start a route` 를 선택 시 `Routes` 탭으로 목적지가 자동으로 선택된다.

## Routes

사용자 선택 및 저장된 경로를 가져온 후, 일정하게 위치를 전달하는 기능이다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/008.png" }}" /> 

> 기본 Location - Routes 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/009.png" }}" /> 

> 도착지가 지정된 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/010.png" }}" /> 

> 출발지/도착지 검색

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/011.png" }}" /> 

검색을 통해서 구글 지도가 제공하는 자동차/지하철/도보/자전거 경로를 선택할 수 있다. `Single points` 의 지점과 동일하게 자주 이용하는 경로를 `SAVE ROUTE` 를 이용해서 경로를 저장할 수도 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/012.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/013.png" }}" /> 

`Saved routes` 에 저장된 경로를 선택 시 구글 지도에 해당 경로들이 그대로 안내된다. 그리고 `PLAY ROUTE` 버튼을 선택하면 아래 그림과 같은 화면으로 변경되고, 안내되는 경로의 지점의 위도/경로가 위치를 수신받는 디바이스로 전달된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0928-emulator-location/014.png" }}" /> 

`PLAY ROUTE` 선택 후 현재 변경되는 위치를 좌측 아래를 통해서 확인 할 수 있다.

## Demo

### Single points

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/xPBqD6BzpoQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### Routes

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/2Cna4YMuFQ4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## 발견된 버그

1. 구글 지도의 경로 탐색이 되지 않는 지역에서 Routes 탭에서 경로 탐색 기능을 사용 시 `Loading Saved Route...` 메시지가 사라지지 않고 계속 유지된다.
2. `IMPORT GPX/KML` 을 이용해 위치 값을 가져온 후, `PLAY ROUTE` 선택 시 해제가 되지 않는 버그가 있다.

------

## Summary

Emulator 29.2.2부터 추가된 기능에는 Location으로보다 위치 정보를 더 이해하기 쉽게 전달할 수 있게 되었다. 대신 기존 버전에 존재하던 고도(altitude), 속도(speed) 값을 입력하던 항목은 제외되었다. 기존에도 부가정보였던 것이라 이번 버전부터 필수 정보만 처리하도록 변경된 것으로 보인다.

이번 버전에는 Location 기능 이외에도 멀티 디스플레이 기능도 추가되었다. 복수 디스플레이 대응도 이제는 Emulator로도 테스트할 수 있게 되었다.