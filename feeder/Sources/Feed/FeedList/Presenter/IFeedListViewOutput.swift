protocol IFeedListViewOutput: AnyObject {
	func didLoad()
	func didTouchRetryButton()
	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID)

	func post(for id: FeedCollectionViewCell.Props.ID) -> FeedCollectionViewCell.Props?
}
