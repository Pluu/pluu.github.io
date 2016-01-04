---
layout: post
title: "[번역] Android 의 Library 프로젝트를 빠르게 Maven Central 에 deploy하기"
date: 2015-05-24 18:00:00
tag: [Android, Gradle, Maven]
categories:
- blog
- Android
- Maven
---

이 포스팅은 [Android のライブラリプロジェクトを爆速で Maven Central にデプロイする](http://qiita.com/KeithYokoma/items/e9ee24e7f6a62623f2fb) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

5개의 Step으로 진행되고, Maven Central 에 Library를 deploy합니다.

###1. Sonatype 의 JIRA 에 SignUp

- - -

[Sonatype 의 JIRA](https://issues.sonatype.org/secure/Dashboard.jspa) 에 계정을 등록합니다.

계정 ID와 Pass 는 이후도 사용하므로 잃어버리지 말아주세요.

###2. Sonatype 의 JIRA 에, Deploy설정 의뢰 보내기

- - -

Sonatype 의 JIRA 의 Community Support 에 티켓을 보낸다.

[참고예](https://issues.sonatype.org/browse/OSSRH-8601)

필수인것은, GroupId, Project URL, SCM url, UserName。

GroupId 는 Maven 의 GroupId 입니다. 자신이 가진 프로젝트 도메인을 좋은 의미로 id 를 붙입시다.

Project URL 은, 코드나 이슈 관리가 이루어지는 장소이거나, 랜딩 페이지같은 장소를 지정합시다.

SCM url 은 (http://oss.sonatype.org)[http://oss.sonatype.org./].

UserName は은 deploy하는 사람의, Sonatype JIRA 계정명을 넣습니다.

티켓을 보내면, 2 ~ 3 일로 답변이 옵니다.

최초 Release 버전을 deploy하면 알려주세요라고 적혀있으므로, deploy하면 코멘트를 답시다.

###3. Maven 에 Deploy할 준비하기

- - -

[Gradle Plugin](https://github.com/chrisbanes/gradle-mvn-push) 을 사용해서 준비합니다.

먼저, ~/.gradle/gradle.properties를 준비합니다. 없으면 만들어주세요.

이 파일의 내용은, 이하의 내용을 기술합니다.

```
NEXUS_USERNAME=hogehoge
NEXUS_PASSWORD=oogggsss

signing.keyId=AABBCCDD
signing.password=safsfs
signing.secretKeyRingFile=~/.gnupg/secring.gpg
```

NEXUS_USERNAME 은 Sonatype JIRA 계정명, NEXUS_PASSWORD 는 Sonatype JIRA 계정 패스워드입니다.

그리고, 라이브러리의 Release판을 Deploy할때에는, PGP 서명이 필수입니다.

signing.* 은 서명 파일의 정보로 됩니다.

서명 파일이 없는 경우에는 gpg 커맨드로 만들어주세요. 프런트로 여러가지 물어봅니다만, 마음에 드는걸 설정해주세요.

signing.keyId 는, `gpg --list-secret-keys` 했을때, `sec 2048R/AABBCCDD 2014-04-09`의 `2048R`의 뒤에 붙어있는 8 글자의  16진수입니다.

signing.password 는, 서명 패스워드입니다.

signing.secretKeyRingFile 은 서명 파일의 Path 설정입니다.

그뒤, 서명을 관리하는 서버에 공개키를 업로드 합니다.

`gpg --keyserver hkp://pool.sks-keyservers.net --send-keys AABBCCDD`

다음으로, 프로젝트의 root 에 있는 gradle.properties를 편집합니다.

기술하는것은 아래 내용입니다.

```
VERSION_NAME=1.0.0
VERSION_CODE=1
GROUP=jp.yokomark

POM_DESCRIPTION=Library description
POM_URL=https://github.com/KeithYokoma/CompoundContainers
POM_SCM_URL=https://github.com/KeithYokoma/CompoundContainers
POM_SCM_CONNECTION=scm:git@github.com:KeithYokoma/CompoundContainers.git
POM_SCM_DEV_CONNECTION=scm:git@github.com:KeithYokoma/CompoundContainers.git
POM_LICENCE_NAME=The Apache Software License, Version 2.0
POM_LICENCE_URL=http://www.apache.org/licenses/LICENSE-2.0.txt
POM_LICENCE_DIST=repo
POM_DEVELOPER_ID=Hogehoge
POM_DEVELOPER_NAME=Hogehoge
```

버전 번호거나, Group ID이거나, 대충 임의의 내용을 입력합니다.

다음으로, Module에도 gradle.properties를 준비합니다. 없으면 만들어주세요.

내용은 아래와 같습니다.

```
POM_NAME=My Library Name
POM_ARTIFACT_ID=MyLibrary
POM_PACKAGING=aar
```

PACKAGING 을 aar 하는것으로, Android 의 각종 Library 결과물을 aar 로하여 업로드 가능하도록합니다.

마지막으로, Build Script를 수정합니다.

Library Module의 `build.gradle`에 아래 행을 기술합니다.


```groovy
apply from: 'https://raw.github.com/chrisbanes/gradle-mvn-push/master/gradle-mvn-push.gradle'
```

이걸로 준비 완료입니다.

###4. Deploy
- - -

```
./gradlew clean build uploadArchives
```

###5. Release 작업
- - -

Deploy는 Staging Server에서 실행됩니다. 이대로라면 Release 되지않습니다.

[https://oss.sonatype.org/](https://oss.sonatype.org/)

여기에서, Sonatype JIRA 계정으로 로그인해서, Staging에 있는 자신의 Repositories를 Release하는 작업을 합니다.

좌측 메뉴의 Build Promotion 에서 Staging Repositories 을 선택해서, 자신의 Repositories를 목록에서 선택합니다.

아래에 표시되는 탭에서, Repositories의 내용을 확인하고, 문제가 없다면, 상단의 TAB의 하단에 있는 Close 버튼을 누릅니다.

잠시기다리면 validation가 작동되고, 문제가 없으면 Close 가 끝납니다.

Close 가 끝나면, Refresh 버튼으로 목록이 갱신되고, 다시한번 자신의 Repositories를 선택해서, Release 버튼을 누릅니다.

이걸로 Release 작업이 종료됩니다.

###appendix. Deploy 실패했다면
- - -

Javadoc 이 어딘가에서 실패한다면, 아래의 Script를 Module의 build.gradle에 기술합니다.


```groovy
afterEvaluate {
    javadocs.classpath += files(android.plugin.runtimeJarList)
}
```
