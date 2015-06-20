---
layout: post
title: "Android JNI Crash 디버그"
date: 2015-06-20 22:00:00
tag: [Android, NDK, Google Breakpad, Crash, JNI, Debug, addr2line, minidump_stackwalk]
categories:
- blog
- Android-Study
- JNI-Study
---

<!--more-->

###Intro

- - -

지난 포스팅에서는 JNI 단에서 발생하는 Crash 를 수집하는 방법을 설명해드렸습니다.

지난 포스팅 링크 : [링크](http://pluu.github.io/blog/android-study/jni-study/2015/06/12/android-google-breakpad-javacallback/)

이번 포스팅에서는 JNI 관련 Crash 발생시 원인이 되는 곳을 찾는법에 대해서 포스팅을 작성하겠습니다.

###사전작업

- - -

주 개발을 Windows 에서 하므로, 몇몇 과정이 다를 수 있습니다.

1. Android NDK Download
 - {NDK-PATH}\ndk-bundle\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64\bin\\`arm-linux-androideabi-addr2line.exe`
2. Google Breakpad Build
 - cygwin 에서 breakpad tools download [google-breakpad-tools-1434-1](https://cygwin.com/cgi-bin2/package-cat.cgi?file=x86_64%2Fgoogle-breakpad-tools%2Fgoogle-breakpad-tools-1434-1&grep=breakpad)
		 - Result : `minidump_stackwalk.exe`
 - linux 계열에서 breakpad Buiild `INSTALL` 파일 확인
     - ./configure
	   - make
	   - make install
     - Build Result : {BREAKPAD-PATH}\src\processor\\`minidump_stackwalk`

#### 기본 테스트 소스

{% highlight java linenos %}
#include <jni.h>
#include <android/log.h>
#include <stdio.h>

#include "google_breakpad/src/client/linux/handler/exception_handler.h"
#include "google_breakpad/src/client/linux/handler/minidump_descriptor.h"

JNIEnv * jEnv = 0;
static google_breakpad::ExceptionHandler* exceptionHandler;

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

void Crash() {
//    volatile int* a = reinterpret_cast<volatile int*>(NULL);
//    *a = 1;
    int i = 10 / 0;
}

extern "C" {
    void Java_com_pluusystem_breakpadjavacall_MainActivity_initNative(JNIEnv* env, jobject obj, jstring filepath)
    {
        jEnv = env;

        if (false) {
            const char *path = env->GetStringUTFChars(filepath, 0);
            google_breakpad::MinidumpDescriptor descriptor(path);
            exceptionHandler = new google_breakpad::ExceptionHandler(descriptor, NULL, DumpCallback, NULL, true, -1);
        }

        __android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "initNative cal");
    }

    void Java_com_pluusystem_breakpadjavacall_MainActivity_crashService(JNIEnv* env, jobject obj)
    {
    	__android_log_print(ANDROID_LOG_DEBUG, "PluuSystem", "crashService call");

        Crash();
    }
}
{% endhighlight %}

###Logcat 결과 체크

- - -

사전 작업 : 51번째 줄을 false 처리하여 Logcat 에 Crash Log 가 나오도록 수정

{% highlight console linenos %}
I/DEBUG﹕ *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
I/DEBUG﹕ Build fingerprint: 'generic/vbox86p/vbox86p:4.3/JLS36G/eng.buildbot.20150609.213200:userdebug/test-keys'
I/DEBUG﹕ Revision: '0'
I/DEBUG﹕ pid: 24903, tid: 24903, name: reakpadjavacall  >>> com.pluusystem.breakpadjavacall <<<
I/DEBUG﹕ signal 8 (SIGFPE), code -6 (SI_TKILL), fault addr 00006147
I/DEBUG﹕ eax 0000000a  ebx 97efffe4  ecx 00000000  edx 00000000
I/DEBUG﹕ esi 9ec38d9c  edi bfb358ac
I/DEBUG﹕ xcs 00000073  xds 0000007b  xes 0000007b  xfs 00000000  xss 0000007b
I/DEBUG﹕ eip 97efe861  ebp bfb35878  esp bfb35868  flags 00210246
I/DEBUG﹕ backtrace:
I/DEBUG﹕ #00  pc 00000861  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so (Crash()+22)
I/DEBUG﹕ #01  pc 00000915  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so (Java_com_pluusystem_breakpadjavacall_MainActivity_crashService+55)
I/DEBUG﹕ #02  pc 0002a05b  /system/lib/libdvm.so (dvmPlatformInvoke+79)
I/DEBUG﹕ #03  pc 0000653f  [heap]
I/DEBUG﹕ #04  pc 00085b32  /system/lib/libdvm.so (dvmCallJNIMethod(unsigned int const*, JValue*, Method const*, Thread*)+434)
I/DEBUG﹕ #05  pc 0008a0b6  /system/lib/libdvm.so (dvmResolveNativeMethod(unsigned int const*, JValue*, Method const*, Thread*)+326)
I/DEBUG﹕ #06  pc 00173058  /system/lib/libdvm.so
I/DEBUG﹕ #07  pc 00005d93  <unknown>
I/DEBUG﹕ #08  pc 0003b322  /system/lib/libdvm.so (dvmMterpStd(Thread*)+66)
I/DEBUG﹕ #09  pc 000369e9  /system/lib/libdvm.so (dvmInterpret(Thread*, Method const*, JValue*)+217)
I/DEBUG﹕ #10  pc 000b9f62  /system/lib/libdvm.so (dvmInvokeMethod(Object*, Method const*, ArrayObject*, ArrayObject*, ClassObject*, bool)+1634)
I/DEBUG﹕ #11  pc 000ce9e0  /system/lib/libdvm.so (Dalvik_java_lang_reflect_Method_invokeNative(unsigned int const*, JValue*)+288)
I/DEBUG﹕ #12  pc 00173058  /system/lib/libdvm.so
I/DEBUG﹕ #13  pc 00005eff  <unknown>
I/DEBUG﹕ #14  pc 0003b322  /system/lib/libdvm.so (dvmMterpStd(Thread*)+66)
I/DEBUG﹕ #15  pc 000369e9  /system/lib/libdvm.so (dvmInterpret(Thread*, Method const*, JValue*)+217)
I/DEBUG﹕ #16  pc 000bacf7  /system/lib/libdvm.so (dvmCallMethodV(Thread*, Method const*, Object*, bool, JValue*, char*)+759)
I/DEBUG﹕ #17  pc 0007774d  /system/lib/libdvm.so (CallStaticVoidMethodV(_JNIEnv*, _jclass*, _jmethodID*, char*)+109)
I/DEBUG﹕ #18  pc 0005d3ea  /system/lib/libandroid_runtime.so (_JNIEnv::CallStaticVoidMethod(_jclass*, _jmethodID*, ...)+42)
I/DEBUG﹕ #19  pc 0005eaac  /system/lib/libandroid_runtime.so (android::AndroidRuntime::start(char const*, char const*)+924)
I/DEBUG﹕ #20  pc 00001017  /system/bin/app_process (main+567)
I/DEBUG﹕ #21  pc 0000cedc  /system/lib/libc.so (__libc_init+108)
I/DEBUG﹕ #22  pc 00000a91  /system/bin/app_process (_start+97)
I/DEBUG﹕ stack:
I/DEBUG﹕ bfb35828  00000000
I/DEBUG﹕ bfb3582c  00000000
I/DEBUG﹕ bfb35830  00000000
I/DEBUG﹕ bfb35834  00000000
I/DEBUG﹕ bfb35838  00000000
I/DEBUG﹕ bfb3583c  00000000
I/DEBUG﹕ bfb35840  00000000
I/DEBUG﹕ bfb35844  00000000
I/DEBUG﹕ bfb35848  00000000
I/DEBUG﹕ bfb3584c  00000000
I/DEBUG﹕ bfb35850  00000000
I/DEBUG﹕ bfb35854  00000000
I/DEBUG﹕ bfb35858  00000000
I/DEBUG﹕ bfb3585c  00000000
I/DEBUG﹕ bfb35860  00000000
I/DEBUG﹕ bfb35864  00000000
I/DEBUG﹕ #00  bfb35868  b71397a9  /system/lib/liblog.so (__android_log_print+9)
I/DEBUG﹕ bfb3586c  97efffe4  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so
I/DEBUG﹕ bfb35870  9ec38d9c
I/DEBUG﹕ bfb35874  bfb358ac  [stack]
I/DEBUG﹕ bfb35878  bfb35898  [stack]
I/DEBUG﹕ bfb3587c  97efe916  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so (Java_com_pluusystem_breakpadjavacall_MainActivity_crashService+56)
I/DEBUG﹕ #01  bfb35880  00000003
I/DEBUG﹕ bfb35884  97efe92f  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so
I/DEBUG﹕ bfb35888  97efe9a6  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so
I/DEBUG﹕ bfb3588c  b61a3ccc  /system/lib/libdvm.so
I/DEBUG﹕ bfb35890  a544bbc8  /dev/ashmem/dalvik-heap (deleted)
I/DEBUG﹕ bfb35894  00000001
I/DEBUG﹕ bfb35898  bfb358c8  [stack]
I/DEBUG﹕ bfb3589c  b600c05c  /system/lib/libdvm.so (dvmPlatformInvoke+80)
I/DEBUG﹕ #02  bfb358a0  b8e8f540  [heap]
I/DEBUG﹕ ........  ........
I/DEBUG﹕ memory map around fault addr 00006147:
I/DEBUG﹕ (no map below)
I/DEBUG﹕ (no map for address)
I/DEBUG﹕ 96e9e000-97223000 rw- /dev/ashmem/gralloc-buffer (deleted)
{% endhighlight %}

Logcat 에서 확인 할 사항은 JNI Module 명과 관련된 11, 12번째 줄에 내용입니다.

JNI 디버그 옵션으로 생성된 `so 파일`과 `arm-linux-androideabi-addr2line` 를 이용해서 결과를 확인합니다.

arm-linux-androideabi-addr2line 를 사용하는 옵션은 아래와 같습니다.

`arm-linux-androideabi-addr2line.exe [option(s)] [addr(s)]`

관련 추천 옵션은 아래를 추천합니다.

- C --demangle[=style]  Demangle function names
- e : 타겟 .so 설정
- f : 함수 출력

{% highlight console %}
// 11줄, 00000861  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so (Crash()+22)
arm-linux-androideabi-addr2line -C -fe x86\libtest_google_breakpad.so 00000861
Crash()
D:\GitHub\BreakpadJavaCall\app\src\main/jni/test_breakpad.cpp:43

// 12줄, 00000915  /data/app-lib/com.pluusystem.breakpadjavacall-2/libtest_google_breakpad.so
arm-linux-androideabi-addr2line -C -fe x86\libtest_google_breakpad.so 00000915
Java_com_pluusystem_breakpadjavacall_MainActivity_crashService
D:\GitHub\BreakpadJavaCall\app\src\main/jni/test_breakpad.cpp:64
{% endhighlight %}

실제로 Crash 가 발생한 Stack 을 체크할수 있습니다.

###Google Breakpad Dump 체크

- - -

사전 작업 : 51번째 줄을 true 처리하여 Google Breakpad 처리하도록 수정

Crash로 생성된 dump 파일 (예, 53cf87db-0429-1cbf-3cd576a2-2b42c50d.dmp) 을 `minidump_stackwalk` 를 이용해서 Dump 파일에서부터 Stack 정보를 취득합니다.

`minidump_stackwalk <minidumo-file> [symbol-path ...]`

{% highlight console %}
minidump_stackwalk 53cf87db-0429-1cbf-3cd576a2-2b42c50d.dmp > 53cf87db-0429-1cbf-3cd576a2-2b42c50d.dmp.txt
{% endhighlight %}

해당 파일을 내용을 간략하게 표시하면 아래와 같습니다.

{% highlight console linenos %}
Operating system: Android
                  0.0.0 Linux 3.4.67-qemu+ #13 SMP PREEMPT Thu Mar 19 15:12:39 CET 2015 i686
CPU: x86
     GenuineIntel family 6 model 60 stepping 3
     1 CPU

Crash reason:  SIGFPE
Crash address: 0x97ece827
Process uptime: not available

Thread 0 (crashed)
 0  libtest_google_breakpad.so + 0x1a827
    eip = 0x97ece827   esp = 0xbfb35868   ebp = 0xbfb35878   ebx = 0x97f01f0c
    esi = 0x9ec38d9c   edi = 0xbfb358ac   eax = 0x0000000a   ecx = 0x00000000
    edx = 0x00000000   efl = 0x00210246
    Found by: given as instruction pointer in context
 1  libtest_google_breakpad.so + 0x1a9e1
    eip = 0x97ece9e1   esp = 0xbfb35880   ebp = 0xbfb35898
    Found by: previous frame's frame pointer
 2  libdvm.so + 0x2a05c
    eip = 0xb600c05c   esp = 0xbfb358a0   ebp = 0xbfb358c8
    Found by: previous frame's frame pointer
 3  libdvm.so + 0x85b33
    eip = 0xb6067b33   esp = 0xbfb358d0   ebp = 0x9df30af0
    Found by: previous frame's frame pointer
 4  data@app@com.pluusystem.breakpadjavacall-1.apk@classes.dex + 0x124f1c
    eip = 0x9804df1c   esp = 0xbfb358e8   ebp = 0x9df30af0
    Found by: stack scanning
 5  libtest_google_breakpad.so + 0x1a9a9
    eip = 0x97ece9a9   esp = 0xbfb358ec   ebp = 0x9df30af0
    Found by: stack scanning
 6  data@app@com.pluusystem.breakpadjavacall-1.apk@classes.dex + 0x119a50
    eip = 0x98042a50   esp = 0xbfb358f4   ebp = 0x9df30af0
    Found by: stack scanning

...생략...
{% endhighlight %}

관련 .so 파일에 해당하는 라인을 검색해서 해당내용을 추적할 수 있습니다.

추적방법은 위의 Logcat 에 적혀있는 방법과 동일합니다.

{% highlight console %}
// 12줄, libtest_google_breakpad.so + 0x1a827
arm-linux-androideabi-addr2line -C -fe x86\libtest_google_breakpad.so 0x1a827
Crash()
D:\GitHub\BreakpadJavaCall\app\src\main/jni/test_breakpad.cpp:43

// 17줄, libtest_google_breakpad.so + 0x1a9e1
arm-linux-androideabi-addr2line -C -fe x86\libtest_google_breakpad.so 0x1a9e1
Java_com_pluusystem_breakpadjavacall_MainActivity_crashService
D:\GitHub\BreakpadJavaCall\app\src\main/jni/test_breakpad.cpp:65

// 29줄, libtest_google_breakpad.so + 0x1a9a9
local>arm-linux-androideabi-addr2line -C -fe x86\libtest_google_breakpad.so 0x1a9a9
Java_com_pluusystem_breakpadjavacall_MainActivity_crashService
D:\GitHub\BreakpadJavaCall\app\src\main/jni/test_breakpad.cpp:61
{% endhighlight %}

###P.S.

Google Breakpad 를 이용해서 덤프를 취득하여 디버그해본 결과, 기존 breakpad 의 샘플로는 올바른 덤프 취득을 할 수 없었습니다.

그래도, 테스트 도중 JNI 레벨에서 Crash 가 일어난 경우에 대해서 Stack 추적에 도움이 될듯합니다.

좀 더 정확한 디버그를 아시는분은 알려주시면 추가 포스팅을 하겠습니다.

###etc

- - -

- [Google Breakpad](https://code.google.com/p/google-breakpad/)
- [Google Breakpad Wiki](https://code.google.com/p/google-breakpad/wiki/GettingStartedWithBreakpad)
