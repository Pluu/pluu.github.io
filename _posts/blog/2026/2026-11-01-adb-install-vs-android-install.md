---
layout: post
title: "[메모] adb install vs android install 차이점 분석 및 비교"
date: 2026-11-01 18:00:00 +09:00
tag: [Android, AndroidCLI]
categories:
- blog
- Android
---

Android CLI의 `android install`은 단순한 `adb install`의 래퍼(Wrapper)가 아닙니다. 소스 빌드 연동 기능과 함께, 변경된 바이트만 전송하는 **증분 설치(Delta Install)**를 기본값으로 사용합니다.

두 도구의 내부 동작 차이를 분석하고, 로컬 에뮬레이터와 네트워크 대역폭 제한 환경에서 설치 속도를 비교했습니다.

<!--more-->

> 본 글은 Gemini를 사용하여 초안을 작성한 후 검수하였습니다.

- - -

본 글에서 사용된 도구 버전 및 환경(2026년 10월 31일 기준)은 다음과 같습니다.

- Android CLI: 1.1.16717390
- Android Debug Bridge (adb): 1.0.41 (platform-tools 37.0.1-15733141)
- Android Gradle Plugin (AGP): 9.5.0
- Kotlin: 2.4.21
- Target Device: Android Virtual Device (Pixel 9a, API 37, arm64-v8a)

---

## 1. 핵심 차이점 한눈에 보기

