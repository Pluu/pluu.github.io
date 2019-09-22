---
layout: post
title: "[요약] Demystifying Android Accessibility Development (Google I/O '19)"
date: 2019-09-22 10:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/bTodlNvQGfY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<!--more-->

Android Accessibility 개발은 매우 복잡하다. Accessibility 조차 Android의 일부이다.

→ 구글 팀이 할일은 복잡성을 다루지않도록 하는 것

세션의 목표

- 아이디어
- 접근성에 대한 전반적인 아이디어
- 경험을 단순화하기 위한 새로운 API
- Test를 위한 일부 Tools

## 일상적인 작업에 적용할 수 있는 세 가지

### 1. 정보를 공개

![001](/Users/pluulove/StudioProjects/pluu.github.io/assets/img/blog/io/io19/demystifying-android-accessibility-development/001.png)

대부분이 시각 장애인을 위한 접근성에 대해서 먼저 시작한다.

#### 크기

- 시력이 약하다
- 나이가 들어서 작은 글씨를 읽기 어려운 것

추가 도구 및 손쉬운 사용없이 정보를 잘 보이게하는 것은 어렵다.

#### 색상

색맹인 사람들에게는 전달하려는 정보가 누락

### 2. 간단하고 큰 컨트롤 선호

![002](/Users/pluulove/StudioProjects/pluu.github.io/assets/img/blog/io/io19/demystifying-android-accessibility-development/002.png)

UI를 보고 내용을 이해할 수 있을때 UI를 사용할 수 있을까? 

이 때 컨트롤의 변화로 큰 차이를 만들 수 있다.

작은 공간에 많은 기능을 추가하면 누군가는 어려움을 겪게된다. (ex, 손가락이 커서 UX 경험이 나쁜 경우)

→ 중요한 정보는 크고 이해하기 쉽게 컨트롤할 수 있도록 해야한다.

![003](/Users/pluulove/StudioProjects/pluu.github.io/assets/img/blog/io/io19/demystifying-android-accessibility-development/003.png)

화면을 볼 수 없는 사용자를 돕기 위해서는 많이 생각해야한다. 이미지 사용시, 전혀 볼 수 없는 사람에게도 효과가 있는지 체크해야한다.



And the simplest way to do that is just to label the image.
And we have a very simple API that Qasid will mention that can help you do that.
When you go to label things, you want to label it precisely, because you're trying to convey information, make sure that information is conveyed in the text.




가장 간단한 방법은 이미지에 레이블을 지정하는 것입니다.
그리고 우리는 Qasid가 당신을 도울 수있는 매우 간단한 API를 가지고 있습니다.
레이블을 지정할 때 정보를 전달하려고하기 때문에 정확하게 레이블을 지정하려고합니다. 정보가 텍스트로 전달되는지 확인하십시오.



But on the other hand, if you think about the experience of a screen reader user, there is-- particularly if it's like a control or something they're going to go to all the time, they don't want to hear a long treatise about how exciting this particular graphic is.
They really want to just get on with their day and get on with whatever action that thing can do.
So you want to label things concisely.
These two things are a little bit in tension with one another.
So part of this is are you trying to really just convey information, and that's what's in there, make sure that's conveyed as precisely as possible.
If you're trying to just explain to somebody how to use something, just one word, which is a verb, is usually enough.
So that's three things.


그러나 다른 한편으로, 스크린 리더 사용자의 경험에 대해 생각하면, 특히 컨트롤이나 그들이 항상 갈 것 같은 것이 있다면, 그들은 오랫동안 듣고 싶지 않습니다. 이 특정 그래픽이 얼마나 흥미로운 지에 대한 논문.
그들은 정말로 하루를 즐기고 그 일을 할 수있는 모든 행동을 계속하고 싶어합니다.
따라서 간결하게 레이블을 지정하려고합니다.
이 두 가지는 서로 약간 긴장되어 있습니다.
이 중 일부는 실제로 정보를 전달하려고하는 것입니다. 그것이 그 안에있는 것이므로 가능한 한 정확하게 전달되도록하십시오.
누군가에게 무언가를 사용하는 방법을 설명하려고한다면, 동사 인 한 단어만으로도 충분합니다.
이것이 세 가지입니다.

But you may have come here to learn more than three things.
So we want to dig a little bit deeper and just think about how users interact with your app.
Much like the three things, there's essentially two things that you're doing.
You're presenting information to users, and you're allowing them to take actions on your UI.
Often the first design ends up being for people who may not necessarily have an accessibility need, but ideally, you're thinking about this upfront.
Then it quickly becomes kind of overwhelming.
You start thinking about, OK, how's somebody who can't see going to use my app? 
How is somebody who's motor impaired going to use my app? 
How is somebody who's deaf or hard of hearing going to use my app? So now suddenly you've got four types of users, which is your original mainstream user and then these three categories.
But within these three categories, the more you stare at them, the more complexity you see.
It's like a fractal.
People who are visually impaired, there's all sorts of different visual impairments.
People can see different levels of detail, different types of things.
Motor impairments come in a radical sort of variety of people out there.
And then also, there are people that have combinations of these disabilities.
And so what are you supposed to do as an app developer? There's like a billion people in the world with a disability.
Are you supposed to think through a billion use cases? The answer is no, fortunately.
And nobody is ever going to think through all billion use cases.
But with an ecosystem like this, we do have the ability to scale to that many use cases.
And the tool we use to do that are Accessibility Services.
These are plug-ins to the Android platform that get information about the UI, can take actions on the UI on behalf of the user.
And those developers can think about, how do I serve this particular set of users that I'm targeting? And so they're the ones that are presenting the information.
If somebody can't see the screen, they're presenting it audio or Braille.
If somebody can't take actions on the screen directly, they may be using a switch to do it.
And then these services can intermediate that.
The way that they work is they get their information from the Android framework, and they use the Android framework to take actions on the UI.

