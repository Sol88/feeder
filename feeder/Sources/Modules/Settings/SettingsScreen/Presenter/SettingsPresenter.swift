final class SettingsPresenter {
	// MARK: - Public
	var router: ISettingsRouter?
	var interactor: ISettingsInteractor?
	weak var view: ISettingsViewInput?
}

// MARK: - IFeedDetailsViewOutput
extension SettingsPresenter: ISettingsViewOutput {
	func didLoad() {
		
	}
}
