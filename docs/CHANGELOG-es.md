> [!IMPORTANT]
> La cuenta de GitHub `@wuiproject` se migró a `@wui-js` para que coincidiera con el nombre de la cuenta de NPM.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)
---

# Registro de Cambios

## [v0.6.0] - 2026-10-08

Características:

1. **Web** - Se actualizó la librería JavaScript a la versión `0.6`.
	- Se agregó la propiedad `onDownloadProgress` (`function` o `null`), que se ejecuta aproximadamente cada 250 ms durante una descarga con `{ loaded, total }` (bytes; `total` es `-1` si no se conoce).
	- Se agregó el campo `status` (`"success"`, `"failed"` o `"cancelled"`) a los argumentos de `onDownloadFile`; `uri` es `null` cuando no es `"success"`. El cambio es aditivo: los consumidores que ignoran `status` siguen funcionando.
	- Se agregó el método `cancelDownload()` para cancelar la descarga en curso. **Pendiente de prueba.**
	- Se agregó el campo `httpStatus` a los argumentos de `onDownloadFile`: el código HTTP cuando la descarga falló por una respuesta HTTP (ej. `401`), o `null`.
	- Soporte para varias descargas simultáneas: `downloadFile(url, filename, headers, options)` retorna una `key` por descarga y acepta `options = { onProgress, onFile }` con callbacks sólo para esa descarga; `cancelDownload(key, done)` cancela sólo esa descarga, o todas sin `key`. Los eventos `onDownloadProgress` y `onDownloadFile` ahora incluyen `key` (`null` en las descargas iniciadas desde el WebView) y se despachan a los callbacks de la descarga, o a las propiedades globales cuando no los hay. Compatible con las llamadas anteriores: una `function` como cuarto argumento de `downloadFile()` o primer argumento de `cancelDownload()` se sigue usando como `done`.
	- Se agregó el método `downloadFile(url, filename, headers, done)` para descargar un archivo de forma nativa enviando cabeceras HTTP (ej. `Authorization` para endpoints autenticados). Emite `onDownloadProgress` y `onDownloadFile` y se puede cancelar con `cancelDownload()`. Sin efecto en web.
	- Se actualizó la página demo (`demo/index.html`): carga `wui-environment-0.6.js` (seguía cargando la `0.1`), usa `openUrl()` (renombrado desde `openURL()` en 0.5), agrega pruebas de `onDownloadProgress`, `downloadFile()` con callbacks propios, `cancelDownload()`, `setNavigationbarStyle()`, `requestPermission()`, `readDeepLink()` y `clearDeepLink()`, y respeta el área segura del dispositivo.
2. **Android** - Se actualizó la librería Java a la versión `0.6`.
	- Se agregó el evento `onDownloadProgress`: con `DownloadManager` se consulta la descarga cada 250 ms (`COLUMN_BYTES_DOWNLOADED_SO_FAR` / `COLUMN_TOTAL_SIZE_BYTES`) en un hilo en segundo plano; al copiar un archivo de assets, se emite desde el bucle de copia.
	- Cambio de comportamiento: con `DownloadManager`, `onDownloadFile`, el escaneo de medios y la apertura del archivo se ejecutaban al encolar la descarga, antes de que el archivo existiera. Ahora se ejecutan cuando la descarga se completa, y `onDownloadFile` también se emite cuando falla o se cancela, con el `status` correspondiente. La ruta del archivo se obtiene de `COLUMN_LOCAL_URI`.
	- La copia de archivos de assets ahora se ejecuta en un hilo en segundo plano en vez del hilo de UI.
	- Se agregó el método `cancelDownload()` (`DownloadManager.remove()`, o interrupción de la copia de assets). **Pendiente de prueba.**
	- `onDownloadFile` envía `httpStatus` desde `COLUMN_REASON` cuando `DownloadManager` falla con un código HTTP.
	- Varias descargas simultáneas con `DownloadManager`: el `downloadId` único se reemplazó por un mapa id de descarga → `key`, protegido por el lock compartido, y `cancelDownload(key)` cancela sólo las descargas de esa `key` (todas sin `key`).
	- `cancelDownload()` ya no elimina una descarga que ya se completó: `downloadId` se protege con un lock compartido con el hilo de seguimiento y se consulta el estado antes de `remove()`.
	- Se corrigió error (presente desde 0.5): el archivo descargado se abría con `Uri.fromFile()`, que lanza `FileUriExposedException` desde Android 7, por lo que nunca se abría. Ahora se abre con un URI `content://` (`getUriForDownloadedFile()` para `DownloadManager`, `FileProvider` para archivos de assets) y `FLAG_GRANT_READ_URI_PERMISSION`. El campo `uri` de `onDownloadFile` sigue siendo la ruta `file://`. `res/xml/file_paths.xml` debe declarar `<external-path name="downloads" path="Download/" />`.
	- Se agregó el método `downloadFile(url, filename, headers)`: `DownloadManager.Request` con `addRequestHeader()` por cada cabecera, con el mismo seguimiento que las descargas del WebView. Si `filename` está vacío se toma de la URL, ya que `DownloadManager` necesita el nombre antes de la solicitud. Los valores de las cabeceras no se registran en el log.
	- Documentación: el ejemplo de integración de `MainActivity` ya no sobrescribe `onActivityResult`, que llamaba al método inexistente `handleFileChooserResult()` (el resultado del selector de archivos lo maneja un `ActivityResultLauncher` registrado por la clase); se corrigió la ruta alternativa de la página de inicio, que duplicaba el prefijo `file:///android_asset/`; y se agregó a la tabla de métodos el método público `handlePermissionResult()`.
	- `developMode` ahora también habilita la inspección del WebView con Chrome DevTools (`WebView.setWebContentsDebuggingEnabled()`), en paridad con `isInspectable` en iOS.
	- Se corrigió error: `onDownloadFile` informaba el nombre de archivo solicitado en vez del guardado cuando ya existía un archivo con el mismo nombre (ej. `download.pdf` en vez de `download (1).pdf`).
