---
layout: post
title: "[번역] Support Library 25.1.0 이상에서 Fragment 전환시의 Lifecycle이 변화하고있는 건과 대응 방법"
date: 2017-01-05 11:15:00 +09:00
tag: [Android, SupportLibrary]
categories:
- blog
- Android
---

본 포스팅은 [Support Library 25.1.0 以降でFragment切替時のライフサイクルが変わっている件と対応方法](http://qiita.com/FumihikoSHIROYAMA/items/b4aff0ebe9bd84ade871) 포스팅을 번역했습니다.

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

[https://code.google.com/p/android/issues/detail?id=230415](https://code.google.com/p/android/issues/detail?id=230415)

Support Library 25.1.0 이상에서 Fragment 전환시의 Lifecycle이 변화하고 있다.

FragmentA이 있고 버튼을 클릭하면 FragmentB로 replace 하는 코드가 있다.
Support Library 25.1.0 이상에서는 다음과 같이 Logcat에 출력된다.

```
D/FragmentA: onStart()
D/FragmentA: onResume()
D/FragmentB: onStart()
D/FragmentB: onResume()
D/FragmentA: onPause()
D/FragmentA: onStop()
```

FragmentA의 onPause, onStop가 호출되기보다 먼저 FragmentB의 onStart, onResume이 호출되고 있다.

[Issue 230415](https://code.google.com/p/android/issues/detail?id=230415)에 따르면, 이것은 `최적화를 위해 추가된 의도적인 행동 변화`라는 것이다.

그러나 Fragment 전환시 반드시 이전 Fragment의 onStop가 호출되고 나서 새로운 Fragment의 onStart이 불리는 것을 전제로 쓰인 코드는 이 사양 변경으로 틀어질 수 있다. 이 경우 `FragmentTransaction#setAllowOptimization(false)`를 사용한다.

```
getFragmentManager()
        .beginTransaction()
        .setAllowOptimization(false)
        .replace(R.id.container, FragmentA.newInstance(), FragmentA.class.getSimpleName())
        .commit();
```

다음 샘플 어플에서 동작을 확인할 수 있다.

[https://github.com/srym/BreakingChangeInFragmentLifecycle](https://github.com/srym/BreakingChangeInFragmentLifecycle)

Click ME! 버튼을 누르면 FragmentA와 FragmentB가 영원히 바뀌기만 하는 샘플이다.

FragmentA -> FragmentB시에서는 Support Library 25.1.0의 영향을 받지만, FragmentB -> FragmentA 때에는 `setAllowOptimization(false)`로 이전 버전과 같은 동작을 하도록 강요하고 있다.
