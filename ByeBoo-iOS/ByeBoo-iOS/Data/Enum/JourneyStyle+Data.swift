//
//  JoutneyStyle+Data.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension JourneyStyle {
    static func toEnum(_ data: String) -> JourneyStyle {
        switch data {
        case "ACTIVE":
            return .active
        case "RECORDING":
            return .recording
        default :
            return .active
        }
    }
}
