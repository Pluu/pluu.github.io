---
layout: post
title: "[번역] DroidKaigi 2017 ~ How to apply DDD to Android Application Development"
date: 2017-04-02 16:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ How to apply DDD to Android Application Development](http://y-anz-m.blogspot.kr/2017/03/droidkaigi-2017_9.html) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어 / 스피치 원고` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-Wom3WRyn8xU/WMDZuM1ADbI/AAAAAAAAll8/Mu0tiFWhR1ANAleuFh17kKdIz0DBlw-NACLcB/s320/DroidKaigi2017.001.jpeg"/>
</div>
<div class="col-lg-6">
    오늘은 도메인 기반 설계에 대해서 Android 앱 개발과 연관 지어 이야기하겠습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-SPUaD1yKb3M/WMDZurloEWI/AAAAAAAAlmA/6UZ3JFHCiuw7EggiqIg7uQvuJWutCA-CgCLcB/s320/DroidKaigi2017.002.jpeg"/>
</div>
<div class="col-lg-6">
    저는 안자이 유키라고 합니다. Android 앱 개발을 생업으로 하고 있습니다.
</div>
</div>

**あんざいゆき**

- blog : Y.A.M 낙서장
  - y-anz-m.blogspot.com
- twitter : @yanzm (やんざむ)
- uPhyca inc. (주식회사 uphyca)

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-1n4KHXIMvhU/WMDZu1dw1yI/AAAAAAAAlmE/aZ-Jr7p5LD0hziktN_mScZrFMzzBCi--wCLcB/s1600/DroidKaigi2017.003.jpeg"/>
</div>
<div class="col-lg-6">
    오랫동안 Y.A.M의 낙서장이라는 블로그에서 Android의 기술 정보를 보내드리고 있습니다. 최근에는 좀처럼 투고 못 했습니다만, 일로서 Android와 관련되어 있었기 때문입니다. Android를 만지기 시작할 무렵에는 아직 학생이었기 때문에 시간이 있었겠지요.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-8LOLeQiaJPc/WMDZu_lnUMI/AAAAAAAAlmI/r1OSsIRtks4zmr4eEsKazmcfz5PKPbtPgCLcB/s1600/DroidKaigi2017.004.jpeg"/>
</div>
<div class="col-lg-6">
    처음으로 Android 관련 내용을 게시한 것은 2009년 5월 24일입니다. 당시는 JavaFX를 만지고 있었으므로, Netbeans으로 Android를 하려고 했던것 같습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-mJ3bUP1HV70/WMDZvP8CKGI/AAAAAAAAlmM/LV_82tc63coAFDMyQ8_mTYBkUSuZSDC7QCLcB/s1600/DroidKaigi2017.005.jpeg"/>
</div>
<div class="col-lg-6">
그 다음날에는 Eclipse로 갈아탔는데요. 역시 Android 앱을 개발한다면 Eclipse이지요.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-6cI7xI1fkAU/WMDZvBgqNcI/AAAAAAAAlmQ/BmkQRCwNL3EwUdp6Rri8pHSwiFQMpSLvgCLcB/s1600/DroidKaigi2017.006.jpeg"/>
</div>
<div class="col-lg-6">
당시의 Android 버전 1.5에서는 Fragment 없이 Support Library 없이 멀티터치조차 없이 스토어는 Google Play 이 아니라 Android Market이라는 이름이었습니다.
<br/>
이때부터 2,3년 정도는 일로서 Android 앱을 개발하고 있는 사람은 거의 제조사의 기본 설치 앱을 만들고 있는 분들로, 많은 사람은 취미로 Android 앱을 개발해서 마켓에 공개했습니다.
<br/>
그들/그녀들이 만든 앱은 대부분 무료이며 사용자는 개발자 자신, 자신이 원하는 것을, 자신에게 유용한 것을 다 만들고 있었습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-Z1FSNF2uqng/WMDZvbKUJcI/AAAAAAAAlmU/0_B6xTEvkN03HB3xcFOp-tNo1rnPvNdeQCLcB/s320/DroidKaigi2017.007.jpeg"/>
</div>
<div class="col-lg-6">
이러한 것은 대부분이 간단한 기능으로, 지속적으로 유지하는 것을 생각하지 않고 만들어져 있습니다.
</div>
</div>

- 기능이 제한된 간단한 앱

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-gwB0mH7RxMc/WMDZvganPtI/AAAAAAAAlmY/kXEWjSPx6vwOl6Rr4dKUuMbyU6v2OCWaQCLcB/s320/DroidKaigi2017.008.jpeg"/>
</div>
<div class="col-lg-6">
당시 취미로 앱을 만들고 있던 사람으로, 반년 혹은 1년 후 자신의 코드를 보고, 무엇을 하고 있는지 몰라. 이런 상황을 경험하신 분 계시지 않을까요. 저도 그중 한 사람입니다.
<br/>
또한 취미 앱의 경우 코드를 만지는 것은 자신뿐입니다. 지금처럼 github를 사용하고 있는 사람도 없었으며, 취미 앱은 OSS로 github에 공개해도 커밋하는 것은 자신뿐이라는 상황도 많지 않나요.
</div>
</div>

- 기능이 제한된 간단한 앱
- 만들고 끝

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-GkZM2b_GN0A/WMDZvlImnQI/AAAAAAAAlmc/i11StwRN594c_7EiXldpiVuKNpE-gSUcACLcB/s320/DroidKaigi2017.009.jpeg"/>
</div>
<div class="col-lg-6">
이처럼 규모가 작고 간단한 앱로 만들어 공개하면 끝, 게다가 제작자는 자신뿐이라는 상황에서 설계 방법 따위 생각 안 해도 되어 좋았습니다. 설계에 그다지 주의를 기울이지 않아도 만들 수 있으니깐요
</div>
</div>

- 기능이 제한된 간단한 앱
- 만들고 끝
- 제작자는 자신뿐

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-TRMPtqBBKbA/WMDZvw4s5GI/AAAAAAAAlmg/DoIf4vrGlFsbeto-GdphbaPQ3zXAwbSoQCLcB/s320/DroidKaigi2017.010.jpeg"/>
</div>
<div class="col-lg-6">
그건 그렇고, 그 후 Android는 파죽지세로 세계를 석권했습니다. 스마트폰도 보급되어 이제는 있는 것이 당연해지고, 대응하는 것이 당연한게 된 플랫폼입니다.
<br/>
스마트 폰을 대상으로 새로운 서비스를 시작하거나 이미 전개하고 있는 사업의 클라이언트로서 앱을 개발하는 것은 취미 앱과는 전제가 다릅니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-lA8vRvJbTWY/WMDZwJgeZ2I/AAAAAAAAlmk/vj4ESFWwMqwg8mBC8LfsrbtWegmp91CMgCLcB/s320/DroidKaigi2017.011.jpeg"/>
</div>
<div class="col-lg-6">
먼저 서비스로서 다양한 기능을 제공하므로 앱이 복잡해집니다. 화면 수도 많으며 다양한 것에 주의를 기울일 필요가 있습니다.
</div>
</div>

- 다양한 기능을 가진 복잡한 앱

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-m_61mDirKfc/WMDZwOG_XqI/AAAAAAAAlmo/SNbuLg4pw30whBZiMX2i3mKKv3cPBk_NACLcB/s320/DroidKaigi2017.012.jpeg"/>
</div>
<div class="col-lg-6">
다음으로 만들면 끝이 아닙니다. 지속적으로 유지 관리하고 비즈니스 요구 사항의 변화에 대응하고 기능을 추가하거나 변경해야 합니다. 런타임 권한에 대응하는 등 플랫폼의 진화에도 따라가지 않으면 안 됩니다.
<br/>
라이벌 앱에 새로운 기능이 추가되면 우리 앱에도 넣자고 이것저것 대안을 하고 싶다고, 게다가 빨리하라고 말한다. 개발하는 것은 힘듭니다.
</div>
</div>

- 다양한 기능을 가진 복잡한 앱
- 계속적인 유지와 기능 추가

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-mWD-y1I6FwY/WMDZwbXU4KI/AAAAAAAAlms/0s2tRs3CZnsMMN8j5OhCYkOrADm97G1bgCLcB/s320/DroidKaigi2017.013.jpeg"/>
</div>
<div class="col-lg-6">
또한 제작자는 혼자만이 아닙니다. 여러 개발자가 앱의 여러 부분에 손을 댑니다. 사람이 바뀌는 것도 있을것입니다.
<br/>
다른 사람이 쓴 곳을 모두 읽지 않으면 기능 변경을 할 수 없는 상황에서는 곤란합니다.
</div>
</div>

- 다양한 기능을 가진 복잡한 앱
- 계속적인 유지와 기능 추가
- 다수가 작업

<hr>

우리의 앱은 위기에 처해있다.

기능을 채울만한 코드가 무질서하게 쌓인 상태는 마치 하울의 움직이는 성.

실수로 나사를 빼 버리면 모든 것이 와해 될 수 있다.

degrade의 폭풍, 불타는 사용자 리뷰.

무섭다.

잘 모르는 코드를 변경할 때에는 조심 조심. 엄청 시간이 걸린다 ...

이대로는 안 된다.

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-aO2sGteeczo/WMDZwSELqlI/AAAAAAAAlmw/p0o5h-rt4NMIn7CkslsR9Vv9Uo-_951wwCLcB/s320/DroidKaigi2017.014.jpeg"/>
</div>
<div class="col-lg-6">
어떻게 하면 여러 사람이 복잡한 앱을 지속적으로 안정적으로 빠르게 개발할 수 있을까.
<br/>
어떤 아키텍처와 어떤 패턴이 쏟아지고 있지만, 모두다 와 닿지 않는다. 잘되고 있다는 얘기도 별로 들리지 않는다. 만약 기술적인 패턴을 적용하는 것만으로 잘된다면 지금쯤 다들 그렇게 하고 있을 테이다. 하지만 그런 식으로는 되지 않았다. 표면적인 기술적 패턴이 아니라 좀 더 본질적인 것을 생각해야 하지 않을까.
<br/>
그 힌트를 찾고 도메인 기반 설계의 책을 손에 들었습니다.
</div>
</div>

여러 사람이 복잡한 앱을 지속적으로 개발

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-voUdgpgZpGQ/WMDZw4ZOY8I/AAAAAAAAlm8/o8Q94o1ggRwzPWD8yldxUcbHfS18WESXQCLcB/s320/DroidKaigi2017.015.jpeg"/>
</div>
<div class="col-lg-6">
먼저 읽은 것이 "에릭 에반스 도메인 기반 설계"입니다.
<br/>
도메인 기반 설계 책이면 이거죠.
<br/>
정말 두껍습니다. 3cm 입니다.
<br/>
혼자서 다 읽는 것은 힘듭니다. 나는 친구와 독서회를 해 다 읽을 수 있었습니다.
<br/><br/>
팀에서 DDD를 써보려고 할 때, 적어도 한 사람은 이 책을 다 읽은 사람이 있어야 한다고 생각합니다. 사실 이 책을 읽으면서 나온 내용을 순서대로 팀에 적용해보면 좋다는 구성은 아닙니다. 마지막 제4절 14장에 중요한 내용이 쓰여 있습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-b-pe_5fBCAk/WMDZw3Gp8dI/AAAAAAAAlm0/Qoa3tnQyIiwapIyOXdf6Fe5cCZMdF7K5wCLcB/s320/DroidKaigi2017.016.jpeg"/>
</div>
<div class="col-lg-6">
다음으로 읽은 것이 "실천 도메인 기반 설계"입니다.
이쪽이 설명의 일본어를 이해할 수 있을까 생각합니다.
<br/><br/>
이 책은 실천이라는 말이 있는 만큼 팀에 DDD를 써보려면 어떻게 하면 좋을 것인냐는 관점에서 쓰여 있습니다.
<br/><br/>
앞서 언급한 에릭 에반스의 책 14장에서 다루고 있는 내용은 2장, 3장에서 다루고 있습니다.
<br/><br/>
"실천 도메인 기반 설계" 쪽이 팀에서 DDD를 배우면서 순차적으로 써보고 싶다는 요구에 초점이 맞춰있습니다.
<br/>
그러나 이 책에서는 에릭 에반스의 책을 읽었다는 것을 전제로 자세한 설명이 되어있지 않는 곳도 있으므로 결국 2권 모두 읽어야 합니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-0HAVe_Zf7Ko/WMDZw7p1NZI/AAAAAAAAlm4/gnigACB0SFIO1X8sxLhOSaN-bFOvUM5tACLcB/s1600/DroidKaigi2017.017.jpeg"/>
</div>
<div class="col-lg-6">
"도메인 기반 설계를 어떻게 Android 앱 개발에 활용할지에"가, 이 세션의 주제이지만 그 이야기를 하려면 먼저 도메인 기반 설계란 무엇인가 이야기를 해야 합니다.
</div>
</div>

도메인 기반 설계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-cwGekmLWwTA/WMDZxa7IliI/AAAAAAAAlnA/_eQOGvGfvjAckyp4YMEJ_6Wl7pD1wo9BQCLcB/s1600/DroidKaigi2017.018.jpeg"/>
</div>
<div class="col-lg-6">
도메인 기반 설계, Domain Driven Design이라는 말을 듣고 처음 생각한 것은 "도메인"이란 도대체 뭘까? 였습니다. 인터넷 주소 등으로 불리는 도메인 이름의 도메인은 아닙니다.
<br/><br/>
책에는 다음과 같이 적혀 있습니다.
</div>
</div>

`도메인` 기반 설계

<hr>

<div class="col">
<img src="https://2.bp.blogspot.com/-ENA7echvGHg/WMDZxUQsenI/AAAAAAAAlnE/P5_HGRjUqNYbuSrNwAS4D-UsrC7qW26cgCLcB/s320/DroidKaigi2017.019.jpeg"/>
</div>

모든 소프트웨어 프로그램은 그것을 사용하는 사용자의 어떤 활동이나 관심과 관계가 있다. 사용자가 프로그램을 적용하는 대상 영역이 소프트웨어의 도메인이다.
<br/><br/>
- 에릭 에반스 도메인 기반 설계

<hr>

<div class="col">
<img src="https://2.bp.blogspot.com/-JUSFAznt0AI/WMDZxfZmAGI/AAAAAAAAlnI/FvOEhXG-Ul04Co0EN8o4OYF8fflN7aQZgCLcB/s320/DroidKaigi2017.020.jpeg"/>
</div>

조직이 실시하는 사업과 그것을 둘러싼 세계이다. 사업이 시장을 정의하고, 제품이나 서비스를 판매한다. 조직은 각각 자신들의 대상 영역에 대한 노하우와 일의 진행 방법이 있다. 그 영역 그리고 업무를 진행시켜 나가는 방법이 도메인이다.
<br/><br/>
- 실천 도메인 기반 설계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-lFngaInpAKU/WMDZxn_3u7I/AAAAAAAAlnM/8s7wwD2cjaEsBQNBNhdlN4RSA7wOchE_ACLcB/s320/DroidKaigi2017.021.jpeg"/>
</div>
<div class="col-lg-6">
우리가 만드는 앱에 사용자가 그것을 적용하는 대상 영역이 있습니다.
</div>
</div>

유저가 프로그램을 적용하는 대상 영역

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-hTpsLNLj5-Y/WMDZxzCNY4I/AAAAAAAAlnQ/Bu0v9MsMmJcSfj9ILW98dalYHGoP_KAQgCLcB/s320/DroidKaigi2017.022.jpeg"/>
</div>
<div class="col-lg-6">
예를 들어 요리 레시피를 검색하는 앱은 어떨까요.
<br/>
사용자는 이 앱을 어떤 영역에 적용할 것인가. 즉 이 앱에서 무엇을 할 것인가? 아파트를 검색하지는 않죠. 음식 레시피를 검색합니다. 즉 이 앱의 도메인은 음식 레시피이나 요리 그 자체라고 할 수 있습니다.
</div>
</div>

유저가 `레시피 검색 앱`을 적용하는 대상영역

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-rzciwuHXayE/WMDZxxONPcI/AAAAAAAAlnU/_Fm__MCv0UgXHH1kpl33zZ0qULbbnBCwwCLcB/s320/DroidKaigi2017.023.jpeg"/>
</div>
<div class="col-lg-6">
아파트를 검색할 경우, 다른 앱을 사용하죠. 사용자는 건물이 원하는 것은 아니라, 살 곳을 찾고 싶은 것이니깐 이러한 앱의 도메인은 아파트가 아닌 주거입니다. 산다는 것과도 말할 수 있습니다.
</div>
</div>

유저가 `아파트 검색 앱`을 적용하는 대상영역

<hr>

Uber 및 Lyft는 어떨까요. 적용 대상 영역은 "이동"이라고 말할 수 있겠지요. 바다를 건너기 위해 사용하지 않기 때문에 도메인은 "근거리 이동"이죠
<br/><br/>
자신의 앱과 서비스의 도메인에 대해 생각해보세요.
<br/><br/>
도메인에 대해 생각하면, 거기에 실제로 존재하는 것부터 개념적인 것까지 여러 가지가 있습니다. 예를 들어, 재료와 조리기구 및 배치 나 자동차 등.
<br/>
github 같은 소스 코드를 관리하는 서비스 도메인은 소프트웨어라는 개념이 포함될 것입니다.

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-I9HBt-UfxG0/WMDZyMflUVI/AAAAAAAAlnY/FchypLYBTas987aL6zBEL74oSLh-ZbqdACLcB/s320/DroidKaigi2017.024.jpeg"/>
</div>
<div class="col-lg-6">
도메인 기반 설계에서 도메인이란 무엇인가를 알아봤습니다.
</div>
</div>

도메인 기반 설계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-jvarCPZcId4/WMDZyDXHNjI/AAAAAAAAlnc/xseL8PSgmiUx8nTDdxaw4ibDOGnma5yogCLcB/s320/DroidKaigi2017.025.jpeg"/>
</div>
<div class="col-lg-6">
그러면 다음 질문은 "도메인 기반으로 설계한다는 것은 무엇일까요? 무엇을 하는가?"입니다.
</div>
</div>

`도메인 기반` 설계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-R2-tntO29iU/WMDZyX407AI/AAAAAAAAlng/WLtnttwPMA0jYIvJxw9EMHfc9XsYWfsIgCLcB/s320/DroidKaigi2017.026.jpeg"/>
</div>
<div class="col-lg-6">
먼저 도메인이 있습니다.
</div>
</div>

도메인

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-AnP95MccBqo/WMDZypFhUsI/AAAAAAAAlnk/pBHiKy0AJqMS6sAT-IMhCAo8upbNUmqeACLcB/s320/DroidKaigi2017.027.jpeg"/>
</div>
<div class="col-lg-6">
다음 도메인 전문가라는 사람이 등장합니다.
</div>
</div>

도메인

- 도메인 전문가

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-MGfCKcaX9ms/WMDZyrZSiDI/AAAAAAAAlno/9jci9mYL7G4EL7AXxcSNEfvXoatzeI0ogCLcB/s320/DroidKaigi2017.028.jpeg"/>
</div>
<div class="col-lg-6">
또 모르는 단어가 나왔습니다. 도메인 전문가는 무엇인가요?
</div>
</div>

도메인 전문가

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-EUPHqWrsF-8/WMDZyw0xQFI/AAAAAAAAlns/JXOgXLwGM_U9CfQSrHC838LGcIq26u4WACLcB/s320/DroidKaigi2017.029.jpeg"/>
</div>
<div class="col-lg-6">
단적으로 말하면 도메인을 잘 아는 사람입니다. 도메인이 무언가는 방금 얘기 했지요. 앱마다 도메인은 다르므로 앱마다 도메인 전문가도 다릅니다.
</div>
</div>

도메인 전문가 = 도메인을 잘 아는 사람

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-mKcCac4zm2Q/WMDZy5_JJxI/AAAAAAAAlnw/j6ZP1uZ2R181OGPUh8GhoKt9759jbB_dwCLcB/s320/DroidKaigi2017.030.jpeg"/>
</div>
<div class="col-lg-6">
전문가라는 말이 붙어있기 때문에 전문가가 아니면 안 된다고 생각할지 모르지만, 그렇지는 않습니다. 도메인에 대해 자신보다 잘 아는 사람 모두가 도메인 전문가입니다.
<br/>
사용자이거나, 동료이거나 다양합니다.
</div>
</div>

- 전문가
- 유저
- 동료
- ...
- 자신보다 잘 아는 사람 모두

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-sQ8dSwkQ3co/WMDZzG4u8kI/AAAAAAAAln0/g9EHKYo-XFQDGQGzsL8kmrkVUPsQDF3ogCLcB/s320/DroidKaigi2017.031.jpeg"/>
</div>
<div class="col-lg-6">
도메인 전문가가 뭔가 알았으니 도메인 기반 설계에서 무엇을 하는지에 돌아가죠.
</div>
</div>

도메인

 - 도메인 전문가

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-tiuJuIuqELA/WMDZzMn6nGI/AAAAAAAAln4/8SLpANGVrr02Zj22e_8AmChKKmlnA2HngCLcB/s320/DroidKaigi2017.032.jpeg"/>
</div>
<div class="col-lg-6">
도메인 전문가의 머릿속에는 도메인을 구성하는 물건이나 행동, 관계 등의 개념적인 무언가가 있습니다.
<br/><br/>
예를 들어 요리한다는 것은 무엇을 의미하냐라고 물으면 "재료를 준비하고, 각각의 분량을 정하고 순서에 따라 조리 해 나가는 것"입니다. 라는 대답이 나올 것입니다.
<br/><br/>
뭔가 "재료"라는 것이 있고, 그것이 여러 가지 필요한 것 같다. 재료에는 "분량"이라는 것이 있고, "분량"이라는 것은 측정하는 것 같다. 또한 "순서"라는 것이 있어 "요리"라고 하는 것이라고.
</div>
</div>

도메인 전문가 ─── (개념적인 모델) ───> 도메인

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-6ffRFF2TS9k/WMDZzdxpWtI/AAAAAAAAln8/v4TylAPzRgg7kthqq5Mp0ITc6pQVt4qogCLcB/s320/DroidKaigi2017.033.jpeg"/>
</div>
<div class="col-lg-6">
머릿속은 직접 보이지 않기 때문에, 도메인 전문가에게 질문하거나 이야기를 듣거나 서로 협력하여 도메인 전문가의 머릿속에 있는 개념적인 뭔가를 잘 꺼내고 해석하고 증류하여 우리의 소프트웨어에 도움이 되는 모델로 만듭니다.
</div>
</div>

도메인 전문가 <─── (대화·회의) ───> 개발자

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-6D7GWmHBSvg/WMDZzSE3GZI/AAAAAAAAloA/n79WYqkXi4YpjNJs5GckA7JKyTprYApMACLcB/s320/DroidKaigi2017.034.jpeg"/>
</div>
<div class="col-lg-6">
그렇게 해서 만들어 낸 것이 도메인을 반영한 모델, 도메인 모델이라고 부르는 것입니다.
<br/><br/>
도메인 모델은 그림을 그려 설명하고, 문장으로 설명할 수 있지만 그림 자체가 도메인 모델이라는 것은 아닙니다. 어디까지나 머릿속의 일반적인 개념으로 모델링 한 것입니다.
</div>
</div>

도메인 전문가 ─── (해석·증류) ───> 도메인 모델

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-1dlgjYk81jc/WMDZzoUtp1I/AAAAAAAAloE/mqufZqhV-M0b_w8fC0yVBnorJPoX5aVXQCLcB/s320/DroidKaigi2017.035.jpeg"/>
</div>
<div class="col-lg-6">
도메인 전문가와 이야기를 할 때 도메인을 구성하는 단어를 찾을 수 있습니다.
</div>
</div>

"요리는 무엇인가요?"

"재료를 준비하고, 각각의 분량을 정하고 순서에 따라 조리 해 나가는 것입니다"

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-TVbNp4011Vs/WMDZz42ppLI/AAAAAAAAloI/tMZQ0hzFDmkFG7QYntCAoNLHNt_ABTu7QCLcB/s320/DroidKaigi2017.036.jpeg"/>
</div>
<div class="col-lg-6">
앞의 예시에서 "재료"와 "분량"과 "요리"라는 단어와 "재료를 준비한다" "분량을 정한다" 등의 문구입니다. 도메인 기반 설계에서는 이러한 도메인을 구성하는 단어를 유비쿼터스 언어라고합니다.
</div>
</div>

"요리는 무엇인가요?"

"`재료를 준비`하고, 각각의 `분량을 정하고` `순서에 따라` `조리` 해 나가는 것입니다"

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-R1Ce28688iI/WMDZz-kjPvI/AAAAAAAAloM/6ya8A7L8QhU8Bnvi50pYheHJwU8EYfkawCLcB/s320/DroidKaigi2017.037.jpeg"/>
</div>
<div class="col-lg-6">
유비쿼터스는 일본어로 "어디에나 존재한다"라는 뜻이지만, 도메인 기반 설계에서는 유비쿼터스 언어로 찾아낸 단어나 문구를 어디에서나 사용합니다. 문서는 물론 회의에서의 대화, 도메인 모델, 그리고 그것을 구현하는 코드에도 사용합니다.
<br/><br/>
도메인 전문가를 포함한 팀 전원이 같은 유비쿼터스 언어를 사용합니다.
<br/><br/>
따라서 무엇을 유비쿼터스 언어로 하는지는 도메인 전문가를 포함한 팀 전원이 논의하고 합의로 결정합니다.
<br/>
유비쿼터스 언어는 도메인 전문가와 개발자, 그리고 팀의 공통 언어입니다. 단순한 용어집이 아닙니다. 말은 진화하고 자라나가는 것입니다.
</div>
</div>

유비쿼터스 언어

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-QxDbSwmKhDQ/WMDZ0NuFQ7I/AAAAAAAAloQ/FLsAnaDU21Qx2Fi8q4j8paoCMiTXD1yAQCLcB/s320/DroidKaigi2017.038.jpeg"/>
</div>
<div class="col-lg-6">
"개발자와 도메인 전문가가 협력하여 도메인을 구성하는 유비쿼터스 언어를 설정하고 그것을 사용하여 도메인을 반영한 모델을 만들어낸다"라는 곳까지 왔습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-07TBZxRoYlM/WMDZ0NNSXsI/AAAAAAAAloU/IpolhhAo0-EqvfknoDN5vC0haqjPGBLpACLcB/s320/DroidKaigi2017.039.jpeg"/>
</div>
<div class="col-lg-6">
도메인 모델을 만들면, 그것을 정확하게 코드로 표현하도록 구현합니다.
<br/><br/>
도메인 기반 설계의 장점으로 자주 코드가 설계이며, 설계가 코드라는 점이 꼽히지만, 코드가 도메인 모델을 정확하게 표현한다면, 그것은 즉 설계라는 것입니다.
<br/>
일반적인 개념 모델로 도메인 모델을 만들고, 그것을 코드로 정확하게 표현하도록 구현하기 때문에 다른 사람에게도 오해하기 어려운 코드가 됩니다.
<br/><br/>
그럼 먼저 도메인 모델을 모두 만들어, 그리고 단숨에 구현해야 하는가 하면, 그렇지는 않습니다.
<br/>
처음부터 완벽한 도메인 모델을 만드는 것은 불가능합니다. 구현하다 보면 이 모델이라면 잘 구현할 수 없다는 것을 발견하고 구현 도중에 더 좋은 모델을 생각해내는 것은 흔합니다.
</div>
</div>

구현 ─── (표현) ───> 도메인 모델

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-uayijRVCD-0/WMDZ0ar0GLI/AAAAAAAAloY/VyjvUss6HScu5zgRzjztL4pdjSBdyzRIwCLcB/s320/DroidKaigi2017.040.jpeg"/>
</div>
<div class="col-lg-6">
따라서 도메인 기반 설계에서는 도메인 모델을 만들고 구현해보고 그 결과를 피드백하여 도메인 모델을 수정하거나 변경하거나 완전히 새로운 모델을 만들고, 그리고 그것을 다시 구현한다. 이것을 반복해서 도메인 모델 및 코드 양쪽을 세련 시킵니다.
<br/>
즉, 애자일 과정을 전제로 하고 있습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-W9MbFxVYRGE/WMDZ0W79e-I/AAAAAAAAloc/VAX-ACKVjT0M38scI7wXADb2G6H0fWicwCLcB/s320/DroidKaigi2017.041.jpeg"/>
</div>
<div class="col-lg-6">
정리하면,
<br/><br/>
먼저 도메인 전문가의 말을 관찰하고 도메인을 구성하는 유비쿼터스 언어를 찾습니다.
<br/>
다음 유비쿼터스 언어를 사용하여 도메인을 적절하게 반영한 우리의 소프트웨어에 도움이 되는 도메인 모델을 만듭니다.
<br/>
그리고 만든 도메인 모델을 정확하게 표현하도록 코드를 구현하고 이를 반복합니다.
<br/><br/>
도메인 모델을 만들고 나서 구현입니다. 갑자기 구현하지 않습니다.
</div>
</div>

1. 유비쿼터스 언어를 정한다
2. 도메인 모델을 만든다
3. 도메인 모델을 정확하게 코드로 표현하도록 구현한다
4. 1~3을 반복한다

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-V9ZoM2P4Kgw/WMDZ0nPLGKI/AAAAAAAAlok/hHdLFovHYxU_pLxY1KMmo9orHS1T2YJcgCLcB/s320/DroidKaigi2017.042.jpeg"/>
</div>
<div class="col-lg-6">
할 일은 알았다. 그렇지만 실제로 하는 것은 어렵다.
<br/><br/>
그래서 도메인 기반 설계에서는 실천하기 위해 다양한 방법이 나옵니다. 이것들은 크게 두 가지로 나눌 수 있습니다.
<br/>
전략적 설계 및 전술적 설계입니다.
</div>
</div>

전략적 설계 / 전술적 설계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-iTLUOGBiv9M/WMDZ0uAGFjI/AAAAAAAAlog/GWjFj3rVPmQdmNxJHdiC9UPmXTdFpf1VgCLcB/s320/DroidKaigi2017.043.jpeg"/>
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-OqewP5rh1ds/WMDZ0w8wPOI/AAAAAAAAloo/s32Wukdx66YF5Dp5FTI0LzIECQfbvZqDgCLcB/s320/DroidKaigi2017.044.jpeg"/>
</div>
<div class="col-lg-6">
도메인 모델을 만들어내는데 도움이 되는 방법이 전략적 설계
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-hAoFIOkL9yw/WMDZ1DX6jlI/AAAAAAAAlos/2MjOGoBDkDsSMgvVPFRVQwH8ShI2xncnACLcB/s320/DroidKaigi2017.045.jpegg"/>
</div>
<div class="col-lg-6">
도메인 모델에서 그것을 표현한 구현을 해나가는 데 도움이 방법이 전술적 설계입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-gI5NBeRI2B4/WMDZ1MGfYPI/AAAAAAAAlow/NjR-agnEsNojXft8Eb-KNM1X2SumFe2EACLcB/s320/DroidKaigi2017.046.jpeg"/>
</div>
<div class="col-lg-6">
지금까지 이야기에 나온 유비쿼터스 언어는 전략적 설계입니다. 그 밖에도 경계 지어진 컨텍스트와 컨텍스트 맵이 있습니다.
<br/><br/>
한편, 전술적 설계는 값 개체와 엔티티, 서비스 등이 있습니다. 이름을 들어 본 적이 있는 분도 있을 것입니다. 이외에도 통합 및 도메인 이벤트와 저장소 등도 있습니다.
<br/><br/>
이러한 코딩의 기술적인 방법은 이해하기 쉬우므로 이 부분만을 도입해 봤다는 이야기는 많습니다만, 이것은 완전한 DDD는 아닙니다.
<br/>
왜? 도메인 모델이 없기 때문입니다.
</div>
</div>

| 전략적 설계 | 전술적 설계 |
| :--: | :--: |
| 유비퀴터스 언어 | 값 객체 |
| 경계 지어진 컨텍스트 | 엔티티 |
| 컨텍스트 맵 | 서비스 |
|  | ... |

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-OxhALcQHA5o/WMDZ1Un9ARI/AAAAAAAAlo0/S2HncxbJx5Q0r4pD1YdzrDSR1SezMlEGwCLcB/s320/DroidKaigi2017.047.jpeg"/>
</div>
<div class="col-lg-6">
그건 그렇고, 도메인 기반 설계가 무엇인지에 대한 이야기를 했습니다.
<br/><br/>
여기서 잠깐 도메인 기반 설계가 무엇이 아닌가의 이야기를 하겠습니다.
</div>
</div>

자주 있는 DDD 착각

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-hV_iRkTNhrc/WMDZ1vFcH0I/AAAAAAAAlo4/Ev2OICIWixE7rbfzJDhdv1dRbFJah3TxACLcB/s320/DroidKaigi2017.048.jpeg"/>
</div>
<div class="col-lg-6">
"DDD는 Clean Architecture를 말하는가?"
<br/><br/>
아닙니다. Clean Architecture를 모르는 사람은 걱정하지 않아도 됩니다.
<br/>
물론 DDD 및 Clean Architecture를 결합하여 사용하는 것은 가능하며, Clean Architecture의 컨셉은 DDD의 영향을 받고 있고, 참고로 한다는 것은 있을 것입니다. 그러나 여기서 말하고 싶은 것은 DDD = Clearn Architecture는 아니라는 것입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-DJ4Dfoj8Z9Q/WMDZ1sTUrnI/AAAAAAAAlo8/cz6s4r-OUa8rQ8dlJ0kVWrvkUmuS2Q5VQCLcB/s320/DroidKaigi2017.049.jpeg"/>
</div>
<div class="col-lg-6">
"DDD는 MVC이나 MVP들과 같은 무리입니까?"
<br/><br/>
이것도 다릅니다. 지금까지의 이야기에서 View가 나왔습니까? 안 나왔죠. 우리가 이야기해온 것은 도메인 모델뿐입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-wNCZLxcdSws/WMDZ1g-cAzI/AAAAAAAAlpE/eLva7XEipXU4bqc9xraq-PN4Vv_RuPrTQCLcB/s320/DroidKaigi2017.050.jpeg"/>
</div>
<div class="col-lg-6">
"계층화 아키텍처로 하면 DDD 이죠?"
<br/><br/>
에릭 에반스의 책에서 계층화 아키텍처가 소개하기 때문에 DDD = 계층화 아키텍처로 하는 것이라는 착각하는 것을 발견할 수 있습니다. 도메인 기반 설계와 아키텍처의 관계는 이후에 설명하지만, 도메인 기반 설계는 특정 아키텍처에 의존하는 것은 아닙니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-6uRS4NMHnFQ/WMDZ1yTXb0I/AAAAAAAAlpA/BukKR-svidEMk8hMDd2FHEtc9-A30BVsgCLcB/s320/DroidKaigi2017.051.jpeg"/>
</div>
<div class="col-lg-6">
"도메인 모델은 만들지 않지만 기술적인 패턴을 모방했으니 DDD 이죠?"
<br/><br/>
도메인 기반 설계에서는 도메인 모델을 만들어 그것을 정확하게 표현하도록 코드를 구현하는 것이지, 특정 기술적 패턴을 취하는 것이 아닙니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-F928lXQDPN8/WMDZ1ywNfRI/AAAAAAAAlpI/8iITj9mu5SI9mVhll5STBUko4ysJbfGngCLcB/s320/DroidKaigi2017.052.jpeg"/>
</div>
<div class="col-lg-6">
"도메인 모델을 만들어 그것을 정확하게 표현하도록 구현했으니 DDD 이죠?"
<br/><br/>
이것이 정답입니다.
<br/><br/>
쉽게 말하지만, 하는 것은 어렵지요.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-LkhxY5-Hvt8/WMDZ2f8jt1I/AAAAAAAAlpQ/xpUMlYM3d9MO4u_IGjhUuif1nZ_YYaP0wCLcB/s320/DroidKaigi2017.053.jpeg"/>
</div>
<div class="col-lg-6">
이제 Android의 이야기를 할까요.
<br/><br/>
Android 앱 개발에서 도메인 기반 설계에 임하는 경우도 같습니다. 도메인 전문가의 이야기를 듣고 개념을 적절하게 반영하는 도메인 모델을 만들고, 그것을 정확하게 표현하도록 구현하고 이를 반복합니다.
<br/><br/>
그렇게 말해도 어디서부터 손대면 좋을지 모르겠어요.
<br/>
앱에는 여러 가지 기능이 있고, 어떤 것을 해야 할 건가?
</div>
</div>

Android 앱 개발 with DDD

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-h4jFYl9oOTI/WMDZ2RpwDpI/AAAAAAAAlpM/90LWVMsfx6kVr_e4DJWwMqr_QwOz31KfgCLcB/s320/DroidKaigi2017.054.jpeg"/>
</div>
<div class="col-lg-6">
어디서부터 손댈 것인가, 그것을 알기 위해서는 앱 전체의 지형을 파악해야 합니다.
</div>
</div>

소프트웨어 지형

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-NTMXPFAFsD8/WMDZ2S0Uj5I/AAAAAAAAlpU/VV3rLttmnls30LBgOSBCNa0kHfcGVxHTQCLcB/s320/DroidKaigi2017.055.jpeg"/>
</div>
<div class="col-lg-6">
이를 위해 도메인 기반 설계에서 등장하는 것이 경계 지어진 컨텍스트와 컨텍스트 맵입니다.
<br/><br/>
또 모르는 단어가 나왔습니다.
<br/>
경계 지어진 컨텍스트와 컨텍스트 맵.
<br/><br/>
조금 전 전략적 설계에서 이름이 나왔습니다. 이 2개도 도메인 기반 설계의 중요한 요소입니다.
</div>
</div>

경계 지어진 컨텍스트

컨텍스트 맵

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-0SIkVSoltf8/WMDZ2mC7v5I/AAAAAAAAlpY/h86Pn4Q9JNguJuMaYPQDVluhVE7ebvCGgCLcB/s320/DroidKaigi2017.056.jpeg"/>
</div>
<div class="col-lg-6">
경계 지어진 컨텍스트.
<br/><br/>
경계는 압니다. 컨텍스트는 무엇입니까? 일본어로 자주 맥락 등으로 번역되네요. Android에서 자주 나오는 그 컨텍스트는 아닙니다.
<br/><br/>
유비쿼터스 언어의 단어가 특정 의미를 가지는 영역이 컨텍스트입니다.
</div>
</div>

경계 지어진 컨텍스트

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-goiHKqK_OSw/WMDZ292vykI/AAAAAAAAlpc/o2KqZz5MuecceIC1Zi9deBGiCazWqrhyACLcB/s320/DroidKaigi2017.057.jpeg"/>
</div>
<div class="col-lg-6">
예를 들어 Account라는 단어가 있습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-XEETfl8L7_o/WMDZ26AcA9I/AAAAAAAAlpg/IqRce7gXVtMRBTOFXb5iXPBJvOfqhv8yQCLcB/s320/DroidKaigi2017.058.jpeg"/>
</div>
<div class="col-lg-6">
이 단어가 사용자 인증의 맥락에서 말하는 경우, 그 의미는 서비스를 이용할 때 사용할 단위의 것을 알 수 있습니다.
</div>
</div>

유저 인증 컨텍스트

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-h_ImLJ7o2Dw/WMDZ3Oq2zPI/AAAAAAAAlpk/4JCAnQmRyCYVH6MtiVJCu3MirkoDmkCFwCLcB/s320/DroidKaigi2017.059.jpeg"/>
</div>
<div class="col-lg-6">
한편, 은행의 맥락에서 말하는 경우, 그 의미는 계좌가 됩니다.
</div>
</div>

은행 컨텍스트 / 계좌

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-go8r7Lo8tmg/WMDZ3EcXV_I/AAAAAAAAlpo/bZ6m6js00WMr26qqCYOu6tqDwXlssEF3gCLcB/s320/DroidKaigi2017.060.jpeg"/>
</div>
<div class="col-lg-6">
또한 문학에서는 Account의 의미는 보고서입니다.
</div>
</div>

문학 컨텍스트 / 보고서

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-NvXMikMjlsk/WMDZ3b3y52I/AAAAAAAAlps/Ts0PYfXeth8byv0oRNlevu66uutcQGAYwCLcB/s320/DroidKaigi2017.061.jpeg"/>
</div>
<div class="col-lg-6">
컨텍스트가 다르면 같은 말이라도 의미가 달라집니다.
<br/>
유비쿼터스 언어를 구성하는 단어가 특정 의미를 가지는 영역이 컨텍스트이며,
<br/>
경계 지어진 컨텍스트 내부에서는 유비쿼터스 언어를 구성하는 단어는 특별한 의미를 가집니다.
</div>
</div>

경계 지어진 컨텍스트 / 유비쿼터스 언어

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-686hgCBkUBQ/WMDZ3m1mxMI/AAAAAAAAlpw/Z5p-4ZLNuHYmZEXHNpTrHSf5sk2ne1IFACLcB/s320/DroidKaigi2017.062.jpeg"/>
</div>
<div class="col-lg-6">
도메인 모델은 유비쿼터스 언어로 구성되어 있으므로, 도메인 모델은 그것을 구성하는 유비쿼터스 언어의 경계에 정한 컨텍스트에 속합니다.
</div>
</div>

경계 지어진 컨텍스트 / `도메인 모델` / 유비쿼터스 언어

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-xAxFJ2uL8XE/WMDZ3kEtxAI/AAAAAAAAlp0/VMzIwaSouMEL3khYBchPy2uogw-VLRxnwCLcB/s320/DroidKaigi2017.063.jpeg"/>
</div>
<div class="col-lg-6">
그럼, 자신의 앱의 경계 지어진 컨텍스트를 어떻게 찾으면 좋을까요
</div>
</div>

경계 지어진 컨텍스트를 발견하는 힌트

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-lyzUdJqmKUg/WMDZ39UartI/AAAAAAAAlp4/Gdp0c6FOOZ4UELhbdBIzuCiDPum-xuYUgCLcB/s320/DroidKaigi2017.064.jpeg"/>
</div>
<div class="col-lg-6">
언어의 경계가 컨텍스트의 경계이므로, 말의 경계를 찾으면 좋을듯합니다.
<br/>
어떤 곳이 단어의 경계가 되는 것입니까?
</div>
</div>

언어의 경계가 컨텍스트의 경계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-16P0xLZpZGs/WMDZ4BHEZuI/AAAAAAAAlp8/GnDjyvHm8AUA7aND8wONnmVK3gHkJeaPQCLcB/s320/DroidKaigi2017.065.jpeg"/>
</div>
<div class="col-lg-6">
예를 들어 팀이 다르면 하나의 유비쿼터스 언어를 유지하는 것은 어려울 것입니다. 커뮤니케이션 비용이 들기 때문에 팀 내 유일한 단어가 발전하고 서로의 말이 서서히 분리되어갑니다.
<br/>
머지않아, 도메인 모델을 경계 내에서 엄격하게 일관성 있게 유지할 수 없게 됩니다.
</div>
</div>

팀의 경계가 컨텍스트의 경계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-rmgX-1AaLLU/WMDZ4Axz4DI/AAAAAAAAlqA/pglBaayj_bA7k4VROUM0o5CD8f3TkdJWACLcB/s320/DroidKaigi2017.066.jpeg"/>
</div>
<div class="col-lg-6">
특정 기능이 외부 라이브러리나 SDK로 제공되는 경우, 그 부분은 다른 컨텍스트가 되는 것이 많습니다. 도메인 모델이 일관성이 있는 범위를 생각하면 이해하기 쉽겠지요.
</div>
</div>

기능의 경계가 컨텍스트의 경계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-Fg2aMqljs7Y/WMDZ4dQyRJI/AAAAAAAAlqE/fYekAqPt8xAJekprsDtpiyk9FMCavHhkACLcB/s320/DroidKaigi2017.067.jpeg"/>
</div>
<div class="col-lg-6">
똑같이 코드 베이스가 다른 경우도 힌트가 됩니다. 알기 쉽게 말하면 github 저장소가 다르면 다른 컨텍스트가 아니냐는 것입니다.
</div>
</div>

코드 베이스 경계가 컨텍스트의 경계

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-CKnRqyuK1YQ/WMDZ4XxafKI/AAAAAAAAlqI/bP29HxRSr0Ad5yh5CREI3KCstiDfBaWhgCLcB/s320/DroidKaigi2017.068.jpeg"/>
</div>
</div>

- 앱의 컨텍스트
- 서버의 컨텍스트
- SDK의 컨텍스트
- 라이브러리의 컨텍스트
- ...

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-kntBTi2F2-c/WMDZ4hhIKqI/AAAAAAAAlqM/8b3M-sQr9BkjcUjFq00agDq9Ho7FD_giQCLcB/s320/DroidKaigi2017.069.jpeg"/>
</div>
<div class="col-lg-6">
찾은 컨텍스트에 이름을 붙입니다.
</div>
</div>

경계 지어진 컨텍스트, 각각에 이름을 붙인다

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-XVC_NGLoPNA/WMDZ4p6usaI/AAAAAAAAlqQ/FbrvpIuVYy8ioOL51fo5Lx6SjGlH5dfnACLcB/s320/DroidKaigi2017.070.jpeg"/>
</div>
<div class="col-lg-6">
그리고 그 이름을 유비쿼터스 언어의 일부로 합니다.
</div>
</div>

이름 ───> 유비쿼터스 언어

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-CCVtcgkWwf0/WMDZ49CmgzI/AAAAAAAAlqU/Z2mI8Bfh_CoOU8Dt_-y4AtVkaQlfQgnaACLcB/s320/DroidKaigi2017.071.jpeg"/>
</div>
<div class="col-lg-6">
경계 지어진 컨텍스트를 알았으면 다음 컨텍스트 맵을 그립니다.
</div>
</div>

컨텍스트 맵

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-isZUcvBbCG4/WMDZ451QHPI/AAAAAAAAlqY/vMpxlq52dW0Xcwj2uhmPpmeWsYyFRFv5wCLcB/s320/DroidKaigi2017.072.jpeg"/>
</div>
<div class="col-lg-6">
컨텍스트 맵은 현시점의 경계 지어진 컨텍스트와 그들이 어떻게 상호 작용하고 있는지를 보여줍니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-fj-72f56zJ0/WMDZ5BC4ORI/AAAAAAAAlqc/lwZXw5MNQEM1cDicu3msFDs-RBK3syUXQCLcB/s320/DroidKaigi2017.073.jpeg"/>
</div>
<div class="col-lg-6">
중요한 것은 이상적인 모습이 아니라 현재의 상태를 그리는 것입니다.
<br/><br/>
그렇다고 정확히 파악해야 한다는 것은 아닙니다. 처음에는 알고 있는 범위에서 충분합니다. 상태가 변하고, 새로운 지식을 찾으면 그때마다 맵을 업데이트합시다.
<br/><br/>
정교한 구조로 할 필요도 없습니다. 화이트 보드에 쓴 것을 사진으로 찍으면 충분합니다.
<br/><br/>
의존하는 다른 프로젝트에 무엇이 있고, 그것과 어떤 관계인지를 팀과 공유하고 생각하는 계기로 합니다.
<br/>
만든 맵은 언제든지 볼 수 있는 곳에 놓아둡니다. Activity의 라이프 사이클 포스터 옆에 붙이는 것이 최고네요.
</div>
</div>

있는 그대로를 적어보는 것이 중요

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-uaPSb3N31ok/WMDZ5cDbU4I/AAAAAAAAlqg/rlpw8IQwFVoDrLu2ZT1pcglrG1170KjzwCLcB/s320/DroidKaigi2017.074.jpeg"/>
</div>
<div class="col-lg-6">
경계 지어진 컨텍스트간의 관계가 어떻게 될지, 이 관계에 대해 DDD는 조직적인 패턴과 통합 패턴이 몇 가지 소개되고 있습니다.
</div>
</div>

컨텍스트 통합

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-9Nbtzt3fkCg/WMDZ5eV4R0I/AAAAAAAAlqk/PFO1d1ctMusWiUyrLEbyna0UBdKOpvT2wCLcB/s320/DroidKaigi2017.075.jpeg"/>
</div>
<div class="col-lg-6">
자신들의 컨텍스트간의 관계가 이러한 패턴 중 어디에 가장 가까운지 생각해 봅시다.
<br/>
그리고 컨텍스트 맵의 컨텍스트끼리들을 연결하는 선이 어떤 패턴인지를 써 봅시다.
<br/><br/>
패턴에 이름이 붙어있는 것은 매우 중요합니다. 나중에 팀에 합류한 사람도 컨텍스트 맵을 보는 것으로써 어떤 의존 프로젝트가 협력적이고, 어디가 융통성이 없는 것인지 파악할 수 있습니다.
<br/><br/>
몇 가지 패턴을 Android 앱 개발에 있을법한 상황에 적용해 보겠습니다.
</div>
</div>

<div class="row">
<div class="col-lg-3">
    <ol>
        <li>파트너십</li>
        <li>공유 커널</li>
        <li>고객/공급자 관계</li>
        <li>적응자</li>
        <li>부패 방지 계층</li>
    </ol>
</div>
<div class="col-lg-3">
    <ol>
        <li>공개 호스트 서비스</li>
        <li>공표된 언어</li>
        <li>각각의 길</li>
        <li>거대한 진흙</li>
    </ol>
</div>
</div>

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-X4i1HymH8EA/WMDZ5vrcDnI/AAAAAAAAlqo/lBmXscxR-5QsNHo58ZMaP_UaufbX-jcuACLcB/s320/DroidKaigi2017.076.jpeg"/>
</div>
<div class="col-lg-6">
파트너십이라는 것은 성공·실패의 운명을 같이하는 관계입니다. 예를 들어 앱의 주요 기능이 모든 앱에 대한 SDK로 제공되는 경우 이러한 운명은 일련탁생(一蓮托生)이며, 파트너십의 관계가 가장 가까운 것입니다.
</div>
</div>

**파트너십**

앱 ─── 주기능을 제공하는 SDK

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-Z3y21h99BeE/WMDZ5h7IwyI/AAAAAAAAlqs/hNzGv26kH5geNlAL19SIZ1AoymJ9PUgAwCLcB/s320/DroidKaigi2017.077.jpeg"/>
</div>
<div class="col-lg-6">
특정 기능을 사내 SDK로 제공하는 경우는 어떨까요. 같은 회사이기 때문에, 앱 쪽의 요구에 대응해 줄지도 모른다. 만약 대응해주는 같은 관계라면, 그것은 고객/공급자의 관계가 가장 가까운 것입니다.
</div>
</div>

**고객/공급자 관계**

앱 ─── 특정 기능의 사내 SDK

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-xeGkL2Mffz0/WMDZ54v90FI/AAAAAAAAlqw/1oQOv4GT2uMbQPlw5_re7tKY23QeS5wzwCLcB/s320/DroidKaigi2017.078.jpeg"/>
</div>
<div class="col-lg-6">
3rd party가 제공하는 SDK는 어떨까요. 예를 들어 twitter와 facebook SDK 등. 이 경우 우리는 제공되는 SDK를 그대로 이용할 수밖에 없습니다. 이러한 관계는 적응자입니다. 사내 SDK에도 앱 쪽의 요구에 대응해주지 않는 관계라면 적응자입니다.
</div>
</div>

**적응자**

앱 ─── 3rd party 서비스 SDK

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-O7WINBT5nII/WMDZ56DuP_I/AAAAAAAAlq0/4tXWzODL2EMoU_rinvyH5N4CRgGC5RCTgCLcB/s320/DroidKaigi2017.079.jpeg"/>
</div>
<div class="col-lg-6">
공개 호스트 서비스에 도메인 기반 설계 책에는 다음과 같이 적혀 있습니다 "서브 시스템에 접근할 수 있도록 하는 프로토콜을 서비스의 집합으로 정의한다. 그 프로토콜을 공개하고 하위 시스템과 통합할 필요가 있는 사람들이 모두 사용할 수 있도록 한다."
<br/><br/>
잘 모르겠네요. 요컨대 이런 것입니다.
<br/><br/>
어느 서브 시스템과 상호 작용하려는 사람들이 다수 있습니다.
<br/>
각각에 개별적으로 대응하는 것은 어려우므로 외부에 방법을 공개하는 것입니다. 방법은 REST 일지도 모르고 RPC 일지도 모른다.
</div>
</div>

**공개 호스트 서비스**

앱 ─── REST API 서버

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-3xa8IMLZ7VE/WMDZ6KMPP_I/AAAAAAAAlq4/tab9J-4USM8VsXSoLro-TdzBh823b_BbwCLcB/s320/DroidKaigi2017.080.jpeg"/>
</div>
<div class="col-lg-6">
공개 호스트 서비스와 함께 사용되는 경우가 많은 것이 공개된 언어입니다.
</div>
</div>

**공개 호스트 서비스**

공개된 언어

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-ecqSYzLb9GA/WMDZ6RaIcBI/AAAAAAAAlq8/LjH6kLMhO2km7ElCJ4yIgwhSiMBOQ52ogCLcB/s320/DroidKaigi2017.081.jpeg"/>
</div>
<div class="col-lg-6">
쉽게 말해, XML이나 JSON이나 Protocol Buffer 라든가, 요컨대 형식이 공표된 언어입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-LrRA1_6W4es/WMDZ6WcjIxI/AAAAAAAAlrA/lj9-R5Lod1Yoj8Fat4nQquHuPp96FOUYgCLcB/s320/DroidKaigi2017.082.jpeg"/>
</div>
<div class="col-lg-6">
또한, 함께 도입하는 경우가 많은 것이 부패 방지 계층입니다.
<br/>
다른 컨텍스트 모델에 따라 자신의 도메인 모델이 오염되지 않도록, 필요에 따라 자신의 컨텍스트내의 모델로 변환합니다. 그래서, 이 변환은 컨텍스트 외부에 있는 것입니다.
</div>
</div>

부패 방지 계층

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-f0T8Oo146Aw/WMfzXjcCqdI/AAAAAAAAl0c/9yOuLEwDe0keaIzf04fQK39U_Qajt40fQCLcB/s320/DroidKaigi2017.001.jpeg"/>
</div>
<div class="col-lg-6">
컨텍스트 맵에 그리면 이렇게 됩니다.
<br/>
OHS는 공개 호스트 서비스, PL은 공개된 언어, ACL은 부패 방지 계층입니다.
<br/><br/>
공개 호스트 서비스에 한정되지 않지만 서버의 서비스가 제공하는 컨텍스트와 앱 컨텍스트가 다른 것이라면 모델의 변환이 필요합니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-BdFQa325Yk4/WMDZ6zzzbbI/AAAAAAAAlrI/kLo3Ff1EVGw5JOtBPlWNl_FeigCq-r-eQCLcB/s320/DroidKaigi2017.084.jpeg"/>
</div>
<div class="col-lg-6">
실천 도메인 기반 설계에서는 다음과 같은 예가 있습니다. 책에서는 XML이지만, 여기에서는 JSON으로 대체했습니다.
<br/><br/>
다른 컨텍스트의 userInRole을 그대로 이용하는 측의 컨텍스트 내에서 사용하는 것이 아니라, 이용측의 컨텍스트에 존재하는 도메인 모델이 Moderator로 변환하여 사용합니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-ZN10hM-4qfc/WMDZ6_pLUxI/AAAAAAAAlrM/65treb5eSaAQiNtnIXtzTnkXL8jiwrhzwCLcB/s320/DroidKaigi2017.085.jpeg"/>
</div>
<div class="col-lg-6">
그건 그렇고, 우리의 앱의 도메인이 무엇인지 생각했습니다.
<br/>
유비쿼터스 언어가 DDD을 하는 데 있어서 중요한 요소임을 이해했습니다.
<br/>
경계 지어진 컨텍스트를 찾아 컨텍스트 맵을 그렸습니다.
<br/><br/>
다음으로 생각할 것은 무엇일까요?
</div>
</div>

1. 도메인
2. 유비쿼터스 언어
3. 경계 지어진 컨텍스트
4. 컨텍스트 맵
5. ?

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-fgIBUm1XrVk/WMDZ7EY8koI/AAAAAAAAlrQ/e_NuAoCcv-g-8eA46Xkyf7Wlm5ZxCP97QCLcB/s320/DroidKaigi2017.086.jpeg"/>
</div>
<div class="col-lg-6">
실천 도메인 기반 설계에서는 컨텍스트 맵의 다음 장은 아키텍처입니다.
</div>
</div>

`5. 아키텍쳐`

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-LGhMYI8ph0A/WMDZ7APg6BI/AAAAAAAAlrU/94zclJdoCBoNBCRo6evR1A9ueDRP93h2wCLcB/s320/DroidKaigi2017.087.jpeg"/>
</div>
<div class="col-lg-6">
도메인 기반 설계에서 아키텍처라고 하면, 계층화 아키텍처가 자주 나옵니다. 에릭 에반스의 책에서 소개되고 있어서 그런지, 도메인 기반 설계에서 계층화 아키텍처를 사용해야 한다라든가, 도메인 기반 설계는 계층화 아키텍처로 하는 것이라는 것과 같은 잘못된 인식을 가끔 볼 수 있습니다.
</div>
</div>

아키텍쳐

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-EOm7YUgKqZ4/WMDZ7DuJCDI/AAAAAAAAlrY/DnJfz2PTzn0Pzcd4UlV7YDU_18GJIR_aACLcB/s320/DroidKaigi2017.088.jpeg"/>
</div>
<div class="col-lg-6">
도메인 기반 설계는 특정 아키텍처에 의존하는 것은 아닙니다.
</div>
</div>

"DDD의 큰 이점의 하나로 `특정 아키텍처에 의존하지 않는다`라는 것이다"

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-LvhJVDiPbxE/WMDZ7Z28kiI/AAAAAAAAlrc/yLLesnOP4ywaxmCi5i0DazTwaMGcQf8RgCLcB/s320/DroidKaigi2017.089.jpeg"/>
</div>
<div class="col-lg-6">
그럼 계층화 아키텍처를 채택한 이유는 왜, 무엇을 하고 싶은지,
<br/>
그것은 도메인 계층을 격리하는 것입니다.
</div>
</div>

"`도메인 계층을 격리한 상태로 유지`할 수 있다면 어느 방법이라도 상관없다"

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-hzCyOG0lclc/WMDZ7ipyqxI/AAAAAAAAlrg/ytmZvNipnXoexFnIvCFzQpIAjbkwz6lkwCLcB/s320/DroidKaigi2017.090.jpeg"/>
</div>
<div class="col-lg-6">
여기서 말하는 도메인 계층이라는 도메인 모델의 집합. 정확히 말하면 도메인 모델을 표현한 코드, 구현의 모음입니다.
</div>
</div>

도메인 계층을 격리한다

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-01MyDo9C0eo/WMDZ7vx52AI/AAAAAAAAlrk/b01Kr-zumbgy-pSeA969StilmAXCwW5kgCLcB/s320/DroidKaigi2017.091.jpeg"/>
</div>
<div class="col-lg-6">
도메인의 개념과 지식, 비즈니스 로직이라고 표현합니다만, 이것을 도메인 모델로 그 외로부터 격리하는 것입니다.
</div>
</div>

비즈니스 로직을 도메인 모델로 격리한다

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-JcFCUP3Orgc/WMDZ77Qc6gI/AAAAAAAAlro/4F3YBDOWpdAv61infCU4KBl0db0Xm6u6QCLcB/s320/DroidKaigi2017.092.jpeg"/>
</div>
<div class="col-lg-6">
Android 앱 개발에서 원래 도메인 모델로 격리할 도메인의 개념과 지식, 비즈니스 로직이 섞이기 쉬운 것이 사용자 인터페이스입니다.
<br/><br/>
왜 우리는 사용자 인터페이스에 도메인의 개념과 지식, 비즈니스 로직을 담아버리는 것인가.
<br/>
그것은 앱을 만드는 방법에 깊이 관련되어 있습니다.
</div>
</div>

비즈니스 로직을 도메인 모델로 `UI에서` 격리한다

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-ENJWkdSM-RA/WMDZ8DhWhlI/AAAAAAAAlrs/tQvd7526ZWw6hJRP_DP2-nAkJqmQ2A4NQCLcB/s320/DroidKaigi2017.093.jpeg"/>
</div>
<div class="col-lg-6">
에릭 에반스의 책에 등장하는 똑똑한 UI (스마트 UI)는 사용자 인터페이스에 모든 비즈니스 로직을 포함하는 패턴입니다.
<br/><br/>
그 장점은 다음과 같이 적혀 있습니다.
<ul>
<li>간단한 어플리케이션의 경우, 생산성이 높고, 신속하게 만들 수 있다.</li>
<li>그다지 유능하지 않은 개발자도 이 방법이라면 대부분 훈련하지 않아도 일할 수 있다.</li>
<li>요구 분석이 부족해도 프로토타입을 사용자에게 공개하고 그 요구를 충족하도록 제품을 변경하여 문제를 극복할 수 있다.</li>
</ul>
<br/>
등
<br/><br/>
이 장점을 장점으로 살리는 곳이 있습니다. Mock이나 프로토타입입니다.
<br/>
Mock과 프로토타입은 화면의 디자인을 움직이는 것으로 빠르게 확인하는 것이 목적이기 때문에, 단순한 비즈니스 로직을 포함, 모든 사용자 인터페이스에 넣습니다.
<br/><br/>
즉, 움직이는 앱을 빠르게 만들어 사용자에게 보여 확인하고 싶은 경우, 똑똑한 UI가 되기 쉽다는 것입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-2yRkFTiLUAE/WMDZ8EXx5YI/AAAAAAAAlrw/9dwcYDgXGe8K-LNQJFYQKRczdgBLZsz_wCLcB/s320/DroidKaigi2017.094.jpeg"/>
</div>
<div class="col-lg-6">
이외에도 사양이 정해진 후에 화면 디자인과 간단한 기능 설명이 적힌 문서가 와서 그것을 바탕으로 구현하는 ...
<br/>
흔히 있는 상황이지만, 화면 디자인과 간단한 기능을 짧은 기간에 만드는 것을 요구되는 상태에서도 똑똑한 UI가 되기 쉽다는 것입니다.
</div>
</div>
화면 디자인 기반 설계 문제
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-o5WEo5KuWyw/WMDZ8TSHRNI/AAAAAAAAlr0/axalZvrIefUauLmPG-8yeOSN-LzqaQ0TACLcB/s320/DroidKaigi2017.095.jpeg"/>
</div>
<div class="col-lg-6">
거기에서 벗어나기 위해서는 어떻게 하면 좋을까.
<br/><br/>
이상을 말하면 기능에 대해 논의하는 곳에서 개발자도 참가하고, 모두의 머릿속에 있는 개념적 모델을 관찰하고 도메인 모델을 만들고 싶다.
<br/><br/>
하지만 갑자기 그런 말을 해도 할 수 없어, 라고 되지요.
<br/><br/><br/>
중요한 것은 똑똑한 UI가 되기에 십상이라고 인식하는 것. 그리고 도메인의 개념과 지식, 비즈니스 로직이 UI에 존재하지 않은가 관찰하고, 도메인 모델로 UI로부터 격리할 수 ​​없는지 생각하는 것입니다.
<br/><br/>
그러나 주의해야 할 것은 사용자 인터페이스에서 비즈니스 로직을 단순히 은폐하는 것과 도메인 모델로 격리하는 것은 다릅니다.
<br/>
Activity와 라이프 사이클을 동기화하는 어느 Presenter 같은 이름의 클래스를 만들고, 거기에 처리를 모두 이양하는 것은 아닙니다.
<br/><br/>
중요한 것은 도메인 모델입니다. 도메인을 반영한 도메인 모델을 만들어 사용자 인터페이스에서 비즈니스 로직을 떼어낼지 생각합시다.
</div>
</div>

- 영리한 UI가 되기 쉽다는 것을 인식
- 도메인 모델로 해야 할 도메인 지식이 UI에 존재하지 않을까 생각

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-FIqKBTiiaCU/WMDZ8bxqjXI/AAAAAAAAlr4/mNO4aXugxP4FCdOblsvkoMy5XVjPxlKzwCLcB/s320/DroidKaigi2017.096.jpeg"/>
</div>
<div class="col-lg-6">
여기까지의 이야기를 일단 정리합시다.
</div>
</div>

정리 1

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-oPGJgi7UNxU/WMDZ8rSaNII/AAAAAAAAlr8/2X0HceLBLQ0_vVasvrg_k7RoRrxVs3YvACLcB/s320/DroidKaigi2017.097.jpeg"/>
</div>
<div class="col-lg-6">
먼저 앱의 도메인이란 무엇인가 생각했습니다.
<br/>
다음으로 도메인 전문가와 대화를 하고 도메인을 구성하는 언어를 찾아 유비쿼터스 언어로 설정하고 키워 나갈 필요가 있다는 것을 발견했습니다.
<br/>
그리고 언어의 경계가 컨텍스트의 경계가 되고, 앱에는 그것을 구성하는 경계 지어진 컨텍스트가 여러 개 있을 수 있다는 것을 보았습니다.
<br/>
컨텍스트 간의 관계를 컨텍스트 맵으로 그리는 것으로, 어떤 관계가 컨텍스트들 사이에 있는지 파악할 수 있게 되었습니다.
</div>
</div>
1. 앱의 도메인에 대해 생각한다
2. 유비쿼터스 언어를 키운다
3. 경계 지어진 컨텍스트를 찾는다
4. 컨텍스트 맵을 그린다.
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-fi0no7oLLA8/WMDZ83RuE5I/AAAAAAAAlsA/CgF1kz7oqcknWYG6EUpECvh-pR8QddknwCLcB/s320/DroidKaigi2017.098.jpeg"/>
</div>
<div class="col-lg-6">
이러한 전략적 설계 및 분류할 수 있는 기법의 목적은
</div>
</div>
`전략적 설계`
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-eVK0i8XqjXg/WMDZ87AOndI/AAAAAAAAlsE/dESXcA8vktUq14L9zarW1qSpfniBwdylgCLcB/s320/DroidKaigi2017.099.jpeg"/>
</div>
<div class="col-lg-6">
도메인을 반영한 모델, 도메인 모델을 만들어내는 것입니다.
</div>
</div>
도메인 모델
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-JE2omp-MhnE/WMDZ8z5M5II/AAAAAAAAlsI/HAA2wIauSqUN0rcvVx3igRLdBEjneDb2ACLcB/s320/DroidKaigi2017.100.jpeg"/>
</div>
<div class="col-lg-6">
만든 도메인 모델을 정확하게 표현하는 코드로 구현하고, 이를 반복해서 도메인 모델 및 코드를 세련 시킨다.
</div>
</div>
도메인 모델 <───> 구현 
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/--w0zWsyyOxY/WMDZ9RnyqpI/AAAAAAAAlsU/FqZt-_9dcdYu5WWHygUQhwALW_rAdpRQACLcB/s320/DroidKaigi2017.101.jpeg"/>
</div>
<div class="col-lg-6">
도메인 모델을 정확하게 코드로 표현한다, 말은 쉽지만 실행하기는 어렵다. 그래서 도메인 기반 설계에서는 거기에 도움이 되는 기술적인 패턴도 소개되고 있으며, 그것이 전술적 설계로 분류되는 방법입니다.
</div>
</div>

도메인 모델 ───(전술적 설계)───> 구현 

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-yicEw6-lfM8/WMDZ9RHawaI/AAAAAAAAlsQ/JQDu0EzkvE08-bpY4Z7xix3bpKN2THWDwCLcB/s320/DroidKaigi2017.102.jpeg"/>
</div>
<div class="col-lg-6">
아키텍처의 이야기 중에 나온 "도메인 격리"이라는 도메인 모델을 정확하게 코드로 표현하기 위해 필요하며, 그 밖에도 값 개체와 개체, 서비스, 저장소 등의 방법이 있습니다.
<br/><br/>
중요한 것은 이러한 기술적 인 패턴, 방법은 "도메인 모델을 정확하게 표현한 코드 구현"을위한 것입니다. 표현하고자하는 도메인 모델이 없는데, 기술적 인 패턴을 흉내 내도 도메인 기반 설계의 혜택은 제한적입니다.
</div>
</div>

**전술적 설계**

- 도메인을 격리한다
- 값 객체
- 엔티티
- ...

<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-4B5E_EkQVJ8/WMDZ9asVXkI/AAAAAAAAlsM/lyGMAGnnQJ0q1SBeOktuxTjPqjc9tPeYgCLcB/s320/DroidKaigi2017.103.jpeg"/>
</div>
<div class="col-lg-6">
도메인 기반 설계에 대해 조금이나마 이해되셨습니까?
<br/><br/>
왠지 모르게 이해했지만, 코드가 나오지 않으면 역시 잘 모른다. 저도 그렇습니다. 말로는 이해하기 어렵다.
<br/><br/>
그래서, 여기부터는 덤입니다.
</div>
</div>
덤
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-_NpspKD8F0w/WMDZ9z_VBWI/AAAAAAAAlsc/TW6RI-PzkvEE7h8ffJWD_jHtW56IRTJRACLcB/s320/DroidKaigi2017.104.jpeg"/>
</div>
<div class="col-lg-6">
도메인 및 도메인 모델을 생각하는 훈련으로 굉장히 간단한 예제를 준비했습니다.
</div>
</div>
예 1
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-Ecf7Qm0bKi4/WMDZ9xDGspI/AAAAAAAAlsY/En7VcZbHJn0pdIiBtZj6KgnWbQ7fwjWRACLcB/s320/DroidKaigi2017.105.jpeg"/>
</div>
<div class="col-lg-6">
동물의 체중을 TextView에 표시하는 코드입니다. 체중을 모르는 동물의 경우는 빈 표시하고 싶은 것 같습니다.
<br/><br/>
이 코드는 두 가지 문제가 있습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-DfpqtkGDsSk/WMDZ900DZCI/AAAAAAAAlsg/p3EEE0b2I0osaJnJZbytkOEisBrKjmkigCLcB/s320/DroidKaigi2017.106.jpeg"/>
</div>
<div class="col-lg-6">
첫 번째가 -1이라는 숫자가 특별한 의미를 가진다는 것을 사용자 인터페이스가 알았다는 것.
</div>
</div>
-1이 특별한 의미가 있는지를 왜 UI가 아는가?
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-lv6Jhzoij0Y/WMDZ-E0lorI/AAAAAAAAlsk/r7bzHpuIUy0hriIDy8Sn7fKe-zGhjhZAgCLcB/s320/DroidKaigi2017.107.jpeg"/>
</div>
<div class="col-lg-6">
두 번째가 마이너스의 체중이라는 것이 표현되었다는 것입니다.
<br/><br/>
체중이라는 것에 대해 생각해보세요. 체중의 개념에 마이너스라는 것은 있습니까? 내 체중이 마이너스라는 분이 있습니까? 있었다고 하면 아마 그 사람은 반물질로 되어있고 생각합니다. 여기에서 중요한 것은 과학적으로 있을 수 있는지가 아니라 도메인에 대해서 생각하는 것입니다. 동물의 체중이라는 개념을 반영한 도메인 모델을 생각하면 마이너스인 상황은 없지요.
<br/><br/>
그럼 어떻게 할까. 체중을 반영한 도메인 모델을 만드는 것입니다. 그 모델은 부동 소수점 값을 가지고 있고, 그 값은 마이너스가 아니다. 아니, 마이너스가 아니라기보다는 0보다 크다고 생각하는 편이 적절하네요. 
</div>
</div>
마이너스 체중은 도대체?
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-H8G6wiejP3Q/WMDZ-YM-8LI/AAAAAAAAlso/Az_O7yhMfvkwxwKummFIKCaBfq4owy1SwCLcB/s320/DroidKaigi2017.108.jpeg"/>
</div>
<div class="col-lg-6">
도메인 모델을 생각했으니 구현해 보자.
<br/><br/>
Weight 객체의 인스턴스에서 얻은 체중의 값은 반드시 0보다 크다. 즉 체중에 대한 도메인 모델을 표현할 수 있습니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-0RgeWug4jY4/WMDZ-ZC1LcI/AAAAAAAAlss/LJhl4IlVbSsFBLhEbXLsXcoD8E6wnrpjQCLcB/s320/DroidKaigi2017.109.jpeg"/>
</div>
<div class="col-lg-6">
이를 이용하면 앞의 코드는 이렇게 됩니다.
<br/><br/>
주의해야 할 것이 미입력을 -1로 표현 할까 null로 표현할까라는 이야기가 아니라는 것입니다.
<br/>
도메인의 체중이라는 것에 대해 생각하고 그것을 반영하는 도메인 모델을 생각해 Weight 클래스는 도메인 객체로 표현한다는 이야기입니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://1.bp.blogspot.com/-EeLdn8mj6rU/WMDZ-s3gDoI/AAAAAAAAlsw/UIZAvH9K1sMDx8vAk5ZaOSBdhiBpFiU4ACLcB/s320/DroidKaigi2017.110.jpeg"/>
</div>
</div>
예 2
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-K_p4T8JQd3U/WMDZ-t2JGSI/AAAAAAAAls0/YNqLzHYXKC0HQeyN526NsRzwO5J0uKf8QCLcB/s320/DroidKaigi2017.111.jpeg"/>
</div>
<div class="col-lg-6">
이번에는 성별을 표시하는 것 같습니다.
<br/><br/>
이 코드에도 문제가 있네요.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-DTI7gaHyJa8/WMDZ-9rY08I/AAAAAAAAls4/kzrRg-4ilTwM6EbCl8mxyNa1udljcR7RQCLcB/s320/DroidKaigi2017.112.jpeg"/>
</div>
<div class="col-lg-6">
문자열이 "M"의 경우가 남성으로 "F"의 경우는 여성이라고 합니다. 문자열의 의미를 UI가 알고 있다. 이 얼마나 현명한 UI인가요?
<br/><br/>
어째서 이런 구현 되어 있는지 물어보았습니다.
<br/>
"서버의 응답이 문자열이었기 때문에 ..."
<br/>
그렇구나 ---.
<br/><br/>
UI가 문자열의 의미를 알고 있는 것은 이상하니 고쳐볼래?
</div>
</div>
M과  F라는 문자의 의미를 왜 UI가 아는가?
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-yNMQzT8GeeA/WMDZ-ydJcmI/AAAAAAAAls8/7mO0_h26OksUKnK1loV_Vbenpxen9mTTQCLcB/s320/DroidKaigi2017.113.jpeg"/>
</div>
<div class="col-lg-6">
"알겠습니다. 다 됐습니다. 유틸리티 클래스를 만들고, 그쪽의 static 메소드에서 판정하도록 했습니다!"
<br/><br/>
그런거 아니야 ...
<br/><br/>
UI가 어떤 유틸리티 메소드를 사용해 판정하는지 알아야 하며, 결국 UI의 현명한 문제는 해결되지 않았다.
<br/><br/>
필요한 것은 도메인, 즉 성별에 대해 생각하는 것입니다.
<br/>
우리의 머릿속에는 성별이라는 개념적인 모델이 있으니까 그것을 표현하는 도메인 모델을 준비합시다.
</div>
</div>
그런거 아니야
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-iXhyB5LGSMA/WMDZ_IFshbI/AAAAAAAAltA/2IQGbjuc6YUiFpe2DcDRwy05Uu_BJb5IQCLcB/s320/DroidKaigi2017.114.jpeg"/>
</div>
<div class="col-lg-6">
동물의 성별을 표현하는 모델로, 수컷 (MALE)과 암컷 (FEMALE)이 있다.
<br/><br/>
이 도메인 모델을 코드로 표현한다면 enum이 좋을 듯합니다.
</div>
</div>
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-2ZZiI6RXNfE/WMDZ_T-sLCI/AAAAAAAAltE/wXu36OwvQQIU8yyw-K0iSdnotO8yd0khACLcB/s320/DroidKaigi2017.115.jpeg"/>
</div>
<div class="col-lg-6">
"서버 응답 문자열이에요. 어디에서 enum으로 변환하나요?"
<br/><br/>
거기서 나오는 것이 컨텍스트의 통합에서 소개한 부패 방지 계층입니다.
<br/><br/>
여기에서, 서버의 응답을 앱의 컨텍스트내의 도메인 모델로 변환합니다.
</div>
</div>
JSON ("sex":"M") ───> ACL (Sex.MALE) ───> 앱
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-RudUY7Mu67I/WMDZ_Zpr2-I/AAAAAAAAltI/rngDJgA8R4cDYhzqbS6h6QWmpnTbBAuxACLcB/s320/DroidKaigi2017.116.jpeg"/>
</div>
<div class="col-lg-6">
오랜 시간 수고하셨습니다.
<br/><br/>
도메인 기반 설계에 대해 조금이나마 이해되셨나요?
</div>
</div>
정리 2
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-1rv3PtTeAas/WMDZ_n1LmkI/AAAAAAAAltQ/ibYYS6Xa8a4R7mw5PM2GIP-1ZRXDzVWmwCLcB/s320/DroidKaigi2017.117.jpeg"/>
</div>
<div class="col-lg-6">
어려웠을지도 모르겠습니다만,
<br/>
우선 도메인에 대해 생각하는 것부터 시작해보세요.
</div>
</div>
도메인에 대해서 생각한다
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://3.bp.blogspot.com/-tqW9SEIe4UA/WMDZ_uizLyI/AAAAAAAAltM/Vh1hqcbrK_ssw1uWERe0oKV3c4_UdOw5QCLcB/s320/DroidKaigi2017.118.jpeg"/>
</div>
<div class="col-lg-6">
그리고 중요한 것은 도메인 모델입니다.
<br/><br/>
기술적인 패턴만 다룬 블로그 등이 자주 있습니다만, 표면적인 것을 흉내 냈을 뿐 잘될 것 같은 그런 간단한 것은 아닙니다.
<br/><br/>
예로든 간단한 도메인 모델부터라도 괜찮습니다. 도메인을 반영한 모델을 만든다는 본질에 임해 주었으면 합니다.
</div>
</div>
중요한 것은 도메인 모델
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://4.bp.blogspot.com/-OGIYwFC2G7U/WMDZ_ycTllI/AAAAAAAAltU/DNvKs8JUwpgk8Rjgn3838X9UbuCKV-fDQCLcB/s320/DroidKaigi2017.119.jpeg"/>
</div>
<div class="col-lg-6">
DDD는 개념적인 이야기가 많아서 이해하기 어려울지도 모릅니다. 이해해도 실행하는 것은 보통 수단으로는 안됩니다. 하지만 두렵지는 않습니다.
<br/><br/>
중구난방식의 설계에 우선 움직이면 된다고 만들어진 앱을 오랫동안 유지하고 기능 추가하는 것이 더 무섭습니다.
<br/><br/>
간단한 곳부터 꼭 도메인 기반 설계의 본질을 도입해보세요.
</div>
</div>
DDD는 어렵지만 무섭지 않다
<hr>

<div class="row">
<div class="col-lg-6">
<img src="https://2.bp.blogspot.com/-e2knimDdPIs/WMDaAPMBNWI/AAAAAAAAltY/4VKZKBN1dM8FRcr6B6-F3H0NP48iGaf5ACLcB/s320/DroidKaigi2017.120.jpeg"/>
</div>
</div>
끝
