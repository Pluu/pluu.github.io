---
layout: post
title: "[번역] DroidKaigi 2016 ~ Android CI: 2016 edition"
date: 2016-07-23 23:50:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [Android CI: 2016 edition](https://speakerdeck.com/gyugyu/android-ci-2016-edition) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

YUSUKE YAGYU AT DROIDKAIGI 2016 DAY 02

ANDROID CI: 2016 EDITION

## 2p

**자기소개**

- GMO Pepabo 주식회사 기술부 기술기반팀
- 여러 가지 만들고 여러 가지를 수정하는 사람 및 테스트하는 아저씨
- Android 앱 개발 자체는 메인이 아닙니다
- 매일 아침 최신 PHP / Ruby / Python3를 빌드하는 것이 사는 보람

## 3p

**대상 청취자**

- 초심자 ~ 중급자
- 앱 개발은 할 수 있지만, 테스트는 어디서부터 해야 할지 잘 모르는 사람
- 막연하게 테스트 코드는 적을 수 있지만, AndroidStudio에서만 테스트해 본 사람

## 4p

**오늘의 테마**

- 개발 흐름에 따른 Android 테스트 분류
- Android 테스트 자동화 Plugin
- Android에서의 CI Plugin
- Android CI 패턴

## 5p

**DISCLAIMER**

- 이 발표는 2016년 2월 시점의 정보이며, 이 자료를 볼 때에는 최신 정보라고는 보장 못합니다.

## 6p

**먼저 중요한 결론을**

- Andriod 개발에 한정적이지 않고, 자동 테스트 / CI에서 어느 부분을 쓰고 버릴지, 일종의 가치판단에 따른다
- 판단 기준으로는 기술적 제약, 인적 자원, 시간적 제약, 예산의 제약을 들 수 있다

## 7p

개발 흐름에 따른 Android 테스트 분류

## 8p

**복습 : 일반적인 개발 흐름**

- 「일반적인」 V자 개발 모델
- 요건분석 → 기본설계 → 상세설계 → 개발 →
- 단위 테스트 → 결합 테스트 → 시스템 테스트 → 주입 테스트

## 9p

**테스트 종류와 자동 테스트의 대응**

- 단위 테스트 : Unit Test, 일부 Instrumentation Test
- 결합 테스트 : 대부분의 Instrumentation Test
- 시스템 · 주입 테스트 : End-to-end Test
- (보충) 탐색적 테스트 : 대부분 수동에 의지

## 10p

**UNIT TEST**

- app/src/text 디렉토리
- JVM / JUnit4 기반 테스트
- 빠른 테스트
- Android SDK를 의존하는 부분은 테스트 불가능

## 11p

**INSTRUMENTATION TEST (ANDROID TEST)**

- app/src/adnroidTest 디렉토리
- 실제 단말 · 에뮬레이터를 사용한 테스트
- Android SDK를 의존하는 코드도 테스트 가능
- Activity 표시도 테스트 가능

## 12p

**INSTRUMENTATION TEST의 장점**

- 외부 의존(e.g. Web API 요청)인 코드를 Mock 처리 가능
- Mock 처리하는 것으로 예외상태 테스트가 가능

## 13p

**INSTRUMENTATION TEST 어려움**

- e.g. Web API 요청이 존재하는 경우, Mock 처리 된 Response가 최신이라는 것을 어떻게 보장하는가?
- Fixture 기반으로 JSON Schema로 검증하는가?
- 더미 API 서버를 올리는가?

## 14p

**END-TO-END TEST**

- 빌드된 APK에 대한 조작 테스트
- 인스톨된 다른 APK와의 협업을 시험
- 스크린샷 촬영도 가능

## 15p

**END-TO-END의 어려움**

- e.g. 어디까지를 해서 End-to-end Test라고 정의하는가?
- Production 서버에 접속하는가?
- Build Flavor를 사용해서 디버그용 API를 가지는 검증용 서버에 접속하는가?

## 16p

Android 테스트 자동화 Plugin

## 17p

**ANDROID 자동 테스트로 빈번히 나오는 단어**

- JUnit
- Mockito
- Robolectric
- Espresso
- UI Automator
- Appium

## 18p

**ROBOLECTRIC**

- Unit Text용 Android SDK shim
- JVM 상에서는 RuntimeException이 되는 Android SDK 부분을 shadow로 바꾼다
- Android SDK 의존 코드를 Unit Text 가능하게 한다

## 19p

**ROBOLECTRIC는 유용한가?**

- 「부분적으로는」 유용
- Bundle, Intent는 단순한 Map으로 이용 가능
- AsyncTaskLoader의 동기화
- 이외의 (특히 단말 결합도가 높은) API는 약하다

## 20p

**MOCKITO**

- Unit Test, Instrumentation Test로 사용 가능한 Mock 라이브러리
- 이외에도 후보는 있다
- Spy, Stub의 차이에 주의

## 21p

**ESPRESSO**

- Instrumentation Test의 높은 레벨 Wrapper
- 비동기의 Activity 테스트를 동기적으로 적을 수 있다
- Testing Support Library의 일부

## 22p

**UI AUTOMATOR**

- End-to-end Test 도구
- Testing Support Library의 일부
- Android OS >= 4.1

## 23p

**APPIUM**

- Selenium 호환의 End-to-end 테스트 도구
- Java, JavaScript (Node), .NET, PHP, Phython, Ruby, Perl 등 언어에 불문하고 테스트 코드를 적을 수 있다

## 24p

**테스트 페이즈와 도구 선정**

- 테스트를 지원하는 도구를 선정한다
- End-to-end Test 도구 선정은 고려할 필요가 있다
- Testing Support Library는 필수

## 25p

**테스트 자동화 이론**

- 실행 속도는 단위 > 결합 > 주입 순으로 느려진다
- 즉 케이스 수는 단위 > 결합 > 주입 순으로 하는 것이 베스트
- 이것은 Android 개발에서도 같다고 할 수 있다

## 26p

**테스트를 어떻게 자동화할 것인가?**

- 가동 중인 앱이 있는 경우와 신규개발인 경우에서의 변화
- 가동 중인 경우 : Instrumentation Test / End-to-end로 가동을 보장하면서 리팩토링
- 신규개발인 경우 : MVP Architecture 등으로 SDK로부터 Lock을 분리하고 Unit Test를 두텁게 한다

## 27p

**어디까지 테스트를 적어야하는가?**

- 예를 들어 커버리지 100% 라고 해도 예상 누락이 발생한다
- End-to-end Test로 행복하게 통과 (성공 패턴) 이외를 적는 것은 어렵다
- 「안심할 때까지 테스트를 적는다」(@ahomu)

## 28p

**거꾸로 말하면**

- End-to-end Test만을 적어서 「움직이는 것만」은 보장한다는 것도 하나의 방법
- 테스트의 계획은 인적 자원의 많고 적음, 멤버의 기술력, 릴리즈까지 남은 시간에 따라서 도출한다

## 29p

**중요한 것은**

- 팀의 멤버 전원이 자동 테스트의 중요함을 느낄 것
- 팀의 개발자 전원이 테스트 코드를 적게 되는 것
- 테스트 코드 작성이 어려운 부분을 나눌 수 있는 「테스트에 강한 엔지니어」가 있으면 더욱 좋다

## 30p

Android에서의 CI Plugin

## 31p

**키워드**

- Jenkins
- 컨테이너 기반 CI 서비스
- Device Farm
- Smartphone Test Farm

## 32p

**JENKINS**

- Jenkins + Git Plugin / GitHub Plugin
- 서버 구성을 컨트롤 가능 = 실제 단말 접속 가능
- Unit Test, Instrumentation Test, End-to-end Test 전부 커버
- 「Jenkins 장인」 문제

## 33p

**컨테어 기반 CI**

- e.g. Travis CI, Circle CI, Drone, Wercker...
- 비교적 싼 가격 (0엔~)으로 테스트 가능
- JVM 기반의 고속 테스트를 특기로 한다
- Activity Test / End-to-end Test를 한다면 별도의 구성이 필요

## 34p

**DEVICE FARM**

- 복수의 실제 단말(단말, OS 버전)을 테스트 실행환경으로 사용할 수 있다
- 독자적 테스트 DSL, Web 기반의 화면조작 등
- DFaaS(Device Farm as a Service)의 Amazon/Google 도입 (Google Cloud Test Lab은 Closed Test 중)

## 35p

**CI용 DFAAS의 선정기준**

- 기존의 테스트 자산(Instrumentation Test, End-to-end Test)을 사용할 수 있는가?
- Jenkins Plugin이 준비되어 있는가?
- Gradle Plugin이 준비되어 있는가?
- Web API가 준비되어 있는가?

## 36p

**SMARTPHONE TEST FARM (STF)**

- Device Farm을 in-house로 가지는 도구
- Device Farm의 표준 기능을 얼추 가지고 있다
- adb connect로 리모트 디버그

## 37p

**STF 2.0**

- REST API (단말 상태, 단말 Lock 취득)의 추가
- 보다 자동 테스트와 친화성이 높은 기능을 취득

## 38p

**CI를 전제로 한 테스트를 적는다**

- 테스트 전후로 단말의 상태가 바뀌지 않는다는 것을 보장한다
- 에뮬레이터를 파기한다, 단말을 스와이프 하기 등
- 단위 > 결합 > 주입의 케이스 수 이론을 지키지 않으면, 금방 실행시간이 폭발적으로 길어진다

## 39p

**계획 전술**

- Jenkins를 유지 보수하는 인적 자원이 확보된다면 Jnekins
- Jenkins를 유지 보수하는 인적 비용을 DFaaS 이용로로 전환할 수 있으면, 컨테이너 기반 CI + DFaaS

## 40p

**중요한 것은**

- CI를 하는 것으로 자동 테스트를 습관화하며 품질을 떨어트리지 않는 것을 팀의 멤버 전원이 동의할 것
- 현시점에서는 Device Farm도 과도기이며, 특정 플랫폼에 지나치게 의존하면 레거시화되는 리스크를 떠안게 된다

## 41p

Android CI 패턴

**패턴 1**

- Jenkins + 실제 기기 접속 (혹은 에뮬레이터)
- 가장 심플한 구성
- 남은 자원으로 시작 가능하다는 간편함이 있다
- 단말의 다양화에는 수동으로 해야 한다

## 42p

**패턴 2**

- Jenkins + (Docker) + STF + 실제 기기 접속
- 심플한 구성을 확장해서 단말의 다양성에 추종 가능한 패턴
- 단말을 준비하는 비용과 유지보수에 드는 인적 지원이 과제

## 43p

**패턴 3**

- 컨테이너 기반 CI 서비스 + DFaaS
- 유지보수에 자유로운 CI 패턴
- DFaaS가 보유하는 단말에 제약을 받는다

## 44p

**우리 회사에의 CI 채용상황**

- minne 모바일 앱에 CI 도입
- 패턴 2와 패턴 3을 병용하여 비교 검토 중

## 45p

**결론을 다시 말하면**

- Andriod 개발에 한정적이지 않고, 자동 테스트 / CI에서 어느 부분을 쓰고 버릴지, 일종의 가치판단에 따른다
- 판단 기준으로는 기술적 제약, 인적 자원, 시간적 제약, 예산의 제약을 들 수 있다
