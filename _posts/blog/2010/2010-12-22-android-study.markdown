---
layout: post
title: "Flip Clock 구현방법2"
date: 2010-12-22 14:32:00
tag: [Android, Flip Clock]
categories:
- blog
- Android-Study
---

이전에 Flip Clock의 이미지가 전부 존재할경우를 올렸는데 

이번에는 각각 숫자마다 아래/위 이미지가 존재할 경우 사용가능에 대해서 올렸습니다.

<!--more-->

실제로 가장 중요한 부분은 setBounds 함수입니다. 

이미지의 크기를 설정해서 보여주기때문에 눈의 착각으로 넘어가는 듯하게 보입니다.


표현하는 순서는

<ol>
<li>아래 이미지를 반 접은 상태를 표시</li>
<li>아래 이미지를 완전히 접은 상태를 표시</li>
<li>위 이미지를 반 접은 상태를 표시</li>
<li>다음 번호가 표시</li>
</ol>
- - -

이미지는 위와 같습니다. 넘어가는 순간순간이 다 이미지로 되어있습니다.

그리고, ViewFlipper라는 컴포넌트를 사용합니다.

ViewFlipper 안에 필요한 이미지 수만큼 ImageView를 추가합니다.


{% highlight Java linenos %}
import java.util.ArrayList;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.View;

public class parts_number extends View implements ServiceInfo {
   // 화면 크기
   private int VIEW_WIDTH;
   private int VIEW_HEIGHT;

   // 표시할 이미지 리스트
   private ArrayList<Integer> img_top;
   private ArrayList<Integer> img_bottom;

   // 뒤쪽에 표시할 이미지
   private Drawable first_prevTop;
   private Drawable first_prevBottom;

   private Drawable second_prevTop;
   private Drawable second_prevBottom;

   // 앞쪽에 표시할 이미지
   private Drawable first_nowTop;
   private Drawable first_nowBottom;

   private Drawable second_nowTop;
   private Drawable second_nowBottom;

   // 리소스
   private Resources r;

   // 이미지 표시 좌표
   // 뒤쪽 이미지용
   private int first_prevTop_w;
   private int first_prevTop_h;
   private int first_prevBottom_w;
   private int first_prevBottom_h;
   private int first_nowTop_w;
   private int first_nowTop_h;
   private int first_nowBottom_w;
   private int first_nowBottom_h;

   // 앞쪽 이미지용
   private int second_prevTop_w;
   private int second_prevTop_h;
   private int second_prevBottom_w;
   private int second_prevBottom_h;
   private int second_nowTop_w;
   private int second_nowTop_h;
   private int second_nowBottom_w;
   private int second_nowBottom_h;

   // 뒤쪽 이미지에 표시할 인덱스
   private int NUM_PREV;
   // 앞족 이미지에 표시할 인덱스
   private int NUM_NOW;

   // 핸들러 메세지
   // 이미지용
   private final int MSG_NEXT_1ST = 11;
   private final int MSG_NEXT_2ND = 12;
   private final int MSG_NEXT_3RD = 13;
   private final int MSG_NEXT_4TH = 14;
   private final int MSG_PREV_1ST = 21;
   private final int MSG_PREV_2ND = 22;
   private final int MSG_PREV_3RD = 23;
   private final int MSG_PREV_4TH = 24;

   // 핸들러 메세지 지연 시간
   private final long HANDLER_DELAY_TIME = 75;

   /**
      * 현재 표현숫자 취득
      * @return
   */
   public int getNum() {
      return NUM_NOW;
   }

   /**
      * 핸들러 처리
   */
   private Handler handler = new Handler() {
      @Override
      public void dispatchMessage(Message msg) {
         switch (msg.what) {
            case MSG_NEXT_1ST:
               Next_1ST();
               break;
            case MSG_NEXT_2ND:
               Next_2ND();
               break;
            case MSG_NEXT_3RD:
               Next_3RD();
               break;
            case MSG_NEXT_4TH:
               Next_4TH();
               break;
            case MSG_PREV_1ST:
               Prev_1ST();
               break;
            case MSG_PREV_2ND:
               Prev_2ND();
               break;
            case MSG_PREV_3RD:
               Prev_3RD();
               break;
            case MSG_PREV_4TH:
               Prev_4TH();
               break;
         }
      }
   };

