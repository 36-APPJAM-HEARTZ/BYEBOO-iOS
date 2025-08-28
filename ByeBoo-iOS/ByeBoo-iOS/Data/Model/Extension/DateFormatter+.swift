//
//  DateFormatter+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/28/25.
//

import Foundation

extension DateFormatter {
    
    private static let serverTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    private static let standardIdentifier = "en_US_POSIX"
    
    static func formatTime(string: String?) -> Date? {
        let formatter = DateFormatter()
        formatter.do {
            $0.dateFormat = serverTimeFormat
            $0.locale = Locale(identifier: standardIdentifier)
            $0.timeZone = TimeZone(secondsFromGMT: 0)
        }
        
        return string.flatMap { formatter.date(from: $0) }
    }
}
