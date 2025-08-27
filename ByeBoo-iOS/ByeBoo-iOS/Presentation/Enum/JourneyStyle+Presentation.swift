//
//  QuestStyle+Presentation.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

// TODO: Journey Type으로 교체
extension SelectQuestType {
    var text: String {
        switch self {
        case .recording:
            return "질문형"
        case .active:
            return "행동형"
        }
    }
}
