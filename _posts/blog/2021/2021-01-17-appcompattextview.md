---
layout: post
title: "AppComapt ~ TextViewCompoundDrawablesXmlDetector"
date: 2021-01-18 23:00:00 +09:00
tag: [Android, AndroidX, AppCompat]
categories:
- blog
- Android
---

본 글은 AndroidX AppComapt 1.2.0-beta01부터 추가된 TextViewCompoundDrawablesXmlDetector Lint를 다루며 해당 Lint를 사용해도 안전할지  AndroidX 내부를 살펴본 글입니다.

<!--more-->

AndroidX에는 안드로이드 개발 시에 과거 버전과 호환성 유지를 위해 각 라이브러리에서 주로 작업이 이루어집니다. 그리고 많은 부분을 담당하는 것이 바로 `AppComapt`입니다. Artifact 이름을 보고 알 수 있듯이 `호환성` 유지를 목적으로 만들어진 AndroidX 라이브러리입니다. 

> 공식 사이트에서는 아래와 같은 설명이 기재되어 있습니다.
>
> Allows access to new APIs on older API versions of the platform (many using Material Design)
>
> 출처 : https://developer.android.com/jetpack/androidx/releases/appcompat

작성 일자인 2021.01.16 기준으로 AppCompat의 버전은 아래와 같습니다.

- Stable : 1.2.0
- Beta : 1.3.0-beta01

## TextViewCompoundDrawablesXmlDetector

안드로이드 버전이 업데이트하면서 TextView에 추가된 API로는 Relative Drawable, Tint, 폰트 등이 존재합니다. 그리고 AppCompat에서는 AppCompatTextView가 호환성을 담당합니다. 그중에서 **Drawable**과 관련된 API에 대한 Lint가 TextViewCompoundDrawablesXmlDetector입니다. 해당 Lint는 `AppComapt 1.2.0-beta01` 버전에 들어간 Lint입니다. 

> 출처 : https://developer.android.com/jetpack/androidx/releases/appcompat#1.2.0-beta01

### 무엇을 탐지하는가?

Drawable을 체크하는 Lint는 어떤 것을 체크할까요? AppCompat 1.2.0-beta01 릴리즈 노트에서 힌트를 얻을 수 있습니다.

> Using compound drawables and tinting on text views: suggests using compat attributes and APIs for backward compatibility

즉, TextView에서의 `CompoundDrawable`과 `Tint` 속성이 체크 대상입니다.

### Lint 동작 확인

아래 샘플에서는 CompoundDrawable에 대한 속성을 확인해보겠습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0118-lint/origin.png" }}" /> 

위 샘플 코드와 확인된 팝업 내용을 봤을 때 TextViewCompoundDrawablesXmlDetector Lint는 android:drawableXXX 속성을 `app:drawableXXXCompat`으로 제안합니다. 각 속성을 결과에 맞게 수정할 경우 아래와 같이 수정됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2021/0118-lint/compat.png" }}" /> 

### Lint 내부 코드 확인

TextViewCompoundDrawablesXmlDetector Lint는 `Layout` 파일에서 `TextView`의 속성들만 체크합니다. 해당 Lint에는 총 8개의 속성을 Compat 형태로 변경을 추천합니다.

- drawableLeft
- drawableRight
- drawableTop
- drawableBottom
- drawableStart
- drawableEnd
- drawableTint
- drawableTintMode

