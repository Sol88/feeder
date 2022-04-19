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
		var timerUpdateAmount: String
		var sourcesEnabled: [PostSource: Bool]
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

			view.setNeedsDisplay()
		}
	}
	var output: ISettingsViewOutput?

	// MARK: - Private
	private let cellIdentifier = "SettingsIdentifier"
	private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Item>

	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .insetGrouped)

		tableView.delegate = self

		return tableView
	}()
	private var dataSource: TableViewDataSource?
	private lazy var timeUpdateTextField: UITextField = {
		let textField = UITextField()

		textField.inputView = timeUpdatePickerView
		textField.isHidden = true

		return textField
	}()
	private lazy var timeUpdatePickerView: UIPickerView = {
		let pickerView = UIPickerView()

		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.backgroundColor = .tertiarySystemBackground

		return pickerView
	}()
	private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerDidTap))
		tapGestureRecognizer.numberOfTapsRequired = 1
		return tapGestureRecognizer
	}()

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()

		output?.didLoad()
	}
}

// MARK: - IFeedDetailsViewInput
extension SettingsViewController: ISettingsViewInput {
	func setupViews() {
		view.addSubview(timeUpdateTextField) { make in
			make.leading.top.equalToSuperview()
			make.size.equalTo(0)
		}
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

	func showTimeUpdatePicker() {
		DispatchQueue.main.async {
			self.view.addGestureRecognizer(self.tapGestureRecognizer)
			self.timeUpdateTextField.becomeFirstResponder()
		}
	}

	func hideTimeUpdatePicker() {
		DispatchQueue.main.async {
			self.view.removeGestureRecognizer(self.tapGestureRecognizer)
			self.timeUpdateTextField.resignFirstResponder()
		}
	}

	func configureTimeUpdatePicker(defaultRow row: Int) {
		DispatchQueue.main.async {
			self.timeUpdatePickerView.selectRow(row, inComponent: 0, animated: false)
		}
	}

	func updateTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		output?.didSelectRow(atIndexPath: indexPath)
	}
}

// MARK: - UIPickerViewDataSource
extension SettingsViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		output?.numberOfElementsInTimeUpdatePicker() ?? 0
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		output?.timerUpdatePickerTitle(atRow: row)
	}
}

// MARK: - UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		output?.timerUpdatePickerDidSelect(row: row)
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

	@objc func tapGestureRecognizerDidTap() {
		output?.didTapGestureRecognizer()
	}
}
