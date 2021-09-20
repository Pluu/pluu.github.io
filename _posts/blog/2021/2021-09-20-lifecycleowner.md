---
layout: post
title: "RecyclerView#ViewHolder에서 ViewTreeLifecycleOwner 사용법"
date: 2021-09-20 14:50:00 +09:00
tag: [Android, AndroidX, Lifecycle]
categories:
- blog
- Android
---

본 글은 AndroidX Lifecycle에 존재하는 ViewTreeLifecycleOwner API를 RecyclerView에서 사용하는 방법에 대해서 소개하는 글입니다.

<!--more-->

> 본 글에서는 자세한 내용은 생략합니다. 
>
> ViewTreeLifecycleOwner에 대한 기본 내용은 이전 "[AndroidX Lifecycle ~ ViewTreeLifecycleOwner/ViewTreeViewModelStoreOwner](http://pluu.github.io/blog/android/2020/12/21/viewtreelifecycle/)" 글을 참고해주세요.

- - -

`ViewTreeLifecycleOwner` API를 사용해 보신 분들이라면, **RecyclerView.Adapter#onBindViewHolder**에서 RecyclerView#ViewHolder의 결과가 아래와 같이 `null`이 반환되는 경험을 했을 겁니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/001.png" }}" />

해당 현상이 발생하는 이유와 해결법에 대해서 살펴보겠습니다.

**사전 조건**

ViewTreeLifecycleOwner를 Activity/Fragment에서 사용하려면 아래 Component보다 높은 버전을 사용해야 합니다.

- Activity 1.2.0-alpha05
- Fragment 1.3.0-alpha05
- AppCompat 1.3.0-alpha01
- Lifecycle 2.3.0-alpha03

## 가볍게 살펴보는 ViewTreeLifecycleOwner

Android에는 생명주기 개념을 가지는 Component로 `Activity`/`Fragment`가 있습니다. 그리고, 생명주기를 다룬다는 정의를 [LifecycleOwner](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner) 인터페이스를 통해서 선언하고 있습니다.

```java
public interface LifecycleOwner {
    @NonNull
    Lifecycle getLifecycle();
}
```

> 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-common/src/main/java/androidx/lifecycle/LifecycleOwner.java

AndroidX에는 ComponentActivity와 Fragment에서 LifecycleOwner 인터페이스를 구현하고 있습니다. 그래서, 해당 Component에서는 직접 getLifecycle() 함수를 통해서 직접 생명주기를 다룰 수 있습니다.

#### 코드 분리

