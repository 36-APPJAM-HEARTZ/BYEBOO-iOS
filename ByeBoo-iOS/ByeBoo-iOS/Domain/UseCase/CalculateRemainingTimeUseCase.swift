//
//  CalculateRemainingTimeUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/28/25.
//

import Foundation

protocol CalculateRemainingTimeUseCase {
    
    func calculateRemainingTime(questOpenTime: Date, currentTime: Date) -> Int
    func formatRemainingTime(seconds: Int) -> String
}

struct DefaultCalculateRemainingTimeUseCase: CalculateRemainingTimeUseCase {
    
    func calculateRemainingTime(questOpenTime: Date, currentTime: Date) -> Int {
        let timeInterval = Int(questOpenTime.timeIntervalSince(currentTime))
        return max(0, timeInterval)
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
