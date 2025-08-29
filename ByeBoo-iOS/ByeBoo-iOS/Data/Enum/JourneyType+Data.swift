//
//  JourneyType+Data.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension JourneyType {
    var key: String {
        switch self {
        case .face:
            "FACE_EMOTION"
        case .process:
            "PROCESS_EMOTION"
        }
    }
    
    static func keyToEnum(_ key: String) -> Self? {
        return Self.allCases.first { $0.key == key }
    }
}
