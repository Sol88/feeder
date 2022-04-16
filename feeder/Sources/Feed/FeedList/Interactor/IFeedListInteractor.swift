import UIKit
protocol IFeedListInteractor: AnyObject {
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)? { get set }
	
	func fetchPost(at indexPath: IndexPath) -> Post?
	func fetchAllPosts()
	func fetchImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void)
}
