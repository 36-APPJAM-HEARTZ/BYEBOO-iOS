//
//  QuestsEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

struct QuestsEntity {
    let progressPeriod: String
    let currentStep: Int
    let isCompleted: Bool
    let steps: [StepEntity]
}

struct StepEntity {
    let stepNumber: Int
    let step: String
    let quests: [QuestEntity]
}

struct QuestEntity {
    let questId: Int
    let questNumber: Int
}
