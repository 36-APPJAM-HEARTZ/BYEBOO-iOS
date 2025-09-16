//
//  JourneyType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/27/25.
//

import Foundation

// 여정의 타입: 감정 직면형, 감정 정리형

enum JourneyType: CaseIterable {
    case face
    case process
}

extension JourneyType {
    var mixpanelKey: String {
        switch self {
        case .face:
            "감정 직면"
        case .process:
            "감정 정리"
        }
    }
}
