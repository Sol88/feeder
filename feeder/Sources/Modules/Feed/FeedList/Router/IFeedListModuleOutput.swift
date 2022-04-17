protocol IFeedListModuleOutput: AnyObject {
	func didSelectPost(withPostID postId: Post.ID)
}
