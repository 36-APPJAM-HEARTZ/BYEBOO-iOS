//
//  QuestType+Data.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/29/25.
//

import Foundation

extension QuestType {
    var key: String {
        switch self {
        case .question:
            "RECORDING"
        case .activation:
            "ACTIVE"
        }
    }
    
    static func keyToEnum(_ key: String) -> Self? {
        return Self.allCases.first { $0.key == key }
    }
}
