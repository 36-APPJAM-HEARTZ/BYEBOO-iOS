//
//  QuestsEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Foundation

struct ProgressingQuestsEntity {
    let progressPeriod: Int
    let currentStep: Int
    let steps: [StepEntity]
}

struct StepEntity {
    let stepNumber: Int
    let step: String
    let quests: [QuestEntity]
}

struct QuestEntity {
    let questId: Int
    let question: String
    let questStyle: String
    let questNumber: Int
}

extension ProgressingQuestsEntity {
    
    static func stub() -> Self {
        return .init(
            progressPeriod: 1,
            currentStep: 1,
            steps: [StepEntity.stub()]
        )
    }
}

extension StepEntity {
    
    static func stub() -> Self {
        return .init(
            stepNumber: 1,
            step: "감정 쏟아내기",
            quests: [QuestEntity.stub()]
        )
    }
}

extension QuestEntity {
    
    static func stub() -> Self {
        return .init(
            questId: 31,
            question: "무슨 일이 있었나요?",
            questStyle: "RECORDING",
            questNumber: 1
        )
    }
}
