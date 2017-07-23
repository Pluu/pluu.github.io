---
layout: post
title: "[번역] kapt의 generateStubs와 DI 도구와의 관계"
date: 2017-07-23 15:40:00 +09:00
tag: [Kotlin]
categories:
- blog
- Kotlin
---

본 포스팅은 [kapt の generateStubs と DI ツールとの関係](http://qiita.com/laprasDrum/items/417b48972ddefdc3b2cd) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

[Kotlin Advent Calendar 2015](http://www.adventar.org/calendars/857) 20일째를 담당합니다 [@laprasDrum](http://qiita.com/laprasDrum) 라고 くろねこ 입니다.

평소에는 Java/Kotlin의 Android 앱을 작성, Objective-C/Swift로 iOS 앱을 만듭니다.

이번에은 kapt의 이야기를 중심으로 합니다.

## kapt (Kotlin Annotation Processing) 란

Java6부터 도입된 Pluggable Annotation Processing API ([JSR 269](https://www.jcp.org/en/jsr/detail?id=269))를 Kotlin에서도 사용 가능하게 된 것입니다.
구현은 [kotlin/libraries/tools/kotlin-annotation-processing](https://github.com/JetBrains/kotlin/tree/master/libraries/tools/kotlin-annotation-processing/src/main/kotlin/org/jetbrains/kotlin/annotation)에 있습니다.

Pluggable Annotation Processing API 자체 설명은 [櫻庭씨의 관련 기사](http://itpro.nikkeibp.co.jp/article/COLUMN/20081219/321816/)에 알기 쉽게 정리되어 있습니다.

## 구상

Kotlin Blog에서 kapt가 언급된 것은 2015년 5월 말이므로 M12가 나오기 직전이네요.

[kapt: Annotation Processing for Kotlin](http://blog.jetbrains.com/kotlin/2015/05/kapt-annotation-processing-for-kotlin/)에서는 Java 이외의 언어가 Annotation Processor에 대응하는 3가지 방안을 말합니다.

- JSR 269를 재구현
   - 구현 비용은 그렇게 높지 않다 (내부 사람에 의하면)
   - Kotlin과 Java가 혼합된 프로젝트에서는 쓸모없다
   - Java와의 호환성을 고려하고 있는 Kotlin의 사상으로 Kotlin 만 혜택을 못 받는것은 좀 ...
- Kotlin 파일에서 Java 파일을 생성
   - 메소드의 내용까지 동작 보증하는 Java 파일을 생성하는 것은 상당한 어려움
   - Java의 Stub를 생성한다
   - [Groovy의 annotation processing 지원 방법이 거기에 해당된다](https://docs.gradle.org/2.4-rc-1/release-notes#support-for-%E2%80%9Cannotation-processing%E2%80%9D-of-groovy-code)
   - Stub 생성을 위한 컴파일, 생성 파일의 컴파일과 절차가 늘어나기 때문에 빌드 시간이 길어진다
- Java 파일의 Annotation 처리시에 Kotlin 파일의 Annotation 처리를 포함한다.
   - **일반 javac보다 먼저 kotlinc가 동작한다**
   - Kotlin 바이너리 파일은 javac 컴파일 대상이 된다
   - 그러나 javac는 Annotation이 부여된 Kotlin 파일까지 자동으로 포함시키는 기구는 없다
      - 구현은 가능하고 무엇보다 얻을 수 있는 혜택이 크다
      - 제약으로는 Kotlin 파일에서는 Annotation 처리에 의해 생성된 소스와 선언을 참조할 수 없다

Kotlin 개발팀은 세 번째 선택으로 이동하여 우리들은 kapt의 혜택을 받을 수 있게 되었습니다. 하지만 위의 포인트를 제대로 읽지 않고 개발하고 있으면 바로 문제에 부딪힙니다. 요즘의 Android 개발에서 반드시라고 말해도 좋을 정도 신세를 지는 DI 도구의 이야기입니다.

## kapt과 DI

여기서부터는 Dagger2를 이용한 Android 개발을 예로 합니다.

Dagger2을 비롯한 [JSR 330](https://jcp.org/en/jsr/detail?id=330)에 준거한 DI 도구는 **javac 실행시**에 Annotation을 처리하고 파일을 생성합니다.

Dagger2에서 생성되는 컴포넌트는 `@component`가 부여된 인터페이스 이름에 기반하고 클래스 이름이 결정되며, javac 실행 후에 클래스 참조가 가능합니다.

만약 컴포넌트를 다음과 같이 정의한 경우

```
// KaptamComponent
@Component(modules = arrayOf(AndroidModule::class, ...))
public interface KaptamComponent {
    ...
```
컴포넌트는 `DaggerKaptamComponent`로 참조할 수 있습니다.

### 빌드시의 고민

지금까지 Android Java만으로 Android 개발하고 있는 분은 생성 타이밍을 신경 쓸 일은 별로 없었다고 생각합니다. (저도 그랬습니다)

그러나 Kotlin를 도입함에 있어서 Kotlin 파일에서 컴포넌트를 참조하면 ...

```
Information:Gradle tasks [:app:assembleDebug]
...
:app:compileDebugKotlin
/path/to/your/file/which/refer/to/Component.kt
Error:(12, 20) Unresolved reference: DaggerKaptamComponent
Error:Execution failed for task ':app:compileDebugKotlin'.
> Compilation error. See log for more details
Information:BUILD FAILED
```

> Error:(12, 20) Unresolved reference: DaggerKaptamComponent

음, 다시 한번 오류 메시지를 확인해 봅시다.

```
Information:Gradle tasks [:app:assembleDebug]
...
:app:compileDebugKotlin
:app:compileDebugJavaWithJavac
...
```

눈치채셨나요? **Java 파일보다 Kotlin 파일의 컴파일이 우선적으로 적용됩니다.**

반복됩니다만,

> - Java 파일의 Annotation 처리시에 Kotlin 파일의 Annotation 처리를 포함한다.
>   - **일반 javac보다 먼저 kotlinc가 동작한다**
>   - Kotlin 바이너리 파일은 javac 컴파일 대상이 된다
>   - 그러나 javac는 Annotation이 부여된 Kotlin 파일까지 자동으로 포함시키는 기구는 없다
>      - 구현은 가능하고 무엇보다 얻을 수 있는 혜택이 크다
>      - 제약으로는 Kotlin 파일에서는 Annotation 처리에 의해 생성된 소스와 선언을 참조할 수 없다

라는 경험을 여기에서 맛볼수 있습니다.

## kapt.generateStubs

5월의 발표로부터 1개월 후 [Better Annotation Processing:Supporting Stubs in kapt](http://blog.jetbrains.com/kotlin/2015/06/better-annotation-processing-supporting-stubs-in-kapt/)에서 Stub가 제공되도록 되었습니다.

구상에서 논의한 두 번째 이야기입니다.

이것을 사용하는 것이 `kapt.generateStubs`이며, `build.gradle`에 선언함으로써 Stub를 사용할 수 있습니다.

```
kapt {
    generateStubs = true
}
```

먼저 논의한대로, Stub를 위한 컴파일을 포함한 빌드 시간이 길어지기 때문에 일반적으로 `false`로 되어 있습니다.

그러나 kapt가 생성한 Stub는 Java 파일이 아닌 바이너리 파일이며, 메서드 자체의 코드 생성을 생략할 수 있는 것은 javac의 실행 시간을 억제하는 것에 연결된다는 장점이 됩니다.

여하튼, 이로써 컴포넌트 참조를 Kotlin 파일에 기술해도 문제없이 되었습니다.

## 덧붙여서

이 문제, 컴포넌트를 참조하는 클래스를 Java 파일로 대체하면 generateStubs의 설정과 관계없이 빌드 순서의 문제를 해결할 수 있습니다.

```
public class InjectorJava {

    private static KaptamComponent component;

    component = DaggerKaptamComponent.builder()
                    .androidModule(new AndroidModule(application))
                    .build();
}
```

100% Java Interoperability을 주장하는 Kotlin 만이 할 수 있네요.

## 참고 참고

모두 내가 직면한 이야기입니다.

문서는 제대로 읽읍시다.

이번 검증 코드는 여기에 있으니 마음대로 사용하세요.

[laprasdrum/kaptam](https://github.com/laprasdrum/kaptam)

- - -

내일은 AAkira 씨입니다. 지켜봐 주시기 바랍니다.