---
layout: post
title: "[Android] 기상청 프로그램 v0.2"
date: 2011-10-30 22:07:00
categories: owner-program
tag: [기상청, Android, owner program]
---

![]({{ site.url }} /assets/images/2011/2011-10-30-owner-program.png)

기상청에서 XML을 제공하고 있기때문에 지역정보 선택후

예보 정보를 화면에 표시하는 어플을 만들었습니다.

**문제점 1. 기상청은 공모전 대상자에게만 제공하는 DB가 있다. (현재날씨 정보 / 지역DB)**

**문제점 2. 구글에서 Geocoder 결과로 나타나는 이름이 기상청에는 관리하는 명칭과 다르거나 없을수 있습니다.**

 - 그래서, 명칭이 에러일 경우 직접선택하는 방법만 가능

**문제점 3. 기지국 기반 위치취득시 제대로 위치가 취득안되는 패턴이 발생.**