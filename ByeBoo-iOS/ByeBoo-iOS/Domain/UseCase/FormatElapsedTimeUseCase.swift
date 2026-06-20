//
//  FormatElapsedTimeUseCase.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/7/26.
//

import Foundation

protocol FormatElapsedTimeUseCase {
    func execute(from timeString: String) -> String?
}

struct DefaultFormatElapsedTimeUseCase: FormatElapsedTimeUseCase {
    
    private let minute: Double = 60
    private let hour: Double = 3600
    private let day: Double = 86400
    
    func execute(from timeString: String) -> String? {
        guard let time = DateFormatter.toDetailDate(from: timeString) else {
            return nil
        }
        
        let diffTime = Date().timeIntervalSince(time)
        
        switch diffTime {
        case ..<minute:
            return "방금 전"
        case minute..<hour:
            let minutes = Int(diffTime / minute)
            return "\(minutes)분 전"
        case hour..<day:
            let hours = Int(diffTime / hour)
            return "\(hours)시간 전"
        default:
            return DateFormatter.toDisplayDateString(from: time)
        }
    }
}
