//
//  FetchCommonQuestByDateUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

protocol FetchCommonQuestByDateUseCase {
    func execute(date: String) async throws -> CommonQuestAnswersEntity
}

struct DefaultFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(date: String) async throws -> CommonQuestAnswersEntity {
        try await repository.fetchCommoncQuest(date: date)
    }
}

struct MockFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    func execute(date: String) async throws -> CommonQuestAnswersEntity {
        .stub()
    }
}
