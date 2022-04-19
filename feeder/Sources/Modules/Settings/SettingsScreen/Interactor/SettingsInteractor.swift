import Foundation

final class SettingsInteractor {
	// MARK: - Private
	private let sourcesRepository: IPostSourcesRepository
	private let updateTimeRepository: IUpdateTimeRepository

	// MARK: -
	init(sourcesRepository: IPostSourcesRepository, updateTimeRepository: IUpdateTimeRepository) {
		self.sourcesRepository = sourcesRepository
		self.updateTimeRepository = updateTimeRepository
	}
}

// MARK: - IFeedDetailsInteractor
extension SettingsInteractor: ISettingsInteractor {
	func fetchAllSources() -> [PostSource] {
		sourcesRepository.fetchAllSources()
	}

	func fetchIsSourceEnabled(_ source: PostSource) -> Bool {
		sourcesRepository.fetchSourceIsEnabled(source)
	}

	func saveSource(_ source: PostSource, isEnabled: Bool) {
		sourcesRepository.saveSource(source, isEnabled: isEnabled)
	}

	func fetchNumberOfUpdateTime() -> Int {
		updateTimeRepository.fetchAllTimeEntities().count
	}

	func fetchUpdateTime(atRow row: Int) -> TimeInterval {
		let entities = updateTimeRepository.fetchAllTimeEntities()
		return entities[row]
	}
}