3. **iOS** - Se actualizó la librería Swift a la versión `0.6`.
	- Se agregó el evento `onDownloadProgress`, observando `Progress.completedUnitCount` de `WKDownload` y de las descargas de respaldo con `URLSession`.
	- Se agregó el campo `status` a `onDownloadFile`; ahora también se emite cuando la descarga falla o se cancela.
	- Se agregó el método `cancelDownload()` (`WKDownload.cancel()` / `URLSessionDownloadTask.cancel()`). **Pendiente de prueba.**
	- `onDownloadFile` envía `httpStatus` cuando una descarga con `URLSession` falla con una respuesta distinta de 2xx.
	- Varias descargas simultáneas: la descarga actual única se reemplazó por un diccionario por descarga (`URLSessionDownloadTask` o `WKDownload`, con su `key`) modificado en el hilo principal, y `cancelDownload(key:)` cancela sólo esa descarga (todas con `nil`).
	- Se corrigió error: el completion handler de `URLSession` (cola en segundo plano) modificaba el estado de las descargas (observaciones de progreso y tarea actual) en paralelo con el hilo principal. Ahora todo el estado de descargas se modifica en el hilo principal; el archivo temporal se sigue moviendo de forma síncrona dentro del handler.
	- Se agregó el método `downloadFile(url:filename:headers:)`: `URLRequest` con las cabeceras sobre la descarga con `URLSession`. Los valores de las cabeceras no se registran en el log.
	- Las descargas con `URLSession` con respuesta distinta de 2xx ahora emiten `onDownloadFile` con `status: "failed"` en vez de guardar el cuerpo de la respuesta como archivo.

	- Se corrigió error: el progreso de las descargas con `URLSession` se informaba en unidades de porcentaje (`URLSessionTask.progress`) en vez de bytes; ahora se observan `countOfBytesReceived` / `countOfBytesExpectedToReceive`.
	- Se eliminó la advertencia del compilador `'task' mutated after capture by sendable closure` en la descarga con `URLSession`.
4. **Plantillas** - Se agregó el directorio `templates/` con los proyectos mínimos `app.myapp.android` (Android Studio) y `app.myapp.ios` (Xcode), que ejecutan la página demo con la última versión de la librería, y el script `tools/sync-templates.sh`, que copia las fuentes vigentes a ambas plantillas.

## [v0.5.1] - 2026-09-08

Características:

1. Se agregó el script `prepare` a `package.json` para que una instalación vía tag de git (`npm install github:wui-js/wuijs-environment-lib#vX.Y.Z`) produzca la misma estructura de archivos aplanada que una instalación desde el registro de npm.

## [v0.5.0] - 2026-07-20

Características:

- Se sincronizó la versión de las librerías Java, Swift y JavaScript.
1. **Web** - Se actualizó la librería JavaScript a la versión `0.5`.
	- Mejora en la detección de `#systemName` en el constructor para resultados confiables multiplataforma. iOS/Android ahora se detectan mediante `userAgent` (corrige el caso de iPad en iOS 13+ que reporta `platform = "MacIntel"`); `#platform` se normaliza a minúsculas antes de hacer match con plataformas de escritorio (`macOS`, `Windows Phone`, `Windows`, `Linux`).
	- Mejora en la detección del estado del permiso para contactos en el método `getPermissionsStatus()`.
	- Corregido error tipográfico en `isLocal()`: llamaba a `isLocalagent()` en lugar de `isLocalAgent()`.
	- Agregado método `isLocalAgent()`: devuelve `true` cuando el entorno es `local.android` o `local.ios`.
	- Agregado método `isLocalHost()`: devuelve `true` cuando `location.hostname` es `localhost` o `127.0.0.1`.
	- Se forzó nomenclatura camelCase en siglas de método público: `openURL()` → `openUrl()`.
