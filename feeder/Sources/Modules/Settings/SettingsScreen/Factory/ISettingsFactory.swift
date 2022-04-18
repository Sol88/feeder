import UIKit

protocol ISettingsFactory: AnyObject {
	func make(sourceFormatter: ISourceFormatter, sourcesRepository: IPostSourcesRepository) -> UIViewController
}
