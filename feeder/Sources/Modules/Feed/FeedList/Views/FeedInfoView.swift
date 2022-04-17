import UIKit
import SnapKit

final class FeedInfoView: UIView {
	struct Props {
		let title: String
		let summary: String?
		let date: String
		let source: String
		let isRead: Bool
	}

	var props: Props? {
		didSet {
			DispatchQueue.main.async {
				guard let props = self.props else { return }

				self.titleLabel.text = props.title
				self.summaryLabel.text = props.summary
				self.dateLabel.text = props.date
				self.sourceLabel.text = props.source

				self.summaryLabelTopConstraint?.update(offset: props.summary == nil ? 0 : 8)

				self.titleLabel.textColor = props.isRead ? .systemGray2 : .systemBlue

				self.setNeedsLayout()
				self.invalidateIntrinsicContentSize()
			}
		}
	}

	// MARK: - UI
	private var summaryLabelTopConstraint: Constraint?
	private lazy var titleLabel: UILabel = {
		let label = UILabel()

		label.numberOfLines = 2
		label.font = .preferredFont(forTextStyle: .title2)
		label.adjustsFontSizeToFitWidth = true

		return label
	}()

	private lazy var summaryLabel: UILabel = {
		let label = UILabel()

		label.numberOfLines = 0
		label.textColor = .systemGray
		label.font = .preferredFont(forTextStyle: .subheadline)

		return label
	}()

	private lazy var dateLabel: UILabel = {
		let label = UILabel()

		label.numberOfLines = 1
		label.textColor = .systemGray
		label.font = .preferredFont(forTextStyle: .footnote)

		return label
	}()

	private lazy var sourceLabel: UILabel = {
		let label = UILabel()

		label.numberOfLines = 1
		label.textColor = .systemGray
		label.font = .preferredFont(forTextStyle: .footnote)

		return label
	}()

	// MARK: -
	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .clear

		let blurEffect = UIBlurEffect(style: .systemMaterial)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		addSubview(visualEffectView) { make in
			make.edges.equalToSuperview()
		}

		addSubview(titleLabel) { make in
			make.leading.top.trailing.equalToSuperview().inset(8)
		}

		summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		addSubview(summaryLabel) { make in
			make.leading.trailing.equalTo(titleLabel)
			summaryLabelTopConstraint = make.top.equalTo(titleLabel.snp.bottom).offset(8).constraint
		}

		addSubview(dateLabel) { make in
			make.leading.equalTo(titleLabel)
			make.top.equalTo(summaryLabel.snp.bottom).offset(8)
			make.bottom.equalToSuperview().inset(8)
		}

		addSubview(sourceLabel) { make in
			make.trailing.equalTo(titleLabel)
			make.bottom.equalTo(dateLabel)
		}
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	func clear() {
		DispatchQueue.main.async {
			self.titleLabel.text = nil
			self.sourceLabel.text = nil
			self.dateLabel.text = nil
			self.sourceLabel.text = nil
		}
	}
}
