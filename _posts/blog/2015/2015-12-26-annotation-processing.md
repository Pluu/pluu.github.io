---
layout: post
title: "[번역] Annotation Processing(apt) 정리 + AndroidAnnotations(AA)과 AutoValue 샘플 코드를 적어봤다"
date: 2015-12-26 01:00:00
tag: [Android, APT]
categories:
- blog
- Android
---

본 포스팅은 [Annotation Processing(apt)のまとめ＋AndroidAnnotations(AA)とAutoValueのサンプルコード書いてみた。](http://qiita.com/shiraji/items/ed674c5883ed0520791b) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

## 서론

원래는 [@takahirom](http://qiita.com/takahirom)씨가 담당하는 날이었지만. 벌써 누가 신청했다고 말했더니 양보받을 수 있었습니다. 대단히 감사합니다!

[@takahirom](http://qiita.com/takahirom)씨와 어느 공부 모임에서 만난 것을 계기로 [PreLollipopTransition](https://github.com/takahirom/PreLollipopTransition) 등으로 엮인 인연으로 친해졌습니다. [@takahirom](http://qiita.com/takahirom)씨의 기사를 기대하고 계셨던 분들은 [이쪽](http://techblog.yahoo.co.jp/android/androidcoordinatorlayout/)을 봐주세요.

## 도대체 누구?

본론에 들어가기 전에, 도대체 너는 누구냐? 왜 APT를 다루느냐? 라는 사람이 많으실 거라고 생각돼서, 자기소개하겠습니다. Annotation Processing Tool(또는 APT)에서의 코드 자동 생성을 무척 좋아해 스스로 만든 [State Pattern용 API  라이브러리](http://qiita.com/shiraji/items/c0995e70f8a04250ede4)를 [공개](https://github.com/shiraji/kenkenpa)한 것으로 모자라, Android 라이브러리에서 Annotation이라고 하면, AndroidAnnotations(AA)이라고 해서, PR을 보내기 시작했습니다. 조금 전에 몇 개의 PR이 머지 되었습니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/20058/00277ba0-f7ca-f37d-a90b-e0571a5bfd90.png" />

(Collaborator는 아닙니다.)

그러므로, 어느 정도 APT에 대해서 이해했다고 생각하지만, 잘못 이해했을 가능성도 있으므로, 그 점은 부드럽게 지적해 주시길 바랍니다.

## 본론

Annotation Processing를 최근 1년간 계속 다루고, 여러 가지 알게 된 사실이 늘어서 참고가 되는 기사나 샘플 코드를 정리하고자 합니다.

## Annotation Processing(APT)는 무엇인가?

[@opengl-8080](http://qiita.com/opengl-8080)씨의 [Pluggable Annotation Processing API 使い方メモ](http://qiita.com/opengl-8080/items/beda51fe4f23750c33e9)가 아주 자세하게 기재되어 있습니다.

어떻게 Android개발시 이용될까는 Jake씨의 [발표 Slide](https://speakerdeck.com/jakewharton/annotation-processing-boilerplate-destruction-droidcon-nyc-2014)를 참고해주세요.

APT 라이브러리가 왜 유행하고 있는가를 간단하게 정리하면

- Reflection등과 다르게 실제 코드를 생성하므로 오버헤드가 없다(ButterKnife와 같이 생성한 코드 안에서 Reflection을 사용한 라이브러리도 있습니다.)
- 라이브러리로서 런타임으로 포함되는 코드량이 적으므로(또는 없다), apk 사이즈를 작게 유지할 수 있다.
- 실제로 생성한 코드를 확인할 수 있으므로 디버그하기 쉽다.

## APT 라이브러리의 사용처

APT 라이브러리의 특징은 아래와 같이 많은 인상이 있습니다.

- 개발자의 대부분 사람이 쓰지 않으면 안되는 코드를 쓰지않아도 되도록 한다.
- 특수한 사용법을 하려는 기능은 구현하지 않는다.
- 필요한 코드만 생성한다

이 특징으로부터, 저는 APT 라이브러리 선정 기준을 아래와 같이 합니다.

- dependancies 지정이 provided로 가능하므로, 기능이 뛰어나다면 바로 도입.
- compile지정할 것은 무엇이 runtime시 필요한 것인가 확인하고, 기능이 뛰어나고 늘어나는 파일 사이즈에 따라서 도입한다.

개발 중 어플리케이션의 도입 시는 이하의 부분이 신경을 씁니다.

- 신규 Class에의 도입은 특히 문제가 없으므로, 익숙해질 때까지는 신규 Class에 대해서만 도입한다.
- 기존에 도입할 때는, 생성된 코드와 중복 코드에 요주의. Refactoring은 필수. 다시 만들 가능성도 큼. 무시하지 않는다. 소중하게.

## APT 만들어 보자!

[@rejasupotaro](http://qiita.com/rejasupotaro)씨의 [Android에서 apt 라이브러리를 만들때의 고속도로](http://qiita.com/rejasupotaro/items/b9b89f88348222b46708)라는 멋진 기사가 있으므로 이쪽을 참조해주세요.

### APT 라이브러리 작성에 필요한 Tool

중복일지도 모르지만, APT 라이브러리 작성시에 유용한 라이브러리가 있으므로, 그것을 소개하겠습니다.

#### [android-apt](https://bitbucket.org/hvisser/android-apt)

Android Studio에서 APT 라이브러리를 움직이기 위해 유용한 gradle plugin. 공식으로는 2가지 유용한 포인트를 다루고 있습니다.

- Annotation Processing 라이브러리를 컴파일 시에만 포함되도록 할 수 있다.
- Source Path를 올바르게 설정해주기 때문에, 자동 생성된 소스를 Android Studio상에서 확인할 수 있다.

매우 좋은 plugin으로 최근 Annotation Processing 라이브러리에서는 많은 라이브러리가 소개 단계에서 채택되고 있습니다.

Android Gradle Plugin에 포함되면 좋을 텐라고 하는 사람도 상당히 있습니다. 저도 포함해서.

이런 느낌으로 사용합니다.

build.gradle

```groovy
buildscript {
    repositories {
        jcenter()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:1.3.0'
        classpath 'com.neenbedankt.gradle.plugins:android-apt:1.8'
    }
}
```

app/build.gradle

```groovy
apply plugin: 'com.android.application'
apply plugin: 'com.neenbedankt.android-apt' // android-apt를 지정

android {
    compileSdkVersion 23
    buildToolsVersion "23.0.1"

    defaultConfig {
        applicationId "com.github.shiraji.sample"
        minSdkVersion 14
        targetSdkVersion 23
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

// 여러개의 apt를 쓰면 중복해서 컴파일 에러가 될 수 있으므로. 우선 이걸로
android {
    packagingOptions {
        exclude 'META-INF/services/javax.annotation.processing.Processor'
    }
}

dependencies {
    provided 'com.github.shiraji:kenkenpa:1.0.3'
    apt 'com.github.shiraji:kenkenpa-compiler:1.0.3' // apt지정이 가능하도록 한다.
}
```

build.gradle 지정 이외에는 특히 아무것도 하지 않아도 되므로, 사용이 편리합니다.

#### [Javapoet](https://github.com/square/javapoet)

코드 생성을 하는 코드는 상당히 복잡해, 변수 하나 작성하거나 읽거나 하는데 매우 많은 코딩이 필요합니다. 그것을 편리하게 해주는 라이브러리가 Javapoet. 새로운 Annotation Processing 라이브러리를 작성한다면 필수라고 생각합니다.

덧붙여서, 아래에 소개하는 라이브러리 중, square씨 이외의 것은 아직 이 라이브러리를 도입하지 않는 것도 있고, 그 프로젝트의 코드 읽기는 상당히 힘들다고 생각합니다.

Javapoet의 자세한 내용은 [@opengl-8080](http://qiita.com/opengl-8080)씨의 [JavaPoet 사용법 메모](http://qiita.com/opengl-8080/items/87f850c6b2467ad4da32)가 자세하게 되어 있습니다.

#### [jcodemodel](https://github.com/phax/jcodemodel)

com.sun.codemodel을 fork한 라이브러리. Javapoet를 사용하지 않는 라이브러리에서 이용하고 곳도 있다. com.sun.codemodel의 사용하기 어려운 부분이 수정되어 있습니다. 역사도 길고, 2005년경부터 개발되고 있습니다. 지금부터 새롭게 만든다면, 아쉽지만, Javapoet을 이용하는 편이 단순하게 구성할 수 있다고 생각합니다.

## Android의 APT Plugin

유명한 것

- [AndroidAnnotations](http://androidannotations.org/)
- [AutoValue](https://github.com/google/auto/tree/master/value)
- [ButterKnife](http://jakewharton.github.io/butterknife/)
- [Dagger 2](http://google.github.io/dagger/)
- [Hugo](https://github.com/JakeWharton/hugo)
- [PermissionsDispatcher](https://github.com/hotchemi/PermissionsDispatcher)

개발이 멈춰있습니다만, 일본에서 유명한 [JsonPullParser](https://github.com/vvakame/JsonPullParser)도 Annotation Processing을 이용하고 있습니다.

곧 정식판이 되는 [Android-Orma](https://github.com/gfx/Android-Orma)도 재미있어 보입니다. 언젠가 PR을 보내기 위해서 노리고 있습니다.

이 중에서 제가 자주 사용하고 있는 AndroidAnnotations/AutoValue의 사용법 등을 소개하고자 합니다.

## AndroidAnnotations(AA)

AA는 역사가 길고, 2010년부터 개발되어왔고, [eBusinessInformation](http://www.ebusinessinformation.fr/)라는 회사가 스폰서가 되어 코어 커미터를 붙여, AA 개발이 활발하게 이루어지도록 도와주고 있습니다.

이 프로젝트의 개발에 자신이 관여하게 된 것은 2015년 10월경에, 위와 같이 어차피 맘에 든다면 가장 멋진 곳에서 코드를 적겠다! 라는 마음으로 참가했습니다.

이런 루즈한 개발자라도 받아준 요인을 이야기하면

- issue Label이 제대로 하고 있다.
- 어느 토론장에서도 응답이 빠르다.
- 기술 수준이 높고, 코드 리뷰의 지적이 날카롭다.
- 영어를 잘 못 해도 의외로 어떻게든 된다.
- 커맨드 하나로 테스트를 제대로 해준다.

특히 `ContributionWelcome` Label은 도움이 되었습니다.

그럼, 그런 AA이지만, AOSP의 개발속도가 너무 빨라서, 개발자 부족에 빠져있습니다.

꽤 중요한 기능도 뒷전으로로 하지 않을 수 없는 상황입니다.

일본의 Androider 중에서 OSS 하고 싶다고 생각하고 계시는 분은 꼭 함께하지 않겠습니까?

### AA를 사용해 보자

마음대로 AA의 소개 + 권유했지만, 실제로 어느  정도 사용할까? 라는 것을 설명하고 싶습니다.

이것도 예상대로 이미 Qiita에 있고, [@hiroq](http://qiita.com/hiroq)씨가 공개한, [Android Studio에서 AndroidAnnotations3.2을 사용하는 방법](http://qiita.com/hiroq/items/2df437733e3fdfe0e507)을 읽고 그대로 하면 이용 가능합니다.

그 순서에 따라, 간단한 Fragment를 사용한 Activity 이동이 있는 프로젝트를 만들어 봅니다.

현재 AA의 최신 버전은 3.3.2이므로, 그것을 이용합니다.

MainActivity.java

```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button toAAButton = (Button) findViewById(R.id.to_aa_button);
        toAAButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AAActivity_.intent(MainActivity.this).start();
            }
        });
    }
}
```

AAActivity.java

```java
@EActivity(R.layout.aaactivity_layout)
public class AAActivity extends AppCompatActivity {
    @ViewById(R.id.textView)
    TextView mTextView;

    @Background(delay = 2000)
    void doInBackgroundAfterTwoSeconds() {
        logTextView();
    }

    @UiThread(delay = 1000)
    void doInUiThread() {
        mTextView.setText(R.string.changed);
    }

    @AfterViews
    void afterInject() {
        logTextView();

        doInBackgroundAfterTwoSeconds();
        doInUiThread();
    }

    private void logTextView() {
        Log.i("AAActivity", "TextView: " + mTextView.getText());
    }
}
```

AAFragment

```java
@EFragment(R.layout.aafragment_layout)
public class AAFragment extends Fragment {
}
```

aaactivity_layout.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="AAActivity"
        android:textAppearance="?android:attr/textAppearanceLarge" />

    <fragment
        android:id="@+id/efragment"
        android:name="com.github.shiraji.aa_sample.AAFragment_"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

</LinearLayout>
```

AndroidManifest.xml

```java
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.github.shiraji.aa_sample">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity android:name=".AAActivity_" />

    </application>

</manifest>
```

app/build.gradle

```diff
apply plugin: 'com.android.application'
+apply plugin: 'android-apt'
+
+def AAVersion = '3.3.2'

android {
    compileSdkVersion 23
    buildToolsVersion "23.0.1"

    defaultConfig {
        applicationId "com.github.shiraji.aa_sample"
        minSdkVersion 14
        targetSdkVersion 23
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    testCompile 'junit:junit:4.12'
    compile 'com.android.support:appcompat-v7:23.1.1'
+
+    apt "org.androidannotations:androidannotations:$AAVersion"
+    compile "org.androidannotations:androidannotations-api:$AAVersion"
}
+
+apt {
+    arguments {
+        androidManifestFile variant.outputs[0]?.processResources?.manifestFile
+    }
+}
```

생성된 코드

AAActivity_.java

```java
public final class AAActivity_
    extends AAActivity
    implements HasViews, OnViewChangedListener
{

    private final OnViewChangedNotifier onViewChangedNotifier_ = new OnViewChangedNotifier();
    private Handler handler_ = new Handler(Looper.getMainLooper());

    @Override
    public void onCreate(Bundle savedInstanceState) {
        OnViewChangedNotifier previousNotifier = OnViewChangedNotifier.replaceNotifier(onViewChangedNotifier_);
        init_(savedInstanceState);
        super.onCreate(savedInstanceState);
        OnViewChangedNotifier.replaceNotifier(previousNotifier);
        setContentView(layout.aaactivity_layout);
    }

    private void init_(Bundle savedInstanceState) {
        OnViewChangedNotifier.registerOnViewChangedListener(this);
    }

    @Override
    public void setContentView(int layoutResID) {
        super.setContentView(layoutResID);
        onViewChangedNotifier_.notifyViewChanged(this);
    }

    @Override
    public void setContentView(View view, LayoutParams params) {
        super.setContentView(view, params);
        onViewChangedNotifier_.notifyViewChanged(this);
    }

    @Override
    public void setContentView(View view) {
        super.setContentView(view);
        onViewChangedNotifier_.notifyViewChanged(this);
    }

    public static AAActivity_.IntentBuilder_ intent(Context context) {
        return new AAActivity_.IntentBuilder_(context);
    }

    public static AAActivity_.IntentBuilder_ intent(android.app.Fragment fragment) {
        return new AAActivity_.IntentBuilder_(fragment);
    }

    public static AAActivity_.IntentBuilder_ intent(android.support.v4.app.Fragment supportFragment) {
        return new AAActivity_.IntentBuilder_(supportFragment);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (((SdkVersionHelper.getSdkInt()< 5)&&(keyCode == KeyEvent.KEYCODE_BACK))&&(event.getRepeatCount() == 0)) {
            onBackPressed();
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onViewChanged(HasViews hasViews) {
        mTextView = ((TextView) hasViews.findViewById(id.textView));
        afterInject();
    }

    @Override
    public void doInUiThread() {
        handler_.postDelayed(new Runnable() {


            @Override
            public void run() {
                AAActivity_.super.doInUiThread();
            }

        }
        , 1000L);
    }

    @Override
    public void doInBackgroundAfterTwoSeconds() {
        BackgroundExecutor.execute(new BackgroundExecutor.Task("", 2000, "") {


            @Override
            public void execute() {
                try {
                    AAActivity_.super.doInBackgroundAfterTwoSeconds();
                } catch (Throwable e) {
                    Thread.getDefaultUncaughtExceptionHandler().uncaughtException(Thread.currentThread(), e);
                }
            }

        }
        );
    }

    public static class IntentBuilder_
        extends ActivityIntentBuilder<AAActivity_.IntentBuilder_>
    {

        private android.app.Fragment fragment_;
        private android.support.v4.app.Fragment fragmentSupport_;

        public IntentBuilder_(Context context) {
            super(context, AAActivity_.class);
        }

        public IntentBuilder_(android.app.Fragment fragment) {
            super(fragment.getActivity(), AAActivity_.class);
            fragment_ = fragment;
        }

        public IntentBuilder_(android.support.v4.app.Fragment fragment) {
            super(fragment.getActivity(), AAActivity_.class);
            fragmentSupport_ = fragment;
        }

        @Override
        public void startForResult(int requestCode) {
            if (fragmentSupport_!= null) {
                fragmentSupport_.startActivityForResult(intent, requestCode);
            } else {
                if (fragment_!= null) {
                    if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) {
                        fragment_.startActivityForResult(intent, requestCode, lastOptions);
                    } else {
                        fragment_.startActivityForResult(intent, requestCode);
                    }
                } else {
                    if (context instanceof Activity) {
                        Activity activity = ((Activity) context);
                        ActivityCompat.startActivityForResult(activity, intent, requestCode, lastOptions);
                    } else {
                        if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) {
                            context.startActivity(intent, lastOptions);
                        } else {
                            context.startActivity(intent);
                        }
                    }
                }
            }
        }

    }

}
```

AAFragment_.java

```java
public final class AAFragment_
    extends com.github.shiraji.aa_sample.AAFragment
    implements HasViews
{

    private final OnViewChangedNotifier onViewChangedNotifier_ = new OnViewChangedNotifier();
    private View contentView_;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        OnViewChangedNotifier previousNotifier = OnViewChangedNotifier.replaceNotifier(onViewChangedNotifier_);
        init_(savedInstanceState);
        super.onCreate(savedInstanceState);
        OnViewChangedNotifier.replaceNotifier(previousNotifier);
    }

    @Override
    public View findViewById(int id) {
        if (contentView_ == null) {
            return null;
        }
        return contentView_.findViewById(id);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        contentView_ = super.onCreateView(inflater, container, savedInstanceState);
        if (contentView_ == null) {
            contentView_ = inflater.inflate(layout.aafragment_layout, container, false);
        }
        return contentView_;
    }

    @Override
    public void onDestroyView() {
        contentView_ = null;
        super.onDestroyView();
    }

    private void init_(Bundle savedInstanceState) {
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        onViewChangedNotifier_.notifyViewChanged(this);
    }

    public static AAFragment_.FragmentBuilder_ builder() {
        return new AAFragment_.FragmentBuilder_();
    }

    public static class FragmentBuilder_
        extends FragmentBuilder<AAFragment_.FragmentBuilder_, com.github.shiraji.aa_sample.AAFragment>
    {


        @Override
        public com.github.shiraji.aa_sample.AAFragment build() {
            AAFragment_ fragment_ = new AAFragment_();
            fragment_.setArguments(args);
            return fragment_;
        }

    }

}
```

어떻게 하면 Background 처리를 실행할지 등을 생각할 필요가 없습니다. Background에서의 처리인가, UiThread인가 등을 메소드에서 명확하게 나누는 것도 코드를 읽기 쉽게 합니다.

프로젝트 전체에 AA를 반영시키는 것이 가장 좋다고 생각합니다만, 기존 Application이라도 신규 추가하는 Class부터 AA를 이용할 수 있다고 증명하기 위해, MainActivity는 AA를 이용하지 않습니다.

[샘플 코드](https://github.com/shiraji/aa-sample)는 GitHub이 올려져 있습니다.

그 밖에도 예를들면, version에 따라서, `getColor()`을 `Resource`에서 얻을 것인가, `ContextCompat`에서 할것인가 등을 이용하고 있는 라이브러리의 버전 차이를 흡수하고 있습니다.

이것이 바로 AA가 하고 싶은 것이다.

> [AA] takes care of the plumbing, and lets you concentrate on what's really important.1

이외의 기능에도 관심이 있으신 분은 AA가 제공하고 있는 [Annotation 리스트](https://github.com/excilys/androidannotations/wiki/AvailableAnnotations)를 참조해주세요.

또한, 최근 유행하는 Kotlin에서도 AA을 이용할 수 있는 것이 kotlin 공식 블로그 [Better Annotation Processing: Supporting Stubs in kapt](http://blog.jetbrains.com/kotlin/2015/06/better-annotation-processing-supporting-stubs-in-kapt/)에서 kapt의 사용법의 샘플로 소개되고 있습니다. AA의 Contributor씨들도 Kotlin에서의 동작을 확인했습니다. Kotlin의 이용을 생각하시는 분은 꼭 이쪽을 확인해 주세요.

### AA의 다음 버전에 대해서

샘플 코드를 작성까지 도입을 촉구했습니다만, 실은 다음 버전 업데이트는 메이저 버전 업데이트로 v4.0.0이 됩니다.

이 버전이 언제 배포 될 것인가는 현재 이야기 중입니다. 확실한 날짜는 모릅니다만,[allow method injection](https://github.com/excilys/androidannotations/pull/1457)은 Merge하고싶다는 이야기가 나와있고, 이 투고의 수시간전에 Merge되었습니다(몹시 당황해서 문장을 바꿨습니다.). 이 issue의 wiki가 완성되는대로, 배포 준비에 착수될 가능성이 큽니다.

어떤 기능이 v4.0.0에 포함되는가는  [milestone 4.0](https://github.com/excilys/androidannotations/issues?page=1&q=milestone%3A4.0+is%3Aclosed)를 확인해주세요. 이행방법 문서도 작성 예정입니다.

만약, 지금부터 신규로 도입을 검토한다면 v4.0.0이 안정된 버전이 된 시점에 도입검토를 하는 것을 추천합니다.

## AutoValue

[Mobile DevOps Advent Calendar](http://qiita.com/advent-calendar/2015/mobile-devops) 2일째 [극적으로 Android개발을 편하게 하는 코드의 자동생성, 2개의 중대한 사용처](http://qiita.com/kikuchy/items/7c95573acdfa758695ab)의 [@kikuchy](http://qiita.com/kikuchy)씨로부터 전달받아서, AutoValue의 사용법도 소개합니다. (기대에 부응하지 못한 기분도 듭니다만...)

라고 해도, AutoValue의 샘플 코드도 이미 Qiita에 있으므로, [@rejasupotaro](http://qiita.com/rejasupotaro)씨의 [자동 생성에 의한 Class 작성의 보조#auto](http://qiita.com/rejasupotaro/items/e2eb047b14a4255fb516#auto)를 보시면 알기 쉬우실거입니다.

단지, 이 기사가 투고된 후 2015년 8월에 매우 [대단한 기능이 Merge](https://github.com/google/auto/pull/265)되었습니다. 아직 SNAPSHOT 버전으로만 공개되었지만, 이 기능에의해 AutoValue를 확장하는것도 가능합니다.

이미 몇가지 확장 라이브러리가 작성되어 공개되어 있습니다.

- [AutoValue: Gson Extension](https://github.com/rharter/auto-value-gson)
- [AutoValue: Parcel Extension](https://github.com/rharter/auto-value-parcel)
- [AutoValue: Cursor Extension](https://github.com/gabrielittner/auto-value-cursor)

확장 라이브러리인 AutoValue: Parcel Extension을 사용해서 코드를 생성해보려고 합니다. (정식판이 배포되면 순서는 수정합니다.)

sonatype 설정을 추가해서, AutoValue의 SNAPSHOT을 사용하도록 합니다.

조금 전 기재한, android-apt도 사용하도록 합니다.

build.gradle

```diff
@@ -3,10 +3,14 @@
 buildscript {
     repositories {
         jcenter()
+        mavenCentral()
+        maven {
+            url = 'https://oss.sonatype.org/content/repositories/snapshots'
+        }
     }
     dependencies {
         classpath 'com.android.tools.build:gradle:1.3.0'
-
+        classpath 'com.neenbedankt.gradle.plugins:android-apt:1.8'
         // NOTE: Do not place your application dependencies here; they belong
         // in the individual module build.gradle files
     }
 @@ -15,6 +19,9 @@ buildscript {
 allprojects {
     repositories {
         jcenter()
+        maven {
+            url = 'https://oss.sonatype.org/content/repositories/snapshots'
+        }
     }
 }
```

AutoValue과 확장 라이브러리를 임포트합니다.

app/build.gradle

```diff
apply plugin: 'com.android.application'
+apply plugin: 'com.neenbedankt.android-apt'

android {
    compileSdkVersion 23
@@ -24,4 +25,7 @@ dependencies {
    testCompile 'junit:junit:4.12'
    compile 'com.android.support:appcompat-v7:23.1.1'
    compile 'com.android.support:design:23.1.1'
+
+    provided 'com.google.auto.value:auto-value:1.2-SNAPSHOT'
+    apt 'com.ryanharter.auto.value:auto-value-parcel:0.2-SNAPSHOT'
}
```

이걸로 설정 부분은 완료.

String foo와 int bar를 가지는 Parcelable Class를 만들고싶어서, 실제 코드를 적어봅니다.

AutoValueParcelSample.java

```java
@AutoValue
public abstract class AutoValueParcelSample implements Parcelable {

    public abstract String bar();

    public abstract int foo();

    public static AutoValueParcelSample create(String bar, int foo) {
        return new AutoValue_AutoValueParcelSample(bar, foo);
    }
}
```

이 클래스를 이용하려면 아래와 같이 코드를 적습니다.

MainActivity.java

```java
AutoValueParcelSample sample = AutoValueParcelSample.create("baaaar", 100);
Log.d("MainActivity", sample.toString());
```

이걸로 run 해봅니다.


```bash
D/MainActivity: AutoValueParcelSample{bar=baaaar, foo=100}
```

AutoValueParcelSample@1234a5 등이 아니라, 제대로 된 `toString()`이 작동하고 있습니다.

### AutoValue의 코드 설명

구현한 코드와 생성 코드를 설명합니다.

갑자기 나온 AutoValue_AutoValueParcelSample은 뭐지? 라고하면, 이것이 Annotation Processing으로 자동생성된 Class입니다.

AutoValue에서는, 반드시 생성된 Class는 AutoValue_라는 prefix가 붙는 구조입니다. 확장 라이브러리도 AutoValue_가 붙습니다. 하지만, create 함수에서 생성방법을 제공하므로, AutoValueParcelSample을 사용하는 사람은 AutoValue_AutoValueParcelSample의 존재를 몰라도 특별히 문제없습니다.

실제로 생성된 AutoValue_AutoValueParcelSample을 봅시다.

파일은 `app/build/generated/source/apt`아래에 있습니다.


```java
final class AutoValue_AutoValueParcelSample extends $AutoValue_AutoValueParcelSample {
  private static final ClassLoader CL = AutoValue_AutoValueParcelSample.class.getClassLoader();

  public static final Parcelable.Creator<AutoValue_AutoValueParcelSample> CREATOR = new android.os.Parcelable.Creator<AutoValue_AutoValueParcelSample>() {
    @java.lang.Override
    public AutoValue_AutoValueParcelSample createFromParcel(android.os.Parcel in) {
      return new AutoValue_AutoValueParcelSample(in);
    }
    @java.lang.Override
    public AutoValue_AutoValueParcelSample[] newArray(int size) {
      return new AutoValue_AutoValueParcelSample[size];
    }
  };

  AutoValue_AutoValueParcelSample(String bar, int foo) {
    super(bar, foo);
  }

  private AutoValue_AutoValueParcelSample(Parcel in) {
    super(
      in.readString(),
      in.readInt()
    );
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(bar());
    dest.writeInt(foo());
  }

  @Override
  public int describeContents() {
    return 0;
  }
}
```

Parcelable에 대한 처리가 기재되어 있습니다.

새로운 Class인 $AutoValue_AutoValueParcelSample를 확인할 수 있습니다.


```java
abstract class $AutoValue_AutoValueParcelSample extends AutoValueParcelSample {

  private final String bar;
  private final int foo;

  $AutoValue_AutoValueParcelSample(
      String bar,
      int foo) {
    if (bar == null) {
      throw new NullPointerException("Null bar");
    }
    this.bar = bar;
    this.foo = foo;
  }

  @Override
  public String bar() {
    return bar;
  }

  @Override
  public int foo() {
    return foo;
  }

  @Override
  public String toString() {
    return "AutoValueParcelSample{"
        + "bar=" + bar + ", "
        + "foo=" + foo
        + "}";
  }

  @Override
  public boolean equals(Object o) {
    if (o == this) {
      return true;
    }
    if (o instanceof AutoValueParcelSample) {
      AutoValueParcelSample that = (AutoValueParcelSample) o;
      return (this.bar.equals(that.bar()))
           && (this.foo == that.foo());
    }
    return false;
  }

  @Override
  public int hashCode() {
    int h = 1;
    h *= 1000003;
    h ^= this.bar.hashCode();
    h *= 1000003;
    h ^= this.foo;
    return h;
  }

}
```

이 Class에서는, 기존의 AutoValue가 제공하는 `toString()`/`equals()`/`hashCode()`의 자동생성한 코드가 포함되어 있습니다. Class 구성은 이런 느낌입니다.


```bash
Parcelable
   └── AutoValueParcelSample // 작성한 코드
        └── $AutoValue_AutoValueParcelSample // 자동 생성된 auto-value가 제공하는 구현 코드
             └── AutoValue_AutoValueParcelSample // 자동 생성된 Parcelable의 구현 코드
```

전부 갖춘 [소스](https://github.com/shiraji/auto-value-parcel-sample)도 확인해주세요.

※AutoValue에는 이외에도 독자적인 `toString()`/`equals()`/`hashCode()`함수의 구현(underride)이나 Builder Class 작성도 가능합니다. 상세는 [README](https://github.com/google/auto/tree/master/value#autovalue)를 확인해주세요.

provided으로 지정하므로, 코드 생성으로 이용한 코드는 apk에 포함되지 않습니다. [ClassyShark](https://github.com/google/android-classyshark)로 확인해보세요.

<img src="https://qiita-image-store.s3.amazonaws.com/0/20058/fceee7e4-c5d6-8412-5222-7ddd5b292f3b.png" />

apk안에는 support 라이브러리만 포함되어있습니다.(단순히 ClassyShark를 사용해보고 싶었습니다!)

## 마지막으로

이 기사에서 멘션, 기사 소개, 라이브러리를 소개된 분들, 마음대로 기재해서 대단히 죄송합니다. 비판하는 것 같은 내용을 적을 생각은 없습니다만, 지우고 싶으신 분이 계시면, Twitter의 @shiraj_i 쪽으로 멘션주세요. 즉시 대응합니다.

## 주석

1. [http://androidannotations.org/](http://androidannotations.org/)
