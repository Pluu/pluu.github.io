---
layout: post
title: "[메모] AndroidX Compose BOM stable/beta/alpha 버전"
date: 2024-09-19 23:00:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

<!--more-->

------

## Compose BOM stable/beta/alpha 버전

드디어 Stable만 지원하던 Compose BOM도 alpha/beta를 지원하기 시작했다.

정의는 매우 간단하다. BOM artifact 이름에 alpha/beta를 추가하면 된다.

```kotlin
dependencies {
   // Specify the Compose BOM with a version definition
   val composeBom = platform("androidx.compose:compose-bom-alpha:2024.09.00")
   //            or platform("androidx.compose:compose-bom-beta:2024.09.00")
   implementation(composeBom)
   // ..
}
```

> 원본 소스 : https://developer.android.com/develop/ui/compose/bom?hl=en#what_if_i_want_to_try_out_alpha_or_beta_releases_of_compose_libraries

## 버전별 내용

공식 문서에는 각 버전이 담당하는 범위에 관해서 설명하고 있다

- Stable : 각 라이브러리의 최신 Stable 버전
- Beta : 각 라이브러리의 최신 Beta 또는 Stable 버전
- Alpha : 각 라이브러리의 최신 Alpha 또는 Beta 또는 Stable 버전

## 상세 버전 체크

Compose의 각 버전별 정보 정의는 androidx [compose 릴리즈 문서](https://developer.android.com/jetpack/androidx/releases/compose?hl=en#versions)를 통해서 확인할 수 있다.

또한 `Google's Maven Repository`를 통해서 BOM마다 어떤 라이브러리와 버전이 정의되었는지 확인할 수 있다.

- [Stable repository](https://maven.google.com/web/index.html?q=compose-bom#androidx.compose:compose-bom)
- [Beta repository](https://maven.google.com/web/index.html?q=compose-bom#androidx.compose:compose-bom-beta)
- [Alpha repository](https://maven.google.com/web/index.html?q=compose-bom#androidx.compose:compose-bom-alpha)

상세한 정의를 확인하고 싶다면 Google's Maven Repository가 정답이다.

## 참고

Ian Lake의 트위터 내용

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Starting with today&#39;s Compose BOM 2024.09.02, there are now three separate artifacts (avoiding Gradle&#39;s suggestions to &#39;upgrade&#39;):<br>1) compose-bom: latest stable releases<br>2) compose-beta: latest beta or stable<br>3) compose-alpha: latest alpha, beta, or stable<a href="https://t.co/8XvScDTofJ">https://t.co/8XvScDTofJ</a></p>&mdash; Ian Lake (@ianhlake) <a href="https://twitter.com/ianhlake/status/1836519888778858760?ref_src=twsrc%5Etfw">September 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