   /**
      * 생성자
      * @param context
      * @param attrs
   */
   public parts_number(Context context, AttributeSet attrs) {
      super(context, attrs);

      r = getResources();

      setFocusable(true);
      setClickable(true);

      Init();
      FirstSetting(0);
   }

   /**
      * 초기설정 : 이미지 리스트 준비
   */
   private void Init() {
      img_top = new ArrayList<Integer>();
      img_bottom = new ArrayList<Integer>();

      img_top.add(R.drawable.l_flap_0_top);
      img_top.add(R.drawable.l_flap_1_top);
      img_top.add(R.drawable.l_flap_2_top);
      img_top.add(R.drawable.l_flap_3_top);
      img_top.add(R.drawable.l_flap_4_top);
      img_top.add(R.drawable.l_flap_5_top);
      img_top.add(R.drawable.l_flap_6_top);
      img_top.add(R.drawable.l_flap_7_top);
      img_top.add(R.drawable.l_flap_8_top);
      img_top.add(R.drawable.l_flap_9_top);

      img_bottom.add(R.drawable.l_flap_0_bottom);
      img_bottom.add(R.drawable.l_flap_1_bottom);
      img_bottom.add(R.drawable.l_flap_2_bottom);
      img_bottom.add(R.drawable.l_flap_3_bottom);
      img_bottom.add(R.drawable.l_flap_4_bottom);
      img_bottom.add(R.drawable.l_flap_5_bottom);
      img_bottom.add(R.drawable.l_flap_6_bottom);
      img_bottom.add(R.drawable.l_flap_7_bottom);
      img_bottom.add(R.drawable.l_flap_8_bottom);
      img_bottom.add(R.drawable.l_flap_9_bottom);

      NUM_NOW = 0;
      NUM_PREV = 0;
   }

   /**
      * 초기 표시 설정 : 0
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#FirstSetting(int)
   */
   @Override
   public void FirstSetting(int init) {
      NUM_NOW = init;
      NUM_PREV = init;

      // Prev (First)
      first_prevTop = r.getDrawable(img_top.get(0));
      first_prevBottom = r.getDrawable(img_bottom.get(0));

      first_prevTop_h = first_prevTop.getIntrinsicHeight();
      first_prevTop_w = first_prevTop.getIntrinsicWidth();

      first_prevBottom_h = first_prevBottom.getIntrinsicHeight();
      first_prevBottom_w = first_prevBottom.getIntrinsicWidth();

      // Prev (Second)
      second_prevTop = r.getDrawable(img_top.get(0));
      second_prevBottom = r.getDrawable(img_bottom.get(0));

      second_prevTop_h = second_prevTop.getIntrinsicHeight();
      second_prevTop_w = second_prevTop.getIntrinsicWidth();

      second_prevBottom_h = second_prevBottom.getIntrinsicHeight();
      second_prevBottom_w = second_prevBottom.getIntrinsicWidth();

      // Now (First)
      first_nowTop = r.getDrawable(img_top.get(0));
      first_nowBottom = r.getDrawable(img_bottom.get(0));

      first_nowTop_h = first_nowTop.getIntrinsicHeight();
      first_nowTop_w = first_nowTop.getIntrinsicWidth();

      first_nowBottom_h = first_nowBottom.getIntrinsicHeight();
      first_nowBottom_w = first_nowBottom.getIntrinsicWidth();

      // Now (Second)
      second_nowTop = r.getDrawable(img_top.get(0));
      second_nowBottom = r.getDrawable(img_bottom.get(0));

      second_nowTop_h = second_nowTop.getIntrinsicHeight();
      second_nowTop_w = second_nowTop.getIntrinsicWidth();

      second_nowBottom_h = second_nowBottom.getIntrinsicHeight();
      second_nowBottom_w = second_nowBottom.getIntrinsicWidth();

      // 위치설정
      first_prevTop.setBounds(0, 0, first_prevTop_w, first_prevTop_h);
      first_prevBottom.setBounds(0, first_prevTop_h, first_prevBottom_w, first_prevTop_h + first_prevBottom_h);
      second_prevTop.setBounds(first_prevTop_w, 0, first_prevTop_w + second_prevTop_w, second_prevTop_h);
      second_prevBottom.setBounds(first_prevTop_w, second_prevTop_h, 
         first_prevTop_w + second_prevBottom_w, second_prevTop_h + second_prevBottom_h);

      first_nowTop.setBounds(0, 0, first_nowTop_w, first_nowTop_h);
      first_nowBottom.setBounds(0, first_nowTop_h, first_nowBottom_w, first_nowTop_h + first_nowBottom_h);
      second_nowTop.setBounds(first_nowTop_w, 0, first_nowTop_w + second_nowTop_w, second_nowTop_h);

      second_nowBottom.setBounds(first_nowTop_w, second_nowTop_h, 
         first_nowTop_w + second_nowBottom_w, second_nowTop_h + second_nowBottom_h);

      // VIEW 설정
      VIEW_WIDTH = first_nowTop_w + second_nowTop_w;
      VIEW_HEIGHT = first_nowTop_h + first_nowBottom_h;
   }

