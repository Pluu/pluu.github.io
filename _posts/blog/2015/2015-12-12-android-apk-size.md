---
layout: post
title: "[번역] 연말 대청소, 어플리케이션 용량을 줄이기 위한 체크 리스트"
date: 2015-12-12 23:30:00
tag: [Android, APK]
categories:
- blog
- Android
---

<!--more-->

본 포스팅은 [年末の大掃除、アプリの容量を削減するためのチェックリスト](http://qiita.com/cookych/items/8399c58297c9860e54ad) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

## APK 최대 파일 사이즈가 50MB에서 100MB로 증가

9/28, Google은 APK 최대 파일 사이즈를 50MB에서 100MB로 2배 늘려, 지금까지 50MB를 넘긴 어플리케이션은 별도 인스톨이 필요했지만, 100MB까지가 되어 불필요하게 되었습니다.

[APK 확장 파일 사용 및 첨부](https://support.google.com/googleplay/android-developer/answer/2481797?hl=ko)

이번 업데이트로 APK 파일 사이즈를 신경 쓸 필요가 없어졌을까요?

그럴 리는 없지요.

어플리케이션을 보다 많은 사람이 사용하길 위해 APK 사이즈에도 관심을 둘 필요가 있습니다.

## FaceBook, LINE의 구조

일본에 있으면 당연하게 고속통신을 사용할 수 있으니깐, APK 사이즈를 의식해서 인스톨을 주저하는 사람은 적다고 생각합니다.

하지만, 고속통신을 이용할 수 없는 신흥국가에서는, 인터넷에 접근하기 위해 선불 SIM을 구입하여 사용하는 경우가 많다고 합니다.

[Facebook, 직원이 신흥국가 모바일 속도를 체험「2G Tuesday」](http://bylines.news.yahoo.co.jp/satohitoshi/20151121-00051676/)

인용
> 신흥국가에서는 대부분이 선불 방식으로, 인터넷에 접근하기 위한 데이터 통신을 할 때도 선불 SIM을 구입해서 이용한다. 예를 들면 「1GB에 10달러」와 같은 가격 설정으로, 1GB를 넘으면 다시 충전하는 플랜입니다.

이런 신흥 국가에 맞게 최적화된 어플리케이션을 FaceBook은 [FaceBook Lite](https://play.google.com/store/apps/details?id=com.facebook.lite&hl=ja)(약 0.5MB)을, LINE은 [LINE Lite](https://play.google.com/store/apps/details?id=com.linecorp.linelite&hl=ja)(약 1MB)을 제공하고 있습니다.

둘다 매우 작은 사이즈로, APK 사이즈를 최소한으로 줄인 것을 알 수 있습니다.

신흥 국가에서도 스마트폰이 급속히 보급되고, 그 인구의 수에서도, 앞으로 더 많은 사용자가 어플리케이션을 사용하기 위해서, 무시할 수 없는 시장입니다.

이와 같은 흐름을 보고 「자신의 어플리케이션은 어디까지 사이즈를 압축할 수 있을까」라고 시험해본 항목을 정리해봤습니다. (단순한 호기심입니다)

### 최적화

먼저 zipalign 명령어로 최적화합니다.

실제로 운영하는 어플리케이션에서 zipalign을 하지 않는 분은, 거의 있지 않다고 생각합니다만, zipalign이 무엇을 하고 있는지 모르는 사람은 많지 않을까요.

[Android에 왜 zipalign을 할 필요가 있는가](http://qiita.com/nogson/items/abe1016f36c3b331db30)

인용
> 무엇을 하고있는가
>
> APK 안의 리소스 파일 등의 미압축 데이터를 4바이트 단위롤 정렬하고 있다.
>
> 실행하지않으면 무엇이 나쁜가
>
> Android에서는, 데이터가 4바이트 단위로 정렬되어 있을 때에 효율적으로 데이터에 접근할 수 있습니다.
> 역으로 정렬되어 있지 않은 경우, 그 정렬되지 않은 데이터를 올바르고 읽기 위해 느리게 되고, 또 많은 메모리를 소비하게 됩니다.


```groovy
buildTypes {
    release {
        debuggable false
        zipAlignEnabled true
     }
}
```

### ProGuard를 적용

난독화 툴인 ProGuard를 적용시킵니다.

부끄럽지만 과거 ProGuard를 적용할 때에 잘못 설정해, 충돌이 일어난 이후, 무서워서 사용하는 것을 피했습니다.

ProGuard는 난독화뿐만아니라, 사용하지않은 메소드나 변수를 제거하거나, 바이트 코드의 최적화를 하거나 APK 파일 사이즈를 압축하기에도 매우 효과가 있습니다.

저도 설정 파일의 도입까지는 상당히 시간을 뺏긴 일이 많았지만, [이 사이트](http://www.andr0o0id.com/?p=5340)를 참고했습니다.


```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```


### 이미지를 아이콘 폰트로 변경

단순한 아이콘 등을 이미지로 표시하는 경우는 가능한 한 아이콘 폰트를 사용합시다.

ProGuard 다음으로 감소 효과가 있습니다.

도입에 대해서는 딱 7일 차의 기사가 올라와 있습니다!

[Android 어플리케이션 개발을 IconFont로 행복하게](http://qiita.com/motodimago/items/8f10a7ddb3bb8f523bfc)

저는 도입이 편한 [android-iconify](https://github.com/JoanZapata/android-iconify)를 사용하는 편이 많습니다.

자체 ttf를 사용할 때는 아래 코드를 사용하고 있습니다.


```groovy
public enum AnimalIcons implements Icon {
    dog('\ue100'),
    cat('\ue101');

    char character;

    AnimalIcons(char character) {
        this.character = character;
    }

    @Override
    public String key() {
        return name().replace('_', '-');
    }

    @Override
    public char character() {
        return character;
    }

    public String icon() {
        return "{" + key() + "}";
    }
}
```


```java
public class AnimalIconModule implements IconFontDescriptor {

    @Override
    public String ttfFileName() {
        return "fonts/animal-icon.ttf";
    }

    @Override
    public Icon[] characters() {
        return AnimalIcons.values();
    }
}
```


```java
iconTextView.setText(AnimalIcons.dog.icon());
```

라이브러리에 따라서 구현 방법이 다르므로, 여러 사람이 개발하고 있는 프로젝트에서는 취향이 다를 가능성이 있습니다.

## 결과

위는 제가 가장 효과가 있었던 3가지 예를 들고 있습니다.

결과로 5MB→17MB와 8MB 압축했으니, 노력한 보람이 있었다고 생각합니다.

(이외에도 이미지 압축 등을 했습니다.)

연말 대청소도 겸해서, 어디까지 압축할 수 있을까를 시험해보면 어떨까요.

또, 그 밖에도 좋은 방법을 아시는 분이 계시면, 알려주세요.
