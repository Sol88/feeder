import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {
	struct Props: Identifiable, Hashable {
		let id: String
		let title: String
		let content: URL
		let summary: String?
		let date: String
		let source: String
		let isRead: Bool
		var image: UIImage?
		var shouldShowSummary: Bool = false
	}

	var props: Props? {
		didSet {
			DispatchQueue.main.async {
				self.handlePropsUpdate()
			}
		}
	}

	var infoViewDidTouched: ((Props.ID) -> Void)?

	// MARK: - UI
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()

		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .tertiarySystemBackground

		imageView.layer.cornerRadius = 12
		imageView.layer.masksToBounds = true

		return imageView
	}()

	private lazy var infoView: FeedInfoView = {
		let view = FeedInfoView()

		view.layer.cornerRadius = 12
		view.layer.masksToBounds = true
		view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

		view.addGestureRecognizer(infoTapGestureRecognizer)

		return view
	}()

	private lazy var infoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoTapGestureRecognizerHandler))

	// MARK: -
	override init(frame: CGRect) {
		super.init(frame: frame)

		contentView.addSubview(imageView) { make in
			make.edges.equalToSuperview()
		}

		contentView.addSubview(infoView)
		contentView.addSubview(infoView) { make in
			make.leading.bottom.trailing.equalToSuperview()
			make.top.greaterThanOrEqualTo(0)
		}
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	override func prepareForReuse() {
		super.prepareForReuse()
		infoView.clear()
		imageView.image = nil
	}
}

// MARK: - Populating cell
private extension FeedCollectionViewCell {
	func handlePropsUpdate() {
		guard let props = props else { return }

		infoView.props = FeedInfoView.Props(
			title: props.title,
			summary: props.shouldShowSummary ? props.summary : nil,
			date: props.date,
			source: props.source,
			isRead: props.isRead
		)
		imageView.image = props.image ?? UIImage(named: "placeholder")

		setNeedsLayout()
	}
}

// MARK: - Actions
private extension FeedCollectionViewCell {
	@objc func infoTapGestureRecognizerHandler() {
		guard let id = props?.id else { return }

		infoViewDidTouched?(id)
	}
}
