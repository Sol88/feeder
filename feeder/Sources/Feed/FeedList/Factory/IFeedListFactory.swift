import UIKit

protocol IFeedListFactory: AnyObject {
	func make(
		postsRepository: IPostsRepository,
		dateFormatter: IDateFormatter,
		sourceFormatter: ISourceFormatter
	) -> UIViewController
}
