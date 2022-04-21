import Foundation
@testable import feeder

final class TaskMock: Resumable & Cancellable {
	var didCallCancel: (() -> Void)?
	var didCallResume: (() -> Void)?

	func cancel() {
		didCallCancel?()
	}

	func resume() {
		didCallResume?()
	}
}

final class URLSessionMock: IURLSession {
	let mockTask: TaskMock
	var didCallDataTaskWithURL: ((URL) -> Void)?

	init(mockTask: TaskMock) {
		self.mockTask = mockTask
	}

	func dataTask(with url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> Cancellable & Resumable {
		didCallDataTaskWithURL?(url)
		completionHandler(Data(), nil)
		return mockTask
	}
}