```kotlin
@Suppress("UnstableApiUsage")
class TextViewCompoundDrawablesXmlDetector : LayoutDetector() {
   companion object {
      internal val ATTRS_MAP = mapOf(
         "drawableLeft" to "drawableLeftCompat",
         "drawableRight" to "drawableRightCompat",
         "drawableTop" to "drawableTopCompat",
         "drawableBottom" to "drawableBottomCompat",
         "drawableStart" to "drawableStartCompat",
         "drawableEnd" to "drawableEndCompat",
         "drawableTint" to "drawableTint",
         "drawableTintMode" to "drawableTintMode"
      )
      ...
   }

   override fun getApplicableElements(): Collection<String>? = listOf("TextView")

   override fun visitElement(context: XmlContext, element: Element) {
      // ATTRS_MAP에 첫 번째 속성에 매칭되는 경우에만 Report를 생성
      for ((from, to) in ATTRS_MAP) {
         if (!element.hasAttributeNS(SdkConstants.ANDROID_URI, from)) {
            continue
         }
         context.report(
            NOT_USING_COMPAT_TEXT_VIEW_DRAWABLE_ATTRS,
            element,
            context.getLocation(element.getAttributeNodeNS(SdkConstants.ANDROID_URI, from)),
            "Use `app:$to` instead of `android:$from`",
            LintFix.create().composite(
               LintFix.create().set(
                  SdkConstants.AUTO_URI, to,
                  element.getAttributeNS(SdkConstants.ANDROID_URI, from)
               ).build(),
               LintFix.create().unset(SdkConstants.ANDROID_URI, from).build()
            )
         )
      }
   }
}
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat-lint/src/main/kotlin/androidx/appcompat/widget/TextViewCompoundDrawablesXmlDetector.kt



## 그럼 안전하게 사용해도 될까?

대부분 Lint에서 추천하는 수정은 적용해도 큰 문제는 없지만 경우에 따라서 추가 수정이 필요할 수도 있습니다. 그렇다면 `CompoundDrawable` 관련 Lint는 괜찮을까요? 우리는 개발자이므로 코드로 동작을 확인하겠습니다. 

해당 내용에 들어가기 전, 한 가지 살펴볼 사항이 있습니다. 

### ViewInflater ★★★★★

여러분은 XML과 코드에서 사용한 View가 Theme마다 다른 View로 매칭된다는 사실을 알고 계신가요? 기본, AppCompat, Material Components 테마마다 다른 View가 매칭됩니다. TextView의 경우 아래와 같이 매칭됩니다.

| Theme | AppCompat | Material Components |
| -------- | -------- | -------- |
| TextView | TextView<br />ㄴ [AppCompatTextView](https://developer.android.com/reference/androidx/appcompat/widget/AppCompatTextView) | TextView<br />ㄴ [AppCompatTextView](https://developer.android.com/reference/androidx/appcompat/widget/AppCompatTextView)<br />ㄴ [MaterialTextView](https://developer.android.com/reference/com/google/android/material/textview/MaterialTextView?hl=en) |

그리고 뷰 생성을 위해 다루는 LayoutInflater 내부에서는 각 테마마다 고유의 `ViewInflater`를 이용하여 View를 생성합니다. AppCompat, Material Components 테마에서 사용되는 ViewInflater 다음과 같습니다.

| Theme | AppCompat                                                    | Material Components                                          |
| ----- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| -     | [AppCompatViewInflater](https://developer.android.com/reference/androidx/appcompat/app/AppCompatViewInflater) | [AppCompatViewInflater](https://developer.android.com/reference/androidx/appcompat/app/AppCompatViewInflater)<br />ㄴ [MaterialComponentsViewInflater](https://developer.android.com/reference/com/google/android/material/theme/MaterialComponentsViewInflater) |

각 ViewInflater의 TextView 생성에는 다음과 같은 코드 블록이 실행됩니다.

**AppCompatViewInflater**

- Document : https://developer.android.com/reference/androidx/appcompat/app/AppCompatViewInflater

```java
public class AppCompatViewInflater {
   @NonNull
   protected AppCompatTextView createTextView(Context context, AttributeSet attrs) {
      return new AppCompatTextView(context, attrs);
   }
}
```

> 출처 : https://android.googlesource.com/platform/frameworks/support/+/refs/heads/androidx-appcompat-release/appcompat/appcompat/src/main/java/androidx/appcompat/app/AppCompatViewInflater.java

**MaterialComponentsViewInflater**

- Document : https://developer.android.com/reference/com/google/android/material/theme/MaterialComponentsViewInflater

```java
public class MaterialComponentsViewInflater extends AppCompatViewInflater {
   @NonNull
   @Override
   protected AppCompatTextView createTextView(Context context, AttributeSet attrs) {
      return new MaterialTextView(context, attrs);
   }
}
```

> 출처 : https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/theme/MaterialComponentsViewInflater.java

정리하면 AppCompat 테마는 AppCompatTextView, Material Components 테마는 MaterialTextView가 실제로 생성되는 TextView입니다. 그리고 MaterialTextView는 AppCompatTextView의 자식 클래스입니다.

우리는 호환성을 위해서 AppCompat이 사용된다는 것을 살펴봤습니다. 그럼 `AppCompatTextView` 가 중요한 키워드일 것이라는 것을 눈치채셨나요?

### AppCompatTextView

AppCompatTextView는 TextView의 자식 클래스입니다. TextView의 접근 가능한 필드와 메소드를 override하여 호환성 유지라는 목적을 달성하고 있습니다.

> 아래 소스는 CompoundDrawable 설명에 필요한 소스만 표기했습니다.
>
> 원문 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/widget/AppCompatTextView.java

먼저 위에 있는 AppCompatTextView를 살펴봤을 때 알 수 있는 사실은 많은 기능이 메소드 override를 하지만 내부 구현은 `Helper`를 호출하는 방법으로 구현하고 있습니다. CompoundDrawable 구현 또한 **AppCompatTextHelper**를 통해서 이루어지고 있습니다. 이어서 관련 내용을 살펴보도록 하겠습니다.

```java
public class AppCompatTextView extends TextView implements TintableBackgroundView,
      TintableCompoundDrawablesView, AutoSizeableTextView {

   // Backgroud, Text, Classifier를 위한 Helper 클래스
   private final AppCompatBackgroundHelper mBackgroundTintHelper;
   private final AppCompatTextHelper mTextHelper;
   private final AppCompatTextClassifierHelper mTextClassifierHelper;

   public AppCompatTextView(
         @NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
      // 생성자 내부에 AppCompatTextHelper를 인스턴스화한 후 AttributeSet 로드와 CompoundDrawables 적용.
      // XML 및 코드에서 View 생성 시에 필요한 초기 설정이 적용.
      mTextHelper = new AppCompatTextHelper(this);
      mTextHelper.loadFromAttributes(attrs, defStyleAttr);
      mTextHelper.applyCompoundDrawablesTints();
   }

   // CompoundDrawable 변경 시 AppCompatTextHelper#applyCompoundDrawablesTints 호출되어 적용
   @Override
   protected void drawableStateChanged() {
      super.drawableStateChanged();
      if (mTextHelper != null) {
         mTextHelper.applyCompoundDrawablesTints();
      }
   }   

   // CompoundDrawable 변경 시 AppCompatTextHelper#onSetCompoundDrawables 호출되어 적용
   // onSetCompoundDrawables을 호출하는 메소드
   // - setCompoundDrawables
   // - setCompoundDrawablesRelative
   // - setCompoundDrawablesWithIntrinsicBounds
   // - setCompoundDrawablesRelativeWithIntrinsicBounds
   @Override
   public void setCompoundDrawables(@Nullable Drawable left, @Nullable Drawable top,
         @Nullable Drawable right, @Nullable Drawable bottom) {
      super.setCompoundDrawables(left, top, right, bottom);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
   @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
   @Override
   public void setCompoundDrawablesRelative(@Nullable Drawable start, @Nullable Drawable top,
         @Nullable Drawable end, @Nullable Drawable bottom) {
      super.setCompoundDrawablesRelative(start, top, end, bottom);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
   @Override
   public void setCompoundDrawablesWithIntrinsicBounds(@Nullable Drawable left,
         @Nullable Drawable top, @Nullable Drawable right, @Nullable Drawable bottom) {
      super.setCompoundDrawablesWithIntrinsicBounds(left, top, right, bottom);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
   @Override
   public void setCompoundDrawablesWithIntrinsicBounds(int left, int top, int right, int bottom) {
      final Context context = getContext();
      setCompoundDrawablesWithIntrinsicBounds(
            left != 0 ? AppCompatResources.getDrawable(context, left) : null,
            top != 0 ? AppCompatResources.getDrawable(context, top) : null,
            right != 0 ? AppCompatResources.getDrawable(context, right) : null,
            bottom != 0 ? AppCompatResources.getDrawable(context, bottom) : null);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
   @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
   @Override
   public void setCompoundDrawablesRelativeWithIntrinsicBounds(@Nullable Drawable start,
         @Nullable Drawable top, @Nullable Drawable end, @Nullable Drawable bottom) {
      super.setCompoundDrawablesRelativeWithIntrinsicBounds(start, top, end, bottom);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
   @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
   @Override
   public void setCompoundDrawablesRelativeWithIntrinsicBounds(
         int start, int top, int end, int bottom) {
      final Context context = getContext();
      setCompoundDrawablesRelativeWithIntrinsicBounds(
            start != 0 ? AppCompatResources.getDrawable(context, start) : null,
            top != 0 ? AppCompatResources.getDrawable(context, top) : null,
            end != 0 ? AppCompatResources.getDrawable(context, end) : null,
            bottom != 0 ? AppCompatResources.getDrawable(context, bottom) : null);
      // CompoundDrawable이 변경되었음을 알림
      if (mTextHelper != null) {
         mTextHelper.onSetCompoundDrawables();
      }
   }
}       
```

> 출처 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/widget/AppCompatTextView.java

AppCompatTextView 내부를 확인했을 때 실제로 다수의 함수들이 View, TextView에 정의된 함수를 override 했습니다. 그리고, 각 기능에 대응하는 Helper 함수를 통해서 호환성을 유지하도록 대응되어 있습니다.

**AppCompatTextView에서 사용되는 Helper**

- AppCompatBackgroundHelper : Background, Background Tint, Background TintMode
- AppCompatTextHelper : CompoundDrawable, TextAllCaps, TextColorTint, TextColorHint, TextColorLink, Tint Mode, Line Height, etc
- AppCompatTextClassifierHelper : TextClassifier

### AppCompatTextHelper

AppCompatTextHelper는 AppComaptTextView의 호환성 대응을 위한 Helper 클래스입니다. 이어서 관련 내용을 살펴보도록 하겠습니다.

> 아래 소스는 CompoundDrawable 설명에 필요한 소스만 표기했습니다.
>
> 원문 : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/widget/AppCompatTextHelper.java

```java
class AppCompatTextHelper {
   @NonNull
   private final TextView mView;
   
   // Compound Drawable에 사용되는 Tint 정의
   private TintInfo mDrawableLeftTint;
   private TintInfo mDrawableTopTint;
   private TintInfo mDrawableRightTint;
   private TintInfo mDrawableBottomTint;
   private TintInfo mDrawableStartTint;
   private TintInfo mDrawableEndTint;
   private TintInfo mDrawableTint;
  
   @SuppressLint("NewApi")
   void loadFromAttributes(@Nullable AttributeSet attrs, int defStyleAttr) {
      final Context context = mView.getContext();
      final AppCompatDrawableManager drawableManager = AppCompatDrawableManager.get();

      // AppCompatTextHelper 스타일 로드한 후 세부 속성을 로드
      // <declare-styleable name="AppCompatTextHelper">
      //    <attr name="android:drawableLeft" />
      //    <attr name="android:drawableTop" />
      //    <attr name="android:drawableRight" />
      //    <attr name="android:drawableBottom" />
      //    <attr name="android:drawableStart" />
      //    <attr name="android:drawableEnd" />
      //    <attr name="android:textAppearance" />
      // </declare-styleable>

      TintTypedArray a = TintTypedArray.obtainStyledAttributes(context, attrs,
            R.styleable.AppCompatTextHelper, defStyleAttr, 0);
      ViewCompat.saveAttributeDataForStyleable(mView, mView.getContext(),
            R.styleable.AppCompatTextHelper, attrs, a.getWrappedTypeArray(),
            defStyleAttr, 0);

      // Compound Drawable이 정의되어 있으면, 해당 항목에 매칭하는 Tint 정보를 정의
      if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableLeft)) {
         mDrawableLeftTint = createTintInfo(context, drawableManager,
               a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableLeft, 0));
      }
      if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableTop)) {
         mDrawableTopTint = createTintInfo(context, drawableManager,
               a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableTop, 0));
      }
      if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableRight)) {
         mDrawableRightTint = createTintInfo(context, drawableManager,
               a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableRight, 0));
      }
      if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableBottom)) {
         mDrawableBottomTint = createTintInfo(context, drawableManager,
               a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableBottom, 0));
      }
      if (Build.VERSION.SDK_INT >= 17) {
         if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableStart)) {
            mDrawableStartTint = createTintInfo(context, drawableManager,
                  a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableStart, 0));
         }
         if (a.hasValue(R.styleable.AppCompatTextHelper_android_drawableEnd)) {
            mDrawableEndTint = createTintInfo(context, drawableManager,
                  a.getResourceId(R.styleable.AppCompatTextHelper_android_drawableEnd, 0));
         }
      }
      // AppCompatTextView 스타일을 읽은 후 세부 속성 로드
      a = TintTypedArray.obtainStyledAttributes(context, attrs, R.styleable.AppCompatTextView);

      // CompoundDrawable Compat 대응에 맞는 속성 로드
      // <declare-styleable name="AppCompatTextView">
      //    ...
      //    <attr name="drawableLeftCompat" format="reference" />
      //    <attr name="drawableTopCompat" format="reference" />
      //    <attr name="drawableRightCompat" format="reference" />
      //    <attr name="drawableBottomCompat" format="reference" />
      //    <attr name="drawableStartCompat" format="reference" />
      //    <attr name="drawableEndCompat" format="reference" />
      //    <attr name="drawableTint" format="color" />
      //    <attr name="drawableTintMode">
      //       ...
      //    </attr>
      // </declare-styleable>
      Drawable drawableLeft = null, drawableTop = null, drawableRight = null,
               drawableBottom = null, drawableStart = null, drawableEnd = null;
      final int drawableLeftId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableLeftCompat, -1);
      if (drawableLeftId != -1) {
         drawableLeft = drawableManager.getDrawable(context, drawableLeftId);
      }
      final int drawableTopId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableTopCompat, -1);
      if (drawableTopId != -1) {
         drawableTop = drawableManager.getDrawable(context, drawableTopId);
      }
      final int drawableRightId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableRightCompat, -1);
      if (drawableRightId != -1) {
         drawableRight = drawableManager.getDrawable(context, drawableRightId);
      }
      final int drawableBottomId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableBottomCompat, -1);
      if (drawableBottomId != -1) {
         drawableBottom = drawableManager.getDrawable(context, drawableBottomId);
      }
      final int drawableStartId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableStartCompat, -1);
      if (drawableStartId != -1) {
         drawableStart = drawableManager.getDrawable(context, drawableStartId);
      }
      final int drawableEndId = a.getResourceId(
            R.styleable.AppCompatTextView_drawableEndCompat, -1);
      if (drawableEndId != -1) {
         drawableEnd = drawableManager.getDrawable(context, drawableEndId);
      }
      setCompoundDrawables(drawableLeft, drawableTop, drawableRight, drawableBottom,
            drawableStart, drawableEnd);
      ...
   }

   void onSetCompoundDrawables() {
      applyCompoundDrawablesTints();
   }
  
   // CompoundDrawables에 Tint를 적용
   // API 17부터 추가된 Start/End 속성을 위해 개별 대응
   // - TextView#getCompoundDrawables
   // - TextView#getCompoundDrawablesRelative
   void applyCompoundDrawablesTints() {
      if (mDrawableLeftTint != null || mDrawableTopTint != null ||
            mDrawableRightTint != null || mDrawableBottomTint != null) {
         final Drawable[] compoundDrawables = mView.getCompoundDrawables();
         applyCompoundDrawableTint(compoundDrawables[0], mDrawableLeftTint);
         applyCompoundDrawableTint(compoundDrawables[1], mDrawableTopTint);
         applyCompoundDrawableTint(compoundDrawables[2], mDrawableRightTint);
         applyCompoundDrawableTint(compoundDrawables[3], mDrawableBottomTint);
      }
      if (Build.VERSION.SDK_INT >= 17) {
         if (mDrawableStartTint != null || mDrawableEndTint != null) {
            final Drawable[] compoundDrawables = mView.getCompoundDrawablesRelative();
            applyCompoundDrawableTint(compoundDrawables[0], mDrawableStartTint);
            applyCompoundDrawableTint(compoundDrawables[2], mDrawableEndTint);
         }
      }
   }  
   private void applyCompoundDrawableTint(Drawable drawable, TintInfo info) {
      if (drawable != null && info != null) {
         AppCompatDrawableManager.tintDrawable(drawable, info, mView.getDrawableState());
      }
   }
  
   // CompoundDrawables을 View에 적용
   // ※ Start/End가 존재하는 경우 Left/Right 속성은 무시됨
   private void setCompoundDrawables(Drawable drawableLeft, Drawable drawableTop,
         Drawable drawableRight, Drawable drawableBottom, Drawable drawableStart,
         Drawable drawableEnd) {
      if (Build.VERSION.SDK_INT >= 17 && (drawableStart != null || drawableEnd != null)) {
         // Start/End CompoundDrawable Compat을 정의한 케이스
         
         // 적용되는 속성
         // - drawableStartCompat 혹은 drawableStart
         // - drawableTopCompat 혹은 drawableTop
         // - drawableEndCompat 혹은 drawableEnd
         // - drawableBottomCompat 혹은 drawableBottom
         final Drawable[] existingRel = mView.getCompoundDrawablesRelative();
         mView.setCompoundDrawablesRelativeWithIntrinsicBounds(
               drawableStart != null ? drawableStart : existingRel[0],
               drawableTop != null ? drawableTop : existingRel[1],
               drawableEnd != null ? drawableEnd : existingRel[2],
               drawableBottom != null ? drawableBottom : existingRel[3]
         );
      } else if (drawableLeft != null || drawableTop != null
            || drawableRight != null || drawableBottom != null) {
         // Start/End CompoundDrawable Compat를 미정의한 케이스

         if (Build.VERSION.SDK_INT >= 17) {
            // CompoundDrawables Compat이 아닌
            // 기존 CompoundDrawable Start/End 속성이 존재하면 LeftCompat/RightCompat는 무시하여 적용
            
            // 적용되는 속성
            // - drawableStart
            // - drawableTopCompat 혹은 drawableTop
            // - drawableEnd
            // - drawableBottomCompat 혹은 drawableBottom
            final Drawable[] existingRel = mView.getCompoundDrawablesRelative();
            if (existingRel[0] != null || existingRel[2] != null) {
               mView.setCompoundDrawablesRelativeWithIntrinsicBounds(
                     existingRel[0],
                     drawableTop != null ? drawableTop : existingRel[1],
                     existingRel[2],
                     drawableBottom != null ? drawableBottom : existingRel[3]
               );
               return;
            }
         }
         // 적용되는 속성
         // - drawableLeftCompat 혹은 drawableLeft
         // - drawableTopCompat 혹은 drawableTop
         // - drawableRightCompat 혹은 drawableRight
         // - drawableBottomCompat 혹은 drawableBottom
         final Drawable[] existingAbs = mView.getCompoundDrawables();
         mView.setCompoundDrawablesWithIntrinsicBounds(
               drawableLeft != null ? drawableLeft : existingAbs[0],
               drawableTop != null ? drawableTop : existingAbs[1],
               drawableRight != null ? drawableRight : existingAbs[2],
               drawableBottom != null ? drawableBottom : existingAbs[3]
         );
      }
   }
}
```

> 출처
>
> - AppCompatTextHelper : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/java/androidx/appcompat/widget/AppCompatTextHelper.java
> - AppCompatTextView declare-styleable : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/res/values/attrs.xml;l=859
> - AppCompatTextHelper declare-styleable : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat/src/main/res/values/attrs.xml;l=1298

AppCompatTextHelper는 기존 View에서 처리하던 Style 속성 읽기/사용을 직접 담당하고 있습니다. 실제로 아래의 순서대로 호출되어 사용자가 정의한 속성이 반영됩니다.

1. loadFromAttributes
2. setCompoundDrawables
3. applyCompoundDrawablesTints

### Relative를 우선으로 처리하는 기능

지금까지 확인한 AppCompatTextHelper의 내부 기능으로는 Left/Right를 가지는 TextView#getCompoundDrawables()보다 Start/End를 가지는 `TextView#getCompoundDrawablesRelative()` 의 우선순위가 높습니다.

