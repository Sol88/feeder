final class FeedListInteractor {
	private let repository: IPostsRepository

	init(repository: IPostsRepository) {
		self.repository = repository
	}
}

// MARK: - IFeedListInteractor
extension FeedListInteractor: IFeedListInteractor {
	func fetchPosts(_ completion: @escaping ([Post]) -> Void) {
		self.repository.getAll { posts in
			completion(posts)
		}
	}
}
