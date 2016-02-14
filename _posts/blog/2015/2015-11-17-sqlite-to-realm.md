---
layout: post
title: "Android Sqlite 에서 Realm 으로 데이터 이관"
date: 2015-11-17 22:40:00
tag: [Android, Sqlite, Realm]
categories:
- blog
- Android
- Realm
---

<!--more-->

최근 안드로이드 웹툰 프로젝트를 GitHub에 완전 공개하면서

RxJava, RxAndroid, Realm 관련 작업을 반영해보기로 했습니다

Rx 자체는 별로 어려운 문제없이 진행했지만, Realm 이 가장 큰 문제였습니다.

## Realm

[Ream 공식 사이트](https://realm.io/kr/)

- SQLite와 Core Data를 대체해서 사용 가능
- ORM Databse

별도의 설명은 Realm 공식 사이트를 참조하시면 됩니다.

#### Realm 으로 바꾸게 된 이유는

1. 그냥... 그냥... 그냥...
2. Sqlbrite 도 써봤으니 이것도 써보자
3. 프로젝트 대공사 하니 DB 도 바꿔보자

별 이유없이 그냥 바꿔보자하는 마음이였습니다.

## Sqlbrite

Sqlbrite 는 Square 사에서 발표한 SQLiteOpenHelper 를 Rx 스타일로 Wrapper 한 DB 사용 라이브러리입니다.

공식 설명은 아래와 같습니다.

**A lightweight wrapper around SQLiteOpenHelper which introduces reactive stream semantics to SQL operation.**

[Sqlbrite GtiHub Site](https://github.com/square/sqlbrite)

**Sqlbrite 를 사용한 이유**

- Rx 스타일 작업 지원
- 믿고 쓰는 Square 라이브러리

## Sqlite to Realm

DB 의 주체를 바꾸는 작업이였기때문에, 몇가지 고려해야할 사항이 있습니다.

1. Realm 의 코어부분은 NDK 로 작성
2. Realm 은 Sqlite 기반으로 작성된 DB 가 아니다
3. Realm 에서 공식적으로 Sqlite 의 데이터를 이관하는 문서는 없다 (작성기준 Realm 0.84.2)

이런 내용만 보면 눈치빠른 분이라면 Sqlite 에 있는 데이터를 Realm 으로 직접 넣는 방법밖에 없다는 점을 알 수 있습니다.

다행히 Realm 영문 사이트의 `ADD-ONS` 에 `SqliteToRealm` 라는 프로젝트가 참고 가능합니다.

[SqliteToRealm GtiHub Site](https://github.com/jixaCo/SqliteToRealm)

위 GitHub Repository 의 ` SqliteHelper.java`, `RealmHelper.java`, `SqliteToRealm.java` 파일이 핵심 로직입니다.

Sqlite에 저장되어있는 테이블의 데이터를 Realm으로 옮기는 작업을 볼 수 있습니다.

## 추천하는 방법

**1. 처음부터 Realm 을 쓰세요.**

서론에 언급한것처럼 Realm 은 sqlite 와 호환되지 않는 데이터베이스입니다.

SqliteToRealm 방법을 사용하는 경우,

sqlite 관련 로직 중 `SQLiteOpenHelper` 를 상속받은 객체 소스를 지울 수 없습니다.

**2. 어쩔 수 없다면 Rx + Preference 를 이용해보세요.**

앱 실행시 이관 작업을 Rx 로 작업한 후 Preference 로 이관 완료 Flag 를 저장해두고,

이후 실행시 해당 Flag 를 체크하여 이관 작업을 진행하지 않으면 됩니다.
