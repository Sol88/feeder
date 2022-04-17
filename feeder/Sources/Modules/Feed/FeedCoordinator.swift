import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let postsRepository: IPostsRepository
	private let dateFormatter: IDateFormatter
	private let imageLoader: IImageLoader
	private let sourceFormatter: ISourceFormatter = SourceFormatter()

	init(parentCoordinator: Coordinator?, postsRepository: IPostsRepository, imageLoader: IImageLoader) {
		self.parentCoordinator = parentCoordinator
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		self.dateFormatter = formatter
		self.postsRepository = postsRepository
		self.imageLoader = imageLoader
	}

	func start() -> UIViewController {
		let feedViewController = FeedListFactory().make(
			postsRepository: postsRepository,
			dateFormatter: dateFormatter,
			sourceFormatter: sourceFormatter,
			imageLoader: imageLoader
		)
		feedViewController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		rootViewController = feedViewController

		return feedViewController
	}
}
