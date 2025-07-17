//
//  SaveQuestTypeUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol SaveQuestTypeUseCase {
    func execute(questID: Int, answer: String, emotionState: String) async throws
}

struct DefaultSaveQuestTypeUseCase: SaveQuestTypeUseCase {
    private let repqository: QuestsInterface
    
    init(repqository: QuestsInterface) {
        self.repqository = repqository
    }
    
    func execute(questID: Int, answer: String, emotionState: String) async throws {
        try await repqository.postQuestionQuest(questID: questID, answer: answer, emotionState: emotionState)
    }
}