그러나 세 가지 이상을 배우기 위해 여기에 왔을 것입니다.
우리는 조금 더 깊이 파고 들고 사용자가 앱과 상호 작용하는 방식에 대해 생각하고 싶습니다.
세 가지와 마찬가지로 본질적으로 두 가지 일이 있습니다.
사용자에게 정보를 제공하고 있으며 UI에서 조치를 취할 수 있습니다.
종종 첫 번째 디자인은 접근성 요구가 반드시 필요한 것은 아니지만 이상적으로는 이러한 선결제에 대해 생각하는 사람들을위한 것입니다.
그러면 빨리 압도적입니다.
당신은 내 앱을 사용하지 못하는 사람은 어떻습니까? 
운동 장애가있는 사람이 내 앱을 어떻게 사용하게 되나요? 
청각 장애가있는 사람이 내 앱을 어떻게 사용합니까? 
이제 갑자기 네 가지 유형의 사용자가 있는데, 이는 원래 주류 사용자이고이 세 가지 범주입니다.
그러나이 세 가지 범주 내에서 더 많이 응시할수록 더 복잡해집니다.
프랙탈과 같습니다.
시각 장애인은 모든 종류의 시각 장애가 있습니다.
사람들은 다른 수준의 세부 사항, 다른 유형의 사물을 볼 수 있습니다.
운동 장애는 다양한 종류의 사람들로 나옵니다.
그리고이 장애들을 조합 한 사람들도 있습니다.
그리고 앱 개발자로서 무엇을해야합니까? 세계에는 10 억 명의 장애인이 있습니다.
10 억 개의 사용 사례를 통해 생각해야합니까? 대답은 다행입니다.
그리고 아무도 10 억 건의 사용 사례를 모두 생각하지 않을 것입니다.
그러나 이와 같은 생태계를 통해 우리는 많은 사용 사례에 맞게 확장 할 수 있습니다.
우리가 사용하는 도구는 접근성 서비스입니다.
이들은 UI에 대한 정보를 얻는 Android 플랫폼에 대한 플러그인이며, 사용자 대신 UI에 대한 조치를 취할 수 있습니다.
그리고 이러한 개발자는 내가 타겟팅하고있는 특정 사용자 집합에 어떻게 서비스를 제공 할 수 있습니까? 그리고 그들은 정보를 제시하는 것들입니다.
누군가 화면을 볼 수 없으면 오디오 나 점자를 제시하는 것입니다.
누군가가 화면에서 직접 조치를 취할 수없는 경우 스위치를 사용하여 조치를 취할 수 있습니다.
그리고 이러한 서비스는이를 중개 할 수 있습니다.
그들이 작동하는 방식은 Android 프레임 워크에서 정보를 얻고 Android 프레임 워크를 사용하여 UI에 대한 조치를 취하는 것입니다.

And so down here at the bottom is your app.
In your app, what it needs to do is present the information to the Android framework so that the framework can then share it with all these different services to support these different users.
And then it needs to allow the framework to take actions on it so that all these different services, all these different users can actually get control of your app.
So the way that you can do this is really to use the APIs that Qasid is going to talk about in a moment to make sure you're presenting the information and allowing users take actions on it.
And once you've done that, you can use these testing tools to verify that your app is actually working for a wide range of different users.
So now let me hand it over to Qasid to talk about these APIs.
QASID SADIQ: Hey, everyone.
I'm Qasid.
I'm on the Android Accessibility team.
Let's talk about APIs.
So as Phil mentioned, the way your application communicates what's visible on screen to the accessibility service is the accessibility APIs.
But thankfully for you guys, most of the information that an accessibility service needs can already be inferred through the view hierarchy.
But there are some situations where you guys actually do have to use our APIs.
Thankfully those are minimal.
But let me show you what I mean.
So let's you say you've made this application.
And let's just say you've got this More Options button.
Now, our frameworks can infer important information, like its position on screen and that it's clickable.
The information in view.
java.

여기 아래쪽에 앱이 있습니다.
앱에서해야 할 일은 정보를 Android 프레임 워크에 표시하여 프레임 워크가 다른 모든 서비스와 정보를 공유하여 서로 다른 사용자를 지원할 수 있도록하는 것입니다.
그런 다음 프레임 워크가 다른 모든 서비스, 다른 모든 사용자가 실제로 앱을 제어 할 수 있도록 조치를 취할 수 있어야합니다.
따라서이를 수행 할 수있는 방법은 실제로 Qasid가 논의 할 API를 사용하여 정보를 제시하고 사용자가 조치를 취할 수 있도록하는 것입니다.
그런 다음이 테스트 도구를 사용하여 앱이 실제로 다양한 사용자를 위해 작동하는지 확인할 수 있습니다.
이제 Qasid에게이 API에 대해 이야기하도록하겠습니다.
QASID SADIQ : 안녕하세요.
나는 Qasid입니다.
저는 Android 접근성 팀에 있습니다.
API에 대해 이야기합시다.
Phil이 언급했듯이 응용 프로그램이 화면에 표시되는 내용을 접근성 서비스와 통신하는 방식은 접근성 API입니다.
그러나 고맙게도, 접근성 서비스에 필요한 대부분의 정보는 뷰 계층을 통해 이미 유추 될 수 있습니다.
그러나 실제로 API를 사용해야하는 상황이 있습니다.
고맙게도 그것들은 최소한입니다.
그러나 내가 의미하는 바를 보여 드리겠습니다.
이 응용 프로그램을 만들었다 고 가정 해 봅시다.
이 추가 옵션 버튼이 있다고 가정 해 봅시다.
이제 Google의 프레임 워크는 화면에서의 위치 및 클릭 가능한 정보와 같은 중요한 정보를 유추 할 수 있습니다.
정보가 표시됩니다.
자바.

But when a TalkBack user, a user who may not be able to see the screen places their finger on this item to hear a description of this item, they're not going to get anything.
And the reason is TalkBack really doesn't know what to say in this situation.
There is no descriptive text associated with it.
So you as an app developer have to step in and fill in the blanks for us.
And you can do that through the content description API.
All you do is pass in a localized string into site content description.
Remember, keep the string localized, concise, and descriptive, because someone has to hear it.
A user has to hear it.
When Phil says label your items, he means this, and for good reason, because this is mostly the accessibility issues your application is going to have.
And thankfully, it's trivially simple to fix.
Now our user knows that this is the More Options button, and we have a successful interaction.
So let's talk about something different.
Let's say you've got this email UI.
And like most inbox UIs with a list of emails, you can tap and email to select it.
And you can swipe to reveal that an email was deletable.
And if you continue swiping, you'll delete that email.
This is great and all, but not all users can tap and swipe on screen.
TalkBack users, for example, drive the UI through a completely different gesture set.
Switch Access users, on the other hand, they drive the UI through a series of single switches.
So for these particular situations, the accessibility service, which Access or TalkBack, need to know what actions you can perform on each item or each view in your hierarchy.
Now, when a Switch Access user highlights a certain item as it currently stands, the user only knows that you can tap an item.
And this may be because of the way we implemented that remove action or that delete action.
So again, like content description, we have to fill in the blanks.
And you can do that through our new accessibility actions API.
All you do is call ViewCompat.
addAc cessibilityAction.
You pass in the view of the action, a localized string describing the action concisely to the user, and a Lambda to be performed at the user's request.

