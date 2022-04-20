import XCTest
@testable import feeder

final class PostXMLParserTests: XCTestCase {

	private var xmlParser: PostXMLParser!

	override func setUpWithError() throws {
		xmlParser = PostXMLParser()
	}

	func test_parseCorrectItem_PostXML() throws {
		let result = xmlPosts(from: XMLTestData.xmlItem)

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].id, "https://lenta.ru/news/2022/04/20/zhenites/")
		XCTAssertEqual(result[0].title, "Юэн Макгрегор женится на Мэри Элизабет Уинстэд")
		XCTAssertEqual(result[0].link, "https://lenta.ru/news/2022/04/20/zhenites/")
		XCTAssertEqual(result[0].description, "Шотландский актер Юэн Макгрегор женится на коллеге по сериалу «Фарго», американской актрисе Мэри Элизабет Уинстэд. Свадьба запланирована на 22 апреля. Летом 2021 года у пары родился родился ребенок. Артистка стала матерью впервые, в то время как у актера есть две родные и две приемные дочери.")
		XCTAssertEqual(result[0].pubDate, "Wed, 20 Apr 2022 18:09:53 +0300")
		XCTAssertEqual(result[0].imageURL, "https://icdn.lenta.ru/images/2022/04/20/17/20220420175209925/pic_7d3f130f70af285d506999ac84001861.jpg")
	}

	func test_parseArrayOfTwoItems_TwoXMLPosts() throws {
		let result = xmlPosts(from: XMLTestData.xmlItems)

		XCTAssertEqual(result.count, 2)
	}

	func test_parseEmptyXMLPost_XMLPostWithEmptyFields() throws {
		let result = xmlPosts(from: XMLTestData.emptyXMLItem)

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].id, "https://lenta.ru/news/2022/04/20/zhenites/")
		XCTAssertEqual(result[0].title, "")
		XCTAssertEqual(result[0].link, "")
		XCTAssertEqual(result[0].description, "")
		XCTAssertEqual(result[0].pubDate, "")
		XCTAssertNil(result[0].imageURL)
	}

	func test_parseXMLWithVideoURL_XMLPostWithNilImageURL() throws {
		let result = xmlPosts(from: XMLTestData.xmlItemWithVideoURL)

		XCTAssertEqual(result.count, 1)
		XCTAssertNil(result[0].imageURL)
	}

	func test_parseXMLWithoutCDATADescription_XMLPostWithRegularDescription() throws {
		let result = xmlPosts(from: XMLTestData.xmlItemWithoutCDATADescription)

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].description, "Test text")
	}

	private func xmlPosts(from string: String) -> [XMLPost] {
		guard let data = string.data(using: .utf8) else {
			XCTFail("\(string) should be correctly decoded")
			return []
		}
		return xmlParser.parse(data: data)
	}
}
