---
layout: post
title: "UI Code Snippet용 Plugin 제작기 ~ 4부 : Drag, Copy, Paste"
date: 2024-03-17 22:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

- 0부 : [서론]({{ site.url }}/blog/android/2024/02/04/designsystem-plugin-00/)
- 1부 : [ToolWindow/Configurable]({{ site.url }}/blog/android/2024/02/10/designsystem-plugin-01/)
- 2부 : [ActionButton/JList]({{ site.url }}/blog/android/2024/02/24/designsystem-plugin-02/)
- 3부 : [Import]({{ site.url }}/blog/android/2024/03/09/designsystem-plugin-03/)
- 4부 : [기타 기능]({{ page.url }}) <- 현재 글

------

본 글에서는 Plugin의 서브 기능 일부를 만들어 보겠습니다.

- Drag & Drop
- Sample Code copy

> 일부 상세 구현은 생략되어 있습니다.

------

## Drag & Drop

먼저 우리가 구현할 동작부터 살펴보겠습니다.

{% include youtube.html id="3cJo1fijn6A" %}

위 영상에는 주요 기능 2가지가 있습니다.

- Drag시 Preview 이미지 노출
- 샘플 코드 붙여 넣기

### (1) Drag시 Preview 이미지 노출

리스트에 있는 Cell을 Drag하면 노출하는 정보를 유사하게 Preview로 보여주고 있습니다. 이것도 구현해야 하는 기능입니다.

{% include img_assets.html id="/blog/2024/designsystem_plugin/15.png" %}

### ResourceDragHandler

#### Drag 기능 활성화

JList에 Drag&Drop 관련 기능을 활성화하고, 데이터 전달용 객체도 적용합니다.

```kotlin
class DesignSystemExplorerListView(
   ...
) : JBList<DesignAssetSet>() {  
   init {
      // Drag&Drop 기능 활성화
      dragEnabled = true
      dropMode = DropMode.ON
      // Drag&Drop시 데이터 전달 객체 적용
      transferHandler = ResourceFilesTransferHandler(this)
   }
}
```

#### 데이터 전달 객체 생성 및 Preview 이미지 노출

Drag&Drop 작업에서 필요한 것은 `데이터 전달`입니다. 해당 처리를 Swing에서는 [TransferHandler](https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/dnd/transferhandler.html)가 담당합니다. 기본 데이터 전송 Handler가 있지만, Plugin에 맞게 커스텀합니다.

