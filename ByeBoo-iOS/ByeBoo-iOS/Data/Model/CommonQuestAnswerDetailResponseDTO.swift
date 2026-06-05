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
    func toEntity() -> [CommonQuestCommentEntity] {
        comments.map {
            $0.toEntity()
        }
    }
}

extension CommonQuestCommentResponseDTO {
    func toEntity() -> CommonQuestCommentEntity {
        .init(
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
