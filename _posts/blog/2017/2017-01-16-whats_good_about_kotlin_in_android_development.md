---
layout: post
title: "[번역] What's Good About Kotlin in Android Development"
date: 2017-01-16 01:15:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [What's Good About Kotlin in Android Development](http://shiraji.github.io/blog/2016/12/11/whats-good-about-kotlin-in-android-development/) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

이것은 [Kotlin Advent Calendar 2016](http://qiita.com/advent-calendar/2016/kotlin) 12/11 기사입니다.

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">kotlinでやるとAndroid簡単に書ける手法まとめとかないかな。extentionでbindingadapter書くとか、custom viewのコンストラクタをJvmOverloadsで省略とか。</p>&mdash; しらじ (@shiraj_i) <a href="https://twitter.com/shiraj_i/status/768082977569898496">2016年8月23日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

8월 23일에 이런 트윗을 하고 지금까지 안드로이드 개발을 해오면서, 이렇게 쓰면 간단해서 기분좋아!!!라는 Kotlin 문법을 소개하려 합니다.

(어디까지나 나 자신이 기분 좋았으니까!)

## 자기소개

[Kotlin 1.0.4](https://blog.jetbrains.com/kotlin/2016/09/kotlin-1-0-4-is-here/), [Kotlin 1.0.5](https://blog.jetbrains.com/kotlin/2016/11/kotlin-1-0-5-is-here/)에 이름이 실린 External Contributors 중 한 명입니다 (기뻤기 때문에 자랑). 주로 Kotlin Plugin의 정적 분석에 컨트리뷰트하고 있습니다. Kotlin으로 쓰여진 [PermissionsDispatcher](https://github.com/hotchemi/PermissionsDispatcher)의 개발에도 참여하고 있습니다.

Android 개발 경험은 3년 정도로 지금은 Android를 Java로도 Kotlin로도 개발하고 있습니다.

조금 정도라면 블로그에 Android/Kotlin 이야기를 써봐도 괜찮은 레벨일까? 생각합니다.

## 전제조건과 예상독자

- Android 개발은 어느 정도 알고 있다
- Kotlin에서 Android 관심이 있는 사람
- Kotlin에서 Android 개발 좋다고 듣지만, 무엇이 좋은지 모르는 사람

Kotlin의 문법은 Java 코드와 비교하면 대체로 알 듯한 느낌으로 기재하고 있습니다만, 만약 모르면 [@shiraj_i](https://twitter.com/shiraj_i) 으로 멘션주시면 답변하므로, 부담 없이 질문 해주세요.

## 기분좋은! 문법들

Kotlin은 쓰기 쉽다고 자주 듣고 있습니다만, 실제로 어떤 곳에서 어떤 문법을 쓰면 "쓰기 쉽다"가 될까 Java와의 비교가 별로 없습니다. 그래서 독단과 편견으로 기분 좋은 문법이다 이거!라고 생각한 문법이나 쓰는 방법을 소개하고 싶습니다.

Kotlin에서 가장 유명한 기능, Null 안전과 세미콜론 리스에 관해서는 많은 문서와 블로그가 있으므로 생략합니다.

### 한 줄 메소드

특정 텍스트를 반환만하는 메소드를 만들 때 Java로 쓰면 이런 느낌입니다.

```
public String getName() {
  return "MyApp";
}
```

Kotlin에서도 똑같이 쓸 수 있습니다.

```
fun getName(): String {
  return "MyApp"
}
```

다만 Kotlin은 한 줄로 return할 경우 `=`를 붙여 `{}`를 생략할 수 있습니다.

```
fun getName(): String = "MyApp"
```

또한, 반환 값이 명백한 경우 형 지정하지 않아도 괜찮으므로

```
fun getName() = "MyApp"
```

짧아서 상당히 기분이 좋네요.

이런 식으로 다음도 Java의 예문을 내고 Kotlin으로 기분 좋게 해보겠습니다. 그러면 점점 가보겠습니다.

### null일때 뭘 할까?

예를 들어, 파라미터가 null인 경우, 즉 메소드를 빠지는 처리를 쓰려고 합니다. Java의 경우, 꽤 이것저것 쓰지 않으면 안됩니다.

```
public void foo(@Nullable String text) {
    if (text == null) {
        return;
    }
    // ...
}
```

Kotlin은 null일때 이렇게 하라는 `?:` 문법이 있습니다. 그것을 사용하면 한 줄로 쓸 수 있습니다.

```
fun foo(text: String?) {
    text ?: return
    // ...
}
```

null일 때에 다른 값을 대입하는 것도 가능합니다.

```
fun foo(text: String?) {
    val bar = text ?: "" // text를 bar에 대입한다. text가 null인 경우, 공백으로 한다.
    // ...
}
```

### 빈 클래스

Java에서는 빈 클래스라면, `{}`를 쓰지않으면 안됩니다. 특히 표시에 대한 interface 라고 생각합니다만

```
interface Foo {}
```

Kotlin에서는 바디가 없는 클래스의 경우 `{}`를 쓰지 않아도 되므로

```
interface Foo
```

물론 class로도 가능합니다.

```
class Bar
```

### 빈 메소드

빈 메소드. Java의 경우 `{}`를 쓰지 않으면 안됩니다.

```
public void foo() {
}
```

Kotlin의 경우, 한 줄 메소드처럼 쓸 수 있습니다.

```
fun foo() = Unit
```

어? 왠지 기...기분이 좋네요!

### getter/setter 생략

Kotlin에서는 getter/setter가 있는 경우, property로 접근할 수 있습니다. AOSP에 적혀있는 getter/setter도 마찬가지입니다.

`Activity#getLayoutInflater()`를 쓰는 방법을 정의하는 경우

```
public LayoutInflater getLayoutInflater() {
    return activity.getLayoutInflater();
}
```

Kotlin으로 쓰면 다음과 같이 쓸 수 있습니다.

```
fun layoutInflater() : LayoutInflater = activity.layoutInflater
```

실제로는 Activity 내에서 `layoutInflater`라는 속성은 존재하지 않지만 Kotlin이 해석해줍니다.

물론, 다음과 같이도 쓸 수 있습니다.

```
fun layoutInflater() : LayoutInflater = activity.getLayoutInflater()
```

단, Android Studio가 "이거 프로퍼티 액세스로 바꾸는건 어때?"라는 suggest가 나옵니다.

<img src="https://raw.githubusercontent.com/wiki/shiraji/images/blog/images/whats-good-about-kotlin-in-android-development/getter_setter.png"/>

Java 같은 코드를 작성하면 이렇게 경고를 내주므로 일일이 수정해 나가면 Kotlin 다운 문법 공부에도 도움됩니다. (platform type에는 주의하시기 바랍니다)

## 매개 변수의 기본값

여기의 파라미터 대체로 같은 값이지만, 때때로 다르기 때문에 overload 메소드를 만들까! 인 경우 없습니까?

```
  public static boolean maybeStartActivity(Context context, Intent intent) {
    return maybeStartActivity(context, intent, false);
  }

  private static boolean maybeStartActivity(Context context, Intent intent, boolean chooser) {
      // ...
  }
```

유명한 [u2020](https://github.com/JakeWharton/u2020/blob/70dd9572f45afb21a62ff414d19b7c095d737372/src/main/java/com/jakewharton/u2020/util/Intents.java)에도 있었습니다.

Kotlin은 매개 변수의 기본값을 정의할 수 있습니다.

```
  fun maybeStartActivity(context: Context, intent: Intent, chooser: Boolean = false): Boolean {
      // ...
  }
```

#### 커스텀 View의 생성자

매개 변수의 기본값에 관련하여 커스텀 View의 생성자 정의 힘들다고 생각합니다.

```
public CustomView(Context context) {
    this(context, null);
}

public CustomView(Context context, AttributeSet attrs) {
    this(context, attrs, 0);
}

public CustomView(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
    binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.custom_view, this, true);
}
```

Kotlin은 기본값을 정의한 메소드를 위와 같이 Java에서 보면 여러 개 있게 하는 `@JvmOverloads` 어노테이션이 있습니다.

이것을 사용하면 커스텀 View의 생성자는 한 줄 정의하는 것만으로 쓸 수 있습니다.

```
class @JvmOverloads CustomView(context: Context, attrs: AttributeSet = null, defStyleAttr: Int = 0) {
}
```

(Kotlin의 생성자 자체는 기분 안좋으므로 설명 생략합니다.)

### 캐스팅에 괄호가 적다

Java에서 캐스팅하는 경우 괄호가 많아지기 마련입니다. PagerAdapter의 `destroyItem`을 구현해봅니다.

```
＠Override public void destroyItem(ViewGroup container, int position, Object obj) {
    ((ViewPager) container).removeView((View) obj)
}
```

Kotlin이라면 `as`를 사용해서 캐스팅합니다. 문법적으로도 괄호가 줄어 어디서 괄호가 끝나고 있는지 쉽게 알 수 있습니다.

```
override fun destroyItem(container: ViewGroup?, position: Int, obj: Any?) {
    (container as ViewPager).removeView(obj as View)
}
```

#### 캐스트 실패시 어떻게 해?

null일 때 어떻게 하는 것에 대해서는 ? 과 함께 사용하는 것으로 캐스트 실패 시 무엇을 할지의 정의도 쉽게 할 수 있습니다.

```
override fun destroyItem(container: ViewGroup?, position: Int, obj: Any?) {
    container as? ViewPager ?: return
    // ...
}
```

또한, readonly 변수의 캐스팅에 성공하면 자동으로 그 변수를 캐스팅해줍니다. 메소드 매개 변수는 readonly. 곳곳에 나오는 `val`로 정의되는 변수도 readonly입니다. (여담이지만 immutable 하지 않으므로 주의하시기 바랍니다.)

```
override fun destroyItem(container: ViewGroup?, position: Int, obj: Any?) {
    container as? ViewPager ?: return
    obj as? View ?: return
    container.removeView(obj)
}
```

mutable 변수 `var`의 경우, `as?` 후에 변경할 수 있어 자동으로 캐스팅 주지 않기 때문에 주의. Kotlin은 이유가 없는 한 `var`를 사용하지 않는 편이 좋다.

### Util 계열

XxxUtils 라든지 만들고, 모든 메소드를 static으로 해서 private 생성자를 만들어 ... 같은 방식을 Java에서는 가끔 하고 있습니다.

```
public class LogUtil {
  private LogUtil() {}

  public void initLog(String tag) {
    Timber.plant(ExtTree(tag))
  }
}
```

kotlin에서는 Top 레벨로 메소드를 쓰면 이런 Util 계열의 메소드를 쓸 수 있습니다.

```
fun initLog(tag: String) = Timber.plant(ExtTree(tag))
```

사용법도 Java의 경우와 다르지 않습니다.

```
import package.initLog

fun foo() {
  initLog("MyApp")
}
```

### String 템플릿

Java에서 String의 결합할 경우 이런 느낌이 됩니다.

```
return originalResponse.newBuilder()
                    .header("Cache-Control", "public, max-age=" + 60 * 3)
                    .build();
```

Kotlin에는 String 템플릿으로 String 내에 `${}`로 변수를 쓸 수 있습니다.

```
return originalResponse.newBuilder()
                    .header("Cache-Control", "public, max-age=${60 * 3}")
                    .build()
```

변수 하나뿐인 경우 `{}` 생략도 가능합니다.

```
val foo = 1
val bar = "Text$foo" // <= "Text1"라는 문자열로
```

### 복수행 String

Java String으로 여러 행을 생성하는 경우, 상당히 괴롭습니다.

```
String text = "aaa\nbbb\nccc";
```

Kotlin에서는 `"""`를 사용하는 것으로 여러 줄의 String 정의를 할 수 있습니다.

```
val text = """aaa
              bbb
              ccc""".trimMargin();
```

.trimMargin() 라든가 여백의 시작 위치라든지 여러 줄의 String은 상당히 다기능이지만, 자세하게 알고 싶다면 [공식 string-literals](https://kotlinlang.org/docs/reference/basic-types.html#string-literals)를 확인해주세요.

### 복수 if -> when

Java에서는 if가 여러 개 있는 경우 조금 괴롭습니다.

예를 들어 다음과 같은 코드가 있다고 합니다. (Java로 behavior를 자체 구현했을 때 사용했던 코드)

```
if (isAnimating) return;
if (consumed > 0) {
    hide(child);
} else {
    show(child);
}
```

이를 Kotlin에서도 그대로 if/else 쓸 수 있습니다.

```
if (isAnimating) return
if (consumed > 0) {
    hide(child)
} else {
    show(child)
}
```

그러나 좀 더 간단하게 when으로 정리할 수 있습니다.

```
when {
    isAnimating -> return
    consumed > 0 -> animateHide(child)
    else -> animateShow(child)
}
```

when은 Java에서의 Switch 문에 가깝지만, 위와 같이 when 뒤에 조건을 지정하지 않거나 변수의 형 case 문에 쓰거나 엄청 기분 좋게 될 수 있습니다.

### 식

Kotlin에서는 if와 when 등 여러 가지가 식입니다.

예를 들어, if의 결과를 변수에 대입하는 경우,

```
int foo;
if(flag) {
    foo = 10;
} else {
    foo = 100;
}
```

kotlin에서는 이런 느낌이 됩니다.

```
val foo = if (flag) {
    10
}  else {
    100
}
```

간단한 경우 `{}`를 생략하기 때문에 한 줄로 쓰는 경우가 많습니다.

```
val foo = if (flag) 10 else 100
```

조건에 따라 다른 값을 대입하고 있는데 `val`로 정의 할 수 있는 것이 포인트입니다.

덧붙여서, [PermissionsDispatcher](https://github.com/hotchemi/PermissionsDispatcher)에서도 이용하고 메소드의 인자로 사용하기도 합니다.

```
builder.beginControlFlow("if (\$N\$T.shouldShowRequestPermissionRationale(\$N, \$N))", if (isPositiveCondition) "" else "!", PERMISSION_UTILS, targetParam, permissionField)
```

중첩할 수도 있지만, 복잡하므로 어려운 경우 로컬 변수로 꺼내는 것이 좋다고 생각합니다.

### Annotation

Dagger2를 사용하는 경우 Activity이나 Fragment Scope를 만들기 위해 자체 Annotation 만들기도 합니다.

```
@Scope
@Retention(RetentionPolicy.RUNTIME)
public @interface ActivityScope {
}
```

`@interface`라는 키워드를 사용하고 있습니다만, Kotlin에서는 `annotation`으로 표현합니다. 직관적이고 좋습니다.

```
@Scope
@Retention
annotation class ActivityScope
```

`Retention`의 기본값이 `RetentionPolicy.RUNTIME`이므로 생략할 수 있는 것도 깔끔해서 기분이 좋습니다.

### Singleton

Java에서는 (간이적인) 싱글톤을 만들려면 다음과 같이 작성해야 했습니다.

```
public class MoshiUtil {
    private static Moshi moshi;

    public static Moshi getMoshi() {
        if (moshi == null) {
            moshi = Moshi.Builder().add(DateAdapter()).build();
        }
        return moshi;
    }
}
```

Kotlin에서는 `object`로 정의하면 앱 내에서 싱글톤으로 사용할 수 있습니다.

```
object MoshiUtil {
    val moshi: Moshi by lazy {
        Moshi.Builder().add(DateAdapter()).build()
    }
}
```

사용법도 Java의 때와 같습니다.

```
MoshiUtil.moshi.adapter(BlackjackHand::java.class)
```

### rx.Observable의 Thread 지정방법

잠깐 했던 것입니다만, Rx의 실행할 스레드의 지정 방법도 기분 좋게 쓸 수 있게 됩니다.

```
load()
  .subscribeOn(AndroidSchedulers.mainThread())
  .observeOn(AndroidSchedulers.mainThread())
  .subscribe();
```

Kotlin의 확장 속성을 이용하여 스레드의 지정방법을 정의합니다.

```
val <T> Observable<T>.observeOnUI: Observable<T>
    get() = observeOn(AndroidSchedulers.mainThread())

val <T> Observable<T>.observeOnIO: Observable<T>
    get() = observeOn(Schedulers.io())

val <T> Observable<T>.observeOnComputation: Observable<T>
    get() = observeOn(Schedulers.computation())

val <T> Observable<T>.subscribeOnUI: Observable<T>
    get() = subscribeOn(AndroidSchedulers.mainThread())

val <T> Observable<T>.subscribeOnIO: Observable<T>
    get() = subscribeOn(Schedulers.io())

val <T> Observable<T>.subscribeOnComputation: Observable<T>
    get() = subscribeOn(Schedulers.computation()).unsubscribeOn(Schedulers.computation())
```

이 확장 속성을 이용하면 다음과 같이 쓸 수 있습니다.

```
load()
  .subscribeOnIO
  .observeOnIO
  .subscribe()
```

### Databinding의 BindingAdapter 지정 방법

Databinding의 BindingAdapter의 [공식 문서의 코드](https://developer.android.com/reference/android/databinding/BindingAdapter.html)를 Kotlin으로 써봅니다.

```
@BindingAdapter("android:bufferType")
public static void setBufferType(TextView view, TextView.BufferType bufferType) {
    view.setText(view.getText(), bufferType);
}
```

이것이 이런 느낌이 되었습니다. `view`가 사라졌습니다.

```
@BindingAdapter("android:bufferType")
fun TextView.setBufferType(TextView.BufferType bufferType) {
    setText(getText(), bufferType)
}
```

### Databinding의 onClick 등의 이벤트 지정 방법

이것도 확장 메서드로 하겠습니다.

```
<android.support.design.widget.FloatingActionButton
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/spacing"
                android:onClick="@{viewModel::onClickTopFab}"
                app:backgroundTint="@color/action_green"
                app:fabSize="normal"
                app:layout_anchor="@id/app_bar"
                app:layout_anchorGravity="bottom|end"
                app:srcCompat="@drawable/plus"/>
```
```
fun onClickFab(View view) {
    Toast.makeText(view.getContext(), R.string.message_fab, Toast.LENGTH_LONG).show();
}
```

kotlin에서는 이런 느낌. Toast 표시용 확장 메서드도 정의하고 있습니다.

```
fun View.onClickFab() {
    Toast.makeText(context, R.string.message_fab, Toast.LENGTH_LONG).show()
}
```

조금 손을 보면

```
fun Context.showLongToast(@StringRes id: Int) {
    Toast.makeText(this, id, Toast.LENGTH_LONG).show()
}

fun View.onClickFab() {
    context.showLongToast(R.string.message_fab)
}
```

top 레벨의 확장 메서드는 사용법·용량을 준수해서 올바르게 사용하세요.

### createIntent/newInstance

저는 createIntent/newInstance 패턴을 좋아합니다.

이것도 기분 좋게 될 수 있습니다.

```
public static Intent createIntent(Context context) {
    Intent intent = new Intent(context, MyActivity.class);
    return intent;
}
```

apply를 사용해서 한 줄로.

```
companion object {
    fun createIntent(context: Context) = Intent(context, MyActivity::class.java).apply { }
}
```

newInstance로도 해봅니다.

```
public static SimpleDialogFragment newInstance(MyPacel entity) {
    SimpleDialogFragment fragment = new SimpleDialogFragment();
    Bundle bundle = new Bundle();
    bundle.putParcelable(PARCELABLE_KEY, entity);
    fragment.setArguments(bundle);
    return fragment;
}
```

파라미터 Set한 인스턴스를 만들고 싶을 뿐입니다만, 꽤 길고 괴롭다...

Kotlin으로 짧게 해보겠습니다.

```
fun newInstance(entity: MyPacel) =
　   SimpleDialogFragment().apply {
         arguments = Bundle().apply {
             putParcelable(PARCELABLE_KEY, entity)
         }
     }
```

nest가 심하므로 분해하겠습니다. 우선 이 부분.

```
arguments = Bundle().apply {
    putParcelable(PARCELABLE_KEY, entity)
}
```

이것을 메소드화하면

```
private fun entity(bundle: Bundle, entity: MyPacel): Bundle {
    return bundle.apply {
        putParcelable(PARCELABLE_KEY, entity)
    }
}
```

bundle 변수에 대한 처리이므로 Bundle의 확장 메서드로 생각하면 좋은 느낌.

```
private fun Bundle.entity(entity: MyPacel): Bundle {
    return this.apply {
        putParcelable(PARCELABLE_KEY, entity)
    }
}
```

return문 한 문장이므로 생략. this도 필요 없기 때문에 생략.

```
private fun Bundel.entity(entity: MyPacel) = apply { putParcelable(PARCELABLE_KEY, entity) }
```

이제 여기

```
fun newInstance(entity: MyPacel) =
     SimpleDialogFragment().apply {
         arguments = Bundle().entity(entity)
     }

private fun Bundel.entity(entity: MyPacel) = apply { putParcelable(PARCELABLE_KEY, entity) }
```

SimpleDialogFragment 부분도 마찬가지로 확장 메소드를 사용해서 작성하면.

```
fun newInstance(entity: MyPacel) = MyFragment().entity(entity)

private fun MyFragment.entity(entity: MyPacel) = apply { arguments = Bundle().entity(entity) }

private fun Bundle.entity(entity: MyPacel) = apply { putParcelable(KEY, entity) }
```

상당히 심플하게 되었습니다. 좋아좋아.

### setVisibleOrGone

Databinding 전에는 꽤 사용하는 일이 많았지만, 지금으로써는...하지만 일단.

View를 지워버릴까 표시할지를 Boolean 값으로 판별하는 Util 계열의 메소드를 작성하면

```
public static void setVisibleOrGone(View view, boolean isVisible) {
    if(view == null) {
        return;
    }

    if(isVisible) {
        view.setVisiblity(View.VISIBLE);
    } else {
        view.setVisiblity(View.GONE);
    }
}
```

이를 kotlin으로 쓰면 한 줄로 할 수 있습니다.

```
fun View?.setVisibleOrGone(isVisible: Boolean) {
    this?.visibility = if (isVisible) View.VISIBLE else View.GONE
}
```

nullable의 View의 확장 메서드, null 안전, setter/getter의 생략, if 문 사용과 다양한 Java에는 없는 기능을 이용하고 있습니다.

### BaseObservable

공식에 있는 다음 코드를 Kotlin으로 기분 좋게 써봅니다.

```
private static class User extends BaseObservable {
   private String firstName;
   private String lastName;
   @Bindable
   public String getFirstName() {
       return this.firstName;
   }
   @Bindable
   public String getLastName() {
       return this.lastName;
   }
   public void setFirstName(String firstName) {
       this.firstName = firstName;
       notifyPropertyChanged(BR.firstName);
   }
   public void setLastName(String lastName) {
       this.lastName = lastName;
       notifyPropertyChanged(BR.lastName);
   }
}
```

Kotlin으로 쓰기 전에 구체적으로 할 일은 다음

- getter에 `@Bindable`을 붙인다
- setter의 마지막에 `notifyPropertyChanged(BR.firstName);`를 부른다

```
class User : BaseObservable {
    @get:Bindable
    var firstName: String
        set(value) {
            field = value
            notifyPropertyChanged(BR.firstName)
        }

    @get:Bindable
    var lastName: String
        set(value) {
            field = value
            notifyPropertyChanged(BR.lastName)
        }
}
```

setter/getter를 쓰지 않아도 되므로 간단하게 되어 있습니다.

좀 더 깔끔하게 되면 좋지만, 일부러 메소드 쓰지 않아도 된다는 것만으로도 좋습니다.

### Delegate

상속하지마! 위임하라! 라고해도 Java 사용하면 상속하게 되기 십상이지만, Kotlin의 Delegate가 있으면 이를 적극적으로 사용하고 싶다고 생각하게 됩니다.

ViewModel에 Rx의 Subscription 기능을 구현하고 `Activity#onDestroy`시에 `unsubscribe()`하고 싶은 경우

```
public class MyViewModel(CompositeSubscription compositeSubscription) {
    // ...
    public void unsubscribe() {
        compositeSubscription.unsubscribe();
    }
}
```

Kotlin으로 delegate하면 `unsubscribe()`는 쓰지 않아도 됩니다.

```
class MyViewModel @Inject constructor(var compositeSubscription: CompositeSubscription) : Subscription by compositeSubscription {
    // ...
}
```

Activity에서는 이런 느낌. `MyViewModel`에서 구현하고 있지 않는데 `unsubscribe()`를 부를 수 있다.

```
class ThirdActivity : AppCompatActivity() {

    @field:[Inject]
    lateinit var viewModel: MyViewModel

// ...

    override fun onDestroy() {
        super.onDestroy()
        viewModel.unsubscribe()
    }
```

droidkaigi2016의 [ArrayRecyclerAdapter](https://github.com/konifar/droidkaigi2016/blob/master/app/src/main/java/io/github/droidkaigi/confsched/widget/ArrayRecyclerAdapter.java)를 다음과 같이 할 수도 있지만, 불필요한 메소드도 생기므로 사용방법과 용량을 (생략

```
abstract class MutableListRecyclerAdapter<T, VH : RecyclerView.ViewHolder>(private val list: MutableList<T>) :
        RecyclerView.Adapter<VH>(), Iterable<T>, MutableList<T> by list {

    var itemClickListener: View.OnClickListener? = null

    override fun getItemCount() = list.size

    @UiThread fun addAllWithNotification(items: Collection<T>) {
        val position = itemCount
        addAll(items)
        notifyItemChanged(position)
    }

    @UiThread fun reset(items: Collection<T>) {
        clear()
        addAll(items)
        notifyDataSetChanged()
    }
}
```

### 지연 초기화

Java로 쉽게 할 경우, getter를 작성하고 property 액세스는 금지하고 그 getter를 통해 값을 얻는다는 원칙하에 간신히 가능한 지연 초기화 처리입니다.

예를 들어, Databinding의 `setContentView`를 이용하여 `binding` 변수를 초기화합니다.

```
private MyBinding binding;

private MyBinding getBinding() {
    if(binding == null) {
        binding = DataBindingUtil.setContentView<MyBinding>(this, R.layout.my);
    }
    return binding;
}
```

Kotlin에서는 `by lazy`를 이용하여 작성합니다. 일단 `binding` 변수에 액세스하면 `by lazy`의 처리가 실행되어 초기화됩니다.

```
private val binding by lazy {
    DataBindingUtil.setContentView<MyBinding>(this, R.layout.my)
}
```

val인 것도 좋습니다.

덧붙여서, enum에 `ordinal`이 아닌 숫자 id를 이용하는 경우가 있어, 그 id로부터 역순하고 싶을 때 캐시 된 `SparseArray`를 이용하여 역순합니다만 이때도 `by lazy` 사용합니다.

```
companion object {
    private val lookup: SparseArray<MyType> by lazy {
        SparseArray<MyType>().apply {
            EnumSet.allOf(MyType::class.java).forEach {
                this@apply.put(it.typeId, it)
            }
        }
    }

    fun fromTypeId(typeId: Int): MyType {
        return lookup.get(typeId)
    }
}
```

### parameter name

Java에서는 원래 불가능하지만, 이런 POJO 클래스가 있다고 합니다.

```
public class User {
    private String firstName;
    private String lastName;

    public User(firstName, lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // 그외 메소드 생략
}
```
```
new User("명", "성");
new User("성", "명"); // 잘못되어있지만, 컴파일 OK
```

첫 번째 인수와 두 번째 인수가 first인지 last인지 알 수 없습니다. 런타임에서 밖에 알 수 없는 것이 괴롭습니다.

```
User(firstName = "명", lastName = "성")
```

인수에 이름을 설정하여 메소드를 호출합니다. 이런 것을 해도 문제가 되지 않고 잘못된 행동을 일으키지 않습니다. 유사한 형태가 많은 메소드 호출에서는 적극적으로 사용하면 좋습니다.

```
User(lastName = "성", firstName = "명")
```

### 마지막으로

나열해 보면 꽤 나왔습니다...

낙선한 항목은 [gist](https://gist.github.com/shiraji/2caf8190d282ab3594a21b467980267e)에 공개하고 있습니다.