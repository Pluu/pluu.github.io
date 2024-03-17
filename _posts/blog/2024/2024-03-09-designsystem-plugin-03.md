---
layout: post
title: "UI Code Snippet용 Plugin 제작기 ~ 3부 : Import"
date: 2024-03-09 22:00:00 +09:00
tag: [Android]
categories:
- blog
- Android
---

<!--more-->

- 0부 : [서론]({{ site.url }}/blog/android/2024/02/04/designsystem-plugin-00/)
- 1부 : [ToolWindow/Configurable]({{ site.url }}/blog/android/2024/02/10/designsystem-plugin-01/)
- 2부 : [ActionButton/JList]({{ site.url }}/blog/android/2024/02/24/designsystem-plugin-02/)
- 3부 : [Import]({{ page.url }}) <- 현재 글
- 4부 : [기타 기능]({{ site.url }}/blog/android/2024/03/17/designsystem-plugin-04/)

------

이전 글에서 JList를 사용해 UI 항목들을 그렸다면, 이번 글에서는 실제 데이터를 가져오는 부분을 만들어 보겠습니다.

- Import Dialog -> ResourceImportDialog

> 일부 상세 구현은 생략되어 있습니다.
>
> 샘플 프로젝트에서는 DesignAssetSet 클래스로 정의하여 asset 관련 정보를 다루고 있습니다.

---

## 구현할 Import Dialog 스펙 정의

UI Code Snippet용 Plugin에 중요한 기능 중 하나인 `신규 내용을 Import`하는 기능입니다. Import시 타입에 맞게 복수 데이터를 입력받아야 하므로 별도 Dialog를 사용합니다. 우리가 만들어 볼 모습은 다음과 같습니다.

{% include img_assets.html id="/blog/2024/designsystem_plugin/12.png" %}

- Import 할 전체 항목 수
- 신규 Import 선택용 **Import more files**버튼
- 각 항목 정보 : 이름, 별칭, 프리뷰 이미지, 파일 정보, Design system type, 코드 타입, 샘플 코드

## 1. Import Dialog 노출 (ResourceImportDialog)

