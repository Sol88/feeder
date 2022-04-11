import Foundation

final class FeedListPresenter {
	private var props: FeedListViewController.Props? {
		didSet {
			guard let props = props else { return }

			DispatchQueue.main.async {
				self.input?.propsChanged(props)
			}
		}
	}
	private let cellPropsFactory: FeedCollectionViewCellPropsFactory

	weak var input: IFeedListViewIntput?
	var interactor: IFeedListInteractor?
	var router: IFeedListRouter?

	var items: [FeedCollectionViewCell.Props] = []

	init(cellPropsFactory: FeedCollectionViewCellPropsFactory) {
		self.cellPropsFactory = cellPropsFactory
	}
}

// MARK: - IFeedListViewOutput
extension FeedListPresenter: IFeedListViewOutput {
	func didLoad() {
		self.props = .loading
		self.interactor?.fetchPosts { [weak self] posts in
			guard let self = self else { return }
			self.items = self.cellPropsFactory.make(from: posts)
			self.props = .data(self.items.map(\.id))
		}
	}

	func didTouchRetryButton() {
		self.props = .loading
	}

	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID) {
		guard let index = self.items.firstIndex(where: { $0.id == id }) else { return }

		var item = self.items.remove(at: index)

		item.shouldShowSummary.toggle()

		self.items.insert(item, at: index)
		self.props = .update([item.id])
	}

	func post(for id: FeedCollectionViewCell.Props.ID) -> FeedCollectionViewCell.Props? {
		self.items.first(where: { $0.id == id })
	}
}
