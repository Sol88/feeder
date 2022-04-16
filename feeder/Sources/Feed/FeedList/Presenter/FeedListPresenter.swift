import Foundation
import UIKit

final class FeedListPresenter {
	// MARK: - Private
	private var props: FeedListViewController.Props? {
		didSet {
			guard let props = props else { return }

			DispatchQueue.main.async {
				self.input?.propsChanged(props)
			}
		}
	}
	private var summaryOpenedPosts: Set<FeedCollectionViewCell.Props.ID> = Set()
	private let cellPropsFactory: FeedCollectionViewCellPropsFactory

	// MARK: - Public
	weak var input: IFeedListViewIntput?
	var interactor: IFeedListInteractor? {
		didSet {
			self.interactor?.didChangeContentWithSnapshot = { snapshot in
				let convertedSnapshot = self.convertSnapshotToFeedSnapshot(snapshot)
				self.props = .snapshot(convertedSnapshot)
			}
		}
	}
	var router: IFeedListRouter?

	// MARK: -
	init(cellPropsFactory: FeedCollectionViewCellPropsFactory) {
		self.cellPropsFactory = cellPropsFactory
	}
}

// MARK: - IFeedListViewOutput
extension FeedListPresenter: IFeedListViewOutput {
	func didLoad() {
		self.props = .loading
		self.interactor?.fetchAllPosts()
	}

	func didTouchRetryButton() {
		self.props = .loading
		self.interactor?.fetchAllPosts()
	}

	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID) {
		if summaryOpenedPosts.contains(id) {
			summaryOpenedPosts.remove(id)
		} else {
			summaryOpenedPosts.insert(id)
		}

		if case .snapshot(var currentSnapshot) = self.props {
			currentSnapshot.reconfigureItems([id])
			self.props = .snapshot(currentSnapshot)
		}
	}

	func didPrefetchItems(at indexPaths: [IndexPath]) {
		self.interactor?.fetchImages(at: indexPaths)
	}

	func didRegisterCell(at indexPath: IndexPath) {
		
	}

	func post(for indexPath: IndexPath) -> FeedCollectionViewCell.Props? {
		guard let post = self.interactor?.fetchPost(at: indexPath) else { return nil }
		var props = self.cellPropsFactory.make(from: post)
		props.shouldShowSummary = self.summaryOpenedPosts.contains(props.id)
		return props
	}
}

// MARK: - Convert snapshot
private extension FeedListPresenter {
	func convertSnapshotToFeedSnapshot(_ snapshot: NSDiffableDataSourceSnapshot<String, Post.ID>) -> FeedDiffableSnapshot {
		var convertedSnapshot = FeedDiffableSnapshot()

		convertedSnapshot.appendSections([.main])
		for section in snapshot.sectionIdentifiers {
			let items: [FeedCollectionViewCell.Props.ID] = snapshot.itemIdentifiers(inSection: section).compactMap { $0 }
			convertedSnapshot.appendItems(items, toSection: .main)
		}

		return convertedSnapshot
	}
}
