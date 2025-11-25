//
//  QuestAnswerResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

struct QuestAnswerResponseDTO: Decodable {
    var stepNumber: Int
    var questNumber: Int
    var createdAt: String
    var question: String
    var answer: String?
    var questEmotionState: String
    var imageUrl: String?
    var imageKey: String?
    var emotionDescription: String
}

extension QuestAnswerResponseDTO {
    func toEntity() -> QuestAnswerEntity {
        QuestAnswerEntity(
            stepNumber: stepNumber,
            questNumber: questNumber,
            createdAt: createdAt,
            question: question,
            answer: answer ?? "",
            questEmotionState: questEmotionState,
            imageUrl: imageUrl ?? "",
            imageKey: imageKey ?? "",
            emotionDescription: emotionDescription
        )
    }
}
