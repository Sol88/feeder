protocol IFeedDetailsInteractor: AnyObject {
	func fetchPost(withPostId postId: Post.ID) -> Post?
}
