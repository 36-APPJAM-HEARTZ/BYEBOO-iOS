//
//  DeleteCommentReplyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/16/26.
//

import Foundation

protocol DeleteCommentReplyUseCase {
    func execute(commentID: Int) async throws
}

struct DefaultDeleteCommentReplyUseCase: DeleteCommentReplyUseCase {
    
    private let repository: CommentInterface
    
    init(repository: CommentInterface) {
        self.repository = repository
    }
    
    func execute(commentID: Int) async throws {
        try await repository.deleteComment(commentID: commentID)
    }
}
