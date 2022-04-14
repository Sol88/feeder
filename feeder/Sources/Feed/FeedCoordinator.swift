import UIKit

final class FeedCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let postsRepository: IPostsRepository
	private let dateFormatter: IDateFormatter
	private let sourceFormatter: ISourceFormatter = SourceFormatter()

	init(parentCoordinator: Coordinator?, postsRepository: IPostsRepository) {
		self.parentCoordinator = parentCoordinator
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		self.dateFormatter = formatter
		self.postsRepository = postsRepository
	}

	func start() -> UIViewController {
		let feedViewController = FeedListFactory().make(
			postsRepository: self.postsRepository,
			dateFormatter: self.dateFormatter,
			sourceFormatter: self.sourceFormatter
		)
		feedViewController.tabBarItem = UITabBarItem(
			title: "Feed",
			image: UIImage(systemName: "list.bullet"),
			selectedImage: UIImage(systemName: "list.bullet")
		)

		self.rootViewController = feedViewController

		return feedViewController
	}
}
