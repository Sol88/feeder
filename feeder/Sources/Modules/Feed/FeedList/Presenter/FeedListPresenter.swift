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

	private let decompressedImageCache = Cache<Post.ID, UIImage>()
	private var snapshotReconfigureThresholdTimer: Timer?
	private var postIDsToReconfigure: Set<Post.ID> = Set()

	// MARK: - Public
	weak var input: IFeedListViewIntput?
	var interactor: IFeedListInteractor? {
		didSet {
			interactor?.didChangeContentWithSnapshot = { [weak self] snapshot in
				guard let self = self else { return }
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
		props = .loading
		interactor?.fetchAllPosts()
	}

	func didTouchRetryButton() {
		props = .loading
		interactor?.fetchAllPosts()
	}

	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID) {
		if summaryOpenedPosts.contains(id) {
			summaryOpenedPosts.remove(id)
		} else {
			summaryOpenedPosts.insert(id)
		}

		if case .snapshot(var currentSnapshot) = props {
			currentSnapshot.reconfigureItems([id])
			props = .snapshot(currentSnapshot)
		}
	}

	func didPrefetchItems(at indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			interactor?.fetchImage(at: indexPath) { _ in }
		}
	}

	func willDisplayCell(at indexPath: IndexPath) {
		guard
			let id = interactor?.fetchPost(at: indexPath)?.id,
			decompressedImageCache.value(forKey: id) == nil
		else { return }

		interactor?.fetchImage(at: indexPath) { [weak self, id] image in
			guard let image = image else { return }
			self?.prepareAndDisplayImage(image, forPostId: id)
		}
	}

	func didEndDisplayingCell(at indexPath: IndexPath) {
		interactor?.cancelFetchingImage(at: indexPath)
	}

	func didSelectItem(at indexPath: IndexPath) {
		guard let post = interactor?.fetchPost(at: indexPath) else { return }
		router?.didSelectPost(withPostID: post.id)
	}

	func post(for indexPath: IndexPath) -> FeedCollectionViewCell.Props? {
		guard let post = interactor?.fetchPost(at: indexPath) else { return nil }
		var props = cellPropsFactory.make(from: post)
		props.shouldShowSummary = summaryOpenedPosts.contains(props.id)
		props.image = decompressedImageCache.value(forKey: post.id)
		return props
	}

	func didReceiveMemoryWarning() {
		decompressedImageCache.removeAll()
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

	func reconfigureCurrentSnapshotIfNeeded() {
		guard case .snapshot(var currentSnapshot) = props else { return }
		DispatchQueue.main.async {
			guard !self.postIDsToReconfigure.isEmpty else { return }
			currentSnapshot.reconfigureItems(Array(self.postIDsToReconfigure))
			self.props = .snapshot(currentSnapshot)
			self.postIDsToReconfigure.removeAll()
		}
	}

	func reconfigureCurrentSnapshotIfNeeded(withThreshold timeThreshold: TimeInterval) {
		snapshotReconfigureThresholdTimer?.invalidate()
		snapshotReconfigureThresholdTimer = Timer(timeInterval: timeThreshold, repeats: false) { [weak self] _ in
			self?.reconfigureCurrentSnapshotIfNeeded()
		}
		RunLoop.main.add(snapshotReconfigureThresholdTimer!, forMode: .common)
	}
}

// MARK: - Prepare UIImage for displaying
private extension FeedListPresenter {
	func prepareAndDisplayImage(_ image: UIImage, forPostId id: Post.ID) {
		image.prepareForDisplay { [weak self] image in
			guard let image = image, let self = self else { return }
			self.decompressedImageCache.insert(image, forKey: id)
			DispatchQueue.main.async {
				self.postIDsToReconfigure.insert(id)
			}

			self.reconfigureCurrentSnapshotIfNeeded(withThreshold: 0.05)
		}
	}
}
