/*
 * @file wui-environment-0.2.js
 * @class WUIEnvironment
 * @version 0.2
 * @author Sergio E. Belmar V. (wuijs.project@gmail.com)
 * @copyright Sergio E. Belmar V. (wuijs.project@gmail.com)
 */

class WUIEnvironment {

	static version = "0.2";
	static #instance = null;
	static #defaults = {
		localStorage: true,
		onReady: null,
		onDownloadFile: null,
		onReceiveDeepLink: null
	};

	#userAgent = null;
	#platform = null;
	#systemName = null;
	#environment = null;
	#localStorage = false;
	#onReady = null;
	#onDownloadFile = null;
	#onReceiveDeepLink = null;

	#checkInterval = 100;
	#reqCount = 0;
	#resCount = 0;
	#responses = {};

	static response(args) {
		const instance = WUIEnvironment.#instance;
		const event = args.event || "";
		const code = args.code || null;
		delete args.event;
		delete args.code;
		if (instance != null) {
			if (code != null && instance.#responses[code] !== undefined) {
				instance.#responses[code] = args.response !== undefined ? args.response : args;
				return;
			}
			switch (event) {
				case "onDownloadFile":
					if (typeof instance.#onDownloadFile === "function") {
						instance.#onDownloadFile(args);
					}
					break;
				case "onReceiveDeepLink":
					if (typeof instance.#onReceiveDeepLink === "function") {
						instance.#onReceiveDeepLink(args.url || "");
					}
					break;
			}
		}
	}

	constructor(properties = {}) {
		const defaults = structuredClone(WUIEnvironment.#defaults);
		this.#userAgent = navigator.userAgent;
		this.#platform = navigator.userAgentData?.platform || navigator.platform;
		this.#systemName =
			this.#platform.match(/iphone|ipad/i) ? ("iOS"
			) : this.#platform.match(/android/i) ? ("Android"
			) : this.#platform.match(/mac/i) ? ("macOS"
			) : this.#platform.match(/linux/i) ? ("Linux"
			) : this.#platform.match(/windows phone|windows mobile/i) ? ("Windows Phone"
			) : this.#platform.match(/win/i) ? ("Windows"
			) : "";
		this.#environment =
			this.#userAgent.match(/WUIEnvironment/i) && this.#userAgent.match(/android/i) && typeof (Android) != "undefined" ? ("local.android"
			) : this.#userAgent.match(/WUIEnvironment/i) && this.#userAgent.match(/iphone|ipad/i) && typeof (webkit) != "undefined" && typeof (webkit.messageHandlers) != "undefined" ? ("local.ios"
			) : ("web");
		Object.entries(defaults).forEach(([name, value]) => {
			this[name] = name in properties ? properties[name] : value;
		});
		WUIEnvironment.#instance = this;
	}

	get userAgent() {
		return this.#userAgent;
	}

	get platform() {
		return this.#platform;
	}

	get systemName() {
		return this.#systemName;
	}

	get environment() {
		return this.#environment;
	}

	get localStorage() {
		return this.#localStorage;
	}

	get onDownloadFile() {
		return this.#onDownloadFile;
	}

	get onReady() {
		return this.#onReady;
	}

	get onReceiveDeepLink() {
		return this.#onReceiveDeepLink;
	}

	set localStorage(value) {
		if (typeof value === "boolean") {
			this.#localStorage = value;
		}
	}

	set onReady(value) {
		if (typeof value === "function") {
			this.#onReady = value;
			if (this.#reqCount === this.#resCount && this.#reqCount > 0) {
				this.#onReady(this.#reqCount);
			}
		}
	}

	set onDownloadFile(value) {
		if (typeof value === "function") {
			this.#onDownloadFile = value;
		}
	}

	set onReceiveDeepLink(value) {
		if (typeof value === "function") {
			this.#onReceiveDeepLink = value;
		}
	}

	#request(options) {
		this.#reqCount++;
		return new Promise((resolve) => {
			if (this.#environment == "local.android") {
				const response = Android.request(JSON.stringify(options));
				if (options.func.match(/^(getDeviceInfo|getDisplayInfo|getAppInfo|getPermissionsStatus|getCurrentPosition|requestPermission)$/) || (options.func == "readFile" && options.name.match(/\.json$/i))) {
					resolve(JSON.parse(response || "{}"));
				} else {
					resolve(response);
				}
				this.#resCount++;
				if (this.#reqCount === this.#resCount && typeof this.#onReady === "function") {
					this.#onReady(this.#reqCount);
				}
			} else if (this.#environment == "local.ios") {
				const code = this.#reqCount;
				this.#responses[code] = null;
				options.code = code;
				webkit.messageHandlers.request.postMessage(options);
				const check = setInterval(() => {
					if (this.#responses[code] !== null) {
						clearInterval(check);
						let response = this.#responses[code];
						delete this.#responses[code];
						this.#resCount++;
						if (options.func == "readFile" && options.name && options.name.match(/\.json$/i) && typeof response === "string") {
							try { response = JSON.parse(response || "{}"); } catch (e) { }
						}
						resolve(response);
						if (this.#reqCount === this.#resCount && typeof this.#onReady === "function") {
							this.#onReady(this.#reqCount);
						}
					}
				}, this.#checkInterval);
			}
		});
	}

	requestPermission(type, done) {
		if (this.isLocal()) {
			return this.#request({ func: "requestPermission", type: type }).then(done);
		} else if (navigator.permissions) {
			const queryName = type == "location" ? "geolocation" : type;
			return navigator.permissions.query({ name: queryName }).then(status => {
				const granted = status.state == "granted";
				if (typeof (done) == "function") {
					done(granted);
				}
				return granted;
			}).catch(() => {
				if (typeof (done) == "function") {
					done(false);
				}
				return false;
			});
		}
		return null;
	}

	isLocal() {
		return Boolean(this.#environment.match(/local/i));
	}

	isMobile() {
		return Boolean(navigator.userAgentData?.mobile || this.#systemName.match(/(Android|iOS|Windows Phone)/));
	}

	isTouch() {
		return Boolean(navigator.maxTouchPoints > 0);
	}

	isTablet() {
		const userAgent = navigator.userAgent;
		const width = window.innerWidth;
		const isTabletUA = userAgent.match(/Tablet|iPad|Playbook|Silk/i);
		const isTabletSize = width >= 768 && width <= 1280;
		return isTabletUA || (this.isMobile() && this.isTouch() && isTabletSize);
	}

	isAppInForeground(done) {
		if (this.isLocal()) {
			return this.#request({ func: "isAppInForeground" }).then(done);
		}
		return null;
	}

	getDeviceInfo(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getDeviceInfo" }).then(done);
		}
		return { platform: this.#systemName };
	}

	getDisplayInfo(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getDisplayInfo" }).then(done);
		}
		return {
			width: screen.width,
			height: screen.height,
			notch: false
		};
	}

	getAppInfo(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getAppInfo" }).then(done);
		}
		return null;
	}

	getPermissionsStatus(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getPermissionsStatus" }).then(done);
		} else if (navigator.permissions) {
			const $this = this;
			return (async () => {
				const permissions = {
					location: "undefined",
					storage: "undefined",
					contacts: "undefined",
					camera: "undefined",
					notifications: "undefined"
				};
				try {
					const location = await navigator.permissions.query({ name: "geolocation" });
					const storage = !$this.#userAgent.match(/Safari/i) ? await navigator.permissions.query({ name: "storage-access" }) : { state: "undefined" };
					const camera = await navigator.permissions.query({ name: "camera" });
					const notifications = await navigator.permissions.query({ name: "notifications" });
					permissions.location = location.state;
					permissions.storage = storage.state;
					permissions.camera = camera.state;
					permissions.notifications = notifications.state;
				} catch (error) {
					console.error("Failed to querying permissions:", error);
				}
				return permissions;
			})().then(done);
		} else {
			return null;
		}
	}

	getCurrentPosition(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getCurrentPosition" }).then(done);
		} else if (navigator.geolocation) {
			return new Promise((resolve) => {
				navigator.geolocation.getCurrentPosition((location) => {
					const coords = location.coords;
					const position = {
						latitude: coords.latitude,
						longitude: coords.longitude,
						accuracy: coords.accuracy
					};
					resolve(position);
					if (typeof (done) == "function") {
						done(position);
					}
				}, (error) => {
					console.error("Failed to get current position:", error);
				}, {
					enableHighAccuracy: true,
					timeout: 10000,
					maximumAge: 0
				});
			});
		}
		return null;
	}

	getConnectionStatus(done) {
		if (this.isLocal()) {
			return this.#request({ func: "getConnectionStatus" }).then(done);
		} else if (typeof (navigator.onLine) != "undefined") {
			if (typeof (done) == "function") {
				done(navigator.onLine);
			}
			return navigator.onLine;
		}
		return null;
	}

	setStatusbarStyle(color, darkIcons, done) {
		if (this.isLocal()) {
			this.#request({ func: "setStatusbarStyle", color: color, darkIcons: darkIcons }).then(done);
		}
	}

	setNavigationbarStyle(color, darkIcons, done) {
		if (this.isLocal()) {
			this.#request({ func: "setNavigationbarStyle", color: color, darkIcons: darkIcons }).then(done);
		}
	}

	setAppBadge(number, done) {
		const n = (typeof number === "number" && number > 0) ? Math.floor(number) : 0;
		if (this.isLocal()) {
			return this.#request({ func: "setAppBadge", number: n }).then(done);
		} else if (n > 0 && typeof navigator.setAppBadge === "function") {
			return navigator.setAppBadge(n).then(done);
		} else if (typeof navigator.clearAppBadge === "function") {
			return navigator.clearAppBadge().then(done);
		}
		return null;
	}

	saveFile(name, content, done) {
		if (name.match(/\.json$/i) && typeof (content) == "object") {
			content = JSON.stringify(content);
		}
		if (this.isLocal()) {
			return this.#request({ func: "saveFile", name: name, content: content }).then(done);
		} else if (this.#localStorage && window.localStorage) {
			window.localStorage.setItem(name, content);
			if (typeof (done) == "function") {
				done(true);
			}
			return true;
		}
		return false;
	}

	readFile(name, done) {
		if (this.isLocal()) {
			return this.#request({ func: "readFile", name: name }).then(done);
		} else if (this.#localStorage && window.localStorage) {
			let content = window.localStorage.getItem(name) || "";
			if (name.match(/\.json$/i)) {
				try {
					content = JSON.parse(content || "{}");
				} catch (error) {
					console.error("Failed to parse content json storage:", error);
				}
			}
			if (typeof (done) == "function") {
				done(content);
			}
			return content;
		}
		return null;
	}

	removeFile(name, done) {
		if (this.isLocal()) {
			return this.#request({ func: "removeFile", name: name }).then(done);
		} else if (window.localStorage) {
			window.localStorage.removeItem(name);
			if (typeof (done) == "function") {
				done(true);
			}
			return true;
		}
		return false;
	}

	openAppSettings(done) {
		if (this.isLocal()) {
			this.#request({ func: "openAppSettings" }).then(done);
		}
	}

	openURL(url) {
		if (this.isLocal()) {
			this.#request({ func: "openURL", url: url });
		} else if (this.#systemName.match(/(Android|iOS)/)) {
			const link = document.createElement("a");
			link.setAttribute("href", url);
			link.style.display = "none";
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		} else {
			window.open(url, "_blank");
		}
	}

	readDeepLink(done) {
		if (this.isLocal()) {
			return this.#request({ func: "readDeepLink" }).then(done);
		}
		return null;
	}

	clearDeepLink(done) {
		if (this.isLocal()) {
			this.#request({ func: "clearDeepLink" }).then(done);
		}
	}

	log(message, force = false) {
		if (this.isLocal()) {
			this.#request({ func: "log", message: String(message), force: Boolean(force) });
		} else if (typeof console !== "undefined" && typeof console.log === "function") {
			console.log(message);
		}
	}
}
