---
layout: post
title: "DroidKaigi 2024 참가 후기"
date: 2024-09-15 22:30:00 +09:00
tag: [주인장 이야기, DroidKaigi]
categories:
- blog
- Owner
- DroidKaigi
---

올해로 4번째로 오프라인으로 참석했다. 코로나로 몇 년간 참석이 어려웠던 시절이 있었지만, 2017년부터 꾸준히 오프라인으로 참석하는 행사 중 하나이다.

<!--more-->

## DroidKaigi 10th

{% include img_assets.html id="/blog/2024/0915-droidkaigi/01.png" %}

이번 DroidKaigi는 10번째 행사라고 한다.

> Android 기술 정보 공유와 커뮤니케이션을 목적으로 하는 컨퍼런스이다.

총 49개의 세션과 1,150명의 참석자가 함께하는 행사라고 소개했다. 마지막으로 참석한 2019년에 비해서도 100명 이상 늘었다.

총 3일의 행사 중 첫날은 워크샵이고, 남은 2일은 세션으로 이뤄졌으며 총 5개의 트랙으로 구성되어 있다.

{% include img_assets.html id="/blog/2024/0915-droidkaigi/02.png" %}

> 출처 : https://2024.droidkaigi.jp/timetable/9-12/

올해도 일부 세션은 동시통역, 전 세션 녹화하는 형태는 유지되었다. 동시통역은 듣는 사람은 편하지만, 비용을 생각하면 엄청난 투자이고, 외국인 참석자도 늘어난다지만 진행한다는게 존경스럽다. 세션 녹화 영상도 당일 혹은 다음 날 올라오는 수준으로 대응도 엄청 빠르다. 이런 것들을 보면 대단한 행사이다.

## DroidKaigi App

올해는 기술 이슈 대신, 8개의 프로젝트 업데이트, 코드 정리, Gradle 이슈 수정 등을 도왔다.

그래도 첫페이지에 사진이 올라가서 매번 뿌듯하다.

{% include img_assets.html id="/blog/2024/0915-droidkaigi/03.png" %}

## 전체 세션

전반적으로 Compose에 관련된 세션이 많고, Compose 응용 + 기반이 되는 기술 등이 많이 보였다. 또한 Context, 오프라인 모드, Kotlin 2.0, 패널 토크, PDF, Android 15, 난독화 등 다루는 세션 범위가 놀라울 정도로 방대했다. Compsoe에 치중되어 있지 않고 주제의 바리에이션도 풍부했다. 

### 내가 들은 세션들

**1) Android ViewからJetpack Composeへ 〜Jetpack Compose移行のすゝめ〜**

- [발표 자료](https://speakerdeck.com/syarihu/from-android-view-to-jetpack-compose-a-guide-to-migration) / [발표 영상](https://youtu.be/yVXp8GTP_gI?si=ECxdYQfczV0O85fA)
- Compose 마이그레이션시에 정해야 할 규칙들을 소개 (패키지, 테마, 이름, 컬러 정의 등)
- Compose 마이그레이션을 고려하는 곳에서 앞으로 결정해야 할 리스트를 얻을 수 있음

**2) Kotlin 2.0が与えるAndroid開発の進化**