리팩토링 등으로 Activity/Fragment에 코드는 없지만, Activity/Fragment의 LifecycleOwner 인터페이스에 접근해야 할 경우가 있습니다. 이때 유용한 API가 바로 `ViewTreeLifecycleOwner`입니다. 그리고, LifecycleOwner는 [ViewTreeLifecycleOwner.get](https://developer.android.com/reference/androidx/lifecycle/ViewTreeLifecycleOwner#get(android.view.View)) 혹은 [View.findViewTreeLifecycleOwner](https://developer.android.com/reference/kotlin/androidx/lifecycle/package-summary#findviewtreeviewmodelstoreowner) KTX를 통해서 가져올 수 있습니다.

```kotlin
public fun View.findViewTreeLifecycleOwner(): LifecycleOwner? = ViewTreeLifecycleOwner.get(this)
```

> 출처 : https://github.com/androidx/androidx/blob/androidx-main/lifecycle/lifecycle-runtime-ktx/src/main/java/androidx/lifecycle/View.kt

## RecyclerView#ViewHolder에서는?

생명주기에 맞춘 핸들링은 Activity/Fragment뿐만 아니라 경우에 따라서 View가 존재하는 어느 곳이더라도 필요할 수도 있습니다. View#findViewTreeLifecycleOwner KTX를 사용하면 쉽게 LifecycleOwner를 가져올 수 있다는 것을 이미 알고 있습니다.

RecyclerView#onBindViewHolder에서도 ViewHolder의 itemView를 사용하면 당연히 LifecycleOwner가 반환될 것이라고 기대할 것입니다. 그러나 결과는 `null`을 반환합니다. 왜일까요?

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/001.png" }}" />

### 탐색 1. ViewTreeLifecycleOwner

먼저 살펴봐야 할 것은 `ViewTreeLifecycleOwner#get`입니다. findViewTreeLifecycleOwner KTX 또한 ViewTreeLifecycleOwner#get을 호출하고 있으므로 LifecycleOwner를 가져오는 핵심 코드입니다.

```java
public class ViewTreeLifecycleOwner {
   @Nullable
   public static LifecycleOwner get(@NonNull View view) {
      LifecycleOwner found = (LifecycleOwner) view.getTag(R.id.view_tree_lifecycle_owner);
      if (found != null) return found;
      ViewParent parent = view.getParent();
      while (found == null && parent instanceof View) { // View#getParent가 유효한지 체크
         final View parentView = (View) parent;
         found = (LifecycleOwner) parentView.getTag(R.id.view_tree_lifecycle_owner);
         parent = parentView.getParent();
      }
      return found;
   }  
}
```

기본 동작은 View#getParent를 반복적으로 호출하면서 `LifecycleOwner` 가 존재하는지 체크하는 형태입니다. 

이어서 RecyclerView.Adapter#onBindViewHolder에서 View#getTag와 View#getParent를 확인해 봅니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/002.png" }}" />

당연히 View#getTag를 통한 LifecycleOwner는 null입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/003.png" }}" />

그러나, ViewHolder에서 View에 해당하는 itemView의 parent는 `null`이라고 출력됩니다.

`ViewTreeLifecycleOwner#get` 로직이 기억나시나요? 내부적으로 View#getParent를 호출하면서 LifecycleOwner가 존재하는 객체를 찾지만, 여기에서는 parent가 null이므로 최종적으로 null로 반환합니다.

**원인은 ViewHolder가 가리키는 View의 `부모 View가 null`이기 때문입니다.**

### 탐색 2. RecyclerView의 이해

RecyclerView 사용 시에 onCreateViewHolder를 통해서 View가 생성되고, onBindViewHolder를 통해서 값을 반영하는 코드라는 것을 알고 있습니다. 

그런데 onBindViewHolder 단계에서 ViewHolder의 View는 RecyclerView에 Add되었을까요? ViewHolder의 itemView는 Attach되었을까요?

**`정답은 NO`**입니다. 그러면 언제 RecyclerView에 add 되는 것일까요?

**최초 ViewHolder를 생성**한 경우의 RecyclerView.Adapter에서는 아래의 순서로 처리됩니다.

1. onCreateViewHolder
2. onBindViewHolder
3. [onViewAttachedToWindow](https://developer.android.com/reference/androidx/recyclerview/widget/RecyclerView.Adapter#onAttachedToRecyclerView(androidx.recyclerview.widget.RecyclerView))

즉, ViewHolder는 onBindViewHolder 시점이 되더라도 RecyclerView에 add 되지 않은 상태입니다. `onViewAttachedToWindow`가 호출되어야 ViewHolder가 add 되었다는 것을 알 수 있습니다.

이제 RecyclerView.Adapter#onBindViewHolder에서 parent가 null로 반환했던 것과 findViewTreeLifecycleOwner 결과의 이유를 알았습니다.

#### RecyclerView#ViewHolder의 생명주기

Google I/O 2016의 **RecyclerView ins and outs**세션에서 더 자세한 내용을 다루고 있습니다. 

<iframe width="560" height="315" src="https://www.youtube.com/embed/LqBlYJTfLP4?start=1042" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### 탐색 3. onViewAttachedToWindow에서의 확인

이제 RecyclerView.Adapter#onViewAttachedToWindow에서도 동일하게 살펴봅니다. 여기에서는 기대했던 결과가 반환됩니다.

- ViewHolder의 itemView의 parent가 RecyclerView로 지정됨 (RecyclerView의 child로 add 됨)
- parent가 존재하므로 findViewTreeLifecycleOwner API 결과로 유효한 LifecycleOwner가 반환

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/004.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/005.png" }}" />

## Goal. 정답은 View가 `Attach된 이후 `

앞서 RecyclerView.ViewHolder를 통한 LifecycleOwner 탐색 시 2가지 사실을 알았습니다.

1. ViewTreeLifecycleOwner#get에서 parent를 반복적으로 호출하면서 LifecycleOwner를 소유하는 객체를 찾음
2. RecyclerView.Adapter#onBindViewHolder 단계에서는 RecyclerView의 child로 추가되지 않음

LifecycleOwner를 얻는 시점을 RecyclerView.Adapter#onViewAttachedToWindow에서 다룰 수도 있지만, 매번 Adapter에서 ViewHolder에 LifecycleOwner를 주입하는 코드는 놓치기 쉬운 코드이며 모든 ViewHolder에서는 필요한 경우는 드뭅니다. 

대신 ViewHolder의 초기화 단계(init)에서 `View#doOnAttach` KTX 함수를 사용하면 ViewHolder에서 코드를 작성할 수 있습니다. 결과로 간단하게 View가 Attach된 이후에 ViewTreeLifecycleOwner#get API를 사용할 수 있습니다.

```kotlin
class ViewHolder(
   private val binding: ItemRecyclerViewSampleBinding
) : RecyclerView.ViewHolder(binding.root) {
   private var lifecycleOwner: LifecycleOwner? = null
  
   init {
      itemView.doOnAttach {
         lifecycleOwner = itemView.findViewTreeLifecycleOwner()
      }
      itemView.doOnDetach {
         lifecycleOwner = null
      }
   }
}    
```

**RecyclerView에서 사용해 본 결과**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0920-lifecycleowner/006.png" }}" width="50%" />

> 본 글에 사용된 샘플 코드는 다음 링크를 참조해주세요.
>
> https://github.com/Pluu/ViewTreeOwnerSample
