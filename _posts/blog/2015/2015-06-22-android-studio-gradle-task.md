---
layout: post
title: "Android Studio - Gradle Task 정리"
date: 2015-06-22 23:50:00
tag: [Android, Gradle, Task]
categories:
- blog
- Android
- Gradle
---

<!--more-->

Android Studio 에서 자주 사용하는 Gradle Task 정리

### NDK Build

- - -

- ndk.debug = true or false


```groovy
import org.apache.tools.ant.taskdefs.condition.Os

// NDK Build
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
    def isDebug = properties.getProperty('ndk.debug').toBoolean()
    if (isDebug) {
        commandLine command, 'NDK_DEBUG=1', '-C', file('src/main').absolutePath
    } else {
        commandLine command, '-C', file('src/main').absolutePath
    }
}

tasks.withType(JavaCompile) {
    compileTask -> compileTask.dependsOn ndkBuild
}

```

### NDK Result File (.a) Copy

- - -


```groovy
// NDK 결과물 App Module 쪽 JNI 폴더로 복사
task ndkResultCopy(type: Copy, dependsOn: 'ndkBuild') {
    from('src/main/obj/local') {
        include '**/*.a'
        exclude '**/objs-debug'
    }

    into('../app/src/main/jni')
}
```

### Make JAR

- - -

- ARTIFACT_ID = ARTIFACT_NAME
- VERSION_NAME = 1_0


```groovy
task clearJar(type: Delete) {
    delete 'build/libs/' + ARTIFACT_ID + '_' + VERSION_NAME + '.jar'
}

task makeJar(type: Copy) {
    from('build/intermediates/bundles/release/')
    into('build/libs/')
    include('classes.jar')
    rename ('classes.jar', ARTIFACT_ID + '_' + VERSION_NAME + '.jar')
}

makeJar.dependsOn(clearJar, build)
```
