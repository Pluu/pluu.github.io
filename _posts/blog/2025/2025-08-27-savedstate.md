---
layout: post
title: "AndroidX의 savedstate 내부 코드 분석"
date: 2025-08-27 22:00:00 +09:00
tag: [Android, AndroidX]
categories:
- blog
- Android
---

[SavedState](https://developer.android.com/reference/androidx/savedstate/SavedState)는 프로세스가 종료될 때 UI 상태를 저장하고 프로세스가 다시 시작될 때 해당 상태를 복원하는 작업을 합니다. 

이는 OS가 프로세스가 애플리케이션의 상태를 유지할 기회를 제공하며, 나중에 애플리케이션이 상태를 복원할 수 있도록 허용한다는 의미입니다. 이는 일반적으로 `상태 복원`이라고 부릅니다.

<!--more-->

------

본 내용은 아래 버전을 기반으로 작성되었습니다

- androidx.savedstate 1.4.0-alpha02 : [링크](https://developer.android.com/jetpack/androidx/releases/savedstate?hl=en#1.4.0-alpha02)

------

# 1. SavedState의 주요 정의

먼저 SavedState에 주요 인터페이스 및 클래스를 살펴보겠습니다.

- SavedState
- SavedStateRegistryOwner
- SavedStateRegistry
- SavedStateRegistryController

## 1) SavedState

[SavedState](https://developer.android.com/reference/kotlin/androidx/savedstate/SavedState)는 공통 타입으로, 시스템이 시작한 프로세스 종료 개념을 가진 네이티브 플랫폼에서 저장 및 복원될 수 있는 저장 가능한 값을 보관합니다. KMP 지원하는 클래스로써 각 플랫폼에 독립적으로 설계되어 다양한 환경에서 상태 저장 및 복원을 원활하게 지원합니다.

```kotlin
public expect class SavedState
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/SavedState.kt;l=26-39)

Android 환경에서 SavedState 클래스의 실체는 Bundle입니다.

```kotlin
public actual typealias SavedState = android.os.Bundle
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/androidMain/kotlin/androidx/savedstate/SavedState.android.kt;l=25)

## 2) SavedStateRegistryOwner

savedstate 기능의 시작은 [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner) 인터페이스입니다. SavedStateRegistryOwner는 SavedStateRegistry를 소유하는 범위를 가리키며, 이 소유자는 SavedStateRegistryController의 [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry)를 통해 접근하고 작업합니다.

```kotlin
public interface SavedStateRegistryOwner : androidx.lifecycle.LifecycleOwner {
   // SavedStateRegistryOwner가 소유한 SavedStateRegistry를 반환
   public val savedStateRegistry: SavedStateRegistry
}
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/SavedStateRegistryOwner.kt?q=file:androidx%2Fsavedstate%2FSavedStateRegistryOwner.kt%20class:androidx.savedstate.SavedStateRegistryOwner)

SavedStateRegistryOwner 인터페이스는 Android의 주요 컴포넌트인 ComponentActivity, ComponentDialog, Fragment, NavBackStackEntry가 구현하고 있습니다. 즉, 일반적인 개발 시에 사용하는 대부분의 화면에서 사용 가능하다는 이야기입니다.

```
androidx.activity.ComponentActivity ← SavedStateRegistryOwner 구현
  ↳ androidx.fragment.app.FragmentActivity
    ↳ androidx.appcompat.app.AppCompatActivity
 
androidx.activity.ComponentDialog ← SavedStateRegistryOwner 구현
  ↳ androidx.appcompat.app.AppCompatDialog
    ↳ androidx.appcompat.app.AlertDialog
    ↳ com.google.android.material.bottomsheet.BottomSheetDialog
  
androidx.fragment.app.Fragment ← SavedStateRegistryOwner 구현
  ↳ androidx.fragment.app.DialogFragment
    ↳ androidx.appcompat.app.AppCompatDialogFragment
      ↳	com.google.android.material.bottomsheet.BottomSheetDialogFragment
```

ComponentActivity의 내부 코드를 보면 아래와 같습니다.

```kotlin
open class ComponentActivity() :
   androidx.core.app.ComponentActivity(),
   SavedStateRegistryOwner
   ... {
     
   final override val savedStateRegistry: SavedStateRegistry

}
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:activity/activity/src/main/java/androidx/activity/ComponentActivity.kt;l=111?q=file:androidx%2Factivity%2FComponentActivity.kt%20class:androidx.activity.ComponentActivity)

## 3) SavedStateRegistry

SavedStateRegistry는 저장된 상태를 소비하고 기여하는 컴포넌트를 연결하기 위한 인터페이스입니다. 이 객체의 수명은 소유하는 컴포넌트의 생명주기에 따라 결정됩니다. 즉, Activity나 Fragment가 재생성될 때 해당 객체의 새 인스턴스도 함께 생성됩니다.

```kotlin
public expect class SavedStateRegistry internal constructor(impl: SavedStateRegistryImpl) {

   // SavedState에 기여하는 컴포넌트를 표시
   public fun interface SavedStateProvider {
      // 컴포넌트가 종료되기 전에 해당 컴포넌트에서 상태를 가져오도록 요청
      // 이후 consumeRestoredStateForKey를 통해 해당 상태를 수신할 수 있도록 하기 위함
      public fun saveState(): SavedState
   }

   // 상태가 생성 후 복원되었고 consumerRestoredStateForKey로 안전하게 사용할 수 있는지 여부
   public val isRestored: Boolean

   // registerSavedStateProvider를 통해 지정된 키로 
   // 등록된 SavedStateProvider에서 이전에 제공한 저장된 상태를 사용
   @MainThread public fun consumeRestoredStateForKey(key: String): SavedState?

   // 주어진 키로 SavedStateProvider를 등록
   @MainThread public fun registerSavedStateProvider(key: String, provider: SavedStateProvider)

   // 이전에 등록된 SavedStateProvider를 반환
   public fun getSavedStateProvider(key: String): SavedStateProvider?

   // 주어진 키로 이전에 등록된 컴포넌트를 등록 해제
   @MainThread public fun unregisterSavedStateProvider(key: String)
}

```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/SavedStateRegistry.kt?q=file:androidx%2Fsavedstate%2FSavedStateRegistry.%20class:androidx.savedstate.SavedStateRegistry)

