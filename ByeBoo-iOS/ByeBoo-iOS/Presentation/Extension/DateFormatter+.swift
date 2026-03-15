//
//  DateFormatter+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Foundation

extension DateFormatter {
    
    private static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter
    }()
    
    private static let APIDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private static let detailDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
    
    static func toAPIDateString(from date: Date) -> String {
        DateFormatter.APIDate.string(from: date)
    }
    
    static func toDisplayDateString(from date: Date) -> String {
        DateFormatter.displayDate.string(from: date)
    }
    
    static func toDetailDate(from string: String) -> Date? {
        DateFormatter.detailDate.date(from: string)
    }
}
