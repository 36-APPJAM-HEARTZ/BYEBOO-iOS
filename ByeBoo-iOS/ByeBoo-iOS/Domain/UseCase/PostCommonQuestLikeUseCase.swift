//
//  PostCommonQuestLikeUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/10/26.
//

import Foundation

protocol PostCommonQuestLikeUseCase {
    func execute(answerID: Int) async throws -> CommonQuestLikeEntity
}

struct DefaultPostCommonQuestLikeUseCase: PostCommonQuestLikeUseCase {
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(answerID: Int) async throws  -> CommonQuestLikeEntity {
        return try await repository.postCommonQuestLikes(answerID: answerID)
    }
}
