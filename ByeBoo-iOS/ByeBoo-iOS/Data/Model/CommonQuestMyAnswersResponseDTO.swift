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
            likeCount: 2,
            commentCount: 3 // TODO: 서버수정되면 수정하기
        )
    }
}
