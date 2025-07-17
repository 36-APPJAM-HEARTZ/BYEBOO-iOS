//
//  QuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

protocol QuestAnswerUseCase {
    func execute(questID: Int) async throws -> QuestAnswerEntity
}

struct DefaultQuestAnswerUseCase: QuestAnswerUseCase {
    private let questAnswerRepository: QuestsInterface
    
    init(questAnswerRepository: QuestsInterface) {
        self.questAnswerRepository = questAnswerRepository
    }
    
    func execute(questID: Int) async throws -> QuestAnswerEntity {
        return try await questAnswerRepository.fetchQuestAnswer(questID: questID)
    }
}
