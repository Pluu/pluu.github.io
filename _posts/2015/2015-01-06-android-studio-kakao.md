---
layout: post
title: "Android Studio + 카카오 SDK [환경편]"
date: 2015-01-06 16:01:00
categories: [Android Studio]
tag: [Android, Android Studio, Kakao, 카카오, SDK]
---

현재 이 포스트는 기존 네이버 블로그 포스트에 추가적으로 작성한 내용입니다.

Android Studio에 카카오 SDK를 Gradle 방식으로 작업시 간단한(?)처리 방법을 작성했습니다.

세션관리 등의 부분은 작성하지 않고, 기본적인 환경설정만 기술했습니다.

## 1. build.gradle
{% highlight groovy linenos %}
subprojects {
    repositories {
        mavenCentral()
        maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }
    }
}
{% endhighlight %}
카카오 Repogitories 추가

## 2. build.gradle
{% highlight groovy linenos %}
apply plugin: 'com.android.application'

android {
    compileSdkVersion 21
    buildToolsVersion "21.1.2"

    defaultConfig {
        applicationId "com.pluu.kakaosdktest"
        minSdkVersion 14
        targetSdkVersion 21
        versionCode 1
        versionName "1.0.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }

    packagingOptions {
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/NOTICE'
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile 'com.android.support:appcompat-v7:21.0.3'
    provided group: project.KAKAO_SDK_GROUP, name: 'usermgmt', version: project.KAKAO_SDK_VERSION
    provided group: project.KAKAO_SDK_GROUP, name: 'kakaolink', version: project.KAKAO_SDK_VERSION
}
{% endhighlight %}

상단에 예제로 카카오 링크와 로그인관련 의존 처리 Gradle 코드를 추가 했습니다.

{% highlight groovy %}
project.KAKAO_SDK_GROUP : com.kakao.sdk
project.KAKAO_SDK_VERSION  : 1.0.46
{% endhighlight %}

추가적인 의존성 데이터

## 3. Manifest
{% highlight xml %}
<meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
{% endhighlight %}

카카오 Developer에서 발급받은 Key 반영한 부분입니다.

- - -

## P.S
카카오에서 제공하는 Gradle Sample에 템플릿이 있지만

샘플 모듈이 작동하기위해서는 샘플 모듈 + 템플릿 모듈 이렇게 한쌍으로 되어있어 오히려 복잡도만 크게 키운게 아닌가 싶습니다.

```Android Studio, Gradle``` 도입이 시작되었으니, 좀더 나은 작업방법이 생기길 바램입니다.
