---
layout: post
title: "Glide와 함께 Coroutines Suspend로 애니메이션 적용해보기"
date: 2023-11-25 16:00:00 +09:00
tag: [Android, Glide, Coroutine]
categories:
- blog
- Android
---

최근 Glide와 함께 애니메이션 처리에 Coroutines Suspend를 적용해 본 사례를 소개합니다.

<!--more-->

만들어 볼 스펙의 모습은 아래와 같습니다.

{% include youtube.html id="BOg-Igjv3Ec" %}

### 요구하는 내용

1. URL을 통한 이미지 로딩
1. TextView에 현재시간을 표시 및 Fade-in + Translation으로 나타나는 애니메이션
1. 2초 대기
1. TextView를 Fade-out + Translation으로 사라지는 애니메이션
1. 복수의 이미지 URL을 사용하여 1~4번 항목 반복

## 간단한 방법으로 해결한다면?

위의 샘플은 사실 Coroutines Suspend를 사용하지 않더라도 손쉽게 작성할 수 있습니다. 간단하게 작업한다면 아래처럼 작성할 수 있습니다.

1. Glide 이미지 로딩 시, RequestListener에 전달된 콜백으로 응답(onResourceReady/onLoadFailed)이 호출될 때까지 대기
2. 이미지 로딩이 끝나면 Animator/Animation 등을 사용하여 나타나는 애니메이션 작업. 이때 다음 작업을 실행할 시점이 필요함
   1. 애니메이션의 종료를 알 수 있는 Listener
   2. 적절한 시간 사용한 Handler
3. Handler#delay를 사용하여 2초 대기도 가능. 혹은 4번 작업의 애니메이션의 시작 시간을 2초 딜레이로도 가능
4. 2번과 동일하게 사라지는 애니메이션 작업
5. 반복을 위해서 이때도 Handler를 사용하여 1번 작업을 호출하도록 합니다.



다른 기술을 사용하더라도 기본적인 기능 호출/콜백/애니메이션/Handler 등 여러 작업이 필수로 요구됩니다. 특히 콜백과 Handler를 동시 사용하면, 코드가 분산되어 가독성이 낮습니다. 

이럴 때 `Coroutines Suspend`을 사용하면 하나의 블록 안에서 순차적으로 선언할 수 있습니다.

## 일시 중지

UI 동작을 Coroutines Suspend로 응용하기 위해서는 각 작업의 종료 시점이 필요합니다. 해당 설명은 Chris Banes의 블로그에서 상세하게 설명하고 있습니다. 먼저 읽으시면, 이후의 내용이 더 이해가 잘됩니다.

