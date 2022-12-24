---
layout: post
title: "[메모] gradle에 중복 repositories 정의 선언 정리"
date: 2022-12-24 21:45:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

## repositories 중복 선언도 보일러 플레이트 코드?!

안드로이드 프로젝트에서 개발에 필요한 플러그인/라이브러리를 다운로드할 원격 저장소를 repositories에 정의합니다.

- root의 settings.gradle : pluginManagement/dependencyResolutionManagement
- root의 build.gradle : buildscript/allprojects/subprojects

```groovy
// New Project시에 생성되는 settings.gradle.kts 모습
pluginManagement {
  repositories {
    google()
    mavenCentral()
    gradlePluginPortal()
  }
}
dependencyResolutionManagement {
  repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
  repositories {
    google()
    mavenCentral()
  }
}
```

includeGroup/excludeGroup 등을 추가로 정의하면 repositories의 코드가 길어집니다.

게다가 최근에는 buildSrc/build-logic 등에서 추가로 settings.gradle을 정의하는 케이스도 생겨나서, 더욱 관리할 코드가 늘어나게 됩니다.

## 수정 방법 : repositories 내의 내용을 별도 파일에 선언

### 적용 1. Kotlin DSL

```kotlin
// repositories.gradle.kts
val configureSharedRepositories : RepositoryHandler.() -> Unit = {
  google {
    content {
      // includeGroup/excludeGroup 관련 선언
    }
  }
  mavenCentral()
}

extra["configureSharedRepositories"] = configureSharedRepositories
```

```kotlin
// 별도 정의한 repositories.gradle.kts를 적용한 settings.gradle.kts
pluginManagement {
  ...
  apply("repositories.gradle.kts")
  repositories {
    gradlePluginPortal()
    val configureSharedRepositories = extra["configureSharedRepositories"] as RepositoryHandler.() -> Unit
    configureSharedRepositories(this)
  }
}

dependencyResolutionManagement {
  ...
  apply("repositories.gradle.kts")
  val configureSharedRepositories = extra["configureSharedRepositories"] as RepositoryHandler.() -> Unit
  configureSharedRepositories(repositories)
}
```

- repositories.gradle를 groovy로 작성했다면, 호출하는 곳에서는 `org.codehaus.groovy.runtime.MethodClosure`로 타입을 변환하면 됩니다.

### 적용 2. Groovy DSL

```groovy
// repositories.gradle
def configureSharedRepositories(RepositoryHandler handler) {
  handler.google {
    content {
      // includeGroup/excludeGroup 관련 선언
    }
  }
  handler.mavenCentral()
}

ext.configureSharedRepositories = this.&configureSharedRepositories
```

```groovy
// 별도 정의한 repositories.gradle를 적용한 settings.gradle
pluginManagement {
  ...
  apply from: "repositories.gradle"
  repositories {
    gradlePluginPortal()
    settings.ext.configureSharedRepositories(it)
  }
}

dependencyResolutionManagement {
  ...
  apply from: "repositories.gradle"
  settings.ext.configureSharedRepositories(repositories)
}
```

Nexus 사용 및 includeGroup/excludeGroup과 같은 선언이 있다면, 정의가 여러 곳에 정의하면 관리 이슈 및 복잡해지므로 나누는 것을 권장합니다.

### 참고

- AndroidX buidSrc/repos.gradle : https://github.com/androidx/androidx/blob/androidx-main/buildSrc/repos.gradle
- https://github.com/ganadist/VersionCodeDemo/blob/main/settings.gradle
