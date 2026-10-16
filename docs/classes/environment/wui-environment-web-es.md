[English](wui-environment-web-en.md) | [Español](wui-environment-web-es.md)

[wuijs-environment-lib](../../README-es.md)

Plataformas: [Android](wui-environment-android-es.md) | [iOS](wui-environment-ios-es.md) | [Web](wui-environment-web-es.md)

# WUIEnvironment (Web)

Versión: `0.6`

La implementación en Web utiliza como fuentes a la clase JavaScript `WUIEnvironment` que debe ser incluida en cada página HTML que utilice el bridge.

## Fuentes

| Tipo | Archivo |
|:----:| ------- |
| JS   | [src/wui-js/environment/web/wui-environment-0.6.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.6.js) |

<a name="web-properties"></a>

## Propiedades JavaScript

Campos públicos y propiedades getter/setter de la instancia de `WUIEnvironment`.

| Propiedad            | Tipo             | Valor por defecto                                         | Descripción |
| -------------------- | ---------------- | --------------------------------------------------------- | ----------- |
| `userAgent`          | `string`         | `navigator.userAgent`                                     | (get)<br><br>String raw del user agent. Resuelto al momento de construcción. |
| `platform`           | `string`         | `navigator.userAgentData?.platform \| navigator.platform` | (get)<br><br>String de plataforma desde el navegador o el SO. Resuelto al momento de construcción. |
| `systemName`         | `string`         | `""`                                                      | (get)<br><br>Nombre normalizado del SO derivado de `platform`: `"iOS"`, `"Android"`, `"macOS"`, `"Linux"`, `"Windows Phone"`, `"Windows"` o `""`. Resuelto al momento de construcción. |
| `environment`        | `string`         | `"web"`                                                   | (get)<br><br>Identificador del entorno de ejecución: `"local.android"` cuando se ejecuta en un WebView Android, `"local.ios"` cuando se ejecuta en un WKWebView iOS, o `"web"` en cualquier otro caso. Resuelto al momento de construcción. |
| `localStorage`       | `boolean`        | `true`                                                    | (get/set)<br><br>Cuando es `true`, `saveFile`, `readFile` y `removeFile` usan `window.localStorage` como fallback en web. No tiene efecto dentro de un WebView nativo. |
| `onReady`            | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando todas las solicitudes bridge pendientes han recibido respuesta. Recibe el número total de solicitudes como argumento. Si se asigna después de que todas las solicitudes ya se resolvieron, se ejecuta inmediatamente. |
| `onDownloadProgress` | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta aproximadamente cada 250 ms mientras está en curso la descarga de un archivo iniciada desde el WebView. Recibe `{ key, loaded, total }`: bytes recibidos y tamaño del archivo en bytes (`-1` si no se conoce). `key` es `null` en las descargas iniciadas desde el WebView. Una descarga iniciada con `downloadFile()` con sus propios callbacks en `options` no ejecuta esta propiedad. |
| `onDownloadFile`     | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando termina la descarga de un archivo iniciada desde el WebView. Recibe `{ key, filename, mimetype, uri, status, httpStatus }`, donde `status` es `"success"`, `"failed"` o `"cancelled"`, `uri` es `null` cuando no es `"success"`, y `httpStatus` es el código HTTP cuando la descarga falló por una respuesta HTTP (ej. `401`), o `null`. Debe asignarse antes de cargar la primera página. `key` es `null` en las descargas iniciadas desde el WebView. Una descarga iniciada con `downloadFile()` con sus propios callbacks en `options` no ejecuta esta propiedad. |
| `onReceiveDeepLink`  | `function\|null` | `null`                                                    | (get/set)<br><br>Callback que se ejecuta cuando la app recibe una URL de Deep Link. Recibe la URL como string. Debe asignarse antes de cargar la primera página. |

<a name="web-class-methods"></a>

## Métodos de la Clase JavaScript

Miembros estáticos de la clase `WUIEnvironment`.

| Miembro          | Tipo              | Descripción |
| ---------------- | ----------------- | ----------- |
| `version`        | `string`          | Versión de la librería: `"0.6"`. |
| `response(args)` | `método estático` | Punto de entrada para la comunicación nativo→JS. Llamado internamente por el bridge nativo para entregar respuestas de solicitudes y despachar los eventos `onDownloadFile` / `onReceiveDeepLink`. No está destinado a ser llamado desde el código de la aplicación. |

<a name="web-instance-methods"></a>

## Métodos de la Instancia JavaScript

