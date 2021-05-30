---
layout: post
title: "[요약] Using Jetpack libraries in Compose  (Google I/O '21)"
date: 2021-05-30 17:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
- io21
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/0z_dwBGQQWQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<!--more-->

- - -

- Jetpack Compose가 기존 Jetpack 라이브러리와 얼마나 잘 동작하는지 살펴볼 예정이다
- Compose 설계 시 중요한 부분 중 하나는 기존 앱에 점진적으로 도입할 수 있어야 한다는 점이다
  - UI 레이어 아래에 해당하는 비즈니스/데이터 레이어를 새로운 Compose UI와 사용할 수 있다는 의미이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/001.png" }}" />

예시의 Bloom에서는 여러 Jetpack 라이브러리가 사용되었다

- Room : 식물을 DB에 저장
- Paging : 메모리를 효율적으로 로드
- ViewModel : UI 로직 처리
- Kotlin Coroutine/Flow : 레이어 간의 상태 및 데이터를 노출
- Hilt : 의존성 주입 솔루션

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/002.png" }}" />

Bloom에서는 ViewModel을 2가지 용도로 사용

1. UI에 노출되는 상태와 해당 상태가 생성되는 방식을 구분 (UI의 비즈니스 로직 처리)
2. Jetpack ViewModel을 상속함으로써 Configuration이 변경되어도 살아남아서 최신 데이터를 즉시 사용 가능

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/003.png" }}" />

- 식물 목록은 Repository 레이어에서 노출된다
- 화면의 나머지 상태는 별도 UI 상태 클래스로 구성해서 노출한다 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/004.png" }}" />

- HomeScreen 화면에서 UI의 각 부분을 개별 Composable로 나눌 수 있다
- 각 Composable은 필요한 데이터만 담으면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/005.png" }}" />

Composable에서 `viewModel` 메소드를 사용해서 HomeViewModel 인스턴스를 얻을 수 있다

- ViewModel의 Scope는 가장 가까운 `ViewModelStoreOwner`로 자동 지정한다
- Default Factory 사용
  - AndroidEntryPoint Annotation이 추가된 Hilt를 사용한 Activity/Fragment의 경우에는 Hilt가 이미 Default Factory로 사용되므로 문제없다
  - Hilt나 다른 의존성 주입 솔루션을 사용하지 않는 경우 ViewModel Factory를 만들어서 `viewModel` 함수에 전달하면 된다

Compose는 재사용 및 Testability를 높이기 위해서 `상태를 유지하지 않는` Composable을 선호하는 것이 좋다. 이를 `Stateless Composable`이라고 부르며 내부 상태를 유지하는 Stateful과 대조된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/006.png" }}" />

- Composable 내에서 ViewModel을 가져오는 HomeScreen은 Stateful Composable이었지만, ViewModel을 매개변수로 전달받는 형태로 변경하면 Stateless가 된다. 해당 Composable은 UI 생성만 담당하도록 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/007.png" }}" />