- [Suspending over Views](https://chrisbanes.me/posts/suspending-views/)
- [Suspending over Views — Example](https://chrisbanes.me/posts/suspending-views-example/)

### 1. Animator의 일시 중지

Animator는 직접 취소/종료 등을 탐지할 수 있는 Animation 객체입니다. 일시 중지는 Animator#AnimatorListenerAdapter를 사용하여 조정할 수 있습니다.

```kotlin
suspend fun Animator.awaitEnd() = suspendCancellableCoroutine<Unit> { cont ->
  // coroutine이 취소된 경우, 애니메이션도 취소
  cont.invokeOnCancellation { cancel() }

  addListener(object : AnimatorListenerAdapter() {
    private var endedSuccessfully = true

    override fun onAnimationCancel(animation: Animator) {
      endedSuccessfully = false
    }

    override fun onAnimationEnd(animation: Animator) {
      // coroutine continuation이 계속 호출되지 않도록 리스너를 제거
      animation.removeListener(this)

      if (cont.isActive) {
        // continuation이 활성화일 때 continuation을 resume/cancel한다
        if (endedSuccessfully) {
          cont.resume(Unit)
        } else {
          cont.cancel()
        }
      }
    }
  })
}
```

#### Fade-in/Fade-out

노출/사라지는 효과는 간단하게 Android에서 기본 제공하는 것으로도 사용할 수 있습니다. 앞서 Animator의 일시 중지와 종료 시점을 확인했으니 이 작업은 매우 간단합니다. 간단하게 Alpha/TranslationY를 사용하여 Animator를 생성합니다.

```kotlin
// TranslationY 수치는 임의의 값
private fun generateFadeIn(target: View): Animator {
  return AnimatorSet().apply {
    interpolator = FastOutSlowInInterpolator()
    playTogether(
      ObjectAnimator.ofFloat(target, View.ALPHA, 0f, 1f),
      ObjectAnimator.ofFloat(target, View.TRANSLATION_Y, 50f, 0f)
    )
  }
}

private fun generateFadeOut(target: View): Animator {
  return AnimatorSet().apply {
    interpolator = FastOutSlowInInterpolator()
    playTogether(
      ObjectAnimator.ofFloat(target, View.ALPHA, 1f, 0f),
      ObjectAnimator.ofFloat(target, View.TRANSLATION_Y, 0f, 50f)
    )
  }
}

private suspend fun View.startAwaitEnd(animator: Animator) {
  animator.setTarget(this)
  animator.start()
  animator.awaitEnd()
}
```

#### 결과 코드 

```kotlin
private suspend fun playStep(url: String) {
  // TODO: 이미지 로드
  binding.notiText.run {
    text = "Show ${Date()}"
    // Fade-in 효과
    startAwaitEnd(generateFadeIn(this))
    // 2초 대기
    delay(2.seconds)
    // Fade-out 효과
    startAwaitEnd(generateFadeOut(this))
  }
}
```

[ViewPropertyAnimator](https://developer.android.com/reference/android/view/ViewPropertyAnimator)도 사용할 수 있겠지만, Animator의 동작을 트래킹하는  [ViewPropertyAnimator#setListener](https://developer.android.com/reference/android/view/ViewPropertyAnimator#setListener(android.animation.Animator.AnimatorListener))의 경우 단일 리스너만 설정가능합니다. 그래서 ViewPropertyAnimator를 정의하는 경우를 고려한다면 ViewPropertyAnimator로 Coroutine 일시 중지를 사용에는 적합하지 않습니다.

### 2. Glide의 일시 중지

이제 Glide로 이미지를 로드하는 동안, Coroutine Scope내의 작업을 일시 중지할 수 있습니다. 앞서 일시 중지를 위해서는 원하는 작업의 종료 시점이 필요하다고 설명했습니다. Glide는 `RequestListener`를 통해서 시점을 처리할 수 있습니다. 해당 함수들은 Glide를 사용하는 사용자라면 익숙한 리스너일 것입니다.

- onResourceReady
- onLoadFailed

이제 해당 리스너의 구현체에서 일시 중지된 작업을 `Continuation#resume`으로 재개할 수 있습니다.

```kotlin
suspend fun ImageView.awaitLoad(url: String) = suspendCoroutine { cont ->
  Glide.with(this)
    .load(url)
    .addListener(object : RequestListener<Drawable> {
      override fun onLoadFailed(
        e: GlideException?,
        model: Any?,
        target: Target<Drawable>?,
        isFirstResource: Boolean
      ): Boolean {
        cont.resume(Unit)
        return false
      }

      override fun onResourceReady(
        resource: Drawable?,
        model: Any?,
        target: Target<Drawable>?,
        dataSource: DataSource?,
        isFirstResource: Boolean
      ): Boolean {
        cont.resume(Unit)
        return false
      }
    })
    .into(this)
}
```

> suspendCancellableCoroutine를 사용한다면 View가 Detach되는 시점 등을 사용하여 CancellableContinuation#cancel을 하는 방법도 있습니다.

#### 결과 코드

```kotlin
private suspend fun playStep(url: String) {
  // 이미지 로드
  binding.imageView.awaitLoad(url)
  binding.notiText.run {
    text = "Show ${Date()}"
    // Fade-in 효과
    startAwaitEnd(generateFadeIn(this))
    // 2초 대기
    delay(2.seconds)
    // Fade-out 효과
    startAwaitEnd(generateFadeOut(this))
  }
}
```

기본적인 동작은 이것으로 끝났습니다.

### 3. 전체 동작을 반복

이미지들을 노출과 애니메이션을 반복하기 위해서는 while/for/재귀호출을 사용할 수 있습니다. 여기서는 while 사용하며 Coroutine이 유효(isActive)할 때까지 반복하도록 합니다.

```kotlin
binding.root.findViewTreeLifecycleOwner()?.lifecycleScope?.launch {
  while (isActive) {
    playStep(/** Image Url */)
  }
}

private suspend fun playStep(url: String) {
  // 이미지 로드
  binding.imageView.awaitLoad(url)
  binding.notiText.run {
    text = "Show ${Date()}"
    // Fade-in 효과
    startAwaitEnd(generateFadeIn(this))
    // 2초 대기
    delay(2.seconds)
    // Fade-out 효과
    startAwaitEnd(generateFadeOut(this))
  }
}
```

이것으로 기대하는 효과를 얻을 수 있습니다.

## 기타. 적용한다면?

모든 애니메이션과 동작들이 Coroutines Suspend를 적용하기 편리하다고는 볼 수 없습니다. 아래 항목들을 참고하여 적용 전에 조건에 맞는지 체크한 후 도입하면 좋습니다.

- 비동기 작업의 종료/취소 시점을 알 수 있는가?
- 동기화된 방식으로 처리 가능한가?

## 응용 버전

{% include youtube.html id="Rx71I5EuvLk" %}

> 샘플 코드 : https://github.com/Pluu/SuspendGlideSample

## 참고 자료

- [Suspending over Views](https://chrisbanes.me/posts/suspending-views/)
- [Suspending over Views — Example](https://chrisbanes.me/posts/suspending-views-example/)
