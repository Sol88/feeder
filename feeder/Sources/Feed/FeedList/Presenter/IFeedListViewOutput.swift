import Foundation

protocol IFeedListViewOutput: AnyObject {
	func didLoad()
	func didTouchRetryButton()
	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID)
	func didPrefetchItems(at indexPaths: [IndexPath])
	func didRegisterCell(at indexPath: IndexPath)

	func post(for id: FeedCollectionViewCell.Props.ID) -> FeedCollectionViewCell.Props?
}
