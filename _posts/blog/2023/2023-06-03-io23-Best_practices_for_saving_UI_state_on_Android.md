---
layout: post
title: "[요약] Best practices for saving UI state on Android (Google I/O '23)"
date: 2023-06-03 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io23
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/V-s4z7B_Gnc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
<!--more-->

- - -

## Section 01 Losing app state

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/001.png" %}

앱에서 UI 상태를 어떻게 잃을 수 있습니까?

1. Configuration 변경 시 (기기 회전, 크기 조정, Multi window 모드 전환, Light/Dark 모드 전환 등)
   1. 기본적으로 Activity가 Recreate 되고, 새로운 Configuration으로 초기화합니다.
   2. Manifest 파일에서 일부 Activity Recreate를 막을 수 있지만 완전히 배제하는 것은 불가능합니다.

> Handle configuration changes : https://goo.gle/configuration-changes
>

2. 시스템에서 리소스가 필요한데 앱이 백그라운드에 존재하는 경우
   1. 시스템의 리소스가 부족하면 메모리 확보를 위해서 백그라운드에 존재하는 앱을 Destory 시킵니다.
3. 사용자 또는 시스템이 앱을 갑자기 Destroy할 경우
   1. 최근 앱 목록에서 앱을 제거하여 강제 종료할 수 있습니다.
   2. 앱이 백그라운드에서 업데이트될 수도 있습니다.

## Section 02 Best practices for saving UI state

### Configuration Changes

Activity Recreate를 완전히 피하는 것은 불가능합니다. Configuration 변경에도 데이터가 유지되도록 하려면 ViewModel API를 사용해야 합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/002.png" %}

- Configuration 변경 시 ViewModel 인스턴스가 메모리에 캐시 됩니다
- Navigation 라이브러리는 Destination이 BackStack에 보관되어 있을 때 ViewModel을 캐시 합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/003.png" %}

ViewModel의 목적은 2가지가 있습니다.

- 데이터가 Configuration 변경 후에도 유지
- UI에 데이터를 노출하는 화면 Level의 State Holder로 ViewModel을 사용 (Optional)

ViewModel API는 Activity, Fragment, Navigation destination 범위에서 Configuration 변경 후에도 데이터를 유지할 수 있는 유일한 방법입니다.

### 예상치 못한 앱 종료 (Unexpected app dismissal)

예상치 못한 앱 종료 후에도 데이터가 살아남으려면 메모리 대신 디스크에 정보를 저장해야 합니다. 네트워크를 통해 자체 데이터 서버에 저장하는 것도 방법 중 하나입니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/004.png" %}

로컬 디바이스에 데이터를 저장하는 방법으로 Jetpack의 DataStore와 Room이 있습니다.

- DataStore : 작거나 간단한 데이터
- Room : 구조화된 데이터, 부분 업데이트, 참조 무결성이 필요하거나 큰 데이터

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/005.png" %}

- Configuration 변경 및 리소스에 의한 상황에서도 유지
- 데이터를 디스크에 저장하므로 디스크 공간의 제한을 받음
- I/O 작업이므로 읽기/쓰기 속도가 느림. UI 상태를 저장하는 용도로는 적합하지 않음

### System needs resources

이 경우는 시스템에 의해 프로세스가 중단될 수 있습니다. 앱으로 다시 돌아갈 때 프로세스를 다시 생성합니다. 디스크에 저장하는 앱 데이터는 문제없지만, UI 상태는 메모리에 있으므로 모든 것을 잃게 됩니다. 

SavedState API를 통해서 필수 데이터를 저장하는 방법을 제공하여 프로세스가 다시 생성되기 전의 상태로 돌아갈 수 있도록 제공할 수 있습니다. SavedState API는 내부적으로 Android Bundle 객체에 의존합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/006.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/007.png" %}

- 시스템은 Configuration 변경과 시스템에 리소스가 필요할 때 모두 Saved State Bundle로 관리
- Bundle은 메모리에 저장되며 직렬화된 사본을 프로세스 외부의 메모리에 보관
- Bundle은 크기 제한이 있으므로 최소한의 데이터만 저장하는 데 사용해야 함
  - 큰 객체를 저장할 경우 Runtime Exception 발생
  - 50KB를 초과하지 않는 것이 좋음
