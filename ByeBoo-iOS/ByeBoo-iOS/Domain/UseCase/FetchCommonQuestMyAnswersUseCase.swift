//
//  FetchCommonQuestMyAnswersUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 3/6/26.
//

protocol FetchCommonQuestMyAnswersUseCase {
    func execute(cursor: Int?) async throws -> CommonQuestMyAnswersEntity
}

struct DefaultFetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(cursor: Int?) async throws -> CommonQuestMyAnswersEntity {
        try await repository.fetchMyCommonQuestAnswers(cursor: cursor)
    }
}

struct MockFetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase {
    
    func execute(cursor: Int?) async throws -> CommonQuestMyAnswersEntity {
        .stub()
    }
}