- AppCompatTextHelper#setCompoundDrawables
  - 호출 시점 : 최초 Inflate시 Attributes 로드하고서 실행
  - 우선 순위 : Start/End 중 하나가 정의되어 있을 경우 Left/Right는 무시
- AppCompatTextHelper#applyCompoundDrawablesTints
  - 호출 시점 : Drawable과 Tint 변경시에 실행
  - 우선 순위 : Left/Right를 처리한 후 Start/End를 처리

이와 같이 최종적으로는 Relative CoompoundDrawables이 반영되므로 TextView에서는 Start/End와 Left/Right 속성을 혼용하지 않도록 주의가 필요합니다.

## 기타

#### AppCompatTextView / AppCompatTextHelper가 변경된 주요 커밋

Fix AlertDialog item direction (Chris Banes on 2015. 9. 7)

- https://android.googlesource.com/platform/frameworks/support/+/f7b73431b366b76bcf58536b7b1086489e4683b2
- Drawable (Left, Top, Right, Bottom) 추가

Remove AppCompatTextHelper API 17 abstraction (Jake Wharton on 2018. 3. 24)

- https://android.googlesource.com/platform/frameworks/support/+/746219c9e09bc6f0a9a3e9faa720cee2db7a0049
- Drawable (Start, End) 추가

Adds compat compound drawable attributes to AppCompatTextView (Nick Butcher on 2018. 8. 23)

- https://android.googlesource.com/platform/frameworks/support/+/bae75fb60a9d36df371a05ff713af713198beaf5
- DrawableCompat 추가

Add drawableTint to AppCompatTextView (Nick Butcher on 2018. 10. 4)

- https://android.googlesource.com/platform/frameworks/support/+/accb6d1b408f24ffa9e3ef597f89867b4192c9f6
- Tint, Tint Mode 추가

#### 참고 사이트

- TextViewCompoundDrawablesXmlDetector : https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:appcompat/appcompat-lint/src/main/kotlin/androidx/appcompat/widget/TextViewCompoundDrawablesXmlDetector.kt

