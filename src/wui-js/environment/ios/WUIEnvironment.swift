/*
 * @file WUIEnvironment.swift
 * @class WUIEnvironment
 * @version 0.6
 * @author Sergio E. Belmar V. (wuijs.project@gmail.com)
 * @copyright Sergio E. Belmar V. (wuijs.project@gmail.com)
 */

import Foundation
import WebKit
import UIKit
import Network
import AVFoundation
import UserNotifications
import CoreLocation
import Contacts

class WUIEnvironment: NSObject {

	var webView: WKWebView!
	private weak var viewController: UIViewController?
	private var developMode: Bool = false
	private var deepLinkURL: String? = nil
	private var pageLoaded: Bool = false
	private let logTag = "WUIEnvironment"
	private weak var statusbarView: UIView?
	private weak var navigationbarView: UIView?
	var preferredStatusBarStyle: UIStatusBarStyle = .default
	private var networkMonitor: NWPathMonitor?
	private var networkQueue = DispatchQueue(label: "WUIEnvironment.network")
	private var isConnected: Bool = false
	private var locationManager: CLLocationManager?
	private var locationCompletion: (([String: Any]) -> Void)?
	private var permissionLocationCompletion: ((Bool) -> Void)?
	private var downloadDestinations: [ObjectIdentifier: (url: URL, mimeType: String)] = [:]
	private var downloadObservations: [ObjectIdentifier: NSKeyValueObservation] = [:]
	private let downloadProgressInterval: TimeInterval = 0.25
	private var activeDownloads: [ObjectIdentifier: (download: AnyObject, key: String?)] = [:]
	private var cancelledDownloads: Set<ObjectIdentifier> = []

	init(viewController: UIViewController, developMode: Bool = false) {
		super.init()
		self.viewController = viewController
		self.developMode = developMode
		webViewInit()
		setupNetworkMonitor()
	}

	init(viewController: UIViewController) {
		super.init()
		self.viewController = viewController
		webViewInit()
		setupNetworkMonitor()
	}

	// MARK: - Initialization