   /**
      * 다음 표시 이미지 계산
   */
   public void NextCal() {
      NUM_PREV = NUM_NOW;
      NUM_NOW++;

      if (NUM_NOW >= 60) {
         NUM_NOW = 0;
      }
      NextView();
   }

   /**
      * 다음 이미지 표시
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#NextView()
   */
   @Override
   public void NextView() {
      handler.sendEmptyMessageDelayed(MSG_NEXT_1ST, HANDLER_DELAY_TIME);
      handler.sendEmptyMessageDelayed(MSG_NEXT_2ND, HANDLER_DELAY_TIME * 2);
      handler.sendEmptyMessageDelayed(MSG_NEXT_3RD, HANDLER_DELAY_TIME * 3);
      handler.sendEmptyMessageDelayed(MSG_NEXT_4TH, HANDLER_DELAY_TIME * 4);
   }

   /**
      * 이전 이미지 계산
      */
   public void PrevCal() {
      NUM_PREV = NUM_NOW;
      NUM_NOW--;

      if (NUM_NOW < 0) {
         NUM_NOW = 59;
      }

      PrevView();
   }

   /**
      * 이전 이미지 표시
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#PrevView()
      */
   @Override
   public void PrevView() {
      handler.sendEmptyMessageDelayed(MSG_PREV_1ST, HANDLER_DELAY_TIME);
      handler.sendEmptyMessageDelayed(MSG_PREV_2ND, HANDLER_DELAY_TIME * 2);
      handler.sendEmptyMessageDelayed(MSG_PREV_3RD, HANDLER_DELAY_TIME * 3);
      handler.sendEmptyMessageDelayed(MSG_PREV_4TH, HANDLER_DELAY_TIME * 4);
   }

