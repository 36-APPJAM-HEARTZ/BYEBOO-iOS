//
//  JourneyType+Data.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension JourneyType {
    var responseKey: String {
        switch self {
        case .recording:
            "RECORDING"
        case .active:
            "ACTIVE"
        case .reunion:
            "REUNION"
        }
    }
    
    var requestKey: String {
        switch self {
        case .recording:
            "FACE_EMOTION"
        case .active:
            "PROCESS_EMOTION"
        case .reunion:
            "PREPARE_REUNION"
        }
    }
    
    static func responseKeyToEnum(_ key: String) -> Self? {
        return Self.allCases.first { $0.responseKey == key }
    }
}
