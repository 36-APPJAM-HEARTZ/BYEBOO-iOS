//
//  QuestType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import Foundation

enum QuestType {
    case question
    case activation
    
    var plaeholder: String {
        switch self {
        case .question:
            return "글로 적다 보면, 스스로에게 한 걸음 더 가까워질 수 있어요."
        case .activation:
            return "꼭 적지 않아도 괜찮지만, 글로 정리해 보면 스스로에게 한 걸음 더 가까워질 수 있어요."
        }
    }
    
    var textLimit: Int {
        switch self {
        case .question:
            return 500
        case .activation:
            return 200
        }
    }
}
