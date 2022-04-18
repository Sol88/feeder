import Foundation
import UIKit.UIDiffableDataSource

protocol IPostsRepository: AnyObject {
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)? { get set }

	func add(_ elements: [XMLPost], forSource source: PostSource)
	func fetchPost(at indexPath: IndexPath) -> Post?
	func fetchPost(withPostId postId: Post.ID) -> Post?
	func fetchAllPosts(forSources sources: [PostSource])
	func markReadPost(withPostId postId: Post.ID)
}
