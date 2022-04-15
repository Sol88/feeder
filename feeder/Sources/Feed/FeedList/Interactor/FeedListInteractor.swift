import Foundation
import UIKit

final class FeedListInteractor {
	private let repository: IPostsRepository
	private let imageLoader: IImageLoader

	init(repository: IPostsRepository, imageLoader: IImageLoader) {
		self.repository = repository
		self.imageLoader = imageLoader
	}
}

// MARK: - IFeedListInteractor
extension FeedListInteractor: IFeedListInteractor {
	func fetchPosts(_ completion: @escaping ([Post]) -> Void) {
		self.repository.fetchAll { posts in
			completion(posts)
		}
	}

	func fetchImage(forPostId postId: String, completion: @escaping (UIImage?) -> Void) {
		self.repository.fetchPost(postId: postId) { [weak self] post in
			guard let imageURL = post?.imageURL else {
				completion(nil)
				return
			}
			self?.imageLoader.getImage(forURL: imageURL, completion: completion)
		}
	}
}
