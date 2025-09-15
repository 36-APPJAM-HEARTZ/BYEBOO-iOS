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
    let questOpenTime: Date?
    let currentTime: Date?
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
    let questStyle: QuestType
    let questNumber: Int
}

extension ProgressingQuestsEntity {
        
    static func stub() -> Self {
        return .init(
            progressPeriod: 30,
            currentStep: 30,
            questOpenTime: nil,
            currentTime: nil,
            steps: (1...5).map { step in
                StepEntity.stub(stepNumber: step)
            }
        )
    }
}

extension StepEntity {
    
    static func stub(stepNumber: Int) -> Self {
        let startIndex = (stepNumber - 1) * 6
        return .init(
            stepNumber: stepNumber,
            step: stepName(for: stepNumber),
            quests: (0..<6).map { i in
                QuestEntity.stub(index: startIndex + i)
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
            questId: index,
            question: "무슨 일이 있었나요?",
            questStyle: .question,
            questNumber: index + 1
        )
    }
}
