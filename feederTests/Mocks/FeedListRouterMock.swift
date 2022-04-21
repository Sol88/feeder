@testable import feeder

final class FeedListRouterMock: IFeedListRouter {
	var didCallSelectPostWithId: ((Post.ID) -> Void)?

	func didSelectPost(withPostID postId: Post.ID) {
		didCallSelectPostWithId?(postId)
	}
}
