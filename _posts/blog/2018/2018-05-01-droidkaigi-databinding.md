---
layout: post
title: "[번역] DroidKaigi 2018 ~ DataBinding 코드 읽기"
date: 2018-05-01 21:00:00 +09:00
tag: [Android, DroidKaigi]
categories:
- blog
- Android
- DroidKaigi
---

본 포스팅은 [DroidKaigi 2018 ~ DataBindingのコードを読む](https://speakerdeck.com/star_zero/databindingfalsekodowodu-mu-droidkaigi-2018) 을 기본으로 번역하여 작성했습니다

제 일본어 실력으로 인하여 오역이나 오타가 발생할 수 있습니다.

<!--more-->

- - -

## 1p

DataBinding 코드 읽기

## 2p, About me

- Kenji Abe
- Android/iOS Developer
- Twitter: STAR_ZERO
- GitHub: STAR-ZERO

## 3p, Contribute 했습니다

- [https://android.googlesource.com/platform/frameworks/databinding/+log/studio-master-dev](https://android.googlesource.com/platform/frameworks/databinding/+log/studio-master-dev)

## 4p, 이야기할 내용

- DataBinding 코드에서 구조를 해설
- Gradle Plugin
- Annotation Processor
- 코드 생성 및 실행

※ Android Gradle Plugin 3.0을 대상으로 합니다

## 5p, DataBinding 코드 검색 및 디버깅

- 블로그에 정리해 두었습니다
- [https://goo.gl/o68Ekt](https://goo.gl/o68Ekt)

## 6p

Gradle Plugin

## 7p, Gradle Plugin

- [https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0](https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0)
   - build-system/gradle
   - build-system/gradle-api
   - build-system/gradle-core

## 8p, Gradle Plugin

- 의존 라이브러리 추가
- Task 추가
- 레이아웃 파일 분석

## 9p, Gradle Plugin

- `의존 라이브러리 추가`
- Task 추가
- 레이아웃 파일 분석

## 10p, 의존 라이브러리 추가

- com.android.databinding:library
- com.android.databinding:baseLibrary
- com.android.databinding:adapters
- com.android.databinding:compiler

## 11p, com.android.databinding:library

- DataBindingUtil
- BaseObservable
- ObservableField

[https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/library/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/library/)

## 12p, com.android.databinding:baseLibrary

- @Bindable
- @BindingAdapter
- @InverseBindingAdapter

[https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/baseLibrary/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/baseLibrary/)

## 13p, com.android.databinding:adapters

- ViewBindingAdapter
- TextViewBindingAdapter
- CompoundButtonBindingAdapter

[https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/)

## 14p, com.android.databinding:compiler

- Annotation Processor
- 코드 생성

[https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/)

## 15p, 의존 라이브러리 추가

- [https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0/build-system/gradlecore/src/main/java/com/android/build/gradle/internal/TaskManager.java](https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0/build-system/gradlecore/src/main/java/com/android/build/gradle/internal/TaskManager.java)

```java
public abstract class TaskManager {
    // ...
    public void addDataBindingDependenciesIfNecessary(DataBindingOptions options) {
        if (!options.isEnabled()) {
            return;
        }
        String version = MoreObjects.firstNonNull(options.getVersion(),
                dataBindingBuilder.getCompilerVersion());
        project.getDependencies()
                .add(
                        "api",
                        SdkConstants.DATA_BINDING_LIB_ARTIFACT
                                + ":"
                                + dataBindingBuilder.getLibraryVersion(version));
        project.getDependencies()
                .add(
                        "api",
                        SdkConstants.DATA_BINDING_BASELIB_ARTIFACT
                                + ":"
                                + dataBindingBuilder.getBaseLibraryVersion(version));
        // TODO load config name from source sets
        project.getDependencies()
                .add(
                        "annotationProcessor",
                        SdkConstants.DATA_BINDING_ANNOTATION_PROCESSOR_ARTIFACT + ":" + version);
        if (options.isEnabledForTests() || this instanceof LibraryTaskManager) {
            project.getDependencies().add("androidTestAnnotationProcessor",
                    SdkConstants.DATA_BINDING_ANNOTATION_PROCESSOR_ARTIFACT + ":" +
                            version);
        }
        if (options.getAddDefaultAdapters()) {
            project.getDependencies()
                    .add(
                            "api",
                            SdkConstants.DATA_BINDING_ADAPTER_LIB_ARTIFACT
                                    + ":"
                                    + dataBindingBuilder.getBaseAdaptersVersion(version));
        }
    }
```

## 16p, Gradle Plugin

- 의존 라이브러리 추가
- `Task 추가`
- 레이아웃 파일 분석

## 17p, Task 추가

- dataBindingExportBuildInfo TASK가 추가
- DataBindingInfo.java를 생성한다

## 18p, DataBindingInfo

```java
@BindingBuildInfo(buildId="8c129f13-798b-4137-8327-f76a34f6a51f")
public class DataBindingInfo {}
```

- 비어있는 클래스
- @BindingBuildInfo가 Annotation Processor에서 처리된다

## 19p, Task 추가

- [https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0/build-system/gradlecore/src/main/java/com/android/build/gradle/internal/TaskManager.java](https://android.googlesource.com/platform/tools/base/+/gradle_3.0.0/build-system/gradlecore/src/main/java/com/android/build/gradle/internal/TaskManager.java)

```java
public abstract class TaskManager {
   // ...
   protected void createDataBindingTasksIfNecessary(@NonNull TaskFactory tasks, @NonNull VariantScope scope) {
      if (!extension.getDataBinding().isEnabled()) {
         return;
      }
      VariantType type = scope.getVariantData().getType();
      boolean isTest = type == VariantType.ANDROID_TEST || type == VariantType.UNIT_TEST;
      if (isTest && !extension.getDataBinding().isEnabledForTests()) {
         BaseVariantData testedVariantData = scope.getTestedVariantData();
         if (testedVariantData.getType() != LIBRARY) {
            return;
         }
      }

      dataBindingBuilder.setDebugLogEnabled(getLogger().isDebugEnabled());

      AndroidTask<DataBindingExportBuildInfoTask> exportBuildInfo = androidTasks
            .create(tasks, new DataBindingExportBuildInfoTask.ConfigAction(scope));

      exportBuildInfo.dependsOn(tasks, scope.getMergeResourcesTask());
      exportBuildInfo.dependsOn(tasks, scope.getSourceGenTask());

      scope.setDataBindingExportBuildInfoTask(exportBuildInfo);
   }
}
```

## 20p, Task 추가

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/LayoutXmlProcessor.java](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/LayoutXmlProcessor.java)

```java
public class LayoutXmlProcessor {
    // ...
    public void writeEmptyInfoClass() {
        final Class annotation = BindingBuildInfo.class;
        String classString = "package " + RESOURCE_BUNDLE_PACKAGE + ";\n\n" +
                 "import " + annotation.getCanonicalName() + ";\n\n" +
                 "@" + annotation.getSimpleName() + "(buildId=\"" + mBuildId + "\")\n" +
                 "public class " + CLASS_NAME + " {}\n";
        mFileWriter.writeToFile(RESOURCE_BUNDLE_PACKAGE + "." + CLASS_NAME, classString);
    }
}
```

## 21p, Gradle Plugin

- 의존 라이브러리 추가
- Task 추가
- `레이아웃 파일 분석`

## 22p, 레이아웃 파일 분석

- mergeDebugResource Task에서 실행된다
- 레이아웃 파일의 <layout> 태그가 있는 것을 분석해서 새로운 XML 파일을 생성한다

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android"
   xmlns:app="http://schemas.android.com/apk/res-auto">
   <!-- ... -->
</layout>
```

## 24p, 레이아웃 파일 분석

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Layout absoluteFilePath="/path_to/project/app/src/main/res/layout/activity_main.xml" directory="layout"
   isMerge="false"
   layout="activity_main" modulePackage="com.star_zero.debugdatabinding">
   <Variables name="viewModel" declared="true" type="com.star_zero.debugdatabinding.ViewModel"> <!-- 변수 -->
      <location endLine="9" endOffset="61" startLine="7" startOffset="8" />
   </Variables>
   <Targets>
      <Target tag="layout/activity_main_0" view="android.support.constraint.ConstraintLayout">
         <Expressions />
         <location endLine="38" endOffset="49" startLine="12" startOffset="4" />
      </Target>
      <Target id="@+id/textView" tag="binding_1" view="TextView"> <!-- View -->
         <Expressions>
            <Expression attribute="android:text" text="viewModel.text"> <!-- 식 -->
               <Location endLine="20" endOffset="43" startLine="20" startOffset="12" />
               <TwoWay>false</TwoWay> <!-- Two-way binding -->
               <ValueLocation endLine="20" endOffset="41" startLine="20" startOffset="28" />
            </Expression>
         </Expressions>
         <location endLine="24" endOffset="55" startLine="16" startOffset="8" />
      </Target>
      <Target id="@+id/button" view="Button">
         <Expressions />
         <location endLine="36" endOffset="65" startLine="26" startOffset="8" />
      </Target>
   </Targets>
</Layout>
```

## 25p, 레이아웃 파일 분석

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/store/LayoutFileParser.java](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/store/LayoutFileParser.java)

```java
public class LayoutFileParser {
   // ...
   private void parseExpressions(String newTag, final XMLParser.ElementContext rootView, final boolean isMerge, ResourceBundle.LayoutFileBundle bundle) {
      // ...
      for (XMLParser.ElementContext parent : bindingElements) {
         // ...
         for (XMLParser.AttributeContext attr : XmlEditor.expressionAttributes(parent)) {
            String value = escapeQuotes(attr.attrValue.getText(), true);
            final boolean isOneWay = value.startsWith("@{");
            final boolean isTwoWay = value.startsWith("@={");
            if (isOneWay || isTwoWay) {
               if (value.charAt(value.length() - 1) != '}') {
                  L.e("Expecting '}' in expression '%s'", attr.attrValue.getText());
               }
               final int startIndex = isTwoWay ? 3 : 2;
               final int endIndex = value.length() - 1;
               final String strippedValue = value.substring(startIndex, ndIndex);
               Location attrLocation = new Location(attr);
               Location valueLocation = new Location();
               // offset to 0 based
               valueLocation.startLine = attr.attrValue.getLine() - 1;
               valueLocation.startOffset = ttr.attrValue.getCharPositionInLine() + ttr.attrValue.getText().indexOf(strippedValue);
               valueLocation.endLine = attrLocation.endLine;
               valueLocation.endOffset = attrLocation.endOffset - 2; // ccount for: "}
               bindingTargetBundle.addBinding(escapeQuotesattr.attrName.getText(), false), strippedValue, isTwoWay, ttrLocation, valueLocation);
```

## 26p, 레이아웃 파일 분석

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/store/LayoutFileParser.java](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/src/main/java/android/databinding/tool/store/LayoutFileParser.java)

```java
public class LayoutFileParser {
   // ...
   private void parseData(File xml, XMLParser.ElementContext data, ResourceBundle.LayoutFileBundle bundle) {
      if (data == null) {
         return;
      }
      for (XMLParser.ElementContext imp : filter(data, "import")) {
         final Map<String, String> attrMap = attributeMap(imp);
         String type = attrMap.get("type");
         String alias = attrMap.get("alias");
         Preconditions.check(StringUtils.isNotBlank(type), "Type of an import cannot be empty."
               + " %s in %s", imp.toStringTree(), xml);
         if (Strings.isNullOrEmpty(alias)) {
            alias = type.substring(type.lastIndexOf('.') + 1);
         }
         bundle.addImport(alias, type, new Location(imp));
      }

      for (XMLParser.ElementContext variable : filter(data, "variable")) {
         final Map<String, String> attrMap = attributeMap(variable);
         String type = attrMap.get("type");
         String name = attrMap.get("name");
         Preconditions.checkNotNull(type, "variable must have a type definition %s in %s", variable.toStringTree(), xml);
         Preconditions.checkNotNull(name, "variable must have a name %s in %s", variable.toStringTree(), xml);
         bundle.addVariable(name, type, new Location(variable), true);
```

## 27p

Gradle Plugin 추가 내용

## 28p, 문서에 없는 옵션

```gradle
dataBinding {
   enabled true
   version "2.3.3"
   addDefaultAdapters false
   enabledForTests true
}
```

## 29p

Annotation Processor

## 30p, Annotation Processor

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/)

