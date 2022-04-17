protocol ISourceFormatter {
	func string(from source: PostSource) -> String
}

final class SourceFormatter: ISourceFormatter {
	func string(from source: PostSource) -> String {
		switch source {
			case .lenta:
				return "Lenta.ru"

			case .nyt:
				return "NYT"
		}
	}
}
