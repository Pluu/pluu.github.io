---
layout: post
title: "[번역] DroidKaigi 2018 ~ Android 앱 개발에서의 도메인 주도 설계를 하는 이야기"
date: 2019-04-28 23:45:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ Android アプリの開発でドメイン駆動設計に取り組む話](http://y-anz-m.blogspot.com/2018/02/android.html) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

[지난번](http://y-anz-m.blogspot.jp/2017/03/droidkaigi-2017_9.html)에 이어 연설 원고와 함께 공개합니다.

(강연에서는 애드립도 있으므로 원고와는 약간 다른 것을 양해 바랍니다)

추가 : [이전의 내용](http://y-anz-m.blogspot.jp/2017/03/droidkaigi-2017_9.html)을 읽지 않은 분은 먼저 이전 내용을 읽어보세요.

### 1p

<img src="https://1.bp.blogspot.com/-WwHiFW5VUT0/Wn1dhlSd3QI/AAAAAAAAtV0/0lv25kjHKtkFJtz1mD4LIMzyI65vvnyGgCLcBGAs/s320/DroidKaigi2018_2.002.png" width="450" />

### 2p

<img src="https://3.bp.blogspot.com/-_QX1ax7B3Ko/Wn1d32HUETI/AAAAAAAAtV8/XdCJcTkoCHUTVBFSdIchU5Nhen5FIowrACLcBGAs/s320/DroidKaigi2018_2.003.png" width="450" />

> 이전 복습

이전 DroidKaigi에서 저는 "도메인 주도 설계이란 무엇인가"라는 이야기를 했습니다. 

사실 이전 CfP를 제출할 시점에서 Android 앱 개발에서의 구현 이야기도 넣을까 했지만, 도메인 주도 설계가 무엇인가를 제대로 설명하는 것만으로도 벅찼습니다.

이번에는 지난번에 후속편이므로, 간단하게 복습부터 하려 합니다. 이전의 이야기의 완전판은 저의 블로그에 적혀있으므로 꼭 읽어 보시기 바랍니다.

### 3p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.004.png" }}" /> 

이전 설명을 복습하면, 도메인 주도 설계란

도메인 전문가의 말을 관찰하고 도메인을 구성하는 유비쿼터스 언어를 찾아 유비쿼터스 언어를 사용하여 도메인을 적절하게 반영한 소프트웨어에 도움되는 모델을 만들고, 만든 도메인 모델을 정확하게 표현하도록 코드를 구현하고 이것을 반복해서 도메인 모델과 구현 모두를 세련시키는 설계 방법입니다.

### 4p

<img src="https://1.bp.blogspot.com/-DK0ao7ndR0U/Wn1d38ifGaI/AAAAAAAAtWA/sXwMzVyiQRQLrEBMB4usyr0lkV084zOnACLcBGAs/s320/DroidKaigi2018_2.005.png" width="450" />

> 전략적 설계 / 전술적 설계

도메인 주도 설계에서는 실천하기 위한 다양한 방법이 나옵니다. 주로 전략적 설계 및 전술 설계의 두 가지로 나눌 수 있습니다.

### 5p

<img src="https://1.bp.blogspot.com/-_MS01-DJjWE/Wn1d4n0TWhI/AAAAAAAAtWI/jeiKS-G5NEIZBhEDviqK9RV10YJx3Jv9wCLcBGAs/s320/DroidKaigi2018_2.006.png" width="450" />

도메인 모델을 만드는데 도움이 되는 방법이 전략적 설계, 도메인 모델에서 그것을 표현한 구현을 하는데 도움이 방법이 전술적 설계입니다.

### 6p

<img src="https://1.bp.blogspot.com/-_MS01-DJjWE/Wn1d4n0TWhI/AAAAAAAAtWI/jeiKS-G5NEIZBhEDviqK9RV10YJx3Jv9wCLcBGAs/s320/DroidKaigi2018_2.007.png" width="450" />

전략적 설계의 유비쿼터스 언어, Bounded Context, Context Map에 대해서 이전에 이야기했습니다.

### 7p

<img src="https://1.bp.blogspot.com/-_MS01-DJjWE/Wn1d4n0TWhI/AAAAAAAAtWI/jeiKS-G5NEIZBhEDviqK9RV10YJx3Jv9wCLcBGAs/s320/DroidKaigi2018_2.008.png" width="450" />

이번에는 전술적 설계를 이야기합니다.

### 8p

<img src="https://1.bp.blogspot.com/-_MS01-DJjWE/Wn1d4n0TWhI/AAAAAAAAtWI/jeiKS-G5NEIZBhEDviqK9RV10YJx3Jv9wCLcBGAs/s320/DroidKaigi2018_2.009.png" width="450" />

도메인 주도 설계에서는 도메인 모델을 그대로 표현하도록 구현합니다.

궁극적으로는 코드를 읽으면 그 도메인 모델을 알고, 그 도메인 모델을 이해하고 있다면 엔지니어가 아니어도 대략 테스트 코드를 읽을 수 있는 상황입니다.

그럼 구체적으로 어떻게 하면, 도메인 모델을 그대로 표현한 것을 구현할 수 있느냐는 생각이 드네요.

### 9p

<img src="https://4.bp.blogspot.com/-aqYG4aXKZrs/Wn1d5xNW_SI/AAAAAAAAtWY/6C7W5fb9pxc-9uGkJxSiTTz8nguZ4GiPQCLcBGAs/s320/DroidKaigi2018_2.010.png" width="450" />

> 전술적 설계
>
> "이렇게 구현하면 제대로 도메인 모델을 표현했어"라는 구현 패턴

### 10p

<img src="https://3.bp.blogspot.com/-Do7zBSEajmo/Wn1d6BjcLbI/AAAAAAAAtWc/EYbxb7hV3dUg9cypCsRec2bhPfYfu3KoQCLcBGAs/s320/DroidKaigi2018_2.011.png" width="450" />

> 전술적 설계
>
> Value Object, Entity, Domain Service, Domain Event, Application Service, Factory, Repository, ...

전술적 설계로 많은 패턴이 소개되어 있는데, 이것들을 도입하지 않아도 도메인 모델을 잘 표현한 구현을 할 수 있다면, 그것은 제대로 도메인 주도 설계입니다.

예를 들어 Domain Event는 에릭 에반스의 책이 출판된 후에 추가되었습니다.

전술적 설계 패턴은 많이 있기 때문에, 모든 Android 앱의 구현에 도움이 되지는 않습니다.

예를 들어, 도메인 주도 설계 구현은 MongoDB와 Spring의 예가 나오는 패턴이 있는데, Android 앱 개발로 대체해서 생각하는 것은 꽤 어렵다.

따라서, 이 강연에서는 이들을 포괄적으로 소개하진 않습니다.

### 11p

<img src="https://3.bp.blogspot.com/-poBcN8DTmYs/Wn1d6WS4OKI/AAAAAAAAtWg/pjmlf3ygj7oboLajmExr2yrlPypBlTqyACLcBGAs/s320/DroidKaigi2018_2.012.png" width="450" />

이번 강연에서는

### 12p

<img src="https://4.bp.blogspot.com/-qEZSY1pIqW4/Wn1d67W5UvI/AAAAAAAAtWk/DDMIUpwDV70uEZcnXz5VdQpVeGFW-2NsACLcBGAs/s320/DroidKaigi2018_2.013.png" width="450" />

> 대상자

오랫동안 개발에서 크고 복잡하게 된 Android 앱에 도메인 주도 설계의 본질을 포함하고 싶지만, 어디서부터 시작하면 좋을지 잘 모르겠다는 사람을 위해서

### 13p

<img src="https://2.bp.blogspot.com/-SgCIuaPaUx8/Wn1d64DWP_I/AAAAAAAAtWo/01X1N4qf2ekCdlrgCmNnU028f9PV2onVQCLcBGAs/s320/DroidKaigi2018_2.014.png" width="450" />

> 도메인 주도 설계를 염두하고 **기존 Android 앱을 리팩토링**해서 이것은 좋았다
>
> 전술적 설계 패턴 & 구체적으로 어떻게 할지의 사례

최근 1년 반, 내가 도메인 주도 설계를 염두에 두고, 기존의 Android 앱 구현을 리팩토링해서 좋았다는 전술적 설계 패턴과 어떻게 도입했는지의 사례를 소개합니다.

새로 만들 때의 이야기는 아닙니다.

지금까지 5개 이상의 앱에서 도메인 주도 설계를 어떻게 활용할지 시행착오를 거쳐 왔습니다.

복잡하게 얽힌 앱의 코드를 조금씩 풀고 UI에 숨겨져 있던 도메인 모델을 구현으로 어떻게 표현했는지 이야기입니다.

### 14p

<img src="https://2.bp.blogspot.com/-p1tCHYC8qxw/Wn1d7LBM86I/AAAAAAAAtWs/hPh1s682QckKmJkWYWE0_0bIYGjLrCiuwCLcBGAs/s320/DroidKaigi2018_2.015.png" width="450" />

>  전제 상황
>
> - Android 앱 개발
> - 릴리즈 후 1년 이상 지속적으로 개발
> - 마스터 데이터는 서버에 있고, 앱은 서버와 API를 경유해서 주고받음
> - 복수 인원으로 개발
> - 서버 측은 다른 팀

좀 더 전제 조건 상황을 이야기하겠습니다.

이런 방법이 좋았어라고 하면 무조건 모두 적용할 수 있는 것은 아닙니다. 어떤 상황일 때 좋았는지를 정해 두지 않으면 서로 불행해집니다.

특히 도메인 주도 설계는 다양한 소프트웨어 개발에서 사용되고 있기 때문에, 동일한 전술적 설계 패턴이라도 해당 도메인뿐만 아니라 플랫폼 및 프레임워크에서 최적의 구현이 다른 것입니다.

이 강연에서 소개하는 구현 예는 다음의 상황을 전제로 하고 있습니다.

먼저 Android 앱 개발에 대한 이야기입니다. iOS 앱과 서버측 개발에는 참고가 되지 않을 수 있습니다.

다음으로 적어도 1년 이상 지속적으로 개발하고 있는 앱을 전제로 하고 있습니다.

이것은 ''어느 정도 모델다운 것이 구성원의 공감대를 가지고, 코드에도 모델이 있는데, 도메인 모델로서 코드에 잘 표현되어 있지 않다" 라는 상황이 되기 위해서는 1년 정도 필요하다고 생각했기 때문입니다. 실제로는 더 기간이 지난 앱을 담당하고 있습니다.

그리고 중요한 전제 조건이 서버와 API를 통해 상호 작용하는 일반적인 클라이언트 앱이라는 점입니다. 게임 앱 등에는 그다지 참고가 되지않을지도 모릅니다.

서버 측이 다른 팀이라는 것은 지난번 이야기한 Bounded Context에 관련된 부분입니다. 서버 및 앱에서 다른 Bounded Context가 되어있는 상황입니다.

그럼, 즉시 본론으로 들어갑시다.

### 15p

<img src="https://4.bp.blogspot.com/-hcDg8_z1qMg/Wn1d7rJ_VqI/AAAAAAAAtWw/3F5CBTxzXLEljQQLz_KG83ksRiflpwBfgCLcBGAs/s320/DroidKaigi2018_2.016.png" width="450" />

> 도메인을 분리한다

첫 번째 전술적 설계 패턴은 "도메인 분리"입니다.

이전의 이야기에서 "도메인 분리"한다는 것은

### 16p

<img src="https://2.bp.blogspot.com/-gRHowVqFg0Q/Wn1d76WTokI/AAAAAAAAtW0/KUJfNwjzbdw3zCUaFqJbu7ebd_7PuuMQwCLcBGAs/s320/DroidKaigi2018_2.017.png" width="450" />

> 비즈니스 로직을 도메인 모델로 분리한다

"비즈니스 로직을 도메인 모델로 분리한다"라고 이야기했습니다.

### 17p

<img src="https://4.bp.blogspot.com/-GC998NenD3E/Wn1d8CfT_OI/AAAAAAAAtW4/bUpkTRQ3dYkNnRuOCgSIKsGBD4Ubzra2wCLcBGAs/s320/DroidKaigi2018_2.018.png" width="450" />

> 왜 분리하는가?

책에는 다음과 같이 적혀있습니다.

### 18p

<img src="https://1.bp.blogspot.com/-ldEwY2mQyI4/Wn1d8yaMZFI/AAAAAAAAtW8/SlvgqmQ0KjAm_qLZozJ2x4Z4KzEm01RHACLcBGAs/s320/DroidKaigi2018_2.019.png" width="450" />

"도메인 로직이 프로그램외의 관심사가 섞여있으면, **설계와 구현을 일치시키는** 것이 현실적이지 않다"

여기에 도메인 로직은 도메인 모델에 속하는 로직입니다. 도메인 모델에 대한 로직, 도메인이 가지고 있는 로직이라고 할 수 있습니다.

예를 들어, 도메인 모델에 속하는 로직이 UI에 쓰여있으며 도메인 모델을 그대로 표현해 구현할 수 없습니다.

### 19p

<img src="https://3.bp.blogspot.com/-TX_OQ2BV83Y/Wn1d9RwWbSI/AAAAAAAAtXA/lxX8Q2OVQvoiZ-Amfno6yLZz7It8-sJFwCLcBGAs/s320/DroidKaigi2018_2.020.png" width="450" />

>  어떻게 분리하는가?

설계와 구현을 일치시키기 위해 분리한다는 것을 알 수 있었습니다.

그렇다면 다음은 어떻게 분리할 것인가입니다.

책에서는 다음과 같이 적혀 있습니다.

### 20p

<img src="https://2.bp.blogspot.com/-QjwcdfxYg6U/Wn1d9YMvvRI/AAAAAAAAtXE/NnqBuu6a07IMxPbLUpLY9A3xYA1KkFVqQCLcBGAs/s320/DroidKaigi2018_2.021.png" width="450" />

> 도메인 레이어를 분리한 상태를 유지할 수 있다면, **어떤 방법이라도 괜찮다**

### 21p

<img src="https://1.bp.blogspot.com/-GoEch6u1AI8/Wn1d9jCZ7sI/AAAAAAAAtXI/V5QgQiW8vpMNZVk7lGDhTns75NSf6Xi8ACLcBGAs/s320/DroidKaigi2018_2.022.png" width="450" />

> "DDD의 큰 이점의 하나가 **특정 아키텍쳐에 의존하지 않는다**라는 것이다"

이 문장은 이전에도 소개했습니다.

### 22p

<img src="https://1.bp.blogspot.com/-D3viE7yGWs0/Wn1d-PgBsXI/AAAAAAAAtXM/A6vbxZcQuEABMH9ucWDl-7KsFSBcNDbxwCLcBGAs/s320/DroidKaigi2018_2.023.png" width="450" />

> 방법은 상관없다

즉 도메인을 분리하는 방법은 상관없다는 것입니다.

원하는 방식으로 하면 됩니다. 그래서 지난번에는 구체적인 방법은 소개하지 않았습니다.

에릭 에반스의 도메인 주도 설계를 읽은 분이라면, 그럼 저건 뭐야, 라고 생각할지도 모릅니다.

### 23p

<img src="https://3.bp.blogspot.com/-CBAHZ58BOIA/Wn1d-YDuTcI/AAAAAAAAtXQ/-AeLZ-n-IMcsjdjOX0qPLj4ffkzBDapHgCLcBGAs/s320/DroidKaigi2018_2.024.png" width="450" />

> Layered Architecture

그렇습니다. Layered Architecture입니다

### 24p

<img src="https://4.bp.blogspot.com/-g7n3cW7sGss/Wn1d-V4C9WI/AAAAAAAAtXU/v2bKmzDi9scxE-KljschGHQpobUsHk4zACLcBGAs/s320/DroidKaigi2018_2.025.png" width="450" />

> 왜 에릭 에반스의 도메인 주도 설계에서는 Layered Architecture가 소개되었는가

방법은 상관없다고 말하는데 소개하고 있으니 그 이유는 간단합니다.

### 25p

<img src="https://1.bp.blogspot.com/-nMqtHRrbeVQ/Wn1d-4-lX8I/AAAAAAAAtXY/i-5gyN2tQ1QH1LKWg8NsAy9A5ZPofDHrQCLcBGAs/s320/DroidKaigi2018_2.026.png" width="450" />

> 어떻게 할지 잘 모르겠다는 사람도 있기 때문에 도메인을 분리할 수 있는 예로서 Layered Architecture가 소개되었다

단순히 예입니다.

갑자기 도메인을 분리하라고 말해도, 구체적인 예가 없으면 이해하기 어렵습니다.

즉, 도메인을 분리할 수 있을 것 같은 설계로 이런 것이 있다는 예로서 Layered Architecture가 소개되고 있다는 것입니다.

### 26p

<img src="https://2.bp.blogspot.com/-6YnIUPnnMRA/Wn1d_CXwFGI/AAAAAAAAtXc/hS714cYyydsccKT0GHipKYWqphXf_zfNQCLcBGAs/s320/DroidKaigi2018_2.027.png" width="450" />

> 목적은 
>
> **도메인을 분리한다** 
>
> 방법은 상관없다

어디까지나 목적은 도메인을 분리하는 것입니다. 그것이 가능하면 어떤 방법이라도 상관없다.
하지만 방법은 다음과 같이 적혀 있습니다.

### 27p

<img src="https://1.bp.blogspot.com/-9vyv7XN81xE/Wn1d_W0wIxI/AAAAAAAAtXg/qT4dWPmTNMw0hANVJ4KFv6fEQp4xWkShwCLcBGAs/s320/DroidKaigi2018_2.028.png" width="450" />

> 아키텍쳐가 **도메인에 관련하는 코드를 분리**해서 응축도가 높은 도메인 설계가 **시스템의 다른 부분과 느슨한 결합**이 되어있다면 그 아키텍쳐는 아마도 도메인 주도 설계를 유지할 수 있을 터이다.

단순히 두는 곳을 나누면 된다는 것은 아니고 다른 부분과 느슨한 결합할 수 있게 할 필요가 있다는 것입니다.

### 28p

<img src="https://1.bp.blogspot.com/-CvFuuzlyPE4/Wn1d_71YGnI/AAAAAAAAtXk/GT5sAV2oZ_YadXRqrS7heuy5Bnzvl35sACLcBGAs/s320/DroidKaigi2018_2.029.png" width="450" />

> 목적은 
>
> **도메인을 분리한다** 
>
> 시스템의 다른 부분과 느슨한 결합할 수 있는 방법으로

정리하면, 시스템의 다른 부분과 느슨한 결합할 수 있는 방법으로 도메인을 격리하는 것입니다.

### 29p

<img src="https://3.bp.blogspot.com/-ze5N7iFPun8/Wn1eALcX7YI/AAAAAAAAtXo/sWmmRBtF56sep7FtW_-eib08uGlKVO2qQCLcBGAs/s320/DroidKaigi2018_2.030.png" width="450" />

> Android 앱에서 도메인을 분리하고 싶다

Android 앱에서도 도메인을 격리하고 싶어졌습니다.

### 30p

<img src="https://1.bp.blogspot.com/-vATlMH2KGZ8/Wn1eAGFbH9I/AAAAAAAAtXs/1l4fDyjuSf0Ov3-mQrwpgSqFiZJw3szrQCLcBGAs/s320/DroidKaigi2018_2.031.png" width="450" />

> 앱 개발은 똑똑한 UI가 되기 쉽다

이전에 이야기했지만, 우리는 UI에 도메인의 개념과 지식, 비즈니스 로직을 담게 됩니다.

똑똑한 UI에서 벗어나기 위해서 꼭 도메인을 분리하고 싶습니다

### 31p

<img src="https://2.bp.blogspot.com/-NRgMfxhyrq0/Wn1eAURZAEI/AAAAAAAAtXw/naKjj9KOzD4nWUXriQ8kPAygiyVV8XGxwCLcBGAs/s320/DroidKaigi2018_2.032.png" width="450" />

> 어떻게 분리할까?

그렇게 되면 문제는 어떻게 분리하는가? 입니다

### 32p

<img src="https://2.bp.blogspot.com/-_n0ZugCb7KY/Wn1eA87tWlI/AAAAAAAAtX0/jYA3p16op2EmpDG3NoMwhX8D7UmsvUI4QCLcBGAs/s320/DroidKaigi2018_2.033.png" width="450" />

> - UI는 도메인을 알지만, 도메인은 UI를 모르게 하고 싶다
>   - UI가 도메인에 의존
> - 의존 방향을 강제하고 싶다
>   - 주의할 기준이라면 모르도록 하는 것
>   - 컴파일 에러로 강제

하고 싶은 것은,

UI는 도메인을 알고 있지만, 도메인은 UI를 모르게 하고 싶은 것,

도메인과 다른 부분을 느슨하게 하고 싶은 것,

그리고 그것을 강제하고자 하는 것입니다.

단순히 패키지를 나누는 것만 아니라 도메인에서 UI의 클래스를 보려고 하면 보입니다.

보지 않도록 조심하기 위해 모르게 합니다. 멤버가 바뀌었을 때 뿐만 아니라 릴리즈에 맞추기 위해서 이번 만큼은 특별히 같은 것을 쉽게 상상할 수 있습니다.

### 33p

<img src="https://1.bp.blogspot.com/-K7Fy_GFEXhU/Wn1eBPH5F9I/AAAAAAAAtX4/BKkL8uJaqlwZIVNjKhftUNFjGtZWhSDIQCLcBGAs/s320/DroidKaigi2018_2.034.png" width="450" />

> 도메인을 별도 모듈로

그래서 도메인용으로 별도 모듈을 만들기로 했습니다.

이 모듈은 gradle 모듈입니다

### 34p

<img src="https://4.bp.blogspot.com/-j4arwPARvxI/Wn1eBRlUvUI/AAAAAAAAtX8/CgmMMJgl9yszXhLU2gpl_I0JT0WreX0qACLcBGAs/s320/DroidKaigi2018_2.035.png" width="450" />

> 별도 모듈로 하면
>
> - 도메인이 UI를 알지 못하도록 강제할 수 있다
> - 단순한 로직 부분이므로 테스트를 적기 쉬워진다
> - 도메인 부분의 동작을 유지한 채 UI만 변경할 수 있다

이러한 구성으로 하면 도메인이 UI를 모르게 하도록 강제할 수 있으며, 순수한 로직 부분만으로 되기 때문에 테스트 쓰기가 쉽습니다.

또한 UI를 변경해도 도메인 부분에 변경이 없으므로, 그 부분의 작동을 담보할 수 있으며, 도메인 모듈을 다시 빌드하지 않기 때문에 조금 빌드가 빨라집니다.

### 35p ~ 37p

<img src="https://2.bp.blogspot.com/-6h2H5PXzzIY/Wn1eCS3YYGI/AAAAAAAAtYI/GXRxFNEGB3wdY2pwXs69gMyBjsZMdrEiQCLcBGAs/s320/DroidKaigi2018_2.038.png" width="450" />

> 1. 도메인을 분리한다 → domain module
>
> 도메인 모델을 찾아서(?) 계속 넣는다

그럼, 도메인 모델이 위치할 것이 결정되었습니다.

그리고 여기에 도메인 모델을 넣어갑니다만,

무엇을 넣으면 좋을지 잘 모르겠다고 생각이 들지 않나요?

아니, 넣는 것은 도메인 모델이라는 것은 알고 있어요.

모르는 것은 자신의 코드 중에서 어느 것이 도메인 모델이어야 하는지, 어디에서부터 찾아가면 좋을지 ...

그래서 도움이 되는 것이 다음의 전술적 설계 패턴 "Value Object"입니다.

### 38p

<img src="https://1.bp.blogspot.com/-bwenKZAgAKc/Wn1eCuBtV1I/AAAAAAAAtYM/q-Svdh_agbwJ3mOKsh10sOBKw1TJRptlwCLcBGAs/s320/DroidKaigi2018_2.039.png" width="450" />

> Value Object

먼저 도메인 주도 설계 책에서 Value Object에 대해 뭐라 하는지 살펴보자.

### 39p

<img src="https://3.bp.blogspot.com/-qzIg8ObovSA/Wn1eC5bxYaI/AAAAAAAAtYQ/CONHnvsFj6IQeL0siZjFSrUgrsAH2qJtgCLcBGAs/s320/DroidKaigi2018_2.040.png" width="450" />

> "어느 Object가 도메인의 기술적인 측면을 표현하고 개념적인 동일성이 없는 경우, 그러한 Object는 Value Object로 불린다."

개념적인 동일성을 가지지 않는다는 것은 고유하게 식별할 필요가 없고, 구별할 필요가 없다는 것입니다.

### 40p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.041.png" }}" /> 

예를 들어 색상은 Value Object의 하나입니다.
같은 색깔을 가진 Color 객체를 구별할 필요가 없겠지요.

도메인 모델 중 일부는 이러한 "무엇인가? 만 문제가 되고 누구인지 어떤 것이든 상관없는 요소"가 나옵니다.
이러한 Value Object로 구현하는 것으로 도메인 모델을 표현한 구현이 됩니다.

Value Object의 다른 면도 보시죠.

### 41p

<img src="https://2.bp.blogspot.com/-PSsx0GO42jQ/Wn1eDSCmQNI/AAAAAAAAtYY/hH32bVUU88Ax4FSU8YgTZim_kNJmFwP-ACLcBGAs/s320/DroidKaigi2018_2.042.png" width="450" />

> "Value Object를 **불변**으로 다루는 것"

도메인 주도 설계에서는 Value Object를 불변으로 권장합니다.

불변이라면 자유롭게 복사 및 공유할 수 있고 여러 스레드에서 안전하게 사용할 수 있습니다. 또한 인수 또는 반환 값으로 다른 객체에 전달해도 그곳에서 변경되지 않기 때문에 설계 단순화에 도움이 됩니다.

### 42p

<img src="https://1.bp.blogspot.com/-TtBKw3sX5W0/Wn1eD5ErbeI/AAAAAAAAtYc/xRuzaWaYoXoLrUPST7O0WtwEtuzANWWWQCLcBGAs/s320/DroidKaigi2018_2.043.png" width="450" />

> Color가 불변이 아니다

예를 들어 Color 객체라면 이처럼 내부적으로 유지하는 색상 값을 조정하는 것은 추천할 수 없습니다.

### 43p

<img src="https://4.bp.blogspot.com/-pKLlAVUQjRY/Wn1eEEibeGI/AAAAAAAAtYg/tirIUfw4OmMW39Hun59QCOGvi8NQKboQQCLcBGAs/s1600/DroidKaigi2018_2.044.png" width="450" />

> Color는 불변이므로 변경할 수 있다

이와 같이 Color 객체는 불변이고 색 변경 시에는 Color 객체 자체를 교체해야 합니다.

이 말을 듣고 왠지 들어 본 적이 있다고 생각하신 분들이 계실거라고 생각합니다. Immutability 이야기는 Effective Java에서도 소개되고 있습니다.

또 다른 부분도 보도록 하죠.

### 44p

<img src="https://4.bp.blogspot.com/-1bk87dl2yf4/Wn1eEWk-VgI/AAAAAAAAtYk/8epRAnDtdZc9cRmsrY4tigReFFhAJqKvwCLcBGAs/s320/DroidKaigi2018_2.045.png" width="450" />

> "Value Object를 구성하는 속성은 **개념적인 통일체**를 형성해야 한다"

개념적인 통일체 ... 좀 어렵네요.

### 45p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.046.png" }}" /> 

예를 들어 사용자에 연결된 정보로 ID와 이름 외에 우편 번호, 도시, 나머지 주소가 있다고 합니다.

이때 우편 번호, 도시, 나머지 주소는 사용자의 별도 속성이 아닌 주소는 통일체를 형성하는 속성입니다.

따라서 이 3가지로 형성되는 주소라는 Value Object를 제공하고 사용자는 주소를 갖도록 합니다.

### 46p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.047.png" }}" /> 

Value Object는 도메인 주도 설계에서 도메인 모델을 구성하는 기본 요소입니다. 엔티티와 도메인 서비스 등 다른 전술적 설계 패턴은 모두 Value Object를 이용합니다.

즉 Value Object가 되는 도메인 모델을 찾는데서 시작하는 것이 최선이라는 것입니다.

그렇게 말해도 Color는 Android 프레임워크에 있고, Value Object로 할만한 것을 찾을 수 있을까?

그런 당신을 위해 이번에는 Android 앱 개발에 Value Object로 모델링한 예를 많이 준비했습니다.

### 47p

<img src="https://4.bp.blogspot.com/-52fOavtqFII/Wn1eFHBOaaI/AAAAAAAAtYw/db5kWp3QxnUQXVpPeeYw4VEoErOoV016wCLcBGAs/s320/DroidKaigi2018_2.048.png" width="450" />

> Android 앱에서 Value Object를 구현한다

예를 소개하기 전에, Android 앱에서 Value Object를 어떻게 구현할까요

### 48p ~ 49P

<img src="https://2.bp.blogspot.com/-Td4Lf5DEdvU/Wn1eFsobniI/AAAAAAAAtY4/Q1IvLg3WENkAZH8nCj_AkyAUdf-gm5nxwCLcBGAs/s320/DroidKaigi2018_2.050.png" width="450" />

> Value Object란
>
> - 상태를 불변으로 유지
> - 값이 같은지 아닌지 비교 가능
> - 전체를 완전히 대체 가능
>
> → Kotlin 이라면 data class + val property가 최적

구현 요구 사항이다

상태를 불변으로 유지, 즉 불변이 가능

값이 같은지 비교 가능

전체를 완전히 대체 가능

에 주목하면,

Kotlin의 data class 가 좋습니다. 불변 객체로 하고 싶기 때문에 속성은 val 이죠.

Java라면 필드를 모두 final로 정의 equals()과 hashCode()를 override하거나 AutoValue 등의 라이브러리를 사용하는 방법도 있습니다. 하지만 이를 계기로 Kotlin를 도입해 보면 어떻습니까.

### 50p

<img src="https://4.bp.blogspot.com/-0KXyO_zlvhM/Wn1eGF2n5zI/AAAAAAAAtY8/4wo8G7VgucoBhz_ijot1W93UacIZvI4XACLcBGAs/s320/DroidKaigi2018_2.051.png" width="450" />

> Android 앱에서 Value Object를 찾자

그럼 Android 앱에서 Value Object를 찾아봅시다

### 51p

<img src="https://3.bp.blogspot.com/-fN3E1YlcAUQ/Wn1eGXL8WJI/AAAAAAAAtZA/IEfPUWocbfI5ms8o9IonAG-tEtN_hzsKQCLcBGAs/s320/DroidKaigi2018_2.052.png" width="450" />

> ID는 Value Object

### 52p ~ 53p

<img src="https://2.bp.blogspot.com/-pSPURq1eVYg/Wn1eG3pUpuI/AAAAAAAAtZI/94P_XV0m-SwV9QXg-rQusx2gvvwFBrO5QCLcBGAs/s320/DroidKaigi2018_2.054.png" width="450" />

> ID를 문자열인 채로 다루지 않나요?

UserId, ItemId, ProductId, OrderId 등 앱에서 하나 정도 ID를 다루고 있습니다.

ID를 문자열로 처리하고 있지 않습니까? ID를 Value Object로 하면 어떻게 될지 첫 번째 예를 살펴봅시다

### 54p

<img src="https://3.bp.blogspot.com/-0wXnpVi14Mg/Wn1eHFGPz0I/AAAAAAAAtZM/Hs1Y_0k3gdkKpmxNkcp8YsxGLG3bSYepQCLcBGAs/s320/DroidKaigi2018_2.055.png" width="450" />

> 예시 1

### 55p ~ 58p

<img src="https://4.bp.blogspot.com/-TOPPJ8OZNI4/Wn1eIc2yghI/AAAAAAAAtZc/fue_HkqKufYGBFpcaV2TBqc6jwKmwyYSgCLcBGAs/s1600/DroidKaigi2018_2.059.png" width="450" />

> userId는 어떻게 넘기면 좋을까요?
>
> Profile Class가 가지는 id는 여기에 넘겨도 괜찮던가?
>
> 빈 문자열을 던지면 어떻게 되지? 호출 전에 매번 체크해?

사용자 ID에서 팔로워 목록을 검색하는 API입니다.

팔로워 목록 화면을 만들 때, 이 API를 호출 쪽도 호출되는 쪽도 같은 사람이 구현하면 무엇을 건네면 좋을지 알고 있기 때문에 String 이어도 특별히 문제없이 구현할 수 있습니다.

나중에 다른 사람이 다른 곳에서 이 API를 호출하거나 기능을 변경하면 다음과 같은 문제가 나옵니다.

- userId는 어디에 있는 id이지?
- Profile 클래스가 가지고 있는 id는 여기에 전달해도 괜찮던가?

- 빈 문자열은 안되죠? 호출하기 전에 확인해야? 
  userId가 빈 문자열일리가 없지만 그래도 Profile이 가지고 있는 id에 빈 문자열이 들어가지 않는다는 것은 다른 부분을 읽지 않으면 보장할 수 없다 ...

### 59p

<img src="https://4.bp.blogspot.com/-Qu-2RG0fu5k/Wn1eIqNN0zI/AAAAAAAAtZg/1xsTx3clzVM_9E_-eIfPjnrJepR2PCw7gCLcBGAs/s1600/DroidKaigi2018_2.060.png" width="450" />

> String에서 UserId로

그래서 UserId를 Value Object로 합시다.

UserId의 인스턴스가 있다면 그것이 가지는 문자는 절대로 빈 문자열일리가 없다고 보장할 수 있는 상태로 합니다.

이렇게 하면 사용 측은 안심하고 getFollower() API를 호출할 수 있습니다.

Profile 클래스가 가지고 있는 id를 UserId 형이라면 이 API에 전달해도 되는 ID 인 것이 분명합니다.

또한 String으로부터 UserId 형으로 변경하는 것으로 어디에서 이용되는지를 정적으로 분석할 수 있고, 리팩토링시의 영향 범위도 조사도 쉬워집니다.

### 60p ~ 62p

<img src="https://1.bp.blogspot.com/-3Xa4xLLG6kM/Wn1eJaROrSI/AAAAAAAAtZs/u_VZTfqKRiwvzgenNIPKJ6gTXf7p4I5ygCLcBGAs/s320/DroidKaigi2018_2.063.png" width="450" />

> 같은 것

Value Object로 ID를 표현한다는 것은 유비쿼터스 언어의 성장에도 연결됩니다.

예를 들어 앱에서 categoryId라는 것이 있어서 Value Object로 하려고 생각해서 사용처를 조사했더니

genreId라는 것도 있는 것을 눈치채고 말았습니다. 차근차근 이야기를 들으면

이 둘은 같은 것이었습니다.

이 ID용 Value Object를 제공하는 클래스의 이름이 필요합니다. 이 이름은 유비쿼터스 언어가 될 것입니다.

그래서 둘 중 누구를 유비쿼터스 언어로 할지는 논의해서 GenreId 통일하자로 되었습니다.

### 63p

<img src="https://1.bp.blogspot.com/-pTI4mGugMKI/Wn1eJ3vH3KI/AAAAAAAAtZw/P-8bckSyyO4fpw82S5pu4xE10uTpgoFOwCLcBGAs/s320/DroidKaigi2018_2.064.png" width="450" />

> GenreId = 유비쿼터스 언어

GenreId를 Value Object로 하면 이렇게 됩니다.

### 64p

<img src="https://2.bp.blogspot.com/-YTQbRuwy_t4/Wn1eKA4yvaI/AAAAAAAAtZ0/DEHki86c8wcEo48l9GsoeeI83WNLE1qEQCLcBGAs/s320/DroidKaigi2018_2.065.png" width="450" />

> 위화감 

GenreId 변수가 categoryId 인게 굉장히 위화감있지요.

ID를 Value Object가 안되는지 생각함으로써 언어의 문제에 주의해, 팀으로 새로운 유비쿼터스 언어를 찾을 수 있었습니다. 헷갈리는 변수 이름이 붙여지는 것을 방지할 수 있습니다.

### 65p

<img src="https://3.bp.blogspot.com/-P3WmpWh1UCQ/Wn1eKKJcirI/AAAAAAAAtZ4/47__x50q9qkjgpuKC9kzKTIsSXZGYk6PACLcBGAs/s320/DroidKaigi2018_2.066.png" width="450" />

> 예시 2

### 66p ~ 67p

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0216-ddd/DroidKaigi2018_2.068.png" }}" /> 

제품 ID가 브랜드의 ID와 브랜드내 코드로 구성되어있습니다.

제품 화면에서 브랜드 목록 화면으로 이동하기 위해 제품 ID 문자열을 처리하여 브랜드 ID 부분을 꺼낼 수 있게 되어있었습니다.

id가 빈 문자열이거나 : 을 포함하지 않는 문자열이라면, 의도하지 않은 값으로 BrandActivity가 열리게 된다는 문제도 있습니다만,

여기에서 가장 큰 문제는 UI가 알아서는 안되는 제품 ID의 형식이 노출되고 있는 것입니다.

이제 잘 알겠죠

### 68p

<img src="https://2.bp.blogspot.com/-Ji9mukxLzYE/Wn1eLMFwApI/AAAAAAAAtaE/JPkSHNFprcoQNHO5ydaBdDgGGohG09zbwCLcBGAs/s320/DroidKaigi2018_2.069.png" width="450" />

> ProductId를 준비

Value Object로 ProductId를 준비합시다.

올바른 형식으로 ProductId가 구성되는 것을 보장할 수 있으며, UI 측은 제품 ID 문자열 표현이 어떻게 되어있는지 몰라도 됩니다.

### 69p

<img src="https://4.bp.blogspot.com/-f-cKyZ8PeHE/Wn1eLmk_N1I/AAAAAAAAtaI/2b7X5jzNIKgwjm4qXiHAUQmbCqRIa4aewCLcBGAs/s320/DroidKaigi2018_2.070.png" width="450" />

> 종류 구별은 Value Object

Value Object를 찾는 방법을 아셨나요?

그럼 다음 예로 이동합니다.

### 70p

<img src="https://4.bp.blogspot.com/-iVuucabZJpE/Wn1eLmjGMsI/AAAAAAAAtaM/7vp2uhJ9nPcK9wsVOEfvZVpJ9pFBQVtxwCLcBGAs/s320/DroidKaigi2018_2.071.png" width="450" />

> "등록화면을 만들 수 있나요? 등록 API는 이겁니다"

사용자 등록 화면의 작성을 의뢰받았습니다.

성별과 생년월일을 전달해야 합니다.

### 71p

<img src="https://4.bp.blogspot.com/-XrRXDroZCf0/Wn1eMF6BW5I/AAAAAAAAtaQ/UK65SMpDZ2cXWjERyL1C2kf7hhX1ncZEwCLcBGAs/s320/DroidKaigi2018_2.072.png" width="450" />

> 성별은 어떤 문자열을 전달하면 좋지? 애초에 성별은 모델이지 않나??

만들기 시작하고서 깨달았습니다.

성별은 어떤 문자열 보내면 좋을까요?

그것보다 원래 다루고 싶은 것은 성별 자체이며, 성별을 표현한 문자열이 아니지요. 그러면 성별은 모델이 아닌가...

같은 성별이라면, 성별로 구분할 필요가 없기 때문에 이것도 Value Object입니다.

### 72p

<img src="https://4.bp.blogspot.com/-dx2cyrI8sic/Wn1eMryX7AI/AAAAAAAAtaU/XNIoPV_Av20cNtY82LTpJm0Zc92UC3NHgCLcBGAs/s320/DroidKaigi2018_2.073.png" width="450" />

이러한 다룰 수 있는 상태가 한정된 Value Object는 enum으로 표현할 수 있지요.

### 73p

<img src="https://1.bp.blogspot.com/-ivd_GDZXWXI/Wn1eM2gdvZI/AAAAAAAAtaY/BNVrxI-SFRUBT6pihW6dapZsslH8IrqngCLcBGAs/s320/DroidKaigi2018_2.074.png" width="450" />

성별 문자열에 대해 UI가 알지 않아도 되었습니다.

하지만 여전히 문제가 있습니다.

### 74p

<img src="https://1.bp.blogspot.com/--y40rZNlwjA/Wn1eNOEKY1I/AAAAAAAAtac/UT5Vxbp_mls2gR3auQgq1F3IrasRh5QYwCLcBGAs/s320/DroidKaigi2018_2.075.png" width="450" />

> 날짜는 Value Object

### 75p

<img src="https://1.bp.blogspot.com/-x-kzUo4DcEs/Wn1eNqeqiHI/AAAAAAAAtag/5VLsUOetPeMJ2uN1sPr61V-m2GIJfuIrgCLcBGAs/s320/DroidKaigi2018_2.076.png" />

> 생일 문자열은 어떤 포맷?
>
> yyyy-MM-dd? 혹은 yyyy/MM/dd 일려나?

생일도 어떤 문자열을 보내면 좋을지 모르겠네요.

이쪽도 생각해 봅시다.

같은 날을 가리키는 날짜는 구별할 필요가 없기 때문에 값 객체로 표현할 수 있습니다.

생일 등 특별한 의미를 가진 날짜는 도메인 모델입니다.

### 76p

<img src="https://4.bp.blogspot.com/-goHSPUxtdvU/Wn1eN0edsQI/AAAAAAAAtak/8pi336Aa9XIblSEHArZm7VmU5UTG_ilqQCLcBGAs/s320/DroidKaigi2018_2.077.png" />

DateOfBirth 클래스로 구현하면 이렇게 될 것입니다.

어떤 포맷으로 하는 문자열인지는 UI로부터 은폐할 수 있습니다.

### 77p

<img src="https://1.bp.blogspot.com/-uo3Cei9ONRs/Wn1eN8XcfTI/AAAAAAAAtao/gTuoDzAJzcABx5EENnpx4PRtO8-YDZbHQCLcBGAs/s320/DroidKaigi2018_2.078.png" />

파라매터 형태로 DateOfBirth을 사용하면 무엇을 건네면 좋을지 분명하게 되었습니다.

### 78p

<img src="https://2.bp.blogspot.com/-C6fPB0Oj1QY/Wn1eOf1JIbI/AAAAAAAAtas/j_hT32GZwgQxvBGXgLdqhSukevzc1rhaACLcBGAs/s320/DroidKaigi2018_2.079.png" />

> 데이터 모델을 벗어나 도메인 모델로

다음의 사례로 가겠습니다.

### 79p

<img src="https://2.bp.blogspot.com/-4sH6bDil1vs/Wn1eOpO7WEI/AAAAAAAAtaw/Hkr-I_qF1wkbCnnLw7YiCummOKG_WVQzgCLcBGAs/s320/DroidKaigi2018_2.080.png" />

> ImageView에 Load

이미지의 가로/세로 크기와 URL을 가진 Image라는 객체가 있습니다. 이미지의 가로세로 비율이 4:3보다 가로로 길다, 예를 들어 16:9라면, wide용 placeholder를 사용한다는 사양입니다.

### 80p

<img src="https://3.bp.blogspot.com/-6Q0Y7F-qonA/Wn1eOzLsmCI/AAAAAAAAta0/GhwdegR_gTo-m6BPp8Z9oiG9erzFRZvCgCLcBGAs/s320/DroidKaigi2018_2.081.png" />

> Image 가로 세로 비율 (width : height)이 4:3보다 가로로 길다면 wide용 placeholder를 사용

> UI 에 로직이 적혀있다.

이 코드의 문제는 wide 여부의 판단 처리가 UI에 작성되어 있는 것입니다. ImageView에 이미지를 로드하는 곳마다 동일한 처리의 코드가 적혀있을 것입니다.

### 81p

<img src="https://4.bp.blogspot.com/-PL_BlJ2vfZI/Wn1ePVmEYnI/AAAAAAAAta8/yh1tcg7I1dkR3-MqQVE0groK8Jv9IQdKwCLcBGAs/s320/DroidKaigi2018_2.083.png" />

> Image가 단순한 데이터 모델

Image 클래스가 단순한 데이터 모델이 되었다는 점입니다. 이러한 상태를 도메인 모델 빈혈증이라고 합니다.

### 82p

<img src="https://4.bp.blogspot.com/-iPbAF6xP4WU/Wn1ePuBC5LI/AAAAAAAAtbA/y9OfH8o_1-Ucf0p4wl6zN7H-OCHmVJLaQCLcBGAs/s320/DroidKaigi2018_2.084.png" />

> Image에 로직을 가지게 한다.

wide 여부의 판단은 도메인 모델, 즉 Image에 속하는 로직이므로, Image에 갖게 합시다.

로직이 누구의 책임인지 생각하기 어렵네요. 저도 헤매는 경우가 종종 있습니다. 이 예제에서도 wide인지 여부의 정보는 placeholder를 용도에 맞게 사용하기 위해 쓰이고 있기 때문에, UI 로직이며 도메인 로직은 아니지 않을까?라고 생각할지도 모릅니다.

이 예제에서는 Image에 뒀지만, 표현하는 도메인 모델이 다르면 다른 구현이 될 것입니다. 획일적인 판단 기준이 아니라 머릿속 도메인 모델에 있어서 자연스러운지 아닌지 일 뿐입니다. wide 여부라는 속성은 Image라는 도메인 모델에게 자연스러운가.

처음부터 마음에 드는 구현이 되지 않는 경우는 많습니다. 중요한 것은 그 구현으로 고정화하지 않고 더 좋은 방법이 생각났을 때 리팩토링할 수 있도록 해 두는 것입니다.

### 83p

<img src="https://4.bp.blogspot.com/-eWDEH7cDJ6U/Wn1eQNZC29I/AAAAAAAAtbE/waJfQNgaBjMvg2VdapeIZJv4cpo_X92wQCLcBGAs/s320/DroidKaigi2018_2.085.png" />

> 서버 응답 형식에 얽매이지 않기

다음의 사례로 가겠습니다.

### 84p

<img src="https://1.bp.blogspot.com/-nFHvQ6HX9RU/Wn1eQTyegaI/AAAAAAAAtbI/LBx4HhQqFu4iQtAARmSQjVECEUt9wrYkACLcBGAs/s320/DroidKaigi2018_2.086.png" />

서버 API를 호출해서 JSON 등의 응답을 받아 그것을 객체에 매핑하는 작업은 많은 Android 앱에서 하고 있습니다.

이때, JSON 또는 XML 구성을 그대로 반영해서 클래스화하지 않았습니까?

### 85p

<img src="https://4.bp.blogspot.com/-l22APUNCm6k/Wn1eQaCMw5I/AAAAAAAAtbM/U9jjQO5UHbI-nSG4tdPWMTIWneLZl6mMgCLcBGAs/s320/DroidKaigi2018_2.087.png" />

예를 들어, 제품 정보를 취득하는 API에서 이와 같은 응답이 돌아온다고 가정하겠습니다.

### 86p

<img src="https://3.bp.blogspot.com/-EMuMyak7q54/Wn1eQ9aXpwI/AAAAAAAAtbQ/O7qiaabAGEAIswtiDSieXSWF__YV3eNhACLcBGAs/s320/DroidKaigi2018_2.088.png" />

> 동일한 이미지의 사이즈 차이

이 images 배열에는 같은 이미지에 다양한 크기의 URL이 포함되어 앱에서는 표시 영역의 크기에 따라서 이 중에서 적절한 것을 사용하는 사양으로 되어있습니다.

### 87p

<img src="https://3.bp.blogspot.com/---tn9McSYgg/Wn1eRC7k7GI/AAAAAAAAtbU/73D__srdrHQ20-uYRcoZ5OXXApnSPNTBgCLcBGAs/s320/DroidKaigi2018_2.089.png" />

이 JSON을 그대로 매핑하면 이러한 클래스가 됩니다.

### 88p

<img src="https://3.bp.blogspot.com/-NdTy5w9k0KA/Wn1eRbOUvvI/AAAAAAAAtbY/gA4CHs__cJgPxOdesSZQgmXWRwiILBWnACLcBGAs/s320/DroidKaigi2018_2.090.png" />

> 표시하는 영역의 크기에 따라 적절한 Image를 선택하는 로직을 어디에 둘까요?

앱은 표시 영역의 크기에 따라 이 중에서 적절한 것을 골라서 사용하는 사양으로 되어있기 때문에 어떤 Image를 사용할지 판단하는 로직이 필요합니다.

그럼, 이 로직을 어디에 두어야 할까요?

### 89p

<img src="https://1.bp.blogspot.com/-orDbR7sz9hY/Wn1eRhFLzFI/AAAAAAAAtbc/JtXZ0FCTnWwNmIg6q8fIWqvmmQDWPo7ugCLcBGAs/s320/DroidKaigi2018_2.091.png" />

여러 곳에서 같은 것을 하므로 UI에 로직을 두는 것은 좋지 않다는 등의 이유로 이러한 유틸리티 클래스에 배치될 수 있습니다.

### 90p

<img src="https://3.bp.blogspot.com/-kUV3gAlFYn0/Wn1eSMPA-AI/AAAAAAAAtbg/cUvRiT4J1JUQkWpnxHEizPj_ry1YUinzwCLcBGAs/s320/DroidKaigi2018_2.092.png" />

> 도메인 모델 빈현증

이 경우 Item 클래스는 값을 가지고 있을 뿐, 그 데이터를 사용한 판단 또는 가공 처리는 다른 곳에서 합니다.

이러한 상태는 이전과 같은 도메인 모델 빈혈증이네요.

### 91p

<img src="https://4.bp.blogspot.com/-wLaS8OOunds/Wn1eSeW2QaI/AAAAAAAAtbk/wJL5EdTfkUEt0cjlXsFn5HwR2OihNnSlQCLcBGAs/s320/DroidKaigi2018_2.093.png" />

> Item에 로직을 둬봤습니다만

Item이 빈혈이므로 Item에 이 로직을 둬봤습니다.

그런데 문제가 발생합니다.

### 92p

<img src="https://1.bp.blogspot.com/-QrxmN04Azds/Wn1eSr47K-I/AAAAAAAAtbo/AJAdfbgP7jM3tLid3ahVUD4tMNiG78hSgCLcBGAs/s320/DroidKaigi2018_2.094.png" />

> 중복

Item 이외에 Category에서도 Image를 선택하는 과정이 필요했습니다.

Item 및 Category에 동일한 로직이 중복되어 좋지 않습니다.

### 93p

<img src="https://4.bp.blogspot.com/-psZq9cmkqiA/Wn1eTMx45UI/AAAAAAAAtbs/_W7WajVH6QUGi7Ohyv-HBjoIIQ_VxUaAQCLcBGAs/s320/DroidKaigi2018_2.095.png" />

> "표현하는 영역의 크기에 따라 적절한 Image를 선택하는 로직"은 누구의 책임인가요?

그럼 어떻게 할까요?

JSON의 형식을 일단 잊어두고 "표시 영역의 크기에 따라 적절한 Image를 선택하는 로직"은 누구의 책임인가를 생각합시다.

정말 Item의 책임일까요?

### 94p

<img src="https://4.bp.blogspot.com/-rGkpWl7vLMo/Wn1eTaL9O4I/AAAAAAAAtbw/Pj-A5Z2RMKQzzw4rQVIPVWZdf27qhvb3QCLcBGAs/s320/DroidKaigi2018_2.096.png" />

Item과 Category의 책임이 아니라, Image의 집합이라는 다른 도메인 모델의 책임이 아닐까요

### 95p

<img src="https://1.bp.blogspot.com/-PG__Huzt7yk/Wn1eTklUBAI/AAAAAAAAtb0/o1tH0K_F-E0f_V2h69AjzBMuG9EyrO4egCLcBGAs/s320/DroidKaigi2018_2.097.png" />

> Image 집합이라는 도메인 모델

Image의 집합을 표현하는 도메인 모델로 Images 클래스를 도입해 보면 어떨까요.

적절한 Image를 선택하는 로직을 둘 곳으로 자연스러운 느낌이 들지 않나요?

### 96p

<img src="https://1.bp.blogspot.com/-XR_PJ5lSfOI/Wn1eTyjnoQI/AAAAAAAAtb4/l1_Jk9dPj9EjJEp0uYv3FppS5GMGaG-LwCLcBGAs/s320/DroidKaigi2018_2.098.png" />

> 서버의 응답 형식에 얽매이지 않고 도메인 모델을 생각

서버의 응답 형식에 얽매이지 않고, 다른 도메인 모델이 있는 것은 아닐까

도메인 모델을 적절히 표현하는 Value Object가 있는 것은 아닐까 생각해 보세요.

### 97p

<img src="https://4.bp.blogspot.com/-EAPq5I9wnqc/Wn1eUEPaTEI/AAAAAAAAtb8/uDz0oaFIgXsy8u2Z3m1cxiuqn_YUolFVgCLcBGAs/s320/DroidKaigi2018_2.099.png" />

다음의 사례로 가겠습니다.

### 98p

<img src="https://3.bp.blogspot.com/-REgkZoztGls/Wn1eUeuluQI/AAAAAAAAtcA/fufBnPoaQaQHWD-WY6kwucdoI8zlL9iWQCLcBGAs/s320/DroidKaigi2018_2.100.png" />

이번에는 소식 목록을 받았을 때의 응답입니다.

각 소식에는 배너가 포함된 경우가 있고, 배너에는 표시 기간의 시작/종료 일시가 있습니다.

### 99p

<img src="https://3.bp.blogspot.com/-tmu2B-O-VPU/Wn1eU_RF-bI/AAAAAAAAtcE/Y0QN_X1b6W0eKfDaQzNv2B5KsaSJ2k5XACLcBGAs/s320/DroidKaigi2018_2.101.png" />

이것을 그대로 매핑하면 이러한 클래스입니다.

이것을 사용한다면 어떨까요?

bannerImageUrl은 null이 아니지만, bannerStartDate가 null인 경우는 어떻게 할까요? 라고 생각하지 않습니까?

### 100p

<img src="https://1.bp.blogspot.com/-J_OCKhBlTmE/Wn1eVAkbWLI/AAAAAAAAtcI/EmGjxq63x3UTmVYkKelo41M0fx1Zv3sigCLcBGAs/s320/DroidKaigi2018_2.102.png" />

>  banner에 관한 3개 속성으로 개념적인 통일체

이 banner 관한 3가지 속성은 각각 소식에 속하는 것이 아니라, 이 3개로 개념적 통일체를 구성하고 있습니다.

### 101p

<img src="https://2.bp.blogspot.com/-a-jjnhhwALo/Wn1eVW24WNI/AAAAAAAAtcM/J5jdGH7ptCYGkhP6yspKdwGSAxXfqEc8gCLcBGAs/s320/DroidKaigi2018_2.103.png" />

즉, 이 3가지 속성을 가진 Value Object가 필요합니다. 그것을 Banner 클래스로 한다면 이렇게 됩니다.

banner 인스턴스가 있으면 url도 날짜도 갖추어져 있다는 것을 확인할 수 있습니다.

### 102p

<img src="https://4.bp.blogspot.com/-aWzW4QigusM/Wn1eVtpUoRI/AAAAAAAAtcQ/wnl6MINVmxcVhza7-AuHDJVS6_yaRXpDACLcBGAs/s320/DroidKaigi2018_2.104.png" />

> 사전조건과 로직을 가지게 한다

추가저긍로 시작 시간이 종료 시간 이전임을 사전 조건으로 보장 가능하며, 오늘이 표시 기간 내인가 판단하는 로직을 넣어둘 곳으로도 자연스럽습니다.

### 103p

<img src="https://2.bp.blogspot.com/-WIZIrYUYujQ/Wn1eV8eMJdI/AAAAAAAAtcU/pWbUbcFywoQhRwhBGb4n0izZ6auSOw8WwCLcBGAs/s320/DroidKaigi2018_2.105.png" />

다음의 사례로 가겠습니다.

### 104p

<img src="https://1.bp.blogspot.com/-qUVPPtLmUHU/Wn1eWN5y_4I/AAAAAAAAtcY/6-9TbeJYoCcYT8PJUCX93IASfAnPc0d0QCLcBGAs/s320/DroidKaigi2018_2.106.png" />

이 앱에는 사용자가 사용할 수 있는 전자 상품이 있습니다.

상품에는 로그인하지 않고도 사용 가능한 것과 로그인이 필요한 것, 유료 회원만 사용할 수 있는 것 등이 있고, 서버에서 여러 상태가 반환됩니다.

예전에는 2종류 밖에 없었다지만 역사적인 경위라든지 확장 등으로, 이런 응답으로 되어있습니다.

### 105p

<img src="https://4.bp.blogspot.com/-71d-GCncM58/Wn1eWo6dU9I/AAAAAAAAtcc/dkjMeSFfEtI-YJQX_nMssfz4flMGC4hpgCLcBGAs/s320/DroidKaigi2018_2.107.png" />

지금까지의 이야기의 흐름에서 상상할 수 있듯이 이런 클래스에 매핑되어 있습니다.

UI 쪽에서 if 문을 사용한 처리가 되리라는 것은 쉽게 상상할 수 있습니다.

여기에서도 일단 응답 형식의 잊도록 합시다.

상품을 도메인 모델로 생각하면, 상품의 속성으로 자연스러운 것은 개별 Boolean보다, 어떤 상품인가라는 종류입니다.

### 106p ~ 107p

<img src="https://2.bp.blogspot.com/-wnpchQ7ZXZE/Wn1eXDoX8VI/AAAAAAAAtck/7jFs1hHWUu8naiuzJiguA-qBA6u142qwACLcBGAs/s320/DroidKaigi2018_2.109.png" />

> 도메인 전문가와 이야기
>
> - 로그인하지 않고도 사용할 수 있는 상품
> - 로그인하면 사용할 수 있는 상품
> - 유료회원만 사용할 수 있는 상품
> - 상품을 구입한 사람이 사용할 수 있는 상품
> - 상품을 구입한 사람 혹은 유료회원이라면 사용할 수 있는 상품
>
> (※ `상품을 구입한 사람`은 원문에서는 都度料金으로 기술했습니다.)

그렇게 되면 다음은 어떤 종류가 있는가이지만, 여기에서는 아무것도 생각하지 말고 Boolean 4개의 조합이므로 2의 4승인 16가지 있구나로해서는 안됩니다.

다음에 할 것은 도메인 전문가와 이야기하는 것입니다.

어떤 종류의 상품이 있다고 인식하고 있는지 물어보면 결국은 5종류밖에 없는 것으로 밝혀졌습니다.

### 108p

<img src="https://1.bp.blogspot.com/-0eAp8bmBiWw/Wn1eXiub4YI/AAAAAAAAtco/HGpp2TvsccMkwksIQptJQt_w8I_y6-yyACLcBGAs/s320/DroidKaigi2018_2.110.png" />

이 5가지를 enum으로하면 좋겠네요.

Boolean 조합은 16 패턴이 있는데 상품은 5종류 밖에 없다는 것은, 있을 수 없는 조합이나 이미 사라진 조합이 있다는 것입니다.

판명된 종류를 바탕으로, 서버 팀에 어떨 때 어떤 값이 돌아오는지 확인합시다.

### 109p

<img src="https://4.bp.blogspot.com/-rMiXVp90ka0/Wn1eXtbRyiI/AAAAAAAAtcs/LSSYXdv0_Kooe2p_Umg3maN0pFgruXGvgCLcBGAs/s320/DroidKaigi2018_2.111.png" />

> isMemberUsable은 isPurchaseRequired가 true일 때에만 의미가 있습니다.

isPurchaseRequired가 true의 경우는 isLoginNeeded와 isMembershipRequired는 의미 없기 때문에 무시하세요.

등의 정보를 얻을 수 있었습니다.

### 110p

<img src="https://4.bp.blogspot.com/-NrrxqMra9ZE/Wn1eYVSsS3I/AAAAAAAAtc0/mSy6icqd_OE8rG9p_zVEW5gD9NgEnOyUACLcBGAs/s320/DroidKaigi2018_2.113.png" />

이후는 얻은 정보로 enum으로 변환합시다.

### 111p

<img src="https://2.bp.blogspot.com/-RH6rJ18Dj_E/Wn1eYr6pAZI/AAAAAAAAtc4/kd2oiOj8ChURRYb-eNBwVehEm4enjMVigCLcBGAs/s320/DroidKaigi2018_2.114.png" />

어디서 변환할까요?

Anticorruption Layer 입니다. 이전에 나왔습니다.

### 112p

<img src="https://3.bp.blogspot.com/-Bc3opZE9QCk/Wn1eY0Wis3I/AAAAAAAAtc8/iw4Hq0juaeQBcvWP7kW3g5oZax3ULsW_ACLcBGAs/s320/DroidKaigi2018_2.115.png" />

> Entity

동일한 속성값을 갖는다면 구분이 필요 없다는 모델이 있고, 그것을 Value Object로 표현하는 방법을 여러 가지 소개했습니다.

그러나 모델에는 동일한 속성값이라도 구별할 필요가 있을 수 있습니다. 예를 들어, A와 B가 같은 야마다 타로라는 이름이라도 다른 사람으로 구별이 필요합니다.

이러한 모델을 표현하는 객체로서 도메인 주도 설계에는 Entity라는 전술적 설계 패턴이 있습니다.

책에서는 이렇게 쓰여있습니다.

### 113p

<img src="https://1.bp.blogspot.com/-3mqOcgd2SR8/Wn1eZfRxy3I/AAAAAAAAtdA/z7Cvc2tFFEINiWGSZLbr6m1OD4EH4bDpACLcBGAs/s320/DroidKaigi2018_2.116.png" />

> "주로 `동일성` 으로 정의되는 객체는 Entity로 부른다,"

### 114p

<img src="https://2.bp.blogspot.com/-Vbv4ldYvrz4/Wn1eZviYajI/AAAAAAAAtdE/eC6l2QCE7PA8Gr5gEy-NhbDWxfgcjX_AwCLcBGAs/s320/DroidKaigi2018_2.117.png" />

"생명주기에서 Entity의 형태와 내용은 근본적으로 바뀔 수 있지만, 연속성의 관계는 유지되어야 한다."

Entity는 생명주기가 있습니다. 사람이 일생동안 변화하는 것처럼 생명주기동안 Entity의 내용은 변경될 수 있습니다. 그 때 새로 만들어지는 것이 아니라 이전의 내용이 바뀌었다는 연속성이 유지될 필요가 있습니다.

### 115p

<img src="https://3.bp.blogspot.com/-JYN7bnyZZfw/Wn1eaohaZLI/AAAAAAAAtdQ/ZvKfDILvvt0A7eM8hnoyceaVLK_HpwZLwCLcBGAs/s320/DroidKaigi2018_2.120.png" />

> 연속성 (→ 영속화)과 동일성 (→ 식별자 발행)

이 연속성과 동일성을 소프트웨어에서 표현할 때 문제가 되는 것은 연속성을 유지하기 위해 어떻게 영속화하는가와 동일성을 가지기 위해 식별자를 어떻게 발행할지입니다.

이것들은 기술적인 제약과 관계 있을 수도 있고, 에릭 에반스의 도메인 주도 설계에서도 도메인 주도 설계 구현에서도 구체적인 구현을 내놓고 논의되고 있습니다.

Android 앱에서도 독립적으로 마스터 데이터를 앱 내의 데이터베이스에 저장하는 경우에는 이를 어떻게 구현하느냐가 문제가 됩니다.

그러나 마스터 데이터가 서버에 저장되고 식별자도 서버에서 발행되는 클라이언트 앱에서는 이러한 앱 쪽에서 할 수 없습니다.

### 116p

<img src="https://1.bp.blogspot.com/-Zci7r7EhtEw/Wn1ea6VesNI/AAAAAAAAtdU/YrR5OAVAgrcBOayuI3VRgN73donKYenzQCLcBGAs/s320/DroidKaigi2018_2.121.png" />

현재 Android 앱에서 Entiy가 내가 말할 수 있는 것은 식별자를 사용하여 객체를 비교하도록 구현해야 한다는 것뿐입니다.

UserId에서 유일하게 식별해야 할 User라면 UserId로 식별하도록 equals()와 hashCode()를 override 해야 합니다.

Android 앱에서 Entity의 취급은 아직 시행착오 중이고, 예를 들면 SharedPreferences에 저장하는 최초 실행 여부 플래그 및 알림을 받을지 여부 설정은 Entity인지 등의 고민은 없습니다.

이 이야기는 기회가 된다면 다음에 할 수 있으면 좋겠습니다.

### 117p

<img src="https://4.bp.blogspot.com/-eLmmxT38a_E/Wn1ea-pcmyI/AAAAAAAAtdY/e8yJutsM_PsZeIbuy6OiL43G93gzpWhMACLcBGAs/s320/DroidKaigi2018_2.122.png" />

그럼 정리입니다

### 118p

<img src="https://4.bp.blogspot.com/-DPoGoGTQkgw/Wn1ebq-zY4I/AAAAAAAAtdc/8030xuIAAwEZ4T7K1qCI34-aRdSBnYW_wCLcBGAs/s320/DroidKaigi2018_2.123.png" />

> - 도메인을 격리할 목적으로 Android에서는 gradle 모듈로 나누는 방법이 있다
> - Value Object를 활용합시다
>   - 불변으로 한다
>   - 로직을 가진다
>   - 조건을 포함할 경우에 인스턴스화한다

도메인을 격리하는 목적에 대해 gradle 모듈로 나누는 방법을 소개했습니다. 모듈로 나누는 것으로 의존 방향을 강제할 수 있고 도메인인가 UI 등의 기타 부분을 모르는 상태로 격리할 수 있습니다.

동일한 속성값을 가지고 있다면 구별할 필요가 없는 모델은 Value Object로 표현할 수 있는 것을 소개했습니다.

속성은 불변으로 하고 Value Object자체를 교체함으로 변경에 대응합시다.

모델에 속해야하는 로직을 갖게 합시다. 모델의 표현으로서 조건을 충족하는 경우에만 인스턴스화합시다.

### 119p

<img src="https://2.bp.blogspot.com/-Iahd7e2WPY4/Wn1eb23XYmI/AAAAAAAAtdg/KrFB9fjdMB0CcJ7NIpmFNeMJbKOLesRSACLcBGAs/s320/DroidKaigi2018_2.124.png" />

> - 문자열로 관리한 요소가 Value Object이지 않은가 생각합시다
>   - ID, 종류, 날짜, 크기 ...
> - 서버의 응답 형식으로부터 자유로워지자
> - 데이터 모델에서 도메인 모델로

문자열로 처리하는 요소가 Value Object가 아닌가 생각합시다. ID, 종류, 날짜, 크기 등은 Value Object를 도입하는 좋은 출발점입니다.

서버의 응답 형식은 어떤 경우는 모델을 잘 표현하지 않을 수 있습니다. 그것에 끌려가서 도메인 모델 빈혈증이 되지 않았나요? 일단 응답 형식이라는 것은 잊고, 어떤 모델이 있어야 할지를 생각합시다.

### 120p

<img src="https://3.bp.blogspot.com/--1Z33jTGRxU/Wn1eb6f6DCI/AAAAAAAAtdk/mWjRS0mr-8kn7DuShiSQxaQ1rEi9LIXFACLcBGAs/s320/DroidKaigi2018_2.125.png" />

이상입니다. 들어 주셔서 감사합니다.