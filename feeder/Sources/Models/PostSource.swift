import Foundation

enum PostSource: String, CaseIterable, Hashable {
	case lenta = "Lenta"
	case nyt = "NYT"
}

extension PostSource {
	var url: URL {
		switch self {
			case .nyt:
				return URL(string: "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml")!

			case .lenta:
				return URL(string: "http://lenta.ru/rss")!
		}
	}

	var xmlParser: IPostXMLParser {
		switch self {
			case .lenta, .nyt:
				return PostXMLParser()
		}
	}
}
