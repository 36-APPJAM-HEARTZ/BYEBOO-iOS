//
//  DateFormatter+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/28/25.
//

import Foundation

final class ServerDateFormatter {
    
    static let shared = ServerDateFormatter()
    private let formatter: DateFormatter
    
    private static let minute: TimeInterval = 60
    private static let hour: TimeInterval = 3600
    private static let day: TimeInterval = 86400
    
    private init() {
        self.formatter = DateFormatter()
        formatter.do {
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            $0.locale = Locale(identifier: "en_US_POSIX")
            $0.timeZone = TimeZone(secondsFromGMT: 0)
        }
    }
    
    func formatDate(string: String?) -> Date? {
        guard let string = string else { return nil }
        return formatter.date(from: string)
    }
    
    func relativeTimeString(from dateString: String) -> String? {
        guard let date = formatter.date(from: dateString) else { return nil }
        
        let diff = Date().timeIntervalSince(date)
        
        switch diff {
        case ..<Self.minute:
            return "방금 전"
        case Self.minute..<Self.hour:
            let minutes = Int(diff / Self.minute)
            return "\(minutes)분 전"
        case Self.hour..<Self.day:
            let hours = Int(diff / Self.hour)
            return "\(hours)시간 전"
        default:
            return DateFormatter.toDisplayDateString(from: date)
        }
    }
}
