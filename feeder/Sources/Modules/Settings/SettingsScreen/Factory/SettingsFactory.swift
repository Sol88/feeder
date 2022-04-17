import UIKit

final class SettingsFactory {
	
}

// MARK: - ISettingsFactory
extension SettingsFactory: ISettingsFactory {
	func make() -> UIViewController {
		let viewController = SettingsViewController()
		let interactor = SettingsInteractor()
		let presenter = SettingsPresenter()
		let router = SettingsRouter()

		viewController.output = presenter

		presenter.interactor = interactor
		presenter.router = router
		presenter.view = viewController

		return viewController
	}
}
