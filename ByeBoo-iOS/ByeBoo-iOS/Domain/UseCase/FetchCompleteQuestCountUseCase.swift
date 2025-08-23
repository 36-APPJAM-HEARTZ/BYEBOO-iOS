//
//  FetchCompleteQuestCountUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import Foundation

protocol FetchCompleteQuestCountUseCase {
    func execute() async throws -> Int
}

struct DefaultFetchCompleteQuestCountUseCase: FetchCompleteQuestCountUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Int {
        return try await repository.fetchCompleteQuestCount()
    }
}
