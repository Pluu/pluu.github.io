---
layout: post
title: "[DataBinding] 중복으로 BindingAdapter가 생성되는 문제 코드"
date: 2024-03-23 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

Kotlin과 [DataBinding](https://developer.android.com/topic/libraries/data-binding)의 [Binding adapter](https://developer.android.com/topic/libraries/data-binding/binding-adapters) 사용 시 일부 문제가 발생하는 케이스를 공유합니다.

> DataBinding의 [Binding adapter](https://developer.android.com/topic/libraries/data-binding/binding-adapters)에 대해서는 본 글에서는 생략합니다.



DataBinding 사용 시 XML에서 View와 특정 값을 연결하기 위해서 Binding Adapter은 필수입니다. Binding Adapter를 사용하는 방법으로 크게 아래 3가지로 나뉩니다.

1. 라이브러리에서 기본 제공하는 Binding Adapter를 사용
1. View에 오픈된 set/get 함수를 통하여 자동으로 Binding Adapter 매칭하여 사용
1. [BindingAdapter](https://developer.android.com/reference/android/databinding/BindingAdapter) annotation를 추가하여 맞춤형 Binding Adapter 사용

> 기본 제공되는 Binding Adapter : https://android.googlesource.com/platform/frameworks/data-binding/+/refs/heads/mirror-goog-studio-master-dev/extensions/baseAdapters/src/main/java/androidx/databinding/adapters

## 문제 코드

문제가 되는 코드는 BindingAdapter annotation을 사용하는 경우입니다. 공식 가이드에서는 `BindingAdapter` 정의를 어디에 하라고 명시하고 있지 않습니다. 그래서 View 내부 companion object에서 정의도 가능합니다.

companion object + JvmStatic + BindingAdapter 조합으로 선언하면, IDE는 빌드 시 경고 문구를 출력합니다.

```kotlin
class SampleView : View(...) {
   ...
   companion object {
      @JvmStatic
      @BindingAdapter("test")
      fun setTest(view: View, value: Int) {
         // TBD
      }
   }
}
```

{% include img_assets.html id="/blog/2024/0323-databinding/01.png" %}

출력된 로그를 봤을 때 Binding Adapter가 재정의된다고 출력하고 있습니다. 이 상태이더라도 동작에는 문제가 없습니다. 해당 코드가 발생하는 이유를 보려면 Kotlin 코드가 생성되는 Java 코드를 살펴봐야 합니다. 

Android Studio의 Tools - Kotlin - Show Kotlin Bytecode로 Kotlin Bytecode 메뉴를 활성화한 후 `Decompile`로 생성된 Java 코드를 볼 수 있습니다.

{% include img_assets.html id="/blog/2024/0323-databinding/02.png" %}

`companion object` 사용으로 싱글톤 접근하는 함수가 생성되는데, 이때 BindingAdapter Annotation도 같이 생성된 모습을 볼 수 있습니다. Android Studio는 컴파일된 코드 기준으로 빌드를 진행하므로 BindingAdapter가 2개가 선언되었다고 탐지합니다.

- SampleView의 static setText 함수
- SampleView 내부 Companion의 setText 함수

결과적으로 IDE는 중복으로 정의되었다고 판단하게 됩니다.

## 정상 코드

중복 코드가 생성되는 않는 몇 개의 패턴이 있습니다.

(1) class내 companion object 내에서는 JvmStatic을 사용하지 않음

```kotlin
class SampleView @JvmOverloads constructor(
   ...
) : View(context, attrs, defStyle) {

   companion object {
      @BindingAdapter("test")
      fun setTest(view: View, padding: Int) {
         // TBD
      }
   }
}
```

(2) 별도 Binding Adapter에서 정의

```kotlin
object ViewBindingAdapter {
   @JvmStatic
   @BindingAdapter("test1")
   fun setTest1(view: View, value: Int) {
      // TBD
   }

   @BindingAdapter("test2")
   fun setTest2(view: View, value: Int) {
      // TBD
   }
}
```

(3) 최상위 함수로 정의

```kotlin
@BindingAdapter("test3")
fun setTest3(view: View, value: Int) {
   // TBD
}
```

## 참고

- [Defining Android Binding Adapter in Kotlin](https://medium.com/@hkhcheung/defining-android-binding-adapter-in-kotlin-b08e82116704)