	private func webViewInit() {
		let contentController = WKUserContentController()
		let xhrPatch = """
			(function() {
				let _seq = 0;
				const _pending = {};
				window._wuiXhrRespond = function(code, content, status) {
					const resolve = _pending[code];
					if (!resolve) return;
					delete _pending[code];
					resolve({ content: content, status: status });
				};
				const _OrigXHR = window.XMLHttpRequest;
				window.XMLHttpRequest = function() {
					let _isFile = false, _async = true, _url = '';
					let _onload = null, _onerror = null;
					let _status = 0, _responseText = '';
					let _native = null;
					const proxy = {
						get status()       { return _isFile ? _status : _native.status; },
						get responseText() { return _isFile ? _responseText : _native.responseText; },
						get onload()       { return _onload; },
						set onload(fn)     { _onload = fn; },
						get onerror()      { return _onerror; },
						set onerror(fn)    { _onerror = fn; },
						overrideMimeType() {},
						open(method, url, async) {
							try { url = new URL(url, window.location.href).href; } catch(e) {}
							_url = url; _async = (async !== false); _isFile = url.startsWith('file:');
							if (_isFile) { if (!_async) _status = 200; }
							else {
								if (!_native) _native = new _OrigXHR();
								_native.open(method, url, async);
								_native.onload  = function() { if (typeof _onload  === 'function') _onload.call(proxy); };
								_native.onerror = function(e){ if (typeof _onerror === 'function') _onerror.call(proxy, e); };
							}
						},
						send() {
							if (!_isFile) { if (_native) _native.send(); return; }
							if (!_async)  { return; }
							const code = ++_seq;
							_pending[code] = function(res) {
								_status = res.status; _responseText = res.content;
								if (typeof _onload === 'function') _onload.call(proxy);
							};
							webkit.messageHandlers.request.postMessage({ func: '_xhrRead', url: _url, code: code });
						}
					};
					return proxy;
				};
			})();
		"""
		let xhrScript = WKUserScript(source: xhrPatch, injectionTime: .atDocumentStart, forMainFrameOnly: true)
		contentController.add(self, name: "request")
		contentController.addUserScript(xhrScript)
		if developMode {
			let consoleBridge = """
				(function() {
					const _log = function(level, args) {
						const msg = Array.from(args).map(a => {
							try { return typeof a === 'object' ? JSON.stringify(a) : String(a); } catch(e) { return String(a); }
						}).join(' ');
						webkit.messageHandlers.request.postMessage({ func: '_console', level: level, msg: msg });
					};
					window.console = { log: function() { _log('log', arguments); }, warn: function() { _log('warn', arguments); }, error: function() { _log('error', arguments); }, info: function() { _log('info', arguments); } };
					window.onerror = function(msg, src, line) { _log('error', ['[onerror] ' + msg + ' @ ' + src + ':' + line]); };
					window.addEventListener('unhandledrejection', function(e) { _log('error', ['[unhandledrejection]', e.reason]); });
				})();
			"""
			let consoleScript = WKUserScript(source: consoleBridge, injectionTime: .atDocumentStart, forMainFrameOnly: true)
			contentController.addUserScript(consoleScript)
		}
		let config = WKWebViewConfiguration()
		config.userContentController = contentController
		config.allowsInlineMediaPlayback = true
		config.allowsAirPlayForMediaPlayback = true
		config.preferences.javaScriptCanOpenWindowsAutomatically = true
		if #available(iOS 10.0, *) {
			config.mediaTypesRequiringUserActionForPlayback = []
		}
		webView = WKWebView(frame: .zero, configuration: config)
		if #available(iOS 16.4, *) { webView.isInspectable = developMode }
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.scrollView.maximumZoomScale = 5.0
		webView.scrollView.minimumZoomScale = 0.5
		webView.scrollView.contentInsetAdjustmentBehavior = .never
		if let vc = viewController {
			vc.view.addSubview(webView)
			webView.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				webView.topAnchor.constraint(equalTo: vc.view.topAnchor),
				webView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
				webView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
				webView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
			])
		}
		setupUserAgent()
	}

	private func setupUserAgent() {
		let appInfo = getAppInfo()
		let name = appInfo["name"] as? String ?? ""
		let version = appInfo["version"] as? String ?? ""
		webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
			guard let self = self else { return }
			let base = result as? String ?? ""
			if !base.isEmpty {
				self.webView.customUserAgent = "\(base) WUIEnvironment (\(name)/\(version))"
			} else {
				let device = UIDevice.current
				let sysVersion = device.systemVersion.replacingOccurrences(of: ".", with: "_")
				let model = device.model.lowercased().contains("ipad") ? "iPad" : "iPhone"
				self.webView.customUserAgent = "Mozilla/5.0 (\(model); CPU iPhone OS \(sysVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 WUIEnvironment (\(name)/\(version))"
			}
			self.log("UserAgent: \(self.webView.customUserAgent ?? "")")
		}
	}

	private func setupNetworkMonitor() {
		networkMonitor = NWPathMonitor()
		networkMonitor?.pathUpdateHandler = { [weak self] path in
			self?.isConnected = (path.status == .satisfied)
		}
		networkMonitor?.start(queue: networkQueue)
	}

	// MARK: - Native bridge functions

	func requestPermission(type: String, completion: @escaping (Bool) -> Void) {
		switch type {
			case "notifications":
				UNUserNotificationCenter.current().getNotificationSettings { settings in
					switch settings.authorizationStatus {
						case .authorized, .provisional, .ephemeral:
							DispatchQueue.main.async { completion(true) }
						case .denied:
							DispatchQueue.main.async { completion(false) }
						case .notDetermined:
							UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
								DispatchQueue.main.async { completion(granted) }
							}
						@unknown default:
							DispatchQueue.main.async { completion(false) }
					}
				}
			case "location":
				let status = CLLocationManager().authorizationStatus
				switch status {
					case .authorizedAlways, .authorizedWhenInUse:
						completion(true)
					case .denied, .restricted:
						completion(false)
					case .notDetermined:
						permissionLocationCompletion = completion
						let manager = CLLocationManager()
						manager.delegate = self
						locationManager = manager
						manager.requestWhenInUseAuthorization()
					@unknown default:
						completion(false)
				}
			case "camera":
				switch AVCaptureDevice.authorizationStatus(for: .video) {
					case .authorized:
						completion(true)
					case .denied, .restricted:
						completion(false)
					case .notDetermined:
						AVCaptureDevice.requestAccess(for: .video) { granted in
							DispatchQueue.main.async { completion(granted) }
						}
					@unknown default:
						completion(false)
				}
			case "contacts":
				switch CNContactStore.authorizationStatus(for: .contacts) {
					case .authorized, .limited:
						completion(true)
					case .denied, .restricted:
						completion(false)
					case .notDetermined:
						CNContactStore().requestAccess(for: .contacts) { granted, _ in
							DispatchQueue.main.async { completion(granted) }
						}
					@unknown default:
						completion(false)
				}
			default:
				completion(false)
		}
	}

	func isAppInForeground() -> Bool {
		var result = false
		let read = { result = UIApplication.shared.applicationState != .background }
		Thread.isMainThread ? read() : DispatchQueue.main.sync { read() }
		return result
	}

	func getDeviceInfo() -> [String: Any] {
		let device = UIDevice.current
		let vendorId = device.identifierForVendor?.uuidString ?? ""
		return [
			"id":       vendorId,
			"uuid":     vendorId,
			"name":     device.name,
			"platform": "iOS",
			"version":  device.systemVersion,
			"maker":    "Apple",
			"model":    device.model
		]
	}

	func getDisplayInfo() -> [String: Any] {
		var result: [String: Any] = [:]
		let read: () -> Void = { [weak self] in
			guard let self = self else { return }
			let screen = UIScreen.main
			let bounds = screen.bounds
			let scale = screen.scale
			let width = Int(bounds.width)
			let height = Int(bounds.height)
			let maxDim = max(bounds.width, bounds.height)
			let minDim = min(bounds.width, bounds.height)
			let orientation = bounds.width > bounds.height ? "landscape" : "portrait"
			let refreshRate: Int
			var statusbarHeight = 0
			var navigationbarHeight = 0
			var notch = false
			var statusbarLightMode = false
			if #available(iOS 10.3, *) {
				refreshRate = screen.maximumFramesPerSecond
			} else {
				refreshRate = 60
			}
			if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			   let window = scene.windows.first(where: { $0.isKeyWindow }) {
				let insets = window.safeAreaInsets
				statusbarHeight = Int(insets.top)
				navigationbarHeight = Int(insets.bottom)
				notch = insets.top > 20
			}
			if #available(iOS 13.0, *) {
				if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
					statusbarLightMode = scene.statusBarManager?.statusBarStyle == .darkContent
				}
			}
			let statusbarTransparent = !(self.statusbarView != nil && (self.statusbarView?.backgroundColor?.cgColor.alpha ?? 0) > 0.01)
			let navigationbarTransparent = !(self.navigationbarView != nil && (self.navigationbarView?.backgroundColor?.cgColor.alpha ?? 0) > 0.01)
			let statusbarOverlay = statusbarTransparent || statusbarHeight == 0
			let navigationbarOverlay = navigationbarTransparent || navigationbarHeight == 0
			result = [
				"width":                     width,
				"height":                    height,
				"density":                   Double(scale),
				"densityDpi":                Int(scale * 160),
				"orientation":               orientation,
				"refreshRate":               refreshRate,
				"aspectRatio":               minDim > 0 ? Double(maxDim / minDim) : 0.0,
				"notch":                     notch,
				"statusbarHeight":           statusbarHeight,
				"statusbarTransparent":      statusbarTransparent,
				"statusbarLightMode":        statusbarLightMode,
				"statusbarOverlay":          statusbarOverlay,
				"navigationMode":            "gestures",
				"navigationbarHeight":       navigationbarHeight,
				"navigationbarTransparent":  navigationbarTransparent,
				"navigationbarLightMode":    false,
				"navigationbarOverlay":      navigationbarOverlay,
				"systembarDrawsBackgrounds": false
			]
		}
		Thread.isMainThread ? read() : DispatchQueue.main.sync { read() }
		return result
	}

	func getAppInfo() -> [String: Any] {
		let info = Bundle.main.infoDictionary
		return [
			"name":    info?["CFBundleName"] as? String ?? "",
			"version": info?["CFBundleShortVersionString"] as? String ?? "",
			"package": Bundle.main.bundleIdentifier ?? "",
			"build":   info?["CFBundleVersion"] as? String ?? ""
		]
	}

	func getPermissionsStatus(completion: @escaping ([String: Any]) -> Void) {
		var permissions: [String: String] = [
			"notifications": "undefined",
			"location":      "undefined",
			"camera":        "undefined",
			"contacts":      "undefined",
			"phone":         "undefined",
			"storage":       "undefined"
		]
		switch CLLocationManager().authorizationStatus {
			case .authorizedAlways, .authorizedWhenInUse: permissions["location"] = "granted"
			case .denied, .restricted:                    permissions["location"] = "denied"
			case .notDetermined:                          permissions["location"] = "default"
			@unknown default: break
		}
		switch AVCaptureDevice.authorizationStatus(for: .video) {
			case .authorized:            permissions["camera"] = "granted"
			case .denied, .restricted:   permissions["camera"] = "denied"
			case .notDetermined:         permissions["camera"] = "default"
			@unknown default: break
		}
		switch CNContactStore.authorizationStatus(for: .contacts) {
			case .authorized:            permissions["contacts"] = "granted"
			case .denied, .restricted:   permissions["contacts"] = "denied"
			case .notDetermined:         permissions["contacts"] = "default"
			case .limited:               permissions["contacts"] = "granted"
			@unknown default: break
		}
		// Notifications must be resolved last; it is the only async status.
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			switch settings.authorizationStatus {
				case .authorized, .provisional: permissions["notifications"] = "granted"
				case .denied:                   permissions["notifications"] = "denied"
				case .notDetermined:            permissions["notifications"] = "default"
				case .ephemeral:                permissions["notifications"] = "granted"
				@unknown default: break
			}
			DispatchQueue.main.async { completion(permissions) }
		}
	}

	func getCurrentPosition(completion: @escaping ([String: Any]) -> Void) {
		requestPermission(type: "location") { [weak self] granted in
			guard let self = self, granted else {
				completion(["error": "Location permission denied"])
				return
			}
			self.locationCompletion = completion
			let manager = CLLocationManager()
			manager.delegate = self
			manager.desiredAccuracy = kCLLocationAccuracyBest
			self.locationManager = manager
			manager.requestLocation()
		}
	}

	func getConnectionStatus() -> Bool {
		// currentPath is live; isConnected is a stale async fallback.
		if let monitor = networkMonitor {
			return monitor.currentPath.status == .satisfied
		}
		return isConnected
	}

	func setStatusbarStyle(color: String, darkIcons: Bool) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self, let vc = self.viewController else { return }
			let uiColor = self.parseColor(color) ?? UIColor.white
			self.statusbarView?.removeFromSuperview()
			let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
			let window = scene?.windows.first(where: { $0.isKeyWindow })
			let height = window?.safeAreaInsets.top
				?? scene?.statusBarManager?.statusBarFrame.height
				?? 0
			let view = UIView(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: height))
			view.backgroundColor = uiColor
			view.autoresizingMask = [.flexibleWidth]
			vc.view.addSubview(view)
			vc.view.bringSubviewToFront(view)
			self.statusbarView = view
			self.preferredStatusBarStyle = darkIcons ? .darkContent : .lightContent
			vc.setNeedsStatusBarAppearanceUpdate()
			// UIHostingController doesn't forward childForStatusBarStyle in SwiftUI apps;
			// propagate icon style via window overrideUserInterfaceStyle as fallback.
			window?.overrideUserInterfaceStyle = darkIcons ? .light : .dark
			self.log("Statusbar set color: \(color), darkIcons: \(darkIcons)")
		}
	}

	func setNavigationbarStyle(color: String, darkIcons: Bool) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self, let vc = self.viewController else { return }
			let uiColor = self.parseColor(color) ?? UIColor.white
			self.navigationbarView?.removeFromSuperview()
			let safeBottom: CGFloat
			if #available(iOS 11.0, *) {
				safeBottom = vc.view.safeAreaInsets.bottom
			} else {
				safeBottom = 0
			}
			guard safeBottom > 0 else { return }
			let yPos = vc.view.bounds.height - safeBottom
			let view = UIView(frame: CGRect(x: 0, y: yPos, width: vc.view.bounds.width, height: safeBottom))
			view.backgroundColor = uiColor
			view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
			vc.view.addSubview(view)
			vc.view.bringSubviewToFront(view)
			self.navigationbarView = view
			self.log("Navigationbar set color: \(color)")
		}
	}

	func setAppBadge(number: Int) {
		requestPermission(type: "notifications") { [weak self] granted in
			guard granted else {
				self?.log("AppBadge skipped: notifications permission denied")
				return
			}
			DispatchQueue.main.async {
				if #available(iOS 16.0, *) {
					UNUserNotificationCenter.current().setBadgeCount(number)
				} else {
					UIApplication.shared.applicationIconBadgeNumber = number
				}
				self?.log("AppBadge set: \(number)")
			}
		}
	}

	@discardableResult
	func saveFile(name: String, content: String) -> Bool {
		let fm = FileManager.default
		guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
		let url = dir.appendingPathComponent(name)
		do {
			let parentDir = url.deletingLastPathComponent()
			if !fm.fileExists(atPath: parentDir.path) {
				try fm.createDirectory(at: parentDir, withIntermediateDirectories: true)
			}
			try content.write(to: url, atomically: true, encoding: .utf8)
			log("File saved: \(name)")
			return true
		} catch {
			log("Failed to save file: \(name) - \(error.localizedDescription)")
			return false
		}
	}

	func readFile(name: String) -> String? {
		let fm = FileManager.default
		guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) else { return nil }
		do {
			let content = try String(contentsOf: url, encoding: .utf8)
			log("File read: \(name)")
			return content
		} catch {
			log("Failed to read file: \(name) - \(error.localizedDescription)")
			return nil
		}
	}

	@discardableResult
	func removeFile(name: String) -> Bool {
		let fm = FileManager.default
		guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) else { return false }
		do {
			try fm.removeItem(at: url)
			log("File removed: \(name)")
			return true
		} catch {
			log("Failed to remove file: \(name) - \(error.localizedDescription)")
			return false
		}
	}

	func openAppSettings() {
		DispatchQueue.main.async {
			if let url = URL(string: UIApplication.openSettingsURLString) {
				UIApplication.shared.open(url)
			}
		}
	}

	func openUrl(url: String) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.log("openUrl requested: \(url)")
			if url.hasPrefix("file://"), let rawURL = URL(string: url) {
				// file:/// + /absolute/path produces file:////path (4 slashes); strip extra leading slashes.
				var cleanPath = rawURL.path
				while cleanPath.hasPrefix("//") { cleanPath = String(cleanPath.dropFirst()) }
				let fileURL = URL(fileURLWithPath: cleanPath)
				self.webView.loadFileURL(fileURL, allowingReadAccessTo: Bundle.main.bundleURL)
			} else if let externalURL = URL(string: url) {
				UIApplication.shared.open(externalURL)
			}
		}
	}

	func saveDeepLink(url: URL?) {
		guard let url = url else { return }
		deepLinkURL = url.absoluteString
		sendDeepLink()
	}

	func sendDeepLink() {
		guard let url = deepLinkURL, pageLoaded else { return }
		pushJavascript(arguments: ["event": "onReceiveDeepLink", "url": url])
	}

	func readDeepLink() -> String? {
		return deepLinkURL
	}

	func clearDeepLink() {
		deepLinkURL = nil
	}

	func downloadFile(url: String, filename: String = "", headers: [String: String] = [:], key: String? = nil) {
		guard let requestURL = URL(string: url) else {
			log("Download failed: invalid URL")
			pushDownloadFile(key: key, filename: filename, mimeType: "", uri: nil, status: "failed")
			return
		}
		var request = URLRequest(url: requestURL)
		headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
		let fallbackFilename = !filename.isEmpty ? filename : requestURL.lastPathComponent.isEmpty ? "download" : requestURL.lastPathComponent
		log("Start download: \(url) with \(headers.count) headers")
		startDownloadTask(request: request, key: key, filename: fallbackFilename, mimeType: mimeTypeForExtension(requestURL.pathExtension)) { [weak self] tempURL, response in
			guard let self = self else { return }
			let mimeType = response?.mimeType ?? self.mimeTypeForExtension(requestURL.pathExtension)
			let suggestedFilename = !filename.isEmpty ? filename : response?.suggestedFilename ?? fallbackFilename
			self.saveDownloadedFile(from: tempURL, filename: suggestedFilename, mimeType: mimeType, key: key)
		}
	}

	func cancelDownload(key: String? = nil) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			for (id, entry) in self.activeDownloads where key == nil || key!.isEmpty || entry.key == key {
				self.cancelledDownloads.insert(id)
				if #available(iOS 14.5, *), let download = entry.download as? WKDownload {
					download.cancel(nil)
				} else if let task = entry.download as? URLSessionDownloadTask {
					task.cancel()
				}
				self.log("Download cancelled")
			}
		}
	}

	func log(_ message: @autoclosure () -> String, force: Bool = false) {
		guard developMode || force else { return }
		NSLog("%@ %@", logTag, message())
	}

	// MARK: - Internal helpers

	private func pushJavascript(arguments: [String: Any]) {
		guard let data = try? JSONSerialization.data(withJSONObject: arguments),
			  let json = String(data: data, encoding: .utf8) else { return }
		let js = "WUIEnvironment.response(\(json))"
		DispatchQueue.main.async { [weak self] in
			self?.webView.evaluateJavaScript(js, completionHandler: nil)
		}
	}

	private func parseColor(_ color: String) -> UIColor? {
		if color.hasPrefix("#") {
			var hex = String(color.dropFirst())
			if hex.count == 6 { hex = "FF" + hex }
			guard hex.count == 8 else { return nil }
			var value: UInt64 = 0
			Scanner(string: hex).scanHexInt64(&value)
			return UIColor(
				red:   CGFloat((value >> 16) & 0xFF) / 255,
				green: CGFloat((value >> 8)  & 0xFF) / 255,
				blue:  CGFloat(value         & 0xFF) / 255,
				alpha: CGFloat((value >> 24) & 0xFF) / 255
			)
		}
		// Named colors resolved from Assets.xcassets; host app must define the color sets.
		return UIColor(named: color)
	}

	// Download state (downloadObservations, activeDownloads, cancelledDownloads)
	// is only mutated on the main thread; URLSession callbacks run on a background queue.
	private func runOnMain(_ block: @escaping () -> Void) {
		if Thread.isMainThread {
			block()
		} else {
			DispatchQueue.main.async(execute: block)
		}
	}

	private func observeDownloadProgress(_ progress: Progress, id: ObjectIdentifier, key: String?) {
		var lastProgressTime: TimeInterval = 0
		downloadObservations[id] = progress.observe(\.completedUnitCount) { [weak self] progress, _ in
			guard let self = self else { return }
			let now = Date().timeIntervalSince1970
			guard now - lastProgressTime >= self.downloadProgressInterval else { return }
			lastProgressTime = now
			self.pushDownloadProgress(key: key, loaded: progress.completedUnitCount, total: progress.totalUnitCount)
		}
	}

	// URLSessionTask.progress is measured in percent units, so the byte counters are observed instead.
	private func observeDownloadProgress(_ task: URLSessionDownloadTask, id: ObjectIdentifier, key: String?) {
		var lastProgressTime: TimeInterval = 0
		downloadObservations[id] = task.observe(\.countOfBytesReceived) { [weak self] task, _ in
			guard let self = self else { return }
			let now = Date().timeIntervalSince1970
			guard now - lastProgressTime >= self.downloadProgressInterval else { return }
			lastProgressTime = now
			self.pushDownloadProgress(key: key, loaded: task.countOfBytesReceived, total: task.countOfBytesExpectedToReceive)
		}
	}

	private func stopObservingDownload(id: ObjectIdentifier) {
		downloadObservations.removeValue(forKey: id)?.invalidate()
	}

	private func pushDownloadProgress(key: String? = nil, loaded: Int64, total: Int64) {
		pushJavascript(arguments: [
			"event":  "onDownloadProgress",
			"key":    key.map { $0 as Any } ?? NSNull(),
			"loaded": loaded,
			"total":  total > 0 ? total : -1
		])
	}

	private func pushDownloadFile(key: String? = nil, filename: String, mimeType: String, uri: String?, status: String, httpStatus: Int? = nil) {
		pushJavascript(arguments: [
			"event":      "onDownloadFile",
			"key":        key.map { $0 as Any } ?? NSNull(),
			"filename":   filename,
			"mimetype":   mimeType,
			"uri":        uri.map { $0 as Any } ?? NSNull(),
			"status":     status,
			"httpStatus": httpStatus.map { $0 as Any } ?? NSNull()
		])
	}

	private func startDownloadTask(request: URLRequest, key: String? = nil, filename: String, mimeType: String, completion: @escaping (URL, URLResponse?) -> Void) {
		final class TaskReference: @unchecked Sendable {
			var task: URLSessionDownloadTask?
		}
		let reference = TaskReference()
		let task = URLSession.shared.downloadTask(with: request) { [weak self] tempURL, response, error in
			guard let self = self else { return }
			if let task = reference.task {
				let id = ObjectIdentifier(task)
				DispatchQueue.main.async { [weak self] in
					self?.stopObservingDownload(id: id)
					self?.activeDownloads.removeValue(forKey: id)
					self?.cancelledDownloads.remove(id)
				}
			}
			guard let tempURL = tempURL else {
				let cancelled = (error as? URLError)?.code == .cancelled
				self.log("Download \(cancelled ? "cancelled" : "failed"): \(error?.localizedDescription ?? "unknown")")
				self.pushDownloadFile(key: key, filename: filename, mimeType: mimeType, uri: nil, status: cancelled ? "cancelled" : "failed")
				return
			}
			if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
				self.log("Download failed: HTTP \(httpResponse.statusCode)")
				self.pushDownloadFile(key: key, filename: filename, mimeType: mimeType, uri: nil, status: "failed", httpStatus: httpResponse.statusCode)
				return
			}
			if let task = reference.task {
				self.pushDownloadProgress(key: key, loaded: task.countOfBytesReceived, total: task.countOfBytesExpectedToReceive)
			}
			completion(tempURL, response)
		}
		reference.task = task
		runOnMain { [weak self] in
			guard let self = self else { return }
			let id = ObjectIdentifier(task)
			self.activeDownloads[id] = (download: task, key: key)
			self.observeDownloadProgress(task, id: id, key: key)
			task.resume()
		}
	}

	private func saveDownloadedFile(from tempURL: URL, filename: String, mimeType: String, key: String? = nil) {
		let fm = FileManager.default
		guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let downloadsDir = dir.appendingPathComponent("Downloads", isDirectory: true)
		if !fm.fileExists(atPath: downloadsDir.path) {
			try? fm.createDirectory(at: downloadsDir, withIntermediateDirectories: true)
		}
		let nameBase = (filename as NSString).deletingPathExtension
		let ext = (filename as NSString).pathExtension
		var destURL = downloadsDir.appendingPathComponent(filename)
		var version = 1
		while fm.fileExists(atPath: destURL.path) {
			let newName = ext.isEmpty ? "\(nameBase) (\(version))" : "\(nameBase) (\(version)).\(ext)"
			destURL = downloadsDir.appendingPathComponent(newName)
			version += 1
		}
		do {
			try fm.moveItem(at: tempURL, to: destURL)
			log("File downloaded: \(destURL.path)")
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.pushDownloadFile(key: key, filename: destURL.lastPathComponent, mimeType: mimeType, uri: destURL.absoluteString, status: "success")
				self.presentShareSheet(for: destURL)
			}
		} catch {
			log("Failed to save downloaded file: \(error.localizedDescription)")
			pushDownloadFile(key: key, filename: filename, mimeType: mimeType, uri: nil, status: "failed")
		}
	}

	private func downloadFileInBackground(url: URL) {
		let filename = url.lastPathComponent.isEmpty ? "download" : url.lastPathComponent
		if url.isFileURL {
			let mimeType = mimeTypeForExtension(url.pathExtension)
			let fm = FileManager.default
			guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
			let downloadsDir = dir.appendingPathComponent("Downloads", isDirectory: true)
			if !fm.fileExists(atPath: downloadsDir.path) {
				try? fm.createDirectory(at: downloadsDir, withIntermediateDirectories: true)
			}
			let nameBase = (filename as NSString).deletingPathExtension
			let ext = (filename as NSString).pathExtension
			var destURL = downloadsDir.appendingPathComponent(filename)
			var version = 1
			while fm.fileExists(atPath: destURL.path) {
				let newName = ext.isEmpty ? "\(nameBase) (\(version))" : "\(nameBase) (\(version)).\(ext)"
				destURL = downloadsDir.appendingPathComponent(newName)
				version += 1
			}
			do {
				try fm.copyItem(at: url, to: destURL)
				log("File copied to downloads: \(destURL.path)")
				let size = ((try? fm.attributesOfItem(atPath: destURL.path))?[.size] as? NSNumber)?.int64Value ?? -1
				pushDownloadProgress(loaded: max(size, 0), total: size)
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.pushDownloadFile(filename: destURL.lastPathComponent, mimeType: mimeType, uri: destURL.absoluteString, status: "success")
					self.presentShareSheet(for: destURL)
				}
			} catch {
				log("Failed to copy file to downloads: \(error.localizedDescription)")
				pushDownloadFile(filename: filename, mimeType: mimeType, uri: nil, status: "failed")
			}
		} else {
			log("Start background download: \(filename)")
			startDownloadTask(request: URLRequest(url: url), filename: filename, mimeType: mimeTypeForExtension(url.pathExtension)) { [weak self] tempURL, response in
				guard let self = self else { return }
				let mimeType = response?.mimeType ?? self.mimeTypeForExtension(url.pathExtension)
				let suggestedFilename = response?.suggestedFilename ?? filename
				self.saveDownloadedFile(from: tempURL, filename: suggestedFilename, mimeType: mimeType)
			}
		}
	}

	private func mimeTypeForExtension(_ ext: String) -> String {
		switch ext.lowercased() {
			case "pdf":         return "application/pdf"
			case "png":         return "image/png"
			case "jpg", "jpeg": return "image/jpeg"
			case "gif":         return "image/gif"
			case "webp":        return "image/webp"
			case "txt":         return "text/plain"
			case "html":        return "text/html"
			case "zip":         return "application/zip"
			default:            return "application/octet-stream"
		}
	}

	private func presentShareSheet(for url: URL) {
		guard let vc = viewController else { return }
		let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		if let popover = activityVC.popoverPresentationController {
			popover.sourceView = vc.view
			popover.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
			popover.permittedArrowDirections = []
		}
		vc.present(activityVC, animated: true)
	}
}

