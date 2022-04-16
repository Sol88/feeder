import Foundation
import UIKit.UIDiffableDataSource

protocol IPostsRepository: AnyObject {
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)? { get set }

	func add(_ elements: [XMLPost])
	func fetchPost(at indexPath: IndexPath) -> Post?
	func fetchAllPosts()
}
