/*
 * @file WUIEnvironment.java
 * @class WUIEnvironment
 * @version 0.4
 * @author Sergio E. Belmar V. (wuijs.project@gmail.com)
 * @copyright Sergio E. Belmar V. (wuijs.project@gmail.com)
 */

package YOUR.PACKAGE.NAME; // Update this to match your project package

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.DownloadManager;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.media.MediaScannerConnection;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.net.http.SslError;
import android.webkit.ConsoleMessage;
import android.webkit.WebChromeClient;
import android.webkit.JavascriptInterface;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.SslErrorHandler;
import android.webkit.URLUtil;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.ValueCallback;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import androidx.activity.OnBackPressedCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.PermissionChecker;
import androidx.core.content.FileProvider;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Consumer;
import me.leolin.shortcutbadger.ShortcutBadger;

public class WUIEnvironment {
	
	public WebView webView;
	private final Context context;
	private AppCompatActivity activity;
	private boolean developMode = false;
	private String deepLinkURL = null;
	private boolean pageLoaded = false;
	private final String className = "WUIEnvironment";
	private final Map<Integer, Consumer<Boolean>> permissionCallbacks = new HashMap<>();
	private final AtomicInteger permissionRequestCodeCounter = new AtomicInteger(1000);
	private ValueCallback<Uri[]> fileChooserCallback = null;
	private Uri cameraOutputUri = null;
	private ActivityResultLauncher<Intent> fileChooserLauncher;
	private ActivityResultLauncher<Intent> cameraLauncher;

	// Initialization

	public WUIEnvironment(Context context, boolean developMode) throws JSONException {
		this.context = context;
		this.developMode = developMode;
		webViewInit();
	}

	public WUIEnvironment(Context context) throws JSONException {
		this.context = context;
		webViewInit();
	}

	private void webViewInit() throws JSONException {
		webView = new WebView(context);
		if (context instanceof AppCompatActivity) {
			activity = (AppCompatActivity) context;
			activity.setContentView(webView);
			setupActivityResultLaunchers();
			setupWebViewSettings();
			setupWebViewClient();
			setupBackPressHandler();
			setupDownloadHandler();
		}
	}
	
	private void setupActivityResultLaunchers() {
		cameraLauncher = activity.registerForActivityResult(
			new ActivityResultContracts.StartActivityForResult(),
			result -> {
				if (fileChooserCallback == null) return;
				Uri[] results = result.getResultCode() == android.app.Activity.RESULT_OK && cameraOutputUri != null
					? new Uri[]{ cameraOutputUri } : null;
				fileChooserCallback.onReceiveValue(results);
				fileChooserCallback = null;
				cameraOutputUri = null;
			}
		);
		fileChooserLauncher = activity.registerForActivityResult(
			new ActivityResultContracts.StartActivityForResult(),
			result -> {
				if (fileChooserCallback == null) return;
				Intent data = result.getData();
				Uri[] results = result.getResultCode() == android.app.Activity.RESULT_OK && data != null && data.getData() != null
					? new Uri[]{ data.getData() } : null;
				fileChooserCallback.onReceiveValue(results);
				fileChooserCallback = null;
				cameraOutputUri = null;
			}
		);
	}

	@SuppressLint("SetJavaScriptEnabled")
	private void setupWebViewSettings() throws JSONException {
		JSONObject appInfo = getAppInfo();
		WebSettings webSettings = webView.getSettings();
		webSettings.setUserAgentString(webSettings.getUserAgentString()+" "+className+" ("+appInfo.get("name")+"/"+appInfo.get("version")+")");
		webSettings.setJavaScriptEnabled(true);
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
		webSettings.setAllowFileAccess(true);
		webSettings.setAllowContentAccess(true);
		webSettings.setAllowUniversalAccessFromFileURLs(true);
		webSettings.setAllowFileAccessFromFileURLs(true);
		webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
		webSettings.setCacheMode(WebSettings.LOAD_NO_CACHE);
		webSettings.setDomStorageEnabled(true);
		webSettings.setDatabaseEnabled(true);
		webSettings.setGeolocationEnabled(true);
		webSettings.setLoadWithOverviewMode(true);
		webSettings.setUseWideViewPort(true);
		webSettings.setBuiltInZoomControls(true);
		webSettings.setDisplayZoomControls(false);
		webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
		webSettings.setBlockNetworkImage(false);
		webSettings.setBlockNetworkLoads(false);
		log("i", "UserAgent: " + webSettings.getUserAgentString());
	}

