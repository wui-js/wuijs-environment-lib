[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README-es.md)

# WUI/JS Environment - Plantillas de Apps

Proyectos mínimos de Android e iOS que ejecutan la página demo de WUIEnvironment (`src/wui-js/environment/demo/index.html`) con la última versión de la librería. Están pensados como punto de partida para una nueva app híbrida.

| Plantilla | Se abre con | Package / Bundle ID | Requisitos |
| --------- | ----------- | ------------------- | ---------- |
| `app.myapp.android` | Android Studio | `app.myapp` | Android SDK 36, JDK 17+ (el incluido en Android Studio), minSdk 24. |
| `app.myapp.ios` | Xcode (`MyApp.xcodeproj`) | `app.myapp` | Xcode 16+, iOS 18.5+. |

## Contenido

| Archivo | Descripción |
| ------- | ----------- |
| `app.myapp.android/app/src/main/java/app/myapp/WUIEnvironment.java` | Bridge nativo (copia de `src/wui-js/environment/android/WUIEnvironment.java` con `package app.myapp;`). |
| `app.myapp.android/app/src/main/java/app/myapp/MainActivity.java` | Carga la página demo y reenvía los Deep Links y los resultados de permisos al bridge. |
| `app.myapp.android/app/src/main/res/` | Íconos de la app, colores de barras usados por `setStatusbarStyle`/`setNavigationbarStyle`, temas y `xml/file_paths.xml` para el `FileProvider`. |
| `app.myapp.android/app/src/main/assets/libraries/wui-js/environment/` | Clase JavaScript (`web/`) y página demo (`demo/`). |
| `app.myapp.ios/MyApp/WUIEnvironment.swift` | Bridge nativo (copia de `src/wui-js/environment/ios/WUIEnvironment.swift`). |
| `app.myapp.ios/MyApp/MyAppApp.swift`, `MainView.swift` | Punto de entrada SwiftUI que carga la página demo y reenvía los Deep Links al bridge. |
| `app.myapp.ios/MyApp/Assets.xcassets/` | Ícono de la app, color de acento y colores de barras usados por `setStatusbarStyle`/`setNavigationbarStyle`. |
| `app.myapp.ios/MyApp/assets/libraries/wui-js/environment/` | Clase JavaScript (`web/`) y página demo (`demo/`), agregadas al bundle como referencia de carpeta para mantener las rutas relativas. |

## Ejecutar

**Android:** abrir `app.myapp.android` en Android Studio, esperar la sincronización de Gradle y ejecutar la configuración `app` en un emulador o dispositivo. Desde la terminal: `./gradlew assembleDebug` (con `JAVA_HOME` apuntando a un JDK 17+ y el SDK en `ANDROID_HOME` o `local.properties`).

**iOS:** abrir `app.myapp.ios/MyApp.xcodeproj` en Xcode y ejecutar el esquema `MyApp` en un simulador. Para ejecutarla en un dispositivo, seleccionar un equipo de desarrollo en *Signing & Capabilities*.

## Crear una nueva app desde una plantilla

1. Copiar el directorio de la plantilla y renombrarlo (ej. `app.miempresa.miproducto.android`).
2. **Android:** cambiar `namespace` y `applicationId` en `app/build.gradle.kts`, mover `app/src/main/java/app/myapp/` a la ruta del nuevo package y actualizar la línea `package` de ambos archivos Java, `app_name` en `res/values/strings.xml` y el esquema de Deep Link (`myapp`) en `AndroidManifest.xml`.
3. **iOS:** cambiar `PRODUCT_BUNDLE_IDENTIFIER` e `INFOPLIST_KEY_CFBundleDisplayName` en la configuración del target, y el esquema de Deep Link (`myapp`) y las descripciones de uso en `MyApp/Info.plist`.
4. Reemplazar la página demo por las páginas de la app en `assets/` y cambiar la ruta que cargan `MainActivity.java` / `MainView.swift`.
5. Poner `developMode` en `true` sólo durante el desarrollo: habilita el log del bridge y la inspección del WebView (Chrome DevTools / Safari Web Inspector) y acepta certificados SSL no confiables.

## Mantener las plantillas actualizadas

Las plantillas contienen copias de las fuentes de la librería. Después de cambiar el bridge, la clase JavaScript o la página demo en `src/`, ejecutar desde la raíz del repositorio:

```bash
tools/sync-templates.sh
```

Copia la clase Java (reemplazando la línea `package`), la clase Swift, el último `wui-environment-<versión>.js` y la página demo a ambas plantillas.
