protocol IPostsRepository: AnyObject {
	func add(_ element: Post)
	func update(elementWithId id: String, isRead: Bool)
	func getAll(completion: ([Post]) -> Void)
}
