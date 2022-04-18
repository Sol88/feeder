import Foundation

protocol IFeedListViewOutput: AnyObject {
	func didLoad()
	func willAppear()
	func didTouchRetryButton()
	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID)
	func didPrefetchItems(at indexPaths: [IndexPath])
	func didReceiveMemoryWarning()
	func didSelectItem(at indexPath: IndexPath)
	func willDisplayCell(at indexPath: IndexPath)
	func didEndDisplayingCell(at indexPath: IndexPath)

	func post(for indexPath: IndexPath) -> FeedCollectionViewCell.Props?
}
