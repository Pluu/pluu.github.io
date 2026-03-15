---
layout: post
title: "Jetpack Compose에서 BringIntoViewRequester를 활용한 스마트한 스크롤 제어"
date: 2026-03-15 23:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

모바일 앱에서 회원가입이나 정보 입력 폼(Form)을 구현할 때, 소프트 키보드가 올라오면서 사용자가 입력 중인 텍스트 필드를 가려버리는 이슈는 안드로이드 개발자라면 누구나 겪어본 흔한 문제입니다.

<!--more-->

본 글에서는 Jetpack Compose에서 `BringIntoViewRequester`를 사용해 이 문제를 해결하는 방법 중 하나를 소개합니다. 아래와 같은 회원가입 화면에서 사용한 일부분을 예제로 만들어보면서 `BringIntoViewRequester`를 어떻게 실전에 적용하는지 소개하겠습니다.

{% include youtube.html id="ZiliLq9ZxuU" %}

---

## 1. BringIntoViewRequester란?

`BringIntoViewRequester`는 Compose에서 특정 Composable 영역이 스크롤 가능한 부모(Viewport) 화면 내에 들어오도록(Bring into view) 스크롤을 요청하는 기능을 제공하는 객체입니다.

사용자가 텍스트 필드를 터치하여 포커스를 얻었을 때, 혹은 키보드가 올라오는 시점에 `bringIntoView()` 함수를 호출하게 되면, Compose가 알아서 해당 Composable이 화면에 잘 보이도록 스크롤 위치를 조정해 줍니다.

## 2. 화면 전체 구성과 기본 세팅

`BringIntoViewRequester`가 올바르게 동작하려면, 상위 부모가 스크롤 가능하고 키보드 높이에 반응해야 합니다. 예제의 `Sample` Composable은 이를 위한 기본 정의입니다.

```kotlin
@Composable
fun Sample() {
    val scrollState = rememberScrollState()
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            // 필수 1. 시스템 바(상태 바 등) 영역을 피하기 위한 패딩
            .systemBarsPadding()
            // 필수 2. 키보드가 올라올 때 하단에 키보드 높이만큼 패딩 확보
            .imePadding() 
            // 필수 3. 뷰포트 내에서 스크롤 가능하도록 설정
            .verticalScroll(scrollState) 
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        // ... (아이디, 비밀번호, 주소 등 폼 입력 Composable 배치)
    }
}
```

-  **`imePadding()`**: 키보드가 차지하는 공간만큼 화면 하단에 패딩을 밀어 넣어 화면 콘텐츠 영역을 조정합니다.
-  **`verticalScroll()`**: 스크롤 상태를 부여하여 좁아진 영역 안에서 스크롤이 가능하도록 만들어줍니다.

이 두 가지가 전제되어야 `BringIntoViewRequester`가 위치를 계산하여 올바르게 스크롤할 수 있습니다.

## 3. 핵심 로직: TextField와 BringIntoViewRequester 직접 연결

여기에서는 복잡한 구조대신, 단일 `TextField`에 직접 `BringIntoViewRequester`를 통해서 동작 원리를 확인해 보겠습니다.

```kotlin
@Composable
fun SimpleInput() {
    // 1. 상태 및 객체 초기화
    var text by remember { mutableStateOf("") }
    var isFocused by remember { mutableStateOf(false) }
    
    val bringIntoViewRequester = remember { BringIntoViewRequester() }
  
    // 키보드 노출 여부
    val isImeVisible = WindowInsets.isImeVisible

    // 2. 포커스 상태와 키보드 노출 여부에 따라 스크롤 요청
    LaunchedEffect(isImeVisible, isFocused) {
        if (isImeVisible && isFocused) {
            // 키보드가 올라오는 애니메이션 시간을 고려한 짧은 지연
            delay(100) 
            bringIntoViewRequester.bringIntoView()
        }
    }

    TextField(
        value = text,
        onValueChange = { text = it },
        label = { Text("간단한 입력") },
        modifier = Modifier
            .fillMaxWidth()
            // 3. Modifier에 bringIntoViewRequester 등록
            .bringIntoViewRequester(bringIntoViewRequester)
            // 4. 포커스 상태 변경 감지
            .onFocusChanged { focusState ->
                isFocused = focusState.hasFocus
            }
    )
}
```

위의 예제는 가장 기본적인 `BringIntoViewRequester`의 사용 패턴입니다.

