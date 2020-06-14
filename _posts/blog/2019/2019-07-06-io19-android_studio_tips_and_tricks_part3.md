---
layout: post
title: "[요약] Android Studio/ Tips and Tricks Part 3 ~ Build&Deploy (Google I/O '19)"
date: 2019-07-08 00:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io19
---

Android Studio/ Tips and Tricks 세션의 내용이 많아서 3개의 파트로 나누어서 공개합니다.

본 글에서는 Build&Deploy를 소개합니다.

<!--more-->

- - - 

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/ihF-PwDfRZ4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Android Studio/ Tips and Tricks

- [Part 1 ~ Profiler, 기본 IDE]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2 ~ Navigation Editor, Resource Manager]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)
- [Part 3 ~ Build&Deploy]({{ site.baseurl }}/blog/android/io19/2019/07/07/io19-android_studio_tips_and_tricks_part3/)

- - -

## Build & Deploy

특정 모듈을 디렉토리 하단으로 넣고 싶을 때, `setting.gradle` 을 수정해서 개선할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/048.png" }}" /> 

실제 디렉토리는 libraries 하단의 core로 되어있지만, `core-utils`로 맵핑되었다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/049.png" }}" /> 

Build Directory를 다른 위치로 지정할 수 도 있다.

#### Managing Dependencies

하드코딩으로 정의된 Dependenceis의 경우 새로운 버전으로 갱신시 모든 모듈에 갱신 작업을 하는 것은 번거로운 작업이다. 그리고, 버전이 다를 경우 디버깅시 정확한 문제 파악에도 어려움이 발생한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/050.png" }}" /> 

Dependencies Library들을 정의한 별도 gradle 파일을 생성한 후 위와 같이 `ext`의 하위에 추가할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/051.png" }}" /> 

그리고, Root Project의 build.gradle에 정의한 gradle을 적용 및 동기화한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/052.png" }}" /> 

그리고, 모듈마다 정의되었던 Dependenceis Library들 정보를 위에서 정의한 ext의 하위의 libs의 값들로 교체한다. 이 변경으로 새로운 버전이 있더라도 프로젝트 전체를 다니면서 수정하지 않고 Library를 정의한 파일만 수정하면 된다.

기본 Gradle은 Library가 의존하는 모든 Library를 다운한다. 그래서 AppCompat 뿐만 아니라, AppCompat의 모든 런타임 의존성을 가지게 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/053.png" }}" /> 

Project Structure의 `Dependencies` > Modules > Declared Dependencies의 항목을 선택한 후 우측의 `Resolved Dependencies` 를 통해 특정 실제 Library가 의존하는 모든 Library를 자세히 볼 수 있다. 

#### Build Speed

빌드 속도를 체크하는 방법 중 빌드 설정이 올바르게 되어있는지 확인하는 방법이 있다.

프로젝트 빌드를 한 번 실행한 다음, 변경없이 다시 빌드했을 때 변경된 것은 없으니 최종 결과물은 같아야하며 어떤 Gradle Task도 실행되서는 안된다.

| 1회                                                          | 2회                                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/054.png" }}" />  | <img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/055.png" }}" />  |

첫 빌드는 21개의 작업중 19개가 실행되었고, 2개가 최신 상태였다. 두 번째는 5개가 실행되었고, 16개가 최신 상태였다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/056.png" }}" /> 

`generateDebugBuildConfig` 는 DebugBuild 구성을 생성하는 Task이다. 이 작업이 변경되어서 Task 가 실행되었다. 이것은 build.gradle 파일 혹은 Project에서 적용된 일부 플러그인 때문일 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/057.png" }}" /> 

20번 줄의 `buildConfigField`는 빌드될 때 정보를 추가적으로 의도로 작성되어있다. 그래서, 해당 부분의 값을 고정으로 변경하면 두 번째 빌드는 모든 Task가 최신이라는 것을 얻을 수 있다.

### Apply Change

이전의 Instant Run과는 달리 APK에 대한 점진적 업데이트를 위해 Device의 Platform 레벨의 지원에 의존한다. Android Studio에서는 Apply Change를 적용하기 위한 기능을 제공한다

- Run : 전체 APK를 빌드하고 실행
- Apply Changes and Restart Activity : Resource를 적용하고 변경 사항을 읽으며 Activity를 다시 시작
- Apply Code Changes : 코드 변경 사항을 적용

예를 들어, XML의 String을 변경한 후 `Apply Changes and Restart Activity` 를 선택하면 이전 APK와의 차이점만 실제 Device에 배포된다.

그리고,  `Apply Code Changes` 는 메소드 본문을 변경한 후 적용할 때에 사용할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io19/android_studio_tips_and_tricks/058.png" }}" /> 

아래쪽에 느낌표는 실제로 현재 코드가 쓸모 없다는 표시이다. 이것은 현재 실행중인 버전의 메소드가 새로운 정의로 무효화되었다는 의미이다. 계속 진행하면 새롭게 정의한 Method가 사용된다.

- - - 

Android Studio/ Tips and Tricks

- [Part 1 ~ Profiler, 기본 IDE]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part1/)
- [Part 2 ~ Navigation Editor, Resource Manager]({{ site.baseurl }}/blog/android/io19/2019/07/06/io19-android_studio_tips_and_tricks_part2/)
- [Part 3 ~ Build&Deploy]({{ site.baseurl }}/blog/android/io19/2019/07/07/io19-android_studio_tips_and_tricks_part3/)