그러나 화면을 볼 수없는 음성 안내 지원 사용자가이 항목에 대한 설명을 듣기 위해이 항목에 손가락을 대면 아무 것도 얻지 못합니다.
그 이유는 TalkBack이이 상황에서 무엇을 말해야하는지 모르기 때문입니다.
관련된 설명 텍스트가 없습니다.
따라서 앱 개발자는 우리를 위해 공백을 채우고 채워야합니다.
컨텐츠 설명 API를 통해이를 수행 할 수 있습니다.
현지화 된 문자열을 사이트 콘텐츠 설명에 전달하기 만하면됩니다.
누군가가 문자열을 들어야하므로 문자열을 현지화되고 간결하며 설명이 필요합니다.
사용자는 그것을 들어야합니다.
Phil이 항목에 레이블을 지정하면 이는 의미가 있으며, 그 이유는 대부분 응용 프로그램에서 발생하는 접근성 문제이기 때문입니다.
고맙게도 고치는 것은 간단합니다.
이제 사용자는 이것이 추가 옵션 버튼이라는 것을 알고 있으며 성공적인 상호 작용을합니다.
그래서 다른 것에 대해 이야기합시다.
이 이메일 UI가 있다고 가정 해 봅시다.
이메일 목록이있는 대부분의받은 편지함 UI와 마찬가지로 이메일을 눌러 선택할 수 있습니다.
스 와이프하여 이메일을 삭제할 수 있음을 표시 할 수 있습니다.
그리고 계속 스 와이프하면 해당 이메일이 삭제됩니다.
이는 훌륭하지만 모든 사용자가 화면을 탭하고 스 와이프 할 수있는 것은 아닙니다.
예를 들어 TalkBack 사용자는 완전히 다른 제스처 세트를 통해 UI를 구동합니다.
반면 스위치 액세스 사용자는 일련의 단일 스위치를 통해 UI를 구동합니다.
따라서 이러한 특정 상황의 경우 Access 또는 TalkBack 인 내게 필요한 옵션 서비스는 계층의 각 항목 또는 각보기에서 수행 할 수있는 작업을 알아야합니다.
이제 스위치 액세스 사용자가 현재있는 특정 항목을 강조 표시하면 사용자는 항목을 누를 수 있다는 것만 알 수 있습니다.
그리고 이것은 제거 조치 또는 삭제 조치를 구현 한 방식 때문일 수 있습니다.
콘텐츠 설명과 마찬가지로 다시 빈칸을 채워야합니다.
새로운 접근성 작업 API를 통해이를 수행 할 수 있습니다.
ViewCompat에 전화하면됩니다.
addAc cessibilityAction.
액션 뷰, 액션을 사용자에게 간결하게 설명하는 지역화 된 문자열 및 사용자 요청시 수행 할 Lambda를 전달합니다.

Now our hypothetical Switch user will be able to perform both the select and the delete action.
And also, because this is an AndroidX, the library we use to back part a lot of our API, this is going to work back to API 21.
OK, but let's get into something a little more complicated.
Let's talk about text and links, or clickable spans.
Now, before AndroidO, our accessibility frameworks really couldn't handle non-URL spans well.
And this is a problem, as you can imagine users like TalkBack users, they wouldn't be informed that there are links on screen.
Actually, they wouldn't be even able to activate them.
They would essentially see nothing.
So to solve this problem, we added some API into AndroidX.
All you do for a text view, which contains these non-URL clickable spans is called ViewCompat.
enabl eAccessibleClick ableSpanSupport.
Pass in the text view or the view that contains these spans.
Now our users all the way back to API 19 will know that these links exist and will be able to successfully activate them.
So as app developers, a lot of you like to roll some interesting custom UI.
So this may look like an alert dialog, but for whatever reason we decided to implement this using a view group, a couple of text views and a button.
Now, this poses a problem for accessibility services like TalkBack, because there's some information that's visually expressed about a context change happening on screen.
But that actually hasn't happened.
This behaves a bit like a window.
So our accessibility user isn't informed about this.
So the way you solve this is by treating this view group as an accessibility pane.
And you can do that by calling ViewCompat.
setAc cessibilityPaneTitle on the view that you consider a pane, and you pass in a localized concise string describing this pane to the user.

이제 가상 스위치 사용자가 선택 및 삭제 작업을 모두 수행 할 수 있습니다.
또한 이것은 API의 많은 부분을 뒷받침하기 위해 사용하는 라이브러리 인 AndroidX이므로 API 21로 다시 작동합니다.
좋아,하지만 좀 더 복잡한 것에 들어가 보자.
텍스트와 링크 또는 클릭 가능한 범위에 대해 이야기합시다.
이제 AndroidO 이전에는 접근성 프레임 워크가 URL이 아닌 범위를 제대로 처리 할 수 ​​없었습니다.
TalkBack 사용자와 같은 사용자를 상상할 수 있듯이 화면에 링크가 있다는 메시지가 표시되지 않습니다.
실제로, 그들은 심지어 그것들을 활성화시킬 수 없습니다.
그들은 본질적으로 아무것도 볼 수 없었습니다.
따라서이 문제를 해결하기 위해 일부 API를 AndroidX에 추가했습니다.
URL을 클릭 할 수없는 범위가 포함 된 텍스트보기에 대해서는 ViewCompat이라고합니다.
eAccessibleClickableSpanSupport를 클릭하십시오.
텍스트 범위 또는 이러한 범위를 포함하는보기를 전달하십시오.
이제 API 19로 돌아가는 사용자는 이러한 링크가 존재하고 성공적으로 활성화 할 수 있음을 알게됩니다.
따라서 앱 개발자로서 많은 사용자가 흥미로운 사용자 정의 UI를 구현하는 것을 좋아합니다.
따라서 이것은 경고 대화 상자처럼 보일 수 있지만, 어떤 이유로 든보기 그룹, 몇 개의 텍스트보기 및 단추를 사용하여이를 구현하기로 결정했습니다.
화면에 상황 변화에 대해 시각적으로 표현 된 정보가 있기 때문에 이것은 음성 안내 지원과 같은 접근성 서비스에 문제가됩니다.
그러나 실제로는 일어나지 않았습니다.
이것은 창처럼 작동합니다.
따라서 접근성 사용자에게는 이에 대한 정보가 없습니다.
따라서이를 해결하는 방법은이 뷰 그룹을 접근성 창으로 취급하는 것입니다.
ViewCompat를 호출하여이를 수행 할 수 있습니다.
분할 창을 고려한보기에서 setAc cessibilityPaneTitle을 설정하고이 분할 창을 설명하는 현지화 된 간결한 문자열을 사용자에게 전달합니다.

Now, when our custom alert appears, TalkBack is going to speak, alert.
This also works all the way back to API 19.
And finally, let's say you have a video player in your application.
And it's pretty typical in that has a play button or some controls that time out and disappear after a certain period of time.
That's useful because most users just want to get to your content.
They don't want to fiddle with your controls.
But you can imagine an accessibility user who needs to take time interacting with your controls.
By the time they're able to precisely interact with this play button, disappears.
Now they've got to figure out a way to get that play button back up on screen.
They've got to figure out a way to interact with it before the timeout disappears again.
And this is a pretty frustrating cycle.
So what we ideally need in this situation is a way to adjust our timeout based on our current user's needs.
And you can do that through our new timeouts API.
First you get a reference to the accessibility manager.
Then you call getRecommendedTi meoutMilliseconds.
This returns the suggested timeout for your view.
It's customized for your view and for your user.
It does this by taking the default timeout that you had planned and adjusting it based on the type of content this view is.
You specify this in the second parameter.
In this situation, this is a play button, and it's a control.
So we pass in FLAG_CONTENT_CONTROLS.
You can imagine someone with a motor disability, for example, may need this adjusted if it's a control.
It also presents visual information, so we pass in FLAG_CONTENT_ICONS for people who may have trouble parsing visual information.
If it was text, we pass in FLAG_CONTENT_TEXT for people who have trouble parsing text.
Now we've got a timeout that's customized for our view and for the current user and a play button that works for everybody.
OK.
So those are the fundamentals.
And let's just say you've used those fundamentals to make your application accessible.
You become a bit of an expert.

