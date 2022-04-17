final class FeedDetailsPresenter {
	// MARK: - Public
	var router: IFeedDetailsRouter?
	var interactor: IFeedDetailsInteractor?
	weak var view: IFeedDetailsViewInput?

	// MARK: - Private
	private let postId: Post.ID

	init(postId: Post.ID) {
		self.postId = postId
	}
}

// MARK: - IFeedDetailsViewOutput
extension FeedDetailsPresenter: IFeedDetailsViewOutput {
	func didLoad() {
		guard let post = interactor?.fetchPost(withPostId: postId) else {
			// TODO: show error
			return
		}

		// TODO: show post
	}
}
