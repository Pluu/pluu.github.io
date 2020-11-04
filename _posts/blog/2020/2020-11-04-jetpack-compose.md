---
layout: post
title: "Jetpack Compose 공부 ~ 2주차"
date: 2020-11-04 23:30:00 +09:00
tag: [Android, AndroidX, Compose]
categories:
- blog
- Android
---

본 글은 개인적으로 Jetpack AndroidX Compose의 스터디한 내용을 정리하는 아카이브용입니다.

<!--more-->

`지극히 개인적인` 의견입니다.

- - -

테스트 전제 조건

- Android Studio 4.2 Canary 15
- Jetpack Compose 1.0.0-alpha06

- - -

실험하는 소스 : https://github.com/Pluu/WebToon/compare/develop-compose

- - -

### 1. Jetpack Compose Release

Jetpack Compose 1.0.0-alpha06 Update

### 2. Image 로딩시 도움되는 라이브러리 (0.3.2 출시)

- 이미지 로딩 라이브러리 : https://github.com/chrisbanes/accompanist
   - `Glide`는 추가 됨

### 3. PreferenceFragmentCompat 를 대체하기 좋은 것은 무엇일까?

#### 유지한다

- Jetpack Compose 내부 샘플
- https://github.com/androidx/androidx/blob/androidx-master-dev/compose/integration-tests/demos/src/main/java/androidx/compose/integration/demos/DemoSettingsActivity.kt#L49

```kotlin
class SettingsFragment : PreferenceFragmentCompat() {
    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        val context = preferenceManager.context
        val screen = preferenceManager.createPreferenceScreen(context)

        val general = PreferenceCategory(context).apply {
            title = "General options"
            screen += this
        }

        general += Preference(context).apply {
            title = "Shuffle all colors"
            onPreferenceClickListener = Preference.OnPreferenceClickListener {
                generateRandomPalette().saveColors(context)
                requireActivity().finish()
                true
            }
        }
 	  ...
    }
}
```

#### XML 키에 해당하는 모든 값들을 Compose로 대체 

- Custom Preference
  - 기본 구조 Diff : https://github.com/Pluu/WebToon/compare/507f4b2...14894fc
- 적용하기 : https://github.com/Pluu/WebToon/compare/14894fc...77e09c4#diff-cf54714a1a0be7d082bdaa282764d5c9593f7be96a99c4fcbc52e3ae77508f2cR92
  - Providers를 통해서 Ambient 전달 : https://github.com/Pluu/WebToon/compare/14894fc...77e09c4#diff-cf54714a1a0be7d082bdaa282764d5c9593f7be96a99c4fcbc52e3ae77508f2cR67
  - Providers를 통해서 값 사용 : https://github.com/Pluu/WebToon/compare/14894fc...77e09c4#diff-cf54714a1a0be7d082bdaa282764d5c9593f7be96a99c4fcbc52e3ae77508f2cR82

```kotlin
@Composable
fun Preference(
    modifier: Modifier = Modifier,
    asset: ImageAsset? = null,
    title: String,
    summary: String? = null
) {
    // 기본 Preference 정의
}

@Composable
fun Preference(
    modifier: Modifier = Modifier,
    asset: VectorAsset? = null,
    title: String,
    summary: String? = null
) {
    // 기본 Preference 정의
}
```

### 4. minHeight / minWidth

`Modifie.sizeIn`으로 해결

>  Link : https://developer.android.com/reference/kotlin/androidx/compose/foundation/layout/package-summary#sizein_1

### 5. 코드에서 StatusBar 색상 변경

- 기존에는  `setStatusBarColor`  를 통해서 변경

### 6. 😭😭😭 ImageView의 AdjustViewBounds 에 매칭되는 처리를 못찾음 😭😭😭

이미지 높이가 가변인 경우, `AdjustViewBounds` 를 true로 지정한다.

### 7. z-index 가 필요한 경우

ZIndexModifier

> Link : https://developer.android.com/reference/kotlin/androidx/compose/ui/ZIndexModifier

### 8. px to dp

```kotlin
val dpValue = with(DensityAmbient.current) { 1.toDp() }
```

> Link : https://developer.android.com/reference/kotlin/androidx/compose/ui/unit/Density#todp

### 9. Transition, Animation

- ANIMATING VISIBILITY IN COMPOSE : http://bentrengrove.com/blog/2020/11/2/animating-visibility-in-compose

### 10. Etc

- tapGestureFilter : https://developer.android.com/reference/kotlin/androidx/compose/ui/gesture/package-summary