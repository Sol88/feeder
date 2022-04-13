protocol IPostsLoader {
	func fetchPosts() async throws -> [XMLPost]
}
