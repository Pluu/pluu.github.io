---
layout: post
title: "ConstraintLayout 1.1.0 Changes 모음"
date: 2018-04-16 23:40:00 +09:00
tag: [Android, ConstraintLayout]
categories:
- blog
- Android
---

ConstraintLayout 1.1.0 가 릴리즈 되었습니다. 미쳐 놓친 변경 로그를 정리했습니다

<!--more-->

- - -

가장 큰 변경점은 아래 정보가 변경되었습니다.

- `layout_constraintWidth_default` / `layout_constraintHeight_default` 의 속성 정보중 `wrap`가 deprecated 되었습니다. 사용시 아래와 같은 로그가 출력됩니다.
   - ConstraintLayout: layout_constraintWidth_default="wrap" is deprecated.
    Use layout_width="WRAP_CONTENT" and layout_constrainedWidth="true" instead.
   - 변경할 부분은 layout_constraintWidth_default="wrap" 대신 `layout_width="WRAP_CONTENT"` 과 `layout_constrainedWidth="true"` 를 사용하면 됩니다
- Circular positioning

<div align="center" >
    <img width="325px" src="https://developer.android.com/reference/android/support/constraint/resources/images/circle1.png">
    <img width="325px" src="https://developer.android.com/reference/android/support/constraint/resources/images/circle2.png">
</div>

- Barriers
- Group

- - -

## 변경 로그

### ConstraintLayout 1.1.0 beta 6

- Improved optimizer performances and exposed it (see documentation)
- Additional experimental performance work with Chains (turned off by default)
- Fixed several issues with margins support in Chains
- Centering larger chains on smaller endpoints now works
- Fix barrier issues (wrap_content behavior)
- ConstraintSet issues with RTL fixed

### ConstraintLayout 1.1.0 beta 5

- Fix barrier issues (wrap_content behavior)
- Added missing ConstraintSet.constrainCircle() method
- Chain RTL behavior fix

### ConstraintLayout 1.1.0 beta 4

- Fixes issue with incorrect spread in Chain
- Fixes RTL issues (guideline, chains, bias)
- Fixes missing percent handling in ConstraintSet
- Fixes various barriers issues
- Improved xml inflation speed

### ConstraintLayout 1.1.0 beta 3 is now available

- Various bugfixes (spread_inside chain, ratio in chain, constraintset)
- RTL guideline support
- Circular constraints

### ConstraintLayout 1.1.0 beta 2

- Many bug fixes (mostly in complex behavior in chains, match constraint, min/max/ratio/percent)
- Redesign of the constraint optimizer, performances are improved
- Change in behavior with 0dp in packed chain (0dp elements will spread)
- Added a new attribute to enforce constraints on wrap_content if needed (previously, wrap_content was considered a fixed dimension not subject to the constraints):
   - app:layout_constrainedWidth=”true|false”
   - app:layout_constrainedHeight=”true|false”
   - Note that the setting to have a match_constraint set to wrap behavior has been deprecated, instead you should use the above layout_constrainedWidth/Height attribute along with width=wrap_content.

### ConstraintLayout 1.1.0 beta 1 release notes

- Bugfixes related to wrap_content
- New features: barriers, placeholder, percent dimensions

## ConstraintLayout 2.0

ChicagoRoboto 2018 에서 공개된 ConstraintLayout 2.0 관련 정보도 첨부합니다.

<script async class="speakerdeck-embed" data-id="fb3afb29302a4b25933532deac0e703c" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>