이제 맞춤 알림이 표시되면 음성 안내 지원에서 음성으로 알려줍니다.
또한 API 19까지 계속 작동합니다.
마지막으로 응용 프로그램에 비디오 플레이어가 있다고 가정 해 봅시다.
재생 버튼이나 일정 시간이 지나면 사라지는 컨트롤이있는 것이 일반적입니다.
대부분의 사용자가 귀하의 콘텐츠를 원하기 때문에 유용합니다.
그들은 당신의 컨트롤을 피하고 싶지 않습니다.
그러나 컨트롤과 상호 작용하는 데 시간이 걸리는 접근성 사용자를 상상할 수 있습니다.
이 재생 버튼과 정확하게 상호 작용할 수있게되면 사라집니다.
이제 재생 버튼을 화면에 다시 표시하는 방법을 찾아야합니다.
타임 아웃이 다시 사라지기 전에 상호 작용하는 방법을 찾아야합니다.
그리고 이것은 꽤 실망스러운주기입니다.
따라서이 상황에서 이상적으로 필요한 것은 현재 사용자의 요구에 따라 시간 초과를 조정하는 방법입니다.
새로운 타임 아웃 API를 통해이를 수행 할 수 있습니다.
먼저 접근성 관리자에 대한 참조를 얻습니다.
그런 다음 getRecommendedTi meoutMilliseconds를 호출하십시오.
뷰에 대한 제안 된 시간 초과가 반환됩니다.
보기 및 사용자에 맞게 사용자 정의되었습니다.
이 작업은 계획 한 기본 시간 초과를 가져 와서이보기의 내용 유형에 따라 조정하여 수행합니다.
두 번째 매개 변수에서이를 지정하십시오.
이 상황에서이 버튼은 재생 버튼이며 컨트롤입니다.
FLAG_CONTENT_CONTROLS에 전달합니다.
예를 들어, 운동 장애가있는 사람이 컨트롤 인 경우이를 조정해야 할 수도 있습니다.
시각적 정보도 제공하므로 시각적 정보를 구문 분석하는 데 문제가있는 사용자를 위해 FLAG_CONTENT_ICONS를 전달합니다.
텍스트 인 경우 텍스트 구문 분석에 문제가있는 사용자를 위해 FLAG_CONTENT_TEXT를 전달합니다.
이제 우리의 시각과 현재 사용자 및 모든 사람에게 적합한 재생 버튼에 맞게 사용자 정의 된 시간 초과가 있습니다.
승인.
이것이 기본입니다.
이러한 기본 사항을 사용하여 애플리케이션에 액세스 할 수 있다고 가정 해 봅시다.
당신은 약간의 전문가가됩니다.

But you are going to really quickly discover there are some murky areas, places where it's not clear what the right thing to do is.
Let's get back to this email UI.
Now, let's just say you're trying to build very specifically for the TalkBack user, the user that can't see on screen.
You try to determine what the experience is going to be when a new email appears.
And you're trying to figure out how to express this change, and you figure the best thing you can do is by making an announcement.
Every time a new email appears, announce the email.
Well, this is a bad idea.
And if you catch yourself using the accessibility event TYPE_ANNOUNCEMENT, you're probably conforming to this anti-pattern.
You see, changes in the UI are expressed very differently, depending on the accessibility service and the user's preferences.
Services don't need fine tuning of accessibility UI from the application.
They need a generic representation of the UI that they themselves can manipulate for the users that they understand so well.
So what do you do in this situation? This is what you do.
That's right.
You don't do anything.
And you can do this by using the widgets we provide to you in our frameworks, such as AndroidX and Material.
These widgets come with accessibility built in out of the box, which significantly reduce the amount of work you as an app developer have to do.
So you can really focus on the very particular value that your application provides to the world.
But if you really must write your own custom widgets, if you really must do it yourself, make sure you're communicating the exact semantics of the changes in your UI by using the correct accessibility events and populating it correctly.
Remember, in this situation, you're not communicating directly with the user.
You're communicating with the accessibility service.
So something similar that people like to do is manage accessibility focus themselves.
And again, this is a bad idea.
Accessibility focus has to be determined by the accessibility service.
And just like announcements, this creates an inconsistency in experience.
And actually, that's one of the biggest issues that accessibility users face, inconsistency across applications and over time.
You see, there are a lot of applications.
And if you as an app developer decide to break with the paradigms of accessibility interaction from the rest of the system, you're making your users' lives frustrating, because now that accessibility user, every time they open your application, they've got to throw out all of their expectations in terms of how their interaction works.
And they've got to relearn this whole new UI at a very fundamental level.
The best thing that you can do for your accessibility user is to maintain consistency over time and with a system.
OK, now that you know how to fix your issues, Isha's going to talk about how to find them and how to make sure you fix them.
ISHA BOBRA: Thanks, Qasid.
Hello, everyone.

그러나 당신은 어떤 어두운 영역, 올바른 일이 무엇인지 명확하지 않은 곳이 있다는 것을 정말로 빨리 알게 될 것입니다.
이 이메일 UI로 돌아 갑시다.
화면에서 볼 수없는 음성 안내 지원 사용자를 위해 특별히 제작하려고한다고 가정 해 보겠습니다.
새 이메일이 나타날 때 어떤 경험이 될지 결정하려고합니다.
그리고 당신은이 변화를 표현하는 방법을 찾으려고 노력하고 있으며, 당신이 할 수있는 가장 좋은 일은 발표를하는 것입니다.
새 이메일이 나타날 때마다 이메일을 알리십시오.
글쎄, 이것은 나쁜 생각입니다.
접근성 이벤트 TYPE_ANNOUNCEMENT를 사용하여 자신을 발견하면 아마도이 안티 패턴을 따르는 것입니다.
UI의 변경 사항은 내게 필요한 옵션 서비스 및 사용자 기본 설정에 따라 매우 다르게 표현됩니다.
서비스는 응용 프로그램에서 접근성 UI를 미세 조정할 필요가 없습니다.
이해하기 쉬운 사용자를 위해 스스로 조작 할 수있는 일반적인 UI 표현이 필요합니다.
이 상황에서 무엇을하십니까? 이것이 당신이하는 일입니다.
맞습니다.
당신은 아무것도하지 않습니다.
AndroidX 및 Material과 같은 프레임 워크에서 제공하는 위젯을 사용하여이를 수행 할 수 있습니다.
이 위젯에는 기본 제공되는 접근성이 내장되어있어 앱 개발자가해야 할 작업량을 크게 줄일 수 있습니다.
따라서 애플리케이션이 세계에 제공하는 매우 특별한 가치에 집중할 수 있습니다.
그러나 실제로 사용자 정의 위젯을 작성해야하는 경우 직접 작성해야하는 경우 올바른 내게 필요한 옵션 이벤트를 사용하고 올바르게 채워서 UI 변경 사항의 정확한 의미를 전달하고 있는지 확인하십시오.
이 상황에서는 사용자와 직접 통신하지 않습니다.
접근성 서비스와 통신하고 있습니다.
따라서 사람들이 좋아하는 것과 비슷한 것은 접근성 포커스 자체를 관리하는 것입니다.
그리고 다시, 이것은 나쁜 생각입니다.
내게 필요한 옵션은 내게 필요한 옵션 서비스에 의해 결정되어야합니다.
발표와 마찬가지로 경험에 일관성이 없습니다.
실제로, 이는 접근성 사용자가 직면 한 가장 큰 문제 중 하나이며, 응용 프로그램간에 시간이 지남에 따라 일관성이 없습니다.
알다시피, 많은 응용 프로그램이 있습니다.
그리고 앱 개발자가 나머지 시스템과의 접근성 상호 작용 패러다임을 극복하기로 결정하면 사용자의 삶이 좌절됩니다. 이제 내게 필요한 접근성 사용자는 응용 프로그램을 열 때마다 그들의 상호 작용이 어떻게 작동하는지에 대한 모든 기대를 버립니다.
그리고이 완전히 새로운 UI를 매우 근본적인 수준으로 다시 배워야합니다.
내게 필요한 옵션 사용자를 위해 할 수있는 최선의 방법은 시간이 지남에 따라 시스템과 일관성을 유지하는 것입니다.
이제 문제를 해결하는 방법을 알게되었으므로 Isha는 문제를 찾는 방법과 문제를 해결하는 방법에 대해 이야기 할 것입니다.
ISHA BOBRA : 감사합니다. Qasid.
여러분 안녕하세요.

