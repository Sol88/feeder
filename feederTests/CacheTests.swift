import XCTest
@testable import feeder

class CacheTests: XCTestCase {

	private var cache: Cache<String, Int>!

    override func setUpWithError() throws {
		cache = Cache(maxAmountOfElements: 5)
    }

    func test_insertingInCache() throws {
		let emptyValue = cache.value(forKey: "1")
		XCTAssertNil(emptyValue)

		cache.insert(1, forKey: "1")
		let value = cache.value(forKey: "1")

		XCTAssertEqual(value, 1)
    }

	func test_removingFromCache() throws {
		cache.insert(1, forKey: "1")
		let value = cache.value(forKey: "1")

		XCTAssertEqual(value, 1)

		cache.remove(forKey: "1")

		let emptyValue = cache.value(forKey: "1")
		XCTAssertNil(emptyValue)
	}

	func test_deletingOldValueAfterInserting() throws {
		for i in 1...15 {
			cache.insert(i, forKey: "\(i)")
		}

		for i in 1...10 {
			XCTAssertNil(cache.value(forKey: "\(i)"))
		}

		for i in 11...15 {
			XCTAssertEqual(cache.value(forKey: "\(i)"), i)
		}
	}
}