## 31p, Annotation Processor

- Binding 클래스 생성
- BR 클래스 생성
- DataBinderMapper 클래스 생성

> kotlin이 사용되고 있다

## 32P, Annotation Processor

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/java/android/databinding/annotationprocessor/ProcessDataBinding.java](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/java/android/databinding/annotationprocessor/ProcessDataBinding.java)

```java
@SupportedAnnotationTypes({
      "android.databinding.BindingAdapter",
      "android.databinding.InverseBindingMethods",
      "android.databinding.InverseBindingAdapter",
      "android.databinding.InverseMethod",
      "android.databinding.Untaggable",
      "android.databinding.BindingMethods",
      "android.databinding.BindingConversion",
      "android.databinding.BindingBuildInfo"} // DataBindingInfo Annotation
)
/**
* Parent annotation processor that dispatches sub steps to ensure execution order.
* Use initProcessingSteps to add a new step.
*/
public class ProcessDataBinding extends AbstractProcessor {
   private List<ProcessingStep> mProcessingSteps;
   private DataBindingCompilerArgs mCompilerArgs;
   @Override
   public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
      if (mProcessingSteps == null) {
         readArguments();
         initProcessingSteps();
      }
      if (mCompilerArgs == null) {
         return false;
      }
      if (mCompilerArgs.isTestVariant() && !mCompilerArgs.isEnabledForTests() &&
```

