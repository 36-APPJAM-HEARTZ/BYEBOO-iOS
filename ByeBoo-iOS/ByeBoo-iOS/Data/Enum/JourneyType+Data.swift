//
//  JourneyType+Data.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

extension JourneyType {
    static func toServerKey(_ rawValue: String) -> String {
        switch rawValue {
        case "감정 직면":
            return "FACE_EMOTION"
        case "감정 정리":
            return "PROCESS_EMOTION"
        default:
            return ""
        }
    }
}
