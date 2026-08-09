//
//  CommonQuestCommentEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Foundation

struct CommonQuestCommentEntity: Hashable {
    let isMyComment: Bool
    let commentID: Int
    let replyCount: Int?
    let writerID: Int
    let writer: String
    let profileIcon: String
    let writtenAt: String
    let content: String
}

extension CommonQuestCommentEntity {
    static func toCommentListStub() -> [Self] {
        return (1...5).map {
            .init(
                isMyComment: false,
                commentID: $0,
                replyCount: $0 - 1,
                writerID: 2,
                writer: "장원영",
                profileIcon: "SADNESS",
                writtenAt: "2026-02-19T02:09:43.735730",
                content: "나도여ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜ냐냐냐냐냐냐냐냐냐"
            )
        }
    }
    
    static func toCommentStub() -> Self {
        .init(
            isMyComment: false,
            commentID: 1,
            replyCount: 2,
            writerID: 2,
            writer: "가을이",
            profileIcon: "SELF_UNDERSTANDING",
            writtenAt: "2026-02-19T02:09:43.735730",
            content: "나도여ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜ냐냐냐냐냐냐냐냐냐"
        )
    }
    
    static func toReplyListStub() -> [Self] {
        return (6...10).map {
            .init(
                isMyComment: false,
                commentID: $0,
                replyCount: nil,
                writerID: 2,
                writer: "안유진",
                profileIcon: "SADNESS",
                writtenAt: "2026-02-19T02:09:43.735730",
                content: "헤어짐ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ"
            )
        }
    }
    
    
    static func toReplyStub() -> Self {
        .init(
            isMyComment: false,
            commentID: 1,
            replyCount: nil,
            writerID: 2,
            writer: "가을이",
            profileIcon: "SELF_UNDERSTANDING",
            writtenAt: "2026-02-19T02:09:43.735730",
            content: "헤어짐"
        )
    }
}
