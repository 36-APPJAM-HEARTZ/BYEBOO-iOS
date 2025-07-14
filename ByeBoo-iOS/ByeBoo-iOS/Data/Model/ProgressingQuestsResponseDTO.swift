//
//  ProgressingQuestsResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

import Foundation

struct ProgressingQuestsResponseDTO: Decodable {
    let progressPeriod: String
    let currentStep: Int
    let steps: [StepResponseDTO]
}

struct StepResponseDTO: Decodable {
    let stepNumber: Int
    let step: String
    let quests: [QuestResponseDTO]
}

struct QuestResponseDTO: Decodable {
    let questId: Int
    let question: String
    let questNumber: Int
}

extension ProgressingQuestsResponseDTO {
    func toEntity() -> ProgressingQuestsEntity {
        .init(
            progressPeriod: progressPeriod,
            currentStep: currentStep,
            steps: steps.map { $0.toEntity() }
        )
    }
}

extension StepResponseDTO {
    func toEntity() -> StepEntity {
        return .init(
            stepNumber: stepNumber,
            step: step,
            quests: quests.map { $0.toEntity() }
        )
    }
}

extension QuestResponseDTO {
    func toEntity() -> QuestEntity {
        return .init(
            questId: questId,
            question: question,
            questNumber: questNumber
        )
    }
}
