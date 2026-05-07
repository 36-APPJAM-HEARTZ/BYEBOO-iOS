//
//  CommonQuestCommentEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Foundation

struct CommonQuestCommentEntity {
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
        let stub = toCommentStub()
        return [stub, stub, stub, stub, stub]
    }
    
    static func toCommentStub() -> Self {
        .init(
            commentID: 1,
            replyCount: 3,
            writerID: 2,
            writer: "장원영",
            profileIcon: "SADNESS",
            writtenAt: "2026-02-19T02:09:43.735730",
            content: "나도여ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅜㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ냐냐냐냐냐냐냐냐냐ㅑ냐냐냐냐냐냐ㅑㄴ냐냐ㅑ냐냐냐냔냐냐냐냐냐"
        )
    }
    
    static func toReplyStub() -> Self {
        .init(
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
