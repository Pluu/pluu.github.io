---
layout: post
title: "Android Studio for Experts 정리"
date: 2015-11-28 23:50:00
tag: [Android, Android-Studio]
categories:
- blog
- Android
---

<!--more-->

본 포스팅은 [Android Studio for Experts (Android Dev Summit 2015)](https://www.youtube.com/watch?v=Y2GC6P5hPeA) 중  `Tor Norbye`씨의 발표 세션을 정리한 내용입니다.

# Code Completion

### Completion (Ctrl + Space)


```java
public boolean completion(String first, String second) {
  return first.contains(second);
}
```

`contains` 에서 `contentEquals` 로 변경시 뒤의 `contains` 내용을 지웠어야 하지만 Code Completion 에서 해당 함수 위치에서 `TAB` 입력지 자동 변환

### Completion 2 (SmartType, Ctrl + Shift + Space)


```java
public void completion2(Context context) {
  Bitmap bitmap = null;
  Drawable drawable = null;
}
```

- 객체 인스턴스 생성시, 코드를 직접 입력해야했지만 이부분을 지원가능한 기능
- `Ctrl + Shift + Space 을 2번`의 경우, 현재 함수가 위치한 `클래스의 변수` 및 `파라매터` 를 이용하여 인스턴스 생성할지를 지원 (자세한건 아래 그림 참조)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-28-AS-01.PNG" }}" />

### Selection (Extend Selection, Ctrl + W, Ctrl + Shift + W)

현재 커서가 위치한 곳에서 영역 선택을 함수 및 인스턴스 단위로 영역을 선택

### Initiablize Fields (Alt + Enter, Bind constructor parameters to fileds 선택)


```java
public static class InitiablizeFields {
  InitiablizeFields(int first, boolean second, boolean third) {
  }
}
```

파라매터 first, second, third 에 해당하는 내부 변수를 final로 정의


```java
public static class InitiablizeFields {
  private final int first;
  private final boolean second;
  private final boolean third;

  InitiablizeFields(int first, boolean second, boolean third) {
    this.first = first;
    this.second = second;
    this.third = third;
  }
}
```

### Instance Check (Alt + Endter, Insert declaration 선택)


```java
public void instanceCheck(Object parameter) {
  if (parameter instanceof Context) {
  }
}
```

Object형 parameter 가 정상적인 Context 데이터인 경우 캐스팅 코드 작성을 자동 완성


```java
public void instanceCheck(Object parameter) {
  if (parameter instanceof Context) {
    Context context = (Context) parameter;
  }
}
```

### Suppress Statements (Alt + Enter, 관련 Lint 하위 메뉴)


```java
public int suppressStatements() {
  int result = 0;
  return result;
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-28-AS-02.PNG" }}" />

위의 함수는 Lint 경고로 result 의 값을 Inline 처리로 가능하지만 경고 해제 Annotation 자동 완성

### Live Template 1 (For Index)

기존 for 의 index 기반 코드 작업시 `fori` 로 자동 완성 처리 후, List 변수의 size 혹은 관련 처리를 했지만,

List<String> list 의 데이터가 존재시 `list.fori` 관련 로 코드 작성시 동일한 코드 자동 완성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-28-AS-03.PNG" }}" />

### Live Template 2 (Log)

- 기본적인 Android Log 관련 코드 자동 완성 (`logd, loge, logi, logw`)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-11-28-AS-04.PNG" }}" />

- `logt` : Log 의 TAG 관련도 클래스 변수에 자동 완성
- `logm` : 현재 함수의 매개변수의 자동 완성
- `logr` : 리턴 값의 자동 완성

### Structural Replace

프로젝트 내부의 문법에 맞는 데이터의 일부를 변경시 사용 가능


```xml
<string name="name" translation_description="description">value</string>
```


```xml
<string name="name">value</string>
```

적용 문법


```xml
// Search
<string name="$name$" translation_description="$des$">$text$</string>

// Replacement
<string name="$name$">$text$</string>
```

### Structural Search


```java
Thread.sleep(500);
```

위와 같은 코드가 duration 이 다르지만, 해당 기능을 쓰는 곳을 찾을때


```java
Thread.sleep($duration$);
```

### Layout Tools

- `tools:showIn` : 레이아웃을 include 한 곳과 연결하여 Preview를 표시
- `tools:attribute` : attribute에 해당하는 값을 실제로 반영되지않지만, Preview에만 적용해서 볼 경우 사용
 - ex) tools:visibility="visible"
- `tools:listitem` : Adapter 와 연결된 View 의 경우 해당하는 Adapater 의 Layout 을 표시

### Resource Prefix

현재 모듈에 동일한 Prefix 리소스명 설정

설정 : build.gradle


```groovy
android {
  ...
  resourcePrefix 'ccl_'
}
```

### Resource public

현재 모듈 이외에 일부의 Resource 값만 공개할 경우 사용 가능


```xml
<resources>
  <public name="name" type="string" />
</resources>
```

### Resource Shrinking

불필요한 리소스 제거


```groovy
android {
  ...
  buildTypes {
    release {
      minifyEnabled true
      shrinkResources true
      proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
  }
}
```
