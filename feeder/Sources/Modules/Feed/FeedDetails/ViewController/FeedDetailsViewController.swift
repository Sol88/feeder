import UIKit

final class FeedDetailsViewController: UIViewController {
	// MARK: - Public
	var output: IFeedDetailsViewOutput?

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()
		output?.didLoad()
	}
}

// MARK: - IFeedDetailsViewInput
extension FeedDetailsViewController: IFeedDetailsViewInput {

}
