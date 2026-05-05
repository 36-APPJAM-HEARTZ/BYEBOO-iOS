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
        if isAnswerExists {
            return try await repository.fetchAIAnswer(questID: questID)
        } else {
            return try await repository.createAIAnswer(questID: questID)
        }
    }
}
