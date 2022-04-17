import Dispatch

final class FeedDetailsPresenter {
	// MARK: - Public
	var router: IFeedDetailsRouter?
	var interactor: IFeedDetailsInteractor?
	weak var view: IFeedDetailsViewInput?

	// MARK: - Private
	private let postId: Post.ID
	private var props: FeedDetailsViewController.Props? {
		didSet {
			DispatchQueue.main.async {
				guard let props = self.props else { return }
				self.view?.propsUpdated(props)
			}
		}
	}

	init(postId: Post.ID) {
		self.postId = postId
	}
}

// MARK: - IFeedDetailsViewOutput
extension FeedDetailsPresenter: IFeedDetailsViewOutput {
	func didLoad() {
		guard let post = interactor?.fetchPost(withPostId: postId) else {
			props = .error("Something went wrong")
			return
		}

		props = .url(post.content)
		interactor?.markReadPost(withPostId: postId)
	}
}
