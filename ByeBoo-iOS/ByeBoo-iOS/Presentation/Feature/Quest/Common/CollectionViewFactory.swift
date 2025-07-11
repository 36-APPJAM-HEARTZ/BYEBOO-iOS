//
//  CollectionViewFactory.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

struct CollectionViewFactory {
    
    static func createLayout() -> UICollectionViewLayout {
        let item = createItem()
        let group = createGroup(item: item)
        let section = createSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private static func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalWidth(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    private static func createGroup(item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(244.adjustedH))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(19.5.adjustedW)
        return group
    }
    
    private static func createSection(group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16.adjustedH,
            leading: 24.adjustedW,
            bottom: 16.adjustedH,
            trailing: 24.adjustedW
        )
        section.interGroupSpacing = 24.adjustedH
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(45.adjustedH))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
}
