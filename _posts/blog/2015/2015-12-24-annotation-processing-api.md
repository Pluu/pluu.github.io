---
layout: post
title: "[번역] Pluggable Annotation Processing API 사용방법 메모"
date: 2015-12-24 13:30:00
tag: [Android, APT]
categories:
- blog
- Android
---

본 포스팅은 [Pluggable Annotation Processing API 使い方メモ](http://qiita.com/opengl-8080/items/beda51fe4f23750c33e9) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

## Pluggable Annotation Processing API 란?

Java 1.6에서 추가된, 컴파일 시 Annotation을 처리하기 위한 구조.

Lombok이나 JPA의 Metamodel 에서 이용되고 있다.

즉, 컴파일 시에 Annotation을 읽어 소스 코드를 자동생성할 수 있다.

Java 1.5에서 Annotation이 추가될 때에, Annotation을 컴파일시에 처리하는 방법으로 Annotation Processing Tool (apt)가 추가되었지만, 그것과는 별개인 것 같다.

## Hello World

### 프로세서를 구현

MyAnnotationProcessor.java

```java
import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;

import javax.lang.model.element.TypeElement;
import javax.lang.model.SourceVersion;

import java.util.Set;
import java.util.HashSet;

public class MyAnnotationProcessor extends AbstractProcessor {

    private int round = 1;

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment env) {
        System.out.println("Round : " + (this.round++));
        annotations.forEach(System.out::println);
        return true;
    }

    @Override
    public Set<String> getSupportedAnnotationTypes() {
        Set<String> supportedAnnotationTypes = new HashSet<>();
        supportedAnnotationTypes.add("*");

        return supportedAnnotationTypes;
    }

    @Override
    public SourceVersion getSupportedSourceVersion() {
        return SourceVersion.RELEASE_8;
    }
}
```

### 처리대상 소스를 만들기

Hoge.java

```java
public class Hoge {
    @Deprecated
    public void deprecatedMethod() {}

    @Override
    public String toString() {
        return "hoge";
    }
}
```

### 프로세서를 컴파일


```bash
> javac MyAnnotationProcessor.java

> dir /b
MyAnnotationProcessor.class
MyAnnotationProcessor.java
Hoge.java
```

### 프로세서를 지정해서 코드를 컴파일


```bash
> javac -processor MyAnnotationProcessor Hoge.java
Round : 1
java.lang.Deprecated
java.lang.Override
Round : 2

> dir /b
Hoge.class
Hoge.java
MyAnnotationProcessor.class
MyAnnotationProcessor.java
```

### 설명

#### 프로세서 작성

MyAnnotationProcessor.java

```java
import javax.annotation.processing.AbstractProcessor;

public class MyAnnotationProcessor extends AbstractProcessor {
```

- Annotation Processor를 만들기 위해서는, [Processor](http://docs.oracle.com/javase/jp/8/docs/api/javax/annotation/processing/Processor.html)를 구현한 Class를 준비한다.
- 표준 `Processor`를 구현한 추상 클래스 [AbstractProcessor](http://docs.oracle.com/javase/jp/8/docs/api/javax/annotation/processing/AbstractProcessor.html) 가 준비되어 있기 때문에, 보통은 그것을 상속해서 만든다.

#### 처리대상을 정의한다

MyAnnotationProcessor.java

```java
@Override
public Set<String> getSupportedAnnotationTypes() {
    Set<String> supportedAnnotationTypes = new HashSet<>();
    supportedAnnotationTypes.add("*");

    return supportedAnnotationTypes;
}

@Override
public SourceVersion getSupportedSourceVersion() {
    return SourceVersion.RELEASE_8;
}
```

- `getSupportedAnnotationTypes()`로 처리하는 Annotation을 정의한다.
 - 반환 값 `Set<String>`은, 처리 대상이 되는 Annotation 패턴을 반환하도록 한다.
 - 보통은 FQCN을 지정한다.
 - `*`을 사용한 와일드카드 표현도 가능
 - `*`만 사용한 경우는, 전체 Annotation이 처리 대상이 된다.
- `getSupportedSourceVersion()`는 지원 범위가 되는 버전을 정의
 - [SourceVersion](http://docs.oracle.com/javase/jp/8/docs/api/javax/lang/model/SourceVersion.html) 열거형으로 지정한다.
 - 지원 버전보다 새로운 JDK 를 사용하면, 경고 메시지가 표시된다.

SourceVersion.RELEASE_7를 반환하도록 한 경우의 경고 메시지

```bash
경고: Annotation Processor 'MyAnnotationProcessor'에서 -source '1.8'보다 낮은 소스 버전 'RELEASE_7'가 지원되고 있다.
```

#### 컴파일 시에 프로세서를 지정


```bash
> javac -processor MyAnnotationProcessor Hoge.java
```

- `-processor` 옵션으로 사용하는 프로세서를 지정한다.

#### Around

실행경과

```bash
Round : 1
java.lang.Deprecated
java.lang.Override
Round : 2
```

- 프로세서에 의한 처리 (process) 의 호출은 여러 번 진행된다.
- 각각의 처리를 **Around** 라고 부른다
- 첫 번째의 Around 처리로 소스 코드를 새로 생성할 때, 생성된 소스에 사용되는 Annotation을 처리하기 위해, 또 한 번 Around을 실행한다.
- 소스 생성 등을 하지 않아도 최저 2회는 Around가 실행된다.

## 지원 버전과 처리 대상 제한을 Annotation으로 지정

MyAnnotationProcessor.java

```java
import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;

import javax.lang.model.element.TypeElement;
import javax.lang.model.SourceVersion;

import java.util.Set;

@SupportedSourceVersion(SourceVersion.RELEASE_8)
@SupportedAnnotationTypes("*")
public class MyAnnotationProcessor extends AbstractProcessor {

    private int round = 1;

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment env) {
        System.out.println("Round : " + (this.round++));
        annotations.forEach(System.out::println);
        return true;
    }
}
```

- 함수 대신에, `@SupportedSourceVersion`과 `@SupportedAnnotationTypes` Annotation으로 정의할 수 있다.

## Annotation 정보 취득

MyAnnotationProcessor.java

```java
import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;

import javax.lang.model.element.TypeElement;
import javax.lang.model.element.Element;
import javax.lang.model.SourceVersion;

import java.util.Set;

@SupportedSourceVersion(SourceVersion.RELEASE_8)
@SupportedAnnotationTypes("*")
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> typeElements, RoundEnvironment env) {

        for (TypeElement typeElement : typeElements) {

            for (Element element : env.getElementsAnnotatedWith(typeElement)) {

                Override override = element.getAnnotation(Override.class);

                if (override != null) {
                    System.out.println("@Override at " + element);
                }
            }
        }

        return true;
    }
}
```

동작 확인

```bash
> javac -processor MyAnnotationProcessor Hoge.java
@Override at toString()
```

- `RoundEnvironment#getElementsAnnotatedWith(TypeElement)` 함수에서, 실제로 Annotate 되는 장소를 나타내는 Element 의 Set 을 얻을 수 있다.
- `Element#getAnnotation(Class)` 함수에서, 실제 Annotation을 얻을 수 있다.

## 메시지 출력

### 기본

MyAnnotationProcessor.java

```java
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;

@SupportedAnnotationTypes("*")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        Messager messager = super.processingEnv.getMessager();

        messager.printMessage(Kind.OTHER, "Other");
        messager.printMessage(Kind.NOTE, "Note");
        messager.printMessage(Kind.WARNING, "Warning");
        messager.printMessage(Kind.MANDATORY_WARNING, "Mandatory Warning");
        messager.printMessage(Kind.ERROR, "Error");

        return true;
    }
}
```

컴파일 실행 결과

```bash
Note:Other
Note:Note
Warning: Warning
Warning: Mandatory Warning
Error: Error
Note:Other
Note:Note
Warning: Warning
Warning: Mandatory Warning
Error: Error
Error 2개
Warning 4개
```

- ※ 2개씩 출력되는 것은, Around가 2회 실행되어 있기 때문에
- `AbstractProcessor` 클래스가 가지는 `processingEnv` 라는 필드로부터, `getMessager()` 함수를 사용해서 [Messager](http://docs.oracle.com/javase/jp/8/docs/api/javax/annotation/processing/Messager.html) 의 인스턴스를 취득한다.
- `Messager#printMessage()` 함수를 사용해서, 컴파일 시의 메시지 출력을 할 수 있다.
- 첫 번째 인수에 메시지 종류를 지정한다 ([Diagnostic.Kind](http://docs.oracle.com/javase/jp/8/docs/api/javax/tools/Diagnostic.Kind.html)).
- 두 번째 인수에 출력할 메시지를 전달한다.
- 종류를 `Kind.ERROR`로 해서 메시지 출력하면 컴파일 결과로 에러가 된다.

### Annotate 된 코드상의 위치정보를 출력

MyAnnotationProcessor.java

```java
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;

@SupportedAnnotationTypes("*")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        Messager messager = super.processingEnv.getMessager();

        for (TypeElement typeElement : annotations) {
            for (Element element : roundEnv.getElementsAnnotatedWith(typeElement)) {
                messager.printMessage(Kind.NOTE, "hogehoge", element);
            }
        }

        return true;
    }
}
```

컴파일 실행 결과

```bash
Hoge.java:5: 注意:hogehoge
    public String toString() {
                  ^
```

- `Messager#printMessage()` 함수의 세 번째 인수로 `Element`를 전달하면, 그 요소의 코드상 위치 정보가 같이 출력된다.

### Annotation 위치 정보를 출력

MyAnnotationProcessor.java

```java
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.AnnotationMirror;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;

@SupportedAnnotationTypes("java.lang.Override")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        Messager messager = super.processingEnv.getMessager();

        for (TypeElement typeElement : annotations) {
            for (Element element : roundEnv.getElementsAnnotatedWith(typeElement)) {
                AnnotationMirror override = element.getAnnotationMirrors().get(0);
                messager.printMessage(Kind.NOTE, "hogehoge", element, override);
            }
        }

        return true;
    }
}
```

컴파일 실행 결과

```bash
Hoge.java:4: 注意:hogehoge
    @Override
    ^
```

- `Messager#printMessage()` 함수의 네 번째 인수로 AnnotationMirror를 전달하면, 그 Annotation의 코드상 위치정보가 같이 출력된다.
- 다섯 번째 인수로 `AnnotationValue`를 전달하면, Annotation 인수의 위치 정보도 출력 가능할 듯하다 (테스트해보지 않음).

## Annotate 된 요소 정보 취득

MyAnnotation.java

```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

@Target({
    ElementType.TYPE, ElementType.METHOD, ElementType.LOCAL_VARIABLE,
    ElementType.FIELD, ElementType.PARAMETER, ElementType.TYPE_PARAMETER
})
public @interface MyAnnotation {

    String value();
}
```

MyAnnotationProcessor.java

```java
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;

@SupportedAnnotationTypes("MyAnnotation")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        for (TypeElement typeElement : annotations) {
            for (Element element : roundEnv.getElementsAnnotatedWith(typeElement)) {
                MyAnnotation anno = element.getAnnotation(MyAnnotation.class);

                String msg =
                    "<<@MyAnnotation(\"" + anno.value() + "\")>>\n"
                  + "  Kind : " + element.getKind() + "\n"
                  + "  SimpleName : " + element.getSimpleName() + "\n"
                  + "  Modifiers : " + element.getModifiers() + "\n"
                  + "  asType : " + element.asType() + "\n"
                  + "  EnclosedElements : " + element.getEnclosedElements() + "\n"
                  + "  EnclosingElement : " + element.getEnclosingElement() + "\n"
                  + "  AnnotationMirrors : " + element.getAnnotationMirrors() + "\n"
                  ;

                System.out.println(msg);
            }
        }

        return true;
    }
}
```

Hoge.java

```java
@MyAnnotation("클래스")
public class Hoge<@MyAnnotation("Generic 인수") T> {

    @MyAnnotation("필드")
    private double d;

    @MyAnnotation("함수")
    public void method(@MyAnnotation("인수") int i) {
        @MyAnnotation("로컬 변수")
        String str;
    }
}
```

컴파일 실행 결과

```bash
<<@MyAnnotation("클래스")>>
  Kind : CLASS
  SimpleName : Hoge
  Modifiers : [public]
  asType : Hoge<T>
  EnclosedElements : Hoge(),d,method(int)
  EnclosingElement : 이름이 없는 Package
  AnnotationMirrors : @MyAnnotation("\u30af\u30e9\u30b9")

<<@MyAnnotation("Generic 인수")>>
  Kind : TYPE_PARAMETER
  SimpleName : T
  Modifiers : []
  asType : T
  EnclosedElements :
  EnclosingElement : Hoge
  AnnotationMirrors : @MyAnnotation("\u578b\u5f15\u6570")

<<@MyAnnotation("필드")>>
  Kind : FIELD
  SimpleName : d
  Modifiers : [private]
  asType : double
  EnclosedElements :
  EnclosingElement : Hoge
  AnnotationMirrors : @MyAnnotation("\u30d5\u30a3\u30fc\u30eb\u30c9")

<<@MyAnnotation("함수")>>
  Kind : METHOD
  SimpleName : method
  Modifiers : [public]
  asType : (int)void
  EnclosedElements :
  EnclosingElement : Hoge
  AnnotationMirrors : @MyAnnotation("\u30e1\u30bd\u30c3\u30c9")

<<@MyAnnotation("인수")>>
  Kind : PARAMETER
  SimpleName : i
  Modifiers : []
  asType : int
  EnclosedElements :
  EnclosingElement : method(int)
  AnnotationMirrors : @MyAnnotation("\u5f15\u6570")
```

- [Element](http://docs.oracle.com/javase/jp/8/docs/api/javax/lang/model/element/Element.html)  인스턴스로부터, Annotate된 여러 가지 요소 정보를 취득할 수 있다.

## jar 에 패키징해서 -processor 옵션 없이도 사용하도록

매번 javac 옵션으로 -processor를 지정하는게 피곤합니다.

Annotation Processor를 소정의 방법으로 jar에 패키징하면, 컴파일 시에 jar을 class path에 지정하는 것으로 프로세서 처리를 할 수 있습니다.

### 프로세서를 포함한 jar을 작성

MyOverrideProcessor.java

```java
package sample.processor;

import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.TypeElement;

@SupportedAnnotationTypes("java.lang.Override")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyOverrideProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        System.out.println("Override!!");
        return true;
    }
}
```

`@Override` Annotation 을 처리하는 프로세서.

이것을 아래의 구성과 같이 jar에 패키징한다.


```bash
|-sample/processor/
|  `-MyOverrideProcessor.class
`-META-INF/services/
   `-javax.annotation.processing.Processor
```

`META-INF/services/javax.annotation.processing.Processor`는 단순한 테스트 파일로, 내용은 아래와 같이 사용하는 프로세서의 FQCN을 기술합니다.

javax.annotation.processing.Processor

```bash
sample.processor.MyOverrideProcessor
```

이 jar 을 `processor.jar` 로 합니다.

### 실행

Hoge.java

```java
public class Hoge {
    @Override
    public String toString() {
        return super.toString();
    }
}
```


```bash
> javac -cp processor.jar Hoge.java
Override!!
Override!!
```

### 설명

- Annotation Processor를 포함하는 jar 파일 안에 `META-INF/services/javax.annotation.processing.Processor`라는 형식으로 텍스트 파일을 배치한다.
- `javax.annotation.processing.Processor`안에는, 사용하는 프로세서의 FQCN을 기술한다.
- 이 jar 을 class path에 포함한 상태에서 컴파일을 실행하면, `javax.annotation.processing.Processor` 로 지정한 프로세서가 컴파일 시에 사용된다.
- `javax.annotation.processing.Processor`에는, 실행구역에 복수 프로세서를 기술할 수가 있다.
- `META-INF/services` 의 아래에 사용하는 Class 정보를 배치하는 방법은 Java의 [ServiceLoader](http://itpro.nikkeibp.co.jp/article/COLUMN/20061215/257003/)라는 구조를 이용한 것으로 보인다.

## Eclipse에서 이용

### 기본

#### 프로세서쪽의 프로젝트를 작성

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/81c13173-2a46-ae32-2555-dffbaa3ffc9c.jpeg" />

MyAnnotationProcessor.java

```java
package sample.processor;

import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;

@SupportedAnnotationTypes("*")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        Messager messager = super.processingEnv.getMessager();
        messager.printMessage(Kind.NOTE, "Hello Annotation Processor!!");

        return true;
    }
}
```

javax.annotation.processing.Processor

```bash
sample.processor.MyAnnotationProcessor
```

- 일반적인 java 프로젝트를 만든다.
- ServiceLoader를 이용하는 형식으로 한다(`javax.annotation.processing.Processor`).

**jar 파일을 출력**

- 프로젝트를 등록정보에서 [Export]를 선택한다
- [Java] > [JAR File]을 선택하고, [다음]을 선택
- 임의의 장소에 jar 파일을 출력한다

#### 프로세서를 이용하는 쪽의 프로젝트를 작성

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/fa4fe36a-3112-06d4-3d7b-ef76184dd9ce.jpeg" />

Hoge.java

```java
public class Hoge {

    @Override
    public String toString() {
        return super.toString();
    }
}
```

평소같이 java 프로젝트를 만든다.

**Annotation Processing를 유효하게 한다**

- 프로젝트 [Properties]를 선택
- [Java Compiler] > [Annotation Processing]을 선택
- [Enable project specific settings]를 체크한다.
- 이어서, [Enable annotation processing]과 [Enable processing in editor]를 체크한다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/7014de5f-4fc5-2ea7-c6c6-bbe309337d59.jpeg" />

- 이어서, [Annotation Processing] > [Factory Path]를 선택한다
- [Enable project specific settings]를 체크한다.
- [Add External Jars]를 클릭해서, 이전에 작성한 `MyAnnotationProcessor` 프로젝트의 jar 파일을 선택한다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/a4a9d50e-0f53-deca-77be-76924c18bef7.jpeg" />

이걸로 Annotation Processing이 유효하게 되었다.

**출력 결과를 확인한다**

- [Window] > [Show View] > [Error Log]를 선택하고「Error Log」창을 표시시킨다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/acc6698d-66f6-895b-4dc8-cadfb8d6dfe7.jpeg" />

- 올바르게 처리되면, Messager에서 출력한 내용이 표시됩니다.
- Eclipse에서 구동시킬 경우, 표준 출력(System.out)에 출력한 내용은 확인할 수 없으므로, Messager에서 출력하여 「Error Log」창에서 확인한다.
- 프로세서 측의 구현을 수정한 경우는, jar를 다시 출력한 후 사용하는 측의 「Factory Path」의 설정을 수정할(한번 제외하고, 다시 설정한다) 필요가 있다.

### 경고나 에러 메시지는 Editor 상에 표시

MyAnnotationProcessor.java

```java
package sample.processor;

import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;

@SupportedAnnotationTypes("java.lang.Override")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        Messager messager = super.processingEnv.getMessager();

        for (TypeElement typeElement : annotations) {
            for (Element element : roundEnv.getElementsAnnotatedWith(typeElement)) {
                messager.printMessage(Kind.ERROR, "オーバーライドさせぬ！", element);
            }
        }

        return true;
    }
}
```

**이용 측의 모습**

<img src="https://qiita-image-store.s3.amazonaws.com/0/28302/e8fa90ff-e2ee-5908-a32f-82823f705acf.jpeg" />

Editor 상에 에러가 표시된다

## Gradle에서 이용

### 기본

#### 폴더 구성

폴더 구성

```bash
|-settings.gradle
|-build.gradle
|-processor/
|  `-src/main/
|     |-java/sample/processor/
|     |  `-MyAnnotationProcessor.java
|     `-resources/META-INF/services/
|        `-javax.annotation.processing.Processor
|
`-client/
   |-build.gradle
   `-src/main/java/sample/processor/
      `-Hoge.java
```


- 멀티 프로젝트 구성.
- `processor` 와 `client` 라는 프로젝트가 있다.
 - `processor` 프로젝트에서는, Annotation Processor를 구현한다.
 - `client` 프로젝트에서는, `processor` 프로젝트에서 작성한 Annotation Processor를 이용한다.

#### 구현 이외

settings.gradle

```groovy
include 'processor', 'client'
```

build.gradle

```groovy
subprojects {
    apply plugin: 'java'
}
```

client/build.gradle

```groovy
dependencies {
    compile project(':processor')
}
```

MyAnnotationProcessor.java

```java
package sample.processor;

import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.TypeElement;

@SupportedAnnotationTypes("*")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        System.out.println("Hello!!");
        return true;
    }
}
```

Hoge.java

```java
package sample.processor;

public class Hoge {
    @Override
    public String toString() {
        return "hoge";
    }
}
```

#### 동작 확인


```bash
> gradle compileJava
:processor:compileJava
:processor:processResources
:processor:classes
:processor:jar
:client:compileJava
Hello!!
Hello!!

BUILD SUCCESSFUL

Total time: 3.423 secs
```

- ServiceLoader를 사용하는 형식으로 하면, 이용할 수 있습니다.

### Eclipse 프로젝트

`gradle eclipse`로 했다면, 자동으로 Annotation Processing 설정이 활성화되도록 한다

#### 폴더 구성

폴더 구성

```bash
|-build.gradle
|-lib/
|  `-processor.jar
`-src/main/java/sample/processor/
   `-Hoge.java
```

프로세서를 패키징한 jar 파일은, `lib` 폴더의 아래에 배치해둡니다

#### build.gradle

client/build.gradle

```groovy
apply plugin: 'java'
apply plugin: 'eclipse'

ext {
    eclipseAptPrefsFile = '.settings/org.eclipse.jdt.apt.core.prefs'
    eclipseFactoryPathFile = '.factorypath'
    processorJarPath = 'lib/processor.jar'
}

dependencies {
    compile files(processorJarPath)
}

eclipse {
    project.name = 'MyAnnotationProcessorClient'

    classpath.file.withXml {
        it.asNode().appendNode('classpathentry', [kind: 'src', path: '.apt_generated'])
    }

    jdt.file.withProperties { properties ->
        properties.put 'org.eclipse.jdt.core.compiler.processAnnotations', 'enabled'
    }
}

eclipseJdt << {
    file(eclipseAptPrefsFile).write """\
        |eclipse.preferences.version=1
        |org.eclipse.jdt.apt.aptEnabled=true
        |org.eclipse.jdt.apt.genSrcDir=.apt_generated
        |org.eclipse.jdt.apt.reconcileEnabled=true
        |""".stripMargin()

    file(eclipseFactoryPathFile).write """\
        |<factorypath>
        |    <factorypathentry kind="PLUGIN" id="org.eclipse.jst.ws.annotations.core" enabled="true" runInBatchMode="false"/>
        |    <factorypathentry kind="EXTJAR" id="${file(processorJarPath).absolutePath}" enabled="true" runInBatchMode="false"/>
        |</factorypath>
        |""".stripMargin()
}

cleanEclipse << {
    file(eclipseAptPrefsFile).delete()
    file(eclipseFactoryPathFile).delete()
}
```

#### 설명

하고 있는것은 단순해서 `eclipse` Task를 실행하면 Annotation Processing을 활성화하기위해 필요한 설정 파일을 추가하고 있습니다.

**org.eclipse.jdt.apt.core.prefs 작성**


```groovy
ext {
    eclipseAptPrefsFile = '.settings/org.eclipse.jdt.apt.core.prefs'
    ...
}

...

eclipseJdt << {
    file(eclipseAptPrefsFile).write """\
        |eclipse.preferences.version=1
        |org.eclipse.jdt.apt.aptEnabled=true
        |org.eclipse.jdt.apt.genSrcDir=.apt_generated
        |org.eclipse.jdt.apt.reconcileEnabled=true
        |""".stripMargin()

...
```

**.factorypath 작성**


```groovy
ext {
    eclipseFactoryPathFile = '.factorypath'
    ...
}

...

eclipseJdt << {
    ...

    file(eclipseFactoryPathFile).write """\
        |<factorypath>
        |    <factorypathentry kind="PLUGIN" id="org.eclipse.jst.ws.annotations.core" enabled="true" runInBatchMode="false"/>
        |    <factorypathentry kind="EXTJAR" id="${file(processorJarPath).absolutePath}" enabled="true" runInBatchMode="false"/>
        |</factorypath>
        |""".stripMargin()
}
```

**.classpath vuswlwq **


```groovy
eclipse {
    ...

    classpath.file.withXml {
        it.asNode().appendNode('classpathentry', [kind: 'src', path: '.apt_generated'])
    }

    ...
}
```

**org.eclipse.jdt.core.prefs 편집**


```groovy
eclipse {
    ...

    jdt.file.withProperties { properties ->
        properties.put 'org.eclipse.jdt.core.compiler.processAnnotations', 'enabled'
    }
}
```

**cleanEclipse 에 삭제 대상을 추가**


```groovy
ext {
    eclipseAptPrefsFile = '.settings/org.eclipse.jdt.apt.core.prefs'
    eclipseFactoryPathFile = '.factorypath'
    ...
}

...

cleanEclipse << {
    file(eclipseAptPrefsFile).delete()
    file(eclipseFactoryPathFile).delete()
}
```

## Java 소스 코드를 만들기

Annotation Processor 처리 중, 소스 코드를 동적으로 만들어 보자.

### 구현

MyAnnotation.java

```java
package sample.processor;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

@Target(ElementType.TYPE)
public @interface MyAnnotation {
    boolean value() default false;
}
```

Hoge.java

```java
package sample.processor;

@MyAnnotation(true)
public class Hoge {
}
```

MyAnnotationProcessor.java

```java
package sample.processor;

import java.io.IOException;
import java.io.Writer;
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Filer;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;
import javax.tools.JavaFileObject;

@SupportedAnnotationTypes("sample.processor.MyAnnotation")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class MyAnnotationProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        if (annotations.size() == 0) {
            return true;
        }

        Messager messager = super.processingEnv.getMessager();

        for (TypeElement typeElement : annotations) {
            for (Element element : roundEnv.getElementsAnnotatedWith(typeElement)) {
                MyAnnotation anno = element.getAnnotation(MyAnnotation.class);

                messager.printMessage(Kind.NOTE, element.getSimpleName() + " class is annotated by @MyAnnotation.");

                if (!anno.value()) {
                    messager.printMessage(Kind.NOTE, "@MyAnnotation value is false. no generate.");
                    break;
                }

                String src =
                    "package sample.processor.generated;\r\n"
                  + "import sample.processor.MyAnnotation;\r\n"
                  + "@MyAnnotation\r\n"
                  + "public class Fuga {\r\n"
                  + "    public void hello() {\r\n"
                  + "        System.out.println(\"Hello World!!\");\r\n"
                  + "    }\r\n"
                  + "}\r\n"
                  ;

                try {
                    Filer filer = super.processingEnv.getFiler();
                    JavaFileObject javaFile = filer.createSourceFile("Fuga");

                    try (Writer writer = javaFile.openWriter()) {
                        writer.write(src);
                    }

                    messager.printMessage(Kind.NOTE, "generate source code!!");
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return true;
    }
}
```

### 동작 확인

컴파일 실행 결과

```bash
Warring:Hoge class is annotated by @MyAnnotation.
Warring:generate source code!!
Warring:Fuga class is annotated by @MyAnnotation.
Warring:@MyAnnotation value is false. no generate.
```

자동 생성된 Fuga Class

```java
package sample.processor.generated;
import sample.processor.MyAnnotation;
@MyAnnotation
public class Fuga {
    public void hello() {
        System.out.println("Hello World!!");
    }
}
```

- `Fuga.java`는 `.class` 파일이 출력된 폴더의 Root에 출력됩니다.
-` Fuga.class`는 동일하게 `.class` 파일의 출력 저장소에 `package` 선언에서 정의한 위치에 출력된다.

출력된 파일 상태

```bash
|-Fuga.java
`-sample/processor/
   |-Hoge.class
   `-generated/
      `-Fuga.class
```

#### 설명

MyAnnotationProcessor.java(일부)

```java
try {
    Filer filer = super.processingEnv.getFiler();
    JavaFileObject javaFile = filer.createSourceFile("Fuga");

    try (Writer writer = javaFile.openWriter()) {
        writer.write(src);
    }

    messager.printMessage(Kind.NOTE, "generate source code!!");
} catch (IOException e) {
    e.printStackTrace();
}
```

- Java 소스 코드를 생성하기 위해서는 먼저 다음 방법으로  [JavaFileObject](http://docs.oracle.com/javase/jp/8/docs/api/javax/tools/JavaFileObject.html) 를 취득한다.
 - `AbstractProcessor#processingEnv`의 `getFiler()` 함수에서 [Filer](http://docs.oracle.com/javase/jp/8/docs/api/javax/annotation/processing/Filer.html) 의 인스턴스를 취득한다
 - `Filer#createSourceFile(String)`함수에서 `JavaFileObject` 의 인스턴스를 취득한다(인수는 생성된 Class 명).
- `JavaFileObject`를 취득하면 `openWriter()`이나 `openOutputStream()`를 사용해서 Writer이나 Stream을 취득해서 소스 코드를 작성한다.
- 생성된 파일은 자동으로 컴파일된다.
- 생성한 소스 코드에 Annotation이 포함된 경우는 다음의 Around가 실행되고 다시 Processor의 `process()` 함수가 실행된다.
- 같은 Class의 소스 코드를 여러 번 출력하면 Error가 된다.
 - 따라서, 처리해야하는 Annotation이 남아있지 않은가를 확인하고, 없다면 바로 처리를 종료시킨다. (판정에는, `process()` 함수의 첫 번째 인수의 Size를 이용한다).

처리해야 하는 Annotation이 남아 있지 않다면, 바로 처리를 종료시키는 부분

```java
@Override
public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
    if (annotations.size() == 0) {
        return true;
    }
```

## 참고

- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 1：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20081219/321816/)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 2：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090115/322957/?ST=develop)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 3：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090122/323258/)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 4：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090129/323775/)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 5：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090204/324186/)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 6：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090212/324605/)
- [Java기술최전선 - 「Java SE 6완전공략」第94回 Annotation을 처리 7：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20090218/324994/)
- [Annotation  Processor를 Eclipse로 동작시키기까지의 유명한 멤버로부터 서포트를 받음 - Togetter 정리](http://togetter.com/li/517171)
- [eclipse에서 Custom Annotation을 만들기위한 메모: mitsuruog 일기](http://se35over.seesaa.net/article/283647859.html)
- [javax.annotation.processing (Java Platform SE 8 )](http://docs.oracle.com/javase/jp/8/docs/api/javax/annotation/processing/package-summary.html)
- [Java기술최전선 - 「Java SE 6완전공략」第11回　Component Load를 하는 ServiceLoader：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20061215/257003/)
- [vvakame / build.gradle | GitHub Gist](https://gist.github.com/vvakame/5176993#file-build-gradle-L196)
- [第38章 Eclipse Plugin](http://gradle.monochromeroad.com/docs/userguide/eclipse_plugin.html)
- [Node (Groovy 2.4.3)](http://docs.groovy-lang.org/latest/html/api/groovy/util/Node.html)
- [Gradle로 Eclipse 설정을 Customize- @ikikko 의 はてな블로그](http://ikikko.hatenablog.com/entry/20120214/1329239103)