그리고, Preview 이미지 노출에 [TransferHandler#getDragImage](https://docs.oracle.com/javase/8/docs/api/javax/swing/TransferHandler.html#getDragImage--) 함수가 사용됩니다.

> - TransferHandler Class : https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/dnd/transferhandler.html
> - Drag and Drop and Data Transfer : https://docs.oracle.com/javase/tutorial/uiswing/dnd/index.html

```kotlin
class ResourceFilesTransferHandler(
   private val assetList: JList<DesignAssetSet>
) : TransferHandler() {
   override fun getSourceActions(c: JComponent?) = COPY_OR_MOVE
  
   override fun getDragImage() = createDragPreview(assetList)
  
   override fun createTransferable(c: JComponent?): Transferable {
        c?.cursor = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR)
        return createCopyTransferable(assetList.selectedValue.asset)
   }
}

@JvmField
val DESIGN_SYSTEM_URL_FLAVOR = DataFlavor(DesignSystemItem::class.java, "DesignSystem File Url")

private val SUPPORTED_DATA_FLAVORS = arrayOf(DESIGN_SYSTEM_URL_FLAVOR, DataFlavor.stringFlavor)

fun createCopyTransferable(asset: DesignSystemItem): Transferable {
   return object : Transferable {
      // 데이터 전달할 타입을 정의
      // - DesignSystemItem
      // - String
      override fun getTransferData(flavor: DataFlavor?): Any {
         return when (flavor) {
            DESIGN_SYSTEM_URL_FLAVOR -> asset
            DataFlavor.stringFlavor -> asset.toString()
            else -> UnsupportedFlavorException(flavor)
         }
      }

      override fun isDataFlavorSupported(flavor: DataFlavor?): Boolean = flavor in SUPPORTED_DATA_FLAVORS

      override fun getTransferDataFlavors(): Array<DataFlavor> = SUPPORTED_DATA_FLAVORS
   }
}
```

Preview로 노출할 이미지도 JList의 Cell이 렌더링한대로 하기 위해서 JList의 [cellRenderer](https://docs.oracle.com/javase%2F7%2Fdocs%2Fapi%2F%2F/javax/swing/ListCellRenderer.html)를 사용합니다.

```kotlin
fun createDragPreview(draggedAssets: JList<DesignAssetSet>): BufferedImage {
   // CellRenderer를 사용해 Component 요청
   val component = draggedAssets.cellRenderer.getListCellRendererComponent(
      draggedAssets,
      draggedAssets.selectedValue, // Preview로 노출할 아이템
      draggedAssets.selectedIndex,
      false,
      false
   )

   // Drag시 Preview 크기 : JList의 넓이 x Component의 높이
   component.setSize(draggedAssets.preferredSize.width, component.preferredSize.height)
   component.validate()
   
   // 노출할 BufferedImage 생성 후 랜더링
   val image = BufferedImage(draggedAssets.width, component.height, BufferedImage.TYPE_INT_ARGB)
   with(image.createGraphics()) {
      color = draggedAssets.background
      fillRect(0, 0, draggedAssets.width, component.height)
      component.paint(this)
      dispose()
   }
   return image
}
```

### (2) 특정 코드 붙여 넣기

#### customPasteProvider 선언 추가

다음은 샘플 코드 붙여 넣기입니다. `DesignSystemItem` 클래스의 **sampleCode** 프로퍼티를 코드에 붙여 넣기 해야 하므로 커스텀이 필요합니다. 먼저 [plugin.xml](https://plugins.jetbrains.com/docs/intellij/plugin-configuration-file.html) 구성 파일에 customPasteProvider를 추가합니다.

```xml
<idea-plugin>
   <extensions defaultExtensionNs="com.intellij">
      <customPasteProvider implementation="com.pluu.plugin.toolWindow.designsystem.model.ResourcePasteProvider"/>
   </extensions>
</idea-plugin>
```

#### ResourcePasteProvider 구현

이어서 [PasteProvider](https://github.com/JetBrains/intellij-community/blob/idea/233.14808.21/platform/platform-api/src/com/intellij/ide/PasteProvider.java) 인터페이스를 사용하여 붙여 넣기 동작을 구현합니다.

- isPasteEnabled/isPastePossible : 붙여 넣기 가능 여부
- performPaste : 붙여 넣기 시도

```kotlin
class ResourcePasteProvider : PasteProvider {
   // 붙여 넣기 지원여부
   override fun isPasteEnabled(dataContext: DataContext): Boolean {
      return isPastePossible(dataContext)
   }
  
   // 붙여 넣기 지원여부
   override fun isPastePossible(dataContext: DataContext): Boolean {
      return getTransferable(dataContext)
         ?.isDataFlavorSupported(DESIGN_SYSTEM_URL_FLAVOR) ?: false
   } 
    
   override fun performPaste(dataContext: DataContext) {
      val caret = CommonDataKeys.CARET.getData(dataContext) ?: return
      // 붙여 넣기 하려는 곳의 파일 정보 취득
      val psiFile: PsiFile = CommonDataKeys.PSI_FILE.getData(dataContext) ?: return
      if (isPastePossible(psiFile)) {
         // 지원하는 파일인 경우, 붙여 넣기 시도
         performForCode(dataContext, psiFile.fileType, caret)
      }
   }
  
   // 파일 기준으로 붙여 넣기 지원 여부 판단
   private fun isPastePossible(psiFile: PsiFile): Boolean {
      return when (psiFile.fileType) {
         XmlFileType.INSTANCE,
         KotlinFileType.INSTANCE -> true
         else -> false
      }
   }

   private fun performForCode(
      dataContext: DataContext,
      fileType: FileType,
      caret: Caret
   ) {
      val item = getDesignSystemItem(dataContext) ?: return
      // DesignSystemItem 개별 항목이 지원하는 파일 타입인지 체크
      if (!isPastSupport(fileType, item.applicableFileType)) return
      // 샘플 코드 붙여 넣기
      val sampleCode = item.sampleCode?.takeIf { it.isNotEmpty() } ?: return
      pasteAtCaret(caret, sampleCode)
   }

   // 붙여 넣기 하려는 데이터 취득
   private fun getDesignSystemItem(dataContext: DataContext): DesignSystemItem? {
      return getTransferable(dataContext)
         ?.getTransferData(DESIGN_SYSTEM_URL_FLAVOR) as? DesignSystemItem
   }

   // 샘플 코드 붙여 넣기
   private fun pasteAtCaret(caret: Caret, text: String) {
      runWriteAction {
         caret.editor.document.insertString(caret.offset, text)
      }
      caret.selectStringFromOffset(text, caret.offset)
   }

   private fun getTransferable(dataContext: DataContext): Transferable? {
      return PasteAction.TRANSFERABLE_PROVIDER.getData(dataContext)?.produce()
   }

   // DesignSystemItem 개별 항목이 지원하는 파일 타입인지 체크
   private fun isPastSupport(sourceFileType: FileType, sampleCodeType: ApplicableFileType): Boolean {
      return when (sampleCodeType) {
         ApplicableFileType.XML -> sourceFileType == XmlFileType.INSTANCE
         ApplicableFileType.KOTLIN -> sourceFileType == KotlinFileType.INSTANCE
         else -> false
      }
   }
  
   override fun getActionUpdateThread(): ActionUpdateThread = ActionUpdateThread.BGT
}

private fun Caret.selectStringFromOffset(resourceReference: String, offset: Int) {
    setSelection(offset, offset + resourceReference.length)
    moveToOffset(offset + resourceReference.length)
}
```

## Copy & Paste

마지막으로 팝업 Action과 키보드 단축키로 샘플 코드 복사하기입니다. 마우스 우클릭 시 Copy 팝업 노출과 단축키 기능을 구현해 보겠습니다.

{% include youtube.html id="PYMasrwaJRo" %}

Copy 기능은 지난번에 작성한 리스트인 DesignSystemExplorerListView에 DataProvider/CopyProvider 인터페이스 사용해 구현합니다.

```kotlin
// DataKey를 사용하여 DesignSystemItem들을 전달하는 용도
val RESOURCE_DESIGN_ASSETS_KEY = DataKey.create<List<DesignSystemItem>>("DesignSystem Assets Key")

class DesignSystemExplorerListView(
   ...
) : JBList<DesignAssetSet>(), DataProvider, CopyProvider {
   private val popupHandler = object : PopupHandler() {
      val actionManager = ActionManager.getInstance()

      // Popup용 ActionGroup 정의
      // - Add, Sample Code Copy Action
      val actionGroup = DefaultActionGroup(CopyComponentAction())

      override fun invokePopup(comp: Component, x: Int, y: Int) {
         val list = comp as JList<*>
         ...
         val popupMenu = actionManager.createActionPopupMenu("ResourceExplorer", actionGroup)
         popupMenu.setTargetComponent(list)
         val menu = popupMenu.component
         menu.show(comp, x, y)
      }
   }
  
   init {
      ...
      // Add PopupHandler
      addMouseListener(popupHandler)
      ...
   }
  
   override fun getData(dataId: String): Any? {
      return when (dataId) {
         // 데이터 전송 요청이 온 경우, 선택된 아이템 리스트를 전달
         RESOURCE_DESIGN_ASSETS_KEY.name -> {
            selectedValuesList.map { it.asset }
         }
         // 단축키 지원으로 CopyProvider 대응
         PlatformDataKeys.COPY_PROVIDER.name -> this
         else -> null
      }
   }
  
   override fun performCopy(dataContext: DataContext) {
      // 단축키로 복사 요청 시,
      // 샘플 코드를 클립보드에 복사
      val item = dataContext.getData(RESOURCE_DESIGN_ASSETS_KEY)?.firstOrNull() ?: return
      CopyPasteManager.getInstance().setContents(StringSelection(item.sampleCode))
   }
  
   // 선택한 항목이 존재하는 경우에만 복사하기 활성화
   override fun isCopyVisible(dataContext: DataContext): Boolean = isCopyEnabled(dataContext)

   override fun isCopyEnabled(dataContext: DataContext): Boolean = selectedValuesList.isNotEmpty()

   // Copy Action
   class CopyComponentAction : AnAction() {
      init {
         ActionUtil.copyFrom(this, IdeActions.ACTION_COPY)
      }

      override fun actionPerformed(dataContext: AnActionEvent) {
         val item = dataContext.getData(RESOURCE_DESIGN_ASSETS_KEY)?.firstOrNull() ?: return
         // Copy Action으로 복사 요청 시,
         // 샘플 코드를 클립보드에 복사
         CopyPasteManager.getInstance().setContents(StringSelection(item.sampleCode))
      }

      override fun getActionUpdateThread(): ActionUpdateThread = ActionUpdateThread.EDT
   }
}
```

[CopyProvider](https://github.com/JetBrains/intellij-community/blob/master/platform/platform-api/src/com/intellij/ide/CopyProvider.java) 동작 이해가 다소 어렵지만, 클립보드에 데이터 복사는 크게 어렵지 않습니다.

RESOURCE_DESIGN_ASSETS_KEY는 복수 DesignSystemItem를 받을 수 있도록 [DataKey](https://github.com/JetBrains/intellij-community/blob/master/platform/core-ui/src/openapi/actionSystem/DataKey.java)를 정의하며, DataProvider#getData로 요청이 오면 선택된 데이터를 리턴합니다. 이후에는 DataKey로 데이터 접근이 가능한 곳에서 사용하면 됩니다.

> DataKey는 AnActionEvent#getData(DataKey) / DataProvider#getData(String)에 사용됩니다.

------

Plugin 관련 글은 여기까지입니다.

긴 글을 읽어주셔서 감사합니다.
