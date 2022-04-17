import Foundation

final class PostsLoader {
	private let session: URLSession

	let source: PostSource

	init(session: URLSession, source: PostSource) {
		self.session = session
		self.source = source
	}
}

// MARK: - PostsLoader
extension PostsLoader: IPostsLoader {
	func fetchPosts() async throws -> [XMLPost] {
		let (data, _) = try await session.data(from: source.url)
		return source.xmlParser.parse(data: data)
	}
}
