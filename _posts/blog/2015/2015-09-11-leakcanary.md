---
layout: post
title: "[번역] LeakCanary 의 구조를 어느정도 이해하고 싶은 사람"
date: 2015-09-11 00:30:00
tag: [Android, Square, LeakCanary]
categories:
- blog
- Android
---
<!--more-->

이 포스팅은 [LeakCanaryの仕組みをある程度理解したいマン](http://hogehuga.com/post-696/) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

###LeakCanary 란 무엇인가

[https://corner.squareup.com/2015/05/leak-canary.html](https://corner.squareup.com/2015/05/leak-canary.html)

Square 회사가 개발한 Memory Leak 을 알려주는 라이브러리.

적용은 굉장히 심플.

{% highlight java %}
LeakCanary.install(this);
{% endhighlight %}

이것만으로 Memory Leak 이 발생했을때 통지해준다. 편리.

그러면, Memory Leak 을 알려주는 것을 어떻게 구현하고 있는가.

궁금해서 읽어봤다.

###어느 타이밍에 Memory Leak 유무 확인을 실행하고 있는가?

열쇠는 ActivityRefWatcher 에 있다

[https://github.com/square/leakcanary/blob/master/leakcanary-android/src/main/java/com/squareup/leakcanary/ActivityRefWatcher.java](https://github.com/square/leakcanary/blob/master/leakcanary-android/src/main/java/com/squareup/leakcanary/ActivityRefWatcher.java)

[ActivityLifecycleCallbacks](http://developer.android.com/reference/android/app/Application.html#registerActivityLifecycleCallbacks(android.app.Application.ActivityLifecycleCallbacks)) 을 Application에 등록하는 것으로 어플리케이션 내에 등록된 Activity의 onXXX 를 Listen 하도록 한다.

{% highlight java linenos %}
private final Application.ActivityLifecycleCallbacks lifecycleCallbacks =
      new Application.ActivityLifecycleCallbacks() {

        /// blahblah...

        @Override public void onActivityDestroyed(Activity activity) {
          ActivityRefWatcher.this.onActivityDestroyed(activity);
        }
      };

void onActivityDestroyed(Activity activity) {
    refWatcher.watch(activity);
}
{% endhighlight %}

위를 보면, Activity 가 파기될 순간에 RefWatcher Class 의 watch 메소드가 불려지고 있다.

화면이 파괴된 순간에 Memory Leak 이 없는가 watch 해서, Memory Leak 이 확인되면 알려준다.

라는 흐름이지 않을까.

자세히 봐보자.

###RefWatcher Class 역할

[https://github.com/square/leakcanary/blob/master/leakcanary-watcher/src/main/java/com/squareup/leakcanary/RefWatcher.java](https://github.com/square/leakcanary/blob/master/leakcanary-watcher/src/main/java/com/squareup/leakcanary/RefWatcher.java)

####watch

watch 에서는 어떤 처리가 실행되고 있을까.

{% highlight java linenos %}
/**
   * Watches the provided references and checks if it can be GCed. This method is non blocking,
   * the check is done on the {@link Executor} this {@link RefWatcher} has been constructed with.
   *
   * @param referenceName An logical identifier for the watched object.
   */
  public void watch(Object watchedReference, String referenceName) {
    checkNotNull(watchedReference, "watchedReference");
    checkNotNull(referenceName, "referenceName");
    if (debuggerControl.isDebuggerAttached()) {
      return;
    }
    final long watchStartNanoTime = System.nanoTime();
    String key = UUID.randomUUID().toString();
    retainedKeys.add(key);
    final KeyedWeakReference reference =
        new KeyedWeakReference(watchedReference, key, referenceName, queue);


    watchExecutor.execute(new Runnable() {
      @Override public void run() {
        ensureGone(reference, watchStartNanoTime);
      }
    });
  }
{% endhighlight %}

{% highlight java %}
final KeyedWeakReference reference =
        new KeyedWeakReference(watchedReference, key, referenceName, queue);
{% endhighlight %}

{% highlight java linenos %}
watchExecutor.execute(new Runnable() {
      @Override public void run() {
        ensureGone(reference, watchStartNanoTime);
      }
});
{% endhighlight %}

ensureGone 메소드에서 전달되는 참조가 GC에 의해 파기되는가를 확인하고있는 느낌.

MainThread 에서 실행하면 Blocking 가 발생하므로 watchExecutor 가 전용 Thread 에서 ensureGone 하고 있다.

KeyedWeakReference Class 가 활약하는것은 이제부터다.

이 Class 덕분에 전달되는 참조가 CG 되는가가를 체크하고 알려주도록 해준다.

이쪽 관련은 추후에.

우선은, ensureGone 메소드를 보자.

####ensureGone

{% highlight java linenos %}
void ensureGone(KeyedWeakReference reference, long watchStartNanoTime) {
    long gcStartNanoTime = System.nanoTime();


    long watchDurationMs = NANOSECONDS.toMillis(gcStartNanoTime - watchStartNanoTime);
    removeWeaklyReachableReferences();
    if (gone(reference) || debuggerControl.isDebuggerAttached()) {
      return;
    }
    gcTrigger.runGc();
    removeWeaklyReachableReferences();
    if (!gone(reference)) {
      long startDumpHeap = System.nanoTime();
      long gcDurationMs = NANOSECONDS.toMillis(startDumpHeap - gcStartNanoTime);


      File heapDumpFile = heapDumper.dumpHeap();


      if (heapDumpFile == HeapDumper.NO_DUMP) {
        // Could not dump the heap, abort.
        return;
      }
      long heapDumpDurationMs = NANOSECONDS.toMillis(System.nanoTime() - startDumpHeap);
      heapdumpListener.analyze(
          new HeapDump(heapDumpFile, reference.key, reference.name, excludedRefs, watchDurationMs,
              gcDurationMs, heapDumpDurationMs));
    }
  }


  private boolean gone(KeyedWeakReference reference) {
    return !retainedKeys.contains(reference.key);
  }


  private void removeWeaklyReachableReferences() {
    // WeakReferences are enqueued as soon as the object to which they point to becomes weakly
    // reachable. This is before finalization or garbage collection has actually happened.
    KeyedWeakReference ref;
    while ((ref = (KeyedWeakReference) queue.poll()) != null) {
      retainedKeys.remove(ref.key);
    }
  }
{% endhighlight %}

대략 이런 흐름은

- GC 를 실행한다
- removeWeaklyReachableReferences() 를 실행해서, 전달되는 참조가 GC 에 의해서 회수되는가를 확인하고, 참조 Key를 보유하고있는 Set Class 변수 retainedKeys 로부터 Key 를 지운다. (메소드 명과 실제 처리내용의 매칭이 미묘한 느낌은 있지만...)
- retainedKeys 에 해당되는 Key 가 말소되었는가를 확인하고, 남아있다면 GC로 회수 안됨 = 누군가가 참조하고 있다 = Memory Leak 로 판단한다
- Memory Leak 로 판단되면 Heap 를 Dump 해서 Notification UI 혹은 상세 정보를 표시하는 Activity 를 나타내는 처리를 실행

이런 느낌.

위의 처리를 어느 Activity 가 Destroy 될때마다 실행하고 있다.

왠지모르게 흐름은 이해된 기분이 든다.

removeWeaklyReachableReferences 에서 KeyedWeakReference Class가 활약한다.

[https://github.com/square/leakcanary/blob/master/leakcanary-watcher/src/main/java/com/squareup/leakcanary/KeyedWeakReference.java](https://github.com/square/leakcanary/blob/master/leakcanary-watcher/src/main/java/com/squareup/leakcanary/KeyedWeakReference.java)

위의 구현을 보고, 이 기사를 보면 아주 알기 쉽다.

[http://www.ne.jp/asahi/hishidama/home/tech/java/weak.html](http://www.ne.jp/asahi/hishidama/home/tech/java/weak.html)

```bash
복수 WeakReference 를 사용하는 경우, 어떤것이 사라졌는지 알기위해서는 모든 WeakReference 를 리스트 혹은 어떤 것에 넣어두고 하나하나 get() 해서 null 이 반환되는지를 체크하면 좋을듯하다.

하지만 이건 낭비가 심하다.

그래서, 아주 조금 세련된 방법이 사용되고있다.

참조 Queue (ReferenceQueueクラス) 라는 것을 사용해서, WeakReference 의 생성자의 파라매터로 전달한다.

그러면, WeakReference 로부터 값이 사라지면, 참조 Queue 에 그 WeakReference 가 추가된다.
```

이것을 근거로, 재차 removeWeaklyReachableReferences 를 보자.

{% highlight java linenos %}
while ((ref = (KeyedWeakReference) queue.poll()) != null) {
      retainedKeys.remove(ref.key);
}
{% endhighlight %}

WeakReference 를 만들때 ReferenceQueue 를 전달하면, GC 가 실행될때에 ReferenceQueue 에 참조 (여기에서 말하는것은 KeyedWeakReference) 가 들어간다

그래서, queue 의 poll 메소드를 호출하면 queue 들어있는 참조를 꺼낼수 있다.

꺼낼수 없다. 라는 것은 참조하는 곳의 오브젝트에 대해서 GC 가 되지않았다. 라는 것이다.

다른 오브젝트가 참조하는 곳의 오브젝트 참조하고 있다 = Memory Leak, 이므로 retainedKeys 로부터 Key 를 꺼낼수 없으므로, gone 에서 false 를 반환한다. 그래서, Memory Leak 시의 처리가 실행된다.

대략 이런 느낌이다.
