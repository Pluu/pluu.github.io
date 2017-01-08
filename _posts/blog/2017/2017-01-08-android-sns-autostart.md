---
layout: post
title: "[번역] SNS 타임라인 동영상 자동 재생"
date: 2017-01-08 23:40:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [SNSタイムライン動画の自動再生](http://qiita.com/neonankiti/items/cfa8cc0d3c48b9edc2fb) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 소개

[FiNC](https://finc.com/)의 Android 엔지니어 겸 Bison의 nanri입니다.

AdventCalendar 라서 섣달 바쁜 시기이지요?

그럼 시작합니다.

우선은 여기를 참조하십시오

<blockquote class="twitter-tweet" data-lang="ja"><p lang="und" dir="ltr"><a href="https://t.co/cLPXZHEonG">pic.twitter.com/cLPXZHEonG</a></p>&mdash; 南里勇気 (@neonankiti) <a href="https://twitter.com/neonankiti/status/811946011388100608">2016年12月22日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

라인의 자동 재생을 녹화해 보았습니다.

사노 히나코 귀엽네요.

다양한 SNS에서 자주 보는 자동 재생.

실제로 구현하고 있는 사례가 별로 보이지 않았기 때문에 생각했습니다.

## 기능 요구 사항

1. Wifi에서 자동 재생 (모바일에서 자동 재생은 사용자가 싫어합니다)
2. 자동 재생은 스크린에 들어갔을 때에 한다.
3. 여러 개있는 경우 면적이 큰 하나만 재생

## 1. Wifi 부분의 구현

[ConnectivityManager](https://developer.android.com/reference/android/net/ConnectivityManager.html)라는 클래스가 있습니다.

이 클래스는 네트워크의 상태, 변화에 대해 책임을 지는 클래스입니다

현재 네트워크가 wifi 상태인지를 얻으려면 다음 코드를 작성합니다.

```
// 네트워크 상태 취득
private static NetworkInfo getNetworkInfo(@NonNull Context context) {
    ConnectivityManager connectivityManager 
        = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    return connectivityManager.getActiveNetworkInfo();
}


// Wifi 상태
public static boolean isWifi(@NonNull Context context) {
    return getNetworkType(context) == ConnectivityManager.TYPE_WIFI;
}
```

간단하네요.

## 2. 자동 재생은 스크린에 들어갔을 때에 한다
## 3. 여러 개있는 경우, 점유 면적이 큰 하나만 재생

정책은 RecyclerView.OnScrollLister에서 화면에 표시되는 각 콘텐츠(ViewHolder)의 position을 얻어 동영상을 시작시킬 position인지 여부를 결정합니다.

동영상을 시작해야 할 position이면 시작하고 그렇지 않으면 그 콘텐츠는 동영상을 멈춥니다.

ReyclerView를 이용할 때 이벤트 리스너로 `RecyclerView.OnScrollListener`를 이용합니다.

콘텐츠가 화면내에 있는지 여부는 얻을 수 있지만, 콘텐츠가 재생시킬 동영상인지 확인하려면 각 콘텐츠마다의 좌표를 얻어 계산해야합니다.

간단하게 화면내에 있는 콘텐츠를 특정하기 위해 먼저 다음과 같은 interface를 정의합니다.

그리고 OnScrollListener에서 insideScreen를 호출합니다.

```
// SampleActivity.java
interface OnPositionListener {
    void insideScreen(int startPosition);
}

// position의 lister는 Map에서 가집니다.
private HashMap<Integer, OnCompletelyVisiblePositionListener> positionListeners = new HashMap<>();

public void setOnPositionListener(
        int position, OnPositionListener positionListener) {
    this.positionListeners.put(position, positionListener);
}
```

insideScreen에서의 구현은 화면의 모든 콘텐츠(ViewHolder)에 대해 startPosition을 건네주고 있습니다.

ViewHolder의 getAdapterPosition()과 비교하여 startPosition이면 VideoView(ExoPlayer가 최근 유행이네요)를 start()하는 형태입니다.

```
// SampleActivity.java
private final RecyclerView.OnScrollListener listener = new RecyclerView.OnScrollListener() {
    @Override
    public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
        insideScreen(getMovieStartPosition(recyclerView));
    }
};


@Override
public void insideScreen(int startPosition) {
    for (Map.Entry<Integer, OnCompletelyVisiblePositionListener> e : onCompletelyVisiblePositionListeners.entrySet()) {
        e.getValue().insideScreen(startPosition);
    }
}
```

## 화면의 면적을 취득하는 부분

```
// SampleActivity.java
private int getMovieStartPosition(RecyclerView recyclerView) {

    // 첫 번째 콘텐츠 취득
    int firstVisibleItemPosition = ((LinearLayoutManager) recyclerView.getLayoutManager()).findFirstVisibleItemPosition();

    // 마지막 콘텐츠의 취득
    int lastVisibleItemPosition = ((LinearLayoutManager) recyclerView.getLayoutManager()).findLastVisibleItemPosition();

    // 콘텐츠의 크기에 따라 화면에 표시되는 콘텐츠의 수는 달라질 수 있다.
    if (lastVisibleItemPosition - firstVisibleItemPosition == 0) {
        return firstVisibleItemPosition;
    }

    // 화면에 표시되는 처음 및 마지막 아이템의 position의 차이가 1 이상일 때, 표시할 콘텐츠 하나를 특정할 필요가 있다.
    float ratio = 0.0f;
    int startPosition = firstVisibleItemPosition;

    // 콘텐츠만큼 for문을 돈다.
    for (int i = 0; i < lastVisibleItemPosition - firstVisibleItemPosition + 1; i++) {

        // position의 adapter를 얻는다
        RecyclerView.ViewHolder holder = recyclerView.findViewHolderForAdapterPosition(firstVisibleItemPosition + i);

        // findViewHolderForAdapterPosition could return null.
        if (holder == null) {
            continue;
        }

        // 각 콘텐츠의 Top, Bottom 좌표를 얻는다
        int topPosition = holder.itemView.getTop() < 0 ? 0 : holder.itemView.getTop();
        int bottomPosition = holder.itemView.getBottom() > displaymetrics.heightPixels
                ? displaymetrics.heightPixels
                : holder.itemView.getBottom();

        // 화면 세로 비율을 얻어 콘텐츠마다 점유 면적을 비교.
        float pointedRatio = (bottomPosition - topPosition) / (float) displaymetrics.heightPixels;
        if (pointedRatio > ratio) {
            ratio = pointedRatio;
            startPosition = firstVisibleItemPosition + i;
        }
    }
    return startPosition;
}
```

위에서 타임 라인에서 동영상을 재생할 position을 특정하기 때문에, 나머지는 ViewHolder.getAdapterPosition()의 값과 비교하여 재생해야 할 콘텐츠인지 판단해주세요.

## 정리

Line, Twitter, Facebook, Vine 등에서 자동 재생을 어떻게 구현하고 있을까라고 생각했기 때문에 실제로 구현해봐서 좋은 공부가 되었습니다.

더 좋은 구현 있으면 가르쳐주세요.