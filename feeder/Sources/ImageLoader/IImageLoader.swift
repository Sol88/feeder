import UIKit

protocol IImageLoader {
	func fetchImage(forURL url: URL, completion: @escaping (UIImage?) -> Void)
	func cancelFetching(forURL url: URL)
}
