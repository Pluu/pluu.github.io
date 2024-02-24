---
layout: post
title: "UI Code Snippet용 Plugin 제작기 ~ 2부 : ActionButton/JList"
date: 2024-02-24 17:30:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

- 0부 : [서론]({{ site.url }}/blog/android/2024/02/04/designsystem-plugin-00/)
- 1부 : [ToolWindow/Configurable]({{ site.url }}/blog/android/2024/02/10/designsystem-plugin-01/)
- 2부 : [ActionButton/JList]({{ page.url }}) <- 현재 글

------

사전 조건

기본적인 Plugin 작업 시 IntelliJ에서 제공하는 [IntelliJ Platform Plugin Template](https://github.com/JetBrains/intellij-platform-plugin-template)을 사용하시면 됩니다.

---

이번 글에서는 Tool Windows에서 보이는 부분을 만들어 볼 단계입니다.

- 창 상단의 메뉴 (Add/Refresh/Search/Filter) -> ActionButton/SearchTextField
- 리스트 결과 -> [JList](https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/javax/swing/JList.html)

> 일부 상세 구현은 생략되어 있습니다.

---

## 기본 컴포넌트 구성

{% include img_assets.html id="/blog/2024/designsystem_plugin/06.png" %}

위 이미지를 보면 UI 구성에 몇 가지의 컴포넌트를 사용하고 있습니다. 개별 항목을 구현하기 전에 먼저 구현할 영역을 나눠보겠습니다.

- 전체 큰 틀 --> DesignSystemExplorer
- 상단 영역 (빨간색 영역) --> DesignSystemExplorerToolbar
- 하단 리스트 영역 (노란색 영역) --> DesignSystemExplorerView

## 1. 전체 큰 틀 (DesignSystemExplorer)

이전 1부에서 작성한 ToolWindowFactory#createToolWindowContent을 구현하면 실제 내용을 그릴 수 있습니다. 먼저 전체 틀을 담당하는 컴포넌트를 생성한 후 ToolWindow의 [ContentManager](https://github.com/JetBrains/intellij-community/blob/idea/233.14015.106/platform/ide-core/src/com/intellij/ui/content/ContentManager.java)를 통해서 추가합니다.

```kotlin
class DesignSystemToolWindowFactory : ToolWindowFactory {
   override fun createToolWindowContent(project: Project, toolWindow: ToolWindow) {
      val designSystemExplorer = DesignSystemExplorer.createForToolWindow()
      val contentManager = toolWindow.contentManager
      val content = contentManager.factory.createContent(designSystemExplorer, null, false)
      contentManager.addContent(content)
   }
}
```

> https://plugins.jetbrains.com/docs/intellij/tool-windows.html#contents-tabs

DesignSystemExplorer는 [BorderLayout](https://docs.oracle.com/javase%2F7%2Fdocs%2Fapi%2F%2F/java/awt/BorderLayout.html)으로 레이아웃 형태로 구현합니다. BorderLayout이 아니더라도 JPanel 생성자에 넘기는 파라미터는 [LayoutManager](https://docs.oracle.com/javase%2F7%2Fdocs%2Fapi%2F%2F/java/awt/LayoutManager.html) 인터페이스를 구현한 클래스 인스턴스라면 다른 레이아웃도 가능합니다.

```kotlin
class DesignSystemExplorer private constructor(
   private val designSystemExplorerView: DesignSystemExplorerView,
   private val toolbar: DesignSystemExplorerToolbar,
) : JPanel(BorderLayout()) {
   init {
      val centerContainer = JPanel(BorderLayout())
      centerContainer.add(toolbar, BorderLayout.NORTH)
      centerContainer.add(designSystemExplorerView)
      add(centerContainer, BorderLayout.CENTER)
   }
  
   companion object {
      @JvmStatic
      fun createForToolWindow(): DesignSystemExplorer {
         val toolbar = DesignSystemExplorerToolbar()
         val designSystemExplorerView = DesignSystemExplorerView()
         return DesignSystemExplorer(
            designSystemExplorerView,
            toolbar
         )
      }
   }
}

class DesignSystemExplorerToolbar : JPanel(...) {
   // TBD
}
class DesignSystemExplorerView : JPanel(...) {
   // TBD
   private val listView = DesignSystemExplorerListView(...)
   ...
}
```

> 대부분의 컴포넌트는 JComponent 추상 클래스의 하위 항목이지만, 여러 컴포넌트가 동시에 존재한다면 JPanel 클래스와 어떻게 그려질지를 담당하는 Layout이 사용됩니다.

## 2. Toolbar (DesignSystemExplorerToolbar)

{% include img_assets.html id="/blog/2024/designsystem_plugin/07.png" %}

Plugin의 상단 영역을 구성하는 부분(DesignSystemExplorerToolbar)을 만들어 보겠습니다. 상단 영역은 아래의 컴포넌트가 있습니다.

- Add/Refresh Action 버튼
- 검색을 담당하는 SearchTextField
- Filter Action 버튼

```kotlin
class DesignSystemExplorerToolbar : JPanel() {
   init {
      // Horizontal 형태로 레이아웃을 구성
      layout = BoxLayout(this, BoxLayout.X_AXIS)
     
      val addAction = action(AddAction())
      val refreshAction = action(RefreshAction())
      // History 기능 지원으로 true로 초기화
      val searchTextField = SearchTextField(true)
      val filterAction = action(FilterAction())

      add(addAction)
      add(refreshAction)
      add(searchAction)
      add(filterAction)
     
      searchTextField.addDocumentListener(object : DocumentAdapter() {
         override fun textChanged(e: DocumentEvent) {
            // 텍스트 업데이트시 반영 (searchTextField.text)
         }
      })
   }
}

class RefreshAction : AnAction(
   "Refresh",
   /** ... */ ,
   AllIcons.Actions.Refresh
) {
   override fun actionPerformed(e: AnActionEvent) {
      // Refresh 버튼 선택 시 동작
   }
}

class AddAction : AnAction(
   "Add item",
   /** ... */ ,
   AllIcons.General.Add
) {
   override fun actionPerformed(e: AnActionEvent) {
      // Add 버튼 선택 시 동작
   }
}

class FilterAction : PopupAction(AllIcons.General.Filter, FILTERS_BUTTON_LABEL) {
   override fun createAddPopupGroup() = DefaultActionGroup().apply {
      // 필터 옵션 동작
      // None/S/M/L 기능 (ToggleAction으로 구현)
   }
}

private fun action(
    addAction: AnAction
) = ActionButton(addAction, PresentationFactory().getPresentation(addAction), "", BUTTON_SIZE)
```

UI에 한정적으로 기본적인 구현을 설명하겠습니다.

- Add/Refresh와 같은 [Action](https://plugins.jetbrains.com/docs/intellij/basic-action-system.html#runtime-placeholder-action)들은 [ActionButton](https://github.com/JetBrains/intellij-community/blob/master/platform/platform-impl/src/com/intellij/openapi/actionSystem/impl/ActionButton.java) 생성자로 전달하여 버튼처럼 사용할 수 있습니다.
- 검색어 입력을 받을 SearchTextField 컴포넌트에 addDocumentListener 함수를 사용해 텍스트 변경을 탐지할 수 있습니다. 

{% include img_assets.html id="/blog/2024/designsystem_plugin/08.png" %}

제가 만든 Plugin의 경우에는 FilterAction 선택 시 팝업이 노출되고 몇 개의 항목 중 하나를 선택하는 기능이 있습니다. 팝업을 노출하기 위해서 PopupAction을 사용하였으며, None/S/M/L 선택에 [ToggleAction](https://plugins.jetbrains.com/docs/intellij/basic-action-system.html#toggleselection)을 사용했습니다.

## 3. 상단 Tab 영역

{% include img_assets.html id="/blog/2024/designsystem_plugin/09.png" %}

여러 타입 중 하나를 선택할 수 있도록 하는 Tab 기능은 Swing에서 제공하는 [TabbedPaneLayout](https://docs.oracle.com/javase/8/docs/api/javax/swing/plaf/basic/BasicTabbedPaneUI.TabbedPaneLayout.html)을 사용했습니다. 그러나, **Resource Manager**와 비슷한 노출을 위해서 해당 Plugin에서 사용하는 [OverflowingTabbedPaneWrapper](https://cs.android.com/android-studio/platform/tools/adt/idea/+/mirror-goog-studio-main:android/src/com/android/tools/idea/ui/resourcemanager/widget/OverflowingTabbedPaneWrapper.kt) 코드를 그대로 사용합니다. 참고로 OverflowingTabbedPaneWrapper의 Tab은 [JTabbedPane](https://docs.oracle.com/javase/8/docs/api/javax/swing/JTabbedPane.html) 컴포넌트가 사용되고 있습니다.

```kotlin
class DesignSystemExplorerView(
   tabs: List<DesignSystemTab>
) : JPanel(...) {
   private val resourcesTabsPanel = OverflowingTabbedPaneWrapper().apply {
      tabs.forEach {
         // 생성자로 전달된 tabs으로 JTabbedPane에 새로운 Tab을 추가
         tabbedPane.add(it.name, null)
      }
      tabbedPane.addChangeListener { event ->
         val index = (event.source as JTabbedPane).selectedIndex
         // 선택한 탭 기준으로 업데이트
      }
   }

   private val centerPanel = JPanel().apply {
      layout = BoxLayout(this, BoxLayout.Y_AXIS)
      // 추후 결과 리스트가 추가될 Panel
   }

   private val root: JPanel = panel {
      row { cell(resourcesTabsPanel).align(AlignX.FILL) }
      row { cell(centerPanel).align(Align.FILL) }
   }
  
   init {
      add(root)
      ...
   }
}

// Tab에서 사용할 데이터 클래스
data class DesignSystemTab(
    val name: String,
    ...
)
```

## 4. 리스트 영역 (DesignSystemExplorerListView)

{% include img_assets.html id="/blog/2024/designsystem_plugin/10.png" %}

다음은 리스트 영역(DesignSystemExplorerListView)을 그려볼 차례입니다. DesignSystemExplorerListView는 JList 클래스를 상속하여 구현합니다. [JList](https://docs.oracle.com/javase/8/docs/api/javax/swing/JList.html)는 이름대로 리스트 형태의 UI 컴포넌트입니다. 실제 작업에는 JList의 확장인 [JBList](https://github.com/JetBrains/intellij-community/blob/idea/233.14475.28/platform/platform-api/src/com/intellij/ui/components/JBList.java)를 사용합니다. 

JList에 사용될 데이터는 별도 모델인 [ListModel](https://docs.oracle.com/javase/8/docs/api/javax/swing/ListModel.html)로 전달해야 합니다.

> List and Tree Controls : https://plugins.jetbrains.com/docs/intellij/lists-and-trees.html

데이터를 기준으로 Cell을 그리는 것은 JList의 **cellRenderer 속성**을 사용합니다. JList의 cellRender는 [ListCellRenderer](https://docs.oracle.com/javase/8/docs/api/javax/swing/ListCellRenderer.html) 인터페이스 타입을 필요로 합니다. 샘플에서는 [ListCellRenderer](https://docs.oracle.com/javase/8/docs/api/javax/swing/ListCellRenderer.html) 인터페이스 정의대로 구현했습니다.

```kotlin
class DesignSystemExplorerListView(
   assets: List<DesignAssetSet>
) : JBList(BorderLayout()) {
   ...
   init {
     ...
     // 레이아웃 그리는 방식
     layoutOrientation = JList.VERTICAL
     // 각 항목(Cell)을 그리는 CellRenderer 적용
     cellRenderer = DesignAssetCellRenderer(...)     
     
     // 실제 데이터 적용
     val collectionListModel = CollectionListModel(assets)
     model = CollectionListModel(collectionListModel)
   }
}

class DesignAssetCellRenderer(
   ...
) : ListCellRenderer<DesignAssetSet> {
    // TBD
}

// Cell 항목에 사용될 객체
data class DesignAssetSet(...)
```

### CellRenderer (DesignAssetCellRenderer)

{% include img_assets.html id="/blog/2024/designsystem_plugin/11.png" %}

마지막으로 개별 Cell을 그릴 차례입니다. 위 이미지에서는 JList의 Cell 하나에서 Image/Label과 같은 컴포넌트를 사용했습니다. Cell 그리는 담당은 [ListCellRenderer](https://docs.oracle.com/javase/8/docs/api/javax/swing/ListCellRenderer.html)입니다. [ListCellRenderer#getListCellRendererComponent](https://docs.oracle.com/javase/8/docs/api/javax/swing/ListCellRenderer.html#getListCellRendererComponent-javax.swing.JList-E-int-boolean-boolean-)에서 화면에 보일 Component를 반환합니다.

```kotlin
class DesignAssetCellRenderer(
   private val assetPreviewManager: DesignAssetPreviewManager, // 이미지 로드용 Manager 클래스
   ...
) : ListCellRenderer<DesignAssetSet> {
   override fun getListCellRendererComponent(
      list: JList<out DesignAssetSet>,
      value: DesignAssetSet,
      index: Int,
      isSelected: Boolean,
      cellHasFocus: Boolean
   ): Component {
        // 화면에 보여질 Cell View
        val assetView = RowAssetView(...)
     
        // 이미지 로드
        val iconProvider = assetPreviewManager.getPreviewProvider(...)
        val icon = iconProvider.getIcon(...,
           /** thumbnail width size */,
           /** thumbnail height size */,
           list,
           { list.getCellBounds(index, index)?.let(list::repaint) },
           { index in list.firstVisibleIndex..list.lastVisibleIndex })
        assetView.thumbnail = icon
     
        return assetView
   }
}
```

#### 화면에 보일 Cell View

화면에 그려질 View는 간단한 형태입니다.

- 첫 번째 영역 : 이미지 노출
- 두 번째 영역 : 좌/우 텍스트 노출 (예:컴포넌트 명칭 / 적용할 파일 타입)
- 세 번째 영역 : 좌/우 텍스트 노출 (예:별칭명 / 컴포넌트 타입)

해당 컴포넌트들도 Panel DSL과 JLabel을 사용해서 배치합니다. 

```kotlin
class RowAssetView(
   ...
) : JPanel(BorderLayout()) {
  
   private val contentWrapper = ChessBoardPanel()
  
   var thumbnail: Icon? = null
      set(value) {
         if (field !== value) {
            contentWrapper.removeAll()
            if (value != null) {
               thumbnailLabel.icon = value
               contentWrapper.add(thumbnailLabel)
            }
         }
         field = value
      }
  
   private val thumbnailLabel= JLabel().apply { horizontalAlignment = JLabel.CENTER }
   private val componentNameLabel = JBLabel()
   private val applicableFileTypeLabel = JBLabel()
   private val aliasNameLabel = JBLabel()
   private val typeLabel = JBLabel()
  
   private val bottomPanel = panel {
      customizeSpacingConfiguration(EmptySpacingConfiguration()) {
         row {
            cell(componentNameLabel).resizableColumn()
            // 우측 정렬
            cell(applicableFileTypeLabel).align(AlignX.RIGHT)
         }
         row {
            cell(aliasNameLabel).resizableColumn()
            // 우측 정렬
            cell(typeLabel).align(AlignX.RIGHT)
         }
      }
   }
  
   init {
      add(contentWrapper, BorderLayout.NORTH)
      add(bottomPanel, BorderLayout.SOUTH)
      
      // 컴포넌트 명칭 
      componentNameLabel.text = /** ... */
      // 적용할 파일 타입
      applicableFileTypeLabel.text = /** ... */
      // 별칭명
      aliasNameLabel.text = /** ... */
      // 컴포넌트 타입
      typeLabel.text = /** ... */
   }
}
```

#### 이미지 가져오기

Android Studio에서 파일을 Image로 가져오는 내부 로직은 좀 더 복잡합니다. 좀 더 간단하게 png/jpg만 처리하는 방법도 존재하므로 용도에 맞춰서 사용하시면 됩니다.

**간단한 버전 (png/jpg)**

```kotlin
val bufferedImage = ImageUtils.readImageAtScale(/** java.io.InputStream */, /** java.awt.Dimension */ )
```

> https://cs.android.com/android-studio/platform/tools/adt/idea/+/mirror-goog-studio-main:adt-ui/src/main/java/com/android/tools/adtui/ImageUtils.java;l=495?q=ImageUtils&ss=android-studio

**Android Studio와 동일한 스펙**

Android Studio에서는 이미지 형태로 그리는 용도로 [AssetIconProvider](https://cs.android.com/android-studio/platform/tools/adt/idea/+/mirror-goog-studio-main:android/src/com/android/tools/idea/ui/resourcemanager/rendering/AssetIconProvider.kt) 인터페이스를 사용하는 다양한 구현체 (Color/Font/Image/Layout/Navigation)가 존재합니다. 다양한 타입에 맞춰 이미지 형태로 가져오기 위해서 [AssetPreviewManager/AssetPreviewManagerImpl](https://cs.android.com/android-studio/platform/tools/adt/idea/+/mirror-goog-studio-main:android/src/com/android/tools/idea/ui/resourcemanager/rendering/AssetPreviewManager.kt)를 사용합니다.

다만, 제공하는 API가 Android Studio 용도에 맞춰서 구현되어 있어서, AssetPreviewManager의 코드 수정이 필요합니다. 본 블로그에서는 세부 구현은 생략합니다. 

> 실제로 만든 Plugin에는 Icon만 가져오는 코드 전용으로 수정했으며, 특정 모듈과 무관하게 동작하는 코드로 구현되어 있습니다.

```kotlin
interface DesignAssetPreviewManager {
   fun getPreviewProvider(...): DesignAssetIconProvider
}

interface DesignAssetIconProvider {
    fun getIcon(
        assetToRender: ...,
        width: Int,
        height: Int,
        component: Component,
        refreshCallback: () -> Unit = {},
        shouldBeRendered: () -> Boolean = { true }
    ): Icon
}
```

------

이번 블로그의 내용은 여기까지입니다. 다음 글에서는 실제 데이터를 저장/불러오는 기능을 다뤄보겠습니다.
