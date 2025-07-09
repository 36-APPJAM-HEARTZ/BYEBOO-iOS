//
//  EmotionState.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

enum EmotionState: Encodable, CaseIterable {
    case exhausted
    case recovering
    case overcoming
    
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
