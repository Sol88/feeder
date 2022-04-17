import Foundation

protocol IDateFormatter: AnyObject {
	func string(from date: Date) -> String
}

extension DateFormatter: IDateFormatter {}

extension ISO8601DateFormatter: IDateFormatter {}

extension RelativeDateTimeFormatter: IDateFormatter {
	func string(from date: Date) -> String {
		localizedString(for: date, relativeTo: Date())
	}
}
