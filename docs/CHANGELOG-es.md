> [!IMPORTANT]
> La cuenta de GitHub `@wuiproject` se migró a `@wui-js` para que coincidiera con el nombre de la cuenta de NPM.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)
---

# Change Log

## [v0.3.1] - 2026-05-06

Características:

1. Liberación del sitio oficial de documentación de WUI/JS: [https://docs.wuijs.dev](https://docs.wuijs.dev)

## [v0.3.0] - 2026-04-28

Características:

1. **Android — file input con soporte de cámara**: `onShowFileChooser` ahora presenta un `AlertDialog` nativo con dos opciones ("Tomar foto" / "Elegir de galería"). Cada opción lanza su intent directamente desde la `Activity` con request codes separados (`CAMERA_REQUEST_CODE` = 2001, `FILE_CHOOSER_REQUEST_CODE` = 2000), garantizando que `onActivityResult` reciba el resultado correctamente. El permiso de cámara se solicita en el momento en que el usuario selecciona "Tomar foto". El host `Activity` debe implementar `onActivityResult` y llamar a `wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data)`.

Correcciones de errores:

1. **Android — crash en `requestPermission()` con callback `null`**: llamar `requestPermission(type, null)` desde código nativo lanzaba `NullPointerException` en Android < 13 (notifications) y en los paths `default`/`allGranted`. Todas las llamadas a `callback.accept()` ahora verifican null antes de invocar.
2. **iOS — `isAppInForeground()` retorna `false` con la app en primer plano**: el check `applicationState == .active` excluía el estado `.inactive`, que cubre transiciones en primer plano (carga inicial, llamada entrante, selector de apps). Cambiado a `applicationState != .background` para que cualquier estado que no sea background retorne `true`.

Calidad de código (Android):

- `setupWebViewSettings()`: se eliminó el parámetro `developMode` que no se usaba.
- `setupDownloadHandler()`: `DownloadListener` anónimo convertido a lambda; se eliminó el branch vacío `data:`.
- `setStatusbarStyle()`, `setNavigationbarStyle()`, `openURL()`: `Runnable` anónimos convertidos a lambdas.
- `setNavigationbarStyle()`: eliminado guard `SDK_INT >= O` innecesario (siempre verdadero dado el minSdk).
- `getDisplayInfo()`: eliminado wrapper `SDK_INT >= M` innecesario (siempre verdadero dado el minSdk).
- `getCurrentPosition()`: `Consumer<Location>` anónimo convertido a lambda; agregado `@SuppressLint("MissingPermission")` (el permiso ya se verifica vía `requestPermissionSync`).
- `handlePermissionResult()`: agregado `@SuppressWarnings("unused")` en el parámetro `permissions`.
- `requestPermissionSync()`: se maneja el valor de retorno ignorado de `CountDownLatch.await()`.
- `setupDownloadHandler()`: null-check en `getParentFile()` antes de `mkdirs()`; se maneja el valor de retorno de `mkdirs()` en el directorio de descargas.
- `saveFile()` / `readFile()`: reemplazado el literal `"UTF-8"` por `StandardCharsets.UTF_8`.
- Corregido error tipográfico en mensaje de log: `"File readed"` → `"File read"`.

## [v0.2.0] - 2026-04-26

Características:

1. Se actualizó el método `getDisplayInfo()`.
	- Se agregó la clave `statusbarOverlay`:
		- **Android**: `true` cuando el contenido se renderiza detrás de la barra de estado. Se detecta mediante `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de estado con alpha < 255. Cubre dispositivos OEM (ej. C2250) que aplican barra de estado transparente sin activar el flag clásico translúcido.
		- **iOS**: `true` cuando no hay ninguna UIView opaca cubriendo la barra de estado (`statusbarTransparent`) o cuando `safeAreaInsets.top` es cero (sin barra de estado visible).
	- Se agregó la clave `navigationbarOverlay`:
		- **Android**: `true` cuando el contenido se renderiza detrás de la barra de navegación. Se detecta mediante `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de navegación con alpha < 255. Cubre dispositivos OEM (ej. C2250) que aplican barra semitransparente en modo overlay sin activar el flag clásico translúcido.
		- **iOS**: `true` cuando no hay ninguna UIView opaca cubriendo el área de navegación (`navigationbarTransparent`) o cuando `safeAreaInsets.bottom` es cero (dispositivos con botón de inicio o landscape sin barra de gestos).
2. Se actualió forzó la salida de tipo boleeana de los métodos `isLocal()`, `isMobile()` y `isTouch()` en la librería JS.

## [v0.1.0] - 2026-04-25

Características:

1. Versión de lanzamiento.