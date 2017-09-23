---
layout: post
title: "[번역] DroidKaigi 2017 ~ 토크 앱에서 이모티콘을 구현한 이야기"
date: 2017-08-23 18:10:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2017 ~ トークアプリで絵文字を実装した話](https://speakerdeck.com/futaboooo/tokuapuridehui-wen-zi-woshi-zhuang-sitahua) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p, 토크 앱에서 이모티콘을 구현한 이야기

DroidKaigi 2017 @futabooo

## 2p, About me

futabooo (ふたぶー)

- Lead Engineer at eureka, Inc. 
- Java, Kotlin, Golang, TypeScript, AngularJS 
- FantasyEarth Zero, s.CRY.ed 

- Github : futabooo 
- Twitter : futabooo

## 3p, About eureka

[https://eure.jp/](https://eure.jp/)

## 4p, About eureka

|  |  |
| :--: | :--: |
| <img src="https://lh3.googleusercontent.com/-H_9o7dHUXUPfkTjOgkKnoHIpKjKFkNDDIMUsYGdkFLX3Vo-F9BEanv3FrMYFSI3QD28=w300-rw" width="50%" /> | <img src="https://lh3.googleusercontent.com/669EqenWA1N1WbfZUTppFO_gMDBd59OsPXK50dqHkSSXBtq6XYPwI6WYkXhTBc86Zg=w300-rw"  width="50%" /> |
| [pairs](https://play.google.com/store/apps/details?id=jp.eure.android.pairs&hl=ko) | [COUPLES](https://play.google.com/store/apps/details?id=jp.eure.couples&hl=ja) |

## 5p, About eureka

<img src="https://lh3.googleusercontent.com/-H_9o7dHUXUPfkTjOgkKnoHIpKjKFkNDDIMUsYGdkFLX3Vo-F9BEanv3FrMYFSI3QD28=w300-rw" width="10%" />

- Web
   - Golang, Gin
   - TypeScript, AngularJS
- Android
   - Java, Kotlin
   - Dagger2, Orma, OkHttp3, Retroﬁt2, RxKotlin, Picasso, ButterKnife, DataBinding
- iOS
   - Objective-C, Swift
   - CoreStore, Alamoﬁre, Moya RxSwift, AsyncDisplayKit

<img src="https://lh3.googleusercontent.com/669EqenWA1N1WbfZUTppFO_gMDBd59OsPXK50dqHkSSXBtq6XYPwI6WYkXhTBc86Zg=w300-rw"  width="10%" />

- Web
   - PHP, Codeigniter
- Android
   - Java
   - ActiveAndroid, Volley, OkHttp3, Retroﬁt2, Socket.IO, RxJava, Glide
- iOS
   - Swift, Objective-C
   - CoreStore, AFNetworking, SwiftyJSON, SDWebImage RxSwift, Cartography

## 6p, About Couples

앨범, 기념일, 스케줄을 하나로

두 사람의 추억을 간단하게 공유

## 7p, About Couples

Talk

## 8p, About Couples

Talk

- 문자 메시지
- 이모티콘
- 음성 메시지
- 이미지
- 동영상
- 스탬프
- 위치 정보
- Thinking of You

## 9p, About Couples

Talk

- 문자 메시지
- `이모티콘`
- 음성 메시지
- 이미지
- 동영상
- 스탬프
- 위치 정보
- Thinking of You

## 10p

앱 자체 이모티콘 도입 전

## 11p

◆ Couples에 대한 의견・감상

이미지처럼 이모티콘이 표시되지 않습니다! 내가 보낸 것은 표시되는 것 같습니다!

## 12p

단말이나 통신사의 차이에 따라 제대로 이모티콘 표시가 안된다

## 13p

자체 이모티콘을 넣자

## 14p

Couples 자체 이모티콘 도입까지의 흐름

## 15p, Couples 자체 이모티콘 도입까지의 흐름

- 사양을 정한다
   - 타사 앱에서 자체 이모티콘이 구현된 것을 연구한다
      - 기능을 파헤친다
      - 퀄리티 확인
- 개발한다
   - 사양 결정으로 밝혀진 기능 구현

## 16p

타사 앱 연구

## 17p, 타사 앱 연구

- 타사 앱에서 자체 이모티콘이 있는 앱을 오로지 사용한다.
   - LINE, Facebook Messenger, etc...
   - 버그를 찾을 정도의 열정으로 이것저것 한다

## 18p, 타사 앱 연구

- 기능을 파헤친 결과
   - 이모티콘을 표시할 수 있다
   - 이모티콘 복사 & 붙여넣기를 할 수 있다
      - 앱 밖으로 붙여넣기하면 대체 문자로 표시된다
   - 이모티콘 하나만 보내면 스탬프가 된다

## 19p

여기서부터 개발 이야기입니다

## 20p

이모티콘을 표시한다

## 21p, 이모티콘을 표시

- 처리 흐름
   - 표시할 문자열 중에서 이모티콘에 대응하는 부분을 식별한다
   - 표시할 문자열의 어디에 어떤 이모티콘을 표시할지를 유지하는 리스트를 작성한다
   - 표시할 문자열을 SpannableString으로 해서, 리스트를 기반으로 대응하는 부분을 이모티콘으로 그린다

## 22p ~ 25p, 이모티콘을 표시

- 처리 흐름

String 타입

안녕하세요`{ { sticon(1,10) } }`오늘은 날씨가 좋네요!`{ { sticon(2,20) } }`

SpannableString 타입

안녕하세요🐻오늘은 날씨가 좋네요!🌞

| TalkMessageToken |
| :-- |
| characterStyle: SticonSpan |
| beginIndex: int |
| endIndex: int |

| DynamicDrawableSpan | SticonSpan |
| :-- | :-- |
| draw() | sticon: Drawable |
|   | altText: Sting |

## 26p ~ 31p, 이모티콘을 표시

- 처리 흐름

```
// 표시하고 싶은 문자열
String message = "안녕하세요{ { sticon(1,10) } } 오늘은 날씨가 좋네요!{ { sticon(2,20) } }"

// 어디에 어떤 이모티콘을 표시할지를 유지한 리스트를 얻는다
List<TalkMessageToken> tokenList = TalkMessageHelper.getSticonSpanTokens(message);

// 리스트를 기반으로 문자열에 이모티콘을 대응시켜 그린다
SpannableString spanedMessage = new SpannableString(message);
for (TalkMessageToken t : tokenList) {
    spanedMessage.setSpan(t.characterStyle, t.beginIndex, t.endIndex, t.flags);
}
talkView.setText(spanedMessage);
```

## 32p ~ 37p, 이모티콘을 표시

- { { mustache } }
   - Logic-less templates
   - 간단한 교체를 하는 템플릿
   - Java 구현 samskivert/jmustache

```
String text = "One, two, { { three } }. Three sir!";
Template tmpl = Mustache.compiler().compile(text);
Map<> data = new HashMap<String, String>();
data.put("three", "five");
System.out.println(tmpl.execute(data));
//result: "One, two, five. Three sir!"
```

## 38p, 이모티콘을 표시

- samskivert/jmustache
   - 문자 to 문자의 교체라면 충분하다
      - 이모티콘으로 하려면 결국 구현이 필요
   - 라이브러리는 사용하지 않고, 파서를 자체 구현

## 39p, 이모티콘을 표시

- 자체 파서
   - mustache를 사용하면서 정규표현식으로 한다
      - Matcher와 Pattern을 사용한다
      - { { sticon(1,10) } } → 대응하는 이모티콘 🐻 을 표시하기 위한 Span을 작성한다

## 40p, 이모티콘을 표시

- { { sticon(1,10) } }
   - sticon은 이모티콘을 말함
   - sticon(그룹ID, ID), ID는 모든 sticon에서 하나의 의미
      - 모든 sticon에서 하나의 의미의 ID는 스탬프로서 전송시에 활약

## 41p ~ 46p, 이모티콘을 표시

- 어디에 어떤 이모티콘을 표시할지를 유지한 리스트를 얻는다

```
// 정규표현식의 패턴을 작성한다
Pattern STICON = Pattern.compile("\\{\\{sticon\\(.+?\\)\\}\\}");
Pattern IDS = Pattern.compile("(\\d+),(\\d+)");
List<TalkMessageToken> getSticonSpanTokens(String rawText) {
   ArrayList<TalkMessageToken> tokens = new ArrayList<>();
   // Matcher를 사용해서 패턴에 매치한 부분에 처리한다
   Matcher t = STICON.matcher(rawText);
   Matcher ids = IDS.matcher("");
   while (t.find()) {// { { sticon(1,10) } }와{ { sticon(2,20) } }
      matcherIds.reset(t.group());
      if (ids.find()) {// (1,10)와(2,20) 
         TalkMessageToken token = new TalkMessageToken(sticonSpan, t.start(), t.end());
         tokens.add(token);   
      }
   }
}
```

## 47p ~ 49p, 이모티콘을 표시

- TalkMessageToken 
   - 어디에 어떤 스타일을 할지 유지한 클래스

```
class TalkMessageToken {
   public CharacterStyle characterStyle;
   public int beginIndex;
   public int endIndex; 
}
```

안녕하세요{ { sticon(1,10) } }오늘은 날씨가 좋네요!{ { sticon(2,20) } }

| TalkMessageToken | TalkMessageToken |
| :-- | :-- |
| characterStyle = sticonSpan | characterStyle = sticonSpan |
| beginIndex = 5 | beginIndex = 32 |
| endIndex = 20 | endIndex = 47 |

## 50p ~ 56p, 이모티콘을 표시

- SticonSpan 
   - 잉모티콘 정보를 가지는 클래스

```
class SticonSpan extends DynamicDrawableSpan {
   Drawable sticon;
   String altText;
   String rawText;
   int stickerId;

   @Override
   public void draw(Canvas canvas, CharSequence text, int start, int end, float x, int top, int y, int bottom, Paint paint) {
      // 자신이 적용된 string 부분을 sticon으로 치환하여 그린다
   }
}
```

## 57p, 이모티콘을 표시

- 복습

String 타입

안녕하세요{ { sticon(1,10) } }오늘은 날씨가 좋네요!{ { sticon(2,20) } }

SpannableString 타입

안녕하세요🐻오늘은 날씨가 좋네요!🌞

| TalkMessageToken |
| :-- |
| characterStyle: SticonSpan |
| beginIndex: int |
| endIndex: int |

| DynamicDrawableSpan | SticonSpan |
| :-- | :-- |
| draw() | sticon: Drawable |
|   | altText: Sting |

## 58p

이모티콘을 복사 & 붙여넣기할 수 있다

## 59p, 이모티콘을 복사 & 붙여넣기

- 처리 흐름
   - 복사되면 아래 문자열을 앱 내에서 유지한다 
      - 원시 텍스트 "안녕하세요{ { sticon(1,10) } }"
      - 대체 텍스트 "안녕하세요(bo)"
   - 대체 텍스트를 클립보드에 보관한다
      - Couples 밖에서의 붙여넣기는 대체 텍스트 표시
   - 복사시의 문자열과 비교하고서 붙여넣기 한다

## 60p ~ 63p, 이모티콘을 복사 & 붙여넣기

- 처리 흐름

SpannableString 타입

안녕하세요{ { sticon(1,10) } }오늘은 날씨가 좋네요!{ { sticon(2,20) } }

-> Copy

->

| 앱 내부 | 클립보드 |
| :-- | :-- |
| copiedRawText: String | cpoiedAltText: String |
| cpoiedAltText: String |   |
| sticonCpied: boolean |   |

-> Paste

> 안녕하세요🐻오늘은 날씨가 좋네요!🌞
>
> 안녕하세요(bo)오늘은 날씨가 좋네요!(Sunny)

## 64p ~ 68p, 이모티콘을 복사 & 붙여넣기

- 처리 흐름

```
// 문자열을 앱내에 유지한다
setCopiedText(message); 
// 클립보드에 대체 텍스트를 저장
altText = TalkMessageHelper.getAltText(message);
String[] mimetype = {ClipDescription.MIMETYPE_TEXT_PLAIN};
ClipData.Item item = new ClipData.Item(altText);
ClipData cd = new ClipData(new ClipDescription("text",mimetype),item);
ClipboardManager cm = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
cm.setPrimaryClip(cd); 
// 복사시의 문자열과 비교한 후에 붙여넣기
@Override public void afterTextChanged(Editable s) {
   if (isSticonPasted()) {
      // 이모티콘 표시 처리
   }
}
```

## 69p, 이모티콘을 복사 & 붙여넣기

- 복습

SpannableString 타입

안녕하세요{ { sticon(1,10) } }오늘은 날씨가 좋네요!{ { sticon(2,20) } }

-> Copy

->

| 앱 내부 | 클립보드 |
| :-- | :-- |
| copiedRawText: String | cpoiedAltText: String |
| cpoiedAltText: String |   |
| sticonCpied: boolean |   |

-> Paste

> 안녕하세요🐻오늘은 날씨가 좋네요!🌞
>
> 안녕하세요(bo)오늘은 날씨가 좋네요!(Sunny)

## 70p

이모티콘 하나만 보내면 스탬프가 된다

## 71p, 이모티콘 하나만 보내면 스탬프가 된다

- 처리 흐름
   - 메시지 송신 타이밍에 이모티콘 하나인지 판단한다
   - 이모티콘 하나인 경우, 스탬프로 송신한다

## 72p ~ 76p, 이모티콘 하나만 보내면 스탬프가 된다

- 스탬프로 보낼지를 판단한다

```
public boolean isSendSticonAsSticker() {
   SticonSpan[] tokens =editText.getText().getSpans(0, editText.getText().length(), SticonSpan.class);
   if(tokens.length == 1) {
      // 이모티콘을 나타내는 문자열이 하나만 입력된 경우
      if(tokens[0].getTemplateString().equals(editText.getText())) {
         return true;
      }
   }
   // 이모티콘이 하나이지 않은 경우
   return false;
}
```

## 77p ~ 80p, 이모티콘 하나만 보내면 스탬프가 된다

- 스탬프를 보낸다

```
if (isSendSticonAsSticker()) {
   Editable t = editText.getText()
   SticonSpan[] spans = t.getSpans(0, t.length(), SticonSpan.class);
   // 스탬프를 생성해서 송신
   Sticker sticker = new Sticker(spans[0].getSticonId());
   sendStamp(sticker); 
} else {
   // 텍스트 메시지&이모티콘으로 송신
} 
```

## 81p, 이모티콘 하나만 보내면 스탬프가 된다

- 복습

## 82p

시간이 걸린 부분

## 83p ~ 84p, 시간이 걸린 부분

- 대량의 이모티콘을 표시하면 스크롤이 끊긴다
- 이모티콘 복사&붙여넣기하면 문자가 짤린다

## 85p, 대량의 이모티콘을 표시하면 스크롤이 끊긴다

- 스크롤의 끊김은 cache 도입으로 해결
   - LruCache
   - 문자 사이즈에 맞춰서 이모티콘 사이즈도 변화하므로, key에 문자 사이즈도 넣는다

## 86p, 대량의 이모티콘을 표시하면 스크롤이 끊긴다

- 스크롤의 끊김은 cache 도입으로 해결

## 87p, 시간이 걸린 부분

- 대량의 이모티콘을 표시하면 스크롤이 끊긴다
- `이모티콘 복사&붙여넣기하면 문자가 짤린다`

## 88p ~ 91p, 이모티콘 복사&붙여넣기하면 문자가 짤린다

- 복사&붙여넣기의 범위를 조절하는 로직을 추가한다

`안녕하세요🐻`오늘은 날씨가 좋네요!🌞

-> Copy

`안녕하세요{` { sticon(1,10) } } 이대로는 mustache의 도중에 짤린다

->

`안녕하세요{ { sticon(1,10) } }` 복사&붙여넣기를 mustache의 종단까지 늘린다

## 92p

정리

## 93p, 정리

- 구현 방법을 모를 때는 참고가 되는 앱을 찾아서 동작을 조사한다
- 이모티콘 표시에는 SpnannableString과 확장한 Span 클래스를 사용
- 표시상으로 이모티콘으로 보일뿐이고 text는 문자열이 들어있으므로, 복사&붙여넣기 등 EditText나 TextView의 처리는 주의한다