//
//  DateFormatter+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Foundation

extension DateFormatter {
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd."
        return formatter
    }()
    
    static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let detailDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssSSS"
        return formatter
    }()
}
