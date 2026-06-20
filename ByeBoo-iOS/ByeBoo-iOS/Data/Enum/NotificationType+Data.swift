//
//  NotificationType+Data.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

extension NotificationType {
    
    var responseKey: String {
        switch self {
        case .questOpen:
            "QUEST_OPEN"
        case .comment:
            "COMMENT"
        case .like:
            "LIKE"
        }
    }
    
    static func keyToEnum(_ key: String) -> Self? {
        allCases.first { $0.responseKey == key }
    }
}
