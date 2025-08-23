//
//  FetchQuestStatusUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import Foundation

protocol FetchQuestStatusUseCase {
    func execute() async throws -> UserQuestStatusEntity
}

struct DefaultFetchQuestStatusUseCase: FetchQuestStatusUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> UserQuestStatusEntity {
        return try await repository.fetchQuestStatus()
    }
}
