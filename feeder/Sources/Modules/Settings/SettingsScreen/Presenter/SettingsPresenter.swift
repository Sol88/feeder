import Foundation

final class SettingsPresenter {
	// MARK: - Public
	var router: ISettingsRouter?
	var interactor: ISettingsInteractor?
	weak var view: ISettingsViewInput?

	// MARK: - Private
	private let sourceFormatter: ISourceFormatter
	private let timeFormatter: ITimeFormatter

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

		var sourcesEnabled: [PostSource: Bool] = [:]
		var sourcesTitles: [PostSource: String] = [:]

		if let sources = interactor?.fetchAllSources() {
			for source in sources {
				sourcesTitles[source] = sourceFormatter.string(from: source)
				sourcesEnabled[source] = interactor?.fetchIsSourceEnabled(source) ?? true
			}
		}

		view?.props = .init(
			snapshot: makeSnapshot(),
			timerTitle: "Update content every",
			timerUpdateAmount: "123",
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
		interactor?.fetchNumberOfUpdateTime() ?? 0
	}

	func timerUpdatePickerTitle(atRow row: Int) -> String? {
		guard let time = interactor?.fetchUpdateTime(atRow: row) else { return nil }
		return timeFormatter.format(time: time)
	}

	func didTapGestureRecognizer() {
		view?.hideTimeUpdatePicker()
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
