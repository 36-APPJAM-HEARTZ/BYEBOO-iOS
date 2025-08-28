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
    let questOpenTime: String?
    let currentTime: String?
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
        return .init(
            progressPeriod: progressPeriod,
            currentStep: currentStep,
            questOpenTime: DateFormatter.formatTime(string: questOpenTime),
            currentTime: DateFormatter.formatTime(string: currentTime),
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
