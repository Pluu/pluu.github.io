---
layout: post
title: "Jetpack Compose로 구현하는 인터랙티브 카드 홀로그램 효과"
date: 2026-10-17 18:00:00 +09:00
tag: [Android, Compose, UI]
categories:
- blog
- Android
---

포켓몬 카드를 손에 쥐고 기울이면, 빛의 각도에 따라 무지개 빛이 반사되고 캐릭터 뒤편에서 홀로그램 효과를 볼 수 있습니다.

<!--more-->

이와 같은 화려한 그래픽 효과는 AGSL, OpenGL 셰이더 같은 전문적인 그래픽 프로그래밍을 통해 구현할 수도 있지만, **Jetpack Compose의 기본 그래픽 API**(`graphicsLayer`, `Brush`, `DrawScope`)만으로도 부드럽고 실감나게 구현할 수 있습니다. 당연히 100% 동일하다는 것은 아닙니다.

이번 글에서는 Compose를 사용해 **루기아 V(Lugia V) 카드**를 모델로 3D 틸트와 홀로그램 효과를 구현하는 방법을 소개합니다.

- - -

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - - 

> **이미지 출처**  
> 본 글에서 사용된 홀로그램 효과 구현의 출처는 Simon Goellner님의 웹 프로젝트인 [poke-holo (https://poke-holo.simey.me)](https://poke-holo.simey.me/)입니다.  
> 카드 일러스트 원본, 마스크 이미지(Mask), 메탈릭 그레인 노이즈 등 사용된 모든 이미지 리소스의 출처 역시 [poke-holo](https://poke-holo.simey.me/)에 기반합니다. 웹(CSS)의 놀라운 시각 효과를 안드로이드 **Jetpack Compose** 캔버스 파이프라인으로 포팅 및 재해석한 과정을 다룹니다.

------

본 글에서 사용된 코드는 아래 버전 기준입니다.

- AndroidX Compose BOM 2026.10.00
- Kotlin 2.4.21

------

## 동작 모습

{% include youtube.html id="8V4rvGXGALc" %}

> 카드를 드래그하거나 스마트폰을 기울이면 3D로 회전하며, 캐릭터 뒤편에서 서로 반대 방향으로 엇갈려 이동하는 두 줄기 대각선 광선과 무지개 스펙트럼이 자연스럽게 반응합니다.

---

## 1. 샘플 이미지 준비

홀로그램 카드를 구현하려면 두 장의 기본 이미지가 필요합니다. 

> 이미지 출처: [poke-holo](https://poke-holo.simey.me/)

| 기본 카드 이미지 | 마스크 이미지 |
| :---: | :---: |
| {% include img_assets.html id="/blog/2026/1017/lugia_v_card.png" %} | {% include img_assets.html id="/blog/2026/1017/lugia_v_mask.webp" %} |
| 카드 전체가 인쇄된 기본 일러스트 | 캐릭터 영역을 보호하기 위한 마스크 |

### ① 기본 카드 이미지 (Base Card Image)
* **카드 외형 및 정보 표시**: 카드의 고유 정보를 화면에 보이게 하는 기본 레이어입니다.
* **빛 반사의 기반 제공**: 홀로그램 효과는 빈 캔버스가 아닌 기본 이미지의 명암 위에 빛을 추가하는 빛 합성(`BlendMode.ColorDodge`)으로 자연스럽게 반사광이 생기도록 합니다.
  * `BlendMode.ColorDodge` (최종 빛 합성): 이후 만들어진 홀로그램 포일 레이어를 원본 카드 위에 얹을 때 사용합니다. 원본의 어두운 영역은 유지하면서 밝은 광선 부분만 채도와 밝기를 높여서 실제 프리즘 호일의 강렬한 빛 반사 효과를 연출합니다.

{% include img_assets.html id="/blog/2026/1017/blendmode_foil_comparison.png" %}

> **BlendMode별 시각적 차이**:  
> `SrcOver`는 배경 일러스트를 불투명하게 덮어버리고, `Screen`은 빛이 하얗게 뜨며, `Overlay`는 어두운 영역이 칙칙해집니다. 반면 **`ColorDodge`**는 원본 일러스트의 생생한 색감을 유지하면서 빛줄기만 환하게 강조해 가장 실감 나는 프리즘 호일을 완성합니다.

### ② 마스크 이미지 (Mask Image)
* **일러스트 보호 (빛 차단)**: 홀로그램 효과가 카드 전체를 덮어 캐릭터 일러스트가 묻히지 않도록, 캐릭터 영역의 빛을 차단하고 배경만 빛을 받을 수 있도록 영역을 분리합니다.
* **3D 공간 깊이감(Depth) 구현**: 캐릭터가 Foreground에 있고, 빛 효과가 Background에 위치하도록 레이어를 구분하여, 2D 카드 평면에서도 입체적인 공간감을 표현합니다.
* **사용하는 BlendMode (`BlendMode.DstIn`)**:
  * **스텐실 마스킹(Stencil Cutout)**: 마스크 이미지의 불투명 영역(배경)에만 기존에 그려둔 홀로그램 포일 효과를 남기고, 투명한 영역(Alpha 0, 캐릭터)은 제외되도록 처리합니다. 결과적으로 캐릭터 영역은 홀로그램에서 제외되고 배경에만 홀로그램이 적용됩니다.

{% include img_assets.html id="/blog/2026/1017/blendmode_mask_comparison.png" %}

> **마스크 적용 유무에 따른 차이**:  
> 마스크를 사용하지 않고 합성할 경우, 캐릭터 얼굴과 몸체까지 홀로그램 빛이 침범해 일러스트가 훼손되지만, **`BlendMode.DstIn`**을 적용하면 캐릭터는 선명하게 전경에 남고, 빛 반사 효과는 캐릭터 뒤 배경에만 선명하게 표현됩니다.

---

## 2. 카드 효과: 입체감 넘치는 3D 틸트 (Tilt)

카드를 손에 들고 기울이는 느낌을 주는 **3D 회전(Tilt)** 효과입니다.

{% include img_assets.html id="/blog/2026/1017/step1_tilt_animation.webp" %}

> 손가락으로 드래그하거나 기기의 센서 움직임에 따라 카드가 3D 공간에서 부드럽게 기울어집니다. 손을 떼었을 때 자연스러운 탄성 효과와 함께 원래 위치로 되돌아오는 애니메이션입니다.

```kotlin
val tiltXAnim = remember { Animatable(0f) }
val tiltYAnim = remember { Animatable(0f) }
val coroutineScope = rememberCoroutineScope()

// 자연스러운 탄성을 위한 감쇠 스프링 설정
val springSpec = remember {
    spring<Float>(
        dampingRatio = 0.55f, // 바운스 감쇠 비율 (0.55: 자연스러운 흔들림)
        stiffness = 300f      // 스프링 탄성 강도
    )
}

Modifier
    .pointerInput(Unit) {
        detectDragGestures(
            onDrag = { change, _ ->
                // 터치 좌표를 0.0 ~ 1.0 비율로 정규화
                val normX = (change.position.x / size.width).coerceIn(0f, 1f)
                val normY = (change.position.y / size.height).coerceIn(0f, 1f)
                // -1.0 ~ +1.0 사이의 틸트 비율 즉각 반영
                coroutineScope.launch {
                    tiltXAnim.snapTo((normX - 0.5f) * 2f)
                    tiltYAnim.snapTo((normY - 0.5f) * 2f)
                }
            },
            onDragEnd = {
                // 손을 떼면 스프링 물리 애니메이션으로 원점(0, 0) 복귀
                coroutineScope.launch {
                    launch { tiltXAnim.animateTo(0f, springSpec) }
                    launch { tiltYAnim.animateTo(0f, springSpec) }
                }
            }
        )
    }
    .graphicsLayer {
        // 손가락 위치나 센서 기울기에 맞춰 X축, Y축으로 3D 회전
        rotationX = -tiltYAnim.value * maxTiltDegrees
        rotationY = tiltXAnim.value * maxTiltDegrees
        // 카메라 거리(원근감) 설정: 값이 적절해야 자연스러운 원근감이 연출됨
        cameraDistance = 16f * density
    }
```

* **3D 원근 회전 (`graphicsLayer`)**: 정규화된 틸트 비율(-1.0 ~ 1.0)에 맞춰 `rotationX`, `rotationY`를 적용하고, `cameraDistance`로 왜곡 없는 입체 원근감을 제공합니다.
* **스프링 물리 복귀 (`Animatable`)**: 손을 떼면 감쇠 스프링으로 자연스러운 탄성 바운스와 함께 원래의 상태로 돌아갑니다.

---

## 3. 빛 홀로그램 효과: 루기아 V의 시그니처 빛 반사 효과

카드를 기울일 때 나타나는 **빛 반사 효과**는 **4개의 빛 레이어**가 순서대로 겹쳐져 완성됩니다.

```
최종 완성 카드
  └── 4. 캐릭터 보존 마스킹 (DstIn으로 캐릭터 뚫고, ColorDodge로 배경 빛 합성)
  └── 3. 메탈릭 호일 질감 (BlendMode.Screen 그레인 노이즈)
  └── 2. 무지개 스펙트럼 (BlendMode.Hue 색조 입히기)
  └── 1. 두 줄기 대각선 광선 (133° 교차 사선 빔)
  └── [카드 원본 일러스트]
```

그래픽 이론이나 셰이더 프로그래밍에 대한 지식이 없어도 쉽게 이해할 수 있도록 하나씩 살펴보겠습니다.

---

### ① 서로 엇갈려 교차하는 두 대각선 광선 (Dual Diagonal Beams)

루기아 V 카드의 가장 큰 특징은 카드를 좌우로 기울일 때 **두 개의 대각선 빛줄기가 서로 반대 방향으로 엇갈려 이동**하는 것입니다.  
어두운 밤하늘에 133° 사선 각도로 비추는 **두 대의 탐조등(손전등)**처럼, 카드를 움직일 때마다 빛의 교차 무늬를 만들어냅니다.

```kotlin
// 기울기(bgX)에 맞춰 한쪽은 왼쪽(-), 다른 쪽은 오른쪽(+)으로 역방향 이동
val forwardShift = -(bgX - 0.5f) * beamCycle * 2.0f
val counterShift = (bgX - 0.5f) * beamCycleAfter * 0.95f

// 1. 순방향 메인 빔 (Base Beam)
val forwardBeamBrush = Brush.linearGradient(
    *V_DIAGONAL_BEAM_STOPS,
    start = Offset(centerX - dirX * halfCycle + dirX * forwardShift, centerY - dirY * halfCycle + dirY * forwardShift),
    end = Offset(centerX + dirX * halfCycle + dirX * forwardShift, centerY + dirY * halfCycle + dirY * forwardShift),
    tileMode = TileMode.Repeated
)

// 2. 반대 방향 빔 (Counter Beam)
val counterBeamBrush = Brush.linearGradient(
    *V_DIAGONAL_BEAM_STOPS,
    start = Offset(centerX - dirX * halfCycleAfter + dirX * counterShift, centerY - dirY * halfCycleAfter + dirY * counterShift),
    end = Offset(centerX + dirX * halfCycleAfter + dirX * counterShift, centerY + dirY * halfCycleAfter + dirY * counterShift),
    tileMode = TileMode.Repeated
)

// 순방향 빔 위에 역방향 빔을 Softlight 모드로 합성
drawRect(brush = forwardBeamBrush)
drawRect(brush = counterBeamBrush, blendMode = BlendMode.Softlight, alpha = 0.85f)
```

> `BlendMode.Softlight`
>
> **부드러운 조명** 효과를 통해 두 광선이 겹칠 때 어두운 곳은 깊어지고 밝은 곳은 부드럽게 중첩되어 자연스러운 교차 무늬를 만들어냅니다.

{% include img_assets.html id="/blog/2026/1017/step2_dual_beam.png" %}

---

### ② 은은하게 퍼지는 수직 무지개 스펙트럼

앞서 만든 두 광선의 흑백 명암 위에 각도에 따라 변하는 **프리즘 무지개 스펙트럼**을 입혀줍니다.  
흑백 스케치북 위에 **투명한 무지개 셀로판지**를 올리는 듯한 느낌으로, 흑백 광선에 생동감 넘치는 화려한 색감을 더합니다.

```kotlin
// 세로 방향 순환 6색 무지개 그라디언트
val rainbowBrush = Brush.linearGradient(
    *SUNPILLAR_COLOR_STOPS,
    start = Offset(0f, sunpillarShiftY),
    end = Offset(0f, sunpillarShiftY - sunpillarCycle),
    tileMode = TileMode.Repeated
)

// 광선 위에 무지개 색조(Hue)만 덧입히기
drawRect(brush = rainbowBrush, blendMode = BlendMode.Hue)
```

> **`BlendMode.Hue`**
>
> 광선의 밝기와 형태(명암)는 그대로 유지하되, 오직 색상(Hue) 정보만 무지개색으로 교체하여 광선이 무지개빛으로 빛나게 합니다.

{% include img_assets.html id="/blog/2026/1017/step3_rainbow_spectrum.png" %}

---

### ③ 실물 카드의 메탈릭 호일 질감 (그레인 노이즈)

매끄러운 디지털 그라디언트는 모니터 화면처럼 보이기 쉽습니다. 실제 카드는 메탈릭 호일 위에 인쇄되므로, 빛 위에 미세한 **메탈릭 입자(노이즈)**를 더하는 과정이 필요합니다.

```kotlin
// 미세한 메탈릭 노이즈 텍스처를 25% 투명도로 얹어줌
drawImage(
    image = grainBitmap,
    dstSize = IntSize(size.width.toInt(), size.height.toInt()),
    blendMode = BlendMode.Screen,
    alpha = 0.25f
)
```

> **`BlendMode.Screen`**
>
> 검은색 배경을 투명하게 처리하고 밝은 노이즈 입자를 추가하여, 은은한 금속 호일의 입자 질감을 만듭니다.

{% include img_assets.html id="/blog/2026/1017/step4_metallic_grain.png" %}

---

### ④ 캐릭터 보존 마스킹과 최종 홀로그램 완성

카드 전체에 홀로그램 빛을 뿌리면 캐릭터 얼굴과 몸까지 번쩍여 일러스트가 가려질 수 있습니다. 미술 시간에 캐릭터 모양대로 오려둔 **`스텐실(Stencil) 마스크`**처럼, 캐릭터 몸체는 보호하고 **오직 캐릭터 뒤편 배경에만** 홀로그램 빛이 투과되도록 합니다.

```kotlin
// 1. 임시 레이어(오프스크린 버퍼) 생성
drawIntoCanvas { canvas ->
    canvas.saveLayer(layerRect, layerPaint) // layerPaint blendMode = ColorDodge

    // ① 두 줄기 광선 + 무지개(Hue) + 그레인(Screen) 그리기
    drawRect(brush = forwardBeamBrush)
    drawRect(brush = rainbowBrush, blendMode = BlendMode.Hue)
    drawRect(brush = counterBeamBrush, blendMode = BlendMode.Softlight, alpha = 0.85f)
    drawImage(grainBitmap, dstSize = dstSize, blendMode = BlendMode.Screen, alpha = 0.25f)

    // ② 마스크로 캐릭터 영역 뚫어내기
    drawImage(maskBitmap, dstSize = dstSize, blendMode = BlendMode.DstIn)

    // 2. 임시 레이어를 닫고 원본 카드 위에 ColorDodge로 빛 합성
    canvas.restore()
}
```

> **`BlendMode.DstIn` (스텐실 마스킹)**
>
> 마스크의 불투명 영역(배경)에만 홀로그램 효과를 추가하고, 캐릭터 영역은 깨끗하게 지워냅니다.
>
> **`BlendMode.ColorDodge` (프리즘 빛 합성)**
>
> 어두운 배경은 유지하면서 밝은 광선 부분의 채도/밝기를 극대화하여 실제 프리즘에서 나타나는 빛 반사 효과를 구현합니다.

{% include img_assets.html id="/blog/2026/1017/step5_masked_foil.png" %}

캐릭터의 원래 색상은 유지되면서 뒤쪽에서만 홀로그램 빔의 빛 반사 효과가 빛나면서 깊이 있는 3D 입체감을 제공합니다.

---

## 4. 전체 구현 코드

이 모든 효과를 하나로 묶은 Composable 코드입니다. 별도의 외부 그래픽 라이브러리 없이 순수 Compose 코드만으로 동작합니다.

```kotlin
// 1. 수직 6색 무지개 그라디언트 색상 구간
val SUNPILLAR_COLOR_STOPS = arrayOf(
    0.0000f to Color(0xFFFF7575),
    0.1667f to Color(0xFFF2E86E),
    0.3333f to Color(0xFFA8ED6E),
    0.5000f to Color(0xFF85F7F0),
    0.6667f to Color(0xFF7A9EFF),
    0.8333f to Color(0xFFE275FF),
    1.0000f to Color(0xFFFF7575)
)

// 2. 루기아 V 대각선 광선 그라디언트 색상 구간
val V_DIAGONAL_BEAM_STOPS = arrayOf(
    0.000f to Color(0xFF0E152E),
    0.316f to Color(0xFF90A3A3),
    0.375f to Color(0xFF90BFBF),
    0.433f to Color(0xFF90A3A3),
    0.833f to Color(0xFF0E152E),
    1.000f to Color(0xFF0E152E)
)

@Composable
fun PokemonVCard(
    cardImageRes: Int,
    maskResId: Int,
    modifier: Modifier = Modifier,
    maxTiltDegrees: Float = 14.3f
) {
    val cardBitmap = ImageBitmap.imageResource(id = cardImageRes)
    val maskBitmap = ImageBitmap.imageResource(id = maskResId)
    val grainBitmap = ImageBitmap.imageResource(id = R.drawable.v_grain)

    val coroutineScope = rememberCoroutineScope()
    val tiltXAnim = remember { Animatable(0f) }
    val tiltYAnim = remember { Animatable(0f) }
    val springSpec = remember {
        spring<Float>(
            dampingRatio = 0.55f, // 바운스 감쇠 비율
            stiffness = 300f      // 스프링 탄성 강도
        )
    }

    // 대각선 133도 방향 벡터
    val beamRad = (133.0 * Math.PI / 180.0).toFloat()
    val dirX = kotlin.math.sin(beamRad)
    val dirY = -kotlin.math.cos(beamRad)

    // 마스킹된 포일을 카드 원본에 빛 합성할 페인트
    val layerPaint = remember {
        Paint().apply {
            blendMode = BlendMode.ColorDodge
        }
    }

    Box(
        modifier = modifier
            .aspectRatio(0.718f) // 공식 포켓몬 카드 종횡비
            .clip(RoundedCornerShape(16.dp))
            .pointerInput(Unit) {
                detectDragGestures(
                    onDrag = { change, _ ->
                        val normX = (change.position.x / size.width).coerceIn(0f, 1f)
                        val normY = (change.position.y / size.height).coerceIn(0f, 1f)
                        coroutineScope.launch {
                            tiltXAnim.snapTo((normX - 0.5f) * 2f)
                            tiltYAnim.snapTo((normY - 0.5f) * 2f)
                        }
                    },
                    onDragEnd = {
                        coroutineScope.launch {
                            launch { tiltXAnim.animateTo(0f, springSpec) }
                            launch { tiltYAnim.animateTo(0f, springSpec) }
                        }
                    }
                )
            }
            .graphicsLayer {
                // Drawing 단계에서 상태를 읽어 불필요한 Recomposition 방지
                rotationX = -tiltYAnim.value * maxTiltDegrees
                rotationY = tiltXAnim.value * maxTiltDegrees
                cameraDistance = 16f * density
            }
            .drawWithCache {
                val w = size.width
                val h = size.height
                val diagonal = kotlin.math.hypot(w, h)
                val layerRect = Rect(0f, 0f, w, h)
                val dstSize = IntSize(w.toInt(), h.toInt())

                val beamCycle = diagonal * 0.2712f
                val beamCycleAfter = diagonal * 0.2049f
                val sunpillarCycle = h * 2.10f

                onDrawWithContent {
                    val normX = (tiltXAnim.value + 1f) * 0.5f
                    val normY = (tiltYAnim.value + 1f) * 0.5f

                    // 1. 카드 기본 일러스트 그리기
                    drawImage(cardBitmap, dstSize = dstSize)

                    // 2. 캐릭터 뒤편 배경에만 홀로그램 포일 합성
                    val bgX = 0.37f + 0.26f * normX
                    val bgY = 0.33f + 0.34f * normY

                    val forwardShift = -(bgX - 0.5f) * beamCycle * 2.0f
                    val counterShift = (bgX - 0.5f) * beamCycleAfter * 0.95f
                    val sunpillarShiftY = (7.0f - 6.0f * bgY) * h

                    // ① 순방향 & 반대 방향 두 광선 브러시
                    val forwardBeamBrush = Brush.linearGradient(
                        *V_DIAGONAL_BEAM_STOPS,
                        start = Offset(w * 0.5f - dirX * beamCycle * 0.5f + dirX * forwardShift, h * 0.5f - dirY * beamCycle * 0.5f + dirY * forwardShift),
                        end = Offset(w * 0.5f + dirX * beamCycle * 0.5f + dirX * forwardShift, h * 0.5f + dirY * beamCycle * 0.5f + dirY * forwardShift),
                        tileMode = TileMode.Repeated
                    )
                    val counterBeamBrush = Brush.linearGradient(
                        *V_DIAGONAL_BEAM_STOPS,
                        start = Offset(w * 0.5f - dirX * beamCycleAfter * 0.5f + dirX * counterShift, h * 0.5f - dirY * beamCycleAfter * 0.5f + dirY * counterShift),
                        end = Offset(w * 0.5f + dirX * beamCycleAfter * 0.5f + dirX * counterShift, h * 0.5f + dirY * beamCycleAfter * 0.5f + dirY * counterShift),
                        tileMode = TileMode.Repeated
                    )
                    // ② 수직 무지개 브러시
                    val rainbowBrush = Brush.linearGradient(
                        *SUNPILLAR_COLOR_STOPS,
                        start = Offset(0f, sunpillarShiftY),
                        end = Offset(0f, sunpillarShiftY - sunpillarCycle),
                        tileMode = TileMode.Repeated
                    )

                    // ③ 오프스크린 레이어에서 포일 합성 후 마스킹
                    drawIntoCanvas { canvas ->
                        canvas.saveLayer(layerRect, layerPaint)

                        // 두 줄기 광선 + 무지개 색조(Hue)
                        drawRect(brush = forwardBeamBrush)
                        drawRect(brush = rainbowBrush, blendMode = BlendMode.Hue)
                        drawRect(brush = counterBeamBrush, blendMode = BlendMode.Softlight, alpha = 0.85f)

                        // 금속 호일 노이즈(Screen)
                        drawImage(grainBitmap, dstSize = dstSize, blendMode = BlendMode.Screen, alpha = 0.25f)

                        // 캐릭터 실루엣 마스킹(DstIn: 캐릭터를 뚫고 배경 포일만 남김)
                        drawImage(maskBitmap, dstSize = dstSize, blendMode = BlendMode.DstIn)

                        canvas.restore()
                    }
                }
            }
    )
}
```

---

## 5. 주의할 점 (성능 최적화)

Compose에서 부드러운 렌더링 성능을 유지하기 위한 최적화하가 중요합니다

* **리컴포지션 방지 (람다 기반 `graphicsLayer`)**
  * 틸트 각도는 초당 수십 번 변경됩니다. 상태를 Composable 상단에서 읽지 않고 `graphicsLayer { ... }` 및 `onDrawWithContent { ... }` 람다 블록 내부에서 읽어야 Composition 단계를 건너뛰고 GPU Drawing 단계에서만 빠르게 렌더링되어 프레임 드랍을 원천적으로 차단합니다.
* **비트맵 디코딩 중복 방지**
  * 카드, 마스크, 그레인 등의 비트맵 리소스는 매 프레임 호출되는 드로잉 루프 내부가 아닌 컴포저블 본문에서 로드(`ImageBitmap.imageResource`)하여 불필요한 I/O와 GC 부하를 방지합니다.
* **오프스크린 `saveLayer` 호출 최소화**
  * `saveLayer`는 임시 버퍼를 생성하므로 GPU 메모리 대역폭을 소모합니다. 포일 합성 및 마스킹 작업을 단일 `saveLayer` 블록 내에서 블렌드 모드 체인으로 처리하여 오프스크린 패스를 1회로 최소화해야 합니다.

---

## 6. 렌더링 방식별 비교 (Compose vs AGSL vs OpenGL)

본 글에서는 **Compose의 기본 그래픽 API**(`graphicsLayer`, `Brush`, `DrawScope`)를 활용해 카드 홀로그램 효과를 구현했습니다. 하지만 안드로이드 플랫폼에서는 프로젝트 타깃 환경, 최소 지원 SDK, 성능 요구 사항에 따라 **AGSL (Android Graphics Shading Language)**이나 **OpenGL ES**를 선택할 수도 있습니다. 

루기아 V 카드를 기준으로 세 가지 렌더링 엔진의 결과물과 기술적 특징을 비교하면 다음과 같습니다.

### ① 렌더링 결과물 비교

<div style="display: flex; gap: 8px; text-align: center;">
  <div style="flex: 1; min-width: 0;">
    <p style="font-weight: bold; margin-bottom: 6px;">Compose</p>
    {% include youtube.html id="8V4rvGXGALc" ratio="124.4%" %}
  </div>
  <div style="flex: 1; min-width: 0;">
    <p style="font-weight: bold; margin-bottom: 6px;">AGSL</p>
    {% include youtube.html id="NkA1gGg5MqA" ratio="124.4%" %}
  </div>
  <div style="flex: 1; min-width: 0;">
    <p style="font-weight: bold; margin-bottom: 6px;">OpenGL ES</p>
    {% include youtube.html id="RiyjKHSLRtE" ratio="124.4%" %}
  </div>
</div>

---

### ② 기술적 특징 및 장단점 비교

| 비교 항목 | Jetpack Compose (DrawScope) | AGSL (RuntimeShader) | OpenGL ES (GLSurfaceView) |
| :--- | :--- | :--- | :--- |
| **최소 지원 OS** | **Android 5.0 (API 21+)** | **Android 13 (API 33+)** | **Android 4.3+ (ES 3.0)** |
| **작성 언어** | Kotlin (100% 순수 코드) | Kotlin + AGSL (SkSL) | Kotlin + GLSL 3.0 |
| **렌더링 파이프라인** | Compose Canvas (`drawWithCache`) | Compose Canvas (`ShaderBrush`) | `GLSurfaceView` 전용 렌더 스레드 |
| **GPU 패스 방식** | 캔버스 다중 레이어 블렌딩 (Multi-pass) | 단일 프래그먼트 셰이더 (Single-pass) | 단일/멀티 패스 프래그먼트 셰이더 |
| **구현 난이도** | **낮음** (기존 Compose 지식 활용) | **보통** (셰이더 문법 학습 필요) | **높음** (EGL 수명주기, VBO/VAO 관리) |
| **Compose UI 통합성** | **완벽** (Modifier, 애니메이션, 클리핑 자연 연동) | **우수** (`ShaderBrush`로 인라인 결합) | **보통** (`AndroidView` 브릿징 필요) |
| **수학적 픽셀 연산 자유도** | 보통 (Compose Brush / Filter 조합) | **높음** (픽셀 단위 알고리즘 자유 구현) | **최상** (완전한 하드웨어 파이프라인 제어) |

## 7. 결론

카드 홀로그램의 핵심은 복잡한 수학 공식이 아니라, **반응하는 3D 틸트**와 **캐릭터를 돋보이게 하는 마스킹**, 그리고 **빛줄기가 교차하며 만들어내는 연출**에 있습니다.

Compose의 `graphicsLayer`와 `DrawScope` 블렌딩 API를 활용하면 셰이더 없이도 간단하면서도 인터랙티브 카드를 만들 수 있습니다.

---

## 참고 자료

- [Android Developers — Compose Graphics & Modifiers](https://developer.android.com/develop/ui/compose/graphics/draw/modifiers)
- [Android Developers — GraphicsLayer Documentation](https://developer.android.com/reference/kotlin/androidx/compose/ui/graphics/GraphicsLayerScope)
- [poke-holo by simeydotme](https://poke-holo.simey.me/)
