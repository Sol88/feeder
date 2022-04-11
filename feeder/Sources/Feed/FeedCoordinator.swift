import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
	}

	func start() -> UIViewController {
		let feedViewController = FeedListFactory().make()
		feedViewController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		self.rootViewController = feedViewController

		return feedViewController
	}
}
