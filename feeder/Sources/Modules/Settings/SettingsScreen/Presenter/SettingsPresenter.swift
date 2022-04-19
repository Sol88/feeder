import Foundation

final class SettingsPresenter {
	// MARK: - Public
	var router: ISettingsRouter?
	var interactor: ISettingsInteractor?
	weak var view: ISettingsViewInput?

	// MARK: - Private
	private let sourceFormatter: ISourceFormatter
	private let timeFormatter: ITimeFormatter
	private var props: SettingsViewController.Props? {
		didSet {
			view?.props = props
		}
	}

	// MARK: -
	init(sourceFormatter: ISourceFormatter, timeFormatter: ITimeFormatter = MinutesAndSecondsTimeFormatter()) {
		self.sourceFormatter = sourceFormatter
		self.timeFormatter = timeFormatter
	}
}

// MARK: - IFeedDetailsViewOutput
extension SettingsPresenter: ISettingsViewOutput {
	func switchDidChangeValue(_ value: Bool, atIndexPath indexPath: IndexPath) {
		guard let sources = interactor?.fetchAllSources() else { return }
		let source = sources[indexPath.item]
		interactor?.saveSource(source, isEnabled: value)
	}

	func didLoad() {
		view?.setupViews()
		view?.configureDataSource()

		let currentUpdateTime = interactor?.fetchCurrentUpdateTime() ?? 0
		if
			let timeEntities = interactor?.fetchAllUpdateTimes(),
			let index = timeEntities.firstIndex(of: currentUpdateTime) {
			view?.configureTimeUpdatePicker(defaultRow: index)
		}

		var sourcesEnabled: [PostSource: Bool] = [:]
		var sourcesTitles: [PostSource: String] = [:]

		if let sources = interactor?.fetchAllSources() {
			for source in sources {
				sourcesTitles[source] = sourceFormatter.string(from: source)
				sourcesEnabled[source] = interactor?.fetchIsSourceEnabled(source) ?? true
			}
		}

		props = .init(
			snapshot: makeSnapshot(),
			timerTitle: "Update content every",
			timerUpdateAmount: timeFormatter.format(time: currentUpdateTime),
			sourcesEnabled: sourcesEnabled,
			sourcesTitles: sourcesTitles
		)
	}

	func didSelectRow(atIndexPath indexPath: IndexPath) {
		if indexPath.section == 0 && indexPath.item == 0 {
			// Timer cell
			view?.showTimeUpdatePicker()
		}
	}

	func numberOfElementsInTimeUpdatePicker() -> Int {
		interactor?.fetchAllUpdateTimes().count ?? 0
	}

	func timerUpdatePickerTitle(atRow row: Int) -> String? {
		guard let time = interactor?.fetchUpdateTime(atRow: row) else { return nil }
		return timeFormatter.format(time: time)
	}

	func didTapGestureRecognizer() {
		view?.hideTimeUpdatePicker()
	}

	func timerUpdatePickerDidSelect(row: Int) {
		guard let time = interactor?.fetchUpdateTime(atRow: row) else { return }
		interactor?.updateCurrentUpdateTime(time)

		var props = self.props
		props?.timerUpdateAmount = timeFormatter.format(time: time)
		self.props = props
	}
}

// MARK: - Snapshot
private extension SettingsPresenter {
	func makeSnapshot() -> SettingsDiffableSnapshot {
		var snapshot = SettingsDiffableSnapshot()
		snapshot.appendSections([.timer, .sources])
		snapshot.appendItems([
			SettingsViewController.Item(type: .timer)
		], toSection: .timer)
		snapshot.appendItems([
			SettingsViewController.Item(type: .source(.lenta)),
			SettingsViewController.Item(type: .source(.nyt))
		], toSection: .sources)
		return snapshot
	}
}
