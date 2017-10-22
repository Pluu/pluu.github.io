---
layout: post
title: "[번역] DroidKaigi 2017 ~ 조금 행복해지 기술"
date: 2017-10-22 23:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ 少し幸せにする技術](https://speakerdeck.com/kamedon/shao-sixing-senisuruji-shu) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 조금 행복해지 기술

DroidKaigi 2017 3/9 18:00 ~

Kameron

## 2p

축! 첫 발표

## 3p

자기소개

## 4p, 프로필

- Kameron
- [Kotlin](https://kotlinlang.org/) 좋아합니다
- [Class Method](https://classmethod.jp/)에서 안드로이드 앱 개발을 하고 있습니다
- [보드 게임](http://dev.classmethod.jp/etc/no-boardgame-no-life/)을 좋아합니다.

## 5p

ClassMethod에 JOIN 했습니다 "めそ子" 입니다.

https://dev.classmethod.jp/etc/mesoko-joined-classmethod/

## 6p, 발표 계기

- 2.3시대, Eclopse 시대의 오래된 정보가 걸립니다
- 입문서가 정말로 입문서
   - 움직이는 코드가 적혀있지만, 프로젝트에 사용하기 위해 필요한것은 그다지 안적혀있다
   - 다음 스텝으로의 키워드로서 상세하게 다루지 않는다
- 발표자의 참가비 무료
   - 지원하는 것만으로도 매진시에 구입 가능
   - 안될걸 생각하고 지원해봤습니다.

## 7p, 이 발표로 행복해지는 사람

- 초심자에서 중급자로 스텝업하려는 사람
   - Android 개발을 더 편하게 한다
   - Android 개발이 덜 실패하도록 한다
   - 계정 정지되지 않도록 한다

## 8p, 아젠다

- 역순 형식으로 소개하겠습니다
   - Android Studio
   - Build.gradle
   - 디버그
   - OS, 단말
   - Proguard
   - Google Play Console

## 9p

Android Studio편

## 10p, Android Studio편 (ver2.3)

- [Jetbrains](https://www.jetbrains.com/)사 IDE
- 예전에 Eclipse 라는게 있었다
   - ADT라는 Plug-in이 있었지만, 지원 종료되었으므로 반드시 [Android Studio](https://developer.android.com/studio/index.html)를 사용하자

## 11p, 다른 IDE와 단축키가 다르므로 짜증났다

- Android Studio 최강 커맨드 Find Action
   - Mac: ⌘ ⇧ A
   - Windows: Ctrl Shift A
- 커맨드를 검색하고 단축키까지 알 수 있다
   - 설정에서 Keymap을 변경하면 원하는 설정이 가능하다

## 12p, 특정 파일에 더 간단하게 접근하기

- Android Studio 최강 커맨드에 이어 Search Everywhere
   - Mac: ⇧ ⇧
   - Windows: Shift Shift
- 파일명을 간단하게 검색할 수 있다

## 13p, 포맷을 준비하는게 귀찮다

- [Save Actions](https://plugins.jetbrains.com/plugin/7642-save-actions)로 저장해서 자동으로 포맷을 준비한다

## 14p, 재설치, 설치가 귀찮다

- Plugin [ADB IDEA](https://plugins.jetbrains.com/plugin/7380-adb-idea)

<img src="https://github.com/pbreault/adb-idea/raw/master/website/adb_operations_popup.png" />

## 15p, 테스트가 실패하는 것을 알고 싶다

```
public class CalcUtil {
   public static int mod(int x, int y) {
      if (y == 0) {
         throw new IllegalArgumentException("y != 0");  
      }
      return x % y;
   }
}
```

## 16p, 테스트가 실패하는 것을 알고 싶다

```
public class CalcUtilTest {
   @Test
   public void 나머지_테스트() {
      Assert.assertThat(3, Is.is(CalcUtil.mod(11, 4)));
      // y가 0인 케이스가 빠져있다
   }
}
```

## 17p, 테스트가 성공못하는 것을 알고 싶다

Run 'Test in ...' with Coverage 를 실행

## 18p

Build.gradle편

## 19p, Build.gradle편

- 앱 기본정보를 설정
   - 이전에는 모두 AndroidManifest에 관리했지만, 일부 설정이 Build.gradle로 관리하게 되었다
   - AndroidManifest: Permission이나 페이지, 동작 설정
   - Build.gradle: 버전, 라이브러리, 환경 설정

## 20p, 개발 버전과 릴리즈 버전은 공존 가능한가?

- [Build Variants와 Product Flavor](https://developer.android.com/studio/build/build-variants.html)를 사용할 수 있다
   - 패키지명이 같으면 공존할 수 없습니다
   - 디버그와 릴리즈버전의 패키지명이 다르도록 Suffix를 붙입니다.

## 21p, 버전 코드와 버전명 관리가 귀찮다

```
// app/build.gradle
buildTypes {   // Build Variants
   release {}
   debug {
      applicationIdSuffix ".debug"
   }
}
productFlavors {   // Product Flavor
   demo {
      applicationIdSuffix ".demo"
   }
   full {
      applicationIdSuffix ".full"
   }
   // {pkg}.{Flavor}.{BuildType}
   // {pkg}.demo.debug
}
```

## 22p, 개발과 제품 버전으로 정수를 나누고 싶다

- Build Variants와 Product Flavor로 동일한 이름이라면  Build Variants 쪽을 우선시
   - BuildConfig 파일이 생긴다

## 23p ~ 24p, 개발과 제품 버전으로 정수를 나누고 싶다

buildTypes {
   release {
      buildConfigField "String", "ENDPOINT", "\"https://hoge.com\" "
   }
   debug {
      applicationIdSuffix ".debug"
      buildConfigField "String", "ENDPOINT", "\"https://localhost\" " 
   }
}

productFlavors {
   demo {
      buildConfigField "boolean", "DEMO", "true"
      applicationIdSuffix ".demo" 
   }
   full {
      buildConfigField "boolean", "DEMO", "false"
      applicationIdSuffix ".full" 
   }
}

## 25p, 개발 버전과 릴리즈 버전, 어느 쪽인지 알기 쉽게하고 싶다.

- 리소스 파일, 소스 코드도 Build Variants와 Product Flavor로 나뉘어져있다 (우선순위는 위에서 순서대로)
   - src/demoDebug/ (Build Variants Flavor)
   - src/debug/ (Build Variants)
   - src/demo/ (Flavor)
   - src/main/ (Main)

## 26p, 개발 버전과 릴리즈 버전, 어느 쪽인지 알기 쉽게하고 싶다.

- 예를들면 실제 버전과 개발 앱 이름을 바꿔본다
   - app/src/main/res/values/strings.xml 을 app/src/debug/res/values/strings.xml에 복사, 편집한다
- 동일한 위치에 작성하면 덮어쓰기된다

## 27p, Build Variants와 Product Flavor 구분을 모르겠다

- Build Variants : 환결 설정
   - 실제 서버와 개발 서버의 주소
   - 실제용 서명, 개발용 서명
- Product Flavor : 앱의 동작
   - Debug Mode : ON/OFF
   - 무료 버전/유료 버전 : ON/OFF

## 28p, 버전 코드와 버전명 관리가 귀찮다

```
// versionName 과 versionCode를 연동하도록 한다
def major = 1
def minor = 0
def patch = 0
def build = 0

// 개발자는 versionName 을 올리고 싶은 Google Play는 versionCode를 올리면 된다
android {
   defaultConfig {
      versionCode major * 10000 + minor * 1000 + patch * 100 + build
      versionName "${major}.${minor}.${patch}"
   }
}
```

## 29p, 서명 관리는 어떻게 하면 좋을까?

- [서명](https://developer.android.com/guide/publishing/app-signing.html)을 build.gradle에 그냥 적기
   - Private Repository 등이면 유효
   - CI에서도 다루기 쉽다
- 파일에 쓴다
   - git에서 무시 설정하고, 키는 별도 관리

## 30p, 서명을 그냥 적는다

```
signingConfigs {
   release {
      storeFile file("./filepath")
      keyAlias "test"
      storePassword "test"
      keyPassword "test"
   }
} 
```

## 31p, 서명 정보를 파일에 적는다

- keystore.properties 작성

```
storePassword=myStorePassword
keyPassword=mykeyPassword
keyAlias=myKeyAlias
storeFile=myStoreFileLocation 
```

## 32p

- build.gradle에서 읽기

```
signingConfigs {
   debug {
      def keystorePropertiesFile = rootProject.file("keystore.properties")
      def keystoreProperties = new Properties()
      keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
      keyAlias keystoreProperties['keyAlias']
      keyPassword keystoreProperties['keyPassword']
      storeFile file(keystoreProperties['storeFile'])
      storePassword keystoreProperties['storePassword']
   }
}
```

## 33p

디버그편

## 34p, 디버그편

- 마지막 수단으로 프린트 디버그
- Memory Leak이나 통신 쪽이 디버그하기 어렵다

## 35p, 제품 버전의 때에는 Log를 출력하고 싶지 않다

- [JakeWharton/timber](https://github.com/JakeWharton/timber)를 사용
   - Debug에만 로그를 출력하는 것이 쉽다
   - 로그를 언제 출력할지 변경도 간단

```
if (BuildConfig.DEBUG) {
   Timber.plant(Timber.DebugTree())
}
Timber.d("test", "test")
```

## 36p, 통신 부분 디버그가 하기 어렵다

- [facebook/stetho](https://github.com/facebook/stetho)를 넣어 Chome으로 디버그
   - 소스 코드에 넣을 필요가 있다
- [mitmproxy](https://mitmproxy.org/)를 넣어 네트워크를 감시
   - 소스 코드에 넣을 필요가 없다
   - python 코드로 endpoint를 바꿀 수 있다

## 39p, Memory Leak 디버그는 힘들다

- [square/leakcanary](https://github.com/square/leakcanary)를 사용하면 간단
   - Application에 적는 것만으로 Leak 시에 알림을 알려준다

## 40p, Log떄문에 Unit Test로 에러가 나온다

- Log 뿐이라면, ClassLoader의 구조를 사용해 Log를 덮어 쓰기 한다

app/src/test/java/android/util/Log.java에 아래 코드를 둔다

```
public class Log {
   public static int v(String tag, String msg) { return 0; }
   public static int v(String tag, String msg, Throwable tr) { return 0; }
   public static int d(String tag, String msg) { return 0; }
   public static int d(String tag, String msg, Throwable tr) { return 0; }
   public static int i(String tag, String msg) { return 0; }
   public static int i(String tag, String msg, Throwable tr) { return 0; }
   public static int w(String tag, String msg) { return 0; }
   public static int w(String tag, String msg, Throwable tr) { return 0; }
   public static int w(String tag, Throwable tr) { return 0; }
   public static int e(String tag, String msg) { return 0; }
   public static int e(String tag, String msg, Throwable tr) { return 0; }
}
```

## 41p

ProGuard 편

## 42p, [Proguard](https://developer.android.com/studio/build/shrink-code.html)

- 보안상으로 최저한 릴리즈시에 반드시 설정한다
   - 앱 사이즈가 줄어듦
   - 일시적인 위안의 난독화

```
public class MainActivity extends c {
   private TextView m;
   public MainActivity() {}
   protected void onCreate(Bundle var1) {
      super.onCreate(var1);
      this.setContentView(2130968603);
      this.m = (TextView)this.findViewById(2131427415);
      this.m.setText("hello world");
   }
} 
```

## 43p, 64k 메소드밖에 안되?

- 64k 메소드는 빌드할 수 없다
   - [ProGuard](https://developer.android.com/studio/build/shrink-code.html)를 쓰는 것으로 메소드 수가 줄어듦
   - 그래도 안되는 경우는 [Multidex](https://developer.android.com/studio/build/multidex.html)를 이용해 64k의 벽을 넘을 수 있다

## 44p, ProGuard를 걸면 에러가 난다. 이상한 땀이 나온다

- ProGuard가 하고있는 것을 이해한다
   - 미사용 메소드 삭제
   - 클래스명, 메소드를 a,b 등으로 이름을 변경
- Reflection을 사용하는 곳에서 에러가 난다
   - 그 부분은 Keep을 사용해서 이름 변경이 되지 않고, 삭제되지 않도록 한다

## 45p, 릴리즈일 때만 ProGuard를 걸면 안심되지 않는다

- 개발 중에도 ProGuard를 걸어두면 안심
   - 빌드가 느려지는 단점
   - 개발 중에는 코드 삭제는 하지만, 이름 변경은 하지 않는 편이 좋다

```
buildTypes {
   debug {
      minifyEnabled true
      useProguard false
      proguardFiles getDefaultProguardFile('proguardandroid.txt'), 'proguard-rules.pro'
   }
} 
```

## 46p, Crash Report가 난독화되어 보기 어렵다

- 난독화시에 생성된 mapping.txt를 Google Play Console에 업로드한다

## 47p

OS, 단말편

## 48p, OS, 단말편

- 기기 의존, 버전 의존, Permission, Task Killer 등으로 재현하기 어려운 등 다양한 문제가 있다

## 49p, 기기 의존이 너무 크다

- 기운낸다
   - 하드웨어 관한 것은 정신과 근성
   - 검증 센터 등에 갈 수 있다면 이용한다
- 가능하면 SupportLibrary가 있는 기능을 사용

## 50p, Runtime Permission 대응

- Android 6.0부터 도입된 Runtime Permission
   - 앱 설치시에 모두 허가할 수 없고, 사용시에 허가를 요구한다
- 독자 구현은 귀찮으므로 hotchemi/PermissionsDispatcher 를 사용

## 51p

Google Paly Console 편

## 52p, Google Paly Console 편

- Google Play는 Google이 운영하는 스토어
- Android는 오픈된 마켓이므로 어디서든 앱을 배포해도 된다
   - Amazon Store, au スマートパス, 블로그
- Google Play Console은 Play 관리 화면

## 53p, Android 심사가 없으므로, 마음대로이죠?

- 아니요. 힘들게 되었습니다.
   - 반드시 [Developer Policy](https://play.google.com/intl/ja/about/developer-content-policy/)를 확인. 가끔씩 변경되므로 주의가 필요.
      - 개인정보 및 민감한 정보
      - 수익 창출 및 광고
- 반년 전의 [Policy 변경](https://play.google.com/intl/ja/about/updates-resources/updates/)은 대규모였으므로 반드시 확인

## 54p, Developer Policy의 사례

- [변경 사례](https://play.google.com/intl/ja_ALL/about/updates-resources/)
   - [개인정보 및 민감한 정보](https://play.google.com/intl/ja_ALL/about/privacy-security/personal-sensitive/) 사용자의 개인 데이터 또는 민감한 사용자 데이터(개인 식별 정보, 금융 및 결제 정보, 인증 정보, 전화번호부 또는 연락처 데이터, 마이크 및 카메라 센서 데이터, 기기 관련 민감한 데이터 등)를 처리하는 경우 다음을 준수해야 합니다.
- 주의할 점
   - [수익 창출 및 광고](https://play.google.com/intl/ja_ALL/about/monetization-ads/ads/) 광고는 게재되는 앱의 내부에만 표시될 수 있습니다. 앱 내에 게재되는 광고는 앱의 일부로 간주됩니다.

## 55p, 언제 공개되는지 알고 싶다

- 공개 버튼을 누르고 실제로 반영되는 것은 2~3시간 후. 알림 설정을 사용할지
- Google Play Console 앱을 사용할지

## 56p, 하지만 더 공개될 때까지 빨리되지 않아?

- 경험에 의하면 Beta가 공개되어있는 경우는 공개 버튼을 누르고 10분 정도로 반영되는 경우가 많습니다

## 57p, 정리

- Android Studio… 멋집니다
- Build.gradle 주변을 찾아보면 개발이 편해진다
- Debug 도구도 풍부해졌다
- Google Play Console은 최근 기능이 늘어났으므로 확인
- 단말 의존은 노력할 수밖에 없다
- ProGuard는 정기적으로 적용해두면 안심

## 58p, 참고 문건

- 슬라이드에 링크를 설정했습니다
- 그 외
   - [DroidKaigi/conference-app-2017](https://github.com/DroidKaigi/conference-app-2017)
   - [JakeWharton/u2020](https://github.com/JakeWharton/u2020)
   - [Android Developers](https://developer.android.com/develop/index.html)