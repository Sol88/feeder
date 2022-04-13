import Foundation

final class PostsUpdater {
	private let postsLoaders: [IPostsLoader]

	init(feedURLs: [(url: URL, parser: IPostXMLParser)]) {
		let urlSession: URLSession = .shared
		self.postsLoaders = feedURLs.map { PostsLoader(session: urlSession, xmlParser: $0.parser, url: $0.url) }
	}

	func update() {
		for loader in self.postsLoaders {
			Task {
				let posts = try? await loader.fetchPosts()
				print(posts ?? [])
			}
		}
	}
}
