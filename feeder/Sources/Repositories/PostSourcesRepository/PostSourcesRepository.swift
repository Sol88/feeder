import Foundation
final class PostSourceUserDefaultsRepository {
	private let userDefaults = UserDefaults.standard

	init() {
		var defaults: [String: Bool] = [:]
		for source in fetchAllSources() {
			defaults[source.rawValue] = true
		}
		userDefaults.register(defaults: defaults)
	}
}

// MARK: - IPostSourceRepository
extension PostSourceUserDefaultsRepository: IPostSourcesRepository {
	func fetchAllSources() -> [PostSource] {
		PostSource.allCases
	}

	func fetchSourceIsEnabled(_ source: PostSource) -> Bool {
		userDefaults.bool(forKey: source.rawValue)
	}

	func saveSource(_ source: PostSource, isEnabled: Bool) {
		userDefaults.set(isEnabled, forKey: source.rawValue)
	}
}
