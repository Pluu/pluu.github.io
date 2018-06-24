---
layout: post
title: "[번역] DroidKaigi 2018 ~ MVVM Best Practice"
date: 2018-06-24 17:20:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ MVVMベストプラクティス](https://speakerdeck.com/cheesesand101/mvvmbesutopurakuteisu) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, MVVM Best Practice

DroidKaigi 2018

Yasuhiko Sakamoto

## 2p, 자기소개 

- Yasuhiko Sakamoto
- Kakaku.com 에서 신규 사업을 담당
- 앱 엔지니어, 팀 빌딩, 데이터 분석 등 여러가지합니다

## 3p, Agenda

- 이 발표에 대해서
- MVVM 개요
- 관심 분리
- RecyclerView
- 데이터 흐름
- 정리

## 4p 

이 발표에 대해서

## 5p ~ 6p, MVVM

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/01.png" }}" />

실제로 만들어 보면...

## 7p, 유난히 덩치큰 사람이 있는 MVVM

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/02.png" }}" />

## 8p, 꽤 자주 만드는데 ...

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/03.png" }}" />

MVVM 어떻게 만들었던가?

## 9p, 복잡한 MVVM

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/04.png" }}" />

## 10p, 이 발표에 대해서

- 지금까지의 경험 (주로 반성) 을 바탕으로 MVVM으로 개발하는데 직면하는 여러 문제에 대해서 베스트라고 생각되는 실천적인 사례를 소개하겠습니다

## 11p ~ 12p, MVVM 개요

- 애플리케이션을 Model / View / ViewModel 로 분리하는 아키텍쳐 패턴
- Microsoft의 Ken Cooper과 Ted Peters가 개발
- WPF/Silverlight 에서 쓰였지만, 최근에는 다른 플랫폼에서도 사용 사례가 많다

## 13p, 관심 분리

## 14p, 문제 : 유난히 덩치큰 사람이 있는 MVVM 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/05.png" }}" />

ViewModel이 View와 Model을 침식하여 비대화 → 「관심 분리」를 생각한다

## 15p, 관심 분리

- `관심 분리란`
- MVVM에 있어서 관심 분리
- Android 개발에 있어서 실천적인 방법

## 16p, 관심 분리란

- 애플리케이션을 적절한 단위로 분리・구성함으로 복잡화를 막고 재이용성・ 보수성을 높일 수 있다

## 17p, Presentation Domain Separation(PDS) 

by 마틴 파울러

「가장 유용한 설계 원칙으로 프로그램 (사용자 인터페이스) 의 `Presentation 층과 그 밖의 기능을 잘 나눈다`, 라는 것이 있습니다」

>  [http://bliki-ja.github.io/PresentationDomainSeparation/](http://bliki-ja.github.io/PresentationDomainSeparation/)

## 18p, 관심 분리

- 관심 분리란
- `MVVM에 있어서 관심 분리`
- Android 개발에 있어서 실천적인 방법

## 19p, MVVM에 있어서 관심 분리 

- MVVM은 Presentation Domain Separation 을 실현하는 패턴의 하나이다

## 20p, MVVM에서 PDS

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/06.png" }}" />

- Presentation (Presentation 계층)
- Domain (그 밖의 기능)

## 21p, View 의 관심

- 데이터 표현법
  - 형태, 레이아웃, 애니메이션 ...
- 사용자 이벤트

## 22p, Model 의 관심

- View와 ViewModel 이외의 Presentation 계층에 의존하지 않는 정보
- 앱의 각종 상태, 데이터 모델, 비즈니스 로직, 네트워크, 데이터베이스 ... etc

## 23p, ViewModel 의 관심

- View 의 상태를 추상화해서 가진다
- Model 과 View의 접속
  - Model을 View가 다루기 쉬운 형태로 한다

## 24p, View 와 ViewModel 의 연결

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/07.png" }}" />

View -- 이벤트 알림 --> ViewModel

- View 에서 이벤트를 발생 → ViewModel에 알림

ViewModel -- 변경 알림 --> View

- View 와 ViewModel 의 연결은 데이터 바인딩으로 구현
- View 는 ViewModel 을 감시, 상태 변경에 따라 View가 변경된다
- `ViewModel은 View에 대한 참조를 가지지 않는다`

## 25p, ViewModel 과 Model 의 연결

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/08.png" }}" />

ViewModel -- 상태 변경을 요구 --> Model

- ViewModel은 Model 의 상태 변경을 요구

Model -- 변경 알림 --> ViewModel

- ViewModel은 Model의 상태를 감시하고, 상태 변경에 따라 ViewModel 이 변경된다
- `Model은 ViewModel에 대한 참조를 가지지 않는다`

## 26p, 관심 분리

- 관심 분리란
- MVVM에 있어서 관심 분리
- `Android 개발에 있어서 실천적인 방법`

## 27p, 관심 분리

- Android 개발에 있어서 실천적인 방법
  - `Testability 를 기준으로 사용`
  - View와 ViewModel
  - ViewModel과 Model
  - Dialog 표시・화면 이동
  - Context

## 28p, Testability 를 기준으로 사용 

- 관심 분리가 되어 있는지의 기준의 하나로서 ViewModel 의 Testability 를 의식한다
- 단위 테스트 작성여부에 관계없이, 좋은 설계의 방침이 된다
- 의존하는 객체에 대해서는 Mock의 교환을 가능하게 한다
  - Dagger2 등으 DI Container 이용을 추천

## 29p, Testability 포인트

- Test 불가능한 것이 섞여있지 않는가
  - View 에 대한 참조
  - 데이터 베이스, 네트워크, 파일 등을 직접 조작하지 않는다
  - Thread 제어를 하지않는다
  - ... etc

## 30p, 관심 분리 

- Android 개발에 있어서 실천적인 방법
  - Testability 를 기준으로 사용
  - `View와 ViewModel`
  - ViewModel과 Model
  - Dialog 표시・화면 이동
  - Context

## 31p, View와 ViewModel 

- `Data binding expression`
- View -> ViewModel
- ViewModel -> VIew
- ViewModel 과 Model

## 32p, Data binding expression

- 레이아웃 XML 내부에 식을 기술하고, View와 ViewModel 의 접속을 한다

```xml
<TextView
 ...
 android:text=”@{viewModel.name}”
 />
```

```kotlin
class ViewModel{
val name : ObservableField<String>
}
```

## 33p, View와 ViewModel

- Data binding expression
- `View -> ViewModel`
- ViewModel -> VIew

## 34p, View -> ViewModel

- View에서 발생한 이벤트를 알림
- ViewModel에  View가 섞이지 않도록 한다

## 35p, View -> ViewModel

```xml
<Button
 ...
 android:onClick="@{viewModel::onClick}"
```

```kotlin
class XXViewModel{
fun onClick(view:View){ // ViewModel에 View가 섞여버린다
```

##36p, View -> ViewModel

```xml
<Button
 ...
 android:onClick="@{() -> viewModel.onClick()}" <!-- 람다를 사용하는 작성법이 가능 -->
```

```kotlin
class XXViewModel{
fun onClick(){
```

## 37p, View와 ViewModel

- Data binding expression
- View -> ViewModel
- `ViewModel -> VIew`

## 38p, ViewModel -> View

- ViewModel은 View에 상태를 공개
- ViewModel 의 상태를 그대로 VIew에서 사용 불가능할 경우 바인딩시에 변환을 한다
  - 커스텀 Setter 를 이용

## 39p, 커스텀 Setter (이미지)

```xml
<layout
 xmlns:android="http://schemas.android.com/apk/res/android"
 xmlns:app="http://schemas.android.com/apk/res-auto"
 >
 ...
<ImageView
 ...
 app:imageUrl="@{viewModel.imageUrl}"
 />
```

```kotlin
@BindingAdapter("imageUrl")
fun ImageView.setImageUrl(imageUrl:String){
   Picasso.with(this.context).load(imageUrl).into(this)
}
```

Kotlin 의 경우, 확장함수를 사용해 BindingAdapter를 작성 가능

## 40p, 관심 분리

Android 개발에 있어서 실천적인 방법

- Testability 를 기준으로 사용
- View와 ViewModel
- `ViewModel과 Model`
- Dialog 표시・화면 이동
- Context

## 41p, ViewModel과 Model

- ViewModel → Model
  - Model 상태를 변경한다
- Model → ViewModel
  - ViewModel이 Model의 상태를 감시한다
  - 감시는 RxJava 등 인터페이스를 사용한다
  - ※ 본 발표에서는 RxJava를 사용합니다. 설명을 단순히 하기위해, 에러 처리나 생명주기 관리는 생략합니다

## 42p, 예시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/09.png" }}" />

## 43p, 나쁜 예 (UserSettingViewModel )

```kotlin
class UserSettingViewModel(private val context: Context) {
   val settingA = ObservableField<String>()

   fun load(){
      val pref = context.getSharedPreferences("UserSetting", Context.MODE_PRIVATE)  // ViewModel이 SharedPreference를 직접 참조
      val value = pref.getString("SettingA", "")
      this.settingA.set(value)
   }
}
```

## 44p, 개선

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/10.png" }}" />

## 45p, UserSettingRepository 

```kotlin
class UserSettingRepository(private val context:Context) {
   private val settingASubject = PublishSubject.create<String>()
    
   fun getSettingA() : Observable<String>{
      return this.settingASubject   // PublishSubject를 Observable로서 반환
   }

   fun loadSettingA(){
      val pref = context.getSharedPreferences("UserSetting", Context.MODE_PRIVATE)
      val value = pref.getString("SettingA", "")
      this.settingASubject.onNext(value)   // 데이터를 얻어 PublishSubject 에 onNext
   }
}
```

## 46p, UserSettingViewModel 

```kotlin
class UserSettingViewModel(private val repository: UserSettingRepository) {
   val settingA = ObservableField<String>()

   init {
      repository.getSettingA().subscribe { value ->
         settingA.set(value)
      }
      // 상태를 감시하여 변경이 있으면 settingA를 갱신
      // ※ 추후에 설정 변경 기능을 붙인 경우에도 변경은 여기로 흘러들어온다
   }

   fun load(){
      repository.loadSettingA()   // repository에 데이터를 읽게함
   }
}
```

## 47p, 관심 분리

- Testability 를 기준으로 사용
- View와 ViewModel
- ViewModel과 Model
- `Dialog 표시・화면 이동`
- Context

## 48p, Dialog 표시・화면 이동

- Dialog 표시나 화면 이동은 ViewModel의 관심이 아니므로, ViewModel로부터는 트리거를 당기기만 한다

## 49p, 대표적인 구현 패턴 

- Navigator
  - Android MVVM 구현에서 자주 사용된다
  - Activity 를 랩핑하는 객체 (Navigator) 를 만들고, ViewModel은 Navigator 경유로 View를 조작한다

## 50p, Navigator 구현 사례 (DroidKaigi/conference-app-2017) 

```kotlin
@ActivityScope
public class Navigator {
   private final Activity activity;
   @Inject
   public Navigator(AppCompatActivity activity) {
      this.activity = activity;
   }
   public void navigateToSessionDetail(@NonNull Session session, @Nullable Class<? extends Activity> parentClass) {
      activity.startActivity(SessionDetailActivity.createIntent(activity, session.id, parentClass));
   }
```

> [https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/view/helper/Navi gator.java](https://github.com/DroidKaigi/conference-app-2017/blob/master/app/src/main/java/io/github/droidkaigi/confsched2017/view/helper/Navi gator.java)

## 51p, 관심 분리

- Testability 를 기준으로 사용
- View와 ViewModel
- ViewModel과 Model
- Dialog 표시・화면 이동
- `Context`

## 52p, Context (android.content.Context) 

```java
public abstract class Context {
 public final String getString(int resId);
 public final String getString(int resId, Object... formatArgs) ;
 public final int getColor(int id);
 public final Drawable getDrawable(int id);
 public final TypedArray obtainStyledAttributes(AttributeSet set, int[] attrs, int defStyleAttr, int
defStyleRes);
 public abstract ClassLoader getClassLoader();
 public abstract String getPackageName();
 public abstract ApplicationInfo getApplicationInfo();
 public abstract String getPackageResourcePath();
 public abstract String getPackageCodePath();
 public abstract SharedPreferences getSharedPreferences(String var1, int var2);
 public abstract boolean moveSharedPreferencesFrom(Context var1, String var2);
 public abstract boolean deleteSharedPreferences(String var1);
 public abstract FileInputStream openFileInput(String var1) throws FileNotFoundException;
 public abstract FileOutputStream openFileOutput(String var1, int var2) throws FileNotFoundException;
 public abstract boolean deleteFile(String var1);
 public abstract File getFileStreamPath(String var1);
 public abstract File getDataDir();
・・・・・・・
```

많아!!!

## 53p, Context

- View, ViewModel, Model 각각이 필요로하는 곳이 있다
- ViewModel이 Context의 기능을 사용하는 경우
  - 사용한다면 getString 부분
  - Wrapper를 만들어서 ViewModel에서만 사용한 쓰기 좋은 메소드를 제한하는 것이 좋다

## 54p, RecyclerView

## 55p, 상당히 자주 사용하는데 ...

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/11.png" }}" />

MVVM로 어떻게 만들지?

## 56p, RecyclerView

- `기본적인 구현 패턴`
- 변경 알림
- 구현의 효율화

## 57p, 기본적인 구현 패턴

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/12.png" }}" />

광고가 있는 TODO 앱

- 광고
- TODO

## 58p, Model 정의

```kotlin
sealed class TaskItem{
   class Task(val name:String, ...) : TaskItem()
   class Ad(...) : TaskItem()
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/13.png" }}" />

## 59p, ViewModel 정의

```kotlin
class TasksViewModel(...){
   val items : ObservableField<List<TaskItem>>
}
sealed class TaskItemViewModel{
   class Task(...) : TaskItemViewModel(){
      val name : String
   }
   class Ad(...) : TaskItemViewModel(){
      ...
   }
}
```

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/14.png" }}" />

## 60p, Adapter 생성

RecyclerView → Adapter

## 61p, Activity

```kotlin
class TasksActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      ...
      val binding = DataBindingUtil.setContentView<ActivityTasksBinding>(this,
R.layout.activity_tasks)
      binding.recyclerView.adapter = TasksAdapter(repository)
```

Adapter 생성

## 62p, Model을 Adapter에 전달

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/15.png" }}" />

>  데이터 바인딩으로 전달

## 63p, BindingAdapter  + Bind

```kotlin
// RecyclerViewExtension.kt
@BindingAdapter("taskItems")
fun RecyclerView.setTaskItems(items:List<TaskItem>>?){
   (this.adapter as TasksAdapter).setData(items ?: listOf())
}
```

```xml
<!-- activity_tasks.xml -->
<android.support.v7.widget.RecyclerView
   android:id="@+id/recyclerView"
   ...
   app:taskItems="@{viewModel.items}"
 />
```

## 64p, Adapter에서 View/View 의 생성과 접속

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/16.png" }}" />

>  데이터 바인딩으로 전달

## 65p, TasksAdapter

길어!! 그러니 포인트만...

## 66p, ViewHolder

```kotlin
class TaskViewHolder(val binding:ItemTaskBinding) :
RecyclerView.ViewHolder(binding.root)

class TaskAdViewHolder(val binding:ItemTaskAdBinding) :
RecyclerView.ViewHolder(binding.root)
```

Binding을 ViewHolder가 가진다

## 67p, TasksAdapter.onCreateViewHolder 

```kotlin
override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int):
RecyclerView.ViewHolder {
   val viewTypeEnum = ViewType.from(viewType)
   val layoutInflater = LayoutInflater.from(parent!!.context)
   return when(viewTypeEnum){
      ViewType.Ad -> TaskAdViewHolder(DataBindingUtil.inflate(layoutInflater,
R.layout.item_task_ad, parent, false))
      ViewType.Task -> TaskViewHolder(DataBindingUtil.inflate(layoutInflater,
R.layout.item_task, parent, false))
   }
 }
```

> ViewHolder 생성

## 68p, TasksAdapter.onBindViewHolder 

```kotlin
override fun onBindViewHolder(holder: RecyclerView.ViewHolder?, position: Int) {
   if(holder != null){
      val item = this.items.get(position)
      when (holder) {
         is TaskViewHolder -> {
            val viewModel = TaskItemViewModel.Task(item as TaskItem.Task, repository)
            holder.binding.viewModel = viewModel
            holder.binding.executePendingBindings()
         }
         is TaskAdViewHolder -> {
            val viewModel = TaskItemViewModel.Ad(item as TaskItem.Ad)
            holder.binding.viewModel = viewModel
            holder.binding.executePendingBindings()
          }
       }
    }
 }
```

> ViewModel 의 생성 & View와 ViewModel 의 접속

## 69p, 완료

## 70p, RecyclerView 

- 기본적인 구현 패턴
- `변경 알림`
- 구현의 효율화

## 71p, 변경 알림

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/17.png" }}" />

> 탭해서 TODO를 추가

## 72, 변경 알림

- Collection 의 자식 요소가 변경시에 그것을 어떻게 View에 반영할 것 인가?
  - 전부 변경 (notifyDataSetChanged)
    - 변경 애니메이션이 안된다 ...
- Diff 갱신을 하는 방법으로 아래의 2가지 방법이 있다
  - ObservableList
  - Diff 감시 기능을 이용

## 73p, ObservableList 

- ObservableList(android.databinding.ObservableList) 인터페이스 이용
  - ObservableArrayList 의 구현 클래스를 사용하는 것이 편리
  - Collection 에 변경이 일어나면, Callback에 변경 내용이 전달된다
  - Adapter에 변경 Callback을 등록하고, 변경이 일어나면 갱신

## 74p, ObservableList 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/18.png" }}" />

## 75p, ObservableList 정의

```kotlin
public interface ObservableList<T> extends List<T> {
   void addOnListChangedCallback(ObservableList.OnListChangedCallback<? extends
ObservableList<T>> listener);
   void removeOnListChangedCallback(ObservableList.OnListChangedCallback<? extends
ObservableList<T>> listener);
}
```

## 76p, OnListChangedCallback 

```kotlin
public abstract static class OnListChangedCallback<T extends ObservableList> {
   public OnListChangedCallback() {
   }
   
   public abstract void onChanged(T var1);
   public abstract void onItemRangeChanged(T var1, int var2, int var3);
   public abstract void onItemRangeInserted(T var1, int var2, int var3); // 신규 추가는 이 메소드가 불려짐
   public abstract void onItemRangeMoved(T var1, int var2, int var3, int var4);
   public abstract void onItemRangeRemoved(T var1, int var2, int var3);
 }
```

## 77p, TasksAdapter 

```kotlin
class TasksAdapter : RecyclerView.Adapter<RecyclerView.ViewHolder>() {
   fun setData(items:ObservableList<TaskItemViewModel>){
      items.addOnListChangedCallback([長い䛾で省略]...{
         override fun onItemRangeInserted(list: ObservableList<TaskItemViewModel>?,
positionStart: Int, itemCount: Int) {
            notifyItemRangeInserted(positionStart, itemCount) // 변경 부분만 Adapter를 갱신
         }
         ……
```

## 78p, Diff 감시

- ViewModel에서 새로운 Collection이 넘겨졌을때에 오래된 Collection과의 Diff 를 계산해서, Diff 부분만 View를 갱신한다

## 79p, Diff 감시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/19.png" }}" />

 Diff 감시 기능 → Diff 를 계산 → 새로운 Collection이 흘러들어온다

## 80p, Diff 감시

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/20.png" }}" />

Diff 감시 기능 → Diff 를 전달 → ADapter → 생성 → View

## 81p, 참고 : Library

- 스스로 구현하는 것은 힘드므로 Library를 사용하고 싶다
- DiffUtil
  - 소개만 함
  - [https://developer.android.com/reference/android/support/v7/util/DiffUtil.html](https://developer.android.com/reference/android/support/v7/util/DiffUtil.html)
- Epoxy
  - 추후에 소개만 합니다

## 82p, RecyclerView

- 기본적인 구현 패턴
- 변경 알림
- `구현의 효율화`

## 83p, 구현의 효율화

- Adapter는 정형적인 구현이 많다
  - ViewType 결정
  - ViewHolder 생성
  - 변경 감시
  - ...

## 84p, Library 이용

- 독자적으로 구현하는것보다 Library를 사용하는게 좋다
- Adapter 구현을 지원하는 Library는 몇가지 존재하므로, 프로젝트 요건에 맞는 것을 채용해주세요

## 85p, 참고 : Epoxy

- [https://github.com/airbnb/epoxy](https://github.com/airbnb/epoxy)
- Airbnb가 개발하고, RecyclerView 구현 지원 Library
- 상당히 간결하게 구현할 수 있다
- DataBinding 에도 대응
- Diff 갱신 기능이 있다
- ※ 여기에서는 소개만 합니다

## 86p, Dataflow

## 87p, 문제 : 복잡한 MVVM

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/21.png" }}" />

- 특히 ViewModel 간의 복잡화
- Dataflow 의 단순화를 생각

## 88p, 왜 복잡해지는가?

- TODO 앱의 샘플로 계속 설명합니다

## 89p, 샘플에 Task 개수를 추가

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/22.png" }}" />

## 90p, Task 완료

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/23.png" }}" />

- 체크하면 완료
- 개수가 줄어든다

## 91p, Flow

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/24.png" }}" />

## 92p, TaskRepository  의 정의 

```kotlin
class TaskRepository {
   fun getTasks() : Single<TaskItem>
   fun complete(id:Long) : Single<TaskItem>
}
```

RxJava의 Single, Repository가 내부적으로 WebAPI에 접속해 반환된 결과를 1회만 반환한다

## 93p, TaskItemViewModel.Task 

```kotlin
sealed class TaskItemViewModel{
   class Task(private val parent:TasksViewModel, private val
repository: TaskRepository, private val model:TaskItem.Task) :
TaskItemViewModel(){
      fun complete(){
         repository.complete(model.id).subscribe ({ models -> // Model 갱신
            parent.onComplete(models) // TaskViewModel을 갱신
         }, {error ->
            //(생략)
         })
      }
   }
}
```

## 94p, TasksViewModel 

```kotlin
class TasksViewModel(private val repository: TaskRepository){
   val items = ObservableField<List<TaskItem>>()
   val count = ObservableInt()
   fun onComplete(models:List<TaskItem>){ // Item, Task 개수 갱신
      items.set(models)
      count.set(models.count { it is TaskItem.Task })
   }
}
```

## 95p, 복잡화

- 이 샘플 수준이라면 아직 따라갈 수 있지만, 이와 같은 ViewModel 간의 소통이 증가하면 점점 복잡화
- 왜?
  - ViewModel 간의 소통에 의해 필요이상으로 데이터 흐름이 복잡화

## 96p, ViewModel과 Model

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/25.png" }}" />

- ViewModel → Model : Model의 변경 상태를 요구
- Model → ViewModel : Model의 상태 변경을 받는다

Model의 상태를 변경 → Model의 상태 변경에 따라 ViewModel이 자동으로 갱신하는 형태라면 ViewModel 간의 소통이 사라지고, 데이터 흐름도 단순하게 된다

## 97p, 개선

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/26.png" }}" />

## 98p, TaskRepository 

```kotlin
class TaskRepository {
   fun getTask() : Observable<TaskItem> // Model의 상태 변경을 알림, 몇번이라도 알리기때문에, Single → Observable로 변경
   fun complete(id:Long) // Model의 상태 변경을 요구, 반환값이 없다
}
```

## 99p, TaskItemViewModel.Task 

```kotlin
sealed class TaskItemViewModel{
   class Task(private val repository: TaskRepository, private val
model:TaskItem.Task) : TaskItemViewModel(){

      fun delete(){
         repository.complete(model.id) // Model 상태 변경을 요구
      }
   }
}
```

## 100p, TasksViewModel 

```kotlin
class TasksViewModel(private val repository: TaskRepository) {
   val items = ObservableField<List<TaskItem>>()
   val count = ObservableInt()
   init {
      repository.getTask().subscribe { models -> // Model의 상태 변경을 계속 감시한다
         items.set(models)
         count.set(models.count { it is TaskItem.Task }) // Model의 상태 변경이 일어날때마다, 매번 최신 상태로 변경한다
      }
   }
}
```

## 101p, 완료 

<img class="img-responsive" src="{{ "/assets/img/blog/" | prepend: site.baseurl }}{{ "2018/06-24-mvvm/27.png" }}" />

## 102p ~ 103p, 정리

- 관심 분리를 생각해서 View - ViewModel - Model을 적절히 분리하고, ViewModel의 비대화를 막는다
- RecyclerView 는 기본적인 구현 패턴을 기반으로 변경 감지나 효율화를 고려
- 데이터 흐름을 단순화해서 복잡화되지 않도록