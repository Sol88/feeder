import Foundation

final class PostsUpdater {
	private let postsLoaders: [IPostsLoader]
	private let repository: IPostsRepository

	init(feedSources: [PostSource], repository: IPostsRepository) {
		let urlSession: URLSession = .shared
		self.postsLoaders = feedSources.map { PostsLoader(session: urlSession, source: $0) }
		self.repository = repository
	}

	func update() {
		for loader in postsLoaders {
			Task {
				guard let posts = try? await loader.fetchPosts() else { return }
				repository.add(posts, forSource: loader.source)
			}
		}
	}
}