So now that we know what we are building for and how to build it, the next obvious question is, how do I know what I built is correct?
Things like, is my text visible to most of the users? Or is my button large enough, or even if my button is labeled or not? Wouldn't it be nice if someone could check that for us? 
Well, there are several approaches in which you can answer this question and make the testing task easy.
On a high level, there are three approaches that you can leverage as a developer to ensure you're creating an accessible experience for most of your users.
The first is automated tests.
This technique requires some coding changes and is very good to detect accessibility issues at the very early developmental phases.
You can run these tests alongside your existing UI unit or integration test as part of resubmit or continuous integration solution.
The next tool we're going to look at is the accessibility testing tools.
These tools do not require any technical knowledge and can be run by QA teams and release managers to perform a sanity check before your app is released out in public.
And the third is a manual testing, which, by experience, we have realized is one of the most effective ways to ensure you're creating an end to end experience for users with disabilities in real world scenarios.
Let's take a deep dive into the three techniques.
Let's first talk about integrating accessibility into your existing testing code.
Most of the Android Accessibility testing tools are backed by the Android Accessibility Testing Framework.
It is a Java library that is written on a rule-based system to evaluate Android UI constructs for accessibility issues at runtime.
Remember, it's open source.
So if you wish to make contributions and add checks for accessibility, please reach out to us on GitHub.
So what does this framework test for? It tests for missing labels, which actually prevents users of screen readers from understanding the content within your app.
It looks for small touch targets, which can prevent users with dexterity issues to interact with your app.
It also looks for low contrast text and images, which impacts the legibility of your app, and it looks for other implementation-specific issues, which can actually prevent your app from sending the proper semantics to the Android Accessibility Framework.
So that was about the framework, and we understood what the framework tests for.
The question is, how do I use this framework? So we've made it really easy to integrate this Accessibility Testing Framework into the existing testing frameworks like Espresso and Robolectric.
These are provided as an optional competent, and you can use our existing test code to run these checks.
As you interact with the view in your tests, these accessibility checks run automatically before proceeding.
So if you're interacting with a button in your test, we look for the button and potentially the UI around the button to look for accessibility issues.

이제 우리가 무엇을 만들고 있는지 그리고 그것을 어떻게 구축하는지 알았으므로, 다음으로 분명한 질문은, 내가 만든 것이 올바른지 어떻게 알 수 있습니까?
내 텍스트가 대부분의 사용자에게 표시됩니까? 또는 내 버튼이 충분히 크거나 내 버튼에 라벨이 붙어 있더라도 말입니까? 누군가 우리를 위해 그것을 확인할 수 있다면 좋지 않을까요?
이 질문에 대답하고 테스트 작업을 쉽게 수행 할 수있는 몇 가지 방법이 있습니다.
높은 수준에서 개발자로서 활용하여 대부분의 사용자가 액세스 할 수있는 환경을 만들 수있는 세 가지 방법이 있습니다.
첫 번째는 자동화 된 테스트입니다.
이 기술은 약간의 코딩 변경이 필요하며 초기 개발 단계에서 접근성 문제를 감지하는 데 매우 좋습니다.
다시 제출 또는 지속적인 통합 솔루션의 일부로 기존 UI 단위 또는 통합 테스트와 함께 이러한 테스트를 실행할 수 있습니다.
다음으로 살펴볼 도구는 내게 필요한 옵션 테스트 도구입니다.
이 도구는 기술 지식이 필요하지 않으며 QA 팀과 릴리스 관리자가 앱을 공개적으로 공개하기 전에 상태 확인을 수행하기 위해 실행할 수 있습니다.
세 번째는 경험에 따라 실제 시나리오에서 장애가있는 사용자에게 엔드 투 엔드 경험을 제공 할 수있는 가장 효과적인 방법 중 하나 인 수동 테스트입니다.
세 가지 기술에 대해 자세히 알아 보겠습니다.
먼저 접근성을 기존 테스트 코드에 통합하는 방법에 대해 이야기하겠습니다.
대부분의 Android 접근성 테스트 도구는 Android 접근성 테스트 프레임 워크에서 지원합니다.
런타임에 접근성 문제에 대한 Android UI 구성을 평가하기 위해 규칙 기반 시스템에서 작성된 Java 라이브러리입니다.
오픈 소스라는 것을 기억하십시오.
당신이 기여를하고 접근성에 대한 점검을 추가하고 싶다면 GitHub에서 우리에게 연락하십시오.
이 프레임 워크는 무엇을 테스트합니까? 레이블이 없는지 테스트하여 실제로 화면 판독기 사용자가 앱 내의 콘텐츠를 이해하지 못하게합니다.
작은 터치 대상을 찾아 손재주 문제가있는 사용자가 앱과 상호 작용하지 못하게 할 수 있습니다.
또한 명암비가 낮은 텍스트와 이미지를 찾아 앱의 가독성에 영향을 미치고 다른 구현 관련 문제를 찾아 앱이 실제로 의미를 Android 접근성 프레임 워크로 전송하지 못하게 할 수 있습니다.
이것이 프레임 워크에 관한 것이었고 우리는 프레임 워크가 무엇을 테스트하는지 이해했습니다.
문제는이 프레임 워크를 어떻게 사용합니까? 따라서이 접근성 테스트 프레임 워크를 Espresso 및 Robolectric과 같은 기존 테스트 프레임 워크에 쉽게 통합 할 수있게되었습니다.
이 옵션은 선택 사항으로 제공되며 기존 테스트 코드를 사용하여 이러한 검사를 실행할 수 있습니다.
테스트에서 뷰와 상호 작용할 때 이러한 접근성 검사는 계속하기 전에 자동으로 실행됩니다.
따라서 테스트에서 버튼과 상호 작용하는 경우 버튼 및 버튼 주위의 UI를 통해 접근성 문제를 찾습니다.

