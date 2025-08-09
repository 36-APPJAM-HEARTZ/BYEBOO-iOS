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
            steps: (1...5).map { StepEntity.stub(stepNumber: $0) }
        )
    }
}

extension StepEntity {
    
    static func stub(stepNumber: Int) -> Self {
        return .init(
            stepNumber: stepNumber,
            step: stepName(for: stepNumber),
            quests: (1...6).map { _ in
                QuestEntity.stub(index: (stepNumber))
            }
        )
    }
    
    private static func stepName(for number: Int) -> String {
        switch number {
        case 1: return "마음 깨우기"
        case 2: return "혼자 있는 힘 기르기"
        case 3: return "감정에 이름 붙이기"
        case 4: return "혼자 있는 힘 기르기"
        case 5: return "스스로에게 대접하기"
        default: return "단계 \(number)"
        }
    }
}

extension QuestEntity {
    
    static func stub(index: Int) -> Self {
        return .init(
            questId: 30 + index,
            question: "무슨 일이 있었나요?",
            questStyle: "RECORDING",
            questNumber: index
        )
    }
}
