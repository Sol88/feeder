import Foundation

final class PostXMLParser: NSObject {
	private var currentElement: String?
	private var id: String = ""
	private var title: String = ""
	private var link: String = ""
	private var summary: String = ""
	private var pubDate: String = ""

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
		self.posts = []
	}

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
		self.currentElement = elementName
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		self.currentElement = nil

		guard elementName == "item" else { return }
		
		self.posts.append(
			XMLPost(id: self.id, title: self.title, link: self.link, pubDate: self.pubDate, description: self.summary)
		)

		self.id = ""
		self.title = ""
		self.link = ""
		self.summary = ""
		self.pubDate = ""
	}

	func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
		guard let element = self.currentElement, element == "description" else { return }
		guard let string = String(data: CDATABlock, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
		self.summary += string
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		guard let element = self.currentElement else { return }
		let value = string.trimmingCharacters(in: .whitespacesAndNewlines)

		switch element {
			case "guid":
				self.id += value
			case "title":
				self.title += value
			case "description":
				self.summary += value
			case "link":
				self.link += value
			case "pubDate":
				self.pubDate += value
			default: break
		}
	}
}
