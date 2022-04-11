protocol IFeedListInteractor: AnyObject {
	func fetchPosts(_ completion: @escaping ([Post]) -> Void)
}
