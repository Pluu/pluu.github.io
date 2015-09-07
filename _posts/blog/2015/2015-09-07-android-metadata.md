---
layout: post
title: "AndroidManifest.xml 의 meta-data 정보 취득"
date: 2015-09-07 18:30:00
tag: [Android, Manifest]
categories:
- blog
---
<!--more-->

여러 3rd Party 라이브러리를 사용하면 `AndroidManifest.xml`에 `meta-data` 를 추가하라는 항목이 가끔씩 나옵니다.

추가는 쉽지만, 실제 Android Java 파일에서 어떻게 값을 취득하는가에 대해서 간단하게 설명을 적겠습니다.

`Fabric` 을 사용하는 경우 아래와 같이 메타 데이터를 사용하고 있습니다.

{% highlight xml %}
<meta-data
    android:name="io.fabric.ApiKey"
    android:value="<!-- Key Value -->" />
{% endhighlight %}

위의 값을 취득하기 위해서는 아래와 같이 진행하시면 됩니다.

1. PackageManager 를 이용해서 해당 `ApplicationInfo` 를 취득
2. ApplicationInfo 취득시 `packageName`과 `flag` 정보 입력. flag 값은 `GET_META_DATA` 를 이용
3. ApplicationInfo 의 `metaData` 값을 취득
4. Bundle 형인 `metaData` 가 null 이 아닌 경우, 실제 원하는 meta-data 의 name 을 이용해서 값을 취득

{% highlight java linenos %}
public static String getApiKeyFromManifest(Context context) {
		String apiKey = null;

		try {
			String e = context.getPackageName();
			ApplicationInfo ai = context
				.getPackageManager()
				.getApplicationInfo(e, PackageManager.GET_META_DATA);
			Bundle bundle = ai.metaData;
			if(bundle != null) {
				apiKey = bundle.getString("io.fabric.ApiKey");
			}
		} catch (Exception var6) {
			Log.d(Furious.LOG_TAG, "Caught non-fatal exception while retrieving apiKey: " + var6);
		}

		return apiKey;
	}
{% endhighlight %}

- - -

####PackageManager

**public abstract [ApplicationInfo](http://developer.android.com/reference/android/content/pm/ApplicationInfo.html) getApplicationInfo ([String](http://developer.android.com/reference/java/lang/String.html) packageName, int flags)**

Retrieve all of the information we know about a particular package/application.

Throws [PackageManager.NameNotFoundException](http://developer.android.com/reference/android/content/pm/PackageManager.NameNotFoundException.html) if an application with the given package name cannot be found on the system.

**Parameters**

- packageName 	The full name (i.e. com.google.apps.contacts) of an application.
- flags 	Additional option flags. Use any combination of [GET_META_DATA](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_META_DATA), [GET_SHARED_LIBRARY_FILES](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_SHARED_LIBRARY_FILES), [GET_UNINSTALLED_PACKAGES](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_UNINSTALLED_PACKAGES) to modify the data returned.

**Returns**

[ApplicationInfo](http://developer.android.com/reference/android/content/pm/ApplicationInfo.html) Returns ApplicationInfo object containing information about the package. If flag GET_UNINSTALLED_PACKAGES is set and if the package is not found in the list of installed applications, the application information is retrieved from the list of uninstalled applications(which includes installed applications as well as applications with data directory ie applications which had been deleted with `DONT_DELETE_DATA` flag set).

**Throws**

[PackageManager.NameNotFoundException](http://developer.android.com/reference/android/content/pm/PackageManager.NameNotFoundException.html)

**See Also**

- [GET_META_DATA](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_META_DATA)
- [GET_SHARED_LIBRARY_FILES](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_SHARED_LIBRARY_FILES)
- [GET_UNINSTALLED_PACKAGES](http://developer.android.com/reference/android/content/pm/PackageManager.html#GET_UNINSTALLED_PACKAGES)
