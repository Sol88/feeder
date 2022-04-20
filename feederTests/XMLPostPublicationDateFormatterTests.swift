import XCTest
@testable import feeder

final class XMLPostPublicationDateFormatterTests: XCTestCase {

	private var formatter: DateFormatter!

    override func setUpWithError() throws {
		formatter = DateFormatters.xmlPostPublicationDateFormatter
    }

    func test_correctDateFromMSCTimeZone() throws {
		let result = formatter.date(from: "Wed, 20 Apr 2022 18:09:53 +0300")
		XCTAssertNotNil(result)

		check(result!, year: 2022, month: 04, day: 20, hour: 15, minute: 9, second: 53)
    }

	func test_correctDateFromUTC() throws {
		let result = formatter.date(from: "Wed, 01 Jan 2022 00:01:01 +0000")
		XCTAssertNotNil(result)

		check(result!, year: 2022, month: 01, day: 01, hour: 0, minute: 1, second: 1)
	}

	func test_incorrectDate_nil() throws {
		let result = formatter.date(from: "01 Jan 2022 00:01:01 +0000")
		XCTAssertNil(result)
	}

	private func check(_ date: Date, year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let components = calendar.dateComponents([.month, .minute, .hour, .second, .year, .day], from: date)

		XCTAssertEqual(components.day, day)
		XCTAssertEqual(components.month, month)
		XCTAssertEqual(components.year, year)
		XCTAssertEqual(components.hour, hour)
		XCTAssertEqual(components.minute, minute)
		XCTAssertEqual(components.second, second)
	}
}
