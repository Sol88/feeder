final class FeedListRouter {
	weak var moduleOutput: IFeedListModuleOutput?
}

// MARK: - IFeedListRouter
extension FeedListRouter: IFeedListRouter {
	func didSelectPost(withPostID postId: Post.ID) {
		moduleOutput?.didSelectPost(withPostID: postId)
	}
}
