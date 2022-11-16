---
layout: post
title: "[요약] Building a scalable, modularized, testable app from scratch"
date: 2022-11-16 22:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
- AndroidDevSummit
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/qX6zmKY4KP0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

개요 : 확장 가능하고 모듈화되고 테스트할 수 있는 앱을 처음부터 빌드하는 방법을 소개

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/001.png" }}" />

확장성을 위한 설계

- 아키텍처
- 모듈화 : 책임을 분리
- 테스트 : 테스트 인프라를 만들어 앱이 예상대로 동작하는지 확인
- UI 디자인 : 유연하고 직관적이며 멋진 사용자 인터페이스를 구축

> 세션 예제로 [Now in Android](goo.gle/nia)를 사용한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/002.png" }}" />

아키텍처는 UI와 데이터, 크게 두 계층으로 나눌 수 있다..

- 데이터 계층 : 비즈니스 로직 수행, UI 계층에 데이터를 전달
- UI 계층 : 화면에 앱 데이터를 표시, 데이터의 변경 사항에 `반응`

새 데이터가 도착할 때 업데이트 방법만 알려주면 된다. **UI가 직접 데이터 요청/가져오지 않으며** 데이터만 수집한다.

UI에서 Data로 발생하는 유일한 통신은 이벤트이다.

데이터 계층은 이벤트를 처리하여 데이터를 업데이트한 후 UI에 대한 변경 사항은 생략한다.

--> 이것으로 앱 데이터에 대한 `단일 정보 소스`를 가질 수 있고, 데이터는 한 방향으로만 흐른다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/003.png" }}" />

데이터 계층

- 북마크를 저장하고 스트림을 발행하여 UI 계층에 노출해야 한다 -> Kotlin Flow 사용 가능

UI 계층

- 정보를 표시하고 변경될 때마다 업데이트한다
- 사용자가 북마크를 추가/제거할 방법을 제공한다
- 사용자 이벤트는 데이터를 업데이트할 수 있도록 데이터 계층에 다시 전달한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/004.png" }}" />

데이터 계층은 두 가지의 구성 요소로 나눌 수 있다.

- Repository : 앱 데이터와 데이터에 대한 변경 사항을 노출한다
- Data Source : 단일 소스에서 데이터를 가져온다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/005.png" }}" />

- LocalDataSource 클래스는 Jetpack DataStore를 사용하여 북마크를 저장한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/006.png" }}" />

- LocalDataSource는 DataStore를 종속성으로 주입받고, bookmarkStream 변수에 북마크 스트림을 노출한다
- DataStore에서 제공하는 데이터 스트림을 사용해 북마크 목록으로 변환

중요한 것은 DataStore에서 직접 데이터를 가져오지 않는다는 개념이다.

- 여기서는 데이터 스트림을 설정, 스트림의 각 항목을 문자열 목록으로 매핑만 한다.

toggleBookmark 함수를 통해 북마크 추가/제거하는 기능을 제공

- 북마크가 변경될 때마다 새로운 북마크 목록이 bookmarkStream을 통해서 내보내 진다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/007.png" }}" />

BookmarkRepository 코드는 

- LocalDataSource를 종속성으로 사용하고 북마크 스트림을 노출하며 북마크를 On/Off할 수 있다.
- 여러 DataSource의 데이터 결합과 같은 복잡한 작업을 수행할 수 있다.
  - 오프라인 우선 기능 : 네트워크 데이터 원본을 가져온 후 로컬 데이터 원본과 동기화

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/008.png" }}" />

- 다른 기능들도 거의 방식으로 구현할 수 있다.
  - 데이터를 로컬에 저장하지 않고 네트워크로부터 가져오는 방법이다
- **앱의 각 데이터 유형에 대한 리포지토리를 갖는 것이 좋다.**

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/009.png" }}" />

- State holder : UI 로직 처리, 앱 데이터로 UI 상태 구성. 데이터 계층의 변경 사항을 수신하여 수행
- Screen : UI 요소를 사용하여 해당 UI 상태를 표시

