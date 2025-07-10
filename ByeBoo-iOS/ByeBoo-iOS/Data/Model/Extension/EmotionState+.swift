//
//  EmotionState+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

extension EmotionState {
    var key: String {
        switch self {
        case .exhausted:
            return "EXHAUSTED"
        case .recovering:
            return "RECOVERING"
        case .overcoming:
            return "OVERCOMING"
        }
    }
}
