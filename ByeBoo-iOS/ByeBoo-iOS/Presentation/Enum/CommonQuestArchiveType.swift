//
//  CommonQuestArchiveType.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import Foundation
import UIKit

enum CommonQuestArchiveType {
    case myAnswer
    case otherAnswer
    case myComment
    case otherComment
    
    enum Action {
        case edit, delete, report, block
    }
    
    struct Item {
        let title: String
        let icon: UIImage
        let color: UIColor
        let action: Action
    }
    
    var items: [Item] {
        switch self {
        case .myAnswer, .myComment:
            return [
                Item(title: "수정하기", icon: .edit, color: .white, action: .edit),
                Item(title: "삭제하기", icon: .trash, color: .error300, action: .delete)
            ]
        case .otherAnswer:
            return [
                Item(title: "사용자 차단하기", icon: .block, color: .white, action: .block),
                Item(title: "게시글 신고하기", icon: .report, color: .error300, action: .report)
            ]
        case .otherComment:
            return [
                Item(title: "차단하기", icon: .block, color: .white, action: .edit),
                Item(title: "신고하기", icon: .report, color: .error300, action: .delete)
            ]
        }
    }
}
