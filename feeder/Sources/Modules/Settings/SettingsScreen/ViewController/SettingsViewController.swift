import UIKit

typealias SettingsDiffableSnapshot = NSDiffableDataSourceSnapshot<SettingsViewController.Section, SettingsViewController.Item>

final class SettingsViewController: UIViewController {
	// MARK: - Public
	public enum Section: CaseIterable {
		case timer
		case sources
	}

	public enum ItemType: Hashable {
		case source(PostSource)
		case timer
	}

	public struct Item: Hashable {
		let type: ItemType
	}

	struct Props {
		let snapshot: SettingsDiffableSnapshot
		let timerTitle: String
		let timerUpdateAmount: String
		let sourcesEnabled: [PostSource: Bool]
		let sourcesTitles: [PostSource: String]
	}

	var props: Props? {
		didSet {
			guard let props = props else {
				return
			}

			DispatchQueue.main.async {
				self.dataSource?.apply(props.snapshot, animatingDifferences: false)
			}
		}
	}
	var output: ISettingsViewOutput?

	// MARK: - Private
	private let cellIdentifier = "SettingsIdentifier"
	private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Item>

	private lazy var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
	private var dataSource: TableViewDataSource?

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()

		output?.didLoad()
	}
}

// MARK: - IFeedDetailsViewInput
extension SettingsViewController: ISettingsViewInput {
	func setupViews() {
		view.backgroundColor = .secondarySystemBackground
		view.addSubview(tableView) { make in
			make.edges.equalToSuperview()
		}
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
	}

	func configureDataSource() {
		dataSource = TableViewDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
			guard let self = self else { return nil }
			let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
			var content = cell.defaultContentConfiguration()

			switch item.type {
				case .timer:
					content.text = self.props?.timerTitle
					content.secondaryText = self.props?.timerUpdateAmount
					cell.accessoryView = nil
				case .source(let source):
					content.text = self.props?.sourcesTitles[source]
					let switcher = UISwitch()
					switcher.isOn = self.props?.sourcesEnabled[source] ?? true
					switcher.addTarget(self, action: #selector(self.valueChangedSwitch(_:)), for: .valueChanged)
					cell.accessoryView = switcher
					cell.selectionStyle = .none
			}

			cell.contentConfiguration = content
			return cell
		}
	}
}

// MARK: - Actions
private extension SettingsViewController {
	@objc func valueChangedSwitch(_ switcher: UISwitch) {
		guard
			let cell = switcher.superview as? UITableViewCell,
			let indexPath = tableView.indexPath(for: cell)
		else { return }

		output?.switchDidChangeValue(switcher.isOn, atIndexPath: indexPath)
	}
}
