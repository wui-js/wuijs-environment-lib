[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README-es.md)

# WUI/JS Environment - App Templates

Minimal Android and iOS projects that run the WUIEnvironment demo page (`src/wui-js/environment/demo/index.html`) with the latest version of the library. They are meant as a starting point for a new hybrid app.

| Template | Opens with | Package / Bundle ID | Requirements |
| -------- | ---------- | ------------------- | ------------ |
| `app.myapp.android` | Android Studio | `app.myapp` | Android SDK 36, JDK 17+ (the one bundled with Android Studio), minSdk 24. |
| `app.myapp.ios` | Xcode (`MyApp.xcodeproj`) | `app.myapp` | Xcode 16+, iOS 18.5+. |

## Contents

| File | Description |
| ---- | ----------- |
| `app.myapp.android/app/src/main/java/app/myapp/WUIEnvironment.java` | Native bridge (copy of `src/wui-js/environment/android/WUIEnvironment.java` with `package app.myapp;`). |
| `app.myapp.android/app/src/main/java/app/myapp/MainActivity.java` | Loads the demo page and forwards Deep Links and permission results to the bridge. |
| `app.myapp.android/app/src/main/res/` | Launcher icons, bar colors used by `setStatusbarStyle`/`setNavigationbarStyle`, themes and `xml/file_paths.xml` for the `FileProvider`. |
| `app.myapp.android/app/src/main/assets/libraries/wui-js/environment/` | JavaScript class (`web/`) and demo page (`demo/`). |
| `app.myapp.ios/MyApp/WUIEnvironment.swift` | Native bridge (copy of `src/wui-js/environment/ios/WUIEnvironment.swift`). |
| `app.myapp.ios/MyApp/MyAppApp.swift`, `MainView.swift` | SwiftUI entry point that loads the demo page and forwards Deep Links to the bridge. |
| `app.myapp.ios/MyApp/Assets.xcassets/` | App icon, accent color and bar colors used by `setStatusbarStyle`/`setNavigationbarStyle`. |
| `app.myapp.ios/MyApp/assets/libraries/wui-js/environment/` | JavaScript class (`web/`) and demo page (`demo/`), added to the bundle as a folder reference to keep the relative paths. |

## Run

**Android:** open `app.myapp.android` in Android Studio, wait for the Gradle sync and run the `app` configuration on an emulator or device. From the command line: `./gradlew assembleDebug` (with `JAVA_HOME` pointing to a JDK 17+ and the SDK in `ANDROID_HOME` or `local.properties`).

**iOS:** open `app.myapp.ios/MyApp.xcodeproj` in Xcode and run the `MyApp` scheme on a simulator. To run it on a device, select a development team in *Signing & Capabilities*.

## Start a new app from a template

1. Copy the template directory and rename it (e.g. `app.mycompany.myproduct.android`).
2. **Android:** change `namespace` and `applicationId` in `app/build.gradle.kts`, move `app/src/main/java/app/myapp/` to the new package path and update the `package` line of both Java files, `app_name` in `res/values/strings.xml` and the Deep Link scheme (`myapp`) in `AndroidManifest.xml`.
3. **iOS:** change `PRODUCT_BUNDLE_IDENTIFIER` and `INFOPLIST_KEY_CFBundleDisplayName` in the target build settings, and the Deep Link scheme (`myapp`) and usage descriptions in `MyApp/Info.plist`.
4. Replace the demo page with the app pages in `assets/` and change the path loaded by `MainActivity.java` / `MainView.swift`.
5. Set `developMode` to `true` only during development: it enables the bridge logging and WebView inspection (Chrome DevTools / Safari Web Inspector) and accepts untrusted SSL certificates.

## Keep the templates up to date

The templates contain copies of the library sources. After changing the bridge, the JavaScript class or the demo page in `src/`, run from the repository root:

```bash
tools/sync-templates.sh
```

It copies the Java class (replacing the `package` line), the Swift class, the latest `wui-environment-<version>.js` and the demo page into both templates.
