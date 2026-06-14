//
//  PostCommonQuestReplyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

protocol PostCommonQuestReplyUseCase {
    func execute(content: String, commentID: Int) async throws
}

struct DefaultPostCommonQuestReplyUseCase: PostCommonQuestReplyUseCase {
    private let repository: CommentInterface

    init(repository: CommentInterface) {
        self.repository = repository
    }

    func execute(content: String, commentID: Int) async throws {
        try await repository.postReply(content: content, commentID: commentID)
    }
}