- ViewModel 매개변수를 사용해서 uiState Flow의 데이터를 다룰 수 있다
- LiveData 및 RxJava로도 가능하다
  - LiveData : [observerAsState](https://developer.android.com/reference/kotlin/androidx/compose/runtime/livedata/package-summary#(androidx.lifecycle.LiveData).observeAsState()) 사용
  - RxJava : [subscribeAsState](https://developer.android.com/reference/kotlin/androidx/compose/runtime/rxjava3/package-summary) 사용

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/008.png" }}" />

- Paging은 [Paging Compose Artifact](https://developer.android.com/jetpack/androidx/releases/paging)로 PagingData Flow를 [collectAsLazyPagingItems()](https://developer.android.com/reference/kotlin/androidx/paging/compose/package-summary#collectaslazypagingitems) 메소드를 사용해 Compose에서 사용할 수 있는 상태로 변환한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/009.png" }}" />

- [loadState](https://developer.android.com/reference/kotlin/androidx/paging/LoadState)를 사용해 데이터의 새로 고침 시점과 추가 데이터가 List에 추가되는 동안 화면에 Loading Composable을 쉽게 추가할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/010.png" }}" />

- HomeScreen에서 ViewModel에서 가져온 데이터로 PlantList를 호출할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/011.png" }}" />

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/012.png" }}" />

- HomeScreen의 CollectionsCarousel Composable은 다른 화면에서도 재사용될 수 있는 Composable이다
- HomeScreen과 PlantDetailScreen에서 CollectionsCarousel의 동작 차이는 항목 클릭 시 확장되는 형태라는 점이다
- Carousel 구현 시 확장/축소 로직 및 내부 상태, 특정 화면 이동 등의 로직은 재상용 가능한 UI Component로는 불가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/013.png" }}" />

- CollectionsCarousel Composable을 재사용하게 하려면 상태를 전달하고 이벤트를 외부로 노출해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/014.png" }}" />

- CollectionsCarousel의 상태는 CollectionsCarouselState라는 클래스로 생성해서 다룰 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/015.png" }}" />

- Carousel이 선택한 Collection의 확장 가능 여부 및 표시할 식물에 대한 정보를 표시한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/016.png" }}" />

- Collection 클릭 시에 상태를 업데이트하는 로직도 캡슐화할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/017.png" }}" />

- CollectionsCarouselState은 매개 변수로 CollectionsCarousel Composable에 전달하며 CollectionsCarousel을 호출하는 곳은 이 상태를 작성해서 관리할 필요가 있다
- 이벤트는 식물을 클릭할 때마다 호출되는 Lambda를 추가 매개변수로 정의할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/018.png" }}" />

- Composable이 Root에 가까울 때 상태를 호스팅하고 로직을 처리하며 이벤트를 처리하는 ViewModel을 생성한다
- 재사용 가능한 Composable 경우에는 ViewModel을 사용하면 안 된다. 대신 상태를 가지는 클래스를 작성해서 관리하고 호출하는 곳에 이벤트를 공개해야 한다. 그 이유는 ViewModel이 Activity/Fragment/Navigation Graph의 목적지로 Scope가 지정되기 때문이다. 그리고 해당 Scope에서는 하나의 인스턴스만 사용 가능하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/019.png" }}" />

화면 레벨의 Component에서 ViewModel의 이점은 다음과 같다

- Configuration 변경에도 그대로 존재한다
- SavedStateHandle을 통해 프로세스가 종료되어도 데이터가 남아있다
- Lifecycle이 화면과 일치하는 상태에 적합하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/020.png" }}" />

- HomeScreen의 상태는 HomeViewModel이 관리하며 carouselState는 ViewModel이 표시하는 UI 상태에 포함된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/021.png" }}" />

- ViewModel과 상태 수집에 대한 연결 없이 HomeScreen 테스트 작성 및 Preview 사용이 되어야 한다
- Root Composable의 HomeScreen 변경은 쉽다. 필요한 정보를 매개변수로 추가하기만 하면 된다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/022.png" }}" />

- viewModel과 collectAsState의 호출을 1레벨 위로 올리는 것은 큰 변화는 없지만, HomeScreen이 어디에 적용되는 것을 고려하면 차이가 보인다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/023.png" }}" />

- 위 예시는 Activity에 하나의 화면만 보여주는 경우에는 유효하지만, 실제로는 훨씬 복잡하다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/024.png" }}" />

- Compose를 도입할 경우 기존 앱의 자연스러운 마이그레이션 흐름은 화면을 한 번에 하나씩 대응하는 것이다
- 예를 들어 HomScreen은 실제로 HomeFragment의 유일한 콘텐츠로 onCreateView에서 ComposeView를 만든다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/025.png" }}" />

- 앱의 모든 화면이 재사용 및 테스트 가능한 Composable을 둘러싼 Wrapper라면 Navigation Compose와 모든 화면을 하나로 묶는 것이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/026.png" }}" />

- Jetpack Navigation Component는 처음부터 일반 런타임으로 만들어져있어 목적지에 대해서는 아는 것이 없다
- 해당 런타임이 공유된다는 것은 각 구현이 Kotlin DSL을 통해 지원된다는 의미이다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/027.png" }}" />

Navigation Compose에는 NavController와 NavHost 이 2가지가 필요하다

NavController

- NavController를 입력으로 사용하는 NavHost와는 별도의 객체로 Stateful NavController를 생성할 수 있다
- NavHost 외부의 다른 Component가 NavController를 상태에 대한 단일 진실 공급원으로 사용하여 목적지 변경에 반응할 수 있다

NavHost

- Composable 목적지를 Compose 계층 구조에 추가하는 역할을 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/028.png" }}" />

- HomeScreen의 경우 Home 목적지를 만들며 고유 경로 선언(예 : "home")이 가능하다
- NavHost startDestination에 Navigation 시작 목적지 설정을 할 수 있다
- 기존 viewModel 대신 `hiltNavGraphViewModel` 메소드를 사용해야 한다
  - 목적지가 @AndroidEntryPoint Activity/Fragment가 아니므로 Default Factory는 Hilt Factory가 아니다.
  - viewModel의 편리한 wrapper이고 항상 적절한 Factory가 설정되도록 한다

### 2개 화면의 경우

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/029.png" }}" />

- Navigation Compose에 추가하기 전 PlantDetailScreen을 빌드하는 것이 첫 번째 단계이다
- Preview 및 테스트를 위해서 HomeScreen처럼 Stateless Component로 빌드해야 한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/030.png" }}" />

- 그 후 생성한 PlantDetailScreen을 Navigation Graph에 추가한다
- arguments에 PlantDetailScreen에 필요한 식물 ID 값을 추가한다. 해당 케이스에서 ID는 int 타입이므로 NavType.IntType을 사용한다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/031.png" }}" />

- 전달된 식물 ID는 ViewModel의 SavedStateHandle을 통해서 사용할 수 있다

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io21/using-jetpack-libraries-in-compose/032.png" }}" />

- HomeScreen에 노출된 식물 클릭 시 Lambda를 사용해 PlatDetailScreen의 경로로 목적지를 navigate를 호출할 수 있다
- 이후로는 NavController가 나머지 부분을 처리하며 HomeScreen의 상태를 저장하고 PlatDetailScreen으로 교체한다