1. **객체 생성**: `BringIntoViewRequester()`를 `remember`로 생성하고 타깃이 되는 UI 요소(여기서는 `TextField`)의 `Modifier`에 연결합니다.
2. **이벤트 트리거**: 상태(`text`, `isFocused`, `isImeVisible`) 변화를 감지하여 CoroutineScope 안에서 `bringIntoView()`를 호출합니다.

## 4. 심화 예제: 휴대폰 번호 입력 필드 상세 구현 (focusGroup의 활용)

`BringIntoViewRequester`는 여러 개의 입력 필드가 하나의 그룹으로 묶일 때도 사용할 수 있습니다. 예제로 휴대폰 번호를 입력받는 `CellularPhone` Composable을 통해 여러 입력 필드 사이에서 어떻게 처리하는지 확인해 보겠습니다.

```kotlin
@Composable
fun CellularPhone(modifier: Modifier = Modifier) {
    // 1. 여러 TextField의 포커스를 제어하기 위한 FocusRequester 
    val (focus1, focus2, focus3) = FocusRequester.createRefs()

    var input1 by remember { mutableStateOf("") }
    // ... input2, input3 생략 ...

    var isFocused by remember { mutableStateOf(false) }
    val bringIntoViewRequester = remember { BringIntoViewRequester() }
    val isImeVisible = WindowInsets.isImeVisible

    // 스크롤 요청 로직
    LaunchedEffect(isImeVisible, isFocused) {
         if (isImeVisible && isFocused) {
             delay(100)
             bringIntoViewRequester.bringIntoView()
         }
    }

    // 2. 입력 필드들을 감싸는 부모 Column에 Modifier 적용
    Column(
        modifier = modifier
            .bringIntoViewRequester(bringIntoViewRequester)
            .onFocusChanged { focusState ->
                isFocused = focusState.hasFocus
            }
            // ✨ 3. 자식들의 포커스를 그룹화
            .focusGroup() 
    ) {
        Text("휴대폰번호")
        Row(verticalAlignment = Alignment.CenterVertically) {
            // 첫 번째 입력 필드
            TextField(
                value = input1,
                // ...
                modifier = Modifier
                    .weight(1f)
                    .focusRequester(focus1)
                    .focusProperties { next = focus2 } // 다음 포커스 지정
            )
            Dash()
            // 두 번째, 세 번째 입력 필드 생략 ...
        }
    }
}
```

### 단계별 상세 설명

1. **포커스 이동 설정 (`focusProperties`)**: 각 `TextField`의 `Modifier.focusProperties`를 통해 `next` 호긍ㄴ `previous`를 지정할 수 있습니다. 이렇게 하면 하드웨어 키보드의 Tab 키나 접근성 서비스(TalkBack 등)를 통한 포커스 이동이 자연스럽게 동작합니다.
2. **`focusGroup()`의 역할**: 부모 `Column`에 적용된 `Modifier.focusGroup()`은 여기서 결정적인 역할을 합니다. 만약 이 Modifier가 없다면, `focus1`을 가진 첫 번째 `TextField`에서 `focus2`를 가진 두 번째 `TextField`로 포커스가 이동할 때, 부모 `Column`은 찰나의 순간에 "포커스를 잃었다"고 판단(`isFocused = false` -> `true`)하게 됩니다. 이는 상태 변화를 일으켜 불필요한 재구성을 유발하거나, 스크롤 로직이 꼬이는 원인이 될 수 있습니다. `focusGroup()`은 내부 자식들 간의 포커스 이동은 그룹 외부로 포커스가 벗어난 것으로 간주하지 않도록 하여 부모의 `isFocused` 상태를 안정적으로 유지시켜 줍니다.

## 5. 결론

Jetpack Compose에서 복잡한 입력 폼을 다룰 때, 키보드가 UI를 가리는 현상을 효과적으로 제어하는 것은 사용자 경험(UX) 측면에서 매우 중요합니다. 다음 3가지만 기억하시면 됩니다.

1. 화면 최상위에 `imePadding()`과 `verticalScroll()`을 적용하여 기본적인 스크롤 캔버스를 확보
2. 단일 입력 컴포넌트 또는 입력 필드 그룹에 `Modifier.bringIntoViewRequester()`를 적용하고, 여러 개의 필드가 묶여있다면 `focusGroup()`으로 감싸 포커스를 안정적으로 관리
3. `WindowInsets.isImeVisible`과 `hasFocus`를 조합하여, 포커스를 가진 상태로 키보드가 나타날 때 `bringIntoView()`를 호출

위 패턴을 도입한다면, 어떠한 긴 가입 폼 화면이라도 사용자가 입력 중인 부분이 키보드에 가려지는 답답한 일을 겪지 않게 될 것입니다.