//
//  QuestAnswerEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

struct QuestAnswerEntity {
    let stepNumber: Int
    let questNumber: Int
    let createdAt: String
    let question: String
    let answer: String
    let questEmotionState: String
    let imageUrl: String?
    let imageKey: String?
    let emotionDescription: String
    let AIAnswerExists: Bool
}

extension QuestAnswerEntity: Equatable {
    static func stub() -> QuestAnswerEntity {
        return .init(
            stepNumber: 1,
            questNumber: 1,
            createdAt: "2025-07-18",
            question: "어쩌구 저쩌구 question",
            answer: "답변입니다 ~",
            questEmotionState: "mock emotion state",
            imageUrl: nil,
            imageKey: nil,
            emotionDescription: "mock emotion description",
            AIAnswerExists: true
        )
    }
}
