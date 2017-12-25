---
layout: post
title: "[번역] DroidKaigi 2017 ~ DataBinding 로 구현하는 MVVM Architecture"
date: 2017-12-25 15:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ DataBinding 로 구현하는 MVVM Architecture](https://speakerdeck.com/star_zero/databindingteshi-xian-surumvvm-architecture) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p

DataBinding 로 구현하는 MVVM Architecture

## 2p, About me

- Kenji Abe
- MEDIROM Inc (前: Re.Ra.Ku)
- twitter/STAR_ZERO
- github/STAR-ZERO

## 3p, 개요

- Android에서 MVVM을 실현을 위한 구현 방법
- 주로 Model-View-ViewModel이 각각 무엇을 할 것인가 이야기

- 슬라이드에 나오는 코드
   - RxJava1
   - Retrolambda

## 4p

MVVM

## 5p, MVVM

- 베이스가된 것은 Microsoft의 WPF와 Silverlight
- 목적은 프레젠테이션과 도메인을 분리하는 것
   - PresentationDomainSeparation
   - [https://martinfowler.com/bliki/PresentationDomainSeparation.html](https://martinfowler.com/bliki/PresentationDomainSeparation.html)
- 테스트하기 쉽고, 변경에 강하다
- DataBinding을 쓰면 좋은 것은 아니다

## 6p

<img src="https://upload.wikimedia.org/wikipedia/commons/8/87/MVVMPattern.png" />

> [https://ja.wikipedia.org/wiki/Model_View_ViewModel](https://ja.wikipedia.org/wiki/Model_View_ViewModel)

## 7p, MVVM 참고

- The MVVM Pattern
   - [https://msdn.microsoft.com/ja-jp/library/hh848246.aspx](https://msdn.microsoft.com/ja-jp/library/hh848246.aspx)
- MVVM 패턴 상식 ― 「M」「V」「VM」 의 역할은? － ＠IT
   - [http://www.atmarkit.co.jp/fdotnet/chushin/greatblogentry_02/greatblogentry_02_01.html](http://www.atmarkit.co.jp/fdotnet/chushin/greatblogentry_02/greatblogentry_02_01.html)
- GUI 아키텍처 패턴의 기초에서 MVVM 패턴으로
   - [https://www.slideboom.com/presentations/591514/GUI%E3%82%A2%E3%83%BC%E3%82%AD%E3%83%86%E3%82%AF%E3%83%81%E3%83%A3](https://www.slideboom.com/presentations/591514/GUI%E3%82%A2%E3%83%BC%E3%82%AD%E3%83%86%E3%82%AF%E3%83%81%E3%83%A3)
- MVVM의 Model에 대한 오해 - the sea of fertility
   - [http://ugaya40.hateblo.jp/entry/model-mistake](http://ugaya40.hateblo.jp/entry/model-mistake)

## 8p

Android에서 MVVM

## 9p, Android에서 MVVM

- DataBinding으로 실현할 수 있도록
- RxJava 와 EventBus 등의 지원이 필요

## 10p

| View |   | ViewModel |   | Model |
| :--: | :--: | :--: | :--: | :--: |
| Activity | <--DataBinding--> | State | --Call Method--> | Besiness Logic |
| Fragment |    | Presentation Logic |    | Domain |
| Layout XML | <--Notification-- |   | <--Notification-- | Repository |
|   |   |   |   | API |

## 11p

| View |   | ViewModel |   | Model |
| :--: | :--: | :--: | :--: | :--: |
| Activity |   | State |   | Besiness Logic |
| Fragment | --Dependency--> | Presentation Logic | --Dependency--> | Domain |
| Layout XML |   |   |   | Repository |
|   |   |   |   | API |

## 12p

View

## 13p, View

- ViewModel의 상태를 반영
- View의 입력을 ViewModel에 전달
- ViewModel에 이벤트 처리를 위임

## 14p, View

- `ViewModel의 상태를 반영`
- View의 입력을 ViewModel에 전달
- ViewModel에 이벤트 처리를 위임

## 15p, ViewModel의 상태를 반영

| View |   | ViewModel |
| :--: | :--: | :--: |
| Activity |   | State |
| Fragment | <--Reflect-- | Property |
| Layout XML |   |   |

- ViewModel에 공개되어있는 상태를 DataBinding을 이용해서 표시한다

## 16p, ViewModel의 상태를 반영

```
// ViewModel
public class ViewModel {
   public final ObservableField<String> title = new ObservableField<>();
}
```

## 17p, ViewModel의 상태를 반영

```
<!-- 레이아웃 XML —>
<TextView
   android:id="@+id/text_title"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:text="@{viewModel.title}" />
```

## 18p, ViewModel의 상태를 반영

- 표준 DataBinding 은 어렵다
- 예를 들어, 이미지 URL로부터 Picasso이나 Glide를 사용해 이미지를 표시하는 경우 등
- DataBinding 사용자 정의 Setter 만들기

## 19p, ViewModel의 상태를 반영

```
// 사용자 정의 Setter 정의
public class ImageViewBinding {

   @BindingAdapter("imageFromURL")
   public static void loadImage(ImageView view, String url) {
      Glide.with(view.getContext()).load(url).into(view);
   }
}
```
```
<!-- 레이아웃 XML —>
<ImageView
   android:layout_width="match_parent"
   android:layout_height=“match_parent"
   app:imageFromURL="@{viewModel.imageURL}" />
```

## 20p, View

- ViewModel의 상태를 반영
- `View의 입력을 ViewModel에 전달`
- ViewModel에 이벤트 처리를 위임

## 21p, View의 입력을 ViewModel에 전달

| View |   | ViewModel |
| :--: | :--: | :--: |
| Activity |   | State |
| Fragment | --Input--> | Property |
| Layout XML |   |   |

- View 입력을 DataBinding을 사용해 ViewModel의 상태에 반영
- 양방향 바인딩

## 22p, View의 입력을 ViewModel에 전달

```
<!-- 레이아웃 XML —>
<EditText
   android:id="@+id/edit_title"
   android:layout_width="match_parent"
   android:layout_height="wrap_content"
   android:text="@={viewModel.title}" />
```

## 23p, View의 입력을 ViewModel에 전달

```
// ViewModel
public class ViewModel {
   public final ObservableField<String> title = new ObservableField<>();
}
```

## 24p, View

- ViewModel의 상태를 반영
- View의 입력을 ViewModel에 전달
- `ViewModel에 이벤트 처리를 위임`

## 25p, ViewModel에 이벤트 처리를 위임

| View |   | ViewModel |
| :--: | :--: | :--: |
| Event | --Dispatch-->  |   |

- View에서 발생한 이벤트를 ViewModel에 처리를 위임
- DataBinding이나 메서드 호출

## 26p, ViewModel에 이벤트 처리를 위임

```
<!-- 레이아웃 XML —>
<android.support.design.widget.FloatingActionButton
   android:id="@+id/fab"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:layout_gravity="bottom|end"
   android:layout_margin="@dimen/fab_margin"
   android:onClick="@{viewModel::onClickDone}"
   android:src="@drawable/ic_done" />
```

## 27p, ViewModel에 이벤트 처리를 위임

```
// ViewModel
public class ViewModel {
   public void onClickDone(View view) {
      // ...
   }
}
```

## 28p, ViewModel에 이벤트 처리를 위임

- android:onClick 이외의 이벤트를 처리하고 싶은 경우
- 문서에는 실려있지 않지만, 일부는 정의되어 있다
   - [https://android.googlesource.com/platform/frameworks/data-binding/+/android-7.1.1_r13/extensions/baseAdapters/src/main/java/android/databinding/adapters](https://android.googlesource.com/platform/frameworks/data-binding/+/android-7.1.1_r13/extensions/baseAdapters/src/main/java/android/databinding/adapters)
- 예를 들어, EditText가 변경될 때마다 이벤트를 처리한다

## 29p, ViewModel에 이벤트 처리를 위임

```
<!-- 레이아웃 XML —>
<!--suppress AndroidUnknownAttribute -->
<EditText
   android:layout_width="match_parent"
   android:layout_height="wrap_content"
   android:onTextChanged="@{viewModel::onTextChanged}" />
```

## 30p, ViewModel에 이벤트 처리를 위임

```
// ViewModel
public class ViewModel {
   public void onTextChanged(CharSequence s,
                             int start,
                             int before,
                             int count) {
      // ...
   }
}
```

> [https://android.googlesource.com/platform/frameworks/data-binding/+/android-7.1.1_r13/extensions/baseAdapters/src/main/java/android/databinding/adapters/TextViewBindingAdapter.java#344](https://android.googlesource.com/platform/frameworks/data-binding/+/android-7.1.1_r13/extensions/baseAdapters/src/main/java/android/databinding/adapters/TextViewBindingAdapter.java#344)

## 31p, ViewModel에 이벤트 처리를 위임

- 어디에도 정의되어있지 않은 이벤트를 처리하고 싶은 경우
- setter가 있는 것은 그대로 사용할 수 있다
- 예를 들어, SwipeRefreshLayout.setOnRefreshListener

## 32p, ViewModel에 이벤트 처리를 위임

```
// ViewModel
public class ViewModel {
   public void onRefresh() {
      // ...
   }
}
```
```
<!-- 레이아웃 XML —>
<android.support.v4.widget.SwipeRefreshLayout
   android:layout_width="match_parent"
   android:layout_height="match_parent"
   app:onRefreshListener="@{viewModel::onRefresh}">
```

## 33p, ViewModel에 이벤트 처리를 위임

- DataBiding 사용할 수 없는 패턴
- 예를 들어 메뉴 처리
- 직접 ViewModel을 부른다

## 34p, ViewModel에 이벤트 처리를 위임

```
// Activity or Fragment
@Override
public boolean onOptionsItemSelected(MenuItem item) {
   switch (item.getItemId()) {
      case R.id.menu_action:
         viewModel.someAction();
         return true;
   }
   return super.onOptionsItemSelected(item);
}
```

## 35p, ViewModel에 이벤트 처리를 위임

```
// ViewModel
public class ViewModel {
   void someAction() {
      // ...
   }
}
```

## 36p

ViewModel

## 37p, ViewModel

- View를 위한 상태유지 및 공개
- Model 처리 호출
- View에 변경 알림 이벤트

## 38p, ViewModel

- `View를 위한 상태유지 및 공개`
- Model 처리 호출
- View에 변경 알림 이벤트

## 39p, View를 위한 상태유지 및 공개

| View |   | ViewModel |
| :--: | :--: | :--: |
| Activity |   | State |
| Fragment | <--Reflect-- | Property |
| Layout XML |   |   |

- View에 표시를 위한 상태를 유지하고 공개한다
- ObservableField와 getter 등

## 40p, View를 위한 상태유지 및 공개

```
// ViewModel
public class ViewModel {
   public final ObservableField<String> title = new ObservableField<>();
}
```

## 41p, View를 위한 상태유지 및 공개

```
// ViewModel
public class ViewModel extends BaseObservable {
   private String title;
   
   @Bindable
   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
      notifyPropertyChanged(BR.title);
   }
}
```

## 42p, View를 위한 상태유지 및 공개

```
<!-- 레이아웃 XML —>
<TextView
   android:id="@+id/text_title"
   android:layout_width="wrap_content"
   android:layout_height=“wrap_content"
   android:text="@{viewModel.title}" />
```

## 43p, ViewModel

- View를 위한 상태유지 및 공개
- `Model 처리 호출`
- View에 변경 알림 이벤트

## 44p, Model 처리 호출

| ViewModel |   | Model |
| :--: | :--: | :--: |
|   |   | Besiness Logic |
|   | --Call Method--> | Domain |
|   |   | Repository |
|   |   | API |

- View에서 이벤트 등을 받고 Model의 처리를 호출

## 45p, Model 처리 호출

- MVVM의 Model에 관련된 오해
   - [http://ugaya40.hateblo.jp/entry/model-mistake](http://ugaya40.hateblo.jp/entry/model-mistake)
- Model에 대해서 ViewModel이 하는 것은 이벤트에 대한 반응과 `반환 값이 없는 메서드` 호출밖에 없는 것

```
ViewModel에 대한 Model 인터페이스

그것을 바탕으로 생각하면 ViewModel이 공개할 Model의 인터페이스는 다음의 두 가지밖에 없습니다.

- Model의 상태의 공개와 그 변경 알림
- Model의 작업에 대한 반환 값이 없는 메서드
```

## 46p, Model 처리 호출

```
// ViewModel
public class ViewModel {
   public void onClickAction(View view) {
      model.someOperation();
   }
}
```

## 47p, Model 처리 호출

- 처리 결과 등은 어떻게 받을 것인가?
- Model의 어떤 곳에서 설명합니다

## 48p, ViewModel

- View를 위한 상태유지 및 공개
- Model 처리 호출
- `View에 변경 알림 이벤트`

## 49p, View에 변경 알림 이벤트

- View를 변경하기 위해 ViewModel의 상태를 변경시켜 그것을 View에 전할 필요가 있다

## 50p, View에 변경 알림 이벤트

| View |   | ViewModel |
| :--: | :--: | :--: |
| Activity | <--Change Notification-- | Property |
| Fragment |    |   |
| Layout XML | <--Change Notification-- | Other |

- ViewModel의 변경을 View에 전달
- ObservableField과 BaseObservable
- RxJava과 EventBus

## 51p, View에 변경 알림 이벤트

- DataBinding을 사용하는 경우

## 52p, View에 변경 알림 이벤트

```
// ViewModel
public class ViewModel {
   public final ObservableField<String> title = new ObservableField<>();

   public void something(String result) {
      // 변경 알림
      title.set(result);
   }
}
```

## 53p, View에 변경 알림 이벤트

```
// ViewModel
public class ViewModel extends BaseObservable {
   private String title;
   @Bindable
   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
      // 변경 알림
      notifyPropertyChanged(BR.title);
   }
}
```

## 54p, View에 변경 알림 이벤트

- DataBiding을 사용할 수 없는 패턴
- 다이얼로그 및 화면 전환
- EventBus or RxJava로 대응

## 55p, View에 변경 알림 이벤트

| View |   | EventBus |   | ViewModel |
| :--: | :--: | :--: | :--: | :--: |
| Activity |   |   |   |   |
| Fragment |   |   |   |   |
|   | --Subscribe--> |   |   |   |
| Something | <--Recieve-- |   |  <--Post-- | Change Event |

EventBus

[https://github.com/greenrobot/EventBus](https://github.com/greenrobot/EventBus)

## 56p, View에 변경 알림 이벤트

```
// EventClass
public class ShowDialogEvent {
   private final String message;

   public ShowDialogEvent(String message) {
      this.message = message;
   }
}
```

## 57p, View에 변경 알림 이벤트

```
// ViewModel
public class ViewModel {
   public void something() {
      EventBus.getDefault().post(
          new ShowDialogEvent("message")
      );
   }
}
```

## 58p, View에 변경 알림 이벤트

```
// View
@Override
protected void onStart() {
   super.onStart();
   EventBus.getDefault().register(this);
}

@Subscribe(threadMode = ThreadMode.MAIN)
public void showDialog(ShowDialogEvent event) {
   // 다이얼로그 표시
}
```

## 59p, View에 변경 알림 이벤트

| View |   | ViewModel |
| :--: | :--: | :--: |
| Activity |   | Subject  |
| Fragment |   | ↓ OnNext  |
| Something | --Subscribe--> | Observable |
| Something | <--Recieve-- | Observable |

RxJava

[https://github.com/ReactiveX/RxJava](https://github.com/ReactiveX/RxJava)

## 60p, View에 변경 알림 이벤트

```
// ViewModel
public class ViewModel {
   private final PublishSubject<String> showDialogSubject = PublishSubject.create();

   final Observable<String> showDialog = showDialogSubject.asObservable();

   public void something() {
      // 알림 이벤트를 발행
      showDialogSubject.onNext("message");
   }
}
```

## 61p, View에 변경 알림 이벤트

```
// View
private void subscribe() {
   viewModel.showDialog.subscribe(message -> {
      // 다이얼로그를 표시
   });
}
```

## 62p, 참고 : RxJava - Subject

- Observer도 되고, Observable도 된다
- Observer로서 onNext 등을 부를 수 있다
- Observable로서 subscribe 가능하다
- 이를 알림에 이용한다
- 자주 사용하는 것은 PublishSubject
- 설명이 어렵기때문에 실제로 시도해보는게 빠릅니다

## 63p, 참고 : RxJava - asObservable

- Subject를 그대로 공개하지 않는다
- 그대로 노출되면 다른 곳에서도 onNext를 부르게 된다
- Observable로 공개할 때도 asObservable를 사용

```
private final PublishSubject<String> subject 
   = PublishSubject.create();

final Observable<String> observable 
   = subject.asObservable();
```

## 64p, 참고 : EventBus vs RxJava

- 좋아하는 방법을 사용하면 된다고 생각한다
- 개인적으로 RxJava
   - retrolambda가 있으면 좋을지도
- EventBus는 글로벌이므로 어디에서 알림이 오는지 알기 어렵다
- EventClass 계속 증가해져 간다
- 하지만 한정적으로 EventBus 사용
   - RecyclerView의 Adapter에서 Activity에 알림 등

## 65p

Model

## 66p, Model

- View와 ViewModel 이외의 처리
- ViewModel에 변경 알림 이벤트

## 67p, Model

- `View와 ViewModel 이외의 처리`
- ViewModel에 변경 알림 이벤트

## 68p, View와 ViewModel 이외의 처리

- 도메인, 비즈니스 로직
- DB
- API
- 그 외 여러 가지

## 69p, Model

- View와 ViewModel 이외의 처리
- `ViewModel에 변경 알림 이벤트`

## 70p, ViewModel에 변경 알림 이벤트

- ViewModel에서 이야기한 반환 값이 없는 메서드를 호출 결과를 받는 방법
- Model에 대한 조작은 Model의 상태를 변경시키는 것
- Model이 변경되면 변경 알림 이벤트 발행한다
- ViewModel은 이벤트를 받을 뿐
- 예외 처리 등도 Model에서 처리하여 알림 이벤트를 발행할 뿐
- 필요한 경우 Model에서 BaseObservable를 사용

## 71p, ViewModel에 변경 알림 이벤트

| ViewModel |   | Model |
| :--: | :--: | :--: |
|   | <--Change Notification-- | Entity |
|   | <--Change Notification-- | Success |
|   | <--Change Notification-- | Error |

- Model에서 알림을 사용해 ViewModel에 변경을 전달한다
- ViewModel은 알림을 받을 뿐

## 72p, ViewModel에 변경 알림 이벤트

- Repository에서 비동기로 Entity를 얻는다

## 73p, ViewModel에 변경 알림 이벤트

```
// Model

// 성공
private final PublishSubject<Entity> entitySubject
         = PublishSubject.create();
public final Observable<Entity> entity
         = entitySubject.asObservable();

// 실패
private final PublishSubject<Void> errorSubject
         = PublishSubject.create();
public final Observable<Void> error
         = errorSubject.asObservable();
```

## 74p, ViewModel에 변경 알림 이벤트

```
repository.get()
         .subscribeOn(Schedulers.newThread())
         .unsubscribeOn(AndroidSchedulers.mainThread())
         .subscribe(new Observer<Entity>() {
            @Override
            public void onCompleted() {
            }

            @Override
            public void onError(Throwable e) {
               // 실패 알림 이벤트
               errorSubject.onNext(null);
            }

            @Override
            public void onNext(Entity entity) {
               // 성공 알림 이벤트
               entitySubject.onNext(entity);
            }
         });
```

## 75p, ViewModel에 변경 알림 이벤트

```
// ViewModel

model.entity.subscribe(entity -> {
   // 성공
});

model.error.subscribe(aVoid -> {
   // 실패
});
```

## 76p, ViewModel에 변경 알림 이벤트

- Entity를 DataBinding으로 View와 바인딩하는 경우
- Entity의 속성 변경을 알린다

## 77p, ViewModel에 변경 알림 이벤트

```
// ViewModel
public class ViewModel {
   public final ObservableField<Entity> entity = new ObservableField<>();
}
```
```
<!-- 레이아웃 XML —>
<TextView
   android:id="@+id/text_name"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:text="@{viewModel.entity.name}" />
```

## 78p, ViewModel에 변경 알림 이벤트

```
public class Entity extends BaseObservable {
   private String name;

   @Bindable
   public String getName() {
      return name;
   }

   public void setName(String name) {
      this.name = name;
      // 값이 설정되면 알림
      notifyPropertyChanged(BR.name);
   }

   // 무언가 조작해서 Model 상태를 변경
   public void someOperation() {
      // …
      setName(value);
   }
}
```

## 79p

정리

## 80p, 정리

- DataBinding을 사용하는 것만으로는 안된다
- 프레젠테이션 및 도메인 격리를 제대로 인식한다
- 각 레이어에서 할 일, 레이어 간의 상호 작용 방법을 이해한다
- EventBus와 RxJava 등을 활용한다

## 81p, 좋은 점

- 각 레이어의 책임이 명확하게 되기때문에, 해야 할 것의 파악이 쉽다, 변경에 강하다
- DataBinding에 의해 View 측 코드가 줄고, 복잡하지 않게 된다
- Model이 View에서 떨어져 있기 때문에 테스트하기 쉽다

## 82p, 괴로운 것

- View 측 코드가 줄어들지만, 그래도 생명주기라든지 여러 가지 힘들다
- ObservableField 등의 속성이 늘어난다
- EventBus의 Event 클래스가 늘어나고 register/unregister 관리
- RxJava의 Subject와 Observable이 증가, subscribe/unsubscribe 관리

## 83p, 샘플

[https://github.com/STAR-ZERO/AndroidMVVM](https://github.com/STAR-ZERO/AndroidMVVM)