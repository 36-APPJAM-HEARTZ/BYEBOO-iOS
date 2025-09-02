//
//  CompletedQuestsEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

struct CompletedQuestsEntity {
    let progressPeriod: String
    let currentStep: Int?
    let steps: [CompletedStepEntity]
}

struct CompletedStepEntity {
    let stepNumber: Int
    let step: String
    let quests: [CompletedQuestEntity]
}

struct CompletedQuestEntity {
    let questId: Int
    let question: String
    let questStyle: QuestType
    let questNumber: Int
}

extension CompletedQuestsEntity {
        
    static func stub() -> Self {
        return .init(
            progressPeriod: "2025-08-28 ~ 2025-09-01",
            currentStep: nil,
            steps: (1...5).map { step in
                CompletedStepEntity.stub(stepNumber: step)
            }
        )
    }
}

extension CompletedStepEntity {
    
    static func stub(stepNumber: Int) -> Self {
        let startIndex = (stepNumber - 1) * 6
        return .init(
            stepNumber: stepNumber,
            step: stepName(for: stepNumber),
            quests: (0..<6).map { i in
                CompletedQuestEntity.stub(index: startIndex + i)
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

extension CompletedQuestEntity {
    
    static func stub(index: Int) -> Self {
        return .init(
            questId: index,
            question: "무슨 일이 있었나요?",
            questStyle: .question,
            questNumber: index + 1
        )
    }
}
