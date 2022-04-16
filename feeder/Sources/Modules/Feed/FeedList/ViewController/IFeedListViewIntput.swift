protocol IFeedListViewIntput: AnyObject {
	var output: IFeedListViewOutput? { get set }

	func propsChanged(_ props: FeedListViewController.Props)
}
