import UIKit

final class FeedDetailsFactory {
	
}

// MARK: - IFeedDetailsFactory
extension FeedDetailsFactory: IFeedDetailsFactory {
	func make() -> UIViewController {
		let viewController = FeedDetailsViewController()
		let interactor = FeedDetailsInteractor()
		let presenter = FeedDetailsPresenter()
		let router = FeedDetailsRouter()

		viewController.output = presenter

		presenter.interactor = interactor
		presenter.router = router
		presenter.view = viewController

		return viewController
	}
}
