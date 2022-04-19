import Foundation

protocol ISettingsInteractor: AnyObject {
	func fetchAllSources() -> [PostSource]
	func fetchIsSourceEnabled(_ source: PostSource) -> Bool
	func saveSource(_ source: PostSource, isEnabled: Bool)

	func fetchNumberOfUpdateTime() -> Int
	func fetchUpdateTime(atRow row: Int) -> TimeInterval
}
