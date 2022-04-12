import UIKit

protocol IImageLoader {
	func getImage(forURL url: URL, completion: @escaping (UIImage?) -> Void)
}
