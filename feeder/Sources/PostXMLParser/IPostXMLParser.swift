import Foundation

protocol IPostXMLParser: AnyObject {
	func parse(data: Data) -> [XMLPost]
}
