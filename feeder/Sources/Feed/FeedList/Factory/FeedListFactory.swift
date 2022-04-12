import UIKit

final class FeedListFactory: IFeedListFactory {
	func make(
		postsRepository: IPostsRepository,
		dateFormatter: IDateFormatter,
		sourceFormatter: ISourceFormatter
	) -> UIViewController {
		let feedCollectionViewCellPropsFactory = FeedCollectionViewCellPropsFactory(
			dateFormatter: dateFormatter,
			sourceFormatter: sourceFormatter
		)
		let viewController = FeedListViewController()
		let presenter = FeedListPresenter(cellPropsFactory: feedCollectionViewCellPropsFactory)
		let interactor = FeedListInteractor(repository: postsRepository, imageLoader: ImageLoader())
		let router = FeedListRouter()

		viewController.output = presenter

		presenter.input = viewController
		presenter.interactor = interactor
		presenter.router = router

		return viewController
	}
}
