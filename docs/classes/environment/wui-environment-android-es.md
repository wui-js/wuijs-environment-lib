[English](wui-environment-android-en.md) | [Español](wui-environment-android-es.md)

[wuijs-environment-lib](../../README-es.md)

Plataformas: [Android](wui-environment-android-es.md) | [iOS](wui-environment-ios-es.md) | [Web](wui-environment-web-es.md)

# WUIEnvironment (Android)

Versión: `0.6`

La librería Java para Android utiliza como motor de renderización **WebView**.

## Fuentes

| Tipo | Archivo |
|:----:| ------- |
| Java | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |

<a name="android-constructor"></a>

## Constructor Java

| Constructor | Descripción |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Inicializa el entorno WUI con configuración por defecto. `developMode = true` permite SSL con certificados no confiables, activa logs de depuración y habilita la inspección del WebView con Chrome DevTools (`chrome://inspect`). **No usar `true` en producción** — deshabilita la validación de certificados en todo el WebView. |

<a name="android-methods"></a>

## Métodos Java

| Método                   | Tipo de retorno | Descripción |
| ------------------------ | --------------- | ----------- |
| `requestPermission`      | `void`          | `requestPermission(type, callback)`<br><br>Argumentos:<br>**• type:** `String`, uno de `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• callback:** `Consumer<Boolean>`, invocado con el resultado.<br><br>Solicita el permiso del sistema indicado. Si ya está concedido, invoca el callback de inmediato. Si está denegado permanentemente (`no volver a preguntar`), retorna `false` sin mostrar el diálogo. En Android < 13, `notifications` siempre resuelve a `true`. Delega el callback del OS a `MainActivity.onRequestPermissionsResult` → `handlePermissionResult(...)`. |
| `handlePermissionResult` | `void`          | `handlePermissionResult(requestCode, permissions, grantResults)`<br><br>Parámetros:<br>**• requestCode:** `int`, código de solicitud recibido en `onRequestPermissionsResult`.<br>**• permissions:** `String[]`, permisos solicitados.<br>**• grantResults:** `int[]`, resultados de la solicitud.<br><br>Reenvía el resultado de una solicitud de permisos al callback registrado por `requestPermission`. Debe llamarse desde `onRequestPermissionsResult` de la actividad (ver [Inicialización del MainActivity](#android-config-mainactivity)). |
| `isAppInForeground`      | `boolean`       | `isAppInForeground()`<br><br>Verifica si la aplicación está actualmente en primer plano. |
| `getDeviceInfo`          | `JSONObject`    | `getDeviceInfo()`<br><br>Devuelve información de hardware del dispositivo: `id`, `uuid`, `name`, `platform`, `version`, `maker`, `model`. |
| `getDisplayInfo`         | `JSONObject`    | `getDisplayInfo()`<br><br>Devuelve métricas de pantalla: `width`, `height`, `density`, `densityDpi`, `orientation`, `refreshRate`, `aspectRatio`, `navigationMode`, `statusbarHeight`, `navigationbarHeight`, `notch`, flags de estilo de barras del sistema, `statusbarOverlay` (`true` cuando el contenido se renderiza detrás de la barra de estado — detectado mediante `FLAG_TRANSLUCENT_STATUS`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra de estado con alpha < 255), y `navigationbarOverlay` (`true` cuando el contenido se renderiza detrás de la barra de navegación — detectado mediante `FLAG_TRANSLUCENT_NAVIGATION`, `FLAG_LAYOUT_NO_LIMITS`, o un color de barra con alpha < 255). |
| `getAppInfo`             | `JSONObject`    | `getAppInfo()`<br><br>Devuelve metadatos de la aplicación: `name`, `version`, `package`, `build`. |
| `getPermissionsStatus`   | `JSONObject`    | `getPermissionsStatus()`<br><br>Verifica el estado de los permisos del sistema: `phone`, `location`, `storage`, `contacts`, `camera`, `notifications`. Valores posibles: `granted`, `denied`, `default`. |
| `getCurrentPosition`     | `JSONObject`    | `getCurrentPosition()`<br><br>Obtiene las coordenadas actuales GPS/Red: `latitude`, `longitude`, `accuracy`, `provider`, `timestamp`. Solicita el permiso de ubicación si no ha sido otorgado. |
| `getConnectionStatus`    | `boolean`       | `getConnectionStatus()`<br><br>Verifica si hay una conexión a internet activa (WiFi, datos móviles o Ethernet). |
| `setStatusbarStyle`      | `void`          | `setStatusbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o clave de `colors.xml` (`statusbarLightColor`, `statusbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` para iconos oscuros, `false` para claros.<br><br>Actualiza el color y el estilo de iconos de la barra de estado. |
| `setNavigationbarStyle`  | `void`          | `setNavigationbarStyle(color, darkIcons)`<br><br>Argumentos:<br>**• color:** `String`, color HEX (`#RRGGBB`) o clave de `colors.xml` (`navigationbarLightColor`, `navigationbarDarkColor`, etc.).<br>**• darkIcons:** `boolean`, `true` para iconos oscuros, `false` para claros.<br><br>Actualiza el color y el estilo de iconos de la barra de navegación. |
| `setAppBadge`            | `void`          | `setAppBadge(number)`<br><br>Argumentos:<br>**• number:** `int`, contador de badge no negativo. `0` elimina el badge.<br><br>Establece o elimina el badge en el ícono de la aplicación con estrategia híbrida según fabricante. En launchers OEM con soporte nativo (Samsung, Xiaomi, Huawei, Honor, Oppo, Vivo, Sony, HTC, LG, Asus) usa `ShortcutBadger` y muestra el número sobre el ícono sin publicar notificación. En launchers stock Pixel/AOSP cae a una notificación silenciosa (canal `wui_badge`, `IMPORTANCE_LOW`, `setShowBadge(true)`, `setNumber(n)`, `setSilent(true)`) que produce un punto (dot) — Pixel no renderiza número nativo. En Android 13+ solicita primero el permiso `POST_NOTIFICATIONS`; si se deniega, la llamada falla silenciosamente. |
| `saveFile`               | `boolean`       | `saveFile(name, content)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br>**• content:** `String`, contenido a guardar.<br><br>Escribe un archivo en el almacenamiento interno privado de la aplicación. Devuelve `true` si tuvo éxito. |
| `readFile`               | `String`        | `readFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Lee un archivo del almacenamiento interno. Devuelve `null` si no existe o hay error. |
| `removeFile`             | `boolean`       | `removeFile(name)`<br><br>Argumentos:<br>**• name:** `String`, nombre del archivo.<br><br>Elimina un archivo del almacenamiento interno. Devuelve `true` si tuvo éxito. |
| `openAppSettings`        | `void`          | `openAppSettings()`<br><br>Abre la pantalla de configuración de la aplicación en Ajustes del sistema. |
| `openUrl`                | `void`          | `openUrl(url)`<br><br>Argumentos:<br>**• url:** `String`, URL de destino o ruta de asset local (`file:///android_asset/...`).<br><br>Carga un asset local en el WebView o abre una URL externa mediante el Intent del sistema. |
| `saveDeepLink`           | `void`          | `saveDeepLink(intent)`<br><br>Argumentos:<br>**• intent:** `Intent`, intent recibido en `onCreate` u `onNewIntent`.<br><br>Extrae y almacena la URL del Deep Link del intent. Si la página ya está cargada, la envía inmediatamente al JavaScript. |
| `sendDeepLink`           | `void`          | `sendDeepLink()`<br><br>Envía la URL de Deep Link almacenada al JavaScript llamando a `WUIEnvironment.response()`. Solo actúa si la página ya está cargada. |
| `readDeepLink`           | `String`        | `readDeepLink()`<br><br>Devuelve la última URL de Deep Link almacenada, o `null` si no hay ninguna. |
| `clearDeepLink`          | `void`          | `clearDeepLink()`<br><br>Elimina la URL de Deep Link almacenada. |
| `downloadFile`           | `void`          | `downloadFile(url, filename, headers[, key])`<br><br>Parámetros:<br>**• url:** `String`, URL del archivo.<br>**• filename:** `String`, nombre sugerido del archivo; si está vacío, se toma de la URL.<br>**• headers:** `JSONObject`, cabeceras HTTP enviadas con la solicitud (ej. `Authorization`).<br>**• key:** `String` *opcional*, identificador de la descarga que se devuelve en los eventos `onDownloadProgress` y `onDownloadFile` (`null` si se omite).<br><br>Descarga un archivo con `DownloadManager` enviando las cabeceras HTTP indicadas. Pueden ejecutarse varias descargas al mismo tiempo; cada una se sigue en su propio hilo. Emite los mismos eventos `onDownloadProgress` y `onDownloadFile` que una descarga iniciada desde el WebView, y se puede cancelar con `cancelDownload(key)`. Los valores de las cabeceras no se registran en el log. |
| `cancelDownload`         | `void`          | `cancelDownload([key])`<br><br>Parámetros:<br>**• key:** `String` *opcional*. Descarga a cancelar; si es `null` o se omite, se cancelan todas las descargas en curso.<br><br>Cancela descargas en curso. Una descarga que ya se completó no se elimina. Una descarga cancelada dispara `onDownloadFile` con `status: "cancelled"`. **Pendiente de prueba.** |
| `log`                    | `void`          | `log(message[, force])`<br><br>Argumentos:<br>**• message:** `String`, mensaje a registrar.<br>**• force:** `boolean` *opcional*, por defecto `false`. Cuando es `true` omite la restricción de `developMode` y siempre escribe en Logcat.<br><br>Reenvía el mensaje a Logcat nativo bajo el tag `WUIEnvironment` con nivel `INFO` y prefijo `[js]`. Solo activo cuando `developMode = true`, salvo que `force` lo sobrescriba. |

<a name="android-events"></a>

## Eventos Android

Los eventos son callbacks que el lado nativo envía al JavaScript cuando una acción asíncrona se completa. Se deben configurar en la instancia de `WUIEnvironment` antes de cargar la primera página.

| Evento               | Argumentos                                                   | Descripción |
| -------------------- | ------------------------------------------------------------ | ----------- |
| `onDownloadProgress` | `key`, `loaded`, `total`                                     | Se dispara aproximadamente cada 250 ms mientras está en curso la descarga de un archivo iniciada desde el WebView. `loaded` es la cantidad de bytes recibidos y `total` el tamaño del archivo en bytes, o `-1` si no se conoce. `key` es el identificador pasado a `downloadFile()`, o `null` en las descargas iniciadas desde el WebView. |
| `onDownloadFile`     | `key`, `filename`, `mimetype`, `uri`, `status`, `httpStatus` | Se dispara cuando termina la descarga de un archivo iniciada desde el WebView. `status` es `"success"`, `"failed"` o `"cancelled"`; `uri` es `null` cuando no es `"success"`. `httpStatus` es el código HTTP cuando la descarga falló por una respuesta HTTP (`COLUMN_REASON`), o `null`. Si la descarga es exitosa, el archivo se guarda en el directorio público `Downloads` del dispositivo y se abre automáticamente con la aplicación correspondiente. Con `DownloadManager` se dispara cuando la descarga se completa o falla (hasta la versión 0.5 se disparaba al encolar la descarga). `key` es el identificador pasado a `downloadFile()`, o `null` en las descargas iniciadas desde el WebView. |
| `onReceiveDeepLink`  | `url`                                                        | Se dispara cuando la aplicación recibe una URL de Deep Link (al abrir o durante la ejecución). |

<a name="android-dialogs"></a>

## Diálogos JavaScript

`WUIEnvironment` intercepta los diálogos estándar de JavaScript (`alert()`, `confirm()`, `prompt()`) y los renderiza mediante `AlertDialog` nativo. Esto reemplaza el diálogo por defecto del WebView, que antepone al mensaje el origen de la página (ej. `"La página 'file://' dice:"`).

| Diálogo     | Comportamiento |
| ----------- | -------------- |
| `alert()`   | Muestra un `AlertDialog` modal con el mensaje y un botón **OK**. Resuelve al confirmar. |
| `confirm()` | Muestra un `AlertDialog` modal con el mensaje y botones **OK** / **Cancelar**. Devuelve `true` al confirmar, `false` al cancelar. |
| `prompt()`  | Muestra un `AlertDialog` modal con el mensaje, un `EditText` con el valor por defecto y botones **OK** / **Cancelar**. Devuelve el texto ingresado al confirmar, `null` al cancelar. |

> [!NOTE]
> Los diálogos son modales (`setCancelable(false)`) — solo se descartan mediante los botones OK/Cancelar. Las etiquetas de los botones son auto-localizadas por el sistema (`android.R.string.ok` / `android.R.string.cancel`).

<a name="android-install"></a>

## Instalación y Configuración

<a name="android-clone"></a>

### 1. Clonar la librería

Clonar el repositorio desde la cuenta oficial de wuiproject en GitHub:

```bash
git clone --branch v0.6.0 https://github.com/wui-js/wuijs-environment-lib.git
```

> [!NOTE]
> El repositorio contendrá las 3 clases, Java para Android, Swift para iOS y JavaScript como contraparte Web.

<a name="android-config-project"></a>

### 2. Configuración del Proyecto

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

### 3. Configuración del Módulo (`app/build.gradle.kts`)

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

### 4. Configuración del Manifest en `AndroidManifest.xml`

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
> Esta configuración es requerida para la implementación de descargas, cámara y compartir archivos por WhatsApp o Correo desde WebView.

`res/xml/file_paths.xml` debe declarar los directorios internos de archivos y caché (cámara) y el directorio público `Download`, que se usa para abrir con `FileProvider` un archivo de assets descargado:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
	<files-path name="files" path="." />
	<cache-path name="cache" path="." />
	<external-path name="downloads" path="Download/" />
</paths>
```

> [!NOTE]
> Sin la entrada `external-path`, un archivo de assets se descarga igual pero no se abre tras la descarga (el error queda en el log).

<a name="android-config-colors"></a>

### 5. Configuración de Colores en `res/values/colors.xml`

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

### 6. Integración de la clase Java `WUIEnvironment.java`

Copiar el archivo `src/wui-js/environment/android/WUIEnvironment.java` a la carpeta de fuentes del proyecto (ej: `app/src/main/java/your/package/name/` si el ID del paquete definido fuese `your.package.name`).

> [!IMPORTANT]
> Se debe editar la primera línea del archivo para que coincida con el ID del paquete de la aplicación:

```java
package YOUR.PACKAGE.NAME; // Update this to match your project package
```

<a name="android-config-wui-environment-js"></a>

### 7. Integración de la clase JavaScript `wui-environment-0.6.js`

Copiar el contenido del directorio `src/wui-js/environment/web/` al directorio `assets/` del proyecto Android. Se recomienda la siguiente estructura:

- `app/src/main/assets/libraries/wui-js/environment/web/wui-environment-0.6.js`
- `app/src/main/assets/libraries/wui-js/environment/demo/index.html`

Lo anterior asegura que los ejemplos de inicialización funcionen correctamente.

<a name="android-config-mainactivity"></a>

### 8. Inicialización del MainActivity `MainActivity.java`

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
			//String path = "pages/index.html";
			wuiEnvironment.openUrl("file:///android_asset/" + path);

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
}
```

> [!IMPORTANT]
> El override de `onRequestPermissionsResult` es requerido por `requestPermission` (y por cualquier método que dependa de él: `setAppBadge`, `getCurrentPosition`). Sin él, el diálogo de permiso aparece pero el callback nunca resuelve.
