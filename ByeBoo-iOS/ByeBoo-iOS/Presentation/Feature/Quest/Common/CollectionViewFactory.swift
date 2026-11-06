//
//  CollectionViewFactory.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

struct CollectionViewFactory {
    
    // iPhone Duo 대응: 칸 크기를 고정값이 아니라 목록 폭에서 계산
    // 한 줄 3칸, 좌우 여백 24, 칸 사이 19.5 → 375pt iPhone에서 디자인과 같은 96pt
    private static let columnCount = 3
    private static let horizontalInset: CGFloat = 24
    private static let interItemSpacing: CGFloat = 19.5
    
    static func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, environment in
            let contentWidth = environment.container.effectiveContentSize.width - horizontalInset * 2
            let spacing = interItemSpacing * CGFloat(columnCount - 1)
            let side = (contentWidth - spacing) / CGFloat(columnCount)
            
            let item = createItem(side: side)
            let group = createGroup(item: item, side: side)
            return createSection(group: group)
        }
    }

    private static func createItem(side: CGFloat) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(side),
                                              heightDimension: .absolute(side))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    private static func createGroup(item: NSCollectionLayoutItem, side: CGFloat) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(side))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: columnCount
        )
        group.interItemSpacing = .fixed(interItemSpacing)
        return group
    }
    
    private static func createSection(group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: horizontalInset,
            bottom: 16,
            trailing: horizontalInset
        )
        section.interGroupSpacing = 24
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(45))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
}
