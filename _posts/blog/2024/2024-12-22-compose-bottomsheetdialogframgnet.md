---
layout: post
title: "[메모] BottomSheetDialogFragment에서 Compose 사용 시 스크롤 체크"
date: 2024-12-22 14:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

Compose를 부분 적용하는 케이스 중 하나는 BottomSheetDialogFragment에서 View만 Compose로 바꾸는 케이스이다.

<!--more-->

------

샘플 코드 : [링크](https://github.com/Pluu/ComposeBottomSheetFragmentSample)

------

## 동작 체크

{% include youtube.html id="xiMbNfqjLxg" %}

스크롤 시 어색하지 않다고 보였다면, 작은 차이가 존재한다. 문제는 기본적으로 아래 2가지의 케이스가 있다.

1. BottomSheet 노출 후 위로 스크롤 시 자연스럽게 스크롤 되지 않고, 0에 걸쳤을 때 더 이상 스크롤이 안된다
2. 일부 컨텐츠를 스크롤한 후 아래로 스크롤 시 0까지 스크롤 되지 않은 상태로 BottomSheet가 내려온다

## 문제의 테스트 코드

동작 체크에 사용한 코드는 아래와 같다.

- BottomSheetDialogFragment + ComposeView + LazyColumn 조합

```kotlin
class ComposeItemListDialogFragment : BottomSheetDialogFragment() {
   override fun onCreateView(
      inflater: LayoutInflater, container: ViewGroup?,
      savedInstanceState: Bundle?
   ): View = content {
      SampleTheme {
         Greeting((0..100).toList())
      }
   }
}

@Composable
fun Greeting(list: List<Int>) {
   LazyColumn(
      contentPadding = PaddingValues(vertical = 8.dp)
   ) {
      items(items = list) {
         Text(
            text = it.toString(),
            fontSize = 20.sp,
            modifier = Modifier
               .fillMaxWidth()
               .padding(horizontal = 16.dp, vertical = 8.dp)
         )
      }
   }
}
```

전체 코드를 보면 특별한 문제는 없어 보일 수 있다.

## 문제 해결

해당 동작의 원인은 BottomSheetDialogFragment의 스크롤과 LazyColumn의 스크롤이 중첩으로 사용해서 발생하는 이슈이다. 기본적으로 BottomSheetDialogFragment은 스크롤이 암시적으로 존재한다.

이 문제의 해결 방법은 [nestedScroll()](https://developer.android.com/reference/kotlin/androidx/compose/ui/input/nestedscroll/package-summary#(androidx.compose.ui.Modifier).nestedScroll(androidx.compose.ui.input.nestedscroll.NestedScrollConnection,androidx.compose.ui.input.nestedscroll.NestedScrollDispatcher))에 [rememberNestedScrollInteropConnection](https://developer.android.com/reference/kotlin/androidx/compose/ui/platform/package-summary#rememberNestedScrollInteropConnection())을 사용하면 된다.

```kotlin
LazyColumn(
   modifier = Modifier.nestedScroll(rememberNestedScrollInteropConnection()),
   ...
) {
   ...
}
```

이 문제의 해결법은 이미 Android Develoepr 사이트의 Compose 가이드에도 존재한다.

- [중첩 스크롤 상호 운용성](https://developer.android.com/develop/ui/compose/touch-input/pointer-input/scroll?hl=ko#nested_scrolling_interop)

그중에서 CoordinatorLayout가 이번 이슈의 주요 이슈 항목이다. 그런데 왜 BottomSheetDialogFragment와 무슨 상관이 있는지 이해가 안 될 수 있다.

### BottomSheetDialogFragment의 구조 체크

BottomSheetDialogFragment를 노출한 상태에서 Layout Inspector로 View 구조를 체크하면 아래와 같다.

{% include img_assets.html id="/blog/2024/1222-compose/view_tree.png" %}

design_bottom_sheet은 coordinatorLayout 하위에 있다.

### BottomSheetDialogFragment 소스 체크

BottomSheetDialogFragment는 기본적으로 AppCompatDialogFragment를 상속하지만, Material의 [BottomSheetDialog](https://developer.android.com/reference/com/google/android/material/bottomsheet/BottomSheetDialog)를 사용하고 있다.

```java
public class BottomSheetDialogFragment extends AppCompatDialogFragment {
  ...

  @NonNull
  @Override
  public Dialog onCreateDialog(@Nullable Bundle savedInstanceState) {
    return new BottomSheetDialog(getContext(), getTheme());
  }
  
  ...
}
```

> 소스 출처 : [BottomSheetDialogFragment.java](https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/bottomsheet/BottomSheetDialogFragment.java#L52-L56)



BottomSheetDialog는 AppCompatDialog를 상속했으며, [design_bottom_sheet_dialog.xml](https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/bottomsheet/res/layout/design_bottom_sheet_dialog.xml)으로 View를 inflate하고 있다.

```java
public class BottomSheetDialog extends AppCompatDialog {
  ...
  @Override
  public void setContentView(View view) {
    super.setContentView(wrapInBottomSheet(0, view, null));
  }
  
  /** Behavior를 찾기 위해 Container layout을 생성 */
  private FrameLayout ensureContainerAndBehavior() {
    if (container == null) {
      container =
          (FrameLayout) View.inflate(getContext(), R.layout.design_bottom_sheet_dialog, null);
      ...
    }
    return container;
  }
  
  private View wrapInBottomSheet(
      int layoutResId, @Nullable View view, @Nullable ViewGroup.LayoutParams params) {
    ensureContainerAndBehavior();
    ...
    return container;
  }
}
```

> 소스 출처 : [BottomSheetDialog.java](https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/bottomsheet/BottomSheetDialog.java)

design_bottom_sheet_dialog.xml에는 [CoordinatorLayout](https://developer.android.com/reference/androidx/coordinatorlayout/widget/CoordinatorLayout)가 존재하며, 자식 뷰로 design_bottom_sheet id를 가지는 FrameLayout이 존재한다. 해당 ID의 자식 뷰로 실제 사용자가 추가하려는 View가 추가되는 구조이다.

```xml
<FrameLayout ...>
  <androidx.coordinatorlayout.widget.CoordinatorLayout
      android:id="@+id/coordinator"
      ...>
    ...

    <FrameLayout
        android:id="@+id/design_bottom_sheet"
        .../>

  </androidx.coordinatorlayout.widget.CoordinatorLayout>
</FrameLayout>
```

> 소스 출처 : [design_bottom_sheet_dialog.xml](https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/bottomsheet/res/layout/design_bottom_sheet_dialog.xml)



bottomSheet#addView로 넘겨지는 View가 ComposeView이고 내부 Content는 샘플로 만들 Composable인 것을 볼 수 있다.

{% include img_assets.html id="/blog/2024/1222-compose/BottomSheetDialog.png" %}

## 전체 동작 체크

아래는 기존 View, 오동작하는 Compose, 스크롤 이슈가 해결된 Compose의 모습이다.

{% include youtube.html id="cOfrHLplHLE" %}
