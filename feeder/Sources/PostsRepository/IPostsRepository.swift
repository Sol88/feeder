protocol IPostsRepository: AnyObject {
	func add(_ elements: [XMLPost])
	func fetchAll(completion: @escaping ([Post]) -> Void)
	func fetchPost(postId: String, completion: @escaping (Post?) -> Void)
}
