//
//  QuestStyle+Presentation.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension JourneyStyle {
    var key: String {
        switch self {
        case .recording:
            return "RECORDING"
        case .active:
            return "ACTIVE"
        }
    }
    
    var text: String {
        switch self {
        case .recording:
            return "질문형"
        case .active:
            return "행동형"
        }
    }
}
