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
	private var preparedImages: Dictionary<Post.ID, UIImage> = [:]
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
		for indexPath in indexPaths {
			self.interactor?.fetchImage(at: indexPath) { _ in }
		}
	}

	func didRegisterCell(at indexPath: IndexPath) {
		guard let id = self.interactor?.fetchPost(at: indexPath)?.id else { return }
		guard !self.preparedImages.keys.contains(id) else { return }
		self.interactor?.fetchImage(at: indexPath) { [weak self, id] image in
			image?.prepareForDisplay { image in
				DispatchQueue.main.async {
					self?.preparedImages[id] = image
				}

				if case .snapshot(var currentSnapshot) = self?.props {
					currentSnapshot.reconfigureItems([id])
					self?.props = .snapshot(currentSnapshot)
				}
			}
		}
	}

	func didSelectItem(at indexPath: IndexPath) {
		print(indexPath)
	}

	func post(for indexPath: IndexPath) -> FeedCollectionViewCell.Props? {
		guard let post = self.interactor?.fetchPost(at: indexPath) else { return nil }
		var props = self.cellPropsFactory.make(from: post)
		props.shouldShowSummary = self.summaryOpenedPosts.contains(props.id)
		props.image = self.preparedImages[post.id]
		return props
	}

	func didReceiveMemoryWarning() {
		DispatchQueue.main.async {
			self.preparedImages.removeAll()
		}
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
