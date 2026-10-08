# Keep the JavaScript bridge methods exposed to the WebView.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
