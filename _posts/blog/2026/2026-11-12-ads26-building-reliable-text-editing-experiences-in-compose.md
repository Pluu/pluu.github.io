---
layout: post
title: "[요약] Building reliable text editing experiences in Compose (Android Dev Summit '26)"
date: 2026-11-12 20:00:00 +09:00
tag: [Android, Compose, UI]
categories:
- blog
- Android
- AndroidDevSummit
---

{% include youtube.html id="1DvjkRYGs2g" %}

<!--more-->

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - -

# 1. Compose 텍스트 입력 API

이번 세션에서 안정적인 텍스트 편집 환경을 구축하는 방법과 아키텍처 변화를 소개합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/01.png" %}

Compose는 세 가지 주요 텍스트 입력 컴포넌트를 제공합니다
- `TextField` / `OutlinedTextField` : Material 디자인 가이드라인을 구현한 표준 컴포넌트
- `BasicTextField `: 스타일이 없는 기본 컴포넌트. 커스텀 디자인 시스템 구축 시 사용하며 Compose 텍스트 필드 내부 구현 담당
- `SecureTextField` : 비밀번호 입력 특화 컴포넌트

### TextFieldState 권장 및 기존 콜백 API의 Deprecated

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/02.png" %}

- [TextFieldState](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState) 사용 권장
  - BasicTextField(state = rememberTextFieldState())는 Compose 1.7에서 Stable 전환
- 기존 콜백 API는 Deprecated
  - Compose 1.13부터 `BasicTextField`, `TextField`, `OutlinedTextField`에서 (value, onValueChange) 오버로드를 Deprecated로 전환
  - 보안 및 접근성 결함을 제외한 신규 기능 추가와 일반 버그 수정 중단

- - -

# 2. 비동기 상태와 IME 동기화 문제 해결

기존 (value, onValueChange) 콜백은 동기식 입력에서는 정상 작동했지만, `StateFlow`와 같은 비동기 데이터 스트림과 결합하면 IME 동기화 결함이 발생합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/03.png" %}

### 주요 문제
- 사용자의 IME 입력 이벤트를 비동기 스트림으로 처리한 후 UI를 다시 그리는 구조
- 빠른 타이핑이나 글자 조합(Composition) 연산 중에 비동기 지연이 발생할 때 나타나는 문제
  - 글자 누락
  - 글자 중복
  - 커서 위치 튐

### TextFieldState의 해결 원리
- 사용자가 입력할 때 비동기 왕복을 기다리지 않고 IME와 동기로 내부 상태 즉시 갱신
- 텍스트 값 외에 선택 영역, Undo/Redo 이력, 서식 스타일(Span/Paragraph Styles)을 단일 편집 세션 객체로 통합 관리
- 스냅샷 시스템 최적화
  - Layout 또는 Draw 단계에서만 텍스트 상태를 읽도록 최적화
  - 타이핑 시 발생하는 불필요한 Recomposition 제거를 통한 렌더링 성능 개선

- - -

# 3. TextFieldBuffer 활용

