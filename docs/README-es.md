> [!IMPORTANT]
> La cuenta de GitHub `@wuiproject` se migró a `@wui-js` para que coincidiera con el nombre de la cuenta de NPM.

[English](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/README-en.md) |
[Español](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/README-es.md)
---

# wuijs-environment-lib

<p align="center">
	<img src="https://github.com/wui-js/wuijs-environment-lib/blob/main/imgs/logo/wuijs-environment-logotype-color.svg" width="220" height="220">
</p>

|                       | |
| --------------------- | ----------- |
| **Nombre librería**   | `wuijs-environment-lib` |
| **Versión librería**  | `0.6.0` ([Registro de Cambios](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/CHANGELOG-es.md)) |
| **Paquete npm**       | `@wui-js/environment` ([npm](https://www.npmjs.com/package/@wui-js/environment)) |
| **Versión documento** | `0.6.0.20261016.0` |
| **Licencia**          | `Licencia Apache 2.0` |
| **Autor**             | `Sergio E. Belmar V. <wuijs.project@gmail.com>` |
| **Repositorio**       | [https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib) |
| **Documentación**     | [https://docs.wuijs.dev](https://docs.wuijs.dev) |
| **Sitio web**         | [https://wuijs.dev](https://wuijs.dev) |

## Índice

*   [Descripción General](#overview)
	*   [Acerca del Proyecto WUI/JS](#project)
	*   [Tabla de Clases](#classtable)
	*   [Mapa de Directorios](#dirmap)
*   [Inicio Rápido](#quickstart)
	*   [Android + Web](#quickstart-android)
	*   [iOS + Web](#quickstart-ios)
	*   [Plantillas de Apps](#quickstart-templates)
*   [Clases](#classes)
	*   [WUIEnvironment (Android)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md)
	*   [WUIEnvironment (iOS)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md)
	*   [WUIEnvironment (Web)](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md)

<a name="overview"></a>

## Descripción General

WUI/JS Environment Lib es un puente (bridge) entre entornos web y motores de renderizado web nativos mediante JavaScript, diseñado para facilitar la creación de aplicaciones híbridas.
Proporciona acceso a instancias del hardware y del sistema tales como archivos, cámara, etc. directamente desde JavaScript.
Actualmente está disponible para Android en Java mediante WebView y para iOS en Swift mediante WebKit.

<a name="project"></a>

### Acerca del Proyecto WUI/JS

WUI/JS Environment Lib es parte del proyecto WUI/JS, que consta actualmente de 4 repositorios:

-	[https://github.com/wui-js/wuijs-main-lib](https://github.com/wui-js/wuijs-main-lib)<br>
	Librería Principal UI.<br><br>
-	[https://github.com/wui-js/wuijs-environment-lib](https://github.com/wui-js/wuijs-environment-lib)<br>
	Librería Puente UI entre entornos web y motores de renderizado web nativos.<br><br>
-	[https://github.com/wui-js/wuijs-plugins-lib](https://github.com/wui-js/wuijs-plugins-lib)<br>
	Librería de Complementos UI.<br><br>
-	[https://github.com/wui-js/wuijs-demos](https://github.com/wui-js/wuijs-demos)<br>
	Repositorio con demos y ejemplos de uso de las librerías del proyecto.<br><br>

<a name="classtable"></a>

### Tabla de Clases

| Nombre Clase                                                                                                                       | Plataforma | Versión | Descripción |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------- |:-------:| ----------- |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md) | Android    | `0.6`   | Clase Java del bridge para Android (WebView). |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md)     | iOS        | `0.6`   | Clase Swift del bridge para iOS (WKWebView). |
| [WUIEnvironment](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md)     | Web        | `0.6`   | Clase JavaScript, contraparte web de las clases Android e iOS. |

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
├── src/
│   └── wui-js/
│       └── environment/
│           ├── android/
│           ├── ios/
│           ├── web/
│           └── demo/
├── templates/
│   ├── app.myapp.android/
│   └── app.myapp.ios/
└── tools/
```

| Ruta                                                                                                                        | Descripción |
| --------------------------------------------------------------------------------------------------------------------------- | ----------- |
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
| [templates](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/)                                           | Proyectos mínimos de Android Studio y Xcode que ejecutan la página demo con la última versión de la librería. |
| [templates/app.myapp.android](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/app.myapp.android/)       | Plantilla Android (Java, Gradle). |
| [templates/app.myapp.ios](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/app.myapp.ios/)               | Plantilla iOS (Swift, SwiftUI). |
| [tools](https://github.com/wui-js/wuijs-environment-lib/tree/main/tools/)                                                   | Scripts de mantenimiento (`sync-templates.sh` copia las fuentes vigentes a las plantillas). |

> [!NOTE]
> La librería `wuijs-environment-lib` opera conjuntamente, es decir, se debe implementar la combinación **Android + Web** o **iOS + Web** para su correcto funcionamiento.

### Fuentes

| Tipo  | Versión | Archivo |
| ----- | :------:| ------- |
| Java  | 0.6     | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |
| Swift | 0.6     | [src/wui-js/environment/ios/WUIEnvironment.swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/ios/WUIEnvironment.swift) |
| JS    | 0.6     | [src/wui-js/environment/web/wui-environment-0.6.js](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/web/wui-environment-0.6.js) |

<a name="quickstart"></a>

## Inicio Rápido

Integración mínima para un proyecto nuevo. Para configuración completa ver las secciones específicas de cada plataforma.

<a name="quickstart-android"></a>

### Android + Web

**Requisitos:** Android Studio, proyecto nuevo con `AppCompatActivity` y `minSdk ≥ 24`.

1. Clonar la librería y copiar `src/wui-js/environment/android/WUIEnvironment.java` a `app/src/main/java/tu/paquete/nombre/`. Editar la primera línea para que coincida con el ID del paquete.
2. Copiar `src/wui-js/environment/web/` y `src/wui-js/environment/demo/` a `app/src/main/assets/libraries/wui-js/environment/`.
3. Agregar permisos, colores y configuración Gradle según [Instalación y Configuración](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-install).
4. Inicializar en `MainActivity.java`:

```java
wuiEnvironment = new WUIEnvironment(this);
wuiEnvironment.openUrl("file:///android_asset/libraries/wui-js/environment/demo/index.html");
wuiEnvironment.saveDeepLink(getIntent());
```

5. En las páginas HTML propias, incluir la clase JS e instanciarla:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.6.js"></script>
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
3. Agregar claves de permisos, color sets y configuración Deep Link según [Instalación y Configuración](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-install).
4. Inicializar en `EnvironmentViewController` dentro de `MainView.swift`:

```swift
wuiEnvironment = WUIEnvironment(viewController: self)
wuiEnvironment?.openUrl(url: Bundle.main.bundleURL.appendingPathComponent("assets/libraries/wui-js/environment/demo/index.html").absoluteString)
```

5. En las páginas HTML propias, incluir la clase JS e instanciarla:

```html
<script src="libraries/wui-js/environment/web/wui-environment-0.6.js"></script>
<script>
	const env = new WUIEnvironment();
	env.getDeviceInfo(function(info) {
		console.log("Plataforma:", info.platform, "| Modelo:", info.model);
	});
</script>
```

> [!NOTE]
> Abrir primero la página demo (`demo/index.html`) para verificar que el bridge funciona antes de cambiar a la URL de producción.

<a name="quickstart-templates"></a>

### Plantillas de Apps

El directorio [templates](https://github.com/wui-js/wuijs-environment-lib/tree/main/templates/) contiene dos proyectos mínimos que cargan la página demo (`src/wui-js/environment/demo/index.html`) con la última versión de la librería ya integrada:

| Plantilla | Se abre con | Package / Bundle ID | Requisitos |
| --------- | ----------- | ------------------- | ---------- |
| `app.myapp.android` | Android Studio | `app.myapp` | Android SDK 36, JDK 17+ (el incluido en Android Studio), minSdk 24. |
| `app.myapp.ios` | Xcode (`MyApp.xcodeproj`) | `app.myapp` | Xcode 16+, iOS 18.5+. |

Están pensadas como punto de partida para una nueva app híbrida: contienen sólo la clase del bridge, la clase JavaScript, la página demo, el logo de WUI/JS como ícono de la app y la configuración requerida (colores, permisos, `FileProvider`, esquema de Deep Link `myapp`). Ver [templates/README.md](https://github.com/wui-js/wuijs-environment-lib/blob/main/templates/README.md) para los pasos para renombrarlas.

<a name="android"></a>

## Librería Android

Versión: `0.6`

La librería Java para Android utiliza como motor de renderización **WebView**.

### Fuentes

| Tipo | Archivo |
|:----:| ------- |
| Java | [src/wui-js/environment/android/WUIEnvironment.java](https://github.com/wui-js/wuijs-environment-lib/blob/main/src/wui-js/environment/android/WUIEnvironment.java) |

<a name="android-constructor"></a>

### Constructor Java

| Constructor | Descripción |
| ----------- | ----------- |
| `WUIEnvironment(Context context[, boolean developMode])` | Inicializa el entorno WUI con configuración por defecto. `developMode = true` permite SSL con certificados no confiables, activa logs de depuración y habilita la inspección del WebView con Chrome DevTools (`chrome://inspect`). **No usar `true` en producción** — deshabilita la validación de certificados en todo el WebView. |

<a name="android-methods"></a>

### Métodos Java

| Método                   | Tipo de retorno | Descripción |
| ------------------------ | --------------- | ----------- |
<a name="classes"></a>

## Clases

La documentación de cada clase está en un documento propio, en el directorio [`docs/classes/`](https://github.com/wui-js/wuijs-environment-lib/tree/main/docs/classes). `WUIEnvironment` tiene un documento por plataforma:

*   WUIEnvironment
	*   <a name="android"></a>[Android](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md)
		*   <a name="android-constructor"></a>[Constructor Java](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-constructor)
		*   <a name="android-methods"></a>[Métodos Java](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-methods)
		*   <a name="android-events"></a>[Eventos Android](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-events)
		*   <a name="android-dialogs"></a>[Diálogos JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-dialogs)
		*   <a name="android-install"></a>[Instalación y Configuración](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-install)
			1.   <a name="android-clone"></a>[Clonar la librería](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-clone)
			2.   <a name="android-config-project"></a>[Configuración del Proyecto](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-project)
			3.   <a name="android-config-module"></a>[Configuración del Módulo](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-module)
			4.   <a name="android-config-manifest"></a>[Configuración del Manifest](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-manifest)
			5.   <a name="android-config-colors"></a>[Configuración de Colores](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-colors)
			6.   <a name="android-config-wui-environment-java"></a>[Integración de la clase Java](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-wui-environment-java)
			7.   <a name="android-config-wui-environment-js"></a>[Integración de la clase JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-wui-environment-js)
			8.   <a name="android-config-mainactivity"></a>[Inicialización del MainActivity](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-android-es.md#android-config-mainactivity)
	*   <a name="ios"></a>[iOS](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md)
		*   <a name="ios-constructor"></a>[Constructor Swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-constructor)
		*   <a name="ios-methods"></a>[Métodos Swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-methods)
		*   <a name="ios-events"></a>[Eventos iOS](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-events)
		*   <a name="ios-dialogs"></a>[Diálogos JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-dialogs)
		*   <a name="ios-install"></a>[Instalación y Configuración](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-install)
			1.   <a name="ios-clone"></a>[Clonar la librería](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-clone)
			2.   <a name="ios-config-permissions"></a>[Configuración de Permisos](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-permissions)
			3.   <a name="ios-config-colors"></a>[Configuración de Colores](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-colors)
			4.   <a name="ios-config-wui-environment-swift"></a>[Integración de la clase Swift](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-wui-environment-swift)
			5.   <a name="ios-config-wui-environment-js"></a>[Integración de la clase JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-wui-environment-js)
			6.   <a name="ios-config-packageapp"></a>[Inicialización del PackageApp](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-packageapp)
			7.   <a name="ios-config-mainview"></a>[Inicialización del MainView](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-ios-es.md#ios-config-mainview)
	*   <a name="web"></a>[Web](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md)
		*   <a name="web-properties"></a>[Propiedades JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md#web-properties)
		*   <a name="web-class-methods"></a>[Métodos de la Clase JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md#web-class-methods)
		*   <a name="web-instance-methods"></a>[Métodos de la Instancia JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md#web-instance-methods)
		*   <a name="web-usage"></a>[Uso JavaScript](https://github.com/wui-js/wuijs-environment-lib/blob/main/docs/classes/environment/wui-environment-web-es.md#web-usage)
