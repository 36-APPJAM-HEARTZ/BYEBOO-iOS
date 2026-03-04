//
//  SaveCommonQuestUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/3/26.
//

import Foundation

protocol SaveCommonQuestUseCase {
    func execute(questID: Int, answer: String) async throws
}

struct DefaultSaveCommonQuestUseCase: SaveCommonQuestUseCase {
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(questID: Int, answer: String) async throws {
        try await repository.saveCommonQuest(questID: questID, answer: answer)
    }
}
