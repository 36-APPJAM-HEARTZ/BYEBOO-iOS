//
//  QuestStyle+Presentation.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

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
