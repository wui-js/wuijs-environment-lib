> [!IMPORTANT]
> The GitHub account `@wuiproject` was migrated to `@wui-js` to match the name with the NPM account.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)
---

# Change Log

## [v0.5.0] - 2026-07-20

Features:

- Synchronized the versions of the Java, Swift, and JavaScript libraries.
1. **Web** - Updated the JavaScript library to version `0.3`.
	- Improved detection of `#systemName` in the constructor for reliable cross-platform results. iOS/Android are now detected via `userAgent` (fixes iPad on iOS 13+ reporting `platform = "MacIntel"`); `#platform` is normalized to lowercase before matching desktop platforms (`macOS`, `Windows Phone`, `Windows`, `Linux`).
	- Improved detection of permission status for contacts in the `getPermissionsStatus()` method.
	- Fixed typo in `isLocal()`: was calling `isLocalagent()` instead of `isLocalAgent()`.
	- Added `isLocalAgent()` method: returns `true` when the environment is `local.android` or `local.ios`.
	- Added `isLocalHost()` method: returns `true` when `location.hostname` is `localhost` or `127.0.0.1`.
	- Forced camelCase naming for acronym in public method: `openURL()` → `openUrl()`.
2. **Android** - Updated the Java library to version `0.5`.
	- Forced camelCase naming for acronym in public method: `openURL()` → `openUrl()`. Also updated the internal JS↔native RPC protocol string (`func: "openURL"` → `func: "openUrl"`) to keep parity with the Web layer change.
	- Forced camelCase naming for acronyms in private methods: `getDeviceID()` → `getDeviceId()`, `getDeviceUUID()` → `getDeviceUuid()`.
3. **iOS** - Updated the Swift library to version `0.5`.
	- Forced camelCase naming for acronym in public method: `openURL(url:)` → `openUrl(url:)`. Also updated the internal JS↔native RPC protocol string (`case "openURL"` → `case "openUrl"`) to keep parity with Android and the Web layer.

## [v0.4.0] - 2026-05-14

Features:

1. **Android** - Updated the Java library to version `0.4`.
	- Bug fixes:
		- Improved the WebView SSL error handler implementation to comply with the [Device and Network Abuse policy](https://support.google.com/googleplay/android-developer/answer/16559646).

## [v0.3.1] - 2026-05-06

Features:

1. Release of the official documentation site for WUI/JS: [https://docs.wuijs.dev](https://docs.wuijs.dev)

## [v0.3.0] - 2026-04-28

Features:

1. **Android** - Updated the Java library to version `0.3`.
	- File input with camera support: `onShowFileChooser` now presents a native `AlertDialog` with two options ("Take photo" / "Choose from gallery"). Each option launches its intent directly from the `Activity` via separate request codes (`CAMERA_REQUEST_CODE` = 2001, `FILE_CHOOSER_REQUEST_CODE` = 2000), ensuring `onActivityResult` receives the result correctly. Camera permission is requested at the moment the user selects "Take photo". The host `Activity` must implement `onActivityResult` and call `wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data)`.
	- Bug fixes:
		- `requestPermission()` crash with `null` callback calling `requestPermission(type, null)` from native code caused a `NullPointerException` on Android < 13 (notifications) and on `default`/`allGranted` paths. All `callback.accept()` calls are now guarded with a null check.
	- Code quality:
		- `setupWebViewSettings()`: removed unused `developMode` parameter.
		- `setupDownloadHandler()`: converted anonymous `DownloadListener` to lambda; removed the unreachable empty `data:` branch.
		- `setStatusbarStyle()`, `setNavigationbarStyle()`, `openURL()`: converted anonymous `Runnable` to lambdas.
		- `setNavigationbarStyle()`: removed unnecessary `SDK_INT >= O` guard (always true given minSdk).
		- `getDisplayInfo()`: removed unnecessary `SDK_INT >= M` wrapper (always true given minSdk).
		- `getCurrentPosition()`: converted anonymous `Consumer<Location>` to lambda; added `@SuppressLint("MissingPermission")` (permission already checked via `requestPermissionSync`).
		- `handlePermissionResult()`: added `@SuppressWarnings("unused")` on the `permissions` parameter.
		- `requestPermissionSync()`: handle ignored return value of `CountDownLatch.await()`.
		- `setupDownloadHandler()`: null-check `getParentFile()` before `mkdirs()`; handle return value of `mkdirs()` on the downloads directory.
		- `saveFile()` / `readFile()`: replaced `"UTF-8"` string literal with `StandardCharsets.UTF_8`.
		- Fixed typo in log message: `"File readed"` → `"File read"`.

2. **iOS** - Updated the Swift library to version `0.3`.
	- Bug fixes:
		- `isAppInForeground()` returns `false` while app is in foreground: the check `applicationState == .active` excluded the `.inactive` state, which covers foreground transitions (initial load, incoming call, app switcher). Changed to `applicationState != .background` so any non-backgrounded state returns `true`.

## [v0.2.0] - 2026-04-26

Features:

1. **Android** - Updated `getDisplayInfo()` method.
	- Added `statusbarOverlay` key: `true` when content renders behind the status bar. Detected via `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, or a status bar color with alpha < 255. Covers OEM devices (e.g. C2250) that apply a transparent status bar without setting the classic translucent flag.
	- Added `navigationbarOverlay` key: `true` when content renders behind the navigation bar. Detected via `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, or a navigation bar color with alpha < 255. Covers OEM devices (e.g. C2250) that apply semi-transparent overlay bars without setting the classic translucent flag.

2. **iOS** - Updated `getDisplayInfo()` method.
	- Added `statusbarOverlay` key: `true` when no opaque UIView covers the status bar area (`statusbarTransparent`) or when `safeAreaInsets.top` is zero (no visible status bar).
	- Added `navigationbarOverlay` key: `true` when no opaque UIView covers the navigation area (`navigationbarTransparent`) or when `safeAreaInsets.bottom` is zero (devices with home button or landscape without gesture bar).

3. **Web** - Updated `getDisplayInfo()` method.
	- Force boolean return type for `isLocal()`, `isMobile()` and `isTouch()` methods.

## [v0.1.0] - 2026-04-25

Features:

1. Release version.