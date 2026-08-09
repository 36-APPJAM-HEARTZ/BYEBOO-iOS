//
//  CommonQuestAnswerRepliesResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Foundation

struct CommonQuestAnswerRepliesResponseDTO: Decodable {
    let totalCount: Int
    let comment: CommonQuestAnswerCommentResponseDTO
    let replies: [CommonQuestAnswerCommentResponseDTO]
}

struct CommonQuestAnswerCommentResponseDTO: Decodable {
    let content: String
    let writer: String
    let createdAt: String
    let profileIcon: String
    let commentId: Int
    let writerId: Int
}

extension CommonQuestAnswerRepliesResponseDTO {
    func toEntity(userID: Int) -> CommonQuestReplyListEntity {
        .init(
            totalCount: totalCount,
            replies: replies.map { $0.toEntity(userID: userID) }
        )
    }
}

extension CommonQuestAnswerCommentResponseDTO {
    func toEntity(userID: Int) -> CommonQuestCommentEntity {
        .init(
            isMyComment: userID == writerId ? true : false,
            commentID: commentId,
            replyCount: nil,
            writerID: writerId,
            writer: writer,
            profileIcon: profileIcon,
            writtenAt: createdAt,
            content: content
        )
    }
}
