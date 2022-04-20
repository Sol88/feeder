import XCTest
@testable import feeder

final class MinutesAndSecondsTimeFormatterTests: XCTestCase {

	private var formatter: MinutesAndSecondsTimeFormatter!

    override func setUpWithError() throws {
        formatter = MinutesAndSecondsTimeFormatter()
    }

	func test_negativeTime_emptyString() throws {
		let result = formatter.format(time: -1)
		XCTAssertEqual(result, "")
	}

    func test_zeroTime_now() throws {
		let result = formatter.format(time: 0)
		XCTAssertEqual(result, "0 sec")
    }

	func test_1seconds_1sec() throws {
		let result = formatter.format(time: 1)
		XCTAssertEqual(result, "1 sec")
	}

	func test_59seconds_59sec() throws {
		let result = formatter.format(time: 59)
		XCTAssertEqual(result, "59 sec")
	}

	func test_60seconds_1min() throws {
		let result = formatter.format(time: 60)
		XCTAssertEqual(result, "1 min")
	}

	func test_61seconds_1min1sec() throws {
		let result = formatter.format(time: 61)
		XCTAssertEqual(result, "1 min 1 sec")
	}

	func test_3600seconds_60min() throws {
		let result = formatter.format(time: 3600)
		XCTAssertEqual(result, "60 min")
	}
}
