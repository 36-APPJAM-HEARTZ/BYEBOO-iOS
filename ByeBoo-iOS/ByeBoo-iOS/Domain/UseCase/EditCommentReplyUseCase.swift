//
//  EditCommentReplyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/16/26.
//

import Foundation

protocol EditCommentReplyUseCase {
    func execute(content: String, targetID: Int) async throws
}

struct DefaultEditCommentReplyUseCase: EditCommentReplyUseCase {
    
    private let repository: CommentInterface
    
    init(repository: CommentInterface) {
        self.repository = repository
    }
    
    func execute(content: String, targetID: Int) async throws {
        try await repository.patchComment(content: content, targetID: targetID)
    }
}
