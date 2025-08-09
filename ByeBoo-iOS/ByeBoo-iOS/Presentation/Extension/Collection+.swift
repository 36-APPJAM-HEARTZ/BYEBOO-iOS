//
//  Collection+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/31/25.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
