---
layout: post
title: "Google Breakpad를 이용한 Android JNI DUMP 및 Java Method Call"
date: 2015-06-12 02:00:00
tag: [Android, Google Breakpad, Crash, JNI, Java, Callback]
categories:
- blog
- Android-Study
- JNI-Study
---

<!--more-->

###Crash Log 수집

- - -

Android 개발하면서 이것저것 죽어버리는 오류를 개발중에는 `Logcat`을 보면서 바로 체크하면되지만

테스트 도중에 일어나면 ... 속수무책입니다.

그래서, 개발시에는 Crash 관련 처리를 미리 해두는것이 좋습니다.

Crash 가 일어난 원인 체크 및 추가적으로 `레드마인`, `JIRA`, `GitLab` 등 이슈 트래킹에 도움이 됩니다.

###Java Crash 처리

- - -

Android 개발시 Java의 Crash 로그 수집의 기본처리는 아래와 같습니다.

{% highlight java %}
public class MyUncaughtExceptionHandler
	implements Thread.UncaughtExceptionHandler {

  // <!-- 생략 -->  

  @Override
	public void uncaughtException(final Thread thread, final Throwable ex) {
    // <!-- 필요한 처리 -->  
  }

}

// reportHandler 는 Thread.UncaughtExceptionHandler 를 상속받은 클래스의 인스턴스
Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
{% endhighlight %}

위의 소스처럼 기본적인 Thread의 에러처리 핸들러를 `UncaughtExceptionHandler` 상속받은 클래스의 인스턴스를 적용하는것으로 끝이다.

그 후, 필요한 처리를 `uncaughtException()` 함수내에서 하시면됩니다.

기본적으로 `stacktrace` 등의 정보를 수집하면 됩니다.

###그래서 JNI ... 대안은 Google Breakpad

- - -

JNI 내부에서 에러가나는 경우에도 `stacktrace` 체크는 가능하지만, 실질적인 에러가 일어난 `C`, `C++`의 파일 위치 확인은 불가능합니다.

그래서 대안은 `Google Breakpad` 가 있습니다.

Google Breakpad는 Cross Platform을 지원하며 이미 여러 프로그램에서 사용중입니다. 예로는 Chrome Browser, Firefox, Camino, Google Picasa, Google Earth 등이 있습니다.

하지만, 현재 `Google Code`는 새로운 프로젝트를 더이상 등록이 불가능하고, Google 측의 전체 프로젝트가 GitHub로 이관 예정이지만, 아직 Google Breakpad 는 이관되지 않았습니다.

추후 Google Code 접근 종료시 제 개인 GitHub Repository를 이용하시길 바랍니다.

###Step1. 기본 설정

- - -

해당순서는 `Android Studio` 기준으로 작성했습니다.

기본적인 View Injection 은 `butterknife` 를 사용했습니다.

1. 기본 프로젝트 Project Download
2. JNI Folder Setting
 * Android.mk 파일 생성
 * Application 파일 생성
 * JNI 파일 생성 (예, test_breakpad.cpp)

####Activity 설정

* Native Load
{% highlight java %}
System.loadLibrary("test_google_breakpad");
{% endhighlight %}

* Native Call Method
{% highlight java %}
native void initNative(String path);
native void crashService();
{% endhighlight %}

`initNative` 메소드는 추후 DUMP 파일이 저장될 곳을 지정하기위해 path 를 매개변수로 받도록 정의했습니다.

####Gradle 설정

기존 Eclipse 에서는 Command 창에서 `ndk-build` 를 입력해서 빌드 처리나 별도 작업했는데, Gradle 관련은 아래 Task 를 build.gradle 파일에 등록해줍니다.

{% highlight groovy %}
task ndkBuild(type: Exec, description:'Compile JNI source via NDK') {
    Properties properties = new Properties()
    properties.load(project.rootProject.file('local.properties').newDataInputStream())

    def command = properties.getProperty('ndk.dir')
    if (Os.isFamily(Os.FAMILY_WINDOWS)) {
        command += "\\ndk-build.cmd"
    } else {
        command += "/ndk-build"
    }

    // Task내에서 Build Type을 검사할 수 없기 때문에 local.properties의 ndk.dir로
    // Debug 가능한 Library를 Build할 지 검사한다.
    def isDebug = true
    if (isDebug) {
        commandLine command, 'NDK_DEBUG=1', '-C', file('src/main').absolutePath
    } else {
        commandLine command, '-C', file('src/main').absolutePath
    }
}

