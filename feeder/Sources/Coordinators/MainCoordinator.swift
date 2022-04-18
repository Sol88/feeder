import UIKit

final class MainCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private lazy var feedCoordinator: Coordinator = FeedCoordinator(
		parentCoordinator: self,
		postsRepository: postsRepository,
		imageLoader: imageLoader,
		sourceFormatter: sourceFormatter,
		sourcesRepository: postSourcesRepository
	)
	private lazy var settingsCoordinator: Coordinator = SettingsCoordinator(
		parentCoordinator: self,
		sourceFormatter: sourceFormatter,
		sourcesRepository: postSourcesRepository
	)

	private let sourceFormatter: ISourceFormatter = SourceFormatter()
	private let coreDataContainer = CoreDataContainer()
	private let updater: PostsUpdater
	private let postsRepository: IPostsRepository
	private let postSourcesRepository: IPostSourcesRepository
	private let imageLoader: IImageLoader = ImageLoader()

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
		postsRepository = PostsCoreDataRepository(coreDataContainer: coreDataContainer)
		postSourcesRepository = PostSourceUserDefaultsRepository()
		updater = PostsUpdater(postsRepository: postsRepository, sourcesRepository: postSourcesRepository)
	}

	func start() -> UIViewController {
		let tabBarController = UITabBarController()

		let feedViewController = feedCoordinator.start()
		let settingsViewController = settingsCoordinator.start()

		tabBarController.viewControllers = [feedViewController, settingsViewController]

		UITabBar.appearance().backgroundColor = .tertiarySystemBackground

		rootViewController = tabBarController

		updater.update()

		return tabBarController
	}
}