extension WUIEnvironment: WKScriptMessageHandler {

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		guard message.name == "request",
			  let json = message.body as? [String: Any],
			  let funcName = json["func"] as? String else { return }
		let code = json["code"] as? Int

		func push(_ response: Any) {
			guard let code = code else { return }
			pushJavascript(arguments: ["code": code, "response": response])
		}

		switch funcName {
			case "isAppInForeground":
				push(isAppInForeground())
			case "getDeviceInfo":
				push(getDeviceInfo())
			case "getDisplayInfo":
				push(getDisplayInfo())
			case "getAppInfo":
				push(getAppInfo())
			case "getPermissionsStatus":
				getPermissionsStatus { result in push(result) }
				return
			case "requestPermission":
				let type = json["type"] as? String ?? ""
				requestPermission(type: type) { granted in push(granted) }
				return
			case "getCurrentPosition":
				getCurrentPosition { result in push(result) }
				return
			case "getConnectionStatus":
				push(getConnectionStatus())
			case "setStatusbarStyle":
				if let color = json["color"] as? String, let darkIcons = json["darkIcons"] as? Bool {
					setStatusbarStyle(color: color, darkIcons: darkIcons)
				}
				push("null")
			case "setNavigationbarStyle":
				if let color = json["color"] as? String, let darkIcons = json["darkIcons"] as? Bool {
					setNavigationbarStyle(color: color, darkIcons: darkIcons)
				}
				push("null")
			case "setAppBadge":
				let number = json["number"] as? Int ?? 0
				setAppBadge(number: number)
				push("null")
			case "saveFile":
				if let name = json["name"] as? String, let content = json["content"] as? String {
					push(saveFile(name: name, content: content))
				} else {
					push(false)
				}
			case "readFile":
				if let name = json["name"] as? String {
					push(readFile(name: name) ?? "")
				} else {
					push("")
				}
			case "removeFile":
				if let name = json["name"] as? String {
					push(removeFile(name: name))
				} else {
					push(false)
				}
			case "openAppSettings":
				openAppSettings()
				push("null")
			case "openUrl":
				if let url = json["url"] as? String { openUrl(url: url) }
				push("null")
			case "readDeepLink":
				push(readDeepLink() as Any)
			case "clearDeepLink":
				clearDeepLink()
				push("null")
			case "downloadFile":
				if let url = json["url"] as? String {
					downloadFile(url: url, filename: json["filename"] as? String ?? "", headers: json["headers"] as? [String: String] ?? [:], key: json["key"] as? String)
				}
				push("null")
			case "cancelDownload":
				cancelDownload(key: json["key"] as? String)
				push("null")
			case "log":
				let message = json["message"] as? String ?? ""
				let force = json["force"] as? Bool ?? false
				log("[js] \(message)", force: force)
				return
			case "_xhrRead":
				guard let urlString = json["url"] as? String, let code = json["code"] as? Int else { return }
				var path = URL(string: urlString)?.path ?? urlString
				while path.hasPrefix("//") { path = String(path.dropFirst()) }
				let fileExists = FileManager.default.fileExists(atPath: path)
				let fileContent = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
				let status = fileExists ? 200 : 404
				guard let jsonData = try? JSONEncoder().encode(fileContent),
					  let jsonStr  = String(data: jsonData, encoding: .utf8) else { return }
				let xhrJs = "window._wuiXhrRespond(\(code), \(jsonStr), \(status))"
				DispatchQueue.main.async { [weak self] in self?.webView.evaluateJavaScript(xhrJs, completionHandler: nil) }
				return
			case "_console":
				let level = json["level"] as? String ?? "log"
				let msg   = json["msg"]   as? String ?? ""
				log("[js:\(level)] \(msg)")
				return
			default:
				push("")
		}
	}
}

