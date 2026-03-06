//
//  CommonQuestAnswersDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/28/26.
//

struct CommonQuestAnswersResponseDTO: Decodable {
    let question: String
    let isAnswered: Bool
    let answerCount: Int
    let answers: [CommonQuestAnswerResponseDTO]
    let hasNext: Bool
    let nextCursor: Int?
    let questId: Int
}

struct CommonQuestAnswerResponseDTO: Decodable {
    let answerId: Int
    let writer: String
    let profileIcon: String
    let writtenAt: String
    let content: String
}

extension CommonQuestAnswersResponseDTO {
    func toEntity() -> CommonQuestAnswersEntity {
        .init(
            question: question,
            questID: questId,
            answerCount: answerCount,
            isAnswered: isAnswered,
            hasNext: hasNext,
            nextCursor: nil,
            answers: answers.map { $0.toEntity() }
        )
    }
}

extension CommonQuestAnswerResponseDTO {
    func toEntity() -> CommonQuestAnswerEntity {
        .init(
            answerID: answerId,
            writer: writer,
            profileIcon: profileIcon,
            writtenAt: writtenAt,
            content: content
        )
    }
}
