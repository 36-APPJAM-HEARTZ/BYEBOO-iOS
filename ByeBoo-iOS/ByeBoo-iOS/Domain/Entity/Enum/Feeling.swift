//
//  Feeling.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

enum Feeling: CaseIterable {
    case exhausted
    case recovering
    case overcoming
}

extension Feeling {
    var mixpanelKey: String {
        switch self {
        case .exhausted:
            "너무 힘들어요"
        case .recovering:
            "극복 중이에요"
        case .overcoming:
            "꽤 극복했어요"
        }
    }
}
