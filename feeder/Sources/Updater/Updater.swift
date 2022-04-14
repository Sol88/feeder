import Foundation

final class PostsUpdater {
	private let postsLoaders: [IPostsLoader]
	private let repository: IPostsRepository

	init(feedURLs: [(url: URL, parser: IPostXMLParser)], repository: IPostsRepository) {
		let urlSession: URLSession = .shared
		self.postsLoaders = feedURLs.map { PostsLoader(session: urlSession, xmlParser: $0.parser, url: $0.url) }
		self.repository = repository
	}

	func update() {
		for loader in self.postsLoaders {
			Task {
				guard let posts = try? await loader.fetchPosts() else { return }
				self.repository.add(posts)
			}
		}
	}
}
