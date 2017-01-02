---
layout: post
title: "[번역] OSS에서 배우는 Activity 시작시 근사한 애니메이션"
date: 2017-01-03 00:40:00 +09:00
tag: [Android, OSS]
categories:
- blog
- Android
---

본 포스팅은 [OSSから学ぶActivity起動時のカッコいいアニメーション](http://qiita.com/nissiy/items/9b978ed1925f3605a25c) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

여러분 Material Design 잘하고 있습니까?

Activity 시작할 때 Reveal Effect를 하고 그 후에 부드럽게 콘텐츠가 나오는 UI를 본 적이 있는 분도 많다고 생각합니다만, 엄청 근사하지요.

이번에는 멋지게 구현되어있는 [InstaMaterial](https://github.com/frogermcs/InstaMaterial) 코드를 분해하면서 어떻게 구현되어 있는지를 풀어보려고 합니다.

## 개요

이번에는 InstaMaterial의 메인 페이지 (MainActivity)에서 사용자 페이지 (UserProfileActivity)로 화면전환 할 때의 애니메이션에 대해서 분해하여 보았습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/40539/0230a278-9642-7dd3-9b63-347d41deb919.gif"/>

> GIF 애니메이션의 사이즈 용량을 줄이기 위해 fps를 낮췄기때문에 자세하게 확인하려면 프로젝트를 각자 빌드해주세요

## MainActivity에서 UserProfileActivity로 Intent

MainActivity에서 UserProfileActivity로 Intent할 때의 코드는 다음과 같이되어 있습니다.

```
// MainActivity.java
@Override
public void onProfileClick(View v) {
    // 화면 전환 후 바로 표시되는 Reveal Effect를 위해 탭한 View의 위치를 얻어서 전달하고 있다.
    int[] startingLocation = new int[2];
    v.getLocationOnScreen(startingLocation);
    startingLocation[0] += v.getWidth() / 2;
    UserProfileActivity.startUserProfileFromLocation(startingLocation, this);

    // 화면 전환의 기본 애니메이션을 끄고 Activity가 바뀐다는 것을 느끼게 하지 않도록 하고 있다.
    overridePendingTransition(0, 0);
}
```

## 화면 전환 후 바로 나타나는 Reveal Effect

UserProfileActivity의 onCreate에서 호출하는 `setupRevealBackground()`에서 Reveal Effect를 할 준비를 하고 있습니다. 코드는 다음과 같습니다.

```
// UserProfileActivity.java
private void setupRevealBackground(Bundle savedInstanceState) {
    // 상태가 변경되면 UserProfileActivity#onStateChange가 불리게 한다.
    vRevealBackground.setOnStateChangeListener(this);

    if (savedInstanceState == null) {
        // MainActivity에서 넘겨진 정보를 취득
        final int[] startingLocation = getIntent().getIntArrayExtra(ARG_REVEAL_START_LOCATION);

        // ViewTreeObserver를 사용하면 vRevealBackground가 그려진 타이밍을 포착하여 애니메이션 작업을 시작하도록 하고 있다
        vRevealBackground.getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                vRevealBackground.getViewTreeObserver().removeOnPreDrawListener(this);
                // 실제로 애니메이션을 하는 부분
                // 애니메이션은 ObjectAnimator로 하고 있다
                // 애니메이션이 끝나면 상태를 "FINISHED"로 변경
                vRevealBackground.startFromLocation(startingLocation);
                return true;
            }
        });
    } else {
        vRevealBackground.setToFinishedFrame();
        userPhotosAdapter.setLockedAnimations(true);
    }
}
```

`vRevealBackground`는 [RevealBackgroundView.java](https://github.com/frogermcs/InstaMaterial/blob/master/app/src/main/java/io/github/froger/instamaterial/ui/view/RevealBackgroundView.java)를 구체화한 것으로, Reveal Effect의 실제 처리를 하거나 상태 유지를 하거나 합니다.

이번에는 생략하지만 멋진 구현 클래스이므로 각각의 앱에 적용할 때 참고로 해 보면 어떨까요.

## 헤더 및 탭 애니메이션

Reveal Effect 애니메이션이 완료되면 상태가 "FINISHED"로 변경되기 때문에 `onStateChange()`가 호출됩니다. 코드는 다음과 같습니다.

```
// UserProfileActivity.java
@Override
public void onStateChange(int state) {
    if (RevealBackgroundView.STATE_FINISHED == state) {
        // Reveal Effect 상태가 FINISHED로 변경된 경우

        // 헤더와 탭이 VISIBLE된다
        rvUserProfile.setVisibility(View.VISIBLE);
        tlUserProfileTabs.setVisibility(View.VISIBLE);
        vUserProfileRoot.setVisibility(View.VISIBLE);

        // 하단의 사진 그리드 처리를 시작
        userPhotosAdapter = new UserProfileAdapter(this);
        rvUserProfile.setAdapter(userPhotosAdapter);

        // 탭 위에서 나오는 애니메이션이 일어난다
        animateUserProfileOptions();

        // 헤더가 위에서 나오는 애니메이션이 일어난다
        animateUserProfileHeader();
    } else {
        tlUserProfileTabs.setVisibility(View.INVISIBLE);
        rvUserProfile.setVisibility(View.INVISIBLE);
        vUserProfileRoot.setVisibility(View.INVISIBLE);
    }   
}

private void animateUserProfileOptions() {
    tlUserProfileTabs.setTranslationY(-tlUserProfileTabs.getHeight());
    tlUserProfileTabs.animate().translationY(0).setDuration(300).setStartDelay(USER_OPTIONS_ANIMATION_DELAY).setInterpolator(INTERPOLATOR);
}

private void animateUserProfileHeader() {
    vUserProfileRoot.setTranslationY(-vUserProfileRoot.getHeight());
    ivUserProfilePhoto.setTranslationY(-ivUserProfilePhoto.getHeight());
    vUserDetails.setTranslationY(-vUserDetails.getHeight());
    vUserStats.setAlpha(0);

    vUserProfileRoot.animate().translationY(0).setDuration(300).setInterpolator(INTERPOLATOR);
    ivUserProfilePhoto.animate().translationY(0).setDuration(300).setStartDelay(100).setInterpolator(INTERPOLATOR);
    vUserDetails.animate().translationY(0).setDuration(300).setStartDelay(200).setInterpolator(INTERPOLATOR);
    vUserStats.animate().alpha(1).setDuration(200).setStartDelay(400).setInterpolator(INTERPOLATOR).start();
}
```

여기에서의 처리는 헤더와 탭의 애니메이션이 주를 이루고 있습니다. 코드를 읽으면 아시겠지만, 복잡한 움직임으로 멋진 애니메이션을 만들고 있습니다.

어떤 멋진 것이더라도 결국에는 복잡한 작업이 쌓인 것입니다!

## 부드럽게 나타나는 각 사진

`onStateChange()`에서는 하단의 사진 그리드를 표시하는 기능도 하고 있습니다.

이 사진 그리드는 간단한 RecyclerView로 되어있지만 이미지를 읽어 들인 후에 스케일시키는 애니메이션을 넣는 것으로 이 움직임을 실현하고 있습니다. 코드는 다음과 같습니다.

```
// UserProfileAdapter.java
@Override
public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
    bindPhoto((PhotoViewHolder) holder, position);
}

private void bindPhoto(final PhotoViewHolder holder, int position) {
    Picasso.with(context)
            .load(photos.get(position))
            .resize(cellSize, cellSize)
            .centerCrop()
            .into(holder.ivPhoto, new Callback() {
                @Override
                public void onSuccess() {
                    // 이미지 로드가 완료되면 애니메이션을 한다
                    animatePhoto(holder);
                }   

                @Override
                public void onError() {

                }   
            }); 
    if (lastAnimatedItem < position) lastAnimatedItem = position;
}

private void animatePhoto(PhotoViewHolder viewHolder) {
    if (!lockedAnimations) {
        if (lastAnimatedItem == viewHolder.getPosition()) {
            setLockedAnimations(true);
        }   

        // 스케일을 0에서 1로하고 부드럽게 표시시키고 있다
        long animationDelay = PHOTO_ANIMATION_DELAY + viewHolder.getPosition() * 30; 

        viewHolder.flRoot.setScaleY(0);
        viewHolder.flRoot.setScaleX(0);

        viewHolder.flRoot.animate()
                .scaleY(1)
                .scaleX(1)
                .setDuration(200)
                .setInterpolator(INTERPOLATOR)
                .setStartDelay(animationDelay)
                .start();
    }   
}
```

## 정리

Activity 시작시 Reveal Effect를 하고 그 후에 부드럽게 콘텐츠가 나오는 UI 구현 방법을 InstaMaterial 코드를 통해 소개했습니다.

이 UI의 핵심은 확실히 Reveal Effect라고 생각하지만, [RevealBackgroundView.java](https://github.com/frogermcs/InstaMaterial/blob/master/app/src/main/java/io/github/froger/instamaterial/ui/view/RevealBackgroundView.java)를 참고하면 앱에서 다양한 형태로 커스터마이즈할 수 있다고 생각하기 때문에 꼭 한번 코드를 읽어보십시오.

그리고 부드럽게 표시하는 애니메이션에는 지름길이 없다는 것을 알았으므로 좋게 표현되도록 꾸준히 애니메이션 조정을 해서 멋지게될 때까지 열심히 노력합시다.