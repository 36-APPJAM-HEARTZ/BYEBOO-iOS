//
//  QuestAnswerEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

struct QuestAnswerEntity {
    var stepNumber: Int
    var questNumber: Int
    var createdAt: String
    var question: String
    var answer: String
    var questEmotionState: String
    var imageUrl: String?
    var emotionDescription: String
}

extension QuestAnswerEntity {
    static func stub() -> QuestAnswerEntity {
        return .init(
            stepNumber: 1,
            questNumber: 1,
            createdAt: "2025-07-18",
            question: "어쩌구 저쩌구 question",
            answer: "답변입니다 ~",
            questEmotionState: "mock emotion state",
            emotionDescription: "mock emotion description"
        )
    }
}
