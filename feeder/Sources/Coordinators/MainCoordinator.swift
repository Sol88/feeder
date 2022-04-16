import UIKit

final class MainCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private lazy var feedCoordinator: Coordinator = FeedCoordinator(
		parentCoordinator: self,
		postsRepository: self.postsRepository,
		imageLoader: self.imageLoader
	)
	private lazy var settingsCoordinator: Coordinator = SettingsCoordinator(parentCoordinator: self)

	private let coreDataContainer = CoreDataContainer()
	private let updater: PostsUpdater
	private let postsRepository: IPostsRepository
	private let imageLoader: IImageLoader = ImageLoader()

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
		self.postsRepository = PostsCoreDataRepository(coreDataContainer: coreDataContainer)
		self.updater = PostsUpdater(
			feedURLs: [
				(URL(string: "http://lenta.ru/rss")!, PostXMLParser()),
				(URL(string: "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml")!, PostXMLParser())
			],
			repository: postsRepository
		)
	}

	func start() -> UIViewController {
		let tabBarController = UITabBarController()

		let feedViewController = self.feedCoordinator.start()
		let settingsViewController = self.settingsCoordinator.start()

		tabBarController.viewControllers = [feedViewController, settingsViewController]

		UITabBar.appearance().backgroundColor = .tertiarySystemBackground

		self.rootViewController = tabBarController

		self.updater.update()

		return tabBarController
	}
}