## 4) SavedStateRegistryController

SavedStateRegistryController는 [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner) 구현체가 [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry)를 제어하기 위한 API입니다. [SavedStateRegistry](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry)의 상태를 복원하기 위해 [performRestore](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performRestore(androidx.savedstate.SavedState))를 호출하고, SavedState를 저장하기 위해 [performSave](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryController#performSave(androidx.savedstate.SavedState))를 호출합니다.

```kotlin
public actual class SavedStateRegistryController
private actual constructor(private val impl: SavedStateRegistryImpl) {

   // 컨트롤러가 소유한 SavedStateRegistry
   public actual val savedStateRegistry: SavedStateRegistry = SavedStateRegistry(impl)

   // SavedStateRegistry를 구성하는 데 필요한 초기의 일회성 attach 작업을 수행
   @MainThread
   public actual fun performAttach() {
      impl.performAttach()
   }

   // SavedStateRegistry의 소유자가 저장된 상태를 복원하기 위한 인터페이스
   @MainThread
   public actual fun performRestore(savedState: SavedState?) {
      impl.performRestore(savedState)
   }

   // SavedStateRegistry의 소유자가 상태 저장을 수행하기 위한 인터페이스
   // 등록된 모든 제공자를 호출하고 소비되지 않은 상태와 병합
   @MainThread
   public actual fun performSave(outBundle: SavedState) {
      impl.performSave(outBundle)
   }

   public actual companion object {

      @JvmStatic
      public actual fun create(owner: SavedStateRegistryOwner): SavedStateRegistryController {
         val impl =
            SavedStateRegistryImpl(
               owner = owner,
               onAttach = { owner.lifecycle.addObserver(Recreator(owner)) },
            )
         return SavedStateRegistryController(impl)
      }
   }
}
```

# 2. ComponentActivity 분석

지금까지 `SavedState`에 관련된 주요 인터페이스/클래스를 살펴봤습니다. 이후로는 해당 클래스가 사용되는 주요 클래스에 대해서 다루겠습니다. 대표적으로 androidx activity의 [ComponentActivity](https://developer.android.com/reference/androidx/activity/ComponentActivity)에서의 확인할 수 있습니다.

## 1) ComponentActivity 내부 코드

ComponentActivity 클래스는 SavedStateRegistryOwner 인터페이스를 구현하고 있습니다. 인터페이스에서 필요로 하는 savedStateRegistry 프로퍼티는 SavedStateRegistryController 객체를 통해서 얻습니다.

```kotlin
open class ComponentActivity() :
   androidx.core.app.ComponentActivity(),
   SavedStateRegistryOwner
   ... {
   
   private val savedStateRegistryController: SavedStateRegistryController =
      SavedStateRegistryController.create(this)

   ...
     
   init {
      ...
      savedStateRegistry.registerSavedStateProvider(ACTIVITY_RESULT_TAG) {
         // ComponentActivity#onSaveInstanceState에서 
         // SavedStateRegistryController을 통해서 호출됨
         val outState = Bundle()
         activityResultRegistry.onSaveInstanceState(outState)
         outState
      }
      addOnContextAvailableListener {
         // Context 활성화시 SavedStateRegistryController의 SavedStateRegistry로부터 savedInstanceState를 취득
         val savedInstanceState =
            savedStateRegistry.consumeRestoredStateForKey(ACTIVITY_RESULT_TAG)
         if (savedInstanceState != null) {
            activityResultRegistry.onRestoreInstanceState(savedInstanceState)
         }
      }
   }
     
   override fun onCreate(savedInstanceState: Bundle?) {
      // SavedStateRegistryController에 savedInstanceState Bundle 보관
      savedStateRegistryController.performRestore(savedInstanceState)
      ...
      super.onCreate(savedInstanceState)
      ...
   }
     
   @CallSuper
   override fun onSaveInstanceState(outState: Bundle) {
      ...
      super.onSaveInstanceState(outState)
      // SavedStateRegistryController를 통해 Bundle
      savedStateRegistryController.performSave(outState)
   }     
   ...
   
   // SavedStateRegistryOwner 인터페이스의 구현은
   // SavedStateRegistryController의 savedStateRegistry를 통해서 반환
   final override val savedStateRegistry: SavedStateRegistry
      get() = savedStateRegistryController.savedStateRegistry
   
   ...
     
   private companion object {
      private const val ACTIVITY_RESULT_TAG = "android:support:activity-result"
   }
}
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:activity/activity/src/main/java/androidx/activity/ComponentActivity.kt)

## 2) ComponentActivity 내부 흐름 (Sequence Diagram)

ComponentActivity 내부 코드에서 살펴본 SavedState의 흐름을 시퀀스 다이어그램으로 살펴보면 아래와 같습니다.

{% include img_assets.html id="/blog/2025/0827-savedstate/chat.svg" %}

# 3. KotlinX Serialization 지원

최근 androidx에는 Kotlin Multiplatform(KMP) 지원이 되고 있습니다. 그에 맞춰 [savedstate 1.3.0](https://developer.android.com/jetpack/androidx/releases/savedstate?hl=en#1.3.0) 버전부터 [KotlinX Serialization](https://github.com/Kotlin/kotlinx.serialization) 지원이 추가되었습니다. 기본적으로 [saved](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner#(androidx.savedstate.SavedStateRegistryOwner).saved(kotlin.String,androidx.savedstate.serialization.SavedStateConfiguration,kotlin.Function0))라는 property delegate를 사용합니다. 

아래 샘플 코드를 봤을 때 이전보다 쉽게 프로세스 종료/재시작 시에도 데이터를 저장/복원해 주며, 기본값 제공도 가능합니다.

```kotlin
@Serializable
data class Person(val firstName: String, val lastName: String)

class MyActivity : ComponentActivity() {
   var person by saved { Person("John", "Doe") }

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      this.person = Person("Jane", "Doe")
   }
}
```

> [소스 출처](https://developer.android.com/jetpack/androidx/releases/savedstate?hl=en#1.3.0)

## 1) saved property delegate

[saved](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner#(androidx.savedstate.SavedStateRegistryOwner).saved(kotlin.String,androidx.savedstate.serialization.SavedStateConfiguration,kotlin.Function0))는 [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner)의 확장 함수로 제공합니다. `@Serializable`를 사용한 클래스를 [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner)에 저장하고 프로세스 종료 및 재시작 시 자동으로 복원하도록 설계되었습니다. 

앞서 설명한 대로 SavedStateRegistryOwner는 Android 주요 컴포넌트인 ComponentActivity, ComponentDialog, Fragment, NavBackStackEntry가 구현하고 있으므로, 기본적인 UI 구현시에 대부분 사용 가능합니다.

```kotlin
@JvmName("savedNullable")
public inline fun <reified T> SavedStateRegistryOwner.saved(
   key: String? = null,
   configuration: SavedStateConfiguration = SavedStateConfiguration.DEFAULT,
   noinline init: () -> T,
): ReadWriteProperty<Any?, T> {
   return saved(configuration.serializersModule.serializer(), key, configuration, init)
}

@JvmName("savedNullable")
public fun <T> SavedStateRegistryOwner.saved(
   serializer: KSerializer<T>,
   key: String? = null,
   configuration: SavedStateConfiguration = SavedStateConfiguration.DEFAULT,
   init: () -> T,
): ReadWriteProperty<Any?, T> {
   return SavedStateRegistryOwnerDelegate(savedStateRegistry, serializer, key, configuration, init)
}
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/serialization/SavedStateRegistryOwnerDelegate.kt)

