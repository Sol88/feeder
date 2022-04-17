import UIKit

protocol ISettingsFactory: AnyObject {
	func make() -> UIViewController
}
