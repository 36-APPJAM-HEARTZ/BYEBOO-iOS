//
//  FetchCommonQuestDetailUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/26/26.
//

import Foundation

protocol FetchCommonQuestDetailUseCase {
    func execute(answerID: Int) async throws -> CommonQuestDetailEntity
}

struct DefaultFetchCommonQuestDetailUseCase: FetchCommonQuestDetailUseCase {
    
    private let repository: CommonQuestInterface
    
    init(repository: CommonQuestInterface) {
        self.repository = repository
    }
    
    func execute(answerID: Int) async throws -> CommonQuestDetailEntity {
        return try await repository.fetchCommonQuestDetail(answerID: answerID)
    }
}
