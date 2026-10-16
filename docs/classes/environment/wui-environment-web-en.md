[English](wui-environment-web-en.md) | [Español](wui-environment-web-es.md)

[wuijs-environment-lib](../../README-en.md)

Platforms: [Android](wui-environment-android-en.md) | [iOS](wui-environment-ios-en.md) | [Web](wui-environment-web-en.md)

# WUIEnvironment (Web)

Version: `0.6`

The web implementation uses the JavaScript class `WUIEnvironment` as its source, which must be included in every HTML page that uses the bridge. Copy `wui-environment-0.6.js` to the project's assets folder and load it with a `<script>` tag before any bridge calls:

## Sources

| Type | File |
|:----:| ---- |
| JS   | [src/wui-js/environment/web/wui-environment-0.6.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.6.js) |

<a name="web-properties"></a>

## JavaScript Properties

Public fields and getter/setter properties of the `WUIEnvironment` instance.

| Property             | Type             | Default value                                             | Description |
| -------------------- | ---------------- | --------------------------------------------------------- | ----------- |
| `userAgent`          | `string`         | `navigator.userAgent`                                     | (get)<br><br>Raw user agent string. Resolved at construction time. |
| `platform`           | `string`         | `navigator.userAgentData?.platform \| navigator.platform` | (get)<br><br>Platform string from the browser or OS. Resolved at construction time. |
| `systemName`         | `string`         | `""`                                                      | (get)<br><br>Normalized OS name derived from `platform`: `"iOS"`, `"Android"`, `"macOS"`, `"Linux"`, `"Windows Phone"`, `"Windows"`, or `""`. Resolved at construction time. |
| `environment`        | `string`         | `"web"`                                                   | (get)<br><br>Runtime environment identifier: `"local.android"` when running in an Android WebView, `"local.ios"` when running in an iOS WKWebView, or `"web"` otherwise. Resolved at construction time. |
| `localStorage`       | `boolean`        | `true`                                                    | (get/set)<br><br>When `true`, `saveFile`, `readFile`, and `removeFile` use `window.localStorage` as fallback on web. Has no effect inside a native WebView. |
| `onReady`            | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired once all pending bridge requests have resolved. Receives the total request count as argument. If assigned after all requests are already resolved, fires immediately. |
| `onDownloadProgress` | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired about every 250 ms while a file download initiated from the WebView is in progress. Receives `{ key, loaded, total }`: bytes received and file size in bytes (`-1` if unknown). `key` is `null` for downloads initiated from the WebView. A download started with `downloadFile()` and its own `options` callbacks does not fire this property. |
| `onDownloadFile`     | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired when a file download initiated from the WebView ends. Receives `{ key, filename, mimetype, uri, status, httpStatus }`, where `status` is `"success"`, `"failed"` or `"cancelled"`, `uri` is `null` when it is not `"success"`, and `httpStatus` is the HTTP code when the download failed because of an HTTP response (e.g. `401`), or `null`. Must be assigned before loading the first page. `key` is `null` for downloads initiated from the WebView. A download started with `downloadFile()` and its own `options` callbacks does not fire this property. |
| `onReceiveDeepLink`  | `function\|null` | `null`                                                    | (get/set)<br><br>Callback fired when the app receives a Deep Link URL. Receives the URL as a string. Must be assigned before loading the first page. |

<a name="web-class-methods"></a>

## JavaScript Class Methods

Static members of the `WUIEnvironment` class.

| Member           | Type            | Description |
| ---------------- | --------------- | ----------- |
| `version`        | `string`        | Library version: `"0.6"`. |
| `response(args)` | `static method` | Entry point for native-to-JS communication. Called internally by the native bridge to deliver request responses and dispatch `onDownloadFile` / `onReceiveDeepLink` events. Not intended to be called from application code. |

<a name="web-instance-methods"></a>

## JavaScript Instance Methods

