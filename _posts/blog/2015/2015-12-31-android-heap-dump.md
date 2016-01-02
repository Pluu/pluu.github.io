---
layout: post
title: "[번역] HeapDump로부터 그 순간의 각 객체가 가진 상태를 찾아보자"
date: 2015-12-31 23:30:00 +09:00
tag: [Android, HeapDump]
categories:
- blog
- Android
---

<!--more-->

본 포스팅은 [ヒープダンプから、その瞬間の各オブジェクトの持っている状態を調べよう](http://qiita.com/KeithYokoma/items/7b3a45819b9fbb1f14c7) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->
- - -

디버그 중, 무언가 좋지 않은 행동을 발견 시에 수상한 객체가 가진 상태가 어떤지를 찾을 경우에 있어, Debugger를 붙여 조사하는 것이 곤란할 때가 있습니다. 예를 들면, 수상한 행동이 재현되지 않는 경우를 생각해보면 또다시 같은 행동이 일어날 때까지 상당한 시간이 필요하게 될지도 모릅니다. 원래 어디가 문제인지 모르는데 무의미하게 Debugger를 연결하는 것은, 검증에 걸리는 시간이 쓸데없이 길어질 가능성도 있습니다.

이 기사는 수상한 행동을 발견한 순간에, Debugger에 의지하지 않고도 객체가 가지고 있는 상태가 어떤지를 알고 싶은 사람을 위한 순서를 정리했습니다.

## AndroidStuido에서 HeapDump를 받기

AndroidStuido에는, 각각의 프로세스가 얼마나 메모리나 CPU, GPU의 자원을 소비하고 있는지를 시각화해주는 도구를 포함하고 있습니다. 평소에는 Logcat를 사용하는 일이 많지만, 화면 아래의 Android Monitor라는 메뉴 중에 Logcat이외에 「Memory」「CPU」「GPU」「Network」Tab이 있어 각각 보고 싶은 프로세스마다 Graph가 표시되게 되어있습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/f85f4b20-595f-f998-741d-ca587ed1c403.png" />

가로축은 시간이므로, 그냥 두면 Graph가 흘러갑니다.

이 Graph는 사실은 단순히 Memory 사용량 상태를 시각화해주는 것만은 아닙니다. 이 Graph의 좌측을 보면, 몇 가지 버튼이 있는 것을 알 수 있습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/eca73b18-e214-efdc-34a0-1893c4acb73e.png" />

이 중에, 아래쪽 화살표를 가지는 위에서 3번째 버튼이 HeapDump를 받기 위한 버튼입니다.

HeapDump를 받아보면, Button 아이콘이 Graph 위에 나타납니다

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/4dd8e2b7-6784-45f9-5be4-6947c7cd2fce.png" />

이 아이콘이 표시된 타이밍의 HeapDump가 취득된 것을 알 수 있습니다.

## HeapDump에서 상태를 파악하고 싶은 Graph 찾기

HeapDump가 끝나면 hprof 파일이 자동으로 열립니다.

기본적으로 애플리케이션의 힙에 있는 각 클래스의 목록이 표시될 것 입니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/ca6b9398-53e1-d1fc-5219-c52698c7e5d4.png" />

여기서 어떤 클래스 이름을 클릭해보면, 힙에 올려져 있는 Instance 리스트가 우측에 표시됩니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/fcdcf235-1a61-7165-312f-1bf06dea3408.png" />

## Instance 목록을 열어 각각의 상태 체크

Instance 리스트 중 하나를 클릭하면, 상세 리스트가 확장되고 그 Instance의 내부 상태가 표시됩니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/e688a2a1-7fe0-26eb-0612-3cef7d3b936c.png" />

이걸로 Instance의 상태가 어떻게 되어있는지 훔쳐 볼 수 있습니다. 그리고 어느 Property가 틀린 값으로 되어있는지를 조사하는 것으로 수상한 행동을 찾아갈 수 있습니다.

## Target Class를 찾는 방법

몇 가지 방법이 있습니다.

1. 클래스 이름 리스트에 포커스를 맞춰, 보고 싶은 클래스 이름을 입력합니다
 - AndroidStuido에는 여러 곳에 직접 문자열을 입력해서 검색할 수 있습니다. Project 패널에 포커스가 있는 경우에는 각 모듈 안에서 문자열과 일치하는 부분을 하이라이트 해줍니다. 이것과 같은 방식으로 HeapDump의 클래스 리스트에서 Target Class를 찾을 수 있습니다.
2. 클래스 목록 표시를 Package 별로 변경하여 찾는다.
 - 클래스 목록 이외에, Package 목록 표시도 할 수 있게 되어있습니다. 클래스 목록에 있는 「Class List View」의 부분을 「Package List View」으로 변경하면 쉽게 표시를 바꿀 수 있습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/31829/04e0cce2-4c58-db3c-0279-0713a6ec98dd.png" />

## 정리

HeapDump이라면 아무래도 Memory Leak 조사에 주안점을 두는 경향이 되지만, AndroidStuido을 사용하면 Memory에 올려있는 객체의 상태도 볼 수 있습니다. 물론, 왜 그런 상태가 된 것인지를 확인하기 위해서는, Debugger를 연결해서 상태 변화하는 곳에 Breakpoint를 걸고 변화 시의 Stacktrace을 보는 등의 방법도 중요하지만, 원래 무엇이 어떻게 잘못되어있는가를 확인하려면 HeapDump를 활용하는 편이 다소 쉽게 할 수 있습니다.
