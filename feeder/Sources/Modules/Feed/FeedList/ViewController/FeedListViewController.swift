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
		button.addTarget(self, action: #selector(retryButtonDidTouchUpInside), for: .touchUpInside)

		return button
	}()

	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .feedLayout)

		collectionView.backgroundColor = .secondarySystemBackground
		collectionView.prefetchDataSource = self
		collectionView.delegate = self

		return collectionView
	}()

	// MARK: - Public
	var output: IFeedListViewOutput?

	// MARK: - Private
	private var dataSource: FeedDiffableDataSource?

	// MARK: - View cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		output?.didLoad()

		view.backgroundColor = .secondarySystemBackground
		title = "Feed"
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		output?.willAppear()
		collectionView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

		output?.didReceiveMemoryWarning()
	}
}

// MARK: - FeedListView
extension FeedListViewController: IFeedListViewIntput {
	func propsChanged(_ props: Props) {
		switch props {
			case .error(let errorText):
				handleErrorState(with: errorText)
			case .loading:
				handleLoadingState()
			case .snapshot(let snapshot):
				handleSnapshotState(with: snapshot)
		}
		view.setNeedsLayout()
		view.setNeedsDisplay()
	}
}

// MARK: - UICollectionViewDelegate
extension FeedListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		output?.didSelectItem(at: indexPath)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		didEndDisplaying cell: UICollectionViewCell,
		forItemAt indexPath: IndexPath
	) {
		output?.didEndDisplayingCell(at: indexPath)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		willDisplay cell: UICollectionViewCell,
		forItemAt indexPath: IndexPath
	) {
		output?.willDisplayCell(at: indexPath)
	}
}

// MAKR: - UICollectionViewDataSourcePrefetching
extension FeedListViewController: UICollectionViewDataSourcePrefetching {
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		output?.didPrefetchItems(at: indexPaths)
	}
}

// MARK: - Setup views
private extension FeedListViewController {
	func setupActivityIndicatorIfNeeded() {
		guard activityIndicator.superview == nil else { return }

		view.addSubview(activityIndicator) { make in
			make.center.equalToSuperview()
		}
	}

	func setupErrorLabelIfNeeded() {
		guard errorLabel.superview == nil else { return }

		view.addSubview(errorLabel) { make in
			make.center.equalToSuperview()
			make.leading.greaterThanOrEqualToSuperview().inset(24)
		}
	}

	func setupRetryButtonIfNeeded() {
		guard retryButton.superview == nil else { return }

		view.addSubview(retryButton) { make in
			make.top.equalTo(errorLabel.snp.bottom).inset(8)
			make.centerX.equalTo(errorLabel.snp.centerX)
		}
	}

	func setupCollectionViewIfNeeded() {
		guard collectionView.superview == nil else { return }

		view.addSubview(collectionView) { make in
			make.edges.equalToSuperview()
		}

		configureDataSource()
	}
}

// MARK: - Handle states
private extension FeedListViewController {
	func handleSnapshotState(with snapshot: FeedDiffableSnapshot) {
		setupCollectionViewIfNeeded()

		activityIndicator.stopAnimating()
		retryButton.isHidden = true
		errorLabel.isHidden = true

		collectionView.isHidden = false
		dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
	}

	func handleErrorState(with errorText: String) {
		setupErrorLabelIfNeeded()
		setupRetryButtonIfNeeded()

		activityIndicator.stopAnimating()
		collectionView.isHidden = true

		errorLabel.text = errorText
		errorLabel.isHidden = false
		retryButton.isHidden = false
	}

	func handleLoadingState() {
		setupActivityIndicatorIfNeeded()
		errorLabel.isHidden = true
		retryButton.isHidden = true
		collectionView.isHidden = true
		activityIndicator.startAnimating()
	}
}

// MARK: - Actions
private extension FeedListViewController {
	@objc func retryButtonDidTouchUpInside() {
		output?.didTouchRetryButton()
	}
}

// MARK: - UICollectionView configuration
private extension FeedListViewController {
	func configureDataSource() {
		let cellRegistration = FeedCellRegistration { [weak output] cell, index, itemIdentifier in
			cell.props = output?.post(for: index)
			cell.infoViewDidTouched = { [weak output] id in
				output?.didTouchPostInfoView(with: id)
			}
		}
		dataSource = FeedDiffableDataSource(
			collectionView: collectionView,
			cellProvider: { collectionView, indexPath, itemIdentifier in
				collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
			}
		)
	}
}