Import Dialog 호출은 [이전 글]({{ site.url }}/blog/android/2024/02/10/designsystem-plugin-02/)에서 소개한 Toolbar 영역의 `+ 버튼`에 연결합니다. 버튼 선택 시 [AnAction#actionPerformed](https://plugins.jetbrains.com/docs/intellij/basic-action-system.html#overriding-the-anactionactionperformed-method) 함수가 호출되므로 Dialog(Import용 ResourceImportDialog)를 노출하면 됩니다.

```kotlin
class AddAction(
   private val viewModel: DesignSystemExplorerToolbarViewModel
) : AnAction(
   "Add item",
   /** ... */ ,
   AllIcons.General.Add
) {
   override fun actionPerformed(e: AnActionEvent) {
      // Add 버튼 선택 시 동작
      ResourceImportDialog(
         project,
         // Import용 ViewModel을 전달
         ResourceImportDialogViewModel(project, /** 초기 노출 리스트 */) {
            // List 갱신용 콜백 호출
            viewModel.populateResourcesCallback()
         }
      ).show()
   }
}
```

ResourceImportDialog에는 Import 처리에 필요한 ViewModel 및 초기값/리스트 갱신 콜백을 전달합니다.

### (1) 기본 코드 작성

Import용 ResourceImportDialog와 처리용 ViewModel의 기본적인 코드를 작성해 봅니다.

```kotlin
class ResourceImportDialog(
   project: Project,
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   ...
   private lateinit var fileCountLabel: JLabel
   private lateinit var content: JPanel

   // Dialog에 노출되는 레이아웃
   private val centerPanel = panel {
      row {
         // Import 할 갯수
         fileCountLabel = label("").component
         // 추가 Import 버튼
         cell(createImportButtonAction()).align(AlignX.RIGHT)
      }
      row {
         content = JPanel(VerticalLayout(0)).apply { ... }
         val centerScroll = JBScrollPane(content).apply { ... }
         cell(centerScroll)
      }
   }
  
   init {
      title = "Import Component"
      ...
   }
  
   override fun createCenterPanel(): JComponent = centerPanel
  
   private fun createImportButtonAction(): JComponent {
      val importAction = object : DumbAwareAction(
         "Import more assets",
         "Import more assets",
         AllIcons.Actions.Upload
      ) {
         override fun actionPerformed(e: AnActionEvent) {
            // TODO: 파일 선택 Dialog 선택 요청
         }
      }
      return ActionButtonWithText(
         importAction,
         importAction.templatePresentation.clone(),,
         "",
         JBUI.size(25)
      )
   }
   ... 
}
```

```kotlin
class ResourceImportDialogViewModel(
   val project: Project,
   assets: Sequence<DesignSystemItem>,
   ...
   private val importDoneCallback: () -> Unit
) {
   ...   
   // Import할 데이터 보관 객체
   private val assetSetsToImport: MutableSet<DesignAssetSet> = assets
        .데이터_정리()
        .toIdentitySet()
  
   val assetSets: Set<DesignAssetSet> get() = assetSetsToImport
   val fileCount: Int get() = assetSets.size
  
   // 데이터 업데이트 콜백
   var updateCallback: () -> Unit = {}
}
```

### (2) 파일 선택 요청

#### Dialog 최초 노출 시

ImportDialog 호출 시 바로 신규 이미지를 선택할 수 있도록 제공하면 `Import more assets` 버튼을 누르는 수고를 덜 수 있습니다. [Window#addWindowListener](https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/events/windowlistener.html)를 사용하여 Window가 활성화 시점인 [windowActivated](https://docs.oracle.com/javase/8/docs/api/java/awt/event/WindowListener.html#windowActivated-java.awt.event.WindowEvent-) 함수를 사용하면 됩니다.

```kotlin
class ResourceImportDialog(
   project: Project,
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   ... 
   init {
      ...
      setupWindowListener()
   }
  
   private fun setupWindowListener() {
      ...
      window.addWindowListener(object : WindowAdapter() {
         override fun windowActivated(e: WindowEvent?) {
            super.windowActivated(e)
            ...
            // 최초 Dialog 활성화 시
            // Asset 데이터가 비어있다면, 파일 선택 Dialog 선택 요청
            dialogViewModel.importMoreAssetIfEmpty { resourceSet ->
               // TODO: 선택한 파일 UI에 추가
            }
         }
         ...
      })
   }
   ... 
}
```

```kotlin
class ResourceImportDialogViewModel(
   val project: Project,
   ...
   private val importersProvider: ImportersProvider = ImportersProvider()
) {
   ...  
   val assetSets: Set<DesignAssetSet> get() = assetSetsToImport
  
   // assetSets 데이터가 비어있다면, 파일 선택 Dialog 선택 요청
   fun importMoreAssetIfEmpty(assetAddedCallback: (DesignAssetSet) -> Unit) {
      if (assetSets.isEmpty()) {
         importMoreAssets(assetAddedCallback)
      }
   }
  
   fun importMoreAssets(assetAddedCallback: (DesignAssetSet) -> Unit) {
      // 복수 파일 선택 가능으로 정의 (importersProvider에서 지정한 타입)
      val supportedFileTypes = importersProvider.supportedFileTypes
      val descriptor = FileChooserDescriptor(true, true, false, false, false, true)
         .withFileFilter { it.extension in supportedFileTypes }
     
      // FileChooser를 사용하여 원하는 파일들을 선택하도록 Dialog 호출
      // FileChooser#chooseFiles는 내부적으로 FileChooserDialog를 사용
      FileChooser.chooseFiles(descriptor, project, null)
         .map { file ->
            DesignAssetSet(...)
         }.forEach {
            assetAddedCallback(it)
         }
   }
}
```

#### Import more assets 버튼 선택 시

"Dialog 최초 노출 시"에도 이미지를 선택할 수 있지만, **Import more assets** 버튼으로도 선택할 수 있습니다. 해당 기능은 이미 만든  ResourceImportDialogViewModel#importMoreAssets 함수를 호출하면 됩니다.

```kotlin
class ResourceImportDialog(
   ...,
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   ...  
   private fun createImportButtonAction(): JComponent {
      val importAction = object : DumbAwareAction(
         "Import more assets",
         "Import more assets",
         AllIcons.Actions.Upload
      ) {
         override fun actionPerformed(e: AnActionEvent) {
            dialogViewModel.importMoreAssets { designAssetSet->
               addAssets(designAssetSet)
            }
         }
      }
      return ...
   }
   ... 
}
```

### (3) 선택된 파일 그리기

앞선 (2)에서 선택한 Asset을 Dialog에 노출할 단계입니다. ResourceImportDialog#addAssets로 전달받은 후 content Panel에 새로운 View를 추가하면 됩니다. 

> DesignAssetSetView는 Asset 데이터가 노출될 View입니다.

```kotlin
class ResourceImportDialog(
   project: Project,
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   // Data 및 View 관리용 객체
   private val assetSetToView = IdentityHashMap<DesignAssetSet, DesignAssetSetView>()
  
   private lateinit var content: JPanel
  
   private fun addAssets(designAssetSet: DesignAssetSet) {
      addDesignAssetSet(designAssetSet)
      ...
   }
   
   private fun addDesignAssetSet(assetSet: DesignAssetSet) {
      val view = DesignAssetSetView(assetSet)
      content.add(view)
      assetSetToView[assetSet] = view
   }
}
```

#### (3-1) Asset Row UI 그리기(DesignAssetSetView)

{% include img_assets.html id="/blog/2024/designsystem_plugin/13.png" %}

위 그림과 같이 Plugin에서는 각 Asset마다 다양한 항목이 있습니다.

- Class name: UI 명칭, 기본 파일명 (필수)
- Alias name: 별칭 (옵션)
- 썸네일 이미지
- 파일명 / 파일 사이즈
- Do not import: 해당 Asset을 목록에서 제거하는 버튼
- Design system Type Combobox (필수)
- 샘플 코드가 적용되는 파일 Type Combobox (필수)
- Sample code : 샘플 코드 TextArea (필수)

대략적인 UI 코드는 아래와 같습니다. UI 노출할 항목이 많을 뿐이지 Row/Column 기준으로 배치한다면 크게 어렵지 않습니다.

> 저는 DesignAssetSet 객체를 이용해서 데이터 업데이트를 대응했습니다. 그러나, 별도 주입 없이 내부적으로 해결하고 최종 Confirm시 DesignAssetSet과 같은 데이터 타입을 만드는 방법도 있습니다.

```kotlin
class ResourceImportDialog(
   ...
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   private inner class DesignAssetSetView(
      private var assetSet: DesignAssetSet
   ) : JPanel(BorderLayout()) {
     
      ///////////////////////////////////////////////////////////////////////////
      // Header Panel
      ///////////////////////////////////////////////////////////////////////////

      private val assetNameField = JBTextField(assetSet.name).apply {
         document.addDocumentListener(object : DocumentAdapter() {
            override fun textChanged(e: DocumentEvent) {
               // TBD: 텍스트 업데이트
               ...
            }
         })
         ...
      }

      private val assetAliasNameField = JBTextField(assetSet.asset.aliasName).apply {
         document.addDocumentListener(object : DocumentAdapter() {
            override fun textChanged(e: DocumentEvent) {
               // TBD: 텍스트 업데이트
               ...
            }
         })
      }

      private val header = panel {
         row {
            cell(assetNameField).label("Class name:")
         }
         row {
            cell(assetAliasNameField).label("Alias name:")
         }
      }
     
      ///////////////////////////////////////////////////////////////////////////
      // Middle Panel
      ///////////////////////////////////////////////////////////////////////////

      private val preview = JBLabel().apply { ... }

      private val previewWrapper = ChessBoardPanel().apply {
         ...
         add(preview)
      }

      private val sampleCodeTextArea = JTextArea(assetSet.asset.sampleCode).apply {
         ...
         document.addDocumentListener(object : DocumentAdapter() {
            override fun textChanged(event: DocumentEvent) {
               // TBD: 텍스트 업데이트
               ...
            }
         })
      }

      private val configurationPanel = panel {
         row("Design system Type:") {
            comboBox(
               ConfigSettings.getInstance().getTypes(),
               SimpleListCellRenderer.create("") { it.name }
            ).applyToComponent {
               selectedItem = null
            }.whenItemSelectedFromUi {
               // TBD: ComboBox Item 업데이트
               ...
            }
         }
         row {
            label("Sample code:")
            comboBox(
               ApplicableFileType.selectableTypes().toList(),
               SimpleListCellRenderer.create("") { it.name }
            ).label("Applicable file:")
               .applyToComponent {
                  selectedItem = null
               }.whenItemSelectedFromUi {
                  // TBD: ComboBox Item 업데이트
                  ...
               }
         }
         row {
            cell(JBScrollPane(sampleCodeTextArea)).align(Align.FILL)
         }
      }

      private val middlePane = panel {
         row {
            panel {
               row {
                  label(assetSet.asset.name)
                  label(StringUtil.formatFileSize(assetSet.asset.file?.length ?: 0))
               }
            }
            link("Do not import") {
               removeAsset()
            }.align(AlignX.RIGHT)
         }
         row {
            cell(configurationPanel).align(Align.FILL)
         }
      }

      init {
         add(header, BorderLayout.NORTH)
         add(panel {
            row {
               cell(previewWrapper).align(AlignY.TOP)
               cell(middlePane).align(Align.FILL)
            }
         })

         // Asset 이미지 로드 요청
         dialogViewModel.getAssetPreview(assetSet.asset).whenComplete { image, _ ->
            image?.let {
               // Preview Label의 Icon 영역에 적용
               preview.icon = ImageIcon(it)
               preview.repaint()
            }
         }
      }
      ...
      // Asset Row 제거
      private fun removeAsset() {
         dialogViewModel.removeAsset(this.assetSet)
         assetSetToView.remove(this.assetSet, this)
         parent.remove(this)
         content.revalidate()
         content.repaint()
         updateOkButton()
      }
   }
}
```

```kotlin
class ResourceImportDialogViewModel(
   ...
) {  
   fun getAssetPreview(asset: DesignSystemItem): CompletableFuture<out Image?> {
      return asset.file?.let { file ->
         // 비동기로 이미지 불러오기
         CompletableFuture.supplyAsync {
            try {
               ImageUtils.readImageAtScale(file.inputStream, JBUI.size(/** 이미지 사이즈 */))
            } catch (e: NullPointerException) {
               null
            }
         }
      } ?: CompletableFuture.completedFuture(null)
   }
}
```

## 2. Asset 저장 (DesignAssetImporter/DesignSystemManager)

이제 Import하려는 데이터를 저장할 차례입니다. 데이터를 저장하는 시점은 Dialog의 OK 버튼을 누를 때입니다. OK 버튼 처리는 [DialogWrapper#doOKAction](https://github.com/JetBrains/intellij-community/blob/master/platform/platform-api/src/com/intellij/openapi/ui/DialogWrapper.java#L1047-L1057) 함수를 오버라이드해서 로직을 작성하면 됩니다. 샘플에서는 여러 단계를 걸쳐서 데이터를 저장합니다.

1. ResourceImportDialog#doOKAction
2. ResourceImportDialogViewModel#commit
3. DesignAssetImporter#importDesignAssets
4. DesignSystemManager#saveSample

> 총 4단계 중 1~3단계는 Import 스펙에 맞춰져 있다면, 4단계는 순수 데이터만 관리한다는 관점으로 분리되어 있습니다.

```kotlin
class ResourceImportDialog(
   ...,
   private val dialogViewModel: ResourceImportDialogViewModel
) : DialogWrapper(project) {
   ...  
   override fun doOKAction() {
      super.doOKAction()
      // OK버튼 선택 시 처리 호출
      dialogViewModel.commit()
   }
   ... 
}
```

```kotlin
class ResourceImportDialogViewModel(
   val project: Project,
   ...,
   private val designAssetImporter: DesignAssetImporter = DesignAssetImporter(),
   private val importDoneCallback: () -> Unit
) {
   ...
   // Import할 DataSet
   private val assetSetsToImport: MutableSet<DesignAssetSet> = ...
  
   fun commit() {
      // 데이터 저장 처리 요청
      designAssetImporter.importDesignAssets(
         assetSetsToImport,
         project,
         ...
      )
      // 저장 후 Callback 호출.
      // 실제 콜백의 호출은 리스트 갱신입니다.
      importDoneCallback()
   }
}
```

### 2-1. DesignAssetImporter

Dialog/ViewModel의 로직은 단순한 편입니다. DesignAssetImporter부터가 핵심 코드입니다. 

이미지 복사/저장에는 아래의 처리가 필요합니다.

1. 데이터 저장위치
2. 폴더 경로 취득 및 생성
3. 실제 파일 복사

```kotlin
class DesignAssetImporter {
   fun importDesignAssets(
      assetSets: Set<DesignAssetSet>,
      project: Project
   ) {
      if (assetSets.isEmpty()) return

      val sampleRoot: VirtualFile = /** 저장할 폴더 최상위 위치 */
      LocalFileSystem.getInstance().refreshIoFiles(listOf(sampleRoot.toIoFile()))

      // 동일 타입 기준으로 그룹핑
      val groupedAssets = assetSets.groupBy { it.asset.type }
     
      // 파일 쓰기 요청
      WriteCommandAction.runWriteCommandAction(project, "Write Samples", null, {
         groupedAssets.forEach { (designSystemType, items) ->
            // 이미지 복사 요청
            copyAssetsInFolder(designSystemType, items, sampleRoot)
            // 샘플 코드 저장
            DesignSystemManager.saveSample(project, designSystemType, items)
         }
      })
   }
  
   // 이미지 복사 요청
   private fun copyAssetsInFolder(
      type: DesignSystemType,
      importingAsset: List<DesignAssetSet>,
      rootSample: VirtualFile
   ) {
      // Folder 경로를 가져온다.
      // 만약, Folder가 존재하지 않는다면 생성 후 가져온다.
      val folder = VfsUtil.createDirectoryIfMissing(rootSample, type.sampleDirName)
      importingAsset.forEach {
         val file = it.asset.file ?: return@forEach
         file.copy(this, folder, it.asset.fileNameWithExtension)
      }
   }
}
```

```kotlin
object DesignSystemManager {
   fun saveSample(project: Project, type: DesignSystemType, items: List<DesignAssetSet>): Boolean {
      // TODO: 샘플 코드 관련 데이터 저장
      return true
   }
}
```

파일을 아래와 같이 저장됩니다.

```bash
Root
ㄴ sample.json <-- 다음 섹션에서 설명
ㄴ button
   ㄴ test_pluu_name.png
ㄴ input
   ㄴ sample_input.png
```

### 2-2. 샘플 코드 저장

메인 데이터를 저장할 차례입니다.

{% include img_assets.html id="/blog/2024/designsystem_plugin/14.png" %}

앞서 언급했지만, 각 항목에 사용된 정보가 저장됩니다.

- UI 명칭
- 별칭
- 썸네일 이미지 파일명
- Design system Type
- 샘플 코드가 적용되는 파일 Type
- 샘플 코드 TextArea

데이터는 같은 타입에 복수개 존재하며, 샘플 코드는 멀티라인이 필수입니다. 이런 저장 조건을 충족하는 여러 방법이 있겠지만, 관리하기 쉬운 JSON을 선택했습니다. 위 이미지 샘플을 저장하면 최종적으로 json에는 아래와 같이 저장됩니다.

```json
{
  "input": [
    {
      "id": "test_pluu_name",
      "thumbnail": "test_pluu_name.png",
      "alias": "test_alias",
      "applicableFileType": "XML",
      "code": "\u003cFrameLayout\n   android:layout_width\u003d\"match_parent\"\n   android:layout_height\u003d\"wrap_content\" /\u003e "
    }
  ]
}
```

타입마다 저장되는 형태는 아래와 같습니다.

```json
{
   "타입1": [샘플1, 샘플2],
   "타입2": [샘플3]
}
```

#### DesignSystemManager

구현은 Json 입력/출력에 Gson을 사용했습니다.

```kotlin
import com.google.gson.GsonBuilder
import com.google.gson.JsonArray
import com.google.gson.JsonObject

// DesignSystem 데이터 관리 담당 manager 클래스
object DesignSystemManager {
   fun saveSample(project: Project, type: DesignSystemType, items: List<DesignAssetSet>) {
      edit(project) { jsonObject ->
         // Json에서 type 키로 취득 후 데이터 추가
         val j = jsonObject.getAsJsonArray(/** 디자인 시스템 타입 키 */) ?: JsonArray().also {
            jsonObject.add(/** 디자인 시스템 타입 키 */, it)
         }
         items.forEach { assetSet ->
            j.add(assetSet.asJson())
         }
      }
   }
  
   private fun edit(project: Project, action: (JsonObject) -> Unit) {
      val jsonObject: JsonObject = /** 기존 저장된 Json 데이터 읽어오기 */
      action(jsonObject)

      val gson: Gson = /** Gson 객체 생성 */

      WriteCommandAction.runWriteCommandAction(project, "Write Json", null, {
         val sampleRootDirectory: VirtualFile = /** Asset 데이터 Root 경로 가져오기 */
         sampleRootDirectory.findChild(/** Json 파일명 */)?.let {
            Files.newBufferedWriter(it.toNioPath(), Charsets.UTF_8).use { writer ->
               // Gson 데이터를 파일로 저장
               gson.toJson(jsonObject, writer)
            }
         }
      })
   }
}
```

## 3. 데이터 불러오기

이제 저장한 데이터를 리스트에 불러올 단계입니다. DesignSystemManager 클래스에 타입에 맞는 항목들을 가져오는 코드를 추가합니다.

### 데이터 불러오기 

```kotlin
object DesignSystemManager {
   fun getModuleResources(
      project: Project,
      type: DesignSystemType?
   ): List<DesignSystemItem> {
      val types:List<DesignSystemType> = if (type != null) {
         /** 단일 타입 */
         listOf(type)
      } else {
         /** 디자인 시스템 전체 타입 */
      }
      return findDesignKit(project, types)
   }
  
   // 전달된 Type에 매칭되는 Item들 가져오기
   fun findDesignKit(project: Project, types: List<DesignSystemType>): List<DesignSystemItem> {
      val rootPath: VirtualFile = /** Asset 데이터 Root 경로 가져오기 */ ?: return emptyList()
      ...
      // 샘플 Json 정보 가져오기
      val jsonObject = loadJsonFromSampleFile(project)

      return types.flatMap { type ->
         jsonObject.getAsJsonArray(/** 디자인 시스템 타입 키 */)
            ?.map { it.asJsonObject }
            .orEmpty()
            .map {
               it.asDesignSystemItem(rootPath, type)
            }
      }
   }
  
   // 샘플 Json 정보 가져오기
   private fun loadJsonFromSampleFile(project: Project): JsonObject {
      val rootPath: VirtualFile = /** Asset 데이터 Root 경로 가져오기 */
      ...
      return rootPath.findChild(/** Json 파일명 */)
         ?.let {
            JsonParser.parseReader(it.inputStream.reader(Charsets.UTF_8)) as? JsonObject
         } ?: run {
           // Empty JsonObject
           JsonObject()
         }
   }
  
   // JsonObject로 DesignSystemItem 객체 생성
   private fun JsonObject.asDesignSystemItem(
      rootPath: VirtualFile, 
      type: DesignSystemType
   ): DesignSystemItem {
      return DesignSystemItem(
         type = type,
         name = get("id").asString,
         file = rootPath.findChild(/** 디자인 시스템 타입 키 */)?.findChild(get("thumbnail").asString),
         aliasName = get("alias").asString,
         applicableFileType = ApplicableFileType.of(get("applicableFileType").asString),
         sampleCode = get("code").asString
      )
   }
}
```

### 리스트 불러오기 및 갱신

이제 마지막 단계입니다. 이전 2부의 [DesignSystemExplorerListView(JList)]({{ site.url }}/blog/android/2024/02/10/designsystem-plugin-02/)에 데이터를 연동하는 부분입니다. 결과를 노출하는 DesignSystemExplorerListView에서 **DesignSystemExplorerListViewModel#getDesignAssetSets**에 데이터를 요청하고, 결과를 [DefaultListModel](https://docs.oracle.com/javase/8/docs/api/javax/swing/DefaultListModel.html)에 반영하면 됩니다.

```kotlin
class DesignSystemExplorerListView(
   private val viewModel: DesignSystemExplorerListViewModel
) : JBList(BorderLayout()) {
   private var populateResourcesFuture: CompletableFuture<List<DesignAssetSet>>? = null
   private val listModel = DefaultListModel<DesignAssetSet>()
   ...
   init {
      ...
      model = listModel
     
      viewModel.updateUiCallback = { reason ->
         when (reason) {
            ...
            UpdateUiReason.DESIGN_SYSTEM_CHANGED -> {
               // ResourceImportDialogViewModel 생성자로 전달되는 importDoneCallback 호출시
               // 리스트가 갱신되도록 처리합니다.
               populateResourcesLists(...)
            }
         }
      }
      populateResourcesLists()
   }
  
   private fun populateResourcesLists(...) {
      ...
      // 기존 요청 취소 처리
      populateResourcesFuture?.cancel(true)
      // 현재 선택된 타입 기준으로 샘플 데이터 가져오기
      populateResourcesFuture = viewModel.getDesignAssetSets()
         .whenCompleteAsync({ list, _ ->
            ...
            displayResources(list)
         }, EdtExecutorService.getInstance())
      ...
   }
  
   private fun displayResources(resourceLists: List<DesignAssetSet>) {
      listModel.clear()
      listModel.addAll(resourceLists)
   }
}
```

ViewModel에서는 앞서 언급한 `DesignSystemManager.getModuleResources`를 사용해서 데이터를 가져오면 됩니다.

```kotlin
class DesignSystemExplorerListViewModel(
   val project: Project,
   initialDesignSystemTab: DesignSystemTab,
   ...
) {
  
   var updateUiCallback: ((UpdateUiReason) -> Unit)? = null
  
   var currentTab: DesignSystemTab by Delegates.observable(initialDesignSystemTab) { _, oldValue, newValue ->
      if (newValue != oldValue) {
         // Tab 변경 시 처리
      }
   }
  
   // 비동기 데이터 요청
   fun getDesignAssetSets() = explorerSupplyAsync {
      getDesignAssetSets(project)
   }

   private fun getDesignAssetSets(project: Project): List<DesignAssetSet> {
      val designSystemType = currentTab.filterType
      // 현재 선택된 타입 기준으로 데이터를 가져오기
      return DesignSystemManager.getModuleResources(project, designSystemType)
         .sortedBy { it.name }
         .map {
            DesignAssetSet(it.name, it)
         }
   }
}

private fun <T> explorerSupplyAsync(runnable: () -> T): CompletableFuture<T> =
   supplyAsync({
      runnable()
   }, AppExecutorUtil.getAppExecutorService())
```

여기까지 진행하면 Import한 데이터가 노출됩니다.

{% include img_assets.html id="/blog/2024/designsystem_plugin/10.png" %}

------

이번 블로그의 내용은 여기까지입니다. 다음 글에서는 마지막 기타 기능을 다뤄보겠습니다.
