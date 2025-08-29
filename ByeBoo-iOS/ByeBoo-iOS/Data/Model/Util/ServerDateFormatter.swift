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
}
