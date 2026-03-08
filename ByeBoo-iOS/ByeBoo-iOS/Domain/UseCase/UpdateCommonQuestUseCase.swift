//
//  UpdateCommonQuestUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 3/7/26.
//

protocol UpdateCommonQuestUseCase {
    func execute(answerID: Int, answer: String) async throws
}

struct DefaultUpdateCommonQuestUseCase: UpdateCommonQuestUseCase {
    
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(answerID: Int, answer: String) async throws {
        try await repository.updateCommonQuest(answerID: answerID, answer: answer)
    }
}
