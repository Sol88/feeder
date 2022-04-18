import Foundation

final class PostsUpdater {
	private let postsLoaders: [IPostsLoader]
	private let postsRepository: IPostsRepository

	init(postsRepository: IPostsRepository, sourcesRepository: IPostSourcesRepository) {
		let urlSession: URLSession = .shared
		self.postsLoaders = sourcesRepository.fetchAllSources().map { PostsLoader(session: urlSession, source: $0) }
		self.postsRepository = postsRepository
	}

	func update() {
		for loader in postsLoaders {
			Task {
				guard let posts = try? await loader.fetchPosts() else { return }
				postsRepository.add(posts, forSource: loader.source)
			}
		}
	}
}
