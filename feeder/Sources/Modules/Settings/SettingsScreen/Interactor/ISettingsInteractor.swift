protocol ISettingsInteractor: AnyObject {
	func fetchAllSources() -> [PostSource]
	func fetchIsSourceEnabled(_ source: PostSource) -> Bool
	func saveSource(_ source: PostSource, isEnabled: Bool)
}
