//
//  UICollectionView+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/17/25.
//

import UIKit

extension UICollectionView {
    
    func scrollToHeader(at section: Int) {
        guard let attributes = layoutAttributesForSupplementaryElement(
            ofKind: Self.elementKindSectionHeader,
            at: IndexPath(item: 0, section: section)
        ) else {
            return
        }
        let offsetY = max(attributes.frame.origin.y - contentInset.top, 0)
        setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
}
