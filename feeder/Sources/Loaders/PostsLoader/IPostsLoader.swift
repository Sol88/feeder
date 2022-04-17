protocol IPostsLoader {
	var source: PostSource { get }
	func fetchPosts() async throws -> [XMLPost]
}
