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
    let replies: [CommonQuestAnswerReplyResponseDTO]
}

struct CommonQuestAnswerCommentResponseDTO: Decodable {
    let content: String
    let writer: String
    let createdAt: String
    let profileIcon: String
    let commentId: Int
    let writerId: Int
}

struct CommonQuestAnswerReplyResponseDTO: Decodable {
    let content: String
    let writer: String
    let createdAt: String
    let profileIcon: String
    let commentId: Int
    let writerId: Int
}

extension CommonQuestAnswerRepliesResponseDTO {
    func toEntity() -> [CommonQuestCommentEntity] {
        replies.map {
            $0.toEntity()
        }
    }
}

extension CommonQuestAnswerReplyResponseDTO {
    func toEntity() -> CommonQuestCommentEntity {
        .init(
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
