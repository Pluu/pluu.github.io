---
layout: post
title: "[번역] DroidKaigi 2017 ~ Android 정기실행 처리 입문"
date: 2017-08-21 23:45:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ Android定期実行処理入門](https://speakerdeck.com/kazy1991/droidkaigi-2017) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Android 정기실행 처리 입문

kazy(kazuki yoshida)

## 2p, 자기소개

- 이름: kazuki yoshida
- 소속: cookpad Inc.
- Twitter: @101kaz
- github: kazy1991

### DroidKaigi 2016

[DroidKaigi2016 발표자료](http://www.slideshare.net/KazukiYoshida/droidkaigi-rxjava)

## 3p, 정기실행 처리란...

유저의 조작과 직접 관계없이 일정 간격으로 작업를 수행한다

### 정기실행 처리 사례

- 피드 갱신
- 로컬에서의 알림

## 4p, 정기실행 처리 사례

"요리 기록"

- 요리 사진만 모아서 기록한다

## 5p, 요리 기록의 구조

1. 단말에 사진이 추가된다
2. 일정 간격으로 새로운 사진을 찾는다
   - 여기에 정기 실행 처리
3. 사진을 요리 판정한다
4. 사진을 업로드한다.

## 6p, 여담

BroadcastReceiver로 NEW_PICTURE 이벤트를 받으면 되지 않는가?

- 초기 프로토타입에서는 이 방침을 구현했다
- 정기 실행 처리가 불필요하므로 구현이 간단해서 좋았다
- 모든 카메라 앱이 NEW_PICTURE 이벤트를 보내주지 않는다
- Deprecated in API level 24 이므로 선택하기 어렵다

## 7p, AlarmManager ..??

정기 실행 처리를 하고 싶은 경우, 모두 어떻게 하고 있습니까?

## 8p, Alarm Manager

- Api Level 1부터 사용 가능하다
- 옛날부터 사용하고 있는 API로 인터넷상에 지식도 많다
- 인터페이스가 간단해서 손쉽게 사용할 수 있다
   - "OO의 시간이 되면 △△를 해줘" 

## 9p, AlarmManager 샘플 (BroadcastReceiver)

```
public class AlarmReceiver extends BroadcastReceiver {
   private static Intent createIntent(Context context) {
      return new Intent(context, AlarmReceiver.class);
   }

   public static PendingIntent createPendingIntent(Context context) {
      return PendingIntent.getBroadcast(context, 0, createIntent(context), 0);
   }

   @Override
   public void onReceive(Context context, Intent intent) {
      // 여기에서 Service를 실행한다 등등..
   }
} 
```
```
# AndroidManifest.xml
<receiver
   android:name=".AlarmReceiver"
   android:exported="false" />
```

## 10p, AlarmManager 샘플 (스케쥴)

```
public class MainActivity extends AppCompatActivity {
   @Override
   protected void onCreate(Bundle savedInstanceState) {
      //..
      PendingIntent intent = AlarmReceiver.createPendingIntent(this);
      AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);          
      alarmManager.set(AlarmManager.RTC_WAKEUP, fiveSecondsLater(), intent);
   }
} 
```

- PendingIntent와 기동시간을 AlarmManager에 전달한다

## 11p, Alarm Manager

- 조금 미묘한 점!
   - OS에 따라 동작이 다르다
   - 재부팅하면 Schedule이 사라지기 때문에 대응이 필요
   - 시간 이외의 제약에 대응 불가능하다
      - 네트워크가 연결되지 않은 경우
      - 배터리가 연결되어 있을시
   - 실패 시 재시도 처리가 없다

## 12p, Alarm Manager 사용처

- 적합한 경우
   - 시간에 업밀한 작업의 구현
- 적합하지 않을 경우
   - 재부팅시의 지원, 재시도 메커니즘을 원하는 경우
   - 전력 효율을 의식한 고성능 처리

## 13p, JobScheduler

고성능을 의식한 모던 작업 관리 구조

## 14p, JobScheduler

- Lollipop에서 등장한 비교적 새로운 API
- Service를 임의 타이밍에 시작할 수 있는 작업 스케줄러
- cookpad 앱 (요리 기록)에서는 JobScheduler를 사용했다

## 15p, JobScheduler 샘플 (Service쪽)

```
public class MyJobService extends JobService {
   @Override
   public boolean onStartJob(JobParameters job) {
       // 여기에 작업을 적는다
       return false;
   }

   @Override
   public boolean onStopJob(JobParameters job) {
      return false;
   }
} 
```
```
<service
   android:name=".MyJobService"
   android:exported="true"
   android:permission="android.permission.BIND_JOB_SERVICE" />
```

## 16p, JobScheduler 샘플 (Service쪽)

```
public class MyJobService extends JobService {
   @Override
   public boolean onStartJob(JobParameters params) {         
      // 여기는 메인 스레드
      tooHeavyJob()
            .subscribeOn(Schedulers.io())
            .subscribe(result -> {
               // 뭔가 갱신 처리 등을 한다
               jobFinished(params, false);
               // 작업이 실패한 경우는 true를 전달하면 다시 Schedule
            });
      // 동기 처리의 경우는 false/비동기 처리의 경우는 true를 전달한다
      return true;
   }

   @Override
   public boolean onStopJob(JobParameters params) {
      // 작업이 완료하기 전에 시스템이 취소하면 호출된다
      return false;
   }
} 
```

## 17p, JobScheduler 샘플 (Schedule 처리)

```
public class MyJobService extends JobService {
   private static final int PERIODIC_JOB_ID = 1;
   
   public static void setPeriodicSchedule(Context context) {
      JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
      
      JobInfo jobInfo = new JobInfo.Builder(PERIODIC_JOB_ID,
            new ComponentName(context, MyJobService.class))
            .setPeriodic(TimeUnit.MINUTES.toMillis(30))
            .setPersisted(true)                
            .setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY) 
            .build();
      scheduler.schedule(jobInfo);
   }

   public static void cancelPeriodicSchedule(Context context) {
      JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
      scheduler.cancel(PERIODIC_JOB_ID);
   }
} 
```

## 18p, JobScheduler에서 Schedule에 유효한 조건

- 최대 마감 시간 (setOverrideDeadline)
- 최소 지연 시간 (setMinimumLatency)
- Backoff / 재시도 정책 (setBackoffCriteria)
- 통신 환경의 제약 (setRequiredNetworkType)
- 충전 환경의 제약 (setRequiresCharging)
- Idle 제약 (setRequiresDeviceIdle)
- 반복 스케줄링 (setPeriodic)
- 재부팅시 지속성 (setPersisted)

## 19p, Job Scheduler에 매개변수를 전달한다

- JobInfo.Builder#setExtras(PersistableBundle extras)

```
PersistableBundle bundle = new PersistableBundle();
JobInfo jobInfo = new JobInfo.Builder(JOB_TAG,
         new ComponentName(this, MyJobService.class))
         .setExtras(bundle)
         .build(); 
```

- JobParameters#getExtras()

```
public class MyJobService extends JobService {
   @Override
   public boolean onStartJob(JobParameters params) {
      PersistableBundle bundle = params.getExtras();
      // PersistableBundle는 Schedule시에 영속하되므로
      // 여기에서 다시 적어도 다음의 job에는 반영되지 않는다
      return false;
   }
} 
```

## 20p, Schedule 상황을 코드로 확인한다

```
public static boolean isPending(Context context, int serviceId) {
   JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);
   List<JobInfo> pendingJobList = scheduler.getAllPendingJobs();
   for (JobInfo jobInfo : pendingJobList) {
      if (serviceId == jobInfo.getId()) {
         return true;
      }
   }
   return false;
} 
```

- JobScheduler#getAllPedingJobs
- Schedule 된 jobInfo 목록을 받는다
- Schedule 했을 때때 전달 된 ID를 비교한다

## 21p, adb 명령어로 JobScheduler 상태를 확인한다

```
adb shell dumpsys jobscheduler
```

- 작업 스케줄러에 등록되어있는 작업 목록 
- 대기 중인 작업 목록 
- 실행된 작업의 히스토리 목록 
- OS 버전에 따라 표시가 다소 다르다

## 22p, dumpsys jobscheduler(OS 7.1의 경우)

```
Settings:
   <단말 설정>
Started users: [0]
   Registered 48 jobs:
   JOB #1000/800 : com.android.server.pm.BackgroundDexOptService
      <JobInfo에 전달한 Schedule 조건>
   JOB #1000/20536: com.android.server.backup.FullBackupJob
      <JobInfo에 전달한 Schedule 조건>
      
[중반은 생략]

Job history:
   -5m54s389ms  STOP:  u0a69 com.example.BackgroundService     
   -5m51s543ms  STOP:  u0a83 com.example.AuthService     
   -21s184ms    START: u0a15 com.example.ServiceName      
   -20s940ms    STOP:  u0a15 com.example.ServiceName
```
 
## 23p, Job Scheduler

- 좋은 점
   - OS 표준이므로 높은 신뢰도
   - 세부 Schedule 조건을 지정할 수 있다
   - 재부팅해도 유지되는 구조가 있다 
   - 다중 사용자 지원 
   - 보류 중인 Job 목록을 가져올 수 있다 (최고!)

## 24p, Job Scheduler

- 미묘한 점!
   - 요구되는 Api 레벨 (5.0 이상)가 높다
   - 프로덕션에서의 이용 실적이 적다
   - 약간의 함정이 있다 (이후에 안내)

## 25p

JobSchduler 개발에서 주의해야 할 함정 이야기

## 26p, 1. 의도하지 않게 Schedule이 사라진다

- 현상
   - 설정한 Schedule이 갑자기 사라졌다
- 재현 조건
   - 5.x의 단말에서 앱을 업데이트하면 초기화된다
- 대응책
   - 패키지 업데이트를 감지하여 재구성

## 27p, 패키지 업데이트 이벤트를 처리한다

```
@Override
public void onReceive(Context context, Intent intent) {
   super.onReceive(context, intent);
   String action = intent.getAction();
   if (Intent.ACTION_MY_PACKAGE_REPLACED.equals(action)) {
      // 예약되어 있는지 확인한다.
   }
} 
```
```
<receiver android:name=".receiver.PackageReplacedBroadcastReceiver">
   <intent-filter>
      <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
   </intent-filter>
</receiver>
```

## 28p, 2. 너무 짧은 DeadLine

- 현상
   - DeadLine의 제약이 의도대로 움직이지 않는다
- 재현 조건
   - DeadLine이 매우 짧은 시간을 설정 (1s 정도) 
   - 일부 단말에서 job의 시작에 몇 분정도 걸린다
- 대책
   - JobScheduler를 즉시성을 추구해서 사용해서는 안 된다

## 29p, 3. 한 번뿐인 Job이 2번 시작한다

- 현상 
   - 한 번뿐인 Schedule이 여러번 시작한다
- 재현 조건 
   - N미만의 모든 단말 
   - Job의 실행 시간보다 Deadline이 짧고 여러번 시작한다
- 대응책 
   - Deadline을 늘려 체크 환경을 준비한다

> [https://stackoverflow.com/questions/33235754/jobscheduler-posting-jobs-twice-not-expected](https://stackoverflow.com/questions/33235754/jobscheduler-posting-jobs-twice-not-expected)

## 30p, 4. 과도한 서비스를 시작하는 단말

- 현상 
   - 일부 단말에서 가정의 수십배 Job을 시작한다
- 재현 조건 
   - 불명 (OS, 기종 등에 치우치지 않는다) 
- 대응책 
   - 체크 환경 준비한다 or 해야만 하는 등 구현을 의식한다

## 31p, GcmNetworkManager

괜찮은 구조를 원하지만, 5.0미만에도 대응하고 싶다

## 32p, GcmNetworkManager

- Google Play services 7.5에서 추가되었다
- JobScheduler과 매우 비슷한 스케줄러 
- 구현이 다른 apk (개발자 서비스)에 있기 때문에 작업의 등록 및 취소는 intent 통해서 잘하고 있다

> [https://android-developers.googleblog.com/2015/05/a-closer-look-at-google-play-services-75.html](https://android-developers.googleblog.com/2015/05/a-closer-look-at-google-play-services-75.html)

## 33p, GCMNetworkManager 샘플 (서비스 쪽)

```
public class MyTaskService extends GcmTaskService {
   @Override
   public void onInitializeTasks() {
      // 앱이 삭제되거나 업데이트된 경우 Schedule이 삭제되므로
      // 여기에 다시 Schedule하는 코드를 작성 (처음에는 불리지 않는다)
   }
   
   @Override
   public int onRunTask(TaskParams taskParams) {
      // 여기에 처리를 작성한다 (Worker 스레드)
      return GcmNetworkManager.RESULT_SUCCESS;
   }
}
```
```
<service
   android:name=".MyTaskService"
   android:exported="true"
   android:permission="com.google.android.gms.permission.BIND_NETWORK_TASK_SERVICE">
   <intent-filter>
      <action android:name="com.google.android.gms.gcm.ACTION_TASK_READY" />
   </intent-filter>
</service> 
```

## 34p, GCMNetworkManager 샘플 (Schedule)

```
public class MainActivity extends AppCompatActivity {

   @Override
   protected void onCreate(Bundle savedInstanceState) {
      // do something.. 
      GcmNetworkManager gcmNetworkManager = GcmNetworkManager.getInstance(this);
      OneoffTask task = new OneoffTask.Builder()
            .setService(MyTaskService.class)
            .setTag(TASK_TAG)
            .setExecutionWindow(0L, 3600L)
            .setPersisted(true)
            .build();
      gcmNetworkManager.schedule(task);
   }
} 
```

- OneoffTask, PeriodicTask의 Builder를 사용하여 Task를 생성하고 GcmNetworkManager에 Schedule한다

## 35p, GCM Network Manager

- 좋은 점
   - Google Play services 7.5+부터 사용할 수 있다
   - 재부팅해도 Schedule이 유지된다
   - 세부 Schedule 조건을 지정할 수 있다
   - Lollipop 이상에서는 JobScheduler를 사용한다 (라고 한다)

## 36p, GCM Network Manager

- 미묘한 점! 
   - 관계성이 얕은 play-services-gcm이 의존에 필요 
   - play-services가 들어있지 않은 단말에서는 사용할 수 없다
      - 일본 국내 시장에서는 거기까지 신경 쓸 필요 없을 것 같다 
   - 장래성이 잘 모르겠다

## 37p, Firebase JobDispatcher

GCM Network Manager 대체 라이브러리

## 38p, Firebase JobDispatcher

- firebase/firebase-jobdispatcher-android 
- Google I/O 2016의 전원/메모리 절약화 세션에서 JobScheduler과 함께 소개되었다
- GCM Network Manager의 대안으로 사용 가능하다

## 39p, FirebaseJobDispatcher 샘플 (서비스 쪽)

```
public class MyJobService extends JobService {
   @Override
   public boolean onStartJob(JobParameters job) {
      Log.d("MyJobService", "onStartJob");
      return false;
   }

   @Override
   public boolean onStopJob(JobParameters job) {
      return false;
   }
}
```
```
<service
   android:name=".MyJobService"
   android:exported="false">
   <intent-filter>
      <action android:name="com.firebase.jobdispatcher.ACTION_EXECUTE" />
   </intent-filter>
</service> 
```

## 40p, FirebaseJobDispatcher 샘플 (Schedule)

```
public class MainActivity extends AppCompatActivity {
   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.activity_main);
      FirebaseJobDispatcher dispatcher = new FirebaseJobDispatcher(new GooglePlayDriver(this));
      Job myJob = dispatcher.newJobBuilder()
               .addConstraint(Constraint.ON_ANY_NETWORK)
               .setService(MyJobService.class)
               .setTag("my-unique-tag")
               .setLifetime(Lifetime.FOREVER)
               .build();
      dispatcher.mustSchedule(myJob);
   }
}
```

- FirebaseJobDispatcher#newJobBuilder에서 Job을 생성 mustSchedule or schedule로 schedule한다

## 41p, Firebase JobDispatcher

- 좋은 점
   - OS 2.3 이상의 단말에서 사용 가능 
   - 재부팅해도 schedule이 유지된다
   - 세부 schedule 조건이 지정할 수 있다
   - OSS로 공개되어 있고, 코드를 읽을 수 있다

## 42p, Firebase JobDispatcher

- 미묘한 점! 
   - 유지 보수가 조금 이상하다
      - issue가 방치되는 경향 
      - 가까스로 최근 maven 저장소에 공개되었다 
   - 실질적으로 PlayServices이 필수 조건 (이후 기술) 
   - 코드는 읽을 수 있지만 전모를 파악할 수 있는 것은 아니다

## 43p

JobDispatcher와 NetworkManager 어느 쪽을 사용해야 할 것인가

## 44p, GCM NetworkManager 구조

어플 -> Job의 시작 조건을 Intent에 채워서 보낸다 -> play-sercies

어플 <- intent-filter를 통해 호출 (com.google.android.gms.gcm.ACTION_TASK_READY
) <- play-sercies

## 45p, Firebase JobDispatcher 구조

어플 -> Job의 시작 조건을 Driver에 전달한다 -> Driver

어플 <- intent-filter를 통해 호출 (com.firebase.jobdispatcher.ACTION_EXECUTE)
) <- play-sercies

## 46p, GooglePlayDriver 구조

어플 -> GooglePlayDriver -> play-sercies

어플 <- GooglePlayDriver <- play-sercies

## 47p, GooglePlayDriver 구조

GooglePlayDriver -> Job의 시작 조건을 Intent에 채워서 보낸다 -> play-sercies

GooglePlayDriver <- intent-filter를 통해 호출 (com.google.android.gms.gcm.ACTION_TASK_READY
) <- play-sercies

## 48p, Firebase JobDispatcher 소감

- Driver라는 추상 구조가 있고, 백엔드 구조는 임의의 것으로 대체할 수 있다
- 현재 (2017/03)에서는 GoolePlayDriver만이 제공 
- AlarmManager와 JobScheduler 기반의 백엔드를 구현할 계획은 있는 것 같다

> [https://github.com/firebase/firebase-jobdispatcher-android/issues/32](https://github.com/firebase/firebase-jobdispatcher-android/issues/32)

## 49p, 2017/03 시점에서 헤매고 있다면 ..

- GCM NetworkManager를 사용하는 것을 추천 
- 공식 문서에서도 낮은 버전의 지원이 필요한 경우 GcmNetworkManager를 권장하고 있다

> [https://developer.android.com/topic/performance/background-optimization.html](https://developer.android.com/topic/performance/background-optimization.html)

## 50p, 이 세션의 정리

- AlarmManager + α 
   - 시간이 정확한 스케줄링을 원한다
- JobScheduler 
   - 배터리 성능을 의식하고 싶다 
   - 다소 지연도 문제없는 일괄 처리 
- GCM networkManager 
   - OS 5.0 이하에서도 지원하고 싶다 
   - PlayServices가 있는 단말만 지원하면 좋다

## 51p, 다른 대안 

- Evernote/android-job 
- SyncAdapter

## 52p, Evernote/android-job라는 선택지

- Evernote가 모든 어둠을 흡수하여 만들어준 최강 작업 스케줄러
- OS 4.0 이상에서 사용 가능 
- AlarmManager, GCM NetworkManger, JobScheduler를 백엔드로 사용한다 
- 라이브러리측이 최적의 백엔드를 선택하므로 개발자는 무엇이 사용되는지 알 필요가 없다

> [https://blog.evernote.com/tech/2015/10/26/unified-job-library-android/](https://blog.evernote.com/tech/2015/10/26/unified-job-library-android/)

## 53p, 기타 참고한 기사

- Scheduling Repeating Alarms 
   - developer.android.com/training/scheduling/alarms.html 
- Scheduling jobs like a pro with JobScheduler 
   - medium.com/google-developers/286ef8510129 
- Samples/JobScheduler 
   - developer.android.com/samples/JobScheduler/index.html 
- Implementing GCM Network Manager on Android 
   - developers.google.com/cloud-messaging/network-manager