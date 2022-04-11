import Foundation

enum PostSource {
	case lenta
}

struct Post {
	let id: String
	let imageURL: URL
	let title: String
	let content: URL
	let summary: String
	let date: Date
	let source: PostSource
	let isRead: Bool
}

extension Post {
	static var dummy: [Post] {
		[
			Post(
				id: "123",
				imageURL: URL(string: "https://icdn.lenta.ru/images/2022/04/08/11/20220408113526242/pic_45a631a117e16967b6629f02e3b4c4ef.jpeg")!,
				title: "Европа отказала Украине в немедленном членстве в ЕКА",
				content: URL(string: "https://lenta.ru/news/2022/04/09/esa/")!,
				summary: "Вскоре после начала спецоперации России по защите Донбасса правительство Украины направило Европейскому космическому агентству (ЕКА) запрос на членство, однако фактически получило отказ. Об этом сообщает SpaceNews. «Это важное решение, и его нельзя принять очень быстро», — заявил глава ЕКА Йозеф Ашбахер.",
				date: Date().addingTimeInterval(-30000),
				source: .lenta,
				isRead: true
			)
		]
	}
}
