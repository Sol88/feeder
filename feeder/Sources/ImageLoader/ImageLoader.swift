import UIKit

final class ImageLoader {
	private let urlSession: IURLSession
	private var urlTasks: [URL: Cancellable] = [:]
	private var urlCompletions: [URL: [(UIImage?) -> Void]] = [:]
	private var queue = DispatchQueue(label: "queue.imageLoader.urlCompletions", attributes: .concurrent)

	init(urlSession: IURLSession) {
		self.urlSession = urlSession
	}
}

// MARK: - IImageLoader
extension ImageLoader: IImageLoader {
	func fetchImage(forURL url: URL, completion: @escaping (UIImage?) -> Void) {
		queue.async(flags: .barrier) {
			if var completions = self.urlCompletions[url] {
				completions.append(completion)
				self.urlCompletions[url] = completions
			} else {
				self.urlCompletions[url] = [completion]
				let task = self.dataTask(forURL: url)
				self.urlTasks[url] = task
				task.resume()
			}
		}
	}

	func cancelFetching(forURL url: URL) {
		queue.async(flags: .barrier) {
			if let task = self.urlTasks.removeValue(forKey: url) {
				task.cancel()
				print("[ImageLoader] cancel loading task \(url)")
			}
		}
	}
}

// MARK: - Private
private extension ImageLoader {
	func dataTask(forURL url: URL) -> Cancellable & Resumable {
		urlSession.dataTask(with: url) { [weak self, url] data, _ in
			self?.queue.async(flags: .barrier) {
				self?.urlTasks.removeValue(forKey: url)
			}
			DispatchQueue.global().async {
				guard let data = data, let image = UIImage(data: data) else {
					self?.returnCompletion(withImage: nil, forURL: url)
					return
				}
				self?.returnCompletion(withImage: image, forURL: url)
			}
		}
	}

	func returnCompletion(withImage image: UIImage?, forURL url: URL) {
		queue.async(flags: .barrier) {
			self.urlCompletions[url]?.forEach { $0(image) }
			self.urlCompletions.removeValue(forKey: url)
		}
	}
}
