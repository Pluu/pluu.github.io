---
layout: post
title: "Android HTML Parser jsoup"
date: 2015-04-14 16:17:00
tag: [Android, jsoup]
categories:
- blog
- Android-Study
---

최근 만화/소설 뷰어 관련 개인 프로젝트 진행하면서

HTML Parser Library로 jsoup을 사용후 관련 포스팅을 남깁니다.

`Jericho`가 유명하지만, 2012년 10월 말 이후 업데이트가 없어서 ... 

[Jericho 다운로드 사이트](http://sourceforge.net/projects/jerichohtml/files/jericho-html/)

그래서, HTML Parser쪽 부흥하고 있는 `jsoup`을 사용하는 것으로 결정했습니다

<!--more-->

- - -

## Android Studio Gradle dependencies

{% highlight Groovy %}
compile 'org.jsoup:jsoup:1.8.2'
{% endhighlight %}

- - -

## Simple jsoup

{% highlight java linenos %}
Document doc = Jsoup.connect(url).get();
{% endhighlight %}

## 간단한 HTML Parse (GET, POST)

{% highlight java linenos %}
Document doc = null;

// GET 방식
doc = Jsoup.connect(url).data("data", data).get();

// POST 방식
doc = Jsoup.connect(url).data("data", data).post();
{% endhighlight %}

## JSON 데이터 취득

{% highlight java linenos %}
String jsonData = Jsoup.connect(url).ignoreContentType(true).execute().body();
{% endhighlight %}

- - -

## HTML Selector

아래 항목의 일부를 번역했습니다

[selector-syntax to find elements](http://jsoup.org/cookbook/extracting-data/selector-syntax)

Selector overview

- `tagname`: 태그명으로 찾기, Ex) a
- `ns|tag`: namespace와 태그명으로 찾기, Ex) <fb:name> 찾기 fb|name
- `#id`: ID명으로 찾기, Ex) #logo
- `.class`: Class명으로 찾기, Ex) .masthead
- `[attribute]`: attribute명으로 찾기, Ex) [href]
- `[^attr]`: 앞글자가 같은 attribute명으로 찾기, Ex) [^data-]
- `[attr=value]`: attribute과 value로 찾기, Ex) [width=500]
- `[attr^=value]`, `[attr$=value]`, `[attr*=value]`: 앞글자, 뒷글자, 글자 포함으로 찾기, Ex) [href*=/path/]
- `[attr~=regex]`: 정규 표현식으로 찾기, Ex) img[src~=(?i)\.(png|jpe?g)]
- `*`: 모든 데이터, Ex) *

Selector combinations

- `el#id`: 해당 ID를 가진 elements, Ex) div#logo
- `el.class`: 해당 Class를 가진 elements, Ex) div.masthead
- `el[attr]`: 해당 Attribute 가진 elements, Ex) a[href]
- Any combination, e.g. a[href].highlight
- `ancestor child`: child elements that descend from ancestor, e.g. .body p finds p elements anywhere under a block with class "body"
- `parent > child`: 상위 element를 가지는 하위 elements 찾기, Ex) div.content > p
- `siblingA + siblingB`: finds sibling B element immediately preceded by sibling A, e.g. div.head + div
- `siblingA ~ siblingX`: finds sibling X element preceded by sibling A, e.g. h1 ~ p
- `el, el, el`: 복수 elements 찾기, Ex) div.masthead, div.logo

Pseudo selectors

- `:lt(n)`: find elements whose sibling index (i.e. its position in the DOM tree relative to its parent) is less than n; e.g. td:lt(3)
- `:gt(n)`: find elements whose sibling index is greater than n; e.g. div p:gt(2)
- `:eq(n)`: find elements whose sibling index is equal to n; e.g. form input:eq(1)
- `:has(seletor)`: find elements that contain elements matching the selector; e.g. div:has(p)
- `:not(selector)`: find elements that do not match the selector; e.g. div:not(.logo)
- `:contains(text)`: find elements that contain the given text. The search is case-insensitive; e.g. p:contains(jsoup)
- `:containsOwn(text)`: find elements that directly contain the given text
- `:matches(regex)`: find elements whose text matches the specified regular expression; e.g. div:matches((?i)login)
- `:matchesOwn(regex)`: find elements whose own text matches the specified regular expression

- - -

참고 사이트

1. [jsou 공식 사이트](http://jsoup.org/download)
2. [jsou Selector](http://jsoup.org/cookbook/extracting-data/selector-syntax)