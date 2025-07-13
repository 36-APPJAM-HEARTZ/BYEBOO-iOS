//
//  QuestInfoResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct QuestInfoResponseDTO: Decodable {
    var step: String
    var stepNumber: Int
    var questNumber: Int
    var questStyle: String
    var question: String
}

extension QuestInfoResponseDTO {
    func toEntity() -> QuestInfoEntity {
        QuestInfoEntity(
            step: step,
            stepNumber: stepNumber,
            questNumber: questNumber,
            questStyle: questStyle,
            question: question
        )
    }
}
