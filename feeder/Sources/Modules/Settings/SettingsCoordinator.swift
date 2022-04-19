import UIKit

final class SettingsCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let settingsFactory: ISettingsFactory
	private let sourceFormatter: ISourceFormatter
	private let sourcesRepository: IPostSourcesRepository
	private let updateTimeRepository: IUpdateTimeRepository

	init(
		parentCoordinator: Coordinator?,
		sourceFormatter: ISourceFormatter,
		sourcesRepository: IPostSourcesRepository,
		updateTimeRepository: IUpdateTimeRepository
	) {
		self.parentCoordinator = parentCoordinator
		self.sourceFormatter = sourceFormatter
		self.sourcesRepository = sourcesRepository
		self.updateTimeRepository = updateTimeRepository
		self.settingsFactory = SettingsFactory()
	}

	func start() -> UIViewController {
		let settingsViewController = settingsFactory.make(
			sourceFormatter: sourceFormatter,
			sourcesRepository: sourcesRepository,
			updateTimeRepository: updateTimeRepository
		)
		settingsViewController.tabBarItem = UITabBarItem(
			title: "Settings",
			image: UIImage(systemName: "gearshape"),
			selectedImage: UIImage(systemName: "gearshape.fill")
		)

		rootViewController = settingsViewController

		return settingsViewController
	}
}
