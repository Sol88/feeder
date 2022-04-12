final class PostsCoreDataRepository: IPostsRepository {
	func add(_ element: Post) {
		// TODO: implement
	}

	func update(elementWithId id: String, isRead: Bool) {
		// TODO: implement
	}

	func getAll(completion: ([Post]) -> Void) {
		completion(Post.dummy)
	}

	func fetchPost(postId: String, completion: @escaping (Post?) -> Void) {
		completion(Post.dummy.first(where: { $0.id == postId }))
	}
}
