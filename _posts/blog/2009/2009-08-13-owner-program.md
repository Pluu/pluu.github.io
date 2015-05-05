---
layout: post
title: "Visual C# + Flash + PHP"
date: 2009-08-13 18:13:00
tag: [주인장 프로그램]
categories:
- blog
- owner-program
---

<!--more-->

1. Visual C# + .NET Framework
 - 이미지 캡쳐한 후 파일 저장 및 서버에 업로드
 - Process.Start()로 PHP 호출

2. PHP 내장 객체 MING + Flash + ActionScript
 - 그림판 Flash에서 사용자의 행동 저장, ActiveX를 이용해 음성 녹음
 - PHP 내장 객체 MING을 이용하여 Flash의 행동 + 음성을 결헙하여 SWF 생성

클라이언트 프로그램을 실행했을 때의 상태

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2009/2009-08-13-owner-program.jpg" }}" />

원하는 영역을 선택하면 JPG 파일로 저장되고, 이 파일이 서버로 업로드 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2009/2009-08-13-owner-program2.jpg" }}" />

업로드 후 미리 만들어둔 PHP 화면으로 Process.Start() 함수를 이용하여 이동

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2009/2009-08-13-owner-program3.jpg" }}" />

현재 cafe24를 이용해서 쓰고있는데  cafe24는 PHP MING을 지원하지않는 버전이라서
결과화면은 못보여주는 상태