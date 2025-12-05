//
//  isValidQuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 12/4/25.
//

import Foundation

protocol IsValidQuestAnswerUseCase {
    func executeWhenQuestionType(previousText: String, changingText: String) -> Bool
}

struct DefaultIsValidQuestAnswerUseCase: IsValidQuestAnswerUseCase {
    func executeWhenQuestionType(previousText: String, changingText: String) -> Bool {
        switch previousText.isEmpty {
        case true:
            let isValidAnswer: Bool = isValidAnswerText(text: changingText)
            return isValidAnswer
        case false:
            let isValidAnswer: Bool = previousText != changingText && isValidAnswerText(text: changingText)
            return isValidAnswer
        }
    }
    
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
