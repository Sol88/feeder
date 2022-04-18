final class SettingsInteractor {
	// MARK: - Private
	private let sourcesRepository: IPostSourcesRepository

	// MARK: -
	init(sourcesRepository: IPostSourcesRepository) {
		self.sourcesRepository = sourcesRepository
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
}
