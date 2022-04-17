import UIKit

protocol IFeedDetailsFactory: AnyObject {
	func make(withPostId postId: Post.ID, postsRepository: IPostsRepository) -> UIViewController
}