## 33p, Annotation Processor

- `Binding 클래스 생성`
- BR 클래스 생성
- DataBinderMapper 클래스 생성

## 34p, Binding 클래스 생성

- View에 반영하는 클래스
- 레이아웃과 Annotation으로부터 생성된다

## 35p, Binding 클래스 생성

```java
public class ActivityMainBinding extends ViewDataBinding {

   @Nullable
   private static final IncludedLayouts sIncludes;
   @Nullable
   private static final SparseIntArray sViewsWithIds;
   static {
      sIncludes = null;
      sViewsWithIds = null;
   }
   @NonNull
   private final LinearLayout mboundView0;
   @NonNull
   public final TextView textView1;
   @Nullable
   private ViewModel mViewModel;

   public ActivityMainBinding(@NonNull DataBindingComponent bindingComponent, @NonNull View root) {
      super(bindingComponent, root, 2);
      final Object[] bindings = mapBindings(bindingComponent, root, 2,    sIncludes, sViewsWithIds);
      this.mboundView0 = (LinearLayout) bindings[0];
      this.mboundView0.setTag(null);
      this.textView1 = (TextView) bindings[1];
      this.textView1.setTag(null);
      setRootTag(root);
      // listeners
      invalidateAll();
   }

   @Override
   public void invalidateAll() {
      synchronized(this) {
         mDirtyFlags = 0x4L;
      }
      requestRebind();
```

