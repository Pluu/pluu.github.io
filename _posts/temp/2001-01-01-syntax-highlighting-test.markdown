---
layout: post
title: "Pygments highlighter Test"
date: 2001-01-01 01:01:00
categories:
tag:
---

## Ruby
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}

{% highlight ruby linenos %}
def show
  puts "Outputting a very lo-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-ong lo-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-ong line"
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}

## C++

{% highlight cpp linenos %}
#include <stdio.h>
int main(int argc, char* argv[]) {
    printf("Hello, world);
    return 0;
}
{% endhighlight %}

## Groovy

{% highlight groovy linenos %}
subprojects {
    repositories {
        mavenCentral()
        maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }
    }
}
{% endhighlight %}

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

## XML

{% highlight xml %}
<meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
{% endhighlight %}