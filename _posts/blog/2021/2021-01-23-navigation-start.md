---
layout: post
title: "간단하게 Navigation 생성 및 흐름 살펴보기"
date: 2021-01-23 14:00:00 +09:00
tag: [Android, AndroidX, Navigation]
categories:
- blog
- Android
---

개인으로 AndroidX Navigation의 흐름을 확인하기 위한 정리한 부분입니다.

<!--more-->

아래 흐름을 확인한 샘플 프로젝트는 아래와 같습니다.

- 프로젝트 : https://github.com/android/sunflower

## Navigation 생성

NavHostFragment#onCreate에서 아래 기능이 호출

#### 간략한 호출 흐름

NavHostController 생성

- NavigatorProvider 생성
  - NavigatorProvider#addNavigator
    - NavGraphNavigator (navigation) 추가
    - ActivityNavigator (activity) 추가

NavHostFragment#onCreateNavController

- NavHostController#getNavigatorProvider
  - NavigatorProvider#addNavigator
    - DialogFragmentNavigator (dialog) 추가
    - FragmentNavigator (fragment) 추가

NavHostController#setGraph

- NavHostController#getNavInflater()
  - NavInflater 생성
- NavInflater#inflate(@NavigationRes graphResId) : NavDestination
  - Resource에 있는 Naviagtion Xml 파싱
    - Argument, DeepLink, Action, NavGraph 처리
  - 최종 생성되는 NavDestination은 NavGraph 객체
    - NavGraph내부의 Node 객체에 NavDestination
- NavHostController#onGraphCreated(@Nullable Bundle startDestinationArgs)
  - NavController#navigate
  - NavGraphNavigator#navigate
    - res#navigation에 정의된 startDestination에 해당하는 NavDestination Node 반환
      - FragmentNavigator.Destination 반환
    - NavigatorProvider#getNavigator(FragmentNavigator.Destination#getNavigatorName)
      - FragmentNavigator 반환
    - FragmentNavigator#navigate

## findNavController().navigate(NavDirections)

> NavDirections이 Fragment인 경우

#### 간략한 호출 흐름

findNavController()

- NavHostController 반환

NavHostController#navigate

- NavigatorProvider#getNavigator(NavDirections#getNavigatorName)
  - FragmentNavigator 반환
- FragmentNavigator#navigate