## 2) SavedStateRegistryOwnerDelegate

[saved](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner#(androidx.savedstate.SavedStateRegistryOwner).saved(kotlin.String,androidx.savedstate.serialization.SavedStateConfiguration,kotlin.Function0)) property delegate의 실제 동작은 **SavedStateRegistryOwnerDelegate** 클래스가 담당합니다. private 클래스이므로 내부 동작은 AndroidX 소스를 통해서 확인할 수 있습니다.

### 생성자

먼저 SavedStateRegistryOwnerDelegate의 생성자를 살펴보겠습니다. 이름대로 property delegate이므로 [ReadWriteProperty](https://kotlinlang.org/api/core/kotlin-stdlib/kotlin.properties/-read-write-property/) 인터페이스를 구현하고 있습니다. ReadWriteProperty는 읽기/쓰기 프로퍼티의 property delegate를 구현하는 데 사용됩니다. 또한, [SavedStateProvider](https://developer.android.com/reference/kotlin/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 인터페이스를 사용해서 상태 저장에 사용됩니다.

그리고, SavedStateRegistryOwnerDelegate는 [KotlinX Serialization](https://github.com/Kotlin/kotlinx.serialization)용으로 만들어졌으므로 직렬화용으로 KSerializer를 전달받습니다. 상태 저장을 위한 **key**와 초기값용인 **init** lambda도 생성자로 전달받습니다.

```kotlin
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistry.SavedStateProvider
import kotlin.properties.ReadWriteProperty
import kotlinx.serialization.KSerializer

/**
 * SavedStateRegistry에 값을 저장하고 복원하는 property delegate
 *
 * @param T 프로퍼티의 타입
 * @param registry SavedStateRegistry를 사용하여 상태를 저장하고 복원
 * @param serializer KSerializer는 직렬화/역직렬화에 사용
 * @param key 값을 저장할 키이며, null인 경우 프로퍼티 이름이 키가 됨
 * @param configuration 직렬화를 위한 Configuration
 * @param init 저장된 상태가 없는 경우 초기값을 제공하는 함수
 */
private class SavedStateRegistryOwnerDelegate<T>(
   private val registry: SavedStateRegistry,
   private val serializer: KSerializer<T>,
   private val key: String?,
   private val configuration: SavedStateConfiguration,
   private val init: () -> T,
) : ReadWriteProperty<Any?, T>, SavedStateProvider {
   ...
}
```

### 상태 저장시 사용할 Key 정의

생성자로 key가 전달되지만, 기본 nullable입니다. 이때 안전한 상태 저장에 내부적으로 키를 별도로 재정의하고 있습니다.

- key가 존재 : key
- key가 null : 프로퍼티가 사용되는 클래스의 고유 이름 (`thisRef::class.canonicalName`)와 프로퍼티 이름 (`property.name`)의 조합

```kotlin
import androidx.savedstate.SavedStateRegistry.SavedStateProvider
import androidx.savedstate.internal.canonicalName
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty

private class SavedStateRegistryOwnerDelegate<T>(
   ...,
   private val key: String?,
) : ReadWriteProperty<Any?, T>, SavedStateProvider {
   ...

   /**
    * SavedStateRegistryOwner에서 충돌을 방지하기 위해 해당 프로퍼티에 대한 고유한 키를 생성
    */
   private fun getQualifiedKey(thisRef: Any?, property: KProperty<*>): String {
      if (key != null) return key

      val classNamePrefix = if (thisRef != null) thisRef::class.canonicalName + "." else ""
      return classNamePrefix + property.name
   }
}
```

### ReadWriteProperty 인터페이스 구현

ReadWriteProperty 인터페이스로 getValue/setValue 함수를 구현하게 되는데, 값을 보관하는 내부 프로퍼티 **cachedValue**에 값을 업데이트합니다. 그리고, 상태 저장을 위해서 getValue/setValue 함수 접근 시 cachedValue가 초기값(=**UNINITIALIZED**)인 상태라면 SavedStateRegistry에 전달된 키로 등록합니다. 이후 상태 복원시에 사용됩니다.

`SavedStateRegistry#consumeRestoredStateForKey`의 응답값으로 복원([SavedState](https://developer.android.com/reference/androidx/savedstate/SavedStateKt))할 상태 값이 있다면 [decodeFromSavedState](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/serialization/SavedStateDecoder.kt)를 통해 복원 처리하며, 없는 경우 생성자로 받은 **init** 함수 값을 반환합니다.

```kotlin
import androidx.savedstate.SavedState
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistry.SavedStateProvider
import androidx.savedstate.internal.canonicalName
import androidx.savedstate.savedState
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty
import kotlinx.serialization.KSerializer

private class SavedStateRegistryOwnerDelegate<T>(
   private val registry: SavedStateRegistry,
   private val serializer: KSerializer<T>,
   ...,
   private val configuration: SavedStateConfiguration,
   private val init: () -> T,
) : ReadWriteProperty<Any?, T>, SavedStateProvider {

   /**
    * 캐시 된 값이 아직 초기화되지 않았음을 나타내는 감시 객체.
    * 이 객체는 초기화되지 않은 값과 캐시 된 `null` 값을 구분.
    */
   private object UNINITIALIZED

   private var cachedValue: Any? = UNINITIALIZED

   override fun getValue(thisRef: Any?, property: KProperty<*>): T {
      // 첫 번째 읽기 시, 이 객체를 SavedStateProvider로 등록하고 초기 값을 로드
      if (cachedValue == UNINITIALIZED) {
         val qualifiedKey = getQualifiedKey(thisRef, property)
         registry.registerSavedStateProvider(qualifiedKey, provider = this)
         cachedValue = loadInitialValue(qualifiedKey)
      }
      @Suppress("UNCHECKED_CAST")
      return cachedValue as T
   }

   override fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
      // 첫 번째 쓰기 시, 이미 등록되지 않았다면 이 객체를 SavedStateProvider로 등록
      // 초기 값을 로드하지 않아 새 값이 즉시 덮어쓰지 않도록 함
      if (cachedValue == UNINITIALIZED) {
         val qualifiedKey = getQualifiedKey(thisRef, property)
         registry.registerSavedStateProvider(qualifiedKey, provider = this)
      }
      cachedValue = value
   }
  
  
   /**
    * 저장된 상태에서 값을 로드하거나 초기 값을 제공
    *
    * qualifiedKey에 해당하는 상태가 발견되지 않으면 init 람다를 실행
    * saveState에 의해 작성된 특수 마커를 확인하여 `null` 값을 올바르게 복원
    */
   private fun loadInitialValue(qualifiedKey: String): T? {
      val restored = registry.consumeRestoredStateForKey(qualifiedKey) ?: return init()

      @Suppress("UNCHECKED_CAST")
      return decodeFromSavedState(
         deserializer = serializer as KSerializer<T & Any>,
         savedState = restored,
         configuration = configuration,
      )
   }

   ...
}
```

### SavedStateProvider 인터페이스 구현

마지막으로 SavedStateRegistry의 [SavedStateProvider](https://developer.android.com/reference/kotlin/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 인터페이스를 구현할 차례입니다. 상태 저장을 위한 `saveState` 함수가 호출되며, 리턴값으로 [SavedState](https://developer.android.com/reference/kotlin/androidx/savedstate/SavedState) 타입입니다. 앞서 언급한 대로 Android에서 SavedState는 Bundle 클래스입니다.

상태 저장 시에는 아래와 같은 순서로 진행됩니다.

1. 캐시 된 값(cachedValue)이 초기 상태인가?
2. 로드된 값 혹은 업데이트된 값이 존재하면 [encodeToSavedState](https://developer.android.com/reference/androidx/savedstate/serialization/SavedStateEncoderKt) 함수를 호출하여 KSerializer를 사용하여 SavedState로 직렬화합니다.

```kotlin
import androidx.savedstate.SavedState
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistry.SavedStateProvider
import androidx.savedstate.internal.canonicalName
import androidx.savedstate.savedState
import kotlin.properties.ReadWriteProperty

private class SavedStateRegistryOwnerDelegate<T>(
   ...,
   private val serializer: KSerializer<T>,
   private val configuration: SavedStateConfiguration,
) : ReadWriteProperty<Any?, T>, SavedStateProvider {
  
   private var cachedValue: Any? = UNINITIALIZED
   ...
   override fun saveState(): SavedState {
      // 값이 한 번도 접근되지 않았다면 아무것도 저장하지 않도록 함
      if (cachedValue == UNINITIALIZED) return savedState()

      // `putNull`을 사용하면 저장된 `null`과 결코 저장되지 않은 상태를 구분 가능
      @Suppress("UNCHECKED_CAST") val typedValue = cachedValue as T

      return encodeToSavedState(serializer, typedValue, configuration)
   }
   ...
}
```

### SavedStateRegistryOwnerDelegate의 전체 코드

```kotlin
import androidx.savedstate.SavedState
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistry.SavedStateProvider
import androidx.savedstate.internal.canonicalName
import androidx.savedstate.savedState
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty
import kotlinx.serialization.KSerializer

/**
 * SavedStateRegistry에 값을 저장하고 복원하는 property delegate
 *
 * @param T 프로퍼티의 타입
 * @param registry SavedStateRegistry를 사용하여 상태를 저장하고 복원
 * @param serializer KSerializer는 직렬화/역직렬화에 사용
 * @param key 값을 저장할 키이며, null인 경우 프로퍼티 이름이 키가 됨
 * @param configuration 직렬화를 위한 Configuration
 * @param init 저장된 상태가 없는 경우 초기값을 제공하는 함수
 */
private class SavedStateRegistryOwnerDelegate<T>(
   private val registry: SavedStateRegistry,
   private val serializer: KSerializer<T>,
   private val key: String?,
   private val configuration: SavedStateConfiguration,
   private val init: () -> T,
) : ReadWriteProperty<Any?, T>, SavedStateProvider {

   /**
    * 캐시 된 값이 아직 초기화되지 않았음을 나타내는 감시 객체.
    * 이 객체는 초기화되지 않은 값과 캐시 된 `null` 값을 구분.
    */
   private object UNINITIALIZED

   private var cachedValue: Any? = UNINITIALIZED

   override fun getValue(thisRef: Any?, property: KProperty<*>): T {
      // 첫 번째 읽기 시, 이 객체를 SavedStateProvider로 등록하고 초기 값을 로드
      if (cachedValue == UNINITIALIZED) {
         val qualifiedKey = getQualifiedKey(thisRef, property)
         registry.registerSavedStateProvider(qualifiedKey, provider = this)
         cachedValue = loadInitialValue(qualifiedKey)
      }
      @Suppress("UNCHECKED_CAST")
      return cachedValue as T
   }

   override fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
      // 첫 번째 쓰기 시, 이미 등록되지 않았다면 이 객체를 SavedStateProvider로 등록
      // 초기 값을 로드하지 않아 새 값이 즉시 덮어쓰지 않도록 함
      if (cachedValue == UNINITIALIZED) {
         val qualifiedKey = getQualifiedKey(thisRef, property)
         registry.registerSavedStateProvider(qualifiedKey, provider = this)
      }
      cachedValue = value
   }

   /**
    * 현재 값을 저장
    *
    * 값에 한 번도 접근하지 않았다면 빈 상태(savedState)를 반환합
    * 값이 `null`인 경우, 저장된 `null`과 한 번도 저장되지 않은 상태를 구분하기 위해 특수 마커를 저장
    * 그렇지 않은 경우 현재 값을 직렬화
    */
   override fun saveState(): SavedState {
      // 값이 한 번도 접근되지 않았다면 아무것도 저장하지 않도록 함
      if (cachedValue == UNINITIALIZED) return savedState()

      // `putNull`을 사용하면 저장된 `null`과 결코 저장되지 않은 상태를 구분 가능
      @Suppress("UNCHECKED_CAST") val typedValue = cachedValue as T

      return encodeToSavedState(serializer, typedValue, configuration)
   }

   /**
    * 저장된 상태에서 값을 로드하거나 초기 값을 제공
    *
    * qualifiedKey에 해당하는 상태가 발견되지 않으면 init 람다를 실행
    * saveState에 의해 작성된 특수 마커를 확인하여 `null` 값을 올바르게 복원
    */
   private fun loadInitialValue(qualifiedKey: String): T? {
      val restored = registry.consumeRestoredStateForKey(qualifiedKey) ?: return init()

      @Suppress("UNCHECKED_CAST")
      return decodeFromSavedState(
         deserializer = serializer as KSerializer<T & Any>,
         savedState = restored,
         configuration = configuration,
      )
   }

   /**
    * SavedStateRegistryOwner에서 충돌을 방지하기 위해 해당 프로퍼티에 대한 고유한 키를 생성
    */
   private fun getQualifiedKey(thisRef: Any?, property: KProperty<*>): String {
      if (key != null) return key

      val classNamePrefix = if (thisRef != null) thisRef::class.canonicalName + "." else ""
      return classNamePrefix + property.name
   }
}
```

> [소스 출처](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:savedstate/savedstate/src/commonMain/kotlin/androidx/savedstate/serialization/SavedStateRegistryOwnerDelegate.kt)
