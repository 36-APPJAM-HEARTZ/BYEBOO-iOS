//
//  QuestTipUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

protocol QuestTipUseCase {
    func fetchQuestTips() async throws -> QuestTipDataEntity
}

struct DefaultQuestTipUseCase: QuestTipUseCase {
    private let questTipRepository: QuestTipInterface
    
    init(questTipRepository: QuestTipInterface) {
        self.questTipRepository = questTipRepository
    }
    
    func fetchQuestTips() async throws -> QuestTipDataEntity {
        return try await questTipRepository.fetchQeustTips()
    }
}

