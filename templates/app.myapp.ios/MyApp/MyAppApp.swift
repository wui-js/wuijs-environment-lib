import SwiftUI

extension Notification.Name {
	static let wuiDeepLink = Notification.Name("WUIDeepLink")
}

@main
struct MyAppApp: App {
	var body: some Scene {
		WindowGroup {
			MainView()
				.onOpenURL { url in
					NotificationCenter.default.post(name: .wuiDeepLink, object: url)
				}
		}
	}
}