| Method                  | Return type               | Description |
| ----------------------- | ------------------------- | ----------- |
| `requestPermission`     | `Promise<boolean>`        | `requestPermission(type[, done])`<br><br>Arguments:<br>**• type:** `string`, one of `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• done:** `function` *optional*, callback.<br><br>Requests the system permission for the given type. Inside a native WebView delegates to the bridge (`requestPermission`). On web falls back to `navigator.permissions.query`. Resolves with `true` when granted. |
| `isLocal`               | `boolean`                 | `isLocal()`<br><br>Alias for `isLocalAgent()`. Returns `true` when running inside a native WebView (`local.android` or `local.ios`). Resolved synchronously. |
| `isLocalAgent`          | `boolean`                 | `isLocalAgent()`<br><br>Returns `true` when the detected environment is `local.android` or `local.ios` (i.e. the page is running inside a native WebView with the WUIEnvironment bridge active). Returns `false` on plain web. Resolved synchronously from the value set at construction. |
| `isLocalHost`           | `boolean`                 | `isLocalHost()`<br><br>Returns `true` when `location.hostname` is `"localhost"` or `"127.0.0.1"`. Useful for distinguishing local development from production without relying on the native bridge. |
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
| `openUrl`               | `void`                    | `openUrl(url)`<br><br>Arguments:<br>**• url:** `string`, the destination URL or local asset path.<br><br>Opens a local resource in the WebView or an external link. On web opens via `window.open`. |
| `readDeepLink`          | `Promise<string>`         | `readDeepLink([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Reads the last received Deep Link URL. Returns `null` on web. |
| `clearDeepLink`         | `void`                    | `clearDeepLink([done])`<br><br>Arguments:<br>**• done:** `function` *optional*, callback.<br><br>Clears the stored Deep Link URL. No-op on web. |
| `downloadFile`          | `string\|null`            | `downloadFile(url[, filename[, headers[, options]]])`<br><br>Arguments:<br>**• url:** `string`, file URL.<br>**• filename:** `string` *optional*, default `""`. Suggested file name; if empty, the native side deduces it.<br>**• headers:** `object` *optional*, default `{}`. HTTP headers sent with the request, e.g. `{ Authorization: "Bearer …" }`.<br>**• options:** `object` *optional*, default `{}`. `{ onProgress, onFile }`: callbacks for this download only, with the same arguments as `onDownloadProgress` and `onDownloadFile`. If omitted, the download events go to the global `onDownloadProgress` and `onDownloadFile` properties. For compatibility, if a `function` is passed it is used as the `done` callback, called when the native side accepts the request.<br><br>Downloads a file natively sending HTTP headers, for endpoints that require authentication (a download started with `window.open()` is requested again by the native downloader without headers). Returns the download `key`, used in the events and in `cancelDownload(key)`, or `null` on web, where it is a no-op. Several downloads can run at the same time. On Android the file name cannot be read from `Content-Disposition`, so it is recommended to pass `filename`. |
| `cancelDownload`        | `void`                    | `cancelDownload([key[, done]])`<br><br>Arguments:<br>**• key:** `string` *optional*. Download to cancel, as returned by `downloadFile()`; if omitted, all downloads in progress are cancelled, including those started from the WebView. For compatibility, if a `function` is passed it is used as `done`.<br>**• done:** `function` *optional*, callback.<br><br>Cancels downloads in progress. A cancelled download fires `onDownloadFile` with `status: "cancelled"`. No-op on web. **Pending testing.** |
| `log`                   | `void`                    | `log(message[, force])`<br><br>Arguments:<br>**• message:** `any`, value to log (coerced to string).<br>**• force:** `boolean` *optional*, default `false`. When `true`, instructs the native side to bypass its `developMode` restriction and always write the message.<br><br>Inside a native WebView forwards the message to the native logger (Logcat / Xcode console). On web falls back to `console.log`. |

<a name="web-usage"></a>

## JavaScript Usage

```html
<!DOCTYPE html>
<html>
<head>
	<script src="libraries/wui-js/environment/web/wui-environment-0.6.js"></script>
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
> The `src` path is relative to the HTML file. For Android, assets are loaded from `app/src/main/assets/`; for iOS, from the `assets/` folder added to the Xcode target. The recommended path `libraries/wui-js/environment/web/wui-environment-0.6.js` matches the structure described in the installation steps.

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
env.onDownloadProgress = function({ loaded, total }) {
	console.log("Downloading:", loaded, "of", total, "bytes");
};
env.onDownloadFile = function(args) {
	console.log("Download", args.status + ":", args.filename, args.mimetype, args.uri);
};
env.onReceiveDeepLink = function(url) {
	console.log("Deep Link received:", url);
};

// Download with HTTP headers (e.g. authenticated endpoints) and its own callbacks

const key = env.downloadFile("https://example.com/api/files/1/download", "file.zip", { Authorization: "Bearer " + token }, {
	onProgress: function({ loaded, total }) {
		console.log("file.zip:", loaded, "of", total, "bytes");
	},
	onFile: function(args) {
		console.log("file.zip", args.status, args.httpStatus);
	}
});
// env.cancelDownload(key); // cancels only this download

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
