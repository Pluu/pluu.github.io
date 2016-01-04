---
layout: post
title: "Android Kakao Talk UI 만들기 2 - 이모티콘 실시간 핫 아이템 UI"
date: 2015-12-06 23:50:00
tag: [Android, Kakao, 카카오]
categories:
- blog
- Android
---

<!--more-->

# 카카오톡 이모티콘 실시간 핫 아이템 UI

카카오톡에서 사용하는 `이모티콘 실시간 핫 아이템` 을 표시하는 기본 샘플을 만들겠습니다

기본적으로 ListView + 2개의 Item을 표시하는 Item View 의 조합입니다.

# 개발 프로세스

1. ListView Adapter의 View Count를 고정(3)으로 설정
2. 총 갯수는 ListView의 View Count의 배수로 설정
3. Item View의 레이아웃은 표시 데이터 2개로 작업
4. 애니메이션 작업
 1. 아래에서 나타나는 애니메이션
 2. 위로 사라지는 애니메이션
5. Item Layout의 상하단에 각각 필요한 데이터 표시와 애니메이션 적용
6. View 데이터 갱신

#### MAdapter.java

```java
public class MAdapter extends BaseAdapter {

    // Offset Position
    private int offsetPos = 0;

    // Sample, Current List View Count
    private final int LIST_COUNT = 3;
    // Sample, Total Count
    private final int TOTAL_COUNT = LIST_COUNT * 3;
    private boolean isFistView = true;

    private final int REFRESH_EVENT = 0;
    private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            // Refresh          
            offsetUp();
            notifyDataSetChanged();
            return false;
        }
    });

    /** Data Offest Position */
    public void offsetUp() {
        offsetPos += LIST_COUNT;

        if (offsetPos >= TOTAL_COUNT) {
            offsetPos = 0;
        }
    }

    @Override
    public int getCount() {
        return LIST_COUNT;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_list, parent, false);
        }

        int pos = offsetPos + position;
        final View view1 = ViewHolder.get(convertView, R.id.layout1);
        final View view2 = ViewHolder.get(convertView, R.id.layout2);

        Context context = parent.getContext();

        final Animation SLIDE_IN_UP = AnimationUtils.loadAnimation(context, R.anim.slide_in_up);
        Animation SLIDE_OUT_UP = AnimationUtils.loadAnimation(context, R.anim.slide_out_up);

        // 사라지는 Animation
        SLIDE_OUT_UP.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) { }

            @Override
            public void onAnimationEnd(Animation animation) {
                view2.setVisibility(View.VISIBLE);

                // 나타나는 애니메이션 실행
                view2.startAnimation(SLIDE_IN_UP);
            }

            @Override
            public void onAnimationRepeat(Animation animation) { }
        });
        // 나타나는 Animation
        SLIDE_IN_UP.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                view1.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                if ((position + 1) % LIST_COUNT == 0) {
                    // 1초 단위 갱신
                    handler.sendEmptyMessageDelayed(REFRESH_EVENT,
                            TimeUnit.MILLISECONDS.convert(1, TimeUnit.SECONDS));
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) { }
        });

        if (isFistView && pos >= LIST_COUNT) {
            // 최초 개수의 Animation 이 끝나면 Flag 수정
            isFistView = false;
        }

        if (!isFistView) {
            // 사라질 View
            // 한 바퀴가 돌고 나면 위치 수정을 위한 보정 코드
            setBindView(view1, (pos + TOTAL_COUNT - LIST_COUNT) % TOTAL_COUNT);
        }
        // 나타날 View
        setBindView(view2, pos);

        if (isFistView) {
            view1.setVisibility(View.GONE);
            view2.setVisibility(View.VISIBLE);
            SLIDE_IN_UP.setStartOffset(150 * position);
            view2.startAnimation(SLIDE_IN_UP);
        } else {
            view1.setVisibility(View.VISIBLE);
            view2.setVisibility(View.GONE);
            SLIDE_OUT_UP.setStartOffset(150 * position);
            view1.startAnimation(SLIDE_OUT_UP);
        }
        return convertView;
    }

    /**
     * Data Bind
     * @param view Bind View
     * @param pos Bind Data Position
     */
    private void setBindView(View view, int pos) {
        pos += 1;

        TextView num = ViewHolder.get(view, R.id.textView);
        num.setText(String.valueOf(pos));
        TextView title = ViewHolder.get(view, R.id.textView2);
        title.setText("Title " + pos);
        TextView summary = ViewHolder.get(view, R.id.textView3);
        summary.setText("Summary " + pos);
    }

    /** Auto Refresh Event Stop */
    public void stop() {
        handler.removeMessages(REFRESH_EVENT);
    }

    private static class ViewHolder {
        @SuppressWarnings("unchecked")
        public static <T extends View> T get(View view, int id) {
            SparseArray<View> viewHolder = (SparseArray<View>) view.getTag();
            if (viewHolder == null) {
                viewHolder = new SparseArray<View>();
                view.setTag(viewHolder);
            }
            View childView = viewHolder.get(id);
            if (childView == null) {
                childView = view.findViewById(id);
                viewHolder.put(id, childView);
            }
            return (T) childView;
        }
    }
}
```

#### item_list.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <include
        android:id="@+id/layout1"
        layout="@layout/merge_list_item" />

    <include
        android:id="@+id/layout2"
        layout="@layout/merge_list_item" />

</FrameLayout>
```

#### merge_list_item.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@android:color/white"
    android:padding="10dp">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_centerVertical="true"
        android:minWidth="48dp"
        android:textAppearance="?android:attr/textAppearanceLarge"
        android:textColor="#F00"
        android:textSize="40sp"
        android:textStyle="bold|italic"
        tools:text="1" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_centerVertical="true"
        android:layout_marginLeft="10dp"
        android:layout_marginRight="10dp"
        android:layout_toEndOf="@+id/textView"
        android:layout_toLeftOf="@+id/image"
        android:layout_toRightOf="@+id/textView"
        android:layout_toStartOf="@+id/image"
        android:orientation="vertical">

        <TextView
            android:id="@+id/textView2"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:ellipsize="end"
            android:singleLine="true"
            android:textAppearance="?android:attr/textAppearanceMedium"
            tools:text="Title" />

        <TextView
            android:id="@+id/textView3"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:ellipsize="end"
            android:singleLine="true"
            android:textAppearance="?android:attr/textAppearanceSmall"
            tools:text="Summary" />
    </LinearLayout>

    <ImageView
        android:id="@+id/image"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_alignParentEnd="true"
        android:layout_alignParentRight="true"
        android:layout_centerVertical="true"
        android:src="@mipmap/ic_launcher" />

</RelativeLayout>
```

#### slide_in_up.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<set
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@anim/custom_decelerate_interpolator"
    android:duration="@android:integer/config_longAnimTime">

    <translate
        android:fromYDelta="50%p"
        android:toYDelta="0"/>

    <alpha
        android:fromAlpha="0.0"
        android:toAlpha="1.0" />
</set>
```

#### slide_out_up.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<set
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@anim/custom_decelerate_interpolator"
    android:duration="@android:integer/config_longAnimTime">

    <translate
        android:fromYDelta="0"
        android:toYDelta="-50%p"/>

    <alpha
        android:fromAlpha="1.0"
        android:toAlpha="0.0" />
</set>
```

#### custom_decelerate_interpolator.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<decelerateInterpolator
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:factor="1.5"/>
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-12-06-android-kakao-android.gif" }}" />
