> [!IMPORTANT]
> La cuenta de GitHub `@wuiproject` se migró a `@wui-js` para que coincidiera con el nombre de la cuenta de NPM.

> [!WARNING]
> Este documento aún no ha sido terminado y esta en una versión preliminar.

> [!NOTE]
> For the English version of this document, see [README-en.md](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/README-en.md)

# wuijs-environment-lib

<div align="center">
	<img src="https://github.com/wui-js/wuijs-environment-lib/blob/main/imgs/logo/wuijs-environment-logotype-color.svg" width="220" height="220">
</div>

|                       | |
| --------------------- | ----------- |
| **Nombre librería**   | `wuijs-environment-lib` |
| **Versión librería**  | `0.3.1` ([Registro de Cambios](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)) |
| **Paquete npm**       | `@wui-js/environment` |
| **Versión documento** | `0.3.1.20260506.0` |
| **Licencia**          | `Licencia Apache 2.0` |
| **Autor**             | `Sergio E. Belmar V. <wuijs.project@gmail.com>` |
| **Repositorio**       | [https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib) |
| **Documentación**     | [https://docs.wuijs.dev](https://docs.wuijs.dev) |
| **Sitio web**         | [https://wuijs.dev](https://wuijs.dev) |

## Índice

*   [Descripción General](#overview)
	*   [Acerca del Proyecto WUI/JS](#project)
	*   [Mapa de Directorios](#dirmap)
*   [Inicio Rápido](#quickstart)
	*   [Android + Web](#quickstart-android)
	*   [iOS + Web](#quickstart-ios)
*   [Implementación en Android](#android)
	*   [Constructor Java](#android-constructor)
	*   [Métodos Java](#android-methods)
	*   [Eventos Android](#android-events)
	*   [Diálogos JavaScript](#android-dialogs)
	*   [Instalación y Configuración](#android-install)
		1.   [Clonar la librería](#android-clone)
		2.   [Configuración del Proyecto](#android-config-project)
		3.   [Configuración del Módulo](#android-config-module)
		4.   [Configuración del Manifest](#android-config-manifest)
		5.   [Configuración de Colores](#android-config-colors)
		6.   [Integración de la clase Java](#android-config-wui-environment-java)
		7.   [Integración de la clase JavaScript](#android-config-wui-environment-js)
		8.   [Inicialización del MainActivity](#android-config-mainactivity)
*   [Implementación en iOS](#ios)
	*   [Constructor Swift](#ios-constructor)
	*   [Métodos Swift](#ios-methods)
	*   [Eventos iOS](#ios-events)
	*   [Diálogos JavaScript](#ios-dialogs)
	*   [Instalación y Configuración](#ios-install)
		1.   [Clonar la librería](#ios-clone)
		2.   [Configuración de Permisos](#ios-config-permissions)
		3.   [Configuración de Colores](#ios-config-colors)
		4.   [Integración de la clase Swift](#ios-config-wui-environment-swift)
		5.   [Integración de la clase JavaScript](#ios-config-wui-environment-js)
		6.   [Inicialización del PackageApp](#ios-config-packageapp)
		7.   [Inicialización del MainView](#ios-config-mainview)
*   [Implementación en Web](#web)
	*   [Propiedades JavaScript](#web-properties)
	*   [Métodos de la Clase JavaScript](#web-class-methods)
	*   [Métodos de la Instancia JavaScript](#web-instance-methods)
	*   [Uso JavaScript](#web-js-usage)

<a name="overview"></a>

## Descripción General

WUI/JS Environment Lib es un puente (bridge) entre entornos web y motores de renderizado web nativos mediante JavaScript, diseñado para facilitar la creación de aplicaciones híbridas.
Proporciona acceso a instancias del hardware y del sistema tales como archivos, cámara, etc. directamente desde JavaScript.
Actualmente está disponible para Android en Java mediante WebView y para iOS en Swift mediante WebKit.

<a name="project"></a>

### Acerca del Proyecto WUI/JS

WUI/JS Environment Lib es parte del proyecto WUI/JS, que consta actualmente de 4 repositorios:

-	[https://github.com/wui-js/wuijs-main-lib](https://github.com/wui-js/wuijs-main-lib)<br>
	Librería UI principal.<br><br>
-	[https://github.com/wui-js/wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib)<br>
	Librería de complementos UI.<br><br>
-	[https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib)<br>
	Librería puente entre entornos web y motores de renderizado web nativos.<br><br>
-	[https://github.com/wui-js/wuijs-demos](https://github.com/wui-js/wuijs-demos)<br>
	Repositorio con demos y ejemplos de uso de las librerías del proyecto.<br><br>

<a name="dirmap"></a>

### Mapa de Directorios

La librería debe ser descargada desde el repositorio de GitHub [wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib). Esta librería cuenta con las 3 clases, Java para Android, Swift para iOS y JavaScript como contraparte Web para las dos anteriores.

La estructura de directorios del repositorio es:

```bash
wuijs-environment-lib/
├── docs/
├── imgs/
│   └── logo/
├── legacy/
│   └── wui-js/
│       └── environment/
└── src/
    └── wui-js/
        └── environment/
            ├── android/
            ├── ios/
            ├── web/
            └── demo/
```

| Ruta                                                                                                                        | Descripción |
| -----------------------------------------	--------------------------------------------------------------------------------- | ----------- |
| [docs](https://github.com/wui-js/wuijs-environment-lib/tree/main/docs/)                                                     | Documentación. |
| [imgs](https://github.com/wui-js/wuijs-environment-lib/tree/main/imgs/)                                                     | Imágenes utilizadas en la documentación. |
| [imgs/logo](https://github.com/wui-js/wuijs-environment-lib/tree/main/imgs/logo/)                                           | Logotipo e isotipo del proyecto en formato SVG y PNG. |
| [legacy](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/)                                                 | Fuentes obsoletas con versiones anteriores. |
| [legacy/wui-js](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/wui-js/)                                   | Directorio del proyecto WUI/JS. |
| [legacy/wui-js/environment](https://github.com/wui-js/wuijs-environment-lib/tree/main/legacy/wui-js/environment/)           | Librería WUI/JS Environment (versiones anteriores). |
| [src](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/)                                                       | Fuentes principales de la última versión. |
| [src/wui-js](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js)                                          | Directorio del proyecto WUI/JS. |
| [src/wui-js/environment/android](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/android/) | Librería WUI/JS Environment para Android. |
| [src/wui-js/environment/ios](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/ios/)         | Librería WUI/JS Environment para iOS. |
| [src/wui-js/environment/web](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/web/)         | Librería WUI/JS Environment para Web. |
| [src/wui-js/environment/demo](https://github.com/wui-js/wuijs-environment-lib/tree/main/src/wui-js/environment/demo/)       | Directorio con interfaz de prueba para entornos Android e iOS. |

> [!NOTE]
> La librería `wuijs-environment-lib` opera conjuntamente, es decir, se debe implementar la combinación **Android + Web** o **iOS + Web** para su correcto funcionamiento.

### Fuentes

| Tipo  | Versión | Archivo |
| ----- | -------:| ------- |
| Java  | 0.3     | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |
| Swift | 0.3     | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |
| JS    | 0.2     | [src/wui-js/environment/web/wui-environment-0.2.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.2.js) |

<a name="quickstart"></a>

## Inicio Rápido

Integración mínima para un proyecto nuevo. Para configuración completa ver las secciones específicas de cada plataforma.

<a name="quickstart-android"></a>

### Android + Web

**Requisitos:** Android Studio, proyecto nuevo con `AppCompatActivity` y `minSdk ≥ 24`.

1. Clonar la librería y copiar `src/wui-js/environment/android/WUIEnvironment.java` a `app/src/main/java/tu/paquete/nombre/`. Editar la primera línea para que coincida con el ID del paquete.
2. Copiar `src/wui-js/environment/web/` y `src/wui-js/environment/demo/` a `app/src/main/assets/libraries/wui-js/environment/`.
3. Agregar permisos, colores y configuración Gradle según [Instalación y Configuración](#android-install).
4. Inicializar en `MainActivity.java`:

```java
wuiEnvironment = new WUIEnvironment(this);
wuiEnvironment.openURL("file:///android_asset/libraries/wui-js/environment/demo/index.html");
wuiEnvironment.saveDeepLink(getIntent());
```

5. En las páginas HTML propias, incluir la clase JS e instanciarla:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Plataforma:", info.platform, "| Modelo:", info.model);
	});
</script>
```

<a name="quickstart-ios"></a>

### iOS + Web

**Requisitos:** Xcode 13+, proyecto nuevo con SwiftUI.

1. Clonar la librería y copiar `src/wui-js/environment/ios/WUIEnvironment.swift` al proyecto Xcode. Agregar el archivo a la fase **Sources** del target.
2. Copiar `src/wui-js/environment/web/` y `src/wui-js/environment/demo/` a una carpeta llamada `assets/libraries/wui-js/environment/` dentro del proyecto Xcode. Agregar la carpeta al target como **folder reference** (ícono azul en Xcode).
3. Agregar claves de permisos, color sets y configuración Deep Link según [Instalación y Configuración](#ios-install).
4. Inicializar en `EnvironmentViewController` dentro de `MainView.swift`:

```swift
wuiEnvironment = WUIEnvironment(viewController: self)
wuiEnvironment?.openURL(url: Bundle.main.bundleURL.appendingPathComponent("assets/libraries/wui-js/environment/demo/index.html").absoluteString)
```

5. En las páginas HTML propias, incluir la clase JS e instanciarla:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Plataforma:", info.platform, "| Modelo:", info.model);
	});
</script>
```

> [!NOTE]
> Abrir primero la página demo (`demo/index.html`) para verificar que el bridge funciona antes de cambiar a la URL de producción.

<a name="android"></a>

## Implementación en Android

La implementación en Android utiliza como motor de renderización WebView.

<a name="android-constructor"></a>

### Constructor Java

| Constructor | Descripción |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Inicializa el entorno WUI con configuración por defecto. `developMode = true` permite SSL con certificados no confiables y activa logs de depuración. **No usar `true` en producción** — deshabilita la validación de certificados en todo el WebView. |

<a name="android-methods"></a>

### Métodos Java

| Método                  | Tipo de retorno | Descripción |
| ----------------------- | --------------- | ----------- |
| `requestPermission`     | `void`          | `requestPermission(type, callback)`<br><br>Argumentos:<br>**• type:** `String`, uno de `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• callback:** `Consumer<Boolean>`, invocado con el resultado.<br><br>Solicita el permiso del sistema indicado. Si ya está concedido, invoca el callback de inmediato. Si está denegado permanentemente (`no volver a preguntar`), retorna `false` sin mostrar el diálogo. En Android < 13, `notifications` siempre resuelve a `true`. Delega el callback del OS a `MainActivity.onRequestPermissionsResult` → `handlePermissionResult(...)`. |
| `isAppInForeground`     | `boolean`       | `isAppInForeground()`<br><br>Verifica si la aplicación está actualmente en primer plano. |
| `getDeviceInfo`         | `JSONObject`    | `getDeviceInfo()`<br><br>Devuelve información de hardware del dispositivo: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`        | `JSONObject`    | `getDisplayInfo()`<br><br>Devuelve métricas de pantalla: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch`, flags de estilo de barras del sistema, `statusbarOverlay` (`true` cuando el contenido se renderiza detrás de la barra de estado — detectado mediante `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de estado con alpha < 255), y `navigationbarOverlay` (`true` cuando el contenido se renderiza detrás de la barra de navegación — detectado mediante `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra con alpha < 255). |
| `getAppInfo`            | `JSONObject`    | `getAppInfo()`<br><br>Devuelve metadatos de la aplicación: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`  | `JSONObject`    | `getPermissionsStatus()`<br><br>Verifica el estado de los permisos del sistema: `phone`, `location`, `storage`, `contacts`, `camera`, `notifications`. Valores posibles: `granted`, `denied`, `default`. |
| `getCurrentPosition`    | `JSONObject`    | `getCurrentPosition()`<br><br>Obtiene las coordenadas actuales GPS/Red: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Solicita el permiso de ubicación si no ha sido otorgado. |
| `getConnectionStatus`   | `boolean`       | `getConnectionStatus()`<br><br>Verifica si hay una conexión a internet activa (WiFi, datos móviles o Ethernet). |
| `setStatusbarStyle`     | `void`          | `setStatusbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o clave de `colors.xml` (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` para iconos oscuros, `false` para claros.<br><br>Actualiza el color y el estilo de iconos de la barra de estado. |
| `setNavigationbarStyle` | `void`          | `setNavigationbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o clave de `colors.xml` (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` para iconos oscuros, `false` para claros.<br><br>Actualiza el color y el estilo de iconos de la barra de navegación. |
| `setAppBadge`           | `void`          | `setAppBadge(number)`<br><br>Argumentos:<br>**• number:** `int`, contador de badge no negativo. `0` elimina el badge.<br><br>Establece o elimina el badge en el ícono de la aplicación con estrategia híbrida según fabricante. En launchers OEM con soporte nativo (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus) usa `ShortcutBadger` y muestra el número sobre el ícono sin publicar notificación. En launchers stock Pixel/AOSP cae a una notificación silenciosa (canal `wui_badge`, `IMPORTANCE_LOW`, `setShowBadge(true)`, `setNumber(n)`, `setSilent(true)`) que produce un punto (dot) — Pixel no renderiza número nativo. En Android 13+ solicita primero el permiso `POST_NOTIFICATIONS`; si se deniega, la llamada falla silenciosamente. |
| `saveFile`              | `boolean`       | `saveFile(name, content)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br>**• content:** `String`, contenido a guardar.<br><br>Escribe un archivo en el almacenamiento interno privado de la aplicación. Devuelve `true` si tuvo éxito. |
| `readFile`              | `String`        | `readFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Lee un archivo del almacenamiento interno. Devuelve `null` si no existe o hay error. |
| `removeFile`            | `boolean`       | `removeFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Elimina un archivo del almacenamiento interno. Devuelve `true` si tuvo éxito. |
| `openAppSettings`       | `void`          | `openAppSettings()`<br><br>Abre la pantalla de configuración de la aplicación en Ajustes del sistema. |
| `openURL`               | `void`          | `openURL(url)`<br><br>Argumentos:<br>**• url:** `String`, URL de destino o ruta de asset local (`file:///android_asset/...`).<br><br>Carga un asset local en el WebView o abre una URL externa mediante el Intent del sistema. |
| `saveDeepLink`          | `void`          | `saveDeepLink(intent)`<br><br>Argumentos:<br>**• intent:** `Intent`, intent recibido en `onCreate` u `onNewIntent`.<br><br>Extrae y almacena la URL del Deep Link del intent. Si la página ya está cargada, la envía inmediatamente al JavaScript. |
| `sendDeepLink`          | `void`          | `sendDeepLink()`<br><br>Envía la URL de Deep Link almacenada al JavaScript llamando a `WUIEnvironment.response()`. Solo actúa si la página ya está cargada. |
| `readDeepLink`          | `String`        | `readDeepLink()`<br><br>Devuelve la última URL de Deep Link almacenada, o `null` si no hay ninguna. |
| `clearDeepLink`         | `void`          | `clearDeepLink()`<br><br>Elimina la URL de Deep Link almacenada. |
| `log`                   | `void`          | `log(message[, force])`<br><br>Argumentos:<br>**• message:** `String`, mensaje a registrar.<br>**• force:** `boolean` *opcional*, por defecto `false`. Cuando es `true` omite la restricción de `developMode` y siempre escribe en Logcat.<br><br>Reenvía el mensaje a Logcat nativo bajo el tag `WUIEnvironment` con nivel `INFO` y prefijo `[js]`. Solo activo cuando `developMode = true`, salvo que `force` lo sobrescriba. |

<a name="android-events"></a>

### Eventos Android

Los eventos son callbacks que el lado nativo envía al JavaScript cuando una acción asíncrona se completa. Se deben configurar en la instancia de `WUIEnvironment` antes de cargar la primera página.

| Evento              | Argumentos                    | Descripción |
| ------------------- | ----------------------------- | ----------- |
| `onDownloadFile`    | `filename`, `mimetype`, `uri` | Se dispara cuando se completa la descarga de un archivo iniciada desde el WebView. El archivo se guarda en el directorio público `Downloads` del dispositivo y se abre automáticamente con la aplicación correspondiente. |
| `onReceiveDeepLink` | `url`                         | Se dispara cuando la aplicación recibe una URL de Deep Link (al abrir o durante la ejecución). |

<a name="android-dialogs"></a>

### Diálogos JavaScript

`WUIEnvironment` intercepta los diálogos estándar de JavaScript (`alert()`, `confirm()`, `prompt()`) y los renderiza mediante `AlertDialog` nativo. Esto reemplaza el diálogo por defecto del WebView, que antepone al mensaje el origen de la página (ej. `"La página 'file://' dice:"`).

| Diálogo     | Comportamiento |
| ----------- | -------------- |
| `alert()`   | Muestra un `AlertDialog` modal con el mensaje y un botón **OK**. Resuelve al confirmar. |
| `confirm()` | Muestra un `AlertDialog` modal con el mensaje y botones **OK** / **Cancelar**. Devuelve `true` al confirmar, `false` al cancelar. |
| `prompt()`  | Muestra un `AlertDialog` modal con el mensaje, un `EditText` con el valor por defecto y botones **OK** / **Cancelar**. Devuelve el texto ingresado al confirmar, `null` al cancelar. |

> [!NOTE]
> Los diálogos son modales (`setCancelable(false)`) — solo se descartan mediante los botones OK/Cancelar. Las etiquetas de los botones son auto-localizadas por el sistema (`android.R.string.ok` / `android.R.string.cancel`).

<a name="android-install"></a>

### Instalación y Configuración

<a name="android-clone"></a>

#### 1. Clonar la librería

Clonar el repositorio desde la cuenta oficial de wuiproject en GitHub:

```bash
git clone https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> El repositorio contendrá las 3 clases, Java para Android, Swift para iOS y JavaScript como contraparte Web.

<a name="android-config-project"></a>

#### 2. Configuración del Proyecto

Asegúrese de que los repositorios estén correctamente definidos:

```kotlin
dependencyResolutionManagement {
	repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
	repositories {
		google()
		mavenCentral()
	}
}
```

<a name="android-config-module"></a>

#### 3. Configuración del Módulo (`app/build.gradle.kts`)

Asegúrese de que `buildConfig` esté habilitado con el valor `true`:

```kotlin
android {
	buildFeatures {
		buildConfig = true
	}
}
```

Agregar la dependencia `ShortcutBadger` requerida por la rama OEM de `setAppBadge`:

```kotlin
dependencies {
	implementation("me.leolin:ShortcutBadger:1.1.22@aar")
}
```

> [!NOTE]
> `setAppBadge` usa una estrategia híbrida: `ShortcutBadger` para fabricantes con APIs propietarias de badge (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus — muestran número), y una notificación silenciosa como fallback para Pixel/AOSP (muestra punto/dot, no número, porque el launcher Pixel no soporta números nativos). La rama fallback agrega una entrada en el panel de notificaciones; la rama OEM no.

<a name="android-config-manifest"></a>

#### 4. Configuración del Manifest en `AndroidManifest.xml`

**Agregar Permisos**

Asegúrese de que la aplicación tenga los permisos necesarios. El bridge requiere al menos Internet y Estado de Red.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" /> -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Configuración Deep Link**

Para habilitar el Deep Link en la aplicación, agregar a la sección `application.activity` la siguiente sentencia:

```xml
<intent-filter>
	<action android:name="android.intent.action.VIEW" />
	<category android:name="android.intent.category.DEFAULT" />
	<category android:name="android.intent.category.BROWSABLE" />
	<data android:scheme="esquema_app" />
</intent-filter>
```

> [!IMPORTANT]
> El atributo `android:scheme` define el esquema de la aplicación. Permite acceder a la aplicación mediante una dirección URL en el navegador utilizando el esquema como protocolo.
> (ej: esquema_app://recurso_url)

**Configuración de intercambio de archivos**

Para habilitar el intercambio de archivos en la aplicación, agregar a la sección `application.activity` la siguiente sentencia:

```xml
<provider
	android:name="androidx.core.content.FileProvider"
	android:authorities="${applicationId}.provider"
	android:exported="false"
	android:grantUriPermissions="true">
	<meta-data
		android:name="android.support.FILE_PROVIDER_PATHS"
		android:resource="@xml/file_paths" />
</provider>
```

> [!NOTE]
> Esta configuración es requerida la implementación de descargas, cámara y compartir archivos por WhatsApp o Correo desde WebView.

<a name="android-config-colors"></a>

#### 5. Configuración de Colores en `res/values/colors.xml`

La librería utiliza estas llaves para el estilo de las barras de estado y navegación:

```xml
<resources>
	<color name="black">#FF000000</color>
	<color name="white">#FFFFFFFF</color>
	<color name="statusbarLightColor">#f5f5f5</color>
	<color name="statusbarLightOverlayColor">#c2c2c2</color>
	<color name="statusbarDarkColor">#212121</color>
	<color name="statusbarDarkOverlayColor">#616161</color>
	<color name="navigationbarLightColor">#efeff6</color>
	<color name="navigationbarLightOverlayColor">#c0c0c6</color>
	<color name="navigationbarDarkColor">#212121</color>
	<color name="navigationbarDarkOverlayColor">#616161</color>
</resources>
```

> [!WARNING]
> Se deben definir todas las llaves para que la clase Java no arroje error.

> [!NOTE]
> Los colores **Light** son compatibles con el tema **default** del plugin **WUIPluginThemes** de la librería [wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib).<br>
> Los colores **Dark** se sugiere relacionarlos con el color de acento de la aplicación.

<a name="android-config-wui-environment-java"></a>

#### 6. Integración de la clase Java `WUIEnvironment.java`

Copiar el archivo `src/wui-js/environment/android/WUIEnvironment.java` a la carpeta de fuentes del proyecto (ej: `app/src/main/java/your/package/name/` si el ID del paquete definido fuese `your.package.name`).

> [!IMPORTANT]
> Se debe editar la primera línea del archivo para que coincida con el ID del paquete de la aplicación:

```java
package YOUR.PACKAGE.NAME; // Update this to match your project package
```

<a name="android-config-wui-environment-js"></a>

#### 7. Integración de la clase JavaScript `wui-environment-0.2.js`

Copiar el contenido del directorio `src/wui-js/environment/web/` al directorio `assets/` del proyecto Android. Se recomienda la siguiente estructura:

- `app/src/main/assets/libraries/wui-js/environment/web/wui-environment-0.2.js`
- `app/src/main/assets/libraries/wui-js/environment/demo/index.html`

Lo anterior asegura que los ejemplos de inicialización funcionen correctamente.

<a name="android-config-mainactivity"></a>

#### 8. Inicialización del MainActivity `MainActivity.java`

```java
package YOUR.PACKAGE.NAME;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {

	private WUIEnvironment wuiEnvironment;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		try {
			wuiEnvironment = new WUIEnvironment(this);

			// Cargar página inicial

			// comenta la siguiente línea después de validar la prueba
			String path = "libraries/wui-js/environment/demo/index.html";
			// descomenta la siguiente línea después de validar la prueba
			//String path = "file:///android_asset/pages/index.html";
			wuiEnvironment.openURL("file:///android_asset/" + path);

			// Solicitar permisos básicos

			wuiEnvironment.requestPermission("notifications", null);
			wuiEnvironment.requestPermission("location", null);
			//wuiEnvironment.requestPermission("camera", null);

			// Habilitar peticiones Deep Link durante la apertura de la app

			wuiEnvironment.saveDeepLink(getIntent());
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);

		// Habilitar peticiones Deep Link durante la ejecución de la app

		try {
			wuiEnvironment.saveDeepLink(intent);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);

		// Requerido por requestPermission() - reenvía el callback del OS al bridge

		if (wuiEnvironment != null) {
			wuiEnvironment.handlePermissionResult(requestCode, permissions, grantResults);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		// Requerido por onShowFileChooser() - reenvía el resultado del selector de archivos al puente.

		if (wuiEnvironment != null) {
			wuiEnvironment.handleFileChooserResult(requestCode, resultCode, data);
		}
	}
}
```

> [!IMPORTANT]
> El override de `onRequestPermissionsResult` es requerido por `requestPermission` (y por cualquier método que dependa de él: `setAppBadge`, `getCurrentPosition`). Sin él, el diálogo de permiso aparece pero el callback nunca resuelve.

<a name="ios"></a>

## Implementación en iOS

La implementación en iOS utiliza como motor de renderización WebKit (WKWebView) y se comunica mediante `WKScriptMessageHandler`.

> [!NOTE]
> **Limitación de XHR con `file://` en WKWebView:** WKWebView bloquea todas las llamadas `XMLHttpRequest` a URLs `file://` sin importar el valor de `allowingReadAccessTo`. `WUIEnvironment` inyecta automáticamente un `WKUserScript` al inicio del documento que intercepta estas solicitudes y las enruta por el bridge nativo mediante `webkit.messageHandlers.request`. Esto es transparente para el código JavaScript — `XMLHttpRequest` funciona con normalidad tanto para archivos locales como para URLs remotas.

<a name="ios-constructor"></a>

### Constructor Swift

| Constructor | Descripción |
| ----------- | ----------- |
| `WUIEnvironment(viewController: UIViewController[, developMode: Bool])` | Inicializa el entorno WUI. `developMode = true` permite SSL con certificados no confiables y activa logs de depuración. **No usar `true` en producción** — deshabilita la validación de certificados en todo el WKWebView. |

<a name="ios-methods"></a>

### Métodos Swift

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
| `openURL`               | `void`          | `openURL(url)`<br><br>Argumentos:<br>**• url:** `String`, URL de destino o ruta de archivo local (`file://...`).<br><br>Carga un archivo local en el WKWebView con `loadFileURL` o abre una URL externa mediante `UIApplication.shared.open`. |
| `saveDeepLink`          | `void`          | `saveDeepLink(url)`<br><br>Argumentos:<br>**• url:** `URL?`, URL recibida en `scene(_:openURLContexts:)` o `application(_:open:)`.<br><br>Extrae y almacena la URL del Deep Link. Si la página ya está cargada, la envía inmediatamente al JavaScript. |
| `sendDeepLink`          | `void`          | `sendDeepLink()`<br><br>Envía la URL de Deep Link almacenada al JavaScript llamando a `WUIEnvironment.response()`. Solo actúa si la página ya está cargada. |
| `readDeepLink`          | `String?`       | `readDeepLink()`<br><br>Devuelve la última URL de Deep Link almacenada, o `nil` si no hay ninguna. |
| `clearDeepLink`         | `void`          | `clearDeepLink()`<br><br>Elimina la URL de Deep Link almacenada. |
| `log`                   | `void`          | `log(_ message[, force:])`<br><br>Argumentos:<br>**• message:** `String` (autoclosure), mensaje a registrar.<br>**• force:** `Bool` *opcional*, por defecto `false`. Cuando es `true` omite la restricción de `developMode` y siempre escribe en la consola de Xcode.<br><br>Reenvía el mensaje a la consola de Xcode con el prefijo `[WUIEnvironment][js]`. Solo activo cuando `developMode = true`, salvo que `force` lo sobrescriba. |

<a name="ios-events"></a>

### Eventos iOS

Los eventos son callbacks que el lado nativo envía al JavaScript cuando una acción asíncrona se completa. Se deben configurar en la instancia de `WUIEnvironment` antes de cargar la primera página.

| Evento              | Argumentos                    | Descripción |
| ------------------- | ----------------------------- | ----------- |
| `onDownloadFile`    | `filename`, `mimetype`, `uri` | Se dispara cuando se completa la descarga de un archivo iniciada desde el WebView. El archivo se guarda en `Documents/Downloads/` dentro del sandbox de la app y se abre mediante `UIActivityViewController`. Requiere iOS 14.5+ para `WKDownloadDelegate`; en versiones anteriores se usa `URLSession` como fallback. |
| `onReceiveDeepLink` | `url`                         | Se dispara cuando la aplicación recibe una URL de Deep Link (al abrir o durante la ejecución). |

<a name="ios-dialogs"></a>

### Diálogos JavaScript

`WUIEnvironment` intercepta los diálogos estándar de JavaScript (`alert()`, `confirm()`, `prompt()`) y los renderiza mediante `UIAlertController` nativo. WKWebView descarta silenciosamente estos diálogos cuando el `WKUIDelegate` no implementa los panel handlers correspondientes — `WUIEnvironment` los provee.

| Diálogo     | Comportamiento |
| ----------- | -------------- |
| `alert()`   | Muestra un `UIAlertController` estilo alert con el mensaje y un botón **OK**. Resuelve al confirmar. |
| `confirm()` | Muestra un `UIAlertController` estilo alert con el mensaje y botones **OK** / **Cancelar**. Devuelve `true` al confirmar, `false` al cancelar. |
| `prompt()`  | Muestra un `UIAlertController` estilo alert con el mensaje, un `UITextField` con el valor por defecto y botones **OK** / **Cancelar**. Devuelve el texto ingresado al confirmar, `null` al cancelar. |

<a name="ios-install"></a>

### Instalación y Configuración

<a name="ios-clone"></a>

#### 1. Clonar la librería

Clonar el repositorio desde GitHub si aún no se ha realizado:

```bash
git clone https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> El repositorio contendrá las 3 clases, Java para Android, Swift para iOS y JavaScript como contraparte Web.

<a name="ios-config-permissions"></a>

#### 2. Configuración de Permisos (`Info.plist` o `project.pbxproj`)

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

#### 3. Configuración de Colores en `Assets.xcassets`

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

#### 4. Integración de la clase Swift `WUIEnvironment.swift`

Copiar el archivo `src/wui-js/environment/ios/WUIEnvironment.swift` en el proyecto Xcode.

> [!NOTE]
> Agregar el archivo a la fase **Sources** del target en Xcode. No agregar como bundle resource.

<a name="ios-config-wui-environment-js"></a>

#### 5. Integración de la clase JavaScript `wui-environment-0.2.js`

Copiar el contenido del directorio `src/wui-js/environment/web/` al directorio `assets/` del proyecto en Xcode. Se recomienda la siguiente estructura:

- `package/assets/libraries/wui-js/environment/web/wui-environment-0.2.js`
- `package/assets/libraries/wui-js/environment/demo/index.html`

Lo anterior asegura que los ejemplos de inicialización funcionen correctamente.

<a name="ios-config-packageapp"></a>

#### 6. Inicialización del PackageApp `packageApp.swift`

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
			MainView().onOpenURL { url in
				NotificationCenter.default.post(name: .wuiDeepLink, object: url)
			}
		}
	}
}
```

<a name="ios-config-mainview"></a>

#### 7. Inicialización del MainView `MainView.swift`

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
		wuiEnvironment?.openURL(url: Bundle.main.bundleURL.appendingPathComponent(path).absoluteString)

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

<a name="web"></a>

## Implementación en Web

La clase JavaScript `WUIEnvironment` debe ser incluida en cada página HTML que utilice el bridge. Copiar `wui-environment-0.2.js` a la carpeta de assets del proyecto y cargarlo con una etiqueta `<script>` antes de cualquier llamada al bridge:

```html
<!DOCTYPE html>
<html>
<head>
	<script src="libraries/wui-js/environment/web/wui-environment-0.2.js"></script>
</head>
<body>
	<script>
		const env = new WUIEnvironment();
		env.getDeviceInfo(function(info) {
			console.log("Plataforma:", info.platform);
		});
	</script>
</body>
</html>
```

> [!NOTE]
> La ruta en `src` es relativa al archivo HTML. En Android, los assets se cargan desde `app/src/main/assets/`; en iOS, desde la carpeta `assets/` agregada al target de Xcode. La ruta recomendada `libraries/wui-js/environment/web/wui-environment-0.2.js` coincide con la estructura descrita en los pasos de instalación.

**Comportamiento del bridge por plataforma:**
- **Android**: las llamadas son **síncronas** — `Android.request()` devuelve el resultado inmediatamente.
- **iOS**: las llamadas son **asíncronas** — el lado nativo llama a `WUIEnvironment.response()` cuando termina.

La librería JS abstrae ambos comportamientos en la misma API basada en callbacks.

<a name="web-properties"></a>

### Propiedades JavaScript

Campos públicos y propiedades getter/setter de la instancia de `WUIEnvironment`.

| Propiedad           | Tipo 	         | Valor por defecto                                         | Descripción |
| ------------------- | ---------------- | --------------------------------------------------------- | ----------- |
| `userAgent`         | `string`         | `navigator.userAgent`                                     | (get)<br><br>String raw del user agent. Resuelto al momento de construcción. |
| `platform`          | `string`         | `navigator.userAgentData?.platform \| navigator.platform` | (get)<br><br>String de plataforma desde el navegador o el SO. Resuelto al momento de construcción. |
| `systemName`        | `string`         | `""`                                                      | (get)<br><br>Nombre normalizado del SO derivado de `platform`: `"iOS"`, `"Android"`, `"macOS"`, `"Linux"`, `"Windows Phone"`, `"Windows"` o `""`. Resuelto al momento de construcción. |
| `environment`       | `string`         | `"web"`                                                   | (get)<br><br>Identificador del entorno de ejecución: `"local.android"` cuando se ejecuta en un WebView Android, `"local.ios"` cuando se ejecuta en un WKWebView iOS, o `"web"` en cualquier otro caso. Resuelto al momento de construcción. |
| `localStorage`      | `boolean`        | `true`                                                    | (get/set)<br><br>Cuando es `true`, `saveFile`, `readFile` y `removeFile` usan `window.localStorage` como fallback en web. No tiene efecto dentro de un WebView nativo. |
| `onReady`           | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando todas las solicitudes bridge pendientes han recibido respuesta. Recibe el número total de solicitudes como argumento. Si se asigna después de que todas las solicitudes ya se resolvieron, se ejecuta inmediatamente. |
| `onDownloadFile`    | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando se completa la descarga de un archivo iniciada desde el WebView. Recibe `{ filename, mimetype, uri }`. Debe asignarse antes de cargar la primera página. |
| `onReceiveDeepLink` | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando la app recibe una URL de Deep Link. Recibe la URL como string. Debe asignarse antes de cargar la primera página. |

<a name="web-class-methods"></a>

### Métodos de la Clase JavaScript

Miembros estáticos de la clase `WUIEnvironment`.

| Miembro          | Tipo              | Descripción |
| ---------------- | ----------------- | ----------- |
| `response(args)` | `método estático` | Punto de entrada para la comunicación nativo→JS. Llamado internamente por el bridge nativo para entregar respuestas de solicitudes y despachar los eventos `onDownloadFile` / `onReceiveDeepLink`. No está destinado a ser llamado desde el código de la aplicación. |

<a name="web-instance-methods"></a>

### Métodos de la Instancia JavaScript

| Método                  | Tipo de retorno           | Descripción |
| ----------------------- | ------------------------- | ----------- |
| `requestPermission`     | `Promise<boolean>`        | `requestPermission(type[, done])`<br><br>Argumentos:<br>**• type:** `string`, uno de `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• done:** `function` *opcional*, callback.<br><br>Solicita el permiso del sistema indicado. Dentro de un WebView nativo delega al bridge (`requestPermission`). En web recae en `navigator.permissions.query`. Resuelve con `true` cuando está concedido. |
| `isLocal`               | `boolean`                 | `isLocal()`<br><br>Devuelve `true` cuando se ejecuta dentro de un WebView nativo (`local.android` o `local.ios`). Devuelve `null` en web. Se resuelve sincrónicamente desde el valor establecido al momento de construcción. |
| `isMobile`              | `boolean`                 | `isMobileEnvironment()`<br><br>Devuelve `true` cuando se ejecuta en un dispositivo móvil (Android, iOS o Windows Phone). Devuelve `false` en web. Se resuelve sincrónicamente desde el valor establecido al momento de construcción. |
| `isTouch`               | `boolean`                 | `isTouch()`<br><br>Devuelve `true` cuando se ejecuta en un dispositivo con pantalla táctil. Devuelve `false` en web. Se resuelve sincrónicamente desde el valor establecido al momento de construcción. |
| `isTablet`              | `boolean`                 | `isTablet()`<br><br>Devuelve `true` cuando se ejecuta en un dispositivo tablet (Android, iOS o Windows Phone). Devuelve `false` en web. Se resuelve sincrónicamente desde el valor establecido al momento de construcción. |
| `isAppInForeground`     | `Promise<boolean>`        | `isAppInForeground([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Verifica si la aplicación está en primer plano. Devuelve `null` en web. |
| `getDeviceInfo`         | `Promise<Object>`         | `getDeviceInfo([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Obtiene información del hardware (UUID, modelo, plataforma, etc.). En web devuelve `{ platform: systemName }`. |
| `getDisplayInfo`        | `Promise<Object>`         | `getDisplayInfo([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Obtiene métricas de pantalla y modo de navegación. En web devuelve `{ width, height, notch: false ... }`. |
| `getAppInfo`            | `Promise<Object>`         | `getAppInfo([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Obtiene metadatos de la aplicación. Devuelve `null` en web. |
| `getPermissionsStatus`  | `Promise<Object>`         | `getPermissionsStatus([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Consulta el estado de los permisos del sistema. En web usa `navigator.permissions` cuando está disponible. |
| `getCurrentPosition`    | `Promise<Object>`         | `getCurrentPosition([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Obtiene la ubicación GPS actual. En web usa `navigator.geolocation`. |
| `getConnectionStatus`   | `Promise<boolean>`        | `getConnectionStatus([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Verifica si hay conexión a internet activa. En web usa `navigator.onLine`. |
| `setStatusbarStyle`     | `void`                    | `setStatusbarStyle(color, darkIcons[, done])`<br><br>Argumentos:<br>**• color:** `string`, color en formato HEX o ID de recurso.<br>**• darkIcons:** `boolean`, iconos oscuros.<br>**• done:** `function` *opcional*, callback.<br><br>Cambia el color y estilo de la barra de estado. Sin efecto en web. |
| `setNavigationbarStyle` | `void`                    | `setNavigationbarStyle(color, darkIcons[, done])`<br><br>Argumentos:<br>**• color:** `string`, color en formato HEX o ID de recurso.<br>**• darkIcons:** `boolean`, iconos oscuros.<br>**• done:** `function` *opcional*, callback.<br><br>Cambia el color y estilo de la barra de navegación. Sin efecto en web. |
| `setAppBadge`           | `Promise<void>`           | `setAppBadge(number[, done])`<br><br>Argumentos:<br>**• number:** `number`, contador de badge no negativo. `0` elimina el badge.<br>**• done:** `function` *opcional*, callback.<br><br>Establece o elimina el badge en el ícono de la aplicación. En web usa la Badging API (`navigator.setAppBadge` / `navigator.clearAppBadge`) cuando está disponible. |
| `saveFile`              | `Promise<boolean>`        | `saveFile(name, content[, done])`<br><br>Argumentos:<br>**• name:** `string`, nombre del archivo.<br>**• content:** `string\|Object`, contenido (los objetos se serializan como JSON para archivos `.json`).<br>**• done:** `function` *opcional*, callback.<br><br>Guarda un archivo en el almacenamiento nativo. En web usa `localStorage` si `localStorage` es `true`. |
| `readFile`              | `Promise<string\|Object>` | `readFile(name[, done])`<br><br>Argumentos:<br>**• name:** `string`, nombre del archivo.<br>**• done:** `function` *opcional*, callback.<br><br>Lee un archivo del almacenamiento nativo. Los archivos `.json` se parsean automáticamente. En web usa `localStorage` si `localStorage` es `true`. |
| `removeFile`            | `Promise<boolean>`        | `removeFile(name[, done])`<br><br>Argumentos:<br>**• name:** `string`, nombre del archivo.<br>**• done:** `function` *opcional*, callback.<br><br>Elimina un archivo del almacenamiento nativo. En web usa `localStorage`. |
| `openAppSettings`       | `void`                    | `openAppSettings([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Abre la pantalla de configuración de la aplicación. Sin efecto en web. |
| `openURL`               | `void`                    | `openURL(url)`<br><br>Argumentos:<br>**• url:** `string`, la URL de destino o ruta de asset local.<br><br>Abre un recurso local en el WebView o un enlace externo. En web usa `window.open`. |
| `readDeepLink`          | `Promise<string>`         | `readDeepLink([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Lee la última URL de Deep Link recibida. Devuelve `null` en web. |
| `clearDeepLink`         | `void`                    | `clearDeepLink([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Limpia la URL de Deep Link almacenada. Sin efecto en web. |
| `log`                   | `void`                    | `log(message[, force])`<br><br>Argumentos:<br>**• message:** `any`, valor a registrar (coercionado a string).<br>**• force:** `boolean` *opcional*, por defecto `false`. Cuando es `true` instruye al lado nativo a omitir su restricción de `developMode` y escribir siempre el mensaje.<br><br>Dentro de un WebView nativo reenvía el mensaje al logger nativo (Logcat / consola de Xcode). En web recae en `console.log`. |

<a name="web-js-usage"></a>

### Uso JavaScript

```js
const env = new WUIEnvironment();

// Configurar los handlers de eventos antes de cargar la primera página

env.onReady = function(count) {
	console.log("Todas las", count, "solicitudes resueltas");
};
env.onDownloadFile = function(args) {
	console.log("Descargado:", args.filename, args.mimetype, args.uri);
};
env.onReceiveDeepLink = function(url) {
	console.log("Deep Link recibido:", url);
};

// Usa onReady para esperar a que todas las solicitudes iniciales se resuelvan

env.getDeviceInfo(function(info) {
	console.log("Plataforma:", info.platform);
});
env.getDisplayInfo(function(display) {
	console.log("Notch:", display.notch);
	console.log("Altura status bar:", display.statusbarHeight);
});
env.getConnectionStatus(function(connected) {
	console.log("Conectado:", connected);
});
env.getCurrentPosition(function(position) {
	if (position.error) {
		console.error("Error de ubicación:", position.error);
	} else {
		console.log("Lat:", position.latitude, "Lon:", position.longitude);
	}
});
```

> [!NOTE]
> Al probar `getCurrentPosition` en el simulador de Android, se debe configurar una ubicación simulada: **menú del Simulador → Extended controls → Location**, en el simulador de iOS, se debe configurar en: **menú del Simulador → Features → Location**
