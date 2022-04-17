import SnapKit
import UIKit

extension UIView {
	func addSubview(_ view: UIView, makeConstraints: (ConstraintMaker) -> Void) {
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		view.snp.makeConstraints(makeConstraints)
	}
}
