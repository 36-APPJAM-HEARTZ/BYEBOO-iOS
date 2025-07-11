//
//  QuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

protocol QuestAnswerUseCase {
    func fetchQuestAnswer() async throws -> QuestAnswerEntity
}

struct DefaultQuestAnswerUseCase: QuestAnswerUseCase {
    private let questAnswerRepository: QuestAnswerInterface
    
    init(questAnswerRepository: QuestAnswerInterface) {
        self.questAnswerRepository = questAnswerRepository
    }
    
    func fetchQuestAnswer() async throws -> QuestAnswerEntity {
        return try await questAnswerRepository.fetchQuestAnswer()
    }
}
