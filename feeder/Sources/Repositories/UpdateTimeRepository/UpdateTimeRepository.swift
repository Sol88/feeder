import Foundation

final class UserDefaultsUpdateTimeRepository {
	private let timeEntities: [TimeInterval] = [15, 30, 60, 120]
	private let userDefaultCurrentTimeKey = "userDefaultCurrentTimeKey"
	private let userDefaults = UserDefaults.standard

	var currentTimeChanged: ((TimeInterval) -> Void)?

	init() {
		userDefaults.register(defaults: [userDefaultCurrentTimeKey: timeEntities[0]])
	}
}

// MARK: - IUpdateTimeRepository
extension UserDefaultsUpdateTimeRepository: IUpdateTimeRepository {
	func fetchAllTimeEntities() -> [TimeInterval] {
		timeEntities
	}

	func fetchCurrentTimeEntity() -> TimeInterval {
		userDefaults.double(forKey: userDefaultCurrentTimeKey)
	}

	func saveCurrentTimeEntity(_ timeInterval: TimeInterval) {
		currentTimeChanged?(timeInterval)
		userDefaults.set(timeInterval, forKey: userDefaultCurrentTimeKey)
	}
}
