import Foundation

protocol IUpdateTimeRepository {
	func fetchAllTimeEntities() -> [TimeInterval]
	func fetchCurrentTimeEntity() -> TimeInterval
	func saveCurrentTimeEntity(_ timeInterval: TimeInterval)
}
