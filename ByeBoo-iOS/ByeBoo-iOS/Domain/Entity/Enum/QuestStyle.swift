//
//  Untitled.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

enum QuestStyle: CaseIterable {
    case recording
    case active
    
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


extension QuestStyle {
    static func toString(questType: String) -> String {
        switch questType {
        case QuestStyle.recording.key:
            return QuestStyle.recording.text
        case QuestStyle.active.key:
            return QuestStyle.active.text
        default:
            return ""
        }
    }
}
