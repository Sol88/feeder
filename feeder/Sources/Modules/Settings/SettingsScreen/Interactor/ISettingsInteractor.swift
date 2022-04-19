import Foundation

protocol ISettingsInteractor: AnyObject {
	func fetchAllSources() -> [PostSource]
	func fetchIsSourceEnabled(_ source: PostSource) -> Bool
	func saveSource(_ source: PostSource, isEnabled: Bool)

	func fetchAllUpdateTimes() -> [TimeInterval]
	func fetchUpdateTime(atRow row: Int) -> TimeInterval
	func updateCurrentUpdateTime(_ time: TimeInterval)
	func fetchCurrentUpdateTime() -> TimeInterval
}
