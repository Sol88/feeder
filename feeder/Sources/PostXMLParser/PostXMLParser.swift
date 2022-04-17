import Foundation

final class PostXMLParser: NSObject {
	private var currentElement: String?
	private var id: String = ""
	private var title: String = ""
	private var link: String = ""
	private var summary: String = ""
	private var pubDate: String = ""
	private var imageURL: String? = ""

	private(set) var posts: [XMLPost] = []
}

// MARK: - IPostXMLParser
extension PostXMLParser: IPostXMLParser {
	func parse(data: Data) -> [XMLPost] {
		let parser = XMLParser(data: data)
		parser.delegate = self
		parser.parse()
		return posts
	}
}

// MARK: - XMLParserDelegate
extension PostXMLParser: XMLParserDelegate {
	func parserDidStartDocument(_ parser: XMLParser) {
		posts = []
	}

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

		if elementName == "item" {
			id = ""
			title = ""
			link = ""
			summary = ""
			pubDate = ""
			imageURL = nil
		}

		currentElement = elementName

		if elementName == "enclosure" && attributeDict["type"]?.contains("image") ?? false {
			imageURL = attributeDict["url"]
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		currentElement = nil

		guard elementName == "item" else { return }
		
		posts.append(
			XMLPost(
				id: id.trimmingCharacters(in: .whitespacesAndNewlines),
				title: title.trimmingCharacters(in: .whitespacesAndNewlines),
				link: link.trimmingCharacters(in: .whitespacesAndNewlines),
				pubDate: pubDate.trimmingCharacters(in: .whitespacesAndNewlines),
				description: summary.trimmingCharacters(in: .whitespacesAndNewlines),
				imageURL: imageURL?.trimmingCharacters(in: .whitespacesAndNewlines)
			)
		)
	}

	func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
		guard let element = currentElement, element == "description" else { return }
		guard let string = String(data: CDATABlock, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
		summary += string
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		guard let element = currentElement else { return }

		switch element {
			case "guid":
				id += string
			case "title":
				title += string
			case "description":
				summary += string
			case "link":
				link += string
			case "pubDate":
				pubDate += string
			default: break
		}
	}
}
