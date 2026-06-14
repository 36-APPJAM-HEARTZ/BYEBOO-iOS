//
//  PostCommonQuestCommentUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

protocol PostCommonQuestCommentUseCase {
    func execute(content: String, targetID: Int) async throws
}

struct DefaultPostCommonQuestCommentUseCase: PostCommonQuestCommentUseCase {
    private let repository: CommentInterface
    
    init(repository: CommentInterface) {
        self.repository = repository
    }
    
    func execute(content: String, targetID: Int) async throws {
        try await repository.postComment(content: content, targetID: targetID)
    }
}
