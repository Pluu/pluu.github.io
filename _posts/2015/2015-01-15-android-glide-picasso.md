---
layout: post
title: "Android Picasso vs Glide"
date: 2015-01-15 11:23:00
categories: [android study]
tag: [Android, Picasso, Glide]
---

Android에서 사용하는 ImageLoader Library중에서 편리중심이며 많이 사용하고 있는 Picasso와

Google I/O 2014로 인해서 급부상항 Glide에 대해서 가벼운 정보를 작성했습니다.

## Picasso
Square Inc 개발 Library

- GitHub : http://square.github.io/picasso/
- Wiki : http://square.github.io/picasso/

최신버전 2.4.0

## Glide
Google I/O 2014 소스에 포함된후 급부상

왠지모를 Picasso의 Copy & Paste ??

최신버전 3.0

- GitHub : https://github.com/bumptech/glide
- Wiki : https://github.com/bumptech/glide/wiki

- - -

## 사용방법 비교

### 기본
{% highlight java %}
// Picasso
Picasso.with(this)
   .load(URL)
   .into(ImageView imageView);

// Glide
Glide.with(this)
   .load(URL)
   .into(ImageView imageView);
{% endhighlight %}

이후는 해당 함수만 표기합니다.

### Resize Image
{% highlight java %}
// Picasso
.resize(200, 200)

// Glide
.override(200, 200)
{% endhighlight %}

### Callback or Listener
{% highlight java %}
// Picasso
.into(ImageView imageView, Callback arg1);

// Glide
.listener(RequestListener<String, GlideDrawable> requestListener)
{% endhighlight %}

### Transform
{% highlight java %}
// Picasso
.transform(new CircleTransform())

// Glide
.transform(new CircleTransform(context))
{% endhighlight %}

### Thumbnail
{% highlight java %}
// Picasso
// No Support

// Glide
.thumbnail(0.1f)
{% endhighlight %}

### Animation
{% highlight java %}
// Picasso
// No Support

// Glide
.animate(anim)
{% endhighlight %}

### Placeholders
{% highlight java %}
// Picasso
.placeholder(drawable/resourceid)
.error(drawable/resourceid)

// Glide
.placeholder(drawable/resourceid)
.error(drawable/resourceid)
{% endhighlight %}

### 외부 통신 Library 연계

#### Picasso - OkHttp
{% highlight groovy %}
dependencies {
   compile 'com.squareup.okhttp:okhttp:2.4.+'
   compile 'com.squareup.okhttp:okhttp-urlconnection:+'
}
{% endhighlight %}

{% highlight java %}
OkHttpClient okHttpClient = new OkHttpClient();
Picasso picasso = new Picasso
   .Builder(this)
   .downloader(new OkHttpDownloader(okHttpClient)).build();
{% endhighlight %}

#### Glide - Vollery
{% highlight groovy %}
dependencies {
   compile 'com.github.bumptech.glide:volley-integration:1.1.+'
   compile 'com.mcxiaoke.volley:library:1.0.+'
}
{% endhighlight %}

{% highlight java %}
Glide
   .get(this)
   .register(GlideUrl.class,
      InputStream.class,
      new VolleyUrlLoader.Factory(yourRequestQueue));
{% endhighlight %}

#### Glide - OkHttp
{% highlight groovy %}
dependencies {
   compile 'com.github.bumptech.glide:okhttp-integration:1.1.+'
   compile 'com.squareup.okhttp:okhttp:2.4.+'
}
{% endhighlight %}

{% highlight java %}
Glide
   .get(this)
   .register(GlideUrl.class,
      InputStream.class,
      new OkHttpUrlLoader.Factory(yourRequestQueue));
{% endhighlight %}

## 비교

| 비고 | Picasso | Glide |
| :-: | :-: | :--: |
| Animated GIF 지원 | X | O |
| Local video 지원 | X | O |
| Thumbnail | X | O |
| Animation | X | O |

- - -

Update

- 2015년 1월 16일 오전 11시 25분
 - Picasso, Glide 소개 페이지 Update
 - Picasso + OkHttp 연계 수정

- - -

참고 사이트

1. http://vardhan-justlikethat.blogspot.kr/2014/09/android-image-loading-libraries-picasso.html
2. http://qiita.com/hotchemi/items/33ebd5faa42d2d05c2b6
3. http://qiita.com/hotchemi/items/375d63261f2eed2b18e1
