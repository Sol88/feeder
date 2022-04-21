import Foundation

protocol Resumable {
	func resume()
}

extension URLSessionDataTask: Resumable {}
