import Foundation

final class PostsLoader {
	private let session: URLSession
	private let xmlParser: IPostXMLParser
	private let url: URL

	init(session: URLSession, xmlParser: IPostXMLParser, url: URL) {
		self.session = session
		self.xmlParser = xmlParser
		self.url = url
	}
}

// MARK: - PostsLoader
extension PostsLoader: IPostsLoader {
	func fetchPosts() async throws -> [XMLPost] {
		let (data, _) = try await self.session.data(from: url)
		return self.xmlParser.parse(data: data)
	}
}
