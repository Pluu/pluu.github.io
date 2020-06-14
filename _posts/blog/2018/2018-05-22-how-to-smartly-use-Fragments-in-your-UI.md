---
layout: post
title: "[요약] Android Jetpack: how to smartly use Fragments in your UI (Google I/O '18)"
date: 2018-05-22 17:45:00 +09:00
tag: [Android]
categories:
- blog
- Android
- IO18
---

<div class="youtube">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/WVPH48lUzGY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</div>

<!--more-->

- - - 

### Activity

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/01.png" }}" /> 

과거 모든 Android App은 Activity로 시작했으며, 시스템에서 애플리케이션의 시작점입니다. View 들을 만들고, 앱의 상태를 뷰 영역에 바인드하며, UI 이벤트를 받거나, 앱 상태를 업데이트했습니다. 많은 사람이 하나의 Activity에 코드를 담는 모습도 있었습니다.

그리고 Tablet이 생겼습니다. 복수의 Phone UI를 가져 원하는 작동을 할 수 있을까?, Fragment가 이 질문에 대한 대답이었습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/02.png" }}" /> 

Gmail이 좋은 사례입니다. 두 화면과 오른쪽의 화면은 큰 차이가 없습니다.

### Fragments of an Activity

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/03.png" }}" />

- Fragment는 거대한 Activity Class를 분리하기 위해 고안되었습니다. 
- Activity가 할 수 있는 것은 Fragment도 할 수 있어야 합니다.
  - 생명주기 이벤트가 필요하며, View 계층을 관리 할 수 있어야 하고, 저장된 인스턴스 관리도 해야 합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/04.png" }}" />

위 API 들은 실제로 많은 문제가 있었습니다.

### Factoring Activities

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/05.png" }}" />

방대한 Activity의 경우, 그것을 Fragment 로 나누는 방법이 있지만, Fragment의 경우 기본적으로 느슨하게 관련된 코드들을 다른 곳으로 옮기는 것입니다. 그리고 Activity를 더 합리적으로 분류될때까지 계속 반복합니다. 여러개의 Fragment가 될 수도 있습니다. 결국 Activity는 이것을 위한 껍데기가 됩니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/06.png" }}" />

만약 Fragment 중 하나가 ViewPager를 가지고 있다면, Fragment를 더 작은 Fragment로 나눕니다.

### Things Fragments do

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/07.png" }}" />

이러한 것들을 염두에 두어 Fragment는 생명주기를 가집니다. 모두 Back stack 관리와 관련되며, 각 개체마다 유지되는 개체가 있어 Configuration 변경시 수행할 수 있습니다. 그리고, 이것들은 FragmentManager에 저장됩니다. 즉, Fragment의 존재가 실제로 앱 상태의 일부임을 의미합니다. Fragment를 여러 레이아웃에서 다시 사용할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/08.png" }}" />

하지만, 모든 Fragment들이 원하든 원하지 않든 모든 것들을 즉시 수행합니다. 대부분 한두가지만 사용하고, 나머지는 사용하지 않은 상태로 이용됩니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/09.png" }}" />

따라서, 일부 작업은 FragmentManager가 올바른 상태인지 확인해야 하는 패턴을 볼 수 있습니다.

### Architecture Components

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/10.png" }}" />

작년 API를 어떻게 하는지에 대해 더 전체적인 접근을 했으며, Architecture Components 에 대한 많은 작업이 시작되었습니다. 여러가지가 아니라 한가지 일에 집중하기 위해서입니다. 

- LifecycleObservers : 생명주기를 가질 수 있는 것과는 독립적으로 onResume, onStart 등 생명주기를 Observe할 수 있는 기능을 제공합니다
- ViewModel
- Navigation : 좀 더 높은 레벨의 아키텍처를 활용하여 UI를 구축하고 조합하여 어떻게 다음 화면으로 이동할 것인지에 대한 문제를 해결합니다.

### Dependencies

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/11.png" }}" />

부분적으로 Fragment는 매우 느슨한 종속성에 대한 개념과 상호작용에 대한 느승한 보장을 중심으로 설계되었습니다.