## 36p, Binding 클래스 생성

- 레이아웃 파일을 파싱한 XML 파일에서 Binding 클래스를 생성

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Layout absoluteFilePath="/path_to/project/app/src/main/res/layout/
activity_main.xml" directory="layout" 
   isMerge="false"
   layout="activity_main" modulePackage="com.star_zero.debugdatabinding">
   <Variables name="viewModel" declared="true"
type="com.star_zero.debugdatabinding.ViewModel">
      <location endLine="9" endOffset="61" startLine="7" startOffset="8" />
   </Variables>
   <Targets>
      <Target tag="layout/activity_main_0"
view="android.support.constraint.ConstraintLayout">
         <Expressions />
         <location endLine="38" endOffset="49" startLine="12" startOffset="4" />
      </Target>
   <!— … —>
   </Targets>
</Layout>
```

## 37p, Binding 클래스 생성

- import 문 생성
- <variable>로 속성 생성
- android:id가 있는 View 필드 생성
- @{} 식을 분석
   - 식 분석에는 ANTLR v4가 사용되고 있다
- EventListener의 구현
- View에 반영하는 처리
   - BindingAdapter Annotation
   - set + XML의 속성 이름의 메소드

## 38p, Binding 클래스 생성

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/LayoutBinderWriter.kt](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/LayoutBinderWriter.kt)

```kt
class LayoutBinderWriter(val layoutBinder : LayoutBinder) {
   // ...
   fun executePendingBindings() = kcode("") {
      nl("@Override")
      block("protected void executeBindings()") {
         val tmpDirtyFlags = FlagSet(mDirtyFlags.buckets)
         tmpDirtyFlags.localName = "dirtyFlags";
         for (i in (0..mDirtyFlags.buckets.size - 1)) {
            nl("${tmpDirtyFlags.type} ${tmpDirtyFlags.localValue(i)} = 0;")
         }
         block("synchronized(this)") {
            for (i in (0..mDirtyFlags.buckets.size - 1)) {
               nl("${tmpDirtyFlags.localValue(i)} = ${mDirtyFlags.localValue(i)};")
               nl("${mDirtyFlags.localValue(i)} = 0;")
            }
         }
         model.pendingExpressions.filter { it.needsLocalField }.forEach {
            nl("${it.resolvedType.toJavaCode()} ${it.executePendingLocalName} = ${if (it.isVariable()) it.fieldName else it.defaultValue};")
         }
         L.d("writing executePendingBindings for %s", className)
         do {
            val batch = ExprModel.filterShouldRead(model.pendingExpressions)
            val justRead = arrayListOf<Expr>()
            L.d("batch: %s", batch)
            while (!batch.none()) {
               val readNow = batch.filter { it.shouldReadNow(justRead) }
               if (readNow.isEmpty()) {
                  throw IllegalStateException("do not know what I can read. bailing out ${batch.joinToString("\n")}")
               }
            L.d("new read now. batch size: %d, readNow size: %d", batch.size, readNow.size)
            nl(readWithDependants(readNow, justRead, batch, tmpDirtyFlags))
```

## 39p, Binding 클래스 생성

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/BindingExpression.g4](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compilerCommon/BindingExpression.g4)

```
grammar BindingExpression;

// ...
expression
   : '(' expression ')' # Grouping
// this isn't allowed yet.
// | THIS # Primary
   | literal # Primary
   | VoidLiteral # Primary
   | identifier # Primary
   | classExtraction # Primary
   | resources # Resource
// | typeArguments (explicitGenericInvocationSuffix | 'this' arguments) # GenericCall
   | expression '.' Identifier # DotOp
   | expression '::' Identifier # FunctionRef
// | expression '.' 'this' # ThisReference
// | expression '.' explicitGenericInvocation # ExplicitGenericInvocationOp
   | expression '[' expression ']' # BracketOp
   | target=expression '.' methodName=Identifier '(' args=expressionList? ')' # MethodInvocation
   | methodName=Identifier '(' args=expressionList? ')' # GlobalMethodInvocation
   | '(' type ')' expression # CastOp
   | op=('+'|'-') expression # UnaryOp
   | op=('~'|'!') expression # UnaryOp
   | left=expression op=('*'|'/'|'%') right=expression # MathOp
   | left=expression op=('+'|'-') right=expression # MathOp
   | left=expression op=('<<' | '>>>' | '>>') right=expression # BitShiftOp
   | left=expression op=('<=' | '>=' | '>' | '<') right=expression # ComparisonOp
   | expression 'instanceof' type # InstanceOfOp
   | left=expression op=('==' | '!=') right=expressi
```

## 40p, Annotation Processor

- Binding 클래스 생성s
- `BR 클래스 생성`
- DataBinderMapper 클래스 생성

## 41p, BR 클래스 생성

- @Bindable에서 BR 클래스를 생성한다
- notifyPropertyChanged를 사용

```java
public class BR {
   public static final int _all = 0;
   public static final int text = 1;
   public static final int viewModel = 2;
}
```

## 42p, BR 클래스 생성

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/BRWriter.kt](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/BRWriter.kt)

```kt
class BRWriter(properties: Set<String>, val useFinal : Boolean) {
   val indexedProps = properties.sorted().withIndex()
   fun write(pkg : String): String = "package $pkg;${StringUtils.LINE_SEPARATOR}$klass"
   val klass: String by lazy {
      kcode("") {
         val prefix = if (useFinal) "final " else "";
         annotateWithGenerated()
         block("public class BR") {
            tab("public static ${prefix}int _all = 0;")
            indexedProps.forEach {
               tab ("public static ${prefix}int ${it.value} = ${it.index + 1};")
            }
         }
      }.generate()
   }
}
```

## 43p, Annotation Processor

- Binding 클래스 생성s
- BR 클래스 생성
- `DataBinderMapper 클래스 생성`

## 44p, DataBinderMapper 클래스 생성

- 레이아웃과 Binding 클래스 매핑

```java
class DataBinderMapper {
   final static int TARGET_MIN_SDK = 19;
   public DataBinderMapper() {
   }
   public ViewDataBinding getDataBinder(DataBindingComponent bindingComponent, View view, int layoutId) {
      switch(layoutId) {
         case R.layout.activity_main:
            return ActivityMainBinding.bind(view, bindingComponent);
      }
      return null;
   }
   // …
}
```

## 45p, DataBinderMapper 클래스 생성

- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/BindingMapperWriter.kt](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/compiler/src/main/kotlin/android/databinding/tool/writer/BindingMapperWriter.kt)

```kt
class BindingMapperWriter(var pkg : String, var className: String, val layoutBinders : List<LayoutBinder>, val compilerArgs: DataBindingCompilerArgs) {
   // ...
   fun write(brWriter : BRWriter) = kcode("") {
      nl("package $pkg;")
      nl("import ${compilerArgs.modulePackage}.BR;")
      val extends = if (generateAsTest) "extends $appClassName" else "" annotateWithGenerated()
      block("class $className $extends") {
         nl("final static int TARGET_MIN_SDK = ${compilerArgs.minApi};")
         if (generateTestOverride) {
            nl("static $appClassName mTestOverride;")
            block("static") {
               block("try") {
               nl("mTestOverride = ($appClassName) $appClassName.class.getClassLoader().loadClass(\"$pkg.$testClassName\").newInstance();")
            }
            block("catch(Throwable ignored)") {
               nl("// ignore, we are not running in test mode")
               nl("mTestOverride = null;")
            }
         }
      }
      nl("")
      block("public $className()") {
```

## 46p

코드 생성 및 실행

## 47p, 코드 생성 및 실행

- notifyPropertyChanged
- executeBindings
- mDirtyFlags
- EventListener
- @BindingAdapter
- Two-way binding

## 48p, 코드 생성 및 실행

- `notifyPropertyChanged`
- executeBindings
- mDirtyFlags
- EventListener
- @BindingAdapter
- Two-way binding

## 49p, notifyPropertyChanged

- View의 변경 알림

```java
public class ViewModel extends BaseObservable {
   private String text;

   @Bindable
   public String getText() {
      return text;
   }

   public void setText(String text) {
      this.text = text;
      notifyPropertyChanged(BR.text);
   }
}
```

## 50p, notifyPropertyChanged

- Activity

```java
public class MainActivity extends AppCompatActivity {
   private ActivityMainBinding binding;
   private ViewModel viewModel = new ViewModel();

   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      binding = DataBindingUtil.setContentView(
      this, R.layout.activity_main);
      binding.setViewModel(viewModel);
      // ...
   }
}
```

## 51p, notifyPropertyChanged

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   // ...
      public void setViewModel(@Nullable ViewModel ViewModel) {
      updateRegistration(2, ViewModel);   // 알림 가능한 상태를 만든다
      this.mViewModel = ViewModel;
      synchronized(this) {
         mDirtyFlags |= 0x4L;
      }
      notifyPropertyChanged(BR.viewModel);
      super.requestRebind();
      }
}
```

## 52p, notifyPropertyChanged

- setViewModel을 한 상태 (간단한 버전)

```
[ViewModel (참조)] → [WeakListener (참조)] → ActivityMainBinding(ViewDataBinding) 
```

## 53p, notifyPropertyChanged

- notifyPropertyChanged를 실행

```
[ViewModel notifyProperty Changed → (참조)] → [WeakListener (참조)] → ActivityMainBinding(ViewDataBinding) → View 갱신 (executeBindings)
```

## 54p, 코드 생성 및 실행

- notifyPropertyChanged
- `executeBindings`
- mDirtyFlags
- EventListener
- @BindingAdapter
- Two-way binding

## 55p, executeBindings

```java
public class ActivityMainBinding extends ViewDataBinding {
   // …
   @Override
   protected void executeBindings() {
      long dirtyFlags = 0;
      synchronized(this) {
         dirtyFlags = mDirtyFlags;
         mDirtyFlags = 0;
      }
      java.lang.String viewModelText = null;
      ViewModel viewModel = mViewModel;

      if ((dirtyFlags & 0x7L) != 0) {
         if (viewModel != null) {
            viewModelText = viewModel.getText();
         }
      }
      if ((dirtyFlags & 0x7L) != 0) {
         TextViewBindingAdapter.setText(this.textView, viewModelText);
      }
   }
   // …
}
```

## 56p, executeBindings

1. 속성 변경 알림
2. mDirtyFlags를 설정
3. Choreographer.postFrameCallback 실행
4. 3의 콜백에서 executeBindings 실행

## 57p, executeBindings

- Choreographer.postFrameCallback 의해 다음 프레임에서 실행된다
- [https://developer.android.com/reference/android/view/Choreographer.html#postFrameCallback(android.view.Choreographer.FrameCallback](https://developer.android.com/reference/android/view/Choreographer.html#postFrameCallback(android.view.Choreographer.FrameCallback)

## 58p, executeBindings

- RecyclerView.ViewHolder
   - 다음 프레임에서 실행되므로, 잘못된 데이터로 View 크기 계산을 할 수 있다
   - 이를 방지하려면 직접 executeBindings를 불러 즉시 반영시킨다
- [https://medium.com/google-developers/android-data-binding-recyclerview-db7c40d9f0e4](https://medium.com/google-developers/android-data-binding-recyclerview-db7c40d9f0e4)

## 59p, 코드 생성 및 실행

- notifyPropertyChanged
- executeBindings
- `mDirtyFlags`
- EventListener
- @BindingAdapter
- Two-way binding

## 60p, mDirtyFlags

- 속성 변경 비트 플래그

```java
public class ActivityMainBinding extends ViewDataBinding {
   @Override
   public void invalidateAll() {
      synchronized(this) {
         mDirtyFlags = 0x10L;
      }
      requestRebind();
   }
   private boolean onChangeViewModelText1(ObservableField<String>    ViewModelText1, int fieldId) {
      if (fieldId == BR._all) {
         synchronized(this) {
            mDirtyFlags |= 0x1L;
         }
         return true;
      }
      return false;
   }

   @Override
   protected void executeBindings() {
      // ...
      if ((dirtyFlags & 0x19L) != 0) {
      TextViewBindingAdapter.setText(this.textView1, viewModelText1Get);
      }
   }
}
```

## 61p, mDirtyFlags

- long의 비트 플래그
- 속성이 64을 초과하는 경우에는 새로운 변수가 만들어진다
   - mDirtyFlags_1
   - mDirtyFlags_2
- 가장 왼쪽의 비트는 모든 변경 플래그
   - 변수가 여러개인 경우 마지막 변수의 첫번째 왼쪽

## 62p, 코드 생성 및 실행

- notifyPropertyChanged
- executeBindings
- mDirtyFlags
- `EventListener`
- @BindingAdapter
- Two-way binding

## 63p, EventListener

```java
public class ViewModel {
   public void onClick(View view) {
      // ...
   }
}
```
```xml
<Button
   android:id="@+id/button"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:onClick="@{viewModel::onClick}"
   android:text="Button" />
```

## 64p, EventListener

- ViewBindingAdapter에 정의
- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/)

```java
@BindingMethods({
   @BindingMethod(type = View.class,
                  attribute = "android:onClick",
                  method = "setOnClickListener"),
})
public class ViewBindingAdapter {
}
```

## 65p, EventListener

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   @Override
   protected void executeBindings() {
      OnClickListener listener = null;
      listener = new OnClickListenerImpl();
      listener.setValue(viewModel);
      button.setOnClickListener(listener);   // EventListener를 설정
   }

   public static class OnClickListenerImpl implements OnClickListener{   // OnClickListener을 정의
      private ViewModel value;
      public OnClickListenerImpl setValue(ViewModel value) {
         this.value = value;
            return value == null ? null : this;
      }
      @Override
      public void onClick(android.view.View arg0) {
         this.value.onClick(arg0);   // ViewModel에 정의한 메소드
      }
   }
}
```

## 66p, 코드 생성 및 실행

- notifyPropertyChanged
- executeBindings
- mDirtyFlags
- EventListener
- `s@BindingAdapter`
- Two-way binding

## 67p, @BindingAdapter

- 커스텀 Setter
- Annotation으로 지정한 메소드가 사용된다

```java
public class CustomBinding {
   @BindingAdapter("intValue")
   public static void setIntValue(TextView view, int value) {
      view.setText(String.valueOf(value));
   }
}
```
```java
public class ActivityMainBinding extends ViewDataBinding {
   @Override
   protected void executeBindings() {
      // …
      CustomBinding.setIntValue(this.textView, viewModelValueGet);   // @BindingAdapter으로 정의한 메소드
      // ...
   }
}
```

## 68p, @BindingAdapter

- 인스턴스 메소드도 사용할 수 있다

```java
public class SampleBindingAdapter {
   private SimpleDateFormat format;

   public SampleBindingAdapter(SimpleDateFormat format) {
      this.format = format;
   }

   @BindingAdapter("dateValue")   // 인스턴스 메소드
   public void setDate(TextView view, Date date) {
      view.setText(format.format(date));
   }
}
```
```xml
<TextView
   android:id="@+id/text"
   android:layout_width="match_parent"
   android:layout_height="wrap_content"
   app:dateValue="@{viewModel.date}"/>
```

## 69p, @BindingAdapter

- DataBindingComponent라는 interaface가 생성된다

```java
package android.databinding;
public interface DataBindingComponent {
   SampleBindingAdapter getSampleBindingAdapter();
}
```

## 70p, @BindingAdapter

- DataBindingComponent를 구현한다

```java
public class MyComponent implements DataBindingComponent {
   @Override
   public SampleBindingAdapter getSampleBindingAdapter() {
      SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
      return new SampleBindingAdapter(format);
   }
}
```

## 71p, @BindingAdapter

- DataBindingUtil.setContentView로 설정
- 또는 setDefaultComponent로 기본 설정

```java
public class MainActivity extends AppCompatActivity {
   private ActivityMainBinding binding;
   
   @Override
   protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      binding = DataBindingUtil.setContentView(this, R.layout.activity_main, new MyComponent());   // 정의한 Component를 지정

      // 기본을 지정하고 싶은 경우
      DataBindingUtil.setDefaultComponent(new MyComponent());
      // ...
   }
}
```

## 72p, @BindingAdapter

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   public ActivityMainBinding(@NonNull DataBindingComponent bindingComponent, @NonNull View root) {
      super(bindingComponent, root, 2);
      // ...
   }

   @Override
   protected void executeBindings() {
      // ...
      this.mBindingComponent.getSampleBindingAdapter().setDate(this.textView, viewModelValueGet);   // setContentView의 인수로 넘긴 Component
   }
}
```

## 73p, 코드 생성 및 실행

- notifyPropertyChanged
- executeBindings
- mDirtyFlags
- EventListener
- @BindingAdapter
- `Two-way binding`

## 74p, Two-way binding

- @={}로 Two-way binding
- TextView에는 TextViewBindingAdapter로 정의
- [https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/](https://android.googlesource.com/platform/frameworks/data-binding/+/gradle_3.0.0/extensions/baseAdapters/)

```xml
<EditText
   android:id="@+id/editText"
   android:layout_width="match_parent"
   android:layout_height="wrap_content"
   android:text="@={viewModel.text}"/>
```

## 75p, Two-way binding

- TextViewBindingAdapter

```java
@BindingAdapter("android:text")
public static void setText(TextView view, CharSequence text) {
   final CharSequence oldText = view.getText();
   if (text == oldText || (text == null && oldText.length() == 0)) {
      return;
   }
   // ...
   view.setText(text);
}
```

## 76p, Two-way binding

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   private InverseBindingListener textAttrChanged = new   InverseBindingListener() {
      @Override
      public void onChange() {
         String callbackArg_0 = TextViewBindingAdapter.getTextString(editText);
         // ...
         viewModel.setText(callbackArg_0));
      }
   };
   @Override
   protected void executeBindings() {
      // …
      TextViewBindingAdapter.setText(editText, viewModelText);   
      TextViewBindingAdapter.setTextWatcher(editText, null, null, null, textAttrChanged);
   }
}
```

## 77p, Two-way binding

- TextViewBindingAdapter

```java
@InverseBindingAdapter(attribute = "android:text",
                       event = "android:textAttrChanged")
public static String getTextString(TextView view) {
   return view.getText().toString();
}
```

## 78p, Two-way binding

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   private InverseBindingListener textAttrChanged = new InverseBindingListener() {
      @Override
      public void onChange() {
         String callbackArg_0 = TextViewBindingAdapter.getTextString(editText);   // @InverseBindingAdapter
         // ...
         viewModel.setText(callbackArg_0));   // ViewModel에 설정
      }
   };
   @Override
   protected void executeBindings() {
      // …
      TextViewBindingAdapter.setText(editText, viewModelText);
      TextViewBindingAdapter.setTextWatcher(editText, null, null, null, textAttrChanged);
   }
}
```

## 79p, Two-way binding

- TextViewBindingAdapter

```java
@BindingAdapter(value = {"android:beforeTextChanged", "android:onTextChanged",
                         "android:afterTextChanged", "android:textAttrChanged"},
                         requireAll = false)
public static void setTextWatcher(TextView view,
   final BeforeTextChanged before,
   final OnTextChanged on,
   final AfterTextChanged after,
   final InverseBindingListener textAttrChanged) {
   // ...
   newValue = new TextWatcher() {
      @Override
      public void onTextChanged(CharSequence s, int start, int before, int count) {
         if (textAttrChanged != null) {
            textAttrChanged.onChange();
         }
      }
      // ...
   };
   // ...
}
```

## 80p, Two-way binding

- Binding 클래스

```java
public class ActivityMainBinding extends ViewDataBinding {
   private InverseBindingListener textAttrChanged = new    InverseBindingListener() {
      @Override
      public void onChange() {
         String callbackArg_0 = TextViewBindingAdapter.getTextString(editText);
         // ...
         viewModel.setText(callbackArg_0));
      }
   };
   @Override
   protected void executeBindings() {
      // …
      TextViewBindingAdapter.setText(editText, viewModelText);
      TextViewBindingAdapter.setTextWatcher(editText, null, null, null, textAttrChanged);   // @BindingAdapter("android:textAttrChanged")
   }
}
```

## 81p

정리

## 82p, 정리

- 코드를 읽음으로써 구조를 깊이 알 수 있다
- 문서에 실리지 않는 것도 알 수 있다
- 코드 읽기는 힘들지만 추천