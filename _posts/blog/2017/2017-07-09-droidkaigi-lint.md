---
layout: post
title: "[번역] DroidKaigi 2017 ~ Inspection 및 Android Lint Custome Rule에 따른 단일 책임 원칙의 실천"
date: 2017-07-09 21:50:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ インスペクションとAndroid Lint Custome Ruleによる、単一責任実装の実践](https://www.slideshare.net/cch-robo/android-lintsrppractice) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

Inspection 및 Android Lint Custome Rule에 따른 단일 책임 원칙의 실천

## 2p 서론

TDD 및 DDD가 시끄러운 요즘, 코드 구현의 **단일 책임의 원칙 (SRP)** `의역 ⇒ 단순화`가 요구되고 있습니다. 

Android 앱 개발도 성숙기가 되고, 신 Activity의 반성에서 **역할(책임)마다 클래스를 분할**하고 소스 코드의 유지 보수 및 테스트 용이성 향상에 대한 관심이 높아지고 있지요.

## 3p Inspection 소스 지적 기능

Android Studio에는 **Inspection**이라는 강력한 소스 분석 (지적) 기능이 있다는 것을 알고 있을 것입니다.

문제점이 있는 부분을 편집기에서 하이라이트 표시하거나 

"Analyze"메뉴의 "Inspect Code..."로 지적 목록을 "Inspection Results 도구 창"에서 카테고리별로 나열도 해주는 기능입니다.

## 4p Android Lint도 함께 제공됩니다

이 "Inspection Results" 왼쪽 창에 있는 카테고리에 "Android > Lint > Correctness" 등, Android Lint 검사 항목이 반영되어있음을 알고 있는 사람도 많지 않을까요.

> Android Studio의 Inspection에는 **Android Lint도 이용되고** 있습니다.

## 5p 독자 Custom Rule로 지적시키기

Android Lint는 독자적인 Custom Rule을 만들 수 있습니다. 

그리고 Custom Rule을 만들기 위해 Java 소스 코드의 정적 분석 기반도 제공되고 있습니다.

이 세션에서는 단일 책임이 되는 간단한 구현을 강제 (강요)하는 오리지널 Android Lint Custome Rule 생성 및 이용에 대해 발표합니다.

## 6p 대상자

초급자 ~ 중급자

- 메소드가 복잡하지 않도록 실천하고 싶은 분
- Android Lint의 Custom Rule과 정적 코드 분석에 대해 이해하고 싶은 분

## 7p 샘플 프로젝트 소개

[cch-robo/Android_Lint_SRP_Practice_Example](https://github.com/cch-robo/Android_Lint_SRP_Practice_Example)
[https://github.com/cch-robo/Android_Lint_SRP_Practice_Example](https://github.com/cch-robo/Android_Lint_SRP_Practice_Example)

본 세션에서 사용하는 단일 책임이 되는 간단한 구현의 강제 (강요)를 촉구하는 오리지널 Android Lint Custome Rule 프로젝트입니다. 

필드 변수(상태)를 변경하는 메소드가 복수 존재 (복합 책무)하는 경우, 그 공유 정도에서 책임(역할)의 혼재의 종류와 문제를 보고합니다.

## 8p 샘플 프로젝트 소개

- 책임 복합 메소드에 대해 **Inspection**으로 편집기에서 메소드 이름이 강조 표시되고 마우스 오버로 문제에 대한 보고서를 확인할 수 있습니다.

## 9p 샘플 프로젝트 소개

- Analyze ⇒ Inspect code ... 으로 프로젝트에 존재하는 문제 (책임 복합 메소드) 부분의 목록을 확인할 수 있습니다.

## 10p 샘플 프로젝트 소개

`주의` : 샘플 프로젝트에서는, Java 소스 탐색에 **JavaPsiScanner**, Java 소스 분석에 **JavaElementVisitor**를 사용하도록 다음과 같은 제한 사항이 있습니다.

- com.intellij.psi의 AST 패키지를 사용하고 있습니다.
- 기존의 일차 자료 문서에 설명이 없습니다. android/tools의 lint는 사용할 수 없습니다.

## 11p 이용에 있어서의 보충

- 프로젝트의 디렉토리 **supplementary**의 **lint-srp-example.jar**를 _USERNAME_/.android/lint~ 디렉토리에 복사하면 Android Studio에서 샘플 기능을 사용할 수 있습니다. 
- 제한 조건의 책무 복합 메소드를 감지하고 있으므로 모든 패턴의 검출이나 추론적인 책임 판단까지 대응하고 있지 않습니다.
- 일부 환경에서는 일본어 출력이 깨재셔 나옵니다.

## 12p 자기소개

- 이름
   - robo (兼高理恵) Twitter : @cch_robo
- 일
   - Java 기술자
   - 요구 사항 정의 설계 및 구현 (최근에는 Android 개발 중심의 프리랜서)
- 좋아하는 것
   - 모바일 단말

## 13p

단일 책임의 원칙

## 14p 단일 책임의 원칙이란 무엇인가

**단일 책임의 원칙** 또는 **단일 책임의 원칙** (SRP : Single Responsibillity Principle)은 "클래스의 **책무** (변경의 원인이 되는 것⇒**역할**)은 오직 하나이어야 한다."...라는 원칙입니다. 

다른 말로는 "클래스가 관리하는 **상태** (책무 변경되는 것)은 복수 있어서는 안 된다."...라는 것입니다.

하나의 상태는 복수의 요소로 구성되더라도 상관없습니다.

## 15p 단일 책임은 추상화를 높이기

서적 「**Clean Code 애자일 소프트웨어 전문가의 기술**」 제10장 클래스에서는 다음과 같은 언급이 있습니다. 

- 클래스 규칙의 필두는 캡슐화와 은폐를 사용하여 작게 하는 것.
- 작게 하는 것은 **책임의 수를 적게 하여 코드의 추상화를 높이는 것**.
- 시스템을 재사용 가능한 작은 클래스의 집합시켜 가동부을 줄이는 것.
- 이렇게 되면 유지 보수시의 영향 범위도 작아진다.

## 16p 단일 책임이 깨지는 요인

단일 책임의 원칙은 클래스를 "**책임을 제한하고 작은 것으로 하는 것**"... 아주 간단하지만 사람들이 말하는 神Activity가 생기는 것은 왜일까요.

나는 "A가 ㄱ일 때는 1, A가 ㄴ일 때는 2, 하지만 A가 ㄱ이고 B가 ㄷ일때는 3"... 등 

**요구 사양 자체가 흐름 절차형이 된 것**

> ... 이 요인의 하나라고 생각합니다.

## 17p 단일 책임이 깨지는 요인 (2/2)

설계 공정이 적은 경우, 요구 사양 자체가 흐름 절차형이 되어있다고 작은 책임 클래스로 분할하는 설계 시간이 없으므로,

1. 모든 상태를 글로벌로 접근할 수 있도록 하나의 클래스에 배치하고
2. 상태를 변경하는 수동적 및 능동적 절차를 만들고
3. 플래그와 조건 분기로 관리하기 때문

> ...처럼 보입니다.

## 18p 단일 책임의 원칙을 지키려면

요구 사양 자체가 흐름 절차형이 되어도 **단일 책임의 원칙을 지키도록 하려면** "**무엇이 무엇에 대해, 메시지를 보내는가**"라는 객체지향 프로그래밍의 원점에서 자문하면서 프로그램을 할 것입니다.

흐름 절차 주체로부터 객체가 주체가 되도록 관점을 바꾸는 것

> ...라고 생각합니다.

## 19p 엔터프라이즈 시스템에서의 논란

엔터프라이즈 시스템 개발은 예전에 Transaction Script 패턴과 Domain Model 패턴의 논란이 있었습니다.

> 이전 페이지의 단일 책임이 깨진 요인이 이 논란과 겹친다고 생각해서 여기에서 언급하겠습니다.

## 20p Transaction Script 패턴

- 데이터와 행동을 다른 객체로 나누어 기능별로 행동 절차를 만드는 패턴. 
- 장점
   - 절차이므로 어떤 행동도 구현할 수 있다. 
- 단점
   - 절차이므로, 로직의 기술처를 강제할 수 없고, 중복 및 상호 모순이 발생하더라도 알아채기 어렵다.

## 21p Domain Model 패턴

- 데이터와 행동을 하나의 (역할과 책임) 객체에 캡슐화하는 패턴.
- 장점
   - 데이터와 행동이 은폐되어 캡슐화되므로, 로직의 기술처는 명확해 중복이나 모순을 알기 쉽다.
- 단점
   - 설계 비용이 많이 든다.
   - 객체에 대한 기능 요구라고 말할 수 없는 것에는, DDD의 Service 패턴을 별도로 적용할 필요가 있다.

## 22p 참고 정보 사이트

- 도메인 모델에 대한 일본/미국의 온도차
  - [http://ameblo.jp/ouobpo/entry-10036477015.html](http://ameblo.jp/ouobpo/entry-10036477015.html)
- 새삼스럽게 물어보지 못하는 "도메인 모델"과 "트랜잭션 스크립트"
  - [http://d.hatena.ne.jp/higayasuo/20080519/1211183826](http://d.hatena.ne.jp/higayasuo/20080519/1211183826)
- 트랜잭션 스크립트 VS 도메인 모델
  - [http://d.hatena.ne.jp/kounan13/20100407/1270619662](http://d.hatena.ne.jp/kounan13/20100407/1270619662)

## 23p

Android Lint Custom rule 작성의 기초

## 24p 일차 자료 (문서)

샘플은 [Android Studio Project Site](http://tools.android.com/)의 다음 페이지의 기초 지식을 바탕으로 만들고 있습니다. 

- Tips > Android lint
   - [http://tools.android.com/tips/lint](http://tools.android.com/tips/lint)
- Writing a Lint Check
   - [http://tools.android.com/tips/lint/writing-a-lint-check](http://tools.android.com/tips/lint/writing-a-lint-check)
- Writing Custom Lint Rules
   - [http://tools.android.com/tips/lint-custom-rules](http://tools.android.com/tips/lint-custom-rules)

# 25p 일차 자료 (문서)의 개요

- [> Tips> Android lint](http://tools.android.com/tips/lint)
   - lint 명령어 도구의 사용법 설명 페이지
- [Writing a Lint Check](http://tools.android.com/tips/lint/writing-a-lint-check)
   - lint check 기초 지식의 페이지
   - 소스의 문제를 지적하기 위해서 사용, **ISSUE**과 **Detector** 등의 구성 요소 설명
- [Writing Custom lint Rules](http://tools.android.com/tips/lint-custom-rules)
   - lint check 새로 만들기의 구체적인 절차 페이지
   - 개발 환경을 만드는 방법과 구현 및 사용에 대한 구체적인 예

## 26p 일차 자료 (소스 코드)

샘플 프로젝트는 다음 페이지의 소스 코드 내용을 참고로 하고 있습니다.

- googlesamples / android-custom-lint-rules
   - [https://github.com/googlesamples/android-custom-lint-rules](https://github.com/googlesamples/android-custom-lint-rules)
   - **Writing Custom Lint Rules로 소개하고 있습니다**
- android / platform / tools / base / studiomaster-dev / / lint / libs
   - [https://android.googlesource.com/platform/tools/base/+/studio-masterdev/lint/libs/](https://android.googlesource.com/platform/tools/base/+/studio-masterdev/lint/libs/)
   - `개발 버전의 소스를 참고하고 있는 것에 주의`

## 27p 기타 (lint 관련 일차 자료)

lint의 사용법에 대한 설명 페이지 

- Improve Your Code with Lint 
   - [https://developer.android.com/studio/write/lint.html](https://developer.android.com/studio/write/lint.html)
- Gradle Plugin User Guide > Lint support 
   - [http://tools.android.com/tech-docs/new-build-system/user-guide#TOCLint-support](http://tools.android.com/tech-docs/new-build-system/user-guide#TOCLint-support)
- LintOptions 
   - [http://google.github.io/android-gradledsl/current/com.android.build.gradle.internal.dsl.LintOptions.html#com.a ndroid.build.gradle.internal.dsl.LintOptions](http://google.github.io/android-gradledsl/current/com.android.build.gradle.internal.dsl.LintOptions.html#com.a ndroid.build.gradle.internal.dsl.LintOptions)

## 28p

Android Studio로 Lint Custom rule을 개발한다

## 28p Android Studio에서 개발하는 방법

Lint Custom rule은 **Java 응용 프로그램**입니다. 따라서 다음과 같은 방법을 이용합니다.

- 기존의 Custom Lint rule 개발 프로젝트를 사용 [googlesamples / android-custom-lint-rules](https://github.com/googlesamples/android-custom-lint-rules)를 로컬에 zip 압축을 풀어 소스를 변경합니다.
- 신규 Android 프로젝트를 수동으로 편집해서 신규 Android 프로젝트를 만들고 Lint Custom rule의 Java 프로젝트가 되도록 수동 편집합니다.

## 29p 기존 프로젝트를 사용하는 경우

일차 자료의 [Writing Custom Lint Rules](http://tools.android.com/tips/lint-custom-rules)는 이쪽에 소개되어 있습니다.

1. [googlesamples / android-custom-lint-rules](http://tools.android.com/tips/lint-custom-rules)의 zip 파일을 다운로드하여 로컬로 연다
2. build.gradle의 jar 태스크와 src 디렉토리 트리의 Java 소스 파일을 변경

## 30p 새 프로젝트를 수동 편집하는 경우

샘플 프로젝트에서는 이쪽을 이용했습니다.

1. 적당한 신규 Android 프로젝트를 만든다 (fig-1) 
   - `참고` : Activity는 만들지 않도록 합니다. 
2. 프로젝트에서 app 모듈을 제거 (fig-2)
   - File > Project structur로 Project structure 대화 상자를 열고 왼쪽 Modules 아래의 app 모듈을 선택하고 왼쪽 위 `-` 아이콘으로 삭제합니다.

## 32p 수동 편집하는 경우 (2/7)

3. Project 뷰로 app 디렉토리를 삭제한다 (fig-3). 
   - 그리고 [app ▼] 실행 설정도 삭제합니다. (fig-4)
   - `주의` : 이전 단계는 논리 삭제이므로 app 모듈의 실제 디렉터리는 남아 있기 때문이다.
4. build.gradle을 덮어쓴다
   - build.gradle의 내용을 android-custom-lint-rules Java 응용 프로그램으로 변경합니다.

> (구체적인 내용은 후술)

## 33p 수동 편집하는 경우 (3/7)

5. src 디렉토리를 새로 생성한다
   - src 툴킷 (src/main/java/...src/test/java/...)을 프로젝트·디렉토리에 새로 작성합니다.
6. Android Studio를 다시 시작합니다. 
   - File > Invalid Cash / Restart... 에서 **Invalid and Restart**를 실행합니다. 재시작한 후, File > Project	structure에서 Project structure의 모듈 구성을 확인하면, 설정 항목이 자동 설정되어있는 것을 확인할 수 있습니다.

## 38p ~ 39p build.gradle 덮어쓸 내용

```
apply	plugin:	'java'

repositories	{
   jcenter()
   maven {
      url "http://dl.bintray.com/android/android-tools"
   }
}

dependencies {
   compile 'com.android.tools.lint:lint-api:25.3.0'
   compile 'com.android.tools.lint:lint-checks:25.3.0'

   testCompile 'junit:junit:4.11'
   testCompile 'com.android.tools.lint:lint:25.3.0'
   testCompile 'com.android.tools.lint:lint-tests:25.3.0'
   testCompile 'com.android.tools:testutils:25.3.0'
}

// jar 파일 이름과 Lint-Registry는 자신에게 맞게 변경하세요
jar {
   archiveName 'lint-example.jar'
   manifest {
      attributes("Lint-Registry":
                 "com.example.ExampleIssueRegistry")
   }
}

defaultTasks 'assemble'
```

## 40p Lint 라이브러리에 소스를 첨부

> 개발 쉽도록 Lint 라이브러리에 소스를 첨부해 봅니다.

## 41p Lint Custom rule 관련 라이브러리

샘플 프로젝트에서 사용하는 Lint Custom rule 관련 라이브러리(jar) 목록

| :-- | --: |
| lint-25.3.0.jar | Lint 도구 관련 |
| lint-api-25.3.0.jar | Lint API 관련 |
| lint-checks-25.3.0.jar | 기존 Detector 관련 |
| lint-test-25.3.0.jar | 기존 Detector 테스트 관련 |
| lombok-ast-0.2.3.jar | lombok AST 관련 |
| uast-162.2228.14.jar | com.intellij AST (PSI) 관련 |

## 42p 라이브러리 소스

다운로드 원래 저장소에는 각 라이브러리의 소스도 배치되어 있습니다.

- lint, lint-api, lint-checks, lint-tests
   - [http://dl.bintray.com/android/android-tools/com/android/tools/lint/](http://dl.bintray.com/android/android-tools/com/android/tools/lint/)
- com-intellij, lombok-ast
   - [http://dl.bintray.com/android/androidtools/com/android/tools/external/](http://dl.bintray.com/android/androidtools/com/android/tools/external/)

## 43p 라이브러리 소스 (2/3)

저장소에 있던 각 라이브러리 소스

| :-- | --: |
| lint | lint-25.3.0-sources.jar |
| lint-api | lint-api-25.3.0-sources.jar |
| lint-checks | lint-checks-25.3.0-sources.jar |
| lint-test | lint-test-25.3.0-sources.jar |
| lombok-ast | lombok-ast-0.2.3-sources.jar |
| uast | uast-162.2228.14-sources.jar |

## 44p 라이브러리 소스 (3/3)

샘플 프로젝트 **supplementary** 폴더에 이전 페이지에서 소개한 소스 jar를 놓아두었습니다. 괜찮으시면, 이용해주세요.

## 45p ~ 46p 라이브러리에 소스를 첨부

1. Android Studio의 Project 뷰에서 Project를 선택하여 External Libraries를 표시
2. External Libraries에서 Gradle에서 DL한 라이브러리 목록에서 위의 lint 관련 라이브러리를 선택 (fig-1)
3. 오른쪽 클릭해서 컨텍스트 메뉴를 열어 Library Properties...를 클릭하여 Library Properties 대화 상자를 연다 (fig-2)
4. 대화 상자 왼쪽 위의 + 로 파일 대화 상자를 연다 (fig-3)
5. 파일 대화 상자에서 라이브러리에 해당하는 내려받아 놓은 소스 jar를 선택하고 OK를 클릭 (fig-4) jar의 내용에서 소스가 첨부된다 (fig-5)
6. Library Properties 대화 상자에서 [OK]를 클릭하여 소스 첨부를 종료한다

## 52p 참고 : 라이브러리 소스의 누락

**lint-tests**와 **uast** 기존 Detector 테스트 및 com.intellij 패키지의 `소스가 누락`되어 있습니다.

- lint-tests 기존 Detector 테스트 소스는 [android/platform/tools/base/studiomaster-dev](https://android.googlesource.com/platform/tools/base/+/studio-master-dev/lint/libs/lint-tests/src/test/java/com/android/tools/lint/checks/)를 참조해주십시오.
- [JetBrains/intellij-community](https://github.com/JetBrains/intellij-community)의 com.intellij.psi 패키지를 사용할 수 없는지 조사해 보았습니다만 구성이 다른 것 같습니다.

## 53p 참고 : 개발 프로젝트의 빌드

Android Studio를 사용한 개발은 Terminal에서 gradlew 명령을 사용하여 빌드합니다.

```
$ ./gradlew clean ⇒ 빌드 결과를 클리어
$ ./gradlew test ⇒ 빌드 및 테스트를 실행
$ ./gradlew assemble ⇒ 빌드 및 jar 파일 만들기
```

> Android Studio 메뉴의 Build 및 Run은 이용하지 않습니다.

## 54p

Android Lint에서 Java 소스 분석의 기본

## 55p Java 소스 분석의 기본

Android Lint에서는 Detector라고 부르는 Issue 검출기를 만들어 프로그램에 문제가 없는지 확인합니다.

- Android Lint는 Java 소스 내용의 문제도 감지할 수 있도록 소스에서 **AST(추상 구문 트리)**에 구문 분석된 _com.intellij.psi._**PsiElement**을 기본 노드로 한 각종 **노드**를 제공해주는 기반을 가지고 있습니다.

## 56p 노드

Java 소스 구문 분석의 노드는 Java 언어의 언어 요소를 나타낸 것입니다.

- 노드는 Class, Field, Method, 문장 (Statement), 식 (Expression), 참조 (Reference), 이름 (Itentifier), 리터럴 (Literal) ... 등의 구문 요소에 대응하고 있습니다.
- 각 노드는 우선순위와 부모 관계가 있고, 구문 분석된 소스는 노드의 중첩 구조로 되어 있습니다.

## 57p

구문 분석된 소스 노드 구조 예

## 58p 소스 분석 전에 사전 학습

Lint Custom rule 개발에 있어서 Java 소스 분석은 각 노드의 부모 관계와 중첩에서 구문 내용을 파악할 수 있습니다.

1. 어떤 구문이 어떤 트리 구조되는지
2. 부모가 되는 노드에서 직접 특정 자식 노드를 참조할 수 있는지, 할 수 있다면 어떤 방법이 준비되어 있는지

...를 사전에 파악 (학습) 할 필요가 있습니다.

## 59p 1. 구문 트리 구조를 배우기

샘플 프로젝트에서는, Java 소스의 구문 분석 결과의 트리 구조 (노드의 중첩 구조) 학습과 확인을 위해 `PsiClassStructureDetector`을 준비했습니다.

- PsiClassStructureDetector는 Lint에서 제공되는 노드의 부모를 디버깅 출력만을 위한 Detector입니다.

## 60p 1. 구문 트리 구조를 배우기 (2/3)

PsiClassStructureDetector 사용

1. `PsiClassStructureDetectorTest`에 샘플을 따라 디버그 출력하고자 하는 구문의 가상 Java 소스를 확인하는 테스트 메소드를 추가
2. Termianl에서 테스트를 실행

```
$ ./gradlew test
```

## 61p 1. 구문 트리 구조를 배우기 (3/3)

3. 디버그 출력 내용을 확인

build/test-results/binary/

TEST-... PsiClassStructureDetectorTest.xml 확인

- 모든 테스트 결과가 1개로 출력되므로 확인하고 싶은 테스트만을 기술하는 것을 추천합니다
- `checkProject가 두번 실행되는` 것에 주의
   - 1 개의 테스트 메소드를 beforeCheckProject과 afterCheckProject가 두번 실행됩니다.

## 62p 1. 구문의 디버깅 출력 (1/3)

디버깅 출력 포맷

```
beforeCheckProject (Ph.1)<<<

beforeCheckFile (Ph.1) -> Source=>>>
*** 체크하는 파일의 원본 내용 ***
<<<

*** Node 디버깅 출력 포맷 ***

afterCheckFile (Ph.1) -> Source=>>>
*** 체크 한 파일의 소스 내용 *** 
<<<

afterCheckProject (Ph.1)<<<
```

## 63p 1. 구문의 디버깅 출력 (2/3)

Node 디버깅 출력 포맷

```
Node=Node 이름
NodeImpl=Node 실제 이름
Source=>>> Node 텍스트 <<<
parent=>>> 부모 Node 텍스트 <<< : 부모 Node 실태 이름
children=>>> [Node 텍스트 : 자식 Node 실태 이름, Node 텍스트 : 자식 Node 실태 이름 ...] <<<
```

## 64p 1. 구문의 디버깅 출력 (3/3)

Node 디버그 출력 예

```
Node=PsiReferenceExpression
NodeImpl=EcjPsiReferenceExpression
Source=>>>isSuccess<<< 
parent=>>> 
if (isSuccess) {
   message = "success";
} 
<<<:EcjPsiIfStatement 
children=>>>[isSuccess:EcjPsiIdentifier, 
]<<<
```

## 65p 2. 노드의 소스에서 배우기

예를 들어, **if 문**을 나타내는 **PsiIfStatement**에는

- 조건식 ⇒ getCondition () : PsiElement
- then 절 (문장) ⇒ getThenBranch() : PsiStatement 
- else 절 (문장) ⇒ getElseBranch() : PsiStatement 

...이 준비되어 있습니다.

이 문서는 제공되지 않기 때문에, 노드가 제공하는 메서드를 찾아서 확인할 수 있습니다.

## 66p 기존 감지기 소스에서 배우기

lint-checks/co.kr/android/tools/lint/checks
   - [https://android.googlesource.com/platform/tools/base/+/studio-masterdev/lint/libs/lint-checks/src/main/java/com/android/tools/lint/checks](https://android.googlesource.com/platform/tools/base/+/studio-masterdev/lint/libs/lint-checks/src/main/java/com/android/tools/lint/checks)

기존 Detector 소스에서 다양하게 배울 수 있습니다.

```
// JavaPsiScanner를 구현 한 Detector
ApiDetector.java, IconDetector.java,
RtlDetector.java, SdCardDetector.java
SecurityDetector.java, SupportAnnotationDetector.java,
UnusedResourceDetector.java, ViewHolderDetector.java
WrongImportDetector.java
```

## 67p ~ 68p 구문 분석된 노드의 수령 절차

Java 소스 분석을 위해, 구문 분석된 각종 **노드**를 제공받기에는 다음 단계를 밟습니다.

1. **Detector**를 상속하고, **JavaPsiScanner** _interface_를 구현 한 `독자 Detector` 클래스를 작성
2. getApplicablePsiTypes()를 오버라이드하여 제공하길 원하는 **노드 유형 목록**을 반환하도록 구현
3. **JavaElementVisitor**을 상속 한 `독자 AST Visitor` 클래스를 작성
4. createPsiVisitor()를 오버라이드하여 `독자 AST Visitor`의 인스턴스를 반환하도록 구현. 구문 분석된 노드를 제공받을 수 있도록 한다.
5. `독자 AST Visitor`의 각 노드 종별 visit 메소드로 제공된 노드를 수령
   - visitClass(PsiClass) : void 등으로 수령한다.

## 69p 구문 분석된 노드의 수령 절차 (3/3)

구체적인 구현의 흐름은 다음 장 **Lint Custom rule 작성의 기본 흐름**과 샘플 프로젝트의 소스를 확인해주십시오.

다음 단계로는 사전에 학습 한 **특정 구문 트리 구조**의 지식과 **부모 노드에서 특정 자식 노드의 취득 방법**에 대한 지식으로
제공된 노드의 중첩보다 Java 소스의 내용을 파악하여 생각되는 문제가 없는지 확인합니다.

## 70p 문제가 있는 구문 구조를 상정하는

Lint에서 문제가 되는 구문 구조를 지적하려면 **문제가 되는 구문 구조를 상정**하고 있어야 합니다.

- 예를 들어, 메소드 boolean 인수를 if 문에서 사용 상태를 변경한다면, 미리 다른 것을 하는지 알고 있으니까 메소드에 다중 역할을 맡기는 것을 피하기 위해 **조건 성립의 처리 함수**와 `조건부 성립의 처리 함수`로 나눠야 합니다.

## 71p 구문 구조를 상정하기 (2/3)

상기의 `문제가 되는 구문 구조`는 단순하게 생각하면 다음과 같이 될 것입니다.

1. 메소드가 boolean 인수를 가진다
2. 메소드 내부에 if 문이 있다
3. if 문 조건식에서 boolean 메소드 인수를 사용하고 있다
4. if 문 then 블록에서 필드 변수를 변경하고 있다
5. if 문 else 블록에서 필드 변수를 변경하고 있다

## 72p 구문 구조를 상정 (3/3)

여기까지 상정되면 문제가 되는 소스의 트리 구조를 디버깅 출력하고 폭넓게 대처할 수 있도록 문제 구문 구조를 추상화하여 트라이&에러로 프로그램을 해나가면, Detector를 만들 수 있다고 생각합니다.

> Java 소스 분석 프로그램 개발은 꾸준한 노력과 작업의 반복입니다.

## 73p 샘플의 분석 로직

샘플 프로젝트의 소스 분석 로직의 자세한 내용은 시간 일정과 소스를 보시면 알기 때문에 여기에서는 생략하겠습니다.

> 특징적인 것은 변수가 지역 변수인지 여부를 확인하기 위해 ElementUtil.ScopeBacktrack.seek()로 메소드 내에서 백트럭하는 것 정도입니다.

## 74p 샘플의 분석 로직 (2/3)

논리의 개요는

1. 상태 (Field 변수)가 책임 (역할)을 나타내면 단순화
2. 상태를 변경하는 메소드가 복수 존재하면 대상
3. 각 메소드의 상태 요소의 공유도로

Issue 보고 (아래)를 실시한다.

- **책임 독립** : 변경 상태 요소가 타인과 공유되지 않는다
- **책임 공유** : 변경 상태 요소가 타인과 공유되고 있다
- `책임 혼합` : 변경 상태 요소가 타인과 과부족이 있다

... 라는 단순한 것입니다.

## 75p 샘플의 분석 로직 (3/3)

`제한 사항`

- 검사를 할 수 있는 것은 primitive 값만
   - 자신 클래스의 primitive값 필드가 대상입니다. 다른 클래스・인스턴스의 상태 변경은 제외로 확인하지 않습니다. 
- 처리 간소화를 위한 내부 클래스와 익명 클래스의 상태 변경 내용은 무시하고 있습니다.

## 76p 참고 : checkProject 2 회 실행

**구문의 트리 구조를 배우고도** 언급했지만, 테스트로는 checkProject ⇒ 노드 스캔(스캔)이 2회 실시하고 있습니다. 

첫 번째와 두 번째는 노드 구성에 차이가 있습니다. 

- 첫 번째 노드 검사로는 Java 소스 그대로의 노드 구성되어 있습니다. 
- 두 번째 노드 검사는 리터럴이나 참조식이 괄호 식으로 대체하고 있습니다.

## 77p 참고 : ... 2 회 실행 (2/5)

구체적으로는,

1. 숫자나 문자 리터럴 (**PsiLiteralExpression**)과 변수 이름 등의 참조 (**PsiReferenceExpression**)가
2. 괄호 식 (`PsiParenthesizedExpression`)로 대체, 공백 (`WhiteSpace`)이 추가되기도 합니다.

> Detector 테스트를 통과하려면 양자 모두에 대응하지 않으면 안됩니다.

## 78p 참고 : ... 2 회 실행 (3/5)

샘플 프로젝트 **supplementary** 폴더에 1번째 **checkProject_loop1.txt**와 두 번째 `checkProject_loop2.txt` 디버깅 출력 내용의 파일을 넣어 두었습니다.

> 괜찮으시면, diff로 차이를 확인하시기 바랍니다.

## 79p 참고 : ... 2 회 실행 (4/5)

`두 번 실행 이유` **Lint 테스트시의 메시지로부터**

The lint check produced different results when run on the normal test files and a version where parentheses and whitespace tokens have been inserted everywhere.

The lint check should be resilient towards these kinds of differences (since in the IDE, PSI will include both types of nodes.

## 80p 참고 : ... 2 회 실행 (5/5)

Your detector should call

**LintUtils.skipParenthes(parent)** to jump across parentheses nodes when checking parents, and there are similar methods in LintUtils to skip across whitespace siblings.

- 다양한 환경에 대응할 수 있도록 첫 번째는 추상 구문 트리로 두 번째는 괄호와 공백을 포함시키고 있습니다.
- LintUtils.skipParenthes(parent)를 사용하여 불필요한 괄호 노드를 건너 뛰십시오.

## 81p 참고 : 임의의 반복 검사 지정

노드 검사는 반복하도록 요구할 수 있습니다.

- afterCheckProject()에서 인수의 Context를 사용하여 context.requestRepeat(Detector, Scope.JAVA_FILE_SCOPE) : void하면, 노드 검사의 반복을 요청할 수 있습니다.
- 몇 번째 노드 검사인지는 beforeCheckProject()와 afterCheckProject()에서 context.getPhase() : int라고하면 확인할 수 있습니다.

## 82p 

Java 소스를 해석할 Lint Custom rule 작성의 기본 흐름

> 샘플 프로젝트의 소스 코드도 함께 확인하시기 바랍니다.

## 91p 독자 사용자 지정・규칙 Detector 클래스를 작성

사용자 정의 규칙 Issue 감지 클래스는 Detector를 상속하고 Java 소스를 분석하기 위해 JavaPsiScanner을 구현합니다.

```
// Detector는、
// com.android.tools.lint.detector.api 패키지의 클래스
public class ExampleDetector extends Detector implements Detector.JavaPsiScanner {
… 생략
}
```

## 84p 보고 문제의 정보를 나타내는 Issue를 생성

이전 페이지 문제 감지 Detector 클래스 내부에서 보고하는 문제 정보 Issue 인스턴스를 생성합니다.

```
// Issue, Category, Severity, Implementation, Scope, 는、
// com.android.tools.lint.detector.api 패키지 클래스입니다.
public static final Issue EXAMPLE_ISSUE = Issue.create(
      "MixedWriteFieldsClassification", // Issue ID 문자열
      "변경의~책무 혼합 문제", // Issue 문제 설명 표제
      "변경하는~합니다。", // Issue 문제 대처 설명
      Category.CORRECTNESS, // Issue 카테고리
      4, // 심각도 (경:1〜10:중)
      Severity.WARNING, // Issue 보고 심각 유형
      new Implementation( // Detector과의 매핑
            ExampleDetector.class, // 문제 검출 Detector
            Scope.JAVA_FILE_SCOPE)); // 검출 대상 범위(복수 가능)
```

## 85p 검사 전후의 자체 처리 오버라이드 · 메소드

```
… 생략
// 프로젝트 검사의 전후 처리가 필요한 경우는 다음을 재정의
@Override
public void beforeCheckProject(Context context) { … }
@Override
public void afterCheckProject(Context context) { … }

// 각 Java 소스・파일 스캔 (AST Node visit)의 전후에
// 처리가 필요한 경우는 다음을 재정의
@Override
public void beforeCheckFile(Context context) { … }
@Override
public void afterCheckFile(Context context) { … }
… 생략 // Context ⇒ com.android.tools.lint.detector.api
```

## 86p Java 소스 분석을 할 AST Visitor를 지정

createPsiVisitor() 메소드를 오버라이드하여 Java 소스 분석의 자체 AST Visitor 인스턴스를 지정합니다.

```
… 생략
// JavaElementVisitor ⇒ com.intellij.psi 패키지
// JavaContext ⇒ com.android.tools.lint.detector.api
@Override
public JavaElementVisitor createPsiVisitor(@NonNull JavaContext context) {
   return new JavaElementExampleVisitor(context);
}
… 생략
```

## 87p AST Visitor 분석 대상의 AST 노드를 지정 (한정)

getApplicablePsiTypes()을 오버라이드하여 분석 대상으로하는 AST (추상 구문 트리) 노드를 지정합니다

```
… 생략
// AST 노드의 PsiElement, PsiClass, PsiMethod는
// com.intellij.psi 패키지의 클래스
@Override
public List<Class<? extends PsiElement>> getApplicablePsiTypes() {
   return Arrays.asList(
     PsiClass.class,
     PsiMethod.class);
}
… 생략
```

## 88p Java 소스를 분석하는 AST Visitor 클래스를 작성

```
private static class JavaElementExampleVisitor extends JavaElementVisitor {
   private final JavaContext mContext;
   private JavaElementWalkVisitor(JavaContext context) {
      mContext = context;
      … 생략
   }

   // getApplicablePsiTypes()에서 지정한 AST 노드의 처리처
   // 분석 visit 노드・엔트리에 대한 메소드를 오버라이드하여
   // 인수 AST 노드를 분석하고 문제를 발견하는 과정을 구현합니다.
   @Override
   public void visitClass(PsiClass aClass) { … }
   @Override
   public void visitMethod(PsiMethod method) { … }
   … 생략
}
```

## 89p AST 노드 분석에 대해서

> 전장 **Android Lint에서 Java 소스 분석의 기초**를 참조해주십시오.

## 90p 문제를 발견한 경우 Issue 보고서를 발행

```
// 문제가 발견된 AST 노드로부터 Java 소스의 해당 부분을 특정하여
// Issue 보고서를 발행 (보고) 합니다.
private void myReport(@NonNull PsiElement detected) {
   // Java 소스의 문제 검출 위치를 특정
   // Location은 com.android.tools.lint.detector.api 의 ㅡㄹ래스
   String contents = mContext.getJavaFile().getText();
   int startOffset = detected.getTextRange().getStartOffset();
   int endOffset = detected.getTextRange().getEndOffset();
   Location location = createLocation(mContext.file, contents, startOffset, endOffset);
   // Issue로 보고하는 메시지 내용을 작성
   String message = "메소드가~추천합니다";
   // Issue 보고서를 발행
   mContext.report(EXAMPLE_ISSUE, location, message);
}
```

## 91p Issue 레포트를 발행 (2/3)

```
private Location createLocation(
      @NonNull File file, @NonNull String contents, 
      int startOffset, int endOffset) {

   DefaultPosition startPosition = 
      new DefaultPosition(
            getLineNumber(contents, startOffset),
            getColumnNumber(contents, startOffset),
            startOffset);

   DefaultPosition endPosition =
      new DefaultPosition(
            getLineNumber(contents, endOffset),
            getColumnNumber(contents, endOffset),
            endOffset);
   return Location.create(
         mContext.file, startPosition, endPosition);
}
```

## 92p Issue 레포트를 발행 (3/3)

```
private int getLineNumber(
      @NonNull String contents, int offset) {
   // this li1ne number is 0 base.
   String preContents = contents.substring(0, offset);
   String remContents = preContents.replaceAll("\n", "");
   return preContents.length() - remContents.length();
}
private int getColumnNumber(
      @NonNull String contents, int offset) {
   // this column number is 0 base.
   String preContents = contents.substring(0, offset);
   String[] preLines = preContents.split("\n");
   int lastIndex = preLines.length -1;
   return preContents.endsWith("\n")
         ? 0
         : preLines[lastIndex].length();
}
```

## 93p 동작 확인 테스트 만들기

> Issue를 감지 Detector 할 수 있으면, 동작 확인을 해 봅니다.

## 94p 독자 사용자 지정・규칙 Detector 테스트를 작성

LintDetectorTest를 상속하여 Detector 테스트・클래스를 만듭니다.

```
// LintDetectorTest 은
// com.android.tools.lint.checks.infrastructure 패키지의 클래스
public class ExampleDetectorTest extends LintDetectorTest {
   … 생략
}
```

## 95p 테스트 대상의 설정 (1/3)

LintDetectorTest 추상 메소드 getDetector()를 구현하여 테스트 할 Detector를 지정합니다.

```
private Set<Issue> mEnabled = new HashSet<Issue>();

protected ExampleDetectorTest getDetector() {
   return new ExampleDetectorTest();
}
… 생략
```

테스트 클래스 구성 주위의 구현의 참고 표

[googlesamples / android-custom-lint-rules](https://github.com/googlesamples/android-custom-lint-rules)

## 96p 테스트 대상의 설정 (2/3)

getIssues()를 오버라이드하여 테스트 대상의 Issue를 지정합니다.

```
… 생략
@Override
protected List<Issue> getIssues() {
   return Arrays.asList(ExampleDetector.EXAMPLE_ISSUE);
}
… 생략

// 다음 페이지의
// TestConfiguration 은 LintDetectorTest 의 서브 클래스
// LintClient ⇒ com.android.tools.lint.client.api
// Issue, Project ⇒ com.android.tools.lint.detector.api
```

## 97p 테스트 대상의 설정 (3/3)

getConfiguration()를 오버라이드하여 테스트 대상 Issue 만 테스트하도록 지정합니다.

```
… 생략
@Override
protected TestConfiguration getConfiguration(
         LintClient client, Project project) {
   return new TestConfiguration(client, project, null) {
      @Override
      public boolean isEnabled(@NonNull Issue issue) {
         return super.isEnabled(issue)
                  && mEnabled.contains(issue);
      }
   };
}
… 생략
```

## 98p 테스트・메소드 작성 (Issue 무검출 패턴)

```
public void testNoIssueClass() throws Exception {
   mEnabled.clear();
   mEnabled.addAll(Arrays.asList(
         ExampleDetector.EXAMPLE_ISSUE));
   String expected = "No warnings."; // 경고없음을 지정
   String result = lintProject(
      java( // 분석할 Java 소스의 가상 파일 경로
         "src/test/pkg/NoIssueClass.java",
         // 분석할 Java 소스의 코드・텍스트
         "" + "package test.pkz;\n"
            + "public class NoIssueClass {\n"
            … 생략
            + "}\n"
      )
   );
   assertEquals(expected, result);
}
```

## 99p 테스트 메소드 작성 (Issue 감지 패턴)

```
public void testExistIssueClass() throws Exception {
   mEnabled.clear();
   mEnabled.addAll(Arrays.asList(
         ExampleDetector.EXAMPLE_ISSUE));

   // 감지 소스 위치 (행과 위치) 및 오류 수와 경고 수까지 지정합니다.
   String expected = "" // 상정하고 있는 경고 메시지를 지정
         + "src/test/pkg/ExistIssueClass.java:18: Warning: "
         … 경고 메시지 생략
         + " public void greet() {\n"
         + " ~~~~~\n"
         + "0 errors, 1 warnings\n";
   String result = lintProject(
      java( … 생략 … )
   );
   assertEquals(expected, result);
}
```

## 100p 작성한 테스트 실행

Android Studio의 Terminal에서 다음 gradle 명령을 사용하여 테스트를 실행합니다.

```
$ ./gradlew clean
$ ./gradlew test
```

테스트 결과는 XML 형식으로 아래에 출력됩니다.
build/test-results/binary/

> 테스트가 성공하면, 작성한 Issue를 저장할 수 있도록 합니다.

## 101p Issue 저장소 클래스를 생성

IssueRegistry를 상속하여 Issue 저장소 클래스를 만듭니다.

```
// IssueRegistry는 com.android.tools.lint.detector.api의 클래스
public class ExampleIssueRegistry extends IssueRegistry {
   // getIssues()를 오버라이드하여 보관할 Issue를 지정합니다.
   // (주) Issue로부터 Detector도 결정됩니다!
   @Override
   public List<Issue> getIssues() {
      return Arrays.asList(
            ExampleDetector.EXAMPLE_ISSUE); // 복수 지정 가능
   }
}
```

## 102p build.gradle에 Lint용 jar 만들기 설정을 추가

```
// Jar Task로 만들 Android Lint에 대한 속성을 설정하여
// 독자 Lint 사용자 정의・규칙 Jar 파일을 작성합니다.
jar {
   // Jar 파일 이름을 지정
   archiveName 'lint-example.jar'

   // Android Lint용 매니페스트 속성에
   // 자체 작성한 Issue 저장소를 지정
   manifest {
      attributes("Lint-Registry":
                 "com.example.ExampleIssueRegistry")
   }
}
```

## 103p 독자 Custom Lint rule의 jar를 생성

Android Studio의 Terminal에서 다음 gradle 명령을 사용하여 jar를 만듭니다.

```
$ ./gradlew clean
$ ./gradlew assemble
```

> 빌드 된 jar는 아래에 출력됩니다. build/libs/

## 104p 독자 Custom Lint rule을 사용할 수 있도록 한다

빌드한 독자 Custom Lint rule (jar)을 다음으로 복사하여 Android Studio에서 사용할 (참조할 수) 있도록 합니다.

```
# MAC, Linux
$ mkdir ~/.android/lint
$ cp 独自カスタムLint.jar ~/.android/lint
```
```
# Windows
> cd Users¥ユーザ名
> mkdir .android¥lint
> copy 独自カスタムLint.jar .android¥lint
```

## 105p AS로 독자 Custom Lint rule을 이용하기

Android Studio를 시작하면 독자 Custom Lint rule이 활성화되어 있습니다.

- 코드 Issue가 있으면 편집기에서 문제 부분이 강조 표시됩니다.
- **Analyze** 메뉴의 "Inspect Code ..."를 실행하면 Android Lint > Warrning from Custom Lint Check로 검색 범위에 포함되는 모든 Issue가 나열됩니다.

## 106p AS로 독자 Custom Lint rule을 이용하기 (2/3)

(편집기에서 문제 부분의 강조 표시)

## 107p AS로 독자 Custom Lint rule을 이용하기 (3/3)

(Inspect Code ...에서 문제 부분 나열)

## 108p 독자 Custom Lint rule 지적 중지

File > Other Settings > Default Settings ...에서 **Default Settings** 대화 상자를 열고 왼쪽 창에서 Editor > Inspections을 선택 Editor > Inspections 설정을 엽니다.

모든 서드파티 Lint Custom rule은 Android > Lint > Collectness에 해당하므로 `Error from Custom Lint Check`와 `Warrning from Custom Lint Check`의 체크를 제외할 경우, 검사도 해제됩니다. (fig-1)

## 109p 독자 Custom Lint rule 지적 중지 (2/2)

(fig-1)

## 110p `주의 : lint 명령에서 사용할 수 없습니다`

이번에 작성한 독자 Lint Custom rule은 Android SDK의 lint 명령줄 도구에서는 사용할 수 없습니다.

Android SDK/tools/lib/의 Lint 라이브러리 (jar)는 AST(추상 구문 트리)에 lombok.ast만을 사용하여 com.intellij 관련 API가 포함되어 있지 않기 때문입니다.

```
$ lint --list

Could not load custom rule jar file 独自カスタムLint.jar
java.lang.NoClassDefFoundError:
com/android/tools/lint/detector/api/Detector$JavaPsiScanner
```

## 111p 단일 책임의 원칙의 실천

> 샘플・프로젝트의 Lint Custom rule과 Android Studio의 검사를 이용하여 단일 책임의 원칙을 실천해보겠습니다.

## 112p 단일 책임의 원칙의 실천

샘플・프로젝트의 사용자 정의 Lint 규칙에서 Android Studio 편집기 화면은

- 필드 변수(상태)를 변경하는 방법이 복수이고,
- 자신도 필드 변수(상태)를 변경하는 메소드에 대해,
- 자동으로 메소드 이름의 하이라이트(또는 점선 표시)을 해줍니다. ⇒ **복합 책임의 지적**

> 복합 책임의 완전한 지적이 아니므로, 익숙해지기까지의 보조 정도로 생각하십시오.

## 113p 단일 책임의 원칙의 실천 (2/2)

샘플・프로젝트의 사용자 정의 Lint 규칙은 자동으로 소스 코드를 생성하는 것은 아닙니다. 우선은 나름대로의 코드를 작성해보세요.

`제한 사항`

- 확인 가능한 필드 변수 (상태)은 primitive 값뿐입니다.
- 처리 간소화를 위한 내부 클래스와 익명 클래스의 상태 변경은 무시하고 있습니다.

## 114p Lint 규칙을 사용하면 포인트

- 필드 변수의 생성은 초기화를 명시하기 위해 생성자에서 합니다.
- 초기화용 메소드는 상태 변경용 메소드인지 구별이 되지 않기 때문에 만들지 않습니다.
- 소멸자는 상태 변경용 메소드인지 구별이 되지 않기 때문에 클로징 등 인스턴스 파기 작업이 필요한 경우가 아니면 만들지 않습니다.

## 115p 규칙을 사용하면 포인트 (2/2)

- 상태 변경 메소드는 클래스에 단 하나만이 되도록 합니다. `이 점은 수정 목적이 하나의 경우에 한정됩니다.`
- 도메인 로직 배포용 패키지를 설치합니다. 클래스의 분할 및 분리가 필요한 경우 이 아래에 각 도메인의 하위 패키지를 마련해 클래스를 배치합니다.

## 116p Lint 규칙에 의한 지적

"메소드가 변경하는 필드 변수 (상태)"에 대해 4가지 지적을 합니다.

1. 다른 메소드와 완전히 독립되어 있습니다.
   - 책임 독립
2. 다른 메소드와 완전히 공유하고 클래스 유일합니다.
   - 책임 공유
3. 다른 메소드와 완전히 공유하지만, 클래스 유일하지 않습니다.
   - 책임 공유
4. 다른 메소드와 완전히 독립이지도 완전 공유이지도 아닙니다.
   - 책임 혼재

## 117p ~ 119p 지적 당 대응

복합 메소드의 지적은 완벽하지 않습니다. 오판도 있으므로 제안 내용에 연연하지 마십시오.

- **책임 독립**
   - 지적이 적절하다고 생각한다면 도메인 로직 패키지에 새로운 클래스를 만들고 해당 메소드와 필드 및 관련 메소드를 분리합니다.
- **책임 공유**
   - 지적이 적절하다고 생각하는 경우 클래스에서 단 하나의 상태 변경 메소드를 만들고 각 메소드를 상태 변경을 하지 않는 접수 방법으로 변경하고 이를 호출합니다. `결국은 책임 독립의 메소드를 목표로 합니다.`
- **책임 혼재**
   - 지적이 적절하다고 생각한다면, 다른 메소드에 부족을 발생시키고 있는 수정할 필드 변수(상태)의 건수가 가장 큰 메소드를 찾아 메소드와 변경할 상태를 분할해 봅니다. 또는 어떤 메소드에도 포함되는 최대 공약수적인 상태가 없는지 찾고 분리합니다. `우선은 책임 독립과 책임 공유의 메소드를 목표로 합니다.`

## 120p 최소한의 책임을 찾기

단일 책임의 원칙을 제대로 판단하려면 기계적으로 실현 될 수 없는 역할의 추상화가 필요합니다. 지적이 없는 것이 이상적이지만, 상태 변경 목적이 비단일시의 현실 목표는 "`책임 혼합을 지적되지 않는다`"이지요.

가장 중요한 것은,

1. 이 클래스의 책임 (역할)는 무엇인가,
2. 무엇을 지키지 않으면 안되는 것인지,

> ...을 의식하여 클래스를 작게하는 것이라고 생각합니다.

## 121p 단일 책임의 원칙 소감

**단일 책임의 원칙**의 소감은

- 상태 G(책임/역할)은 한정하고 복수가 되어서는 안된다.
- 상태 G(책임/역할)는 단순한 Java Bean 아니라 역할에 대한 제약을 지키고 있지 않으면 안된다.
- 상태 G에 변경 사항이 복수이고 공개된 접수처를 복수 마련하고도 상태 변경 메소드는 목적마다 단 하나만을 목표로 하고, 제약 로직 및 제약기구를 가지고 있어야 한다.

> ...를 충족하는 것으로 생각합니다.

## 122p

요구 사양 자체가 흐름 절차적이어도, "**무엇이 무엇에 메시지를 보내느냐**"라는 객체지향 프로그래밍의 관점을 잊지 않도록

> 유의하고 싶습니다.