[English](wui-environment-ios-en.md) | [Español](wui-environment-ios-es.md)

[wuijs-environment-lib](../../README-es.md)

Plataformas: [Android](wui-environment-android-es.md) | [iOS](wui-environment-ios-es.md) | [Web](wui-environment-web-es.md)

# WUIEnvironment (iOS)

Versión: `0.6`

La implementación en iOS utiliza como motor de renderización WebKit (WKWebView) y se comunica mediante `WKScriptMessageHandler`.

> [!NOTE]
> **Limitación de XHR con `file://` en WKWebView:** WKWebView bloquea todas las llamadas `XMLHttpRequest` a URLs `file://` sin importar el valor de `allowingReadAccessTo`. `WUIEnvironment` inyecta automáticamente un `WKUserScript` al inicio del documento que intercepta estas solicitudes y las enruta por el bridge nativo mediante `webkit.messageHandlers.request`. Esto es transparente para el código JavaScript — `XMLHttpRequest` funciona con normalidad tanto para archivos locales como para URLs remotas.

## Fuentes

| Tipo  | Archivo |
|:-----:| ------- |
| Swift | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |

<a name="ios-constructor"></a>

## Constructor Swift

| Constructor | Descripción |
| ----------- | ----------- |
| `WUIEnvironment(viewController: UIViewController[, developMode: Bool])` | Inicializa el entorno WUI. `developMode = true` permite SSL con certificados no confiables, activa logs de depuración y habilita la inspección del WKWebView con Safari Web Inspector (iOS 16.4+). **No usar `true` en producción** — deshabilita la validación de certificados en todo el WKWebView. |

<a name="ios-methods"></a>

## Métodos Swift

