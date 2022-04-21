import Foundation

final class FeedCollectionViewCellPropsFactory {
	private let dateFormatter: IDateFormatter
	private let sourceFormatter: ISourceFormatter

	init(dateFormatter: IDateFormatter, sourceFormatter: ISourceFormatter) {
		self.dateFormatter = dateFormatter
		self.sourceFormatter = sourceFormatter
	}

	func make(from posts: [Post]) -> [FeedCollectionViewCell.Props] {
		posts.map { make(from: $0) }
	}

	func make(from post: Post) -> FeedCollectionViewCell.Props {
		let summary: String
		if post.summary.isEmpty {
			summary = "No summary"
		} else {
			summary = post.summary
		}
		return FeedCollectionViewCell.Props(
			id: post.id,
			title: post.title,
			content: post.content,
			summary: summary,
			date: dateFormatter.string(from: post.date),
			source: sourceFormatter.string(from: post.source),
			isRead: post.isRead,
			image: nil
		)
	}
}
