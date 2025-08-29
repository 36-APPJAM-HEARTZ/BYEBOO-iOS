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
    func formatRemainingTime(seconds: Int) -> String
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
    
    func formatRemainingTime(seconds: Int) -> String {
        let hours = calculateHours(seconds: seconds)
        let minutes = calculateMinutes(seconds: seconds)
        let remainingTime = formatTime(hours, minutes)
        return remainingTime
    }
    
    private func calculateHours(seconds: Int) -> Int {
        seconds / TimeConstant.secondPerHour
    }
    
    private func calculateMinutes(seconds: Int) -> Int {
        (seconds % TimeConstant.secondPerHour) / TimeConstant.secondPerMinute
    }
    
    private func formatTime(_ hours: Int, _ minutes: Int) -> String {
        String(format: "%02d:%02d", hours, minutes)
    }
}
