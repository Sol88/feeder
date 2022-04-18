protocol IPostSourcesRepository: AnyObject {
	func fetchAllSources() -> [PostSource]
	func fetchSourceIsEnabled(_ source: PostSource) -> Bool
	func saveSource(_ source: PostSource, isEnabled: Bool)
}
