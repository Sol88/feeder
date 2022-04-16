import Foundation
import UIKit

final class FeedListInteractor {
	// MARK: - Private
	private let repository: IPostsRepository
	private let imageLoader: IImageLoader

	// MARK: - Public
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)?

	// MARK: - 
	init(repository: IPostsRepository, imageLoader: IImageLoader) {
		self.repository = repository
		self.imageLoader = imageLoader

		self.repository.didChangeContentWithSnapshot = { snapshot in
			self.didChangeContentWithSnapshot?(snapshot)
		}
	}
}

// MARK: - IFeedListInteractor
extension FeedListInteractor: IFeedListInteractor {
	func fetchPost(at indexPath: IndexPath) -> Post? {
		self.repository.fetchPost(at: indexPath)
	}

	func fetchAllPosts() {
		self.repository.fetchAllPosts()
	}
}