For Espresso, you can use AccessibilityChecks.
enable to enable the tests.
The result of AccessibilityChecks.
enable is an accessibility validator, which can be used to customize your tests.
For example, you can use .
setRunChecksfroomRootView to increase the coverage of your tests by running them onto the on the entire view hierarchy where a view actions is performed.
You can also call .
setSupressingResultMatcher to whitelist known accessibility issues so that your tests are green as you fix them.
It is required that you use a view action from the view actions class to perform these tests.
In this example, you see the use of click action.
Remember, if you interact with the view directly, you bypass the accessibility checks.
For Robolectric, you use AddAccessibilityChecks annotation to enable the tests.
Tests will be called in the view when you call ShadowView.
clickOn the view you want to test.
And much like Espresso, you can customize your tests using Robolectric's accessibility tools.
So that was all about automated tests, making changes in your code, and figuring out accessibility issues at the very, very early development phases.
Next, we're going to look at is using the accessibility testing tools.
These are automated tools and do not require any technical knowledge.
The first we're going to talk about is the Google Play Pre-Launch Report.
It is an automated tool that controls your app on multiple physical devices and looks for accessibility issues so that you can fix them before launching your app.
It looks for issues like crashes, performance, and now even accessibility.
We've made it really easy to get accessibility test results by integrating those directly into its developer console.
These checks run on all APKs released on any Play Store track.
Pre-Launch Report is located within the Google Play Console beneath Release Management.
You can see here's a list of issues that are highlighted by the Pre-Launch Report.
These issues are clustered, characterized, and ranked by severity.
Here's a detailed view of how a report looks like generated by the Pre-Launch Report.
You can see the text with the incorrect contrast ratios highlighted and a suggestion is provided to improve it.
On the left-hand side panel, you can see the occurrences of the similar underlining issues being highlighted.
For each of the accessibility findings identified by the report, there is a Learn More link, which gives you a detailed understanding of the concept and provides suggestions to improve it.

Espresso의 경우 접근성 검사를 사용할 수 있습니다.
테스트를 활성화합니다.
접근성 검사 결과.
enable은 테스트를 사용자 정의하는 데 사용할 수있는 접근성 검사기입니다.
예를 들어을 사용할 수 있습니다.
setRunChecksfroomRootView는보기 조치가 수행되는 전체보기 계층 구조에서 테스트를 실행하여 테스트 범위를 증가시킵니다.
전화를 걸 수도 있습니다.
알려진 접근성 문제를 화이트리스트로 설정하여 테스트 할 때 문제가 해결되도록 setSupressingResultMatcher를 설정하십시오.
이러한 테스트를 수행하려면보기 조치 클래스의보기 조치를 사용해야합니다.
이 예에서는 클릭 동작이 사용됩니다.
뷰와 직접 상호 작용하는 경우 접근성 검사를 무시합니다.
Robolectric의 경우 AddAccessibilityChecks 주석을 사용하여 테스트를 활성화합니다.
ShadowView를 호출하면보기에서 테스트가 호출됩니다.
테스트하려는보기를 클릭하십시오.
Espresso와 마찬가지로 Robolectric의 접근성 도구를 사용하여 테스트를 사용자 정의 할 수 있습니다.
초기 단계에서 자동화 된 테스트, 코드 변경, 접근성 문제 파악 등이 전부였습니다.
다음으로 접근성 테스트 도구를 사용하겠습니다.
이들은 자동화 된 도구이며 기술 지식이 필요하지 않습니다.
가장 먼저 이야기 할 것은 Google Play 사전 출시 보고서입니다.
이 도구는 여러 물리적 장치에서 앱을 제어하고 접근성 문제를 찾아서 앱을 시작하기 전에 해결할 수있는 자동화 된 도구입니다.
충돌, 성능 및 접근성 같은 문제를 찾습니다.
우리는 개발자 콘솔에 직접 통합하여 접근성 테스트 결과를 쉽게 얻을 수 있도록했습니다.
이 확인은 모든 Play Store 트랙에서 출시 된 모든 APK에서 실행됩니다.
출시 전 보고서는 출시 관리 아래의 Google Play 콘솔에 있습니다.
사전 실행 보고서에서 강조 표시된 문제 목록은 다음과 같습니다.
이러한 문제는 심각도별로 분류되고 특성화되며 순위가 결정됩니다.
다음은 사전 실행 보고서에서 생성 된 보고서의 모양에 대한 자세한보기입니다.
대비 비율이 잘못된 텍스트가 강조 표시되어 개선을위한 제안이 제공됩니다.
왼쪽 패널에서 강조 표시된 유사한 밑줄 문제가 나타나는 것을 볼 수 있습니다.
보고서에 의해 식별 된 각각의 접근성 결과마다 개념에 대한 자세한 이해를 제공하고 개념을 개선하기위한 제안을 제공하는 추가 정보 링크가 있습니다.

Yeah, that was about the Google Play Pre-Launch Report.
Now we're going to move on to the Accessibility Scanner.
It's another app that scans your UI and looks for potential accessibility issues, like missing labels, small touch targets, et cetera.
You do not require any code change to use Accessibility Scanner.
All you need to do is go to the Play Store, download the app, or visit g.
co/accessibilityscanner.
Launching the app will take you through the set-up process.
Here's an app that we've created to highlight some of the known accessibility issues.
You can see a blue floating button on the UI.
This is the button that appears when you switch on Accessibility Scanner.
In order to scan my app, I would simply tap on the blue button while my app's UI is in the foreground.
Here is an example of how a report created by Accessibility Scanner looks like.
You can see the text with incorrect ratios highlighted.
It's not just highlighted, but also a suggestion to improve it is provided.
You can share the reports by scanner via email or Google Drive.
And if you click on the Learn More link, it opens a detailed documentation of the concept and the issue you're looking at.
So that was about the automated tools.
We looked at the automated tests, which required coding changes and are good to detect issues while you're developing.
Next we looked at the automated testing tools, which were the Pre-Launch Report and the Accessibility Scanner.
The third technique we're going to look at is manual testing.
So automation is really helpful, because it helps you detect issues while you're developing, but it's not a complete solution as it comes with certain limitations.
Let's look at them.
If you're depending on your automated tests, and they're based on the test that you've already written for your code, its performance very much depends on the coverage that your test code provides.
Parts of your code that are not tested can have serious accessibility issues.
Secondly, like any other automation, there are always chances of false positives and false negatives.
We strive to reduce false positives as much as we can, but that can result in neglecting some of the legitimate accessibility issues.
And thirdly, there are certain issues that require human judgment and intervention.
For example, our tools can tell you that you're missing a label, but whether or not the label string is making sense to the user is understandable and acceptable is something that only humans can decide.
So manual testing is all about understanding your users and understanding how they're going to interact with your app using assistive technology.

