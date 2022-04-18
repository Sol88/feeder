import Foundation

protocol ISettingsViewOutput: AnyObject {
	func didLoad()

	func switchDidChangeValue(_ value: Bool, atIndexPath indexPath: IndexPath)
}
