---
layout: post
title: "[번역] DroidKaigi 2016 ~ 카메라 어플 첫 걸음"
date: 2016-06-11 18:40:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [Camera 2 APIはじめの一歩](https://speakerdeck.com/mhidaka/camera-2-apihazimefalse-bu) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

DroidKaigi2016 카메라 어플 첫 걸음

## 2p

Camera2 API Overview

## 3p

**Camera2 API What's new?**

- Android 5.0부터 추가된 새로운 package
  - android.hardware.camera2
- Camera API를 대체하는 고성능 카메라 제어가 특징
  - Request나 Session 같은 새로운 개념

## 4p

**카메라 어플 첫 걸음**

- Session 대상자
  - Camera2 API를 다룬 적이 없는 사람
  - Camera1 API와의 차이를 알고 싶은 사람
- Session 목표
  - Camera2 API 개념을 이해
  - 샘플 코드를 스스로 읽고, 시행착오하면서 변경할 수 있도록

## 5p

**자기 소개**

- @mhidaka / 日高 正博
  - 엔지니어
  - Android 개발은 7년차
- TechBooster
  - 책을 만들거나 기술 잡지(동인지)를 발행하거나
  - techBooster.org

## 6p

**Target Platform Versions**

| Versions | Codename | API | Distribution |
| :- | :- | :- | :- |
| 2.2 | Froyo | 8 | 0.1% |
| 2.2.3 - 2.3.7 | Gingerbread | 10 | 2.7% |
| 4.0.3 - 4.0.4 | Ice Cream Sandwich | 15 | 2.5% |
| 4.1.x | Jelly Bean | 16 | 8.8% |
| 4.2.x | Jelly Bean | 17 | 11.7% |
| 4.3 | Jelly Bean | 18 | 3.4% |
| 4.4 | KitKat | 19 | 35.5% |
| 5.0 | Lollipop | 21 | 17.0% |
| 5.1 | Lollipop | 22 | 17.1% |
| 6.0 | Marshmallow | 23 | 1.2% |


2/19/2016 - Camera 2 API Covered : 35%

> [https://developer.android.com/about/dashboards/index.html?hl=ja](https://developer.android.com/about/dashboards/index.html?hl=ja)

## 7p

**Camera Use case**

- Android에서 카메라는 다음 같은 조합
  - Point & Shoot
  - DSLR
  - Effects
  - Innovations

## 8p

**FAQ**

- Camera1 API의 가치는 사라졌는가?
  - No, 이용가치는 아직 높다
  - 원숙한 API & 수많은 BAD 노하우
  - `This class was deprecated.`
- Camera2 API는 시기상조인가?
  - No, Camera1에서는 불가능한 것이 가능하다
  - 모던한 API, 높은 확장성

## 9p

**If You Build Camera App**

- 어플의 일부, Option으로서의 개발하는 경우
  - 공수는 그다지 들이고 싶지 않다
  - 주기능은 별도로 있다
- Camera2 API는 불필요
  - Intent에 의한 카메라 어플 연동
  - Google Play Services 7.9 - Mobile Version API (QR 코드)
  - 그래도 부족하면 Camera1 API를 이용

> [https://github.com/googlesamples/android-vision](https://github.com/googlesamples/android-vision)

## 10p

**If You Build Camera App**

- 어플의 주기능으로서 개발하는 경우
  - 일체화한 사용자 경험을 만들려고 한다
  - 장래적으로 확장을 시야에 넣는다
- Camera2 API를 사용 가능
  - Innovations 분야라면 적용 가능
  - 1년 후에는 Android 5.x이상이 70%로.
  - 즉 오늘의 지식은 이후 수년간 남아있다

## 11p

**Camera2 API Workflow**

## 12p

**Request에 의한 비동기 모델**

모덜리스 / 파이프라인 처리

| | 파이프라인 | |
| :-: | :-: | :-: |
| Request → | Request Queue → Camera Device → Image Buffer | → Surface |

## 13p

**Request에 의한 비동기 모델**

스트림을 은폐한 파이프라인 처리로 복수 요청 실행이 가능

| | 파이프라인 | |
| :-: | :-: | :-: |
| Request → | Request Queue → Camera Device → Image Buffer | → Surface |
| Request ↗ | Result | ↘ Surface |

## 14p

**Request와 Session**

Camera Device에 대해서 CaptureRequest와 Session을 발행. Request가 조작, Session이 조작 반영을 담당

| :- | :- |
| Request | 조작. 카메라 파라매터 설정 |
| Session | 실행단위. 복수 Request를 받음으로 동시처리가 가능 |
| Camera Devices | 처리. 결과는 Surface로 |

## 15p

**Request와 Session**

- Camera Preview의 경우
  - ※ Preview안의 정지 촬영은 일단 Preview를 멈춰서 실행한다

| :- | :- |
| Request | 조작. `Camera Preview 지정` |
| Session | 실행단위. 동시 Preview를 하기 위해서 Request `Repeat 실행` |
| Camera Devices | 처리. 결과는 TextureView로 |

## 16p

**Camera2 Advantage**

출력 Surface, ImageBuffter 설정에 따라 자유롭게 표현

- Preview 표시 : TextureView
- 녹화 : MediaRecorder
- 인코딩만 : MediaCodec
- YUV처리 : RenderScriptAllocation

## 17p

**기본적인 처리 순서**

1. 카메라 디바이스를 준비한다
2. 준비 완료 알림을 받는다
3. CaptureRequest를 준비한다
4. CaptureSession을 준비한다
5. Session 상태 알림을 받는다
6. CaptureRequest를 발행한다
7. 카메라 디바이스 사용을 완료한다

## 18p

How to Use

## 19p

**Camera2 Sample**

방금 공개했습니다!!

[https://github.com/mhidaka/Camera2App/](https://github.com/mhidaka/Camera2App/)

## 20p

**Camera2 API Classes**

- [CameraManager](https://developer.android.com/reference/android/hardware/camera2/CameraManager.html?hl=ja) : 카메라 시스템 서비스
- [CameraDevice](https://developer.android.com/reference/android/hardware/camera2/CameraDevice.html?hl=ja) : 카메라 제어
- [CaptureRequest](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest.html?hl=ja) : 이미지 취득 Request
- [CameraCaptureSession](https://developer.android.com/reference/android/hardware/camera2/CameraCaptureSession.html?hl=ja) : 이미지를 취득 · 처리하는 Session

## 21p

**기본적인 처리 순서**

1. 카메라 디바이스를 준비한다 > CameraManager#openCamera
2. 준비 완료 알림을 받는다 > CameraDevice.StateCallback
3. CaptureRequest를 준비한다 > CaptureRequest.Builder
4. CaptureSession을 준비한다 > CameraDevice.createCaptureSession
5. Session 상태 알림을 받는다 > CameraCaptureSession.StateCallback
6. CaptureRequest를 발행한다 > CameraCaptureSession#capture
7. 카메라 디바이스 사용을 완료한다 > CameraDevice#close

## 22p

**1. 카메라 디바이스를 준비한다**

동작 : TextureView에 Preview를 표시한다

CameraManager

| CameraManager의 주요 메서드 | 설명 |
| :- | :- |
| open | 카메라 사용 시작 |
| getCameraIdList | 카메라 리스트 취득 (id) |
| getCameraCharacteristics | 방향 등의 파라매터 |
| Close | 카메라 사용 종료 |

## 23p

```
private void openCamera(intwidth, intheight) {
  if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
    requestCameraPermission();
    return;
  }

  String cameraId= setUpCameraOutputs(width, height);
  CameraManager manager = (CameraManager) getSystemService(Context.CAMERA_SERVICE);
  try {
    if (!mCamera.isLocked()) {
      throw new RuntimeException( "Time out waiting to lock camera opening.");
    }
    manager.openCamera(cameraId, mCamera.stateCallback, mThread.getHandler());
  }

  …error handling…
}
```

## 24p

**View에 의존하는 처리**

- 표시 사이즈에 의존해서 카메라 출력의 가로세로비를 계산
  - 표시 사이즈는 화면 사이즈에 의존
  - 카메라 출력 사이즈가 디바이스마다 고유
  - 화면 회전, 다시 그릴때에 사이즈가 필요
- TextureView에 그리는 것은 ImageBuffter 경유로 실시
  - Camera2에서는 Stream으로 이미지를 처리 (File은 아니다)
- YUV 표색계로 하면 고속 (BurstCapture에서 뚜렷함)

## 25p

**2. 카메라 디바이스 상태변화를 얻는다**

비동기로 카메라 디바이스의 접속을 검출한다

CameraDevice.StateCallback 인터페이스

| StateCallback 인터페이스 | 설명 |
| :- | :- |
| onOpend | 카메라 디바이스와 접속이 완료 |
| onDisconnected | 카메라 디바이스와 접속이 끊어졌다 |
| onError | 회복 불능 상태 |

## 26p ~ 27p

```
public class BasicCamera{
  private Semaphore mCameraOpenCloseLock= new Semaphore(1);
  private CameraDevicemCameraDevice;
  ...생략...
  public final CameraDevice.StateCallbackstateCallback =
    new CameraDevice.StateCallback() {

    @Override
    public void onOpened(CameraDevicecameraDevice) {
      // 카메라가 사용가능 상태가 됨
      mCameraOpenCloseLock.release();
      mCameraDevice= cameraDevice;
      createCameraPreviewSession();
    }

    @Override
    public void onDisconnected(CameraDevicecameraDevice) {
      mCameraOpenCloseLock.release();
      cameraDevice.close();
      mCameraDevice= null;
    }

    @Override
    public void onError(CameraDevicecameraDevice, interror) {
      mCameraOpenCloseLock.release();
      cameraDevice.close();
      mCameraDevice= null;
      Log.e(TAG, "Camera StateCallbackonError: Please Reboot Android OS");
    }
};
```

## 28p

**3,4,5 Request와 Session을 사용**

| CameraRequest에 관한 주요 메서드 | 설명 |
| :- | :- |
| CameraDevice.createCaptureRequest | CaptureRequestBuild 취득 |
| CaptureRequest.Build.set | AF 등 촬영 내용 설정 |
| CaptureRequest.Build.build | CaptureRequest 생성 |

Request > Session > Camera Device

| CameraSession에 관한 주요 메서드 | 설명 |
| :- | :- |
| CameraDevice.creaeCaptureSession | CaptureSession 생성 |
| CameraCaptureSession.setRepeatingRequest | 요청의 반복 실행 (Preview 등)
| CameraCaptureSession.capture | 요청 실행 |

## 29p ~ 30p

```
mCameraDevice.createCaptureSession(Arrays.asList(surface, imageRenderSurface),
  new CameraCaptureSession.StateCallback() {

  @Override
  public void onConfigured(CameraCaptureSessioncameraCaptureSession) {
    // Preview 준비가 완료되었으므로 카메라의 AF, AE 제어를 지정한다
    mCaptureSession= cameraCaptureSession;
    try {
      // Preview가 흐릿해서는 안되므로 오토 포커스를 사용한다
      mPreviewRequestBuilder.set(CaptureRequest.CONTROL_AF_MODE,
        CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE);
      // 노출, 플래시는 자동 모드를 사용한다
      mPreviewRequestBuilder.set(CaptureRequest.CONTROL_AE_MODE,
        CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH);
      // 카메라 Preview를 시작한다 (여기에서는 시작 요청만)
      mPreviewRequest= mPreviewRequestBuilder.build();
      mCaptureSession.setRepeatingRequest(mPreviewRequest,
        mCaptureCallback, mInterface.getBackgroundHandler());
    } catch (CameraAccessExceptione) {
      e.printStackTrace();
    }
  }

  @Override
  public void onConfigureFailed(CameraCaptureSessioncameraCaptureSession) {
    Log.e(TAG, "CameraCaptureSessiononConfigureFailed");
  }
}, null
);
```

## 31p

**왜 이런 비동기 처리가 많은가**

- <del>너무 힘들다</del>
- 하드웨어 디바이스의 특성
  - 입력에 대한 응답까지의 시차가 무조건 있다
  - CameraManager#openCamera는 500ms단위로 처리 (높은 비용)
- 파이프라인 특성
  - 복수 Request를 파이프라인으로 처리하기 위해서는 단위성을 올린다
  - Result는 Request의 Queuing시에는 모르므로 (어쩔 수 없다)

## 32p

**6. CaptureRequest를 발행한다**

정지 이미지를 촬영한다

Camera Device > Image Buffer > File Save

- CameraCaptureSession.StateCallback
  - Session 상태 알림
- CameraCaptureSession.`CaptureCallback`
  - Session 처리 알림

## 33p

**CameraCaptureSession.CaptureCallback**

| CaptureCallback | 설명 |
| :- | :- |
| onCaptureProgressed | Session 요청 처리 결과 |
| onCaptrueCompleted | Capture (촬영) 완료 |

onCaptureProgressed 메서드는 Request 내용에 반응해서 여러 번 호출된다는 점에 주의

(CaptureRequest.Build.set을 파라매터마다 여러 번 지정 가능하므로)

## 34p

```
private CameraCaptureSession.CaptureCallbackmCaptureCallback
  = new CameraCaptureSession.CaptureCallback() {

  @Override
  public void onCaptureProgressed(CameraCaptureSessionsession,
    CaptureRequestrequest, CaptureResultpartialResult) {
    // Capture 진척상황 (즉시 호출된다)
    process(partialResult);
  }

  @Override
  public void onCaptureCompleted(CameraCaptureSessionsession,
    CaptureRequestrequest, TotalCaptureResultresult) {
    // Capture 완료 (Preview의 경우, Preview 상태가 지속）
    process(result);
  }
}
```

## 35p

**카메라로 촬영한다는 것은**

일본어 표현

「Preview 중에 사진 촬영 버튼을 눌렀으니 오토 포커스를 맞춘다. 포커스가 맞을 때에 사진의 밝기 (노출)가 적절한 순간에 정지 영상을 취득해서 촬영이 완료되면 이미지를 Preview 안으로 돌아간다. 그때 포커스 락을 해제하는 것을 잊지 말자」

를 「촬영한다」의 한마디로 표현 가능한 일본어가 무섭다

## 36p

**프로그램 표현**

```
STATE_PREVIEW
↓
↓ Request: CONTROL_AF_TRIGGER_START
↓
STATE_WAITING_LOCK
↓
↓ AF가 적절한 경우, 촬영한다
↓ Request: CONTROL_AF_MODE_CONTINUOUS_PICTURE, CONTROL_AE_MODE_ON_AUTO_FLASH, TEMPLATE_STILL_CAPTURE
↓
STATEU_PICTURE_TAKEN

STATE_WAITING_LOCK
↓
↓ AE (자동노출)의 조정이 필요
↓ Request: CONTROL_AE_PRECAPTURE_TRIGGER_START
↓
STATE_WAITING_PRECAPTURE
↓
STATE_WAITING_NONPRECAPTURE
↓
STATEU_PICTURE_TAKEN

STATEU_PICTURE_TAKEN
↓
↓ Preview를 재시작
↓ Request: CONTROL_AF_TRIGGER_CANCEL, TEMPLATE_PREVIEW
↓
STATE_PREVIEW
```

## 37p

일본어 표현

「`Preview 중에 사진 촬영 버튼을 눌렀으니 오토 포커스를 맞춘다. 포커스가 맞을 때에 사진의 밝기 (노출)가 적절한 순간에 정지 영상을 취득`해서 촬영이 완료되면 이미지를 Preview 안으로 돌아간다. 그때 포커스 락을 해제하는 것을 잊지 말자」

## 38p ~ 39p

```
private void process(CaptureResultresult) {
  switch (mState) {
    case STATE_PREVIEW: {  // Preview내에 아무것도 하지 않는다
      break;
    }
    case STATE_WAITING_LOCK: { // 조점이 맞을때에 정지 영상을 촬영한다 (AF)
      Integer afState= result.get(CaptureResult.CONTROL_AF_STATE);
      if (afState== null) {
        captureStillPicture();
      } else if (CaptureResult.CONTROL_AF_STATE_FOCUSED_LOCKED== afState ||
        CaptureResult.CONTROL_AF_STATE_NOT_FOCUSED_LOCKED== afState) {
          // CONTROL_AE_STATE가 null인 디바이스가 있다
          Integer aeState= result.get(CaptureResult.CONTROL_AE_STATE);
          if (aeState== null ||  aeState== CaptureResult.CONTROL_AE_STATE_CONVERGED) {
            mState= STATE_PICTURE_TAKEN; captureStillPicture();
          }
...省略...

private void captureStillPicture() {
  try {
    // 정지 영상 촬영을 시작한다
    final CaptureRequest.BuildercaptureBuilder = mCameraDevice.
      createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE);
    captureBuilder.addTarget(mInterface.getImageRenderSurface());

    // 정지 영상 촬영 모드를 지정 (AF,AE)
    captureBuilder.set(CaptureRequest.CONTROL_AF_MODE,
      CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE);
    captureBuilder.set(CaptureRequest.CONTROL_AE_MODE,
      CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH);

    // 현재 카메라 방향을 지정한다 (0~270도)
    introtation = mInterface.getRotation();
    captureBuilder.set(CaptureRequest.JPEG_ORIENTATION,
      ORIENTATIONS.get(rotation));
```

## 40p

**카메라 촬영 조건**

카메라에는 어떻게 하더라도 「오토 포커스가 안맞는다」등 어려운 대상물이 있다. 핀이 안맞는 이미지가 촬영되었을 때는 슬프지만, 촬영 불가능한 상황이 가장 경험을 해친다

그러므로, 어떤 상황이라도 촬영할 수 있다는 것(우선 찍는다)이 카메라로서 쓰기 위해서는 중요한 것이다.

## 41p

일본어 표현

「Preview 중에 사진 촬영 버튼을 눌렀으니 오토 포커스를 맞춘다. 포커스가 맞을때에 사진의 밝기 (노출)가 적절한 순간에 정지 영상을 취득`해서 촬영이 완료되면 이미지를 Preview 안으로 돌아간다. 그때 포커스 락을 해제하는 것을 잊지 말자`」

## 42p ~ 43p

```
private void captureStillPicture() {
  try {
    ...이전 리스트부터 계속... CameraCaptureSession.CaptureCallbackCaptureCallback
      = new CameraCaptureSession.CaptureCallback() {
      @Override
      public void onCaptureCompleted(CameraCaptureSessionsession,
        CaptureRequestrequest, TotalCaptureResultresult) {
        // 정지 영상 촬영이 완료될 때에 호출되는 콜백
        Log.e(TAG, "onCaptureCompletedPicture Saved");
        // Preview용 설정으로 복원
        unlockFocus();
      }
    };
    mCaptureSession.stopRepeating(); // Preview를 일단 정지한다
    // 정지 영상 이미지를 촬영한다 (captureBuilder)
    mCaptureSession.capture(captureBuilder.build(), CaptureCallback, null);
}

private void unlockFocus() {
  try {
    // AF Lock을 해제한다 (Trigger를 취소한다)
    mPreviewRequestBuilder.set(CaptureRequest.CONTROL_AF_TRIGGER,
      CameraMetadata.CONTROL_AF_TRIGGER_CANCEL);
    mPreviewRequestBuilder.set(CaptureRequest.CONTROL_AE_MODE,
      CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH);
    // AF 트리거의 취소를 실행한다
    mCaptureSession.capture(mPreviewRequestBuilder.build(),
      mCaptureCallback, mInterface.getBackgroundHandler());
    // Preview를 유지하기위해 setRepeatingRequest 함수를 실행한다
    mState= STATE_PREVIEW;
    mCaptureSession.setRepeatingRequest(mPreviewRequest, mCaptureCallback,
      mInterface.getBackgroundHandler());
  } catch (CameraAccessExceptione) {
    e.printStackTrace();
  }
}
```

## 44p

**Camera2 API, 복잡하지 않나요?**

틀림없이 어렵다. 하지만, 자유도가 무척 높다. 카메라의 스테이트 머신은 어플의 기능 요건에 의존이 높고, 성질이 특이. 제대로 쓰기 위해서는 카메라의 지식이 필요.

어플에서 맞추기 위해서는 카메라 제어 (비동기 처리)라는 스테이트 머신을 강하게 결합되는 케이스가 많아져 복잡도가 급속하게 늘어난다.

이것은 설계로 회피 가능한 문제이기도 하다 (설명으로 사용한 샘플에서는 스테이트 머신과 Camera2 API의 구현을 다른 클래스로 나누었다. Google의 Camera2Basic은 강하게 결합되어 있다)

## 45p

Abyss of Camera2

## 46p

<img src="https://source.android.com/devices/camera/images/ape_fwk_camera.png" />

- 어플리케이션 계층
- 레이어간은 모듈마다 인터페이스를 사용, 유연한 결합
- 하드웨어 계층

> [https://source.android.com/devices/camera/index.html](https://source.android.com/devices/camera/index.html)

## 47p

**Camera HAL3 Overview**

<img src="https://source.android.com/devices/camera/images/camera_block.png" />

METADATA를 제어할 수 있다는 것이 Camera2 의의

METADATA : 색 공간이나 휘도 등 카메라의 파라매터

> [https://source.android.com/devices/camera/camera3.html](https://source.android.com/devices/camera/camera3.html)

## 48p

**HAL subsystem**

<img src="https://source.android.com/devices/camera/images/camera_model.png" />

- 하드웨어를 추상화
  - 렌즈, 센서 플래시
  - 동작 모드
  - YUV 변환

> [https://source.android.com/devices/camera/camera3_requests_hal.html](https://source.android.com/devices/camera/camera3_requests_hal.html)

## 49p

**Tips**

- 3A Modes
  - AF,AE,AW 설정에 대한 것
  - 카메라 디바이스 기동시는 오토 포커스, 자동 노출, 화이트 밸런스 어느 것이라도 "STATE_INACTIVE"
- CTS requirements
  - Android 5.0 and later devices `must pass both` Camera API1 CTS and Camera API2 CTS. And as always, devices are required to pass the CTS Verifier camera tests.

## 50p

정리

## 51p

**정리**

- Camera2 API는 이후의 주류
- 많은 개발자는 카메라의 내부를 만들려는 것이 아니라 카메라를 사용해서 새로운 경험을 만들고 싶다
  - 간단함을 추구하면 Camera1 API 형태에 자리 잡는다
  - 손이 가는 부분을 샘플로 정리해서 공개, 아마도 누군가가 좋은 추상화 구현이 만들어질 것이라고 기대한다
- Camera2 API는 Camera1 API의 rebase, rebuild
  - 최근 Android API (MediaCodec, BLE, NFC 등)는 내부 구조를 깊게 접근 가능하게 되어 그 흐름에서는 자연스럽다
- 카메라라는 말에는 사람을 끌어당기는 늪 같은것이 있다.
