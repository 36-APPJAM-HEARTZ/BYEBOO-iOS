//
//  GetQuestInfoUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol GetQuestInfoUseCase {
    func execute(questId: Int) async throws -> QuestInfoEntity
}

struct DefaultGetQuestInfoUseCase: GetQuestInfoUseCase {
    private let questInfoReposiroty: GetQuestInfoInterface
    
    init(questInfoReposiroty: GetQuestInfoInterface) {
        self.questInfoReposiroty = questInfoReposiroty
    }
    
    func execute(questId: Int) async throws -> QuestInfoEntity {
        try await questInfoReposiroty.execute(questID: questId)
    }
}
