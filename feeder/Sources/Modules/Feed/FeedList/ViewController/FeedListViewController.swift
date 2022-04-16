import UIKit
import SnapKit

typealias FeedCellRegistration = UICollectionView.CellRegistration<FeedCollectionViewCell, FeedCollectionViewCell.Props.ID>
typealias FeedDiffableDataSource = UICollectionViewDiffableDataSource<FeedSection, FeedCollectionViewCell.Props.ID>
typealias FeedDiffableSnapshot = NSDiffableDataSourceSnapshot<FeedSection, FeedCollectionViewCell.Props.ID>

enum FeedSection {
	case main
}

final class FeedListViewController: UIViewController {
	enum Props {
		case snapshot(FeedDiffableSnapshot)
		case error(String)
		case loading
	}

	// MARK: - UI
	private lazy var errorLabel: UILabel = {
		let label = UILabel()

		label.textColor = .systemGray3

		return label
	}()

	private lazy var activityIndicator: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()

		view.hidesWhenStopped = true

		return view
	}()

	private lazy var retryButton: UIButton = {
		let button = UIButton()

		button.setTitle("Retry", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.addTarget(self, action: #selector(self.retryButtonDidTouchUpInside), for: .touchUpInside)

		return button
	}()

	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .feedLayout)

		collectionView.backgroundColor = .secondarySystemBackground
		collectionView.prefetchDataSource = self
		collectionView.delegate = self

		return collectionView
	}()

	// MARK: - Private
	private var dataSource: FeedDiffableDataSource?

	// MARK: - Public
	var output: IFeedListViewOutput?

	// MARK: - View cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		self.output?.didLoad()

		self.view.backgroundColor = .secondarySystemBackground
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

		self.output?.didReceiveMemoryWarning()
	}
}

// MARK: - FeedListView
extension FeedListViewController: IFeedListViewIntput {
	func propsChanged(_ props: Props) {
		switch props {
			case .error(let errorText):
				self.handleErrorState(with: errorText)
			case .loading:
				self.handleLoadingState()
			case .snapshot(let snapshot):
				self.handleSnapshotState(with: snapshot)
		}
		self.view.setNeedsLayout()
	}
}

// MARK: - UICollectionViewDelegate
extension FeedListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.output?.didSelectItem(at: indexPath)
	}
}

// MAKR: - UICollectionViewDataSourcePrefetching
extension FeedListViewController: UICollectionViewDataSourcePrefetching {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		self.output?.didPrefetchItems(at: indexPaths)
	}
}

// MARK: - Setup views
private extension FeedListViewController {
	func setupActivityIndicatorIfNeeded() {
		guard self.activityIndicator.superview == nil else { return }

		self.view.addSubview(self.activityIndicator) { make in
			make.center.equalToSuperview()
		}
	}

	func setupErrorLabelIfNeeded() {
		guard self.errorLabel.superview == nil else { return }

		self.view.addSubview(self.errorLabel) { make in
			make.center.equalToSuperview()
			make.leading.greaterThanOrEqualToSuperview().inset(24)
		}
	}

	func setupRetryButtonIfNeeded() {
		guard self.retryButton.superview == nil else { return }

		self.view.addSubview(self.retryButton) { make in
			make.top.equalTo(self.errorLabel.snp.bottom).inset(8)
			make.centerX.equalTo(self.errorLabel.snp.centerX)
		}
	}

	func setupCollectionViewIfNeeded() {
		guard self.collectionView.superview == nil else { return }

		self.view.addSubview(self.collectionView) { make in
			make.edges.equalToSuperview()
		}

		self.configureDataSource()
	}
}

// MARK: - Handle states
private extension FeedListViewController {
	func handleSnapshotState(with snapshot: FeedDiffableSnapshot) {
		self.setupCollectionViewIfNeeded()

		self.activityIndicator.stopAnimating()
		self.retryButton.isHidden = true
		self.errorLabel.isHidden = true

		self.collectionView.isHidden = false
		self.dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
	}

	func handleErrorState(with errorText: String) {
		self.setupErrorLabelIfNeeded()
		self.setupRetryButtonIfNeeded()

		self.activityIndicator.stopAnimating()
		self.collectionView.isHidden = true

		self.errorLabel.text = errorText
		self.errorLabel.isHidden = false
		self.retryButton.isHidden = false
	}

	func handleLoadingState() {
		self.setupActivityIndicatorIfNeeded()
		self.errorLabel.isHidden = true
		self.retryButton.isHidden = true
		self.collectionView.isHidden = true
		self.activityIndicator.startAnimating()
	}
}

// MARK: - Actions
private extension FeedListViewController {
	@objc func retryButtonDidTouchUpInside() {
		self.output?.didTouchRetryButton()
	}
}

// MARK: - UICollectionView configuration
private extension FeedListViewController {
	func configureDataSource() {
		let cellRegistration = FeedCellRegistration { [weak output] cell, index, itemIdentifier in
			output?.didRegisterCell(at: index)
			cell.props = output?.post(for: index)
			cell.infoViewDidTouched = { [weak output] id in
				output?.didTouchPostInfoView(with: id)
			}
		}
		self.dataSource = FeedDiffableDataSource(
			collectionView: self.collectionView,
			cellProvider: { collectionView, indexPath, itemIdentifier in
				collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
			}
		)
	}
}
