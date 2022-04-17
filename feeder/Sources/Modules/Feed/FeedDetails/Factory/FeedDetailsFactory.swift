import UIKit

final class FeedDetailsFactory {
	
}

// MARK: - IFeedDetailsFactory
extension FeedDetailsFactory: IFeedDetailsFactory {
	func make(withPostId postId: Post.ID, postsRepository: IPostsRepository) -> UIViewController {
		let viewController = FeedDetailsViewController()
		let interactor = FeedDetailsInteractor(postsRepository: postsRepository)
		let presenter = FeedDetailsPresenter(postId: postId)
		let router = FeedDetailsRouter()

		viewController.output = presenter

		presenter.interactor = interactor
		presenter.router = router
		presenter.view = viewController

		return viewController
	}
}