   /**
      * 화면에 표시할 사이즈 설정
      *  (非 Javadoc)
      * @see android.view.View#onMeasure(int, int)
      */
   @Override
   protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
      setMeasuredDimension(VIEW_WIDTH, VIEW_HEIGHT);
   }

   /**
      * 화면 표시
      *  (非 Javadoc)
      * @see android.view.View#onDraw(android.graphics.Canvas)
      */
   @Override
   protected void onDraw(Canvas canvas) {
      super.onDraw(canvas);

      // Prev Draw
      first_prevTop.draw(canvas);
      first_prevBottom.draw(canvas);
      second_prevTop.draw(canvas);
      second_prevBottom.draw(canvas);

      // Now Draw
      first_nowTop.draw(canvas);
      first_nowBottom.draw(canvas);
      second_nowTop.draw(canvas);
      second_nowBottom.draw(canvas);
   }

   /**
      * 다음 이미지 표시 : 1단계
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#Next_1ST()
      */
   @Override
   public void Next_1ST() {
      int position_prev_10 = NUM_PREV / 10;
      int position_prev_1 = NUM_PREV % 10;
      int position_now_10 = NUM_NOW / 10;
      int position_now_1 = NUM_NOW % 10;

      // Prev (First)
      first_prevTop = r.getDrawable(img_top.get(position_prev_10));
      first_prevBottom = r.getDrawable(img_bottom.get(position_now_10));

      // Prev (Second)
      second_prevTop = r.getDrawable(img_top.get(position_prev_1));
      second_prevBottom = r.getDrawable(img_bottom.get(position_now_1));

      // Now (First)
      first_nowTop = r.getDrawable(img_top.get(position_prev_10));
      first_nowBottom = r.getDrawable(img_bottom.get(position_prev_10));

      // Now (Second)
      second_nowTop = r.getDrawable(img_top.get(position_prev_1));
      second_nowBottom = r.getDrawable(img_bottom.get(position_prev_1));

      // 위치설정
      first_prevTop.setBounds(0, 0, first_prevTop_w, first_prevTop_h);
      first_prevBottom.setBounds(0, first_prevTop_h, first_prevBottom_w, first_prevTop_h + first_prevBottom_h);
      second_prevTop.setBounds(first_prevTop_w, 0, first_prevTop_w + second_prevTop_w, second_prevTop_h);
      second_prevBottom.setBounds(first_prevTop_w, second_prevTop_h, 
         first_prevTop_w + second_prevBottom_w, second_prevTop_h + second_prevBottom_h);

      first_nowTop.setBounds(0, 0, first_nowTop_w, first_nowTop_h);
      first_nowBottom.setBounds(0, first_nowTop_h, first_nowBottom_w, first_nowTop_h + (first_nowBottom_h / 2));
      second_nowTop.setBounds(first_nowTop_w, 0, first_nowTop_w + second_nowTop_w, second_nowTop_h);
      second_nowBottom.setBounds(first_nowTop_w, second_nowTop_h,
         first_nowTop_w + second_nowBottom_w, second_nowTop_h + (second_nowBottom_h / 2));

      invalidate();
   }

   /**
   * 다음 이미지 표시 : 2단계
   *
   *  (非 Javadoc)
   * @see casio.timer.ServiceInfo#Next_2ND()
   */
   @Override
   public void Next_2ND() {
      int position_prev_10 = NUM_PREV / 10;
      int position_prev_1 = NUM_PREV % 10;
      int position_now_10 = NUM_NOW / 10;
      int position_now_1 = NUM_NOW % 10;

      // Prev (First)
      first_prevTop = r.getDrawable(img_top.get(position_now_10));
      first_prevBottom = r.getDrawable(img_bottom.get(position_now_10));

      // Prev (Second)
      second_prevTop = r.getDrawable(img_top.get(position_now_1));
      second_prevBottom = r.getDrawable(img_bottom.get(position_now_1));

      // Now (First)
      first_nowTop = r.getDrawable(img_top.get(position_prev_10));
      first_nowBottom = r.getDrawable(img_bottom.get(position_now_10));

      // Now (Second)
      second_nowTop = r.getDrawable(img_top.get(position_prev_1));
      second_nowBottom = r.getDrawable(img_bottom.get(position_now_1));

      // 위치설정
      first_prevTop.setBounds(0, 0, first_prevTop_w, first_prevTop_h);
      first_prevBottom.setBounds(0, first_prevTop_h, first_prevBottom_w, first_prevTop_h + first_prevBottom_h);
      second_prevTop.setBounds(first_prevTop_w, 0, first_prevTop_w + second_prevTop_w, second_prevTop_h);
      second_prevBottom.setBounds(first_prevTop_w, second_prevTop_h,
         first_prevTop_w + second_prevBottom_w, second_prevTop_h + second_prevBottom_h);

      first_nowTop.setBounds(0, 0, first_nowTop_w, first_nowTop_h);
      first_nowBottom.setBounds(0, first_nowTop_h, first_nowBottom_w, first_nowTop_h + first_nowBottom_h);
      second_nowTop.setBounds(first_nowTop_w, 0, first_nowTop_w + second_nowTop_w, second_nowTop_h);
      second_nowBottom.setBounds(first_nowTop_w, second_nowTop_h,
         first_nowTop_w + second_nowBottom_w, second_nowTop_h);

      invalidate();
   }

   /**
      * 다음 이미지 표시 : 3단계
      *
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#Next_3RD()
      */
   @Override
   public void Next_3RD() {
      int position_prev_10 = NUM_PREV / 10;
      int position_prev_1 = NUM_PREV % 10;
      int position_now_10 = NUM_NOW / 10;
      int position_now_1 = NUM_NOW % 10;

      // Prev (First)
      first_prevTop = r.getDrawable(img_top.get(position_prev_10));
      first_prevBottom = r.getDrawable(img_bottom.get(position_now_10));

      // Prev (Second)
      second_prevTop = r.getDrawable(img_top.get(position_prev_1));
      second_prevBottom = r.getDrawable(img_bottom.get(position_now_1));

      // Now (First)
      first_nowTop = r.getDrawable(img_top.get(position_now_10));
      first_nowBottom = r.getDrawable(img_bottom.get(position_now_10));

      // Now (Second)
      second_nowTop = r.getDrawable(img_top.get(position_now_1));
      second_nowBottom = r.getDrawable(img_bottom.get(position_now_1));

      // 위치설정
      first_prevTop.setBounds(0, 0, first_prevTop_w, first_prevTop_h);
      first_prevBottom.setBounds(0, first_prevTop_h, first_prevBottom_w, first_prevTop_h + first_prevBottom_h);
      second_prevTop.setBounds(first_prevTop_w, 0, first_prevTop_w + second_prevTop_w, second_prevTop_h);
      second_prevBottom.setBounds(first_prevTop_w, second_prevTop_h,
         first_prevTop_w + second_prevBottom_w, second_prevTop_h + second_prevBottom_h);

      first_nowTop.setBounds(0, first_nowTop_h / 2, first_nowTop_w, first_nowTop_h);
      first_nowBottom.setBounds(0, first_nowTop_h, first_nowBottom_w, first_nowTop_h + first_nowBottom_h);
      second_nowTop.setBounds(first_nowTop_w, second_nowTop_h / 2, first_nowTop_w + second_nowTop_w, second_nowTop_h);
      second_nowBottom.setBounds(first_nowTop_w, second_nowTop_h,
         first_nowTop_w + second_nowBottom_w, second_nowTop_h + second_nowBottom_h);

      invalidate();
   }

   /**
      * 다음 이미지 표시 : 4단계
      *
      *  (非 Javadoc)
      * @see casio.timer.ServiceInfo#Next_4TH()
      */
   @Override
   public void Next_4TH() {
      int position_10 = NUM_NOW / 10;
      int position_1 = NUM_NOW % 10;

      // Now (First)
      first_nowTop = r.getDrawable(img_top.get(position_10));
      first_nowBottom = r.getDrawable(img_bottom.get(position_10));

      // Now (Second)
      second_nowTop = r.getDrawable(img_top.get(position_1));
      second_nowBottom = r.getDrawable(img_bottom.get(position_1));

      // 위치설정
      first_nowTop.setBounds(0, 0, first_nowTop_w, first_nowTop_h);
      first_nowBottom.setBounds(0, first_nowTop_h, first_nowBottom_w, first_nowTop_h + first_nowBottom_h);
      second_nowTop.setBounds(first_nowTop_w, 0, first_nowTop_w + second_nowTop_w, second_nowTop_h);
      second_nowBottom.setBounds(first_nowTop_w, second_nowTop_h,
         first_nowTop_w + second_nowBottom_w, second_nowTop_h + second_nowBottom_h);

      invalidate();
   }
}

{% endhighlight %}