//
//  GetQuestInfoUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol GetQuestInfoUseCase {
    func execute(questID: Int) async throws -> QuestInfoEntity
}

struct DefaultGetQuestInfoUseCase: GetQuestInfoUseCase {
    private let questInfoReposiroty: QuestsInterface
    
    init(questInfoReposiroty: QuestsInterface) {
        self.questInfoReposiroty = questInfoReposiroty
    }
    
    func execute(questID: Int) async throws -> QuestInfoEntity {
        try await questInfoReposiroty.getQuestInfo(questID: questID)
    }
}
