import UIKit

final class SettingsCoordinator: Coordinator {
	private(set) var parentCoordinator: Coordinator?
	private(set) var rootViewController: UIViewController?

	private let settingsFactory: ISettingsFactory
	private let sourceFormatter: ISourceFormatter
	private let sourcesRepository: IPostSourcesRepository

	init(parentCoordinator: Coordinator?, sourceFormatter: ISourceFormatter, sourcesRepository: IPostSourcesRepository) {
		self.parentCoordinator = parentCoordinator
		self.sourceFormatter = sourceFormatter
		self.sourcesRepository = sourcesRepository
		self.settingsFactory = SettingsFactory()
	}

	func start() -> UIViewController {
		let settingsViewController = settingsFactory.make(
			sourceFormatter: sourceFormatter,
			sourcesRepository: sourcesRepository
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
