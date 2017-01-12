---
layout: post
title: "[번역] 쉬운 Dagger2"
date: 2017-01-13 00:15:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

본 포스팅은 [やさしいDagger2](http://starzero.hatenablog.com/entry/2016/12/02/084412) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

[Android 제２ Advent Calendar 2016 - Qiita](http://qiita.com/advent-calendar/2016/android_second) 2일째의 기사입니다.

Dagger2는 최초 허들이 높아 좀처럼 도입 안되거나 장점을 잘 모르거나 합니다. 그런 분들이 분위기만이라도 잡을 수 있도록 간단한 예제를 구현하면서 확인할 수 있는 것을 썼습니다.

상당히 오래되어버린 느낌입니다만, 그다지 복잡한 것은 하지 않을 예정입니다.

## 설치

build.gradle에 의존관계를 추가합니다

```
compile 'com.google.dagger:dagger:2.7'
annotationProcessor 'com.google.dagger:dagger-compiler:2.7'
```

## Hello Dagger2

무척 간단한 샘플입니다.

### 의존 해결되는 클래스

우선 의존 해결되는 클래스를 만듭니다. `Dog` 클래스라고 합니다.

```
public class Dog {
    public String getName() {
        return "ぽち";
    }
}
```

### 인스턴스를 제공하는 클래스

의존성 문제를 해결하기 위해 인스턴스를 제공해야 합니다. 그 설정을 합니다.

클래스는 `@Module`을 붙이고, 인스턴스를 제공하는 메소드에는 `@Provides`을 붙입니다.

`@Provides`의 반환 값은 주입하고자 의존의 형태가 됩니다. 이번에는 `Dog` 클래스를 주입하고 싶으므로 `Dog` 가 반환 값으로 되어 있습니다.

```
@Module
public class SampleModule {
    @Provides
    Dog provideDog() {
        return new Dog();
    }
}
```

### 의존 해결을 위한 interface

의존 해결을 하고 싶은 곳과 어떤 모듈을 사용할 것인지 정의합니다.

`@Component` 의 인수에는 사용할 Module 클래스를 설정합니다.

`inject` 메소드를 정의하여 인수에 의존 해결을 하는 클래스를 설정합니다. 이번에는 `MainActivity`로 의존 해결합니다.

빌드하면 `DaggerSampleComponent` 클래스가 자동으로 생성됩니다. 이것은 다음과 같이 사용합니다.

```
@Component(modules = SampleModule.class)
public interface SampleComponent {
    void inject(MainActivity activity);
}
```

### 실제로 의존 해결해보자

`MainActivity`를 다음과 같은 코드로 합니다. 자주 있는 샘플에서는 `Application` 클래스에서 하고 있습니다만, 우선 간단하게 Acitivty에서 직접합니다.

하는 것은 코드 쪽에 코멘트 했습니다만, 기본적으로 인스턴스를 주입하고 싶은 것에 `@Inject`를 붙이고, Component를 만들어 주입하는 느낌입니다.

이번에는 `SampleModule`에서 설정한 `Dog` 클래스를 반환 값으로 설정한 것이 주입됩니다.

```
public class MainActivity extends AppCompatActivity {

    // 인스턴스가 주입되는 필드
    @Inject
    Dog dog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // SampleComponent로부터 DaggerSampleComponent 가 자동 생성되므로, 그것을 사용하여 SampleComponent를 만듭니다.
        SampleComponent component = DaggerSampleComponent.builder()
                // 사용하는 Module 인스턴스를 지정합니다.
                // (여기서 deprecated 될 수 있지만, 일단 모든 코드를 작성하고 빌드하면 사라질 것입니다)
                .sampleModule(new SampleModule())
                .build();

        // 의존 주입을 실행합니다
        component.inject(this);

        String name = dog.getName();

        Log.d("MainActivity", name);

    }
}
```

### 확인

여기까지 구현하여 실행하면 로그가 출력되고 있다고 생각합니다.

이것만으로는 무엇을 위해 있는지 잘 모르겠다고 생각합니다만, 일단 여기에서는 의존성 문제를 해결하기 위해 Module과 Component가 필요하다는 것을 파악해두면 좋다.

## Field InjectionとConstructor Injection

아까는 조금 다른 의존 해결 방법을 간단하게 하겠습니다.

좀 전에 한 것은 클래스의 필드에 `@Inject`를 달고 거기에 주입했기 때문에 `Field Injection`이 됩니다.

또 하나가 `Constructor Injection`가 있습니다. 생성자의 매개 변수로 의존성을 주입합니다.

### 생성자에 주입되는 클래스

새롭게 `Owner`라는 클래스를 만듭니다.

생성자에 좀 전의 `Dog` 클래스를 매개 변수로 받을 수 있게 되어있습니다. 또한 `@Inject`를 달고 있습니다.

```
public class Owner {

    private Dog dog;

    @Inject
    public Owner(Dog dog) {
        this.dog = dog;
    }

    public String getPetName() {
        return dog.getName();
    }
}
```

### MainActivity를 수정

다음과 같이 수정합니다.

변경 사항은 필드가 `Dog`에서 `Owner`로 바뀌었습니다.

`Owner` 대해서는 Module로 설정하거나 하지 않았습니다만, Dagger2가 마음대로 생성자에 주입하여 `Owner`의 인스턴스를 만들어주고 있습니다.

```
public class MainActivity extends AppCompatActivity {

    @Inject
    Owner owner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        SampleComponent component = DaggerSampleComponent.builder()
                .sampleModule(new SampleModule())
                .build();

        component.inject(this);

        Log.d("MainActivity", owner.getPetName());

    }
}
```

### 확인

여기까지 했다면 실행하여 확인합니다. 결과는 전과 다르지 않지만 `Owner`의 처리에서 `Dog`의 처리를 호출하게 했습니다.

`Constructor Injection`을 사용하면 Dagger2가 Module로 설정된 것을 사용하여 인스턴스를 만들어줍니다.

저는 이것이 매우 편리하다고 생각하고 있습니다. Context 같은 것을 Module로 설정해놓고 사용하고 싶은 클래스의 생성자에 매개 변수로 하는 것을 자주 합니다.

## interface를 쓰자

지금까지 사용한 것은 구현 클래스였지만, 다음은 interface를 사용하도록 변경합니다.

### 새로운 interface를 만들자

새롭게 `Pet`라는 interface를 만듭니다.

```
public interface Pet {
    String getName();
}
```

그리고 `Dog`가 그것을 구현하는 형태로 수정합니다.

```
public class Dog implements Pet {

    @Override
    public String getName() {
        return "포치";
    }
}
```

### interface를 사용하도록 수정한다

우선은 Module을 수정합니다.

```
@Module
public class SampleModule {

    @Provides
    Pet providePet() {
        return new Dog();
    }
}
```

다음으로 `Owner` 매개 변수를 변경합니다.

```
public class Owner {

    private Pet pet;

    @Inject
    public Owner(Pet pet) {
        this.pet = pet;
    }

    public String getPetName() {
        return pet.getName();
    }
}
```

### 확인

실행하여 확인합니다. 결과는 바뀌지 않았습니다.

여기에서 확인할 포인트는 `Owner`의 클래스입니다.

지금까지 `Dog`라는 구현 클래스에 의존했지만, interface로 변경함으로써 거기와의 의존이 없어지고 interface에만 의존하게 되었습니다.

## Build Variants에서 동작을 변경한다

[Build Variants](https://developer.android.com/studio/build/build-variants.html)에서 동작을 변경하도록 합니다. Build Variants 자체에 대한 문서는 구글링해주세요.

이번에는 ProductFlavors로 나누게 합니다.

### build.gradle

build.gradle을 아래와 같이 하여 `dog`와 `cat`의 ProductFlavor를 만듭니다.

```
android {
    ...
    productFlavors {
        dog {
        }
        cat {
        }
    }
}
```

### 폴더 생성

`src` 폴더 아래 `dog/java` 폴더를 만들고 추가로 패키지를 작성합니다. 마찬가지로 `cat/java`도 만들어 둡니다.

아마 어느 java 폴더가 소스 폴더로 인식되지 않는다고 생각합니다. 메뉴의 View → Tool Windows → Build Variants에서 Build Variant를 전환함으로써 해결된다고 생각합니다.

실행할 때도 Build Variants의 Window에서 전환할 수 있습니다

<img src="https://cdn-ak.f.st-hatena.com/images/fotolife/S/STAR_ZERO/20161105/20161105094229.png"/>

### Cat 클래스

새롭게 `Pet` interface를 구현한 클래스를 추가합니다. 이것은 `main` 폴더의 소스 폴더에 추가합니다.

```
public class Cat implements Pet {

    @Override
    public String getName() {
        return "타마";
    }
}
```

`main` 폴더에 있는 `SampleModule` 클래스를 제거합니다.

BuidType과 ProductFlavor에서 `main` 폴더 내에 같은 클래스 이름을 사용할 수 없기 때문입니다. 대신 `dog` 폴더와 `cat` 폴더에 `SampleModule`을 추가하도록 합니다.

### cat의 ProductFlavor

`cat`의 ProductFlavor 실행 시에는 조금 전의 `Cat` 클래스를 사용하도록 합니다.

`cat` 폴더의 소스 폴더에 다음을 추가합니다. 지금까지와 다른 것은 `Dog` 클래스의 인스턴스를 반환하는 것이 아니라 `Cat` 클래스를 반환하도록 합니다.

```
@Module
public class SampleModule {

    @Provides
    Pet providePet() {
        return new Cat();
    }
}
```

<img src="https://cdn-ak.f.st-hatena.com/images/fotolife/S/STAR_ZERO/20161105/20161105094307.png"/>

### dog의 ProductFlavor

`dog`의 ProductFlavor의 경우 지금까지의 `Dog` 클래스를 사용합니다.

`dog` 폴더의 소스 폴더에 다음을 추가합니다.

```
@Module
public class SampleModule {

    @Provides
    Pet providePet() {
        return new Dog();
    }
}
```

<img src="https://cdn-ak.f.st-hatena.com/images/fotolife/S/STAR_ZERO/20161105/20161105094319.png"/>

### 확인

Build Variants의 Window에서 `catDebug`와 `dogDebug`를 전환하여 실행해보세요.

각각 다른 결과가 될 거라고 생각합니다.

Build Variants에서 구현 클래스를 통째로 바꿔 각각 다른 동작이 가능합니다. BuildType의 release와 debug로 처리를 나누고 싶거나 ProductFlavor의 유료 버전과 무료 버전으로 처리를 나누고 싶은 경우 등에 사용할 수 있습니다.

## 테스트를 써본다

`Owner` 클래스의 테스트를 써봅니다. 이 샘플 코드는 Dagger2 없이도 별 어려움이 없을 것으로 생각합니다만...

### 테스트

테스트를 다음과 같이 써봅니다. `androidTest` 쪽이 아니고, `test` 쪽입니다.

`Owner`에 전달할 매개 변수는 익명 클래스로 즉석에서 생성합니다.

이번에는 그다지 장점을 느끼지 못할지도 모릅니다만, 직접 `Dog`의 인스턴스를 전달하지 않습니다.

예를 들어 `Dog` 클래스의 `getName`이 API 통신하는 경우 `Dog` 클래스에 직접 의존하고 있는 상태라고 테스트를 작성하는 것이 상당히 힘든 상태라고 생각합니다. 또한, 만약 `Dog` 클래스의 생성자에서 `Context`가 필요하거나 하면 꽤 힘든 느낌이라고 생각합니다.

이번처럼 interface를 사용하여 테스트 시 동작을 변경하는 것으로 `Owner`의 테스트가 쓰기 쉬워졌습니다.

```
public class OwnerTest {

    @Test
    public void getPetName() throws Exception {
        Owner owner = new Owner(new Pet() {
            @Override
            public String getName() {
                return "애완 동물의 이름";
            }
        });

        assertThat(owner.getPetName(), is("애완 동물의 이름"));
    }
}
```

### 확인

테스트를 실행해보고 통과하는지 확인합니다.

`Constructor Injection`을 사용하고 있는 덕분에 테스트가 상당히 쓰기 쉽게 되는 느낌입니다.

## 정리

이번 샘플은 그다지 실용적이지 않을까 하고 생각합니다만, 분위기를 알았다면 기쁩니다.

Dagger2의 테스트 샘플이라면 상당히 UI에 대해서 많거나 하지만, UI 이외의 테스트에도 매우 유효하다고 생각하고, 도입하기 쉬울 거라고 생각합니다.

실제로 손을 움직여 확인하지 않으면 이해하기 어려움도 있으므로 Dagger2을 해본 적이 없는 사람은 한 번 해보게 빠르다고 생각합니다. 복잡한 부분도 있지만, 단순한 사용법이라면 크게 문제없이 사용할 수 있다고 생각합니다. (저는 간단한 사용법밖에 못 하지만 ...)