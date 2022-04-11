import UIKit
import SnapKit

final class FeedListViewController: UIViewController {
	typealias FeedDiffableSnapshot = NSDiffableDataSourceSnapshot<Section, FeedCollectionViewCell.Props.ID>
	typealias FeedCellRegistration = UICollectionView.CellRegistration<FeedCollectionViewCell, FeedCollectionViewCell.Props.ID>
	typealias FeedDiffableDataSource = UICollectionViewDiffableDataSource<Section, FeedCollectionViewCell.Props.ID>

	enum Section {
		case main
	}

	enum Props: Equatable {
		case data([FeedCollectionViewCell.Props.ID])
		case update([FeedCollectionViewCell.Props.ID])
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
}

// MARK: - FeedListView
extension FeedListViewController: IFeedListViewIntput {
	func propsChanged(_ props: Props) {
		switch props {
			case .data(let items):
				self.handleAddDataState(with: items)
			case .update(let items):
				self.handleUpdateDataState(with: items)
			case .error(let errorText):
				self.handleErrorState(with: errorText)
			case .loading:
				self.handleLoadingState()
		}
		self.view.setNeedsLayout()
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
	func handleAddDataState(with feeds: [FeedCollectionViewCell.Props.ID]) {
		self.setupCollectionViewIfNeeded()

		self.activityIndicator.stopAnimating()
		self.retryButton.isHidden = true
		self.errorLabel.isHidden = true

		self.collectionView.isHidden = false

		var snapshot = FeedDiffableSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(feeds, toSection: .main)
		self.dataSource?.apply(snapshot, animatingDifferences: true)
	}

	func handleUpdateDataState(with feeds: [FeedCollectionViewCell.Props.ID]) {
		guard var snapshot = self.dataSource?.snapshot() else { return }

		snapshot.reconfigureItems(feeds)
		self.dataSource?.apply(snapshot, animatingDifferences: false)
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
			cell.props = output?.post(for: itemIdentifier)
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
