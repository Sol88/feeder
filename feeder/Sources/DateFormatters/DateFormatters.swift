import Foundation

final class DateFormatters {
	static var xmlPostPublicationDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
		formatter.locale = Locale(identifier: "en_US")
		return formatter
	}()

	static var longAgoNamedDateFormatter: IDateFormatter = {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		return formatter
	}()
}
