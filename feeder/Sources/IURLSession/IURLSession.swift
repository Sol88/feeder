import Foundation

protocol IURLSession: AnyObject {
	func dataTask(with url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> Cancellable & Resumable
}

extension URLSession: IURLSession {
	func dataTask(with url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> Cancellable & Resumable {
		dataTask(with: url) { data, _, error in
			completionHandler(data, error)
		}
	}
}
