protocol IFeedListInteractor: AnyObject {
	func fetchPosts(_ completion: ([Post]) -> Void)
}


import Foundation

enum PostSource {
	case lenta
}

struct Post {
	let id: String
	let imageURL: String
	let title: String
	let content: String
	let summary: String
	let date: Date
	let source: PostSource
}