- [발표 자료](https://speakerdeck.com/masayukisuda/kotlin-2-dot-0gayu-eruandroidkai-fa-nojin-hua) / [발표 영상](https://youtu.be/aZds8ewbRkk?si=6m9KfSYqQ5Io4M8N)
- Kotlin 2.0 마이그레이션에 고려할 사항을 미리 살펴볼 수 있음
- IDEA의 Kotlin K2 모드 활성화가 필수
  - 아직 IDEA에서도 전부 지원하지 않으며 Intellij IDEA 2024.3에서 전부 대응 예정
- DataBinding
  - ksp로 지원하지 않으므로 빌드 성능 향상에 변경 필요함
  - Compose or ViewBinding으로 전환
  - [MigrateDataBindingToViewBindingPlugin](https://gist.github.com/kubode/2200d657b3a5516ede72cc2031a21158) 추천
- K2 Compiler : kapt 혹은 java가 남아있으면 속도 개선을 덜 받는다
- Smart Cast 개선 : if 조건문, any 타입 체크, inline 함수, 함수형 프로퍼티
- 개선된 BackingField 개선
- Enum entries Stable
- Kotlin test에 포함된 [Power Assert](https://kotlinlang.org/docs/power-assert.html)
- Compose String Skip Mode가 기본 활성화

**3) Jetpack Compose Modifier徹底解説**

- [발표 자료](https://docs.google.com/presentation/d/1cx0796Gc0qLlzUMJwWTz94PqSZ60LHMFmAdz0m7T3kA/edit#slide=id.p1) / [발표 영상](https://youtu.be/xemVJ10oW-E?si=7cPfz4Mxu71cvts4)
- Compose Modifier 리스트를 예제와 함께 이해할 수 있음
- Modifier의 깊이를 알기보다는 알려진 API의 예제를 보는 용도

**4) PDF Viewer作成の今までとこれから ~ Android 15で進化したPdfRenderer~ PDF Viewer作成の今までとこれから ~ Android 15で進化したPdfRenderer~**

- [발표 자료](https://speakerdeck.com/hunachi/droidkaigi-2024) / [발표 영상](https://youtu.be/KvqD3X6931s?si=IyYrjOY-Zy2amRVI)
- Android에서 취약한 부분 중 하나가 PDF인데, Android 15(플랫폼 API)에서 제공하는 API에 대한 설명
- 기본적인 동작과 트러블슈팅을 소개함
- PDF Path -> PDF (data) -> Bitmap 단계로 PDF를 노출

**5) 仕組みから理解する！Composeプレビューを様々なバリエーションでスクリーンショットテストしよう**

- [발표 자료](https://speakerdeck.com/sumio/shi-zu-mikarali-jie-suru-composepurebiyuwoyang-nabariesiyondesukurinsiyotutotesutosiyou) / [발표 영상](https://youtu.be/c4AxUXTQgw4?si=0ShK0NJUY-Pd-x10)
- Compose Preview 전반의 스크린샷 테스트를 위한 기반 기술을 소개
- 몇개의 단계로 나눠서 설명 : Preview 가져오기 -> Preview마다 스크린샷 촬영 -> various variation에 맞춰서 스크린샷 촬영
- Robolectric / Roborazzi를 기반으로 설명

**6) アイデアからIDEへ： Android Studio用プラグインの開発**

- [발표 영상](https://youtu.be/3ID-W-X_5mw?si=lhXd4_yicIGJ25lS)
- Android Studio Plugin 개발시에 봐두면 좋은 기본적인 내용들이 소개하고 있다
- Actions -> PSI -> Services -> Threading Model
- Plugin 제작에 필요한 기본 과정을 설명. IDE 플랫폼 Plugin 2.0 버전 나옴
- Plugin.xml : Plugin 제작에 관련된 내용을 기입하는 곳

**7) Jetpack ComposeにおけるShared Element Transitionsの実例と導入方法 またその仕組み**

- [발표 자료](https://docs.google.com/presentation/d/1kmKLeTsic2Fixxu63xFjVwu5wE1AC07HzGvD5mS9T0o/edit#slide=id.g2f7714da44f_0_538) / [발표 영상](https://youtu.be/JaeUS5T8DlI?si=vtwNijjMP00YW1HO)
- Compose에서 Shared Element Transition을 활용하여 UI를 연결하는 형태를 소개
- 기본적인 Shared Element Transition 적용 방법
- GridView/DetailView 패턴으로 UI 애니메이션을 적용할 때의 트러블 슈팅들을 소개

**8) WebADBを使用したAndroid専用端末化への自動キッティング手法**

- [발표 영상](https://youtu.be/JYXVGYfGoVw?si=_VLv28kHoo3kv6yQ)
- 택시 운전수 전용 단말기와 같이 특수 목적을 위한 만들어지는 단말기가 메인
- 비개발자이더라도 단말 초기 설정을 편하게 하기 위해서 WebADB를 사용
- Shell Script + 접근성 서비스를 사용해서 특정 동작하도록 대응

**9) デザインからアプリ実装まで一貫したデザインシステムを構築するベストプラクティス**

- [발표 자료](https://speakerdeck.com/shuzo/tesainkaraahurishi-zhuang-mate-guan-sitatesainsisutemuwogou-zhu-suruhesutohurakuteisu) / [발표 영상](https://youtu.be/7Jj48h35XEg?si=-X4b742djpgMQ0B0)
- 디자인 시스템 구축시에 필요한 정의를 소개
- 디자인 시스템이 실패하는 이유
  - 협의 없이 특정 팀이 일방적으로 만들어지는 경우
  - 만들어도 사용하지 않는 경우

**10) 使って知るCustomLayout. vs DailyScheduler**

- [발표 자료](https://sasasaiki.github.io/slidev_droidkaigi2024/1) / [발표 영상](https://youtu.be/OQtAKrjAsps?si=PPtzU8Mv-g9ydR3-)
- 캘린더 앱에서 사용하는 UI를 커스텀으로 만드는 방식을 소개
  - 레이아웃 / 제스처 등
- 커스텀 Composable 사용시의 레이아웃 선택 기준을 소개

**11) タッチイベントの仕組みを理解してジェスチャーを使いこなそう**

- [발표 자료](https://speakerdeck.com/usuiat/tatutiibentonoshi-zu-miwoli-jie-siteziesutiyawoshi-ikonasou) / [발표 영상](https://youtu.be/vWkbeEKhfjE?si=X98pAgu4M1hNZcTM)
- Compsoe에서의 터치 이벤트 처리에 대한 개요와 응용을 소개해줌으로 이벤트 처리를 이해하는데 좋았던 세션

**12) Compose UIを使ったクリエイティブで複雑なユーザーインターフェース**

- [발표 영상](https://youtu.be/eWDthP0oUKc?si=BwH3YIHJ5zsIGp1R)
- 게임 UI를 Compsoe로 구현하는 이색적인 세션 내용이었다. (세션에서 소개한 게임은 페르소나)
- 색다른 UI를 구현해야할때 고민이 많은데, 해결해나가는 방법이 좋은 내용들이었다

## Etc

|                                                              |                                                              |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| {% include img_assets.html id="/blog/2024/0915-droidkaigi/05.png" %} | {% include img_assets.html id="/blog/2024/0915-droidkaigi/06.png" %} |
| {% include img_assets.html id="/blog/2024/0915-droidkaigi/07.png" %} | {% include img_assets.html id="/blog/2024/0915-droidkaigi/04.png" %} |

- 2019년 이후로 오랜만에 간 행사라서 반가움이 컸다.
- 계속 성장하는 행사라서 항상 갈 때마다 자극을 받는다.
- 이전에는 세션 중 모르는 부분도 많았다. 그렇지만 이번 행사의 일부 세션 중에서는 80% 이상 이미 알고 있는 내용도 있었다. 나도 조금 성장했다고 느끼는 시간이었다.
- 케이터링으로 마신 따뜻한 커피 라떼 맛있었다.