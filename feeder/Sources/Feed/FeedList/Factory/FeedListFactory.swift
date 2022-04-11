import UIKit

final class FeedListFactory: IFeedListFactory {
	func make() -> UIViewController {
		let viewController = FeedListViewController()
		let presenter = FeedListPresenter()
		let interactor = FeedListInteractor()
		let router = FeedListRouter()

		viewController.output = presenter

		presenter.input = viewController
		presenter.interactor = interactor
		presenter.router = router

		return viewController
	}
}
