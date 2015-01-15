---
layout: page
title: 모든것은 음모다
tagline: Main page
---
{% include JB/setup %}

이곳은 개발자 마음대로 작성하는 공간입니다.

주로 안드로이드 관련으로 포스트할 예정입니다.

**블로그 이전 작업중** ... 수동 이전이므로 다소 시간이 지연됨

**GitHub Page 뒤죽박죽 작업중**

**페이지 추가 작업이 필요한 경우, `TODO` TAG가 들어가있습니다**

- - -

이전 블로그 링크 [네이버 블로그](http://blog.naver.com/pluulove84)

- - -

## 최근 포스트 (Limit 10)

<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>