예, Google Play 사전 출시 보고서에 관한 것이 었습니다.
이제 접근성 검사기로 넘어갑니다.
UI를 스캔하고 레이블 누락, 작은 터치 대상 등과 같은 잠재적 접근성 문제를 찾는 또 다른 앱입니다.
내게 필요한 옵션 스캐너를 사용하기 위해 코드를 변경할 필요는 없습니다.
Play 스토어로 이동하거나 앱을 다운로드하거나 g를 방문하기 만하면됩니다.
공동 / 접근성 스캐너.
앱을 시작하면 설정 과정이 진행됩니다.
다음은 알려진 접근성 문제 중 일부를 강조하기 위해 만든 앱입니다.
UI에서 파란색 부동 버튼을 볼 수 있습니다.
내게 필요한 옵션 스캐너를 켤 때 나타나는 버튼입니다.
앱을 스캔하려면 앱 UI가 포 그라운드에있는 동안 파란색 버튼을 누르기 만하면됩니다.
다음은 액세서 빌 러티 스캐너에서 작성된 보고서의 모습에 대한 예입니다.
잘못된 비율로 강조 표시된 텍스트를 볼 수 있습니다.
강조 될뿐만 아니라 개선을위한 제안도 제공됩니다.
이메일 또는 Google 드라이브를 통해 스캐너로 보고서를 공유 할 수 있습니다.
자세히 알아보기 링크를 클릭하면 개념 및보고있는 문제에 대한 자세한 문서가 열립니다.
그것은 자동화 된 도구에 관한 것입니다.
코딩 변경이 필요하고 개발하는 동안 문제를 감지하기에 적합한 자동 테스트를 살펴 보았습니다.
다음으로 Pre-Launch Report와 Accessibility Scanner 인 자동화 된 테스트 도구를 살펴 보았습니다.
우리가 살펴볼 세 번째 기술은 수동 테스트입니다.
따라서 자동화는 개발하는 동안 문제를 감지하는 데 도움이되기 때문에 실제로 유용하지만 특정 제한 사항이 있으므로 완벽한 솔루션은 아닙니다.
그들을 보자.
자동화 된 테스트에 의존하고 이미 코드에 대해 작성한 테스트를 기반으로하는 경우 테스트 코드가 제공하는 적용 범위에 따라 성능이 크게 좌우됩니다.
테스트되지 않은 코드 부분에는 심각한 접근성 문제가있을 수 있습니다.
둘째, 다른 자동화와 마찬가지로 항상 오 탐지 및 오 탐지 가능성이 있습니다.
우리는 가능한 한 오 탐지를 줄이기 위해 노력하지만 합법적 인 접근성 문제를 무시할 수 있습니다.
셋째, 인간의 판단과 개입이 필요한 특정 문제가 있습니다.
예를 들어 Google 도구를 사용하면 라벨이 누락되었음을 알 수 있지만 라벨 문자열이 사용자에게 이해가되는지 이해할 수 있고 수용 가능한지 여부는 사람 만 결정할 수 있습니다.
따라서 수동 테스트는 보조 기술을 사용하여 사용자를 이해하고 앱과 상호 작용하는 방법을 이해하는 것입니다.

One way to achieve this is working directly with these users with accessibility needs and soliciting their feedback.
It can be done formally or informally.
Another way to achieve this is using Android's own Accessibility Services.
So testing your app with TalkBack can actually ensure that you're providing the correct semantics to the Android Accessibility Framework.
And testing your app with Switch Access can ensure that your app is reacting well to the actions initiated by these APIs.
At Google, we've learned that the most successful teams are those who adopt both automated and manual testing in their development process.
If you want to learn more about using Android's Accessibility Services, please visit g.
co/androidaccessibility.
And it can also take you through step-by-step approach to testing with keeping accessibility in mind.
And with that, I will let Phil come up and give some key takeaways.
Thank you.
PHIL WEAVER: Thank you, Isha.
So hopefully you found this information useful.
But as you work on your app, really what we're asking is for you to help us help others use your app and help other accessibility service developers help others use your app.
So we've presented a few APIs here.
We hope you'll use them to share UI with as many people as possible.
If you've played around with accessibility before, you're maybe wondering like why are we not showing you-- we could have gone through the details of accessibility node info and accessibility event.
And our goal is really to try to limit the number of people who ever need to crack that API surface open.
This new API for adding actions I think is really important in that respect, because it used to be, if you were doing something relatively minor, overwriting the touch handler, it was like, OK, you did the small change, and now you've got a crack open this great big API surface and figure out how to modify your accessibility node info.
We have an accessibility action API you needed to add.
You needed to go through and override a method in view.
And a lot of people, they kind of come up against a learning curve, they're like, you know, I'm kind of OK with my touch handler just kind of being like that, and I feel bad about not having it be accessible, but I just don't have the time.
And so we're hoping that these APIs reduce that energy barrier to one line of code that's pretty straightforward.
And so we hope that you'll use them.
Similarly, testing for accessibility, there's all different ways to do it.
We all hope that you'll go out and find a wide range of users and test for accessibility with all of those users.
And I know some of you will.

이를 달성하기위한 한 가지 방법은 접근성 요구 사항이있는 사용자와 직접 작업하고 피드백을 요청하는 것입니다.
공식적으로나 비공식적으로 할 수 있습니다.
이를 달성하는 또 다른 방법은 Android 자체 접근성 서비스를 사용하는 것입니다.
따라서 음성 안내 지원으로 앱을 테스트하면 실제로 Android 접근성 프레임 워크에 올바른 의미를 제공 할 수 있습니다.
또한 Switch Access로 앱을 테스트하면 앱이 이러한 API에 의해 시작된 작업에 잘 반응하고 있는지 확인할 수 있습니다.
Google에서 가장 성공적인 팀은 개발 과정에서 자동화 및 수동 테스트를 모두 채택한 팀이라는 것을 알게되었습니다.
Android 접근성 서비스 사용에 대한 자세한 내용을 보려면 g를 방문하십시오.
co / androidaccessibility.
또한 액세스 가능성을 염두에두고 테스트에 대한 단계별 접근 방식을 안내 할 수도 있습니다.
그걸로 Phil이 일어나서 몇 가지 중요한 조치를 취할 것입니다.
감사합니다.
필 위버 : 감사합니다, 이샤.
이 정보가 도움이 되길 바랍니다.
하지만 앱에서 작업 할 때 실제로 요청하는 것은 다른 사람이 앱을 사용하도록 도와주고 다른 접근성 서비스 개발자가 다른 사람이 앱을 사용하도록 도와주는 것입니다.
여기에 몇 가지 API를 제시했습니다.
UI를 사용하여 가능한 많은 사람들과 UI를 공유하기를 바랍니다.
접근성을 가지고 놀아 본 적이 있다면 왜 우리가 보여주지 않는지 궁금 할 것입니다. 접근성 노드 정보 및 접근성 이벤트에 대한 세부 정보를 살펴볼 수 있습니다.
그리고 우리의 목표는 실제로 API 표면을 열어야하는 사람들의 수를 제한하는 것입니다.
내가 생각하기에 액션을 추가하기위한이 새로운 API는 상대적으로 사소한 일을했을 때 터치 핸들러를 덮어 쓰는 것과 같았 기 때문에 작은 변화를 겪었으므로 이제는 이 큰 API 표면을 열면 접근성 노드 정보를 수정하는 방법을 알아낼 수 있습니다.
추가해야 할 접근성 작업 API가 있습니다.
보기에서 메소드를 검토하고 대체해야했습니다.
많은 사람들이 학습 곡선에 맞서고 있습니다. 마치 터치 핸들러 만 있으면 괜찮아요. 접근 할 수 있지만 시간이 없습니다.
그리고 우리는 이러한 API가 에너지 장벽을 한 줄의 코드로 줄여 줄 것으로 기대하고 있습니다.
그래서 우리는 당신이 그것들을 사용할 수 있기를 바랍니다.
마찬가지로 접근성을 테스트하는 방법에는 여러 가지가 있습니다.
우리는 여러분이 다양한 사용자를 찾아 모든 사용자와의 접근성을 테스트하기를 희망합니다.
그리고 나는 당신의 일부를 알고 있습니다.

