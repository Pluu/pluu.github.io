---
layout: post
title: "Flip Clock 구현방법"
date: 2010-09-08 23:14:00
tag: [Android, Flip Clock, TODO]
categories:
- blog
- Android
---

안드로이드나 아이폰 시계관련 어플을 보다보면 종종 Flip Clock가 나옵니다.

그래서 한번 구현해봤습니다.

<!--more-->


먼저 가장 필요한것은 이미지입니다.

종이가 넘어가는 듯한 느낌을 보면 화려해서 구현하기 힘들것이라고 생각하시겠지만,

실제로 눈에 보이는것은 이미지가 계속 바뀌는 것뿐입니다. 눈의 착각입니다.

- - -

### 이미지 작업중

- - -

이미지는 위와 같습니다. 넘어가는 순간순간이 다 이미지로 되어있습니다.

그리고, ViewFlipper라는 컴포넌트를 사용합니다.

ViewFlipper 안에 필요한 이미지 수만큼 ImageView를 추가합니다.


{% highlight Java linenos %}
private ViewFlipper viewFlipper;
private final int DELAY_TIME = 50;

@Override
public void onCreate(Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   setContentView(R.layout.main);

   viewFlipper = (ViewFlipper) findViewById(R.id.ViewFlipper01);
   viewFlipper.setOnClickListener(new OnClickListener() {
      public void onClick(View arg0) {
         for(int i=1; i<=7; i++) {
            handler.sendEmptyMessageDelayed(0, DELAY_TIME * i);
         }
      }
   });
}

private final Handler handler = new Handler() {
   @Override
   public void handleMessage(Message msg) {
      Flipping();
   }
};

private void Flipping() {
   viewFlipper.showNext();
}

{% endhighlight %}

보시는것과 같이 ViewFlipper를 클릭했을 경우에 이미지가 바뀌도록 만들었습니다.

실제로, 타이머같은 기능을 쓸경우에는 ViewFlipper의 Touch 이벤트를 추가하면됩니다.



이런 로직을 사용한 이유를 알려드리겠습니다.

1. ViewFlipper에는 startFlipping이라는 함수가 존재합니다.

   자동으로 슬라이드가 되는것 처럼보여주고, 멈추는 stopFlipping이라는 함수도 존재합니다.

   하지만, start는 가능하지만, stop하는 타이밍을 잡기가 어렵습니다.

   가능한 방법은 스레드에서 해당 child를 보고 stop하는 방법뿐일듯 합니다.

2. 굳이 Handler를 이용하지않아도, for를 이용해서 setDisplayedChild() 함수를 이용할수도 있습니다.

    하지만, 이 경우에는 너무 빠르게 지나갑니다.

    엑스페리아, 넥서스원으로 테스트해봤지만, 종이가 넘어가는 순간이나 닫혀지는 순간만 잠깐 보이기만 합니다.

    그래서 Handler에 존재하는 sendEmptyMessageDelayed() 를 이용합니다.

    메세지과 함께 딜레이 타임을 설정해줄수 있기때문에, 이미지가 바뀌는 시간을 설정해줄수 있습니다.

- - -

위의 예제는 단순하게 어떻게 보이는지 확인하기 위한 예제일뿐입니다.

설명이 좀 복잡하지만, 도움이되는 정보가 되었으면합니다.
