final class FeedDetailsPresenter {
	// MARK: - Public
	var router: IFeedDetailsRouter?
	var interactor: IFeedDetailsInteractor?
	weak var view: IFeedDetailsViewInput?
}

// MARK: - IFeedDetailsViewOutput
extension FeedDetailsPresenter: IFeedDetailsViewOutput {
	func didLoad() {
		
	}
}
