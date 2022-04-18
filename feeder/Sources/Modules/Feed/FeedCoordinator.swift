import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let postsRepository: IPostsRepository
	private let dateFormatter: IDateFormatter
	private let imageLoader: IImageLoader
	private let sourceFormatter: ISourceFormatter

	private let feedListFactory: IFeedListFactory
	private let feedDetailsFactory: IFeedDetailsFactory

	init(
		parentCoordinator: Coordinator?,
		postsRepository: IPostsRepository,
		imageLoader: IImageLoader,
		sourceFormatter: ISourceFormatter
	) {
		self.parentCoordinator = parentCoordinator
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		self.dateFormatter = formatter
		self.postsRepository = postsRepository
		self.imageLoader = imageLoader
		self.feedListFactory = FeedListFactory()
		self.feedDetailsFactory = FeedDetailsFactory()
		self.sourceFormatter = sourceFormatter
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

		let barAppearance = UINavigationBarAppearance()
		barAppearance.backgroundColor = .tertiarySystemBackground
		navigationController.navigationBar.scrollEdgeAppearance = barAppearance

		navigationController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		rootViewController = navigationController

		return navigationController
	}

	private func showDetails(withPostID postId: Post.ID) {
		let viewController = feedDetailsFactory.make(withPostId: postId, postsRepository: postsRepository)
		(rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
	}
}

// MARK: - IFeedListModuleOutput
extension FeedCoordinator: IFeedListModuleOutput {
	func didSelectPost(withPostID postId: Post.ID) {
		showDetails(withPostID: postId)
	}
}
