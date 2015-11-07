---
layout: post
title: "Android Kakao Talk UI 만들기"
date: 2015-08-14 23:50:00
tag: [Android, Kakao, 카카오]
categories:
- blog
- Android
---
<!--more-->

###카카오톡 광고 배너 UI

카카오톡에서 사용하는 복수개의 광고 배너의 기본 샘플을 만들겠습니다

기본적으로 Custom ViewPager + Item Layout 의 조합입니다.

####개발 프로세스
1. Item Layout 에는 기본 표시 View + ViewPager의 Background View 의 조합으로 구성
2. ViewPager 의 `instantiateItem` 의 View 생성시 Background View 의 `Alpha 0`으로 설정
3. ViewPager 의 `onPageScrolled`, `onScrollChanged` 를 이용해 투명도 계산
4. ViewPager 의 `onDraw` 에서 전후 Background View 의 Drawable 를 `Canvas` 에 그림

####pager_item.xml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout
	xmlns:android="http://schemas.android.com/apk/res/android"
	xmlns:tools="http://schemas.android.com/tools"
	android:layout_width="match_parent"
	android:layout_height="match_parent">

	<ImageView
		android:id="@+id/imgBg"
		android:layout_width="match_parent"
		android:layout_height="match_parent"
		tools:background="@drawable/bg_01" />

	<ImageView
		android:id="@+id/img"
		android:layout_width="wrap_content"
		android:layout_height="wrap_content"
		android:layout_alignParentRight="true"
		android:layout_centerVertical="true"
		tools:background="@drawable/emp_friends_01"/>
</RelativeLayout>
{% endhighlight %}

####CrossFadeAdapter.java
{% highlight java %}
public class CrossFadeAdapter extends PagerAdapter {

	private final List<CrossFadeItem> list;

	private LayoutInflater inflater;

	public CrossFadeAdapter(Context context, List<CrossFadeItem> list) {
		inflater = LayoutInflater.from(context);
		this.list = list;
	}

	@Override
	public Object instantiateItem(ViewGroup container, int position) {
		CrossFadeItem item = list.get(position);

		View view = inflater.inflate(R.layout.pager_item, container, false);
		ImageView badge1 = ButterKnife.findById(view, R.id.imgBg);
		ImageView badge2 = ButterKnife.findById(view, R.id.img);

		badge1.setImageResource(item.bgResId);
		badge2.setImageResource(item.imgResId);

		ViewCompat.setAlpha(badge1, 0f);
		view.setTag(Const.PAGER_TAG + position);

		container.addView(view);
		return view;
	}

	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
		container.removeView((View) object);
	}

	@Override
	public int getCount() {
		return list != null ? list.size() : 0;
	}

	@Override
	public boolean isViewFromObject(View view, Object object) {
		return view == object;
	}
}
{% endhighlight %}

####CrossFadeViewPager.java
{% highlight java %}
public class CrossFadeViewPager extends ViewPager {

	private int alpha;
	private boolean ltr = true;
	private int frontIdx, forwardIdx;

	public CrossFadeViewPager(Context context) {
		super(context);
	}

	public CrossFadeViewPager(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	@Override
	protected void onDraw(Canvas canvas) {
		final Rect rect = canvas.getClipBounds();
		View view;
		if (alpha < 255) {
			view  = findViewWithTag(Const.PAGER_TAG + forwardIdx);
			if (view != null) {
				drawBg(canvas, rect, view, false);
			}
		}
		view = findViewWithTag(Const.PAGER_TAG + frontIdx);
		if (view != null) {
			drawBg(canvas, rect, view, true);
		}
		super.onDraw(canvas);
	}

	private void drawBg(Canvas canvas, Rect rect, View view, boolean isFront) {
		view = view.findViewById(R.id.imgBg);
		if (view != null) {
			Drawable drawable = ((ImageView) view).getDrawable();
			if (drawable != null) {
				drawable.setBounds(rect.left, 0, rect.right, getHeight());
				drawable.setAlpha(isFront ? alpha : 255 - alpha);
				drawable.draw(canvas);
				drawable.setAlpha(0);
			}
		}
	}

	@Override
	protected void onPageScrolled(int position, float offset, int offsetPixels) {
		super.onPageScrolled(position, offset, offsetPixels);
		PagerAdapter adapter = getAdapter();
		if (adapter == null) {
			return;
		}
		if (offset == 0.0F) {
			alpha = 255;
			frontIdx = position;
			return;
		}

		final int totalCount = adapter.getCount();
		if (ltr) {
			frontIdx = ((position + totalCount + 1) % totalCount);
			forwardIdx = position;
		} else {
			frontIdx = position;
			forwardIdx = ((position + totalCount + 1) % totalCount);
		}

		int offsetAlpha = (int) (255.0F * offset);
		int tempAlpha = offsetAlpha;
		if (!ltr) {
			tempAlpha = 255 - offsetAlpha;
		}
		alpha = tempAlpha;
	}

	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
		super.onScrollChanged(l, t, oldl, oldt);
		ltr = (l - oldl >= 0);
	}
}
{% endhighlight %}

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-08-14-CrossFadeViewPager.gif" }}" />

샘플소스 : [링크](https://github.com/Pluu/CrossFadeViewPager)
