import Foundation

final class PostsUpdater {
	private let sourcesRepository: IPostSourcesRepository
	private let postsRepository: IPostsRepository
	private let urlSession: URLSession = .shared

	init(postsRepository: IPostsRepository, sourcesRepository: IPostSourcesRepository) {
		self.postsRepository = postsRepository
		self.sourcesRepository = sourcesRepository
	}

	func update() {
		let postsLoaders = sourcesRepository.fetchAllSources()
			.filter(sourcesRepository.fetchSourceIsEnabled)
			.map { PostsLoader(session: urlSession, source: $0) }
		for loader in postsLoaders {
			Task {
				guard let posts = try? await loader.fetchPosts() else { return }
				postsRepository.add(posts, forSource: loader.source)
			}
		}
	}
}
