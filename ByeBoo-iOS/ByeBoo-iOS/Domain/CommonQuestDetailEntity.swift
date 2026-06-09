//
//  CommonQuestDetailEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/9/26.
//

import Foundation

struct CommonQuestDetailEntity {
    let question: String
    let answer: CommonQuestAnswerDetailEntity
    let comments: [CommonQuestCommentEntity]
}

struct CommonQuestAnswerDetailEntity {
    let isMyAnswer: Bool
    let content: String
    let writerID: Int
    let writer: String
    let profileIcon: String
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
    let writtenAt: String
}
