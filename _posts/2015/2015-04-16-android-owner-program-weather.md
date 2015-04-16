---
layout: post
title: "[Android] 기상청 프로그램 v2.0.0"
date: 2015-04-16 10:25:00
categories: [owner program]
tag: [주인장 프로그램, 기상청, Android]
---

![]({{ site.url }} /assets/images/2015/2015-04-16-owner-program-weather01.png)
![]({{ site.url }} /assets/images/2015/2015-04-16-owner-program-weather02.png)
![]({{ site.url }} /assets/images/2015/2015-04-16-owner-program-weather03.png)
![]({{ site.url }} /assets/images/2015/2015-04-16-owner-program-weather04.png)
![]({{ site.url }} /assets/images/2015/2015-04-16-owner-program-weather05.png)

v2.0.0 추가사항

- Design
 - Material Design

- Dev
 - butterknife 적용
 - Navigation Drawer 추가
 - ObservableScrollView 추가

 - - -

#기상청 XML 데이터 문제점
 - 최근 기상청에서 일부 데이터가 들어오지않는 케이스 발견 (중요사항은 아님)
 - 0시~3시 사이 데이터 취득시 날짜가 내일부터 시작 (Offset처리로 해결)