2. **Android** - Se actualizó la librería Java a la versión `0.5`.
	- Se forzó nomenclatura camelCase en siglas de método público: `openURL()` → `openUrl()`. Se actualizó también la cadena del protocolo interno de RPC JS↔nativo (`func: "openURL"` → `func: "openUrl"`) para mantener paridad con el cambio en la capa Web.
	- Se forzó nomenclatura camelCase en siglas de métodos privados: `getDeviceID()` → `getDeviceId()`, `getDeviceUUID()` → `getDeviceUuid()`.
3. **iOS** - Se actualizó la librería Swift a la versión `0.5`.
	- Se forzó nomenclatura camelCase en siglas de método público: `openURL(url:)` → `openUrl(url:)`. Se actualizó también la cadena del protocolo interno de RPC JS↔nativo (`case "openURL"` → `case "openUrl"`) para mantener paridad con Android y la capa Web.

## [v0.4.0] - 2026-05-14

Características:

1. **Android** - Se actualizó la librería Java a la versión `0.4`.
	- Correcciones de errores:
		- Se mejoró la implementación del controlador de errores SSL de WebView para cumplir con los requerimientos de la Play Store [Device and Network Abuse policy](https://support.google.com/googleplay/android-developer/answer/16559646).

## [v0.3.1] - 2026-05-06

Características:

1. Liberación del sitio oficial de documentación de WUI/JS: [https://docs.wuijs.dev](https://docs.wuijs.dev)

## [v0.3.0] - 2026-04-28

Características:

1. **Android** - Se actualizó la librería Java a la versión `0.3`.
	- File input con soporte de cámara: `onShowFileChooser` ahora presenta un `AlertDialog` nativo con dos opciones ("Tomar foto" / "Elegir de galería"). Cada opción lanza su intent directamente desde la `Activity` con request codes separados (`CAMERA_REQUEST_CODE` = 2001, `FILE_CHOOSER_REQUEST_CODE` = 2000), garantizando que `onActivityResult` reciba el resultado correctamente. El permiso de cámara se solicita en el momento en que el usuario selecciona "Tomar foto". El host `Activity` debe implementar `onActivityResult` y llamar a `wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data)`.
	- Correcciones de errores:
		- Crash en `requestPermission()` con callback `null`**: llamar `requestPermission(type, null)` desde código nativo lanzaba `NullPointerException` en Android < 13 (notifications) y en los paths `default`/`allGranted`. Todas las llamadas a `callback.accept()` ahora verifican null antes de invocar.
	- Calidad de código:
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

2. **iOS** - Se actualizó la librería Swift a la versión `0.3`.
	- Correcciones de errores:
		- `isAppInForeground()` retorna `false` con la app en primer plano**: el check `applicationState == .active` excluía el estado `.inactive`, que cubre transiciones en primer plano (carga inicial, llamada entrante, selector de apps). Cambiado a `applicationState != .background` para que cualquier estado que no sea background retorne `true`.

## [v0.2.0] - 2026-04-26

Características:

1. **Android** - Se actualizó el método `getDisplayInfo()`.
	- Se agregó la clave `statusbarOverlay`: `true` cuando el contenido se renderiza detrás de la barra de estado. Se detecta mediante `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de estado con alpha < 255. Cubre dispositivos OEM (ej. C2250) que aplican barra de estado transparente sin activar el flag clásico translúcido.
	- Se agregó la clave `navigationbarOverlay`: `true` cuando el contenido se renderiza detrás de la barra de navegación. Se detecta mediante `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de navegación con alpha < 255. Cubre dispositivos OEM (ej. C2250) que aplican barra semitransparente en modo overlay sin activar el flag clásico translúcido.

2. **iOS** - Se actualizó el método `getDisplayInfo()`.
	- Se agregó la clave `statusbarOverlay`: `true` cuando no hay ninguna UIView opaca cubriendo la barra de estado (`statusbarTransparent`) o cuando `safeAreaInsets.top` es cero (sin barra de estado visible).
	- Se agregó la clave `navigationbarOverlay`: `true` cuando no hay ninguna UIView opaca cubriendo el área de navegación (`navigationbarTransparent`) o cuando `safeAreaInsets.bottom` es cero (dispositivos con botón de inicio o landscape sin barra de gestos).

3. **Web** - Se actualizó el método `getDisplayInfo()`.
	- Se forzó la salida de tipo booleano en los métodos `isLocal()`, `isMobile()` e `isTouch()`.

## [v0.1.0] - 2026-04-25

Características:

1. Versión de lanzamiento.