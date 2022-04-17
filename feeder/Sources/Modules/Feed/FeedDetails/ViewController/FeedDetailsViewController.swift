import UIKit
import WebKit

final class FeedDetailsViewController: UIViewController {
	// MARK: - Public
	enum Props {
		case error(String)
		case url(URL)
	}
	var output: IFeedDetailsViewOutput?

	// MARK: - Private
	private lazy var webView: WKWebView = WKWebView()
	private lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = .systemGray3
		return label
	}()

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()

		output?.didLoad()

		view.backgroundColor = .secondarySystemBackground
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		webView.stopLoading()
	}
}

// MARK: - IFeedDetailsViewInput
extension FeedDetailsViewController: IFeedDetailsViewInput {
	func propsUpdated(_ props: Props) {
		switch props {
			case .url(let url):
				handleURLState(withURL: url)

			case .error(let text):
				handleErrorState(withText: text)
		}
	}
}

// MARK: - Handle props update
private extension FeedDetailsViewController {
	func handleURLState(withURL url: URL) {
		if webView.superview == nil {
			view.addSubview(webView) { make in
				make.edges.equalToSuperview()
			}
		}

		errorLabel.isHidden = true
		webView.isHidden = false
		let request = URLRequest(url: url)
		webView.load(request)
	}

	func handleErrorState(withText text: String) {
		if errorLabel.superview == nil {
			view.addSubview(errorLabel) { make in
				make.center.equalToSuperview()
				make.leading.equalToSuperview().offset(32)
			}
		}
		errorLabel.isHidden = false
		webView.isHidden = true

		errorLabel.text = text
	}
}
