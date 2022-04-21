import UIKit
@testable import feeder

final class FeedListInteractorMock: IFeedListInteractor {
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)?

	var didCallFetchPostAtIndexPath: ((IndexPath) -> Void)?
	var didCallFetchAllPosts: (() -> Void)?
	var didCallFetchImageAtIndexPath: ((IndexPath) -> Void)?
	var didCallCancelFetchingImageAtIndexPath: ((IndexPath) -> Void)?

	func fetchPost(at indexPath: IndexPath) -> Post? {
		didCallFetchPostAtIndexPath?(indexPath)

		return Post(
			id: "1",
			imageURL: nil,
			title: "Test title",
			content: URL(string: "http://lenta.ru")!,
			summary: "Test summary",
			date: Date(timeIntervalSince1970: 0),
			source: .lenta,
			isRead: false
		)
	}

	func fetchAllPosts() {
		didCallFetchAllPosts?()
	}

	func fetchImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
		didCallFetchImageAtIndexPath?(indexPath)
	}

	func cancelFetchingImage(at indexPath: IndexPath) {
		didCallCancelFetchingImageAtIndexPath?(indexPath)
	}
}
