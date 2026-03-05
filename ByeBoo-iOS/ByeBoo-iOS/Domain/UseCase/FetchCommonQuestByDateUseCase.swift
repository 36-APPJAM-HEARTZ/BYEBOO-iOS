//
//  FetchCommonQuestByDateUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

protocol FetchCommonQuestByDateUseCase {
    func execute(
        date: String,
        answerID: Int?,
        limit: Int
    ) async throws -> CommonQuestAnswersEntity
}

struct DefaultFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(
        date: String,
        answerID: Int?,
        limit: Int
    ) async throws -> CommonQuestAnswersEntity {
        try await repository.fetchCommonQuest(
            date: date,
            answerID: answerID,
            limit: limit
        )
    }
}

struct MockFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    func execute(
        date: String,
        answerID: Int?,
        limit: Int
    ) async throws -> CommonQuestAnswersEntity {
        .stub()
    }
}
