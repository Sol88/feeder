import UIKit

extension UICollectionViewLayout {
	static var feedLayout: UICollectionViewLayout {
		let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
		let item = NSCollectionLayoutItem(
			layoutSize: layoutSize,
			supplementaryItems: []
		)
		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: layoutSize,
			subitems: [item]
		)
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
		section.interGroupSpacing = 12

		return UICollectionViewCompositionalLayout(section: section)
	}
}