[TextFieldState.text](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState#text())는 읽기 전용 불변 스냅샷입니다. 코드로 텍스트를 직접 수정하려면 [edit](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState#edit(kotlin.Function1)) 함수를 사용해야 합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/04.png" %}

### state.edit { ... }와 TextFieldBuffer
[state.edit { }](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldState#edit(kotlin.Function1)) 람다 내부에서 가변 객체인 [TextFieldBuffer](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldBuffer)를 제공받아 글자 삽입, 치환, 삭제, 커서 이동 API를 호출합니다.

```kotlin
val state = rememberTextFieldState("Hello")

state.edit {
    // 텍스트를 변경하고 커서를 끝으로 이동
    replace(0, length, "Hello World")
    placeCursorAtEnd()
}
```

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/05.png" %}

> **성능 최적화: edit 호출을 하나로 묶기**
>
> 여러 편집 작업을 처리할 때 `edit`을 반복 호출하지 말고 하나의 `edit { }` 블록 안에 묶어야 합니다. Compose는 단일 `TextFieldBuffer` 인스턴스에서 인플레이스(In-place)로 메모리를 변경한 뒤, IME 및 스냅샷 시스템과 1회만 동기화합니다.  
> clearText(), setTextAndPlaceCursorAtEnd() 등 자주 쓰는 동작은 이미 `TextFieldState` 확장 함수로 제공됩니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/06.png" %}

- - -

# 4. 입력 제한과 시각적 가공: InputTransformation vs OutputTransformation

### InputTransformation: 키보드 충돌 없는 입력 검증
과거 `onValueChange` 방식의 입력 검증은 텍스트가 키보드에 이미 커밋된 후에 실행되었습니다. 잘못된 입력을 되돌릴 때 IME 내부 상태와 충돌하여 글자가 깜빡이거나 엉키는 현상이 있었습니다.

- 사용자 입력이 `TextFieldState`에 반영되기 전 가로채기 수행
- ChangeList를 사용해 실제 변경된 인덱스 범위만 전달하여 전체 문자열 비교 비용 제거
- 허용하지 않는 입력은 `revertAllChanges()`로 취소

```kotlin
// 숫자만 허용하는 InputTransformation
inputTransformation = InputTransformation {
    val text = asCharSequence()
    if (!text.all { it.isDigit() }) {
        // Reject non-digit characters
        revertAllChanges()
    }
}
```

### OutputTransformation: 원본 데이터를 보존하는 화면 표시 가공
신용카드 번호 4자리 구분 공백이나 비밀번호 마스킹처럼 원본 데이터는 유지하고 화면 표시 형식만 변경해야 할 때 사용합니다.

```kotlin
// Raw data untouched; formatting is purely visual
outputTransformation = OutputTransformation {
    if (length > 6) {
        insert(6, "-")
    }
    if (length > 3) {
        insert(3, "-")
    }
}
```

- 화면에 그리는 버퍼만 변경하고 원본 `TextFieldState` 데이터는 유지
- 스냅샷 시스템을 감지하여 변환 조건에 사용된 State 값이 변경될 때 화면 자동 재계산

- - -

# 5. 상태 호이스팅(State Hoisting) 설계 패턴

아키텍처 구조에 맞춰 텍스트 필드 상태의 위치를 결정합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/07.png" %}

### 1) Composable 트리 내부 관리
- 단일 화면이나 인접한 Composable 간에 상태를 공유할 때 `rememberTextFieldState()` 사용

### 2) ViewModel 직접 관리
- ViewModel에 Compose Runtime 종속성을 허용하는 프로젝트에 적합
- `TextFieldState`를 ViewModel 프로퍼티로 직접 선언
- 프로세스 종료 후 복원을 위해 `SavedStateHandle.saveable(saver = TextFieldState.Saver)` 사용

```kotlin
class FormViewModel : ViewModel() {
  val username = TextFieldState()
  val uiState: StateFlow<FormUiState> = ...
}
```

```kotlin
class FormViewModel(savedStateHandle: SavedStateHandle) : ViewModel() {
  val username: TextFieldState = savedStateHandle.saveable(
    key = "username",
    saver = TextFieldState.Saver,
    init = { TextFieldState() }
  )
}
```

### 3) Conforming 패턴: 순수 Kotlin ViewModel 유지
ViewModel 레이어에 Compose UI 런타임 종속성을 배제하고 순수 Kotlin 코루틴/Flow만 유지해야 한다면 Conforming 패턴을 적용합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/08.png" %}

- Composable 내부에서 `rememberTextFieldState()`로 텍스트 필드의 단일 진실 공급원(Single Source of Truth) 상태 유지
- `LaunchedEffect`와 `snapshotFlow`를 사용하여 텍스트 변화를 감지하고 ViewModel 메서드로 전달

```kotlin
@Composable
fun LoginScreen(viewModel: LoginViewModel) {
    val usernameState = rememberTextFieldState(viewModel.initialUsername)

    LaunchedEffect(usernameState, viewModel) {
        snapshotFlow { usernameState.text.toString() }
            .drop(1) // 최초 초기값 방출을 무시하여 ViewModel 상태 덮어쓰기 방지
            .collect { viewModel.onUsernameChanged(it) }
    }

    BasicTextField(state = usernameState)
}
```

> **.drop(1) 호출 이유**:  
> 
> `snapshotFlow`는 수집을 시작할 때 현재 상태의 초기값을 즉시 방출합니다. ViewModel 초기값으로 텍스트 필드를 생성한 경우, 이 첫 번째 방출이 ViewModel로 역전달되어 중복 이벤트나 덮어쓰기 문제를 일으키므로 `.drop(1)`로 초기 방출을 건너뜁니다.

> [Migrate to state-based text fields](https://goo.gle/migrate_to_state_textfield)

- - -

# 6. 서식 있는 텍스트 편집 (Rich Text Editing)

Compose 1.12부터 서식 있는 텍스트 편집 API를 지원합니다.

### AnnotatedString 대신 TextFieldBuffer를 사용하는 이유

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/09.png" %}

- 정적 텍스트용 `AnnotatedString`: 불변(Immutable) 객체. 글자를 입력할 때마다 문자열 전체와 스타일 리스트를 새로 복사·할당하므로 메모리 부하 발생
- 편집용 `TextFieldBuffer`: 가변 인플레이스(In-place) 엔진 탑재. 텍스트 입력 중에도 메모리 재할당 없이 스타일 추가, 수정, 삭제 가능

### addStyle과 ExpandPolicy

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/10.png" %}

특정 텍스트에 스타일을 지정한 후 경계 지점에서 타이핑을 이어갈 때 스타일을 유지할지 여부를 [ExpandPolicy](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/ExpandPolicy)로 제어합니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/11.png" %}

- InsideOnly: 스타일 범위 내부에서 입력할 때만 스타일 적용 (경계 지점 입력 시 확장 제외)
- AtEnd: 스타일 범위 끝에서 입력 시 스타일 확장
- AtStart: 스타일 범위 시작 지점에서 입력 시 스타일 확장
- AtBoth: 시작과 끝 양쪽 모두 입력 시 스타일 확장

### 스타일 쿼리와 TrackedRange

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/12.png" %}

- 스타일 쿼리 ([getSpanStyles](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TextFieldBuffer#getSpanStyles(androidx.compose.ui.text.TextRange)))
  - 적용된 순서대로 반환(Order-aware)하여 나중에 적용한 스타일의 우선순위 보장
  - TextFieldBuffer에서는 TrackedRange 리스트 반환
- [TrackedRange](https://developer.android.com/reference/kotlin/androidx/compose/foundation/text/input/TrackedRange)
  - 버퍼 내 스타일 범위를 가리키는 포인터 핸들
  - 기존 스타일 삭제 및 재생성 없이 범위(range), expandPolicy, 스타일 내용을 인플레이스로 직접 변경 가능

> Style rich text input : https://developer.android.com/develop/ui/compose/text/rich-text-input

- - -

# 7. 실전 유즈케이스 구현

### 1) WYSIWYG 에디터의 볼드(Bold) 토글

사용자가 선택한 영역의 볼드 스타일을 켜고 끄는 구현입니다

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/13.png" %}

```kotlin
fun TextFieldBuffer.toggleBoldSelection() {
    if (selection.collapsed) return
    val boldSpans = getSpandStyles(selection)

    if (!isFullyBold(boldSpans, selection)) {
        // 볼드가 아니면 선택 영역에 볼드 스타일 적용
        addStyle(
            SpanStyle(fontWeight = FontWeight.Bold),
            selection,
            ExpandPolicy.AtEnd
        )
    } else {
        unboldSelection(boldSpans.first())
    }
}
```

### 2) 패턴 기반 스타일링 (마크다운 실시간 변환)

`**단어**` 입력 시 마크다운 기호를 제거하고 볼드 서식을 적용합니다

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/14.png" %}

- `InputTransformation`을 활용하여 텍스트가 상태에 반영되기 전 아스테리스크(`**`)를 제거하고 내부 텍스트에 볼드 스타일 적용

### 3) 검색어 하이라이트 (Search Highlighting)

검색창에 입력한 단어와 일치하는 본문 텍스트를 노란색 배경으로 강조 표시합니다

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/15.png" %}

- 원본 데이터 상태 변경 없이 시각적 하이라이트만 적용하기 위해 `OutputTransformation` 사용
- `MutableState` 기반 검색 쿼리 변경 시 스냅샷 시스템이 감지하여 하이라이트 자동 재계산

- - -

# 8. 차세대 라이브러리: Markup Text Library

Compose 팀에서 개발 중인 신규 라이브러리 프리뷰입니다.

{% include img_assets.html id="/blog/ads26/building-reliable-text-editing-experiences-in-compose/16.png" %}

- 마크다운 등 리치 텍스트 포맷 지원
- 증분 파싱(Incremental Parsing) 및 증분 렌더링(Incremental Rendering)
  - 텍스트 전체를 다시 파싱하거나 그리지 않고 변경된 노드만 감지하여 갱신
  - 대용량 문서 편집 및 LLM 마크다운 스트리밍 출력 시 깜빡임 없는 변경 부분 렌더링 지원
