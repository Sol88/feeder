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

	func fetchImages(at indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			self.fetchImage(at: indexPath) { _ in }
		}
	}

	func fetchImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
		guard let post = self.repository.fetchPost(at: indexPath), let imageURL = post.imageURL else { return }
		self.imageLoader.getImage(forURL: imageURL, completion: completion)
	}
}
