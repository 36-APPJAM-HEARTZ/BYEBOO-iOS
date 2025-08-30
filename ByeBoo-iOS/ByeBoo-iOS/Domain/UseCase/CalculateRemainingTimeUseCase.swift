//
//  CalculateRemainingTimeUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/28/25.
//

import Foundation

enum TimeConstant {
    static let secondPerHour = 3600
    static let secondPerMinute = 60
}

protocol CalculateRemainingTimeUseCase {
    
    func isQuestLocked(questOpenTime: Date?, currentTime: Date?) -> Bool
    func calculateRemainingTime(questOpenTime: Date?, currentTime: Date?) -> Int
}

struct DefaultCalculateRemainingTimeUseCase: CalculateRemainingTimeUseCase {
    
    func isQuestLocked(questOpenTime: Date?, currentTime: Date?) -> Bool {
        questOpenTime != nil && currentTime != nil
    }
    
    func calculateRemainingTime(questOpenTime: Date?, currentTime: Date?) -> Int {
        if let questOpenTime, let currentTime {
            let timeInterval = Int(questOpenTime.timeIntervalSince(currentTime))
            return max(0, timeInterval)
        }
        return 0
    }
}
