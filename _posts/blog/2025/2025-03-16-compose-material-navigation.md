---
layout: post
title: "Jetpack Compose Material Navigation"
date: 2025-03-16 12:00:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

Android 개발 시 Compose 사용이 늘어남에 따라 다양한 기능들이 요구되고 있습니다. 대표적인 것 중 하나가 Navigation입니다. 구글도 Compose navigation을 제공하고 있지만, 오늘은 Compose Navigation에서 BottomSheet에 관련된 케이스를 다뤄보겠습니다.

<!--more-->

Compose Navigation에서 BottomSheet 사용 시 많이 거론되는 것이 `Accompanist` 라이브러리입니다.

> Accompanist : https://google.github.io/accompanist/

Accompanist 라이브러리는 개발자에게 필요하지만, androidX 라이브러리로는 아직 미제공 중인 기능 그룹입니다. Jetpack Compose를 보완하는 것을 목표로 하고 있습니다

> 원문 : Accompanist is a group of libraries that aim to supplement [Jetpack Compose](https://developer.android.com/jetpack/compose) with features that are commonly required by developers but not yet available.

현재는 대부분의 기능은 AndroidX로 이전되거나 일부만 남아있습니다.

## Accompanist Navigation Material 소개

https://google.github.io/accompanist/navigation-material/

Accompanist Navigation Material은 Navigation 사용 시 BottomSheet를 연결하는 용도로 사용합니다. 아래 코드로도 알 수 있듯이 기존 XML 기반의 navigation에서 BottomSheet를 연결하는 것과 동일합니다.

```kotlin
NavHost(…) {
   bottomSheet(…) {
      // Composable content
   }
}
```

## Accompanist ➡️ Jetpack Compose Material Navigation

Accompanist의 Navigation Material은 AndroidX의 `androidx.compose.material.navigation`로 이전되었습니다. 

> AndroidX androidx.compose.material.navigation 1.7.0-alpha04부터 지원 : https://developer.android.com/jetpack/androidx/releases/compose-material#1.7.0-alpha04

### Jetpack Compose Material Navigation

Jetpack Compose Material Navigation로 이전되었지만, 대부분의 API 그대로 승계되었습니다. Accompanist Navigation Material을 사용하고 있다면 [Migration](https://google.github.io/accompanist/navigation-material/#migration)을 참고해주세요. 이로써 BottomSheet를 Jetpack Compose Navigation에서도 사용할 수 있습니다.

```kotlin
@Composable
fun BottomSheetNavDemo() {
   val bottomSheetNavigator = rememberBottomSheetNavigator()
   val navController = rememberNavController(bottomSheetNavigator)

   ModalBottomSheetLayout(bottomSheetNavigator) {
      NavHost(navController, ...) {
         bottomSheet(...) {
            ...
         }
      }
   }
}
```

> 샘플 코드 출처 : https://github.com/androidx/androidx/blob/androidx-main/compose/material/material-navigation/samples/src/main/java/androidx/compose/material/navigation/samples/ComposeMaterialNavigationSamples.kt

이전부터 Accompanist를 사용했다면 이전되었다는 것을 알지만, 아쉽게도 Jetpack으로 이전 후 공식 릴리즈 노트에서는 별다른 언급이 없습니다. 게다가 Compose BOM 사이트에서도 언급은 안되고 있습니다. 

> BOM to library version mapping : https://developer.android.com/develop/ui/compose/bom/bom-mapping

다행히 실제 Compose BOM을 관리하는 bom.pom파일에는 Compose Material Navigation(=androidx.compose.material.navigation) 내용이 포함되어 있으므로 사용에는 문제없습니다.

> Google maven repository : https://maven.google.com/web/m_index.html?q=bom#androidx.compose:compose-bom:2025.03.00

{% include img_assets.html id="/blog/2025/2025-03-16-compose-material-navigation/01.png" %}

그리고, 버전업에 맞춰서 API 변경도 진행되고 있습니다.

> https://github.com/androidx/androidx/tree/androidx-main/compose/material/material-navigation/api

### Material ✅

그럼 우리는 compose material navigation을 사용하면 될까요? 기존 Navigation 스펙과 동일하게 사용된다면 문제없습니다. 다만, Material 3를 사용하는 개발자에겐 예외입니다.

현재 compose material navigation의 build.gradle.kts 코드의 종속성을 찾아보면 기본 material를 참조하고 있습니다.

```
implementation(project(":compose:material:material"))
```

> 소스 출처 : https://github.com/androidx/androidx/blob/androidx-main/compose/material/material-navigation/build.gradle#L30

### Material 3 ❓

material 3 naviation 라이브러리도 제공하지 않을까? 하는 생각이 자연스럽게 떠오릅니다. 하지만 개발 시작한 지 얼마 안 된 코드들과 마주하게 됩니다. 게다가 2025.03.16 시점에는 릴리즈도 안 된 상태입니다. 이 경우에 해당한다면 다른 대안을 생각해 보셔야 합니다.

> 개발 중인 navigation3 : https://github.com/androidx/androidx/blob/androidx-main/navigation3/navigation3/androidx-navigation3-documentation.md

## 곧 deprecated될 운명??

Twitter/Reddit에서 deprecated되는 것이 아니냐라는 언급들이 보입니다.

<blockquote  class="twitter-tweet"><p lang="en"  dir="ltr">Navigation-Compose is effectively abandoned, and slated to  be deprecated when Navigation3 comes out. <a  href="https://twitter.com/hashtag/androiddev?src=hash&amp;ref_src=twsrc%5Etfw">#androiddev</a><br><br>Always  great to use those &quot;officially supported libraries&quot;  managed by another party &amp; another team, that will surely be  supported forever...<a  href="https://t.co/5f50BqWMIT">https://t.co/5f50BqWMIT</a>  <a  href="https://t.co/BuQtWwvJll">pic.twitter.com/BuQtWwvJll</a></p>&mdash;  Gabor Varadi (@Zhuinden) <a  href="https://twitter.com/Zhuinden/status/1897003798645936571?ref_src=twsrc%5Etfw">March  4, 2025</a></blockquote> <script async src="https://platform.twitter.com/widgets.js"  charset="utf-8"></script>

<blockquote class="reddit-embed-bq" style="height:316px" data-embed-height="316"><a href="https://www.reddit.com/r/androiddev/comments/1j38edm/migrate_fragments_transaction_to_compose/">migrate fragments transaction to compose navigation</a><br> by<a href="https://www.reddit.com/user/hulkdx/">u/hulkdx</a> in<a href="https://www.reddit.com/r/androiddev/">androiddev</a></blockquote><script async="" src="https://embed.reddit.com/widgets.js" charset="UTF-8"></script>

현 단계에서 **Jetpack Compose Material Navigation**은 어떤 방향으로 흘러갈지는 알 수 없습니다. 구글 또한 몇 가지의 기능들이 우선 개발되고 있을 테고, 아마도 최신 API와 Material 3의 우선순위가 높을 것입니다.

> 개인적으로는 Material 3가 Material의 지원 속도가 빠르며, 동일한 컴포넌트더라도 더 많은 기능을 제공하고 있으므로 **Material 3**의 우선순위가 높다고 판단했습니다.

## 정리

최근 트랜드와 구글의 기술 지원 덕분에 Compose가 기존 XML 대비 장점이 부각되고 있습니다. 다만, 기존 XML은 10년 이상 쌓인 기술/노하우와 라이브러리들이 존재합니다. 그에 비해 Compose는 기술 채용되는 속도에 비례하여 지원 속도가 아쉬운 상태입니다. 장기적으로 나아질 거라는 기대를 해봅니다.