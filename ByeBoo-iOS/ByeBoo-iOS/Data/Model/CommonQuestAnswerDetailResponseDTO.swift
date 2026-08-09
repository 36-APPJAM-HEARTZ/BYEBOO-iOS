//
//  CommonQuestAnswerDetailResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Foundation

struct CommonQuestAnswerDetailResponseDTO: Decodable {
    let question: String
    let answer: CommonQuestAnswerSimpleResponseDTO
    let comments: [CommonQuestCommentResponseDTO]
}

struct CommonQuestAnswerSimpleResponseDTO: Decodable {
    let content: String
    let writerId: Int
    let writer: String
    let profileIcon: String
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
    let writtenAt: String 
}

struct CommonQuestCommentResponseDTO: Decodable {
    let commentId: Int
    let replyCount: Int
    let writerId: Int
    let writer: String
    let profileIcon: String
    let writtenAt: String
    let content: String
}

extension CommonQuestAnswerDetailResponseDTO {
    func toEntity(userID: Int) -> CommonQuestDetailEntity {
        .init(
            question: question,
            answer: answer.toEntity(userID: userID),
            comments: comments.map { $0.toEntity(userID: userID) }
        )
    }
}

extension CommonQuestAnswerSimpleResponseDTO {
    func toEntity(userID: Int) -> CommonQuestAnswerDetailEntity {
        .init(
            isMyAnswer: userID == writerId ? true : false,
            content: content,
            writerID: writerId,
            writer: writer,
            profileIcon: profileIcon,
            likeCount: likeCount,
            commentCount: commentCount,
            isLiked: isLiked,
            writtenAt: writtenAt
        )
    }
}

extension CommonQuestCommentResponseDTO {
    func toEntity(userID: Int) -> CommonQuestCommentEntity {
        return .init(
            isMyComment: userID == writerId ? true : false,
            commentID: commentId,
            replyCount: replyCount,
            writerID: writerId,
            writer: writer,
            profileIcon: profileIcon,
            writtenAt: writtenAt,
            content: content
        )
    }
}
