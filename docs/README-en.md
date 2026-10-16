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
| **Library version**  | `0.6.0` ([Change Log](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md)) |
| **NPM package**      | `@wui-js/environment` ([npm](https://www.npmjs.com/package/@wui-js/environment)) |
| **Document version** | `0.6.0.20261016.0` |
| **License**          | `Apache License 2.0` |
| **Author**           | `Sergio E. Belmar V. <wuijs.project@gmail.com>` |
| **Repository**       | [https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib) |
| **Documentation**    | [https://docs.wuijs.dev](https://docs.wuijs.dev) |
| **Website**          | [https://wuijs.dev](https://wuijs.dev) |

## Index

*   [Overview](#overview)
	*   [About the WUI/JS Project](#project)
	*   [Classes Table](#classtable)
	*   [Directory Map](#dirmap)
*   [Quick Start](#quickstart)
	*   [Android + Web](#quickstart-android)
	*   [iOS + Web](#quickstart-ios)
	*   [App Templates](#quickstart-templates)
*   [Classes](#classes)
	*   [WUIEnvironment (Android)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md)
	*   [WUIEnvironment (iOS)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md)
	*   [WUIEnvironment (Web)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md)

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

<a name="classtable"></a>

### Classes Table

| Class Name                                                                                                                         | Platform | Version | Description |
| ---------------------------------------------------------------------------------------------------------------------------------- | -------- |:-------:| ----------- |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md) | Android  | `0.6`   | Java bridge class for Android (WebView). |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md)     | iOS      | `0.6`   | Swift bridge class for iOS (WKWebView). |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md)     | Web      | `0.6`   | JavaScript class, web counterpart of the Android and iOS classes. |

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
├── src/
│   └── wui-js/
│       └── environment/
│           ├── android/
│           ├── ios/
│           ├── web/
│           └── demo/
├── templates/
│   ├── app.myapp.android/
│   └── app.myapp.ios/
└── tools/
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
| [templates](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/)                                           | Minimal Android Studio and Xcode projects that run the demo page with the latest version of the library. |
| [templates/app.myapp.android](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/app.myapp.android/)       | Android template (Java, Gradle). |
| [templates/app.myapp.ios](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/app.myapp.ios/)               | iOS template (Swift, SwiftUI). |
| [tools](https://github.com/wui-js/wuijs-environment-lib/tree/main/tools/)                                                   | Maintenance scripts (`sync-templates.sh` copies the current sources into the templates). |

> [!NOTE]
> The `wuijs-environment-lib` library operates jointly, meaning the **Android + Web** or **iOS + Web** combination must be implemented for it to work correctly.

### Sources

| Type  | Version | File |
| ----- | :------:| ---- |
| Java  | 0.6     | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |
| Swift | 0.6     | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |
| JS    | 0.6     | [src/wui-js/environment/web/wui-environment-0.6.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.6.js) |

<a name="quickstart"></a>

## Quick Start

Minimal integration for a new project. For full configuration details see the platform-specific sections below.

<a name="quickstart-android"></a>

### Android + Web

**Prerequisites:** Android Studio, new project with `AppCompatActivity` and `minSdk ≥ 24`.

1. Clone the library and copy `src/wui-js/environment/android/WUIEnvironment.java` to `app/src/main/java/your/package/name/`. Edit the first line to match your package ID.
2. Copy `src/wui-js/environment/web/` and `src/wui-js/environment/demo/` to `app/src/main/assets/libraries/wui-js/environment/`.
3. Add permissions, colors, and Gradle config as described in [Installation and Setup](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-install).
4. Initialize in `MainActivity.java`:

```java
wuiEnvironment = new WUIEnvironment(this);
wuiEnvironment.openUrl("file:///android_asset/libraries/wui-js/environment/demo/index.html");
wuiEnvironment.saveDeepLink(getIntent());
```

5. In your own HTML pages, include the JS class and instantiate it:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.6.js"></script>
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
3. Add permission keys, color sets, and Deep Link config as described in [Installation and Setup](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-install).
4. Initialize in `EnvironmentViewController` inside `MainView.swift`:

```swift
wuiEnvironment = WUIEnvironment(viewController: self)
wuiEnvironment?.openUrl(url: Bundle.main.bundleURL.appendingPathComponent("assets/libraries/wui-js/environment/demo/index.html").absoluteString)
```

5. In your own HTML pages, include the JS class and instantiate it:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.6.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Platform:", info.platform, "| Model:", info.model);
	});
</script>
```

> [!NOTE]
> Open the demo page first (`demo/index.html`) to verify the bridge works before switching to your production HTML.

<a name="quickstart-templates"></a>

### App Templates

The [templates](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/) directory contains two minimal projects that load the demo page (`src/wui-js/environment/demo/index.html`) with the latest version of the library already integrated:

| Template | Opens with | Package / Bundle ID | Requirements |
| -------- | ---------- | ------------------- | ------------ |
| `app.myapp.android` | Android Studio | `app.myapp` | Android SDK 36, JDK 17+ (the one bundled with Android Studio), minSdk 24. |
| `app.myapp.ios` | Xcode (`MyApp.xcodeproj`) | `app.myapp` | Xcode 16+, iOS 18.5+. |

They are meant as a starting point for a new hybrid app: they contain only the bridge class, the JavaScript class, the demo page, the WUI/JS logo as app icon and the required configuration (colors, permissions, `FileProvider`, Deep Link scheme `myapp`). See [templates/README.md](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README.md) for the steps to rename them.

<a name="android"></a>

## Android Library

Version: `0.6`

The Android library uses **WebView** as its rendering engine.

### Sources

| Type | File |
|:----:| ---- |
| Java | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |

<a name="android-constructor"></a>

### Java Constructor

| Constructor | Description |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Initializes the WUI environment with default settings. `developMode = true` allows SSL with untrusted certificates, enables debug logging and enables WebView inspection with Chrome DevTools (`chrome://inspect`). **Do not use `true` in production** — it disables certificate validation for the entire WebView. |

<a name="android-methods"></a>

### Java Methods

| Method                   | Return type  | Description |
| ------------------------ | ------------ | ----------- |
<a name="classes"></a>

## Classes

The documentation of each class is in its own document, in the [`docs/classes/`](https://github.com/wui-js/wuijs-environment-lib/tree/main/docs/classes) directory. `WUIEnvironment` has one document per platform:

*   WUIEnvironment
	*   <a name="android"></a>[Android](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md)
		*   <a name="android-constructor"></a>[Java Constructor](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-constructor)
		*   <a name="android-methods"></a>[Java Methods](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-methods)
		*   <a name="android-events"></a>[Android Events](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-events)
		*   <a name="android-dialogs"></a>[JavaScript Dialogs](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-dialogs)
		*   <a name="android-install"></a>[Installation and Setup](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-install)
			1.   <a name="android-clone"></a>[Clone the library](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-clone)
			2.   <a name="android-config-project"></a>[Project Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-project)
			3.   <a name="android-config-module"></a>[Module Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-module)
			4.   <a name="android-config-manifest"></a>[Manifest Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-manifest)
			5.   <a name="android-config-colors"></a>[Colors Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-colors)
			6.   <a name="android-config-wui-environment-java"></a>[Java Class Integration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-wui-environment-java)
			7.   <a name="android-config-wui-environment-js"></a>[JavaScript Class Integration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-wui-environment-js)
			8.   <a name="android-config-mainactivity"></a>[MainActivity Initialization](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-en.md#android-config-mainactivity)
	*   <a name="ios"></a>[iOS](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md)
		*   <a name="ios-constructor"></a>[Swift Constructor](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-constructor)
		*   <a name="ios-methods"></a>[Swift Methods](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-methods)
		*   <a name="ios-events"></a>[iOS Events](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-events)
		*   <a name="ios-dialogs"></a>[JavaScript Dialogs](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-dialogs)
		*   <a name="ios-install"></a>[Installation and Setup](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-install)
			1.   <a name="ios-clone"></a>[Clone the library](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-clone)
			2.   <a name="ios-config-permissions"></a>[Permissions Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-permissions)
			3.   <a name="ios-config-colors"></a>[Colors Configuration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-colors)
			4.   <a name="ios-config-wui-environment-swift"></a>[Swift Class Integration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-wui-environment-swift)
			5.   <a name="ios-config-wui-environment-js"></a>[JavaScript Class Integration](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-wui-environment-js)
			6.   <a name="ios-config-packageapp"></a>[PackageApp Initialization](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-packageapp)
			7.   <a name="ios-config-mainview"></a>[MainView Initialization](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-en.md#ios-config-mainview)
	*   <a name="web"></a>[Web](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md)
		*   <a name="web-properties"></a>[JavaScript Properties](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md#web-properties)
		*   <a name="web-class-methods"></a>[JavaScript Class Methods](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md#web-class-methods)
		*   <a name="web-instance-methods"></a>[JavaScript Instance Methods](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md#web-instance-methods)
		*   <a name="web-usage"></a>[JavaScript Usage](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-en.md#web-usage)
