---
layout: post
title: "[Lint] Compose에서 Modifier가 필요한 케이스 Lint로 찾기"
date: 2024-08-03 14:00:00 +09:00
tag: [Android, Lint]
categories:
- blog
- Android
---

<!--more-->

------

Android에 Compose가 나온 이후 도입 사례들도 점차 늘고 있습니다.

그에 따라 Google에서 안내하는 기본 API 가이드라인을 지키고 있는지도 재검토하는 것도 중요합니다.

> API Guidelines for @Composable components in Jetpack Compose : https://github.com/androidx/androidx/blob/androidx-main/compose/docs/compose-component-api-guidelines.md

가이드라인을 잘 지키도록 Lint로도 제공하고 있습니다.

본 글에서는 필수 규칙이지만, Lint로는 미제공하는 케이스를 Lint로 만들어 보려고 합니다.

> Lint 초기 설정에 대해서는 생략합니다. 다음 링크를 참고해 주세요.
>
> https://github.com/googlesamples/android-custom-lint-rules

------

# modifier parameter

API 가이드라인의 [modifier parameter](https://github.com/androidx/androidx/blob/androidx-main/compose/docs/compose-component-api-guidelines.md#modifier-parameter) 섹션에는 몇 가지 규칙이 정의되어 있습니다. 또한 해당 내용은 private/internal보다는 정의된 Composable을 실제로 사용하는 것을 전제로 된 Composable에 더 적합한 내용입니다.

외부로 노출되는 UI 컴포넌트는 Modifier 파라미터를 가져야 합니다.

- Modifier 타입 파라미터가 있어야 한다.
- 첫 번째 Optional 파라미터이어야 한다.
- 기본 Modifier를 제공되어야 한다.
- 파라미터들에 있는 유일한 Modifier 파라미터이어야 한다.
- 컴포넌트 구현에서 가장 상위에 있는 레이아웃에 대한 체인의 첫 번째 Modifier로 한 번 사용되어야 한다.

위 모든 케이스가 Lint로 제공하고 있지는 않습니다.

# 기본 제공하는 Lint

> 다음 설명하는 Lint 내용의 구현은 [ModifierParameterDetector](compose/ui/ui-lint/src/main/java/androidx/compose/ui/lint/ModifierParameterDetector.kt) 코드로 확인할 수 있습니다.

## 1) Modifier 파라미터 이름은 `modifier`로 정의되어야 한다.

modifier대신 다른 이름을 사용한 모습

{% include img_assets.html id="/blog/2024/0803-compose-lint/03.png" %}

API 가이드라인에 맞게 수정된 모습

- Modifier 파라미터는 `modifier`라는 파라미터 이름을 사용

{% include img_assets.html id="/blog/2024/0803-compose-lint/04.png" %}

## 2) 첫 번째 Optional 파라미터이어야 한다.

Optional Modifier 파라미터를 첫 번째로 제공하지 않는 모습

{% include img_assets.html id="/blog/2024/0803-compose-lint/01.png" %}

API 가이드라인에 맞게 수정된 모습

- Optional 파라미터의 첫 번째 위치로 변경

{% include img_assets.html id="/blog/2024/0803-compose-lint/02.png" %}

## 3) 파라미터는 Modifier 타입이 여야 한다.

Modifier를 구현한 커스텀 Modifier인 경우의 모습

{% include img_assets.html id="/blog/2024/0803-compose-lint/05.png" %}

API 가이드라인에 맞게 수정된 모습

- CheckboxRow를 사용하는 곳에서 커스텀 Modifier를 주입해서 Lint 문제를 해결

{% include img_assets.html id="/blog/2024/0803-compose-lint/06.png" %}

## 4) Modifier 기본값은 기본 제공되는 Modifier이어야 한다.

Modifier대신 SampleModifier로 기본값을 제공한 모습

{% include img_assets.html id="/blog/2024/0803-compose-lint/07.png" %}

API 가이드라인에 맞게 수정된 모습

- 기본 제공하는 Modifier로 변경

{% include img_assets.html id="/blog/2024/0803-compose-lint/08.png" %}

# 미제공하는 Lint 케이스

API 가이드라인의 [modifier parameter](https://github.com/androidx/androidx/blob/androidx-main/compose/docs/compose-component-api-guidelines.md#modifier-parameter) 섹션에서 가장 첫 줄을 읽어보면 다음과 같이 정의되어 있습니다.

> Every component that emits UI should have a modifier parameter. 

외부로 제공하는 Composable 컴포넌트는 Modifier가 필수이어야 한다.

## ModifierParameterDetector로는 부족한 내용

[ModifierParameterDetector](https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui-lint/src/main/java/androidx/compose/ui/lint/ModifierParameterDetector.kt) Lint는 Modifier가 존재한 이후의 케이스만 처리하고 있습니다. 그래서 필수 Modifier 파라미터 체크는 안 하고 있습니다

```
override fun visitMethod(node: UMethod) {
   // Composable 함수가 아닌 경우 ignore
   if (!node.isComposable) return
   // Unit을 리턴하는 Composable 함수가 아닌 경우 ignore
   if (!node.returnsUnit) return

   // Modifier 파라미터가 없다면 ignore
   val modifierParameter =
      node.uastParameters.firstOrNull { parameter ->
         parameter.sourcePsi is KtParameter &&
            parameter.type.inheritsFrom(Names.Ui.Modifier)
      } ?: return
   ...
```

> https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui-lint/src/main/java/androidx/compose/ui/lint/ModifierParameterDetector.kt#L64-L68

## 커스텀으로 Lint 만들기

Modifier 파라미터가 필수인 케이스를 정리해 봅니다.

- Composable 함수일 것
- Preview인 경우는 ignore : Preview는 일반 용도와 다르므로 예외 대응
- Unit을 리턴할 것
- private이 아닐 것 : public/internal은 정의한 곳이 아닌 곳에서 사용가능하므로 미대응 케이스로 정의

기본적인 코드들은 AndroidX에 존재하는 기능을 사용하겠습니다.

### 1) Composable 함수일 것

```kotlin
val PsiMethod.isComposable
    get() = annotations.any { it.qualifiedName == Names.Runtime.Composable.javaFqn }
```

> 출처 : https://github.com/androidx/androidx/blob/androidx-main/compose/lint/common/src/main/java/androidx/compose/lint/ComposableUtils.kt#L101-L102

Composable 함수인지 판단하는 기준은 해당 함수에 정의된 annotation의 qualifiedName이 `androidx.compose.runtime.Composable`과 동일한지 체크하고 있습니다. 

### 2) Preview가 아닐 것

Composable Preview도 동일하게 Annotation으로 정의하고 있으므로 Composable 체크와 동일한 방법을 사용합니다

실제 Preview 케이스는 더 많지만, 여기서는 단순하게 `androidx.compose.ui.tooling.preview.Preview`를 체크합니다

### 3) Unit을 리턴할 것

```kotlin
val PsiMethod.returnsUnit
    get() = returnType.isVoidOrUnit

val PsiType?.isVoidOrUnit
    get() = this == PsiType.VOID || this?.canonicalText == "kotlin.Unit"
```

> 출처 : https://github.com/androidx/androidx/blob/androidx-main/compose/lint/common/src/main/java/androidx/compose/lint/PsiUtils.kt#L31-L42

### 4) private이 아닐 것

함수의 접근 제한자를 체크하기 위해서는 UMethod#modifierList에서 Private가 존재하는지만 체크하면 됩니다

```kotlin
override fun visitMethod(node: UMethod) {
   if (node.modifierList.hasModifierProperty(PsiModifier.PRIVATE)) return
   ...
}
```

### 5) Modifier가 존재하는가?

1~4단계를 거친 후 체크할 것은 파라미터에 Modifier 타입이 존재하는지 체크하면 됩니다.

```kotlin
val noneModifier = node.uastParameters.none { parameter ->
   parameter.sourcePsi is KtParameter &&
      parameter.type.inheritsFrom(Names.Ui.Modifier)
}

fun PsiType.inheritsFrom(name: Name) = InheritanceUtil.isInheritor(this, name.javaFqn)
```

## 완성된 Lint Detector

```kotlin
class RequiredModifierParameterDetector : Detector(), SourceCodeScanner {
   override fun getApplicableUastTypes() = listOf(UMethod::class.java)

   override fun createUastHandler(context: JavaContext) =
      object : UElementHandler() {
         override fun visitMethod(node: UMethod) {
            // Ignore non-composable functions
            if (!node.isComposable) return
            // Ignore composable preview functions
            if (node.isComposablePreview) return
            // Ignore non-unit composable functions
            if (!node.returnsUnit) return
            // Ignore private composable functions
            if (node.modifierList.hasModifierProperty(PsiModifier.PRIVATE)) return

            val noneModifier = node.uastParameters.none { parameter ->
               parameter.sourcePsi is KtParameter &&
                  parameter.type.inheritsFrom(Names.Ui.Modifier)
            }
            if (noneModifier) {
               val incident = Incident(context, ISSUE)
                  .message(message)
                  .at(node)
               context.report(incident)
            }
         }
      }

   companion object {
      private const val message = "public/internal Composable functions, the Modifier parameter is required."
      @JvmField
      val ISSUE = Issue.create(
         ...
      )
   }
}
```

| 체크할 코드                                                  | Lint 결과 모습                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| {% include img_assets.html id="/blog/2024/0803-compose-lint/09.png" %} | {% include img_assets.html id="/blog/2024/0803-compose-lint/10.png" %} |

의도대로 필요한 Composable 함수에서만 Lint 경고가 노출되는 모습을 볼 수 있습니다.