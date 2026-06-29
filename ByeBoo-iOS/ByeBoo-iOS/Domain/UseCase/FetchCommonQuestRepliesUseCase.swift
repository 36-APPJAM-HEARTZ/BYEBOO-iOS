//
//  FetchCommonQuestRepliesUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/15/26.
//

import Foundation

protocol FetchCommonQuestRepliesUseCase {
    func execute(commentID: Int) async throws -> CommonQuestReplyListEntity
}

struct DefaultFetchCommonQuestRepliesUseCase: FetchCommonQuestRepliesUseCase {
    private let repository: CommentInterface

    init(repository: CommentInterface) {
        self.repository = repository
    }

    func execute(commentID: Int) async throws -> CommonQuestReplyListEntity {
        return try await repository.fetchReplies(commentID: commentID)
    }
}
