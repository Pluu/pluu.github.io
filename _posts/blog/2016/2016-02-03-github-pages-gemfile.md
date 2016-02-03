---
layout: post
title: "GitHub Pages Jekyll 3.0으로 Upgrade"
date: 2016-02-03 10:40:00 +09:00
tag: [GitHub, Jekyll]
categories:
- blog
- GitHub
---

GitHub가 어제 GitHub Pages에서 사용하는 Jekyll 3.0으로 업그레이드 안내했습니다.

<!--more-->

## Change

상세내용은 [GitHub Pages now faster and simpler with Jekyll 3.0](https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0) 을 참고해주세요.

간단하게 변경 관련 내용은

1. Markdown
 - Jekyll 기본 Markdown 엔진을 `Kramdown`만 지원 (2016년 5월 1일부터)
 - Rdiscount 과 Redcarpet은 미지원
2. Highlight
 - `Rouge`만 지원 (Python과 Pygments를 설치하지 않아도 됨)
3. Need for speed
 - `build` 혹은  `serve` 명령어 입력시 `--profile`를 추가함으로 빌드 시간 얻을 수 있음
4. Two additional changes
 - relative permalinks를 지원하지 않음 (Jekyll 2.0에서 명시적으로 `relative_permalinks: true`를 사용한 경우에 해당)
 - 2016년 5월 1일부터 GitHub Pages [Textile](http://redcloth.org/textile)를 지원하지 않음

Jekyll 3.0의 상세한 변경 사항은 [Jekyll Upgrading from 2.x to 3.x](http://jekyllrb.com/docs/upgrading/2-to-3/) 문서를 참고하세요

- - -

## gem update

아래 설정 중 필요한 update 명령어를 입력

- gem update github-pages
- bundle update github-pages

## Change Markdown

`_config.yml` 파일의 Markdown을 변경

```diff
-markdown: redcarpet
-highlighter : pygments
-redcarpet:
-  extensions: ["no_intra_emphasis", "fenced_code_blocks", "autolink", "tables", "strikethrough", "superscript", "with_toc_data"]
+kramdown:
+  input: GFM
```

## Support

이상한 모임의 `시아님`, [GitHub riseshia](https://github.com/riseshia)의 도움으로 손쉽게 업그레이드를 할 수 있었습니다.

좀 더 자세한 사항은 시아님 포스팅을 참고해주시길 바랍니다

[Upgrade to Jekyll 3.0](https://riseshia.github.io/2016/02/02/upgrade-to-jekyll-3-0.html)

### P.S.

기존 테마를 사용한 곳에서 이전부터 별도로 업데이트가 이루어지지 않는 걸로 보아

2016년 5월 1일에 제대로 동작할지는 잘 모르겠네요

하하하하하하
