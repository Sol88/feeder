import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let postsRepository: IPostsRepository
	private let dateFormatter: IDateFormatter
	private let imageLoader: IImageLoader
	private let sourceFormatter: ISourceFormatter = SourceFormatter()

	private let feedListFactory: IFeedListFactory

	init(parentCoordinator: Coordinator?, postsRepository: IPostsRepository, imageLoader: IImageLoader) {
		self.parentCoordinator = parentCoordinator
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		self.dateFormatter = formatter
		self.postsRepository = postsRepository
		self.imageLoader = imageLoader
		self.feedListFactory = FeedListFactory()
	}

	func start() -> UIViewController {
		let feedViewController = feedListFactory.make(
			postsRepository: postsRepository,
			dateFormatter: dateFormatter,
			sourceFormatter: sourceFormatter,
			imageLoader: imageLoader
		)
		let navigationController = UINavigationController(rootViewController: feedViewController)
		navigationController.hidesBarsWhenVerticallyCompact = true
		navigationController.view.backgroundColor = .tertiarySystemBackground
		navigationController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().backgroundColor = .tertiarySystemBackground

		rootViewController = navigationController

		return navigationController
	}
}
