import Foundation

enum PostSource: Hashable {
	case lenta
}

struct Post: Identifiable, Hashable {
	typealias ID = String
	let id: ID
	let imageURL: URL?
	let title: String
	let content: URL
	let summary: String
	let date: Date
	let source: PostSource
	let isRead: Bool
}

// MARK: - Factory methods
extension Post {
	static func make(fromCoreData post: PostCoreData, dateFormatter: DateFormatter) -> Post? {
		guard
			let id = post.id,
			let title = post.title,
			let link = post.link,
			let content = URL(string: link),
			let summary = post.summary,
			let date = post.pubDate
		else { return nil }

		var imageURL: URL?
		if let url = post.imageURL {
			imageURL = URL(string: url)
		}

		return Post(
			id: id,
			imageURL: imageURL,
			title: title,
			content: content,
			summary: summary,
			date: date,
			source: .lenta,
			isRead: false
		)
	}
}