- 직렬화/역직렬화가 필요하므로 읽기/쓰기 시간이 느릴 수 있음
- 큰 객체나 List를 저장하는 것을 추천하지 않음
- 안전한 상태로 저장되어야 하는 데이터를 목적으로 함
  - List의 스크롤 위치
  - 특정 항목의 ID
  - Text Field의 입력

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/008.png" %}

상태를 저장하는 API로는

- Jetpack Compose : rememberSaveable API
- 기존 View : onSaveInstanceState

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/009.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/010.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/011.png" %}

View 시스템에서 동일하게 상태를 저장하려면 onSaveInstanceState/onRestoreInstanceState 함수를 사용해야 합니다. 주의할 점은 View에 `isSaveEnabled = true`이여야 하며 View에 ID가 있어야 한다는 것입니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/012.png" %}

Saved State API를 테스트하려면 아래 API를 사용하면 됩니다.

- Jetpack Compose : StateRestorationTester API
- 기존 View : ActivityScenario.recreate()

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/013.png" %}

> Compose에서 상태 복원 테스트 방법과 동작 테스트 샘플

#### 비즈니스 로직 복잡성을 해결하기 위한 SavedStateHandle API

ViewModel을 State Holder로 사용하는 경우에는 `SavedStateHandle` API를 사용해야 합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/014.png" %}

SavedStateHandle가 유효한 경우는 Activity가 Stop될 때 쓰여진 데이터만 저장한다는 것입니다.

> Saved State module for ViewModel : https://goo.gle/architecture-viewmodel-savedstate

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/015.png" %}

## Section 03 Under the hood and advanced use cases

### Case1. 자체 클래스에서 Saved State처리하는 방법

ViewModel은 재사용할 수 있는 UI 요소의 복잡성을 관리하기에는 좋은 솔루션은 아닙니다.

#### Compose에서 처리

> 다음 예는 뉴스에서 재사용할 수 있는 검색 UI 요소가 있고, 검색된 사용자 입력을 Saved State로 처리하고 싶은 경우입니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/016.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/017.png" %}

Compose에서 상태를 Saved State로 대응하는 방법은 rememberSaveable API를 사용방법이 있습니다. Compose API 스펙대로 rememberSaveable을 내부적으로 사용하는 remember 함수로 만들 수 있습니다.

NewsSearchState는 복잡한 객체이므로 Custom Saver를 제공해야 합니다. Saver는 객체를 저장 가능한 상태로 변환하여 저장할 수 있도록 합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/018.png" %}

Saver는 save/restore 두 가지 함수를 제공해야 합니다. TextFieldValue에는 자체 Saver가 있으므로 해당 기능을 위임하고 현재 검색 입력을 저장/복원하면 됩니다. 복원된 검색 입력과 Saver 함수에 전달할 NewsRepository를 전달하여 NewsSearchState의 새 인스턴스를 생성합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/019.png" %}

최종적으로 rememberNewsSearchState에 saver를 호출하여 처리할 수 있습니다.

#### View System에서 처리

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/020.png" %}

NewsSearchState라는 Holder Class는 몇 가지의 제약이 있습니다.

- ViewModel을 상속하지 않으므로 SavedStateHandle 사용 불가능
- View Class에서 사용가능한 onSaveInstanceState 사용 불가능

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/021.png" %}

SavedStateRegistry는 컴포넌트가 저장된 인스턴스 상태 메커니즘을 사용하여 상태를 저장/복원할 수 있는 인터페이스입니다. RegistryOwner의 saveState에 콘텐츠를 제공할 수 있는 Provider도 있습니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/022.png" %}

현재 검색어를 saveState에 저장하려면 [SavedStateProvider](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry.SavedStateProvider) 인터페이스를 구현하고, [SavedStateRegistryOwner](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistryOwner)가 중지되기 전에 호출되는 saveState 메소드를 구현해야 합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/023.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/024.png" %}

