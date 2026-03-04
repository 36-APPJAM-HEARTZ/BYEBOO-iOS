//
//  FetchAIAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 3/3/26.
//

protocol FetchAIAnswerUseCase {
    func execute(questID: Int, isAnswerExists: Bool) async throws -> AIAnswerEntity
}

struct DefaultFetchAIAnswerUseCase: FetchAIAnswerUseCase {
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(questID: Int, isAnswerExists: Bool) async throws -> AIAnswerEntity {
        try await repository.fetchAIAnswer(questID: questID, isAnswerExists: isAnswerExists)
    }
}
