final class FeedDetailsInteractor {
	// MARK: - Private
	private let postsRepository: IPostsRepository

	// MARK: -
	init(postsRepository: IPostsRepository) {
		self.postsRepository = postsRepository
	}
}

// MARK: - IFeedDetailsInteractor
extension FeedDetailsInteractor: IFeedDetailsInteractor {
	func fetchPost(withPostId postId: Post.ID) -> Post? {
		postsRepository.fetchPost(withPostId: postId)
	}

	func markReadPost(withPostId postId: Post.ID) {
		postsRepository.markReadPost(withPostId: postId)
	}
}
