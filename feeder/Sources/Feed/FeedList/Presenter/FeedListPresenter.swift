import Foundation

final class FeedListPresenter {
	private var props: FeedListViewController.Props? {
		didSet {
			guard let props = props else { return }

			DispatchQueue.main.async {
				self.input?.propsChanged(props)
			}
		}
	}
	weak var input: IFeedListViewIntput?
	var interactor: IFeedListInteractor?
	var router: IFeedListRouter?

	var items = [
		FeedCollectionViewCell.Props(
			id: "123",
			imageURL: URL(string: "https://icdn.lenta.ru/images/2022/04/08/11/20220408113526242/pic_45a631a117e16967b6629f02e3b4c4ef.jpeg")!,
			title: "Европа отказала Украине в немедленном членстве в ЕКА",
			content: URL(string: "https://lenta.ru/news/2022/04/09/esa/")!,
			summary: "Вскоре после начала спецоперации России по защите Донбасса правительство Украины направило Европейскому космическому агентству (ЕКА) запрос на членство, однако фактически получило отказ. Об этом сообщает SpaceNews. «Это важное решение, и его нельзя принять очень быстро», — заявил глава ЕКА Йозеф Ашбахер.",
			date: "28.02.22",
			source: "Лента.ру"
		)
	]
}

// MARK: - IFeedListViewOutput
extension FeedListPresenter: IFeedListViewOutput {
	func didLoad() {
		self.props = .loading
		self.interactor?.fetchPosts { [weak self] posts in
			guard let self = self else { return }
			self.props = .data(self.items.map(\.id))
		}
	}

	func didTouchRetryButton() {
		self.props = .loading
	}

	func didTouchPostInfoView(with id: FeedCollectionViewCell.Props.ID) {
		guard let index = self.items.firstIndex(where: { $0.id == id }) else { return }

		var item = self.items.remove(at: index)

		item.shouldShowSummary.toggle()

		self.items.insert(item, at: index)
		self.props = .update([item.id])
	}

	func post(for id: FeedCollectionViewCell.Props.ID) -> FeedCollectionViewCell.Props? {
		self.items.first(where: { $0.id == id })
	}
}
