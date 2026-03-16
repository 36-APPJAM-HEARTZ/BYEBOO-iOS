//
//  Untitled.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

// 온보딩 시에 퀘스트 방식 선택

enum SelectQuestType: CaseIterable {
    case recording
    case reunion
}

extension SelectQuestType {
    var mixpanelKey: String {
        switch self {
        case .recording:
            "이별극복"
        case .reunion:
            "재회준비"
        }
    }
}
