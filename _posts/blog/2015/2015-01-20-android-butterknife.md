---
layout: post
title: "Android View Injection ButterKnife"
date: 2015-01-20 13:10:00
tag: [Android, Android-Library, Dependency Injection, Injection, ButterKnife]
categories:
- blog
- Android
---

## 기본적으로 읽어볼 내용

- 위키백과 [Dependency Injection](http://ko.wikipedia.org/wiki/%EC%9D%98%EC%A1%B4%EC%84%B1_%EC%A3%BC%EC%9E%85)

- StackOverflow [What is dependency injection?](http://stackoverflow.com/questions/130794/what-is-dependency-injection)

- Naver 개발자 블로그 hello world에 포스팅된 내용 [Android에서 @Inject, @Test](http://helloworld.naver.com/helloworld/textyle/342818)

<!--more-->

- - -

## Android에서의 Injection

안드로이드 개발자가 가장 많이 사용하는 함수/기능은 아래에 기술한 부분을 차지한다고 생각합니다

- `findViewById`
- 각종 `Listener`

- - -

## ButterKnife

ButterKnife는 ActionBarSherlock 등 Square의 Jake Wharton씨에 의해 개발된 Android용 `View Injection` 라이브러리입니다.

- `Activity, View의 findViewById 적용`
- `View의 Listener 이용`

ButterKnife는 위의 항목을 심플하게 사용을 목적으로 두며, Annotation Processing을 통해 코드 생성합니다.

### Gradle 설정

{% highlight groovy %}
dependencies {
   compile 'com.jakewharton:butterknife:6.0.0'
}
{% endhighlight %}

### 지원 기능

ButterKnife에서 지원하는 Annotation은 다음과 같습니다.

- View Injection
 - View Injection findViewById -> `@InjectView`
 - View Lists Injection -> `@InjectViews`
- Listener Injection
 - View.OnClickListener -> `@OnClick`
 - CompoundButton.OnCheckedChangeListener -> `@OnCheckedChanged`
 - TextView.OnEditorActionListener -> `@OnEditorAction`
 - View.OnFocusChangeListener -> `@OnFocusChange`
 - AdapterView.OnItemClickListener -> `@OnItemClick`
 - AdapterView.OnItemLongClickListener -> `@OnItemLongClick`
 - AdapterView.OnItemSelectedListener -> `@OnItemSelected`
 - View.OnLongClickListener -> `@OnLongClick`
 - support.v4.view.ViewPager.OnPageChangeListener -> `@OnPageChange`
 - text.TextWatcher -> `@OnTextChanged`
 - View.OnTouchListener -> `@OnTouch`

- - -

## Injection 사용전 필수사항

### Activity

Activity의 onCreate함수에서 setContentView 호출후 `ButterKnife.inject(Activity target)` 코드 반영

### Fragment

- Fragment의 onCreateView함수에서 setContentView 호출후 `ButterKnife.inject(Object target, View source)` 코드 반영
- Injection Reset을 위하여 Fragment의 onDestroyView()에서 `ButterKnife.reset(Object target)` 코드 반영

- - -

## 샘플 코드

샘플 코드는 ButterKnife 페이지의 내용을 사용했습니다.

### Activity에서의 View Injection

{% highlight java %}
class ExampleActivity extends Activity {
  @InjectView(R.id.title) TextView title;
  @InjectView(R.id.subtitle) TextView subtitle;
  @InjectView(R.id.footer) TextView footer;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.simple_activity);
    ButterKnife.inject(this);
    // TODO Use "injected" views...
  }
}
{% endhighlight %}

### Fragment에서의 View Injection

{% highlight java %}
public class FancyFragment extends Fragment {
  @InjectView(R.id.button1) Button button1;
  @InjectView(R.id.button2) Button button2;

  @Override View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    View view = inflater.inflate(R.layout.fancy_fragment, container, false);
    ButterKnife.inject(this, view);
    // TODO Use "injected" views...
    return view;
  }
}
{% endhighlight %}

### Fragment에서의 Injection Reset

{% highlight java %}
@Override void onDestroyView() {
  super.onDestroyView();
  ButterKnife.reset(this);
}
{% endhighlight %}

### Adapter에서의 ViewHolder

{% highlight java %}
public class MyAdapter extends BaseAdapter {
  @Override public View getView(int position, View view, ViewGroup parent) {
    ViewHolder holder;
    if (view != null) {
      holder = (ViewHolder) view.getTag();
    } else {
      view = inflater.inflate(R.layout.whatever, parent, false);
      holder = new ViewHolder(view);
      view.setTag(holder);
    }

    holder.name.setText("John Doe");
    // etc...

    return view;
  }

  static class ViewHolder {
    @InjectView(R.id.title) TextView name;
    @InjectView(R.id.job_title) TextView jobTitle;

    public ViewHolder(View view) {
      ButterKnife.inject(this, view);
    }
  }
}
{% endhighlight %}

### View Lists

{% highlight java %}
@InjectViews({ R.id.first_name, R.id.middle_name, R.id.last_name })
List<EditText> nameViews;
{% endhighlight %}

### Custom Action

{% highlight java %}
ButterKnife.apply(nameViews, DISABLE);
ButterKnife.apply(nameViews, ENABLED, false);

static final Action<View> DISABLE = new Action<>() {
  @Override public void apply(View view, int index) {
    view.setEnabled(false);
  }
}
static final Setter<View, Boolean> ENABLED = new Setter<>() {
  @Override public void set(View view, Boolean value, int index) {
    view.setEnabled(value);
  }
}
{% endhighlight %}

### Property Apply

{% highlight java %}
ButterKnife.apply(nameViews, View.ALPHA, 0);
{% endhighlight %}

### OnClickListener

{% highlight java %}
@OnClick(R.id.submit)
public void submit(View view) {
  // TODO submit data to server...
}

@OnClick(R.id.submit)
public void submit() {
  // TODO submit data to server...
}

@OnClick(R.id.submit)
public void sayHi(Button button) {
  button.setText("Hello!");
}

@OnClick({ R.id.door1, R.id.door2, R.id.door3 })
public void pickDoor(DoorView door) {
  if (door.hasPrizeBehind()) {
    Toast.makeText(this, "You win!", LENGTH_SHORT).show();
  } else {
    Toast.makeText(this, "Try again", LENGTH_SHORT).show();
  }
}
{% endhighlight %}

- - -

### 자세한 사용방법 : [ButterKnife Page](http://jakewharton.github.io/butterknife/)

- - -

참고사이트

1. http://helloworld.naver.com/helloworld/textyle/342818
2. http://jakewharton.github.io/butterknife/
3. http://qiita.com/yyaammaa/items/cb52ad37309c2e195e56
