//
//  JourneyType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/27/25.
//

import Foundation

// 여정의 타입: 이별 극복, 재회 준비

enum JourneyType: CaseIterable {
    case recording
    case active
    case reunion
}

extension JourneyType {
    var mixpanelKey: String {
        switch self {
        case .recording:
            "이별 극복"
        case .active:
            "감정 정리"
        case .reunion:
            "재회 준비"
        }
    }
}
