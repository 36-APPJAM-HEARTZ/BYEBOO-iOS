//
//  QuestAnswerResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

struct QuestAnswerResponseDTO: Decodable {
    let stepNumber: Int
    let questNumber: Int
    let createdAt: String
    let question: String
    let answer: String?
    let questEmotionState: String
    let imageUrl: String?
    let imageKey: String?
    let emotionDescription: String
    // TODO: API 변동되면 옵셔널 해제
    let aiAnswerExists: Bool?
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
            emotionDescription: emotionDescription,
            AIAnswerExists: aiAnswerExists ?? true
        )
    }
}
