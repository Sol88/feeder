import XCTest
@testable import feeder

final class FeedListPresenterTests: XCTestCase {

	private var presenter: IFeedListViewOutput!
	private var interactor: FeedListInteractorMock!

    override func setUpWithError() throws {
		let presenter = FeedListPresenter(
			cellPropsFactory: FeedCollectionViewCellPropsFactory(
				dateFormatter: DateFormatters.longAgoNamedDateFormatter,
				sourceFormatter: SourceFormatter()
			)
		)

		interactor = FeedListInteractorMock()
		presenter.interactor = interactor

		self.presenter = presenter
    }

    func test_willAppearCallFetchAllPosts() throws {
		let exp = expectation(description: "Waiting for call of fetchAllPosts")
		interactor.didCallFetchAllPosts = {
			exp.fulfill()
		}
		presenter.willAppear()
		wait(for: [exp], timeout: 1)
    }

	func test_postForIndexPathWillCallFetchPostAtIndexPath() throws {
		let exp = expectation(description: "Waiting for call of postAtIndexPath")
		interactor.didCallFetchPostAtIndexPath = { indexPath in
			XCTAssertEqual(indexPath.item, 12)
			XCTAssertEqual(indexPath.section, 11)
			exp.fulfill()
		}
		let post = presenter.post(for: IndexPath(item: 12, section: 11))
		wait(for: [exp], timeout: 1)

		XCTAssertEqual(post?.id, "1")
	}

	func test_willDisplayCellWillCallFetchImageAtIndexPath() throws {
		let exp = expectation(description: "Waiting for call of fetchImageAtIndexPath")
		interactor.didCallFetchImageAtIndexPath = { indexPath in
			XCTAssertEqual(indexPath.item, 1)
			XCTAssertEqual(indexPath.section, 1)
			exp.fulfill()
		}

		presenter.willDisplayCell(at: IndexPath(item: 1, section: 1))
		wait(for: [exp], timeout: 1)
	}

	func test_didPrefetchItemsWillCallFetchImageAtIndexPath() throws {
		let exp = expectation(description: "Waiting for call of fetchImageAtIndexPath")
		interactor.didCallFetchImageAtIndexPath = { indexPath in
			XCTAssertEqual(indexPath.item, 2)
			XCTAssertEqual(indexPath.section, 2)
			exp.fulfill()
		}

		presenter.didPrefetchItems(at: [IndexPath(item: 2, section: 2)])
		wait(for: [exp], timeout: 1)
	}

	func test_didPrefetchItemsWillCallCancelFetchingImageAtIndexPath() throws {
		let exp = expectation(description: "Waiting for call of cancelFetchingImageAtIndexPath")
		interactor.didCallCancelFetchingImageAtIndexPath = { indexPath in
			XCTAssertEqual(indexPath.item, 2)
			XCTAssertEqual(indexPath.section, 2)
			exp.fulfill()
		}

		presenter.didEndDisplayingCell(at: IndexPath(item: 2, section: 2))
		wait(for: [exp], timeout: 1)
	}
}