extension WUIEnvironment: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		pageLoaded = true
		log("Page loaded: \(webView.url?.absoluteString ?? "")")
		sendDeepLink()
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		log("WebView error: \(error.localizedDescription)")
	}

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		log("WebView provisional navigation error: \(error.localizedDescription)")
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard let url = navigationAction.request.url else {
			decisionHandler(.allow)
			return
		}
		if url.isFileURL || url.scheme == "about" {
			decisionHandler(.allow)
		} else if navigationAction.navigationType == .linkActivated {
			UIApplication.shared.open(url)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		let mimeType = navigationResponse.response.mimeType ?? "application/octet-stream"
		let renderableMimeTypes: Set<String> = [
			"text/html", "text/plain", "text/xml", "application/xhtml+xml",
			"image/jpeg", "image/png", "image/gif", "image/webp", "image/svg+xml",
			"application/pdf"
		]
		var shouldDownload = false
		if let httpResponse = navigationResponse.response as? HTTPURLResponse {
			let disposition = httpResponse.value(forHTTPHeaderField: "Content-Disposition") ?? ""
			shouldDownload = disposition.lowercased().contains("attachment") || !renderableMimeTypes.contains(mimeType)
		} else {
			shouldDownload = !renderableMimeTypes.contains(mimeType)
		}
		guard shouldDownload else {
			decisionHandler(.allow)
			return
		}
		if #available(iOS 14.5, *) {
			decisionHandler(.download)
		} else {
			if let url = navigationResponse.response.url {
				let suggestedFilename = navigationResponse.response.suggestedFilename ?? url.lastPathComponent
				log("Start download (URLSession fallback): \(suggestedFilename)")
				startDownloadTask(request: URLRequest(url: url), filename: suggestedFilename, mimeType: mimeType) { [weak self] tempURL, _ in
					self?.saveDownloadedFile(from: tempURL, filename: suggestedFilename, mimeType: mimeType)
				}
			}
			decisionHandler(.cancel)
		}
	}

	@available(iOS 14.5, *)
	func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
		startDownload(download)
	}

	@available(iOS 14.5, *)
	func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
		startDownload(download)
	}

	@available(iOS 14.5, *)
	private func startDownload(_ download: WKDownload) {
		download.delegate = self
		let id = ObjectIdentifier(download)
		activeDownloads[id] = (download: download, key: nil)
		observeDownloadProgress(download.progress, id: id, key: nil)
	}
}

