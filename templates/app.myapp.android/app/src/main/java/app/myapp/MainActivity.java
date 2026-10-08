package app.myapp;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import org.json.JSONException;

public class MainActivity extends AppCompatActivity {

	private WUIEnvironment wuiEnvironment;
	private final boolean developMode = false; // true: enables bridge logging, Chrome DevTools inspection and accepts untrusted SSL certificates (development only)

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		try {
			wuiEnvironment = new WUIEnvironment(this, developMode);

			// Load the demo page

			String path = "libraries/wui-js/environment/demo/index.html";
			wuiEnvironment.openUrl("file:///android_asset/" + path);

			// Enable Deep Link requests when the app opens

			wuiEnvironment.saveDeepLink(getIntent());
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	protected void onNewIntent(@NonNull Intent intent) {
		super.onNewIntent(intent);

		// Enable Deep Link requests while the app is running

		try {
			wuiEnvironment.saveDeepLink(intent);
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);

		// Required by requestPermission() - forwards the OS callback to the bridge

		if (wuiEnvironment != null) {
			wuiEnvironment.handlePermissionResult(requestCode, permissions, grantResults);
		}
	}
}
