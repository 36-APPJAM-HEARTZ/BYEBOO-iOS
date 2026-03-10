//
//  JoutneyStyle+Data.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension SelectQuestType {
    var key: String {
        switch self {
        case .recording:
            "RECORDING"
        case .reunion:
            "REUNION"
        }
    }
    
    static func keyToEnum(_ key: String) -> Self? {
        return Self.allCases.first { $0.key == key }
    }
}
