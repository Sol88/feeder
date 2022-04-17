import UIKit

final class SettingsViewController: UIViewController {
	// MARK: - Public
	var output: ISettingsViewOutput?

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()
		output?.didLoad()
		view.backgroundColor = .secondarySystemBackground
	}
}

// MARK: - IFeedDetailsViewInput
extension SettingsViewController: ISettingsViewInput {

}