	@SuppressLint("JavascriptInterface")
	private void setupWebViewClient() {
		webView.addJavascriptInterface(new WebViewJavascriptInterface(), "Android");
		webView.setWebChromeClient(new WebChromeClient() {
			@Override
			public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
				log("d", "(JS) " + consoleMessage.message() + " -- From line "
						+ consoleMessage.lineNumber() + " of "
						+ consoleMessage.sourceId());
				return true;
			}
			@Override
			public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
				new AlertDialog.Builder(activity)
					.setMessage(message)
					.setPositiveButton(android.R.string.ok, (d, w) -> result.confirm())
					.setCancelable(false)
					.show();
				return true;
			}
			@Override
			public boolean onJsConfirm(WebView view, String url, String message, JsResult result) {
				new AlertDialog.Builder(activity)
					.setMessage(message)
					.setPositiveButton(android.R.string.ok, (d, w) -> result.confirm())
					.setNegativeButton(android.R.string.cancel, (d, w) -> result.cancel())
					.setCancelable(false)
					.show();
				return true;
			}
			@Override
			public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
				EditText input = new EditText(activity);
				if (defaultValue != null) input.setText(defaultValue);
				new AlertDialog.Builder(activity)
					.setMessage(message)
					.setView(input)
					.setPositiveButton(android.R.string.ok, (d, w) -> result.confirm(input.getText().toString()))
					.setNegativeButton(android.R.string.cancel, (d, w) -> result.cancel())
					.setCancelable(false)
					.show();
				return true;
			}
			@Override
			public boolean onShowFileChooser(WebView view, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
				if (fileChooserCallback != null) {
					fileChooserCallback.onReceiveValue(null);
				}
				fileChooserCallback = filePathCallback;
				cameraOutputUri = null;
				final Intent fileIntent = fileChooserParams.createIntent();
				Intent cameraIntent = null;
				try {
					File cameraFile = File.createTempFile("wui_camera_", ".jpg", activity.getCacheDir());
					cameraOutputUri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".provider", cameraFile);
					cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
					cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, cameraOutputUri);
					cameraIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
				} catch (Exception e) {
					log("w", "Could not prepare camera intent: " + e.getMessage());
				}
				final Intent finalCameraIntent = cameraIntent;
				new AlertDialog.Builder(activity)
					.setItems(new CharSequence[]{ "Take photo", "Choose from gallery" }, (dialog, which) -> {
						if (which == 0 && finalCameraIntent != null) {
							requestPermission("camera", granted -> {
								if (!granted) {
									fileChooserCallback.onReceiveValue(null);
									fileChooserCallback = null;
									cameraOutputUri = null;
									return;
								}
								try {
									cameraLauncher.launch(finalCameraIntent);
								} catch (Exception e) {
									fileChooserCallback.onReceiveValue(null);
									fileChooserCallback = null;
									cameraOutputUri = null;
									log("e", "Cannot open camera: " + e.getMessage());
								}
							});
						} else {
							try {
								fileChooserLauncher.launch(fileIntent);
							} catch (Exception e) {
								fileChooserCallback.onReceiveValue(null);
								fileChooserCallback = null;
								cameraOutputUri = null;
								log("e", "Cannot open file chooser: " + e.getMessage());
							}
						}
					})
					.setOnCancelListener(dialog -> {
						fileChooserCallback.onReceiveValue(null);
						fileChooserCallback = null;
						cameraOutputUri = null;
					})
					.show();
				return true;
			}
		});
		webView.setWebViewClient(new WebViewClient() {

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
				String url = request.getUrl().toString();
				if (url.startsWith("file:///android_asset/")) {
					return false;
				}
				view.loadUrl(url);
				return true;
			}
			
			@Override
			public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
				int errorCode = error.getPrimaryError();
				log("e", "SSL error: " + error);
				switch (errorCode) {
					case SslError.SSL_DATE_INVALID: log("e", "SSL error: Certificate date is invalid (code: " + errorCode + ")"); break;
					case SslError.SSL_EXPIRED: log("e", "SSL error: Certificate has expired (code: " + errorCode + ")"); break;
					case SslError.SSL_IDMISMATCH: log("e", "SSL error: Certificate ID mismatch (code: " + errorCode + ")"); break;
					case SslError.SSL_UNTRUSTED: log("e", "SSL error: Certificate is not trusted (code: " + errorCode + ")"); break;
					case SslError.SSL_NOTYETVALID: log("e", "SSL error: Certificate is not yet valid (code: " + errorCode + ")"); break;
					default: log("e", "SSL error: Unknown SSL error (code: " + errorCode + ")"); break;
				}
				handler.cancel();
			}
			
			@Override
			public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
				super.onReceivedError(view, request, error);
				log("e", "WebView Error (" + request.getUrl() + "): " + error.getDescription() + " (Code: " + error.getErrorCode() + ")");
				if (request.isForMainFrame()) {
					log("e", "Main frame failed to load!");
				}
			}

			@Override
			public void onPageFinished(WebView view, String url) {
				pageLoaded = true;
				log("i", "Page loaded: " + url);
				if (deepLinkURL != null) {
					try {
						JSONObject arguments = new JSONObject();
						arguments.put("event", "onReceiveDeepLink");
						arguments.put("url", deepLinkURL);
						pushJavascript(arguments);
					} catch (JSONException e) {
						throw new RuntimeException(e);
					}
				}
			}
		});
	}

	private void setupBackPressHandler() {
		activity.getOnBackPressedDispatcher().addCallback(activity, new OnBackPressedCallback(true) {

			@Override
			public void handleOnBackPressed() {
				if (webView.canGoBack()) {
					webView.goBack();
				} else {
					this.setEnabled(false);
					activity.getOnBackPressedDispatcher().onBackPressed();
				}
			}
		});
	}

	private void setupDownloadHandler() {
		webView.setDownloadListener((url, userAgent, contentDisposition, mimetype, contentLength) -> {
			String filename = "";
			File downloadFile = null;
			boolean downloaded = false;
			log("d", "Start download '"+url+"'");
			if (url.startsWith("file:///android_asset/")) {
				try {
					String assetPath = url.replace("file:///android_asset/", "");
					File sourceFile = new File(activity.getCacheDir(), assetPath);
					if (!sourceFile.exists()) {
						File sourceParent = sourceFile.getParentFile();
						if (sourceParent != null && !sourceParent.exists() && !sourceParent.mkdirs()) {
							log("w", "Could not create cache directory: " + sourceParent.getAbsolutePath());
						}
						try (java.io.InputStream in = context.getAssets().open(assetPath);
							java.io.FileOutputStream out = new java.io.FileOutputStream(sourceFile)) {
							byte[] buffer = new byte[1024];
							int len;
							while ((len = in.read(buffer)) != -1) {
								out.write(buffer, 0, len);
							}
						}
					}
					if (sourceFile.exists()) {
						File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
						if (!downloadsDir.exists() && !downloadsDir.mkdirs()) {
							log("w", "Could not create downloads directory");
						}
						filename = URLUtil.guessFileName(url, contentDisposition, mimetype);
						downloadFile = new File(downloadsDir, filename);
						int version = 1;
						while (downloadFile.exists()) {
							String nameWithoutExt = filename.replaceFirst("[.][^.]+$", "");
							String extension = filename.substring(filename.lastIndexOf('.'));
							downloadFile = new File(downloadsDir, nameWithoutExt + " (" + version + ")" + extension);
							version++;
						}
						try (java.io.FileInputStream in = new java.io.FileInputStream(sourceFile);
							java.io.FileOutputStream out = new java.io.FileOutputStream(downloadFile)) {
							byte[] buffer = new byte[1024];
							int len;
							while ((len = in.read(buffer)) != -1) {
								out.write(buffer, 0, len);
							}
						}
						log("i", "Asset file downloaded to: " + downloadFile.getAbsolutePath());
						downloaded = true;
					}
				} catch (Exception e) {
					log("e", "Error downloading asset file: " + e.getMessage());
				}
			} else {
				filename = URLUtil.guessFileName(url, contentDisposition, mimetype);
				File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
				downloadFile = new File(downloadsDir, filename);
				DownloadManager downloadManager = (DownloadManager) activity.getSystemService(Context.DOWNLOAD_SERVICE);
				DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));
				request.setTitle(filename);
				request.setMimeType(mimetype);
				request.allowScanningByMediaScanner();
				request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
				request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, filename);
				downloadManager.enqueue(request);
				downloaded = true;
			}
			if (downloaded) {
				MediaScannerConnection.scanFile(context, new String[]{downloadFile.getAbsolutePath()}, null, null);
				Intent openIntent = new Intent(Intent.ACTION_VIEW);
				Uri uri = Uri.fromFile(downloadFile);
				openIntent.setDataAndType(uri, mimetype != null && !mimetype.isEmpty() ? mimetype : "application/octet-stream");
				openIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				try {
					context.startActivity(openIntent);
				} catch (Exception e) {
					log("e", "No app found to open the file: " + e.getMessage());
				}
				try {
					JSONObject arguments = new JSONObject();
					arguments.put("event", "onDownloadFile");
					arguments.put("filename", filename);
					arguments.put("mimetype", mimetype);
					arguments.put("uri", uri.toString());
					pushJavascript(arguments);
				} catch (JSONException e) {
					throw new RuntimeException(e);
				}
			}
		});
	}

	// Native bridge functions

	public void requestPermission(String type, Consumer<Boolean> callback) {
		String[] perms;
		switch (type) {
			case "notifications":
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
					perms = new String[]{ Manifest.permission.POST_NOTIFICATIONS };
				} else {
					if (callback != null) callback.accept(true);
					return;
				}
				break;
			case "location":
				perms = new String[]{ Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION };
				break;
			case "camera":
				perms = new String[]{ Manifest.permission.CAMERA };
				break;
			case "contacts":
				perms = new String[]{ Manifest.permission.READ_CONTACTS };
				break;
			case "storage":
				perms = new String[]{ Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE };
				break;
			default:
				if (callback != null) callback.accept(false);
				return;
		}
		boolean allGranted = true;
		for (String p : perms) {
			if (ContextCompat.checkSelfPermission(activity, p) != PackageManager.PERMISSION_GRANTED) { allGranted = false; break; }
		}
		if (allGranted) {
			if (callback != null) callback.accept(true);
			return;
		}
		// Permanent denial ("don't ask again") returns DENIED immediately via onRequestPermissionsResult,
		// so the callback resolves with false without blocking — no extra heuristic needed.
		final String[] permsFinal = perms;
		int requestCode = permissionRequestCodeCounter.getAndIncrement();
		permissionCallbacks.put(requestCode, callback);
		activity.runOnUiThread(() -> ActivityCompat.requestPermissions(activity, permsFinal, requestCode));
	}

	@SuppressWarnings("unused")
	public void handlePermissionResult(int requestCode, String[] permissions, int[] grantResults) {
		Consumer<Boolean> callback = permissionCallbacks.remove(requestCode);
		if (callback == null) return;
		boolean granted = false;
		for (int r : grantResults) {
			if (r == PackageManager.PERMISSION_GRANTED) { granted = true; break; }
		}
		callback.accept(granted);
	}


	public boolean isAppInForeground() {
		ActivityManager activityManager = (ActivityManager) activity.getSystemService(Context.ACTIVITY_SERVICE);
		if (activityManager == null) return false;
		String packageName = activity.getPackageName();
		for (RunningAppProcessInfo processInfo : activityManager.getRunningAppProcesses()) {
			if (processInfo.processName.equals(packageName)) {
				return processInfo.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND;
			}
		}
		return false;
	}

	@SuppressLint("HardwareIds")
	private String getDeviceID() {
		String deviceId = Settings.Secure.getString(activity.getContentResolver(), Settings.Secure.ANDROID_ID);
		if (deviceId != null && !deviceId.equals("9774d56d682e549c")) {
			return deviceId;
		}
		return "";
	}

	private String getDeviceUUID() {
		String deviceId = this.getDeviceID();
		if (!deviceId.isEmpty()) {
			UUID deviceUUID = UUID.nameUUIDFromBytes(deviceId.getBytes());
			return deviceUUID.toString();
		}
		return "";
	}

	private String getDeviceName() {
		try {
			if (ActivityCompat.checkSelfPermission(activity, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
				log("w", "Bluetooth permission not granted, using Build.USER as device name");
				return Build.USER;
			}
			BluetoothAdapter device = BluetoothAdapter.getDefaultAdapter();
			if (device != null) {
				return device.getName();
			}
		} catch (SecurityException e) {
			log("w", "SecurityException accessing Bluetooth: " + e.getMessage());
			return Build.USER;
		} catch (Exception e) {
			log("w", "Exception getting device name: " + e.getMessage());
			return Build.USER;
		}
		return Build.USER;
	}

	public JSONObject getDeviceInfo() {
		JSONObject deviceInfo = new JSONObject();
		try {
			deviceInfo.put("id", this.getDeviceID());
			deviceInfo.put("uuid", this.getDeviceUUID());
			deviceInfo.put("name", this.getDeviceName());
			deviceInfo.put("platform", "Android");
			deviceInfo.put("version", Build.VERSION.RELEASE);
			deviceInfo.put("maker", Build.MANUFACTURER);
			deviceInfo.put("model", Build.MODEL);
		} catch (JSONException e) {
			try {
				deviceInfo.put("error", "Failed to get device information: " + e.getMessage());
			} catch (JSONException ex) {
				throw new RuntimeException(ex);
			}
		}
		return deviceInfo;
	}

	@RequiresApi(api = Build.VERSION_CODES.O)
	@SuppressLint({"InternalInsetResource", "DiscouragedApi"})
	public JSONObject getDisplayInfo() {
		JSONObject displayInfo = new JSONObject();
		try {
			Window window = activity.getWindow();
			View decorView = window.getDecorView();
			float density = context.getResources().getDisplayMetrics().density;
			int densityDpi = context.getResources().getDisplayMetrics().densityDpi;
			int width = context.getResources().getDisplayMetrics().widthPixels;
			int height = context.getResources().getDisplayMetrics().heightPixels;
			String orientation = context.getResources().getConfiguration().orientation == android.content.res.Configuration.ORIENTATION_LANDSCAPE ? "landscape" : "portrait";
			float refreshRate = activity.getWindowManager().getDefaultDisplay().getRefreshRate();
			boolean hasNotch = false;
			int statusbarHeight = 0;
			int navigationbarHeight = 0;
			String navigationMode = "unknown";
			boolean statusbarTransparent = (window.getAttributes().flags & WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS) != 0;
			boolean statusbarLightMode = (decorView.getSystemUiVisibility() & View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR) != 0;
			boolean statusbarOverlay = statusbarTransparent
				|| (window.getAttributes().flags & WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS) != 0
				|| android.graphics.Color.alpha(window.getStatusBarColor()) < 255;
			boolean navigationbarTransparent = (window.getAttributes().flags & WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION) != 0;
			boolean navigationbarLightMode = (decorView.getSystemUiVisibility() & View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR) != 0;
			boolean navigationbarOverlay = navigationbarTransparent
				|| (window.getAttributes().flags & WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS) != 0
				|| android.graphics.Color.alpha(window.getNavigationBarColor()) < 255;
			boolean systembarDrawsBackgrounds = (window.getAttributes().flags & WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS) != 0;
			android.view.WindowInsets insets = decorView.getRootWindowInsets();
			if (insets != null) {
				statusbarHeight = insets.getSystemWindowInsetTop();
				navigationbarHeight = insets.getSystemWindowInsetBottom();
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
					android.view.DisplayCutout cutout = insets.getDisplayCutout();
					hasNotch = cutout != null;
				}
			}
			if (statusbarHeight == 0) {
				int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
				if (resourceId > 0) statusbarHeight = context.getResources().getDimensionPixelSize(resourceId);
			}
			if (navigationbarHeight == 0) {
				int resourceId = context.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
				if (resourceId > 0) navigationbarHeight = context.getResources().getDimensionPixelSize(resourceId);
			}
			try {
				// Navigation Mode detection (Gestures vs Buttons)
				// 0: 3-button, 1: 2-button, 2: Gestures
				int mode = Settings.Secure.getInt(context.getContentResolver(), "navigation_mode");
				navigationMode = mode == 2 ? "gestures" : mode == 1 ? "2-button" : "3-button";
			} catch (Settings.SettingNotFoundException e) {
				// On some Honor/Huawei devices detect by bar height
				if (navigationbarHeight > 0 && navigationbarHeight < (20 * density)) navigationMode = "gestures_hint";
			}
			displayInfo.put("width", (int) (width / density));
			displayInfo.put("height", (int) (height / density));
			displayInfo.put("density", density);
			displayInfo.put("densityDpi", densityDpi);
			displayInfo.put("orientation", orientation);
			displayInfo.put("refreshRate", Math.round(refreshRate));
			displayInfo.put("aspectRatio", (float) Math.max(width, height) / Math.min(width, height));
			displayInfo.put("notch", hasNotch);
			displayInfo.put("statusbarHeight", (int) (statusbarHeight / density));
			displayInfo.put("statusbarTransparent", statusbarTransparent);
			displayInfo.put("statusbarLightMode", statusbarLightMode);
			displayInfo.put("statusbarOverlay", statusbarOverlay);
			displayInfo.put("navigationMode", navigationMode);
			displayInfo.put("navigationbarHeight", (int) (navigationbarHeight / density));
			displayInfo.put("navigationbarTransparent", navigationbarTransparent);
			displayInfo.put("navigationbarLightMode", navigationbarLightMode);
			displayInfo.put("navigationbarOverlay", navigationbarOverlay);
			displayInfo.put("systembarDrawsBackgrounds", systembarDrawsBackgrounds);

		} catch (JSONException e) {
			try {
				displayInfo.put("error", "Failed to get display information: " + e.getMessage());
			} catch (JSONException ex) {
				throw new RuntimeException(ex);
			}
		}
		return displayInfo;
	}

	public JSONObject getAppInfo() {
		JSONObject appInfo = new JSONObject();
		try {
			PackageManager packageManager = activity.getPackageManager();
			PackageInfo packageInfo = packageManager.getPackageInfo(activity.getPackageName(), 0);
			appInfo.put("name", packageManager.getApplicationLabel(Objects.requireNonNull(packageInfo.applicationInfo)).toString());
			appInfo.put("version", packageInfo.versionName);
			appInfo.put("package", packageInfo.packageName);
			appInfo.put("build", packageInfo.versionCode);
		} catch (PackageManager.NameNotFoundException | JSONException e) {
			try {
				appInfo.put("error", "Could not get application information: " + e.getMessage());
			} catch (JSONException ex) {
				throw new RuntimeException(ex);
			}
		}
		return appInfo;
	}

	public JSONObject getPermissionsStatus() {
		JSONObject permissions = new JSONObject();
		JSONObject manifestPermissions = new JSONObject();
		try {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				manifestPermissions.put("notifications", Manifest.permission.POST_NOTIFICATIONS);
			}
			manifestPermissions.put("location", Manifest.permission.ACCESS_FINE_LOCATION);
			manifestPermissions.put("location.2", Manifest.permission.ACCESS_COARSE_LOCATION);
			manifestPermissions.put("camera", Manifest.permission.CAMERA);
			manifestPermissions.put("contacts", Manifest.permission.READ_CONTACTS);
			manifestPermissions.put("phone", Manifest.permission.READ_PHONE_STATE);
			manifestPermissions.put("storage", Manifest.permission.READ_EXTERNAL_STORAGE);
			manifestPermissions.put("storage.2", Manifest.permission.WRITE_EXTERNAL_STORAGE);
			manifestPermissions.keys().forEachRemaining(key -> {
				if (!key.contains(".")) {
					try {
						String permission = manifestPermissions.getString(key);
						String permission2 = manifestPermissions.has(key + ".2") ? manifestPermissions.getString(key + ".2") : null;
						boolean granted = ActivityCompat.checkSelfPermission(activity, permission) == PermissionChecker.PERMISSION_GRANTED || (permission2 != null && ActivityCompat.checkSelfPermission(activity, permission2) == PermissionChecker.PERMISSION_GRANTED);
						if (granted) {
							permissions.put(key, "granted");
						} else if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission) || (permission2 != null && ActivityCompat.shouldShowRequestPermissionRationale(activity, permission2))) {
							permissions.put(key, "denied");
						} else {
							permissions.put(key, "default");
						}
					} catch (Exception e) {
						try { permissions.put(key, "undefined"); } catch (Exception ignore) {}
					}
				}
			});
		} catch (Exception e) {
			try { permissions.put("error", "Failed to get permissions: " + e.getMessage()); } catch (Exception ignore) {}
		}
		return permissions;
	}

	@SuppressLint("MissingPermission")
	public JSONObject getCurrentPosition() {
		JSONObject position = new JSONObject();
		try {
			if (!requestPermissionSync("location")) {
				position.put("error", "Location permission not granted");
				return position;
			}
			LocationManager locationManager = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
			if (locationManager == null) {
				position.put("error", "LocationManager not available");
				return position;
			}
			boolean isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
			boolean isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
			if (!isGpsEnabled && !isNetworkEnabled) {
				position.put("error", "Location services are disabled (GPS and Network)");
				return position;
			}
			Location location = null;
			if (isNetworkEnabled) {
				location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
			}
			if (location == null && isGpsEnabled) {
				location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
			}
			if (location == null) {
				for (String provider : locationManager.getProviders(true)) {
					Location l = locationManager.getLastKnownLocation(provider);
					if (l != null) {
						location = l;
						break;
					}
				}
			}
			if (location == null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
				// (Android 11+)
				final Location[] freshLocation = new Location[1];
				final CountDownLatch latch = new CountDownLatch(1);
				try {
					String provider = isGpsEnabled ? LocationManager.GPS_PROVIDER : LocationManager.NETWORK_PROVIDER;
					locationManager.getCurrentLocation(
						provider,
						null,
						activity.getMainExecutor(),
						loc -> {
							freshLocation[0] = loc;
							latch.countDown();
						}
					);
					// Wait up to 5 seconds for a fresh location
					if (latch.await(5, TimeUnit.SECONDS)) {
						location = freshLocation[0];
					}
				} catch (Exception e) {
					log("e", "Error requesting fresh location: " + e.getMessage());
				}
			}
			if (location != null) {
				position.put("latitude", location.getLatitude());
				position.put("longitude", location.getLongitude());
				position.put("accuracy", location.getAccuracy());
				position.put("provider", location.getProvider());
				position.put("timestamp", location.getTime());
			} else {
				String status = "GPS: " + (isGpsEnabled ? "ON" : "OFF") + ", Network: " + (isNetworkEnabled ? "ON" : "OFF");
				position.put("error", "Location unavailable. Cache is empty and fresh request timed out. " + status);
				log("w", "Could not get location. Status: " + status);
			}
		} catch (Exception e) {
			try {
				position.put("error", "Failed to get current position: " + e.getMessage());
			} catch (JSONException ex) {
				throw new RuntimeException(ex);
			}
		}
		return position;
	}

	public boolean getConnectionStatus() {
		ConnectivityManager connectivityManager = (ConnectivityManager) activity.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (connectivityManager != null) {
			Network network = connectivityManager.getActiveNetwork();
			if (network != null) {
				NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
				return capabilities != null && (
					capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
					capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
					capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET));
			}
		}
		return false;
	}

	public void setStatusbarStyle(String color, boolean darkIcons) {
		activity.runOnUiThread(() -> {
			Window window = activity.getWindow();
			int colorCode;
			if (color.startsWith("#")) {
				try {
					colorCode = android.graphics.Color.parseColor(color);
				} catch (IllegalArgumentException e) {
					colorCode = ContextCompat.getColor(context, R.color.statusbarLightColor);
				}
			} else {
				switch (color) {
					case "statusbarLightColor": colorCode = ContextCompat.getColor(context, R.color.statusbarLightColor); break;
					case "statusbarLightOverlayColor": colorCode = ContextCompat.getColor(context, R.color.statusbarLightOverlayColor); break;
					case "statusbarDarkColor": colorCode = ContextCompat.getColor(context, R.color.statusbarDarkColor); break;
					case "statusbarDarkOverlayColor": colorCode = ContextCompat.getColor(context, R.color.statusbarDarkOverlayColor); break;
					default: colorCode = ContextCompat.getColor(context, R.color.statusbarLightColor); break;
				}
			}
			log("i", "Statusbar set color: " + color);
			window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			window.setStatusBarColor(colorCode);
			View decor = window.getDecorView();
			int flags = decor.getSystemUiVisibility();
			if (darkIcons) {
				flags |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
			} else {
				flags &= ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
			}
			decor.setSystemUiVisibility(flags);
		});
	}

	@RequiresApi(api = Build.VERSION_CODES.O)
	public void setNavigationbarStyle(String color, boolean darkIcons) {
		activity.runOnUiThread(() -> {
			Window window = activity.getWindow();
			int colorCode;
			if (color.startsWith("#")) {
				try {
					colorCode = android.graphics.Color.parseColor(color);
				} catch (IllegalArgumentException e) {
					colorCode = ContextCompat.getColor(context, R.color.white);
				}
			} else {
				switch (color) {
					case "navigationbarLightColor": colorCode = ContextCompat.getColor(context, R.color.navigationbarLightColor); break;
					case "navigationbarLightOverlayColor": colorCode = ContextCompat.getColor(context, R.color.navigationbarLightOverlayColor); break;
					case "navigationbarDarkColor": colorCode = ContextCompat.getColor(context, R.color.navigationbarDarkColor); break;
					case "navigationbarDarkOverlayColor": colorCode = ContextCompat.getColor(context, R.color.navigationbarDarkOverlayColor); break;
					default: colorCode = ContextCompat.getColor(context, R.color.white); break;
				}
			}
			log("i", "Navigationbar set color: " + color);
			window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			window.setNavigationBarColor(colorCode);
			View decor = window.getDecorView();
			int flags = decor.getSystemUiVisibility();
			if (darkIcons) {
				flags |= View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
			} else {
				flags &= ~View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
			}
			decor.setSystemUiVisibility(flags);
		});
	}

	@SuppressLint("MissingPermission")
	public void setAppBadge(int number) {
		final int n = Math.max(0, number);
		final String channelId = "wui_badge";
		final int notificationId = 1;
		final NotificationManagerCompat manager = NotificationManagerCompat.from(context);
		final String manufacturer = Build.MANUFACTURER == null ? "" : Build.MANUFACTURER.toLowerCase();
		final boolean oemNativeBadge = manufacturer.matches(".*(samsung|xiaomi|huawei|honor|oppo|vivo|sony|htc|lg|asus).*");
		if (n == 0) {
			try { ShortcutBadger.removeCount(context); } catch (Exception ignore) {}
			manager.cancel(notificationId);
			return;
		}
		if (oemNativeBadge) {
			try {
				if (ShortcutBadger.applyCount(context, n)) {
					manager.cancel(notificationId);
					return;
				}
			} catch (Exception e) {
				log("w", "ShortcutBadger failed, falling back to notification: " + e.getMessage());
			}
		}
		requestPermission("notifications", granted -> {
			if (!granted) {
				log("w", "setAppBadge skipped: notifications permission denied");
				return;
			}
			try {
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
					NotificationChannel channel = new NotificationChannel(channelId, "Badge", NotificationManager.IMPORTANCE_LOW);
					channel.setShowBadge(true);
					channel.setSound(null, null);
					channel.enableVibration(false);
					NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
					if (nm != null) nm.createNotificationChannel(channel);
				}
				Notification notification = new NotificationCompat.Builder(context, channelId)
					.setSmallIcon(context.getApplicationInfo().icon)
					.setContentTitle(context.getApplicationInfo().loadLabel(context.getPackageManager()).toString())
					.setContentText(n + (n == 1 ? " notification" : " notifications"))
					.setNumber(n)
					.setPriority(NotificationCompat.PRIORITY_LOW)
					.setSilent(true)
					.setOngoing(false)
					.setAutoCancel(true)
					.build();
				manager.notify(notificationId, notification);
			} catch (Exception e) {
				log("e", "setAppBadge failed: " + e.getMessage());
			}
		});
	}

	public boolean saveFile(String name, String content) {
		try (FileOutputStream fileOutput = activity.openFileOutput(name, Context.MODE_PRIVATE)) {
			fileOutput.write(content.getBytes(java.nio.charset.StandardCharsets.UTF_8));
			fileOutput.flush();
			log("i", "File saved: " + name);
			return true;
		} catch (IOException e) {
			log("e", "Failed to save file: " + name + " - " + e.getMessage());
			return false;
		}
	}

	@RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
	public String readFile(String name) {
		try (FileInputStream fileInput = activity.openFileInput(name)) {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buffer = new byte[1024];
			int len;
			while ((len = fileInput.read(buffer)) != -1) {
				baos.write(buffer, 0, len);
			}
			String result = baos.toString(StandardCharsets.UTF_8);
			log("i", "File read: " + name);
			return result;
		} catch (IOException e) {
			log("e", "Failed to read file: " + name + " - " + e.getMessage());
			return null;
		}
	}

	public boolean removeFile(String name) {
		try {
			boolean result = activity.deleteFile(name);
			log("i", "File removed: " + name);
			return result;
		} catch (Exception e) {
			log("e", "Failed to remove file: " + name + " - " + e.getMessage());
			return false;
		}
	}

	public void openAppSettings() {
		Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
		intent.setData(Uri.parse("package:" + activity.getPackageName()));
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		activity.startActivity(intent);
	}

	public void openURL(final String url) {
		log("i", "openURL requested: " + url);
		if (url.startsWith("file:///android_asset/")) {
			String assetPath = url.replace("file:///android_asset/", "");
			try {
				context.getAssets().open(assetPath).close();
				log("i", "Asset confirmed exists: " + assetPath);
			} catch (IOException e) {
				log("e", "Asset NOT found via AssetManager: " + assetPath);
			}
		}
		activity.runOnUiThread(() -> {
			if (url.startsWith("file://")) {
				webView.loadUrl(url);
			} else {
				try {
					Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
					intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					activity.startActivity(intent);
				} catch (Exception e) {
					throw new RuntimeException(e);
				}
			}
		});
	}

	public void saveDeepLink(Intent intent) throws JSONException {
		if (intent != null && intent.getData() != null) {
			deepLinkURL = intent.getData().toString();
			sendDeepLink();
		}
	}

	public void sendDeepLink() {
		if (pageLoaded) {
			try {
				JSONObject arguments = new JSONObject();
				arguments.put("event", "onReceiveDeepLink");
				arguments.put("url", deepLinkURL);
				pushJavascript(arguments);
			} catch (JSONException e) {
				throw new RuntimeException(e);
			}
		}
	}

	public String readDeepLink() {
		return deepLinkURL;
	}

	public void clearDeepLink() {
		deepLinkURL = null;
	}

	public void log(String message) {
		log(message, false);
	}

	public void log(String message, boolean force) {
		log("i", "[js] " + message, force);
	}

	// Internal helpers

	private boolean requestPermissionSync(String type) {
		final boolean[] result = new boolean[]{ false };
		final CountDownLatch latch = new CountDownLatch(1);
		requestPermission(type, granted -> {
			result[0] = granted;
			latch.countDown();
		});
		try {
			if (!latch.await(60, TimeUnit.SECONDS)) {
				log("w", "requestPermissionSync timed out for type: " + type);
			}
		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
		}
		return result[0];
	}

	private void log(String level, String message) {
		log(level, message, false);
	}

	private void log(String level, String message, boolean force) {
		if (!developMode && !force) return;
		switch (level) {
			case "d": Log.d(className, message); break;
			case "i": Log.i(className, message); break;
			case "w": Log.w(className, message); break;
			case "e": Log.e(className, message); break;
		}
	}

	private void pushJavascript(JSONObject arguments) {
		if (webView != null) {
			activity.runOnUiThread(() -> {
				String js = "WUIEnvironment.response(" + arguments.toString() + ")";
				webView.evaluateJavascript(js, null);
			});
		}
	}

	class WebViewJavascriptInterface {
		@RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
		@JavascriptInterface
		public String request(String argumentsString) throws JSONException {
			JSONObject arguments = new JSONObject(argumentsString);
			String func = arguments.get("func").toString();
			if (func.matches("^(getDeviceInfo|getDisplayInfo|getAppInfo|getPermissionsStatus|getCurrentPosition|readFile|readDeepLink)$")) {
				return
					func.equals("getDeviceInfo") ? getDeviceInfo().toString() :
					func.equals("getDisplayInfo") ? getDisplayInfo().toString() :
					func.equals("getAppInfo") ? getAppInfo().toString() :
					func.equals("getPermissionsStatus") ? getPermissionsStatus().toString() :
					func.equals("getCurrentPosition") ? getCurrentPosition().toString() :
					func.equals("readFile") ? readFile(arguments.get("name").toString()) :
					func.equals("readDeepLink") ? readDeepLink() :
					"";
			} else if (func.matches("^(isAppInForeground|getConnectionStatus|saveFile|removeFile|requestPermission)$")) {
				return
					func.equals("isAppInForeground") && isAppInForeground() ? "true" :
					func.equals("getConnectionStatus") && getConnectionStatus() ? "true" :
					func.equals("saveFile") && saveFile(arguments.get("name").toString(), arguments.get("content").toString()) ? "true" :
					func.equals("removeFile") && removeFile(arguments.get("name").toString()) ? "true" :
					func.equals("requestPermission") && requestPermissionSync(arguments.get("type").toString()) ? "true" :
					"false";
			} else if (func.matches("^(setStatusbarStyle|setNavigationbarStyle|setAppBadge|openAppSettings|openURL|clearDeepLink|log)$")) {
				switch (func) {
					case "setStatusbarStyle": setStatusbarStyle(arguments.get("color").toString(), (Boolean) arguments.get("darkIcons")); break;
					case "setNavigationbarStyle": setNavigationbarStyle(arguments.get("color").toString(), (Boolean) arguments.get("darkIcons")); break;
					case "setAppBadge": setAppBadge(arguments.getInt("number")); break;
					case "openAppSettings": openAppSettings(); break;
					case "openURL": openURL(arguments.get("url").toString()); break;
					case "clearDeepLink": clearDeepLink(); break;
					case "log": log(arguments.get("message").toString(), arguments.optBoolean("force", false)); break;
				}
				return "null";
			}
			return "";
		}
	}
}