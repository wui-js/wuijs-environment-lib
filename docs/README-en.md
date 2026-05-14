> [!IMPORTANT]
> The GitHub account `@wuiproject` was migrated to `@wui-js` to match the name with the NPM account.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/README-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/README-es.md)
---

# wuijs-environment-lib

<p align="center">
	<img src="https://github.com/wui-js/wuijs-environment-lib/blob/main/imgs/logo/wuijs-environment-logotype-color.svg" width="220" height="220">
</p>

|                      | |
| -------------------- | ----------- |
| **Library name**     | `wuijs-environment-lib` |
| **Library version**  | `0.4.0` ([Change Log](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md)) |
| **NPM package**      | `@wui-js/environment` ([npm](https://www.npmjs.com/package/@wui-js/environment)) |
| **Document version** | `0.4.0.20260512.0` |
| **License**          | `Apache License 2.0` |
| **Author**           | `Sergio E. Belmar V. <wuijs.project@gmail.com>` |
| **Repository**       | [https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib) |
| **Documentation**    | [https://docs.wuijs.dev](https://docs.wuijs.dev) |
| **Website**          | [https://wuijs.dev](https://wuijs.dev) |

## Table of Contents

*   [Overview](#overview)
	*   [About the WUI/JS Project](#project)
	*   [Directory Map](#dirmap)
*   [Quick Start](#quickstart)
	*   [Android + Web](#quickstart-android)
	*   [iOS + Web](#quickstart-ios)
*   [Android Library](#android)
	*   [Java Constructor](#android-constructor)
	*   [Java Methods](#android-methods)
	*   [Android Events](#android-events)
	*   [JavaScript Dialogs](#android-dialogs)
	*   [Installation and Setup](#android-install)
		1.   [Clone the library](#android-clone)
		2.   [Project Configuration](#android-config-project)
		3.   [Module Configuration](#android-config-module)
		4.   [Manifest Configuration](#android-config-manifest)
		5.   [Colors Configuration](#android-config-colors)
		6.   [Java Class Integration](#android-config-wui-environment-java)
		7.   [JavaScript Class Integration](#android-config-wui-environment-js)
		8.   [MainActivity Initialization](#android-config-mainactivity)
*   [iOS Library](#ios)
	*   [Swift Constructor](#ios-constructor)
	*   [Swift Methods](#ios-methods)
	*   [iOS Events](#ios-events)
	*   [JavaScript Dialogs](#ios-dialogs)
	*   [Installation and Setup](#ios-install)
		1.   [Clone the library](#ios-clone)
		2.   [Permissions Configuration](#ios-config-permissions)
		3.   [Colors Configuration](#ios-config-colors)
		4.   [Swift Class Integration](#ios-config-wui-environment-swift)
		5.   [JavaScript Class Integration](#ios-config-wui-environment-js)
		6.   [PackageApp Initialization](#ios-config-packageapp)
		7.   [MainView Initialization](#ios-config-mainview)
*   [Web Library](#web)
	*   [JavaScript Properties](#web-properties)
	*   [JavaScript Class Methods](#web-class-methods)
	*   [JavaScript Instance Methods](#web-instance-methods)
	*   [JavaScript Usage](#web-usage)

<a name="overview"></a>

## Overview

WUI/JS Environment Lib is a bridge between web environments and native web rendering engines via JavaScript, designed to facilitate the creation of hybrid applications.
It provides access to hardware and system instances such as files, camera, etc. directly from JavaScript.
It is currently available for Android in Java via WebView and for iOS in Swift via WebKit.

<a name="project"></a>

### About the WUI/JS Project

WUI/JS Environment Lib is part of the WUI/JS project, which currently consists of 4 repositories:

-	[https://github.com/wui-js/wuijs-main-lib](https://github.com/wui-js/wuijs-main-lib)<br>
	UI Main library.<br><br>
-	[https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib)<br>
	UI Bridge library between a web environments and native web rendering engines.<br><br>
-	[https://github.com/wui-js/wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib)<br>
	UI Plugins library.<br><br>
-	[https://github.com/wui-js/wuijs-demos](https://github.com/wui-js/wuijs-demos)<br>
	Repository with demos and usage examples for the project libraries.<br><br>

<a name="dirmap"></a>

### Directory Map

The library must be downloaded from the GitHub repository [wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib). This library includes 3 classes: Java for Android, Swift for iOS, and JavaScript as the web counterpart for both.

The repository directory structure is:

```bash
wuijs-environment-lib/
├── docs/
├── imgs/
│   └── logo/
├── legacy/
│   └── wui-js/
│       └── environment/
└── src/
    └── wui-js/
        └── environment/
            ├── android/
            ├── ios/
            ├── web/
            └── demo/
```

| Path                                                                                                                        | Description |
| --------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [docs](https://github.com/wui-js/wuijs-environment-lib/tree/main/docs/)                                                     | Documentation. |
| [imgs](https://github.com/wui-js/wuijs-environment-lib/tree/main/imgs/)                                                     | Images used in the documentation. |
| [imgs/logo](https://github.com/wui-js/wuijs-environment-lib/tree/main/imgs/logo/)                                           | Project logotype and isotype in SVG and PNG format. |
| [legacy](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/)                                                 | Deprecated sources with previous versions. |
| [legacy/wui-js](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/wui-js/)                                   | WUI/JS Project directory. |
| [legacy/wui-js/environment](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/wui-js/environment/)           | WUI/JS Environment library (previous versions). |
| [src](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/)                                                       | Main sources for the latest version. |
| [src/wui-js](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js)                                          | WUI/JS Project directory. |
| [src/wui-js/environment/android](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/android/) | WUI/JS Environment library for Android. |
| [src/wui-js/environment/ios](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/ios/)         | WUI/JS Environment library for iOS. |
| [src/wui-js/environment/web](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/web/)         | WUI/JS Environment library for Web. |
| [src/wui-js/environment/demo](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/demo/)       | Directory with the demo interface for Android and iOS environments. |

> [!NOTE]
> The `wuijs-environment-lib` library operates jointly, meaning the **Android + Web** or **iOS + Web** combination must be implemented for it to work correctly.

### Sources

| Type  | Version | File |
| ----- | -------:| ---- |
| Java  | 0.4     | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |
| Swift | 0.3     | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |
| JS    | 0.2     | [src/wui-js/environment/web/wui-environment-0.2.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.2.js) |

<a name="quickstart"></a>

## Quick Start

Minimal integration for a new project. For full configuration details see the platform-specific sections below.

<a name="quickstart-android"></a>

### Android + Web

**Prerequisites:** Android Studio, new project with `AppCompatActivity` and `minSdk ≥ 24`.

1. Clone the library and copy `src/wui-js/environment/android/WUIEnvironment.java` to `app/src/main/java/your/package/name/`. Edit the first line to match your package ID.
2. Copy `src/wui-js/environment/web/` and `src/wui-js/environment/demo/` to `app/src/main/assets/libraries/wui-js/environment/`.
3. Add permissions, colors, and Gradle config as described in [Installation and Setup](#android-install).
4. Initialize in `MainActivity.java`:

```java
wuiEnvironment = new WUIEnvironment(this);
wuiEnvironment.openURL("file:///android_asset/libraries/wui-js/environment/demo/index.html");
wuiEnvironment.saveDeepLink(getIntent());
```

5. In your own HTML pages, include the JS class and instantiate it:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Platform:", info.platform, "| Model:", info.model);
	});
</script>
```

<a name="quickstart-ios"></a>

### iOS + Web

**Prerequisites:** Xcode 13+, new SwiftUI project.

1. Clone the library and copy `src/wui-js/environment/ios/WUIEnvironment.swift` into the Xcode project. Add it to the target's **Sources** build phase.
2. Copy `src/wui-js/environment/web/` and `src/wui-js/environment/demo/` to a folder named `assets/libraries/wui-js/environment/` inside the Xcode project. Add the folder to the target as a **folder reference** (blue icon in Xcode).
3. Add permission keys, color sets, and Deep Link config as described in [Installation and Setup](#ios-install).
4. Initialize in `EnvironmentViewController` inside `MainView.swift`:

```swift
wuiEnvironment = WUIEnvironment(viewController: self)
wuiEnvironment?.openURL(url: Bundle.main.bundleURL.appendingPathComponent("assets/libraries/wui-js/environment/demo/index.html").absoluteString)
```

5. In your own HTML pages, include the JS class and instantiate it:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Platform:", info.platform, "| Model:", info.model);
	});
</script>
```

> [!NOTE]
> Open the demo page first (`demo/index.html`) to verify the bridge works before switching to your production HTML.

<a name="android"></a>

## Android Library

Version: `0.4`

The Android library uses **WebView** as its rendering engine.

### Sources

| Type | File |
|:----:| ---- |
| Java | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |

<a name="android-constructor"></a>

### Java Constructor

| Constructor | Description |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Initializes the WUI environment with default settings. `developMode = true` allows SSL with untrusted certificates and enables debug logging. **Do not use `true` in production** — it disables certificate validation for the entire WebView. |

<a name="android-methods"></a>

### Java Methods

| Method                  | Return type  | Description |
| ----------------------- | ------------ | ----------- |
| `requestPermission`     | `void`       | `requestPermission(type, callback)`<br><br>Arguments:<br>**• type:** `String`, one of `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• callback:** `Consumer<Boolean>`, invoked with the result.<br><br>Requests the system permission for the given type. If already granted, invokes the callback immediately. If permanently denied (`don't ask again`), returns `false` without showing the dialog. On Android < 13, `notifications` always resolves to `true`. Delegates the OS callback through `MainActivity.onRequestPermissionsResult` → `handlePermissionResult(...)`. |
| `isAppInForeground`     | `boolean`    | `isAppInForeground()`<br><br>Checks whether the application is currently in the foreground. |
| `getDeviceInfo`         | `JSONObject` | `getDeviceInfo()`<br><br>Returns device hardware information: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`        | `JSONObject` | `getDisplayInfo()`<br><br>Returns screen metrics: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch`, system bar style flags, `statusbarOverlay` (`true` when content renders behind the status bar — detected via `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, or a status bar color with alpha < 255), and `navigationbarOverlay` (`true` when content renders behind the navigation bar — detected via `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, or a navigation bar color with alpha < 255). |
| `getAppInfo`            | `JSONObject` | `getAppInfo()`<br><br>Returns application metadata: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`  | `JSONObject` | `getPermissionsStatus()`<br><br>Checks the status of system permissions: `phone`, `location`, `storage`, `contacts`, `camera`, `notifications`. Possible values: `granted`, `denied`, `default`. |
| `getCurrentPosition`    | `JSONObject` | `getCurrentPosition()`<br><br>Obtains current GPS/Network coordinates: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Requests location permission if not yet granted. |
| `getConnectionStatus`   | `boolean`    | `getConnectionStatus()`<br><br>Checks whether an active internet connection exists (WiFi, mobile data, or Ethernet). |
| `setStatusbarStyle`     | `void`       | `setStatusbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or a `colors.xml` key (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` for dark icons, `false` for light.<br><br>Updates the color and icon style of the status bar. |
| `setNavigationbarStyle` | `void`       | `setNavigationbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or a `colors.xml` key (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` for dark icons, `false` for light.<br><br>Updates the color and icon style of the navigation bar. |
| `setAppBadge`           | `void`       | `setAppBadge(number)`<br><br>Arguments:<br>**• number:** `int`, non-negative badge count. `0` clears the badge.<br><br>Sets or clears the application icon badge using a hybrid strategy based on the device manufacturer. On OEM launchers with native badge support (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus), uses `ShortcutBadger` to render the number directly on the icon without publishing a notification. On stock Pixel/AOSP launchers, falls back to a silent notification (channel `wui_badge`, `IMPORTANCE_LOW`, `setShowBadge(true)`, `setNumber(n)`, `setSilent(true)`) which produces a dot on the icon — Pixel does not render native numbers. On Android 13+ requests the `POST_NOTIFICATIONS` permission first; if denied, the call fails silently. |
| `saveFile`              | `boolean`    | `saveFile(name, content)`<br><br>Arguments:<br>**• name:** `String`, file name.<br>**• content:** `String`, content to save.<br><br>Writes a file to the application's private internal storage. Returns `true` on success. |
| `readFile`              | `String`     | `readFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Reads a file from internal storage. Returns `null` if the file does not exist or an error occurs. |
| `removeFile`            | `boolean`    | `removeFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Deletes a file from internal storage. Returns `true` on success. |
| `openAppSettings`       | `void`       | `openAppSettings()`<br><br>Opens the application settings screen in the system Settings app. |
| `openURL`               | `void`       | `openURL(url)`<br><br>Arguments:<br>**• url:** `String`, destination URL or local asset path (`file:///android_asset/...`).<br><br>Loads a local asset directly in the WebView or opens an external URL via the system Intent. |
| `saveDeepLink`          | `void`       | `saveDeepLink(intent)`<br><br>Arguments:<br>**• intent:** `Intent`, intent received in `onCreate` or `onNewIntent`.<br><br>Extracts and stores the Deep Link URL from the intent. If the page is already loaded, it is sent to JavaScript immediately. |
| `sendDeepLink`          | `void`       | `sendDeepLink()`<br><br>Sends the stored Deep Link URL to JavaScript by calling `WUIEnvironment.response()`. Only acts if the page is already loaded. |
| `readDeepLink`          | `String`     | `readDeepLink()`<br><br>Returns the last stored Deep Link URL, or `null` if none is stored. |
| `clearDeepLink`         | `void`       | `clearDeepLink()`<br><br>Clears the stored Deep Link URL. |
| `log`                   | `void`       | `log(message[, force])`<br><br>Arguments:<br>**• message:** `String`, message to log.<br>**• force:** `boolean` *optional*, default `false`. When `true`, bypasses the `developMode` restriction and always writes to Logcat.<br><br>Forwards the message to native Logcat under the `WUIEnvironment` tag with level `INFO` and the `[js]` prefix. Only active when `developMode = true` unless `force` overrides it. |

<a name="android-events"></a>

### Android Events

Events are callbacks that the native side sends to JavaScript when an asynchronous action completes. They must be configured on the `WUIEnvironment` instance before loading the first page.

| Event               | Arguments                     | Description |
| ------------------- | ----------------------------- | ----------- |
| `onDownloadFile`    | `filename`, `mimetype`, `uri` | Fired when a file download initiated from the WebView completes. The file is saved to the device's public `Downloads` directory and automatically opened with the corresponding application. |
| `onReceiveDeepLink` | `url`                         | Fired when the application receives a Deep Link URL (on launch or while running). |

<a name="android-dialogs"></a>

### JavaScript Dialogs

`WUIEnvironment` intercepts standard JavaScript dialogs (`alert()`, `confirm()`, `prompt()`) and renders them via native `AlertDialog`. This replaces the default WebView dialog that prefixes the message with the page origin (e.g. `"The page at 'file://' says:"`).

| Dialog                     | Native behavior |
| -------------------------- | --------------- |
| `alert(message)`           | Displays `AlertDialog` with the message and an **OK** button. Blocks JavaScript until dismissed. |
| `confirm(message)`         | Displays `AlertDialog` with **OK** / **Cancel** buttons. Returns `true` / `false` to JavaScript. |
| `prompt(message, default)` | Displays `AlertDialog` with a text input and **OK** / **Cancel** buttons. Returns the entered string or `null` on cancel. |

> [!NOTE]
> Dialogs are modal (`setCancelable(false)`) — dismissal only via the OK/Cancel buttons. Button labels are auto-localized by the system (`android.R.string.ok` / `android.R.string.cancel`).

<a name="android-install"></a>

### Installation and Setup

<a name="android-clone"></a>

#### 1. Clone the library

Clone the repository from the official wuiproject account on GitHub:

```bash
git clone https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> The repository will contain all 3 classes: Java for Android, Swift for iOS, and JavaScript as the web counterpart.

<a name="android-config-project"></a>

#### 2. Project Configuration

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

#### 3. Module Configuration (`app/build.gradle.kts`)

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

#### 4. Manifest Configuration in `AndroidManifest.xml`

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

<a name="android-config-colors"></a>

#### 5. Colors Configuration in `res/values/colors.xml`

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

#### 6. Java Class Integration `WUIEnvironment.java`

Copy the file `src/wui-js/environment/android/WUIEnvironment.java` to the project's source folder (e.g.: `app/src/main/java/your/package/name/` if the defined package ID is `your.package.name`).

> [!IMPORTANT]
> The first line of the file must be edited to match the application's package ID:

```java
package YOUR.PACKAGE.NAME; // Update this to match your project package
```

<a name="android-config-wui-environment-js"></a>

#### 7. JavaScript Class Integration `wui-environment-0.2.js`

Copy the contents of the `src/wui-js/environment/web/` directory to the `assets/` directory of the Android project. The following structure is recommended:

- `app/src/main/assets/libraries/wui-js/environment/web/wui-environment-0.2.js`
- `app/src/main/assets/libraries/wui-js/environment/demo/index.html`

The above ensures that the initialization examples work correctly.

<a name="android-config-mainactivity"></a>

#### 8. MainActivity Initialization `MainActivity.java`

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
			//String path = "file:///android_asset/pages/index.html";
			wuiEnvironment.openURL("file:///android_asset/" + path);

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

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		// Required by onShowFileChooser() - forwards the file picker result to the bridge

		if (wuiEnvironment != null) {
			wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data);
		}
    }
}
```

> [!IMPORTANT]
> The `onRequestPermissionsResult` override is required by `requestPermission` (and by any method that depends on it: `setAppBadge`, `getCurrentPosition`). Without it the permission dialog appears but the callback never resolves.

<a name="ios"></a>

## iOS Library

Version: `0.3`

The iOS implementation uses WebKit (WKWebView) as its rendering engine and communicates via `WKScriptMessageHandler`.

> [!NOTE]
> **`file://` XHR limitation in WKWebView:** WKWebView blocks all `XMLHttpRequest` calls to `file://` URLs regardless of the `allowingReadAccessTo` setting. `WUIEnvironment` automatically injects a `WKUserScript` at document start that intercepts these requests and routes them through the native bridge via `webkit.messageHandlers.request`. This is transparent to your JavaScript code — `XMLHttpRequest` works as expected for both local files and remote URLs.

### Sources

| Type  | File |
|:-----:| ---- |
| Swift | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |

<a name="ios-constructor"></a>

### Swift Constructor

| Constructor | Description |
| ----------- | ----------- |
| `WUIEnvironment(viewController: UIViewController[, developMode: Bool])` | Initializes the WUI environment. `developMode = true` allows SSL with untrusted certificates and enables debug logging. **Do not use `true` in production** — it disables certificate validation for the entire WKWebView. |

<a name="ios-methods"></a>

### Swift Methods

| Method                  | Return type     | Description |
| ----------------------- | --------------- | ----------- |
| `requestPermission`     | `void`          | `requestPermission(type, completion)`<br><br>Arguments:<br>**• type:** `String`, one of `location`, `notifications`, `camera`, `contacts`.<br>**• completion:** `(Bool) -> Void`, invoked with the result.<br><br>Requests the system permission for the given type. If already granted, invokes the completion immediately. If denied or restricted, returns `false`. For `location`, uses `CLLocationManager.requestWhenInUseAuthorization`; for `notifications`, `UNUserNotificationCenter.requestAuthorization`; for `camera`, `AVCaptureDevice.requestAccess`; for `contacts`, `CNContactStore.requestAccess`. |
| `isAppInForeground`     | `Bool`          | `isAppInForeground()`<br><br>Checks whether the application is currently in the foreground. |
| `getDeviceInfo`         | `[String: Any]` | `getDeviceInfo()`<br><br>Returns device hardware information: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`        | `[String: Any]` | `getDisplayInfo()`<br><br>Returns screen metrics: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch`, and system bar style flags.<br><br>`statusbarTransparent` and `navigationbarTransparent` reflect the current state of the UIView overlays managed by `setStatusbarStyle` and `setNavigationbarStyle`: `true` when no opaque overlay is placed over that area. `statusbarOverlay` is `true` when content renders behind the status bar — derived from `statusbarTransparent` or when `safeAreaInsets.top` is zero. `navigationbarOverlay` is `true` when content renders behind the navigation bar — derived from `navigationbarTransparent` or when `safeAreaInsets.bottom` is zero (devices with home button or landscape without gesture bar). `navigationbarLightMode` is always `false` (the iOS home indicator adapts automatically). |
| `getAppInfo`            | `[String: Any]` | `getAppInfo()`<br><br>Returns application metadata: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`  | `void`          | `getPermissionsStatus(completion)`<br><br>Arguments:<br>**• completion:** `([String: Any]) -> Void`, callback with the result.<br><br>Checks the status of system permissions: `location`, `camera`, `contacts`, `notifications`. Possible values: `granted`, `denied`, `default`, `undefined`. The `phone` and `storage` keys are always `undefined` (no equivalent system permission in iOS). Async — delivers the result on the main thread. |
| `getCurrentPosition`    | `void`          | `getCurrentPosition(completion)`<br><br>Arguments:<br>**• completion:** `([String: Any]) -> Void`, callback with the result.<br><br>Obtains current GPS coordinates: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Requests location permission if not yet granted. Async — delivers the result via `CLLocationManagerDelegate`.<br><br>> **Requires** `NSLocationWhenInUseUsageDescription` in `Info.plist`. Without it, iOS silently ignores the permission request. |
| `getConnectionStatus`   | `Bool`          | `getConnectionStatus()`<br><br>Checks whether an active internet connection exists. Reads the current network state synchronously via `NWPathMonitor.currentPath`; the internal `pathUpdateHandler` keeps the cached state updated for subsequent calls. |
| `setStatusbarStyle`     | `void`          | `setStatusbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or `Assets.xcassets` color set name (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `Bool`, `true` for dark icons, `false` for light.<br><br>Places a UIView with the given color over the status bar area. Icon style is applied via `preferredStatusBarStyle` — the host ViewController must expose this property and call `setNeedsStatusBarAppearanceUpdate()`. |
| `setNavigationbarStyle` | `void`          | `setNavigationbarStyle(color, darkIcons)`<br><br>Arguments:<br>**• color:** `String`, HEX color (`#RRGGBB`) or `Assets.xcassets` color set name (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `Bool`, ignored on iOS (home indicator is not configurable).<br><br>Places a UIView with the given color over the `safeAreaInsets.bottom` area. No effect on devices with a home button. |
| `setAppBadge`           | `void`          | `setAppBadge(number)`<br><br>Arguments:<br>**• number:** `Int`, non-negative badge count. `0` clears the badge.<br><br>Sets or clears the application icon badge. Requests the notifications permission first. On iOS 16+ uses `UNUserNotificationCenter.setBadgeCount`; on earlier versions falls back to `UIApplication.shared.applicationIconBadgeNumber`. |
| `saveFile`              | `Bool`          | `saveFile(name, content)`<br><br>Arguments:<br>**• name:** `String`, file name.<br>**• content:** `String`, content to save.<br><br>Writes a file to the application's `Documents` directory. Returns `true` on success. |
| `readFile`              | `String?`       | `readFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Reads a file from the `Documents` directory. Returns `nil` if the file does not exist or an error occurs. |
| `removeFile`            | `Bool`          | `removeFile(name)`<br><br>Arguments:<br>**• name:** `String`, file name.<br><br>Deletes a file from the `Documents` directory. Returns `true` on success. |
| `openAppSettings`       | `void`          | `openAppSettings()`<br><br>Opens the application settings screen in the system Settings app. |
| `openURL`               | `void`          | `openURL(url)`<br><br>Arguments:<br>**• url:** `String`, destination URL or local file path (`file://...`).<br><br>Loads a local file in the WKWebView via `loadFileURL` or opens an external URL via `UIApplication.shared.open`. |
| `saveDeepLink`          | `void`          | `saveDeepLink(url)`<br><br>Arguments:<br>**• url:** `URL?`, URL received in `scene(_:openURLContexts:)` or `application(_:open:)`.<br><br>Extracts and stores the Deep Link URL. If the page is already loaded, it is sent to JavaScript immediately. |
| `sendDeepLink`          | `void`          | `sendDeepLink()`<br><br>Sends the stored Deep Link URL to JavaScript by calling `WUIEnvironment.response()`. Only acts if the page is already loaded. |
| `readDeepLink`          | `String?`       | `readDeepLink()`<br><br>Returns the last stored Deep Link URL, or `nil` if none is stored. |
| `clearDeepLink`         | `void`          | `clearDeepLink()`<br><br>Clears the stored Deep Link URL. |
| `log`                   | `void`          | `log(_ message[, force])`<br><br>Arguments:<br>**• message:** `String` (autoclosure), message to log.<br>**• force:** `Bool` *optional*, default `false`. When `true`, bypasses the `developMode` restriction and always writes to the Xcode console.<br><br>Forwards the message to the Xcode console with the `[WUIEnvironment][js]` prefix. Only active when `developMode = true` unless `force` overrides it. |

<a name="ios-events"></a>

### iOS Events

Events are callbacks that the native side sends to JavaScript when an asynchronous action completes. They must be configured on the `WUIEnvironment` instance before loading the first page.

| Event               | Arguments                     | Description |
| ------------------- | ----------------------------- | ----------- |
| `onDownloadFile`    | `filename`, `mimetype`, `uri` | Fired when a file download initiated from the WebView completes. The file is saved to `Documents/Downloads/` inside the app sandbox and opened via `UIActivityViewController`. Requires iOS 14.5+ for `WKDownloadDelegate`; a `URLSession` fallback is used on earlier versions. |
| `onReceiveDeepLink` | `url`                         | Fired when the application receives a Deep Link URL (on launch or while running). |

<a name="ios-dialogs"></a>

### JavaScript Dialogs

`WUIEnvironment` intercepts standard JavaScript dialogs (`alert()`, `confirm()`, `prompt()`) and renders them via native `UIAlertController`. WKWebView silently discards these dialogs when `WKUIDelegate` does not implement the corresponding panel handlers — `WUIEnvironment` provides them.

| Dialog                     | Native behavior |
| -------------------------- | --------------- |
| `alert(message)`           | Displays `UIAlertController` with the message and an **OK** button. |
| `confirm(message)`         | Displays `UIAlertController` with **OK** / **Cancel** buttons. Returns `true` / `false` to JavaScript. |
| `prompt(message, default)` | Displays `UIAlertController` with a text input and **OK** / **Cancel** buttons. Returns the entered string or `null` on cancel. |

<a name="ios-install"></a>

### Installation and Setup

<a name="ios-clone"></a>

#### 1. Clone the library

Clone the repository from GitHub if it has not been cloned previously:

```bash
git clone https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> The repository will contain all 3 classes: Java for Android, Swift for iOS, and JavaScript as the web counterpart.

<a name="ios-config-permissions"></a>

#### 2. Permissions Configuration (`Info.plist` or `project.pbxproj`)

If the project uses `GENERATE_INFOPLIST_FILE = YES` (Xcode 13+), add the required usage description keys directly to the target's build settings:

| Build Setting Key                                   | Required for |
| --------------------------------------------------- | ------------ |
| `INFOPLIST_KEY_NSUserNotificationsUsageDescription` | `requestPermission()` and `setAppBadge()` (notifications) |
| `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` | `requestPermission()`, `getCurrentPosition()` and `getPermissionsStatus()` (location) |
| `INFOPLIST_KEY_NSCameraUsageDescription`            | `requestPermission()` and `getPermissionsStatus()` (camera) |
| `INFOPLIST_KEY_NSContactsUsageDescription`          | `requestPermission()` and `getPermissionsStatus()` (contacts) |

> [!WARNING]
> Without `NSLocationWhenInUseUsageDescription`, iOS silently ignores `requestWhenInUseAuthorization()` — the permission dialog never appears and `getCurrentPosition` never delivers a result.

> [!NOTE]
> If the keys are omitted in `project.pbxproj`, Xcode will read them from the `Info.plist` file.

If the project uses a manual `Info.plist`, add the keys directly to that file:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Required to send notifications.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Required to obtain the device's current position.</string>
<key>NSCameraUsageDescription</key>
<string>Required to check camera permission status.</string>
<key>NSContactsUsageDescription</key>
<string>Required to check contacts permission status.</string>
```

> [!NOTE]
> **Selectively disabling contacts permission (iOS):** If the host app does not require contacts access, you can suppress the permission request by commenting out the three contacts-related blocks in `WUIEnvironment.swift`: the `import Contacts` statement, the `"contacts"` case inside the request dispatcher, and the `CNContactStore.authorizationStatus` call inside `getPermissionsStatus`.
> Remove `NSContactsUsageDescription` from `Info.plist` as well. iOS will not prompt the user for contacts in that case. See `app.agromapp.monitor.ios` as a reference implementation.

<a name="ios-config-colors"></a>

#### 3. Colors Configuration in `Assets.xcassets`

The library uses these color set names for the status and navigation bar styles:

| Color Set Name                   | Default Value |
| -------------------------------- | ------------- |
| `statusbarLightColor`            | `#f5f5f5` |
| `statusbarLightOverlayColor`     | `#c2c2c2` |
| `statusbarDarkColor`             | `#212121` |
| `statusbarDarkOverlayColor`      | `#616161` |
| `navigationbarLightColor`        | `#efeff6` |
| `navigationbarLightOverlayColor` | `#c0c0c6` |
| `navigationbarDarkColor`         | `#212121` |
| `navigationbarDarkOverlayColor`  | `#616161` |

To add a color set in Xcode: open `Assets.xcassets`, click **+** → **Color Set**, name it exactly as shown, and set the color value in the Attributes Inspector.

> [!WARNING]
> All color sets used by the application must be defined. If a named color is not found in `Assets.xcassets`, `UIColor(named:)` returns `nil` and the affected bar defaults to white.

> [!NOTE]
> The **Light** colors are compatible with the **default** theme of the **WUIPluginThemes** plugin from the [wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib) library.<br>
> The **Dark** colors are suggested to be related to the application's accent color.

<a name="ios-config-wui-environment-swift"></a>

#### 4. Swift Class Integration `WUIEnvironment.swift`

Copy the file `src/wui-js/environment/ios/WUIEnvironment.swift` into the Xcode project.

> [!NOTE]
> Add the file to the Xcode target's **Sources** build phase. Do not add it as a bundle resource.

<a name="ios-config-wui-environment-js"></a>

#### 5. JavaScript Class Integration `wui-environment-0.2.js`

Copy the contents of the `src/wui-js/environment/web/` directory to the `assets/` directory of the Xcode project. The following structure is recommended:

- `package/assets/libraries/wui-js/environment/web/wui-environment-0.2.js`
- `package/assets/libraries/wui-js/environment/demo/index.html`

The above ensures that the initialization examples work correctly.

<a name="ios-config-packageapp"></a>

#### 6. PackageApp Initialization `packageApp.swift`

The name of the `packageApp.swift` file changes depending on the package name assigned to the project.

Use `.onOpenURL` to intercept Deep Link URLs and forward them to the bridge via `NotificationCenter`. This is the correct place to handle URL opening in a SwiftUI app.

```swift
import SwiftUI

extension Notification.Name {
	static let wuiDeepLink = Notification.Name("WUIDeepLink")
}

@main
struct packageApp: App {
	var body: some Scene {
		WindowGroup {
			MainView()
				.onOpenURL { url in
					NotificationCenter.default.post(name: .wuiDeepLink, object: url)
				}
		}
	}
}
```

<a name="ios-config-mainview"></a>

#### 7. MainView Initialization `MainView.swift`

The filename `MainView.swift` is optional; however, it should be consistent with the name of the function called from `packageApp.swift`.

```swift
import SwiftUI
import UIKit
import WebKit

extension Notification.Name {
	static let wuiDeepLink = Notification.Name("WUIDeepLink")
}

struct MainView: View {
	var body: some View {
		EnvironmentView().ignoresSafeArea().onOpenURL { url in
			// Forward Deep Link URLs to WUIEnvironment via NotificationCenter.
			// .onOpenURL handles both app-launch and in-app URL delivery in SwiftUI.
			NotificationCenter.default.post(name: .wuiDeepLink, object: url)
		}
	}
}

struct EnvironmentView: UIViewControllerRepresentable {

	func makeUIViewController(context: Context) -> EnvironmentViewController {
		EnvironmentViewController()
	}

	func updateUIViewController(_ uiViewController: EnvironmentViewController, context: Context) {}
}

class EnvironmentViewController: UIViewController {

	private var wuiEnvironment: WUIEnvironment?

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return wuiEnvironment?.preferredStatusBarStyle ?? .default
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		wuiEnvironment = WUIEnvironment(viewController: self)

		// Load home page

		// comment out the following line after validating the test
		let path = "assets/libraries/wui-js/environment/demo/index.html"
		// uncomment the following line after validating the test
		//let path = "assets/pages/index.html"
		wuiEnvironment?.openURL(url: Bundle.main.bundleURL.appendingPathComponent(path).absoluteString)

		// Request basic permissions
		
		wuiEnvironment?.requestPermission(type: "notifications") { granted in }
		wuiEnvironment?.requestPermission(type: "location") { granted in }
		//wuiEnvironment?.requestPermission(type: "camera") { granted in }

		// Add deep link listener

		NotificationCenter.default.addObserver(self, selector: #selector(handleDeepLink(_:)), name: .wuiDeepLink, object: nil)
	}

	deinit {

		// Remove deep link listener

		NotificationCenter.default.removeObserver(self, name: .wuiDeepLink, object: nil)
	}

	// Forward deep link

	@objc private func handleDeepLink(_ notification: Notification) {
		wuiEnvironment?.saveDeepLink(url: notification.object as? URL)
	}
}
```

<a name="web"></a>

## Web Library

Version: `0.2`

The web implementation uses the JavaScript class `WUIEnvironment` as its source, which must be included in every HTML page that uses the bridge. Copy `wui-environment-0.2.js` to the project's assets folder and load it with a `<script>` tag before any bridge calls:

### Sources

| Type | File |
|:----:| ---- |
| JS   | [src/wui-js/environment/web/wui-environment-0.2.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.2.js) |

<a name="web-properties"></a>

### JavaScript Properties

Public fields and getter/setter properties of the `WUIEnvironment` instance.

| Property            | Type             | Default value                                             | Description |
| ------------------- | ---------------- | --------------------------------------------------------- | ----------- |
| `userAgent`         | `string`         | `navigator.userAgent`                                     | (get)<br><br>Raw user agent string. Resolved at construction time. |
| `platform`          | `string`         | `navigator.userAgentData?.platform \| navigator.platform` | (get)<br><br>Platform string from the browser or OS. Resolved at construction time. |
| `systemName`        | `string`         | `""`                                                      | (get)<br><br>Normalized OS name derived from `platform`: `"iOS"`, `"Android"`, `"macOS"`, `"Linux"`, `"Windows Phone"`, `"Windows"`, or `""`. Resolved at construction time. |
| `environment`       | `string`         | `"web"`                                                   | (get)<br><br>Runtime environment identifier: `"local.android"` when running in an Android WebView, `"local.ios"` when running in an iOS WKWebView, or `"web"` otherwise. Resolved at construction time. |
| `localStorage`      | `boolean`        | `true`                                                    | (get/set)<br><br>When `true`, `saveFile`, `readFile`, and `removeFile` use `window.localStorage` as fallback on web. Has no effect inside a native WebView. |
| `onReady`           | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired once all pending bridge requests have resolved. Receives the total request count as argument. If assigned after all requests are already resolved, fires immediately. |
| `onDownloadFile`    | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired when a file download initiated from the WebView completes. Receives `{ filename, mimetype, uri }`. Must be assigned before loading the first page. |
| `onReceiveDeepLink` | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired when the app receives a Deep Link URL. Receives the URL as a string. Must be assigned before loading the first page. |

<a name="web-class-methods"></a>

### JavaScript Class Methods

Static members of the `WUIEnvironment` class.

| Member           | Type            | Description |
| ---------------- | --------------- | ----------- |
| `version`        | `string`        | Library version: `"0.1"`. |
| `response(args)` | `static method` | Entry point for native-to-JS communication. Called internally by the native bridge to deliver request responses and dispatch `onDownloadFile` / `onReceiveDeepLink` events. Not intended to be called from application code. |

<a name="web-instance-methods"></a>

### JavaScript Instance Methods

| Method                  | Return type               | Description |
| ----------------------- | ------------------------- | ----------- |
| `requestPermission`     | `Promise<boolean>`        | `requestPermission(type[, done])`<br><br>Arguments:<br>**• type:** `string`, one of `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• done:** `function` *optional*, callback.<br><br>Requests the system permission for the given type. Inside a native WebView delegates to the bridge (`requestPermission`). On web falls back to `navigator.permissions.query`. Resolves with `true` when granted. |
| `isLocal`               | `boolean`                 | `isLocal()`<br><br>Returns `true` when running inside a native WebView (`local.android` or `local.ios`). Returns `null` on web. Resolved synchronously at call time from the value set at construction. |
| `isMobile`              | `boolean`                 | `isMobileEnvironment()`<br><br>Returns `true` when running on a mobile device (Android, iOS or Windows Phone). Returns `false` on web. Resolved synchronously at call time from the value set at construction. |
| `isTouch`               | `boolean`                 | `isTouch()`<br><br>Returns `true` when running on a device with a touch screen. Returns `false` on web. Resolved synchronously at call time from the value set at construction. |
| `isTablet`              | `boolean`                 | `isTablet()`<br><br>Returns `true` when running on a tablet device (Android, iOS or Windows Phone). Returns `false` on web. Resolved synchronously at call time from the value set at construction. |
| `isAppInForeground`     | `Promise<boolean>`        | `isAppInForeground([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Checks whether the application is in the foreground. Returns `null` on web. |
| `getDeviceInfo`         | `Promise<Object>`         | `getDeviceInfo([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Gets hardware information (UUID, model, platform, etc.). On web returns `{ platform: systemName }`. |
| `getDisplayInfo`        | `Promise<Object>`         | `getDisplayInfo([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Gets screen metrics and navigation mode. On web returns `{ width, height, notch: false ... }`. |
| `getAppInfo`            | `Promise<Object>`         | `getAppInfo([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Gets application metadata. Returns `null` on web. |
| `getPermissionsStatus`  | `Promise<Object>`         | `getPermissionsStatus([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Queries the status of system permissions. On web uses `navigator.permissions` when available. |
| `getCurrentPosition`    | `Promise<Object>`         | `getCurrentPosition([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Gets the current GPS location. On web uses `navigator.geolocation`. |
| `getConnectionStatus`   | `Promise<boolean>`        | `getConnectionStatus([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Checks whether there is an active internet connection. On web uses `navigator.onLine`. |
| `setStatusbarStyle`     | `void`                    | `setStatusbarStyle(color, darkIcons[, done])`<br><br>Arguments:<br>**• color:** `string`, color in HEX format or resource ID.<br>**• darkIcons:** `boolean`, dark icons.<br>**• done:** `function` *optional*, callback.<br><br>Changes the color and style of the status bar. No-op on web. |
| `setNavigationbarStyle` | `void`                    | `setNavigationbarStyle(color, darkIcons[, done])`<br><br>Arguments:<br>**• color:** `string`, color in HEX format or resource ID.<br>**• darkIcons:** `boolean`, dark icons.<br>**• done:** `function` *optional*, callback.<br><br>Changes the color and style of the navigation bar. No-op on web. |
| `setAppBadge`           | `Promise<void>`           | `setAppBadge(number[, done])`<br><br>Arguments:<br>**• number:** `number`, non-negative badge count. `0` clears the badge.<br>**• done:** `function` *optional*, callback.<br><br>Sets or clears the application icon badge. On web uses the Badging API (`navigator.setAppBadge` / `navigator.clearAppBadge`) when available. |
| `saveFile`              | `Promise<boolean>`        | `saveFile(name, content[, done])`<br><br>Arguments:<br>**• name:** `string`, file name.<br>**• content:** `string\|Object`, content (Objects are JSON-stringified for `.json` files).<br>**• done:** `function` *optional*, callback.<br><br>Saves a file to native storage. On web uses `localStorage` if `localStorage` is `true`. |
| `readFile`              | `Promise<string\|Object>` | `readFile(name[, done])`<br><br>Arguments:<br>**• name:** `string`, file name.<br>**• done:** `function` *optional*, callback.<br><br>Reads a file from native storage. `.json` files are parsed automatically. On web uses `localStorage` if `localStorage` is `true`. |
| `removeFile`            | `Promise<boolean>`        | `removeFile(name[, done])`<br><br>Arguments:<br>**• name:** `string`, file name.<br>**• done:** `function` *optional*, callback.<br><br>Deletes a file from native storage. On web uses `localStorage`. |
| `openAppSettings`       | `void`                    | `openAppSettings([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Opens the application settings screen. No-op on web. |
| `openURL`               | `void`                    | `openURL(url)`<br><br>Arguments:<br>**• url:** `string`, the destination URL or local asset path.<br><br>Opens a local resource in the WebView or an external link. On web opens via `window.open`. |
| `readDeepLink`          | `Promise<string>`         | `readDeepLink([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Reads the last received Deep Link URL. Returns `null` on web. |
| `clearDeepLink`         | `void`                    | `clearDeepLink([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Clears the stored Deep Link URL. No-op on web. |
| `log`                   | `void`                    | `log(message[, force])`<br><br>Arguments:<br>**• message:** `any`, value to log (coerced to string).<br>**• force:** `boolean` *optional*, default `false`. When `true`, instructs the native side to bypass its `developMode` restriction and always write the message.<br><br>Inside a native WebView forwards the message to the native logger (Logcat / Xcode console). On web falls back to `console.log`. |

<a name="web-usage"></a>

### JavaScript Usage

```html
<!DOCTYPE html>
<html>
<head>
	<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
</head>
<body>
	<script>
		const env = new WUIEnvironment();
		env.getDeviceInfo(function(info) {
			console.log("Platform:", info.platform);
		});
	</script>
</body>
</html>
```

> [!NOTE]
> The `src` path is relative to the HTML file. For Android, assets are loaded from `app/src/main/assets/`; for iOS, from the `assets/` folder added to the Xcode target. The recommended path `libraries/wui-js/environment/web/wui-environment-0.2.js` matches the structure described in the installation steps.

**Bridge behavior by platform:**

- **Android**: calls are **synchronous** — `Android.request()` returns the result immediately.
- **iOS**: calls are **asynchronous** — the native side calls `WUIEnvironment.response()` when done.

The JS library abstracts both into the same callback-based API.

```js
const env = new WUIEnvironment();

// Configure event handlers before loading the first page

env.onReady = function(count) {
	console.log("All", count, "requests resolved");
};
env.onDownloadFile = function(args) {
	console.log("Downloaded:", args.filename, args.mimetype, args.uri);
};
env.onReceiveDeepLink = function(url) {
	console.log("Deep Link received:", url);
};

// Use onReady to wait for all initial requests to settle

env.getDeviceInfo(function(info) {
	console.log("Platform:", info.platform);
});
env.getDisplayInfo(function(display) {
	console.log("Notch:", display.notch);
	console.log("Status bar height:", display.statusbarHeight);
});
env.getConnectionStatus(function(connected) {
	console.log("Connected:", connected);
});
env.getCurrentPosition(function(position) {
	if (position.error) {
		console.error("Location error:", position.error);
	} else {
		console.log("Lat:", position.latitude, "Lon:", position.longitude);
	}
});
```

> [!NOTE]
> When testing `getCurrentPosition` on the Android Simulator, a simulated location must be configured: **Simulator menu → Extended controls → Location**, on the iOS Simulator, it must be configured in: **Simulator menu → Features → Location**
