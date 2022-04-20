import Foundation

final class PostsUpdater {
	private let sourcesRepository: IPostSourcesRepository
	private let postsRepository: IPostsRepository
	private let urlSession: URLSession
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

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.timeoutIntervalForRequest = 10
		sessionConfiguration.timeoutIntervalForResource = 10
		self.urlSession = URLSession(configuration: sessionConfiguration)

		self.updateTimeRepository.currentTimeChanged = { [weak self] fetchTime in
			self?.startUpdateTimer(everyTime: fetchTime)
		}
	}

	func start() {
		let time = updateTimeRepository.fetchCurrentTimeEntity()
		startUpdateTimer(everyTime: time)
		timer?.fire()
	}

	func stop() {
		timer?.invalidate()
	}

	private func startUpdateTimer(everyTime time: TimeInterval) {
		timer?.invalidate()
		timer = Timer(timeInterval: time, repeats: true, block: { [weak self] _ in
			self?.update()
		})
		RunLoop.main.add(timer!, forMode: .default)
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
