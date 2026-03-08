//
//  CommonQuestMyAnswersEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 3/6/26.
//

import Foundation

struct CommonQuestMyAnswersEntity {
    let hasNext: Bool
    let nextCursor: Int?
    let answers: [CommonQuestMyAnswerEntity]
}

struct CommonQuestMyAnswerEntity {
    let answerID: Int
    let writtenAt: String
    let content: String
    let question: String
}

extension CommonQuestMyAnswersEntity {
    
    static let allAnswers: [CommonQuestMyAnswerEntity] = (1...30).map {
        CommonQuestMyAnswerEntity(
            answerID: $0,
            writtenAt: Date.now.toString(),
            content: "\($0)번째 테스트 답변",
            question: "\($0)번째 질문"
        )
    }
    
    static func emptyAnswerStub() -> Self {
        .init(
            hasNext: false,
            nextCursor: nil,
            answers: []
        )
    }
    static func stub() -> Self {
        .init(hasNext: true, nextCursor: 5, answers: CommonQuestMyAnswerEntity.stubs())
    }
}

extension CommonQuestMyAnswerEntity {
    
    static func stubs() -> [Self] {
        [
            .init(answerID: 1, writtenAt: "2025-01-11", content: "content", question: "question"),
            .init(answerID: 2, writtenAt: "2025-01-12", content: "content", question: "question"),
            .init(answerID: 3, writtenAt: "2025-01-13", content: "content", question: "question"),
            .init(answerID: 4, writtenAt: "2025-01-14", content: "content", question: "question")
        ]
    }
}
