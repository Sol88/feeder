import UIKit

final class MainCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private lazy var feedCoordinator: Coordinator = FeedCoordinator(parentCoordinator: self)
	private lazy var settingsCoordinator: Coordinator = SettingsCoordinator(parentCoordinator: self)

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
	}

	func start() -> UIViewController {
		let tabBarController = UITabBarController()

		let feedViewController = self.feedCoordinator.start()
		let settingsViewController = self.settingsCoordinator.start()

		tabBarController.viewControllers = [feedViewController, settingsViewController]

		UITabBar.appearance().backgroundColor = .tertiarySystemBackground

		self.rootViewController = tabBarController

		return tabBarController
	}
}
