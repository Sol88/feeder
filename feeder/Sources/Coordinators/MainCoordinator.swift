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
		sourcesRepository: postSourcesRepository,
		updateTimeRepository: updateTimeRepository
	)

	private let sourceFormatter: ISourceFormatter = SourceFormatter()
	private let coreDataContainer = CoreDataContainer()
	private let updater: PostsUpdater
	private let postsRepository: IPostsRepository
	private let postSourcesRepository: IPostSourcesRepository
	private let imageLoader: IImageLoader = ImageLoader()
	private let updateTimeRepository: IUpdateTimeRepository = UserDefaultsUpdateTimeRepository()

	init(parentCoordinator: Coordinator?) {
		self.parentCoordinator = parentCoordinator
		postsRepository = PostsCoreDataRepository(coreDataContainer: coreDataContainer)
		postSourcesRepository = PostSourceUserDefaultsRepository()
		updater = PostsUpdater(
			postsRepository: postsRepository,
			sourcesRepository: postSourcesRepository,
			updateTimeRepository: updateTimeRepository
		)

		NotificationCenter.default.addObserver(
			forName: UIApplication.willResignActiveNotification,
			object: nil,
			queue: nil) { [weak self] _ in
				self?.updater.stop()
			}

		NotificationCenter.default.addObserver(
			forName: UIApplication.didBecomeActiveNotification,
			object: nil,
			queue: nil) { [weak self] _ in
				self?.updater.start()
			}
	}

	func start() -> UIViewController {
		let tabBarController = UITabBarController()

		let feedViewController = feedCoordinator.start()
		let settingsViewController = settingsCoordinator.start()

		tabBarController.viewControllers = [feedViewController, settingsViewController]

		UITabBar.appearance().backgroundColor = .tertiarySystemBackground

		rootViewController = tabBarController

		updater.start()

		return tabBarController
	}
}
