//
//  QuestTipResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

struct QuestTipResponseDTO: Decodable {
    var step: String
    var stepNumber: Int
    var questNumber: Int
    var question: String
    var tips: [QuestTipDTO]
}

struct QuestTipDTO: Decodable {
    var tipStep: Int
    var tipQuestion: String
    var tipAnswer: String
}

extension QuestTipResponseDTO {
    func toEntity() -> QuestTipDataEntity {
        .init(
            step: step,
            stepNumber: stepNumber,
            questNumber: questNumber,
            question: question,
            tips:tips.map { $0.toEntity() }
        )
    }
}

extension QuestTipDTO {
    func toEntity() -> QuestTipEntity {
        .init(
            tipStep: tipStep,
            tipQuestion: tipQuestion,
            tipAnswer: tipAnswer)
    }
}
