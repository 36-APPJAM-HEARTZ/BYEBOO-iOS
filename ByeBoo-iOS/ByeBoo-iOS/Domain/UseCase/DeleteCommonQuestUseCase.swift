//
//  DeleteCommonQuestUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 3/10/26.
//

protocol DeleteCommonQuestUseCase {
    func execute(answerID: Int) async throws
}

struct DefaultDeleteCommonQuestUseCase: DeleteCommonQuestUseCase {
    
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(answerID: Int) async throws {
        try await repository.deleteCommonQuest(answerID: answerID)
    }
}
