protocol IFeedDetailsInteractor: AnyObject {
	func fetchPost(withPostId postId: Post.ID) -> Post?
	func markReadPost(withPostId postId: Post.ID)
}
