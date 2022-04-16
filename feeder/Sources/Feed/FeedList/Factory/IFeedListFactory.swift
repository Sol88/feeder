import UIKit

protocol IFeedListFactory: AnyObject {
	func make(
		postsRepository: IPostsRepository,
		dateFormatter: IDateFormatter,
		sourceFormatter: ISourceFormatter,
		imageLoader: IImageLoader
	) -> UIViewController
}