| Método                  | Tipo de retorno | Descripción |
| ----------------------- | --------------- | ----------- |
| `requestPermission`     | `void`          | `requestPermission(type, completion)`<br><br>Argumentos:<br>**• type:** `String`, uno de `location`, `notifications`, `camera`, `contacts`.<br>**• completion:** `(Bool) -> Void`, invocado con el resultado.<br><br>Solicita el permiso del sistema indicado. Si ya está concedido, invoca la completion de inmediato. Si está denegado o restringido, retorna `false`. Para `location` usa `CLLocationManager.requestWhenInUseAuthorization`; para `notifications` `UNUserNotificationCenter.requestAuthorization`; para `camera` `AVCaptureDevice.requestAccess`; para `contacts` `CNContactStore.requestAccess`. |
| `isAppInForeground`     | `Bool`          | `isAppInForeground()`<br><br>Verifica si la aplicación está actualmente en primer plano. |
| `getDeviceInfo`         | `[String: Any]` | `getDeviceInfo()`<br><br>Devuelve información de hardware del dispositivo: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`        | `[String: Any]` | `getDisplayInfo()`<br><br>Devuelve métricas de pantalla: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch` y flags de estilo de barras del sistema.<br><br>`statusbarTransparent` y `navigationbarTransparent` reflejan el estado actual de las UIView overlay gestionadas por `setStatusbarStyle` y `setNavigationbarStyle`: `true` cuando no hay overlay opaco sobre esa área. `statusbarOverlay` es `true` cuando el contenido se renderiza detrás de la barra de estado — derivado de `statusbarTransparent` o cuando `safeAreaInsets.top` es cero. `navigationbarOverlay` es `true` cuando el contenido se renderiza detrás de la barra de navegación — derivado de `navigationbarTransparent` o cuando `safeAreaInsets.bottom` es cero (dispositivos con botón de inicio o landscape sin barra de gestos). `navigationbarLightMode` es siempre `false` (el home indicator de iOS se adapta automáticamente). |
| `getAppInfo`            | `[String: Any]` | `getAppInfo()`<br><br>Devuelve metadatos de la aplicación: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`  | `void`          | `getPermissionsStatus(completion)`<br><br>Argumentos:<br>**• completion:** `([String: Any]) -> Void`, callback con el resultado.<br><br>Verifica el estado de los permisos del sistema: `location`, `camera`, `contacts`, `notifications`. Valores posibles: `granted`, `denied`, `default`, `undefined`. Las llaves `phone` y `storage` son siempre `undefined` (sin permiso de sistema equivalente en iOS). Async — entrega el resultado en el main thread. |
| `getCurrentPosition`    | `void`          | `getCurrentPosition(completion)`<br><br>Argumentos:<br>**• completion:** `([String: Any]) -> Void`, callback con el resultado.<br><br>Obtiene las coordenadas GPS actuales: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Solicita el permiso de ubicación si no ha sido otorgado. Async — entrega el resultado vía `CLLocationManagerDelegate`.<br><br>> **Requiere** `NSLocationWhenInUseUsageDescription` en `Info.plist`. Sin esta clave iOS ignora silenciosamente la solicitud de permiso. |
| `getConnectionStatus`   | `Bool`          | `getConnectionStatus()`<br><br>Verifica si hay una conexión a internet activa. Lee el estado actual de la red de forma sincrónica mediante `NWPathMonitor.currentPath`; el `pathUpdateHandler` interno mantiene el estado en caché actualizado para llamadas posteriores. |
| `setStatusbarStyle`     | `void`          | `setStatusbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o nombre de color set en `Assets.xcassets` (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `Bool`, `true` para iconos oscuros, `false` para claros.<br><br>Coloca una UIView con el color indicado sobre el área del status bar. El estilo de iconos se aplica vía `preferredStatusBarStyle` — el host ViewController debe exponer esta propiedad y llamar a `setNeedsStatusBarAppearanceUpdate()`. |
| `setNavigationbarStyle` | `void`          | `setNavigationbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o nombre de color set en `Assets.xcassets` (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `Bool`, ignorado en iOS (el home indicator no es configurable).<br><br>Coloca una UIView con el color indicado sobre el área `safeAreaInsets.bottom`. Sin efecto en dispositivos con botón de inicio. |
| `setAppBadge`           | `void`          | `setAppBadge(number)`<br><br>Argumentos:<br>**• number:** `Int`, contador de badge no negativo. `0` elimina el badge.<br><br>Establece o elimina el badge en el ícono de la aplicación. Solicita el permiso de notificaciones primero. En iOS 16+ usa `UNUserNotificationCenter.setBadgeCount`; en versiones anteriores recae en `UIApplication.shared.applicationIconBadgeNumber`. |
| `saveFile`              | `Bool`          | `saveFile(name, content)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br>**• content:** `String`, contenido a guardar.<br><br>Escribe un archivo en el directorio `Documents` de la aplicación. Devuelve `true` si tuvo éxito. |
| `readFile`              | `String?`       | `readFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Lee un archivo del directorio `Documents`. Devuelve `nil` si no existe o hay error. |
| `removeFile`            | `Bool`          | `removeFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Elimina un archivo del directorio `Documents`. Devuelve `true` si tuvo éxito. |
| `openAppSettings`       | `void`          | `openAppSettings()`<br><br>Abre la pantalla de configuración de la aplicación en Ajustes del sistema. |
| `openUrl`               | `void`          | `openUrl(url)`<br><br>Argumentos:<br>**• url:** `String`, URL de destino o ruta de archivo local (`file://...`).<br><br>Carga un archivo local en el WKWebView con `loadFileURL` o abre una URL externa mediante `UIApplication.shared.open`. |
| `saveDeepLink`          | `void`          | `saveDeepLink(url)`<br><br>Argumentos:<br>**• url:** `URL?`, URL recibida en `scene(_:openURLContexts:)` o `application(_:open:)`.<br><br>Extrae y almacena la URL del Deep Link. Si la página ya está cargada, la envía inmediatamente al JavaScript. |
| `sendDeepLink`          | `void`          | `sendDeepLink()`<br><br>Envía la URL de Deep Link almacenada al JavaScript llamando a `WUIEnvironment.response()`. Solo actúa si la página ya está cargada. |
| `readDeepLink`          | `String?`       | `readDeepLink()`<br><br>Devuelve la última URL de Deep Link almacenada, o `nil` si no hay ninguna. |
| `clearDeepLink`         | `void`          | `clearDeepLink()`<br><br>Elimina la URL de Deep Link almacenada. |
| `downloadFile`          | `void`          | `downloadFile(url:filename:headers:key:)`<br><br>Parámetros:<br>**• url:** `String`, URL del archivo.<br>**• filename:** `String`, nombre sugerido del archivo; si está vacío, se toma de `Content-Disposition` o de la URL.<br>**• headers:** `[String: String]`, cabeceras HTTP enviadas con la solicitud (ej. `Authorization`).<br>**• key:** `String?` *opcional*, identificador de la descarga que se devuelve en los eventos `onDownloadProgress` y `onDownloadFile` (`nil` si se omite).<br><br>Descarga un archivo con `URLSession` enviando las cabeceras HTTP indicadas. Pueden ejecutarse varias descargas al mismo tiempo. Una respuesta distinta de 2xx emite `onDownloadFile` con `status: "failed"` y `httpStatus`. Emite los mismos eventos `onDownloadProgress` y `onDownloadFile` que una descarga iniciada desde el WebView, y se puede cancelar con `cancelDownload(key:)`. Los valores de las cabeceras no se registran en el log. |
| `cancelDownload`        | `void`          | `cancelDownload(key:)`<br><br>Parámetros:<br>**• key:** `String?` *opcional*. Descarga a cancelar; si es `nil`, se cancelan todas las descargas en curso.<br><br>Cancela descargas en curso. Una descarga cancelada dispara `onDownloadFile` con `status: "cancelled"`. **Pendiente de prueba.** |
| `log`                   | `void`          | `log(_ message[, force:])`<br><br>Argumentos:<br>**• message:** `String` (autoclosure), mensaje a registrar.<br>**• force:** `Bool` *opcional*, por defecto `false`. Cuando es `true` omite la restricción de `developMode` y siempre escribe en la consola de Xcode.<br><br>Reenvía el mensaje a la consola de Xcode con el prefijo `[WUIEnvironment][js]`. Solo activo cuando `developMode = true`, salvo que `force` lo sobrescriba. |

<a name="ios-events"></a>

## Eventos iOS

Los eventos son callbacks que el lado nativo envía al JavaScript cuando una acción asíncrona se completa. Se deben configurar en la instancia de `WUIEnvironment` antes de cargar la primera página.

| Evento               | Argumentos                                                   | Descripción |
| -------------------- | ------------------------------------------------------------ | ----------- |
| `onDownloadProgress` | `key`, `loaded`, `total`                                     | Se dispara aproximadamente cada 250 ms mientras está en curso la descarga de un archivo iniciada desde el WebView. `loaded` es la cantidad de bytes recibidos y `total` el tamaño del archivo en bytes, o `-1` si no se conoce. `key` es el identificador pasado a `downloadFile()`, o `null` en las descargas iniciadas desde el WebView. |
| `onDownloadFile`     | `key`, `filename`, `mimetype`, `uri`, `status`, `httpStatus` | Se dispara cuando termina la descarga de un archivo iniciada desde el WebView. `status` es `"success"`, `"failed"` o `"cancelled"`; `uri` es `null` cuando no es `"success"`. `httpStatus` es el código HTTP cuando una descarga con `URLSession` falló por una respuesta distinta de 2xx, o `null`. Si la descarga es exitosa, el archivo se guarda en `Documents/Downloads/` dentro del sandbox de la app y se abre mediante `UIActivityViewController`. Requiere iOS 14.5+ para `WKDownloadDelegate`; en versiones anteriores se usa `URLSession` como fallback. `key` es el identificador pasado a `downloadFile()`, o `null` en las descargas iniciadas desde el WebView. |
| `onReceiveDeepLink`  | `url`                                                        | Se dispara cuando la aplicación recibe una URL de Deep Link (al abrir o durante la ejecución). |

<a name="ios-dialogs"></a>

## Diálogos JavaScript

`WUIEnvironment` intercepta los diálogos estándar de JavaScript (`alert()`, `confirm()`, `prompt()`) y los renderiza mediante `UIAlertController` nativo. WKWebView descarta silenciosamente estos diálogos cuando el `WKUIDelegate` no implementa los panel handlers correspondientes — `WUIEnvironment` los provee.

| Diálogo     | Comportamiento |
| ----------- | -------------- |
| `alert()`   | Muestra un `UIAlertController` estilo alert con el mensaje y un botón **OK**. Resuelve al confirmar. |
| `confirm()` | Muestra un `UIAlertController` estilo alert con el mensaje y botones **OK** / **Cancelar**. Devuelve `true` al confirmar, `false` al cancelar. |
| `prompt()`  | Muestra un `UIAlertController` estilo alert con el mensaje, un `UITextField` con el valor por defecto y botones **OK** / **Cancelar**. Devuelve el texto ingresado al confirmar, `null` al cancelar. |

<a name="ios-install"></a>

## Instalación y Configuración

<a name="ios-clone"></a>

### 1. Clonar la librería

Clonar el repositorio desde GitHub si aún no se ha realizado:

```bash
git clone --branch v0.6.0 https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> El repositorio contendrá las 3 clases, Java para Android, Swift para iOS y JavaScript como contraparte Web.

<a name="ios-config-permissions"></a>

### 2. Configuración de Permisos (`Info.plist` o `project.pbxproj`)

Si el proyecto utiliza `GENERATE_INFOPLIST_FILE = YES` (Xcode 13+), agregar las claves de descripción de uso directamente en los build settings del target:

| Clave en Build Settings                             | Requerida para |
| --------------------------------------------------- | -------------- |
| `INFOPLIST_KEY_NSUserNotificationsUsageDescription` | `requestPermission()` y `setAppBadge()` (notificaciones) |
| `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` | `requestPermission()`, `getCurrentPosition()` y `getPermissionsStatus()` (ubicación) |
| `INFOPLIST_KEY_NSCameraUsageDescription`            | `requestPermission()` y `getPermissionsStatus()` (cámara) |
| `INFOPLIST_KEY_NSContactsUsageDescription`          | `requestPermission()` y `getPermissionsStatus()` (contactos) |

> [!WARNING]
> Sin `NSLocationWhenInUseUsageDescription`, iOS ignora silenciosamente `requestWhenInUseAuthorization()` — el diálogo de permiso nunca aparece y `getCurrentPosition` nunca entrega un resultado.

> [!NOTE]
> Si las claves se omiten en `project.pbxproj`, Xcode las leerá desde el archivo `Info.plist`.

Si el proyecto utiliza un `Info.plist` manual, agregar las claves directamente en ese archivo:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Requerido para enviar notificaciones.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Requerido para obtener la posición actual del dispositivo.</string>
<key>NSCameraUsageDescription</key>
<string>Requerido para verificar el estado del permiso de cámara.</string>
<key>NSContactsUsageDescription</key>
<string>Requerido para verificar el estado del permiso de contactos.</string>
```

> [!NOTE]
> **Deshabilitar el permiso de contactos (iOS):** Si el proyecto no requiere acceso a contactos, puedes suprimir la solicitud de permiso comentando los tres bloques relacionados en `WUIEnvironment.swift`: el `import Contacts`, el `case "contacts"` dentro del dispatcher de requests, y la llamada a `CNContactStore.authorizationStatus` dentro de `getPermissionsStatus`.
> Eliminar también `NSContactsUsageDescription` del `Info.plist`. iOS no solicitará el permiso al usuario en ese caso. Ver `app.agromapp.monitor.ios` como implementación de referencia.

<a name="ios-config-colors"></a>

### 3. Configuración de Colores en `Assets.xcassets`

La librería utiliza estos nombres de color set para el estilo de las barras de estado y navegación:

| Nombre del Color Set             | Valor por Defecto |
| -------------------------------- | ----------------- |
| `statusbarLightColor`            | `#f5f5f5` |
| `statusbarLightOverlayColor`     | `#c2c2c2` |
| `statusbarDarkColor`             | `#212121` |
| `statusbarDarkOverlayColor`      | `#616161` |
| `navigationbarLightColor`        | `#efeff6` |
| `navigationbarLightOverlayColor` | `#c0c0c6` |
| `navigationbarDarkColor`         | `#212121` |
| `navigationbarDarkOverlayColor`  | `#616161` |

Para agregar un color set en Xcode: abrir `Assets.xcassets`, hacer clic en **+** → **Color Set**, nombrarlo exactamente como se indica y definir el valor de color en el Attributes Inspector.

> [!WARNING]
> Todos los color sets utilizados por la aplicación deben estar definidos. Si un color nombrado no se encuentra en `Assets.xcassets`, `UIColor(named:)` devuelve `nil` y la barra afectada usará blanco por defecto.

> [!NOTE]
> Los colores **Light** son compatibles con el tema **default** del plugin **WUIPluginThemes** de la librería [wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib).<br>
> Los colores **Dark** se sugiere relacionarlos con el color de acento de la aplicación.

<a name="ios-config-wui-environment-swift"></a>

### 4. Integración de la clase Swift `WUIEnvironment.swift`

Copiar el archivo `src/wui-js/environment/ios/WUIEnvironment.swift` en el proyecto Xcode.

> [!NOTE]
> Agregar el archivo a la fase **Sources** del target en Xcode. No agregar como bundle resource.

<a name="ios-config-wui-environment-js"></a>

### 5. Integración de la clase JavaScript `wui-environment-0.6.js`

Copiar el contenido del directorio `src/wui-js/environment/web/` al directorio `assets/` del proyecto en Xcode. Se recomienda la siguiente estructura:

- `package/assets/libraries/wui-js/environment/web/wui-environment-0.6.js`
- `package/assets/libraries/wui-js/environment/demo/index.html`

Lo anterior asegura que los ejemplos de inicialización funcionen correctamente.

<a name="ios-config-packageapp"></a>

### 6. Inicialización del PackageApp `packageApp.swift`

El nombre del archivo `packageApp.swift` cambia dependiendo del nombre del paquete que se asignó al proyecto.

Usar `.onOpenURL` para interceptar URLs de Deep Link y reenviarlas al bridge mediante `NotificationCenter`. Este es el lugar correcto para manejar la apertura de URLs en una app SwiftUI.

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

### 7. Inicialización del MainView `MainView.swift`

El nombre del archivo `MainView.swift` es opcional, no obstante, debe ser coherente con el nombre de la función llamada desde `packageApp.swift`.

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
			// Reenvía las URLs de Deep Link a WUIEnvironment mediante NotificationCenter.
			// .onOpenURL gestiona tanto el lanzamiento de la app como la recepción en ejecución.
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
		
		// Cargar página inicial

		// comenta la siguiente línea después de validar la prueba
		let path = "assets/libraries/wui-js/environment/demo/index.html"
		// descomenta la siguiente línea después de validar la prueba
		//let path = "assets/pages/index.html"
		wuiEnvironment?.openUrl(url: Bundle.main.bundleURL.appendingPathComponent(path).absoluteString)

		// Solicitar permisos básicos

		wuiEnvironment?.requestPermission(type: "notifications") { granted in }
		wuiEnvironment?.requestPermission(type: "location") { granted in }
		//wuiEnvironment?.requestPermission(type: "camera") { granted in }

		// Agregar el detector de deep link

		NotificationCenter.default.addObserver(self, selector: #selector(handleDeepLink(_:)), name: .wuiDeepLink, object: nil)
	}

	deinit {

		// Eliminar el detector de deep link

		NotificationCenter.default.removeObserver(self, name: .wuiDeepLink, object: nil)
	}

	// Reenviar deep link

	@objc private func handleDeepLink(_ notification: Notification) {
		wuiEnvironment?.saveDeepLink(url: notification.object as? URL)
	}
}
```
