---
layout: post
title: "POST TEST"
date: 2001-01-01 01:01:00
categories:
tag:
---

## Ruby

```cpp
#include <stdio.h>
int main(int argc, char* argv[]) {
    printf("Hello, world);
    return 0;
}
```

## Groovy

```Groovy
subprojects {
    repositories {
        mavenCentral()
        maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }
    }
}
```

## Groovy2

```Groovy
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
```

## XML

```xml
<meta-data android:name="com.kakao.sdk.AppKey" android:value="@string/kakao_app_key"/>
```