### State holder

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/010.png" }}" />

- ViewModel은 뉴스/북마크 Repository에서 데이터를 결합하여 UI 상태를 생성

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/011.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/012.png" }}" />

- ViewModel은 2개의 Repository를 결합하여 SaveableNewsResources 목록을 만든다
- 각 항목에 뉴스 리소스와 북마크 저장 여부가 포함된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/013.png" }}" />

구현에 필요한 모델 코드는 간단하다

- NewsResource : 뉴스 기사에 대한 필드
- SavableNewsResource : NewsResource의 래퍼일 뿐이며 해당 뉴스 리소스가 북마크에 추가되었는지 여부도 포함

결합한 데이터를 나타내기 위해 UI 레이어에서 사용된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/014.png" }}" />

- 2개의 Repository를 결합하는 `combine` 함수를 사용하여 Flow를 만든다
- 두 스트림 중 하나에서 데이터가 변경될 때마다 최신 NewsResources/북마크와 함께 변환 기능이 호출된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/015.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/016.png" }}" />

- 데이터가 결합되면 ViewModel은 이를 UI State로 변환해야 한다.
- 상태는 Loading 혹은 Success 두 가지 중 하나일 수 있다.
  - Loading : 데이터가 처음 로드될 때 사용. 네트워크를 통해 로드될 때 사용
  - Success : 데이터가 성공적으로 로드되었을 때 사용. UI가 데이터를 표시할 수 있도록 내용이 포함되어 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/017.png" }}" />

- UI 상태를 나타내기 위해 sealed interface 사용
  - Loading : 단순한 object 객체일 뿐
  - Success : 저장 가능한 뉴스 목록을 보유
- ViewModel에서 Ui 상태를 StateFlow로 노출하는 변수를 만든다
  - 결합한 데이터 Flow를 StateFlow로 변환하기 위해 stateIn을 사용
  - CoroutineScope 범위와 초깃값 지정이 필요
  - started로 최소 하나의 Collector가 있는 경우에만 Flow가 활성화되도록 한다. 자원 낭비를 방지
    - 화면 회전과 같이 일시적으로 Collector가 사라진 경우를 대비하여 Flow 중지까지 5초를 기다린다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/018.png" }}" />

- 북마크를 저장/저장 해제하려는 UI 요청을 처리하는 함수를 구현
- ViewModel 이점 : Configuration 변경 후에도 유지된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/019.png" }}" />

- ViewModel에서 UI 상태를 읽고 UI 요소를 사용하여 렌더링 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/020.png" }}" />

- 만들어야 할 디자인 컨셉의 모습

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/021.png" }}" />

NewsResourceCard에 대한 Composable 함수 생성

- 뉴스 리소스, 북마크 여부, 사용자가 북마크 버튼을 탭 할 때 호출한 람다를 사용
- Column에는 제목, 콘텐츠, 북마크 버튼에 대한 UI 컴포넌트를 포함
- 북마크 버튼을 클릭하면 onToggleBookmark를 호출

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/022.png" }}" />

NewsFeed라는 뉴스 리소스 카드 목록을 표시하는 Composable

- 단순히 열을 만들고 요소를 반복하여 각 요소에 대한 뉴스 리소스 카드를 렌더링

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/023.png" }}" />

- `Preview` Annotation을 사용하여 Android Studiod에서 Composable을 미리 볼 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/024.png" }}" />

ForYouScreen Composable 함수에서는

- UI 상태가 Loading 중이면, 텍스트 **Loading**만 표시
- Success이면 UIState에서 뉴스 리소스를 가져와서 NewsFeed에 전달

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/025.png" }}" />

- ViewModel을 얻는 ForYouScreen의 `Stateful 버전`을 만들 수 있다.
- 리소스 낭비를 방지하고자 앱이 Foreground에 있을 때만 스트림에서 수집하기 위해 `collectAsStateWithLifecycle`을 사용
- UiState가 변경되면 Composable 함수가 `재구성`된다.
- `Stateless`한 ForYouScreen에 UiState와 북마크 이벤트에 대한 참조를 전달하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/026.png" }}" />

