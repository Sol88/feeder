import UIKit

final class SettingsFactory {}

// MARK: - ISettingsFactory
extension SettingsFactory: ISettingsFactory {
	func make(
		sourceFormatter: ISourceFormatter,
		sourcesRepository: IPostSourcesRepository,
		updateTimeRepository: IUpdateTimeRepository
	) -> UIViewController {
		let viewController = SettingsViewController()
		let interactor = SettingsInteractor(sourcesRepository: sourcesRepository, updateTimeRepository: updateTimeRepository)
		let presenter = SettingsPresenter(sourceFormatter: sourceFormatter)
		let router = SettingsRouter()

		viewController.output = presenter

		presenter.interactor = interactor
		presenter.router = router
		presenter.view = viewController

		return viewController
	}
}
