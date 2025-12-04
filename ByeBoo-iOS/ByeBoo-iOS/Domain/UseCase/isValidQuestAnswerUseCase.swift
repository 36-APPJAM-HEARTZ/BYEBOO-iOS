//
//  isValidQuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 12/4/25.
//

import Foundation

protocol IsValidQuestAnswerUseCase {
    func execute(previousText: String, changingText: String) -> Bool
}

struct DefaultIsValidQuestAnswerUseCase: IsValidQuestAnswerUseCase {
    func execute(previousText: String, changingText: String) -> Bool {
        if previousText.isEmpty {
            if isValidAnswerText(text: changingText) {
                return true
            } else {
                return false
            }
        } else {
            if previousText != changingText && isValidAnswerText(text: changingText) {
                return true
            } else {
                return false
            }
        }
    }
    
    private func isValidAnswerText(text: String) -> Bool {
        if (text.count >= 10) && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        } else {
            return false
        }
    }
}