App에서는 여전히 Activity가 필요하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/027.png" }}" />

- App Module에 코드를 전부 위치하는 것이 아니라, 각각의 고유한 책임 집합에 대한 Module을 생성하여 확장할 수 있다.
- Module은 또한 병렬 작업 가능하여 잠재적으로 빌드 시간을 줄일 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/028.png" }}" />

- **Now in Android**에서 사용하는 모듈화 전략
- 모듈화
  - app 모듈 : feature을 결합하는 역할
  - feature 모듈 : 콘텐츠 제공과 같은 사용자와의 대면 책임의 단일 영역으로 범위가 지정
    - feature 모듈 간의 의존은 하지 않으며, core 모듈을 의존
  - core 모듈 : 앱 전체에서 사용되는 공통 라이브러리 모듈. 단일 책임 영역
    - Repositories => Data 모듈
    - 네트워킹 코드 => Network 모듈

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/029.png" }}" />

- 각 Class마다 어느 모듈에 위치할지의 소개

### 중복된 Build 내용 및 정의 해결

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/030.png" }}" />

- 모듈화의 일반적인 문제는 빌드 파일에 많은 중복 종속성 및 코드가 있다는 것이다.
- Now in Android 예제에서는 convention plugins을 사용하여 해결했다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/031.png" }}" />

- 공통 옵션과 종속성을 플러그인으로 이동한 다음, 필요한 모듈에 해당 플러그인을 포함하는 것이다.
- 모든 구성이 한 곳에서 유지되고 쉽게 업데이트할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/032.png" }}" />

- 플러그인과 지원 코드는 다른 모듈보다 먼저 빌드되는 별도의 빌드 로직 모듈에 포함된다.

### 라이브러리 버전 추적

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/033.png" }}" />

- 여러 Gradle 파일이 흩어져 있는 경우 Version Catalog로 라이브러리 버전 정보를 추적할 수 있다.
- Version Catalog는 라이브러리 목록이 포함된 단일 파일이다
- 라이브러리에 Gradle 구성 파일에서 참조할 수 있는 고유한 ID가 있다.
- 라이브러리 업데이트 시 Version Catalog에서 해당 내용을 업데이트하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/034.png" }}" />

> Now in Android용 모듈 그래프

- 생성할 Class와 저장할 모듈을 알고 있다
- 의도한 대로 작동하는지 여부는 불확실

## Tests verify behaviour

실제로 생성해야 하는 클래스에 대한 명확한 아이디어가 있는 경우 테스트를 먼저 작성하는 것이 훨씬 좋다.

테스트에 필요한 이론은 [Fundamentals of testing Android apps](goo.gle/android-testing-intro)에서 확인할 수 있다.

### Unit Test

로직이 있는 모든 곳에 테스트를 추가해야 하며, 그 중 하나가 ViewModel이다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/035.png" }}" />

- 2개의 Stream 데이터를 결합하여 UI 상태로 변환하는 동작 확인을 테스트로 작성할 수 있다.
- 테스트를 작성할 때 가장 먼저 해야 할 일은 테스트 대상을 종속성(이 경우 리포지토리)에서 격리하는 것이다.
- 네트워크 및 로컬 스토리지에서 데이터를 가져오는 것과 같이 작업할 실제 리포지토리를 사용하는 대신 테스트 더블이라고도 하는 테스트 종속성을 만들어야 한다.
- ViewModel이 구체적인 클래스에 의존하지 않고, 테스트 대상이 의존할 수 있는 인터페이스로 연결해야 한다.
- 테스트할 때 제공할 테스트 클래스를 만들 수 있다. (ex: TestNewsRepository, TestBookmarksRepository)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/036.png" }}" />

