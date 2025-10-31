//
//  QuestInfoEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct QuestInfoEntity {
    var step: String
    var stepNumber: Int
    var questNumber: Int
    var questStyle: String
    var question: String
}

extension QuestInfoEntity: Equatable {
    static func stub() -> QuestInfoEntity {
        return .init(
            step: "1",
            stepNumber: 1,
            questNumber: 1,
            questStyle: "quest style",
            question: "question"
        )
    }
}
