protocol IFeedListRouter: AnyObject {
	func didSelectPost(withPostID postId: Post.ID)
}
