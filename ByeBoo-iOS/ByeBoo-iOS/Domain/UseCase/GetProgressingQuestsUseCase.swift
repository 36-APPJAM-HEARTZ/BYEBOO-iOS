//
//  GetProgressingQuestsUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

protocol GetProgressingQuestsUseCase {
    func execute(userID: Int) async throws -> ProgressingQuestsEntity
}

struct DefaultGetProgressingQuestsUseCase: GetProgressingQuestsUseCase {
    
    private let repository: GetProgressingQuestsInterface
    
    init(repository: GetProgressingQuestsInterface) {
        self.repository = repository
    }
    
    func execute(userID: Int) async throws -> ProgressingQuestsEntity {
        return try await repository.fetchProgressingQuests()
    }
}
