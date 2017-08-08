---
layout: post
title: "[번역] Function Introduction of Google Play Services"
date: 2017-08-09 01:40:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [Function Introduction of Google Play Services](https://speakerdeck.com/syarihu/droidkaigi-2017-function-introduction-of-google-play-services) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, Function Introduction of Google Play Services

DroidKaigi 2017

2017/03/09 (Thu.)

Taichi Sato (@syarihu)

## 2p, 대상자

- Android 앱 개발을 어느 정도 해본 적이 있는 사람
- Google Sign-In API에 관심이 있는 사람
- ASO에 관심 있는 사람
- App Invites에 관심이 있는 사람

## 3p, 이야기 주제

1. Google Sign-In API
2. Google Plus One Button
3. App Invites for Android

## 4p

자기 소개

## 5p, Taichi Sato (@syarihu)

- GMO Media, inc.
- 엔지니어
   - Android 앱
   - 서버 사이드 앱 (Java)

## 6p

Point Town

## 7p

Google Sign-In API

## 8p, 이전의 Google Sign-In

- 계정 선택 화면 AccountManager.newChooseAccountIntent
- 스스로 Intent 보내고, 돌아오면 여러 가지 해준다 ...

## 9p, 이전의 Google Sign-In

- AuthToken 취득 (AccountManager#getAuthToken)
   - 인증 상태 확인
   - 인증되지 않은 경우, 인증 허가 대화 상자를 표시
   - 인증되어 있으면 AuthToken을 취득
   - 인증 허가가 안되면 재취득도 스스로 ...

## 10p, 이전의 Google Sign-In

계정 선택에 사용하는 메소드

```
AccountManager.newChooseAccountIntent(
Account selectedAccount,
ArrayList<Account> allowableAccounts,
String[] allowableAccountTypes,
boolean alwaysPromptForAccount,
String descriptionOverrideText,
String addAccountAuthTokenType,
String[] addAccountRequiredFeatures,
Bundle addAccountOptions)
```

## 11p, 이전의 Google Sign-In

AuthToken 취득에 사용하는 메소드

```
AccountManager#getAuthToken(
Account account,
String authTokenType,
Bundle options,
boolean notifyAuthFailure,
AccountManagerCallBack<Bundle> callback,
Handler handler)
```

## 12p, 새로운 Google Sign-In API

- Google Play Services 8.3을 출시했을 때, 그 신기능의 하나로서 새로운 Google Sign-In API가 공개되었다

## 13p~14p, 새로운 Google Sign-In API

- Google Sign-In을 Android에서 구현하기 위해서는 이전에는 구현이 매우 귀찮았다
- 이것을 쉽게 구현할 수 있게 된 것이 새로운 Google Sign-In API

## 15p~19p, 새로운 Google Sign-In API

- 계정을 취득하고 로그인하는 데 권한이 필요 없다
- 새롭게 디자인된 로그인 버튼
- 구현도 이전보다 간단
- Silent Sign-In

## 20p

샘플 앱

## 21p~27p

1. 로그인 버튼을 누른다
2. 계정을 선택한다
3. 권한 부여한다
4. 로그인 완료
4. 로그인 정보를 이용하여 뭔가 한다
5. 로그아웃한다

## 28p, Silent Sign-In

- 사용자가 이전에 다른 플랫폼의 앱에 권한을 허가한 경우, Silent Sign-In을 사용할 수 있다

## 29p, Silent Sign-In

- 프로젝트의 클라이언트가 요구 사항을 충족하도록 구성되어 있는 경우 사용자는 즉시 응용 프로그램에 로그인할 수 있다

## 30p, Silent Sign-In 요구사항

- OAuth 2.0 클라이언트 ID는 같은 Google Developer Console 프로젝트이어야 한다
- OAuth Scope는 양쪽 클라이언트 모두 동일해야한다

## 31p

요컨대 이렇게 되어있으면

## 32p

새롭게 허가할 필요가 없다

## 33p, 다국어 대응

- com.google.android.gms.common.SignInButton은 지역화된 문자열을 제공하고 있으며, 이들은 자동으로 사용할 수 있다

## 34p, 다국어 대응

어느 언어에 대응하고 있는지 등을 확인하기 위해서는 SDK의 아래 디렉토리에서 확인할 수 있다

```
<android-sdk-folder>/extras/google/google_play_services/libproject/google-play-services_lib/res/
```

## 35p

Google Sign-In API의 구현

## 36p, Google Sign-In을 사용하기 위한 전제 조건

- Google Play Store를 포함한 Android 2.3 이상
- 또는 Android 4.2.2 이상의 Google API 플랫폼을 실행하는 Google Play Services의 버전 9.8.0 이상을 포함 AVD

## 37p, 사전 준비

1. 설정 파일 취득, 배치
2. build.gradle에 추가

## 38p, 설정 파일 취득

- 설정 파일에는 서비스 고유의 정보가 기술되어있다
- Google API Console에서 기존 프로젝트를 선택하거나 새 프로젝트를 만들 필요가 있다

## 39p, 설정 파일 취득

- 앱 패키지명과 서명 인증서의 SHA-1 해시도 필요

## 40p, 설정 파일 취득

Google Developer Console에 프로젝트가 이미 있는 경우 다음 페이지에서 google-services.json를 얻을 수 있다.

[https://developers.google.com/mobile/add?platform=android](https://developers.google.com/mobile/add?platform=android)

## 42p, 설정 파일 취득

추가하려는 프로젝트가 Firebase의 경우 Firebase Console에서 google-services.json를 얻을 수 있다.

[https://console.firebase.google.com/](https://console.firebase.google.com/)

## 44p, 설정 파일 배치

- 다운로드 한 google-services.json을 프로젝트의 app 폴더 아래에 배치한다

## 45p, build.gradle에 추가

- 프로젝트의 build.gradle에 아래를 추가

```
classpath 'com.google.gms:google-services:3.0.0'
```

## 46p, build.gradle에 추가

- app의 build.gradle에 아래를 추가

```
compile 'com.google.android.gms:play-services-auth:10.2.0'
```

## 47p, build.gradle에 추가

- app의 build.gradle에 `가장 아래에` 아래를 추가

```
apply plugin: 'com.google.gms.google-services'
```

## 48p, Google Sign-In API의 구현

- GoogleSignInOptions 객체를 생성
- GoogleApiClient 객체를 생성
- Google 로그인 버튼 추가
- 로그인 처리 구현
- 로그아웃 처리 구현

## 49p~51p, GoogleSignInOptions 객체를 생성

```
GoogleSignInOptions gso = 
   new GoogleSignInOptions.Builder(
      GoogleSignInOptions.DEFAULT_SIGN_IN
   )
   .requestEmail()
   .build();
```

## 52p, GoogleSignInOptions 객체를 생성

```
mScope = new Scope("https://www.googleapis.com/auth/urlshortener");
```

## 53p~54p, GoogleSignInOptions 객체를 생성

```
GoogleSignInOptions gso =
   new GoogleSignInOptions.Builder(
      GoogleSignInOptions.DEFAULT_SIGN_IN
   )
   .requestScopes(mScope)
   .requestEmail()
   .build();
```

## 55p, GoogleApiClient 객체를 생성

```
mGoogleApiClient =
   new GoogleApiClient.Builder(this)
      .enableAutoManage(
         this /* FragmentActivity */,
         this /* OnConnectionFailedListener */)
      .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
      .build();
mGoogleApiClient.connect();
```

## 56p, Google 로그인 버튼 추가

```
<com.google.android.gms.common.SignInButton
   android:id="@+id/sign_in_button"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```

## 57p~58p, 로그인 처리 구현

```
Intent signInIntent =
   Auth.GoogleSignInApi
      .getSignInIntent(mGoogleApiClient);
startActivityForResult(signInIntent, RC_SIGN_IN);
```

## 59p, 로그인 처리 구현

```
@Override
public void onActivityResult(
   int requestCode,int resultCode,
   Intent data) {
      super.onActivityResult(requestCode, 
         resultCode, data);
      /** GoogleSignInResult */
}
```

## 60p~61p, 로그인 처리 구현

```
if (requestCode == RC_SIGN_IN) {
   GoogleSignInResult result =
      Auth.GoogleSignInApi
            .getSignInResultFromIntent(data);
      handleSignInResult(result);
}
```

## 62p~64p, 로그인 처리 구현

```
private void handleSignInResult(GoogleSignInResult result) {
   if (result.isSuccess()) {
      mGoogleSignInAccount = result
         .getSignInAccount();
      showMessage(result.getSignInAccount()
         .getEmail());
   }
}
```

## 65p~66p, 로그아웃 처리 구현

```
Auth.GoogleSignInApi
   .signOut(mGoogleApiClient)
   .setResultCallback(
      // new ResultCallback
   );
```

## 67p, 로그아웃 처리 구현

```
new ResultCallback<Status>() {
   @Override
   public void onResult(Status status) {
      // 로그아웃 후 처리
   }
});
```

## 68p~69p, 권한 취소

```
Auth.GoogleSignInApi
   .revokeAccess(mGoogleApiClient)
   .setResultCallback(
      // new ResultCallback
   );
```

## 70p, 권한 취소

```
new ResultCallback<Status>() {
   @Override
   public void onResult(Status status) {
      signOut();
   }
});
```

## 71p, GoogleSignInStatusCodes

- status.getStatusCode()에서 StatusCode를 얻을 수 있다.
- GoogleSignInStatusCodes 내용은 다음을 참조
[https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInStatusCodes](https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInStatusCodes)

## 72p, AuthToken 취득

- AccountManager에서 OAuth2 인증할 때는 AccountManager#getAuthToken을 사용하여 AuthToken를 취득했다

## 73p, AuthToken 취득

- GoogleSignInAccount에 그런 메소드는 없기 때문에 GoogleAuthUtil.getToken을 사용하여 AuthToken를 얻는다.

## 74p, AuthToken 취득

- AuthToken를 얻으면, 나머지는 이전과 마찬가지로 API에 요청을 보낼 때, 이 AuthToken을 access_token 매개 변수로 전달해주는 것으로, API를 이용할 수 있다.

## 75p, AuthToken 취득

```
GoogleAuthUtil.getToken(context, new Account(
   mGoogleSignInAccount.getEmail(),
   ACCOUNT_TYPE),
   "oauth2:" + SHORTENER_SCOPE
);
```

## 76p, AuthToken 취득

- SHORTENER_SCOPE
   - "[https://www.googleapis.com/auth/urlshortener](https://www.googleapis.com/auth/urlshortener)"
- ACCOUNT_TYPE
   - "com.google"

## 77p, Slient Sign-In

- 이미 권한을 부여받는 경우 Silent Sign-In을 이용하여 로그인할 수 있다

## 78p~79p, Slient Sign-In

```
@Override
public void onResume() {
   super.onResume();
   OptionalPendingResult<GoogleSignInResult> opr =
      Auth.GoogleSignInApi
         .silentSignIn(mGoogleApiClient);
}
```

## 80p, Silent Sign-In 성공시

```
if (opr.isDone()) {
   GoogleSignInResult result = opr.get();
   handleSignInResult(result);
}
```

## 81p, 샘플 코드

- syarihu/GoogleSignInTest: New Google Sign-In API Sample

[https://github.com/syarihu/GoogleSignInTest](https://github.com/syarihu/GoogleSignInTest)

## 82p, Qiita

- Android의 새로운 Google 로그인 API에 대해 - Qiita

[http://qiita.com/syarihu/items/1c67816ad926f08d76d8](http://qiita.com/syarihu/items/1c67816ad926f08d76d8)

## 83p

Google Plus One Button

## 84p, Google Plus One Button이란?

- 사용자가 좋아하는 콘텐츠를 Google 검색에서 추천하거나 Google+로 공유할 수 있는 기능

## 85p, Google Plus One Button이란?

- 누르면 숫자가 증가
- Facebook에서 말하는 "좋아요!" 같은 것

## 86p, Google Plus One Button이란?

- Google Play 스토어에는 이 버튼은 존재하지 않는다

## 87p, Google+1은 ASO에 영향이 있는가

- ASO를 알아보니, Google+1 수는 검색 순위에 영향을 미친다는 같은 기사를 봤다
- 정말 오를지 궁금했기 때문에 실제로 검증해 봤다

## 88p

해본 것

## 89p~95p, 해본 것

- 앱 최초 실행 후, 3일 이상 경과 한 경우에 "+1 응원 부탁드립니다!"와 같은 대화 상자를 표시한다

## 96p

구현 방법

## 97p, build.gradle의 dependencies에 추가

```
dependencies {
   compile "com.google.android.gms:play-services-plus:10.2.0"
}
```

## 98p, Google+1 버튼을 xml에 추가

```
<com.google.android.gms.plus.PlusOneButton
   xmlns:plus="http://schemas.android.com/
   apk/lib.com.google.android.gms.plus"
   android:id="@+id/plus_one_button"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:layout_gravity="center"
   android:layout_margin="8dp"
   plus:annotation="inline"
   plus:size="medium"/>
```

## 99p, Activity onResume에서 초기화

```
PlusOneButton button = (PlusOneButton) findViewById(R.id.plus_one_button);
```

## 100p, Activity onResume에서 초기화

```
private static final REQUEST_CODE_PLUS_ONE = 0;
// +1 버튼 초기화
button.initialize("https://play.google.com/store/apps/details?id=패키지명", REQUEST_CODE_PLUS_ONE);
```

## 101p, 클릭시에 뭔가 하고 싶을 때

```
implements PlusOneButton.OnPlusOneClickListener {
```

## 102p, 클릭시에 뭔가 하고 싶을 때

```
// +1 버튼 초기 화
button.initialize("https://play.google.com/store/apps/details?id=패키지명", this /** OnPlusOneClickListener */);
```

## 103p, 클릭시에 뭔가 하고 싶을 때

```
@Override
public void onPlusOneClick(Intent intent) {
   // PlusOne Activity를 시작한다
   startActivityForResult(intent, PLUS_ONE_BUTTON);
}
```

## 104p~106p, Google+1 수의 변화

- 릴리즈한 이후
   - 1개월 후 ... 약 2배 증가
   - 1년 후 ... 약 6배 증가

## 107p, 클릭 이벤트

## 108p, 무료 Top 종합 순위

## 109p, 카테고리 순위

## 110p, 검색 순위

## 111p, 결과

- 종합 순위, 카테고리 순위에 큰 영향을 준다
- 일시적으로 상승하지만, 그 상태를 유지하는 것이 아니라 점차 떨어진다

## 112p, 결과

- 검색 순위에는 다소 영향을 준다
- 여기는 한번 오른 후는 별로 떨어지지 않는다
- 종합 순위, 카테고리 순위보다 결과가 빨리 나오기 어렵다

## 113p, 결과

- +1 수가 순위를 결정하기 위한 하나의 요소임을 알았다
- 종합 순위, 카테고리 순위는 항상 변화하고 있으므로 상위를 유지하기 위해 +1 이외의 요소가 필요

## 114p, 결과

- 구현이 쉽고 장기적으로 보고 오를 가능성이 있기 때문에 여유가 있으면 구현해야 한다

## 115p

App Invites for Android

## 116p~117p, App Invites 란

- Google Play Services 8.1에서 등장한 메일이나 SMS로 친구·지인을 쉽게 초대할 수 있는 구조
- 개발자가 초대 메일을 사용자 정의할 수 있다

## 118p, App Invites 란

- 메일 초대 링크에서 앱을 설치하면 이메일로 공유된 내용을 딥 링크로 자연스럽게 앱을 열 수 있다

## 119p, App Invites 란

- 현재는 Firebase Invites라는 이름이 되었지만 기능 자체는 Firebase Invites가 되기 이전과 거의 동일

## 120p, Firebase Invites 와의 차이

- play-services-appinvite에 의존하고 있다
- 사용하는 클래스의 패키지명은 com.google.android.gms.appinvite이다

## 121p, Firebase Invites 와의 차이

- 앱 설치용으로 생성된 링크는 Firebase Invites가 되고 나서 FirebaseDynamic Links 링크가 생성되게 되었다

## 122p~123p, Firebase Invites 와의 차이

- 이전 : [https://plus.google.com/appinvites/xxxxxxxxx-xxxxxxxx-xxxxxxxxxxx](https://plus.google.com/appinvites/xxxxxxxxx-xxxxxxxx-xxxxxxxxxxx)
- 지금 : [https://xxxxx.app.goo.gl/xxxxxxxxx-xxxxxxxx-xxxxxxxxxxx](https://xxxxx.app.goo.gl/xxxxxxxxx-xxxxxxxx-xxxxxxxxxxx)

## 124p

Google Santa Tracker

## 125p 

초대하는 쪽

## 126p, [초대하는 쪽] 게임에서 논다

## 127p~128p, [초대하는 쪽] 게임에서 논다

- 이 게임 재미있어!
- 누구에게 공유하고 싶어!

## 129p~130p, [초대하는 쪽] 공유 버튼을 누른다

## 131p~134p, [초대하는 쪽] App Invites 초대 화면

- 연락처를 선택해서
- 송신 버튼을 누를 뿐

## 135p, [초대하는 쪽] 메일 송신 완료

송신 완료!

## 136p

초대되는 쪽

## 137p, [초대되는 쪽] 메일 수신

아, 뭔가 친구한테서 메일 왔다

## 138p~139p, [초대되는 쪽] 메일 수신

재미있어 보이니깐 설치해보자

## 140p, [초대되는 쪽] 앱 설치

## 141p~142p, [초대되는 쪽] 앱 기동

앱 시작 후 딥 링크가 발동하여 공유된 게임을 즉시 놀 수 있다!

## 143p

App Invites 흐름

## 144p, 초대할 때

초대장 송신 -> 메일 or SMS -> 초대장 수신

## 145p, 초대될 때 (앱 미설치 시)

스토어 -> 앱 설치 -> 앱 열기 -> 딥 링크 발동 -> 앱 기동

## 146p, 초대될 때 (이미 앱 설치 상태)

앱을 연다 -> 딥 리이크 발동 -> 앱 기동

## 147p

App Invites 구현

## 148p, 전 준비

1. Firebase Dynamic Links 활성화
2. 설정 파일 가져오기, 배치
3. build.gradle에 추가

## 149p, Firebase Dynamic Link 활성화

- App Invites에 초대할 때 생성되는 공유 링크는 Firebase Dynamic Links를 이용하고 있다

## 150p, Firebase Dynamic Link 활성화

- 따라서 Firebase Dynamic Links를 사용하지 않는 경우 Firebase Console에서 [Dynamic Links] 섹션을 열고 표시되는 이용 약관에 동의하여 활성화한다

## 151p, 설정 파일 취득

- Firebase Console에서 google-services.json을 취득한다

[https://console.firebase.google.com/](https://console.firebase.google.com/)

## 153p, 설정 파일 배치

- 다운로드한 google-services.json을 프로젝트의 app 폴더 아래에 배치한다

## 154p, build.gradle에 추가

- 프로젝트 build.gradle 다음을 추기

```
classpath 'com.google.gms : google-services : 3.0.0'
```

## 155p, build.gradle에 추가

- app의 build.gradle에 아래를 추가

```
compile 'com.google.firebase:firebase-core:10.2.0'
compile 'com.google.firebase:firebase-invites:10.2.0'
```

## 156p, build.gradle에 추가

- app의 builde.gradle의 `가장 아래에` 이하를 추가

```
apply plugin: 'com.google.gms.google-services'
```

## 157p, App Invites 구현

- 딥 링크용 Activity를 작성
- App Invites 초대장 전송 화면을 시작한다
- 앱 시작시의 Activity에서 App Invites을 받는다

## 158p~159p, 딥 링크용 Activity 작성

```
public class AppInvitesActivity extends AppCompatActivity {
   @Override
   protected void onStart() {
      super.onStart();
      Intent intent = getIntent();
      // Intent에 App Invites 정보가 포함되어 있는지 검사
      if (AppInviteReferral.hasReferral(intent)) {
         processReferralIntent(intent);
      }
   }
```

## 160p, 딥 링크용 Activity 작성

```
private void processReferralIntent(Intent intent) {
   // 초대 ID 취득
   String invitationId = AppInviteReferral.getInvitationId(intent);
   // 딥 링크용 URL 취득
   String deepLink = AppInviteReferral.getDeepLink(intent);
   // 딥 링크 URL에 포함된 매개 변수를 사용해서
   // 뭔가 처리한다
```

## 161p, 딥 링크용 Activity 작성

```
<activity android:name=
   ".app.ui.AppInvitesActivity">
   <!-- [START deep_link_filter] -->
   <intent-filter>
      <!-- action, category, data -->
   </intent-filter>
   <!-- [END deep_link_filter] -->
</activity>
```

## 162p, 딥 링크용 Activity 작성

```
<action android:name=
   "android.intent.action.VIEW"/>
   <category android:name=
      "android.intent.category.DEFAULT"/>
   <category android:name=
      "android.intent.category.BROWSABLE"/>
   <data android:host="invites.syarihu.net"
      android:scheme="http" />
```

## 163p~165p, 초대장 송신 화면 실행

```
Intent intent = new AppInviteInvitation
   .IntentBuilder("액션바의 제목 부분")
   .setMessage("메일 본문의 상단 부분")
   .setDeepLink(Uri.parse(getString(R.string.invitation_deep_link) + "?param=hoge"))
   .setGoogleAnalyticsTrackingId(GA_TRACKER_ID)
```

## 166p~167p, 초대장 송신 화면 실행

```
   .setEmailHtmlContent("<html><body>"
      + "<h1>App Invites</h1>"
      + "<a href=\"%%APPINVITE_LINK_PLACEHOLDER%%\">Install Now!</a>"
      + "<body></html>")
   .setEmailSubject("メール䛾タイトル")
   .build();
```

## 168p, 초대장 송신 화면 실행

```
startActivityForResult(intent, 0);
```

## 169p, App Invites를 받기

```
mGoogleApiClient = new GoogleApiClient.Builder(this)
      .enableAutoManage(
         this /* FragmentActivity */,
         this /* OnConnectionFailedListener */)
      .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
      .build();
mGoogleApiClient.connect();
```

## 170p, App Invites 받기

```
boolean autoLaunchDeepLink = true;
AppInvite.AppInviteApi.getInvitation(
   mGoogleApiClient,
   this /* Activity */,
   autoLaunchDeepLink
)
```

## 171p, App Invites 받기

```
boolean autoLaunchDeepLink = false;
AppInvite.AppInviteApi.getInvitation(
   mGoogleApiClient,
   this,
   autoLaunchDeepLink
).setResultCallback(
   /** ResultCallback */
);
```

## 172p, App Invites 받기

```
new ResultCallback<AppInviteInvitationResult>() {
   @Override
   public void onResult(AppInviteInvitationResult result) {
      // 여기에 직접 딥 링크를 받아
      // Activity를 시작하는 처리를 적는다
   }
});
```

## 173p

효과 검증 방법

## 174p, 효과 검증은 어떻게해?

- Google Analytics와 연계하면, 송신, 수락, 성립 수치를 얻을 수 있다

## 175p, 효과 검증은 어떻게해?

- 송신
   - 메일 혹은 SMS을 클릭
- 수락
   - 메일의 설치 링크를 클릭

## 176p, 효과 검증은 어떻게해?

- 성립
   - 메일의 설치 링크 경유로 앱을 설치

## 177p, 효과 검증은 어떻게해?

- App Invites에서 Firebase Invites로 바뀐 시점에 Google Analytics와의 연계 방법에 대한 문서가 사라진 것 같다

## 178p, Google Analytics 설정

- 관리 -> 속성 -> 사용자 정의 -> 사용자 정의 측정 -> 새 사용자 정의 측정에서 측정을 추가

## 180p, Google Analytics 설정

- 이 측정은 사용자 정의 측정 테이블의 인덱스 1 이어야 한다.

## 182p, Google Analytics 설정

- 미리 정의된 [App Invites dashboard](https://www.google.com/analytics/web/template?uid=Po4taKHETwmWrzqOOqrlQQ)를 다운로드하고 TrackingID -> 모든 모바일 앱의 데이터를 선택
- [https://www.google.com/analytics/web/template?uid=Po4taKHETwmWrzqOOqrlQQ](https://www.google.com/analytics/web/template?uid=Po4taKHETwmWrzqOOqrlQQ)

## 184p, Google Analytics 설정

- App Invites 보고서는 왼쪽 탐색 패널에서 내 보고서 목록 -> 비공개 -> AppInvites (방금 적은 이름)을 선택하여 확인할 수 있다

## 186p~188p, 보고서의 보는 방법

- 초대 메일 수
- 설치 링크 클릭 수
- 설치 수

## 189p, 이벤트를 직접 볼 경우

- 이벤트 범주
   - Invitation
- 이벤트 액션
   - Sent
   - Accepted
   - Completed

## 190p, Google Analytics 설정

- Google Analytics는 즉시 App Invites 데이터의 수신을 시작하는데 Google Analytics가 표시하는데 필요한 데이터를 얻기까지 1~2 일 소요되므로 처음에는 빈 데이터가 된다

## 191p

App Invites를 도입한 결과

## 192p, 도입 항목

- 메일 앱을 소개하는 버튼을 눌렀을 때
- 지금까지 메일 앱을 시작할 수 있도록 했는데, 그것을 App Invites가 시작하도록 변경했다

## 194p, 결과

- 전송의 약 50%가 수락하고 그 약 30%가 성립했다
- App Invites를 도입에 따른 설치 수에 큰 변화는 없었다

## 195p, 결과

- **Point Town의 경우** 콘텐츠의 공유가 아니라 단순히 앱을 소개하는 이메일이기 때문에 딥 링크를 살린 이메일로 하면 좀 더 개선할 수 있을지도 모른다

## 196p, App Invites를 도입해야 하는가

- 원래 이메일로 무언가를 공유하는 기능이 있는 경우, 이를 구현하면 3단계 (공유 버튼을 누른다, 연락처를 선택한다, 송신한다)에서 앱 내에서 메일을 보낼 수 있고, 사용자 경험 향상으로 이어지기 때문에 도입하는 것이 좋다

## 197p, Google Santa Tracker

- google/santa-tracker-android: Ho Ho Ho

[https://github.com/google/santa-tracker-android](https://github.com/google/santa-tracker-android)

## 198p, Qiita

- App Invites의 구조를 이해 - Qiita

[http://qiita.com/syarihu/items/1847a7f1caf7f71d26a4](http://qiita.com/syarihu/items/1847a7f1caf7f71d26a4)

## 199p

정리

## 200p, 정리

- 새로운 Google Sign-In API는 도입이 쉽고 권한도 불필요
- 다른 플랫폼에서 로그인하는 경우 Silent Sign-In로 로그인할 수 있다

## 201p, 정리

- Google+1은 종합 순위, 검색 순위를 결정하는 하나의 중요한 요소이다
- Google+1 수를 올리는 것은 장기적으로 순위가 오를 가능성이 있으므로 여유가 있으면 구현해야 한다

## 202p, 정리

- 애초에 메일로 무언가를 공유하는 기능이 있으면 App Invites에 의한 사용자 경험의 향상으로 연결되어 도입하는 것이 좋다