### Architecture Components ~ Lifecycle Observers

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/12.png" }}" />

LifecycleObservers는 사용자에 의해 생성되며, Reflection 을 통해 다시 만들지 않습니다. 그러나, 이 의미는 더 이상 시스템에 의한 상태 저장/복원이 일어나지 않는다는 것입니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/13.png" }}" />

UI는 없으며, onStart/onStop 생명주기 이벤트를 수신하기 위한 경우 위와 같은 형태가 됩니다. 여기서 중요한 것은 Activity와 Fragment로부터 독립되어 있는 부분입니다. 그리고, 독립적으로 테스트를 할 수 있습니다.

### Retained Instance Fragments

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/14.png" }}" />

RetainedInstance Fragment는 실제 Activity보다 오래 지속되도록 설계되었습니다. Configuration 변경시 즉각적인 상태 유지가 가능하며, 높은 비용의 데이터나 작업에 대한 핸들을 절약할 수 있습니다. 하지만, UI는 사용하지 마세요. Fragment는 모든 것을 동시에 합니다. 

### Architecture Components ~ ViewModels

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/15.png" }}" />

고정된 인스턴스 패턴에 대한 해결책으로는 ViewModel이 있습니다. 실제로 ViewModel은 많은 것을 하지 않으며, 단지 시스템과 연결되는 방식에 대한 것입니다. 따라서, Fragment API의 일부가 되는 대신, 더 일반적인 목적을 가지는 것입니다.

UI와 연결시 LiveData를 이용할 수 있습니다. LiveData는 생명주기를 지키는 관찰자같은 것입니다. Fragment나 Activity는 ViewModel이 소유한 LiveData를 Observe 가능합니다. 그리고, ViewModel은 Retained Instance Fragments에 대한 대안을 제공합니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/16.png" }}" />

AndroidViewModel은 Application Context 참조를 제공하며, Service Locator Pattern 과 같은 작업에 유용합니다. 여기서 중요한 것은 ViewModel이 LiveData의 인스턴스를 저장하는 부분입니다. 어디서나 데이터를 가져올 수 있으며, 올바른 생명주기 이벤트를 설정하여 LiveData를 올바른 상태로 만들 수 있습니다. Fragment나 Activity는 이 데이터가 어디에서 왔는지 알 필요가 없습니다.

### Architecture Components ~ Navigation

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/17.png" }}" />

Fragment 혹은 다른 UI 조각 사이의 화면 전환에 초점을 맞춘 새로운 Architecture Component 입니다. 

동기/비동기 Fragment Transaction 사용과 관계없이 Fragment가 올바르게 동작하기 바라며, 실제로 더 많은 일을 하고 있습니다. Navigation 의 기능 중 하나는 실제 Back Stack의 소유권을 가져와 동기/비동기시 Back Stack을 처리하는 것입니다.

