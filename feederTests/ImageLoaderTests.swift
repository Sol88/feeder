import XCTest
@testable import feeder

final class ImageLoaderTests: XCTestCase {

	private var task: TaskMock!
	private var urlSession: URLSessionMock!
	private var imageLoader: IImageLoader!

    override func setUpWithError() throws {
        task = TaskMock()
		urlSession = URLSessionMock(mockTask: task)
		imageLoader = ImageLoader(urlSession: urlSession)
    }

    func test_fetchImageCallsTaskResume() throws {
		let expTask = expectation(description: "Waiting for calling resume")
		let expURLSession = expectation(description: "Waiting for calling dataTask")
		task.didCallResume = {
			expTask.fulfill()
		}
		urlSession.didCallDataTaskWithURL = { url in
			XCTAssertEqual(url.absoluteString, "http://lenta.ru")
			expURLSession.fulfill()
		}
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		wait(for: [expTask, expURLSession], timeout: 1)
    }

	func test_cancelFetchingCallsTaskCancelIfTaskIsResuming() throws {
		let expTask = expectation(description: "Waiting for calling cancel")
		task.didCallCancel = {
			expTask.fulfill()
		}
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		imageLoader.cancelFetching(forURL: URL(string: "http://lenta.ru")!)
		wait(for: [expTask], timeout: 1)
	}

	func test_cancelFetchingNotCallsTaskCancelIfTaskIsNotResuming() throws {
		let expTask = expectation(description: "Waiting for calling cancel")
		expTask.isInverted = true
		task.didCallCancel = {
			expTask.fulfill()
		}
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		imageLoader.cancelFetching(forURL: URL(string: "http://nyt.ru")!)
		wait(for: [expTask], timeout: 1)
	}

	func test_cancelFetchingNotCallsTaskCancelIfNoTaskIsResuming() throws {
		let expTask = expectation(description: "Waiting for calling cancel")
		expTask.isInverted = true
		task.didCallCancel = {
			expTask.fulfill()
		}
		imageLoader.cancelFetching(forURL: URL(string: "http://nyt.ru")!)
		wait(for: [expTask], timeout: 1)
	}

	func test_fetchingImageCallsDataTaskOnlyOnce() throws {
		let expURLSession = expectation(description: "Waiting for calling dataTask")
		expURLSession.expectedFulfillmentCount = 2
		expURLSession.isInverted = true
		urlSession.didCallDataTaskWithURL = { url in
			XCTAssertEqual(url.absoluteString, "http://lenta.ru")
			expURLSession.fulfill()
		}
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		wait(for: [expURLSession], timeout: 1)
	}

	func test_fetchingImageCallsDataTaskTwiceAfterResturningCompletion() throws {
		let expURLSession = expectation(description: "Waiting for calling dataTask")
		expURLSession.expectedFulfillmentCount = 2
		urlSession.didCallDataTaskWithURL = { url in
			XCTAssertEqual(url.absoluteString, "http://lenta.ru")
			expURLSession.fulfill()
		}
		imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { [weak self] _ in
			self?.imageLoader.fetchImage(forURL: URL(string: "http://lenta.ru")!, completion: { _ in })
		})

		wait(for: [expURLSession], timeout: 1)
	}
}