@available(iOS 14.5, *)
extension WUIEnvironment: WKDownloadDelegate {

	func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
		let fm = FileManager.default
		guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
			completionHandler(nil)
			return
		}
		let downloadsDir = dir.appendingPathComponent("Downloads", isDirectory: true)
		if !fm.fileExists(atPath: downloadsDir.path) {
			try? fm.createDirectory(at: downloadsDir, withIntermediateDirectories: true)
		}
		let nameBase = (suggestedFilename as NSString).deletingPathExtension
		let ext = (suggestedFilename as NSString).pathExtension
		var destURL = downloadsDir.appendingPathComponent(suggestedFilename)
		var version = 1
		while fm.fileExists(atPath: destURL.path) {
			let newName = ext.isEmpty ? "\(nameBase) (\(version))" : "\(nameBase) (\(version)).\(ext)"
			destURL = downloadsDir.appendingPathComponent(newName)
			version += 1
		}
		log("Download destination: \(destURL.path)")
		let mimeType = response.mimeType ?? "application/octet-stream"
		downloadDestinations[ObjectIdentifier(download)] = (url: destURL, mimeType: mimeType)
		completionHandler(destURL)
	}

	func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
		let key = ObjectIdentifier(download)
		let info = downloadDestinations.removeValue(forKey: key)
		stopObservingDownload(id: key)
		activeDownloads.removeValue(forKey: key)
		let status = cancelledDownloads.remove(key) != nil ? "cancelled" : "failed"
		log("Download \(status): \(error.localizedDescription)")
		pushDownloadFile(filename: info?.url.lastPathComponent ?? "", mimeType: info?.mimeType ?? "", uri: nil, status: status)
	}

	func downloadDidFinish(_ download: WKDownload) {
		let key = ObjectIdentifier(download)
		stopObservingDownload(id: key)
		activeDownloads.removeValue(forKey: key)
		cancelledDownloads.remove(key)
		guard let info = downloadDestinations[key] else { return }
		downloadDestinations.removeValue(forKey: key)
		log("Download finished: \(info.url.lastPathComponent)")
		pushDownloadProgress(loaded: download.progress.completedUnitCount, total: download.progress.totalUnitCount)
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.pushDownloadFile(filename: info.url.lastPathComponent, mimeType: info.mimeType, uri: info.url.absoluteString, status: "success")
			self.presentShareSheet(for: info.url)
		}
	}
}

