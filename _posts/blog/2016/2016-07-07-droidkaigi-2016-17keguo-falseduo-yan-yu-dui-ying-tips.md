---
layout: post
title: "[번역] DroidKaigi 2016 ~ 17개국 대국어 대응 Tips"
date: 2016-07-07 01:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [17ヶ国の多言語対応Tips](https://speakerdeck.com/konifar/17keguo-falseduo-yan-yu-dui-ying-tips) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

- - -

## 1p

**17개국 다국어 대응 Tips**

2016/02/19 (금)

Konifar (@konifar)

DroidKaigi

## 2p

[Konifar 기병대](https://github.com/konifar)

## 3p

[android-material-design-icon-generator-plugin](https://github.com/konifar/android-material-design-icon-generator-plugin)

## 4p

[material-cat](https://github.com/konifar/material-cat)

## 5p

**Taptrip**

- `전 세계` 친구를 만들 수 있다
- `자동번역`으로 간단하게 커뮤니케이션
- `250개국/500만 명`이 이용

[https://play.google.com/store/apps/details?id=com.taptrip](https://play.google.com/store/apps/details?id=com.taptrip)

## 6p

Taptrip Google Analytics

## 7p ~ 8p

Taptrip supports `17` languages

## 9p ~ 10p

**DroidKaigi 2016**

- 원래 다국어 대응 세션 샘플로 만들었다

[https://github.com/konifar/droidkaigi2016](https://github.com/konifar/droidkaigi2016)

## 11p

아랍어 대응

## 12p

언어 변경 방법

## 13p

Q. 다국어 대응은 힘든가?

## 14p

**A. 「대응」의 정도에 따라서**

- Google 번역으로 일단 번역?
- RTL에 따라 세밀한 레이아웃도 조절?
- 화폐나 시간 표기 등도 제대로 바꾼다?
- 성별이나 뉘앙스 등 작은 번역의 차이까지도 완전히 대응한다?

## 15p

Q. 어디까지 대응할 것인가?

## 16p

**A. 어플 종류와 확보한 공수에 따라서**

- 아랍어권을 메인 타깃으로한 어플이라면 제대로 RTL도 대응해야 한다
- 이틀동안 우선 영어로 사용할 수 있게 한다면, 번역과 약간의 수정만 한다
- `이쪽은 개발 내용의 그림이 잡히지 않는다면 판단하기 어렵다`

## 17p

**오늘의 목표**

- `다국어 대응의 구현 이미지, 개발 비용이 대략 알게 된다`
- 「내일부터 1주일 동안 다국어 대응해줘」라고 들었을 때, 어디까지 대응할 것인가 판단하기 쉽게 된다

## 18p

**오늘 이야기할 내용**

1. strings.xml 관리방법
2. 번역 흐름
3. 수사(數詞)의 복수형 대응
4. 날짜 현지화
5. RTL (Right To Left) 대응
6. 상세한 디자인 조정

## 19p

**오늘 이야기하지 않는 내용**

1. 성별의 차이 등 세밀한 언어 사양
2. 방언 수준의 현지화
3. 서버를 포함한 전체 설계
4. API 17 미만의 RTL 대응
5. 테스트 방법

## 20p

**1. strings.xml 관리방법**

## 21p ~ 22p

**values-xx/strings.xml**

- values

```
<string name="all_sessions">All Sessions</string>
```

- values-ar

```
<string name="all_sessions">جميع الجلسات</string>
```

- values-ja

```
<string name="all_sessions">すべてのセッション</string>
```

## 23p

**인도네시아어 등 특정 언어에 주의**

예전 Java가 실수한 흔적으로 특수한 일반적인 언어 코드와 다른 부분이 있다

- × values-id
- ○ values-in

## 24p

**인도네시아어 등 특정 언어에 주의**

```
private String convertOldISOCodes(String language) {
  language = language.toLowerCase().intern();
  switch (language) {
    case "he": // 히브리어
      return "iw";
    case "yi": // 이디시어
      return "ji";
    case "id": // 인도네시아어
      return "in";
    default:
      return language;
  }
}
```

## 25p

**하드 코딩 항목 색출**

- Analyze > Run Inspection by name... > Hard coded strings
- setText("타이틀")이라든가 검출 가능하다. 로그의 하드 코딩 항목도 전부 검출되므로 조금은 다행

## 26p

**Lint > Internationalization**

## 27p ~ 28p

**Translation Editor**

- strings.xml의 오른쪽 위의 Open editor 링크로부터
- 테이블에서 보고 추가도 가능하다.
- 아직 그렇게 훌륭하지 않다
- 누락방지로는 쓸 수 있다

## 29p

17개 언어 대응하면 힘들다

## 30p

**언어 전환**

- 기본적으로는 단말의 언어 설정에 의존
  - `Locale.getDefault()` 값이 바뀌면, 거기에 대응해서 표시가 변경된다
- MoreLocale2로 전환
  - 단말의 언어설정을 임의의 언어로 바꿀 수 있다
  - [https://play.google.com/store/apps/details?id=jp.co.c_lis.ccl.morelocale]([https://play.google.com/store/apps/details?id=jp.co.c_lis.ccl.morelocale])

## 31p

**언어 전환을 어플로 제어한다**

```
public static void setLocale(Context context, String languageId) {
  Configuration config = new Configuration();
  Locale locale = new Locale(languageId);
  Locale.setDefault(locale);
  config.locale = locale;
  context.getResources().updateConfiguration(config, context.getResources().getDisplayMetrics());
}
```

- ja. en과 같은 languageId를 넘기면 전환된다

## 32p

**2. 번역 흐름**

## 33p ~ 34p

**Taptrip의 경우**

1. 일본어로 제대로 구현
2. 사내에서 영어로 번역
3. 외부 서비스 (GENGO)를 사용해서 번역의뢰
4. 언어마다 strings.xml에 적용

> 3~4 항목이 이번에 할 이야기

## 35p

**기계번역 or 사람번역**

1. 기계번역 : <font color="blue">무료</font>이지만 `부정확`
2. 사람번역 : `비싸`지만 <font color="blue">정확</font>

## 36p

**Google 번역의 정밀도**

- `일본어 <=> 한국어`는 매우 높은 정밀도

## 37p

**Taptrip에서의 앙케이트 결과**

- 아래의 Google 번역 결과는 정밀도가 높다
  - 일본어 <=> 한국어
  - 스페인 <=> 폴란드어
  - 영어 <=> 중국어

## 38p ~ 39p

**기계번역의 경우의 Tips**

- AndroidLocalizationer
  - [https://github.com/westlinkin/AndroidLocalizationer](https://github.com/westlinkin/AndroidLocalizationer)
  - [http://qiita.com/okey01/items/e2cfd9f1264f3b7a81f2](http://qiita.com/okey01/items/e2cfd9f1264f3b7a81f2)
- Microsoft/Google API로 자동 번역된다
- Plurals는 제대로 대응 안되므로 주의

## 40p ~ 41p

**사람번역 서비스의 선정 포인트**

단가 x 속도 x 기능의 풍부함

- 단가 : 1문자 or 1단어/`4~8엔` 정도
- 속도 : `30분~1일`
- 기능 : API, 사전 기능, 차트 기능

## 42p

**GENGO**

- 단가 : 싸다. 1단어 or 1문자/`4~5엔`
- 속도 : 17개국 언어도 `3시간` 정도로 맞춘다
- 기능 : API, 사전 존재. 차트로 세밀한 주고받음이나 반려도 가능.

## 43p

**xml적용의 귀차니즘**

- 의뢰할때는 SpreadSheet or 텍스트
- strings.xml로 변경하는 것은 상당히 귀찮다

## 44p ~ 45p

**해결 1 : 도구를 사용해서 변환**

- Android-strings-xml-csv-converter
  - [https://github.com/pandawarrior91/Android-strings-xml-csv-converter](https://github.com/pandawarrior91/Android-strings-xml-csv-converter)
  - [https://plugins.jetbrains.com/plugin/7782?pr=androidstudio](https://plugins.jetbrains.com/plugin/7782?pr=androidstudio)
- xml <=> csv로 간단하게 전환할 수 있다
- strings의 일부 변환은 대응 안되어있다

## 46p

**해결 2 : xml 그대로 번역 의뢰한다**

- GENGO의 경우, [[[]]]로 감싸면 그 부분은 번역대상이 안된다 (돈은 안든다)
- Taptrip에서는 xml의 일부를 번역하고 의뢰하는 AndroidStudio Plugin 「Alice」를 만들어서 사용하고 있다

## 47p ~ 49p

**AS Plugin 「Alice」**

- GENGO에 간단하게 의뢰하는 플러그인
- `※ 서버의 콜백 실패로 아직 움직이고 있지 않다`

## 50p

**Google 공식 번역 서비스를 이용한다**

- Android Studio의 Translation Editor로부터 번역의뢰 페이지로 이동한다.

## 51p ~ 52p

**Google 공식 번역 서비스를 이용시의 궁리**

- 상세를 주석이나 description으로 적는다

```
<!-- The action for submitting a form. This text is on a button that can fit 30 chars -->
<string name="login_submit_button">Sign in</string>
```

> [http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html](http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html)

- 번역하지 않는 부분은 <xliff:g>로 감싼다

```
<string name="countdown">
    <xliff:g id="time" example="5 days>%1$s</xliff:g>until holiday
</string>
```

> [http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html](http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html)

## 53p ~ 54p

**아랍어 편집시의 궁리**

- AndroidStudio 에디터는 RTL 텍스트에 친절하지 않다. 별도 에디터를 쓰는 것이 좋다
- SublimeText, Vim은 괜찮다. Atom은 안된다. Emacs는 안봤다.

## 55p

**3. 수사(數詞)의 복수형 대응**

## 56p

**일본어에서의 「수사(數詞)」**

- 1 人
- 2 人
- 3 人 `<= 바뀌지않는다`

## 57p

**영어에서의 「수사(數詞)」**

- 1 person
- 2 people `<=복수형으로 변화`
- 3 people

## 58p ~ 59p

**아랍어에서의 「수사(數詞)」**

- 0 أشخاص
- 1 شخص
- 2 الناس
- 3~10 أشخاص
- 11~100 شخصا
- 100~  شخص

`?????`

## 60p

**Language Plural Rules**

[http://www.unicode.org/cldr/charts/27/supplemental/language_plural_rules.html](http://www.unicode.org/cldr/charts/27/supplemental/language_plural_rules.html)

## 61p

**values/strings.xml**

```
<plurals name="number_with_brackets">
  <item quantity="one">(%1$d person)</item>
  <item quantity="other">(%1$d people)</item>
</plurals>
```

## 62p

**values-ja/strings.xml**

```
<plurals name="number_with_brackets">
  <item quantity="other">(%1$d人)</item>
</plurals>
```

## 63p

**values-ar/strings.xml**

```
<plurals name="number_with_brackets">
  <item quantity="zero">(%1$d أشخاص)</item>
  <item quantity="one">(%1$d شخص)</item>
  <item quantity="two">(%1$d شخصين)</item>
  <item quantity="few">(%1$d أشخاص)</item>
  <item quantity="many">(%1$d شخص)</item>
  <item quantity="other">(%1$d شخص)</item>
</plurals>
```

## 64p

**getQuantityString()**

```
getResources().getQuantityString(R.plurals.number_with_brackets, count, count);
```

- 2번째 인수에는 치환하는 숫자를 넣는다
- 3번째 인수에는 적용하는 포맷에 대응하는 숫자를 넣는다

## 65p ~ 66p

**숫자 단락 문자**

- 일본어 : 10,000  `← 소수점`
- 영어 : 10,000  `← 소수점`
- 프랑스어 : 10.000  `← 마침표`
- 아랍어 : ١٠٬٠٠٠  `← 여러가지 다르다`

## 67p

**NumberFormat를 사용**

```
NumberFormat.getNumberInstance().format(1);
// 1
// 10,000
```

## 68p

**NumberFormat를 사용**

- getNumberInstance()
  - `=> 1、 10,000`
- getCurrencyInstance()
  - `=> ￥1、￥10,000`
- getIntegerInstance()
  - `=> 1、10,000`
- getPercentInstance()
  - `=> 1%、100%`

## 69p

**4. 날짜 현지화**

## 70p ~ 71p

**날짜 현지화**

일본어 / 아랍어

- DateFormat과 DateUtils이 우수
- DroidKaigi 앱을 사례로 몇 가지 소개합니다

## 72p ~ 75p

**2月19日 (MMMd)**

```
public static String getMonthDate(Date date, Context context) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
        String pattern = DateFormat.getBestDateTimePattern(Locale.getDefault(), FORMAT_MMDD);
        return new SimpleDateFormat(pattern).format(date);
    } else {
        int flag = DateUtils.FORMAT_ABBREV_ALL | DateUtils.FORMAT_NO_YEAR;
        return DateUtils.formatDateTime(context, date.getTime(), flag);
    }
}
```

## 76p ~ 79p

**10:00 (kkmm)**

```
public static String getHourMinute(Date date) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
        String pattern = DateFormat.getBestDateTimePattern(Locale.getDefault(), FORMAT_KKMM);
        return new SimpleDateFormat(pattern).format(date);
    } else {
        return String.valueOf(DateFormat.format(FORMAT_KKMM, date));
    }
}
```

## 80p ~ 83p

**2016年2月18日 16:30**

```
public static String getLongFormatDate(Date date, Context context) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
        String pattern = DateFormat.getBestDateTimePattern(Locale.getDefault(), FORMAT_YYYYMMDDKKMM);
        return new SimpleDateFormat(pattern).format(date);
    } else {
        java.text.DateFormat dayOfWeekFormat = java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG);
        java.text.DateFormat shortTimeFormat = java.text.DateFormat.getTimeInstance(java.text.DateFormat.SHORT);
        dayOfWeekFormat.setTimeZone(LocaleUtil.getDisplayTimeZone(context));
        shortTimeFormat.setTimeZone(LocaleUtil.getDisplayTimeZone(context));
        return dayOfWeekFormat.format(date) + " " + shortTimeFormat.format(date);
    }
}
```

## 84p ~ 85p

**시차 보정**

도쿄 10:00 / 런던 1:00

- DroidKaigi 앱의 표시시각은 JST. 기본 json 데이터도 JST로 보유하고 있다.
- 런던에서 현지 시각으로 표시하고 싶은 경우에는 어떻게 할 것인가?

## 86p ~ 87p

**DateFormat을 사용해 타임존을 고려**

- Date 클래스는 타임존과 관계없이 날짜 시간을 보유한다.
- 2016/02/18 10:00은 10시로 다룬다
- 그러므로 JST시각으로부터 단말의 타임존으로 변환해야 한다

```
public static Date getDisplayDate(@NonNull Date date, Context context) {
    DateFormat formatTokyo = SimpleDateFormat.getDateTimeInstance();
    formatTokyo.setTimeZone(CONFERENCE_TIMEZONE);
    DateFormat formatLocal = SimpleDateFormat.getDateTimeInstance();
    formatLocal.setTimeZone(getDisplayTimeZone(context));
    try {
        return formatLocal.parse(formatTokyo.format(date));
    } catch (ParseException e) {
        Log.e(TAG, "date: " + date + "can not parse." + e);
        return date;
    }
}
```

## 88p

**5. RTL (Right To Left) 대응**

## 89p

**This is RTL**

[https://twitter.com/?lang=ar](https://twitter.com/?lang=ar)

## 90p

DroidKaigi 2016

## 91p

언어 변경 방법

## 92p

Q. 애시당초 해야만 하는가?

## 93p

**아랍어권 친구에게 물어봤다**

- Omran Ali Qaraeen
- 요르단 사람
- 25살 엔지니어
- 일본어는 엄청 잘한다

## 94p

- Konifar : 「문자는 왼쪽에서 흐르면 역시 이상해?」
- Omran : 「이상합니다. 짧은 문장이면, 왜 우측에 공백이 있어?라고 생각합니다」
- Konifar : 「Drawer도 오른쪽에서 나타나는 편이 좋아?」
- Omran : 「그렇네요. 요르단의 아랍어 앱은 대체로 그렇습니다. 그편이 자연스럽습니다」
- Konifar : 「그러면 전부 오른쪽부터 표시하는 것이 좋은 것이네?」
- Omran : 「그렇습니다 (y)」

## 95p

A. 하는게 좋다고 합니다

## 96p

**단 Drawer등의 대응은 가지각색**

Omran이 추천하는 뉴스 앱은 좌측에서부터 Drawer가 나온다

## 97p

**AndroidManifest.xml**

```
<application
    android:name=".MainApplication"
    android:allowBackup="true"
    android:configChanges="locale"
    android:icon="@mipmap/ic_launcher"
    android:labe="@string/app_name"
    android:supportRtl="true"
    android:theme="@style/APpTheme">
```

## 98p ~ 100p

**Start & End attributes**

- marginLeft => marginStart
- paddingLeft => paddingStart
- toLeftOf => toStartOf
- gravity="left" => gravity="start"

layout_toRight만 지정하면 날짜만 오른쪽에 치우기 때문에 더 오른쪽에 표시하려다 아무것도 표시되지 않는다

```
<android.support.v7.widget.CardView
    android:id="@+id/card_view"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginLeft="@dimen/spacing_small"
    android:layout_toRightOf="@+id/txt_stime"
```

↓

```
<android.support.v7.widget.CardView
    android:id="@+id/card_view"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginLeft="@dimen/spacing_small"
    android:layout_marginStart="@dimen/spacing_small"
    android:layout_toEndOf="@id/txt_stime"
    android:layout_toRightOf="@+id/txt_stime"
```

## 101p

**Add RTL Support Where Possible**

- AndroidStudio의 편리기능
- RTL 대응이 필요한 곳을 검출해준다

## 102p

**ViewPager**

TabLayout은 RTL에 대응하지만, ViewPager는 대응하고 안하고 있다.

## 103p ~ 106p

**RtlViewPager**

- ViewPager를 확장해서 RTL이라면 내부에서 currentItme이나 스크롤 위치를 변환한다
  - [https://github.com/konifar/droidkaigi2016/blob/a92ae2dc943e97243d9eea5b00f66382e8fc86e9/app/src/main/java/io/github/droidkaigi/confsched/widget/RtlViewPager.java](https://github.com/konifar/droidkaigi2016/blob/a92ae2dc943e97243d9eea5b00f66382e8fc86e9/app/src/main/java/io/github/droidkaigi/confsched/widget/RtlViewPager.java)
- Adapter#getItem() 호출 시나 스크롤시의 position 변환

```
private int convert(int position) {
    if (position >= 0 && isRtl()) {
        return getAdapter() == null ? 0 : getAdapter().getCount() - position - 1;
    } else {
        return position;
    }
}
```

- RTL인지 아닌지 판정

```
protected boolean isRtl() {
   return TextUtilsCompat.getLayoutDirectionFromLocale(Locale.getDefault()) == ViewCompat.LAYOUT_DIRECTION_RTL;
}
```

`getLayoutDirectionFromLocale()으로 설정 로케일에 따른 방향이 취득된다`

## 107p

**RTL Mark 삽입**

문자의 첫 문자가 아랍어가 아닐 때, 좌측에서 이어지는 문제가 있다.

`강제적으로 RTL으로 할 특수문자`를 넣는 것으로 해결한다.

## 108p

**RTL Mark in strings.xml**

strings.xml 내부라면, `&#8207;`을 첫 줄에 넣기만 하면 된다

```
<string name="about_youtube">&#8207;YouTube قناة</string>
```

## 109p

**RTL Mark in Java**

- CustomView
  - RtlTextView같은 것을 만들어서 setText()를 Override한다
- DataBinding
  - BindingAdapter를 만들어 Text를 Set한다

## 110p ~ 112p

**RTL Mark using DataBinding**

```
@BindingAdapter("textRtlConsidered")
public static void setTextRtlConsidered(TextView textView, String text) {
    textView.setText(LocaleUtil.getRtlConsideredText(text));
}
```

[https://github.com/konifar/droidkaigi2016/blob/master/app/src/main/java/io/github/droidkaigi/confsched/util/DataBindingAttributeUtil.java#L120-L123](https://github.com/konifar/droidkaigi2016/blob/master/app/src/main/java/io/github/droidkaigi/confsched/util/DataBindingAttributeUtil.java#L120-L123)

```
public static String getRtlConsideredText(String text) {
    if (shouldRtl()) {
        return "\u200F" + text;
    } else {
        return text;
    }
}
```

```
<TextView
    android:id="@+id/txt_speaker_name"
    style="@style/TextSub"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:gravity="center_vertical"
    app:textRtlConsidered="@{session.speaker.name}" />
```

`android:text` 대신에 `app:textRtlConsidered` 를 사용하는 것

## 113p

**이미지의 반전**

- 말풍선을 9path 이미지로 하고 있는 경우에는 대응이 필요

## 114p ~ 115p

**android:autoMirrored**

```
<?xml version="1.0" encoding="utf-8"?>
<bitmap xmlns:android="http://schemeas.android.com/apk/res/android"
    xmlns:tools="http://schemeas.android.com/tools"
    android:autoMirrored="true"
    android:src="@drawable/ic_search_white_24dp"
    tools:ignore="UnusedAttribute" />
```

- 검색 버튼의 drawable xml를 만든다
- autoMirrored를 사용하는 것으로 Locale.getDefault()의 값에 따라 이미지를 반전시켜준다

## 116p

아라비아 숫자

## 117p

Q. 어떻게 구사하면 좋을까?

## 118p

**다시 Omran에 물어봤다**

- Omran Ali Qaraeen
- 요르단 사람
- 25살 엔지니어
- 일본어는 엄청 잘한다

## 119p

- Konifar : 「이거 역시나 인도 아라비아 숫자의 쪽이 좋아?」
- Omran : 「그렇네요! 날짜는 그편이 자연스럽습니다.」
- Konifar : 「시간은?」
- Omran : 「시간은...보통은 아라비아 숫자쪽이 좋겠네요」
- Konifar : 「응...? 그러면 30분은?」
- Omran : 「그것은 아라비아 숫자가 좋습니다」

## 120p

솔직히 Omran만으로는 사용이 모르겠다

## 121p

**동료에게도 물어봤다**

- Zakaria
- 알제리 사람
- 30살 엔지니어
- 일본어 조금 한다

## 122p

- Konifar : 「날짜는 인도 아라비아 숫자인게 좋지?」
- Zakaria : 「아라비아 숫자가 좋아요. 저는 태어나서부터 그다지 인도 아라비아 숫자를 사용한 적이 없어요」
- Konifar : 「응?!」

## 123p

A. 유스 케이스이나 지역에 상당히 의존한다

## 124p

**NumberFormat, DateUtils를 사용**

- 이 2개를 사용해서 변환하면 된다
- 무리하게 변환하는 로직을 끼워 넣을 필요는 없지 않을까? 라는 결론
- 혹시나 한다면 CustomView를 만들던가 DataBinding을 사용하는 편이 좋다

## 125p

**6. 상세한 디자인 조정**

## 126p

**언어에따른 텍스트 길이의 차이**

- 일본어 : 「말할수 있는 언어」
- 영어 : 「Languages you speak」
- 러시아어 : 「Языки на которых Вы говорите」

## 127p

**일본어의 1.5~2배를 가정한다**

- 일본어는 꽤 짧다
- 중국어가 가장 짧다
- 러시아어는 가장 길다

## 128p ~ 129p

**행 고정 + 생략**

- ellipsis, lines, maxLines으로 조정한다

```
<TextView
  android:id="@+id/txt_title"
  android:layout_width="match_parent"
  android:layout_height="wrap_content"
  android:ellipsize="end"
  android:layout_marginBottom="@dimen/line_spacing"
  android:maxLines="2"
  android:text="5 лет с последующим 'Hatena Закладка', чтобы продолжить разработку технологии приложения" />
```

## 130p

**태그 등 생략하고 싶지 않은 케이스**

1. 옆으로 스크롤 가능하도록 한다
2. 비어져 나올 떄는 다음 행으로 표시한다

## 131p ~ 132p

**비어져 나올 떄는 다음 행으로 표시한다**

- FlowLayout
  - [https://github.com/ApmeM/android-flowlayout](https://github.com/ApmeM/android-flowlayout)

```
<org.apmem.tools.layouts.FlowLayout
    android:id="@+id/tag_container"
    android:layout_width="match_parent"
    android:layout_height="wrap_content">

    <TextView
        android:id="@+id/txt_place"
        style="@style/Tag"
        android:background="@drawable/tag_language"
        android:text="@{session.place.name}" />

    <io.github.droidkaigi.confsched.widget.CategoryView
        android:id="@+id/txt_category"
        style="@style/Tag"
```

## 133p

**언어에 따라 행간을 바꾼다**

- 행간을 조정하는 편이 읽기 쉽기도 하다.
- values-xx/dimens.xml을 언어마다 준비해서 사용하는 것이 좋다.

## 134p

정리

## 135p

**strings.xml의 관리**

언어마다 준비는 필수입니다. AndroidStudio의 기능을 활용합시다.

## 136p

**번역 흐름**

가능하면 사람 번역으로 정밀도를 높입시다. 플러그인이나 스크립트를 구사해 수고를 줄입시다

## 137p

**복수형 대응**

plurals를 제대로 사용합시다

## 138p

**날짜 현지화**

DateUtils, SimpleDateFormat를 사용합시다.

## 139p

**RTL (Right To Left)**

아랍권을 메인으로 한다면 제대로 합시다. start, end 대응만으로도 상당히 좋아집니다

## 140p

**세밀한 디자인 조정**

디자이너와 협력하고, 문자의 길이나 행간을 고려합시다

## 141p

어디까지 다국어에 대응할지는 어플에 따라 다르다

## 142p

어디까지 할 것인가의 인식을 맞춰, 가능한 것부터 합시다

## 143p

감사합니다

[https://github.com/konifar/droidkaigi2016](https://github.com/konifar/droidkaigi2016)

## 144p

**매우 참고되는 링크**

1. 엔지니아 · Web 디자이너 필독 : 어플리케이션을 국제화 · 다국어 전개하기 전에 알아둬야 할 것
  - [http://qiita.com/hachi8833/items/4666638e930de65dcdef](http://qiita.com/hachi8833/items/4666638e930de65dcdef)
2. RTL 지원 강화
  - [http://d.hatena.ne.jp/fkm/20131118/p1](http://d.hatena.ne.jp/fkm/20131118/p1)
3. 현지화 체크 리스트
  - [http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html#translate-strings](http://developer.android.com/intl/ja/distribute/tools/localization-checklist.html#translate-strings)
