protocol IPostsRepository: AnyObject {
	func add(_ element: Post)
	func update(elementWithId id: String, isRead: Bool)
	func getAll(completion: @escaping ([Post]) -> Void)
	func fetchPost(postId: String, completion: @escaping (Post?) -> Void)
}
