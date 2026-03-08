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
        let limit = 10
        let startIndex: Int
        let allAnswers = CommonQuestMyAnswersEntity.allAnswers
        
        if let cursor {
            let cursorIndex = allAnswers.firstIndex { $0.answerID == cursor } ?? -1
            startIndex = cursorIndex + 1
        } else {
            startIndex = 0
        }
        
        let endIndex = min(startIndex + limit, allAnswers.count)
        guard startIndex < allAnswers.count else {
            return .emptyAnswerStub()
        }
        
        let limitedAnswer = Array(allAnswers[startIndex..<endIndex])
        let hasNext = endIndex < allAnswers.count
        let nextCursor = hasNext ? limitedAnswer.last?.answerID : nil
        
        return .init(
            hasNext: hasNext,
            nextCursor: nextCursor,
            answers: limitedAnswer
        )
    }
}
