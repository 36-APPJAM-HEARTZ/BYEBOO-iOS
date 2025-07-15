//
//  SaveQuestActiveUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

protocol SaveQuestActiveUseCase {
    func execute(questID: Int, answer: String, emotionState: String, image: Data, imageKey: String) async throws
}

struct DefaultSaveQuestActiveUseCase: SaveQuestActiveUseCase {
    private let questActiveRepository: SaveQuestActiveInterface
    
    init(questActiveRepository: SaveQuestActiveInterface) {
        self.questActiveRepository = questActiveRepository
    }
    
    func execute(questID: Int, answer: String, emotionState: String, image: Data, imageKey: String) async throws {
        try await questActiveRepository.postActiveQuest(
            questID: questID,
            answer: answer,
            emotionState: emotionState,
            image: image,
            imageKey: imageKey
        )
    }
}
