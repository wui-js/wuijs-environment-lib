[English](wui-environment-ios-en.md) | [Español](wui-environment-ios-es.md)

[wuijs-environment-lib](../../README-en.md)

Platforms: [Android](wui-environment-android-en.md) | [iOS](wui-environment-ios-en.md) | [Web](wui-environment-web-en.md)

# WUIEnvironment (iOS)

Version: `0.6`

The iOS implementation uses WebKit (WKWebView) as its rendering engine and communicates via `WKScriptMessageHandler`.

> [!NOTE]
> **`file://` XHR limitation in WKWebView:** WKWebView blocks all `XMLHttpRequest` calls to `file://` URLs regardless of the `allowingReadAccessTo` setting. `WUIEnvironment` automatically injects a `WKUserScript` at document start that intercepts these requests and routes them through the native bridge via `webkit.messageHandlers.request`. This is transparent to your JavaScript code — `XMLHttpRequest` works as expected for both local files and remote URLs.

## Sources

| Type  | File |
|:-----:| ---- |
| Swift | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |

<a name="ios-constructor"></a>

## Swift Constructor

| Constructor | Description |
| ----------- | ----------- |
| `WUIEnvironment(viewController: UIViewController[, developMode: Bool])` | Initializes the WUI environment. `developMode = true` allows SSL with untrusted certificates, enables debug logging and enables WKWebView inspection with Safari Web Inspector (iOS 16.4+). **Do not use `true` in production** — it disables certificate validation for the entire WKWebView. |

<a name="ios-methods"></a>

## Swift Methods

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
| `openUrl`               | `void`          | `openUrl(url)`<br><br>Arguments:<br>**• url:** `String`, destination URL or local file path (`file://...`).<br><br>Loads a local file in the WKWebView via `loadFileURL` or opens an external URL via `UIApplication.shared.open`. |
| `saveDeepLink`          | `void`          | `saveDeepLink(url)`<br><br>Arguments:<br>**• url:** `URL?`, URL received in `scene(_:openURLContexts:)` or `application(_:open:)`.<br><br>Extracts and stores the Deep Link URL. If the page is already loaded, it is sent to JavaScript immediately. |
| `sendDeepLink`          | `void`          | `sendDeepLink()`<br><br>Sends the stored Deep Link URL to JavaScript by calling `WUIEnvironment.response()`. Only acts if the page is already loaded. |
| `readDeepLink`          | `String?`       | `readDeepLink()`<br><br>Returns the last stored Deep Link URL, or `nil` if none is stored. |
| `clearDeepLink`         | `void`          | `clearDeepLink()`<br><br>Clears the stored Deep Link URL. |
| `downloadFile`          | `void`          | `downloadFile(url:filename:headers:key:)`<br><br>Arguments:<br>**• url:** `String`, file URL.<br>**• filename:** `String`, suggested file name; if empty, it is taken from `Content-Disposition` or the URL.<br>**• headers:** `[String: String]`, HTTP headers sent with the request (e.g. `Authorization`).<br>**• key:** `String?` *optional*, download identifier sent back in the `onDownloadProgress` and `onDownloadFile` events (`nil` if omitted).<br><br>Downloads a file with `URLSession` sending the given HTTP headers. Several downloads can run at the same time. A non-2xx response fires `onDownloadFile` with `status: "failed"` and `httpStatus`. It fires the same `onDownloadProgress` and `onDownloadFile` events as a download initiated from the WebView, and can be cancelled with `cancelDownload(key:)`. Header values are not logged. |
| `cancelDownload`        | `void`          | `cancelDownload(key:)`<br><br>Arguments:<br>**• key:** `String?` *optional*. Download to cancel; if `nil`, all downloads in progress are cancelled.<br><br>Cancels downloads in progress. A cancelled download fires `onDownloadFile` with `status: "cancelled"`. **Pending testing.** |
| `log`                   | `void`          | `log(_ message[, force])`<br><br>Arguments:<br>**• message:** `String` (autoclosure), message to log.<br>**• force:** `Bool` *optional*, default `false`. When `true`, bypasses the `developMode` restriction and always writes to the Xcode console.<br><br>Forwards the message to the Xcode console with the `[WUIEnvironment][js]` prefix. Only active when `developMode = true` unless `force` overrides it. |

