import Foundation

protocol ISettingsViewOutput: AnyObject {
	func didLoad()
	func didSelectRow(atIndexPath indexPath: IndexPath)
	func didTapGestureRecognizer()

	func switchDidChangeValue(_ value: Bool, atIndexPath indexPath: IndexPath)
	func numberOfElementsInTimeUpdatePicker() -> Int
	func timerUpdatePickerTitle(atRow row: Int) -> String?
	func timerUpdatePickerDidSelect(row: Int)
}
