---
layout: post
title: "[번역] DroidKaigi 2016 ~ 실천! Android Studio Plugin 개발"
date: 2016-03-31 21:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

<!--more-->

본 포스팅은 [実践！Android Studioプラグイン開発
](https://speakerdeck.com/konifar/shi-jian-android-studiopuraguinkai-fa) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

실제 `슬라이드의 일본어` 부분을 번역했다는 점 양해바랍니다.

<!--more-->

## 1p

**실천! Android Studio Plugin 개발**

- 2016/02/18 (목)
- 小西 裕介 (@konifar)
- DroidKaigi RoomB

## 2p

こにふぁー (@konifar)

## 3p

**Taptrip**

- 전 세계에 친구를 만든다
- `자동번역`으로 간단한 커뮤니케이션
- `250개국 / 500만 명`이 이용

[https://play.google.com/store/apps/details?id=com.taptrip](https://play.google.com/store/apps/details?id=com.taptrip)

## 4p

**android-material-icon-generator**

[https://github.com/konifar/android-material-design-icon-generator-plugin](https://github.com/konifar/android-material-design-icon-generator-plugin)

## 5p ~ 8p

**android-material-icon-generator**

- Material Icon을 간단하게 배치할 수 있다
  - [https://github.com/google/material-design-icons](https://github.com/google/material-design-icons)
- 단어로 Incremental 검색할 수 있다
- 아이콘 색을 자유롭게 변경 가능하다

`특히 개인 개발시 무척 편리!`

## 9p

android-material-icon-generator

## 10p

40,000 정도 설치

## 11p

Plugin 개발을 이야기합니다

## 12p

Plugin 개발 특징 복습

## 13p ~ 15p

**AndroidStudio Plugin 특징**

- IntelliJ 기반. `개발 시에는 IntelliJ가 필요`
- 화면 쪽은 `Swing`
- Java7은 동작하지 않으므로 `Java6`에서 개발이 필요

## 16p

HelloWorld

## 17p ~ 23p

**HelloWorld 순서**

1. IntelliJ 설치
2. IntelliJ Platform Plugin 프로젝트 작성
3. plugin.xml 기술
  ① name
  ② version
  ③ 연락처 메일 주소
  ④ Site URL
  ⑤ Header 이름
  ⑥ 설명
  ⑦ Change notes  
4. Action Class 작성
5. 빌드 실행

```
public class HelloWorldAction extends AnAction {
  public void actionPerformed(AnActionEvent event) {
    // 여기에 처리를 적는다. 이하는 HelloWorld Notification을 나타내는 코드
    Notifications.Bus.notify(
    new Notification("group", "Hello World Title", "Hello World Content",
      NotificationType.INFORMATION));
  }
}
```

자세한 것은 Qitta에!

[http://qiita.com/konifar/items/c6e23921ffec475907fc](http://qiita.com/konifar/items/c6e23921ffec475907fc)

## 24p

여기까지는 그다지 간단

## 25p

문제는 여기부터

## 26p

**무엇을 어떻게 하면 좋은가 모르겠다**

- Text 선택 시에 Menu를 표시하기 위해서는?
- Dialog나 Alert을 어떻게 표시하는가?
- File 조작은 어떻게 하는가?

## 27p

Plugin을 실제로 만들 때 도움되는 이야기를 합니다

## 28p

**오늘 이야기할 것**

1. 알아둬야 하는 Class와 역할
2. UI 구현
3. 고민할 때에 조사 방법

## 29p

**오늘 이야기하지 않을 것**

1. 기본적인 개발 흐름
2. swing의 자세한 이야기
3. 테스트 코드 이야기

## 30p

1. 알아둬야 하는 Class와 역할

## 31p ~ 32p

1. AnActionEvent
2. Project
3. Editor
4. Document
5. PsiFile

## 33p

**AnActionEvent**

- Plugin의 Action에 관련된 여러 가지 정보를 얻는 Class
- 프로젝트 내부를 참조, 조작하고 싶을 때에 이 Class로부터 정보를 얻을 수 있다

## 34p

**메뉴 표시 전환**

- strings.xml에서 Right Click
- java 파일에서 Right Click

## 35p ~ 37p

**메뉴 표시 전환**

```
@Override
public void update(AnActionEvent event) {
  VirtualFile file = event.getData(PlatformDataKeys.VIRTUAL_FILE);
  boolean isStringXml = file != null && file.getName().equals("strings.xml");
  event.getPresentation().setVisible(isStringXml);
}
```

- strings.xml인지 판정
- event.getPresentation().setVisible()에서 표시를 전환

## 39p

**Project**

- Project 이름이나 폴더 Path등, 프로젝트 정보를 얻을 수 있다
- ProejctRootManager()를 사용해서 SDK나 빌드대상의 소스 폴더 등도 얻을 수 있다

## 40p ~ 42p

**SDK 버전 취득**

```
Project project = event.getData(PlatformDataKeys.PROJECT);
Sdk sdk = ProjectRootManager.getInstance(project).getProjectSdk();
System.out.println("sdk_version: " + sdk.getVersionString());
// => sdk_version: java version "1.7.0_71"
```

- ProjectRootManager를 사용해서 Sdk 취득
- Root Path이나 File 리스트를 얻을 수도 있다

## 44p

**Editor**

- Editor 안의 정보를 얻을 수 있다

## 45p ~ 47p

**Selection 내의 Text 취득**

```
@Override
public void invoke(Project project, Editor editor, PsiFile file) {
  final SelectionModel selectionModel = editor.getSelectionModel();
  boolean hasSelection = selectionModel.hasSelection();
  if (hasSelection) {
    final String selectedText = selectionModel.getSelectedText(true);
```

- editor.getSelectionModel()에서 Selection 텍스트 정보를 얻어 hasSelection()으로 선택 중인가를 판정
- getSelectedText()으로 Selection의 텍스트를 취득

## 48p ~ 49p

**Editor를 가장 위까지 스크롤**

```
@Override
public void invoke(Project project, Editor editor, PsiFile file) {
  ScrollingModel scrollingModel = editor.getScrollingModel();
  // 가장 위까지 스크롤
  scrollingModel.scrollVertically(0);
```

- getScrollingModel()로 스크로를 나타낸 Model을 취득
- scrollVertically(0)으로 가장 위까지 스크롤 시킨다

## 51p

**Document**

- Editor에 표시한 Text를 취득, 편집할 수 있다

## 52p ~ 53p

**Editor 내의 텍스트를 취득**

```
Editor editor = event.getData(PlatformDataKeys.EDITOR);
Document document = editor.getDocument();
String text = document.getText();
```

- editor.getDocument().getText()로 텍스트를 얻는다

## 54p ~ 55p

**Editor 내의 변경을 감지**

```
Editor editor = event.getData(PlatformDataKeys.EDITOR);
Document document = editor.getDocument();
document.addDocumentListener(new DocumentListener() {
  @Override
  public void beforeDOcumentChange(DocumentEvent documentEvent) {

  }

  @Override
  public void documentChanged(DocumentEvent documentEvent) {
    // Droid를 치면, 'D', 'r', 'o', 'i', 'd' 5번 이곳을 통과한다
    System.out.println("Changed:" + documentEvent.getNewFragment());
  }  
});
```

## 57p

**PsiFile**

- Program Structure Interface File
- IntelliJ에서 다루는 파일 추상 클래스
- 프로젝트의 파일 정보를 얻을 수 있다

## 58p

커서 위치의 Java 클래스를 취득

## 59p ~ 62p

**커서 위치의 Java 클래스를 취득**

```
PsiFile psiFile = event.getData(LangDataKeys.PSI_FILE);
// 커서 위치 취득
int offset = editor.getCaretModel().getoffset();
// 커서 위치 요소 취득
PsiElement element = psiFile.findElementAt(offset);
// 부모 클래스 취득
PsiClass psiClass = PsiTreeUtil.getParentOfType(element, PsiClass.class);

System.out.println("Element:" + element.getText() + ", PsiClass:" + psiClass);
// => Element: FloatingActionButton, PsiClass: PsiClass:MainActivity
```

- editor.getCaretModel()로부터 커서 위치를 얻는다
- psiFile.findElementAt(offset)으로 커서 위치 요소를 취득
- 커서 위치에 있는 테스트 FloatingActionButton의 Element

## 63p

UI 구현

## 64p

**쓰기 편리한 컴포넌트**

1. Dialog
2. Editor Hint
3. Notification
4. File Chooser

## 67p ~ 68p

**DIalogWrapper를 사용**

```
public class SampleDialogWrapper extends DIalogWrapper {
  private JPanel contentPane;

  public SampleDialogWrapper(@Nullable Project project) {
    super(project);
    setTitle("Sample Dialog");
    init();
  }

  @Nullable
  @Override
  protected JComponent createCenterPanel() { return contentPane; }
}
```

## 69p ~ 70p

**Dialog 호출**

```
DIalogWrapper dialog = new SampleDialogWrapper(e.getProject());
dialog.show();
```

## 73p ~ 74p

**HintManager**

```
Editor editor = e.getData(PlatformDataKeys.EDITOR);
HintManager.getInstance().showInformationHint(editor, "Sample information");
```

## 77p ~ 78p

**Notifications.Bus**

```
Notifications.Bus.nofity(
  new Notification("sampleDisplayId", "Sample title",
    "Sample content", NotificationType.INFORMATION));
```

## 81p ~ 82p

**TextFieldWithBrowseButton**

```
public class SampleDialogWrapper extends DIalogWrapper {
  private JPanel contentPane;
  private TextFieldWithBrowseButton textFieldWithBrowseButton

  public SampleDialogWrapper(@Nullable Project project) {
    super(project);
    setTitle("Sample Dialog");
    init();
    Editor editor = e.getData(PlatformDataKeys.EDITOR);
    textFieldWithBrowseButton.addBrowseFolderListener(new TextBrowseFolderListener(
      new FileChooserDescriptor(false, true, false, false, false, false), project));
  }
}
```

- TextFieldWithBrowseButton에 addBrowseFolderListener()를 붙인다

## 83p

고민할 때에 조사 방법

## 84p

공개되어있는 코드를 읽는 것이 가장 빠르다

## 85p ~ 86p

**Android Studio Plugin Repository**

[https://githb.com/konifar/android-material-design-icon-generator-plugin](https://githb.com/konifar/android-material-design-icon-generator-plugin)

## 87p

**추천 5가지**

1. intellij-sdk-docs
2. android-parcelable-intellij-plugin
3. android-drawable-importer-intellij-plugin
4. adb-idea
5. Android Studio Code

## 88p

**intellij-sdk-docs**

- 공식 문서
- Editor 조작이나 Code Inspection 등 종류별로 나뉘어 심플한 구현 코드가 모여있다
- Kotlin 샘플도 있다

[https://github.com/JetBrains/intellij-sdk-docs/tree/master/code_samples](https://github.com/JetBrains/intellij-sdk-docs/tree/master/code_samples)

## 89p

**android-parcelable-intellij-plugin**

- Parcelable 구현 코드를 자동 생성해주는 Plugin
- Dialog 표시나 코드 생성, File 갱신 등의 구현방법이 있다

[https://github.com/mcharmas/android-parcelable-intellij-plugin](https://github.com/mcharmas/android-parcelable-intellij-plugin)

## 90p

**android-drawable-importer-intellij-plugin**

- 아이콘을 Project의 dpi 폴더에 간단하게 배치하는 Plugin
- 리소스 파일 읽기이나 Http통신 등의 구현방법이 있다

[https://github.com/winterDroid/android-drawable-importer-intellij-plugin](https://github.com/winterDroid/android-drawable-importer-intellij-plugin)

## 91p

**adb-idea**

- adb 명령어를 Android Studio에서 간단하게 실행하는 Plugin
- Dialog 표시이나 Plugin에서 터미널 명령어를 다루는 방법이 있다

[https://github.com/pbreault/adb-idea](https://github.com/pbreault/adb-idea)

## 92p

**Android Studio Code**

- Android Studio 자체 코드를 읽으면 좋다
- 명령어이나 버전 지정은 Android Tools Project Site 페이지의 Build Overview를 참고

[http://tools.android.com/build](http://tools.android.com/build)

## 93p

정리

## 94p

Project이나 Editor 등의 클래스는 기억해두자

## 95p

UI도 Dialog이나 Notification은 준비되어있다

## 96p

모를 때는 비슷한 코드를 읽어보자

## 97p

그래도 어떻게 하지 못할 때는

## 98p ~ 99p

Intellij Plugin 스터디

@androhi님이 주최하는 IntelliJ Plugin 스터디가 근시일내에 3번째가 됩니다

## 100p

원하는 Plugin을 만들어 Android 개발을 더욱 재미있게

## 101p

감사합니다!
