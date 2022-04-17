import UIKit

final class SettingsCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let settingsFactory: ISettingsFactory

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
		self.settingsFactory = SettingsFactory()
	}

	func start() -> UIViewController {
		let settingsViewController = settingsFactory.make()
		settingsViewController.tabBarItem = UITabBarItem(
			title: "Settings",
			image: UIImage(systemName: "gearshape"),
			selectedImage: UIImage(systemName: "gearshape.fill")
		)

		rootViewController = settingsViewController

		return settingsViewController
	}
}
