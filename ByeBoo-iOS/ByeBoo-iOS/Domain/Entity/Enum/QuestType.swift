//
//  QuestType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/29/25.
//

import Foundation

// 퀘스트 타입 (질문형, 행동형)

enum QuestType: CaseIterable {
    case question
    case activation
}

extension QuestType {
    var mixpanelKey: String {
        switch self {
        case .question:
            "질문형"
        case .activation:
            "행동형"
        }
    }
}
