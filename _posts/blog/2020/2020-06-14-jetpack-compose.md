---
layout: post
title: "Jetpack Compose ~ Preview / Interactive"
date: 2020-06-14 23:00:00 +09:00
tag: [Android, Jetpack, Compose]
categories:
- blog
- Android
- Compose
---

Android 11 Beta Launch 이벤트 세션 Jetpack Compose의 `Preview` / `Interactive` 기능의 테스트입니다.

<!--more-->

본 글은 `Android Studio 4.2 Canary 1`에서 테스트를 진행했습니다.

------

Android Studio 4.2 Canary 1부터는 Jetpack Compose로 개발 시에 Preview 패널과 Embded Emulator를 사용하면 다양한 테스트를 Android Studio에서 진행할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0615-jetpack-compose/interactive_02.png" }}" /> 

------

## PreviewParameter

Jetpack Compose에서는 [PreviewParameter](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/PreviewParameter)를 사용해서 기존 개발 시에 사용했던 XML Sample Data 소스와 유사한 결과물을 얻을 수 있습니다. 아래에서 관련된 내용을 살펴보겠습니다.

- [PreviewParameterProvider](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/PreviewParameterProvider) : [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview)에 파라미터로 샘플 데이터를 공급자가 구현할 인터페이스입니다.
- [PreviewParameter](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/PreviewParameter) : 데이터 수신자를 지정하는 Annotation으로 샘플 데이터를 공급할 구현체를 지정합니다.

------

#### PreviewParameter 생성자 정보

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0615-jetpack-compose/PreviewParameter_Constructors.png" }}" /> 

#### CollectionPreviewParameterProvider Sample

Jetpack News Sample 소스에 포함되어 있는 샘플 post 정보를 사용해서 Sample Data 제공자를 구성합니다.

> 샘플 소스 : https://github.com/android/compose-samples/blob/master/JetNews/app/src/main/java/com/example/jetnews/data/posts/impl/PostsData.kt#L926

```kotlin
// Sample Data, CollectionPreviewParameterProvider 구현체
class SamplePostProvider : CollectionPreviewParameterProvider<Post>(
    listOf(post1, post2, post3)
)
```

#### PreviewParameter Sample

```kotlin
@Preview
@Composable
fun PreviewPostImageSampleData(
    @PreviewParameter(SamplePostProvider::class) post: Post
) {
    val context = ContextAmbient.current
    val previewPosts = getPostsWithImagesLoaded(listOf(post), context.resources)
    val imageLoadedPost = previewPosts.first()

    ThemedPreview {
        PostCardTop(post = imageLoadedPost)
    }
}
```

> fun getPostsWithImagesLoaded(posts: List<Post>, resources: Resources): List<Post>
>
> 소스 위치 : https://github.com/android/compose-samples/blob/master/JetNews/app/src/main/java/com/example/jetnews/data/posts/impl/PostsData.kt#L1020

#### 샘플 결과

샘플 소스 3개를 Preview로 노출한 결과입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0615-jetpack-compose/PreviewParameter.png" }}" width="400" /> 

## Interactive

Jetpack Compose에서 또 다른 기능으로 Interactive / Deploy Preview 기능이 있습니다. 

해당 기능은 각 `Preview`마다 우측 상단의 Interactive / Deploy Preview 버튼이 존재합니다. 두 기능 개별적으로 Preview의 동작을 확인할 수 있습니다.

- Interactive : [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview)로 지정된 Composable을 Compose Preivew 패널에서 확인
- Deploy Preview : [@Preview](https://developer.android.com/reference/kotlin/androidx/ui/tooling/preview/Preview) 지정된 Composable을 디바이스 및 에뮬레이터에서 샘플 동작 확인

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2020/0615-jetpack-compose/interactive_01.png" }}" /> 

------

이후의 샘플은 Composable의 3가지 크기(Small, Medium, Large)를 Interactive / Deploy Preview에서 어떻게 노출되는지 샘플로 촬영한 모습입니다.

### Small Composable

```kotlin
@Composable
fun BookmarkButton(
    isBookmarked: Boolean,
    onBookmark: (Boolean) -> Unit,
    modifier: Modifier = Modifier
) {
    IconToggleButton(
        checked = isBookmarked,
        onCheckedChange = onBookmark
    ) {
        ...
    }
}
```

#### Interactive

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/DeTB1KHuK2E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

#### Deploy Preview

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/GtSQXWN3VVE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### Middle Composable

```kotlin
@Composable
fun PostCardSimple(post: Post) {
    Row(modifier = Modifier
        .clickable(onClick = { navigateTo(Screen.Article(post.id)) })
        .padding(16.dp)
    ) {
        PostImage(post, Modifier.padding(end = 16.dp))
        Column(modifier = Modifier.weight(1f)) {
            PostTitle(post)
            AuthorAndReadTime(post)
        }
        BookmarkButton(
            isBookmarked = isFavorite(postId = post.id),
            onBookmark = { toggleBookmark(postId = post.id) }
        )
    }
}
```

#### Interactive

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/mbgSttYf0hA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

#### Deploy Preview

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/Az95GG1VT84" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### Large Composable

```kotlin
@Composable
private fun HomeScreenBody(
    posts: List<Post>,
    ...
) {
    ...
    VerticalScroller(...) {
        HomeScreenTopSection(...)
        HomeScreenSimpleSection(...)
        HomeScreenPopularSection(...)
        HomeScreenHistorySection(...)
    }
}
```

#### Interactive

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/FdQdrQM-pJY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>  

#### Deploy Preview

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/djG3ZouNW8U" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### 참고

- compose-samples / JetNews : https://github.com/android/compose-samples/tree/master/JetNews