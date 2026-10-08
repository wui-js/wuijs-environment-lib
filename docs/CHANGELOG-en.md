> [!IMPORTANT]
> The GitHub account `@wuiproject` was migrated to `@wui-js` to match the name with the NPM account.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)
---

# Change Log

## [v0.6.0] - 2026-10-08

Features:

1. **Web** - Updated the JavaScript library to version `0.6`.
	- Added the `onDownloadProgress` property (`function` or `null`), fired about every 250 ms during a download with `{ loaded, total }` (bytes; `total` is `-1` if unknown).
	- Added the `status` field (`"success"`, `"failed"` or `"cancelled"`) to the `onDownloadFile` arguments; `uri` is `null` when it is not `"success"`. The change is additive: consumers that ignore `status` keep working.
	- Added the `cancelDownload()` method to cancel the download in progress. **Pending testing.**
	- Added the `httpStatus` field to the `onDownloadFile` arguments: the HTTP code when the download failed because of an HTTP response (e.g. `401`), or `null`.
	- Support for several simultaneous downloads: `downloadFile(url, filename, headers, options)` returns a `key` per download and accepts `options = { onProgress, onFile }` with callbacks for that download only; `cancelDownload(key, done)` cancels only that download, or all of them without `key`. The `onDownloadProgress` and `onDownloadFile` events now include `key` (`null` for downloads initiated from the WebView) and are dispatched to the download callbacks, or to the global properties when there are none. Compatible with the previous calls: a `function` as fourth argument of `downloadFile()` or first argument of `cancelDownload()` is still used as `done`.
	- Added the `downloadFile(url, filename, headers, done)` method to download a file natively sending HTTP headers (e.g. `Authorization` for authenticated endpoints). It fires `onDownloadProgress` and `onDownloadFile` and can be cancelled with `cancelDownload()`. No-op on web.
	- Updated the demo page (`demo/index.html`): it loads `wui-environment-0.6.js` (it still loaded `0.1`), uses `openUrl()` (renamed from `openURL()` in 0.5), adds tests for `onDownloadProgress`, `downloadFile()` with its own callbacks, `cancelDownload()`, `setNavigationbarStyle()`, `requestPermission()`, `readDeepLink()` and `clearDeepLink()`, and respects the device safe area.
2. **Android** - Updated the Java library to version `0.6`.
	- Added the `onDownloadProgress` event: with `DownloadManager`, the download is polled every 250 ms (`COLUMN_BYTES_DOWNLOADED_SO_FAR` / `COLUMN_TOTAL_SIZE_BYTES`) in a background thread; when copying an asset file, it is fired from the copy loop.
	- Behavior change: with `DownloadManager`, `onDownloadFile`, the media scan and the opening of the file used to run when the download was enqueued, before the file existed. They now run when the download completes, and `onDownloadFile` is also fired when it fails or is cancelled, with the corresponding `status`. The file path is taken from `COLUMN_LOCAL_URI`.
	- The asset file copy now runs in a background thread instead of the UI thread.
	- Added the `cancelDownload()` method (`DownloadManager.remove()`, or interruption of the asset copy). **Pending testing.**
	- `onDownloadFile` sends `httpStatus` from `COLUMN_REASON` when `DownloadManager` fails with an HTTP code.
	- Several simultaneous `DownloadManager` downloads: the single `downloadId` was replaced by a map of download id → `key`, protected by the shared lock, and `cancelDownload(key)` cancels only the downloads of that `key` (all of them without `key`).
	- `cancelDownload()` no longer removes a download that has already completed: `downloadId` is protected by a lock shared with the tracking thread and the status is checked before `remove()`.
	- Fixed error (present since 0.5): the downloaded file was opened with `Uri.fromFile()`, which throws `FileUriExposedException` since Android 7, so it was never opened. It is now opened with a `content://` URI (`getUriForDownloadedFile()` for `DownloadManager`, `FileProvider` for asset files) and `FLAG_GRANT_READ_URI_PERMISSION`. The `uri` field of `onDownloadFile` is still the `file://` path. `res/xml/file_paths.xml` must declare `<external-path name="downloads" path="Download/" />`.
	- Added the `downloadFile(url, filename, headers)` method: `DownloadManager.Request` with `addRequestHeader()` for each header, tracked like the WebView downloads. If `filename` is empty it is taken from the URL, since `DownloadManager` needs the name before the request. Header values are not logged.
	- Documentation: the `MainActivity` integration example no longer overrides `onActivityResult`, which called the nonexistent `handleFileChooserResult()` method (the file chooser result is handled by an `ActivityResultLauncher` registered by the class); fixed the alternative path of the home page, which duplicated the `file:///android_asset/` prefix; and the public `handlePermissionResult()` method was added to the methods table.
	- `developMode` now also enables WebView inspection with Chrome DevTools (`WebView.setWebContentsDebuggingEnabled()`), in parity with `isInspectable` on iOS.
	- Fixed error: `onDownloadFile` reported the requested file name instead of the saved one when a file with the same name already existed (e.g. `download.pdf` instead of `download (1).pdf`).
3. **iOS** - Updated the Swift library to version `0.6`.
	- Added the `onDownloadProgress` event, observing `Progress.completedUnitCount` of `WKDownload` and of the `URLSession` fallback downloads.
	- Added the `status` field to `onDownloadFile`; it is now also fired when the download fails or is cancelled.
	- Added the `cancelDownload()` method (`WKDownload.cancel()` / `URLSessionDownloadTask.cancel()`). **Pending testing.**
	- `onDownloadFile` sends `httpStatus` when a `URLSession` download fails with a non-2xx response.
	- Several simultaneous downloads: the single current download was replaced by a dictionary per download (`URLSessionDownloadTask` or `WKDownload`, with its `key`) modified on the main thread, and `cancelDownload(key:)` cancels only that download (all of them with `nil`).
	- Fixed error: the `URLSession` completion handler (background queue) modified the download state (progress observations and current task) concurrently with the main thread. All download state is now modified on the main thread; the temporary file is still moved synchronously inside the handler.
	- Added the `downloadFile(url:filename:headers:)` method: `URLRequest` with the headers over the `URLSession` download. Header values are not logged.
	- `URLSession` downloads with a non-2xx response now fire `onDownloadFile` with `status: "failed"` instead of saving the response body as the file.

	- Fixed error: the progress of `URLSession` downloads was reported in percent units (`URLSessionTask.progress`) instead of bytes; `countOfBytesReceived` / `countOfBytesExpectedToReceive` are now observed.
	- Removed the `'task' mutated after capture by sendable closure` compiler warning in the `URLSession` download.
4. **Templates** - Added the `templates/` directory with the minimal `app.myapp.android` (Android Studio) and `app.myapp.ios` (Xcode) projects, which run the demo page with the latest version of the library, and the `tools/sync-templates.sh` script, which copies the current sources into both templates.

## [v0.5.1] - 2026-09-08

Features:

1. Added a `prepare` script to `package.json` so a git-tag install (`npm install github:wui-js/wuijs-environment-lib#vX.Y.Z`) produces the same flattened file layout as an npm-registry install.

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