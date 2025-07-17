//
//  QuestTipEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

struct QuestTipDataEntity {
    let step: String
    let stepNumber: Int
    let questNumber: Int
    let question: String
    let tips: [QuestTipEntity]
}

struct QuestTipEntity {
    let tipStep: Int
    let tipAnswer: String
}

extension QuestTipDataEntity {
    static func stub() -> QuestTipDataEntity {
        return .init(
            step: "1",
            stepNumber: 1,
            questNumber: 1,
            question: "question",
            tips: [.stub()]
        )
    }
}

extension QuestTipEntity {
    static func stub() -> QuestTipEntity {
        return .init(tipStep: 1, tipAnswer: "tip answer")
    }
}
