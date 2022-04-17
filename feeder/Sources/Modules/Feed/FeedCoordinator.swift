import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let postsRepository: IPostsRepository
	private let dateFormatter: IDateFormatter
	private let imageLoader: IImageLoader
	private let sourceFormatter: ISourceFormatter = SourceFormatter()

	private let feedListFactory: IFeedListFactory
	private let feedDetailsFactory: IFeedDetailsFactory

	init(parentCoordinator: Coordinator?, postsRepository: IPostsRepository, imageLoader: IImageLoader) {
		self.parentCoordinator = parentCoordinator
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		self.dateFormatter = formatter
		self.postsRepository = postsRepository
		self.imageLoader = imageLoader
		self.feedListFactory = FeedListFactory()
		self.feedDetailsFactory = FeedDetailsFactory()
	}

	func start() -> UIViewController {
		let feedViewController = feedListFactory.make(
			postsRepository: postsRepository,
			dateFormatter: dateFormatter,
			sourceFormatter: sourceFormatter,
			imageLoader: imageLoader,
			moduleOutput: self
		)
		let navigationController = UINavigationController(rootViewController: feedViewController)
		navigationController.hidesBarsWhenVerticallyCompact = true
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.backgroundColor = .tertiarySystemBackground
		navigationController.view.backgroundColor = .tertiarySystemBackground
		navigationController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		rootViewController = navigationController

		return navigationController
	}

	private func showDetails(withPostID postId: Post.ID) {
		let viewController = feedDetailsFactory.make()
		(rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
	}
}

// MARK: - IFeedListModuleOutput
extension FeedCoordinator: IFeedListModuleOutput {
	func didSelectPost(withPostID postId: Post.ID) {
		showDetails(withPostID: postId)
	}
}
