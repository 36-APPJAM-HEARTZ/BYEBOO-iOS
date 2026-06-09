//
//  CommonQuestMyAnswersResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 3/6/26.
//

struct CommonQuestMyAnswersResponseDTO: Decodable {
    let hasNext: Bool
    let nextCursor: Int?
    let answers: [CommonQuestMyAnswerResponseDTO]
}

struct CommonQuestMyAnswerResponseDTO: Decodable {
    let answerId: Int
    let writtenAt: String
    let content: String
    let question: String
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
}

extension CommonQuestMyAnswersResponseDTO {
    func toEntity(userName: String) -> CommonQuestMyAnswersEntity {
        .init(
            hasNext: hasNext,
            nextCursor: nextCursor,
            answers: answers.map { $0.toEntity(userName: userName)
            })
    }
}

extension CommonQuestMyAnswerResponseDTO {
    func toEntity(userName: String) -> CommonQuestMyAnswerEntity {
        .init(
            answerID: answerId,
            writtenAt: writtenAt,
            content: content,
            question: question,
            nickname: userName,
            isLiked: false,
            likeCount: likeCount,
            commentCount: commentCount
        )
    }
}
