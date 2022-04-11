import Foundation

final class FeedCollectionViewCellPropsFactory {
	private let dateFormatter: IDateFormatter
	private let sourceFormatter: ISourceFormatter

	init(dateFormatter: IDateFormatter, sourceFormatter: ISourceFormatter) {
		self.dateFormatter = dateFormatter
		self.sourceFormatter = sourceFormatter
	}

	func make(from posts: [Post]) -> [FeedCollectionViewCell.Props] {
		posts.map {
			FeedCollectionViewCell.Props(
				id: $0.id,
				imageURL: $0.imageURL,
				title: $0.title,
				content: $0.content,
				summary: $0.summary,
				date: self.dateFormatter.string(from: $0.date),
				source: self.sourceFormatter.string(from: $0.source),
				isRead: $0.isRead
			)
		}
	}
}
