---
layout: post
title: "Android Studio Tips #2"
date: 2019-07-25 00:00:00 +09:00
tag: [Android Studio]
categories:
- blog
- Android Studio
---

Android Studio 에 숨어있는 꿀팁 등 다양한 기능을 공유하는 포스팅입니다.

<!--more-->

- - -

연재 글

- [Android Studio Tips #1]({{ site.baseurl }}/blog/android studio/2019/07/13/android-studio-tip1/)

- - -

## Templates in Android Studio

개발 시에 반복적으로 일정한 형태의 코드를 작성하는 것은 많이 경험한다. 더 효과적으로 코드 블록 및  파일을 제공하기 위해서 Templates가 존재한다. 예를 들어, Android Studio에서는 Activity, Fragment, Resource와 같은 Files을 만들거나 Toast, findViewById 등 Template 형태를 제공한다.

그리고, Android Studio에는 대략 아래의 Templates 가 존재한다.

- Android Templates
- File and Code Templates
- Live Templates

### Android Templates

Android Templates 라고 지칭하는 것은 `New` Menu에서 노출되는 것 중 하단 `Android` 아이콘이 섬네일로 노출되는 부분을 이야기한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/01.png" }}" /> 

위 Template는 Android Studio 설치 시 기본적으로 제공하고 있다. 해당 Template은 Mac의 경우 `/Applications/{Application Name}/Contents/plugins/android/lib/templates` 하단에 실제 파일들이 있다.

```
activities
├── BasicActivity
│   ├── globals.xml.ftl
│   ├── recipe.xml.ftl
│   ├── recipe_fragment.xml.ftl
│   ├── root
│   │   ├── res
│   │   │   └── layout
│   │   │       ├── activity_fragment_container.xml.ftl
│   │   │       └── fragment_simple.xml.ftl
│   │   └── src
│   │       └── app_package
│   │           ├── SimpleActivity.java.ftl
│   │           ├── SimpleActivity.kt.ftl
│   │           ├── SimpleActivityFragment.java.ftl
│   │           └── SimpleActivityFragment.kt.ftl
│   ├── template.xml
│   ├── template_basic_activity.png
│   └── template_basic_activity_fragment.png
├── ...
```

**templates** 내부에는 다양하게 Template 이 존재하며 `BasicActivity` 의 경우 위와 같은 형태로 구성되어 있다. 그러나, `Android Templates` 는 FreeMarker Template Language로 만들어져있다 (확장자 ftl). FreeMarker Template Language는 Template 엔진으로 Template를 기반으로 생성하고 변경하는 Java 라이브러리이다.

> Apache FreeMarker™ is a template engine: a Java library to generate text output (HTML web pages, e-mails, configuration files, source code, etc.) based on templates and changing data.

그러나 Java, Kotlin, XML 형태가 아니므로 이해하기 어려운 형태로 구성되어 있고, Android Studio가 업데이트될 때마다 **templates** 폴더가 갱신되므로, 커스텀으로 만들어서 사용한 경우 조금은 불편하지만, 매번 추가해줘야 한다.

**templates** 폴더의 아래에 넣어서 사용 시, Android Templates는 복잡한 형태와 복수의 파일을 하나의 그룹 형태로 제공할 수 있는 장점이 있다. 이렇게 함으로 특정 패턴으로 복수의 파일을 생성하는 수고를 덜 수 있다.

### File Templates

`Android Templates`만큼 복수의 파일을 생성할 수 없지만, 단일 파일을 **Templates** 형태로 제공하는 경우에는 `File Templates`로 제공할 수 있다. Kotlin Script, Singletone 등 아래에 Box로 감싼 리스트의 항목으로 제공한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/02.png" }}" />  

File Templates을 더 활용하는 방법의 하나는 Kotlind으로 CustomView 생성 시에 도움이 된다. 기본적으로 충족해야 할 Template 조건은 아래와 같다. 가장 많이 사용되는 패턴이다.

1. XML에서 접근 가능한 `@JvmOverloads`를 적용한 생성자 처리
2. `obtainStyledAttributes` 정의

해당 기능은 정의한 Templates는  `Preferences | Editor | File and Code Templates`에서 추가하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/03.png" }}" /> 

> 위 이미지와 같이 새로운 Template를 추가할 수 있다.

기본적으로 `${<VARIABLE_NAME>}`로 작성하며, 추가 변수로 정의하여 사용 시에 입력값으로 받을 수 있다. 그리고, 아래와 같이 미리 정의된 변수도 제공하고 있다.

| Key                 | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| ${PACKAGE_NAME}     | name of the package in which the new file is created         |
| ${NAME}             | name of the new file specified by you in the New <TEMPLATE_NAME> dialog |
| ${USER}             | current user system login name                               |
| ${DATE}             | current system date                                          |
| ${TIME}             | current system time                                          |
| ${YEAR}             | current year                                                 |
| ${MONTH}            | current month                                                |
| ${MONTH_NAME_SHORT} | first 3 letters of the current month name. Example: Jan, Feb, etc. |
| ${MONTH_NAME_FULL}  | full name of the current month. Example: January, February, etc. |
| ${DAY}              | current day of the month                                     |
| ${DAY_NAME_SHORT}   | first 3 letters of the current day name. Example: Mon, Tue, etc. |
| ${DAY_NAME_FULL}    | full name of the current day. Example: Monday, Tuesday, etc. |
| ${HOUR}             | current hour                                                 |
| ${MINUTE}           | current minute                                               |
| ${PROJECT_NAME}     | the name of the current project                              |

위에서 Kotlind으로 CustomView 작업시에 필요한 조건을 Template로 작성하면 아래와 같다. 

Kotlin 사용시 CustomView 작성과 ObtainStyledAttributes 처리 시 대략 아래와 같은 Template를 사용할 수 있다.

```
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}

#end
import android.content.Context
import android.util.AttributeSet
import android.view.View

#parse("File Header.java")
class ${NAME} @JvmOverloads constructor(
context: Context,
attrs: AttributeSet? = null,
defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {
   init {
       val attr = context.theme.obtainStyledAttributes(attrs, R.styleable.${NAME}, 0, 0)
       try {
           // TODO:
       } catch (e: Exception) {
           e.printStackTrace()
       } finally {
           attr.recycle()
       }
   }
}
```

현재 Template에서는 **PACKAGE_NAME**, **NAME**을 입력받고, **File Header.java** 를 이용해서 해당 위치의 Header 추가 처리를 하고 있다.

이렇게 추가한 `File and Code Templates`은 New Menu를 통해서 사용할 수 있다. 이로써, Custom View를 더욱 빠르게 작성할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/04.png" }}" /> 

#### 입력 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/05.png" }}" /> 

#### 결과 화면

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/06.png" }}" /> 

이렇게 우리가 원했던 코드를 한 번에 작성했다. 추가로 해야 할 일은 Custom View의 `styleable` 를 위한 Attribute 파일을 추가하기만 하면 된다.  

### Live Templates

앞서 알아본 Android Templates, File and Code Templates의 경우는 새로운 파일을 만드는 Template이다. 자주 사용되는 코드를 입력하고 싶을 때 사용하는 것이 `Live Templates`이다. 

`Live Templates` 를 적용하기 좋은 곳이 ConstraintLayout 혹은 LiveData 일 것 같다. 가장 일반적으로 많이 쓰는 형태로 작성해보면 아래와 같다.

```kotlin
private val _title: MutableLiveData<String> = MutableLiveData<String>()
val title: LiveData<String>
    get() = _title
```

이 코드에서 바뀌는 부분은 변수명과 LiveData에서 관리되는 Instance Type이다. 그리고, Template으로 한다면 아래처럼 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/07.png" }}" /> 

이렇게 색칠한 부분을 Template으로 변경하면 된다.

해당 기능은 정의한 Templates는 `Preferences | Editor | Live Templates` 에서 추가하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/08.png" }}" /> 

> Live Templates 화면

Live Templates의 우측 `+` 버튼을 이용해서 사용자가 원하는 형태로 `Live Template`를 만들거나 Template을 묶을 `Template Group`을 추가할 수 있다. 이번에는 Live Template를 사용한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/09.png" }}" /> 

> 위 이미지와 같이 새로운 Template를 추가할 수 있다.

실제 필요한 화면만 자세히 살펴보자.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/10.png" }}" /> 

- Abbreviation : Live Template으로 확장할 축약어
- Description : Live Template 설명
- Template text : 대치할 변수를 사용할 수 있는 템플릿
- 우측의 Edit variables : Template text에서 사용한 변수를 편집
- 하단 Change : Live Template을 사용할 수 있는 Langue와 Scope (ex, class, function 등)

```kotlin
private val _$NAME$: MutableLiveData<$TYPE$> = MutableLiveData<$TYPE$>()
val $NAME$: LiveData<$TYPE$>
    get() = _$NAME$
```

> LiveData를 위한 Template

기본적으로 `$<variable_name>$` 형태로 변수를 정의한다. 그러나 기존 Template와 다르게 미리 정의된 변수는 없다. 정의된 변수에 기본적으로 적용하기 위해서 `Edit variables Dialog` 를 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/11.png" }}" /> 

미리 정의된 수식을 사용할 수 있으며, 기본값, Live Template으로 코드가 추가된 후 입력을 Skip할 지 여부 체크도 가능하다. 

> [IntelliJ IDEA Help ~ Creating live templates](https://www.jetbrains.com/help/idea/creating-and-editing-live-templates.html)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/12.png" }}" /> 

> 적용할 Language와 Scope 화면

그리고,  Live Template을 사용할 수 있는 Langue와 Scope 선택할 수 있다.

## External Annotation

Android 개발 시 Framework, AndroidX, 3rd-party 라이브러리 등 다양한 소스를 이용해서 개발한다. 그리고, Kotlin 또한 Android 개발자에게 많은 호응을 얻어 사용하고 있다. 그러다 보니 Nullable에 민감한 Kotlin 사용 시 마주치는 NPE. 즉 `NullPointException`는 큰 고민 중 하나이다.

Null-Safe 한 로직이 주요 핵심이다. Null-Safe 한 로직을 위해서 Kotlin에서 가장 잘 알려진 방법의 하나로  `T?.`를 이용하는 것이다. `T?.` 를 이용함으로 Receiver인 T의 타입에 대해 안전하게 처리할 수 있다. 그리고, Java로 이루어진 기능을 사용 시 Annotation 부재로 인한 `Platform Type`을 안전하게 쓰는 것이다.

그러나, Platform Type을 사용 시에는 Null 혹은 NonNull 중 명확하게 알 수 없다. 누락된 Annotation이 언제 적용될지는 알 수 없으며 오랜 시간이 필요할 수 있다. 그래서, 내부 코드를 파악한 후 방어 코드로 의존하게 되는 현상이 발생한다. 이럴 때 `External Annotation`을 정의함으로 실제 Annotation이 정의된 것과 동일한 형태로 IDE에 노출된다.

> [IntelliJ IDEA Help ~ External annotations](https://www.jetbrains.com/help/idea/external-annotations.html)

### 사전 단계

예를들어, 아래와 같은 Java 코드를 Kotlin에서 사용할 경우를 생각해보자.

```java
// ExternalAnnotationSample.java
public class ExternalAnnotationSample {
    private String safeString;
    private String unsafeString;

    @Nullable
    public String getSafeString() {
        return safeString;
    }

    public String getUnsafeString() {
        return unsafeString;
    }
}
```

getSafeString는 Nullable, getUnsafeString는 확실한 타입을 알 수 없는 Platform Type으로 노출될 것이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/13.png" }}" /> 

> s1 = Nullable, s2 = Platform Type 으로 IDE가 인지하고 있다.

### Step1

먼저 Java에서 External Annotation을 활성화해야한다. 해당 기능은 `Preferences | Editor | Code Style | Java` 으로 이동 후 Code Generation 탭에서 Use external annotation을 체크하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/14.png" }}" /> 

### Step2

External Annotation을 지정하기 위해 Annotation이 정의되지 않은 곳에서 `⌥⏎` 키를 선택한 후, `Annotation method ~~~` 를 선택한다. 해당 기능은 사용한 쪽 및 정의된 코드에서 동일하게 정의할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/15.png" }}" /> 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/16.png" }}" /> 

### Step3

원하는 Annotation 중 하나를 선택하면 된다. 이번 예제에는 `Nullable` 처리를 노출하기 위해서 **org.jetbrains.annotations.Nullable**을 선택하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/17.png" }}" /> 

### 결과

이 동작으로 실제 코드에서 정의되지 않은 Annotation이 반영된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/18.png" }}" /> 

> s2는 Nullable로 인식하는 것으로 변경되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2019/0722-android-studio-tips/20.png" }}" /> 

> 그리고 소스의 가장 왼쪽에 **External Annotation** 을 표시하는  `@` 마크가 노출된다.

이로써 Nullable / NonNull 이 정의되지 않은 외부 소스로부터 한걸음 안전하게 개발을 할 수 있다. 그리고, `External Annotation` 은 Project에 별도 파일로 존재하므로 프로젝트를 사용하는 사람들과 공유할 수 있다.

```xml
<!-- annotations.xml -->
<root>
    <item
        name='com.pluu.sample.ExternalAnnotationSample java.lang.String getUnsafeString()'>
        <annotation name='org.jetbrains.annotations.Nullable' />
    </item>
</root>
```

## 참고

- [kingori님의 ConstraintLayout LiveTemplate](https://gist.github.com/kingori/fa4a71bf4e844b02d772d8c6d667fd32)
