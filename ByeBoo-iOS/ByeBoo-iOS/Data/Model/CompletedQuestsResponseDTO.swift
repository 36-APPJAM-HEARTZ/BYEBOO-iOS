//
//  CompletedQuestsDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

struct CompletedQuestsResponseDTO: Decodable {
    let progressPeriod: String
    let currentStep: Int?
    let steps: [CompletedStepDTO]
}

struct CompletedStepDTO: Decodable {
    let stepNumber: Int
    let step: String
    let quests: [CompletedQuestDTO]
}

struct CompletedQuestDTO: Decodable {
    let questId: Int
    let question: String
    let questStyle: String
    let questNumber: Int
}

extension CompletedQuestsResponseDTO {
    func toEntity() -> CompletedQuestsEntity {
        .init(
            progressPeriod: "2025-08-28 ~ 2025-09-01",
            currentStep: nil,
            steps: steps.map { $0.toEntity() }
        )
    }
}

extension CompletedStepDTO {
    func toEntity() -> CompletedStepEntity {
        .init(
            stepNumber: stepNumber,
            step: step,
            quests: quests.map { $0.toEntity() }
        )
    }
}

extension CompletedQuestDTO {
    func toEntity() -> CompletedQuestEntity {
        .init(
            questId: questId,
            question: question,
            questStyle: QuestType.keyToEnum(questStyle) ?? .question,
            questNumber: questNumber
        )
    }
}