extension WUIEnvironment: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let result: [String: Any] = [
			"latitude":  location.coordinate.latitude,
			"longitude": location.coordinate.longitude,
			"accuracy":  location.horizontalAccuracy,
			"provider":  "gps",
			"timestamp": Int(location.timestamp.timeIntervalSince1970 * 1000)
		]
		DispatchQueue.main.async { [weak self] in
			self?.locationCompletion?(result)
			self?.locationCompletion = nil
			self?.locationManager = nil
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		log("Location error: \(error.localizedDescription)")
		DispatchQueue.main.async { [weak self] in
			self?.locationCompletion?(["error": "Failed to get location: \(error.localizedDescription)"])
			self?.locationCompletion = nil
			self?.locationManager = nil
		}
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if let permissionCompletion = permissionLocationCompletion {
			switch manager.authorizationStatus {
				case .authorizedWhenInUse, .authorizedAlways:
					permissionLocationCompletion = nil
					locationManager = nil
					DispatchQueue.main.async { permissionCompletion(true) }
				case .denied, .restricted:
					permissionLocationCompletion = nil
					locationManager = nil
					DispatchQueue.main.async { permissionCompletion(false) }
				default:
					break
			}
			return
		}
		switch manager.authorizationStatus {
			case .authorizedWhenInUse, .authorizedAlways:
				// locationServicesEnabled() is intentionally not checked here to avoid the
				// main-thread unresponsiveness warning; didFailWithError handles that case.
				manager.requestLocation()
			case .denied, .restricted:
				DispatchQueue.main.async { [weak self] in
					self?.locationCompletion?(["error": "Location permission denied"])
					self?.locationCompletion = nil
					self?.locationManager = nil
				}
			default:
				break
		}
	}
}

extension WUIEnvironment: WKUIDelegate {

	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		if let url = navigationAction.request.url {
			downloadFileInBackground(url: url)
		}
		return nil
	}

	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		guard let vc = viewController else { completionHandler(); return }
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
		vc.present(alert, animated: true)
	}

	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
		guard let vc = viewController else { completionHandler(false); return }
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) })
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) })
		vc.present(alert, animated: true)
	}

	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
		guard let vc = viewController else { completionHandler(nil); return }
		let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
		alert.addTextField { $0.text = defaultText }
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(nil) })
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(alert.textFields?.first?.text) })
		vc.present(alert, animated: true)
	}

}
