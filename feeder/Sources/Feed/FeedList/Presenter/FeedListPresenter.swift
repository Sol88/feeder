import Foundation
import UIKit

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
		self.updateItem(forId: id) { item in
			item.shouldShowSummary.toggle()
		}
	}

	func didPrefetchItems(at indexPaths: [IndexPath]) {
		let itemsToPrefetchImages = indexPaths.map { self.items[$0.item] }
		for item in itemsToPrefetchImages where item.image == nil {
			self.interactor?.fetchImage(forPostId: item.id) { _ in }
		}
	}

	func didRegisterCell(at indexPath: IndexPath) {
		let item = self.items[indexPath.item]
		guard item.image == nil else { return }
		self.interactor?.fetchImage(forPostId: item.id) { [weak self, item] image in
			guard let image = image else { return }
			self?.updateImage(forPostId: item.id, image: image)
		}
	}

	func post(for id: FeedCollectionViewCell.Props.ID) -> FeedCollectionViewCell.Props? {
		self.items.first(where: { $0.id == id })
	}
}

// MARK: - Update image
private extension FeedListPresenter {
	func updateImage(forPostId postId: String, image: UIImage) {
		image.prepareForDisplay { [weak self] image in
			self?.updateItem(forId: postId) { item in
				item.image = image
			}
		}
	}

	func updateItem(forId id: String, update: @escaping (inout FeedCollectionViewCell.Props) -> Void) {
		DispatchQueue.main.async {
			guard let index = self.items.firstIndex(where: { $0.id == id }) else { return }

			var item = self.items.remove(at: index)
			update(&item)
			self.items.insert(item, at: index)
			self.props = .update([item.id])
		}
	}
}
