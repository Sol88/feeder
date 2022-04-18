import UIKit

final class SettingsFactory {}

// MARK: - ISettingsFactory
extension SettingsFactory: ISettingsFactory {
	func make(sourceFormatter: ISourceFormatter, sourcesRepository: IPostSourcesRepository) -> UIViewController {
		let viewController = SettingsViewController()
		let interactor = SettingsInteractor(sourcesRepository: sourcesRepository)
		let presenter = SettingsPresenter(sourceFormatter: sourceFormatter)
		let router = SettingsRouter()

		viewController.output = presenter

		presenter.interactor = interactor
		presenter.router = router
		presenter.view = viewController

		return viewController
	}
}