| 비교 항목 | adb install | android install |
|---|---|---|
| 도구 성격 | Low-level 범용 기기 통신 도구 (`platform-tools`) | High-level Android 개발자/에이전트 워크플로 CLI |
| 입력 형태 | 로컬 APK 파일 경로만 지원 | 로컬 APK 경로뿐만 아니라 빌드 참조 ([system://][path]?[target]) 지원 |
| 빌드 연동 | 불가 (사전에 빌드 완료된 APK 필요) | 소스 빌드와 배포를 한 번에 연동 가능 (-- <build_args>) |
| 증분 설치 (Delta) | `--fastdeploy` 옵션 필요 (별도 agent) | `--use-delta-install` 기본 활성화 (default: true) |
| 전송 최적화 | Streaming Install 지원 (`--streaming`) | 변경된 delta 패치 파일만 기기로 전송 (Zero-copy 활용) |
| 다중 APK 지원 | install-multiple, install-multi-package 분리 | --apks=a.apk,b.apk 로 단순화 |
| 실행 연계 | 설치만 수행 | 설치만 수행 (`android run` 시 설치 후 launch까지 연동) |

### (1) 소스 빌드 참조(Build Reference) 지원
`adb install`은 오직 디스크에 존재하는 `.apk` 파일만을 대상으로 동작합니다.
반면 `android install`은 Android CLI 1.1부터 **빌드 참조 문법**을 직접 인식합니다.

```bash
# 로컬 APK 파일 설치
android install --apks=app/build/outputs/apk/debug/app-debug.apk

# Gradle 프로젝트 빌드 후 설치까지 한 번에 수행
android install :app
android install ~/MyProject?:app@debug -- --offline
```

빌드 타깃을 지정하면 CLI가 프로젝트 구조를 분석해 빌드를 실행하고, 생성된 APK를 찾아 기기에 바로 설치합니다.

### (2) 기본 Delta Install (증분 패치) 지원
`android install`은 증분 설치 옵션(`--use-delta-install`)을 기본값(true)으로 사용합니다.

기기에 이전 버전의 앱이 이미 설치되어 있다면, APK 전체를 보내지 않고 로컬 APK와 기기 설치본의 차이(Delta)만 계산해 패치 파일(`.seq`)을 전송합니다.

기기의 임시 디렉터리(/data/local/tmp)에 배포 에이전트(`installer.jar`)를 올려 커널의 Zero-copy 시스템 콜로 패치를 적용한 뒤 Package Manager에 반영합니다.

## 2. 벤치마크 환경 구성

두 도구의 설치 소요 시간과 Delta Install의 데이터 전송 절감량을 확인하기 위해 아래 시나리오별로 테스트를 진행했습니다.

### 테스트 시나리오
APK 내 특정 영역만 변경되는 상황을 시뮬레이션하기 위해 4종류의 APK 변형(Variant)을 생성했습니다.

1. fresh: 앱을 완전히 삭제(`uninstall`)한 상태에서 최초 설치
2. same: 동일한 APK를 덮어쓰기 재설치
3. code: Kotlin 코드 상수만 변경 (`classes*.dex`만 변경)
4. res: 문자열 리소스만 변경 (`resources.arsc`만 변경)
5. asset: 에셋 파일 1개만 변경 (`assets/marker.txt`만 변경)

또한 APK 크기에 따른 전송 대역폭 영향을 보기 위해 두 가지 크기로 측정했습니다.
- 기본 Compose 앱: 약 11~12MB
- 대용량 리소스 포함 앱: 약 52MB (비압축 40MB 더미 페이로드 포함)

## 3. 결과 비교

### 1) 로컬 에뮬레이터 환경

로컬 에뮬레이터는 호스트 메모리 버퍼를 통해 데이터를 전달하므로 네트워크 전송 병목이 없습니다. 5회 반복 측정 후 중앙값 기준입니다.

#### ① 기본 Compose 앱 (약 11~12MB)

| 시나리오 | adb install -r | android install (기본 delta) | android install (delta OFF) |
|---|---:|---:|---:|
| fresh | 0.26s | 1.17s | 1.13s |
| same | 0.32s | 1.01s | 1.03s |
| code | 0.32s | 1.01s | 1.07s |
| res | 0.36s | 1.04s | 1.05s |
| asset | 0.33s | 1.06s | 1.03s |

#### ② 52MB 앱 (대용량 에셋 포함)

| 시나리오 | adb install -r | android install (기본 delta) | android install (delta OFF) |
|---|---:|---:|---:|
| fresh | 0.46s | 1.50s | 1.22s |
| same | 0.57s | 1.54s | 1.30s |
| code | 0.52s | 1.47s | 1.24s |
| res | 0.48s | 1.42s | 1.28s |
| asset | 0.52s | 1.38s | 1.28s |

### 결과 분석
로컬 에뮬레이터에서는 `adb install -r`이 더 빠릅니다.
- Android CLI 자체를 기동하는 데 약 0.45초의 기본 오버헤드가 발생합니다.
- 전송 지연이 없는 환경에서는 50MB 전체를 전송하더라도 0.5초 안에 끝나므로, 차이점(Delta)을 계산하고 기기에서 패치 에이전트를 구동하는 시간이 전송 절약 시간보다 더 깁니다.

### 2) 실기기 / Wi-Fi 디버깅 환경 (5 MB/s 대역폭 제한)

실제 개발 환경에서는 Wi-Fi 페어링 무선 디버깅이나 USB 2.0 케이블 연결처럼 **전송 대역폭이 제한되는 환경**이 많습니다. 이를 재현하기 위해 에뮬레이터 포트 앞에 5 MB/s 전송 속도 제한 프록시를 두고 재측정했습니다.

> ※ 배수 비교는 `adb install -r` 대비 `android install`의 소요 시간 기준이며, 절감율은 전체 APK 크기 대비 실제 전송된 패치 크기 기준입니다.

#### ① 52MB 앱 (대역폭 5 MB/s)

| 시나리오 | adb install -r | android install (Delta ON) | 절감율 / 전송량 |
|---|---:|---:|---|
| fresh | 10.41s | 11.63s | 전체 전송 (51.80 MB) |
| same | 10.44s | 1.52s (adb 대비 약 6.8배 빠름) | 554 KB 전송 (98.9% 절감) |
| code | 10.44s | 1.45s (adb 대비 약 7.2배 빠름) | 584 KB 전송 (98.9% 절감) |
| res | 10.53s | 1.68s (adb 대비 약 6.3배 빠름) | 1.46 MB 전송 (97.2% 절감) |
| asset | 10.52s | 1.63s (adb 대비 약 6.4배 빠름) | 1.46 MB 전송 (97.2% 절감) |

#### ② 11~12MB 기본 앱 (대역폭 5 MB/s)

| 시나리오 | adb install -r | android install (Delta ON) | 절감율 / 전송량 |
|---|---:|---:|---|
| fresh | 2.30s | 3.48s | 전체 전송 (11.33 MB) |
| same | 2.31s | 1.28s (adb 대비 약 1.8배 빠름) | 89 KB 전송 (99.2% 절감) |
| code | 2.32s | 1.29s (adb 대비 약 1.8배 빠름) | 140 KB 전송 (98.8% 절감) |
| res | 2.40s | 1.54s (adb 대비 약 1.6배 빠름) | 1.02 MB 전송 (91.4% 절감) |
| asset | 2.40s | 1.49s (adb 대비 약 1.6배 빠름) | 1.02 MB 전송 (91.4% 절감) |

### 결과 분석
전송 속도가 제한되는 네트워크나 USB 환경에서는 `android install`이 훨씬 빠릅니다.
- `adb install -r`은 변경된 내용이 적더라도 52MB 전체를 스트리밍 전송하므로 매번 **10초 이상(10.44s~10.53s)** 걸립니다.
- 반면 `android install`은 **584KB 패치 파일만 전송(전송량 98.9% 절감)**하므로 전송 시간을 0.1초대로 줄여 전체 설치를 **1.45초(약 7.2배 빠름)**에 마칩니다.

## 4. "adb --fastdeploy"와의 차이

`adb install`에도 `--fastdeploy` 옵션이 있지만, 아래 경고를 출력하며 일반 전체 설치로 전환될 수도 있습니다.

> Fast Deploy is only compatible with devices of API version 24 or higher, ignoring.

반면 `android install`의 Delta Install은 Android Studio 배포 시스템(Deployer)의 기술을 CLI에 적용해 최신 OS에서도 정상적으로 패치 설치를 수행합니다.

## 5. 요약 및 상황별 추천

1. `android install`을 써야 하는 경우
   - 실기기 디버깅(특히 Wi-Fi 무선 디버깅): 코드나 리소스 일부만 수정하고 재설치할 때 전송 시간이 대폭 줄어듭니다.
   - 대용량 프로젝트: APK 크기가 클수록 Delta 패치 전송의 절약 효과가 큽니다.
   - 빌드와 배포 연동: `:app` 같은 타깃 참조를 넘겨 빌드와 설치를 명령어 하나로 실행할 때 적합합니다.

2. `adb install`을 써야 하는 경우
   - 로컬 에뮬레이터 반복 테스트: 전송 병목이 없어 CLI 기동 오버헤드가 없는 `adb`가 0.2초대로 가장 빠릅니다.
   - 가벼운 CI/CD 파이프라인: 별도의 Android CLI 스택 없이 `platform-tools`만 설치된 환경에서 배포할 때 유리합니다.
   - 세부 설치 옵션 제어: `--instant`, `--abi`, 다중 패키지 원자적 설치 등 저수준 Package Manager 옵션이 필요할 때 사용합니다.
