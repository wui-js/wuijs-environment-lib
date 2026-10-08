import SwiftUI
import UIKit

struct MainView: View {
	var body: some View {
		EnvironmentView().ignoresSafeArea()
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
	private let developMode: Bool = false // true: enables bridge logging, Web Inspector and accepts untrusted SSL certificates (development only)

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return wuiEnvironment?.preferredStatusBarStyle ?? .default
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		wuiEnvironment = WUIEnvironment(viewController: self, developMode: developMode)

		// Load the demo page

		let path = "assets/libraries/wui-js/environment/demo/index.html"
		wuiEnvironment?.openUrl(url: Bundle.main.bundleURL.appendingPathComponent(path).absoluteString)

		// Add deep link listener

		NotificationCenter.default.addObserver(self, selector: #selector(handleDeepLink(_:)), name: .wuiDeepLink, object: nil)
	}

	deinit {

		// Remove deep link listener

		NotificationCenter.default.removeObserver(self, name: .wuiDeepLink, object: nil)
	}

	// Forward deep link

	@objc private func handleDeepLink(_ notification: Notification) {
		wuiEnvironment?.saveDeepLink(url: notification.object as? URL)
	}
}
