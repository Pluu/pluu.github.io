---
layout: post
title: "[번역] AndroidStudio의 Postfix Completion로 고속 코딩"
date: 2015-05-24 16:00:00
tag: [Android, AndroidStudio, TODO]
categories:
- blog
- Android-Studio
---

이 포스팅은 [AndroidStudioのPostfix Completionで爆速コーディング](http://qiita.com/takahirom/items/ac1d1b08351610dfcc43) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

AndroidStudio의 기본이 되고있는 IntelliJ Idea에는 Postfix Completion라는 기능이 있습니다.

예를들변 변수.par를 입력해서 Enter를 누르면 (변수)라는 괄호로 씌어줍니다.

이것을 이용해서 고속 코딩을 해봅시다.

###.var

- - -

`testInstance.var`로

`Test test = testInstance;`
`
같이 대입해서 로컬 변수로 할 수 있습니다.

평소같이 대입해서도 사용가능하지만, 이것은 1행이 길어졌을때에 변수에 대입해서 알기쉽게 할수 있습니다.

{% highlight java %}
Toast.makeText(context, context.getString(R.string.app_name), Toast.LENGTH_SHORT).show();
{% endhighlight %}

↓

{% highlight java %}
final String name = context.getString(R.string.app_name);
Toast.makeText(context, name, Toast.LENGTH_SHORT).show();
{% endhighlight %}

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/6db3c5b5-fa40-5f90-bf59-0895c6dc16ad.gif" />

###.field

- - -

멤버 변수에 대입해준다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/7e33ea47-bd34-960a-fbe7-832ba2a4aa28.gif" />

###.notnull (.nn도 가능)

- - -

NULL 체크의 if문을 만들어준다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/1ef1ef4b-13d0-0fa8-978b-60c060c9d285.gif" />

###.for

- - -

List의 인스턴스로부터 for문을 만들어준다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/44230cce-0c54-55a0-7040-55a1f8484bf8.gif" />

이외에도 여러가지 Postfix Completion이 있으므로 써보세요! (설정으로부터 확인가능합니다.)

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/1c5fd4ba-e462-7acf-4cc1-4b18c6584ce2.png" />

###Android특화 Postfix Completion

- - -

표준에는 `"test".log`로 `Log.d(TAG,"test");`등은 지원되지않습니다.

그러므로 "Android Postfix Completion"라는 플러그인이 Release 했습니다.

AndroidStudio에서 Preferences -> Plugins -> Browse repositories에서 "Android Postfix Completion"라고 검색해서 인스톨할 수 있습니다.

<img class="img-responsive" src="https://qiita-image-store.s3.amazonaws.com/0/27388/f2491c4a-d5dc-e196-ec7e-8948e830e6d1.gif" />

| Postfix Expression | Description | Example |
| -------------------| ----------- | ------- |
| .toast | Toast 표시 | Toast.makeText(context, expr, Toast.LENGTH_SHORT).show() |
| .log | メンバ변수에 "TAG"가 있다면 그걸이용하고, 없다면 Class명을 TAG로해서 이용해 Logging한다 | Log.d(TAG, expr) |
| .logd | .log에 if (BuildConfig.DEBUG)를 추가한것 | if (BuildConfig.DEBUG) Log.d(TAG, expr) |

[https://github.com/takahirom/android-postfix-plugin](https://github.com/takahirom/android-postfix-plugin)

현재 아직까지 보완가능한 수가 많지않으므로, 이런 보완을 원하시다면 Pull Request나 issue로 등록해주시면 감사하겠습니다.
