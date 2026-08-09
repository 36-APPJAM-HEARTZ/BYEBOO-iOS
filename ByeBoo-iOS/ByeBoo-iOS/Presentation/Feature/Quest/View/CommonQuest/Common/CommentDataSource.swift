//
//  CommentDataSource.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import Foundation

enum CommentSection: Hashable {
    case main
}

enum ReplySection: Hashable {
    case comment
    case replies
}

struct CommentItem: Hashable {
    let entity: CommonQuestCommentEntity
    var showAllText: Bool
}
