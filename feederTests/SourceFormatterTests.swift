import XCTest
@testable import feeder

final class SourceFormatterTests: XCTestCase {

	private var formatter: SourceFormatter!

    override func setUpWithError() throws {
		formatter = SourceFormatter()
    }

    func test_lenta_LentaRu() throws {
		let result = formatter.string(from: .lenta)
		XCTAssertEqual(result, "Lenta.ru")
    }

	func test_nyt_NYT() throws {
		let result = formatter.string(from: .nyt)
		XCTAssertEqual(result, "NYT")
	}
}
