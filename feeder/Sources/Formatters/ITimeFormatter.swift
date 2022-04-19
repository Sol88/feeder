import Foundation

protocol ITimeFormatter {
	func format(time: TimeInterval) -> String
}
