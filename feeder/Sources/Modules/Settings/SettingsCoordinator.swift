import UIKit

final class SettingsCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
	}

	func start() -> UIViewController {
		let settingsViewController = UIViewController()
		settingsViewController.tabBarItem = UITabBarItem(
			title: "Settings",
			image: UIImage(systemName: "gearshape"),
			selectedImage: UIImage(systemName: "gearshape.fill")
		)

		rootViewController = settingsViewController

		return settingsViewController
	}
}