tasks.withType(JavaCompile) {
    compileTask -> compileTask.dependsOn ndkBuild
}
{% endhighlight %}

####JNI 초기파일 설정

{% highlight cpp %}
#include <jni.h>
#include <stdio.h>
#include <android/log.h>

extern "C" {
    void Java_com_pluusystem_breakpadjavacall_MainActivity_initNative(JNIEnv* env, jobject obj, jstring filepath)
    {
        __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "initNative cal");
    }

    void Java_com_pluusystem_breakpadjavacall_MainActivity_crashService(JNIEnv* env, jobject obj)
    {
        __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "crashService call");
    }
}
{% endhighlight %}

JNI 호출시 해당 C, C++ 파일의 함수 정의 양식은 `Java_JNI 호출 패키지_호출 패키지_호출 함수`과 같습니다.

 * 결과 : Java_com_pluusystem_breakpadjavacall_MainActivity_initNative

올바른 설정이 되었다면 다음 로그가 출력됩니다.

 * 앱 실행 : `initNative call`
 * 버튼 선택 : `crashService call`

Step1 소스 : [Step1 링크](https://github.com/Pluu/BreakpadJavaCall)

###Step2. Google Breakpad & Crash

- - -

1. Google Breakpad Download
 * [https://code.google.com/p/google-breakpad/](https://code.google.com/p/google-breakpad/)
 * [GitHub - 개인 Mirror](https://github.com/Pluu/google-breakpad)
2. Google Breakpad 관련 JNI 설정
3. Crash 연결

####Android Stuido JNI 폴더 구조
<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-06-12-android-google-breakpad-javacallback-01.png" }}" />

- jni - 하위 구조
 * google_breakpad - src
     * Google Breakpad - src 폴더
 * google_breakpad - src - Android.mk
     * Google Breakpad - android - google_breakpad - Android.mk 파일
 * Android.mk
     * Google Breakpad - android - sample_app - jni - Android.mk 파일
 * Application.mk
     * Google Breakpad - android - sample_app - jni - Application.mk 파일

####Android.mk 파일 수정 (jni 하위)

Google Breakpad 원본 - 현재 프로젝트 비교
<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-06-12-android-google-breakpad-javacallback-02.PNG" }}" />

```
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_DEFAULT_CPP_EXTENSION := cpp

LOCAL_MODULE := test_google_breakpad
LOCAL_SRC_FILES := test_breakpad.cpp
LOCAL_STATIC_LIBRARIES += breakpad_client
LOCAL_LDLIBS := -L$(SYSROOT)/usr/lib -llog

include $(BUILD_SHARED_LIBRARY)

# If NDK_MODULE_PATH is defined, import the module, otherwise do a direct
# includes. This allows us to build in all scenarios easily.
ifneq ($(NDK_MODULE_PATH),)
  $(call import-module,google_breakpad)
else
  include $(LOCAL_PATH)/google_breakpad/Android.mk
endif
```

####Android.mk 파일 수정 (jni - google_breakpad 하위)

Google Breakpad 원본 - 현재 프로젝트 비교

 * LOCAL PATH
<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-06-12-android-google-breakpad-javacallback-03.PNG" }}" />

 * LOCAL_SRC_FILES 추가
<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2015/2015-06-12-android-google-breakpad-javacallback-04.PNG" }}" />

```
src/client/linux/dump_writer_common/thread_info.cc \
src/client/linux/dump_writer_common/seccomp_unwinder.cc \
src/client/linux/dump_writer_common/ucontext_reader.cc \
src/client/linux/microdump_writer/microdump_writer.cc \
```

####test_breakpad.cpp 파일 수정

DUMP 파일 수집을 위해 Google Breakpad 관련 내용을 적용합니다.

{% highlight cpp %}
#include <jni.h>
#include <android/log.h>
#include <stdio.h>

#include "google_breakpad/src/client/linux/handler/exception_handler.h"
#include "google_breakpad/src/client/linux/handler/minidump_descriptor.h"

static google_breakpad::ExceptionHandler* exceptionHandler;
bool DumpCallback(const google_breakpad::MinidumpDescriptor& descriptor,
                  void* context,
                  bool succeeded) {

    __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "Dump path: %s\n", descriptor.path());
    return succeeded;
}

void Crash() {
    volatile int* a = reinterpret_cast<volatile int*>(NULL);
    *a = 1;
}

extern "C" {
    void Java_com_pluusystem_breakpadjavacall_MainActivity_initNative(JNIEnv* env, jobject obj, jstring filepath)
    {
        const char *path = env->GetStringUTFChars(filepath, 0);
        google_breakpad::MinidumpDescriptor descriptor(path);
        exceptionHandler = new google_breakpad::ExceptionHandler(descriptor, NULL, DumpCallback, NULL, true, -1);

        __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "initNative cal");
    }

    void Java_com_pluusystem_breakpadjavacall_MainActivity_crashService(JNIEnv* env, jobject obj)
    {
		__android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "crashService call");

        Crash();
    }
}
{% endhighlight %}

