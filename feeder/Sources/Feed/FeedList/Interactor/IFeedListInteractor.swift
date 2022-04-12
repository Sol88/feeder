import UIKit
protocol IFeedListInteractor: AnyObject {
	func fetchPosts(_ completion: @escaping ([Post]) -> Void)
	func fetchImage(forPostId postId: String, completion: @escaping (UIImage?) -> Void)
}
