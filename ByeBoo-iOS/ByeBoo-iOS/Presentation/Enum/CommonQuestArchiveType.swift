//
//  CommonQuestArchiveType.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import Foundation
import UIKit

enum CommonQuestArchiveType {
    case mine
    case other
    
    struct Item {
        let title: String
        let icon: UIImage
        let color: UIColor
    }
    
    var items: [Item] {
        switch self {
        case .mine:
            return [
                Item(title: "수정하기", icon: .edit, color: .white),
                Item(title: "삭제하기", icon: .trash, color: .error300)
            ]
        case .other:
            return [
                Item(title: "사용자 차단하기", icon: .block, color: .white),
                Item(title: "게시글 신고하기", icon: .report, color: .error300)
            ]
        }
    }
}
