import XCTest
@testable import feeder

final class FeedListPresenterTests: XCTestCase {

	private var presenter: IFeedListViewOutput!
	private var interactor: FeedListInteractorMock!
	private var router: FeedListRouterMock!

    override func setUpWithError() throws {
		let presenter = FeedListPresenter(
			cellPropsFactory: FeedCollectionViewCellPropsFactory(
				dateFormatter: DateFormatters.longAgoNamedDateFormatter,
				sourceFormatter: SourceFormatter()
			)
		)

		interactor = FeedListInteractorMock()
		presenter.interactor = interactor

		router = FeedListRouterMock()
		presenter.router = router

		self.presenter = presenter
    }

	// MARK: - Interactor
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

	// MARK: - Router
	func test_didSelectItemWillCallSelectPostWithId() {
		let exp = expectation(description: "Waiting for call of selectPostWithId")
		router.didCallSelectPostWithId = { id in
			XCTAssertEqual(id, "123")
			exp.fulfill()
		}
		interactor.returnFetchPost = Post(
			id: "123",
			imageURL: nil,
			title: "",
			content: URL(string: "http://lenta.ru")!,
			summary: "",
			date: Date(timeIntervalSince1970: 0),
			source: .lenta,
			isRead: false
		)
		presenter.didSelectItem(at: IndexPath(item: 0, section: 0))
		wait(for: [exp], timeout: 1)
	}

	func test_didSelectItemWillNotCallSelectPostWithIdIfNoPostAtIndex() {
		let exp = expectation(description: "Waiting for call of selectPostWithId")
		exp.isInverted = true
		router.didCallSelectPostWithId = { id in
			exp.fulfill()
		}
		interactor.returnFetchPost = nil
		presenter.didSelectItem(at: IndexPath(item: 0, section: 0))
		wait(for: [exp], timeout: 1)
	}
}
