import UIKit

protocol Coordinator: AnyObject {
	var parentCoordinator: Coordinator? { get }
	var rootViewController: UIViewController? { get }

	func start() -> UIViewController
}