But again, we're trying to scale this to the entire ecosystem.
And so that's why we've got these different points where, if we want to just a quick scan, we've got Accessibility Scanner.
We've got something-- after you've uploaded to the Play Store, you can get a quick check for accessibility.
But the more you do, the better the experience will be overall.
And also, as you go through and you do this testing, and you find weird problems, and then you start thinking, I know Qasid said don't do this, don't add announcements, don't try to control focus, but it's just broken.
The only way to make my app better is by just tweaking it a little bit.
You find yourself sort of digging through maybe the TalkBack source code, which is online, to try to figure out what TalkBack is doing and like, OK, how do I sort of give it the right signals that it will do the right thing? Please realize that you probably found a bug, and it's probably our bug.
And we're eventually going to fix that bug, hopefully.
We'll fix it a lot faster if you tell us about it.
So if you find yourself doing engineering-- and realize, if you're doing engineering for accessibility, you're doing a lot more than the average developer.
And we need this ecosystem to work for every developer in order for it to work for every user.
So if you find yourself doing engineering, and you realize no one else in the world is ever going to do this, as Qasid said, you end up building something that's inconsistent with the rest of the platform, even if it's better.
And so if you found something like that, please tell us.
We're monitoring the AOSP issue tracker.
We monitor Stack Overflow.

그러나 우리는 이것을 전체 생태계로 확장하려고 노력하고 있습니다.
따라서 빠른 스캔을 원한다면 접근성 스캐너를 사용하는 여러 가지 점이 있습니다.
Play 스토어에 업로드 한 후 접근성을 빠르게 확인할 수 있습니다.
그러나 더 많이할수록 전반적인 경험이 향상됩니다.
또한 테스트를 수행하고 이상한 문제를 발견하고 생각하기 시작하면 Qasid는 이것을하지 말고 공지 사항을 추가하지 말고 초점을 제어하려고 시도하지 말라고 알고 있습니다. 방금 고장났어
내 앱을 더 좋게 만드는 유일한 방법은 조금만 조정하면됩니다.
온라인 상태 인 TalkBack 소스 코드를 통해 TalkBack이 무엇을하고 있는지 알아 내려고 노력하고 있습니다. 알았어요. 올바른 일을하겠다는 올바른 신호를 어떻게 제공합니까? 버그를 발견했을 가능성이 있으며, 아마도 버그 일 것입니다.
그리고 우리는 결국 그 버그를 고칠 것입니다.
알려 주시면 더 빨리 해결하겠습니다.
엔지니어링을하고 있고 접근성을 위해 엔지니어링을하고 있다면 평범한 개발자보다 훨씬 더 많은 일을하고 있다는 사실을 깨닫게됩니다.
또한 모든 사용자가 작업 할 수 있도록 모든 개발자를 위해이 에코 시스템이 필요합니다.
Qasid가 말했듯이 엔지니어링을 수행하고 있고 세계 어느 누구도이 작업을 수행하지 않을 것이라는 사실을 알게되면 더 나은 플랫폼이라해도 나머지 플랫폼과 일치하지 않는 무언가를 만들게됩니다.
그런 것을 발견하면 알려주십시오.
AOSP 이슈 트래커를 모니터링하고 있습니다.
스택 오버플로를 모니터링합니다.

Reach out to us if you're stuck or you're just doing something that's way harder than it should be, because that's the only way that-- that's the best way we can get feedback, and prioritize our own work, and really scale the-- actually, you can submit AOSP-- also, if you want to submit a code patch to AOSP if you found a bug in the framework, I'd very much appreciate that, too.
But if we do the engineering, it can scale through the entire ecosystem.
And so if you've got the extra cycles to do that much, to think about it that deeply, please do think about at the level of like, how could this thing that I've figured out work for everyone? And figure out how to upstream it and reach out to us.
So I started with three things.
I'll finish with the three things, just making information visible, prefer simple, big controls, label images precisely and concisely.
We're doing app reviews and office hours.
And it was striking yesterday as people were coming out, found that most of what we're saying is essentially in these three categories, that, really, if everybody does these three things, we're going to be a lot of the way there.
Speaking of that, we've got accessibility office hours and app reviews that are happening over back that way.
We've got an Accessibility Sandbox, which is, again, just outside on the other side here, that's ongoing through all of I/O.
And so if you've got questions to ask us, we'll also be outside.
You can come find us after the talk.
And if you want to just explore the world of accessibility, we've got a Sandbox for you.
So with that, thank you so much for coming, and thank you for your interest in accessibility.

당신이 갇혀 있거나해야 할 것보다 어려운 일을한다면 우리에게 연락하십시오. 그것이 유일한 방법이기 때문입니다. 이것이 우리가 피드백을 받고, 우리 자신의 작업에 우선 순위를 부여하고, 실제로 확장 할 수있는 가장 좋은 방법입니다. 프레임 워크에서 버그를 발견 한 경우 AOSP에 코드 패치를 제출하려는 경우에도 매우 감사합니다.
그러나 엔지니어링을 수행하면 전체 생태계를 통해 확장 할 수 있습니다.
그래서 당신이 그렇게 많이 할 여분의 사이클이 있다면, 그것에 대해 깊이 생각하기 위해, 같은 수준에서 생각하십시오. 어떻게 내가 알아 낸이 일이 모든 사람을 위해 일할 수 있었습니까? 그것을 업스트림하고 우리에게 다가가는 방법을 알아 내십시오.
그래서 세 가지로 시작했습니다.
정보를 표시하고, 단순하고 큰 컨트롤을 선호하며, 이미지에 정확하고 간결하게 레이블을 지정하는 세 가지 작업으로 마무리하겠습니다.
우리는 앱 리뷰와 근무 시간을하고 있습니다.
어제 사람들이 나올 때 눈에 띄었습니다. 우리가 말하고있는 대부분이 본질적으로이 세 가지 범주에 속한다는 것을 알았습니다. 실제로 모든 사람이이 세 가지 일을한다면 우리는 많은 길을 갈 것입니다. .
말하자면, 우리는 그런 식으로 다시 발생하는 접근성 근무 시간과 앱 리뷰를 가지고 있습니다.
우리는 접근성 샌드 박스를 가지고 있습니다. 다시 한 번, 여기 반대편에있는 모든 I / O를 통해 진행되고 있습니다.
질문이 있으시면 외부에있을 것입니다.
당신은 대화 후 우리를 찾을 수 있습니다.
접근성의 세계를 탐험하고 싶다면 샌드 박스가 있습니다.
그래서와 주셔서 감사하고 접근성에 관심을 가져 주셔서 감사합니다.