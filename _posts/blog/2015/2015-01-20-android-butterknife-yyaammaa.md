---
layout: post
title: "[번역] Butter Knife 소개"
date: 2015-01-20 18:10:00
tag: [Android, Android-Library, Dependency Injection, Injection, ButterKnife]
categories:
- blog
- Android
---

이 포스팅은 [Butter Knifeの紹介](http://qiita.com/yyaammaa/items/cb52ad37309c2e195e56) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

Android용 View Injection 라이브러리인 [Butter Knife](http://jakewharton.github.io/butterknife/)에 대해서 설명합니다(라고하지만, 사이트에 적혀있는 것을 대부분 그대로 일본어로 번역한 것 뿐입니다.)

## 개요

Butter Knife은 [ActionBarSherlock](http://actionbarsherlock.com/)등 [square](http://squareup.com/)의 Jake Wharton씨에 의한 Android용 View Injection 라이브러리입니다.

- - -

## 사용방법

이 라이브러리의 목적은

- Activity, View의 findViewById를 편하게 쓰기
- View의 onClickListener 등을 편하게 쓰기

라는 심플한것이므로, 간단하게 이해되리라고 생각합니다. 아래는 익숙한 Activity 코드입니다.


```java
public class MainActivity extends Activity {

  TextView mTextView;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.activity_main);
    mTextView = (TextView) findViewById(R.id.activity_main_textview);
  }
}
```

View가 한두개라면 좋지만, 늘어갈수록 setContentView 이후에 findViewById가 길게 나열되어 보기어려운 코드가 됩니다.

이것을 아래와 같이 작성하는 것이 됩니다.


```java
public class MainActivity extends Activity {

  @InjectView(R.id.activity_main_textview)
  TextView mTextView;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.activity_main);
    ButterKnife.inject(this);
    // 아래에 mTextView를 사용한 코드 (mTextView.setText() 등)
  }
}
```

`@InjectView(int id)`으로 View의 Resource Id를 지정하면  `ButterKnife.inject(Activity)`에서 `mTextView = (TextView) findViewById(R.id.activity_main_textview)`와 같은 처리가 이루어집니다.

또한,


```java
public class MainActivity extends Activity {

  Button mButton;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.activity_main);
    mButton = (Button) findViewById(R.id.activity_main_button);
    mButton.setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
         onClickButton();
      }
    });
  }

  void onClickButton() {
    // 버튼을 눌렀을때의 처리
  }
}
```

findViewById하여, OnClickListener를 설정하고... 이런 ButtonButton처리도, Button의 수가 늘어갈수록 대단히 보기어려운 코드가 됩니다만, 이것을


```java
public class MainActivity extends Activity {

  @OnClick(R.id.activity_main_button)
  void onClickButton() {
    // 버튼을 눌렀을때의 처리
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.activity_main);
    ButterKnife.inject(this);
  }
}
```

Button의 onClick시에 호출되는 메소드에 `@OnClick(int id)`으로 View의 Resource Id를 지정하는 것만으로도 좋게됩니다.

복수의 Button의 onClick 이벤트 공통처리를 작성하고 싶을때에도,


```java
@OnClick({ R.id.activity_main_button1,
           R.id.activity_main_button2,
           R.id.activity_main_button3 })
void onClickButton(CustomButton button) {
  if (button.isHoge()) {
    // ...
  }
}
```

이렇게 작성할수 있으므로 편리합니다. `@InjectView`도 `@OnClick`도 View를 상속받은 클래스에서도 사용가능하므로 커스텀 View도 가능합니다.

또한, Injection의 대상인 View를 지정할수 있으므로, Fragment에서도,


```java
public class MainFragment extends Fragment {

  @InjectView(R.id.fragment_main_textview)
  TextView mTextView;

  @Override
  View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    View view = inflater.inflate(R.layout.fragment_main, container, false);
    ButterKnife.inject(this, view);
    // 아래는 mTextView를 사용한 처리

    return view;
  }

  @Override
  void onDestroyView() {
    super.onDestroyView();

    ButterKnife.reset(this);
  }
}
```

와 같이 사용할수 있습니다. (Fragment의 경우 onDestroyView에서 ButterKnife.reset를 호출해주세요).

이것과 같이, ListView등에서 사용하는 ViewHolder 패턴도 아래와 같이 간결하게 작성할수 있습니다.


```java
public class MyListAdapter extends BaseAdapter {

  @Override
  public View getView(int position, View view, ViewGroup parent) {
    ViewHolder holder;
    if (view != null) {
      holder = (ViewHolder) view.getTag();
    } else {
      view = inflater.inflate(R.layout.list_item, parent, false);
      holder = new ViewHolder(view);
      view.setTag(holder);
    }

    // 아래에 ViewHolder의 변수를 사용한 처리

    holder.mTitleView.setText("title");
    holder.mNameView.setText("my name");

    return convertView;
  }

  static class ViewHolder {

    @InjectView(R.id.title)
    TextView mTitleView;

    @InjectView(R.id.name)
    TextView mNameView;

    public ViewHolder(View view) {
      ButterKnife.inject(this, view);
    }
  }

}
```

이밖에도 아래 내용을 사용할수 있습니다.

- View의 OnLongClick
- ListView등의 OnItemClick, OnItemLongClick
- TextView의 OnEditorAction
- CompoundButton의 OnCheckedChanged

- - -

## 추가사항

같은 코드를 BaseActvity나 HogeUtil 안에 적는 사람들도 많을것입니다. `View#findViewById(int id)`나 `Activity#findViewById(int id)`의 Helper도 있습니다.


```java
View childView = getLayoutInflater().inflate(R.layout.child, null);

TextView childText = ButterKnife.findById(childView, R.id.child_text);
ImageView childImage = ButterKnife.findById(childeView, R.id.child_image);
```

- - -

## IDE 설정

- [Butter Knife](http://jakewharton.github.io/butterknife/) 사이트로부터 jar을 다운받습니다.
- jar를 libs 이하에 두어 Java의 Build path를 이용하여 설정합니다.
- Annotation Processing의 설정합니다.
 - IntelliJ IDEA / Android Studio의 경우, 그대로 사용할수 있는가봅니다.(사용안하기때문에 테스트해보지 않음). 안움직이는 경우 [여기](http://jakewharton.github.io/butterknife/ide-idea.html)를 참조
 - Eclipse의 경우는 [여기](http://jakewharton.github.io/butterknife/ide-eclipse.html)를 참조
- apt_generated/에 XXX$$ViewInjector.java와 같은 파일이 생성되면 됩니다. 생성되지 않는 경우네는 project를 clean하거나 IDE 재기동하면 잘 됩니다.

- - -

## ProGuard

ProGuard를 사용하는 경우에는 proguard-project.txt 등에 아래와 같이 설정해주세요.

```
-dontwarn butterknife.internal.**
-keep class **$$ViewInjector { *; }
-keepnames class * { @butterknife.InjectView *;}
```

- - -

## 개발 경위에 대해서

[Jake Wharton씨가 Google+에 투고. Mar 6, 2013](https://plus.google.com/+JakeWharton/posts/T5uPgt9FWHz)

```
People really like the concept of view "injection" for Android
and it often comes up when talking about Dagger.
Last night, I wrote a view injection library which uses
annotation processing as a little experiment and half-joke.
```

[Dagger](http://square.github.io/dagger/)에서 다른 개발자와 대화할때에 View의 Injection 문제가 자주 나타나므로, Annotation Processing로 시험삼아 만들어봤습니다, 라는 정도로 시작한듯 합니다.

```
RoboGuice uses an annotation in a different package and reflection
at runtime whereas this uses code generation along with a static method call.
It uses the same annotation name so people feel at home (similar to how @Inject is a standard).
This is for people who use Dagger or Guice (or no dependency injection)
but can't bring themselves to write findViewById calls.
```

Guice ([RoboGuice](https://github.com/roboguice/roboguice))와의 차이는 Guice는 Annotation의 LookUp이나 필드의 값 대입에 Reflection을 사용하는데(그런데, 느림), Butter Knife는 그렇지않고 빌드시에 코드를 생성합니다. 라고 (Reflection 하는건 `ButterKnife.inject `정도).

[Jake Wharton씨가 Google+에 투고. Mar 26, 2013](https://plus.google.com/+JakeWharton/posts/bWawKt8jqyi)

```
Ondřej Kroupa:
Seems nice, but what is main advantage to android-annotations library?

Jake Wharton:
This is a tiny, purpose-built library whereas AA is an application framework.
```

[AndroidAnnotations](http://androidannotations.org/)에서도 `@ViewById`나 `@Click`을 사용해 동일하게 쓸수있지만 느리네? 라는 질문에 대해서는, AndroidAnnotations는 여러가지 가능한 어플리케이션 프레임워크이지만, Butter Knife는 View의 Injection만을 특화시킨 심플라이브러리이다. 라고

다른 사람도 Butter Knife의 소개 기사를 작성하고 있습니다만,

[5 Reasons You Should Use Butterknife For Android](http://www.thekeyconsultant.com/2013/09/5-reasons-you-should-use-butterknife.html)

```
3. You find AndroidAnnotations to be overkill for your project.

AndroidAnnotations is a cool idea. It has tons of features
and more are being added all the time.
Depending on which camp you are in, adding features can be both a blessing and curse.
If you want to use annotations to inject everything imaginable
then definitely give AndroidAnnotations a look.
I am not 100% sold on the annotating and injecting of everything just yet.
For now views, viewholders, and OnClickListeners is enough for me.
```

AndroidAnnotations을 사용하고 있다면 그걸로도 충분하고, 혹시, 이 프로젝트는 거기까지는 필요 없다라고 생각한다면 Butter Knife을 써보자라고, 잘 분간해서 사용하면 되잖아, 라고.

AndroidAnnotations을 사용하면, HogeActivity에 대해서 Injection된 HogeActivity_ 클래스가 생성되니깐, `startActivity(new Intent(this, HogeActivity_.class))`라고 작성하거나 AndroidManifest.xml에　`<activity android:name=".HogeActivity_" />`라고 작성하지 않으면 안되는것이 개인적으로는 조금 불편합니다.(그러고 보니 AndroidAnnotations을 만든 [Pierre-Yves Ricau](https://github.com/pyricau)씨도 Square 소속입니다)

나도 findViewById를 무시할정도라면 굳이 사용할 필요는 없다고 생각하고 있었기때문에, 사용하기 시작해보면 정말로 편리하므로 추천합니다.

최후로 여담입니다만, 이 "Butter Knife"라는 이름은 재치가 있다고 생각합니다.

- Dagger (단도)는 여러가지가 가능하다. 베거나 찌르거나 깎아내거나
- Butter knife (버터 나이프)는 빵에 버터를 바르는것밖에 안된다. 하지만, 빵에 버터를 바를때는 편리하다

그러므로, 뭐든지 되는(Dependency Injector) [Dagger](http://square.github.io/dagger/) 에 비해, 빵에 버터를 바르는 (View를 Inject한다) 것밖에 안되지만, 그 용도만으로도 편리하다라는 의미로 Butter Knife라는 이름으로 했지않을까라고 생각한다

[Butter Knife - View "injection" library for Android](http://jakewharton.github.io/butterknife/)