앱 실행 후 NATIVE CRASH 버튼을 선택하면 다음 로그가 출력됩니다.

`Dump path: /storage/emulated/0/Android/data/com.pluusystem.breakpadjavacall/cache/741afdff-1cb4-feb8-6890f070-16e328fa.dmp`

741afdff-1cb4-feb8-6890f070-16e328fa.dmp 대신 다른 파일이 출력됩니다.

Step2 소스 : [Step2 링크](https://github.com/Pluu/BreakpadJavaCall/tree/step2)

###Step3. Crash Java Function Call

1. JNI 에서 호출 할 Java Ntive Interface Class 생성
2. JNI 에서 호출

* NativeController.java

{% highlight java %}
public class NativeController {
	public static int NativeCrashCallback(String fileName) {

		Log.d("PluuSystem", "NativeCrashCallback Called");
		Log.d("PluuSystem", "Dump FileName=" + fileName);

		return 0;
	}
}

{% endhighlight %}

* test_breakpad.cpp
{% highlight cpp %}
bool DumpCallback(const google_breakpad::MinidumpDescriptor& descriptor,
                  void* context,
                  bool succeeded) {

    __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "Dump path: %s\n", descriptor.path());

    jclass cls = jEnv->FindClass("com/pluusystem/breakpadjavacall/NativeController");

    if(cls == NULL) {
      return false;
    }

    jmethodID mhthod = jEnv->GetStaticMethodID(cls, "NativeCrashCallback", "(Ljava/lang/String;)I");
    if(mhthod == NULL) {
      return false;
    }

    const char* path = descriptor.path();

    jstring jstr = jEnv->NewStringUTF(path);
    if (jstr == NULL) {
      return false;
    }

    jint i = jEnv->CallStaticIntMethod(cls, mhthod, jstr);

    return succeeded;
}
{% endhighlight %}

최초 `Java_com_pluusystem_breakpadjavacall_MainActivity_initNative` 호출시 전달받은 `JNIEnv* env` 객체를 이용해서 다음 로직을 호출하여 자바의 함수를 호출합니다.

JNI 작업 순서

1. FindClass
2. GetStaticMethodID
3. CallStaticIntMethod

해당 작업 완료 후, Crash 가 일어났을때 나타나는 로그

1. `NativeCrashCallback Called`
2. `Dump FileName=/storage/emulated/0/Android/data/com.pluusystem.breakpadjavacall/cache/649a81f1-b6be-90fa-6532828a-0ce9ba0c.dmp`

Step3 소스 : [Step3 링크](https://github.com/Pluu/BreakpadJavaCall/tree/final)

###추천 Android 관련 Crash Report Service

- - -

추천하는 서비스는 아래를 참고하시길 바랍니다.

| 비고 | Fabric | Acra | UrQA | HockeyApp |
| :--: | :--: | :--: | :--: | :--: |
| Java | O | O | O | O |
| JNI | X | X | O | O |
| JNI Module | - | - | Google Breakpad | Google Breakpad |

###etc

- - -

- [Google Breakpad](https://code.google.com/p/google-breakpad/)
- [Google Breakpad Wiki](https://code.google.com/p/google-breakpad/wiki/GettingStartedWithBreakpad)
- [Fabric](https://get.fabric.io/)
- [ACRA](https://github.com/ACRA/acra)
- [UrQA](http://urqa.io/urqa/)
- [HockeyApp](http://hockeyapp.net/features/)
- [원도우즈 환경에서 breakpad 사용하기](http://yardbirds.tistory.com/107)
- [모바일 앱 크래시!! 네이버에서는 어떻게 수집하고 보여줄까요?](http://deview.kr/2014/session?seq=8)
