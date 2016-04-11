---
layout: post
title: "[번역] AutoCompleteTextView로 해시태그 기능을 구현해보자"
date: 2015-12-13 18:00:00
tag: [Android, AutoCompleteTextView]
categories:
- blog
- Android
---

본 포스팅은 [AutoCompleteTextViewでハッシュタグの補完を実装してみる](http://qiita.com/Horie1024/items/545659072250ca0b24ed) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할수 있습니다.

<!--more-->

- - -

트위터에 투고할 때이나 Instagram에 설명을 적을 때 해시 태그를 입력하면 단어 목록이 표시되고 쉽게 해시태그를 입력할 수 있습니다. 제가 개발하고 있는 어플리케이션 [iQON](https://play.google.com/store/apps/details?id=jp.vasily.iqon&hl=ja)에도 작성한 코디를  게시할 때 등 해시 태그를 붙일 수 있습니다만, 자동완성이 구현되어 있지않습니다.

여기에서, 해시 태그의 자동완성을 구현해보려고 합니다.

## 우선 자동 완성 처리를 보자

살펴보면, [yanzm씨의 기사](http://y-anz-m.blogspot.jp/2013/02/androidautocompletetextview.html)에 소개된 AutoCompleteTextView를 사용해서 구현할 수 있을 것입니다. [AutoCompleteTextView의 Reference](http://developer.android.com/intl/ja/reference/android/widget/AutoCompleteTextView.html)를 보면 아래와 같은 샘플코드가 소개되어 있습니다.


```java
public class CountriesActivity extends Activity {
    protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        setContentView(R.layout.countries);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                android.R.layout.simple_dropdown_item_1line, COUNTRIES);
        AutoCompleteTextView textView = (AutoCompleteTextView)
                findViewById(R.id.countries_list);
        textView.setAdapter(adapter);
    }

    private static final String[] COUNTRIES = new String[] {
            "Belgium", "France", "Italy", "Germany", "Spain"
    };
}
```

AutoCompleteTextView에 단어 리스트를 가지는 Adapter를 설정함으로, 처리됩니다. 단어를 해시 태그같이 해서 우선 작동해 보세요.


```java
private static final String[] COUNTRIES = new String[] {
    "#Belgium", "#France", "#Italy", "#Germany", "#Spain"
};
```

또, layout은 아래와 같이 정의합니다.


```xml
<AutoCompleteTextView
    android:id="@+id/countries_list"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />
```

어플리케이션을 빌드해서 입력해보면, 아래와 같이 입력에 맞춰 팝업이 나타나 단어가 표시됩니다. 복수 해시 태그가 있는 경우에는 자동 완성이 안되지만, 이것으로 자동 완성을 하기 위해서 필요한 최소한의 방법을 배웠습니다.

<img src="http://tech.vasily.jp/images/tech-blog/horie_20151212_qiita/hashtag1.gif" />

## AutoCompleteTextView 구조

해시 태그 자도 완성을 만들기 위해 AutoCompleteTextVie 구조를 찾아봤습니다. 내용이 길어져 버려서 다른 포스팅으로 정리했습니다.

[AutoCompleteTextView 구조를 찾아보자](http://qiita.com/Horie1024/items/d52ef21c589b135b5c37)

## 해시 태그 자동 완성 기능

구현하고 싶은 기능을 적어봤습니다.

- 복수 해시 태그가 존재할 경우, 현재 입력 중인 해시 태그만을 자동 완성 처리
- 항목 리스트에서 선택된 현재 입력 중인 해시 태그만 선택한 항목으로 교체한다.
- 해시 태그의 단어 리스트는 동적으로 준비한다.

이 기능을 구현하기 위해서 구현하겠습니다.

## 해시 태그 자동 완성 구현

### 커스텀 Adapter 작성

ArrayAdapter를 상속한 커스텀 Adapter를 작성해, getFilter로 반환할 filter는 Filter 클래스를 상속한 HashTagFilter 클래스로 대체합니다.


```java
public class HashTagSuggestAdapter extends ArrayAdapter<String> {

    private HashTagFilter filter;

    public HashTagSuggestAdapter(Context context, int resource, String[] objects) {
        super(context, resource, objects);
    }

    @Override
    public Filter getFilter() {

        if (filter == null) {
            filter = new HashTagFilter();
        }

        return filter;
    }

    public class HashTagFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            return null;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
        }
    }
}
```

### Filter의 performFiltering과 publishResults를 구현

performFiltering과 publishResults를 구현하겠습니다.

#### publishResults

publishResults에서는, Adapter의 갱신 처리를 적는데, ArrayAdapter의 코드와 같이 results가 있는 경우에 notifyDataSetChanged를 실행하게 합니다. results가 없다면 Adapter에 갱신이 없으므로 notifyDataSetInvalidated를 호출하도록 합니다.


```java
@Override
protected void publishResults(CharSequence constraint, FilterResults results) {
    if (results != null && results.count > 0) {
        notifyDataSetChanged();
    } else {
        notifyDataSetInvalidated();
    }
}
```

#### performFiltering

performFiltering에서 필터링 처리를 구현합니다. 먼저, 복수 해시 태그가 있는 경우에도 처리되도록 합니다. 구현할 내용은 아래와 같은 느낌입니다.

- 입력 문자열에서 해시 태그를 추출
- Adapter에 적용된 데이터들과 비교해 FilterResults로서 return
- Adapter 데이터들을 갱신

입력된 문자열의 해시 태그는 정규 표현식으로 추출합니다. [이 기사](http://qiita.com/corin8823/items/75309761833d823cac6f)를 참고해서, 구현합니다. performFiltering가 전달받은 인수 constraint는, 입력된 문자열 전체를 가리키므로 거기에서 해시 태그를 추출합니다.

해시 태그를 추출되면, Adapter에 적용된 데이터들과 비교합니다. 데이터는 COUNTRIES입니다.


```java
private static final String[] COUNTRIES = new String[]{
        "#Belgium", "#France", "#Italy", "#Germany", "#Spain"
};
```

COUNTRIES를 toLowerCase한 문자열과 추출한 해시 태그를 startsWith로 비교해서 매칭되는 경우, 미리 준비한 suggests 리스트에 추가합니다. 그리고, filterResults.values에는 suggests 리스트를, filterResults.count에는 suggests리스트의 사이즈를 대입합니다. 이외에 Adapter의 getCount 함수와 getItem 함수를 Override해서 suggests 리스트 사이즈와 아이템을 반환하도록 합니다.


```java
public class HashTagSuggestAdapter extends ArrayAdapter<String> {

    private HashTagFilter filter;
    private List<String> objects;
    private List<String> suggests = new ArrayList<>();

    public HashTagSuggestAdapter(Context context, int resource, String[] objects) {
        super(context, resource, objects);
        this.objects = Arrays.asList(objects);
    }

    @Override
    public int getCount() {
        return suggests.size();
    }

    @Override
    public String getItem(int position) {
        return suggests.get(position);
    }

    @Override
    public Filter getFilter() {

        if (filter == null) {
            filter = new HashTagFilter();
        }

        return filter;
    }

    public class HashTagFilter extends Filter {

        private final Pattern pattern = Pattern.compile("[#＃]([Ａ-Ｚａ-ｚA-Za-z一-\u9FC60-9０-９ぁ-ヶｦ-ﾟー])+");

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {

            FilterResults filterResults = new FilterResults();

            if (constraint != null) {

                suggests.clear();

                Matcher m = pattern.matcher(constraint.toString());
                while (m.find()) {

                    // 추출한 태그를 취득
                    String tag = constraint.subSequence(m.start(), m.end()).toString();

                    // 데이터(COUNTRIES) 비교
                    for (int i =0; i < objects.size();i++) {

                        String country = objects.get(i);
                        if (country.toLowerCase().startsWith(tag)) {
                            // match되면 suggest리스트에 add
                            suggests.add(country);
                        }
                    }
                }
            }

            filterResults.values = suggests;
            filterResults.count = suggests.size();

            return filterResults;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            if (results != null && results.count > 0) {
                notifyDataSetChanged();
            } else {
                notifyDataSetInvalidated();
            }
        }
    }
}
```

이걸로 해시 태그가 복수가 있는 경우에도 자동 완성 후보들이 표시 됩니다.

<img src="http://tech.vasily.jp/images/tech-blog/horie_20151212_qiita/hashtag2.gif" />

#### 입력중인 해시 태그만 선택 단어로 교체

위의 Gif에서는 완성 리스트에 표시된 #Spain를 선택하면, 입력 전체가 교체되어버립니다. 이 경우 #s가 #Spain으로 교체되는 것이 올바른 동작일 터입니다. 후보 단어를 선택해서 입력을 교체하는 처리는, AutoCompleteTextView의 [replaceText](http://tools.oesf.biz/android-6.0.0_r1.0/xref/frameworks/base/core/java/android/widget/AutoCompleteTextView.java#replaceText)에서 일어나므로 AutoCompleteTextView를 상속해서 Override합니다.


```java
public class HashTagAutoCompleteTextView extends AutoCompleteTextView {

    public HashTagAutoCompleteTextView(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.autoCompleteTextViewStyle);
    }

    public HashTagAutoCompleteTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void replaceText(CharSequence text) {
        // replace 처리
    }
}
```

replace할 때에 필요로 하는 것은, 입력 문자열의 몇 번째 문자에서 몇 번째 문자까지가 입력 중인 해시 태그인가? 라는 정보입니다. 커서 위치를 취득하면, 사용자가 지금 입력하고 있는 부분이 어디 있는지 알 수 있으므로, HashTagSuggestAdapter에 다음 interface를 추가합니다.


```java
public interface CursorPositionListener {
    int currentCursorPosition();
}
```

그리고, Activity에 interface를 구현해서 커서 위치를 반환하도록 합니다.


```java
final AutoCompleteTextView textView = (AutoCompleteTextView) findViewById(R.id.input_form);

HashTagSuggestAdapter adapter = new HashTagSuggestAdapter(this, android.R.layout.simple_dropdown_item_1line, COUNTRIES);
adapter.setCursorPositionListener(new HashTagSuggestAdapter.CursorPositionListener() {
    @Override
    public int currentCursorPosition() {
        return textView.getSelectionStart();
    }
});
```

이걸로 커서 위치를 취득할 수 있게 되었으므로, 해시 태그의 추출 부분을 수정합니다. 매칭된 입력된 해시 태그의 start, end와 커서 위치를 비교해 현재 입력 중인 해시 태그에 대한 것만을 목록 리스트를 나오도록 합니다. 또한, start와 end를 보관해둬서 입력 문자열의 몇 번째 문자에서 몇 번째 문자까지가 입력 중인 해시 태그인가를 판별할 수 있도록 합니다.


```java
int cursorPosition = listener.currentCursorPosition();

Matcher m = pattern.matcher(constraint.toString());
while (m.find()) {

    if (m.start() < cursorPosition && cursorPosition <= m.end()) {

        start = m.start();
        end = m.end();

        // 추출한 태그를 취득
        String tag = constraint.subSequence(m.start(), m.end()).toString();

        // 데이터(COUNTRIES) 비교
        for (int i = 0; i < objects.size(); i++) {

            String country = objects.get(i);
            if (country.toLowerCase().startsWith(tag)) {
                // match되면 suggest리스트에 add
                suggests.add(country);
            }
         }
     }
}
```

HashTagFilter의 start와 end를 보면, 입력 문자열의 몇 번째부터 몇 번째까지가 입력 중인 해시 태그인가를 알 수 있으므로, replaceText를 아래와 같이 구현합니다.


```java
public class HashTagAutoCompleteTextView extends AutoCompleteTextView {
    public HashTagAutoCompleteTextView(Context context) {
        this(context, null);
    }

    public HashTagAutoCompleteTextView(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.autoCompleteTextViewStyle);
    }

    public HashTagAutoCompleteTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void replaceText(CharSequence text) {

        clearComposingText();

        HashTagSuggestAdapter adapter = (HashTagSuggestAdapter) getAdapter();
        HashTagSuggestAdapter.HashTagFilter filter = (HashTagSuggestAdapter.HashTagFilter) adapter.getFilter();

        // span은 인력된 전체 문자열
        Editable span = getText();

        // text는 리스트로부터 선택된 단어
        span.replace(filter.start, filter.end, text);
    }
}
```

이걸로 올바르게 교체할 수 있게 되었습니다.

<img src="http://tech.vasily.jp/images/tech-blog/horie_20151212_qiita/hashtag3.gif" />

### 완성 후보를 API로부터 취득

여기까지의 예로는, 완성 후보를 하드 코딩했기 때문에 완성 후보가 동적으로 변경되는 경우에는 사용할 수 없었습니다. 그래서, 아래의 그림과 같이 사용자 입력에 맞춰서 API로부터 완성 후보를 취득해서, 그것을 사용해서 작업하도록 합니다.

<img src="https://qiita-image-store.s3.amazonaws.com/0/43438/2f11a0e1-5d84-f1df-b4da-4436dc03da24.png" />

#### API를 준비

정의한 keyword로부터 iQON에 사용된 태그를 취득하는 API가 딱 있었기때문에 그것을 사용합니다. 응답은 아래와 같은 형식입니다.


```json
{
    results: [
        {
            tag: "태그1",
            count: 1000
        },
        {
            tag: "태그2",
            count: 100
        },
        {
            tag: "태그3",
            count: 10
        }
    ]
}
```

#### API에 요청

[Retrofit](http://square.github.io/retrofit/)를 사용해서 요청합니다. 아래와 같이 Service와 데이터 클래스를 준비합니다.


```java
public interface SuggestService {
    @GET("적절하게 고쳐 써주세요")
    Call<SuggestResponse> listHashTags(@Query("keyword") String keyword);
}

public class SuggestResponse {

    private ArrayList<HashTag> results;

    public SuggestResponse() {
    }
}

public class HashTag {
    private final String tag;
    private final String count;

    public HashTag(String tag, String count) {
        this.tag = tag;
        this.count = count;
    }
}
```

SuggestService의 구현을 취득합니다.


```java
Retrofit retrofit = new Retrofit.Builder()
        .baseUrl("적절하게 고쳐 써주세요")
        .addConverterFactory(GsonConverterFactory.create())
        .build();

SuggestService service = retrofit.create(SuggestService.class);
```

다음은 service를 사용해서 API에 요청해서, 응답을 suggests 리스트에 추가하면 동적으로 완성 후보애 표시됩니다. API의 기능상 keyword에는, m.start() + 1해서 #을 제거한 문자열을 지정합니다.


```java
String keyword = constraint.subSequence(m.start() + 1, m.end()).toString();
Call<SuggestResponse> call = service.listHashTags(keyword);
try {
    List<HashTag> hashTags = call.execute().body().results;
    for (HashTag hashTag : hashTags) {
        suggests.add(hashTag.tag);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

실제 움직여보면 이런 느낌입니다.

<img src="http://tech.vasily.jp/images/tech-blog/horie_20151212_qiita/hashtag4.gif" />

#### 완성 후보 리스트의 레이아웃을 커스텀해보자

이번에 사용한 API에는, 태그명 이외에, 그 태그의 투고수를 취득할 수 있습니다. 앞의 예에 추가한 태그명에 투고수를 표시해 보려고합니다. 방법은 간단해서, getView를 Override해서 커스텀하면 OK입니다.


```java
@Override
public View getView(int position, View convertView, ViewGroup parent) {

    if (convertView == null) {
        convertView = inflater.inflate(R.layout.hashtag_suggest_cell, null);
    }

    try {
        HashTag hashTag = getItem(position);

        AppCompatTextView tagName = (AppCompatTextView) convertView.findViewById(R.id.hash_tag_name);
        AppCompatTextView tagCount = (AppCompatTextView) convertView.findViewById(R.id.hash_tag_count);

        tagName.setText(hashTag.tag);
        tagCount.setText(hashTag.count);

    } catch (Exception e) {
        e.printStackTrace();
    }

    return convertView;
}
```

또, API에서 응답을 받은 부분을 변경해서, suggests를 List<HashTag>로 변경해서 results를 그대로 대입합니다.


```java
String keyword = constraint.subSequence(m.start() + 1, m.end()).toString();
Call<SuggestResponse> call = service.listHashTags(keyword);
try {
    suggests = call.execute().body().results;
} catch (IOException e) {
    e.printStackTrace();
}
```

자동 완성 단어를 선택했을 때에 tag명만을 replaceText에 전달할 필요가 있으므로, Filter클래스의 convertResultToString를 Override합니다.


```java
@Override
public CharSequence convertResultToString(Object resultValue) {
    return String.format("#%s ", ((HashTag) resultValue).tag);
}
```

이걸로 태그명과 투고수를 표시하게 됩니다.

<img src="http://tech.vasily.jp/images/tech-blog/horie_20151212_qiita/hashtag5.gif" />

## 샘플 코드

샘플 코드는 이쪽입니다.

[https://github.com/horie1024/HashTagAutoCompleteTextView](https://github.com/horie1024/HashTagAutoCompleteTextView)

## 정리

이번에 해시 태그의 자동 완성에 도전해봤습니다. 감으로 찾으면서 했지만, 일단 동작하니 다행입니다.

## 참고

- [http://y-anz-m.blogspot.jp/2013/02/androidautocompletetextview.html](http://y-anz-m.blogspot.jp/2013/02/androidautocompletetextview.html)
- [http://developer.android.com/reference/android/widget/AutoCompleteTextView.html](http://developer.android.com/reference/android/widget/AutoCompleteTextView.html)
- [https://www.websequencediagrams.com/](https://www.websequencediagrams.com/)
 - 그림을 만드는데 사용했습니다.
- [http://qiita.com/corin8823/items/75309761833d823cac6f](http://qiita.com/corin8823/items/75309761833d823cac6f)
- [https://github.com/square/retrofit/blob/master/samples/src/main/java/com/example/retrofit/SimpleService.java](https://github.com/square/retrofit/blob/master/samples/src/main/java/com/example/retrofit/SimpleService.java)
- [http://inthecheesefactory.com/blog/retrofit-2.0/en](http://inthecheesefactory.com/blog/retrofit-2.0/en)