| Método                  | Tipo de retorno           | Descripción |
| ----------------------- | ------------------------- | ----------- |
| `requestPermission`     | `Promise<boolean>`        | `requestPermission(type[, done])`<br><br>Argumentos:<br>**• type:** `string`, uno de `location`, `notifications`, `camera`, `contacts`, `storage`.<br>**• done:** `function` *opcional*, callback.<br><br>Solicita el permiso del sistema indicado. Dentro de un WebView nativo delega al bridge (`requestPermission`). En web recae en `navigator.permissions.query`. Resuelve con `true` cuando está concedido. |
| `isLocal`               | `boolean`                 | `isLocal()`<br><br>Alias de `isLocalAgent()`. Devuelve `true` cuando se ejecuta dentro de un WebView nativo (`local.android` o `local.ios`). Se resuelve sincrónicamente. |
| `isLocalAgent`          | `boolean`                 | `isLocalAgent()`<br><br>Devuelve `true` cuando el entorno detectado es `local.android` o `local.ios` (es decir, la página se ejecuta dentro de un WebView nativo con el bridge WUIEnvironment activo). Devuelve `false` en web plano. Se resuelve sincrónicamente desde el valor establecido al momento de construcción. |
| `isLocalHost`           | `boolean`                 | `isLocalHost()`<br><br>Devuelve `true` cuando `location.hostname` es `"localhost"` o `"127.0.0.1"`. Útil para distinguir desarrollo local de producción sin depender del bridge nativo. |
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
| `openUrl`               | `void`                    | `openUrl(url)`<br><br>Argumentos:<br>**• url:** `string`, la URL de destino o ruta de asset local.<br><br>Abre un recurso local en el WebView o un enlace externo. En web usa `window.open`. |
| `readDeepLink`          | `Promise<string>`         | `readDeepLink([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Lee la última URL de Deep Link recibida. Devuelve `null` en web. |
| `clearDeepLink`         | `void`                    | `clearDeepLink([done])`<br><br>Argumentos:<br>**• done:** `function` *opcional*, callback.<br><br>Limpia la URL de Deep Link almacenada. Sin efecto en web. |
| `downloadFile`          | `string\|null`            | `downloadFile(url[, filename[, headers[, options]]])`<br><br>Argumentos:<br>**• url:** `string`, URL del archivo.<br>**• filename:** `string` *opcional*, por defecto `""`. Nombre sugerido del archivo; si está vacío, lo deduce el lado nativo.<br>**• headers:** `object` *opcional*, por defecto `{}`. Cabeceras HTTP enviadas con la solicitud, ej. `{ Authorization: "Bearer …" }`.<br>**• options:** `object` *opcional*, por defecto `{}`. `{ onProgress, onFile }`: callbacks sólo para esta descarga, con los mismos argumentos que `onDownloadProgress` y `onDownloadFile`. Si se omiten, los eventos de la descarga van a las propiedades globales `onDownloadProgress` y `onDownloadFile`. Por compatibilidad, si se pasa una `function` se usa como callback `done`, que se ejecuta cuando el lado nativo acepta la solicitud.<br><br>Descarga un archivo de forma nativa enviando cabeceras HTTP, para endpoints que requieren autenticación (una descarga iniciada con `window.open()` es pedida de nuevo por el descargador nativo sin cabeceras). Retorna la `key` de la descarga, usada en los eventos y en `cancelDownload(key)`, o `null` en web, donde no tiene efecto. Pueden ejecutarse varias descargas al mismo tiempo. En Android el nombre no se puede leer de `Content-Disposition`, por lo que se recomienda pasar `filename`. |
| `cancelDownload`        | `void`                    | `cancelDownload([key[, done]])`<br><br>Argumentos:<br>**• key:** `string` *opcional*. Descarga a cancelar, tal como la retorna `downloadFile()`; si se omite, se cancelan todas las descargas en curso, incluidas las iniciadas desde el WebView. Por compatibilidad, si se pasa una `function` se usa como `done`.<br>**• done:** `function` *opcional*, callback.<br><br>Cancela descargas en curso. Una descarga cancelada dispara `onDownloadFile` con `status: "cancelled"`. Sin efecto en web. **Pendiente de prueba.** |
| `log`                   | `void`                    | `log(message[, force])`<br><br>Argumentos:<br>**• message:** `any`, valor a registrar (coercionado a string).<br>**• force:** `boolean` *opcional*, por defecto `false`. Cuando es `true` instruye al lado nativo a omitir su restricción de `developMode` y escribir siempre el mensaje.<br><br>Dentro de un WebView nativo reenvía el mensaje al logger nativo (Logcat / consola de Xcode). En web recae en `console.log`. |

<a name="web-usage"></a>

## Uso JavaScript

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
			console.log("Plataforma:", info.platform);
		});
	</script>
</body>
</html>
```

> [!NOTE]
> La ruta en `src` es relativa al archivo HTML. En Android, los assets se cargan desde `app/src/main/assets/`; en iOS, desde la carpeta `assets/` agregada al target de Xcode. La ruta recomendada `libraries/wui-js/environment/web/wui-environment-0.6.js` coincide con la estructura descrita en los pasos de instalación.

**Comportamiento del bridge según plataforma:**

- **Android**: las llamadas son **síncronas** — `Android.request()` devuelve el resultado inmediatamente.
- **iOS**: las llamadas son **asíncronas** — el lado nativo llama a `WUIEnvironment.response()` cuando termina.

La librería JS abstrae ambos comportamientos en la misma API basada en callbacks.

```js
const env = new WUIEnvironment();

// Configurar los handlers de eventos antes de cargar la primera página

env.onReady = function(count) {
	console.log("Todas las", count, "solicitudes resueltas");
};
env.onDownloadProgress = function({ loaded, total }) {
	console.log("Descargando:", loaded, "de", total, "bytes");
};
env.onDownloadFile = function(args) {
	console.log("Descarga", args.status + ":", args.filename, args.mimetype, args.uri);
};
env.onReceiveDeepLink = function(url) {
	console.log("Deep Link recibido:", url);
};

// Descarga con cabeceras HTTP (ej. endpoints autenticados) y callbacks propios

const key = env.downloadFile("https://example.com/api/files/1/download", "file.zip", { Authorization: "Bearer " + token }, {
	onProgress: function({ loaded, total }) {
		console.log("file.zip:", loaded, "de", total, "bytes");
	},
	onFile: function(args) {
		console.log("file.zip", args.status, args.httpStatus);
	}
});
// env.cancelDownload(key); // cancela sólo esta descarga

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
