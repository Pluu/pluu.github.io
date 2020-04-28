---
layout: post
title: "Glide#into 사용시 주의점"
date: 2020-04-28 23:50:00 +09:00
tag: [Android, Glide]
categories:
- blog
- Android
---

Glide#into 에 전달하는 Target, 잘못 전달하고 있지 않나요?

Android 개발 시에 손쉽게 이미지 로딩으로 사용하는 라이브러리로 몇 가지가 있습니다. [Glide](https://bumptech.github.io/glide/), [Picasso](https://square.github.io/picasso/), [Fresco](https://frescolib.org/)가 최근 몇 년간 꾸준히 사용되고 있으며, Kotlin Corutine을 이용한 이미지 로딩 라이브러리로 [Coil](https://coil-kt.github.io/coil/)도 최근 발표도 되었습니다.

본 글에서는 다양한 라이브러리 중 Glide의 기능 중 하나를 살펴볼 예정입니다.

<!--more-->

### 먼저 내리는 결론

`문서를 잘 읽고, API를 사용합시다`

### 기본 Glide 이미지 요청

먼저 Glide를 사용한 간단한 샘플을 보겠습니다.

```kotlin
Glide.with(/** Context|Activity|FragmentActivity|Fragment|View */)
    .load(/** Resource */)
    .transform(/** transformation */)
    .transition(/** transition options */)
    .error(/** Drawable|DrawableRes */)
    .thumbnail(/** Size Multiplier */)
    .override(/** width */, /** height */)
    .into(/** ImageView|Target */)
```

[Method chaining](https://en.wikipedia.org/wiki/Method_chaining) 방식을 통해서 손쉽게 이미지를 비동기로 가져와서 필요한 곳에 전달됩니다. 또한, 단순 이미지 로드, 이미지 변형, 에러 대응 등 기본적으로 이미지 로드 시에 필요한 기본적인 활용 범위에서는 충분합니다. 

### 왜 이렇게 될까요?

#### 사전 조건

아래에 사용한 ImageView는 ScaleType을 별도로 갱신하지 않고, 기본 타입인 `FIT_CENTER`가 사용됩니다.

샘플로 사용할 이미지의 크기는 아래와 같습니다.

| 1214 x 2475 픽셀 이미지                                      | 80 x 80 픽셀 이미지                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/sample_over.png" }}" width="400" /> | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/sample_11.jpg" }}" width="400" /> |

#### 성공 샘플

먼저 이 샘플 코드를 한번 확인해보겠습니다

```kotlin
Glide.with(context)
  .load(/** Image Url */)
  .transform(CenterCrop(), RoundedCorners(/** 10dp */))
  .into(/** ImageView */)
```

기본적인 API를 사용했으며 CenterCrop과 이미지의 모서리를 10dp만큼 둥글게 표현하는 코드입니다. 100dp x 100dp 의 이미지 뷰에 샘플 코드를 적용하면 아래와 같은 결과를 얻을 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/good_sample.png" }}" />

> 붉은색의 Round Border는 이미지 뷰 영역 표시를 위해서 노출했습니다
>
> 좌측 : 1,214px 2,475px / 우측 : 80px x 80px

원본 이미지의 크기와 상관없이 예상했던 결과대로 CenterCrop과 10dp의 둥근 코너 형태의 이미지가 반영되었습니다. 다만 원본 이미지보다 적용하는 ImageView의 크기 차이로 선명함 차이는 있습니다. 

#### 실패 샘플 ~ CustomTarget

다음으로 아래 코드를 사용해봅니다. 

```kotlin
Glide.with(context)
  .load(/** Image Url */)
  .transform(CenterCrop(), RoundedCorners(/** 10dp */))
  .into(object : CustomTarget<Drawable>() {
      override fun onResourceReady(
        resource: Drawable,
        transition: Transition<in Drawable>?
      ) {
        imageView.setImageDrawable(resource)
      }

      override fun onLoadCleared(placeholder: Drawable?) {}
  }
```

성공 샘플과 다른 부분은 `into` 함수에 전달하는 파라매터의 차이입니다. 그 결과는 아래와 같습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/bad_sample.png" }}" />

> 붉은색의 Round Border는 이미지 뷰 영역 표시를 위해서 노출했습니다
>
> 좌측 : 1,214px 2,475px / 우측 : 80px x 80px

`CustomTarget` 사용시 ScaleType과의 조합이 맞지 않을지도 모릅니다. 그러니 다음 케이스도 써봅니다.

#### 실패 샘플 ~ CustomTarget => ImageView ScaleType 수정

또 다른 샘플로 `CustomTarget`을 사용하면서 ImageView의 ScaleType을 다양하게 적용해봅니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/bad_sample2.png" }}" />

ImageView에 정의된 ScaleType으로는 성공 샘플과 다른 결과를 출력합니다.

### API 부터 파악

Glide 사용 시의 [into(ImageView)](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L666) 함수는 메소드 체이닝에 의해서 실제로는 [RequestBuilder#into](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L666) 함수입니다.

#### RequestBuilder#into(ImageView)

먼저 가장 많이 사용하는 [into(ImageView)](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L666) 함수를 사용할 때는 아래의 흐름으로 Glide에서 사용하는 ViewTarget을 얻습니다.

1. [RequestBuilder#into(ImageView)](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L666)
2. [GlideContext#buildImageViewTarget(ImageView, Class\<Type\>)](https://github.com/bumptech/glide/blob/1caeff4bf17952c7372acbbbc27297cd06615e5f/library/src/main/java/com/bumptech/glide/GlideContext.java#L97)
3. [ImageViewTargetFactory#buildTarget(ImageView, Class\<Type\>)](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/ImageViewTargetFactory.java)

```java
public class ImageViewTargetFactory {
  @NonNull
  @SuppressWarnings("unchecked")
  public <Z> ViewTarget<ImageView, Z> buildTarget(
      @NonNull ImageView view, @NonNull Class<Z> clazz) {
    if (Bitmap.class.equals(clazz)) {
      return (ViewTarget<ImageView, Z>) new BitmapImageViewTarget(view);
    } else if (Drawable.class.isAssignableFrom(clazz)) {
      return (ViewTarget<ImageView, Z>) new DrawableImageViewTarget(view);
    } else {
      throw new IllegalArgumentException(
          "Unhandled class: " + clazz + ", try .as*(Class).transcode(ResourceTranscoder)");
    }
  }
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/ImageViewTargetFactory.java

Glide를 통해서 어떤 리소스를 얻는가에 따라서 [BitmapImageViewTarget](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/BitmapImageViewTarget.java), [DrawableImageViewTarget](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/DrawableImageViewTarget.java) 을 사용합니다. 이를 통해서 얻는 ViewTarget 또한 특정 클래스를 상속합니다.

```kotlin
// BitmapImageViewTarget
ViewTarget
ㄴ ImageViewTarget
   ㄴ BitmapImageViewTarget

// DrawableImageViewTarget
ViewTarget
ㄴ ImageViewTarget
   ㄴ DrawableImageViewTarget
```

이 구조를 통해서 확인할 수 있는 사실은 [RequestBuilder#into(ImageView)](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L666) 사용 중 [RequestBuilder#into(Target)](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L597) 으로 변경 시 기존과 동일한 흐름을 유지하려면 적어도 [ImageViewTarget](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/ImageViewTarget.java) 를 사용해야합니다.

#### RequestBuilder#into(CustomTarget)

손쉽게 사용할 수 있는 Target 중에는 [CustomTarget](https://bumptech.github.io/glide/javadocs/490/com/bumptech/glide/request/target/CustomTarget.html) 이 있습니다. 다만 이 클래스는 `매우 조심히` 사용되어야 합니다.

Glide 사이트에는 다음과 같이 작성되어 있습니다.

> Using `Target.SIZE_ORIGINAL` can be very inefficient or cause OOMs if your image sizes are large enough. As an alternative, You can also pass in a size to your `Target`’s constructor and provide those dimensions to the callback:

> 출처 : http://bumptech.github.io/glide/doc/targets.html#custom-targets

이미지 크기가 큰 경우, [CustomTarget](https://bumptech.github.io/glide/javadocs/490/com/bumptech/glide/request/target/CustomTarget.html) 사용 시 비효율적이거나 OOM을 유발할 수 있다고 설명하고 있습니다.

```java
public abstract class CustomTarget<T> implements Target<T> {
  ...
  public CustomTarget() {
    this(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL);
  }

  public CustomTarget(int width, int height) {
    this.width = width;
    this.height = height;
  }
  ...
}
```

> 소스 출처 : https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/CustomTarget.java#L53

[CustomTarget](https://bumptech.github.io/glide/javadocs/490/com/bumptech/glide/request/target/CustomTarget.html) 생성자로 크기를 전달하지 않는 경우 [Target.SIZE_ORIGINAL](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/Target.java#L32) 를 width/height에 대입하고 있습니다. 이미지 요청 시 원본 이미지 크기로 읽겠다는 정의하고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/bad_sample.png" }}" />

지금까지 내용을 토대로 위 현상을 해석을 하면 다음과 같습니다.

- 좌측 : 1,212 x 2,475 이미지를 CenterCrop + 10dp로 모서리를 Round 처리한 이미지를 ImageView에 적용
- 우측 : 80 x 80 이미지를 CenterCrop + 10dp로 모서리를 Round 처리한 이미지를 ImageView에 적용
   - Pixel 3a에서 10dp는 27px로 Round 처리
   - Round 되지 않는 부분은 4면의 26px만 해당됩니다.
   - Round할 수치를 늘린다면 원형으로 표시됩니다.

또한 [CustomTarget](https://bumptech.github.io/glide/javadocs/490/com/bumptech/glide/request/target/CustomTarget.html) 을 상속하는 클래스는 아래와 같습니다. 

```kotlin
CustomTarget
ㄴ AppWidgetTarget
ㄴ PreloadTarget
ㄴ NotificationTarget
ㄴ DelayTarget in GifFrameLoader
```

## Glide로부터 읽어온 Drawable 크기 확인

앞서 나열한 `RequestBuilder#into` 에 전달하는 항목마다 얼만큼 Drawable이 사용되는지 [RequestBuilder#listener(RequestListener\<Type\>)](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/RequestBuilder.java#L173) 함수를 사용해서 확인해볼 수 있습니다. 이 함수를 통해 확인 가능한 사실은 [CustomTarget](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/CustomTarget.java) 은 Glide로 load한 이미지 리소스의 원본 크기를 그대로 읽어오는 것을 확인할 수 있습니다. 

그 결과로 ImageView와 [ImageViewTarget](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/ImageViewTarget.java) 은 100dp(=275px)의 Drawable을 읽어옵니다. 큰 이미지를 [CustomTarget](https://github.com/bumptech/glide/blob/master/library/src/main/java/com/bumptech/glide/request/target/CustomTarget.java) 를 사용해 이미지를 읽는 경우, 픽셀 3a에서 100dp(=275px)의 정사각형에 1,212 x 2,475 크기의 Drawable을 ImageView에 반영하고 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0429-glidetarget/loaded_image.png" }}" />

## 정리

본 글을 통해서 RequestBuilder#into에 전달하는 파라매터 사용시에는 API 문서를 제대로 체크해야 한다는 것이 전달되었길 바랍니다.

### 성공하는 패턴

- into의 매개변수로 ImageView를 전달
- into의 매개변수로 [ImageViewTarget](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/ImageViewTarget.java)을 전달
- into의 매개변수로 [CustomViewTarget](https://github.com/bumptech/glide/blob/1caeff4bf1/library/src/main/java/com/bumptech/glide/request/target/CustomViewTarget.java)을 전달
- 이미 영역 크기를 알고 있다면, override(width, height)로 고정 + into의 매개변수로 CustomTarget을 전달
