import Foundation

protocol IUpdateTimeRepository: AnyObject {
	var currentTimeChanged: ((TimeInterval) -> Void)? { get set }
	
	func fetchAllTimeEntities() -> [TimeInterval]
	func fetchCurrentTimeEntity() -> TimeInterval
	func saveCurrentTimeEntity(_ timeInterval: TimeInterval)
}
