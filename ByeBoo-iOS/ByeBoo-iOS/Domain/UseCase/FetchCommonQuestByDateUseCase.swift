//
//  FetchCommonQuestByDateUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

protocol FetchCommonQuestByDateUseCase {
    func execute(
        date: String,
        cursor: Int?
    ) async throws -> CommonQuestAnswersEntity
}

struct DefaultFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(
        date: String,
        cursor: Int?
    ) async throws -> CommonQuestAnswersEntity {
        try await repository.fetchCommonQuest(
            date: date,
            cursor: cursor
        )
    }
}

struct MockFetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase {
    
    func execute(
        date: String,
        cursor: Int?
    ) async throws -> CommonQuestAnswersEntity {
        let limit = 10
        let startIndex: Int
        let allAnswers = CommonQuestAnswersEntity.allAnswers
        
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
            question: "오늘 하루 어떤 감정을 가장 많이 느꼈나요?",
            questID: 1,
            answerCount: allAnswers.count,
            isAnswered: true,
            hasNext: hasNext,
            nextCursor: nextCursor,
            answers: limitedAnswer
        )
    }
}
