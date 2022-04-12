import UIKit

final class ImageLoader {
	private let urlSession: URLSession
	private var urlCompletions: [URL: [(UIImage?) -> Void]] = [:]
	private var urlCompletionsQueue = DispatchQueue(label: "queue.imageLoader.urlCompletions")

	init() {
		let configuration = URLSessionConfiguration.default
		configuration.urlCache = .shared

		self.urlSession = URLSession(configuration: configuration)
	}
}

// MARK: - IImageLoader
extension ImageLoader: IImageLoader {
	func getImage(forURL url: URL, completion: @escaping (UIImage?) -> Void) {
		self.urlCompletionsQueue.async(flags: .barrier) {
			if var completions = self.urlCompletions[url] {
				completions.append(completion)
				self.urlCompletions[url] = completions
			} else {
				self.urlCompletions[url] = [completion]
				self.urlSession.dataTask(with: url) { [weak self, url] data, _, _ in
					DispatchQueue.global().async {
						guard let data = data, let image = UIImage(data: data) else {
							self?.returnCompletion(withImage: nil, forURL: url)
							return
						}
						self?.returnCompletion(withImage: image, forURL: url)
					}
				}.resume()
			}
		}
	}
}

// MARK: - Private
private extension ImageLoader {
	func returnCompletion(withImage image: UIImage?, forURL url: URL) {
		self.urlCompletionsQueue.async(flags: .barrier) {
			self.urlCompletions[url]?.forEach { $0(image) }
			self.urlCompletions.removeValue(forKey: url)
		}
	}
}
