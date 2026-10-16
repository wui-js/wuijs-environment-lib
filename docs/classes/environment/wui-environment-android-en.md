[English](wui-environment-android-en.md) | [Español](wui-environment-android-es.md)

[wuijs-environment-lib](../../README-en.md)

Platforms: [Android](wui-environment-android-en.md) | [iOS](wui-environment-ios-en.md) | [Web](wui-environment-web-en.md)

# WUIEnvironment (Android)

Version: `0.6`

The Android library uses **WebView** as its rendering engine.

## Sources

| Type | File |
|:----:| ---- |
| Java | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |

<a name="android-constructor"></a>

## Java Constructor

| Constructor | Description |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Initializes the WUI environment with default settings. `developMode = true` allows SSL with untrusted certificates, enables debug logging and enables WebView inspection with Chrome DevTools (`chrome://inspect`). **Do not use `true` in production** — it disables certificate validation for the entire WebView. |

<a name="android-methods"></a>

## Java Methods

| Method                   | Return type  | Description |
| ------------------------ | ------------ | ----------- |
| `requestPermission`      | `void`       | `requestPermission(type, callback)`<br><br>Arguments:<br>**• type:** `String`, one of `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• callback:** `Consumer<Boolean>`, invoked with the result.<br><br>Requests the system permission for the given type. If already granted, invokes the callback immediately. If permanently denied (`don't ask again`), returns `false` without showing the dialog. On Android < 13, `notifications` always resolves to `true`. Delegates the OS callback through `MainActivity.onRequestPermissionsResult` → `handlePermissionResult(...)`. |
| `handlePermissionResult` | `void`       | `handlePermissionResult(requestCode, permissions, grantResults)`<br><br>Arguments:<br>**• requestCode:** `int`, request code received in `onRequestPermissionsResult`.<br>**• permissions:** `String[]`, requested permissions.<br>**• grantResults:** `int[]`, results of the request.<br><br>Forwards the result of a permission request to the callback registered by `requestPermission`. Must be called from `onRequestPermissionsResult` of the activity (see [MainActivity Initialization](#android-config-mainactivity)). |
| `isAppInForeground`      | `boolean`    | `isAppInForeground()`<br><br>Checks whether the application is currently in the foreground. |
| `getDeviceInfo`          | `JSONObject` | `getDeviceInfo()`<br><br>Returns device hardware information: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`         | `JSONObject` | `getDisplayInfo()`<br><br>Returns screen metrics: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch`, system bar style flags, `statusbarOverlay` (`true` when content renders behind the status bar — detected via `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, or a status bar color with alpha < 255), and `navigationbarOverlay` (`true` when content renders behind the navigation bar — detected via `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, or a navigation bar color with alpha < 255). |
| `getAppInfo`             | `JSONObject` | `getAppInfo()`<br><br>Returns application metadata: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`   | `JSONObject` | `getPermissionsStatus()`<br><br>Checks the status of system permissions: `phone`, `location`, `storage`, `contacts`, `camera`, `notifications`. Possible values: `granted`, `denied`, `default`. |
| `getCurrentPosition`     | `JSONObject` | `getCurrentPosition()`<br><br>Obtains current GPS/Network coordinates: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Requests location permission if not yet granted. |
| `getConnectionStatus`    | `boolean`    | `getConnectionStatus()`<br><br>Checks whether an active internet connection exists (WiFi, mobile data, or Ethernet). |
| `setStatusbarStyle`      | `void`       | `setStatusbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or a `colors.xml` key (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` for dark icons, `false` for light.<br><br>Updates the color and icon style of the status bar. |
| `setNavigationbarStyle`  | `void`       | `setNavigationbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or a `colors.xml` key (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` for dark icons, `false` for light.<br><br>Updates the color and icon style of the navigation bar. |
| `setAppBadge`            | `void`       | `setAppBadge(number)`<br><br>Arguments:<br>**• number:** `int`, non-negative badge count. `0` clears the badge.<br><br>Sets or clears the application icon badge using a hybrid strategy based on the device manufacturer. On OEM launchers with native badge support (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus), uses `ShortcutBadger` to render the number directly on the icon without publishing a notification. On stock Pixel/AOSP launchers, falls back to a silent notification (channel `wui_badge`, `IMPORTANCE_LOW`, `setShowBadge(true)`, `setNumber(n)`, `setSilent(true)`) which produces a dot on the icon — Pixel does not render native numbers. On Android 13+ requests the `POST_NOTIFICATIONS` permission first; if denied, the call fails silently. |
| `saveFile`               | `boolean`    | `saveFile(name, content)`<br><br>Arguments:<br>**• name:** `String`, file name.<br>**• content:** `String`, content to save.<br><br>Writes a file to the application's private internal storage. Returns `true` on success. |
| `readFile`               | `String`     | `readFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Reads a file from internal storage. Returns `null` if the file does not exist or an error occurs. |
| `removeFile`             | `boolean`    | `removeFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Deletes a file from internal storage. Returns `true` on success. |
| `openAppSettings`        | `void`       | `openAppSettings()`<br><br>Opens the application settings screen in the system Settings app. |
| `openUrl`                | `void`       | `openUrl(url)`<br><br>Arguments:<br>**• url:** `String`, destination URL or local asset path (`file:///android_asset/...`).<br><br>Loads a local asset directly in the WebView or opens an external URL via the system Intent. |
| `saveDeepLink`           | `void`       | `saveDeepLink(intent)`<br><br>Arguments:<br>**• intent:** `Intent`, intent received in `onCreate` or `onNewIntent`.<br><br>Extracts and stores the Deep Link URL from the intent. If the page is already loaded, it is sent to JavaScript immediately. |
| `sendDeepLink`           | `void`       | `sendDeepLink()`<br><br>Sends the stored Deep Link URL to JavaScript by calling `WUIEnvironment.response()`. Only acts if the page is already loaded. |
| `readDeepLink`           | `String`     | `readDeepLink()`<br><br>Returns the last stored Deep Link URL, or `null` if none is stored. |
| `clearDeepLink`          | `void`       | `clearDeepLink()`<br><br>Clears the stored Deep Link URL. |
| `downloadFile`           | `void`       | `downloadFile(url, filename, headers[, key])`<br><br>Arguments:<br>**• url:** `String`, file URL.<br>**• filename:** `String`, suggested file name; if empty, it is taken from the URL.<br>**• headers:** `JSONObject`, HTTP headers sent with the request (e.g. `Authorization`).<br>**• key:** `String` *optional*, download identifier sent back in the `onDownloadProgress` and `onDownloadFile` events (`null` if omitted).<br><br>Downloads a file with `DownloadManager` sending the given HTTP headers. Several downloads can run at the same time; each one is tracked in its own thread. It fires the same `onDownloadProgress` and `onDownloadFile` events as a download initiated from the WebView, and can be cancelled with `cancelDownload(key)`. Header values are not logged. |
| `cancelDownload`         | `void`       | `cancelDownload([key])`<br><br>Arguments:<br>**• key:** `String` *optional*. Download to cancel; if `null` or omitted, all downloads in progress are cancelled.<br><br>Cancels downloads in progress. A download that has already completed is not removed. A cancelled download fires `onDownloadFile` with `status: "cancelled"`. **Pending testing.** |
| `log`                    | `void`       | `log(message[, force])`<br><br>Arguments:<br>**• message:** `String`, message to log.<br>**• force:** `boolean` *optional*, default `false`. When `true`, bypasses the `developMode` restriction and always writes to Logcat.<br><br>Forwards the message to native Logcat under the `WUIEnvironment` tag with level `INFO` and the `[js]` prefix. Only active when `developMode = true` unless `force` overrides it. |

<a name="android-events"></a>

## Android Events

Events are callbacks that the native side sends to JavaScript when an asynchronous action completes. They must be configured on the `WUIEnvironment` instance before loading the first page.

| Event                | Arguments                                                    | Description |
| -------------------- | ------------------------------------------------------------ | ----------- |
| `onDownloadProgress` | `key`, `loaded`, `total`                                     | Fired about every 250 ms while a file download initiated from the WebView is in progress. `loaded` is the number of bytes received and `total` the file size in bytes, or `-1` if unknown. `key` is the identifier passed to `downloadFile()`, or `null` for downloads initiated from the WebView. |
| `onDownloadFile`     | `key`, `filename`, `mimetype`, `uri`, `status`, `httpStatus` | Fired when a file download initiated from the WebView ends. `status` is `"success"`, `"failed"` or `"cancelled"`; `uri` is `null` when it is not `"success"`. `httpStatus` is the HTTP code when the download failed because of an HTTP response (`COLUMN_REASON`), or `null`. On success the file is saved to the device's public `Downloads` directory and automatically opened with the corresponding application. With `DownloadManager` it is fired when the download completes or fails (up to version 0.5 it was fired when the download was enqueued). `key` is the identifier passed to `downloadFile()`, or `null` for downloads initiated from the WebView. |
| `onReceiveDeepLink`  | `url`                                                        | Fired when the application receives a Deep Link URL (on launch or while running). |

<a name="android-dialogs"></a>

## JavaScript Dialogs

`WUIEnvironment` intercepts standard JavaScript dialogs (`alert()`, `confirm()`, `prompt()`) and renders them via native `AlertDialog`. This replaces the default WebView dialog that prefixes the message with the page origin (e.g. `"The page at 'file://' says:"`).

| Dialog                     | Native behavior |
| -------------------------- | --------------- |
| `alert(message)`           | Displays `AlertDialog` with the message and an **OK** button. Blocks JavaScript until dismissed. |
| `confirm(message)`         | Displays `AlertDialog` with **OK** / **Cancel** buttons. Returns `true` / `false` to JavaScript. |
| `prompt(message, default)` | Displays `AlertDialog` with a text input and **OK** / **Cancel** buttons. Returns the entered string or `null` on cancel. |

> [!NOTE]
> Dialogs are modal (`setCancelable(false)`) — dismissal only via the OK/Cancel buttons. Button labels are auto-localized by the system (`android.R.string.ok` / `android.R.string.cancel`).

<a name="android-install"></a>

## Installation and Setup

<a name="android-clone"></a>

### 1. Clone the library

Clone the repository from the official wuiproject account on GitHub:

```bash
git clone --branch v0.6.0 https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> The repository will contain all 3 classes: Java for Android, Swift for iOS, and JavaScript as the web counterpart.

<a name="android-config-project"></a>

### 2. Project Configuration

Ensure the repositories are correctly defined:

```kotlin
dependencyResolutionManagement {
	repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
	repositories {
		google()
		mavenCentral()
	}
}
```

<a name="android-config-module"></a>

### 3. Module Configuration (`app/build.gradle.kts`)

Ensure `buildConfig` is enabled with the value `true`:

```kotlin
android {
	buildFeatures {
		buildConfig = true
	}
}
```

Add the `ShortcutBadger` dependency required by the OEM branch of `setAppBadge`:

```kotlin
dependencies {
	implementation("me.leolin:ShortcutBadger:1.1.22@aar")
}
```

> [!NOTE]
> `setAppBadge` uses a hybrid strategy: `ShortcutBadger` for manufacturers with proprietary badge APIs (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus — render the number), and a silent notification fallback for Pixel/AOSP (renders a dot, not a number, because the Pixel launcher does not support native numeric badges). The fallback branch adds an entry to the notification panel; the OEM branch does not.

<a name="android-config-manifest"></a>

### 4. Manifest Configuration in `AndroidManifest.xml`

**Add Permissions**

Ensure the application has the necessary permissions. The bridge requires at least Internet and Network State.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" /> -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Deep Link Configuration**

To enable Deep Link in the application, add the following statement to the `application.activity` section:

```xml
<intent-filter>
	<action android:name="android.intent.action.VIEW" />
	<category android:name="android.intent.category.DEFAULT" />
	<category android:name="android.intent.category.BROWSABLE" />
	<data android:scheme="app_scheme" />
</intent-filter>
```

> [!IMPORTANT]
> The `android:scheme` attribute defines the application scheme. It allows access to the application via a URL in the browser using the scheme as the protocol.
> (e.g.: app_scheme://url_resource)

**File Sharing Configuration**

To enable file sharing in the application, add the following statement to the `application.activity` section:

```xml
<provider
	android:name="androidx.core.content.FileProvider"
	android:authorities="${applicationId}.provider"
	android:exported="false"
	android:grantUriPermissions="true">
	<meta-data
		android:name="android.support.FILE_PROVIDER_PATHS"
		android:resource="@xml/file_paths" />
</provider>
```

> [!NOTE]
> This configuration is required for the implementation of downloads, camera, and file sharing via WhatsApp or Email from WebView.

`res/xml/file_paths.xml` must declare the internal files and cache directories (camera) and the public `Download` directory, which is used to open a downloaded asset file with `FileProvider`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
	<files-path name="files" path="." />
	<cache-path name="cache" path="." />
	<external-path name="downloads" path="Download/" />
</paths>
```

> [!NOTE]
> Without the `external-path` entry, an asset file is still downloaded but it is not opened after the download (the error is logged).

<a name="android-config-colors"></a>

### 5. Colors Configuration in `res/values/colors.xml`

The library uses these keys for the status and navigation bar styles:

```xml
<resources>
	<color name="black">#FF000000</color>
	<color name="white">#FFFFFFFF</color>
	<color name="statusbarLightColor">#f5f5f5</color>
	<color name="statusbarLightOverlayColor">#c2c2c2</color>
	<color name="statusbarDarkColor">#212121</color>
	<color name="statusbarDarkOverlayColor">#616161</color>
	<color name="navigationbarLightColor">#efeff6</color>
	<color name="navigationbarLightOverlayColor">#c0c0c6</color>
	<color name="navigationbarDarkColor">#212121</color>
	<color name="navigationbarDarkOverlayColor">#616161</color>
</resources>
```

> [!WARNING]
> All keys must be defined or the Java class will throw an error.

> [!NOTE]
> The **Light** colors are compatible with the **default** theme of the **WUIPluginThemes** plugin from the [wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib) library.<br>
> The **Dark** colors are suggested to be related to the application's accent color.

<a name="android-config-wui-environment-java"></a>

### 6. Java Class Integration `WUIEnvironment.java`

Copy the file `src/wui-js/environment/android/WUIEnvironment.java` to the project's source folder (e.g.: `app/src/main/java/your/package/name/` if the defined package ID is `your.package.name`).

> [!IMPORTANT]
> The first line of the file must be edited to match the application's package ID:

```java
package YOUR.PACKAGE.NAME; // Update this to match your project package
```

<a name="android-config-wui-environment-js"></a>

### 7. JavaScript Class Integration `wui-environment-0.6.js`

Copy the contents of the `src/wui-js/environment/web/` directory to the `assets/` directory of the Android project. The following structure is recommended:

- `app/src/main/assets/libraries/wui-js/environment/web/wui-environment-0.6.js`
- `app/src/main/assets/libraries/wui-js/environment/demo/index.html`

The above ensures that the initialization examples work correctly.

<a name="android-config-mainactivity"></a>

### 8. MainActivity Initialization `MainActivity.java`

```java
package YOUR.PACKAGE.NAME;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {

	private WUIEnvironment wuiEnvironment;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		try {
			wuiEnvironment = new WUIEnvironment(this);

			// Load home page

			// comment out the following line after validating the test
			String path = "libraries/wui-js/environment/demo/index.html";
			// uncomment the following line after validating the test
			//String path = "pages/index.html";
			wuiEnvironment.openUrl("file:///android_asset/" + path);

			// Request basic permissions

			wuiEnvironment.requestPermission("notifications", null);
			wuiEnvironment.requestPermission("location", null);
			//wuiEnvironment.requestPermission("camera", null);

			// Enable Deep Link requests when the app opens

			wuiEnvironment.saveDeepLink(getIntent());
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);

		// Enable Deep Link requests while the app is running

		try {
			wuiEnvironment.saveDeepLink(intent);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);

		// Required by requestPermission() - forwards the OS callback to the bridge

		if (wuiEnvironment != null) {
			wuiEnvironment.handlePermissionResult(requestCode, permissions, grantResults);
		}
	}
}
```

> [!IMPORTANT]
> The `onRequestPermissionsResult` override is required by `requestPermission` (and by any method that depends on it: `setAppBadge`, `getCurrentPosition`). Without it the permission dialog appears but the callback never resolves.
