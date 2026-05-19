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
//    let likeCount: Int
//    let commentCount: Int
//    let isLiked: Bool
    let answerId: Int
//    let userId: Int
//    let writerId: String
    let writer: String
    let writerId: Int
    let profileIcon: String
    let writtenAt: String
    let content: String
}

extension CommonQuestAnswersResponseDTO {
    func toEntity(userName: String) -> CommonQuestAnswersEntity {
        .init(
            question: question,
            questID: questId,
            answerCount: answerCount,
            isAnswered: isAnswered,
            hasNext: hasNext,
            nextCursor: nil,
            answers: answers.map { $0.toEntity(userName: userName) }
        )
    }
}

extension CommonQuestAnswerResponseDTO {
    func toEntity(userName: String) -> CommonQuestAnswerEntity {
        .init(
//            isMyAnswer: userName == writerId ? true : false,
//            answerID: answerId,
//            writerID: writerId,
//            profileIcon: profileIcon,
//            writtenAt: writtenAt,
//            content: content,
//            userID: userId,
//            likeCount: likeCount,
//            commentCount: commentCount,
//            isLiked: isLiked
            isMyAnswer: userName == writer ? true : false,
            answerID: answerId,
            writerID: writer,
            profileIcon: profileIcon,
            writtenAt: writtenAt,
            content: content,
            userID: writerId,
            likeCount: 3,
            commentCount: 4,
            isLiked: false,
        )
    }
}
