import Foundation

final class PostsUpdater {
	private let sourcesRepository: IPostSourcesRepository
	private let postsRepository: IPostsRepository
	private let urlSession: URLSession = .shared
	private let updateTimeRepository: IUpdateTimeRepository

	private var timer: Timer?

	init(
		postsRepository: IPostsRepository,
		sourcesRepository: IPostSourcesRepository,
		updateTimeRepository: IUpdateTimeRepository
	) {
		self.postsRepository = postsRepository
		self.sourcesRepository = sourcesRepository
		self.updateTimeRepository = updateTimeRepository
	}

	func start() {
		let time = updateTimeRepository.fetchCurrentTimeEntity()
		timer?.invalidate()
		timer = Timer(timeInterval: time, repeats: true, block: { [weak self] _ in
			self?.update()
		})
		RunLoop.main.add(timer!, forMode: .default)
		timer?.fire()
	}

	func stop() {
		timer?.invalidate()
	}

	private func update() {
		let postsLoaders = sourcesRepository.fetchAllSources()
			.filter(sourcesRepository.fetchSourceIsEnabled)
			.map { PostsLoader(session: urlSession, source: $0) }
		for loader in postsLoaders {
			Task {
				guard let posts = try? await loader.fetchPosts() else { return }
				postsRepository.add(posts, forSource: loader.source)
			}
		}
	}
}
