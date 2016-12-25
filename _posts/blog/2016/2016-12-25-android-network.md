---
layout: post
title: "[번역] Android 통신 라이브러리의 역사를 되돌아본다"
date: 2016-12-25 23:25:00 +09:00
tag: [Android, Network]
categories:
- blog
- Android
---

본 포스팅은 [Androidの通信ライブラリの歴史を振り返る](http://qiita.com/Reyurnible/items/33049c293c70bd9924ee) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `발표내용에 해당하는 슬라이드와 슬라이드의 일본어 부분만 번역`만 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 소개

왜 이제 와서 이런 아무런 도움이 되지 않는 것을 쓰는지를 이야기를 합니다.

최근 Android를 새로 시작하는 사람은 거침없이 앱 개발을 익히고, 예전에는 힘들었던 통신도 Retrofit 하나로 아무런 망설임 없이 끝납니다. Retrofit은 정말 좋은 라이브러리입니다. 어노테이션을 사용하여 코드를 거의 쓰지 않고 초보자도 알기 쉽게 쓸 수 있으며, 커스터마이즈 가능성도 매우 높습니다.

하지만, 그렇기에 옛날의 Android 통신의 오랜 역사를 알고, 지금까지 이상으로 Retrofit 등의 라이브러리의 훌륭함을 실감해 주었으면 한다고 생각해서 썼습니다.

그리고 가능하면 누군가가 차세대 통신 라이브러리를 만들 때의 거름으로 사용해 줄 것을 바라고 있습니다.

## 주요 역사

- 2007/11/05 : Android가 발표
- 2011/09/29 : [HttpURLConnection을 권장하는 블로그가 나옴](http://android-developers.blogspot.jp/2011/09/androids-http-clients.html)
- 2013/05/06 : OkHttp 1.0.0이 릴리즈 됨
- 2013/05/14 : Retrofit 1.0.0이 릴리즈 됨
- 2013/05/21 : Volley가 릴리즈 됨
- 2016 : [Android6.0에서 HttpClient가 삭제 됨](https://developer.android.com/about/versions/marshmallow/android-6.0-changes.html?hl=ja#behavior-apache-http-client)
- 2016/03/12 : Retrofit2가 릴리즈 됨

Android에서의 통신이라면 HttpClient이었습니다. HttpClient라고해도, DefaultHttpClient라고 불리는 Apache HTTP Client와 AndroidHttpClient이라는 Http Client 변종 등이 사용되고 있었습니다.
하지만, HttpClient에는 몇 가지 버그가 있어, 2011년에는 Google의 Android Developers의 블로그에서 HttpUrlConnection이 권장되고 나서 이쪽이 주로 사용되고 있던 것 같습니다.

그 후, Volley는 사용법이 복잡했던 HttpUrlConnection 대안으로, Google이 만들었다는 것도 있고, 표준 라이브러리로 사용되었습니다. Square의 OkHttp도 인기가 높고, 많이 사용되어 있었습니다.

하지만, Android5.1에서 HttpClient가 Deprecated된 후, HTTPClient에 의존하는 Volley도 Deprecated되었습니다. Square에서 만들어진 라이브러리인 OkHttp와 그 래퍼인 Retrofit의 단 하나 선택 같은 상태가 되었습니다. Retofit에서는 통신 클라이언트 부분과 콜백 형식 등을 플러그로 변경하는 것이 가능하므로 매우 인기 있습니다.

## 구현을 비교

다시 구현을 비교해보고자 합니다.

또한 아직 유행하는지 알 수 없지만 ion라는 라이브러리도 실어둡니다.

이번 기사에 싣는 것은 이쪽입니다.

- DefaultHttpClient
- HttpUrlConnection
- Volley
- OkHttp
- Retrofit2
- ion

### 프로젝트에 대해

이번에는 간단하게 날씨 예보 API를 GET 요청만 하는 샘플을 만들었습니다.

POST 부분에서 바꾸는 부분도 많이 있겠지만, 라이브러리의 사용은 알 거라고 생각하기 때문에 일단 무시했습니다.

사용하는 API는 Livedoor의 날씨 API입니다.

[http://weather.livedoor.com/](http://weather.livedoor.com/)

### 프로젝트의 구성에 대해

프로젝트의 구성은 라이브러리의 사용 방법을 알기 쉽게, DI 등으로 라이브러리는 사용하지 않고 Java 언어 기능만을 사용하여 만들었습니다.

어플에서 하는 것은 각 라이브러리마다 통신을 하고 결과를 Gson을 사용하여 각 Object로 파싱하고 표시하는 데까지입니다. 통신에 사용하는 라이브러리는 Spinner를 사용하여 변경할 수 있도록 하고 있습니다.

패키지의 구성은 다음과 같습니다.

- repository
  - WeatherRepository : Repository 인터페이스
  - WeatherRepositoryImpl{LibraryName} : 각 라이브러리의 구성 클래스
- entities

통신을 할 Repository의 인터페이스는 다음입니다.

Rx를 사용하면 스레드를 만질 수 있어 편리합니다만 라이브러리 사용법의 사용이 어려워져버리므로 다음과 같은 형태로 콜백을 준비했습니다.

`getWeather`에서 라이브러리가 구현할 부분입니다.

```
// WeatherRepository.java
public interface WeatherRepository {
    // URL Const Vals
    String SCHEME = "http";
    String AUTHORITY = "weather.livedoor.com";
    String PATH = "/forecast/webservice/json/v1";
    // URI
    Uri uri = new Uri.Builder()
            .scheme(SCHEME)
            .authority(AUTHORITY)
            .path(PATH)
            .appendQueryParameter("city", "130010")
            .build();

    void getWeather(RequestCallback callback);

    interface RequestCallback {
        // 생성시의 Callback
        void success(Weather weather);

        // 실패시의 Callback
        void error(Throwable throwable);
    }

}
```

또한 각 Repository 인스턴스 관리는 `RepositoryProvider`가 합니다.

## 각 라이브러리의 구현에 대해

### [DefaultHttpClient](https://developer.android.com/reference/org/apache/http/client/HttpClient.html)

DefaultHttpClient를 사용한 예입니다.

Android6에서 DefaultHttpClient는 지워졌기 때문에 이쪽을 사용하려면 `build.gradle`에서 `useLibrary`를 추가합니다.

```
// app/build.gradle
android {
    useLibrary 'org.apache.http.legacy'
}
```

HttpClient는 HttpClient 인스턴스를 만들고 Get 요청하면 HttpGet, Post 요청하면 HttpPost를 사용합니다. Response는 HttpResponse 형식으로 되돌아옵니다.

괴로운 포인트로는 비동기 처리 등을 직접 처리하지 않으면 안 되므로, AsyncTask로 감싸줄 필요가 있습니다.

```
// WeatherRepositoryImplHttpClient.java
public class WeatherRepositoryImplHttpClient implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplHttpClient.class.getSimpleName();

    @Override
    public void getWeather(final RequestCallback callback) {
        new AsyncTask<Void, Void, Weather>() {
            // 처리 전에 호출되는 메소드
            @Override
            protected void onPreExecute() {
                super.onPreExecute();
            }

            // 처리를 하는 메소드
            @Override
            protected Weather doInBackground(Void... params) {
                final HttpClient httpClient = new DefaultHttpClient();
                final HttpGet httpGet = new HttpGet(uri.toString());
                final HttpResponse httpResponse;
                try {
                    httpResponse = httpClient.execute(httpGet);
                    final String response = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
                    return new Gson().fromJson(response, Weather.class);
                } catch (IOException e) {
                    return null;
                }
            }

            // 처리가 모두 끝나면 불리는 메소드
            @Override
            protected void onPostExecute(Weather response) {
                super.onPostExecute(response);
                // 통신 실패로 처리
                if (response == null) {
                    callback.error(new IOException("HttpClient request error"));
                } else {
                    Log.d(TAG, "result: " + response.toString());
                    // 통신 결과를 표시
                    callback.success(response);
                }
            }
        }.execute();
    }
}
```

### [HttpURLConnection](https://developer.android.com/reference/java/net/HttpURLConnection.html)

HttpURLConnection을 사용한 예입니다.

HttpURLConnection은 URL을 생성하고 거기에 연결을합니다.
응답은 버퍼 형식으로 받기 위하여 스스로 String로 변환합니다.

이쪽도 마찬가지로 비동기 처리해야 하므로 괴롭네요.

```
// WeatherRepositoryImplHttpURLConnection.java
public class WeatherRepositoryImplHttpURLConnection implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplHttpURLConnection.class.getSimpleName();

    @Override
    public void getWeather(final RequestCallback callback) {
        new AsyncTask<Void, Void, Weather>() {
            // 처리 전에 호출되는 메소드
            @Override
            protected void onPreExecute() {
                super.onPreExecute();
            }

            // 처리를 하는 메소드
            @Override
            protected Weather doInBackground(Void... params) {
                final HttpURLConnection urlConnection;
                try {
                    URL url = new URL(uri.toString());
                    urlConnection = (HttpURLConnection) url.openConnection();
                    urlConnection.setRequestMethod("GET");
                    urlConnection.setRequestProperty("Content-Type", "application/json; charset=utf-8");
                } catch (MalformedURLException e) {
                    return null;
                } catch (IOException e) {
                    return null;
                }
                final String buffer;
                try {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
                    buffer = reader.readLine();
                } catch (IOException e) {
                    return null;
                } finally {
                    urlConnection.disconnect();
                }
                if (TextUtils.isEmpty(buffer)) {
                    return null;
                }
                return new Gson().fromJson(buffer, Weather.class);
            }

            // 처리가 모두 끝나면 불리는 메소드
            @Override
            protected void onPostExecute(Weather response) {
                super.onPostExecute(response);
                // 통신 실패로 처리
                if (response == null) {
                    callback.error(new IOException("HttpURLConnection request error"));
                } else {
                    Log.d(TAG, "result: " + response.toString());
                    // 통신 결과를 표시
                    callback.success(response);
                }
            }
        }.execute();
    }
}
```

### [Volley](https://android.googlesource.com/platform/frameworks/volley)

Volley를 사용한 예입니다.

Volley에서는 비동기 처리를 감싸주고 있기 때문에 AsyncTask 등 사용하지 않아도 됩니다.
이번에는 Json을 얻고 싶기때문에 JsonObjectRequest를 합니다. Header 정보 등도 멋대로 붙여줍니다.

```
// WeatherRepositoryImplVolley.java
public class WeatherRepositoryImplVolley implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplVolley.class.getSimpleName();

    RequestQueue queue;

    public WeatherRepositoryImplVolley(Context context) {
        queue = Volley.newRequestQueue(context);
    }

    @Override
    public void getWeather(final RequestCallback callback) {
        final JsonObjectRequest request =
                new JsonObjectRequest(uri.toString(), null, new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d(TAG, "result: " + response.toString());
                        final Weather weather = new Gson().fromJson(response.toString(), Weather.class);
                        callback.success(weather);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        callback.error(error);
                    }
                });
        queue.add(request);

    }
}
```

### [OkHttp](http://square.github.io/okhttp/)

OkHttp을 사용한 예입니다.

OkHttp는 통신을 동기화로할지 비동기 처리로할지 선택할 수 있습니다.
그러나 스레드를 넘나들 수 없으므로 Handler를 사용합니다.

```
// WeatherRepositoryImplOkHttp3.java
public class WeatherRepositoryImplOkHttp3 implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplOkHttp3.class.getSimpleName();

    private Handler handler = new Handler();

    @Override
    public void getWeather(final RequestCallback callback) {
        final Request request = new Request.Builder()
                // URL 생성
                .url(uri.toString())
                .get()
                .build();
        // 클라이언트 개체를 만듬
        final OkHttpClient client = new OkHttpClient();
        // 새로운 요청을 한다
        client.newCall(request).enqueue(new Callback() {
            // 통신이 성공했을 때
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                // 통신 결과를 로그에 출력한다
                final String responseBody = response.body().string();
                Log.d(TAG, "result: " + responseBody);
                final Weather weather = new Gson().fromJson(responseBody, Weather.class);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        callback.success(weather);
                    }
                });
            }

            // 통신이 실패했을 때
            @Override
            public void onFailure(Call call, final IOException e) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        callback.error(e);
                    }
                });
            }
        });
    }
}
```

### [Retrofit](http://square.github.io/retrofit/)

Retrofit을 사용한 예입니다.

Retrofit은 어노테이션을 사용하여 코드를 생성하기 때문에 이를 위한 인터페이스를 만듭니다.

```
// WeatherRepositoryImplRetrofit2.java
public class WeatherRepositoryImplRetrofit2 implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplRetrofit2.class.getSimpleName();

    private final WeatherService service;

    public WeatherRepositoryImplRetrofit2() {
        final Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(new Uri.Builder().scheme(SCHEME).authority(AUTHORITY).build().toString())
                .client(new OkHttpClient())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        service = retrofit.create(WeatherService.class);
    }

    @Override
    public void getWeather(final RequestCallback callback) {
        service.getWeather(130010).enqueue(new Callback<Weather>() {
            @Override
            public void onResponse(Call<Weather> call, Response<Weather> response) {
                Log.d(TAG, "result: " + response.body().toString());
                callback.success(response.body());
            }

            @Override
            public void onFailure(Call<Weather> call, Throwable error) {
                callback.error(error);
            }
        });
    }

    private interface WeatherService {
        @GET(PATH)
        Call<Weather> getWeather(@Query("city") int city);
    }

}
```

### [ion](https://github.com/koush/ion)

ion을 사용한 예입니다.

ion은 아주 간단한 라이브러리이지만, 스레드 등도 좋은 느낌으로 해줍니다.
callback의 형태는 `as`라는 부분에서 제어할 수 있으며, `TypeToken`을 지정하면 뒤에서 Gson을 사용하여 객체를 Parse 합니다.

```
// WeatherRepositoryImplIon.java
public class WeatherRepositoryImplIon implements WeatherRepository {
    public static final String TAG = WeatherRepositoryImplIon.class.getSimpleName();

    private Context context;

    public WeatherRepositoryImplIon(Context context) {
        this.context = context;
    }

    @Override
    public void getWeather(final RequestCallback callback) {
        // 클라이언트 개체를 만든다
        // 새로운 요청을 한다
        Ion.with(context)
                .load(uri.toString())
                .as(new TypeToken<Weather>() {
                })
                .setCallback(new FutureCallback<Weather>() {
                    // 통신이 종료했을 때
                    @Override
                    public void onCompleted(Exception e, Weather weather) {
                        // 통신이 실패했을 때
                        if (e != null) {
                            callback.error(e);
                            return;
                        }
                        // 통신 결과를 로그에 출력한다
                        Log.d(TAG, "result: " + weather.toString());
                        callback.success(weather);
                    }
                });
    }
}
```

## 마지막으로

역시 Retrofit은 훌륭하네요.
하지만 이번에 사용하면서 ion도 간단하게 사용할 수 있어 교육 목적 등에서는 매우 좋지 않을까 생각했습니다.

이번 소스는 여기에 있습니다.
이외에도 Retrofit1과 OkHttp2 등의 사용 버전도 여기에 게재되어 있습니다.
교육적으로도 재미있다고 생각하니 봐주셨으면 생각합니다.

[https://github.com/Reyurnible/AndroidNetworkHistory](https://github.com/Reyurnible/AndroidNetworkHistory)

댓글에 여러분의 흑역사를 게시해주시면 기쁩니다. 기다리겠습니다.

### 참고

- [Android의 통신 처리에 무엇을 사용하면 좋을지 모른다고 한 이야기. - 되도록 될지도](http://quesera2.hatenablog.jp/entry/2014/11/22/021741)
- [Android 6.0에서 Apache HTTP Client가 삭제되었습니다. - RiskFinder 주식 회사 블로그](http://blog.riskfinder.co.jp/2015/10/android-60apatch-http-client.html)
- [Android 버전 Cookpad 앱에서 채택하고있는 기술 현황 확인 2015년판 - Cookpad 개발자 블로그](http://techlife.cookpad.com/entry/2015/06/25/093507)
- [Yuki의 분석 : Android : Deprecated HTTP Classes on Android5.1](http://yuki312.blogspot.jp/2015/03/android-deprecated-http-classes-on.html)