클래스 초기화 시 검색 상태를 SavedStateRegistryOwner에 Provider로 등록합니다. 그다음으로 이전에 저장된 상태라면 [consumeRestoredStateForKey](https://developer.android.com/reference/androidx/savedstate/SavedStateRegistry#consumeRestoredStateForKey(kotlin.String)) 메소드를 호출하여 상태를 복원할 수 있습니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/025.png" %}

View에서 검색 UI 정보를 사용하는 경우 State Holder를 초기화할 수 있습니다.

### Case2. rememberSaveable 값의 lifecycle을 제어하는 방법

기본적으로 save 이벤트가 발생하기 전에 UI 요소가 composition에 있었다면 rememberSaveable의 값이 복원됩니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/026.png" %}

Composable은 Composable에 들어온 후 0번 이상 recomposition이 일어날 수 있고, 최종적으로 Composable에서 떠납니다. 

UI가 Composable에 진입할 때 rememberSaveable의 값이 Saved State에 저장되며 Configuration 변경으로 Activity가 재생성되면 이전 Composition이 파괴되고 새로운 Composition 생성되며 rememberSaveable의 값이 복원됩니다.

Composable에서 벗어나면 rememberSaveable 내부의 값은 Saved State에서 제거됩니다.

> - rememberSaveable API : Activity 재생성시 값은 복원됨
> - remember API : Activity 재생성시 값은 손실됨

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/027.png" %}

Compose에도 View 시스템과 동일하게 상태를 저장/복원할 수 있는 [SaveableStateRegistry](https://developer.android.com/reference/kotlin/androidx/compose/runtime/saveable/SaveableStateRegistry) 인터페이스가 있습니다. 이 인터페이스가 Android 플랫폼에 구애받지 않는다는 것이 다른 부분입니다. 

Compose가 Android 타겟으로 실행되면 [DisposableSaveableStateRegistry](https://github.com/androidx/androidx/blob/androidx-main/compose/ui/ui/src/androidMain/kotlin/androidx/compose/ui/platform/DisposableSaveableStateRegistry.android.kt) 구현을 통해 SaveableStateRegistry와 연결됩니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/028.png" %}

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/029.png" %}

[SaveableStateProvider](https://developer.android.com/reference/kotlin/androidx/compose/runtime/saveable/SaveableStateHolder#SaveableStateProvider(kotlin.Any,kotlin.Function0))를 사용하여 SavedState 값을 제어할 수 있는 [SaveableStateHolder](https://developer.android.com/reference/kotlin/androidx/compose/runtime/saveable/SaveableStateHolder)가 있습니다.

Compose서 rememberSaveableStateHolder 함수를 사용해 API의 인스턴스를 생성할 수 있습니다. 컴포넌트의 특정 부분에서 rememberSaveable 값의 수명 주기를 제어하고 싶을 때 필요합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/030.png" %}

> RememberSaveable : https://github.com/androidx/androidx/blob/androidx-main/compose/runtime/runtime-saveable/src/commonMain/kotlin/androidx/compose/runtime/saveable/RememberSaveable.kt

rememberSaveable 구현체에는 LocalSaveableStateRegistry에 접근하여 consumeRestored를 호출하여 초기화합니다. 이전에 저장된 값이 없는 경우, 전달된 init 함수를 통해 초기화됩니다.

이 방법이 [Jetpack Navigation Compose](https://goo.gle/jetpack-compose-navigation)가 ViewModel 인스턴스 캐싱, rememberSaveable 값을 메모리에 유지하는데도 사용합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/031.png" %}

특정 대상의 content가 backStackEntry에서 호출되는 LocalOwnersProvider 내부에 배치됩니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/032.png" %}

LocalOwnersProvider는 몇 가지의 LocalComposition을 가지고 있으며 사용자 정의 SaveableStateProvider를 호출합니다. 이 SaveableStateProvider로 rememberSaveable 값을 Registry에서의 생명주기를 제어합니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/033.png" %}

이 예에서는 SaveableStateHolder와 연결되어 각각 다른 ID를 가지는 destination이 존재합니다. 새로운 화면이 열리면, 새로운 destination가 BackStack에 추가됩니다.

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/034.png" %}

이전 화면으로 돌아가면 destination이 BackStack에서 제거됩니다. 그리고 Navigation은 해당 ID로 removeState 함수를 호출하여 관련된 모든 rememberSaveableState를 제거합니다.

## Section 04 Recap

{% include img_assets.html id="/blog/io/io23/Best_practices_for_saving_UI_state_on_Android/035.png" %}

- ViewModel : Configuration, Saved State API, 시스템에서 메모리를 요구하는 경우, 영구 저장소 등 예기치 않은 앱 종료에도 안전

변경빈도가 높고 지연이 거의 없음 : ViewModel > Saved State APIs > Persistent Storage

데이터 손실이 없지만, 느리고 안정적임 : Persistent Storage > Saved State APIs > ViewModel
