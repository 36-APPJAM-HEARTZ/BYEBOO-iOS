//
//  QuestTipEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

struct QuestTipDataEntity {
    let step: String
    let stepNumber: Int
    let questNumber: Int
    let question: String
    let tips: [QuestTipEntity]
}

struct QuestTipEntity {
    let tipStep: Int
    let tipAnswer: String
}

extension QuestTipDataEntity: Equatable {
    static func stub() -> QuestTipDataEntity {
        return .init(
            step: "감정 정리하기",
            stepNumber: 1,
            questNumber: 10,
            question: "연애에서 반복됐던 문제 패턴 3가지를 생각해보아요.",
            tips: QuestTipEntity.stub()
        )
    }
}

extension QuestTipEntity: Equatable {
    static func stub() -> [QuestTipEntity] {
        return [
            .init(
                tipStep: 1,
                tipAnswer: "그 사람의 눈치를 보느라 하고 싶은 걸 억누르고 참았던 적이 있지 않나요? 하지만 이제는, 더 이상 맞춰줄 필요 없어요. 내 마음대로, 나답게 생각해도 되는 시간이에요. 억눌렀던 마음을 천천히 꺼내 보면서, 잃어버렸던 ‘진짜 나’를 다시 찾아가봐요."
            ),
            .init(
                tipStep: 2,
                tipAnswer: "그 사람이 싫어해서 참았던 말투, 옷차림, 취미는 무엇이었나요? 해보고 싶었지만, 싸우게 될까봐 망설였던 건요?"
            ),
            .init(
                tipStep: 3,
                tipAnswer: "관계 속에서 잃었던 나의 일부를 다시 인식하게 돼요. 내가 어떤 부분에서 억눌려 있었는지 알게 돼요. 앞으로 어떤 걸 자유롭게 선택할 수 있는지 알게 돼요."
            )
        ]
    }
}
