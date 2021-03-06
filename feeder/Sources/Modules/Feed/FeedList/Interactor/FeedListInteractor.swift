import Foundation
import UIKit

final class FeedListInteractor {
	// MARK: - Public
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)?
	
	// MARK: - Private
	private let repository: IPostsRepository
	private let imageLoader: IImageLoader
	private let sourcesRepository: IPostSourcesRepository

	// MARK: - 
	init(repository: IPostsRepository, imageLoader: IImageLoader, sourcesRepository: IPostSourcesRepository) {
		self.repository = repository
		self.imageLoader = imageLoader
		self.sourcesRepository = sourcesRepository

		repository.didChangeContentWithSnapshot = { [weak self] snapshot in
			self?.didChangeContentWithSnapshot?(snapshot)
		}
	}
}

// MARK: - IFeedListInteractor
extension FeedListInteractor: IFeedListInteractor {
	func fetchPost(at indexPath: IndexPath) -> Post? {
		repository.fetchPost(at: indexPath)
	}

	func fetchAllPosts() {
		let enabledSources = sourcesRepository.fetchAllSources().filter(sourcesRepository.fetchSourceIsEnabled(_:))
		repository.fetchAllPosts(forSources: enabledSources)
	}

	func fetchImages(at indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			fetchImage(at: indexPath) { _ in }
		}
	}

	func fetchImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
		guard let post = repository.fetchPost(at: indexPath), let imageURL = post.imageURL else { return }
		imageLoader.fetchImage(forURL: imageURL, completion: completion)
	}

	func cancelFetchingImage(at indexPath: IndexPath) {
		guard let post = repository.fetchPost(at: indexPath), let imageURL = post.imageURL else { return }
		imageLoader.cancelFetching(forURL: imageURL)
	}
}
