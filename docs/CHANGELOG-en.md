# Change Log

## [v0.3.1] - 2026-05-06

Features:

1. Release of the official documentation site for WUI/JS: [https://docs.wuijs.dev](https://docs.wuijs.dev)

## [v0.3.0] - 2026-04-28

Features:

1. **Android — file input with camera support**: `onShowFileChooser` now presents a native `AlertDialog` with two options ("Take photo" / "Choose from gallery"). Each option launches its intent directly from the `Activity` via separate request codes (`CAMERA_REQUEST_CODE` = 2001, `FILE_CHOOSER_REQUEST_CODE` = 2000), ensuring `onActivityResult` receives the result correctly. Camera permission is requested at the moment the user selects "Take photo". The host `Activity` must implement `onActivityResult` and call `wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data)`.

Bug fixes:

1. **Android — `requestPermission()` crash with `null` callback**: calling `requestPermission(type, null)` from native code caused a `NullPointerException` on Android < 13 (notifications) and on `default`/`allGranted` paths. All `callback.accept()` calls are now guarded with a null check.
2. **iOS — `isAppInForeground()` returns `false` while app is in foreground**: the check `applicationState == .active` excluded the `.inactive` state, which covers foreground transitions (initial load, incoming call, app switcher). Changed to `applicationState != .background` so any non-backgrounded state returns `true`.

Code quality (Android):

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

## [v0.2.0] - 2026-04-26

Features:

1. Updated `getDisplayInfo()` method.
	- Added `statusbarOverlay` key:
		- **Android**: `true` when content renders behind the status bar. Detected via `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, or a status bar color with alpha < 255. Covers OEM devices (e.g. C2250) that apply a transparent status bar without setting the classic translucent flag.
		- **iOS**: `true` when no opaque UIView covers the status bar area (`statusbarTransparent`) or when `safeAreaInsets.top` is zero (no visible status bar).
	- Added `navigationbarOverlay` key:
		- **Android**: `true` when content renders behind the navigation bar. Detected via `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, or a navigation bar color with alpha < 255. Covers OEM devices (e.g. C2250) that apply semi-transparent overlay bars without setting the classic translucent flag.
		- **iOS**: `true` when no opaque UIView covers the navigation area (`navigationbarTransparent`) or when `safeAreaInsets.bottom` is zero (devices with home button or landscape without gesture bar).
2. Updated to force boolean return type for `isLocal()`, `isMobile()` and `isTouch()` methods in the JS library.

## [v0.1.0] - 2026-04-25

Features:

1. Release version.