> 더 자세한 세션을 원하면 아래의 세션을 참고해주세요
>
> [Android Jetpack: manage UI navigation with Navigation Controller (Google I/O '18)](https://www.youtube.com/watch?v=8GCXtCjtg40)

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/18.png" }}" />

`Navigation.createNavigateOnClickListener` 이라는 Helper Method를 제공합니다. 버튼을 클릭시 다른 Fragment로 전환을 위한 Method입니다. Navition 에서 설정한 목적지의 ID를 전달하면 됩니다.

실제로는 **NavigationController** 를 사용합니다. Navigation의 유용한 점 중 하나는 Navigation으로 생성된 모든 View 혹은 Fragment에서 NavigationController 를 실제로 찾을 수 있습니다. Navigate 호출은 Fragment Transaction을 어떻게 해야 하는지를 알고 있습니다. 만약 Arguments를 전달하려면 Bundle 방식을 사용할 수 있습니다. 

## Why Fragments in 2018?

Fragment 의 코드를 다른 부분으로 잘라낸 후에도 Fragment가 여전히 좋은 점은 무엇일까요?

### Android layering

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/19.png" }}" />

`android.widget`은 UI에 대한 모든 메커니즘을 유지하도록 설계되었습니다. 즉, 사용자에게 상태를 보여주고 상호 작용 이벤트를 앱의 다른 상위 Layer에 알리는 것입니다.

`android.app` 은 Activity, Fragment가 존재하는 등 정책이 적용되는 곳입니다. 이것은 위젯에 바인딩할 상태를 정의하는 것입니다.

### App Screens

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/20.png" }}" />

Fragment가 화면 대부분을 차지하고 있는 것의 앱의 주요 콘텐츠입니다. 이 부분이 Navigation이 시작되는 곳입니다. 이 모델에서는 Single-Activity 로 훨씬 쉽게 이동할 수 있습니다. 그러면 이 모델에서 Activity가 수행하는 유일한 작업은 Common App Chrome의 종류를 처리하는 것입니다. 액션바, Bottom Navigation, Side Navigation 을 사용하는 경우 Activity 가 관리할 수 있는 좋은 것입니다. 그러나 나머지는 분리된 목적으로 된 화면이 될 수 있습니다. 이를 통해 수동으로 처리해야 하는 많은 작업을 시스템으로 이동할 수 있습니다.

물론 상호 배타적이지 않습니다. 이것은 단지 하나의 방법입니다. 더 큰 종류의 콘텐츠 기반의 Fragment는 여전히 `android.app` 과 위젯 사이를 연결하는 좋은 방법입니다.

### DialogFragment

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/21.png" }}" />

일부는 Dialog를 통해 Fragment의 일부분으로 즉각적인 상태 복원을 활용할 수 있습니다. 예를 들어 화면의 크기를 조정하거나 기기를 회전할 때 화면이 실제로 사라지지 않도록 할 수 있습니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/22.png" }}" />

DialogFramgment는 문자 그대로 show를 할 수 있으며, 올바른 작업을 수행한 후 올바른 상태로 되돌릴 수 있습니다.

### Options Menus

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/23.png" }}" />

Fragment 에서 자주 사용하는 것 중 하나는 메뉴를 관리하는 것입니다. 일반적인 사용 사례는 Support Option Menu를 호출하여 특정 Toolbar에 현재 Context에 대한 무엇을 바인딩합니다. 고정적인 노출일 경우 좋습니다. FragmentPagerAdapter의 경우 Pager가 변경되면 시스템에서 Option Menu에 대해 처리를 합니다. 

오늘날 UI는 Toolbar 혹은 다른 종류의 메뉴가 실제 콘텐츠의 일부가 되기도 합니다. CollapsingToolbarLayout 과 같은 정교한 것들도 존재하므로, 필요 이상으로 복잡하게 만들지 마세요. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/24.png" }}" />

모든 것을 Activity OptionMenu에 작성하기보다는 조금 더 자급자족으로 할 수 있습니다.

### Testing Fragments

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/25.png" }}" />

FragmentController 클래스를 이용해 생명주기를 조정할 수 있어, FragmentManager의 Test FragmentController를 생성하여 실제 발생할 수 있는 것을 배제하여 테스트할 수 있습니다. 가능하지만, 최선의 인터페이스는 아닙니다.

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/26.png" }}" />

AOSP의 SupportLibrary 테스트 중 일부 메소드입니다. 

### Loaders

최근 Fragment 로부터 Loader를 분리했습니다. 새로운 Primitive를 사용하여 LiveData와 ViewModel를 가지고 독립적으로 만듭니다. 이제 LifecycleOwner를 가지는 클래스에서 Loader를 사용할 수 있습니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/27.png" }}" />

SupportFragment 혹은 LoaderManager를 호출하는 대신 인스턴스를 불러오면 됩니다. 실제 LoaderManager를 사용하는 사용자가 LifecycleObserver이므로 생명주기에 대한 더 강력한 보장을 주기 위해 이런 새로운 것들에 의존합니다. 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "io/io18/how-to-smartly-use-Fragments-in-your-UI/28.png" }}" />

이제 `android.app.fragmentmanager` 는 공식적으로 **Deprecated** 되었습니다. 이 기능은 AndroidX 패키지 및 Support Library에서 훨씬 잘 작동합니다. 