- Coroutine Dispatcher를 TestDispatcher로 설정하는 Rule을 만든다.
  - 모든 Coroutine이 테스트 내에서 순차적으로 실행되며 Flow를 테스트할 때 필수이다.
- 테스트 종속성으로 생성한 인스턴스를 사용해서 ViewModel이 올바른 UI 상태를 생성하는지 확인하는 테스트를 작성할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/037.png" }}" />

- Test 함수의 ViewModel에서 Flow 데이터 수집을 시작한다.
- `launch`없이는 어떤 값도 Flow로 내보낼 수 없다.
- Test Repository에 테스트용 데이터를 전달하고 UI 상태를 얻고 성공 여부 및 올바른 NewResource가 북마크 되었는지 확인하면 된다.
- 마지막으로 CollectJob을 취소한다. 만약 취소하지 않으면 테스트가 무기한 실행된다.
- 로컬에서 실행되는 단위 테스트이므로 기능 모듈의 Test 폴더에 저장한다.

### UI Test

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/038.png" }}" />

UI 테스트는 선택하여 작성할 수 있다.

- Roboelectric과 같은 테스트 프레임워크를 사용하여 직접 UI 테스트를 실행할 수 있다.
  - 로컬 테스트라고 하며 이전 테스트와 동일한 위치에 저장한다.
- 계측 테스트라고 하는 Android 기기/에뮬레이터에서 실행할 수 있다.

로컬 테스트는 더 빠르지만, 계측 테스트보다 정확도가 떨어진다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/039.png" }}" />

- Composable을 제어할 수 있는 JUnit Rule을 추가한다.
- `rule#setContent` 메서드를 사용하면 Composable을 제공하고, Activity에서 작동하는 것과 같은 방식으로 화면에 렌더링 할 수 있다.
  - ForYouScreen을 만들면서 데이터와 관련 리소스를 전달한다
- Stateless Screen Composable을 사용하면 테스트하기가 쉽다는 이점이 있다.
- `onNodeWithText` Matcher를 사용하여 NewsResource 제목이 있는 노드를 찾고 존재하는지 확인할 수 있다.
- 계측 테스트이므로 Android Test 폴더에 저장한다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/040.png" }}" />

- 앱의 테마 색상을 정의할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/041.png" }}" />

- 다음으로 Light/Dark 모드에 대한 Color Scheme를 정의한다
- Material 3은 각 색상에 해당 색상이 사용되어야 하는 컨텍스트를 설명하는 의미론적 이름을 부여한다.
  - Primary Color 위에는 onPrimary 색상이 사용된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/042.png" }}" />

- 텍스트 스타일 정의를 위해 Typography 클래스를 만들 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/043.png" }}" />

- 앱의 모든 콘텐츠를 래핑하는 Composable Theme를 만들 수 있다.
- 먼저 Device의 다크 모드 여부에 따라서 사용할 Color Scheme를 정한다
- 그 다음, Color Scheme와 Typography를 기반으로 Material Theme를 만든다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/044.png" }}" />

- 테마를 사용하려면 Theme Composable에 콘텐츠를 래핑하면 된다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/045.png" }}" />

- 예로써 Composable 미리보기에서테마에서 정의한 색상을 사용되고 있다
- 텍스트 정의마다 다른 텍스트 스타일을 지정할 수 있다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/046.png" }}" />

- Material Design components의 장점 중 하나는 커스텀 가능하도록 설계되었다는 것이다.
- 좋은 사례로 Toggle 버튼 클래스는 Material Icon 버튼을 래핑하여 On일 때 원형 배경과 같은 색 기능을 제공한다.
- 북마크 버튼은 Toggle 버튼을 래핑하여 On/Off에 대한 북마크 아이콘을 제공한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "ads22/Building_a_scalable_modularized_testable_app_from_scratch/047.png" }}" />

- 기존 버튼 대신 BookmarkButton으로 교체하고 몇 가지 사항을 수정하면 디자인 스펙에 더 가까워진다.
