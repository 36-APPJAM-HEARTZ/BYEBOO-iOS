//
//  ProgressingQuestsResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

import Foundation

struct ProgressingQuestsResponseDTO: Decodable {
    let progressPeriod: Int
    let currentStep: Int
    let questOpenTime: Date?
    let currentTime: Date?
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
    let questStyle: String
    let questNumber: Int
}

extension ProgressingQuestsResponseDTO {
    func toEntity() -> ProgressingQuestsEntity {
        .init(
            progressPeriod: progressPeriod,
            currentStep: currentStep,
            questOpenTime: questOpenTime,
            currentTime: currentTime,
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
            questStyle: questStyle,
            questNumber: questNumber
        )
    }
}