<a name="ios-events"></a>

## iOS Events

Events are callbacks that the native side sends to JavaScript when an asynchronous action completes. They must be configured on the `WUIEnvironment` instance before loading the first page.

| Event                | Arguments                                                    | Description |
| -------------------- | ------------------------------------------------------------ | ----------- |
| `onDownloadProgress` | `key`, `loaded`, `total`                                     | Fired about every 250 ms while a file download initiated from the WebView is in progress. `loaded` is the number of bytes received and `total` the file size in bytes, or `-1` if unknown. `key` is the identifier passed to `downloadFile()`, or `null` for downloads initiated from the WebView. |
| `onDownloadFile`     | `key`, `filename`, `mimetype`, `uri`, `status`, `httpStatus` | Fired when a file download initiated from the WebView ends. `status` is `"success"`, `"failed"` or `"cancelled"`; `uri` is `null` when it is not `"success"`. `httpStatus` is the HTTP code when a `URLSession` download failed because of a non-2xx response, or `null`. On success the file is saved to `Documents/Downloads/` inside the app sandbox and opened via `UIActivityViewController`. Requires iOS 14.5+ for `WKDownloadDelegate`; a `URLSession` fallback is used on earlier versions. `key` is the identifier passed to `downloadFile()`, or `null` for downloads initiated from the WebView. |
| `onReceiveDeepLink`  | `url`                                                        | Fired when the application receives a Deep Link URL (on launch or while running). |

<a name="ios-dialogs"></a>

## JavaScript Dialogs

`WUIEnvironment` intercepts standard JavaScript dialogs (`alert()`, `confirm()`, `prompt()`) and renders them via native `UIAlertController`. WKWebView silently discards these dialogs when `WKUIDelegate` does not implement the corresponding panel handlers — `WUIEnvironment` provides them.

| Dialog                     | Native behavior |
| -------------------------- | --------------- |
| `alert(message)`           | Displays `UIAlertController` with the message and an **OK** button. |
| `confirm(message)`         | Displays `UIAlertController` with **OK** / **Cancel** buttons. Returns `true` / `false` to JavaScript. |
| `prompt(message, default)` | Displays `UIAlertController` with a text input and **OK** / **Cancel** buttons. Returns the entered string or `null` on cancel. |

<a name="ios-install"></a>

## Installation and Setup

<a name="ios-clone"></a>

### 1. Clone the library

Clone the repository from GitHub if it has not been cloned previously:

```bash
git clone --branch v0.6.0 https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> The repository will contain all 3 classes: Java for Android, Swift for iOS, and JavaScript as the web counterpart.

<a name="ios-config-permissions"></a>

### 2. Permissions Configuration (`Info.plist` or `project.pbxproj`)

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

### 3. Colors Configuration in `Assets.xcassets`

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

### 4. Swift Class Integration `WUIEnvironment.swift`

Copy the file `src/wui-js/environment/ios/WUIEnvironment.swift` into the Xcode project.

> [!NOTE]
> Add the file to the Xcode target's **Sources** build phase. Do not add it as a bundle resource.

<a name="ios-config-wui-environment-js"></a>

### 5. JavaScript Class Integration `wui-environment-0.6.js`

Copy the contents of the `src/wui-js/environment/web/` directory to the `assets/` directory of the Xcode project. The following structure is recommended:

- `package/assets/libraries/wui-js/environment/web/wui-environment-0.6.js`
- `package/assets/libraries/wui-js/environment/demo/index.html`

The above ensures that the initialization examples work correctly.

<a name="ios-config-packageapp"></a>

### 6. PackageApp Initialization `packageApp.swift`

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

### 7. MainView Initialization `MainView.swift`

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
		wuiEnvironment?.openUrl(url: Bundle.main.bundleURL.appendingPathComponent(path).absoluteString)

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
